Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A77C20B7F5
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgFZSRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:17:54 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:59804 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbgFZSRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:17:32 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05QIHKUt115360;
        Fri, 26 Jun 2020 13:17:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593195440;
        bh=X1AdtspTztF0AsbIA9EqIyCbI1qi1qSf0aeaX1Wq600=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=pS7nzfvFqyrvwmju07m7Oyd6+zceLwR27lZTCbufbUafLxM0dL4B2Jcnb8dNP9wWG
         n/sWEragj6VJKengnFOMcmB+jPIYsGPJyJ/wyLvQx4Z3gnz4G+XAXwWfpcVM8PpNVD
         f+a5Og74LwjBQ5c+BYbfe/2fQH95ZzXzEt+AyBsY=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05QIHJba008680
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 26 Jun 2020 13:17:20 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 26
 Jun 2020 13:17:19 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 26 Jun 2020 13:17:19 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05QIHIXH122959;
        Fri, 26 Jun 2020 13:17:19 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 5/6] net: ethernet: ti: am65-cpsw-ethtool: configured critical setting only when no running netdevs
Date:   Fri, 26 Jun 2020 21:17:08 +0300
Message-ID: <20200626181709.22635-6-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200626181709.22635-1-grygorii.strashko@ti.com>
References: <20200626181709.22635-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that critical setting can only be configured when there are no
running netdevs - all ports are down.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
index f7b33875a385..496dafb25128 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
@@ -445,7 +445,7 @@ static int am65_cpsw_set_channels(struct net_device *ndev,
 	/* Check if interface is up. Can change the num queues when
 	 * the interface is down.
 	 */
-	if (netif_running(ndev))
+	if (common->usage_count)
 		return -EBUSY;
 
 	am65_cpsw_nuss_remove_tx_chns(common);
@@ -734,6 +734,9 @@ static int am65_cpsw_set_ethtool_priv_flags(struct net_device *ndev, u32 flags)
 
 	rrobin = !!(flags & AM65_CPSW_PRIV_P0_RX_PTYPE_RROBIN);
 
+	if (common->usage_count)
+		return -EBUSY;
+
 	if (common->est_enabled && rrobin) {
 		netdev_err(ndev,
 			   "p0-rx-ptype-rrobin flag conflicts with QOS\n");
-- 
2.17.1

