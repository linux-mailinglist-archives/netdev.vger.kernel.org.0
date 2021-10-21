Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF556436281
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 15:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhJUNOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 09:14:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230520AbhJUNOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 09:14:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBDBA61354;
        Thu, 21 Oct 2021 13:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634821942;
        bh=txmVNN0hLjbw9YKaQiBsAl86Vw+FAG8CaBtPXu0Y250=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iCKVcb2Z+rDGCeLEBoiyII0me6t41asKYlO8DZrgVDqsHm4IOgf7nYIH6SDOGI/OH
         RzOnSu9NaPSbQ3yeP47++kKo2Di+rIrjwFUBmQbNXBjtnHBSkmmrtBDS4EhP2QzpSe
         j68EE5C+8OKVO0OwZNUMyHQBSJnn/M5dGB8lfHG8hNu1P3JuwSe7SqOawV7Ew9BCrc
         aD7FngIF8h0nDlwq9vqJCXnNRHydmW8Jko6oC0KNEG8/D1u/QrjswkIWJbnCmwmW8w
         t4z8F+WTalqoG2hXRRjxMc5N8wM5MbrEvR9O6VxK+03cKfpJFarMWnAFPgeQTlPion
         TBo4ALGgifSKQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 10/12] net: plip: use eth_hw_addr_set()
Date:   Thu, 21 Oct 2021 06:12:12 -0700
Message-Id: <20211021131214.2032925-11-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211021131214.2032925-1-kuba@kernel.org>
References: <20211021131214.2032925-1-kuba@kernel.org>
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

