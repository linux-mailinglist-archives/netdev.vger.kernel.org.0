Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2E668FEF
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389812AbfGOORr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:17:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389465AbfGOORq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:17:46 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 726DA21530;
        Mon, 15 Jul 2019 14:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200265;
        bh=saYp66UYcTDDQpWG5VhqspncKjwKOnk1Hdx4A4GhGMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKiIxMhw9Vr22xuYJFOsurKxG3utMQr24e0BXn4PlvKlkNBhwESB4f/V7JGJJJO0E
         K/kekWK4tf5kxJoLeNXwFWbQtTTUl26ghoPLPToZOUTqsMHOY/Pqjs5Hmaa4gv+IpA
         affrXxyxa6BB9szAMfOv7WFVxEIGHVm+tuoY/mbU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Maximets <i.maximets@samsung.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        xdp-newbies@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 218/219] xdp: fix race on generic receive path
Date:   Mon, 15 Jul 2019 10:03:39 -0400
Message-Id: <20190715140341.6443-218-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilya Maximets <i.maximets@samsung.com>

[ Upstream commit bf0bdd1343efbbf65b4d53aef1fce14acbd79d50 ]

Unlike driver mode, generic xdp receive could be triggered
by different threads on different CPU cores at the same time
leading to the fill and rx queue breakage. For example, this
could happen while sending packets from two processes to the
first interface of veth pair while the second part of it is
open with AF_XDP socket.

Need to take a lock for each generic receive to avoid race.

Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: William Tu <u9012063@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp_sock.h |  2 ++
 net/xdp/xsk.c          | 31 ++++++++++++++++++++++---------
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index d074b6d60f8a..ac3c047d058c 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -67,6 +67,8 @@ struct xdp_sock {
 	 * in the SKB destructor callback.
 	 */
 	spinlock_t tx_completion_lock;
+	/* Protects generic receive. */
+	spinlock_t rx_lock;
 	u64 rx_dropped;
 };
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index a14e8864e4fa..5e0637db92ea 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -123,13 +123,17 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	u64 addr;
 	int err;
 
-	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
-		return -EINVAL;
+	spin_lock_bh(&xs->rx_lock);
+
+	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
 
 	if (!xskq_peek_addr(xs->umem->fq, &addr) ||
 	    len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
-		xs->rx_dropped++;
-		return -ENOSPC;
+		err = -ENOSPC;
+		goto out_drop;
 	}
 
 	addr += xs->umem->headroom;
@@ -138,13 +142,21 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	memcpy(buffer, xdp->data_meta, len + metalen);
 	addr += metalen;
 	err = xskq_produce_batch_desc(xs->rx, addr, len);
-	if (!err) {
-		xskq_discard_addr(xs->umem->fq);
-		xsk_flush(xs);
-		return 0;
-	}
+	if (err)
+		goto out_drop;
+
+	xskq_discard_addr(xs->umem->fq);
+	xskq_produce_flush_desc(xs->rx);
 
+	spin_unlock_bh(&xs->rx_lock);
+
+	xs->sk.sk_data_ready(&xs->sk);
+	return 0;
+
+out_drop:
 	xs->rx_dropped++;
+out_unlock:
+	spin_unlock_bh(&xs->rx_lock);
 	return err;
 }
 
@@ -765,6 +777,7 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
 
 	xs = xdp_sk(sk);
 	mutex_init(&xs->mutex);
+	spin_lock_init(&xs->rx_lock);
 	spin_lock_init(&xs->tx_completion_lock);
 
 	mutex_lock(&net->xdp.lock);
-- 
2.20.1

