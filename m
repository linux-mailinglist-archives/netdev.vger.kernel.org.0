Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A32F3615
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389785AbfKGRry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:47:54 -0500
Received: from mga03.intel.com ([134.134.136.65]:33463 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730591AbfKGRrx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 12:47:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 09:47:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,278,1569308400"; 
   d="scan'208";a="353858401"
Received: from unknown (HELO VM.jf.intel.com) ([10.78.3.78])
  by orsmga004.jf.intel.com with ESMTP; 07 Nov 2019 09:47:52 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, u9012063@gmail.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next 1/5] libbpf: support XDP_SHARED_UMEM with external XDP program
Date:   Thu,  7 Nov 2019 18:47:36 +0100
Message-Id: <1573148860-30254-2-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support in libbpf to create multiple sockets that share a single
umem. Note that an external XDP program need to be supplied that
routes the incoming traffic to the desired sockets. So you need to
supply the libbpf_flag XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD and load
your own XDP program.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/lib/bpf/xsk.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 86c1b61..8ebd810 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -586,15 +586,21 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	if (!umem || !xsk_ptr || !rx || !tx)
 		return -EFAULT;
 
-	if (umem->refcount) {
-		pr_warn("Error: shared umems not supported by libbpf.\n");
-		return -EBUSY;
-	}
-
 	xsk = calloc(1, sizeof(*xsk));
 	if (!xsk)
 		return -ENOMEM;
 
+	err = xsk_set_xdp_socket_config(&xsk->config, usr_config);
+	if (err)
+		goto out_xsk_alloc;
+
+	if (umem->refcount &&
+	    !(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
+		pr_warn("Error: shared umems not supported by libbpf supplied XDP program.\n");
+		err = -EBUSY;
+		goto out_xsk_alloc;
+	}
+
 	if (umem->refcount++ > 0) {
 		xsk->fd = socket(AF_XDP, SOCK_RAW, 0);
 		if (xsk->fd < 0) {
@@ -616,10 +622,6 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	memcpy(xsk->ifname, ifname, IFNAMSIZ - 1);
 	xsk->ifname[IFNAMSIZ - 1] = '\0';
 
-	err = xsk_set_xdp_socket_config(&xsk->config, usr_config);
-	if (err)
-		goto out_socket;
-
 	if (rx) {
 		err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
 				 &xsk->config.rx_size,
@@ -687,7 +689,12 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	sxdp.sxdp_family = PF_XDP;
 	sxdp.sxdp_ifindex = xsk->ifindex;
 	sxdp.sxdp_queue_id = xsk->queue_id;
-	sxdp.sxdp_flags = xsk->config.bind_flags;
+	if (umem->refcount > 1) {
+		sxdp.sxdp_flags = XDP_SHARED_UMEM;
+		sxdp.sxdp_shared_umem_fd = umem->fd;
+	} else {
+		sxdp.sxdp_flags = xsk->config.bind_flags;
+	}
 
 	err = bind(xsk->fd, (struct sockaddr *)&sxdp, sizeof(sxdp));
 	if (err) {
-- 
2.7.4

