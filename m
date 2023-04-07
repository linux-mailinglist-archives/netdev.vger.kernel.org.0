Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77816DAFA3
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbjDGPZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbjDGPZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:25:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750B45FEC
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 08:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Z5IQvTFcmGGpdy7wPN1jqAydJBSopgZpKUblUtUCQ9E=; b=FSOZs2sEmv7B2a+cG5aFjs9GaQ
        Rh8GyZhqQxlJ74Eu3RduuwmHODJToEnbH/9+/ogdbnSzi5yPudLXbWKnyo1jILZKJTTpzYbTpXmXM
        hIWEgQCpsQEr9vyMzGCNLFh+WQMuXPMhmZ0uZoGTdelVpIQGkw0RU8/zFd+jX8y9CqE0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pknxp-009jjf-QB; Fri, 07 Apr 2023 17:25:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     shawnguo@kernel.org
Cc:     s.hauer@pengutronix.de, Russell King <rmk+kernel@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 2/3] ARM: dts: imx6qdl: Add missing phy-mode and fixed links
Date:   Fri,  7 Apr 2023 17:25:02 +0200
Message-Id: <20230407152503.2320741-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230407152503.2320741-1-andrew@lunn.ch>
References: <20230407152503.2320741-1-andrew@lunn.ch>
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
for the CPU port. Add a phy-mode based on what the SoC ethernet is
using. For RGMII mode, have the switch add the delays.

Additionally, the cpu label has never actually been used in the
binding, so remove it.

Lastly add a fixed-link node indicating the expected speed/duplex of
the link to the SoC.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/boot/dts/imx6qdl-gw5904.dtsi   | 7 ++++++-
 arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-gw5904.dtsi b/arch/arm/boot/dts/imx6qdl-gw5904.dtsi
index 9fc79af2bc9a..9594bc5745ed 100644
--- a/arch/arm/boot/dts/imx6qdl-gw5904.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw5904.dtsi
@@ -238,8 +238,13 @@ port@3 {
 
 				port@5 {
 					reg = <5>;
-					label = "cpu";
 					ethernet = <&fec>;
+					phy-mode = "rgmii-id";
+
+					fixed-link {
+						speed = <1000>;
+						full-duplex;
+					};
 				};
 			};
 		};
diff --git a/arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi b/arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi
index 5bb47c79a4da..826a9d6cb4d8 100644
--- a/arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi
@@ -757,7 +757,7 @@ port@1 {
 
 				port@2 {
 					reg = <2>;
-					label = "cpu";
+					phy-mode = "rmii";
 					ethernet = <&fec>;
 
 					fixed-link {
-- 
2.40.0

