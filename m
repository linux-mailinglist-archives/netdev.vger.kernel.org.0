Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2973C47CA
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 08:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfJBGcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 02:32:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:48425 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfJBGcN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 02:32:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 23:32:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,573,1559545200"; 
   d="scan'208";a="343234531"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.37.230])
  by orsmga004.jf.intel.com with ESMTP; 01 Oct 2019 23:32:10 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf v2] xsk: fix crash in poll when device does not support ndo_xsk_wakeup
Date:   Wed,  2 Oct 2019 08:31:59 +0200
Message-Id: <1569997919-11541-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes a crash in poll() when an AF_XDP socket is opened in copy mode
and the bound device does not have ndo_xsk_wakeup defined. Avoid
trying to call the non-existing ndo and instead call the internal xsk
sendmsg function to send packets in the same way (from the
application's point of view) as calling sendmsg() in any mode or
poll() in zero-copy mode would have done. The application should
behave in the same way independent on if zero-copy mode or copy mode
is used.

Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP rings")
Reported-by: syzbot+a5765ed8cdb1cca4d249@syzkaller.appspotmail.com
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk.c | 42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index fa8fbb8f..9044073 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -305,9 +305,8 @@ bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc)
 }
 EXPORT_SYMBOL(xsk_umem_consume_tx);
 
-static int xsk_zc_xmit(struct sock *sk)
+static int xsk_zc_xmit(struct xdp_sock *xs)
 {
-	struct xdp_sock *xs = xdp_sk(sk);
 	struct net_device *dev = xs->dev;
 
 	return dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
@@ -327,11 +326,10 @@ static void xsk_destruct_skb(struct sk_buff *skb)
 	sock_wfree(skb);
 }
 
-static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
-			    size_t total_len)
+static int xsk_generic_xmit(struct sock *sk)
 {
-	u32 max_batch = TX_BATCH_SIZE;
 	struct xdp_sock *xs = xdp_sk(sk);
+	u32 max_batch = TX_BATCH_SIZE;
 	bool sent_frame = false;
 	struct xdp_desc desc;
 	struct sk_buff *skb;
@@ -394,6 +392,18 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
 	return err;
 }
 
+static int __xsk_sendmsg(struct sock *sk)
+{
+	struct xdp_sock *xs = xdp_sk(sk);
+
+	if (unlikely(!(xs->dev->flags & IFF_UP)))
+		return -ENETDOWN;
+	if (unlikely(!xs->tx))
+		return -ENOBUFS;
+
+	return xs->zc ? xsk_zc_xmit(xs) : xsk_generic_xmit(sk);
+}
+
 static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 {
 	bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
@@ -402,21 +412,18 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 
 	if (unlikely(!xsk_is_bound(xs)))
 		return -ENXIO;
-	if (unlikely(!(xs->dev->flags & IFF_UP)))
-		return -ENETDOWN;
-	if (unlikely(!xs->tx))
-		return -ENOBUFS;
-	if (need_wait)
+	if (unlikely(need_wait))
 		return -EOPNOTSUPP;
 
-	return (xs->zc) ? xsk_zc_xmit(sk) : xsk_generic_xmit(sk, m, total_len);
+	return __xsk_sendmsg(sk);
 }
 
 static unsigned int xsk_poll(struct file *file, struct socket *sock,
 			     struct poll_table_struct *wait)
 {
 	unsigned int mask = datagram_poll(file, sock, wait);
-	struct xdp_sock *xs = xdp_sk(sock->sk);
+	struct sock *sk = sock->sk;
+	struct xdp_sock *xs = xdp_sk(sk);
 	struct net_device *dev;
 	struct xdp_umem *umem;
 
@@ -426,9 +433,14 @@ static unsigned int xsk_poll(struct file *file, struct socket *sock,
 	dev = xs->dev;
 	umem = xs->umem;
 
-	if (umem->need_wakeup)
-		dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
-						umem->need_wakeup);
+	if (umem->need_wakeup) {
+		if (dev->netdev_ops->ndo_xsk_wakeup)
+			dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
+							umem->need_wakeup);
+		else
+			/* Poll needs to drive Tx also in copy mode */
+			__xsk_sendmsg(sk);
+	}
 
 	if (xs->rx && !xskq_empty_desc(xs->rx))
 		mask |= POLLIN | POLLRDNORM;
-- 
2.7.4

