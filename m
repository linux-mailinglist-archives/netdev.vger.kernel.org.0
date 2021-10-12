Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1584C42ACA2
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 20:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbhJLSz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 14:55:56 -0400
Received: from mail-eopbgr1410102.outbound.protection.outlook.com ([40.107.141.102]:26208
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232684AbhJLSzz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 14:55:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGfzEtAfveiHzcvkC4cpMHmSkVeMu45ldlKHNA7ZURR15sJ+v+82OM2Y6Cv92uMPUazb4dLIiiG272dzlihddcbhIeK8kVmoX9fvZodHJFk02i4Lwn9y/hNPAH4D/vHJXnwSWYJVs6yyY786hs072bM/iK9rSjLNJoUuLrg3P3sl0CzdDZqTEseDbGKgQy5SRoEjM8o95wfrNS0RRTaytPp5s0f+YTNQncxp2zRdmeStuYoDyAt+vMhDW/+ew20rpCZ3+aBX7LfJiGQLh1wC9DlsmUxiFDhfnfRr4h5zpAurtCmx8HLTGPESyK6Znt8HOA4wanqjIrqzeCS03NYPuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+7r2cHSArT3jDP9S/skc+aiU1l1gR1eVS8G8zQV1CKo=;
 b=AiUPY4hFzbzQ62drlExy6/GllRMksxeIGVkNnIdtsJvJWGBSpevuWdMhNiOeYCIEGbiWJnJiD5jYZavvaGNpvINPdFaaJPY07anlFz6SMPR36JRMqLXzVQpLM1qERUj4g1bAwhpOPv+iT2/85TGsz//I75itjWnksI+WJMMFxHF722eIWZ8qESLgPH9GIUE+uBSSvPuLi0KsG/o/LMcyqTQAy6C7GOCPhtWgQo34pp55mwtcCQN4rCwSbMJEnWjXxB6bRCwBvbJOIHC1nHfEmhmQ0zUioah0SaZQ0mQvPszb+1fPwgSjcOyFV1/AvtHAb3xLZkGV8xxfE+3OJhPHrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+7r2cHSArT3jDP9S/skc+aiU1l1gR1eVS8G8zQV1CKo=;
 b=UWWUiFR9Q4IiDVe369QgRyvCkpXe5OPNPSmU97u29UaaA312FgaAyz9b5OoVViHs9uUwiLFFrjtCt16nN5o9XgLlUEu/jAuSj+FykeQcIa8f8yiYSo5vne4c/JywXTtdCXV9jjBTfOp1QC6LPib1d5rSrk2eqm2MT3O/QKJf5ms=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB2134.jpnprd01.prod.outlook.com (2603:1096:603:26::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 18:53:50 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 18:53:50 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org>, Chris Paterson
        <Chris.Paterson2@renesas.com>, Biju Das <biju.das@bp.renesas.com" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next v3 00/14] Add functional support for Gigabit
 Ethernet driver
Thread-Topic: [PATCH net-next v3 00/14] Add functional support for Gigabit
 Ethernet driver
Thread-Index: AQHXv4dKgBnK88kVVkGc1kUz1FHm7qvPrEoAgAABg9CAAASpgIAAANWQ
Date:   Tue, 12 Oct 2021 18:53:50 +0000
Message-ID: <OS0PR01MB5922B6FD6195B9DC0F2C8EA986B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
        <20211012111920.1f3886b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <OS0PR01MB59228B47A02008629DF1782A86B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <20211012114125.0a9d71ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211012114125.0a9d71ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8cb91527-3b7e-430a-3719-08d98db1a174
x-ms-traffictypediagnostic: OSBPR01MB2134:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB2134DFE7437B1052353D39A486B69@OSBPR01MB2134.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rOWnT8yD1GHz74tSllprvK9WBducVyjr8FJB2OqZmSFwrpprHEbOI973ccs2bEPTArte9NMECM4tp4eL4c+dhQPZbx7c6fyavU6Do+x0X/JskCuS/YyD89LenElI7cWhpLNBL7KiVqNouYUl1xWRxxWH66Y7wElGWgeKpe3DdCnyMjldI72DF/7J608oatXWiYBRgFoQNRhz8Qd1jMT4dXA+n88U6k0fNRsSUS0HGTQy3kKubzJ4Ag+RAOr/g2pn6aoan6F9m1DDHx0XJh2wkR1mo9Pt77/b+hSd85DsFInAOFDF2k0yi9JbxOuweetg57zbedZfqKQCYe/mfhvXlSd2Fk4XrSve3AABuDTaY7G2PYMfXR3xwIIsiBWOtu7R2AGYTACnrr4AiR1zRzyMZdyNWYJSaPLE37yVoIN3Zudbqpp7L65L8njKtXsO2qBTZHBABH2Urh4wzse1qlrt9GzlV5nT80f1R7JMdH2riCgrsQ1WNyHtFm/1u8JT7sAQ71pqXf+UKRNkIZUyEjgxdaWgIlhoEAArevRFQZyBMKolTylxsv6AQHmr//BTZglbh15UXgG/F0rvdGzFqJwgXgmMFxrt/EsxSFtYHDXGm2Honw/ydO53ughwMsvflxhTjBluz4wycrmBOwPgr8H/Ev8Z1BaXquYJ5hGuDme01kCPiwVWbMV9RF8pGnTpnSwyEYWKmTOFZIGefPRKyW+R9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(122000001)(6916009)(54906003)(66556008)(64756008)(55016002)(9686003)(8676002)(52536014)(38100700002)(66946007)(76116006)(66476007)(316002)(8936002)(33656002)(4326008)(2906002)(86362001)(508600001)(26005)(83380400001)(38070700005)(5660300002)(6506007)(71200400001)(186003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?viIcXi8cKNCxwGJ3VaGMqQ82YZ93uSwd7iV3aK+VN5x+eAXBjJGoocYcSrCM?=
 =?us-ascii?Q?s52ML8EQdrL0p0YOFq9YZ0XomKVXizPNh4kF15FYt1Fmw8IjNk8pNImCd0wD?=
 =?us-ascii?Q?iBVriaYIKyw42HuKCKmor1qxNTH2iL9L0qS0pWI3zt7RScULDf3Vt2iaL9Xq?=
 =?us-ascii?Q?u6hpl3VKZcpdaYJmGxeW3Va3pULHM+Yye1dMntL1RygFCvyMljxOhsXEVmMJ?=
 =?us-ascii?Q?KiL2oAWec6syLUj1plkfHUxXGnKHZh15n+E59AonFkw4eQn/Kd/WXNAR8VaH?=
 =?us-ascii?Q?HyPzdCuvqtTSCni4XFysJFdArNHWKdbIdl8RPwQdf0Mfzxc6VfqtTdraY302?=
 =?us-ascii?Q?ZFA7b+o0B8WEoGEIx8Lt2kNHkwIE2sbMCoqYQ/SgfHoBNcYSZup2Qah/Q7nn?=
 =?us-ascii?Q?tj2uNWJTeRKy8w/l3wehIdmLu15hWnQtub7HTyjzN3QZBscKz/9tfXNIPwmz?=
 =?us-ascii?Q?Ppgm62/V0pe9Iu4AV20fQhJEENq+IdOoR9x23I1sS23oe7qirlywN6vIaKrX?=
 =?us-ascii?Q?jmtM7oE3foY9t/yiFDh03uFy8lmaomTrIhiRcAjsLBQpElKAMK7v5w8xG5/g?=
 =?us-ascii?Q?v40stBnl9eKvzYY4HEQLry7tcYiMiJU/xTHMjnnxsNRPJH/Y+dcHvcOD2SZZ?=
 =?us-ascii?Q?4/FYgq87xKFJyYGXZQLFuk6gAQ1EucIwt0g5MohSFLrFik5VBbimEkJnnAym?=
 =?us-ascii?Q?lQaMmRftPlvldMdLgNcrsUz3ieKfnQahhg2WR/cy94jhAfqtrZMt0gQZBwDh?=
 =?us-ascii?Q?h0kHeMH1aPkcRwK8W3Lb5ArWGYUKtdN+hrmIq5GDCfYIuKQTsW3fJmFsAAO2?=
 =?us-ascii?Q?WU0gC+S5n5knmnzlfbpvh9MkwZsR7Y1eRYkv5IBkm/Z5iRlkZg6xmbNZxNb0?=
 =?us-ascii?Q?j/kudbGJQ4mohZCpyVSVWExyHDhT/DO3+VpDcc0+V/xBwfbiHvDYrVwJyD1H?=
 =?us-ascii?Q?ExV/W0gcUY+Xr6bCApW2WIID9yqbqQd1XYoTI1W2ZTtYypbFAQLx3FuaNNlj?=
 =?us-ascii?Q?z4UbsS1rGWI7r+NgzQlHi9ryHobr4GxfaUty0jTcMVViDZVj2tBovP9F+1eJ?=
 =?us-ascii?Q?CrOSGWfn8WiMySxSbCHpYKnJJurlvcdq7Haj/WAV8dusjVwIDnDG7FACEOgm?=
 =?us-ascii?Q?p73LAEtYHFTmWZKcDPiWElBSl9XKiYmdrFRI3497IYpiSQJh16E8Mw68r0tJ?=
 =?us-ascii?Q?zR2a6mtJjy4wBJwMUURWYvDCh/rSlGOXmYU1qGTVreMu2tyWlAGUFaPtV/Za?=
 =?us-ascii?Q?gzAKB9kmDdzHNcV+fT7H+L2FOq37C/TaoRnZDjSrpESY7fZyX/3w83KgznxE?=
 =?us-ascii?Q?f78=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb91527-3b7e-430a-3719-08d98db1a174
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 18:53:50.4453
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NWA05TRWWG6tC6QRzEDw5JhTSY4USabuda4gGv67DNqO8Mvlzap6Y9KTHAqyxl2t6ih2WyYoMGaBxW6oMlnv5ZrbwALgbxzQ3Bf50D2QSw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Jakub Kicinski,

Thanks for the feedback.

> Subject: Re: [PATCH net-next v3 00/14] Add functional support for Gigabit
> Ethernet driver
>=20
> On Tue, 12 Oct 2021 18:28:07 +0000 Biju Das wrote:
> > > On Tue, 12 Oct 2021 17:35:59 +0100 Biju Das wrote:
> > > > set_feature patch will send as separate RFC patch along with
> > > > rx_checksum patch, as it needs further discussion related to HW
> > > checksum.
> > >
> > > Is this part relating to the crash you observed because of TCP csum
> > > offload?
> >
> > Yes, you are correct. Sergey, suggested use R-Car RX-HW checksum with
> > RCSC/RCPT and But the TOE gives either 0x0 or 0xffff as csum output
> > and feeding this value to skb->csum lead to kernel crash.
>=20
> That's quite concerning. Do you have any of the
>=20
> /proc/sys/kernel/panic_on_io_nmi
> /proc/sys/kernel/panic_on_oops
> /proc/sys/kernel/panic_on_rcu_stall
> /proc/sys/kernel/panic_on_unrecovered_nmi
> /proc/sys/kernel/panic_on_warn
>=20
> knobs set? I'm guessing we hit do_netdev_rx_csum_fault() when the checksu=
m
> is incorrect, but I'm surprised that causes a panic.
>=20

I tested this last week, if I remember correctly It was not panic, rather d=
o_netdev_rx_csum_fault. I will recheck and will send you the stack trace ne=
xt time.=20

>=20
> BTW are you seeing 0 / ffff with good or bad checksums? If the device doe=
s
> a checksum over the IP pseudo-header + TCP only - 0 and ffff would be
> correct for a packet with has a valid checksum. But you can't set it to
> skb->csum and use CSUM_COMPLETE, you'd need to do something like:
>=20
> if (dev_csum =3D=3D 0 || dev_csum =3D=3D 0xffff)
> 	skb->ip_summed =3D CHECKSUM_UNNECESSARY;

Yes, it computes IPv4 header checksum and TCP/UDP/ICMP checksum.

It will set to 0x0 for both csums, if there is no error.

For IPV6, ipv4 header checksum is always set to 0xffff and 0 for TCP/UDP/IC=
MP checksum.

Ok I will use this logic on next RFC.

Regards,
Biju
