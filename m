Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED24D2C1CC4
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 05:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgKXEfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 23:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728941AbgKXEev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 23:34:51 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7682C061A4E
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 20:34:50 -0800 (PST)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 144CB806AC;
        Tue, 24 Nov 2020 17:34:47 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1606192487;
        bh=rahYTMKg48FQZl0G+TVwUrwmoLl/GnDk1rA6BJUvqUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=P4fXWko0FrwyuwPO5sGorBw6CzL/mJy83AsxqPjJWqK9ClctpVj3scp+mq6rTUX3m
         UzAsTLBdgXJzVrkPK/0AYaxb9oq2LlUWPDH29B9hlbk82gv+z/odN81lhPVg1NuST5
         eL0f6L7A/5+S0ZcUxx+aFap/sPep6RL2OY3Knkn8n/4kQhFKgBi+4WFE6vbCZY/SLB
         9RfGseYn0QZflw0Mek+ynh3vafv6GlzBc8VJ0MK8Fq25k0cWEGcoU1C2RBNed3ALoD
         76XF/O3dWDwCoQvNqbG9BL4SLJj7EhXtzjFODDpF+qVu8U9u39UdjICMi5jqF6jqsa
         vtCYcUGz8HP5Q==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5fbc8d640001>; Tue, 24 Nov 2020 17:34:46 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 71ECA13EF0D;
        Tue, 24 Nov 2020 17:34:44 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 40E3A2800AA; Tue, 24 Nov 2020 17:34:45 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, pavana.sharma@digi.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [net-next PATCH v5 1/4] net: dsa: mv88e6xxx: Don't force link when using in-band-status
Date:   Tue, 24 Nov 2020 17:34:37 +1300
Message-Id: <20201124043440.28400-2-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201124043440.28400-1-chris.packham@alliedtelesis.co.nz>
References: <20201124043440.28400-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a port is configured with 'managed =3D "in-band-status"' switch chip=
s
like the 88E6390 need to propagate the SERDES link state to the MAC
because the link state is not correctly detected. This causes problems
on the 88E6185/88E6097 where the link partner won't see link state
changes because we're forcing the link.

To address this introduce a new device specific op port_sync_link() and
push the logic from mv88e6xxx_mac_link_up() into that. Provide an
implementation for the 88E6185 like devices which doesn't force the
link.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
Changes in v5:
- Update mv88e6xxx_mac_link_down code path
Changes in v4:
- Introduce new device op
- Remove review from Andrew as things have changed a lot
Changes in v3:
- None
Changes in v2:
- Add review from Andrew

 drivers/net/dsa/mv88e6xxx/chip.c | 35 +++++++++++++++++++++++++++----
 drivers/net/dsa/mv88e6xxx/chip.h |  4 ++++
 drivers/net/dsa/mv88e6xxx/port.c | 36 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h |  3 +++
 4 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
index e8258db8c21e..296932b2b80d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -727,8 +727,8 @@ static void mv88e6xxx_mac_link_down(struct dsa_switch=
 *ds, int port,
=20
 	mv88e6xxx_reg_lock(chip);
 	if ((!mv88e6xxx_port_ppu_updates(chip, port) ||
-	     mode =3D=3D MLO_AN_FIXED) && ops->port_set_link)
-		err =3D ops->port_set_link(chip, port, LINK_FORCED_DOWN);
+	     mode =3D=3D MLO_AN_FIXED) && ops->port_sync_link)
+		err =3D ops->port_sync_link(chip, port, mode, false);
 	mv88e6xxx_reg_unlock(chip);
=20
 	if (err)
@@ -768,8 +768,8 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *=
ds, int port,
 				goto error;
 		}
=20
-		if (ops->port_set_link)
-			err =3D ops->port_set_link(chip, port, LINK_FORCED_UP);
+		if (ops->port_sync_link)
+			err =3D ops->port_sync_link(chip, port, mode, true);
 	}
 error:
 	mv88e6xxx_reg_unlock(chip);
@@ -3210,6 +3210,7 @@ static const struct mv88e6xxx_ops mv88e6085_ops =3D=
 {
 	.phy_read =3D mv88e6185_phy_ppu_read,
 	.phy_write =3D mv88e6185_phy_ppu_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
 	.port_set_frame_mode =3D mv88e6351_port_set_frame_mode,
@@ -3249,6 +3250,7 @@ static const struct mv88e6xxx_ops mv88e6095_ops =3D=
 {
 	.phy_read =3D mv88e6185_phy_ppu_read,
 	.phy_write =3D mv88e6185_phy_ppu_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6185_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_set_frame_mode =3D mv88e6085_port_set_frame_mode,
 	.port_set_egress_floods =3D mv88e6185_port_set_egress_floods,
@@ -3279,6 +3281,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6185_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
 	.port_set_frame_mode =3D mv88e6351_port_set_frame_mode,
@@ -3317,6 +3320,7 @@ static const struct mv88e6xxx_ops mv88e6123_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_set_frame_mode =3D mv88e6085_port_set_frame_mode,
 	.port_set_egress_floods =3D mv88e6352_port_set_egress_floods,
@@ -3351,6 +3355,7 @@ static const struct mv88e6xxx_ops mv88e6131_ops =3D=
 {
 	.phy_read =3D mv88e6185_phy_ppu_read,
 	.phy_write =3D mv88e6185_phy_ppu_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
 	.port_set_frame_mode =3D mv88e6351_port_set_frame_mode,
@@ -3392,6 +3397,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6341_port_set_speed_duplex,
 	.port_max_speed_mode =3D mv88e6341_port_max_speed_mode,
@@ -3443,6 +3449,7 @@ static const struct mv88e6xxx_ops mv88e6161_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
 	.port_set_frame_mode =3D mv88e6351_port_set_frame_mode,
@@ -3484,6 +3491,7 @@ static const struct mv88e6xxx_ops mv88e6165_ops =3D=
 {
 	.phy_read =3D mv88e6165_phy_read,
 	.phy_write =3D mv88e6165_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_disable_learn_limit =3D mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override =3D mv88e6xxx_port_disable_pri_override,
@@ -3518,6 +3526,7 @@ static const struct mv88e6xxx_ops mv88e6171_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6352_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
@@ -3560,6 +3569,7 @@ static const struct mv88e6xxx_ops mv88e6172_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6352_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6352_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
@@ -3611,6 +3621,7 @@ static const struct mv88e6xxx_ops mv88e6175_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6352_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
@@ -3653,6 +3664,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6352_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6352_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
@@ -3706,6 +3718,7 @@ static const struct mv88e6xxx_ops mv88e6185_ops =3D=
 {
 	.phy_read =3D mv88e6185_phy_ppu_read,
 	.phy_write =3D mv88e6185_phy_ppu_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6185_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_set_frame_mode =3D mv88e6085_port_set_frame_mode,
 	.port_set_egress_floods =3D mv88e6185_port_set_egress_floods,
@@ -3743,6 +3756,7 @@ static const struct mv88e6xxx_ops mv88e6190_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6390_port_set_speed_duplex,
 	.port_max_speed_mode =3D mv88e6390_port_max_speed_mode,
@@ -3802,6 +3816,7 @@ static const struct mv88e6xxx_ops mv88e6190x_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6390x_port_set_speed_duplex,
 	.port_max_speed_mode =3D mv88e6390x_port_max_speed_mode,
@@ -3861,6 +3876,7 @@ static const struct mv88e6xxx_ops mv88e6191_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6390_port_set_speed_duplex,
 	.port_max_speed_mode =3D mv88e6390_port_max_speed_mode,
@@ -3920,6 +3936,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6352_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6352_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
@@ -3978,6 +3995,7 @@ static const struct mv88e6xxx_ops mv88e6250_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6352_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6250_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
@@ -4015,6 +4033,7 @@ static const struct mv88e6xxx_ops mv88e6290_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6390_port_set_speed_duplex,
 	.port_max_speed_mode =3D mv88e6390_port_max_speed_mode,
@@ -4076,6 +4095,7 @@ static const struct mv88e6xxx_ops mv88e6320_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
 	.port_set_frame_mode =3D mv88e6351_port_set_frame_mode,
@@ -4118,6 +4138,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
 	.port_set_frame_mode =3D mv88e6351_port_set_frame_mode,
@@ -4158,6 +4179,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6341_port_set_speed_duplex,
 	.port_max_speed_mode =3D mv88e6341_port_max_speed_mode,
@@ -4211,6 +4233,7 @@ static const struct mv88e6xxx_ops mv88e6350_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6352_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
@@ -4251,6 +4274,7 @@ static const struct mv88e6xxx_ops mv88e6351_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6352_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
@@ -4295,6 +4319,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6352_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6352_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
@@ -4355,6 +4380,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6390_port_set_speed_duplex,
 	.port_max_speed_mode =3D mv88e6390_port_max_speed_mode,
@@ -4418,6 +4444,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6390x_port_set_speed_duplex,
 	.port_max_speed_mode =3D mv88e6390x_port_max_speed_mode,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx=
/chip.h
index 7faa61b7f8f8..3543055bcb51 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -417,6 +417,10 @@ struct mv88e6xxx_ops {
 	 */
 	int (*port_set_link)(struct mv88e6xxx_chip *chip, int port, int link);
=20
+	/* Synchronise the port link state with that of the SERDES
+	 */
+	int (*port_sync_link)(struct mv88e6xxx_chip *chip, int port, unsigned i=
nt mode, bool isup);
+
 #define PAUSE_ON		1
 #define PAUSE_OFF		0
=20
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx=
/port.c
index 8128dc607cf4..77a5fd1798cd 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -162,6 +162,42 @@ int mv88e6xxx_port_set_link(struct mv88e6xxx_chip *c=
hip, int port, int link)
 	return 0;
 }
=20
+int mv88e6xxx_port_sync_link(struct mv88e6xxx_chip *chip, int port, unsi=
gned int mode, bool isup)
+{
+	const struct mv88e6xxx_ops *ops =3D chip->info->ops;
+	int err =3D 0;
+	int link;
+
+	if (isup)
+		link =3D LINK_FORCED_UP;
+	else
+		link =3D LINK_FORCED_DOWN;
+
+	if (ops->port_set_link)
+		err =3D ops->port_set_link(chip, port, link);
+
+	return err;
+}
+
+int mv88e6185_port_sync_link(struct mv88e6xxx_chip *chip, int port, unsi=
gned int mode, bool isup)
+{
+	const struct mv88e6xxx_ops *ops =3D chip->info->ops;
+	int err =3D 0;
+	int link;
+
+	if (mode =3D=3D MLO_AN_INBAND)
+		link =3D LINK_UNFORCED;
+	else if (isup)
+		link =3D LINK_FORCED_UP;
+	else
+		link =3D LINK_FORCED_DOWN;
+
+	if (ops->port_set_link)
+		err =3D ops->port_set_link(chip, port, link);
+
+	return err;
+}
+
 static int mv88e6xxx_port_set_speed_duplex(struct mv88e6xxx_chip *chip,
 					   int port, int speed, bool alt_bit,
 					   bool force_bit, int duplex)
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx=
/port.h
index 44d76ac973f6..500e1d4896ff 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -298,6 +298,9 @@ int mv88e6390_port_set_rgmii_delay(struct mv88e6xxx_c=
hip *chip, int port,
=20
 int mv88e6xxx_port_set_link(struct mv88e6xxx_chip *chip, int port, int l=
ink);
=20
+int mv88e6xxx_port_sync_link(struct mv88e6xxx_chip *chip, int port, unsi=
gned int mode, bool isup);
+int mv88e6185_port_sync_link(struct mv88e6xxx_chip *chip, int port, unsi=
gned int mode, bool isup);
+
 int mv88e6065_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int por=
t,
 				    int speed, int duplex);
 int mv88e6185_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int por=
t,
--=20
2.29.2

