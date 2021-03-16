Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0C733D769
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhCPP3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:29:38 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7580 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236777AbhCPP3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:29:13 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12GFGLEh003846;
        Tue, 16 Mar 2021 08:28:56 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by mx0a-0016f401.pphosted.com with ESMTP id 378umtgxey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 08:28:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOhMVbZoUhBO30IuJyfhWxO2DuJdjVap6u1/csLwevoIID3IG3cPmbzv1mAhzcLgwsLdym7lImS3AtNpyED7KymWpGvHP/VdobxTHuQ67YnCBTgobw9S9gGiZTF7KS4/87kpozG3BWxleOIaT8gVlt8qG2lDzppevANDW2J8m7PMrJMbowQn9JGNnDnfuWd+UdQlwuKG/3RLe9OHwo2/su3nAmaKjLtzNuFD3+vbcsfu58UBn77kwQcKiPaCfoQ3v7HDeRVKRH3zskMlFxrDnCzwjkAWoY6rDjXeSVIqCizrJy2XjyvX0Aa23PrI43qJfiBolIBDlc7ShEB2GOS0jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orU0v4XarF/tgp304t4Ytu9zHdSdhtQfiY2TvNG6F5Q=;
 b=SLOdH0oto0oQjCCvDnMyCqs5DTkwXhF2VoQRC3QPIGRyFrU1tDglCTC0JzbKKTfK0HCsE9UKjIHycTJ5/QQXjWZEBGVtRyl4snj2aMsiVSmwFom6Zw8wkHGOUr+ozvwdlnQ/XkwvkahsOy3jmFoegEJKDxJ35ikPYnhIC0H4iVUZxQR9D1CnRQj8eiaefgyWBy/5z/GcmvWADF14iaUXaxoNlfAxJ/Sa5wVBmtfLoPS0LHknlS/6jriCiZnyMg9FUMGsVNEHVKa+AcOqCyz+kc1qrhFuilP7/OB8xJq+LMIWo/jvtebQnUlWKm+xLzcC2MOxgARnenJtoxpJCGP4Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orU0v4XarF/tgp304t4Ytu9zHdSdhtQfiY2TvNG6F5Q=;
 b=L7usNrCsA/WC1V1FSQ/B0l7yytajwpDDKy2amtkORPkaq8sbkXGg6jAlFhHF3E6dHhNX5yPEu7YOvHLV3C0W2hmZeSVlaUqB3Vf30IYcGRMyUgXv/cXpAUf0fPdpKb4WCzQ1inxgYkl1O5X/Sdi7GBwzdtjamZKStQUc+hY3QHw=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MW3PR18MB3642.namprd18.prod.outlook.com (2603:10b6:303:5f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Tue, 16 Mar
 2021 15:28:52 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3933.033; Tue, 16 Mar 2021
 15:28:52 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>, "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "rabeeh@solid-run.com" <rabeeh@solid-run.com>
Subject: RE: [EXT] Re: [V2 net-next] net: mvpp2: Add reserved port private
 flag configuration
Thread-Topic: [EXT] Re: [V2 net-next] net: mvpp2: Add reserved port private
 flag configuration
Thread-Index: AQHXFpW4dTR4hPIdakagD6uzfQ/d0ap/ArIAgAfBQuA=
Date:   Tue, 16 Mar 2021 15:28:51 +0000
Message-ID: <CO6PR18MB38733E25F6B3194D4858147BB06B9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1615481007-16735-1-git-send-email-stefanc@marvell.com>
 <YEpMgK1MF6jFn2ZW@lunn.ch>
In-Reply-To: <YEpMgK1MF6jFn2ZW@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce1ed19e-2f42-4fe6-c886-08d8e8903424
x-ms-traffictypediagnostic: MW3PR18MB3642:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB36421B12504CB1E505E319BEB06B9@MW3PR18MB3642.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4YbgrWkcuMSr1Tc/sUHG0AopAA9N9AgWd3C8y/ABCPkH0proKwcrrvSWHxlwlddAncjwD0NofCpOUSyIM4GcTWZWNwmG6/exZULs7BnGWhq1PpA3YstuvJ4hY72OVOsqoBY2cv843W2GKJmZ8V2i5hjak9D/KFdeB9fmQBjhkA6XyYrzgZl8Wr9kgYFeaWh5oP70CM6WkMVF1HuhiVb6wEynM1BW8I8OOgeCf/pc1nLuvLETqASiZKzRxc82x9yHgCU3uq61cweH3Wxy7A7u14QHOF5CrNc283DhNd9wihRj1KHiG8PcZ6bV1F1oPRSLxVUWMoIFf31TqKjSUnL2Hhqtn19crSbRl5NlrrOIQ99FE5RFJLO2uaCvHQc0sT3BQqzePEmL9xcNBEjgYxY77t/4iQHgMmWVJ5WHNO74c5yNIP5b31KeBc6P7jJlaJhDBX5PpbvbwunbH/m1XmimF05SECX6/Xg8xDi+3O7WWH/e9jXtJ1L+4SE1hD8hZcfJXrUPGnLTyJKoTVbln2QpVv/Z9f/iKxG9o3fRYT/up1Z0zDuiq+Hm2sjSyM39bOYEyC9Ohr05C1hmPA+MRKPKr0sezZL41SVb6S2EncL+kr51n+EqYUF3cR4eyPunoFfGHuO/PEH/5tYaaQeRskEb5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(6506007)(498600001)(8676002)(64756008)(66476007)(76116006)(15188155005)(33656002)(83380400001)(7696005)(26005)(9686003)(2906002)(71200400001)(66556008)(110136005)(16799955002)(7416002)(186003)(52536014)(54906003)(966005)(4326008)(55016002)(5660300002)(86362001)(8936002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?IOUJjXTLE5t8BJik/1z/9eO3MpxWOkoGm/5NWlY66xa9t9fPVhJtvgrSZ5x6?=
 =?us-ascii?Q?ot5W7fGUUb3TYOg4V80SolTFn6J2JiHajREtA3PVt/0xeqM+1v+PLdID9CeF?=
 =?us-ascii?Q?eYK93BE6YY/Sgm2pS08Lcx83n3wNHnrf06BrPCanq87tSjtCC8JoDZrClTdn?=
 =?us-ascii?Q?iUNUHFkeWgKO8KN6Kv2YX0b9ywpsGWdIUnQ2dHESZeY6fr2gsaWGrgyf+Uhh?=
 =?us-ascii?Q?D02yq0aQyVhXm2wU3ctQyDEzRlNvuPgmVIqnhFXiGXOGG9mT0uChBxp7MmZB?=
 =?us-ascii?Q?wRofi2QDYi50hcpuYOVU66EAL44Amfbp8cECVfAtKZn7MRiJJ+nO6DHeGDM4?=
 =?us-ascii?Q?HW6CQDbbAX65320mdIwUYg9/MlfHCtB/CTrskywfr+WzuRbR+nVvV07KfvLC?=
 =?us-ascii?Q?6ifRwdKgf7NOY5xvHQ8olckkxVji3t5D+IEKGlsonOmZGId91lVD29OZdc5i?=
 =?us-ascii?Q?mK/SD/j55Cvy6b4krbMYo8nDN4cE2XGbq0YiPxpgbMa9pu49+hOrXcHxaXlN?=
 =?us-ascii?Q?6s6bH1e5wXVSKJwWsaW+umN8yK1xlcrG94m9rbU3r7CNSji4kaKv9gEyFZN2?=
 =?us-ascii?Q?E5WckL6dEqy5AAU6QlztiMiHkLX3z3NyF1JZTSD8mcOXOEFf2u2QkRDP2GSn?=
 =?us-ascii?Q?jnVBMd8hMmUI7XjbTEW6OJTiyh4oTlW921YfQmI0FeaZBNyi57C4th7c8mwk?=
 =?us-ascii?Q?oa2tatAxZAPdWC+0VURLf8T++R9sERePubqC+ug6vlZLLBQVywKm99FJAnTK?=
 =?us-ascii?Q?G79gzRF8PWSw3IHRz6VvUcG0Xn3tWu5Xm2UtawP6DefZv/rID+ZlQhWzpqHJ?=
 =?us-ascii?Q?tH+HE9fW395qL82qfjZG/6tdTMCekCT/rveQQBEmXlAKoxRcBXt0ObVybg1A?=
 =?us-ascii?Q?1lQ9mVM/eHwnggewho8EJcueKTQ/BYFpbd2G8nuk+KLj3i/EgEMCk+dysrts?=
 =?us-ascii?Q?wu8AHXnI/Wos09Bx1ojBhC+llbr0Bm0XhW57Qfp6Jlv5czbHwC35hO3RPpU4?=
 =?us-ascii?Q?vfI+HGNOAbyYposHnZWP4X+MfLW7vvPHRqlbtCz9J19viwH5z40rByHL0wQM?=
 =?us-ascii?Q?CiPVJrNYmGRfqhRfq9ifrXftCUtzJA2mUJcJZfmNcVCYj3cYfZy77ckrbgKf?=
 =?us-ascii?Q?SOMeCIAYNFYEMUW6h7/DvVjWaGatxi3P5I2VA0Q7hH5tKxTkM2Xb2m+cvH2I?=
 =?us-ascii?Q?KEQQQHq9UccIP1jcB68kxsymEFGqHyrIGv/wsDR+89RuD97hhId9YAiK4hjD?=
 =?us-ascii?Q?9gYFNvjbm/krz3sx3fwXppCEJ7W+rIkGtBJzvpKNQK9HSjMWrHV+KbL10fu8?=
 =?us-ascii?Q?NAo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce1ed19e-2f42-4fe6-c886-08d8e8903424
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 15:28:51.8684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h1P/8wN6sb/o0Yx7e7BSXtWc19y2X2QF7y79Y7p6na0/624Bs34wDvvOBMctu+Ek8gNxWtgrxqrhVJ7MOeZEVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3642
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_05:2021-03-16,2021-03-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Stefan
>=20
> Thanks for the strings change. Looks a lot better.
>=20
> Now i took a look at the bigger picture.
>=20
> > According to Armada SoC architecture and design, all the PPv2 ports
> > which are populated on the same communication processor silicon die
> > (CP11x) share the same Classifier and Parser engines.
> >
> > Armada is an embedded platform and therefore there is a need to
> > reserve some of the PPv2 ports for different use cases.
> >
> > For example, a port can be reserved for a CM3 CPU running FreeRTOS for
> > management purposes

Hi Andrew and Jakub,

There are multiple reasons why we must let the kernel initialize and manage=
 the reserved port:
1. According to pp2 hardware design, all classifier and parser configuratio=
n access are indirect. In order to prevent race conditions, it needs to be =
configured by single entity.=20
2. CM3 code has very small footprint requirement, we cannot implement the c=
omplete Serdes and PHY infrastructure that kernel provides as part of CM3 a=
pplication. Therefore I would like to continue relying on kernel configurat=
ion for that.
3. In some cases we need to dynamically switch the port "user" between CM3 =
and kernel. So I would like to preserve this functionality.

> So the CM3 CPU has its own driver for this hardware? It seems like we sho=
uld
> not even instantiate the Linux driver for this port. Does the
> CM3 have its own DT blob? I think the better solution is that the Armada =
DT
> for the board does not list the port, and the DT for the CM3 does. Linux
> never sees the port, since Linux should not be using it.
>=20
> > or by user-space data plane application.
>=20
> You mean XDP/AF_XDP? I don't see any other XDP capable drivers having a
> flag like this. If this was required, i would expect it to be a common pr=
operly,
> not driver private.

No XDP doesn't require this. One of the use cases of the port reservation f=
eature is the Marvell User Space SDK (MUSDK) which its latest code is publi=
cly available here:
https://github.com/MarvellEmbeddedProcessors/musdk-marvell
You can find example use case for this application here:
http://wiki.macchiatobin.net/tiki-index.php?page=3DMUSDK+Introduction

Stefan.
