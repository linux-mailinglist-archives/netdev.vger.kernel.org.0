Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F18137AF0C
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 19:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbfG3RJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 13:09:45 -0400
Received: from mga05.intel.com ([192.55.52.43]:33179 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729537AbfG3RJn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 13:09:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jul 2019 10:09:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,327,1559545200"; 
   d="scan'208";a="183192503"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.140])
  by orsmga002.jf.intel.com with ESMTP; 30 Jul 2019 10:09:40 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, jonathan.lemon@gmail.com,
        saeedm@mellanox.com, maximmi@mellanox.com,
        stephen@networkplumber.org
Cc:     bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH bpf-next v4 03/11] libbpf: add flags to umem config
Date:   Tue, 30 Jul 2019 08:53:52 +0000
Message-Id: <20190730085400.10376-4-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190730085400.10376-1-kevin.laatz@intel.com>
References: <20190724051043.14348-1-kevin.laatz@intel.com>
 <20190730085400.10376-1-kevin.laatz@intel.com>
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
v2:
  - Removed the headroom check from this patch. It has moved to the
    previous patch.

v4:
  - modified chunk flag define
---
 tools/include/uapi/linux/if_xdp.h | 9 +++++++--
 tools/lib/bpf/xsk.c               | 3 +++
 tools/lib/bpf/xsk.h               | 2 ++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
index faaa5ca2a117..a691802d7915 100644
--- a/tools/include/uapi/linux/if_xdp.h
+++ b/tools/include/uapi/linux/if_xdp.h
@@ -17,6 +17,10 @@
 #define XDP_COPY	(1 << 1) /* Force copy-mode */
 #define XDP_ZEROCOPY	(1 << 2) /* Force zero-copy mode */
 
+/* Flags for xsk_umem_config flags */
+#define XDP_UMEM_UNALIGNED_CHUNK_FLAG_SHIFT 15
+#define XDP_UMEM_UNALIGNED_CHUNK_FLAG (1 << XDP_UMEM_UNALIGNED_CHUNK_FLAG_SHIFT)
+
 struct sockaddr_xdp {
 	__u16 sxdp_family;
 	__u16 sxdp_flags;
@@ -49,8 +53,9 @@ struct xdp_mmap_offsets {
 #define XDP_OPTIONS			8
 
 struct xdp_umem_reg {
-	__u64 addr; /* Start of packet data area */
-	__u64 len; /* Length of packet data area */
+	__u64 addr;     /* Start of packet data area */
+	__u64 len:48;   /* Length of packet data area */
+	__u64 flags:16; /* Flags for umem */
 	__u32 chunk_size;
 	__u32 headroom;
 };
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 5007b5d4fd2c..5e7e4d420ee0 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -116,6 +116,7 @@ static void xsk_set_umem_config(struct xsk_umem_config *cfg,
 		cfg->comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
 		cfg->frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
 		cfg->frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM;
+		cfg->flags = XSK_UMEM__DEFAULT_FLAGS;
 		return;
 	}
 
@@ -123,6 +124,7 @@ static void xsk_set_umem_config(struct xsk_umem_config *cfg,
 	cfg->comp_size = usr_cfg->comp_size;
 	cfg->frame_size = usr_cfg->frame_size;
 	cfg->frame_headroom = usr_cfg->frame_headroom;
+	cfg->flags = usr_cfg->flags;
 }
 
 static int xsk_set_xdp_socket_config(struct xsk_socket_config *cfg,
@@ -182,6 +184,7 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, void *umem_area, __u64 size,
 	mr.len = size;
 	mr.chunk_size = umem->config.frame_size;
 	mr.headroom = umem->config.frame_headroom;
+	mr.flags = umem->config.flags;
 
 	err = setsockopt(umem->fd, SOL_XDP, XDP_UMEM_REG, &mr, sizeof(mr));
 	if (err) {
diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 833a6e60d065..44a03d8c34b9 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -170,12 +170,14 @@ LIBBPF_API int xsk_socket__fd(const struct xsk_socket *xsk);
 #define XSK_UMEM__DEFAULT_FRAME_SHIFT    12 /* 4096 bytes */
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

