Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC70510FC5
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 05:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357596AbiD0EBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 00:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350517AbiD0EA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 00:00:59 -0400
Received: from twspam01.aspeedtech.com (twspam01.aspeedtech.com [211.20.114.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B0871A17;
        Tue, 26 Apr 2022 20:57:48 -0700 (PDT)
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 23R3gSNV032327;
        Wed, 27 Apr 2022 11:42:28 +0800 (GMT-8)
        (envelope-from dylan_hung@aspeedtech.com)
Received: from DylanHung-PC.aspeed.com (192.168.2.216) by TWMBX02.aspeed.com
 (192.168.0.24) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Apr
 2022 11:54:58 +0800
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     <robh+dt@kernel.org>, <joel@jms.id.au>, <andrew@aj.id.au>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <p.zabel@pengutronix.de>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <krzk+dt@kernel.org>
CC:     <BMC-SW@aspeedtech.com>, Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH net-next v6 1/3] dt-bindings: net: add reset property for aspeed, ast2600-mdio binding
Date:   Wed, 27 Apr 2022 11:54:59 +0800
Message-ID: <20220427035501.17500-2-dylan_hung@aspeedtech.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220427035501.17500-1-dylan_hung@aspeedtech.com>
References: <20220427035501.17500-1-dylan_hung@aspeedtech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.2.216]
X-ClientProxiedBy: TWMBX02.aspeed.com (192.168.0.24) To TWMBX02.aspeed.com
 (192.168.0.24)
X-DNSRBL: 
X-MAIL: twspam01.aspeedtech.com 23R3gSNV032327
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AST2600 MDIO bus controller has a reset control bit and must be
deasserted before manipulating the MDIO controller. By default, the
hardware asserts the reset so the driver only need to deassert it.

Regarding to the old DT blobs which don't have reset property in them,
the reset deassertion is usually done by the bootloader so the reset
property is optional to work with them.

Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
---
 .../devicetree/bindings/net/aspeed,ast2600-mdio.yaml        | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml b/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
index 1c88820cbcdf..f81eda8cb0a5 100644
--- a/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
@@ -20,10 +20,14 @@ allOf:
 properties:
   compatible:
     const: aspeed,ast2600-mdio
+
   reg:
     maxItems: 1
     description: The register range of the MDIO controller instance
 
+  resets:
+    maxItems: 1
+
 required:
   - compatible
   - reg
@@ -34,11 +38,13 @@ unevaluatedProperties: false
 
 examples:
   - |
+    #include <dt-bindings/clock/ast2600-clock.h>
     mdio0: mdio@1e650000 {
             compatible = "aspeed,ast2600-mdio";
             reg = <0x1e650000 0x8>;
             #address-cells = <1>;
             #size-cells = <0>;
+            resets = <&syscon ASPEED_RESET_MII>;
 
             ethphy0: ethernet-phy@0 {
                     compatible = "ethernet-phy-ieee802.3-c22";
-- 
2.25.1

