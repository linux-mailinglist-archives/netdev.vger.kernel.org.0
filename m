Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFA022A654
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 06:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgGWD7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 23:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgGWD7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 23:59:53 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE61C0619E5
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 20:59:52 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 15626891B0;
        Thu, 23 Jul 2020 15:59:51 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1595476791;
        bh=5ZZqKBnsOz8V+DUdHLkNrk+2ojHCMSG9gyVpz6EyGNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=xoRgPmKM/vQfLgEznJx6Yj1aDnyumpc8wnybuG5Rsv94IBOtr8Md2pwOd85/u7rpy
         e6IcdHqvIOZy/5FaK2MnUrobvpT71mGaIpUiNqBRdA1NYVxF7xmCtUAME2Ztu/Vl5F
         9CcWxnWB8dV3Pcfy58xcAX3Ucpd0pd++Rp4RTzleipTEESwIp8teyhviujSgBkiMpV
         TunCUbVUhUs6FrGqrpf4JBi3rLQChLZhdQbSwqNuHbrTzQ3FGs3vhem/FoJ6pi3vhg
         M4xHsjxHsumxgDeEMBgLVlOjL53WLcd6k+Q+4pWuujJGpxVF/E0hi5EMgFllKn76Cx
         rUY36u27qdedg==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f190b370002>; Thu, 23 Jul 2020 15:59:51 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id BAE8C13EEA1;
        Thu, 23 Jul 2020 15:59:49 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id EAEFB280079; Thu, 23 Jul 2020 15:59:50 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 3/4] net: dsa: mv88e6xxx: Implement .port_change_mtu/.port_max_mtu
Date:   Thu, 23 Jul 2020 15:59:41 +1200
Message-Id: <20200723035942.23988-4-chris.packham@alliedtelesis.co.nz>
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

Add implementations for the mv88e6xxx switches to connect with the
generic dsa operations for configuring the port MTU.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
index c2a4ac99545d..04e4a7291d14 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2841,6 +2841,30 @@ static int mv88e6xxx_devlink_param_set(struct dsa_=
switch *ds, u32 id,
 	return err;
 }
=20
+static int mv88e6xxx_port_change_mtu(struct dsa_switch *ds, int port,
+				     int new_mtu)
+{
+	struct mv88e6xxx_chip *chip =3D ds->priv;
+	int err =3D -EOPNOTSUPP;
+
+	mv88e6xxx_reg_lock(chip);
+	if (chip->info->ops->port_set_jumbo_size)
+		err =3D chip->info->ops->port_set_jumbo_size(chip, port, new_mtu);
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
+static int mv88e6xxx_port_max_mtu(struct dsa_switch *ds, int port)
+{
+	struct mv88e6xxx_chip *chip =3D ds->priv;
+
+	if (chip->info->ops->port_set_jumbo_size)
+		return 10240;
+
+	return 1518;
+}
+
 static const struct devlink_param mv88e6xxx_devlink_params[] =3D {
 	DSA_DEVLINK_PARAM_DRIVER(MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH,
 				 "ATU_hash", DEVLINK_PARAM_TYPE_U8,
@@ -5562,6 +5586,8 @@ static const struct dsa_switch_ops mv88e6xxx_switch=
_ops =3D {
 	.get_ts_info		=3D mv88e6xxx_get_ts_info,
 	.devlink_param_get	=3D mv88e6xxx_devlink_param_get,
 	.devlink_param_set	=3D mv88e6xxx_devlink_param_set,
+	.port_change_mtu	=3D mv88e6xxx_port_change_mtu,
+	.port_max_mtu		=3D mv88e6xxx_port_max_mtu,
 };
=20
 static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
--=20
2.27.0

