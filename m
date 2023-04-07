Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158D86DAF94
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbjDGPSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjDGPSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:18:33 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F8D2101
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 08:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Aef/cPEZRs70ps+UbYT9b+tcsbhl00kc6GDJgQn6C+I=; b=urus1nO8tsZix88f0TUfZPcrWH
        y8CuwVIjuHZM+F3NvKHQWZrp7E0f2Hwy+GTfsKzrxZz1O1JY0zyl+ixXPxIsnx+SZb7Je1LE4Vs4p
        cDsZk/OagmNmetw5gJqrk9oxfDkB6tqVRBwbLDSfph1SORWRaEOC/ROQ4pMHgh8E0PxI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pknrA-009jg3-8G; Fri, 07 Apr 2023 17:18:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gregory Clement <gregory.clement@bootlin.com>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 3/3] ARM: dts: armada: Add missing phy-mode and fixed links
Date:   Fri,  7 Apr 2023 17:17:22 +0200
Message-Id: <20230407151722.2320481-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230407151722.2320481-1-andrew@lunn.ch>
References: <20230407151722.2320481-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA framework has got more picky about always having a phy-mode
for the CPU port. The Armada Ethernet supports RGMII, SGMII,
1000base-x and 2500Base-X. Set the switch phy-mode based on how the
SoC Ethernet ports is been configured. For RGMII mode, have the switch
add the delays.

Additionally, the cpu label has never actually been used in the
binding, so remove it.

Lastly, add a fixed-link node indicating the expected speed/duplex of
the link to the SoC.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/boot/dts/armada-370-rd.dts               | 2 +-
 arch/arm/boot/dts/armada-381-netgear-gs110emx.dts | 2 +-
 arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dts  | 7 ++++++-
 arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dts  | 7 ++++++-
 arch/arm/boot/dts/armada-385-linksys.dtsi         | 2 +-
 arch/arm/boot/dts/armada-385-turris-omnia.dts     | 2 --
 arch/arm/boot/dts/armada-xp-linksys-mamba.dts     | 2 +-
 7 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/armada-370-rd.dts b/arch/arm/boot/dts/armada-370-rd.dts
index be005c9f42ef..2fce8e794265 100644
--- a/arch/arm/boot/dts/armada-370-rd.dts
+++ b/arch/arm/boot/dts/armada-370-rd.dts
@@ -171,8 +171,8 @@ port@3 {
 
 			port@5 {
 				reg = <5>;
-				label = "cpu";
 				ethernet = <&eth1>;
+				phy-mode = "rgmii-id";
 				fixed-link {
 					speed = <1000>;
 					full-duplex;
diff --git a/arch/arm/boot/dts/armada-381-netgear-gs110emx.dts b/arch/arm/boot/dts/armada-381-netgear-gs110emx.dts
index 095df5567c93..f4c4b213ef4e 100644
--- a/arch/arm/boot/dts/armada-381-netgear-gs110emx.dts
+++ b/arch/arm/boot/dts/armada-381-netgear-gs110emx.dts
@@ -148,7 +148,7 @@ ports {
 
 			port@0 {
 				ethernet = <&eth0>;
-				label = "cpu";
+				phy-mode = "rgmii";
 				reg = <0>;
 
 				fixed-link {
diff --git a/arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dts b/arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dts
index c9ac630e5874..1990f7d0cc79 100644
--- a/arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dts
+++ b/arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dts
@@ -68,8 +68,13 @@ port@8 {
 
 			port@10 {
 				reg = <10>;
-				label = "cpu";
+				phy-mode = "2500base-x";
+
 				ethernet = <&eth1>;
+				fixed-link {
+					speed = <2500>;
+					full-duplex;
+				};
 			};
 
 		};
diff --git a/arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dts b/arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dts
index fa653b379490..b795ad573891 100644
--- a/arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dts
+++ b/arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dts
@@ -48,8 +48,13 @@ port@4 {
 
 			port@5 {
 				reg = <5>;
-				label = "cpu";
+				phy-mode = "2500base-x";
 				ethernet = <&eth1>;
+
+				fixed-link {
+					speed = <2500>;
+					full-duplex;
+				};
 			};
 
 		};
diff --git a/arch/arm/boot/dts/armada-385-linksys.dtsi b/arch/arm/boot/dts/armada-385-linksys.dtsi
index 85e8d966f6c1..fc8216fd9f60 100644
--- a/arch/arm/boot/dts/armada-385-linksys.dtsi
+++ b/arch/arm/boot/dts/armada-385-linksys.dtsi
@@ -195,7 +195,7 @@ port@4 {
 
 			port@5 {
 				reg = <5>;
-				label = "cpu";
+				phy-mode = "sgmii";
 				ethernet = <&eth2>;
 
 				fixed-link {
diff --git a/arch/arm/boot/dts/armada-385-turris-omnia.dts b/arch/arm/boot/dts/armada-385-turris-omnia.dts
index 0c1f238e4c30..2d8d319bec83 100644
--- a/arch/arm/boot/dts/armada-385-turris-omnia.dts
+++ b/arch/arm/boot/dts/armada-385-turris-omnia.dts
@@ -479,7 +479,6 @@ ports@4 {
 
 			ports@5 {
 				reg = <5>;
-				label = "cpu";
 				ethernet = <&eth1>;
 				phy-mode = "rgmii-id";
 
@@ -491,7 +490,6 @@ fixed-link {
 
 			ports@6 {
 				reg = <6>;
-				label = "cpu";
 				ethernet = <&eth0>;
 				phy-mode = "rgmii-id";
 
diff --git a/arch/arm/boot/dts/armada-xp-linksys-mamba.dts b/arch/arm/boot/dts/armada-xp-linksys-mamba.dts
index dbe8dfe236fb..7a0614fd0c93 100644
--- a/arch/arm/boot/dts/armada-xp-linksys-mamba.dts
+++ b/arch/arm/boot/dts/armada-xp-linksys-mamba.dts
@@ -302,7 +302,7 @@ port@4 {
 
 			port@5 {
 				reg = <5>;
-				label = "cpu";
+				phy-mode = "rgmii-id";
 				ethernet = <&eth0>;
 				fixed-link {
 					speed = <1000>;
-- 
2.40.0

