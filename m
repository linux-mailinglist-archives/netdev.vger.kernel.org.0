Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB252933B2
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 05:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391222AbgJTDqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 23:46:07 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:33458 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391199AbgJTDqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 23:46:06 -0400
X-Greylist: delayed 90124 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2020 23:46:05 EDT
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id DD94C806B7;
        Tue, 20 Oct 2020 16:46:02 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1603165562;
        bh=DRng7TBazrBB0TH/cxu/re8Syh3uFw1RCXUxNX3nLHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Fn9aeH1L0aZwM1i+ct1HrPskOAJ+cfk9i2n+XUbgkRQt10iCK2Z26/Wkw4hP6vbnm
         kIL24ennOp4FcVwbyDLVxFXm1hQsNOS+pzXRvkBU7KTHNzmQCPHWxjdhQIGXNnYBA6
         eBdqk/P2hDxFerch4fwEcV8yzzFoG+3bhGVD5AvdHoiaTAtliAvY0qYO9RHl3k8+Cv
         tORb7+bC7pjZxzvgESWOJvJVeR5n34InCDOpjEp8Hxb1YCApFlH7PHXOEurbwKcfgv
         HRO6bRvwKTSX1oTlUYSS37nfJBe0If3h8x4ZrK7VzV1MJ6XmS7TSOecTH4UkEpU9lP
         qmJjgk9Egiihw==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f8e5d7a0001>; Tue, 20 Oct 2020 16:46:02 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 6E47213EEBB;
        Tue, 20 Oct 2020 16:46:02 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id B95D1283A9C; Tue, 20 Oct 2020 16:46:02 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v3 1/3] net: dsa: mv88e6xxx: Don't force link when using in-band-status
Date:   Tue, 20 Oct 2020 16:45:56 +1300
Message-Id: <20201020034558.19438-2-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201020034558.19438-1-chris.packham@alliedtelesis.co.nz>
References: <20201020034558.19438-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a port is configured with 'managed =3D "in-band-status"' don't force
the link up, the switch MAC will detect the link status correctly.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v3:
- None
Changes in v2:
- Add review from Andrew

 drivers/net/dsa/mv88e6xxx/chip.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
index f0dbc05e30a4..1ef392ee52c5 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -767,8 +767,11 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch =
*ds, int port,
 				goto error;
 		}
=20
-		if (ops->port_set_link)
-			err =3D ops->port_set_link(chip, port, LINK_FORCED_UP);
+		if (ops->port_set_link) {
+			int link =3D mode =3D=3D MLO_AN_INBAND ? LINK_UNFORCED : LINK_FORCED_=
UP;
+
+			err =3D ops->port_set_link(chip, port, link);
+		}
 	}
 error:
 	mv88e6xxx_reg_unlock(chip);
--=20
2.28.0

