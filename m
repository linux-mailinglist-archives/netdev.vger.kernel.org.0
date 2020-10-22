Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E0529560E
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 03:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894743AbgJVBZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 21:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2894708AbgJVBZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 21:25:25 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E97C0613CF
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 18:25:24 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 5E7A3891B1;
        Thu, 22 Oct 2020 14:25:19 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1603329919;
        bh=MfJt0rJ0799sDaipIQ4wgBS64UUty7YEQai2i/sCsv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=uwZzuxjKK0AReGXUUIelgS6AchBWRF4HJ1xzGpW+D1p2FdMFeUkdIlFQHm3RcFTYW
         bqO4qO8SkEYaE1fz5Wu7As83Jl0nYNt5NhmeKs2Tr5anES1jy369RKJSEcIq7HIgYI
         yQyyIrs4S0nhUUWUeuHObAoWzmfdzh/sDNruGbZ+/upimYfxAxZEAA0MrVEVfM+LwK
         s+PY9md0vdv42bCvYr8CDXEuc5/EdT1sdn2Wp9IblyJnaMi2kJAeyfSDdO1Er1zT6G
         VK/H2mV+KbDmDVl+1MnhwLrch9+QOWdRVfUfoTCgqa/AzKsQv4+OemwKuaTyxiQiQs
         IfVit43unDJ6g==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f90df800001>; Thu, 22 Oct 2020 14:25:20 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id F121E13EEBB;
        Thu, 22 Oct 2020 14:25:17 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 2D961283AAA; Thu, 22 Oct 2020 14:25:19 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 4/4] net: dsa: mv88e6xxx: Support serdes ports on MV88E6123/6131
Date:   Thu, 22 Oct 2020 14:25:15 +1300
Message-Id: <20201022012516.18720-5-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201022012516.18720-1-chris.packham@alliedtelesis.co.nz>
References: <20201022012516.18720-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement serdes_power, serdes_get_lane and serdes_pcs_get_state ops for
the MV88E6123 so that the ports without a built-in PHY supported as
serdes ports and directly connected to other network interfaces or to
SFPs. Also implement serdes_get_regs_len and serdes_get_regs to aid
future debugging.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
This is untested (apart from compilation) it assumes the SERDES "phy"
address corresponds to the port number but I'm not confident that is a
valid assumption.

Changes in v4:
- Error handling in mv88e6123_serdes_get_regs
Changes in v3:
- None
Changes in v2:
- new

 drivers/net/dsa/mv88e6xxx/chip.c   | 10 +++++++
 drivers/net/dsa/mv88e6xxx/serdes.c | 46 ++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h |  4 +++
 3 files changed, 60 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
index b582d98ca437..737416c666c1 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3575,6 +3575,11 @@ static const struct mv88e6xxx_ops mv88e6123_ops =3D=
 {
 	.set_egress_port =3D mv88e6095_g1_set_egress_port,
 	.watchdog_ops =3D &mv88e6097_watchdog_ops,
 	.mgmt_rsvd2cpu =3D mv88e6352_g2_mgmt_rsvd2cpu,
+	.serdes_power =3D mv88e6123_serdes_power,
+	.serdes_get_lane =3D mv88e6185_serdes_get_lane,
+	.serdes_pcs_get_state =3D mv88e6185_serdes_pcs_get_state,
+	.serdes_get_regs_len =3D mv88e6123_serdes_get_regs_len,
+	.serdes_get_regs =3D mv88e6123_serdes_get_regs,
 	.pot_clear =3D mv88e6xxx_g2_pot_clear,
 	.reset =3D mv88e6352_g1_reset,
 	.atu_get_hash =3D mv88e6165_g1_atu_get_hash,
@@ -3615,6 +3620,11 @@ static const struct mv88e6xxx_ops mv88e6131_ops =3D=
 {
 	.set_egress_port =3D mv88e6095_g1_set_egress_port,
 	.watchdog_ops =3D &mv88e6097_watchdog_ops,
 	.mgmt_rsvd2cpu =3D mv88e6185_g2_mgmt_rsvd2cpu,
+	.serdes_power =3D mv88e6123_serdes_power,
+	.serdes_get_lane =3D mv88e6185_serdes_get_lane,
+	.serdes_pcs_get_state =3D mv88e6185_serdes_pcs_get_state,
+	.serdes_get_regs_len =3D mv88e6123_serdes_get_regs_len,
+	.serdes_get_regs =3D mv88e6123_serdes_get_regs,
 	.ppu_enable =3D mv88e6185_g1_ppu_enable,
 	.set_cascade_port =3D mv88e6185_g1_set_cascade_port,
 	.ppu_disable =3D mv88e6185_g1_ppu_disable,
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6x=
xx/serdes.c
index ec9ca7210bb0..0e84d5c7be61 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -430,6 +430,52 @@ u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *=
chip, int port)
 	return lane;
 }
=20
+int mv88e6123_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lan=
e,
+			   bool up)
+{
+	u16 val, new_val;
+	int err;
+
+	err =3D mv88e6xxx_phy_read(chip, port, MII_BMCR, &val);
+	if (err)
+		return err;
+
+	if (up)
+		new_val =3D val & ~BMCR_PDOWN;
+	else
+		new_val =3D val | BMCR_PDOWN;
+
+	if (val !=3D new_val)
+		err =3D mv88e6xxx_phy_write(chip, port, MII_BMCR, val);
+
+	return err;
+}
+
+int mv88e6123_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port)
+{
+	if (mv88e6xxx_serdes_get_lane(chip, port) =3D=3D 0)
+		return 0;
+
+	return 26 * sizeof(u16);
+}
+
+void mv88e6123_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, vo=
id *_p)
+{
+	u16 *p =3D _p;
+	u16 reg;
+	int err;
+	int i;
+
+	if (mv88e6xxx_serdes_get_lane(chip, port) =3D=3D 0)
+		return;
+
+	for (i =3D 0; i < 26; i++) {
+		err =3D mv88e6xxx_phy_read(chip, port, i, &reg);
+		if (!err)
+			p[i] =3D reg;
+	}
+}
+
 int mv88e6185_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lan=
e,
 			   bool up)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6x=
xx/serdes.h
index c24ec4122c9e..b573139928c4 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -104,6 +104,8 @@ unsigned int mv88e6352_serdes_irq_mapping(struct mv88=
e6xxx_chip *chip,
 					  int port);
 unsigned int mv88e6390_serdes_irq_mapping(struct mv88e6xxx_chip *chip,
 					  int port);
+int mv88e6123_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lan=
e,
+			   bool up);
 int mv88e6185_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lan=
e,
 			   bool up);
 int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lan=
e,
@@ -129,6 +131,8 @@ int mv88e6390_serdes_get_strings(struct mv88e6xxx_chi=
p *chip,
 int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 			       uint64_t *data);
=20
+int mv88e6123_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port)=
;
+void mv88e6123_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, vo=
id *_p);
 int mv88e6352_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port)=
;
 void mv88e6352_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, vo=
id *_p);
 int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port)=
;
--=20
2.28.0

