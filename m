Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F519340090
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 09:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhCRICb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 04:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhCRIB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 04:01:57 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FB4C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 01:01:57 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 75so3089843lfa.2
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 01:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5ftvg1446N8FMgxYGi171PMe6mdbxrq7Bt/9DXl/ndE=;
        b=LULvgsyhKFJoStcgY3MGoLrZmzt1k4hyGiRZCh/P15M9sKf26+adCCNCpYxMDbp2Dp
         P3uZNelepyNbwrpcBBCnE3RSpLEQprMH102R37NKJn7Vaj/ys6wuR9n8ZfhHfOqIX3LQ
         LHJOscFDaZV6rjDFb2sdqN5sqm4rPs2cWUFgLu/BkFpipc7PFiSgWoh368L0A5yX0wUs
         iLQgpTImIfmo6K+Etsl8EBg44sdiw4s8WxsgczrBDPuXOYl+RDYAFGIm6i6N3xWEx/9h
         YxdwMeFu9lQwTblPTMlbvrperiu3fnUvgwgDqyXATgeAXJKBa+s9q1RH5aenFs9AnWLf
         p5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5ftvg1446N8FMgxYGi171PMe6mdbxrq7Bt/9DXl/ndE=;
        b=gXN0d/nlOipSwDlVCQKfA9RzhAquSBJKNxlMI280UN5krNwHAVwV4yG9FMpxIn8u3S
         z8I4yb49SJ11NlavN/QXlEU7VIPyY9VGmjNFYdbCHRFOjX6jb2nzRRZb0Igl7p7tXnQJ
         yYM2luo0swIV+E9s4nd553ThKa0IIwfhqGPeqrTHpmyQYlETGATqzLhkTm6c+zKLxoDU
         yCSoadkm6eUJY7LYzYZwnCdKZ+YX3Sr3Fxz9/MGlYnpPhyr28rBofzOkclOccEPNJmjK
         Xle1YUlR5KECSy6C2D3k5bGwB6lHvYMNKDOfS15o2TlzJOTAQz3t86o47NfCrStO0NdB
         NxEA==
X-Gm-Message-State: AOAM5321FuRrm9+OHZG/wy5uBtpx5RKwX69lhT+RyhY4JOxVvUp9YbAC
        zIowJTT5GLmv2uOGlBcwx/k=
X-Google-Smtp-Source: ABdhPJzu85eT1QxBxcICRRG7gm0Lzxztg44nxBDnMDfHtpU7e/glYwm9aMZzBXbwrkRJGIl803Ipzg==
X-Received: by 2002:a19:7403:: with SMTP id v3mr4559759lfe.379.1616054515645;
        Thu, 18 Mar 2021 01:01:55 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id m19sm142717ljb.10.2021.03.18.01.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 01:01:55 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next V2 1/2] net: dsa: bcm_sf2: add function finding RGMII register
Date:   Thu, 18 Mar 2021 09:01:42 +0100
Message-Id: <20210318080143.32449-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Simple macro like REG_RGMII_CNTRL_P() is insufficient as:
1. It doesn't validate port argument
2. It doesn't support chipsets with non-lineral RGMII regs layout

Missing port validation could result in getting register offset from out
of array. Random memory -> random offset -> random reads/writes. It
affected e.g. BCM4908 for REG_RGMII_CNTRL_P(7).

Fixes: a78e86ed586d ("net: dsa: bcm_sf2: Prepare for different register layouts")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/dsa/bcm_sf2.c      | 49 +++++++++++++++++++++++++++++-----
 drivers/net/dsa/bcm_sf2_regs.h |  2 --
 2 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 3708cd8d7be8..4261a06ad050 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -32,6 +32,31 @@
 #include "b53/b53_priv.h"
 #include "b53/b53_regs.h"
 
+static u16 bcm_sf2_reg_rgmii_cntrl(struct bcm_sf2_priv *priv, int port)
+{
+	switch (priv->type) {
+	case BCM4908_DEVICE_ID:
+		/* TODO */
+		break;
+	default:
+		switch (port) {
+		case 0:
+			return REG_RGMII_0_CNTRL;
+		case 1:
+			return REG_RGMII_1_CNTRL;
+		case 2:
+			return REG_RGMII_2_CNTRL;
+		default:
+			break;
+		}
+	}
+
+	WARN_ONCE(1, "Unsupported port %d\n", port);
+
+	/* RO fallback reg */
+	return REG_SWITCH_STATUS;
+}
+
 /* Return the number of active ports, not counting the IMP (CPU) port */
 static unsigned int bcm_sf2_num_active_ports(struct dsa_switch *ds)
 {
@@ -693,6 +718,7 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	u32 id_mode_dis = 0, port_mode;
+	u32 reg_rgmii_ctrl;
 	u32 reg;
 
 	if (port == core_readl(priv, CORE_IMP0_PRT_ID))
@@ -716,10 +742,12 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 		return;
 	}
 
+	reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
+
 	/* Clear id_mode_dis bit, and the existing port mode, let
 	 * RGMII_MODE_EN bet set by mac_link_{up,down}
 	 */
-	reg = reg_readl(priv, REG_RGMII_CNTRL_P(port));
+	reg = reg_readl(priv, reg_rgmii_ctrl);
 	reg &= ~ID_MODE_DIS;
 	reg &= ~(PORT_MODE_MASK << PORT_MODE_SHIFT);
 
@@ -727,13 +755,14 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 	if (id_mode_dis)
 		reg |= ID_MODE_DIS;
 
-	reg_writel(priv, reg, REG_RGMII_CNTRL_P(port));
+	reg_writel(priv, reg, reg_rgmii_ctrl);
 }
 
 static void bcm_sf2_sw_mac_link_set(struct dsa_switch *ds, int port,
 				    phy_interface_t interface, bool link)
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
+	u32 reg_rgmii_ctrl;
 	u32 reg;
 
 	if (!phy_interface_mode_is_rgmii(interface) &&
@@ -741,13 +770,15 @@ static void bcm_sf2_sw_mac_link_set(struct dsa_switch *ds, int port,
 	    interface != PHY_INTERFACE_MODE_REVMII)
 		return;
 
+	reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
+
 	/* If the link is down, just disable the interface to conserve power */
-	reg = reg_readl(priv, REG_RGMII_CNTRL_P(port));
+	reg = reg_readl(priv, reg_rgmii_ctrl);
 	if (link)
 		reg |= RGMII_MODE_EN;
 	else
 		reg &= ~RGMII_MODE_EN;
-	reg_writel(priv, reg, REG_RGMII_CNTRL_P(port));
+	reg_writel(priv, reg, reg_rgmii_ctrl);
 }
 
 static void bcm_sf2_sw_mac_link_down(struct dsa_switch *ds, int port,
@@ -781,11 +812,15 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	struct ethtool_eee *p = &priv->dev->ports[port].eee;
-	u32 reg, offset;
 
 	bcm_sf2_sw_mac_link_set(ds, port, interface, true);
 
 	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
+		u32 reg_rgmii_ctrl;
+		u32 reg, offset;
+
+		reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
+
 		if (priv->type == BCM4908_DEVICE_ID ||
 		    priv->type == BCM7445_DEVICE_ID)
 			offset = CORE_STS_OVERRIDE_GMIIP_PORT(port);
@@ -796,7 +831,7 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 		    interface == PHY_INTERFACE_MODE_RGMII_TXID ||
 		    interface == PHY_INTERFACE_MODE_MII ||
 		    interface == PHY_INTERFACE_MODE_REVMII) {
-			reg = reg_readl(priv, REG_RGMII_CNTRL_P(port));
+			reg = reg_readl(priv, reg_rgmii_ctrl);
 			reg &= ~(RX_PAUSE_EN | TX_PAUSE_EN);
 
 			if (tx_pause)
@@ -804,7 +839,7 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 			if (rx_pause)
 				reg |= RX_PAUSE_EN;
 
-			reg_writel(priv, reg, REG_RGMII_CNTRL_P(port));
+			reg_writel(priv, reg, reg_rgmii_ctrl);
 		}
 
 		reg = SW_OVERRIDE | LINK_STS;
diff --git a/drivers/net/dsa/bcm_sf2_regs.h b/drivers/net/dsa/bcm_sf2_regs.h
index e297b09411f3..3d5515fe43cb 100644
--- a/drivers/net/dsa/bcm_sf2_regs.h
+++ b/drivers/net/dsa/bcm_sf2_regs.h
@@ -55,8 +55,6 @@ enum bcm_sf2_reg_offs {
 #define CROSSBAR_BCM4908_EXT_GPHY4	1
 #define CROSSBAR_BCM4908_EXT_RGMII	2
 
-#define REG_RGMII_CNTRL_P(x)		(REG_RGMII_0_CNTRL + (x))
-
 /* Relative to REG_RGMII_CNTRL */
 #define  RGMII_MODE_EN			(1 << 0)
 #define  ID_MODE_DIS			(1 << 1)
-- 
2.26.2

