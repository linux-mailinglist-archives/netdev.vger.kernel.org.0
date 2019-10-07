Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08F9ACDC36
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 09:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfJGHIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 03:08:54 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:53039 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727028AbfJGHIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 03:08:53 -0400
X-UUID: 4f78dc3b78fb4c0c8a6dbf0fafcf538e-20191007
X-UUID: 4f78dc3b78fb4c0c8a6dbf0fafcf538e-20191007
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <mark-mc.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1850811406; Mon, 07 Oct 2019 15:08:47 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 7 Oct 2019 15:08:44 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 7 Oct 2019 15:08:44 +0800
From:   MarkLee <Mark-MC.Lee@mediatek.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Nelson Chang <nelson.chang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rene van Dorst <opensource@vdorst.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, MarkLee <Mark-MC.Lee@mediatek.com>
Subject: [PATCH net,v2 2/2] arm: dts: mediatek: Fix mt7629 dts to reflect the latest dt-binding
Date:   Mon, 7 Oct 2019 15:08:44 +0800
Message-ID: <20191007070844.14212-3-Mark-MC.Lee@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20191007070844.14212-1-Mark-MC.Lee@mediatek.com>
References: <20191007070844.14212-1-Mark-MC.Lee@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Removes mediatek,physpeed property from dtsi that is useless in PHYLINK
* Use the fixed-link property speed = <2500> to set the phy in 2.5Gbit.
* Set gmac1 to gmii mode that connect to a internal gphy

Signed-off-by: MarkLee <Mark-MC.Lee@mediatek.com>
--
v1->v2:
* SGMII port only support BASE-X at 2.5Gbit.
---
 arch/arm/boot/dts/mt7629-rfb.dts | 13 ++++++++++++-
 arch/arm/boot/dts/mt7629.dtsi    |  2 --
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/mt7629-rfb.dts b/arch/arm/boot/dts/mt7629-rfb.dts
index 3621b7d2b22a..9980c10c6e29 100644
--- a/arch/arm/boot/dts/mt7629-rfb.dts
+++ b/arch/arm/boot/dts/mt7629-rfb.dts
@@ -66,9 +66,21 @@
 	pinctrl-1 = <&ephy_leds_pins>;
 	status = "okay";
 
+	gmac0: mac@0 {
+		compatible = "mediatek,eth-mac";
+		reg = <0>;
+		phy-mode = "2500base-x";
+		fixed-link {
+			speed = <2500>;
+			full-duplex;
+			pause;
+		};
+	};
+
 	gmac1: mac@1 {
 		compatible = "mediatek,eth-mac";
 		reg = <1>;
+		phy-mode = "gmii";
 		phy-handle = <&phy0>;
 	};
 
@@ -78,7 +90,6 @@
 
 		phy0: ethernet-phy@0 {
 			reg = <0>;
-			phy-mode = "gmii";
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/mt7629.dtsi b/arch/arm/boot/dts/mt7629.dtsi
index 9608bc2ccb3f..867b88103b9d 100644
--- a/arch/arm/boot/dts/mt7629.dtsi
+++ b/arch/arm/boot/dts/mt7629.dtsi
@@ -468,14 +468,12 @@
 			compatible = "mediatek,mt7629-sgmiisys", "syscon";
 			reg = <0x1b128000 0x3000>;
 			#clock-cells = <1>;
-			mediatek,physpeed = "2500";
 		};
 
 		sgmiisys1: syscon@1b130000 {
 			compatible = "mediatek,mt7629-sgmiisys", "syscon";
 			reg = <0x1b130000 0x3000>;
 			#clock-cells = <1>;
-			mediatek,physpeed = "2500";
 		};
 	};
 };
-- 
2.17.1

