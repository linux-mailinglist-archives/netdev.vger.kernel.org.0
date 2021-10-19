Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5601433B7B
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 18:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhJSQDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 12:03:38 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59269 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229789AbhJSQDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 12:03:38 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JFUOMD020984;
        Tue, 19 Oct 2021 09:01:17 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bt05g0a50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 09:01:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LmOAZ714TdpKH0Wnlbft0bvLmjeOyiZ9bj3POhyuxJnnGzLrujYwmTVWFJ0DRjyfj4xU6T0wdCr2RzAQ6yb/G4SgwUpOWL/u4ie5NI0Q1n6WFA7JQ1u+D0A7z+XxJ3dhkWGj4ZrPCjVxfNnezhTmusPjQEoKrNl35BAoibwgU+XYsv0x4HPWd4Nm59JrlrIs3RPs09w+KwtqbfI/nbfOXK6Y3ebtOrldCGnEjuuNdJujLWRbNFP6I6ZrRyNzbt/SemgrMyAoL6SBA99xjkiG62hWB36gNX15INWnGm/ogk/86Qhi5SstTI6ZPsu4RtswKFWecxZOl3Lbuy8spyJW1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mnSSFA+YHyHwhz/XnC6GupcC56RrPCOL5PV+kD8Rf9c=;
 b=df3WdoRij9FAClARSrOMzfJn2tce7mz/SdTRQoxGRgEt1sNpoZRcfpF4XiQUKxOQhBoT0mJ4LdTDdfQMVCbW/JPsbdB4i0OplsMK4Nxd9utqicpM4T1GfHFFqbotndzTaRe9lL5phR0Jv5jv2GhQno5wB5nlgvzvLHqUGirJnumdXcZ7FtW/oJlwgcDSTDPhUtWghoakfwtJQ+hRgu2zT/nfOplPgkqb3nnbvc+ATEWW97ssagLL1lLZyIhevZfDJsmuR2fcrF1UAubzZIkqZu+talU56e2yZQBywW/ScsravDJpjjppA8pnGD45IJGFB4y2WXFIkNGvOU3r/Z9CWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mnSSFA+YHyHwhz/XnC6GupcC56RrPCOL5PV+kD8Rf9c=;
 b=oosjVUk+/CBofQigbLUoElyDz9Pnv64Ra8YEmz5KScDBb40xO5QpLLOGI8ITp03tZhNhXE+pDTGN1/p5DdazuDBawqOBKeew5FGwD1SXT4hWRA/X189f8hLxZoEY+lYaRu2Cp/b0t+dRS99ELiH9HS7yGIT05coO/7LdqFJzZIs=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by BYAPR18MB2357.namprd18.prod.outlook.com (2603:10b6:a03:133::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Tue, 19 Oct
 2021 16:01:09 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502%9]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 16:01:09 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: marvell: prestera: add firmware v4.0
 support
Thread-Topic: [PATCH net-next v2] net: marvell: prestera: add firmware v4.0
 support
Thread-Index: AQHXxQKISOm2MNQLz0iE312ePTHa8g==
Date:   Tue, 19 Oct 2021 16:01:09 +0000
Message-ID: <SJ0PR18MB40099BBA546BFBE941B969DCB2BD9@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <1634623424-15011-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <YW6+r9u2a9k6wKF+@lunn.ch>
In-Reply-To: <YW6+r9u2a9k6wKF+@lunn.ch>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: ad933691-e4ca-a1a9-2223-94a671900502
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d95e271-da0b-4520-8cd8-08d99319aac5
x-ms-traffictypediagnostic: BYAPR18MB2357:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <BYAPR18MB23575172BF786BB9D40BAD51B2BD9@BYAPR18MB2357.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gL+vxO/jY2u4fdkcYgLFEer/cPNVUCOTVpCEJZ/79W16vXicPeIV9l2nruL3O141/a3xkQr1fr+V5zlsghr72HW1YKY7ZrgBLBvvbe4NuaAX0dJjBcQeEI22CxjSD/2HR927z1NCfJrPi5DdiQdEJ0QPqByCmr3WKCpobZ/xW8aGU2s+XQBaTlYlaYPoeGzRbJUs8liNrOqPJoSB3/CRI06TIbTvDYg1OISZKKat5b4ATT8t9UPAq0dUS7DIwe+10t2YWTHtRFK24QlSxgMjylKe8MtZQMomLsJn8vP4028dhqoI2iF0Agl+w091d2kffT1Z6OE/EpBhWtXQBuPzTMiqZgLi8Qt6EP5YhXAfdsoYH18UXrxBTSFLMF6DA7brn5HVL590fvrdI6OE0OUwRkzrz5t15PSXT5uHb19ZnRmvbMKblhVvq/OIIsde14GGYMEz14RptLBrpYTDe+g8sbivB7MKSe38S4D2VSVgAks61pNSWjrHac719XjB5J9+pg6pDE7ZIUU+OX4/y5J2b3/kcdbxa8QD/gti3rB/Db18S0WtS1tBys33NIdqAMywnAgQOABdOcx9Lx4DkO0oh5lPztA+lfn0dcfpVhEVELSc4bRob71aJmSXL8sZC4+vH7TO3zDCks22dXFmWSY0Z4tkinlM+/W37s21+IPb6nfQvF8pcRTWby7GipWFNkucOrEzURCgUNuhgs2OoXHpAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(122000001)(38100700002)(38070700005)(33656002)(86362001)(71200400001)(64756008)(66946007)(76116006)(66556008)(66446008)(66476007)(5660300002)(186003)(8676002)(8936002)(4326008)(26005)(6506007)(7696005)(54906003)(52536014)(6916009)(9686003)(55016002)(508600001)(316002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?crAlQ/X/zrS0J4eGvRF1AhSCGWXkwM/jCXZuDFl3JcJLFSjrcuTHtWBOPJ?=
 =?iso-8859-1?Q?gyvOCbWef79erZvkrIOzpE6o/56js/YaXAzT7l9nvhIirEhvDIgbSXi1DW?=
 =?iso-8859-1?Q?ABzAvcOVyYH0PsDnKWpq+4MuvNP7nSVb2Xrqf/GkzPlzRN+a/kaOA4Mtu7?=
 =?iso-8859-1?Q?N51hSZRkqBCeGFsRt1zS9fIrxSTiT106setEpoRKyUJGcvNQkpbEwriccU?=
 =?iso-8859-1?Q?XYA9ss/3Xq4QHF9UXV929AiHxix9WN+ogfVXl4lc1zZaTyjZERIIQbYfDc?=
 =?iso-8859-1?Q?PInAqZvusw2vqy/NaPlG0OUlQaoqYqkHZZF0tXYsZoB3JBOm2iNHAIaoUN?=
 =?iso-8859-1?Q?t7klYb67KpYZLkX+HssGMpN6YLBHfTkfNO+A1SbLtsv6PWwHNeK+5bMsBs?=
 =?iso-8859-1?Q?SNGQyVekIImQv5oBeQUFgM6uubHQqPCowTGGPBfR6VIJ+mJXEojsyJEIfy?=
 =?iso-8859-1?Q?kMzRd+TOYnhNpdFiv4IE23f3k70Ejl6URPHG3LCEznhq9r8FSZv5Yshzu3?=
 =?iso-8859-1?Q?ziBu0dbjEZBAm88QFmBwn5vBbiON1m44Qrk7LhxwmA51OTIYeZMGJKWCTB?=
 =?iso-8859-1?Q?vs/2Biv+w45ZxGNCiqQVOP5DYx1oISY52MzNiKu20Icr7yO1loJzxvQpOU?=
 =?iso-8859-1?Q?HlmtjHtXCkzRRjA3sIlJ7kd9owA2hLccv7xvazcH+jsCP+C3S0ILBtf5Hx?=
 =?iso-8859-1?Q?dzThasJudHkY1uR/CJ16vB4KoujqEsEYhYZkGDR4CfE3Dxll67WBloqka7?=
 =?iso-8859-1?Q?+HQ+wiurJ8UqQs1KTmJh9i7uu9KfPChOqumdPZgFM9UVAnMcz2dW9EDsxj?=
 =?iso-8859-1?Q?xS5bVteI3XVkz/DoLp6fV2JIgFJhqpRD3wYAHgvplGIugfRkQBq1SHO3dc?=
 =?iso-8859-1?Q?iNoG5uqPHkYm/d+smseyWV4uG9t8r3WnlM6dhhLuquY6MG9H5wXEmp4Ij1?=
 =?iso-8859-1?Q?V2H3zqD5RuaO1rcAEcIN3l2z+TZUt3L66C5l6Zt6dr6i8Zv8cWeUg0v+h+?=
 =?iso-8859-1?Q?Smez49WmpFRTkkliyx7jEMu/6tVY0EarNB2SzjxW6lt0i6HlY3cPzJSgq+?=
 =?iso-8859-1?Q?PkR3F4jNen/3U+4X94GKomq8ksCJO2/QFGTwGhqIPrA05imY6UqfXL4yRy?=
 =?iso-8859-1?Q?sjE4dQy7qRSX948TpwUD1c9BFkrNwysl+Sm5tl2UFIiqC8yklzltiSFJcP?=
 =?iso-8859-1?Q?m0kpwfAhKIcxMpuIiEURvxirHAkVN7Ae8GvS6bfqgegGYPDtUeRwO8Dqcm?=
 =?iso-8859-1?Q?bicC3d1ekutKq/uy1kEbCG31FRYXw/V4CV6GyCrIhTKJfP4l11Y1gAO7pi?=
 =?iso-8859-1?Q?4lAITsDeVMcdKZ1FtPLuFb2CA2RLd1XV05m4C0yxaRPFH3EQYzHM7hwjqt?=
 =?iso-8859-1?Q?byBaYLbP3TtRvIrW+zN0k64/P0AOxhneWGpVs1XwqML9/SYXjHCOAxZbYY?=
 =?iso-8859-1?Q?y9YqywcPXmi0Hy6/AwuPR9er/zGwOUL2uIxtprl7diLg3ZU50nT2se4hDH?=
 =?iso-8859-1?Q?N0FranDQGR+iYQWfAm1gtYD0BheTm8hlVUicI4W13Iy0QCfxdSNblJJTNZ?=
 =?iso-8859-1?Q?W2Bm2W2qEprOWzlCKN8B2g+mpzXFZhZfVfxilTbXle/oDzR6vvF+5Q1WX7?=
 =?iso-8859-1?Q?iOFCF7O2wnUrBMYIndJYyeqtSWpMFV/G3xMtv51WN627pcrTMVzcjYqw?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d95e271-da0b-4520-8cd8-08d99319aac5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2021 16:01:09.7587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: quS25J1bIR8/8ZOGHiqyWO0YL3PoKfvIE/WuUPVRNUp5KJuc2S+QpARUk+6rUpR4sXboaIdR2yDtl5e3/lPqIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2357
X-Proofpoint-GUID: W5Wn1Es9qIV-nQlVBv4icSju3aaqQ42p
X-Proofpoint-ORIG-GUID: W5Wn1Es9qIV-nQlVBv4icSju3aaqQ42p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-19_02,2021-10-19_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,=0A=
=0A=
> On Tue, Oct 19, 2021 at 09:03:43AM +0300, Volodymyr Mytnyk wrote:=0A=
> > From: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> >=0A=
> > Add firmware (FW) version 4.0 support for Marvell Prestera=0A=
> > driver. This FW ABI will be compatible with future Prestera=0A=
> > driver versions and features.=0A=
> >=0A=
> > The previous FW support is dropped due to significant changes=0A=
> > in FW ABI, thus this version of Prestera driver will not be=0A=
> > compatible with previous FW versions.=0A=
> =0A=
> So we are back to breaking any switch already deployed using the=0A=
> driver with the older firmware. Bricks in broom closets, needing=0A=
> physical access to fix them. Was nothing learnt from the upgrade from=0A=
> v2 to v3 with its ABI breakage and keeping backwards support for one=0A=
> version? Do you see other vendors making ABI breaking changes to there=0A=
> firmware?=0A=
=0A=
- Major changes have been made to new v4.0 FW ABI to add support of new fea=
tures,=0A=
  introduce the stability of the FW ABI and ensure better forward compatibi=
lity=0A=
  for the future vesrions. So, the idea was to break support and focus on m=
ore=0A=
  stable FW instead of supporting old version with very minimal and limited=
 set=0A=
  of features/capabilities.=0A=
=0A=
- For backward support, the addition compatability layer is required in the=
 =0A=
  driver which will have two different codebase under "if FW-VER elif FW-VE=
R else"=0A=
  conditions that will be removed in the future.=0A=
=0A=
- All current platforms using this driver have dedicated OOB mgmt port, thu=
s the=0A=
  user still be able to do upgrade of the FW. So, no "Bricks in broom close=
ts" :).=0A=
  Also, this is Marvell guidelines to have OOB for the future platforms.=0A=
=0A=
> =0A=
> Why would anybody decide to use Marvell, when you can use Microchip=0A=
> devices an avoid all these problems?=0A=
> =0A=
>         Andrew=0A=
>=0A=
=0A=
Volodymyr=
