Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9135148900
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgAXOUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:20:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404345AbgAXOUB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:20:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B89F222D9;
        Fri, 24 Jan 2020 14:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875601;
        bh=6J0/GOKN5YQoNJVfktllwsQTAUpa12zICp72WrsWBdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qInIpqUUNvHTjH4hAwuY3rvUWkhm4bxb0gbluN2SGRoA0IcKD7H08DHAGiJsKGoGk
         mOOc5Zv7AbUHv2VvIbQDgA+JjZPJ3inUi5I/fn6kIblgw54vucs+pfWXQAT8G7ja36
         I8Hvckc5/InNbQaNiK0REkD4GHN95gN34DvIfRig=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 089/107] net: ethernet: ave: Avoid lockdep warning
Date:   Fri, 24 Jan 2020 09:17:59 -0500
Message-Id: <20200124141817.28793-89-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 82d5d6a638cbd12b7dfe8acafd9efd87a656cc06 ]

When building with PROVE_LOCKING=y, lockdep shows the following
dump message.

    INFO: trying to register non-static key.
    the code is fine but needs lockdep annotation.
    turning off the locking correctness validator.
     ...

Calling device_set_wakeup_enable() directly occurs this issue,
and it isn't necessary for initialization, so this patch creates
internal function __ave_ethtool_set_wol() and replaces with this
in ave_init() and ave_resume().

Fixes: 7200f2e3c9e2 ("net: ethernet: ave: Set initial wol state to disabled")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/socionext/sni_ave.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index 6e984d5a729fe..38d39c4b5ac83 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -424,16 +424,22 @@ static void ave_ethtool_get_wol(struct net_device *ndev,
 		phy_ethtool_get_wol(ndev->phydev, wol);
 }
 
-static int ave_ethtool_set_wol(struct net_device *ndev,
-			       struct ethtool_wolinfo *wol)
+static int __ave_ethtool_set_wol(struct net_device *ndev,
+				 struct ethtool_wolinfo *wol)
 {
-	int ret;
-
 	if (!ndev->phydev ||
 	    (wol->wolopts & (WAKE_ARP | WAKE_MAGICSECURE)))
 		return -EOPNOTSUPP;
 
-	ret = phy_ethtool_set_wol(ndev->phydev, wol);
+	return phy_ethtool_set_wol(ndev->phydev, wol);
+}
+
+static int ave_ethtool_set_wol(struct net_device *ndev,
+			       struct ethtool_wolinfo *wol)
+{
+	int ret;
+
+	ret = __ave_ethtool_set_wol(ndev, wol);
 	if (!ret)
 		device_set_wakeup_enable(&ndev->dev, !!wol->wolopts);
 
@@ -1216,7 +1222,7 @@ static int ave_init(struct net_device *ndev)
 
 	/* set wol initial state disabled */
 	wol.wolopts = 0;
-	ave_ethtool_set_wol(ndev, &wol);
+	__ave_ethtool_set_wol(ndev, &wol);
 
 	if (!phy_interface_is_rgmii(phydev))
 		phy_set_max_speed(phydev, SPEED_100);
@@ -1768,7 +1774,7 @@ static int ave_resume(struct device *dev)
 
 	ave_ethtool_get_wol(ndev, &wol);
 	wol.wolopts = priv->wolopts;
-	ave_ethtool_set_wol(ndev, &wol);
+	__ave_ethtool_set_wol(ndev, &wol);
 
 	if (ndev->phydev) {
 		ret = phy_resume(ndev->phydev);
-- 
2.20.1

