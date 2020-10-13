Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CC528C714
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 04:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbgJMCTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 22:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728559AbgJMCTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 22:19:09 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C35BC0613D6
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 19:19:08 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 90D81806B7;
        Tue, 13 Oct 2020 15:19:03 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1602555543;
        bh=99RErdQeBX7aXP21ejbYfxI9/mDXZ6suSRyQgbRiIVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=c2Zu9tlfQi95NSKIfmTgz3rVsLiBCxyigw515AP/uafnuzEbLWVs5seHftN07ebMf
         DNOPmZiOi+PZ9/N2hLRuHGWbhb20PtYTpusG8ZQoOq3/44VRTl39AB+iypHdurvZzE
         sas/KBgtkTFnwnAZbYDpuHAZTpnCkS35nFQ+/hz5bHcPWahAzPNe7ChkYlHMSaUAIa
         BdfyWCx9YIzXmitWKlnJUP4lN92fma4lJw/Blkaos60iTNwDHAJncWELspflxDxxvQ
         zcBEw78pUhoCJEZPIO8HVQSQcmChV+8yo2cttnfSaO/Y8fRqIullD37jP9toXrjPcu
         det3hkHC7ZQQg==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f850e960000>; Tue, 13 Oct 2020 15:19:02 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 48BBE13EEB7;
        Tue, 13 Oct 2020 15:19:02 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 7012C280063; Tue, 13 Oct 2020 15:19:03 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 1/2] net: dsa: mv88e6xxx: Don't force link when using in-band-status
Date:   Tue, 13 Oct 2020 15:18:57 +1300
Message-Id: <20201013021858.20530-2-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201013021858.20530-1-chris.packham@alliedtelesis.co.nz>
References: <20201013021858.20530-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a port is configured with 'managed =3D "in-band-status"' don't force
the link up, the switch MAC will detect the link status correctly.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
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

