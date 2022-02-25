Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58E74C4215
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 11:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239385AbiBYKS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 05:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237042AbiBYKSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 05:18:54 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A99818E3EE;
        Fri, 25 Feb 2022 02:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=R1TUjW3FR0g4N/arQpSNxRqerqgJRvX9AVweP0pFvqk=; b=QBZQTz00vs0LOMzxKJLWEYQ750
        9kk0tkqlrECDqILShqnXPoZdE/WX87gvPOU4yOZV2lCy/QU7H7ww3Mfa+MUwtcVgRGK1QuwbR4FON
        0hH64DSko2JnCeEGkecUym2xqzV0xwaZdNOUke2+6LIVIIihto1+0wsV/prpJheAo4lI=;
Received: from p200300daa7204f00f847964d075b2b3d.dip0.t-ipconnect.de ([2003:da:a720:4f00:f847:964d:75b:2b3d] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nNXg1-0007J1-AM; Fri, 25 Feb 2022 11:18:17 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] arm64: dts: mediatek: mt7622: introduce nodes for Wireless Ethernet Dispatch
Date:   Fri, 25 Feb 2022 11:18:04 +0100
Message-Id: <20220225101811.72103-6-nbd@nbd.name>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220225101811.72103-1-nbd@nbd.name>
References: <20220225101811.72103-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce wed0 and wed1 nodes in order to enable offloading forwarding
between ethernet and wireless devices on the mt7622 chipset.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 arch/arm64/boot/dts/mediatek/mt7622.dtsi | 28 ++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index a2257ec6d256..47d223e28f8d 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -901,6 +901,11 @@ sata_port: sata-phy@1a243000 {
 		};
 	};
 
+	hifsys: syscon@1af00000 {
+		compatible = "mediatek,mt7622-hifsys", "syscon";
+		reg = <0 0x1af00000 0 0x70>;
+	};
+
 	ethsys: syscon@1b000000 {
 		compatible = "mediatek,mt7622-ethsys",
 			     "syscon";
@@ -919,6 +924,26 @@ hsdma: dma-controller@1b007000 {
 		#dma-cells = <1>;
 	};
 
+	pcie_mirror: pcie-mirror@10000400 {
+		compatible = "mediatek,mt7622-pcie-mirror",
+			     "syscon";
+		reg = <0 0x10000400 0 0x10>;
+	};
+
+	wed0: wed@1020a000 {
+		compatible = "mediatek,mt7622-wed",
+			     "syscon";
+		reg = <0 0x1020a000 0 0x1000>;
+		interrupts = <GIC_SPI 214 IRQ_TYPE_LEVEL_LOW>;
+	};
+
+	wed1: wed@1020b000 {
+		compatible = "mediatek,mt7622-wed",
+			     "syscon";
+		reg = <0 0x1020b000 0 0x1000>;
+		interrupts = <GIC_SPI 215 IRQ_TYPE_LEVEL_LOW>;
+	};
+
 	eth: ethernet@1b100000 {
 		compatible = "mediatek,mt7622-eth",
 			     "mediatek,mt2701-eth",
@@ -946,6 +971,9 @@ eth: ethernet@1b100000 {
 		mediatek,ethsys = <&ethsys>;
 		mediatek,sgmiisys = <&sgmiisys>;
 		mediatek,cci-control = <&cci_control2>;
+		mediatek,wed = <&wed0>, <&wed1>;
+		mediatek,pcie-mirror = <&pcie_mirror>;
+		mediatek,hifsys = <&hifsys>;
 		dma-coherent;
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.32.0 (Apple Git-132)

