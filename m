Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBFE5C2264
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 15:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731343AbfI3NsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 09:48:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:45443 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730864AbfI3NsJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 09:48:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Sep 2019 06:48:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,567,1559545200"; 
   d="scan'208";a="342654351"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.40.22])
  by orsmga004.jf.intel.com with ESMTP; 30 Sep 2019 06:48:07 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf] xsk: fix crash in poll when device does not support ndo_xsk_wakeup
Date:   Mon, 30 Sep 2019 15:30:12 +0200
Message-Id: <1569850212-4035-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes a crash in poll() when an AF_XDP socket is opened in copy mode
with the XDP_USE_NEED_WAKEUP flag set and the bound device does not
have ndo_xsk_wakeup defined. Avoid trying to call the non-existing ndo
and instead call the internal xsk sendmsg functionality to send
packets in the same way (from the application's point of view) as
calling sendmsg() in any mode or poll() in zero-copy mode would have
done. The application should behave in the same way independent on if
zero-copy mode or copy-mode is used.

Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP rings")
Reported-by: syzbot+a5765ed8cdb1cca4d249@syzkaller.appspotmail.com
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index c2f1af3..a478d8ec 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -327,8 +327,7 @@ static void xsk_destruct_skb(struct sk_buff *skb)
 	sock_wfree(skb);
 }
 
-static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
-			    size_t total_len)
+static int xsk_generic_xmit(struct sock *sk)
 {
 	u32 max_batch = TX_BATCH_SIZE;
 	struct xdp_sock *xs = xdp_sk(sk);
@@ -394,22 +393,31 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
 	return err;
 }
 
-static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
+static int __xsk_sendmsg(struct socket *sock)
 {
-	bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
 
-	if (unlikely(!xsk_is_bound(xs)))
-		return -ENXIO;
 	if (unlikely(!(xs->dev->flags & IFF_UP)))
 		return -ENETDOWN;
 	if (unlikely(!xs->tx))
 		return -ENOBUFS;
+
+	return xs->zc ? xsk_zc_xmit(sk) : xsk_generic_xmit(sk);
+}
+
+static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
+{
+	bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
+	struct sock *sk = sock->sk;
+	struct xdp_sock *xs = xdp_sk(sk);
+
+	if (unlikely(!xsk_is_bound(xs)))
+		return -ENXIO;
 	if (need_wait)
 		return -EOPNOTSUPP;
 
-	return (xs->zc) ? xsk_zc_xmit(sk) : xsk_generic_xmit(sk, m, total_len);
+	return __xsk_sendmsg(sock);
 }
 
 static unsigned int xsk_poll(struct file *file, struct socket *sock,
@@ -426,9 +434,14 @@ static unsigned int xsk_poll(struct file *file, struct socket *sock,
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
+			__xsk_sendmsg(sock);
+	}
 
 	if (xs->rx && !xskq_empty_desc(xs->rx))
 		mask |= POLLIN | POLLRDNORM;
-- 
2.7.4

