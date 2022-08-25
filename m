Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B665A1B86
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243484AbiHYVpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244083AbiHYVpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:45:19 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F048AA34B;
        Thu, 25 Aug 2022 14:44:56 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id D5F339A87;
        Thu, 25 Aug 2022 23:44:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661463883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zRsiRxIvVLTYwaf26x4VwnBi3EbjID5udnHi2XzBIfw=;
        b=HvLpgjGf5vCpML4fJ45VTKnfE2+kWLhHEE77sMdrn9QN+K7etxrUhHzJEkUyCENYNekVQE
        V/b4W3o02ecbprcD0+eU6Pdod0YFWvU1HZPV4RMBDr7VPy0CWqLSNKuYX4EFvDHEdy5F4C
        tzX4eV8DRKwkIF/k59VifKAM76DMpdp0nvliYGmkbsDmEqhLZ6jwuu5XjRaZY2RsfeNnLk
        Q/LFlg/X3sfZMo/fy0/lit8vgHMlVysK2uMZHQ1z33cyXfLDowO13sgBB5bnVv4wuAU9ZY
        IDYsbcTrbERQ93Zn/m2lZUWBrbTRt7RSVAgjupzfDECPtbKYFhS7+OqE2CayTQ==
From:   Michael Walle <michael@walle.cc>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH v1 14/14] arm64: dts: ls1028a: sl28: get MAC addresses from VPD
Date:   Thu, 25 Aug 2022 23:44:23 +0200
Message-Id: <20220825214423.903672-15-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220825214423.903672-1-michael@walle.cc>
References: <20220825214423.903672-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that it is finally possible to get the MAC addresses from the OTP
memory, use it to set the addresses of the network devices.

There are 8 reserved MAC addresses in total per board. Distribute them
as follows:

+----------+------+------+------+------+------+
|          | var1 | var2 | var3 | var4 | kbox |
+----------+------+------+------+------+------+
| enetc #0 |   +0 |      |      |   +0 |   +0 |
| enetc #1 |      |      |   +0 |   +1 |   +1 |
| enetc #2 | rand | rand | rand | rand | rand |
| enetc #3 |      |      |      |      |      |
| felix p0 |      |   +0 |      |      |   +4 |
| felix p1 |      |   +1 |      |      |   +5 |
| felix p2 |      |      |      |      |   +6 |
| felix p3 |      |      |      |      |   +7 |
| felix p4 |      |      |      |      |      |
| felix p5 |      |      |      |      |      |
+----------+------+------+------+------+------+

An empty cell means, the port is not available and thus doesn't need an
ethernet address.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 .../freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts |  8 ++++++++
 .../dts/freescale/fsl-ls1028a-kontron-sl28-var1.dts |  2 ++
 .../dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts |  4 ++++
 .../dts/freescale/fsl-ls1028a-kontron-sl28-var4.dts |  2 ++
 .../boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts | 13 +++++++++++++
 5 files changed, 29 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
index 6b575efd84a7..b5c874c145d3 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
@@ -76,6 +76,8 @@ &mscc_felix_port0 {
 	managed = "in-band-status";
 	phy-handle = <&qsgmii_phy0>;
 	phy-mode = "qsgmii";
+	nvmem-cells = <&base_mac_address 4>;
+	nvmem-cell-names = "mac-address";
 	status = "okay";
 };
 
@@ -84,6 +86,8 @@ &mscc_felix_port1 {
 	managed = "in-band-status";
 	phy-handle = <&qsgmii_phy1>;
 	phy-mode = "qsgmii";
+	nvmem-cells = <&base_mac_address 5>;
+	nvmem-cell-names = "mac-address";
 	status = "okay";
 };
 
@@ -92,6 +96,8 @@ &mscc_felix_port2 {
 	managed = "in-band-status";
 	phy-handle = <&qsgmii_phy2>;
 	phy-mode = "qsgmii";
+	nvmem-cells = <&base_mac_address 6>;
+	nvmem-cell-names = "mac-address";
 	status = "okay";
 };
 
@@ -100,6 +106,8 @@ &mscc_felix_port3 {
 	managed = "in-band-status";
 	phy-handle = <&qsgmii_phy3>;
 	phy-mode = "qsgmii";
+	nvmem-cells = <&base_mac_address 7>;
+	nvmem-cell-names = "mac-address";
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var1.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var1.dts
index 7cd29ab970d9..1f34c7553459 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var1.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var1.dts
@@ -55,5 +55,7 @@ &enetc_port0 {
 &enetc_port1 {
 	phy-handle = <&phy0>;
 	phy-mode = "rgmii-id";
+	nvmem-cells = <&base_mac_address 0>;
+	nvmem-cell-names = "mac-address";
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
index 330e34f933a3..0ed0d2545922 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
@@ -48,6 +48,8 @@ &mscc_felix_port0 {
 	managed = "in-band-status";
 	phy-handle = <&phy0>;
 	phy-mode = "sgmii";
+	nvmem-cells = <&base_mac_address 0>;
+	nvmem-cell-names = "mac-address";
 	status = "okay";
 };
 
@@ -56,6 +58,8 @@ &mscc_felix_port1 {
 	managed = "in-band-status";
 	phy-handle = <&phy1>;
 	phy-mode = "sgmii";
+	nvmem-cells = <&base_mac_address 1>;
+	nvmem-cell-names = "mac-address";
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var4.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var4.dts
index 9b5e92fb753e..a4421db3784e 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var4.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var4.dts
@@ -43,5 +43,7 @@ vddh: vddh-regulator {
 &enetc_port1 {
 	phy-handle = <&phy1>;
 	phy-mode = "rgmii-id";
+	nvmem-cells = <&base_mac_address 1>;
+	nvmem-cell-names = "mac-address";
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts
index 4ab17b984b03..72429b37a8b4 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts
@@ -92,6 +92,8 @@ &enetc_port0 {
 	phy-handle = <&phy0>;
 	phy-mode = "sgmii";
 	managed = "in-band-status";
+	nvmem-cells = <&base_mac_address 0>;
+	nvmem-cell-names = "mac-address";
 	status = "okay";
 };
 
@@ -154,6 +156,17 @@ partition@3e0000 {
 				label = "bootloader environment";
 			};
 		};
+
+		otp-1 {
+			compatible = "kontron,sl28-vpd", "user-otp";
+
+			serial_number: serial-number {
+			};
+
+			base_mac_address: base-mac-address {
+				#nvmem-cell-cells = <1>;
+			};
+		};
 	};
 };
 
-- 
2.30.2

