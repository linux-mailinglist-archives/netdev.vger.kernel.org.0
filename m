Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88041292137
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 04:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731142AbgJSCoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 22:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730938AbgJSCoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 22:44:03 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB11C0613D5
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 19:44:02 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 9A8CE891B1;
        Mon, 19 Oct 2020 15:43:58 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1603075438;
        bh=pOlDkPSWcFe4t6wrAIwitt3Hp17azUV8YDn/AQFQBd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=P0Q/1t/31YyONgSpCT225L3uhvs2WgIO/DllJ/NIeWW4Zz3fPCl9u0WobUriaRQds
         4lDLXu5PGv0jd/8XJ75XiKJXWBeTAtoVmXKMh4/K05Yco/q8cfh9AuOYsJ7v0wrQ2S
         R0/hjRqYtF6D/outadYJKHkNGc7NlN0nxMmprEWrhZAkKueNPPR1mEf3G7AXKHvn2W
         9lR+9lwanbX3l1xgmk+L6psO1w93h2DmQJAeFAdbAxErl52ehGGUDdlNDvnJcMQS5G
         ogHJBP2u40rwFRGus2MGC+z7/Ig2edNqdwA0yuNXWVgOtSDPG/GeYuPmhRZh5B+KFl
         ctXw2UbH+RVbQ==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f8cfd6e0002>; Mon, 19 Oct 2020 15:43:58 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 3719A13EEB7;
        Mon, 19 Oct 2020 15:43:57 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 6202528006D; Mon, 19 Oct 2020 15:43:58 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v2 2/3] net: dsa: mv88e6xxx: Support serdes ports on MV88E6097/6095/6185
Date:   Mon, 19 Oct 2020 15:43:54 +1300
Message-Id: <20201019024355.30717-3-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201019024355.30717-1-chris.packham@alliedtelesis.co.nz>
References: <20201019024355.30717-1-chris.packham@alliedtelesis.co.nz>
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
---

Changes in v2:
- expand support to cover 6095 and 6185
- move serdes related code to serdes.c

 drivers/net/dsa/mv88e6xxx/chip.c   |  9 +++++
 drivers/net/dsa/mv88e6xxx/serdes.c | 58 ++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h |  5 +++
 3 files changed, 72 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
index 1ef392ee52c5..62d4d7b5d9ac 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3496,6 +3496,9 @@ static const struct mv88e6xxx_ops mv88e6095_ops =3D=
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
@@ -3534,6 +3537,9 @@ static const struct mv88e6xxx_ops mv88e6097_ops =3D=
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
@@ -3958,6 +3964,9 @@ static const struct mv88e6xxx_ops mv88e6185_ops =3D=
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
index 9c07b4f3d345..2d52c8ede943 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -428,6 +428,64 @@ u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *=
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
+	switch (chip->ports[port].cmode) {
+	case MV88E6185_PORT_STS_CMODE_SERDES:
+	case MV88E6185_PORT_STS_CMODE_1000BASE_X:
+		return 0xff; /* Unused */
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
2.28.0

