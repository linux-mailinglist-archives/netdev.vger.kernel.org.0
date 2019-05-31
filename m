Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37DEB31501
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbfEaS5L convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 31 May 2019 14:57:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59102 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726308AbfEaS5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:57:10 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4VIsM8Q004317
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 11:57:09 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2su6aa8uee-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 11:57:09 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 31 May 2019 11:57:07 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id D948B22F2BC07; Fri, 31 May 2019 11:57:05 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH v3 bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an xskmap
Date:   Fri, 31 May 2019 11:57:04 -0700
Message-ID: <20190531185705.2629959-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190531185705.2629959-1-jonathan.lemon@gmail.com>
References: <20190531185705.2629959-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-31_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=803 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905310114
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the AF_XDP code uses a separate map in order to
determine if an xsk is bound to a queue.  Instead of doing this,
have bpf_map_lookup_elem() return the queue_id, as a way of
indicating that there is a valid entry at the map index.

Rearrange some xdp_sock members to eliminate structure holes.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xdp_sock.h                            |  6 +++---
 kernel/bpf/verifier.c                             |  6 +++++-
 kernel/bpf/xskmap.c                               |  4 +++-
 .../selftests/bpf/verifier/prevent_map_lookup.c   | 15 ---------------
 4 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index d074b6d60f8a..7d84b1da43d2 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -57,12 +57,12 @@ struct xdp_sock {
 	struct net_device *dev;
 	struct xdp_umem *umem;
 	struct list_head flush_node;
-	u16 queue_id;
-	struct xsk_queue *tx ____cacheline_aligned_in_smp;
-	struct list_head list;
+	u32 queue_id;
 	bool zc;
 	/* Protects multiple processes in the control path */
 	struct mutex mutex;
+	struct xsk_queue *tx ____cacheline_aligned_in_smp;
+	struct list_head list;
 	/* Mutual exclusion of NAPI TX thread and sendmsg error paths
 	 * in the SKB destructor callback.
 	 */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2778417e6e0c..91c730f85e92 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2905,10 +2905,14 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	 * appear.
 	 */
 	case BPF_MAP_TYPE_CPUMAP:
-	case BPF_MAP_TYPE_XSKMAP:
 		if (func_id != BPF_FUNC_redirect_map)
 			goto error;
 		break;
+	case BPF_MAP_TYPE_XSKMAP:
+		if (func_id != BPF_FUNC_redirect_map &&
+		    func_id != BPF_FUNC_map_lookup_elem)
+			goto error;
+		break;
 	case BPF_MAP_TYPE_ARRAY_OF_MAPS:
 	case BPF_MAP_TYPE_HASH_OF_MAPS:
 		if (func_id != BPF_FUNC_map_lookup_elem)
diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index 686d244e798d..249b22089014 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -154,7 +154,9 @@ void __xsk_map_flush(struct bpf_map *map)
 
 static void *xsk_map_lookup_elem(struct bpf_map *map, void *key)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	struct xdp_sock *xs = __xsk_map_lookup_elem(map, *(u32 *)key);
+
+	return xs ? &xs->queue_id : NULL;
 }
 
 static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
diff --git a/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c b/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
index bbdba990fefb..da7a4b37cb98 100644
--- a/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
+++ b/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
@@ -28,21 +28,6 @@
 	.errstr = "cannot pass map_type 18 into func bpf_map_lookup_elem",
 	.prog_type = BPF_PROG_TYPE_SOCK_OPS,
 },
-{
-	"prevent map lookup in xskmap",
-	.insns = {
-	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
-	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
-	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
-	BPF_LD_MAP_FD(BPF_REG_1, 0),
-	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
-	BPF_EXIT_INSN(),
-	},
-	.fixup_map_xskmap = { 3 },
-	.result = REJECT,
-	.errstr = "cannot pass map_type 17 into func bpf_map_lookup_elem",
-	.prog_type = BPF_PROG_TYPE_XDP,
-},
 {
 	"prevent map lookup in stack trace",
 	.insns = {
-- 
2.17.1

