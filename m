Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9191B2414
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 12:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgDUKmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 06:42:04 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:32672 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728510AbgDUKmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 06:42:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587465722; x=1619001722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vzlw1G5Ee347qgrm5+cdRwJvE93MjjUjImWalReU+Fg=;
  b=dsHFSnOAcFEVBoT5dU9N428WeFaCWTecbblzAcM2vvUH6K1IAJj1s8bz
   hJSTZUBjWIL6UJEhMWdAEECFL37fHC1c1TnMyR7MQpZQ6yGpUut7xafsV
   UesD2VP+Zh5Y/MQhHnQPjJzbk720b0S2kIrgwaN6a2wnWNnpiras7MJE9
   ytewZKXzGBysmUTQQsp7ZqMBLQZTOxXVXtxDJkGP5ncBmd/nMJjUKx4ts
   Xb622WUfrD0ZFrcKOaYvxdJrTWw7eh+vNDlbScLks3Q3MXeGVIfv4k1bx
   jZ/Iv8YQuF65CxfeU8QLeCIcocMGz/rZmEYA+mOG2ss4A2KiT18GedLOC
   A==;
IronPort-SDR: o8KUXHko2mnUGDDidQNOKWvT8xtAPU/I8R5ninw7kikWHgaFuZ6gaQSEIV0ez/dFXbn17RHSb3
 ZzUr2tYi5FLJxBMOofT4xyIsEFlrYXaPEDfXCBemMVn8rkE4ItQLXx8RB40jj2KbOfzrRc8D72
 7mThJWBjEd4Fxq2FG+nkGYXHSL29AFWm4a/KVRkMFYIx3gft3KsZmhK41d8lv3uhY8B/xQ/i4w
 likLRSHXsLrZ1r2sxPul9JXmVGdK+NRxoHdS9yc/EJkpPjjVOHX3I+uwVJxc6LZjy2Fx8bLo06
 9M8=
X-IronPort-AV: E=Sophos;i="5.72,410,1580799600"; 
   d="scan'208";a="71017521"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Apr 2020 03:41:46 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 21 Apr 2020 03:41:45 -0700
Received: from ness.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 21 Apr 2020 03:41:44 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <sergio.prado@e-labworks.com>, <antoine.tenart@bootlin.com>,
        <f.fainelli@gmail.com>, <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <michal.simek@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH v2 4/7] net: macb: fix macb_suspend() by removing call to netif_carrier_off()
Date:   Tue, 21 Apr 2020 12:41:01 +0200
Message-ID: <da134cb7ffbdfcad1f8e7f2348b66c31f3a35680.1587463802.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1587463802.git.nicolas.ferre@microchip.com>
References: <cover.1587463802.git.nicolas.ferre@microchip.com>
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
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
Changes in v2:
- new in v2 serries

 drivers/net/ethernet/cadence/macb_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index b17a33c60cd4..72b8983a763a 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4562,7 +4562,6 @@ static int __maybe_unused macb_suspend(struct device *dev)
 			bp->pm_data.scrt2 = gem_readl_n(bp, ETHT, SCRT2_ETHT);
 	}
 
-	netif_carrier_off(netdev);
 	if (bp->ptp_info)
 		bp->ptp_info->ptp_remove(netdev);
 	pm_runtime_force_suspend(dev);
-- 
2.20.1

