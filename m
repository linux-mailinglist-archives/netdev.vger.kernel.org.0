Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBBE2C1CBE
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 05:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgKXEev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 23:34:51 -0500
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:58973 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728906AbgKXEeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 23:34:50 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id BB896891B1;
        Tue, 24 Nov 2020 17:34:47 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1606192487;
        bh=niRNuez+BZjGyO7OLyzNRcGU9m4X7Fzz+jkM3Ru2y74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=H4TlKNioucwoGn5y/zPILyLPsvIxkKWnrFiF5Hh5HFO527HTs/YMGP3PUu9T/kR49
         b6M5Jly4Fe69C2aK9RCk/54VyhkXMSF+A0ZTZtfc5ZKd1lrLalfRaPue6KBmuPN03e
         gPVMDedoIrqJWIzrOCi3fdfPDjmsKwEqUTTZjHJpM3bmuVcalRxBeF63QSmif86BoZ
         pv8sN1ayWMA0hK2RTx/e4jnWrNm9GHimXJi6WhChr9KiQxqVhnrT2gx70ytuitxL1D
         Pt16h5WZV2pTbWb7XLnQaWl04jgFBZ2+DJHQ1AkqLJP2reoaHX2MWeq/MtaK00qV2n
         XPTnuIFmQRHig==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5fbc8d650002>; Tue, 24 Nov 2020 17:34:47 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 0C32D13EFA7;
        Tue, 24 Nov 2020 17:34:45 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id CF4A12800AA; Tue, 24 Nov 2020 17:34:45 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, pavana.sharma@digi.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [net-next PATCH v5 4/4] net: dsa: mv88e6xxx: Handle error in serdes_get_regs
Date:   Tue, 24 Nov 2020 17:34:40 +1300
Message-Id: <20201124043440.28400-5-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201124043440.28400-1-chris.packham@alliedtelesis.co.nz>
References: <20201124043440.28400-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the underlying read operation failed we would end up writing stale
data to the supplied buffer. This would end up with the last
successfully read value repeating. Fix this by only writing the data
when we know the read was good. This will mean that failed values will
return 0xffff.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v5:
- Add review from Andrew.
Changes in v4:
- new

 drivers/net/dsa/mv88e6xxx/serdes.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6x=
xx/serdes.c
index e60e8f0d0225..3195936dc5be 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -400,14 +400,16 @@ void mv88e6352_serdes_get_regs(struct mv88e6xxx_chi=
p *chip, int port, void *_p)
 {
 	u16 *p =3D _p;
 	u16 reg;
+	int err;
 	int i;
=20
 	if (!mv88e6352_port_has_serdes(chip, port))
 		return;
=20
 	for (i =3D 0 ; i < 32; i++) {
-		mv88e6352_serdes_read(chip, i, &reg);
-		p[i] =3D reg;
+		err =3D mv88e6352_serdes_read(chip, i, &reg);
+		if (!err)
+			p[i] =3D reg;
 	}
 }
=20
@@ -1096,6 +1098,7 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_chi=
p *chip, int port, void *_p)
 	u16 *p =3D _p;
 	int lane;
 	u16 reg;
+	int err;
 	int i;
=20
 	lane =3D mv88e6xxx_serdes_get_lane(chip, port);
@@ -1103,8 +1106,9 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_chi=
p *chip, int port, void *_p)
 		return;
=20
 	for (i =3D 0 ; i < ARRAY_SIZE(mv88e6390_serdes_regs); i++) {
-		mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				      mv88e6390_serdes_regs[i], &reg);
-		p[i] =3D reg;
+		err =3D mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+					    mv88e6390_serdes_regs[i], &reg);
+		if (!err)
+			p[i] =3D reg;
 	}
 }
--=20
2.29.2

