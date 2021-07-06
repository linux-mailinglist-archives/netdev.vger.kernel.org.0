Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C709A3BCFE6
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbhGFLbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232815AbhGFLZZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:25:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1534C613E1;
        Tue,  6 Jul 2021 11:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570375;
        bh=dGEst82KgXLfRcJ0/1y8AuFQlbPJYg4Iu3JQwfeZVk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVc4gIrg+kJjEOTKLv84zyIPpm9VmGjdeNs83GraccI5cak8PsUrC3N903ahmkOTm
         L24sDfSe7jkp7gLtX9VyjNurjy/Xu2OMs7/Ti3d2waUMxnprNXC3QHnzWaCw6jELwv
         486VPWOU/CeZPZkQOXnxXj3QlSRDxDj1EtQcAD2LAru+2+ua5W2egzdksNVVTlHPub
         axWCiHFvjqUhT2q/npfJ9wPSigG5q+Y7UeeMsvhpF5U407I6GzLkSgmjsv8ZkcuPXy
         POR65rmD85o+R6jMg82P5jsUTG6OSxRl6x+cOIUVLi/sjVdFr3doaAxGPs9R/xIlvL
         aLOWlzU8tXwng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 051/160] virtio-net: Add validation for used length
Date:   Tue,  6 Jul 2021 07:16:37 -0400
Message-Id: <20210706111827.2060499-51-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit ad993a95c508417acdeb15244109e009e50d8758 ]

This adds validation for used length (might come
from an untrusted device) to avoid data corruption
or loss.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20210531135852.113-1-xieyongji@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0824e6999e49..447582fa20a5 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -660,6 +660,12 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	len -= vi->hdr_len;
 	stats->bytes += len;
 
+	if (unlikely(len > GOOD_PACKET_LEN)) {
+		pr_debug("%s: rx error: len %u exceeds max size %d\n",
+			 dev->name, len, GOOD_PACKET_LEN);
+		dev->stats.rx_length_errors++;
+		goto err_len;
+	}
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (xdp_prog) {
@@ -761,6 +767,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 err_xdp:
 	rcu_read_unlock();
 	stats->xdp_drops++;
+err_len:
 	stats->drops++;
 	put_page(page);
 xdp_xmit:
@@ -814,6 +821,12 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	head_skb = NULL;
 	stats->bytes += len - vi->hdr_len;
 
+	if (unlikely(len > truesize)) {
+		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
+			 dev->name, len, (unsigned long)ctx);
+		dev->stats.rx_length_errors++;
+		goto err_skb;
+	}
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (xdp_prog) {
@@ -938,13 +951,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	}
 	rcu_read_unlock();
 
-	if (unlikely(len > truesize)) {
-		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
-			 dev->name, len, (unsigned long)ctx);
-		dev->stats.rx_length_errors++;
-		goto err_skb;
-	}
-
 	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
 			       metasize);
 	curr_skb = head_skb;
-- 
2.30.2

