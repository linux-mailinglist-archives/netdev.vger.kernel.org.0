Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21DA40F915
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244786AbhIQN16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:27:58 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:35300 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241298AbhIQN1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 09:27:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631885184; x=1663421184;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PEhpboyKYhkZA63XA+bUNRdGy3auCyFQHbq/E5LZgck=;
  b=fAgORmlWDjY0EJNmbfSQk9VUKi9xY11El3HIG80Meam0N2rTNSwnW2gO
   /AKv86SZpzFw/0aMSvMLjiSnmWe1ER5nLoJ3D4gfxqoT1HjrYELH9/Ydz
   ro2DjzVrRXlo5Cnj//+q2oR5JG4fcHlvW2+o4nh3S28ceptW2Y37S+9vU
   MGUAY1MXDJr9C07Dc4IiNNVFLYP7UApJWMw6jM/m/dm31xctsuzLxtcXg
   GBHGuGKVsxLrwUogy9x0u5IsN0kd4zcbd8EqDsCI5fWI+7p0PnMV8paJM
   jS6EZqNSrKcMXYKHxz5+IAMEWvn+CJzAKHZY2i+lmxmkdOMaywyymePHa
   A==;
IronPort-SDR: +BEwzkOAvIJqQGE0yZaHrJTqVldx0kuIA0sCGDGnlnpsUstdKy1+W4xWAh4U/Bs1VrqTha9rhO
 vQxJilflgnyngS7MiEQCueM6YH+19/jsQMi3w3GlpOnM7rc42pSsECwJF2D7+XZqVlKxmUtUSg
 g0ZmtY5c3ymjf9+PW8lx6iRQcn/xE+6ZnHKISKOcEg4CLgX93fNBE9TsLu3WYttT87eK34ZWpw
 d0ABvMZbQTMKLWOqk+A82hmWIzXLg1F9vjq82341+NsHuAy58TxjexnK66+i6tPQ3bLqZCSPB9
 UXDUVKNHlMtnWuWD7kkowu4f
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="129681571"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Sep 2021 06:26:23 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 17 Sep 2021 06:26:23 -0700
Received: from rob-dk-mpu01.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 17 Sep 2021 06:26:22 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 3/4] net: macb: add support for mii on rgmii
Date:   Fri, 17 Sep 2021 16:26:14 +0300
Message-ID: <20210917132615.16183-4-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210917132615.16183-1-claudiu.beznea@microchip.com>
References: <20210917132615.16183-1-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cadence IP has option to enable MII support on RGMII interface. This
could be selected though bit 28 of network control register. This option
is not enabled on all the IP versions thus add a software capability to
be selected by the proper implementation of this IP.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
 drivers/net/ethernet/cadence/macb.h      | 3 +++
 drivers/net/ethernet/cadence/macb_main.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index c33e98bfa5e8..5620b97b3482 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -246,6 +246,8 @@
 #define MACB_SRTSM_OFFSET	15 /* Store Receive Timestamp to Memory */
 #define MACB_OSSMODE_OFFSET	24 /* Enable One Step Synchro Mode */
 #define MACB_OSSMODE_SIZE	1
+#define MACB_MIIONRGMII_OFFSET	28 /* MII Usage on RGMII Interface */
+#define MACB_MIIONRGMII_SIZE	1
 
 /* Bitfields in NCFGR */
 #define MACB_SPD_OFFSET		0 /* Speed */
@@ -713,6 +715,7 @@
 #define MACB_CAPS_GEM_HAS_PTP			0x00000040
 #define MACB_CAPS_BD_RD_PREFETCH		0x00000080
 #define MACB_CAPS_NEEDS_RSTONUBR		0x00000100
+#define MACB_CAPS_MIIONRGMII			0x00000200
 #define MACB_CAPS_CLK_HW_CHG			0x04000000
 #define MACB_CAPS_MACB_IS_EMAC			0x08000000
 #define MACB_CAPS_FIFO_MODE			0x10000000
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d13fb1d31821..cdf3e35b5b33 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -684,6 +684,9 @@ static void macb_mac_config(struct phylink_config *config, unsigned int mode,
 		} else if (state->interface == PHY_INTERFACE_MODE_10GBASER) {
 			ctrl |= GEM_BIT(PCSSEL);
 			ncr |= GEM_BIT(ENABLE_HS_MAC);
+		} else if (bp->caps & MACB_CAPS_MIIONRGMII &&
+			   bp->phy_interface == PHY_INTERFACE_MODE_MII) {
+			ncr |= MACB_BIT(MIIONRGMII);
 		}
 	}
 
-- 
2.25.1

