Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DA12C1CC3
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 05:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbgKXEe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 23:34:59 -0500
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:58961 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728904AbgKXEev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 23:34:51 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 790BD891AE;
        Tue, 24 Nov 2020 17:34:47 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1606192487;
        bh=G5sq2vVDIrSno+g2Y0noNVDx0SanexzY29s2eUCZ7IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=WWuA00j8OfpPOHe6dLZ/+5UcPLGIg8Y/FBm6P77s4dCxfsN+pJtM811mnqXo8kBxV
         F3tE+wHs0nKNnvML2SsSSE2DHcqnUqBNh3jFX8DaKfFNERAaOQRl5R7A37GdSnGvvB
         ZGEHnUso4ex/FwwfEL8QrW1PsFmdSwpkqlam1Kp9SOVQLpbkgHMS6tQdcjuKLAyaAA
         EWuF4YsRORRSs8jl1GFIAdZr6QHB8SwQUQYT/NFytF6Jmkqc0AKJqA6q/Osa07f+Ov
         se7OzyaiSxEEbfPuL54d0biZrKmwHwkpEHT/269JanSSRrmsRjwWWvNFl7vgMpf3sM
         AcDG3IY5EPtgw==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5fbc8d650000>; Tue, 24 Nov 2020 17:34:46 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id AA1CF13EF9C;
        Tue, 24 Nov 2020 17:34:44 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 776392800AA; Tue, 24 Nov 2020 17:34:45 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, pavana.sharma@digi.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [net-next PATCH v5 2/4] net: dsa: mv88e6xxx: Support serdes ports on MV88E6097/6095/6185
Date:   Tue, 24 Nov 2020 17:34:38 +1300
Message-Id: <20201124043440.28400-3-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201124043440.28400-1-chris.packham@alliedtelesis.co.nz>
References: <20201124043440.28400-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement serdes_power, serdes_get_lane and serdes_pcs_get_state ops for
the MV88E6097/6095/6185 so that ports 8 & 9 can be supported as serdes
ports and directly connected to other network interfaces or to SFPs
without a PHY.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v5:
- None
Changes in v4:
- None
Changes in v3:
- Add comment to mv88e6185_serdes_get_lane
- Add review from Andrew
Changes in v2:
- expand support to cover 6095 and 6185
- move serdes related code to serdes.c

 drivers/net/dsa/mv88e6xxx/chip.c   |  9 +++++
 drivers/net/dsa/mv88e6xxx/serdes.c | 62 ++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h |  5 +++
 3 files changed, 76 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
index 296932b2b80d..545eb9c6c3fc 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3263,6 +3263,9 @@ static const struct mv88e6xxx_ops mv88e6095_ops =3D=
 {
 	.stats_get_strings =3D mv88e6095_stats_get_strings,
 	.stats_get_stats =3D mv88e6095_stats_get_stats,
 	.mgmt_rsvd2cpu =3D mv88e6185_g2_mgmt_rsvd2cpu,
+	.serdes_power =3D mv88e6185_serdes_power,
+	.serdes_get_lane =3D mv88e6185_serdes_get_lane,
+	.serdes_pcs_get_state =3D mv88e6185_serdes_pcs_get_state,
 	.ppu_enable =3D mv88e6185_g1_ppu_enable,
 	.ppu_disable =3D mv88e6185_g1_ppu_disable,
 	.reset =3D mv88e6185_g1_reset,
@@ -3302,6 +3305,9 @@ static const struct mv88e6xxx_ops mv88e6097_ops =3D=
 {
 	.set_egress_port =3D mv88e6095_g1_set_egress_port,
 	.watchdog_ops =3D &mv88e6097_watchdog_ops,
 	.mgmt_rsvd2cpu =3D mv88e6352_g2_mgmt_rsvd2cpu,
+	.serdes_power =3D mv88e6185_serdes_power,
+	.serdes_get_lane =3D mv88e6185_serdes_get_lane,
+	.serdes_pcs_get_state =3D mv88e6185_serdes_pcs_get_state,
 	.pot_clear =3D mv88e6xxx_g2_pot_clear,
 	.reset =3D mv88e6352_g1_reset,
 	.rmu_disable =3D mv88e6085_g1_rmu_disable,
@@ -3736,6 +3742,9 @@ static const struct mv88e6xxx_ops mv88e6185_ops =3D=
 {
 	.set_egress_port =3D mv88e6095_g1_set_egress_port,
 	.watchdog_ops =3D &mv88e6097_watchdog_ops,
 	.mgmt_rsvd2cpu =3D mv88e6185_g2_mgmt_rsvd2cpu,
+	.serdes_power =3D mv88e6185_serdes_power,
+	.serdes_get_lane =3D mv88e6185_serdes_get_lane,
+	.serdes_pcs_get_state =3D mv88e6185_serdes_pcs_get_state,
 	.set_cascade_port =3D mv88e6185_g1_set_cascade_port,
 	.ppu_enable =3D mv88e6185_g1_ppu_enable,
 	.ppu_disable =3D mv88e6185_g1_ppu_disable,
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6x=
xx/serdes.c
index 9c07b4f3d345..d4f40a739b17 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -428,6 +428,68 @@ u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *=
chip, int port)
 	return lane;
 }
=20
+int mv88e6185_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lan=
e,
+			   bool up)
+{
+	/* The serdes power can't be controlled on this switch chip but we need
+	 * to supply this function to avoid returning -EOPNOTSUPP in
+	 * mv88e6xxx_serdes_power_up/mv88e6xxx_serdes_power_down
+	 */
+	return 0;
+}
+
+u8 mv88e6185_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
+{
+	/* There are no configurable serdes lanes on this switch chip but we
+	 * need to return non-zero so that callers of
+	 * mv88e6xxx_serdes_get_lane() know this is a serdes port.
+	 */
+	switch (chip->ports[port].cmode) {
+	case MV88E6185_PORT_STS_CMODE_SERDES:
+	case MV88E6185_PORT_STS_CMODE_1000BASE_X:
+		return 0xff;
+	default:
+		return 0;
+	}
+}
+
+int mv88e6185_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port=
,
+				   u8 lane, struct phylink_link_state *state)
+{
+	int err;
+	u16 status;
+
+	err =3D mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &status);
+	if (err)
+		return err;
+
+	state->link =3D !!(status & MV88E6XXX_PORT_STS_LINK);
+
+	if (state->link) {
+		state->duplex =3D status & MV88E6XXX_PORT_STS_DUPLEX ? DUPLEX_FULL : D=
UPLEX_HALF;
+
+		switch (status &  MV88E6XXX_PORT_STS_SPEED_MASK) {
+		case MV88E6XXX_PORT_STS_SPEED_1000:
+			state->speed =3D SPEED_1000;
+			break;
+		case MV88E6XXX_PORT_STS_SPEED_100:
+			state->speed =3D SPEED_100;
+			break;
+		case MV88E6XXX_PORT_STS_SPEED_10:
+			state->speed =3D SPEED_10;
+			break;
+		default:
+			dev_err(chip->dev, "invalid PHY speed\n");
+			return -EINVAL;
+		}
+	} else {
+		state->duplex =3D DUPLEX_UNKNOWN;
+		state->speed =3D SPEED_UNKNOWN;
+	}
+
+	return 0;
+}
+
 u8 mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	u8 cmode =3D chip->ports[port].cmode;
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6x=
xx/serdes.h
index 14315f26228a..c24ec4122c9e 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -73,6 +73,7 @@
 #define MV88E6390_PG_CONTROL		0xf010
 #define MV88E6390_PG_CONTROL_ENABLE_PC		BIT(0)
=20
+u8 mv88e6185_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 u8 mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 u8 mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
@@ -85,6 +86,8 @@ int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *=
chip, int port,
 				u8 lane, unsigned int mode,
 				phy_interface_t interface,
 				const unsigned long *advertise);
+int mv88e6185_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port=
,
+				   u8 lane, struct phylink_link_state *state);
 int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port=
,
 				   u8 lane, struct phylink_link_state *state);
 int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port=
,
@@ -101,6 +104,8 @@ unsigned int mv88e6352_serdes_irq_mapping(struct mv88=
e6xxx_chip *chip,
 					  int port);
 unsigned int mv88e6390_serdes_irq_mapping(struct mv88e6xxx_chip *chip,
 					  int port);
+int mv88e6185_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lan=
e,
+			   bool up);
 int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lan=
e,
 			   bool on);
 int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lan=
e,
--=20
2.29.2

