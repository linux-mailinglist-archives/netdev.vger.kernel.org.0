Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23581C79FA
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 21:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgEFTLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 15:11:43 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:46830 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgEFTLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 15:11:42 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046JBWCq025897;
        Wed, 6 May 2020 14:11:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588792292;
        bh=/5vVUDy+xDJuPs/2JxsnxOLycj/Z7dCmyZc/fbS7E5A=;
        h=From:To:CC:Subject:Date;
        b=Ozb27oNdIVpSyyI8nJ+Agefj78mGAwD22/LLTPz0eLhSl9XJKqjmeFpTASqKhg/oC
         eCKWz0m4wS8MYc8+XYwH5Uo8d6cWwULN5CWT6TFauSU3Vfr701Y6pv1MRswxJxs46Q
         i1YvyIDtruSxg9Ksh8qL0lgrobyC+ea1JY0euiJ4=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 046JBWRZ011813
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 May 2020 14:11:32 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 14:11:32 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 14:11:32 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046JBV2x038119;
        Wed, 6 May 2020 14:11:32 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH next] ARM: dts: am57xx: fix networking on boards with ksz9031 phy
Date:   Wed, 6 May 2020 22:11:24 +0300
Message-ID: <20200506191124.31569-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the
KSZ9031 PHY") the networking is broken on boards:
 am571x-idk
 am572x-idk
 am574x-idk
 am57xx-beagle-x15

All above boards have phy-mode = "rgmii" and this is worked before because
KSZ9031 PHY started with default RGMII internal delays configuration (TX
off, RX on 1.2 ns) and MAC provided TX delay. After above commit, the
KSZ9031 PHY starts handling phy mode properly and disables RX delay, as
result networking is become broken.

Fix it by switching to phy-mode = "rgmii-rxid" to reflect previous
behavior.

Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Philippe Schenker <philippe.schenker@toradex.com>
Fixes: commit bcf3440c6dd7 ("net: phy: micrel: add phy-mode support for the KSZ9031 PHY")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm/boot/dts/am571x-idk.dts                | 4 ++--
 arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi | 4 ++--
 arch/arm/boot/dts/am57xx-idk-common.dtsi        | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/am571x-idk.dts b/arch/arm/boot/dts/am571x-idk.dts
index 669559c9c95b..c13756fa0f55 100644
--- a/arch/arm/boot/dts/am571x-idk.dts
+++ b/arch/arm/boot/dts/am571x-idk.dts
@@ -190,13 +190,13 @@
 
 &cpsw_port1 {
 	phy-handle = <&ethphy0_sw>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-rxid";
 	ti,dual-emac-pvid = <1>;
 };
 
 &cpsw_port2 {
 	phy-handle = <&ethphy1_sw>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-rxid";
 	ti,dual-emac-pvid = <2>;
 };
 
diff --git a/arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi b/arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi
index a813a0cf3ff3..565675354de4 100644
--- a/arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi
+++ b/arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi
@@ -433,13 +433,13 @@
 
 &cpsw_emac0 {
 	phy-handle = <&phy0>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-rxid";
 	dual_emac_res_vlan = <1>;
 };
 
 &cpsw_emac1 {
 	phy-handle = <&phy1>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-rxid";
 	dual_emac_res_vlan = <2>;
 };
 
diff --git a/arch/arm/boot/dts/am57xx-idk-common.dtsi b/arch/arm/boot/dts/am57xx-idk-common.dtsi
index aa5e55f98179..a3ff1237d1fa 100644
--- a/arch/arm/boot/dts/am57xx-idk-common.dtsi
+++ b/arch/arm/boot/dts/am57xx-idk-common.dtsi
@@ -408,13 +408,13 @@
 
 &cpsw_emac0 {
 	phy-handle = <&ethphy0>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-rxid";
 	dual_emac_res_vlan = <1>;
 };
 
 &cpsw_emac1 {
 	phy-handle = <&ethphy1>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-rxid";
 	dual_emac_res_vlan = <2>;
 };
 
-- 
2.17.1

