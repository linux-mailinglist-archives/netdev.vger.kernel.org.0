Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C364D434F77
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 17:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhJTP6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 11:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230507AbhJTP6m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 11:58:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D69516138F;
        Wed, 20 Oct 2021 15:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634745388;
        bh=txmVNN0hLjbw9YKaQiBsAl86Vw+FAG8CaBtPXu0Y250=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jL6iT9Ki+IP8tmuGiuN5BJTlC2LZYTdhy1owZTJ1iZ2xLIc8F/SCxLKxhEl20qu+u
         sVmGWZuTWIJf2fa752Hy5UGXApBg/Xkl9UiSti9Pf7rFGkpynOWYYKKO0No7nGPfxq
         +3M6ctsdxv7DquNE5tlMKGK3hUem5Z/AjPyDEAH1ryuDnMeQ9/HfRm5sDnNO2NR7AL
         E8p+7uOUJeWNlbebvsNM9zl8g6zZrox8gAI+pmVqP0tgLn/0bxoZxTj6j+90v1vLDt
         utBcLQ89iM8Sdwjd3HrZP1pAR033Iv9N89eciFU1mJLqdrmpwLg0LEyvI8x8K3HHuU
         gLFI/qRKqQg1g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 10/12] net: plip: use eth_hw_addr_set()
Date:   Wed, 20 Oct 2021 08:56:15 -0700
Message-Id: <20211020155617.1721694-11-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020155617.1721694-1-kuba@kernel.org>
References: <20211020155617.1721694-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get it ready for constant netdev->dev_addr.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/plip/plip.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index 82d609401711..0d491b4d6667 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -284,12 +284,16 @@ static const struct net_device_ops plip_netdev_ops = {
 static void
 plip_init_netdev(struct net_device *dev)
 {
+	static const u8 addr_init[ETH_ALEN] = {
+		0xfc, 0xfc, 0xfc,
+		0xfc, 0xfc, 0xfc,
+	};
 	struct net_local *nl = netdev_priv(dev);
 
 	/* Then, override parts of it */
 	dev->tx_queue_len 	 = 10;
 	dev->flags	         = IFF_POINTOPOINT|IFF_NOARP;
-	memset(dev->dev_addr, 0xfc, ETH_ALEN);
+	eth_hw_addr_set(dev, addr_init);
 
 	dev->netdev_ops		 = &plip_netdev_ops;
 	dev->header_ops          = &plip_header_ops;
@@ -1109,7 +1113,7 @@ plip_open(struct net_device *dev)
 		   plip_init_dev(). */
 		const struct in_ifaddr *ifa = rcu_dereference(in_dev->ifa_list);
 		if (ifa != NULL) {
-			memcpy(dev->dev_addr+2, &ifa->ifa_local, 4);
+			dev_addr_mod(dev, 2, &ifa->ifa_local, 4);
 		}
 	}
 
-- 
2.31.1

