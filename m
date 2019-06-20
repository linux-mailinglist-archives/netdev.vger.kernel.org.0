Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41EC84D4F8
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 19:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732520AbfFTRYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 13:24:54 -0400
Received: from mga12.intel.com ([192.55.52.136]:64663 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732512AbfFTRYu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 13:24:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 10:24:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,397,1557212400"; 
   d="scan'208";a="359020373"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.110])
  by fmsmga006.fm.intel.com with ESMTP; 20 Jun 2019 10:24:48 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com
Cc:     bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH 07/11] libbpf: add flags to umem config
Date:   Thu, 20 Jun 2019 09:09:54 +0000
Message-Id: <20190620090958.2135-8-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620090958.2135-1-kevin.laatz@intel.com>
References: <20190620090958.2135-1-kevin.laatz@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a 'flags' field to the umem_config and umem_reg structs.
This will allow for more options to be added for configuring umems.

The first use for the flags field is to add a flag for unaligned chunks
mode. These flags can either be user-provided or filled with a default.

Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/include/uapi/linux/if_xdp.h | 4 ++++
 tools/lib/bpf/xsk.c               | 7 +++++++
 tools/lib/bpf/xsk.h               | 2 ++
 3 files changed, 13 insertions(+)

diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
index caed8b1614ff..8548f2110a77 100644
--- a/tools/include/uapi/linux/if_xdp.h
+++ b/tools/include/uapi/linux/if_xdp.h
@@ -17,6 +17,9 @@
 #define XDP_COPY	(1 << 1) /* Force copy-mode */
 #define XDP_ZEROCOPY	(1 << 2) /* Force zero-copy mode */
 
+/* Flags for xsk_umem_config flags */
+#define XDP_UMEM_UNALIGNED_CHUNKS (1 << 0)
+
 struct sockaddr_xdp {
 	__u16 sxdp_family;
 	__u16 sxdp_flags;
@@ -52,6 +55,7 @@ struct xdp_umem_reg {
 	__u64 len; /* Length of packet data area */
 	__u32 chunk_size;
 	__u32 headroom;
+	__u32 flags;
 };
 
 struct xdp_statistics {
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 7ef6293b4fd7..df4207d4ff4a 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -115,6 +115,7 @@ static void xsk_set_umem_config(struct xsk_umem_config *cfg,
 		cfg->comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
 		cfg->frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
 		cfg->frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM;
+		cfg->flags = XSK_UMEM__DEFAULT_FLAGS;
 		return;
 	}
 
@@ -122,6 +123,7 @@ static void xsk_set_umem_config(struct xsk_umem_config *cfg,
 	cfg->comp_size = usr_cfg->comp_size;
 	cfg->frame_size = usr_cfg->frame_size;
 	cfg->frame_headroom = usr_cfg->frame_headroom;
+	cfg->flags = usr_cfg->flags;
 }
 
 static int xsk_set_xdp_socket_config(struct xsk_socket_config *cfg,
@@ -181,6 +183,11 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, void *umem_area, __u64 size,
 	mr.len = size;
 	mr.chunk_size = umem->config.frame_size;
 	mr.headroom = umem->config.frame_headroom;
+	mr.flags = umem->config.flags;
+
+	/* Headroom must be 0 for unaligned chunks */
+	if ((mr.flags & XDP_UMEM_UNALIGNED_CHUNKS) && mr.headroom != 0)
+		return -EINVAL;
 
 	err = setsockopt(umem->fd, SOL_XDP, XDP_UMEM_REG, &mr, sizeof(mr));
 	if (err) {
diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 82ea71a0f3ec..8d393873b70f 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -170,12 +170,14 @@ LIBBPF_API int xsk_socket__fd(const struct xsk_socket *xsk);
 #define XSK_UMEM__DEFAULT_FRAME_SHIFT    11 /* 2048 bytes */
 #define XSK_UMEM__DEFAULT_FRAME_SIZE     (1 << XSK_UMEM__DEFAULT_FRAME_SHIFT)
 #define XSK_UMEM__DEFAULT_FRAME_HEADROOM 0
+#define XSK_UMEM__DEFAULT_FLAGS 0
 
 struct xsk_umem_config {
 	__u32 fill_size;
 	__u32 comp_size;
 	__u32 frame_size;
 	__u32 frame_headroom;
+	__u32 flags;
 };
 
 /* Flags for the libbpf_flags field. */
-- 
2.17.1

