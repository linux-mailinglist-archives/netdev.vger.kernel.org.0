Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE2647B803
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbhLUCDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:03:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35582 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234437AbhLUCBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 21:01:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C968B81109;
        Tue, 21 Dec 2021 02:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AC8C36AF4;
        Tue, 21 Dec 2021 02:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052112;
        bh=lYcfx75qi5eJ4gP86YhXQ0iQy9jsZBGY1pe4z56HV04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vhjv1mtxKz3pJ1AEHffZmahPfw8q/xRu80eDF9PrKiB5gug5ScbvXwzhw+VyoC4i8
         BPyBcD8JEwzR8DT9+bukKQnxpRxYI/XWk6sLxX2M43cIpde3eWdOPQPhD3WiazIt1M
         w+q0mM6/XezzkcyQ1ut/+rDo8RdgWW5YPTrQJpCUQzlOn3T3O/3eySF7gBRA8vyk92
         i4yvPhYriVamDD4SSQYxKGgm0QTkZSSX3rABmnIoj4d1RabBucdiG7nB+SJG4OY0dG
         V1UQOvH3j6insf1Dcq33XQMLOvyJJDBe7q5XFAEvD6QXof5r78RSi8RXNL3Dby5x9L
         wOmnJlJkGoo6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaoqian Lin <linmq006@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, opendmb@gmail.com,
        kuba@kernel.org, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 5/9] net: bcmgenet: Fix NULL vs IS_ERR() checking
Date:   Mon, 20 Dec 2021 21:01:19 -0500
Message-Id: <20211221020123.117380-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221020123.117380-1-sashal@kernel.org>
References: <20211221020123.117380-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit ab8eb798ddabddb2944401bf31ead9671cb97d95 ]

The phy_attach() function does not return NULL. It returns error pointers.

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 72fad2a63c625..e609154d1ac93 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -535,9 +535,9 @@ static int bcmgenet_mii_pd_init(struct bcmgenet_priv *priv)
 		 * Internal or external PHY with MDIO access
 		 */
 		phydev = phy_attach(priv->dev, phy_name, pd->phy_interface);
-		if (!phydev) {
+		if (IS_ERR(phydev)) {
 			dev_err(kdev, "failed to register PHY device\n");
-			return -ENODEV;
+			return PTR_ERR(phydev);
 		}
 	} else {
 		/*
-- 
2.34.1

