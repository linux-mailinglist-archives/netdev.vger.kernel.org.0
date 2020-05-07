Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4951C947E
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 17:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgEGPNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 11:13:14 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:45950 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbgEGPNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 11:13:13 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 047FCqlM092059;
        Thu, 7 May 2020 10:12:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588864372;
        bh=uHPwV69Dhv7IS63ZpxLzpMltxKOgBIIHLVDM5YZVhN0=;
        h=From:To:CC:Subject:Date;
        b=kT8IjwRgE2gl+b9P3zAs5HOYtpWHYrNjlZkW9khLiAPIX0ip7/GQgkmCrzv+GGDDe
         NJ9ISUCTJeLtlxEW7oUSRY9ZZr7HNCvLBHiim8+UsBbVl5HrtMGsbCjn6f9yv/sh6Q
         1BqAqX5VhKE1RsTRz9kLiX+GA3b6/4/PY+PNs/mI=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 047FCqD0043780;
        Thu, 7 May 2020 10:12:52 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 7 May
 2020 10:12:51 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 7 May 2020 10:12:51 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 047FCosF070313;
        Thu, 7 May 2020 10:12:51 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH v2] ARM: dts: am437x: fix networking on boards with ksz9031 phy
Date:   Thu, 7 May 2020 18:12:44 +0300
Message-ID: <20200507151244.24218-1-grygorii.strashko@ti.com>
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
 am437x-gp-evm
 am437x-sk-evm
 am437x-idk-evm

All above boards have phy-mode = "rgmii" and this is worked before, because
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
 arch/arm/boot/dts/am437x-gp-evm.dts  | 2 +-
 arch/arm/boot/dts/am437x-idk-evm.dts | 2 +-
 arch/arm/boot/dts/am437x-sk-evm.dts  | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am437x-gp-evm.dts
index 811c8cae315b..d692e3b2812a 100644
--- a/arch/arm/boot/dts/am437x-gp-evm.dts
+++ b/arch/arm/boot/dts/am437x-gp-evm.dts
@@ -943,7 +943,7 @@
 
 &cpsw_emac0 {
 	phy-handle = <&ethphy0>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-rxid";
 };
 
 &elm {
diff --git a/arch/arm/boot/dts/am437x-idk-evm.dts b/arch/arm/boot/dts/am437x-idk-evm.dts
index 9f66f96d09c9..a958f9ee4a5a 100644
--- a/arch/arm/boot/dts/am437x-idk-evm.dts
+++ b/arch/arm/boot/dts/am437x-idk-evm.dts
@@ -504,7 +504,7 @@
 
 &cpsw_emac0 {
 	phy-handle = <&ethphy0>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-rxid";
 };
 
 &rtc {
diff --git a/arch/arm/boot/dts/am437x-sk-evm.dts b/arch/arm/boot/dts/am437x-sk-evm.dts
index 25222497f828..4d5a7ca2e25d 100644
--- a/arch/arm/boot/dts/am437x-sk-evm.dts
+++ b/arch/arm/boot/dts/am437x-sk-evm.dts
@@ -833,13 +833,13 @@
 
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

