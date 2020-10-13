Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBF328C715
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 04:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgJMCTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 22:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728614AbgJMCTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 22:19:09 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0590EC0613D5
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 19:19:08 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id C4BDE80719;
        Tue, 13 Oct 2020 15:19:03 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1602555543;
        bh=OdeIKAlqwwGhfTCJ19xhIWD6JUilxHZP5/rj2zxthlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=jEQau7d6oW1zGaqPUqUDSxMfN4GsszHfERiV13TEMQzBGoGhppWj2hyNPWnwQep7M
         xMhLCp+GFL9/1JBIabCiLZUZH+iy3TT7RZlp6PrloJ2uPRD9D/pjlNmHmgcv48hBda
         OmFa0715pCtpx7hw7i0wo3FYlC3C3nmZ0PBpj70vTNQmjjNRttMz4M7BD49UCgNAbR
         efXF/5yEZoTibs0WgGOcflk71yOk/VvBs+vkdgTnN6D9Zt4RCSXGuwYYeYNmdAhKQR
         9lqizPtFjYKzUv/WrJ5qjKpWxmkvRixQo0fo+Z824xy1jYm6SFw+wu3L1n488lTvuP
         dZF45SEuaFdyg==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f850e960001>; Tue, 13 Oct 2020 15:19:02 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 6BAB913EEB7;
        Tue, 13 Oct 2020 15:19:02 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 930AC280063; Tue, 13 Oct 2020 15:19:03 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 2/2] net: dsa: mv88e6xxx: Support serdes ports on MV88E6097
Date:   Tue, 13 Oct 2020 15:18:58 +1300
Message-Id: <20201013021858.20530-3-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201013021858.20530-1-chris.packham@alliedtelesis.co.nz>
References: <20201013021858.20530-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement serdes_power, serdes_get_lane and serdes_pcs_get_state ops for
the MV88E6097 so that ports 8 & 9 can be supported as serdes ports and
directly connected to other network interfaces or to SFPs without a PHY.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---

This should be usable for all variants of the 88E6185 that have
tri-speed capable ports (which is why I used the mv88e6185 prefix
instead of mv88e6097). But my hardware only has a 88e6097 so I've only
connected up the ops for that chip.

 drivers/net/dsa/mv88e6xxx/chip.c | 61 ++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
index 1ef392ee52c5..1c6cd5c43eb1 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3436,6 +3436,64 @@ static int mv88e6xxx_set_eeprom(struct dsa_switch =
*ds,
 	return err;
 }
=20
+static int mv88e6185_serdes_power(struct mv88e6xxx_chip *chip, int port,=
 u8 lane,
+				  bool up)
+{
+	/* The serdes power can't be controlled on this switch chip but we need
+	 * to supply this function to avoid returning -EOPNOTSUPP in
+	 * mv88e6xxx_serdes_power_up/mv88e6xxx_serdes_power_down
+	 */
+	return 0;
+}
+
+static u8 mv88e6185_serdes_get_lane(struct mv88e6xxx_chip *chip, int por=
t)
+{
+	switch (chip->ports[port].cmode) {
+	case MV88E6185_PORT_STS_CMODE_SERDES:
+	case MV88E6185_PORT_STS_CMODE_1000BASE_X:
+		return port;
+	default:
+		return 0;
+	}
+}
+
+static int mv88e6185_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, i=
nt port,
+					  u8 lane, struct phylink_link_state *state)
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
 static const struct mv88e6xxx_ops mv88e6085_ops =3D {
 	/* MV88E6XXX_FAMILY_6097 */
 	.ieee_pri_map =3D mv88e6085_g1_ieee_pri_map,
@@ -3534,6 +3592,9 @@ static const struct mv88e6xxx_ops mv88e6097_ops =3D=
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
--=20
2.28.0

