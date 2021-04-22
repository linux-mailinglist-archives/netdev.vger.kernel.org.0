Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B195367E01
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 11:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235848AbhDVJo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 05:44:29 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:23815 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235831AbhDVJoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 05:44:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1619084621; x=1650620621;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ehSGyX+Ga6l2AWeQjA+Xf0MRfAPcLht8qG9mbmCJcUs=;
  b=QHGDQ2ZpMi5LzMRudr01kJboJnqXFPrdAU9JRtkqyKibn6H9OMnXbRCC
   ZeQCS6MlWMVKGMdDIeJcYU01ECFg+S5HLHYqpcYfnapq/5gfzY0iOPPjX
   MpdQyKIdXG9P+DaqmBw8Tamg/Tmagfd+sZdmrNyZuZpDlT9iyJKoXOiOP
   zgW7UwPwNMTayv0fGpTp8GC/9GujMSAnIE3/uqTX09KDMgrbKF/f4Lqs0
   wqHUd+Ad9AIVgFuT2ew/Z0HP+GY496SeoPxKzdbq2uJK3q9NGZAP854Jz
   FW31UdtmcxMFXuztyysObVGNHxkV/RW6oUJa+H+PIahKnFcBb2SQ1mtnH
   g==;
IronPort-SDR: W/EXwLyvX6/QYhRT4fUr7HWTFBLJSdS+R1+yb0LbWSenjgYR1xAQxGc2d2MkAOmSyMyCTPwX1d
 67eG+SKZEyTZAGur9cycJX1FuLZ+13CQXjwDIxF6xcQXgKNyMg8Qi/M1YkAyyJjRSBBRo1wL0T
 HlCOOCPTKaBFkcvZfcoZDAnXZgMcylxykXEP/ciBmlTz2d9TwesoZeGTaS7FX7/D6oPRK71h9h
 67HMpMkR/QF//OMIUqlf0c4BzFk1d4M63aCuO8Ac13w8ACxVN5SFvKZWDJktMEGUpDgBlNxoPU
 GWk=
X-IronPort-AV: E=Sophos;i="5.82,242,1613458800"; 
   d="scan'208";a="111784908"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Apr 2021 02:43:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 02:43:41 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Thu, 22 Apr 2021 02:43:34 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v2 net-next 5/9] net: dsa: microchip: add support for phylink management
Date:   Thu, 22 Apr 2021 15:12:53 +0530
Message-ID: <20210422094257.1641396-6-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for phylink_validate() and reused KSZ commmon API for
phylink_mac_link_down() operation

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 42 ++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 944c6f4d6d60..93c392081423 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -312,6 +312,46 @@ static int lan937x_get_max_mtu(struct dsa_switch *ds, int port)
 	return FR_MAX_SIZE;
 }
 
+static void lan937x_phylink_validate(struct dsa_switch *ds, int port,
+				     unsigned long *supported,
+			  struct phylink_link_state *state)
+{
+	struct ksz_device *dev = ds->priv;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	if (phy_interface_mode_is_rgmii(state->interface) ||
+	    state->interface == PHY_INTERFACE_MODE_SGMII ||
+		state->interface == PHY_INTERFACE_MODE_RMII ||
+		state->interface == PHY_INTERFACE_MODE_MII ||
+		lan937x_is_internal_100BTX_phy_port(dev, port)) {
+		phylink_set(mask, 10baseT_Half);
+		phylink_set(mask, 10baseT_Full);
+		phylink_set(mask, 100baseT_Half);
+		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, Autoneg);
+		phylink_set_port_modes(mask);
+		phylink_set(mask, Pause);
+		phylink_set(mask, Asym_Pause);
+	}
+
+	/*  For RGMII & SGMII interfaces */
+	if (phy_interface_mode_is_rgmii(state->interface) ||
+	    state->interface == PHY_INTERFACE_MODE_SGMII) {
+		phylink_set(mask, 1000baseT_Full);
+	}
+
+	/* For T1 PHY */
+	if (lan937x_is_internal_t1_phy_port(dev, port)) {
+		phylink_set(mask, 100baseT1_Full);
+		phylink_set_port_modes(mask);
+	}
+
+	bitmap_and(supported, supported, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
 static int	lan937x_port_pre_bridge_flags(struct dsa_switch *ds, int port,
 					      struct switchdev_brport_flags flags,
 					 struct netlink_ext_ack *extack)
@@ -340,6 +380,8 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.port_fast_age		= ksz_port_fast_age,
 	.port_max_mtu		= lan937x_get_max_mtu,
 	.port_change_mtu	= lan937x_change_mtu,
+	.phylink_validate	= lan937x_phylink_validate,
+	.phylink_mac_link_down	= ksz_mac_link_down,
 };
 
 int lan937x_switch_register(struct ksz_device *dev)
-- 
2.27.0

