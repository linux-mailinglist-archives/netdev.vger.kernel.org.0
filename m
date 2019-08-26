Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E01D89C8FC
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 08:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbfHZGL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 02:11:26 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38274 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729348AbfHZGL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 02:11:26 -0400
Received: by mail-pf1-f194.google.com with SMTP id o70so11095999pfg.5;
        Sun, 25 Aug 2019 23:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6hdTdPpF9Wg+T70R6ZHOrFu/emCNeLVTxxZFb2xfDQw=;
        b=uLkaz7RqAcxFxGVJFmeFmmgaYYvOWs5iJ1zbPwYyp4MOdebXjvcWKky6JWkgIkcI/R
         zaD+ErMX/tSJUacxRuNHl8C3aLrcys2EbUBVT82ARFNL3Vg6nVx4ydrUvpg7d2HGK0Sy
         dx1wNu3+LPBjLpB9nXdY3tDn6VO8U6gyVrsFETz/bAvfqKWqOW8yUx2KRbbePMNmsdb0
         RtH3CIAAm3mZYl9c/oo8pLXoV3aKixsCrd7lC8DRqXKM+SdNencWK45dO+cL0Sms+TLW
         jDKA9sQErMxYzRuAUhnc6KnIPRhKpL78mkDYsQZeDhjv2Et43JS1GtzmgMbtUFqIA5F8
         snHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6hdTdPpF9Wg+T70R6ZHOrFu/emCNeLVTxxZFb2xfDQw=;
        b=Xa0cNZqQMqsr7JmtFtBUIIhsQ2IaQmtpab1leyk2hEg3wGxcKfK+4RQ004AZgWbDx+
         fkRzf0wPoJ3VpBDLNcBAKWhrxgIBPGvCljLK4GeT6NBVDZCYGywXUvrFuS+xb8Nbeh5w
         sfNhvTV/6x82Pdtjsp1fXfPQABcIxZ6EvwjFBPa0+g60JQqi6baPQGxS2HbPu0bbZ4sz
         XtxeNKW2m3kAtcThKcVeGlhAUw+4Sb5sxJbBx+JLk9v9rO1+dHxpFjWeVSS2jGYdFSMa
         EFH5jEKjlp/FBJ4uG74gI0b9lfR9lMSoERG4LAYPjGNUg2Tn6xwXVXskH0TO/2r8uQ14
         EVWg==
X-Gm-Message-State: APjAAAV0Nrb7ZtOBZUiagSSp/gAdPcN/MmKOTTdqaXz3ytXnHfXm9TZD
        tKFS3KYvAu4kGIROYkNMmKM=
X-Google-Smtp-Source: APXvYqx//KsHBg5+gH6ZIGVGHslDHAE/q7Yk7Gcg5rj0KjkW/aa/YK1gM9/M+zSWctIoeuG9zjKBXA==
X-Received: by 2002:a62:64d4:: with SMTP id y203mr18205660pfb.91.1566799885293;
        Sun, 25 Aug 2019 23:11:25 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id d2sm9567452pjs.21.2019.08.25.23.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 23:11:24 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: [PATCH bpf-next v2 2/4] xsk: add proper barriers and {READ, WRITE}_ONCE-correctness for state
Date:   Mon, 26 Aug 2019 08:10:51 +0200
Message-Id: <20190826061053.15996-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190826061053.15996-1-bjorn.topel@gmail.com>
References: <20190826061053.15996-1-bjorn.topel@gmail.com>
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
 1 file changed, 40 insertions(+), 17 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index f3351013c2a5..8fafa3ce3ae6 100644
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
 
@@ -362,7 +375,7 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
 
-	if (unlikely(!xs->dev))
+	if (unlikely(!xsk_is_bound(xs)))
 		return -ENXIO;
 	if (unlikely(!(xs->dev->flags & IFF_UP)))
 		return -ENETDOWN;
@@ -378,10 +391,15 @@ static unsigned int xsk_poll(struct file *file, struct socket *sock,
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
@@ -417,10 +435,9 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
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
@@ -495,7 +512,9 @@ static int xsk_release(struct socket *sock)
 	local_bh_enable();
 
 	xsk_delete_from_maps(xs);
+	mutex_lock(&xs->mutex);
 	xsk_unbind_dev(xs);
+	mutex_unlock(&xs->mutex);
 
 	xskq_destroy(xs->rx);
 	xskq_destroy(xs->tx);
@@ -589,19 +608,18 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
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
@@ -626,10 +644,15 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
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
@@ -869,7 +892,7 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 	unsigned long pfn;
 	struct page *qpg;
 
-	if (xs->state != XSK_READY)
+	if (READ_ONCE(xs->state) != XSK_READY)
 		return -EBUSY;
 
 	if (offset == XDP_PGOFF_RX_RING) {
-- 
2.20.1

