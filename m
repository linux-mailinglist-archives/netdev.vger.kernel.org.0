Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FBF47B7A2
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbhLUCAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:00:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34060 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233697AbhLUB7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:59:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FEFAB8110B;
        Tue, 21 Dec 2021 01:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7A3C36AEB;
        Tue, 21 Dec 2021 01:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051989;
        bh=+31zAUEqLZ4p24DVIeYtdQ9QUYg7k8xqpKZZRE+cjjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrQ08xn+AqWnvTEmOZzwRfLhIH7McrMszdA789U2HplUiYcWVnD2HJz/F2r0RV+Av
         X2U/jN7caLrjcQcYSaYWrLrfdosDSaHdiEa6iFmh2x4Ng/jtYrMZvSFaXHFIVb1EG0
         M98wPJpiRwZChyrFbCTCI0tOEOf2+J7jIcgyBn2mYDVqWFUdEEqij6p9DClgplplvd
         +EfgRyY1uTw0JYKZI/4GLpgl9GEnhgVmnS7iOxshWhpxhqpezypA9Mb6blMoXwyrzE
         BjCagMVjyUZX6dPxo60Jemi8lBlZbR+qvGOIWK385xjDxRmT4AXAIOKro3c+qFCzhP
         yS4kzMigl5QMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenliang Wang <wangwenliang.1995@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 17/19] virtio_net: fix rx_drops stat for small pkts
Date:   Mon, 20 Dec 2021 20:59:12 -0500
Message-Id: <20211221015914.116767-17-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015914.116767-1-sashal@kernel.org>
References: <20211221015914.116767-1-sashal@kernel.org>
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
index cbe47eed7cc3c..3ba289b695f04 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -697,7 +697,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		pr_debug("%s: rx error: len %u exceeds max size %d\n",
 			 dev->name, len, GOOD_PACKET_LEN);
 		dev->stats.rx_length_errors++;
-		goto err_len;
+		goto err;
 	}
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
@@ -782,10 +782,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
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
@@ -796,13 +794,12 @@ static struct sk_buff *receive_small(struct net_device *dev,
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

