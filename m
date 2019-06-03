Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0B8330D7
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 15:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbfFCNTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 09:19:21 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41017 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728512AbfFCNTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 09:19:20 -0400
Received: by mail-lf1-f65.google.com with SMTP id 136so2045876lfa.8
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 06:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LeBa2Av8Q3e3e0gop1RqyOgipHnUTdOBWLST+LfMBZo=;
        b=kVwr+JpNPbnORWl2440+rFIkNFkxHijSXQ8N0yKhmdjM74znKnUapTv/KM89fUl10j
         Kp2QnBwdZZCQ1TDD5q+3ytVy+btOQPLCqOCtRRBXeDg+zT574J2frXm1yl87auU/KG6v
         0/aDB+qDl0o28yhBT+p8N8W/h/OEcM1tuKXyg1JRcWJAL7ukNcKvkkvmPgpRpZoM+mY5
         y5JuIkAoitn7R8Xq80QPC5mX9i7Mm5meR4XX8BuXARkuVEgbiDoKICnaSkGYOjPzPdV8
         GmSgmTnj4W6/4DIHvF9BkTpx1bSsK9iMxHq57ubWxUZxFEs5I2BPFr6YuU9p10/K3sKy
         c5/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LeBa2Av8Q3e3e0gop1RqyOgipHnUTdOBWLST+LfMBZo=;
        b=PHMWSGd2PHvPPRr4+SkcIsoWGQ2OIHCciIAtkBI0dRAy5DSBorHVp6pI/MuneGsl/J
         Hbp8FeX6qh1QGuYkB5FskJGW+WEG38ct1uNS4k5mL3RjF+kPyvj5uNiY6wUwbC5cRffS
         Iucb4tWLhzc5Uae/oGZdxpnUZ4OLphrgz8er8shpWI56eP46c7upOAjKh7uNG2mxabE7
         S1Gr9Bz11Yz7ri1v5BXQx3sDeo+K0Cb7AYN2NW/P8tvtDwqRVbEBA7Clq2A/VzthSx/i
         IX6ZR8VC9D+C9fOHc7BoEICarTDq+t1KjiBjjQD5hikW6e65AdlmVmVfUYR++du6E3yJ
         CZyw==
X-Gm-Message-State: APjAAAX/vBiwjcGcoDFyMC2DkSWN6TkKBU/6XeabTP7duaaBe7/Tr5CR
        qUVUW96gBHeT4LOVlKXkRKUaeaHF
X-Google-Smtp-Source: APXvYqx6clVHDRhpd5nlJnpgzDsnshvEgXl3IxVdDDguCQ7RA0xDp+vzIdLdHnR+Bqwkp8d2dhhr/Q==
X-Received: by 2002:ac2:5231:: with SMTP id i17mr13962040lfl.39.1559567958183;
        Mon, 03 Jun 2019 06:19:18 -0700 (PDT)
Received: from localhost.localdomain (host-185-93-94-143.ip-point.pl. [185.93.94.143])
        by smtp.gmail.com with ESMTPSA id 20sm577808ljf.21.2019.06.03.06.19.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 03 Jun 2019 06:19:17 -0700 (PDT)
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
X-Google-Original-From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com,
        jonathan.lemon@gmail.com, songliubraving@fb.com
Subject: [RFC PATCH bpf-next 4/4] libbpf: don't remove eBPF resources when other xsks are present
Date:   Mon,  3 Jun 2019 15:19:07 +0200
Message-Id: <20190603131907.13395-5-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.16.1
In-Reply-To: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
References: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case where multiple xsk sockets are attached to a single interface
and one of them gets detached, the eBPF maps and program are removed.
This should not happen as the rest of xsksocks are still using these
resources.

In order to fix that, let's have an additional eBPF map with a single
entry that will be used as a xsks count. During the xsk_socket__delete,
remove the resources only when this count is equal to 0.  This map is
not being accessed from eBPF program, so the verifier is not associating
it with the prog, which in turn makes bpf_obj_get_info_by_fd not
reporting this map in nr_map_ids field of struct bpf_prog_info. The
described behaviour brings the need to have this map pinned, so in
case when socket is being created and the libbpf detects the presence of
bpf resources, it will be able to access that map.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/lib/bpf/xsk.c | 59 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 51 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index e28bedb0b078..88d2c931ad14 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -44,6 +44,8 @@
  #define PF_XDP AF_XDP
 #endif
 
+#define XSKS_CNT_MAP_PATH "/sys/fs/bpf/xsks_cnt_map"
+
 struct xsk_umem {
 	struct xsk_ring_prod *fill;
 	struct xsk_ring_cons *comp;
@@ -65,6 +67,7 @@ struct xsk_socket {
 	int prog_fd;
 	int qidconf_map_fd;
 	int xsks_map_fd;
+	int xsks_cnt_map_fd;
 	__u32 queue_id;
 	char ifname[IFNAMSIZ];
 };
@@ -372,7 +375,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 static int xsk_create_bpf_maps(struct xsk_socket *xsk)
 {
 	int max_queues;
-	int fd;
+	int fd, ret;
 
 	max_queues = xsk_get_max_queues(xsk);
 	if (max_queues < 0)
@@ -392,6 +395,24 @@ static int xsk_create_bpf_maps(struct xsk_socket *xsk)
 	}
 	xsk->xsks_map_fd = fd;
 
+	fd = bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "xsks_cnt_map",
+				 sizeof(int), sizeof(int), 1, 0);
+	if (fd < 0) {
+		close(xsk->qidconf_map_fd);
+		close(xsk->xsks_map_fd);
+		return fd;
+	}
+
+	ret = bpf_obj_pin(fd, XSKS_CNT_MAP_PATH);
+	if (ret < 0) {
+		pr_warning("pinning map failed; is bpffs mounted?\n");
+		close(xsk->qidconf_map_fd);
+		close(xsk->xsks_map_fd);
+		close(fd);
+		return ret;
+	}
+	xsk->xsks_cnt_map_fd = fd;
+
 	return 0;
 }
 
@@ -456,8 +477,10 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
 		close(fd);
 	}
 
+	xsk->xsks_cnt_map_fd = bpf_obj_get(XSKS_CNT_MAP_PATH);
 	err = 0;
-	if (xsk->qidconf_map_fd < 0 || xsk->xsks_map_fd < 0) {
+	if (xsk->qidconf_map_fd < 0 || xsk->xsks_map_fd < 0 ||
+	    xsk->xsks_cnt_map_fd < 0) {
 		err = -ENOENT;
 		xsk_delete_bpf_maps(xsk);
 	}
@@ -467,17 +490,25 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
 	return err;
 }
 
-static void xsk_clear_bpf_maps(struct xsk_socket *xsk)
+static void xsk_clear_bpf_maps(struct xsk_socket *xsk, long *xsks_cnt_ptr)
 {
+	long xsks_cnt, key = 0;
 	int qid = false;
 
 	bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qid, 0);
 	bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
+	bpf_map_lookup_elem(xsk->xsks_cnt_map_fd, &key, &xsks_cnt);
+	if (xsks_cnt)
+		xsks_cnt--;
+	bpf_map_update_elem(xsk->xsks_cnt_map_fd, &key, &xsks_cnt, 0);
+	if (xsks_cnt_ptr)
+		*xsks_cnt_ptr = xsks_cnt;
 }
 
 static int xsk_set_bpf_maps(struct xsk_socket *xsk)
 {
 	int qid = true, fd = xsk->fd, err;
+	long xsks_cnt, key = 0;
 
 	err = bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qid, 0);
 	if (err)
@@ -487,9 +518,18 @@ static int xsk_set_bpf_maps(struct xsk_socket *xsk)
 	if (err)
 		goto out;
 
+	err = bpf_map_lookup_elem(xsk->xsks_cnt_map_fd, &key, &xsks_cnt);
+	if (err)
+		goto out;
+
+	xsks_cnt++;
+	err = bpf_map_update_elem(xsk->xsks_cnt_map_fd, &key, &xsks_cnt, 0);
+	if (err)
+		goto out;
+
 	return 0;
 out:
-	xsk_clear_bpf_maps(xsk);
+	xsk_clear_bpf_maps(xsk, NULL);
 	return err;
 }
 
@@ -752,13 +792,18 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 	size_t desc_sz = sizeof(struct xdp_desc);
 	struct xdp_mmap_offsets off;
 	socklen_t optlen;
+	long xsks_cnt;
 	int err;
 
 	if (!xsk)
 		return;
 
-	xsk_clear_bpf_maps(xsk);
-	xsk_delete_bpf_maps(xsk);
+	xsk_clear_bpf_maps(xsk, &xsks_cnt);
+	unlink(XSKS_CNT_MAP_PATH);
+	if (!xsks_cnt) {
+		xsk_delete_bpf_maps(xsk);
+		xsk_remove_xdp_prog(xsk);
+	}
 
 	optlen = sizeof(off);
 	err = getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen);
@@ -774,8 +819,6 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 
 	}
 
-	xsk_remove_xdp_prog(xsk);
-
 	xsk->umem->refcount--;
 	/* Do not close an fd that also has an associated umem connected
 	 * to it.
-- 
2.16.1

