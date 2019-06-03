Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 229153351F
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 18:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbfFCQjA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 3 Jun 2019 12:39:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55478 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727308AbfFCQi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 12:38:59 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x53GYaIj020048
        for <netdev@vger.kernel.org>; Mon, 3 Jun 2019 09:38:57 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sw0hph9gs-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 09:38:57 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 3 Jun 2019 09:38:53 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id C29AF230C88D5; Mon,  3 Jun 2019 09:38:52 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH v4 bpf-next 2/2] libbpf: remove qidconf and better support external bpf programs.
Date:   Mon, 3 Jun 2019 09:38:52 -0700
Message-ID: <20190603163852.2535150-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190603163852.2535150-1-jonathan.lemon@gmail.com>
References: <20190603163852.2535150-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030115
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the recent change to XSKMAP bpf_map_lookup_elem() to test if
there is a xsk present in the map instead of duplicating the work
with qidconf.

Fix things so callers using XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD
bypass any internal bpf maps, so xsk_socket__{create|delete} works
properly.

Clean up error handling path.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Song Liu <songliubraving@fb.com>
Tested-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/lib/bpf/xsk.c | 103 ++++++++++++--------------------------------
 1 file changed, 28 insertions(+), 75 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 38667b62f1fe..7ef6293b4fd7 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -60,10 +60,8 @@ struct xsk_socket {
 	struct xsk_umem *umem;
 	struct xsk_socket_config config;
 	int fd;
-	int xsks_map;
 	int ifindex;
 	int prog_fd;
-	int qidconf_map_fd;
 	int xsks_map_fd;
 	__u32 queue_id;
 	char ifname[IFNAMSIZ];
@@ -265,15 +263,11 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 	/* This is the C-program:
 	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
 	 * {
-	 *     int *qidconf, index = ctx->rx_queue_index;
+	 *     int index = ctx->rx_queue_index;
 	 *
 	 *     // A set entry here means that the correspnding queue_id
 	 *     // has an active AF_XDP socket bound to it.
-	 *     qidconf = bpf_map_lookup_elem(&qidconf_map, &index);
-	 *     if (!qidconf)
-	 *         return XDP_ABORTED;
-	 *
-	 *     if (*qidconf)
+	 *     if (bpf_map_lookup_elem(&xsks_map, &index))
 	 *         return bpf_redirect_map(&xsks_map, index, 0);
 	 *
 	 *     return XDP_PASS;
@@ -286,15 +280,10 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 		BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_1, -4),
 		BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
 		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
-		BPF_LD_MAP_FD(BPF_REG_1, xsk->qidconf_map_fd),
+		BPF_LD_MAP_FD(BPF_REG_1, xsk->xsks_map_fd),
 		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
 		BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
-		BPF_MOV32_IMM(BPF_REG_0, 0),
-		/* if r1 == 0 goto +8 */
-		BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 8),
 		BPF_MOV32_IMM(BPF_REG_0, 2),
-		/* r1 = *(u32 *)(r1 + 0) */
-		BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1, 0),
 		/* if r1 == 0 goto +5 */
 		BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 5),
 		/* r2 = *(u32 *)(r10 - 4) */
@@ -366,18 +355,11 @@ static int xsk_create_bpf_maps(struct xsk_socket *xsk)
 	if (max_queues < 0)
 		return max_queues;
 
-	fd = bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "qidconf_map",
+	fd = bpf_create_map_name(BPF_MAP_TYPE_XSKMAP, "xsks_map",
 				 sizeof(int), sizeof(int), max_queues, 0);
 	if (fd < 0)
 		return fd;
-	xsk->qidconf_map_fd = fd;
 
-	fd = bpf_create_map_name(BPF_MAP_TYPE_XSKMAP, "xsks_map",
-				 sizeof(int), sizeof(int), max_queues, 0);
-	if (fd < 0) {
-		close(xsk->qidconf_map_fd);
-		return fd;
-	}
 	xsk->xsks_map_fd = fd;
 
 	return 0;
@@ -385,10 +367,8 @@ static int xsk_create_bpf_maps(struct xsk_socket *xsk)
 
 static void xsk_delete_bpf_maps(struct xsk_socket *xsk)
 {
-	close(xsk->qidconf_map_fd);
+	bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
 	close(xsk->xsks_map_fd);
-	xsk->qidconf_map_fd = -1;
-	xsk->xsks_map_fd = -1;
 }
 
 static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
@@ -417,10 +397,9 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
 	if (err)
 		goto out_map_ids;
 
-	for (i = 0; i < prog_info.nr_map_ids; i++) {
-		if (xsk->qidconf_map_fd != -1 && xsk->xsks_map_fd != -1)
-			break;
+	xsk->xsks_map_fd = -1;
 
+	for (i = 0; i < prog_info.nr_map_ids; i++) {
 		fd = bpf_map_get_fd_by_id(map_ids[i]);
 		if (fd < 0)
 			continue;
@@ -431,11 +410,6 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
 			continue;
 		}
 
-		if (!strcmp(map_info.name, "qidconf_map")) {
-			xsk->qidconf_map_fd = fd;
-			continue;
-		}
-
 		if (!strcmp(map_info.name, "xsks_map")) {
 			xsk->xsks_map_fd = fd;
 			continue;
@@ -445,40 +419,18 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
 	}
 
 	err = 0;
-	if (xsk->qidconf_map_fd < 0 || xsk->xsks_map_fd < 0) {
+	if (xsk->xsks_map_fd == -1)
 		err = -ENOENT;
-		xsk_delete_bpf_maps(xsk);
-	}
 
 out_map_ids:
 	free(map_ids);
 	return err;
 }
 
-static void xsk_clear_bpf_maps(struct xsk_socket *xsk)
-{
-	int qid = false;
-
-	bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qid, 0);
-	bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
-}
-
 static int xsk_set_bpf_maps(struct xsk_socket *xsk)
 {
-	int qid = true, fd = xsk->fd, err;
-
-	err = bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qid, 0);
-	if (err)
-		goto out;
-
-	err = bpf_map_update_elem(xsk->xsks_map_fd, &xsk->queue_id, &fd, 0);
-	if (err)
-		goto out;
-
-	return 0;
-out:
-	xsk_clear_bpf_maps(xsk);
-	return err;
+	return bpf_map_update_elem(xsk->xsks_map_fd, &xsk->queue_id,
+				   &xsk->fd, 0);
 }
 
 static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
@@ -497,26 +449,27 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
 			return err;
 
 		err = xsk_load_xdp_prog(xsk);
-		if (err)
-			goto out_maps;
+		if (err) {
+			xsk_delete_bpf_maps(xsk);
+			return err;
+		}
 	} else {
 		xsk->prog_fd = bpf_prog_get_fd_by_id(prog_id);
 		err = xsk_lookup_bpf_maps(xsk);
-		if (err)
-			goto out_load;
+		if (err) {
+			close(xsk->prog_fd);
+			return err;
+		}
 	}
 
 	err = xsk_set_bpf_maps(xsk);
-	if (err)
-		goto out_load;
+	if (err) {
+		xsk_delete_bpf_maps(xsk);
+		close(xsk->prog_fd);
+		return err;
+	}
 
 	return 0;
-
-out_load:
-	close(xsk->prog_fd);
-out_maps:
-	xsk_delete_bpf_maps(xsk);
-	return err;
 }
 
 int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
@@ -643,9 +596,7 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 		goto out_mmap_tx;
 	}
 
-	xsk->qidconf_map_fd = -1;
-	xsk->xsks_map_fd = -1;
-
+	xsk->prog_fd = -1;
 	if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
 		err = xsk_setup_xdp_prog(xsk);
 		if (err)
@@ -708,8 +659,10 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 	if (!xsk)
 		return;
 
-	xsk_clear_bpf_maps(xsk);
-	xsk_delete_bpf_maps(xsk);
+	if (xsk->prog_fd != -1) {
+		xsk_delete_bpf_maps(xsk);
+		close(xsk->prog_fd);
+	}
 
 	optlen = sizeof(off);
 	err = getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
-- 
2.17.1

