Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0476A256F89
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 19:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgH3Rew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 13:34:52 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:37150 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgH3Rev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 13:34:51 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07UHYeVE048007;
        Sun, 30 Aug 2020 12:34:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598808881;
        bh=tZK2TP+2t+mV0g/68G8cvz0ZN9xuJYPJklBKZRz98cU=;
        h=From:To:CC:Subject:Date;
        b=jUPKGZ54DdcDx3hI7okuktTei1TwUue4GK/7Mj/FKzzMs8OWK4aVAD9E44didGBob
         +qKOxpq2Zq3+5sQ59GxFcM8EXLfkxVodjUzspSGJHZX6ojYdqEl5Z5STnX0PeBlLKl
         VZ7kQO/k53avLuxRHJT1H3r0VmUcogLlTRn0BChA=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07UHYew0111224;
        Sun, 30 Aug 2020 12:34:40 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Sun, 30
 Aug 2020 12:34:40 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Sun, 30 Aug 2020 12:34:40 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07UHYdDD109498;
        Sun, 30 Aug 2020 12:34:40 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] net: ethernet: ti: am65-cpsw: fix rmii 100Mbit link mode
Date:   Sun, 30 Aug 2020 20:34:32 +0300
Message-ID: <20200830173432.14960-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In RMII link mode it's required to set bit 15 IFCTL_A in MAC_SL MAC_CONTROL
register to enable support for 100Mbit link speed.

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index cb994f66c3be..9baf3f3da91e 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -174,6 +174,8 @@ void am65_cpsw_nuss_adjust_link(struct net_device *ndev)
 		if (phy->speed == 10 && phy_interface_is_rgmii(phy))
 			/* Can be used with in band mode only */
 			mac_control |= CPSW_SL_CTL_EXT_EN;
+		if (phy->speed == 100 && phy->interface == PHY_INTERFACE_MODE_RMII)
+			mac_control |= CPSW_SL_CTL_IFCTL_A;
 		if (phy->duplex)
 			mac_control |= CPSW_SL_CTL_FULLDUPLEX;
 
-- 
2.17.1

