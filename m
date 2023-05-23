Return-Path: <netdev+bounces-4643-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F35D70DA88
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:29:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF5411C20D4D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:29:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9847A1F187;
	Tue, 23 May 2023 10:28:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849FC1E53D
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:28:37 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1D9186
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=wpzDxGFtOwVLolmb6TB31ZWWQz60u0sCm09L9jCR6Jo=; b=L1z6hiJ6QgndPCITTzoDFX4o4j
	/mPXsdftVahZ/XbOt8txsisY8mR+xuwsxGZybDZ/h0d4vXpx2wr63G1ijdh49Ip4vIX5kuIOYJvZD
	I5Q6Ngax+h8blu1nzOFKb+hz/ZNys0A8SM5SlrZmi8p/7qiImlI4BVHoHU0LobD+gKF648YQw0Q+O
	kDL8iiR9vlHKrdom2nPWxl6q7hwWqGaeAG537MgtxLyAFGO8Q66+8OXvcxtgyfb1BsxjDBNk7tXkB
	rsG0zrBnuLsByt0oAzlOvwq7y3j3UgVExH68DvdANfp2ebWTNOmK1UC42qEQl75V6cEEY55PiLQXl
	OvBwK0zQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52356 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q1P3U-000069-Nz; Tue, 23 May 2023 11:15:48 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q1P3U-007E8V-5D; Tue, 23 May 2023 11:15:48 +0100
In-Reply-To: <ZGyR/jDyYTYzRklg@shell.armlinux.org.uk>
References: <ZGyR/jDyYTYzRklg@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next 1/9] net: mdio: add clause 73 to ethtool conversion
 helper
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q1P3U-007E8V-5D@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Tue, 23 May 2023 11:15:48 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add a helper to convert a clause 73 advertisement to an ethtool bitmap.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 include/linux/mdio.h      | 39 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/mdio.h | 24 ++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 27013d6bf24a..0670cc6e067c 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -486,6 +486,45 @@ static inline u32 linkmode_adv_to_mii_10base_t1_t(unsigned long *adv)
 	return result;
 }
 
+/**
+ * mii_c73_mod_linkmode - convert a Clause 73 advertisement to linkmodes
+ * @adv: linkmode advertisement setting
+ * @lpa: array of three u16s containing the advertisement
+ *
+ * Convert an IEEE 802.3 Clause 73 advertisement to ethtool link modes.
+ */
+static inline void mii_c73_mod_linkmode(unsigned long *adv, u16 *lpa)
+{
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+			 adv, lpa[0] & MDIO_AN_C73_0_PAUSE);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			 adv, lpa[0] & MDIO_AN_C73_0_ASM_DIR);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+			 adv, lpa[1] & MDIO_AN_C73_1_1000BASE_KX);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+			 adv, lpa[1] & MDIO_AN_C73_1_10GBASE_KX4);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
+			 adv, lpa[1] & MDIO_AN_C73_1_40GBASE_KR4);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
+			 adv, lpa[1] & MDIO_AN_C73_1_40GBASE_CR4);
+	/* 100GBASE_CR10 and 100GBASE_KP4 not implemented */
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+			 adv, lpa[1] & MDIO_AN_C73_1_100GBASE_KR4);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+			 adv, lpa[1] & MDIO_AN_C73_1_100GBASE_CR4);
+	/* 25GBASE_R_S not implemented */
+	/* The 25GBASE_R bit can be used for 25Gbase KR or CR modes */
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+			 adv, lpa[1] & MDIO_AN_C73_1_25GBASE_R);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+			 adv, lpa[1] & MDIO_AN_C73_1_25GBASE_R);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+			 adv, lpa[1] & MDIO_AN_C73_1_10GBASE_KR);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
+			 adv, lpa[2] & MDIO_AN_C73_2_2500BASE_KX);
+	/* 5GBASE_KR not implemented */
+}
+
 int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum);
 int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val);
 int __mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index 256b463e47a6..b826598d1e94 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -231,6 +231,30 @@
 #define MDIO_PMA_EXTABLE_BT1		0x0800	/* BASE-T1 ability */
 #define MDIO_PMA_EXTABLE_NBT		0x4000  /* 2.5/5GBASE-T ability */
 
+/* AN Clause 73 linkword */
+#define MDIO_AN_C73_0_S_MASK		GENMASK(4, 0)
+#define MDIO_AN_C73_0_E_MASK		GENMASK(9, 5)
+#define MDIO_AN_C73_0_PAUSE		BIT(10)
+#define MDIO_AN_C73_0_ASM_DIR		BIT(11)
+#define MDIO_AN_C73_0_C2		BIT(12)
+#define MDIO_AN_C73_0_RF		BIT(13)
+#define MDIO_AN_C73_0_ACK		BIT(14)
+#define MDIO_AN_C73_0_NP		BIT(15)
+#define MDIO_AN_C73_1_T_MASK		GENMASK(4, 0)
+#define MDIO_AN_C73_1_1000BASE_KX	BIT(5)
+#define MDIO_AN_C73_1_10GBASE_KX4	BIT(6)
+#define MDIO_AN_C73_1_10GBASE_KR	BIT(7)
+#define MDIO_AN_C73_1_40GBASE_KR4	BIT(8)
+#define MDIO_AN_C73_1_40GBASE_CR4	BIT(9)
+#define MDIO_AN_C73_1_100GBASE_CR10	BIT(10)
+#define MDIO_AN_C73_1_100GBASE_KP4	BIT(11)
+#define MDIO_AN_C73_1_100GBASE_KR4	BIT(12)
+#define MDIO_AN_C73_1_100GBASE_CR4	BIT(13)
+#define MDIO_AN_C73_1_25GBASE_R_S	BIT(14)
+#define MDIO_AN_C73_1_25GBASE_R		BIT(15)
+#define MDIO_AN_C73_2_2500BASE_KX	BIT(0)
+#define MDIO_AN_C73_2_5GBASE_KR		BIT(1)
+
 /* PHY XGXS lane state register. */
 #define MDIO_PHYXS_LNSTAT_SYNC0		0x0001
 #define MDIO_PHYXS_LNSTAT_SYNC1		0x0002
-- 
2.30.2


