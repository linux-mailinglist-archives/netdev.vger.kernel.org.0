Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004246A6DDE
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 15:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjCAOI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 09:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjCAOI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 09:08:28 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2051.outbound.protection.outlook.com [40.107.22.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E131C591;
        Wed,  1 Mar 2023 06:08:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxAX1Me8raOrvbpyDggF0TVqc3qznpLy/zHWbQdfQAw7aD8ruoQTgTMgivcoCQS4ORhq/56/7IzjzWnY5Kh6WikOGBwplLeWw80zsQNIFR+m9JbyT+2ranvotm2rxAS4ZoGmadyXmj1jve+oZfjWrfmn2/siaWazrm9wDhXgutnlOESgChPOJOfK8KrJCJBNysj3C/o97UkOamFkABYPnukaB4OaOhoNrB30pCZoaujerK69A8FcagezzHHHn+M1M30JfbBUvdkPQWeCNyiBP9K8egRS7esqLMj+S6KQLo6ehqhGCUb9jslWl8oQWFwdwYk6+TtvtuSpILOmlUo91Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hdL+3xQXOrpxj5F9JRp+QECNE8mZCU37Z8+wVug8Ie0=;
 b=hloVQRUWPgkp6GOABWYocMaZkjEM6YY+zryVLT1ci1sFIPSE7HOBA3fnMtE9gXLwv02aHgoMGnMU9NzWHhU1YbQu1ez4MVvhCiSUYFUh/SUweakpIEuTgu1b2vr7D/5lB11Mpp3Z4gQoRsAL0gx7s5YusIAki2YaN8ZHksGEyCPiP9v3HF+JLfcjYTpLFlejS9Rvz+Rtqbb2lwdaoOPFjvoGF2D31DjQlEOEZdj/e6Am3mtRwy99SHWSmK6ZGtfChsYSGHPpZ2bulq0u7EP6Uh5PY46TApdKcbL7evf5ujcACapSkErJU4j0tvKKTL1zHV31gX1Eptu+dSzyMkP5hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hdL+3xQXOrpxj5F9JRp+QECNE8mZCU37Z8+wVug8Ie0=;
 b=ioYcmETM/PbbDi44XN5GxOqauIawoDR55FSVC3/RW7RCPun2Jj6Lik6iJIu3LRtFpDOLKil0Zb2e5JLYoZIw5vLfhNRW8SCjBIu2dEAjGux55yBc6jlCs/V60jb/Jli0KGYqv25A79cvWjzoZQ/aol+qzbr5I3docZouDYqwAq5Hosonfi7xT1FtdyeCGFwJg3IZY7xKNq0cRUIX+RlgF7qJQkpJmv3+fw/+CRal68yBrW2RZN+YpqJIqcMcJiLMjPiMgqnYlMCc6IZPWzlGLZhdwDEWMCnx0UJzkfzcYOKvDqQGbbuFbDaGQihKcaHs18VvPdL4by2i4o4WgGH9PQ==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by PR3PR08MB5865.eurprd08.prod.outlook.com (2603:10a6:102:92::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Wed, 1 Mar
 2023 14:08:01 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::27d4:87f6:273e:4a80]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::27d4:87f6:273e:4a80%7]) with mapi id 15.20.6134.025; Wed, 1 Mar 2023
 14:08:01 +0000
From:   Ken Sloat <ken.s@variscite.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
CC:     Michael Hennerich <michael.hennerich@analog.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ken Sloat <ken.s@variscite.com>
Subject: RE: [PATCH v1] net: phy: adin: Add flags to disable enhanced link
 detection
Thread-Topic: [PATCH v1] net: phy: adin: Add flags to disable enhanced link
 detection
Thread-Index: AQHZS4L7Pv2IgKC+70qPmaRcnFBcv67kcbqAgAAD6KCAAANXgIAAzIOAgACfsACAAADx8A==
Date:   Wed, 1 Mar 2023 14:08:01 +0000
Message-ID: <DU0PR08MB9003892BC6DFC96B5FCC5ED5ECAD9@DU0PR08MB9003.eurprd08.prod.outlook.com>
References: <20230228144056.2246114-1-ken.s@variscite.com>
 <Y/4VV6MwM9xA/3KD@lunn.ch>
 <DU0PR08MB900305C9B7DD4460ED29F5FBECAC9@DU0PR08MB9003.eurprd08.prod.outlook.com>
 <Y/4ba4s37NayCIwW@lunn.ch> <20230228193105.0f378a9d@kernel.org>
 <Y/9M7nPZk8qMt0ZO@lunn.ch>
In-Reply-To: <Y/9M7nPZk8qMt0ZO@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR08MB9003:EE_|PR3PR08MB5865:EE_
x-ms-office365-filtering-correlation-id: 068f084f-d22f-41f5-d612-08db1a5e5e55
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ojajfaYG0lpcBNJ9TCM8Ii4kOBWMN2QzT2r45SAM5QNUzYaMyZGx9oYIBOfQN3bEgQQkeXoZBrq5Gf0AmQoVQRTiVAW2lPLnkZ5m/+TxMN1qR5G+POXxxMyTCVzL6/nOS2GLcdGKINbzaBuzTpegYO59rdli48PHR/CiRZYGzxS/PxagzYNBAG3d3M+BlVOscoGNXAAIYd2Pg6vRyIoEwUQoAm8zBggEuO2ZZJtKsJIIfrIoZ4wHuCzLSrBPcunwgQUT7KnmeWlJBgh4AtMKXuU6D2fDfUHehdWoTVQGDdRkBqWF16rx4SDbQbhxz2woRn/vWWPsD/nS2KfpuPye6ZYyZbPAsa23fi9s6baMqvcLly0C0PYfSQhLO5yXUDCTt2PtSf+mBbzsapcCvAP9GVqkLKT6nMmlm0ZSVi4Hn3WaTW13NF04mpyaJ0u9hjTC5OBlrRDtsZSHCPzcXaEu6HkVKbTlEhBdjsAwaGHa+W+SD18nNtH0RywJ+12u/q4KaHlkGQYhgnprWUabYiMMSxknbZY9+f+BMvfWnsrWzBrfl0+qImRBn+7j+RqZIJoG8Y230rdn/+OYYbd0tdca6DNbOdDqI8UKmsQSBKsQy9SFdk1AN4MAHUI5Q73/o9g4feBUsx83ROmtuL4KD2g9ASwNUr+beUwz0noSIqSqaN6eSsoiEuIPP/01RZjBTAGi27AEp4ainiwxObkpuXRi7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39850400004)(366004)(396003)(136003)(376002)(346002)(451199018)(64756008)(6506007)(83380400001)(52536014)(186003)(26005)(9686003)(53546011)(110136005)(107886003)(316002)(54906003)(7696005)(2906002)(71200400001)(38070700005)(55016003)(66446008)(41300700001)(33656002)(86362001)(122000001)(8936002)(8676002)(38100700002)(76116006)(5660300002)(66946007)(66476007)(4326008)(478600001)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KXKoFGS5TSuqzE5l9Tk6MBy2L1hnYa9mUTdAEg7b0WRo/oW4OOGrVuZ99JJM?=
 =?us-ascii?Q?I9J0YdHjQFIb37Dy1rNVP/+vDI7gqqu+DhM7Hyfv2cLrUUlLtvOQ80bq+bxx?=
 =?us-ascii?Q?rd1v+pHTQDIOLNBGoZzvE2wKxf1vyjS+enLeFAx8P0SNDfxK4/ey/p+tTTaw?=
 =?us-ascii?Q?NF9BFi5bIhEXi3Xs2GV3tx0SPjXoGzkcTvP98i/gnDDTKwtx+kVm6U7Rooep?=
 =?us-ascii?Q?xJ3MK8BdmO+Ww2fc/FyjN9gO9unH282pJAuoUMmRytccu4AKu8tvhsDUZL2O?=
 =?us-ascii?Q?NRI44czJcq11JS8cnRbael+4PuiMfRvuSuN24wM9Ec1lmBh/BdEUsrclSg9R?=
 =?us-ascii?Q?ivxKC7o3w0yyuYtVBwIoff37Osc8P6TnQE5qZEyNrqGX9dgFiHwXtinWCKwb?=
 =?us-ascii?Q?uvHD3QNL5UpCE8mUUDw8xGddtWsDlg8jDmtyZ+iCXVbhd0EM9VORQX4wS8yi?=
 =?us-ascii?Q?BFL7W8HeNoPc+qQsoZo9mPJBtVF/tqGIJsuVBnBSIqaiEqZ1qU6xrcekPb8u?=
 =?us-ascii?Q?RLcEjD51wWHr+yhjPfQMFeatUDdXpKPTJ0JYVGiRGt8cN1DOznqw1hfQVUSP?=
 =?us-ascii?Q?UeMz2a4eiZUll/wgrGEU4TXiDxKYFE17QW9Pdk2CycVrorpRc6Tjng0e2X/p?=
 =?us-ascii?Q?9ihMAupga6DawCtk/efX/9aj0EP9EwGe7EGhi4p8jHaozuwizydK7VnazFuc?=
 =?us-ascii?Q?nsEDjWX1dmspAmAHnZZCzeukfcafY17wLkalfidqBPdzCWEduxRQCFkogLdP?=
 =?us-ascii?Q?GthDaeuqxv8DGXE6SB/LGziyFZ0c5u6deeWBQdPiO7bQ5lml5OdRWGKf3Yb+?=
 =?us-ascii?Q?iQAEpSpGyrsMBd91M4KHEnmF6gfKwln49hIcWWzIKSD3PPp+17q6vpvF/xTu?=
 =?us-ascii?Q?fZg+r8D0a7dZ6LuvvnyJyaVUu7YYeGAbUvn0OKyXKhJBSsObpe1WpY8hc+kN?=
 =?us-ascii?Q?xzucTc6qZI4QNb5Zw2WV4+PSbdud3CYyNCM8PuIZfhBINbKg9tWpF5iuyrtl?=
 =?us-ascii?Q?2WD7emtHUGx/22wXNeMo1d4ahqPGvN1VsQGNTf+Q+bIFXfYxBZaeHK3fC6ER?=
 =?us-ascii?Q?gdhWBgJ/X8Am5B6JN3B7iPPn7MAjHP/pwK4mQSprduEKFW3rtIah3vNAM+tE?=
 =?us-ascii?Q?GGGehtwvasi6DZ6NZR5X9c1pbxqd/+dH3VxFzHc1rbJ+TeNF28GQYYaUD6tJ?=
 =?us-ascii?Q?wPj1z9cUIL6v1VDCHPaSziAX+SdhmjIE6X8CkCntQpVDmVEHwcKQoKn4aVcU?=
 =?us-ascii?Q?zwlp5ZJ68mP1+jKuCQ1Wa5/iKXljV5BvKNDaPbviG0K+puEl3HPtu4VpuEIq?=
 =?us-ascii?Q?iX9gxE0Mz1z1zAG+hL4BSOC4eIftSPi8rMIPQpsoHY31sMck6DkJnAXewmYP?=
 =?us-ascii?Q?Yn6cJtk1B/R/L9Vi5wyceAVCyfJB233Iw9P6g0Gftp3o4V5gTA/eooa/4Uuj?=
 =?us-ascii?Q?s610nY5a7BlJ2VuaSi87I0/D6bLkBm119GIy3PSNflFqvfILFAt6gB9XF2WC?=
 =?us-ascii?Q?+yCqI+vFvJFtE+B0Opvkk0OlqwYTrlhREU12pQY/h/5UGeXN1wTDpmu0Aaa2?=
 =?us-ascii?Q?ADIENLyL1pyW19alXEVbdCb/VmwnJjjb8uch69+H?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 068f084f-d22f-41f5-d612-08db1a5e5e55
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2023 14:08:01.4832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T+upMAagMiMe1NHaxaqyLU+47dt9Wkw4ayaPf5Hb0vdShjZ1g+E7Yla4HGYKZsnODGsbIpxVjIQJuSuVtTLqow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5865
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, March 1, 2023 8:03 AM
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: Ken Sloat <ken.s@variscite.com>; Michael Hennerich
> <michael.hennerich@analog.com>; Heiner Kallweit
> <hkallweit1@gmail.com>; Russell King <linux@armlinux.org.uk>; David S.
> Miller <davem@davemloft.net>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH v1] net: phy: adin: Add flags to disable enhanced lin=
k
> detection
>=20
> On Tue, Feb 28, 2023 at 07:31:05PM -0800, Jakub Kicinski wrote:
> > On Tue, 28 Feb 2023 16:19:07 +0100 Andrew Lunn wrote:
> > > The Marvell PHYs also support a fast link down mode, so i think
> > > using fast link down everywhere, in the code and the commit message
> > > would be good. How about adin_fast_down_disable().
> >
> > Noob question - does this "break the IEEE standard" from the MAC<>PHY
> > perspective or the media perspective? I'm guessing it's the former and
> > the setting will depend on the MAC, given configuration via the DT?
>=20
> IEEE 802.3 says something like you need to wait 1 second before declaring
> the link down. For applications like MetroLAN, 1 second is too long, they
> want to know within something like 50ms so they can swap to a hot standby=
.
>=20
> Marvell PHYs have something similar, there is a register you can poke to
> shorten the time it waits until it declares the link down. I'm sure other=
s PHYs
> have it too.
>=20
> Ah, we already have a PHY tunable for it, ETHTOOL_PHY_FAST_LINK_DOWN.
> I had forgotten about that. The Marvell PHY supports its.
>=20
> So i have two questions i guess:
>=20
> 1) Since it is not compliant with 802.3 by default, do we actually want i=
t
> disabled by default? But is that going to cause regressions?
> Or there devices actually making use of this feature of this PHY?
>=20
I would think you have a risk here like you said of regression, perhaps som=
e users are not even aware of this feature, but their system is somehow rel=
iant on it.

I am not an IEEE expert, but by examining the datasheet, we can see that cl=
earing this bit alone does not guarantee IEEE compliance. There is another =
related feature, which is "1000BASE-T retrain" which is disabled by default=
 because as the datasheet explains, it should not be enabled when "Enhanced=
 Link Detection" is enabled (default). It further explains that "Clause 40.=
4.6.1 of Standard 802.3 requires a PHY that is operating in 1000BASE-T mode=
 to retrain if it detects that its receiver status is not okay." So technic=
ally, you would also need to reverse this default as well if IEEE complianc=
e was the goal - and perhaps there are even others.=20

The motivating reason for this change is a customer is having broken link i=
ssues, and as the ADI datasheet suggests "Having enhanced link detection en=
abled is not suitable for all applications because it causes the PHY to rea=
ct quickly to high levels of disturbance on the MDI lines. This configurati=
on needs to be considered when performing conformance testing and EMC testi=
ng where the media-dependent interface can be exposed to fast transients. T=
hese transients may trigger enhanced link detection to bring the link down =
during such tests. In this case, it is preferred to configure all bits in t=
he FLD_EN register to 0."

Moreover, defaulting it to opposite the HW default might be confusing for a=
 user inspecting the datasheet. If we provide a parameter though, we allow =
for a reasonable way to override it if the feature causes a problem for the=
 user.

> 2) Rather than a vendor specific DT bool to disable it, should we add a g=
eneric
> DT property listing the actual delay in milliseconds, which basically doe=
s what
> the PHY tunable does.
>=20
> I think the answer to the second question should be Yes. It is a bit more
> effort for this change, but is a generic solution.
>=20
How would the new structure look in your mind? I can foresee two obvious im=
plementations:

1. Each PHY driver that wants to implement this feature would add a device_=
property_read_u32() call to read some DT param like "fast-down-threshold-ms=
" and then set associated registers.

2. The dt portion of #1 is done at a higher level which then calls down to =
the phy set_tunable with ETHTOOL_PHY_FAST_LINK_DOWN (not sure if that's pro=
per or not). In the ADIN case, this has the added benefit of providing the =
ability for ethtool to set this.

I also see further complication with the ADIN PHY though. This PHY doesn't =
support a threshold value, but rather this feature is full on or full off. =
While it is not hard to just compare if set >=3D 750 mS and then turn featu=
re off, as the datasheet says "more than either 350 ms or 750 ms in 1000BAS=
E-T, depending if the PHY is 1000BASE-T master or 1000BASE-T slave." Also, =
I am not sure what the standard says about 100BASE-TX and if you see in my =
changes there are separate bit sets for each - hence the two properties.

> I was pondering the first question while reviewing and decided to say
> nothing. There is a danger of regressions. But as this case shows, it can=
 also
> cause problems.
>=20
> 	  Andrew

Perhaps I am overcomplicating this, but I am open to suggestions and will a=
wait your feedback.

Thanks!

Sincerely,
Ken Sloat
