Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D392C1CC6
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 05:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbgKXEfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 23:35:07 -0500
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:58968 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728898AbgKXEeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 23:34:50 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id AC38C891B0;
        Tue, 24 Nov 2020 17:34:47 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1606192487;
        bh=iCf6CouTHLrAGO3ba+fPueaNsgs8ZDrvSCWyQyadSMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=JrxrEtx7HWGHSFqrr4atHDXQ1Be4ax2PXb7pud7alAPpLhaUp4tpzTedad3x4V1yb
         J5v2d68EO6vhNlSmAY7AVK0+XYRnTB+KcUG4Q2foefHgtur+gy96jkaoEmsmQAhr1h
         FkYaioEUOCvx++l0ETvpdZ7VhgEt7lVmo2AtF3RKXdcOJEWa48p14wCk6pKI1lBbEW
         K5C5Ze1tNpF29B0Y+vMDZoNmBi1Hsg4rnc0rroVF2A1LSGZ6qMJpJhdPNhkIVU8oj+
         otB4l20T9w2965n6lxJsKFjoVTR4uTvb7kkeOrsiASXtBOU9evHIsOYjOe/oV4WCAS
         IN/A3JnN4hfiA==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5fbc8d650001>; Tue, 24 Nov 2020 17:34:47 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id DEB8F13EFA5;
        Tue, 24 Nov 2020 17:34:44 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id ADA142800AA; Tue, 24 Nov 2020 17:34:45 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, pavana.sharma@digi.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [net-next PATCH v5 3/4] net: dsa: mv88e6xxx: Add serdes interrupt support for MV88E6097
Date:   Tue, 24 Nov 2020 17:34:39 +1300
Message-Id: <20201124043440.28400-4-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201124043440.28400-1-chris.packham@alliedtelesis.co.nz>
References: <20201124043440.28400-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MV88E6097 presents the serdes interrupts for ports 8 and 9 via the
Switch Global 2 registers. There is no additional layer of
enablinh/disabling the serdes interrupts like other mv88e6xxx switches.
Even though most of the serdes behaviour is the same as the MV88E6185
that chip does not provide interrupts for serdes events so unlike
earlier commits the functions added here are specific to the MV88E6097.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
Changes in v5:
- New

 drivers/net/dsa/mv88e6xxx/chip.c   |  3 ++
 drivers/net/dsa/mv88e6xxx/serdes.c | 47 ++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h |  4 +++
 3 files changed, 54 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
index 545eb9c6c3fc..e7f68ac0c7e3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3308,6 +3308,9 @@ static const struct mv88e6xxx_ops mv88e6097_ops =3D=
 {
 	.serdes_power =3D mv88e6185_serdes_power,
 	.serdes_get_lane =3D mv88e6185_serdes_get_lane,
 	.serdes_pcs_get_state =3D mv88e6185_serdes_pcs_get_state,
+	.serdes_irq_mapping =3D mv88e6390_serdes_irq_mapping,
+	.serdes_irq_enable =3D mv88e6097_serdes_irq_enable,
+	.serdes_irq_status =3D mv88e6097_serdes_irq_status,
 	.pot_clear =3D mv88e6xxx_g2_pot_clear,
 	.reset =3D mv88e6352_g1_reset,
 	.rmu_disable =3D mv88e6085_g1_rmu_disable,
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6x=
xx/serdes.c
index d4f40a739b17..e60e8f0d0225 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -490,6 +490,53 @@ int mv88e6185_serdes_pcs_get_state(struct mv88e6xxx_=
chip *chip, int port,
 	return 0;
 }
=20
+int mv88e6097_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u=
8 lane,
+				bool enable)
+{
+	u8 cmode =3D chip->ports[port].cmode;
+
+	/* The serdes interrupts are enabled in the G2_INT_MASK register. We
+	 * need to return 0 to avoid returning -EOPNOTSUPP in
+	 * mv88e6xxx_serdes_irq_enable/mv88e6xxx_serdes_irq_disable
+	 */
+	switch (cmode) {
+	case MV88E6185_PORT_STS_CMODE_SERDES:
+	case MV88E6185_PORT_STS_CMODE_1000BASE_X:
+		return 0;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static void mv88e6097_serdes_irq_link(struct mv88e6xxx_chip *chip, int p=
ort)
+{
+	u16 status;
+	int err;
+
+	err =3D mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &status);
+	if (err) {
+		dev_err(chip->dev, "can't read port status: %d\n", err);
+		return;
+	}
+
+	dsa_port_phylink_mac_change(chip->ds, port, !!(status & MV88E6XXX_PORT_=
STS_LINK));
+}
+
+irqreturn_t mv88e6097_serdes_irq_status(struct mv88e6xxx_chip *chip, int=
 port,
+					u8 lane)
+{
+	u8 cmode =3D chip->ports[port].cmode;
+
+	switch (cmode) {
+	case MV88E6185_PORT_STS_CMODE_SERDES:
+	case MV88E6185_PORT_STS_CMODE_1000BASE_X:
+		mv88e6097_serdes_irq_link(chip, port);
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
 u8 mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	u8 cmode =3D chip->ports[port].cmode;
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6x=
xx/serdes.h
index c24ec4122c9e..93822ef9bab8 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -110,10 +110,14 @@ int mv88e6352_serdes_power(struct mv88e6xxx_chip *c=
hip, int port, u8 lane,
 			   bool on);
 int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lan=
e,
 			   bool on);
+int mv88e6097_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u=
8 lane,
+				bool enable);
 int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u=
8 lane,
 				bool enable);
 int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u=
8 lane,
 				bool enable);
+irqreturn_t mv88e6097_serdes_irq_status(struct mv88e6xxx_chip *chip, int=
 port,
+					u8 lane);
 irqreturn_t mv88e6352_serdes_irq_status(struct mv88e6xxx_chip *chip, int=
 port,
 					u8 lane);
 irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int=
 port,
--=20
2.29.2

