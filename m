Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 979D2642BCD
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 16:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbiLEPb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 10:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiLEPaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 10:30:52 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73A86332;
        Mon,  5 Dec 2022 07:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670254188; x=1701790188;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fr+m1IBK+OruzgQto/Ovdj+7udSquCWkwSxcuR1wIjY=;
  b=YDsCWzvswP5V+DGGBFz1N4qMY5ffRN1HL7odO1kHBHAlltNRRL5ytOVq
   vCDwusBPAHFnG8c7wVgGHbtBKakgVYZmkyWuzKtYZP2R6YP64s75teU1B
   j8lUcUUTeQDOnanL9mibIWjAVdle6K0DiQdnhDX5G1CMGmRb132R0Bzpg
   M2vvvENhJczdIKOWOhcEnEWWOstGLCYLc94LXY0SiGcRAYNarRRhT46x9
   1HXGaFxTmP3Al0RrtxxAUlJ3nI5BKm6hOvU/ZTmGC+0/VOh2GygSITulJ
   TwpyEQGMgJwrPm511qnoeXKzw2IUFMJzoi4wX7tw4OMHbSHGrIO2aARHC
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="126541656"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2022 08:29:37 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 5 Dec 2022 08:29:36 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 5 Dec 2022 08:29:34 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>, <hkallweit1@gmail.com>
CC:     <sergiu.moga@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 1/2] net: phylink: add helper to initialize phylink's phydev
Date:   Mon, 5 Dec 2022 17:33:27 +0200
Message-ID: <20221205153328.503576-2-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20221205153328.503576-1-claudiu.beznea@microchip.com>
References: <20221205153328.503576-1-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helper to initialize phydev embedded in a phylink object.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/phy/phylink.c | 10 ++++++++++
 include/linux/phylink.h   |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 09cc65c0da93..1e2478b8cd5f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2541,6 +2541,16 @@ int phylink_ethtool_set_eee(struct phylink *pl, struct ethtool_eee *eee)
 }
 EXPORT_SYMBOL_GPL(phylink_ethtool_set_eee);
 
+/**
+ * phylink_init_phydev() - initialize phydev associated to phylink
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ */
+int phylink_init_phydev(struct phylink *pl)
+{
+	return phy_init_hw(pl->phydev);
+}
+EXPORT_SYMBOL_GPL(phylink_init_phydev);
+
 /* This emulates MII registers for a fixed-mode phy operating as per the
  * passed in state. "aneg" defines if we report negotiation is possible.
  *
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index c492c26202b5..6a969aa75c7f 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -609,6 +609,7 @@ int phylink_ethtool_set_eee(struct phylink *, struct ethtool_eee *);
 int phylink_mii_ioctl(struct phylink *, struct ifreq *, int);
 int phylink_speed_down(struct phylink *pl, bool sync);
 int phylink_speed_up(struct phylink *pl);
+int phylink_init_phydev(struct phylink *pl);
 
 #define phylink_zero(bm) \
 	bitmap_zero(bm, __ETHTOOL_LINK_MODE_MASK_NBITS)
-- 
2.34.1

