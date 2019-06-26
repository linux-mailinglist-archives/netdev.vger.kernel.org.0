Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1DDE56C31
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbfFZOgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:36:20 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59845 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727437AbfFZOgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:36:18 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jun 2019 17:36:16 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5QEaGY1027430;
        Wed, 26 Jun 2019 17:36:16 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bjorn.topel@intel.com,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <bsd@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH bpf-next V6 03/16] xsk: Add getsockopt XDP_OPTIONS
Date:   Wed, 26 Jun 2019 17:35:25 +0300
Message-Id: <1561559738-4213-4-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
References: <1561559738-4213-1-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Make it possible for the application to determine whether the AF_XDP
socket is running in zero-copy mode. To achieve this, add a new
getsockopt option XDP_OPTIONS that returns flags. The only flag
supported for now is the zero-copy mode indicator.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/uapi/linux/if_xdp.h       |  8 ++++++++
 net/xdp/xsk.c                     | 20 ++++++++++++++++++++
 tools/include/uapi/linux/if_xdp.h |  8 ++++++++
 3 files changed, 36 insertions(+)

diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
index caed8b1614ff..faaa5ca2a117 100644
--- a/include/uapi/linux/if_xdp.h
+++ b/include/uapi/linux/if_xdp.h
@@ -46,6 +46,7 @@ struct xdp_mmap_offsets {
 #define XDP_UMEM_FILL_RING		5
 #define XDP_UMEM_COMPLETION_RING	6
 #define XDP_STATISTICS			7
+#define XDP_OPTIONS			8
 
 struct xdp_umem_reg {
 	__u64 addr; /* Start of packet data area */
@@ -60,6 +61,13 @@ struct xdp_statistics {
 	__u64 tx_invalid_descs; /* Dropped due to invalid descriptor */
 };
 
+struct xdp_options {
+	__u32 flags;
+};
+
+/* Flags for the flags field of struct xdp_options */
+#define XDP_OPTIONS_ZEROCOPY (1 << 0)
+
 /* Pgoff for mmaping the rings */
 #define XDP_PGOFF_RX_RING			  0
 #define XDP_PGOFF_TX_RING		 0x80000000
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index b68a380f50b3..35ca531ac74e 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -650,6 +650,26 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
 
 		return 0;
 	}
+	case XDP_OPTIONS:
+	{
+		struct xdp_options opts = {};
+
+		if (len < sizeof(opts))
+			return -EINVAL;
+
+		mutex_lock(&xs->mutex);
+		if (xs->zc)
+			opts.flags |= XDP_OPTIONS_ZEROCOPY;
+		mutex_unlock(&xs->mutex);
+
+		len = sizeof(opts);
+		if (copy_to_user(optval, &opts, len))
+			return -EFAULT;
+		if (put_user(len, optlen))
+			return -EFAULT;
+
+		return 0;
+	}
 	default:
 		break;
 	}
diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
index caed8b1614ff..faaa5ca2a117 100644
--- a/tools/include/uapi/linux/if_xdp.h
+++ b/tools/include/uapi/linux/if_xdp.h
@@ -46,6 +46,7 @@ struct xdp_mmap_offsets {
 #define XDP_UMEM_FILL_RING		5
 #define XDP_UMEM_COMPLETION_RING	6
 #define XDP_STATISTICS			7
+#define XDP_OPTIONS			8
 
 struct xdp_umem_reg {
 	__u64 addr; /* Start of packet data area */
@@ -60,6 +61,13 @@ struct xdp_statistics {
 	__u64 tx_invalid_descs; /* Dropped due to invalid descriptor */
 };
 
+struct xdp_options {
+	__u32 flags;
+};
+
+/* Flags for the flags field of struct xdp_options */
+#define XDP_OPTIONS_ZEROCOPY (1 << 0)
+
 /* Pgoff for mmaping the rings */
 #define XDP_PGOFF_RX_RING			  0
 #define XDP_PGOFF_TX_RING		 0x80000000
-- 
1.8.3.1

