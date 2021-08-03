Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E04C3DF399
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237711AbhHCRKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:10:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:16898 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237502AbhHCRKl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 13:10:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="213466138"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="213466138"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 10:10:18 -0700
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="521327118"
Received: from shyamasr-mobl.amr.corp.intel.com ([10.209.65.83])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 10:10:17 -0700
From:   Kishen Maloor <kishen.maloor@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, hawk@kernel.org,
        magnus.karlsson@intel.com
Cc:     Kishen Maloor <kishen.maloor@intel.com>
Subject: [RFC bpf-next 2/5] libbpf: SO_TXTIME support in AF_XDP
Date:   Tue,  3 Aug 2021 13:10:03 -0400
Message-Id: <20210803171006.13915-3-kishen.maloor@intel.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210803171006.13915-1-kishen.maloor@intel.com>
References: <20210803171006.13915-1-kishen.maloor@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds userspace support for SO_TXTIME in AF_XDP
to include a specific TXTIME (aka "Launch Time")
with XDP frames issued from userspace XDP applications.

The userspace API has been expanded with two helper functons:

- int xsk_socket__enable_so_txtime(struct xsk_socket *xsk, bool enable)
   Sets the SO_TXTIME option on the AF_XDP socket (using setsockopt()).

- void xsk_umem__set_md_txtime(void *umem_area, __u64 chunkAddr,
                               __s64 txtime)
   Packages the application supplied TXTIME into struct xdp_user_tx_metadata:
   struct xdp_user_tx_metadata {
        __u64 timestamp;
        __u32 md_valid;
        __u32 btf_id;
   };
   and stores it in the XDP metadata area, which precedes the XDP frame.

Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
---
 tools/include/uapi/linux/if_xdp.h     |  2 ++
 tools/include/uapi/linux/xdp_md_std.h | 14 ++++++++++++++
 tools/lib/bpf/xsk.h                   | 27 ++++++++++++++++++++++++++-
 3 files changed, 42 insertions(+), 1 deletion(-)
 create mode 100644 tools/include/uapi/linux/xdp_md_std.h

diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
index a78a8096f4ce..31f81f82ed86 100644
--- a/tools/include/uapi/linux/if_xdp.h
+++ b/tools/include/uapi/linux/if_xdp.h
@@ -106,6 +106,8 @@ struct xdp_desc {
 	__u32 options;
 };
 
+#define XDP_DESC_OPTION_METADATA (1 << 0)
+
 /* UMEM descriptor is __u64 */
 
 #endif /* _LINUX_IF_XDP_H */
diff --git a/tools/include/uapi/linux/xdp_md_std.h b/tools/include/uapi/linux/xdp_md_std.h
new file mode 100644
index 000000000000..f00996a61639
--- /dev/null
+++ b/tools/include/uapi/linux/xdp_md_std.h
@@ -0,0 +1,14 @@
+#ifndef _UAPI_LINUX_XDP_MD_STD_H
+#define _UAPI_LINUX_XDP_MD_STD_H
+
+#include <linux/types.h>
+
+#define XDP_METADATA_USER_TX_TIMESTAMP 0x1
+
+struct xdp_user_tx_metadata {
+	__u64 timestamp;
+	__u32 md_valid;
+	__u32 btf_id;
+};
+
+#endif /* _UAPI_LINUX_XDP_MD_STD_H */
diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 01c12dca9c10..1b52ffe1c9a3 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -16,7 +16,8 @@
 #include <stdint.h>
 #include <stdbool.h>
 #include <linux/if_xdp.h>
-
+#include <linux/xdp_md_std.h>
+#include <errno.h>
 #include "libbpf.h"
 
 #ifdef __cplusplus
@@ -248,6 +249,30 @@ static inline __u64 xsk_umem__add_offset_to_addr(__u64 addr)
 LIBBPF_API int xsk_umem__fd(const struct xsk_umem *umem);
 LIBBPF_API int xsk_socket__fd(const struct xsk_socket *xsk);
 
+/* Helpers for SO_TXTIME */
+
+static inline void xsk_umem__set_md_txtime(void *umem_area, __u64 addr, __s64 txtime)
+{
+	struct xdp_user_tx_metadata *md;
+
+	md = (struct xdp_user_tx_metadata *)&((char *)umem_area)[addr];
+
+	md->timestamp = txtime;
+	md->md_valid |= XDP_METADATA_USER_TX_TIMESTAMP;
+}
+
+static inline int xsk_socket__enable_so_txtime(struct xsk_socket *xsk, bool enable)
+{
+	unsigned int val = (enable) ? 1 : 0;
+	int err;
+
+	err = setsockopt(xsk_socket__fd(xsk), SOL_XDP, SO_TXTIME, &val, sizeof(val));
+
+	if (err)
+		return -errno;
+	return 0;
+}
+
 #define XSK_RING_CONS__DEFAULT_NUM_DESCS      2048
 #define XSK_RING_PROD__DEFAULT_NUM_DESCS      2048
 #define XSK_UMEM__DEFAULT_FRAME_SHIFT    12 /* 4096 bytes */
-- 
2.24.3 (Apple Git-128)

