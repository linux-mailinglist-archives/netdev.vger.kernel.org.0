Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C7C2C4B9F
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 00:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733238AbgKYXZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 18:25:58 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:37252 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731750AbgKYXZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 18:25:56 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4ChH7k2VYrz1qs3D;
        Thu, 26 Nov 2020 00:25:54 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4ChH7k27VHz1vdfr;
        Thu, 26 Nov 2020 00:25:54 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id xsV1O1AGOiez; Thu, 26 Nov 2020 00:25:52 +0100 (CET)
X-Auth-Info: bSbI5zVU0PcFVOfLl5E/cpCrEQQdaQoXBldrUCwgHoo=
Received: from localhost.localdomain (89-64-5-98.dynamic.chello.pl [89.64.5.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 26 Nov 2020 00:25:52 +0100 (CET)
From:   Lukasz Majewski <lukma@denx.de>
To:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     NXP Linux Team <linux-imx@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>, stefan.agner@toradex.com,
        krzk@kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Lukasz Majewski <lukma@denx.de>
Subject: [RFC 4/4] ARM: dts: imx28: Add description for L2 switch on XEA board
Date:   Thu, 26 Nov 2020 00:24:59 +0100
Message-Id: <20201125232459.378-5-lukma@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201125232459.378-1-lukma@denx.de>
References: <20201125232459.378-1-lukma@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'eth_switch' node is now used to enable support for L2 switch.
Moreover, a separate 'switch' node was introduced to keep the code more
clean.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
 arch/arm/boot/dts/imx28-xea.dts | 55 +++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/arch/arm/boot/dts/imx28-xea.dts b/arch/arm/boot/dts/imx28-xea.dts
index 672080485b78..b8a896df02c0 100644
--- a/arch/arm/boot/dts/imx28-xea.dts
+++ b/arch/arm/boot/dts/imx28-xea.dts
@@ -9,6 +9,30 @@
 
 / {
 	model = "XEA";
+
+	switch {
+		compatible = "imx,mtip-l2switch";
+		reg = <0x800f8000 0x400>, <0x800fC000 0x4000>;
+		ports {
+			port0@0 {
+				reg = <0>;
+				label = "lan1";
+				phy-handle = <&ethsw0>;
+			};
+
+			port1@1 {
+				reg = <1>;
+				label = "lan2";
+				phy-handle = <&ethsw1>;
+			};
+
+			port2@2 {
+				reg = <2>;
+				label = "cpu";
+				ethernet = <&eth_switch>;
+			};
+		};
+	};
 };
 
 &can0 {
@@ -23,6 +47,37 @@
 	status = "okay";
 };
 
+&eth_switch {
+	compatible = "fsl,imx28-l2switch";
+	reg = <0x800f0000 0x8000>, <0x800f8400 0x400>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&mac0_pins_a>, <&mac1_pins_a>;
+	phy-mode = "rmii";
+	phy-supply = <&reg_fec_3v3>;
+	phy-reset-gpios = <&gpio2 13 0>;
+	phy-reset-duration = <100>;
+	interrupts = <100>, <101>, <102>;
+	clocks = <&clks 57>, <&clks 57>, <&clks 64>, <&clks 35>;
+	clock-names = "ipg", "ahb", "enet_out", "ptp";
+	local-mac-address = [ 00 11 22 AA BB CC ];
+	status = "okay";
+
+	fixed-link {
+		speed = <100>;
+		full-duplex;
+	};
+
+	mdio {
+		ethsw0: ethernet-phy@0 {
+			reg = <0>;
+		};
+
+		ethsw1: ethernet-phy@1 {
+			reg = <1>;
+		};
+	};
+};
+
 &pinctrl {
 	pinctrl-names = "default";
 	pinctrl-0 = <&hog_pins_a &hog_pins_tiva>;
-- 
2.20.1

