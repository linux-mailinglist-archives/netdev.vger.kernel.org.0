Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3BE452BA5
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 08:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhKPHlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 02:41:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:42900 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230356AbhKPHla (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 02:41:30 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="231099053"
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="231099053"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 23:38:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="671857324"
Received: from silpixa00401086.ir.intel.com (HELO localhost.localdomain) ([10.55.129.110])
  by orsmga005.jf.intel.com with ESMTP; 15 Nov 2021 23:38:31 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        toke@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        Ciara Loftus <ciara.loftus@intel.com>
Subject: [RFC PATCH bpf-next 3/8] xsk: handle XDP_REDIRECT_XSK and expose xsk_rcv/flush
Date:   Tue, 16 Nov 2021 07:37:37 +0000
Message-Id: <20211116073742.7941-4-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211116073742.7941-1-ciara.loftus@intel.com>
References: <20211116073742.7941-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handle the XDP_REDIRECT_XSK action on the SKB path by retrieving the
handle to the socket from the netdev_rx_queue struct and immediately
calling the xsk_generic_rcv function. Also, prepare for supporting
this action in the drivers by exposing the xsk_rcv and xsk_flush functions
so they can be used directly in the drivers.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 include/net/xdp_sock_drv.h | 21 +++++++++++++++++++++
 net/core/dev.c             | 14 ++++++++++++++
 net/core/filter.c          |  4 ++++
 net/xdp/xsk.c              |  6 ++++--
 4 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 443d45951564..e923f5d1adb6 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -22,6 +22,8 @@ void xsk_set_tx_need_wakeup(struct xsk_buff_pool *pool);
 void xsk_clear_rx_need_wakeup(struct xsk_buff_pool *pool);
 void xsk_clear_tx_need_wakeup(struct xsk_buff_pool *pool);
 bool xsk_uses_need_wakeup(struct xsk_buff_pool *pool);
+int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp);
+void xsk_flush(struct xdp_sock *xs);
 
 static inline u32 xsk_pool_get_headroom(struct xsk_buff_pool *pool)
 {
@@ -130,6 +132,11 @@ static inline void xsk_buff_raw_dma_sync_for_device(struct xsk_buff_pool *pool,
 	xp_dma_sync_for_device(pool, dma, size);
 }
 
+static inline struct xdp_sock *xsk_get_redirect_xsk(struct netdev_rx_queue *q)
+{
+	return READ_ONCE(q->xsk);
+}
+
 #else
 
 static inline void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries)
@@ -179,6 +186,15 @@ static inline bool xsk_uses_need_wakeup(struct xsk_buff_pool *pool)
 	return false;
 }
 
+static inline int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
+{
+	return 0;
+}
+
+static inline void xsk_flush(struct xdp_sock *xs)
+{
+}
+
 static inline u32 xsk_pool_get_headroom(struct xsk_buff_pool *pool)
 {
 	return 0;
@@ -264,6 +280,11 @@ static inline void xsk_buff_raw_dma_sync_for_device(struct xsk_buff_pool *pool,
 {
 }
 
+static inline struct xdp_sock *xsk_get_redirect_xsk(struct netdev_rx_queue *q)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_XDP_SOCKETS */
 
 #endif /* _LINUX_XDP_SOCK_DRV_H */
diff --git a/net/core/dev.c b/net/core/dev.c
index edeb811c454e..9b38b50f1f97 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -106,6 +106,7 @@
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
 #include <net/checksum.h>
+#include <net/xdp_sock.h>
 #include <net/xfrm.h>
 #include <linux/highmem.h>
 #include <linux/init.h>
@@ -4771,6 +4772,7 @@ u32 bpf_prog_run_generic_xdp(struct sk_buff *skb, struct xdp_buff *xdp,
 	 * kfree_skb in response to actions it cannot handle/XDP_DROP).
 	 */
 	switch (act) {
+	case XDP_REDIRECT_XSK:
 	case XDP_REDIRECT:
 	case XDP_TX:
 		__skb_push(skb, mac_len);
@@ -4819,6 +4821,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 
 	act = bpf_prog_run_generic_xdp(skb, xdp, xdp_prog);
 	switch (act) {
+	case XDP_REDIRECT_XSK:
 	case XDP_REDIRECT:
 	case XDP_TX:
 	case XDP_PASS:
@@ -4875,6 +4878,17 @@ int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
 		act = netif_receive_generic_xdp(skb, &xdp, xdp_prog);
 		if (act != XDP_PASS) {
 			switch (act) {
+#ifdef CONFIG_XDP_SOCKETS
+			case XDP_REDIRECT_XSK:
+				struct xdp_sock *xs =
+					READ_ONCE(skb->dev->_rx[xdp.rxq->queue_index].xsk);
+
+				err = xsk_generic_rcv(xs, &xdp);
+				if (err)
+					goto out_redir;
+				consume_skb(skb);
+				break;
+#endif
 			case XDP_REDIRECT:
 				err = xdp_do_generic_redirect(skb->dev, skb,
 							      &xdp, xdp_prog);
diff --git a/net/core/filter.c b/net/core/filter.c
index 4497ad046790..c65262722c64 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8203,7 +8203,11 @@ static bool xdp_is_valid_access(int off, int size,
 
 void bpf_warn_invalid_xdp_action(u32 act)
 {
+#ifdef CONFIG_XDP_SOCKETS
+	const u32 act_max = XDP_REDIRECT_XSK;
+#else
 	const u32 act_max = XDP_REDIRECT;
+#endif
 
 	WARN_ONCE(1, "%s XDP return value %u, expect packet loss!\n",
 		  act > act_max ? "Illegal" : "Driver unsupported",
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 94ee524b9ca8..ce004f5fae64 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -226,12 +226,13 @@ static int xsk_rcv_check(struct xdp_sock *xs, struct xdp_buff *xdp)
 	return 0;
 }
 
-static void xsk_flush(struct xdp_sock *xs)
+void xsk_flush(struct xdp_sock *xs)
 {
 	xskq_prod_submit(xs->rx);
 	__xskq_cons_release(xs->pool->fq);
 	sock_def_readable(&xs->sk);
 }
+EXPORT_SYMBOL(xsk_flush);
 
 int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
@@ -247,7 +248,7 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	return err;
 }
 
-static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
+int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	int err;
 	u32 len;
@@ -266,6 +267,7 @@ static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 		xdp_return_buff(xdp);
 	return err;
 }
+EXPORT_SYMBOL(xsk_rcv);
 
 int __xsk_map_redirect(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
-- 
2.17.1

