Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0247B22BA26
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgGWXV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:21:27 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:46223 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbgGWXV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 19:21:27 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 9B089891B4;
        Fri, 24 Jul 2020 11:21:24 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1595546484;
        bh=ygJw+StLaLgK+RAsbex5A3XEplXxMiWAgkqunNF1oLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=eoWGRD1dVdycW3CfMFEfmrSyK6H21feyRCYMzb+z6Cf50Qx/i4lHzSlrvOFKioYh7
         9XmMHIPVKLmYn+zig+mfjVAuqm5WaxX9x9LARDxsgAWWinT01EvQJqgcfRx7KrcGfU
         clBlAEbhWt7785fquflx7jMH1skQIq8tLoX8TCGx9QKKRA7aoh0FNYs3aOZVCR6RWy
         0put+opCKgPdPu2OxYMBKhAtbojtQkNdYIAnu4Gx0B7QHy/h5NBkB7ebdtF6nKswP8
         nVez5eAO0frm7YnVAGvpRlWFbMQJWwx3qZC3+k6Lr38haPY4LhWF6jFyaYzA6xyoVk
         b6g9ZWH2J5nlQ==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f1a1b720004>; Fri, 24 Jul 2020 11:21:22 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 5246413EEB7;
        Fri, 24 Jul 2020 11:21:24 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 7C63D280079; Fri, 24 Jul 2020 11:21:24 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v2 3/3] net: dsa: mv88e6xxx: Use chip-wide max frame size for MTU
Date:   Fri, 24 Jul 2020 11:21:22 +1200
Message-Id: <20200723232122.5384-4-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723232122.5384-1-chris.packham@alliedtelesis.co.nz>
References: <20200723232122.5384-1-chris.packham@alliedtelesis.co.nz>
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

Changes in v2:
- Rebase on top of net-next/master

 drivers/net/dsa/mv88e6xxx/chip.c    |  9 +++++++++
 drivers/net/dsa/mv88e6xxx/chip.h    |  3 +++
 drivers/net/dsa/mv88e6xxx/global1.c | 17 +++++++++++++++++
 drivers/net/dsa/mv88e6xxx/global1.h |  2 ++
 4 files changed, 31 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
index 43a2ab8cf2c8..b8a3e8c88c07 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2699,6 +2699,8 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch =
*ds, int port)
=20
 	if (chip->info->ops->port_set_jumbo_size)
 		return 10240;
+	else if (chip->info->ops->set_max_frame_size)
+		return 1632;
 	return 1522;
 }
=20
@@ -2710,6 +2712,8 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *=
ds, int port, int new_mtu)
 	mv88e6xxx_reg_lock(chip);
 	if (chip->info->ops->port_set_jumbo_size)
 		ret =3D chip->info->ops->port_set_jumbo_size(chip, port, new_mtu);
+	else if (chip->info->ops->set_max_frame_size)
+		ret =3D chip->info->ops->set_max_frame_size(chip, new_mtu);
 	else
 		if (new_mtu > 1522)
 			ret =3D -EINVAL;
@@ -3450,6 +3454,7 @@ static const struct mv88e6xxx_ops mv88e6085_ops =3D=
 {
 	.vtu_getnext =3D mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge =3D mv88e6352_g1_vtu_loadpurge,
 	.phylink_validate =3D mv88e6185_phylink_validate,
+	.set_max_frame_size =3D mv88e6185_g1_set_max_frame_size,
 };
=20
 static const struct mv88e6xxx_ops mv88e6095_ops =3D {
@@ -3478,6 +3483,7 @@ static const struct mv88e6xxx_ops mv88e6095_ops =3D=
 {
 	.vtu_getnext =3D mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge =3D mv88e6185_g1_vtu_loadpurge,
 	.phylink_validate =3D mv88e6185_phylink_validate,
+	.set_max_frame_size =3D mv88e6185_g1_set_max_frame_size,
 };
=20
 static const struct mv88e6xxx_ops mv88e6097_ops =3D {
@@ -3515,6 +3521,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops =3D=
 {
 	.vtu_getnext =3D mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge =3D mv88e6352_g1_vtu_loadpurge,
 	.phylink_validate =3D mv88e6185_phylink_validate,
+	.set_max_frame_size =3D mv88e6185_g1_set_max_frame_size,
 };
=20
 static const struct mv88e6xxx_ops mv88e6123_ops =3D {
@@ -3549,6 +3556,7 @@ static const struct mv88e6xxx_ops mv88e6123_ops =3D=
 {
 	.vtu_getnext =3D mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge =3D mv88e6352_g1_vtu_loadpurge,
 	.phylink_validate =3D mv88e6185_phylink_validate,
+	.set_max_frame_size =3D mv88e6185_g1_set_max_frame_size,
 };
=20
 static const struct mv88e6xxx_ops mv88e6131_ops =3D {
@@ -3938,6 +3946,7 @@ static const struct mv88e6xxx_ops mv88e6185_ops =3D=
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
index 1c541b074256..2d70eac30e58 100644
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

