Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AF33DF3A3
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237873AbhHCRKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:10:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:16903 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237726AbhHCRKn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 13:10:43 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="213466135"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="213466135"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 10:10:17 -0700
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="521327107"
Received: from shyamasr-mobl.amr.corp.intel.com ([10.209.65.83])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 10:10:16 -0700
From:   Kishen Maloor <kishen.maloor@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, hawk@kernel.org,
        magnus.karlsson@intel.com
Cc:     Kishen Maloor <kishen.maloor@intel.com>
Subject: [RFC bpf-next 1/5] net: xdp: SO_TXTIME support in AF_XDP
Date:   Tue,  3 Aug 2021 13:10:02 -0400
Message-Id: <20210803171006.13915-2-kishen.maloor@intel.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210803171006.13915-1-kishen.maloor@intel.com>
References: <20210803171006.13915-1-kishen.maloor@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds kernel support for SO_TXTIME in AF_XDP
to include a specific TXTIME (aka "Launch Time")
with XDP frames issued from userspace XDP applications.

The timestamp is stored in the XDP metadata area and
passed down to the NIC driver to configure the launch time.
The timestamp is internally conveyed to the sk_buff destined
to generic mode NIC drivers.

Alternatively, a new XSK Zero-Copy driver API:

s64 xsk_buff_get_txtime(struct xsk_buff_pool *pool,
                        struct xdp_desc *desc)

nay used to retrieve and consume the TXTIME provided by the
userspace XDP application.

Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
---
 include/net/xdp_sock.h          |  1 +
 include/net/xdp_sock_drv.h      | 10 +++++++
 include/net/xsk_buff_pool.h     |  1 +
 include/uapi/linux/if_xdp.h     |  2 ++
 include/uapi/linux/xdp_md_std.h | 14 +++++++++
 net/xdp/xsk.c                   | 51 ++++++++++++++++++++++++++++++++-
 net/xdp/xsk.h                   |  2 ++
 net/xdp/xsk_buff_pool.c         | 23 +++++++++++++++
 net/xdp/xsk_queue.h             |  4 +--
 9 files changed, 105 insertions(+), 3 deletions(-)
 create mode 100644 include/uapi/linux/xdp_md_std.h

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index fff069d2ed1b..b78932921b44 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -58,6 +58,7 @@ struct xdp_sock {
 
 	struct xsk_queue *tx ____cacheline_aligned_in_smp;
 	struct list_head tx_list;
+	u32 so_txtime_mask;
 	/* Protects generic receive. */
 	spinlock_t rx_lock;
 
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 4e295541e396..7d190b454772 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -95,6 +95,11 @@ static inline dma_addr_t xsk_buff_raw_get_dma(struct xsk_buff_pool *pool,
 	return xp_raw_get_dma(pool, addr);
 }
 
+static inline s64 xsk_buff_get_txtime(struct xsk_buff_pool *pool, struct xdp_desc *desc)
+{
+	return xp_raw_get_txtime(pool, desc);
+}
+
 static inline void *xsk_buff_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
 {
 	return xp_raw_get_data(pool, addr);
@@ -232,6 +237,11 @@ static inline void *xsk_buff_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
 	return NULL;
 }
 
+static inline s64 xsk_buff_get_txtime(struct xsk_buff_pool *pool, u64 addr)
+{
+	return -1;
+}
+
 static inline void xsk_buff_dma_sync_for_cpu(struct xdp_buff *xdp, struct xsk_buff_pool *pool)
 {
 }
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 7a9a23e7a604..32863cde4128 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -107,6 +107,7 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs);
 struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool);
 bool xp_can_alloc(struct xsk_buff_pool *pool, u32 count);
 void *xp_raw_get_data(struct xsk_buff_pool *pool, u64 addr);
+s64 xp_raw_get_txtime(struct xsk_buff_pool *pool, struct xdp_desc *desc);
 dma_addr_t xp_raw_get_dma(struct xsk_buff_pool *pool, u64 addr);
 static inline dma_addr_t xp_get_dma(struct xdp_buff_xsk *xskb)
 {
diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
index a78a8096f4ce..31f81f82ed86 100644
--- a/include/uapi/linux/if_xdp.h
+++ b/include/uapi/linux/if_xdp.h
@@ -106,6 +106,8 @@ struct xdp_desc {
 	__u32 options;
 };
 
+#define XDP_DESC_OPTION_METADATA (1 << 0)
+
 /* UMEM descriptor is __u64 */
 
 #endif /* _LINUX_IF_XDP_H */
diff --git a/include/uapi/linux/xdp_md_std.h b/include/uapi/linux/xdp_md_std.h
new file mode 100644
index 000000000000..f00996a61639
--- /dev/null
+++ b/include/uapi/linux/xdp_md_std.h
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
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index d6b500dc4208..c92baedf18b8 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -339,6 +339,7 @@ bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
 			continue;
 		}
 
+		desc->options |= xs->so_txtime_mask;
 		/* This is the backpressure mechanism for the Tx path.
 		 * Reserve space in the completion queue and only proceed
 		 * if there is space in it. This avoids having to implement
@@ -374,7 +375,7 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *
 				   u32 max_entries)
 {
 	struct xdp_sock *xs;
-	u32 nb_pkts;
+	u32 nb_pkts, i;
 
 	rcu_read_lock();
 	if (!list_is_singular(&pool->xsk_tx_list)) {
@@ -395,6 +396,9 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *
 		goto out;
 	}
 
+	for (i = 0; i < nb_pkts; i++)
+		descs[i].options |= xs->so_txtime_mask;
+
 	/* This is the backpressure mechanism for the Tx path. Try to
 	 * reserve space in the completion queue for all packets, but
 	 * if there are fewer slots available, just process that many
@@ -445,6 +449,19 @@ static void xsk_destruct_skb(struct sk_buff *skb)
 	sock_wfree(skb);
 }
 
+static void xsk_process_so_txtime(struct xsk_buff_pool *pool,
+				  struct xdp_desc *desc,
+				  struct sk_buff *skb)
+{
+	if ((desc->options & (XDP_DESC_OPTION_METADATA | XDP_SOL_OPTION_SO_TXTIME))
+	    == (XDP_DESC_OPTION_METADATA | XDP_SOL_OPTION_SO_TXTIME)) {
+		s64 tstamp = xsk_buff_get_txtime(pool, desc);
+
+		if (tstamp != -1)
+			skb->tstamp = tstamp;
+	}
+}
+
 static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
 					      struct xdp_desc *desc)
 {
@@ -469,6 +486,7 @@ static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
 	ts = pool->unaligned ? len : pool->chunk_size;
 
 	buffer = xsk_buff_raw_get_data(pool, addr);
+	xsk_process_so_txtime(pool, desc, skb);
 	offset = offset_in_page(buffer);
 	addr = buffer - pool->addrs;
 
@@ -520,6 +538,7 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
 		skb_put(skb, len);
 
 		buffer = xsk_buff_raw_get_data(xs->pool, desc->addr);
+		xsk_process_so_txtime(xs->pool, desc, skb);
 		err = skb_store_bits(skb, 0, buffer, len);
 		if (unlikely(err)) {
 			kfree_skb(skb);
@@ -557,6 +576,7 @@ static int xsk_generic_xmit(struct sock *sk)
 			goto out;
 		}
 
+		desc.options |= xs->so_txtime_mask;
 		skb = xsk_build_skb(xs, &desc);
 		if (IS_ERR(skb)) {
 			err = PTR_ERR(skb);
@@ -1098,6 +1118,23 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 		mutex_unlock(&xs->mutex);
 		return err;
 	}
+	case SO_TXTIME:
+	{
+		u32 option;
+
+		if (optlen != sizeof(u32))
+			return -EINVAL;
+
+		if (copy_from_sockptr(&option, optval, sizeof(option)))
+			return -EFAULT;
+
+		if (option)
+			xs->so_txtime_mask |= XDP_SOL_OPTION_SO_TXTIME;
+		else
+			xs->so_txtime_mask &= ~XDP_SOL_OPTION_SO_TXTIME;
+
+		return 0;
+	}
 	default:
 		break;
 	}
@@ -1249,6 +1286,18 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
 
 		return 0;
 	}
+	case SO_TXTIME:
+	{
+		u32 option = 0;
+
+		if (xs->so_txtime_mask & XDP_SOL_OPTION_SO_TXTIME)
+			option = 1;
+
+		if (copy_to_user(optval, &option, sizeof(option)))
+			return -EFAULT;
+
+		return 0;
+	}
 	default:
 		break;
 	}
diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
index a4bc4749faac..9c8686185d68 100644
--- a/net/xdp/xsk.h
+++ b/net/xdp/xsk.h
@@ -11,6 +11,8 @@
 #define XSK_NEXT_PG_CONTIG_SHIFT 0
 #define XSK_NEXT_PG_CONTIG_MASK BIT_ULL(XSK_NEXT_PG_CONTIG_SHIFT)
 
+#define XDP_SOL_OPTION_SO_TXTIME (1 << 31)
+
 struct xdp_ring_offset_v1 {
 	__u64 producer;
 	__u64 consumer;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 8de01aaac4a0..58bf877cc5cf 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -3,6 +3,7 @@
 #include <net/xsk_buff_pool.h>
 #include <net/xdp_sock.h>
 #include <net/xdp_sock_drv.h>
+#include <linux/xdp_md_std.h>
 
 #include "xsk_queue.h"
 #include "xdp_umem.h"
@@ -522,6 +523,28 @@ void xp_free(struct xdp_buff_xsk *xskb)
 }
 EXPORT_SYMBOL(xp_free);
 
+s64 xp_raw_get_txtime(struct xsk_buff_pool *pool, struct xdp_desc *desc)
+{
+	struct xdp_user_tx_metadata *md;
+
+	if ((desc->addr % pool->chunk_size) <
+	    sizeof(struct xdp_user_tx_metadata))
+		return -1;
+
+	if (!(desc->options & XDP_SOL_OPTION_SO_TXTIME) ||
+	    !(desc->options & XDP_DESC_OPTION_METADATA))
+		return -1;
+
+	md = (xp_raw_get_data(pool, desc->addr) -
+	      sizeof(struct xdp_user_tx_metadata));
+
+	if (!(md->md_valid & XDP_METADATA_USER_TX_TIMESTAMP))
+		return -1;
+
+	return md->timestamp;
+}
+EXPORT_SYMBOL(xp_raw_get_txtime);
+
 void *xp_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
 {
 	addr = pool->unaligned ? xp_unaligned_add_offset_to_addr(addr) : addr;
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 9ae13cccfb28..f7b323374b6d 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -140,7 +140,7 @@ static inline bool xp_aligned_validate_desc(struct xsk_buff_pool *pool,
 	if (chunk >= pool->addrs_cnt)
 		return false;
 
-	if (desc->options)
+	if (desc->options & ~XDP_DESC_OPTION_METADATA)
 		return false;
 	return true;
 }
@@ -160,7 +160,7 @@ static inline bool xp_unaligned_validate_desc(struct xsk_buff_pool *pool,
 	    xp_desc_crosses_non_contig_pg(pool, addr, desc->len))
 		return false;
 
-	if (desc->options)
+	if (desc->options & ~XDP_DESC_OPTION_METADATA)
 		return false;
 	return true;
 }
-- 
2.24.3 (Apple Git-128)

