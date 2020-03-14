Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B201856C4
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgCOB3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:29:50 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55780 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726916AbgCOB3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:29:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Fk+FnxOZ4piBC7QLssjdVkifsLfaxw3Fwj8s/Ji+Uas=; b=HE33uxbm4OwusDQn9X2FIOitw2
        m+Q/G/2sCoAd12zShryY+f0aixAhl4eYaagNq4f42aQL20rsdswU1XJyxrrX11MLHUEMGYWHX8ZY4
        /0jAKPYQV4nt12UrtzrfEPpcGwFRmMII/t3UI6fCVN03J8d2923VpqLnajkieKNf5LXcQuKI4j7wL
        ZYKyArMH5kqRMk69DZBJ40EqqOFFErC44G7SwrK2Ll+fzm0XONpvcD2/5YVTnnosKZyooFO/GBtr/
        dq8EiBWHQR0IIl6Op6R2/FVCcHsja9KmsJQ79aLv1zy/3odgSGCcojDj159nCg/qqFJbdlGNYMy+N
        nBx3d48A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:41716 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jD3pj-0006C4-EP; Sat, 14 Mar 2020 10:15:55 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jD3ph-0006Dq-Pd; Sat, 14 Mar 2020 10:15:53 +0000
In-Reply-To: <20200314101431.GF25745@shell.armlinux.org.uk>
References: <20200314101431.GF25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 6/8] net: dsa: mv88e6xxx: combine port_set_speed and
 port_set_duplex
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jD3ph-0006Dq-Pd@rmk-PC.armlinux.org.uk>
Date:   Sat, 14 Mar 2020 10:15:53 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting the speed independently of duplex makes little sense; the two
parameters result from negotiation or fixed setup, and may have inter-
dependencies. Moreover, they are always controlled via the same
register - having them split means we have to read-modify-write this
register twice.

Combine the two operations into a single port_set_speed_duplex()
operation. Not only is this more efficient, it reduces the size of the
code as well.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 103 ++++++++++-------------------
 drivers/net/dsa/mv88e6xxx/chip.h |  18 ++----
 drivers/net/dsa/mv88e6xxx/port.c | 108 +++++++++++++++----------------
 drivers/net/dsa/mv88e6xxx/port.h |  23 ++++---
 4 files changed, 107 insertions(+), 145 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 548a0c3edfac..34c7f3e588ec 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -452,8 +452,9 @@ static int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port,
 	if (err)
 		return err;
 
-	if (chip->info->ops->port_set_speed) {
-		err = chip->info->ops->port_set_speed(chip, port, speed);
+	if (chip->info->ops->port_set_speed_duplex) {
+		err = chip->info->ops->port_set_speed_duplex(chip, port,
+							     speed, duplex);
 		if (err && err != -EOPNOTSUPP)
 			goto restore_link;
 	}
@@ -467,12 +468,6 @@ static int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port,
 			goto restore_link;
 	}
 
-	if (chip->info->ops->port_set_duplex) {
-		err = chip->info->ops->port_set_duplex(chip, port, duplex);
-		if (err && err != -EOPNOTSUPP)
-			goto restore_link;
-	}
-
 	err = mv88e6xxx_port_config_interface(chip, port, mode);
 restore_link:
 	if (chip->info->ops->port_set_link(chip, port, link))
@@ -762,14 +757,9 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
 		if (err)
 			goto error;
 
-		if (ops->port_set_speed) {
-			err = ops->port_set_speed(chip, port, speed);
-			if (err && err != -EOPNOTSUPP)
-				goto error;
-		}
-
-		if (ops->port_set_duplex) {
-			err = ops->port_set_duplex(chip, port, duplex);
+		if (ops->port_set_speed_duplex) {
+			err = ops->port_set_speed_duplex(chip, port,
+							 speed, duplex);
 			if (err && err != -EOPNOTSUPP)
 				goto error;
 		}
@@ -3412,8 +3402,7 @@ static const struct mv88e6xxx_ops mv88e6085_ops = {
 	.phy_read = mv88e6185_phy_ppu_read,
 	.phy_write = mv88e6185_phy_ppu_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
-	.port_set_speed = mv88e6185_port_set_speed,
+	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
@@ -3452,8 +3441,7 @@ static const struct mv88e6xxx_ops mv88e6095_ops = {
 	.phy_read = mv88e6185_phy_ppu_read,
 	.phy_write = mv88e6185_phy_ppu_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
-	.port_set_speed = mv88e6185_port_set_speed,
+	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_set_frame_mode = mv88e6085_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6185_port_set_egress_floods,
 	.port_set_upstream_port = mv88e6095_port_set_upstream_port,
@@ -3483,8 +3471,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
-	.port_set_speed = mv88e6185_port_set_speed,
+	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
@@ -3523,8 +3510,7 @@ static const struct mv88e6xxx_ops mv88e6123_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
-	.port_set_speed = mv88e6185_port_set_speed,
+	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_set_frame_mode = mv88e6085_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
@@ -3558,8 +3544,7 @@ static const struct mv88e6xxx_ops mv88e6131_ops = {
 	.phy_read = mv88e6185_phy_ppu_read,
 	.phy_write = mv88e6185_phy_ppu_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
-	.port_set_speed = mv88e6185_port_set_speed,
+	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6185_port_set_egress_floods,
@@ -3601,9 +3586,8 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
-	.port_set_speed = mv88e6341_port_set_speed,
+	.port_set_speed_duplex = mv88e6341_port_set_speed_duplex,
 	.port_max_speed_mode = mv88e6341_port_max_speed_mode,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
@@ -3654,8 +3638,7 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
-	.port_set_speed = mv88e6185_port_set_speed,
+	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
@@ -3697,8 +3680,7 @@ static const struct mv88e6xxx_ops mv88e6165_ops = {
 	.phy_read = mv88e6165_phy_read,
 	.phy_write = mv88e6165_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
-	.port_set_speed = mv88e6185_port_set_speed,
+	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
@@ -3733,9 +3715,8 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
-	.port_set_speed = mv88e6185_port_set_speed,
+	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
@@ -3777,9 +3758,8 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
-	.port_set_speed = mv88e6352_port_set_speed,
+	.port_set_speed_duplex = mv88e6352_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
@@ -3830,9 +3810,8 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
-	.port_set_speed = mv88e6185_port_set_speed,
+	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
@@ -3874,9 +3853,8 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
-	.port_set_speed = mv88e6352_port_set_speed,
+	.port_set_speed_duplex = mv88e6352_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
@@ -3929,8 +3907,7 @@ static const struct mv88e6xxx_ops mv88e6185_ops = {
 	.phy_read = mv88e6185_phy_ppu_read,
 	.phy_write = mv88e6185_phy_ppu_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
-	.port_set_speed = mv88e6185_port_set_speed,
+	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_set_frame_mode = mv88e6085_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6185_port_set_egress_floods,
 	.port_egress_rate_limiting = mv88e6095_port_egress_rate_limiting,
@@ -3967,9 +3944,8 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
-	.port_set_speed = mv88e6390_port_set_speed,
+	.port_set_speed_duplex = mv88e6390_port_set_speed_duplex,
 	.port_max_speed_mode = mv88e6390_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
@@ -4028,9 +4004,8 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
-	.port_set_speed = mv88e6390x_port_set_speed,
+	.port_set_speed_duplex = mv88e6390x_port_set_speed_duplex,
 	.port_max_speed_mode = mv88e6390x_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
@@ -4089,9 +4064,8 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
-	.port_set_speed = mv88e6390_port_set_speed,
+	.port_set_speed_duplex = mv88e6390_port_set_speed_duplex,
 	.port_max_speed_mode = mv88e6390_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
@@ -4151,9 +4125,8 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
-	.port_set_speed = mv88e6352_port_set_speed,
+	.port_set_speed_duplex = mv88e6352_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
@@ -4211,9 +4184,8 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
-	.port_set_speed = mv88e6250_port_set_speed,
+	.port_set_speed_duplex = mv88e6250_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
@@ -4250,9 +4222,8 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
-	.port_set_speed = mv88e6390_port_set_speed,
+	.port_set_speed_duplex = mv88e6390_port_set_speed_duplex,
 	.port_max_speed_mode = mv88e6390_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
@@ -4314,8 +4285,7 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
-	.port_set_speed = mv88e6185_port_set_speed,
+	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
@@ -4358,8 +4328,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
-	.port_set_speed = mv88e6185_port_set_speed,
+	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
@@ -4400,9 +4369,8 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
-	.port_set_speed = mv88e6341_port_set_speed,
+	.port_set_speed_duplex = mv88e6341_port_set_speed_duplex,
 	.port_max_speed_mode = mv88e6341_port_max_speed_mode,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
@@ -4455,9 +4423,8 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
-	.port_set_speed = mv88e6185_port_set_speed,
+	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
@@ -4497,9 +4464,8 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
-	.port_set_speed = mv88e6185_port_set_speed,
+	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
@@ -4543,9 +4509,8 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
-	.port_set_speed = mv88e6352_port_set_speed,
+	.port_set_speed_duplex = mv88e6352_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
@@ -4605,9 +4570,8 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
-	.port_set_speed = mv88e6390_port_set_speed,
+	.port_set_speed_duplex = mv88e6390_port_set_speed_duplex,
 	.port_max_speed_mode = mv88e6390_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
@@ -4670,9 +4634,8 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.phy_read = mv88e6xxx_g2_smi_phy_read,
 	.phy_write = mv88e6xxx_g2_smi_phy_write,
 	.port_set_link = mv88e6xxx_port_set_link,
-	.port_set_duplex = mv88e6xxx_port_set_duplex,
 	.port_set_rgmii_delay = mv88e6390_port_set_rgmii_delay,
-	.port_set_speed = mv88e6390x_port_set_speed,
+	.port_set_speed_duplex = mv88e6390x_port_set_speed_duplex,
 	.port_max_speed_mode = mv88e6390x_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
 	.port_set_policy = mv88e6352_port_set_policy,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 93cc8b6a2bef..72214c4bb2ab 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -399,15 +399,6 @@ struct mv88e6xxx_ops {
 	 */
 	int (*port_set_link)(struct mv88e6xxx_chip *chip, int port, int link);
 
-#define DUPLEX_UNFORCED		-2
-
-	/* Port's MAC duplex mode
-	 *
-	 * Use DUPLEX_HALF or DUPLEX_FULL to force half or full duplex,
-	 * or DUPLEX_UNFORCED for normal duplex detection.
-	 */
-	int (*port_set_duplex)(struct mv88e6xxx_chip *chip, int port, int dup);
-
 #define PAUSE_ON		1
 #define PAUSE_OFF		0
 
@@ -417,13 +408,18 @@ struct mv88e6xxx_ops {
 
 #define SPEED_MAX		INT_MAX
 #define SPEED_UNFORCED		-2
+#define DUPLEX_UNFORCED		-2
 
-	/* Port's MAC speed (in Mbps)
+	/* Port's MAC speed (in Mbps) and MAC duplex mode
 	 *
 	 * Depending on the chip, 10, 100, 200, 1000, 2500, 10000 are valid.
 	 * Use SPEED_UNFORCED for normal detection, SPEED_MAX for max value.
+	 *
+	 * Use DUPLEX_HALF or DUPLEX_FULL to force half or full duplex,
+	 * or DUPLEX_UNFORCED for normal duplex detection.
 	 */
-	int (*port_set_speed)(struct mv88e6xxx_chip *chip, int port, int speed);
+	int (*port_set_speed_duplex)(struct mv88e6xxx_chip *chip, int port,
+				     int speed, int duplex);
 
 	/* What interface mode should be used for maximum speed? */
 	phy_interface_t (*port_max_speed_mode)(int port);
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 0b43c650e100..442abb719cdc 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -162,46 +162,9 @@ int mv88e6xxx_port_set_link(struct mv88e6xxx_chip *chip, int port, int link)
 	return 0;
 }
 
-int mv88e6xxx_port_set_duplex(struct mv88e6xxx_chip *chip, int port, int dup)
-{
-	u16 reg;
-	int err;
-
-	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_MAC_CTL, &reg);
-	if (err)
-		return err;
-
-	reg &= ~(MV88E6XXX_PORT_MAC_CTL_FORCE_DUPLEX |
-		 MV88E6XXX_PORT_MAC_CTL_DUPLEX_FULL);
-
-	switch (dup) {
-	case DUPLEX_HALF:
-		reg |= MV88E6XXX_PORT_MAC_CTL_FORCE_DUPLEX;
-		break;
-	case DUPLEX_FULL:
-		reg |= MV88E6XXX_PORT_MAC_CTL_FORCE_DUPLEX |
-			MV88E6XXX_PORT_MAC_CTL_DUPLEX_FULL;
-		break;
-	case DUPLEX_UNFORCED:
-		/* normal duplex detection */
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_MAC_CTL, reg);
-	if (err)
-		return err;
-
-	dev_dbg(chip->dev, "p%d: %s %s duplex\n", port,
-		reg & MV88E6XXX_PORT_MAC_CTL_FORCE_DUPLEX ? "Force" : "Unforce",
-		reg & MV88E6XXX_PORT_MAC_CTL_DUPLEX_FULL ? "full" : "half");
-
-	return 0;
-}
-
-static int mv88e6xxx_port_set_speed(struct mv88e6xxx_chip *chip, int port,
-				    int speed, bool alt_bit, bool force_bit)
+static int mv88e6xxx_port_set_speed_duplex(struct mv88e6xxx_chip *chip,
+					   int port, int speed, bool alt_bit,
+					   bool force_bit, int duplex)
 {
 	u16 reg, ctrl;
 	int err;
@@ -239,11 +202,29 @@ static int mv88e6xxx_port_set_speed(struct mv88e6xxx_chip *chip, int port,
 		return -EOPNOTSUPP;
 	}
 
+	switch (duplex) {
+	case DUPLEX_HALF:
+		ctrl |= MV88E6XXX_PORT_MAC_CTL_FORCE_DUPLEX;
+		break;
+	case DUPLEX_FULL:
+		ctrl |= MV88E6XXX_PORT_MAC_CTL_FORCE_DUPLEX |
+			MV88E6XXX_PORT_MAC_CTL_DUPLEX_FULL;
+		break;
+	case DUPLEX_UNFORCED:
+		/* normal duplex detection */
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
 	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_MAC_CTL, &reg);
 	if (err)
 		return err;
 
-	reg &= ~MV88E6XXX_PORT_MAC_CTL_SPEED_MASK;
+	reg &= ~(MV88E6XXX_PORT_MAC_CTL_SPEED_MASK |
+		 MV88E6XXX_PORT_MAC_CTL_FORCE_DUPLEX |
+		 MV88E6XXX_PORT_MAC_CTL_DUPLEX_FULL);
+
 	if (alt_bit)
 		reg &= ~MV88E6390_PORT_MAC_CTL_ALTSPEED;
 	if (force_bit) {
@@ -261,12 +242,16 @@ static int mv88e6xxx_port_set_speed(struct mv88e6xxx_chip *chip, int port,
 		dev_dbg(chip->dev, "p%d: Speed set to %d Mbps\n", port, speed);
 	else
 		dev_dbg(chip->dev, "p%d: Speed unforced\n", port);
+	dev_dbg(chip->dev, "p%d: %s %s duplex\n", port,
+		reg & MV88E6XXX_PORT_MAC_CTL_FORCE_DUPLEX ? "Force" : "Unforce",
+		reg & MV88E6XXX_PORT_MAC_CTL_DUPLEX_FULL ? "full" : "half");
 
 	return 0;
 }
 
 /* Support 10, 100, 200 Mbps (e.g. 88E6065 family) */
-int mv88e6065_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed)
+int mv88e6065_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
+				    int speed, int duplex)
 {
 	if (speed == SPEED_MAX)
 		speed = 200;
@@ -275,11 +260,13 @@ int mv88e6065_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed)
 		return -EOPNOTSUPP;
 
 	/* Setting 200 Mbps on port 0 to 3 selects 100 Mbps */
-	return mv88e6xxx_port_set_speed(chip, port, speed, false, false);
+	return mv88e6xxx_port_set_speed_duplex(chip, port, speed, false, false,
+					       duplex);
 }
 
 /* Support 10, 100, 1000 Mbps (e.g. 88E6185 family) */
-int mv88e6185_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed)
+int mv88e6185_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
+				    int speed, int duplex)
 {
 	if (speed == SPEED_MAX)
 		speed = 1000;
@@ -287,11 +274,13 @@ int mv88e6185_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed)
 	if (speed == 200 || speed > 1000)
 		return -EOPNOTSUPP;
 
-	return mv88e6xxx_port_set_speed(chip, port, speed, false, false);
+	return mv88e6xxx_port_set_speed_duplex(chip, port, speed, false, false,
+					       duplex);
 }
 
 /* Support 10, 100 Mbps (e.g. 88E6250 family) */
-int mv88e6250_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed)
+int mv88e6250_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
+				    int speed, int duplex)
 {
 	if (speed == SPEED_MAX)
 		speed = 100;
@@ -299,11 +288,13 @@ int mv88e6250_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed)
 	if (speed > 100)
 		return -EOPNOTSUPP;
 
-	return mv88e6xxx_port_set_speed(chip, port, speed, false, false);
+	return mv88e6xxx_port_set_speed_duplex(chip, port, speed, false, false,
+					       duplex);
 }
 
 /* Support 10, 100, 200, 1000, 2500 Mbps (e.g. 88E6341) */
-int mv88e6341_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed)
+int mv88e6341_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
+				    int speed, int duplex)
 {
 	if (speed == SPEED_MAX)
 		speed = port < 5 ? 1000 : 2500;
@@ -317,7 +308,8 @@ int mv88e6341_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed)
 	if (speed == 2500 && port < 5)
 		return -EOPNOTSUPP;
 
-	return mv88e6xxx_port_set_speed(chip, port, speed, !port, true);
+	return mv88e6xxx_port_set_speed_duplex(chip, port, speed, !port, true,
+					       duplex);
 }
 
 phy_interface_t mv88e6341_port_max_speed_mode(int port)
@@ -329,7 +321,8 @@ phy_interface_t mv88e6341_port_max_speed_mode(int port)
 }
 
 /* Support 10, 100, 200, 1000 Mbps (e.g. 88E6352 family) */
-int mv88e6352_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed)
+int mv88e6352_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
+				    int speed, int duplex)
 {
 	if (speed == SPEED_MAX)
 		speed = 1000;
@@ -340,11 +333,13 @@ int mv88e6352_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed)
 	if (speed == 200 && port < 5)
 		return -EOPNOTSUPP;
 
-	return mv88e6xxx_port_set_speed(chip, port, speed, true, false);
+	return mv88e6xxx_port_set_speed_duplex(chip, port, speed, true, false,
+					       duplex);
 }
 
 /* Support 10, 100, 200, 1000, 2500 Mbps (e.g. 88E6390) */
-int mv88e6390_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed)
+int mv88e6390_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
+				    int speed, int duplex)
 {
 	if (speed == SPEED_MAX)
 		speed = port < 9 ? 1000 : 2500;
@@ -358,7 +353,8 @@ int mv88e6390_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed)
 	if (speed == 2500 && port < 9)
 		return -EOPNOTSUPP;
 
-	return mv88e6xxx_port_set_speed(chip, port, speed, true, true);
+	return mv88e6xxx_port_set_speed_duplex(chip, port, speed, true, true,
+					       duplex);
 }
 
 phy_interface_t mv88e6390_port_max_speed_mode(int port)
@@ -370,7 +366,8 @@ phy_interface_t mv88e6390_port_max_speed_mode(int port)
 }
 
 /* Support 10, 100, 200, 1000, 2500, 10000 Mbps (e.g. 88E6190X) */
-int mv88e6390x_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed)
+int mv88e6390x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
+				     int speed, int duplex)
 {
 	if (speed == SPEED_MAX)
 		speed = port < 9 ? 1000 : 10000;
@@ -381,7 +378,8 @@ int mv88e6390x_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed)
 	if (speed >= 2500 && port < 9)
 		return -EOPNOTSUPP;
 
-	return mv88e6xxx_port_set_speed(chip, port, speed, true, true);
+	return mv88e6xxx_port_set_speed_duplex(chip, port, speed, true, true,
+					       duplex);
 }
 
 phy_interface_t mv88e6390x_port_max_speed_mode(int port)
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 0ec4327c2b42..1d18426b7ff6 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -298,15 +298,20 @@ int mv88e6390_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,
 
 int mv88e6xxx_port_set_link(struct mv88e6xxx_chip *chip, int port, int link);
 
-int mv88e6xxx_port_set_duplex(struct mv88e6xxx_chip *chip, int port, int dup);
-
-int mv88e6065_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed);
-int mv88e6185_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed);
-int mv88e6250_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed);
-int mv88e6341_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed);
-int mv88e6352_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed);
-int mv88e6390_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed);
-int mv88e6390x_port_set_speed(struct mv88e6xxx_chip *chip, int port, int speed);
+int mv88e6065_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
+				    int speed, int duplex);
+int mv88e6185_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
+				    int speed, int duplex);
+int mv88e6250_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
+				    int speed, int duplex);
+int mv88e6341_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
+				    int speed, int duplex);
+int mv88e6352_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
+				    int speed, int duplex);
+int mv88e6390_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
+				    int speed, int duplex);
+int mv88e6390x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
+				     int speed, int duplex);
 
 phy_interface_t mv88e6341_port_max_speed_mode(int port);
 phy_interface_t mv88e6390_port_max_speed_mode(int port);
-- 
2.20.1

