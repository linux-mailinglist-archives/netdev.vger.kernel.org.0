Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0900998EE9
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 11:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733048AbfHVJNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 05:13:53 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44177 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733031AbfHVJNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 05:13:53 -0400
Received: by mail-pf1-f196.google.com with SMTP id c81so3514103pfc.11;
        Thu, 22 Aug 2019 02:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=53kzOzk9uol8OLrgJrHS3uVmvMJpgzP74FNMi6gK/mk=;
        b=jZ72maZkiKbEi0HIFWIRpNYXtmWLrhzm9paPa4zWmdhrgIh0b6Yy7I63McSw7kU8v0
         HXlZAEwCl4JMXaRjI+oFHaqJ0UFGeFYGltcoA1NDwl7uW2AHjf9m7/hthofX/rt8MeJz
         dlrUDXWJz2A2zqMsHPVVlFS+uB8OMy85Kl2pTOgHqW6/u0VdD12Vaw0fTEqQdSTekI8C
         twC6ee8o//t86OQV2ZW96jLxY4q34HFOEQjiZZF0r8L+Nw4aV6pl7SPW6qVqAxPj4qq1
         gkfKOQ10ZqnxTB5qMie62MISwVpC1MXS/WZ9D7AFfvOHcZtfjNgEvb23YBPiUeryfYU1
         E/zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=53kzOzk9uol8OLrgJrHS3uVmvMJpgzP74FNMi6gK/mk=;
        b=L/1N7an1WiZssQw0UFnDt8N1E3H6Q3UeQGh641Vv/SmzENo2ILZy/RBRHTKfAunyLz
         Cg3dEdALoAymNWn1CyRzA6WStAnvEIuz7/y1xSxg8XEmt7l7/tOpcPMnCgpLXeviABFf
         IuOfNjGtzTYjcLfFmzKiDxCOuwqC1rV+x0k17NS7FYp7XUUCOH9lghcQXMBu4xdKySo5
         ow21KVhi/jV/Q7/eAsaR7HixnGIoyPHeGUtXZTqZz7QVZCefgd8/4wze5+wiN7jJfY3k
         uK7tWLPzyz59ZqC6TMl+9KXhuJGWSN/01bFatxBSNXABn71+jv+293RNUFvJR4lYz8un
         B1xw==
X-Gm-Message-State: APjAAAUqsfUCrSgUrHt216wNU3eb7cmePUhWKICz5IZbwirBhMq4WYFM
        HUP3MuFObv8plFKyoNDH+uI=
X-Google-Smtp-Source: APXvYqzcE238JwBE/c3B4RyLI5BXrxnF4Jvl96NuTQwF/WEMMg/WMasa7Wk4j8UURI1MFG36nKwitg==
X-Received: by 2002:a63:e70f:: with SMTP id b15mr32873869pgi.152.1566465232382;
        Thu, 22 Aug 2019 02:13:52 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.43])
        by smtp.gmail.com with ESMTPSA id w207sm28414754pff.93.2019.08.22.02.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 02:13:51 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: [PATCH bpf-next 2/4] xsk: add proper barriers and {READ, WRITE}_ONCE-correctness for state
Date:   Thu, 22 Aug 2019 11:13:04 +0200
Message-Id: <20190822091306.20581-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822091306.20581-1-bjorn.topel@gmail.com>
References: <20190822091306.20581-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The state variable was read, and written outside the control mutex
(struct xdp_sock, mutex), without proper barriers and {READ,
WRITE}_ONCE correctness.

In this commit this issue is addressed, and the state member is now
used a point of synchronization whether the socket is setup correctly
or not.

This also fixes a race, found by syzcaller, in xsk_poll() where umem
could be accessed when stale.

Suggested-by: Hillf Danton <hdanton@sina.com>
Reported-by: syzbot+c82697e3043781e08802@syzkaller.appspotmail.com
Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP rings")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 57 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 16 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index f3351013c2a5..31236e61069b 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -162,10 +162,23 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 	return err;
 }
 
+static bool xsk_is_bound(struct xdp_sock *xs)
+{
+	if (READ_ONCE(xs->state) == XSK_BOUND) {
+		/* Matches smp_wmb() in bind(). */
+		smp_rmb();
+		return true;
+	}
+	return false;
+}
+
 int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	u32 len;
 
+	if (!xsk_is_bound(xs))
+		return -EINVAL;
+
 	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
 		return -EINVAL;
 
@@ -362,6 +375,8 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
 
+	if (unlikely(!xsk_is_bound(xs)))
+		return -ENXIO;
 	if (unlikely(!xs->dev))
 		return -ENXIO;
 	if (unlikely(!(xs->dev->flags & IFF_UP)))
@@ -378,10 +393,15 @@ static unsigned int xsk_poll(struct file *file, struct socket *sock,
 			     struct poll_table_struct *wait)
 {
 	unsigned int mask = datagram_poll(file, sock, wait);
-	struct sock *sk = sock->sk;
-	struct xdp_sock *xs = xdp_sk(sk);
-	struct net_device *dev = xs->dev;
-	struct xdp_umem *umem = xs->umem;
+	struct xdp_sock *xs = xdp_sk(sock->sk);
+	struct net_device *dev;
+	struct xdp_umem *umem;
+
+	if (unlikely(!xsk_is_bound(xs)))
+		return mask;
+
+	dev = xs->dev;
+	umem = xs->umem;
 
 	if (umem->need_wakeup)
 		dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
@@ -417,10 +437,9 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
 {
 	struct net_device *dev = xs->dev;
 
-	if (!dev || xs->state != XSK_BOUND)
+	if (xs->state != XSK_BOUND)
 		return;
-
-	xs->state = XSK_UNBOUND;
+	WRITE_ONCE(xs->state, XSK_UNBOUND);
 
 	/* Wait for driver to stop using the xdp socket. */
 	xdp_del_sk_umem(xs->umem, xs);
@@ -495,7 +514,9 @@ static int xsk_release(struct socket *sock)
 	local_bh_enable();
 
 	xsk_delete_from_maps(xs);
+	mutex_lock(&xs->mutex);
 	xsk_unbind_dev(xs);
+	mutex_unlock(&xs->mutex);
 
 	xskq_destroy(xs->rx);
 	xskq_destroy(xs->tx);
@@ -589,19 +610,18 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		}
 
 		umem_xs = xdp_sk(sock->sk);
-		if (!umem_xs->umem) {
-			/* No umem to inherit. */
+		if (!xsk_is_bound(umem_xs)) {
 			err = -EBADF;
 			sockfd_put(sock);
 			goto out_unlock;
-		} else if (umem_xs->dev != dev || umem_xs->queue_id != qid) {
+		}
+		if (umem_xs->dev != dev || umem_xs->queue_id != qid) {
 			err = -EINVAL;
 			sockfd_put(sock);
 			goto out_unlock;
 		}
-
 		xdp_get_umem(umem_xs->umem);
-		xs->umem = umem_xs->umem;
+		WRITE_ONCE(xs->umem, umem_xs->umem);
 		sockfd_put(sock);
 	} else if (!xs->umem || !xdp_umem_validate_queues(xs->umem)) {
 		err = -EINVAL;
@@ -626,10 +646,15 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	xdp_add_sk_umem(xs->umem, xs);
 
 out_unlock:
-	if (err)
+	if (err) {
 		dev_put(dev);
-	else
-		xs->state = XSK_BOUND;
+	} else {
+		/* Matches smp_rmb() in bind() for shared umem
+		 * sockets, and xsk_is_bound().
+		 */
+		smp_wmb();
+		WRITE_ONCE(xs->state, XSK_BOUND);
+	}
 out_release:
 	mutex_unlock(&xs->mutex);
 	rtnl_unlock();
@@ -869,7 +894,7 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 	unsigned long pfn;
 	struct page *qpg;
 
-	if (xs->state != XSK_READY)
+	if (READ_ONCE(xs->state) != XSK_READY)
 		return -EBUSY;
 
 	if (offset == XDP_PGOFF_RX_RING) {
-- 
2.20.1

