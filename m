Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468DC2933B8
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 05:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391271AbgJTDqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 23:46:24 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:33474 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391204AbgJTDqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 23:46:06 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 65339891B0;
        Tue, 20 Oct 2020 16:46:03 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1603165563;
        bh=qX3g2P73J5MkYVS6EMfPePjP/p6o1Fj6TLS7Z60Wzts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ToA2cHTv7Dgxyj1jBcgzIHb3d+eMERTH/TtqgJb0cAQI3PzBHyWw47VfnvzIWspsr
         sgKGGrmw5F+TmiCOpQ48ac+F2qy4FMlbm5cExdiDOAeBu4mJGbPG+4bE/+V0y0FXAb
         mjxSN0j90+knnfA96G45+9LYHVdQSo0zy8fZRuGAkUvSekNabmTMxY6uA081UZIt8P
         f4m/zk41SzgKSzl61RldbHfHfxytyPau6RItyy712Nmn3DqnSeWHi5TUaByfhW62OW
         q3QfwayEQPcQm9x1SdaQMolR9LwS8VHEqzQi1Loj7/VxHyT65UYHDyemQ00bhucG8x
         7K/nBzm+bNy+A==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f8e5d7b0000>; Tue, 20 Oct 2020 16:46:03 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id D9F9813EEBB;
        Tue, 20 Oct 2020 16:46:02 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 2FAAF283A9C; Tue, 20 Oct 2020 16:46:03 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v3 3/3] net: dsa: mv88e6xxx: Support serdes ports on MV88E6123/6131
Date:   Tue, 20 Oct 2020 16:45:58 +1300
Message-Id: <20201020034558.19438-4-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201020034558.19438-1-chris.packham@alliedtelesis.co.nz>
References: <20201020034558.19438-1-chris.packham@alliedtelesis.co.nz>
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

Changes in v3:
- None
Changes in v2:
- new

 drivers/net/dsa/mv88e6xxx/chip.c   | 10 +++++++
 drivers/net/dsa/mv88e6xxx/serdes.c | 44 ++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h |  4 +++
 3 files changed, 58 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
index 62d4d7b5d9ac..5344fc84b03e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3574,6 +3574,11 @@ static const struct mv88e6xxx_ops mv88e6123_ops =3D=
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
@@ -3613,6 +3618,11 @@ static const struct mv88e6xxx_ops mv88e6131_ops =3D=
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
index d4f40a739b17..eb89debbf576 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -428,6 +428,50 @@ u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *=
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
+	int i;
+
+	if (mv88e6xxx_serdes_get_lane(chip, port) =3D=3D 0)
+		return;
+
+	for (i =3D 0; i < 26; i++) {
+		mv88e6xxx_phy_read(chip, port, i, &reg);
+		p[i] =3D reg;
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

