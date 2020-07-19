Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CF122516D
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 13:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgGSLAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 07:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgGSLAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 07:00:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764FDC0619D2;
        Sun, 19 Jul 2020 04:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pfbrKMZbukV4D22VnfokUOnwQuv0f1aU2UCKwOx5Fu0=; b=yBauyqXIXmm7OYaqATu2Ow3lL4
        jOa4L02Yn87LavOGmKpCGK25db6If9UvXKBUal0E3y+ELhrXvUneRAPqJjlGxXnME2BhXOlYSMDAh
        HXe0Tgd+V7cewYRsY/3kKtj5mFJgVOzYlv3Uq+hjTecWC9HdRTEUxFCMm/d1X6aY8M3HY1DGD2RKd
        lqTudwPQmPB7MmJwA0p7lQI/e24Vr6gLREvp1gN3/9wxj44IVhbS0E4dPz7Y0rb1EK6kxoQc6+s0Y
        pV+eD29n+3oiTWX+HVYu52rPc3Ln9He/J5rlUNSIGMAiGrZYkBXL+86yd4GVbXfd8Q2u+UsEm5Faz
        G7QokFpQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54116 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jx73h-0002CO-5j; Sun, 19 Jul 2020 12:00:41 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jx73g-0006mp-UI; Sun, 19 Jul 2020 12:00:40 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Martin Rowe <martin.p.rowe@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Gregory Clement <gregory.clement@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net] arm64: dts: clearfog-gt-8k: fix switch link configuration
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jx73g-0006mp-UI@rmk-PC.armlinux.org.uk>
Date:   Sun, 19 Jul 2020 12:00:40 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit below caused a regression for clearfog-gt-8k, where the link
between the switch and the host does not come up.

Investigation revealed two issues:
- MV88E6xxx DSA no longer allows an in-band link to come up as the link
  is programmed to be forced down. Commit "net: dsa: mv88e6xxx: fix
  in-band AN link establishment" addresses this.

- The dts configured dissimilar link modes at each end of the host to
  switch link; the host was configured using a fixed link (so has no
  in-band status) and the switch was configured to expect in-band
  status.

With both issues fixed, the regression is resolved.

Fixes: 34b5e6a33c1a ("net: dsa: mv88e6xxx: Configure MAC when using fixed link")
Reported-by: Martin Rowe <martin.p.rowe@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
index c8243da71041..eb01cc96ba7a 100644
--- a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
+++ b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
@@ -454,10 +454,7 @@
 	status = "okay";
 	phy-mode = "2500base-x";
 	phys = <&cp1_comphy5 2>;
-	fixed-link {
-		speed = <2500>;
-		full-duplex;
-	};
+	managed = "in-band-status";
 };
 
 &cp1_spi1 {
-- 
2.20.1

