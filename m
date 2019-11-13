Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F79CFA51E
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbfKMCVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:21:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727935AbfKMByI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:54:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58E85222CD;
        Wed, 13 Nov 2019 01:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610047;
        bh=seh6PmXvSTkNpVGMUR2DlyeDVyJ5I38GlRYzKWTGXiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNTQnJAdprWe3WgsAAUyrABxhg4t0YvYma9tyjkU66TPWKjrzP2x/NG8SoIHzHC3A
         R4NFaoKHx6BKqn2S5WJAx5VKDoO0M1LcREyJzO2KfDC0J1dr6+FLBz7/qtkjd0O/on
         5Cw6nYwTh6sDYAfeGo2JQJ2xzB7MvXfp2KIE/G8I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 135/209] xsk: proper AF_XDP socket teardown ordering
Date:   Tue, 12 Nov 2019 20:49:11 -0500
Message-Id: <20191113015025.9685-135-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

[ Upstream commit 541d7fdd7694560404c502f64298a90ffe017e6b ]

The AF_XDP socket struct can exist in three different, implicit
states: setup, bound and released. Setup is prior the socket has been
bound to a device. Bound is when the socket is active for receive and
send. Released is when the process/userspace side of the socket is
released, but the sock object is still lingering, e.g. when there is a
reference to the socket in an XSKMAP after process termination.

The Rx fast-path code uses the "dev" member of struct xdp_sock to
check whether a socket is bound or relased, and the Tx code uses the
struct xdp_umem "xsk_list" member in conjunction with "dev" to
determine the state of a socket.

However, the transition from bound to released did not tear the socket
down in correct order.

On the Rx side "dev" was cleared after synchronize_net() making the
synchronization useless. On the Tx side, the internal queues were
destroyed prior removing them from the "xsk_list".

This commit corrects the cleanup order, and by doing so
xdp_del_sk_umem() can be simplified and one synchronize_net() can be
removed.

Fixes: 965a99098443 ("xsk: add support for bind for Rx")
Fixes: ac98d8aab61b ("xsk: wire upp Tx zero-copy functions")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xdp_umem.c | 11 +++--------
 net/xdp/xsk.c      | 13 ++++++++-----
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 8cab91c482ff5..d9117ab035f7c 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -32,14 +32,9 @@ void xdp_del_sk_umem(struct xdp_umem *umem, struct xdp_sock *xs)
 {
 	unsigned long flags;
 
-	if (xs->dev) {
-		spin_lock_irqsave(&umem->xsk_list_lock, flags);
-		list_del_rcu(&xs->list);
-		spin_unlock_irqrestore(&umem->xsk_list_lock, flags);
-
-		if (umem->zc)
-			synchronize_net();
-	}
+	spin_lock_irqsave(&umem->xsk_list_lock, flags);
+	list_del_rcu(&xs->list);
+	spin_unlock_irqrestore(&umem->xsk_list_lock, flags);
 }
 
 int xdp_umem_query(struct net_device *dev, u16 queue_id)
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 661504042d304..ff15207036dc5 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -343,12 +343,18 @@ static int xsk_release(struct socket *sock)
 	local_bh_enable();
 
 	if (xs->dev) {
+		struct net_device *dev = xs->dev;
+
 		/* Wait for driver to stop using the xdp socket. */
-		synchronize_net();
-		dev_put(xs->dev);
+		xdp_del_sk_umem(xs->umem, xs);
 		xs->dev = NULL;
+		synchronize_net();
+		dev_put(dev);
 	}
 
+	xskq_destroy(xs->rx);
+	xskq_destroy(xs->tx);
+
 	sock_orphan(sk);
 	sock->sk = NULL;
 
@@ -707,9 +713,6 @@ static void xsk_destruct(struct sock *sk)
 	if (!sock_flag(sk, SOCK_DEAD))
 		return;
 
-	xskq_destroy(xs->rx);
-	xskq_destroy(xs->tx);
-	xdp_del_sk_umem(xs->umem, xs);
 	xdp_put_umem(xs->umem);
 
 	sk_refcnt_debug_dec(sk);
-- 
2.20.1

