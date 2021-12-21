Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4921D47B757
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbhLUB7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 20:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233396AbhLUB6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:58:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EA2C06179B;
        Mon, 20 Dec 2021 17:58:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45B53B8110A;
        Tue, 21 Dec 2021 01:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FC0C36AEA;
        Tue, 21 Dec 2021 01:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051919;
        bh=i5NdvtJkmeX104ODEzdrBY1EYBH6FWDEKFIIEEhroZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqyNH4gIOdq8Bn3lBJsfQZmNYDHlIS2rbi4BwsJLZBSi3myck1v6Pi55L/qBtSQAx
         SR3V2jANl9EThRd+eWC0s1x3S1UuwOqUdaxvTvoHHuyJ2/jtkQwY3x5Ou6fKKR7Pi9
         IeKOweltyZRGXcIj/f5WkjsU0u0zHBa1ka1P3ui0e5j62IllHfO/KCrJi6G4nqA6cJ
         fvhmqkQo6dB0AUN2ZLZ+titrMFL82xAM44FCSbLY0LKUAtURcW9M5pjaDHwzcB67aJ
         pdUjeeOObXbZLCcHJ2zyo9WBukrBfzKLnMO9HNNqSAudGU38V+scXGBXyySqRr80h6
         vO/JUo+Ot7Bfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenliang Wang <wangwenliang.1995@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 22/29] virtio_net: fix rx_drops stat for small pkts
Date:   Mon, 20 Dec 2021 20:57:43 -0500
Message-Id: <20211221015751.116328-22-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015751.116328-1-sashal@kernel.org>
References: <20211221015751.116328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenliang Wang <wangwenliang.1995@bytedance.com>

[ Upstream commit 053c9e18c6f9cf82242ef35ac21cae1842725714 ]

We found the stat of rx drops for small pkts does not increment when
build_skb fail, it's not coherent with other mode's rx drops stat.

Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4ad25a8b0870c..1231b48f7183e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -730,7 +730,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		pr_debug("%s: rx error: len %u exceeds max size %d\n",
 			 dev->name, len, GOOD_PACKET_LEN);
 		dev->stats.rx_length_errors++;
-		goto err_len;
+		goto err;
 	}
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
@@ -815,10 +815,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	rcu_read_unlock();
 
 	skb = build_skb(buf, buflen);
-	if (!skb) {
-		put_page(page);
+	if (!skb)
 		goto err;
-	}
 	skb_reserve(skb, headroom - delta);
 	skb_put(skb, len);
 	if (!xdp_prog) {
@@ -829,13 +827,12 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	if (metasize)
 		skb_metadata_set(skb, metasize);
 
-err:
 	return skb;
 
 err_xdp:
 	rcu_read_unlock();
 	stats->xdp_drops++;
-err_len:
+err:
 	stats->drops++;
 	put_page(page);
 xdp_xmit:
-- 
2.34.1

