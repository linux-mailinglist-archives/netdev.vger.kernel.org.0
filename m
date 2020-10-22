Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E7929560D
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 03:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894737AbgJVBZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 21:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2894707AbgJVBZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 21:25:25 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9585DC0613D2
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 18:25:24 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id ECFF5806B7;
        Thu, 22 Oct 2020 14:25:18 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1603329918;
        bh=DChVq/baJQUGjdlGXM/PlIA2ToNpGIV2Xz01tKmsxVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=tR7A9YWDOrmiU1ZBDy/TUzeDKgztNykaD4Z8Qq7ScVIk/m3CA5iI0FusPNY5lGYKJ
         Yn0Hr9qshujJ5DjKwhEsADEU0R0VwYClFUaxVqgN0GQbrH7q8mgekA1sZ0emCaoWLs
         i8hpZBQhBSiRUbyPNYkTFL1zj8PL5ZiPO1G0dSFY6SWaNN52ZTKbEsaPEz1ZzJUfNa
         BMHiArjxfyK3evOFHokeKI+BlZ9JwbQsu117jeY3yjf3mbodZSvY6xbqtD6Tc9UUAz
         jky5PzItNEekzLp0NWjHeKXOjJbA8E+dSP6JbD1b5WY6i0+FXTNJXC4y/JY83+BAwm
         BAvZxP2ii3b9A==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f90df7f0001>; Thu, 22 Oct 2020 14:25:19 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 63B8213EEBB;
        Thu, 22 Oct 2020 14:25:17 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 941F0283AAA; Thu, 22 Oct 2020 14:25:18 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 1/4] net: dsa: mv88e6xxx: Don't force link when using in-band-status
Date:   Thu, 22 Oct 2020 14:25:12 +1300
Message-Id: <20201022012516.18720-2-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201022012516.18720-1-chris.packham@alliedtelesis.co.nz>
References: <20201022012516.18720-1-chris.packham@alliedtelesis.co.nz>
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
on the 88E6185/88E6097 where the link partner won't see link link state
changes because we're forcing the link.

To address this introduce a new device specific op port_sync_link() and
push the logic from mv88e6xxx_mac_link_up() into that. Provide an
implementation for the 88E6185 like devices which doesn't force the
link.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
Changes in v4:
- Introduce new device op
- Remove review from Andrew as things have changed a lot
Changes in v3:
- None
Changes in v2:
- Add review from Andrew

 drivers/net/dsa/mv88e6xxx/chip.c | 31 +++++++++++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/chip.h |  4 ++++
 drivers/net/dsa/mv88e6xxx/port.c | 36 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h |  3 +++
 4 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
index f0dbc05e30a4..47d452136946 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -767,8 +767,8 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *=
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
@@ -3442,6 +3442,7 @@ static const struct mv88e6xxx_ops mv88e6085_ops =3D=
 {
 	.phy_read =3D mv88e6185_phy_ppu_read,
 	.phy_write =3D mv88e6185_phy_ppu_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
 	.port_set_frame_mode =3D mv88e6351_port_set_frame_mode,
@@ -3481,6 +3482,7 @@ static const struct mv88e6xxx_ops mv88e6095_ops =3D=
 {
 	.phy_read =3D mv88e6185_phy_ppu_read,
 	.phy_write =3D mv88e6185_phy_ppu_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6185_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_set_frame_mode =3D mv88e6085_port_set_frame_mode,
 	.port_set_egress_floods =3D mv88e6185_port_set_egress_floods,
@@ -3511,6 +3513,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6185_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
 	.port_set_frame_mode =3D mv88e6351_port_set_frame_mode,
@@ -3549,6 +3552,7 @@ static const struct mv88e6xxx_ops mv88e6123_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_set_frame_mode =3D mv88e6085_port_set_frame_mode,
 	.port_set_egress_floods =3D mv88e6352_port_set_egress_floods,
@@ -3583,6 +3587,7 @@ static const struct mv88e6xxx_ops mv88e6131_ops =3D=
 {
 	.phy_read =3D mv88e6185_phy_ppu_read,
 	.phy_write =3D mv88e6185_phy_ppu_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
 	.port_set_frame_mode =3D mv88e6351_port_set_frame_mode,
@@ -3624,6 +3629,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6341_port_set_speed_duplex,
 	.port_max_speed_mode =3D mv88e6341_port_max_speed_mode,
@@ -3675,6 +3681,7 @@ static const struct mv88e6xxx_ops mv88e6161_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
 	.port_set_frame_mode =3D mv88e6351_port_set_frame_mode,
@@ -3716,6 +3723,7 @@ static const struct mv88e6xxx_ops mv88e6165_ops =3D=
 {
 	.phy_read =3D mv88e6165_phy_read,
 	.phy_write =3D mv88e6165_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_disable_learn_limit =3D mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override =3D mv88e6xxx_port_disable_pri_override,
@@ -3750,6 +3758,7 @@ static const struct mv88e6xxx_ops mv88e6171_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6352_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
@@ -3792,6 +3801,7 @@ static const struct mv88e6xxx_ops mv88e6172_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6352_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6352_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
@@ -3843,6 +3853,7 @@ static const struct mv88e6xxx_ops mv88e6175_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6352_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
@@ -3885,6 +3896,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6352_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6352_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
@@ -3938,6 +3950,7 @@ static const struct mv88e6xxx_ops mv88e6185_ops =3D=
 {
 	.phy_read =3D mv88e6185_phy_ppu_read,
 	.phy_write =3D mv88e6185_phy_ppu_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6185_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_set_frame_mode =3D mv88e6085_port_set_frame_mode,
 	.port_set_egress_floods =3D mv88e6185_port_set_egress_floods,
@@ -3975,6 +3988,7 @@ static const struct mv88e6xxx_ops mv88e6190_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6390_port_set_speed_duplex,
 	.port_max_speed_mode =3D mv88e6390_port_max_speed_mode,
@@ -4034,6 +4048,7 @@ static const struct mv88e6xxx_ops mv88e6190x_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6390x_port_set_speed_duplex,
 	.port_max_speed_mode =3D mv88e6390x_port_max_speed_mode,
@@ -4093,6 +4108,7 @@ static const struct mv88e6xxx_ops mv88e6191_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6390_port_set_speed_duplex,
 	.port_max_speed_mode =3D mv88e6390_port_max_speed_mode,
@@ -4152,6 +4168,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6352_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6352_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
@@ -4210,6 +4227,7 @@ static const struct mv88e6xxx_ops mv88e6250_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6352_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6250_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
@@ -4247,6 +4265,7 @@ static const struct mv88e6xxx_ops mv88e6290_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6390_port_set_speed_duplex,
 	.port_max_speed_mode =3D mv88e6390_port_max_speed_mode,
@@ -4308,6 +4327,7 @@ static const struct mv88e6xxx_ops mv88e6320_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
 	.port_set_frame_mode =3D mv88e6351_port_set_frame_mode,
@@ -4350,6 +4370,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
 	.port_set_frame_mode =3D mv88e6351_port_set_frame_mode,
@@ -4390,6 +4411,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6341_port_set_speed_duplex,
 	.port_max_speed_mode =3D mv88e6341_port_max_speed_mode,
@@ -4443,6 +4465,7 @@ static const struct mv88e6xxx_ops mv88e6350_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6352_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
@@ -4483,6 +4506,7 @@ static const struct mv88e6xxx_ops mv88e6351_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6352_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6185_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
@@ -4527,6 +4551,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6352_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6352_port_set_speed_duplex,
 	.port_tag_remap =3D mv88e6095_port_tag_remap,
@@ -4587,6 +4612,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops =3D=
 {
 	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
 	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
 	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_sync_link =3D mv88e6xxx_port_sync_link,
 	.port_set_rgmii_delay =3D mv88e6390_port_set_rgmii_delay,
 	.port_set_speed_duplex =3D mv88e6390_port_set_speed_duplex,
 	.port_max_speed_mode =3D mv88e6390_port_max_speed_mode,
@@ -4650,6 +4676,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops =3D=
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
index 823ae89e5fca..62e4cf1d74b4 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -400,6 +400,10 @@ struct mv88e6xxx_ops {
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
index 8128dc607cf4..c9af0f5a7fde 100644
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
+	if (isup && mode =3D=3D MLO_AN_INBAND)
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
2.28.0

