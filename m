Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA955295611
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 03:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894698AbgJVBZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 21:25:24 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:37181 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442670AbgJVBZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 21:25:24 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 357CF891B0;
        Thu, 22 Oct 2020 14:25:19 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1603329919;
        bh=mESVuA+4wRNUh8+bS1Q0lqoxQHcyiLLjvLs0fHPvDlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=y/DOQq6frhwgXkLuoLoBREM2emn9IV9qz/Sn5Ki2cEwxKh7NdAtzHlIlYJOaO4/0v
         mmRnfpdMLEHKqpqlNIZScIAVmVnpH2Wv2pFlAudg6JZ5wMvmM64hgVB7+NX9IugCsn
         r2aDy9R9l+KdQFv/uIpOCCAI+pziTnFo0iCRGQec9pi/rnUC42d+9SC1y3gyN2CWdO
         XTsaCsuNrwZW6MrMc0+KVXkywx/KoVsCiz3IKNXc53vauhUiwMT5NeFyjQhO8gQux0
         wJD+gNvmK2/qpPkre2AI8daxn/gOMCa2cdda7tqIHxBbkHIkRc6gsDK5gF0UNfOml0
         r5Oj64x8WJfuA==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f90df800000>; Thu, 22 Oct 2020 14:25:20 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id BD49A13EEBB;
        Thu, 22 Oct 2020 14:25:17 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id EDF60283AAA; Thu, 22 Oct 2020 14:25:18 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 3/4] net: dsa: mv88e6xxx: Handle error in serdes_get_regs
Date:   Thu, 22 Oct 2020 14:25:14 +1300
Message-Id: <20201022012516.18720-4-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201022012516.18720-1-chris.packham@alliedtelesis.co.nz>
References: <20201022012516.18720-1-chris.packham@alliedtelesis.co.nz>
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
---
Changes in v4:
- new

 drivers/net/dsa/mv88e6xxx/serdes.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6x=
xx/serdes.c
index d4f40a739b17..ec9ca7210bb0 100644
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
@@ -1049,6 +1051,7 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_chi=
p *chip, int port, void *_p)
 	u16 *p =3D _p;
 	int lane;
 	u16 reg;
+	int err;
 	int i;
=20
 	lane =3D mv88e6xxx_serdes_get_lane(chip, port);
@@ -1056,8 +1059,9 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_chi=
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
2.28.0

