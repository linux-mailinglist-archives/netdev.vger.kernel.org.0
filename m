Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A27350277
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 16:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbhCaOgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 10:36:45 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14522 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235836AbhCaOge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 10:36:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12VEKlni010428;
        Wed, 31 Mar 2021 07:36:23 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by mx0b-0016f401.pphosted.com with ESMTP id 37ma9w2rcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 07:36:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdnRk+9yBI3nm+tZ0zoK7LAjKdI8btZ31A3pjyKBkWYBMzmgI+MxOLc00n3Qfmvf3/5zbQaikC2SNZ5JOfBIF4PiLWG+GpU/rEwyxJ60zlmlPZaEWN63k7ZGgAOTP+bdL85qyNLe7Ig/lIQOQtNu6gGZovVBXNZVw9TwVt4Y9FuGIMbowPDvgmtEfZNSg6nLnCBd6jitzeDht/FmyyY/MnLspVUciiN3TyO0bu75Vi3ZSjMbzaPQEpvyHuM73+TTc6T80pDRiXyEgmEfpQH79/nws/bUhT0RYYQiKT+pvIaAah6s2u0vtKMpKn4e9uqHcAK7bIRBGDWQQgRWG4q36w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SkrxASzXt8a/YnR/X7ikW9k79//uPRK8RFigybnH03s=;
 b=fsYvi2T1nLtsDvIM5znOL9jkpOgHtfsk7+KsHRhd13QyesBTQGsVIOHWMx/VwrX15+QJeNYAfG+ARbGG+RFoqJ/5gMnKINZ0/dcbXRvJxuwQ27L4VD9aixkcPvXI+6zSqKiM05olcX7F4ZNdlmzJG8ZGRnCrESh4jFEBqdkOJ7n77SOepIrLaZgiGFUhCqENIXe9dvL/4/QjgMm8EeWcQ7WSbh7aq5WpsUH1k7u8rs7KPurBt3+Fnq0lyhTlzT3AEUgiUQ86f2EyLwC/JnOTykRweRPJs/u4UrFWIOT1t32KPwWCYKLiVkEWwtRlG5wX/gSSmZIxMm4vGXGl8fWYIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SkrxASzXt8a/YnR/X7ikW9k79//uPRK8RFigybnH03s=;
 b=WdoIia6RlWUkVRsknKvRKMI6kIk4nxysu8s3YpEAtJ7U5YBc0hdnHgKgGc8Eyg2fOGxWuQ+8WU2Z4Z6BcnlduV0GzWrpKvc87XuPo7Oan8Xv0PzX1H35GnUOXp4jvnFrNjAjpdJXTLj6o2k85AMfuYBl4cqNOYPbXxJOfuVjuvs=
Received: from CY4PR18MB1414.namprd18.prod.outlook.com (2603:10b6:903:111::9)
 by CY4PR18MB1047.namprd18.prod.outlook.com (2603:10b6:903:a7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Wed, 31 Mar
 2021 14:36:19 +0000
Received: from CY4PR18MB1414.namprd18.prod.outlook.com
 ([fe80::e84e:af76:192a:72eb]) by CY4PR18MB1414.namprd18.prod.outlook.com
 ([fe80::e84e:af76:192a:72eb%7]) with mapi id 15.20.3977.033; Wed, 31 Mar 2021
 14:36:19 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Sunil Kovvuri <sunil.kovvuri@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [net-next PATCH 0/8] configuration support for switch headers &
 phy
Thread-Topic: [net-next PATCH 0/8] configuration support for switch headers &
 phy
Thread-Index: AdcmOqXzS25KviZSS/OczUe/AGT1Xw==
Date:   Wed, 31 Mar 2021 14:36:19 +0000
Message-ID: <CY4PR18MB141480A90AEBB086BAC6D423DE7C9@CY4PR18MB1414.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [27.59.248.27]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21ae5676-bb40-487f-c28b-08d8f4525940
x-ms-traffictypediagnostic: CY4PR18MB1047:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR18MB1047C480F54ED173513936A8DE7C9@CY4PR18MB1047.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7cAdQOifnt61r9l9V8iF/nsJn8tWxPYDZTI7p9vc6gdi6VVL1Ke8p3RMLDt3N2/zmrtTNhBOJYdDZvW9dUA7IbgK1C1PkmVQL/rjLLU3jI3vLax+tY4M7/d/tKSO2xB/anRvCbBn1GAOhGiYN3koTVfNLmRlvfeKJmWdAb/S4yvSW7aSJtXlvnUZ8A6+jVy+9cucn2c8QUAxVcz/9KX1xp1SP3QisrvvAk9qo6RADXJOF3kuTb3TMAvih35KeI2KQzX/iVODYH6DvYbaDpCO9youboJ7AB+p+hO0Ptoux3SA4YeL9NcsjdbzU/cDSOE0P9LDIKledxjKPWVchc5wjMGWyOzl0W2r3zv9ANDWpcMgONfNbtcbTPnADhhB9VmvDTCm94m2fsyoRMY47Z6abBvSly0fDuiRxQ1qH/zuDWfqQ+nHXu8Mf57KjoonGxbTQdCu78fO+/3RfOe6zjjh2L1HJbYRMC4NAk2Rpk05J4InZE5fMjaB7AiToKd+0abAQoai1jECtQUJ0duh7aUfn09aqmsrUrxfpYrS5ykNUslZlF+oIN65dDC53/HdoOe79eYTWCUCzOrbcU2d7N8wbY9/9UU4Mfx/E6NL9oRNlQs5IoNN3HhMXQLW2wX3Fn7VHISWHPpSBZ3sgg5T1XT1W4tzl24Y1ZGbqMdyBJcmD+A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR18MB1414.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(6506007)(8936002)(9686003)(55016002)(86362001)(38100700001)(107886003)(2906002)(7696005)(8676002)(83380400001)(5660300002)(66476007)(66446008)(64756008)(66556008)(498600001)(26005)(4326008)(52536014)(33656002)(186003)(71200400001)(76116006)(66946007)(110136005)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?r3j7zt0PlrmAf+J/ShOQPfU1PBnWXSgw2VE7C/xUsDfRS/ydA1oPTDewI1yi?=
 =?us-ascii?Q?Z9GrLMc82bKXZS1X9qO2lqF76AAKpdj5kInhD8rXfZbwWKtGo+gEenix5aYe?=
 =?us-ascii?Q?38rChFERwM6if8q13zXWj+ysXsB1ff5HHicV/t3F05RG7rjs5VJFFMMMCgql?=
 =?us-ascii?Q?EHTd23BI9OmvRJE0n35QVLt7vusch5Xf7yvXhaVVNnjhQ0c+iKbGxmIjZ83z?=
 =?us-ascii?Q?5Fcg1ofnTi+Af/YqqexM7hfHnXHsMJTGWFSufmgCHDp7sqE6R/fLKGO0TK62?=
 =?us-ascii?Q?QRkD9Uuy6HlcvcPXP4TMddLaWNicNdTnwQL5PKK0Q+8H480NCmtd0oRdpuQv?=
 =?us-ascii?Q?vQoKqg04Us5jBLMLZUYWwcUSTduZNXe8wSLzEH9vtrZyVygY9hGt/fjqbZj/?=
 =?us-ascii?Q?MjhoL3SLTJauQLu6SvPoCPcjYM6jZogF65h3RB7c9LFjOaY4NJCiVU3iQrE8?=
 =?us-ascii?Q?qEBFBBuQ8DCa4hHua/csvdf2UJHvcE0UDwrM492y1K3HGaqdGiWsgnvwOdmI?=
 =?us-ascii?Q?yrWas4YwZapN/hZU7yETWpTGl3LG4NSmTx2rCfITKus40jXq5Tiysgq6Gcwp?=
 =?us-ascii?Q?PPQK7pbER0gmTj2oadDp4gejISFG9IK53ayDwfVyCWRsLK1jwwat8RYVt3Rs?=
 =?us-ascii?Q?t2X/pF41BbOrFbrZKUcJJzREGiy37Pl+UxDs9Ndol9AIfwRfMysRRZv0CVON?=
 =?us-ascii?Q?iOVtuzVgQX7+dpBPAtd7k9STz3YFuVAKs4dqNzkYgJHP19Ce/bHzIGireqvr?=
 =?us-ascii?Q?+tH7RSyWotgDWbnLs9OSVKaA15j6XY/DE2QLYgaWaWflO2tFIuFwMisgYpcr?=
 =?us-ascii?Q?1sUywcnw4eyOWj9Kt+0Dyuy4rYQld3N1OYx1NgO1Xk9C26F7AawUzhtMsrS1?=
 =?us-ascii?Q?Vx1QXPRVVmsBsQlgPqAYfvyYeitn/3wEVrNvpGBgEG+evLd4OiQVS6qEqLwN?=
 =?us-ascii?Q?lzltaJUSo3nROSULSQbM1QZpy00ERPelndOMFZzGUaZ8/Qfae1rBYTVylx6a?=
 =?us-ascii?Q?glFrm2FybMBj0IsXn6hSuloLS/XOOQ4H4z+f6z/t1v3JhqNUbKJ2VvrQXIyU?=
 =?us-ascii?Q?1Axf8S6xCpjztduO0Ya0Az1Azb7y1S7gTAbPSl4sjBjPIE1qr1MisHChx+Q+?=
 =?us-ascii?Q?u6aImKVHMm+vPqSis5qi4rAhvVgt95mQq2sW5sR7nfno+n7AaaQvgGW1KN/a?=
 =?us-ascii?Q?UraQbGekArmjE9yPDB9fnQrpTcdP2jatq2GIssQZbAEVbJJxZwDRj8ix2bPD?=
 =?us-ascii?Q?VzzxYIcJ/ShJ+P2gwQtfkaUkdUPmDvYCkiIEIJtVbPeoyds1F0asINQzxZ8F?=
 =?us-ascii?Q?+Es=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR18MB1414.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21ae5676-bb40-487f-c28b-08d8f4525940
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 14:36:19.1728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wOrm9EQBj1ApXT/M+C6UYgII3qF+mAuQi8+t9Bc8beJBU9/7ZMqMZmzWUxk4q9dB81ht4QPZhToV0V8ARtGc5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1047
X-Proofpoint-GUID: CME43Ae8ZdJHHYAzoiw_7S17BixanhDm
X-Proofpoint-ORIG-GUID: CME43Ae8ZdJHHYAzoiw_7S17BixanhDm
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-31_06:2021-03-31,2021-03-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Sunday, March 28, 2021 11:17 PM
> To: Sunil Kovvuri <sunil.kovvuri@gmail.com>
> Cc: Hariprasad Kelam <hkelam@marvell.com>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; kuba@kernel.org; davem@davemloft.net;
> Sunil Kovvuri Goutham <sgoutham@marvell.com>; Linu Cherian
> <lcherian@marvell.com>; Geethasowjanya Akula <gakula@marvell.com>;
> Jerin Jacob Kollanukkaran <jerinj@marvell.com>; Subbaraya Sundeep Bhatta
> <sbhatta@marvell.com>
> Subject: [EXT] Re: [net-next PATCH 0/8] configuration support for switch
> headers & phy
>=20
> > The usecase is simple, unlike DSA tag, this 4byte FDSA tag doesn't
> > have a ethertype, so HW cannot recognize this header. If such packers
> > arise, then HW parsing will fail and RSS will not work.
> >
> > Hypothetically if we introduce some communication between MAC driver
> > and DSA driver, wouldn't that also become specific to the device, what
> > generic usecase that communication will have ?
>=20
> Hi Sunil
>=20
> We need to be careful with wording. Due to history, the Linux kernel uses
> dsa to mean any driver to control an Ethernet switch. It does not imply t=
he
> {E}DSA protocol used by Marvell switches, or even that the switch is a
> Marvell switch.
>=20
> netdev_uses_dsa(ndev) will tell you if the MAC is being used to connect t=
o a
> switch. It is set by the Linux DSA core when the switch cluster is setup.=
 That
> could be before or after the MAC is configured up, which makes it a bit h=
ard
> to use, since you don't have a clear indicator when to evaluate to determ=
ine
> if you need to change your packet parsing.
>=20
> netdev_uses_dsa() looks at ndev->dsa_ptr. This is a pointer to the struct=
ure
> which represents the port on the switch the MAC is connected to. In Linux
> DSA terms, this is the CPU port. You can follow dsa_ptr->tag_ops which gi=
ves
> you the tagger operations, i.e. those used to add and remove the
> header/trailer. One member of that is proto. This contains the tagging
> protocol, so EDSA, DSA, or potentially FDSA, if that is ever supported. A=
nd
> this is all within the core DSA code, so is generic. It should work for a=
ny
> tagging protocol used by any switch which Linux DSA supports.
>=20
> So actually, everything you need is already present, you don't need a pri=
vate
> flag. But adding a notifier that the MAC has been connected to a switch a=
nd
> ndev->dsa_ptr is set would be useful. We could maybe use NETDEV_CHANGE
> for that, or NETDEV_CHANGELOWERSTATE, since the MAC is below the
> switch slave interfaces.


Hi Andrew,
	We are looking into  DSA to MAC driver communication options, will get bac=
k once we have clear picture.

Thanks,
Hariprasad k=20
>=20
>       Andrew

