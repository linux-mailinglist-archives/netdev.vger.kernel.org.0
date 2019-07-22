Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C592470D73
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 01:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731177AbfGVXhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 19:37:31 -0400
Received: from mail-eopbgr10100.outbound.protection.outlook.com ([40.107.1.100]:3072
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727157AbfGVXhb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 19:37:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHUN8NMEf0QoMOJfs+fCc2PQOMSK+JMHIEUoKu5XQnuo1CsPmjc/40lyaE0i4iuBbXoyDmrcvyqvs+zjpPYGT2v2OvL9KpXEOLtYBgE7taHh7Cok2A9zsFpwHnjz5cWfw3nZehP2OsHQ7H99YR//EqvvHBe1IGT5WNwAJKb3dV0Ewolf8An5wZuk0KqifbIWYOMD6R+/7s1zauwdTO40f1D3Rgkw5pMt9Shtipq3MXp6LSnkWE+aXGAlNHqDGggk3Ehhh375bh61ZMFxwomN+qei6gbeOPR0nyLJEZjF6Psdca+cltOpxcVNSBiJX4ZMRlUDj7/d1FeMSx22eUdwBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xf1y9NnJPfLfpGCw7T86Mfp07+a9O1k9qAw2U/lmaGI=;
 b=IExPE4ovFs4jvIBENidAjzHYOBzqftvHGcsXaE0Zgfl76vnHBZGSIpMDDqxH18WfUA7PNkyU6hkTMZutM7yOj2GlDfV5qSzmSacC5bRweZm64Mb0Lm6/9Kpj6Cd3kZnRsrmnAaGFjkZnijMaqeeeZP+oyMq+9GJPnuS941n5eMclbwReFX8bvMcwFfGfldva3T6OsMW8vPcpFGywOmnzDYkSH8V9m29KnKuHPMbYy3/vsi/QwJdXxUh/sG/dLEyDxMn8vWOl6BIAlVyX8YZsdWUP2/RdfG4bFDZcaF03DR5MajXrDCiV4PW+OaVn+t4bSEfJWalbvr2yPJetbVKDcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=prevas.se;dmarc=pass action=none
 header.from=prevas.dk;dkim=pass header.d=prevas.dk;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xf1y9NnJPfLfpGCw7T86Mfp07+a9O1k9qAw2U/lmaGI=;
 b=BnpxOcMD1aPjIBIJt0F/jQKYybTSP00sBXRStJwkbFcAQ2zztO4Q9eYTnNQhN6QQ6pIcZS9yxLe9wdIVEZeDQoy3VHAj9e9V3Lrni+7Nd/qe9hM4zlNaJoEWpUnN/OYvUyZVLPg7HQ4GTbJVrlyHZV7JtSO1Amm2rZlxR8gK498=
Received: from AM0PR10MB3476.EURPRD10.PROD.OUTLOOK.COM (10.186.175.83) by
 AM0PR10MB3617.EURPRD10.PROD.OUTLOOK.COM (10.186.175.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Mon, 22 Jul 2019 23:37:26 +0000
Received: from AM0PR10MB3476.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9451:861a:85cc:daa0]) by AM0PR10MB3476.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9451:861a:85cc:daa0%2]) with mapi id 15.20.2094.017; Mon, 22 Jul 2019
 23:37:26 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: avoid some redundant vtu
 load/purge operations
Thread-Topic: [PATCH net-next] net: dsa: mv88e6xxx: avoid some redundant vtu
 load/purge operations
Thread-Index: AQHVQOZrz5Mh4qk+xE+98wWJgclwEQ==
Date:   Mon, 22 Jul 2019 23:37:26 +0000
Message-ID: <20190722233713.31396-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5P194CA0017.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::27) To AM0PR10MB3476.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:15e::19)
x-mailer: git-send-email 2.20.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [5.186.115.35]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2abd304-0cfd-4639-e029-08d70efd8dd3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM0PR10MB3617;
x-ms-traffictypediagnostic: AM0PR10MB3617:
x-microsoft-antispam-prvs: <AM0PR10MB361770CD9B83E5667E63B4BF8AC40@AM0PR10MB3617.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:513;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(366004)(39850400004)(136003)(346002)(189003)(199004)(42882007)(476003)(66066001)(5660300002)(8676002)(2616005)(53936002)(36756003)(305945005)(508600001)(26005)(186003)(6512007)(7736002)(25786009)(6436002)(14454004)(386003)(102836004)(71446004)(6486002)(6506007)(68736007)(4326008)(52116002)(6116002)(486006)(71190400001)(316002)(66446008)(66476007)(256004)(14444005)(99286004)(44832011)(1076003)(66946007)(64756008)(66556008)(71200400001)(2906002)(81156014)(81166006)(8936002)(50226002)(54906003)(110136005)(8976002)(3846002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR10MB3617;H:AM0PR10MB3476.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: soRwpb58/sEF1fsGWv561DRZSpYziYhKCP5tajoX5j8OafUcf3VdnVAQjmzCC2R9eYGS2saH1GBjZDEjjnBPspbhSOSQLE/UB6BIUVQCRfGGC502H64T25WbTEe4spB3JcqyMndbOWS8buHe06b+ildjXw2dyk3juID/bkCOf+CkxGCDFg20UBUf/x1CVhZtXka69dI3xiQRk1ZNpaFR4pO6OFCGHHqLWGBrIW8mHyqBdSncPkyLAACktBzHLl2bx0YH0URXpMWfq/Dr9g8KhgpzJ+jopMxkJ0F7dGWX/aLcakxugbU7sRWSEmLK3WiyfKUi7wnbr3QHb28dnuzxOmCuWaNG6Mdm98gcwVSGUMsMCD+4uwDzlHxkRrxhX8Z7krCOnJc5WLM3D+r0DQWBLkRq5/BpJjWJSoYUviVIlfo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: b2abd304-0cfd-4639-e029-08d70efd8dd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 23:37:26.7293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3617
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have an ERPS (Ethernet Ring Protection Switching) setup involving
mv88e6250 switches which we're in the process of switching to a BSP
based on the mainline driver. Breaking any link in the ring works as
expected, with the ring reconfiguring itself quickly and traffic
continuing with almost no noticable drops. However, when plugging back
the cable, we see 5+ second stalls.

This has been tracked down to the userspace application in charge of
the protocol missing a few CCM messages on the good link (the one that
was not unplugged), causing it to broadcast a "signal fail". That
message eventually reaches its link partner, which responds by
blocking the port. Meanwhile, the first node has continued to block
the port with the just plugged-in cable, breaking the network. And the
reason for those missing CCM messages has in turn been tracked down to
the VTU apparently being too busy servicing load/purge operations that
the normal lookups are delayed.

Initial state, the link between C and D is blocked in software.

     _____________________
    /                     \
   |                       |
   A ----- B ----- C *---- D

Unplug the cable between C and D.

     _____________________
    /                     \
   |                       |
   A ----- B ----- C *   * D

Reestablish the link between C and D.
     _____________________
    /                     \
   |                       |
   A ----- B ----- C *---- D

Somehow, enough VTU/ATU operations happen inside C that prevents
the application from receving the CCM messages from B in a timely
manner, so a Signal Fail message is sent by C. When B receives
that, it responds by blocking its port.

     _____________________
    /                     \
   |                       |
   A ----- B *---* C *---- D

Very shortly after this, the signal fail condition clears on the
BC link (some CCM messages finally make it through), so C
unblocks the port. However, a guard timer inside B prevents it
from removing the blocking before 5 seconds have elapsed.

It is not unlikely that our userspace ERPS implementation could be
smarter and/or is simply buggy. However, this patch fixes the symptoms
we see, and is a small optimization that should not break anything
(knock wood). The idea is simply to avoid doing an VTU load of an
entry identical to the one already present. To do that, we need to
know whether mv88e6xxx_vtu_get() actually found an existing entry, or
has just prepared a struct mv88e6xxx_vtu_entry for us to load. To that
end, let vlan->valid be an output parameter. The other two callers of
mv88e6xxx_vtu_get() are not affected by this patch since they pass
new=3Dfalse.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/c=
hip.c
index 6b17cd961d06..2e500428670c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1423,7 +1423,6 @@ static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *c=
hip, u16 vid,
=20
 		/* Initialize a fresh VLAN entry */
 		memset(entry, 0, sizeof(*entry));
-		entry->valid =3D true;
 		entry->vid =3D vid;
=20
 		/* Exclude all ports */
@@ -1618,6 +1617,9 @@ static int _mv88e6xxx_port_vlan_add(struct mv88e6xxx_=
chip *chip, int port,
 	if (err)
 		return err;
=20
+	if (vlan.valid && vlan.member[port] =3D=3D member)
+		return 0;
+	vlan.valid =3D true;
 	vlan.member[port] =3D member;
=20
 	err =3D mv88e6xxx_vtu_loadpurge(chip, &vlan);
--=20
2.20.1

