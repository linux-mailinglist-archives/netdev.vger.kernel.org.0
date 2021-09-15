Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E41240BFCD
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 08:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236549AbhIOGtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 02:49:06 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:36058 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236489AbhIOGtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 02:49:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631688462; x=1663224462;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e6GO9tw2z7CzWA7UGiw1OwSYdNRLkOqWBkkYRcdq7/U=;
  b=aOY6FsOltTlHEnaol8bcSDFjEcv3zqfUfCbVp2iY19urKpOeGb5bsKkg
   vaXaTZ9SItBESMtPdW63Bg+c/GOBJnhuXMMg1jQ43dKywi5hTr+By7qfV
   jC5PgUHiLMU3Q+syK8IXbXnzg4UnSYbMVT3Nq2gVgU7sSO1C/LCtBxz/C
   Mcf1vOHGpTf/yMa3MyncI3n3ol0tJ9W7jsWdRXhF9P6/ZgUgNgsxI+ifr
   nW1IDz02s4yqQERH1tyT8oSQw1VItk10dq3YoWSlt8pR+fAUpfgbxRs0J
   Cr0l1dgi+kHhi54lzs4cgcQ2qsCP6u6Q26J1IvwwMw/GV6mEqDWxXdpfz
   g==;
IronPort-SDR: AbYa88Q7a65AAIOAJMJjbXX1O8YBJkSftj7Ppgs28Fn7WD7zqIamBNEdYQUiMEjqYEMeyv7Rv/
 pYQoL2BuNO7C2VBEF09Y7C33VYcCc9R1tx33u/b2NSKriG3Q8rJcB6l2UEYl5dmDC301JkSgSy
 1YbvZclDtzM/NFAQ8+7jW1XRiHdcqj0iY02Mv3HF3MZ4zCv/sD6v8/kr02yp4XazAknBgsBuhj
 c/lCipv0lGlOqmU5z5tpmcUptlDnQ4GzhD1Mft1NaPCR2H/szPRtnE+lXXoUfUGADC1s1Y3Ck+
 IkQyXeUidlQnf1AogiZO2KAE
X-IronPort-AV: E=Sophos;i="5.85,294,1624345200"; 
   d="scan'208";a="136592256"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Sep 2021 23:47:31 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 14 Sep 2021 23:47:30 -0700
Received: from rob-dk-mpu01.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 14 Sep 2021 23:47:29 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 3/3] net: macb: add support for mii on rgmii
Date:   Wed, 15 Sep 2021 09:47:21 +0300
Message-ID: <20210915064721.5530-4-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210915064721.5530-1-claudiu.beznea@microchip.com>
References: <20210915064721.5530-1-claudiu.beznea@microchip.com>
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

