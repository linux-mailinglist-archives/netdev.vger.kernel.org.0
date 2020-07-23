Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E7422A657
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 06:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgGWEAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 00:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgGWD7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 23:59:53 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0391BC0619E6
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 20:59:53 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 70A28891B1;
        Thu, 23 Jul 2020 15:59:51 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1595476791;
        bh=+qu9Iy2eXnB+ehHD2h3/JL3cjBdzGF7zCj6jUY5803s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=1/OHxNEu9ZLOOWlsdelfl+m4jy0FRn/iaD5Uiq95+aMxV9pfyMktjUyzdI1leZGs7
         0H/jN+ecEjWDdFmDWOYEaRreUWa5SAZ/aGtz43uiV8VsU+L6g/kZLFm09Rpn9x9OCN
         ChEbtWnK9s0T51Zyy7lh+MMphg/eCBJ5gYavv2DFg1/EPFoiyffQ/nb4e4lUyXIocE
         DpMt4l6l4+tszcINI8onJJTw5HYgLfFGbYnKV+cFSTt2WZFFbmnZYhrkUMMPIXVerh
         XwRLpswxrJF7F0BeZ/nEn3bDsKyuXXhdU0PQnuhwYvqUeYceNgfwrJP1CjnORe/FdU
         KeJTJuv7cqzHA==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f190b380000>; Thu, 23 Jul 2020 15:59:52 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 058F413EEA1;
        Thu, 23 Jul 2020 15:59:50 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 33EDF280079; Thu, 23 Jul 2020 15:59:51 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 4/4] net: dsa: mv88e6xxx: Use chip-wide max frame size for MTU
Date:   Thu, 23 Jul 2020 15:59:42 +1200
Message-Id: <20200723035942.23988-5-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723035942.23988-1-chris.packham@alliedtelesis.co.nz>
References: <20200723035942.23988-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of the chips in the mv88e6xxx family don't support jumbo
configuration per port. But they do have a chip-wide max frame size that
can be used. Use this to approximate the behaviour of configuring a port
based MTU.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---

The only hardware I have access to uses a 88E6097. I've included the 6085=
, 6123
and 6185 based on reading the datasheets.

 drivers/net/dsa/mv88e6xxx/chip.c    |  9 +++++++++
 drivers/net/dsa/mv88e6xxx/chip.h    |  3 +++
 drivers/net/dsa/mv88e6xxx/global1.c | 17 +++++++++++++++++
 drivers/net/dsa/mv88e6xxx/global1.h |  2 ++
 4 files changed, 31 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
index 04e4a7291d14..836d7c894ef2 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2850,6 +2850,8 @@ static int mv88e6xxx_port_change_mtu(struct dsa_swi=
tch *ds, int port,
 	mv88e6xxx_reg_lock(chip);
 	if (chip->info->ops->port_set_jumbo_size)
 		err =3D chip->info->ops->port_set_jumbo_size(chip, port, new_mtu);
+	else if (chip->info->ops->set_max_frame_size)
+		err =3D chip->info->ops->set_max_frame_size(chip, new_mtu);
 	mv88e6xxx_reg_unlock(chip);
=20
 	return err;
@@ -2861,6 +2863,8 @@ static int mv88e6xxx_port_max_mtu(struct dsa_switch=
 *ds, int port)
=20
 	if (chip->info->ops->port_set_jumbo_size)
 		return 10240;
+	else if (chip->info->ops->set_max_frame_size)
+		return 1632;
=20
 	return 1518;
 }
@@ -3449,6 +3453,7 @@ static const struct mv88e6xxx_ops mv88e6085_ops =3D=
 {
 	.vtu_getnext =3D mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge =3D mv88e6352_g1_vtu_loadpurge,
 	.phylink_validate =3D mv88e6185_phylink_validate,
+	.set_max_frame_size =3D mv88e6185_g1_set_max_frame_size,
 };
=20
 static const struct mv88e6xxx_ops mv88e6095_ops =3D {
@@ -3477,6 +3482,7 @@ static const struct mv88e6xxx_ops mv88e6095_ops =3D=
 {
 	.vtu_getnext =3D mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge =3D mv88e6185_g1_vtu_loadpurge,
 	.phylink_validate =3D mv88e6185_phylink_validate,
+	.set_max_frame_size =3D mv88e6185_g1_set_max_frame_size,
 };
=20
 static const struct mv88e6xxx_ops mv88e6097_ops =3D {
@@ -3514,6 +3520,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops =3D=
 {
 	.vtu_getnext =3D mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge =3D mv88e6352_g1_vtu_loadpurge,
 	.phylink_validate =3D mv88e6185_phylink_validate,
+	.set_max_frame_size =3D mv88e6185_g1_set_max_frame_size,
 };
=20
 static const struct mv88e6xxx_ops mv88e6123_ops =3D {
@@ -3548,6 +3555,7 @@ static const struct mv88e6xxx_ops mv88e6123_ops =3D=
 {
 	.vtu_getnext =3D mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge =3D mv88e6352_g1_vtu_loadpurge,
 	.phylink_validate =3D mv88e6185_phylink_validate,
+	.set_max_frame_size =3D mv88e6185_g1_set_max_frame_size,
 };
=20
 static const struct mv88e6xxx_ops mv88e6131_ops =3D {
@@ -3937,6 +3945,7 @@ static const struct mv88e6xxx_ops mv88e6185_ops =3D=
 {
 	.vtu_getnext =3D mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge =3D mv88e6185_g1_vtu_loadpurge,
 	.phylink_validate =3D mv88e6185_phylink_validate,
+	.set_max_frame_size =3D mv88e6185_g1_set_max_frame_size,
 };
=20
 static const struct mv88e6xxx_ops mv88e6190_ops =3D {
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx=
/chip.h
index e5430cf2ad71..f9faf48139e0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -552,6 +552,9 @@ struct mv88e6xxx_ops {
 	void (*phylink_validate)(struct mv88e6xxx_chip *chip, int port,
 				 unsigned long *mask,
 				 struct phylink_link_state *state);
+
+	/* Max Frame Size */
+	int (*set_max_frame_size)(struct mv88e6xxx_chip *chip, int mtu);
 };
=20
 struct mv88e6xxx_irq_ops {
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6=
xxx/global1.c
index ca3a7a7a73c3..f62aa83ca08d 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -196,6 +196,23 @@ int mv88e6185_g1_ppu_disable(struct mv88e6xxx_chip *=
chip)
 	return mv88e6185_g1_wait_ppu_disabled(chip);
 }
=20
+int mv88e6185_g1_set_max_frame_size(struct mv88e6xxx_chip *chip, int mtu=
)
+{
+	u16 val;
+	int err;
+
+	err =3D mv88e6xxx_g1_read(chip, MV88E6XXX_G1_CTL1, &val);
+	if (err)
+		return err;
+
+	val &=3D ~MV88E6185_G1_CTL1_MAX_FRAME_1632;
+
+	if (mtu > 1518)
+		val |=3D MV88E6185_G1_CTL1_MAX_FRAME_1632;
+
+	return mv88e6xxx_g1_write(chip, MV88E6XXX_G1_CTL1, val);
+}
+
 /* Offset 0x10: IP-PRI Mapping Register 0
  * Offset 0x11: IP-PRI Mapping Register 1
  * Offset 0x12: IP-PRI Mapping Register 2
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6=
xxx/global1.h
index 5324c6f4ae90..1e3546f8b072 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -282,6 +282,8 @@ int mv88e6250_g1_reset(struct mv88e6xxx_chip *chip);
 int mv88e6185_g1_ppu_enable(struct mv88e6xxx_chip *chip);
 int mv88e6185_g1_ppu_disable(struct mv88e6xxx_chip *chip);
=20
+int mv88e6185_g1_set_max_frame_size(struct mv88e6xxx_chip *chip, int mtu=
);
+
 int mv88e6xxx_g1_stats_snapshot(struct mv88e6xxx_chip *chip, int port);
 int mv88e6320_g1_stats_snapshot(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_g1_stats_snapshot(struct mv88e6xxx_chip *chip, int port);
--=20
2.27.0

