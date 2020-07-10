Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAFF21B565
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 14:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgGJMri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 08:47:38 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:50138 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbgGJMrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 08:47:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594385257; x=1625921257;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zvVFXVg26gKJue+5xGIofrm/3BbbDksLZVvakopyGEQ=;
  b=hppezngz0Stb8tiFsXsQo1wc/UNoK1GeZlVkIlRZq1Nr1MNnZz4GaAU7
   g9QhmgXc0YgZrkfh1ttgi4LawCX6g2Rf+qcKzFhI7BFtqmE4cw/bXFI3y
   QKYRxxl0dniVV8rvy6WxIczbcoOy5Fuq39dkm8ITcRQXRSt7qnrJeVGXU
   38k7mEDPfhs3jBk6g0rwwTVHhhBr1ggwVVYd2nopsaw1XevH0Om/DUn4A
   bijlhKc8Wiv7BsVLURYfmq8uEs7vEyRKh8SfFpysYfgOrMreJ+Mwl6guW
   IeSKe/UvMl89Smh9dazAEgphaLspL0FT2/riuxgow8dMUQofaYcEw8jvH
   A==;
IronPort-SDR: NplFPck3JUElnTy7fY7g5mvxsN7nFfXmDdWETcEKVZfYIdeQZotJt85eSxGX4KpCNzRoUcYCq/
 RW0GoOduYim8yskSCvoOcJLTgHrPyuciSHDoTYa/FasuBZnmIaKdiiS8nE76VlocbVqhULifY5
 rDBM9ExDSlR/3E7CjFUeJzbwalEImzFQQzoQdD0hUSI24qFkZvJ6ziWGGGDfVeB17DJ5Zt6d5O
 k/oXJ2ktWyBcaWMzNkFrfSbEz3+nCzwLNYiXJho2gi8R0nxqJNOOTY0mL6Jt4XmWnWLga7Dcng
 RX0=
X-IronPort-AV: E=Sophos;i="5.75,335,1589266800"; 
   d="scan'208";a="82588083"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Jul 2020 05:47:37 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 10 Jul 2020 05:47:35 -0700
Received: from ness.mchp-main.com (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 10 Jul 2020 05:47:32 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux@armlinux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <netdev@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>, <f.fainelli@gmail.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH v5 4/5] net: macb: fix macb_suspend() by removing call to netif_carrier_off()
Date:   Fri, 10 Jul 2020 14:46:44 +0200
Message-ID: <a7eb7eb11da8b4e4326d86e30e4110872ac987c6.1594384335.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1594384335.git.nicolas.ferre@microchip.com>
References: <cover.1594384335.git.nicolas.ferre@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

As we now use the phylink call to phylink_stop() in the non-WoL path,
there is no need for this call to netif_carrier_off() anymore. It can
disturb the underlying phylink FSM.

Fixes: 7897b071ac3b ("net: macb: convert to phylink")
Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Harini Katakam <harini.katakam@xilinx.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
Changes in v2:
- new in v2 serries

 drivers/net/ethernet/cadence/macb_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 79c2fe054303..548815255e22 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4604,7 +4604,6 @@ static int __maybe_unused macb_suspend(struct device *dev)
 			bp->pm_data.scrt2 = gem_readl_n(bp, ETHT, SCRT2_ETHT);
 	}
 
-	netif_carrier_off(netdev);
 	if (bp->ptp_info)
 		bp->ptp_info->ptp_remove(netdev);
 	pm_runtime_force_suspend(dev);
-- 
2.27.0

