Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269886A5BEC
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 16:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjB1PaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 10:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjB1PaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 10:30:00 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2065.outbound.protection.outlook.com [40.107.22.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DC11EFE0;
        Tue, 28 Feb 2023 07:29:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4vASmkqA48N5bafE7oYPb9SsvqFXYOBjo1bhSLEuEyVHrC6H9N3dOaCoMF7O6xOyfua/eBZKLtYcvl+yYEkDBzNtqTwK9mU8owM7IuF549/OO5Lj3YEApceeUY1cdoMZALcX6gOyAiI2pxbpFjwcW3BypMvaawPwzuUWX+gPgPHTfK9lhlz4nQ5vJVLhpJvzEdD5qShA/O38pA0FMHZR+BKeHVet5dqU+qEdvIwfe47yMonZmDNCGqrmfSlSXgVLu12/oTWag++91RViigte5hByK5nRKdHC8tFrsKYpJLs3rhUuHSlHgby04RoJ9ETZs7ZB2ksHsMZXKlh1ZJ/QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8cdjCr1q3vFR62S8oi/0aRICRQcBWrP/qaaJcv1v8QE=;
 b=Mg60hN5HgkIJzpi1gkK7n3C5MhRZW+3Io4ndIPIwgxl+srDQNwnNp1vTYJpFuoNNVyIBd3DsdWLxDdGco9o2lTq8qOABrOWJ4lwNHJZziB3qQPs+HVh3cbBqPje42cZikhsk1awwMzZ4EcKDmPe3K7Ig4TV6x4cBtkfWZ91njZTJWlourdxhcYN2vBWcGuB/Yh84LhLvCGt0lHGPjZQmPQg+kcOGFgZjxQUOnahML4NtiCYH6Jn47S95mx0Bp7reMZJtugIIUBe0HuvTGcFQPXCd6DVmuqcLaNKPHHbxLINAUeyp6JFSe9DnCY+NTMBYHTJTtbefjjgWPbCAb9G4Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cdjCr1q3vFR62S8oi/0aRICRQcBWrP/qaaJcv1v8QE=;
 b=nN+pOEf0pqmfGWWth9GMYd/EEHcj1nH34vP7D//RIlXyj8RxxE+dW3xIoqb49fWh9gfLISfnDXyVBcbh5pH6wCkAIN74CnHEwnWaXQdPF9DKI+k9A3gJKRSKGsoHTJ0PZsPf5cMRQW1xqam7j9UfhUGjCWFlSmZdDfZvXhuxAyxaUrqKa455r5KT2sMBCG/rDQ1U3O/+KpYJJRywMOZEjsS48VXJp88u9cMxiXph0IkOam5IpoTOcb4SA5xMKFTmlBPYfaPr7LH04ooVSt3tnX7fQe0rxJj15CeNIobdSUZehEh3E9ia5cDdKLykJnq5JmW6oLUTO8EauKvDvP7c8Q==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by VE1PR08MB5838.eurprd08.prod.outlook.com (2603:10a6:800:1a7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 15:28:43 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::27d4:87f6:273e:4a80]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::27d4:87f6:273e:4a80%7]) with mapi id 15.20.6134.025; Tue, 28 Feb 2023
 15:28:43 +0000
From:   Ken Sloat <ken.s@variscite.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Michael Hennerich <michael.hennerich@analog.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ken Sloat <ken.s@variscite.com>
Subject: RE: [PATCH v1] net: phy: adin: Add flags to disable enhanced link
 detection
Thread-Topic: [PATCH v1] net: phy: adin: Add flags to disable enhanced link
 detection
Thread-Index: AQHZS4L7Pv2IgKC+70qPmaRcnFBcv67kcbqAgAAD6KCAAANXgIAAAYeA
Date:   Tue, 28 Feb 2023 15:28:43 +0000
Message-ID: <DU0PR08MB9003DF34A62F764A90F70FE5ECAC9@DU0PR08MB9003.eurprd08.prod.outlook.com>
References: <20230228144056.2246114-1-ken.s@variscite.com>
 <Y/4VV6MwM9xA/3KD@lunn.ch>
 <DU0PR08MB900305C9B7DD4460ED29F5FBECAC9@DU0PR08MB9003.eurprd08.prod.outlook.com>
 <Y/4ba4s37NayCIwW@lunn.ch>
In-Reply-To: <Y/4ba4s37NayCIwW@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR08MB9003:EE_|VE1PR08MB5838:EE_
x-ms-office365-filtering-correlation-id: 48a07229-e271-4dd9-98b0-08db19a079d9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qbSd4+g0JeTcjtniGjn3a0OChZGxncZnvnS1szHOzS1nMKKkGpy6lNEjzFarLiusm6AZdIrNUczS2Ohf+oB64d135McPMusR2RHnsaVJVJr183ozBgG5MB7BNGvZj4ZWQTkQkCY5oTKuzivFGc86SkjgJ8MDklVQENvqoBZyEV8AD33vGk3cXsfLsuMiG0a2jwYCLT1ruo1ked1H3pgHkHzJv+nimFEeoId24xWwqGnmlpHBc736u3hfIQ3vTo4z5SvcK/mNfN1kKqB5K39Pg6BAwKPi2c6QtTij9EqoUs9YWuy7WFD9JBSO9NYwjni6dA/Tl3nym0QmDG+6g5x+Hi6FuqeNDETiisZRmba5tlRh9YKXoDRfvOzebReFuzOXuOK5Bm65tUSkzRJmDb4SDo/ljavTSROc5ulcB18P3QJqIM2e8SH3zngLMuuZysrrDmNNPk+YvilLOR6lORJX+HQBaZN5uMHHb4LFLM61AuzD2xsSg2G6FUYzH092z9npA9KnTr9m+FkxU+j7ZaixGix8P4h/PmDTv4QBuRBCD+orgt1KwcylswxP1lDkrYgVtMwAIbLoQTWtCWll1alaIPrb774SbEaSdCTrnuhQF3pCnZ+b7k10Il045TTtLVHFesSP9ZIVGiT3QrpJh1PrnyJHuW5tqTNSAhNwnGkTagwCjoDZ5zIADxFBpEK8o17BiAWvNnlpJnuVgOJu5ACHNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(366004)(396003)(39840400004)(376002)(451199018)(83380400001)(5660300002)(2906002)(41300700001)(186003)(53546011)(8936002)(107886003)(26005)(38070700005)(52536014)(6506007)(122000001)(66446008)(64756008)(38100700002)(66556008)(4326008)(9686003)(6916009)(66476007)(8676002)(76116006)(66946007)(33656002)(55016003)(54906003)(86362001)(316002)(478600001)(71200400001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VLfFdDZnOLg9zZkeVWZ7k+PS+nuI/5ZrMn69H9lrdoAQqja2ZWxOuc2wF6ab?=
 =?us-ascii?Q?k+PosvgJcI9S/ju6SWzfMz4wsrtTiPU0dKsopwRB90VOaASnEtZv8NcHAe9j?=
 =?us-ascii?Q?UWkVQWIAg/XepfQ2i2Lhm+m8hkxC3C4mcVuXvN/33WR0GGWe0+r8bWge9d0E?=
 =?us-ascii?Q?XsCu2dFUs8Uf5A2RyR8+ANQOxefYZe/EklNvz7i4eleOW1ou8FtqYsvbBfjN?=
 =?us-ascii?Q?+0NkmyZvVCqoB+p/UYqS8x2cJ2KTBuHBDapeS6gCU47vlV2OjmfMAptV9LGQ?=
 =?us-ascii?Q?OxQLCQladYm92caLGE5CFuuJ8fuE7u+4E4Zc6VyPxkJdoJuUvqe71ujupiO6?=
 =?us-ascii?Q?KS+X+aP7U1VvIHXRadbuzcUaylJoeVzrgSojhPckakDP0WwrA8w4rYxpUP97?=
 =?us-ascii?Q?MTnRm5PeNJQvW+lqMQCLznAAhM91AcmHaiPLY02WexHkC7GS0/9vx3ah/QZ3?=
 =?us-ascii?Q?rZTo6fc6FeJyYxApvcfVu6PVdNq77yAr8YDLvW1s69wTJ4/fSeWEH25J3lon?=
 =?us-ascii?Q?BenCAfs3R11/8yxxtzYKy6+Do5NnJkaICUhFx22L5i9gvIW63CqxM9xZZtg7?=
 =?us-ascii?Q?6PsEbQQ3tSSOht1LosB+0WfMfT2wgVmvXLDxP6DOMuf9RT+fL76njN+Z/4KF?=
 =?us-ascii?Q?92cFuy/PT4qtSc+L861Ts0f7U/lX18TVymDCKd8LYipIE4yXDgzSgIO/VUmD?=
 =?us-ascii?Q?dtqQFTpGb8H66mCKz0KOfT0ygZsuZDpAdyJ/sSGV/DlPS717t+gYAfecrdr8?=
 =?us-ascii?Q?wWCS+y0O5gB0wtE/s66w8qYufJdR6mUsJfBeEy4UcMjPX9tvjwNttD+JIv01?=
 =?us-ascii?Q?84UprVr5mI1TQM6S3chYxRYDrBLhiv0jJLP8aCrMe3SuVpgNqORffIrlIGi6?=
 =?us-ascii?Q?a85xt8n3bdoltv2mTgo5JaPgB2MiTWkyF2st8PC+KylXMtezToOmAPhYJLhX?=
 =?us-ascii?Q?NNaBjk60jSPCJ03AUpJvSfZzOFDhfN28uq2YR4+hSQr+TNlNp8N8nLBfDr0A?=
 =?us-ascii?Q?B4saWT+JGHlWDi6EMZufzH8crp40X7c1lt25FHmWNOiXWYMbgODMZbG4l65b?=
 =?us-ascii?Q?YI+Rp9NrIkfPuEvMVLKjHfZtCSMPbJHeqMx0ZP8iN4OUDEy7nAZ+mZDbSHCu?=
 =?us-ascii?Q?7RFUr20kaBeH3Pi5BCtSnvu2tFOK/a5jWJ0oDxL1iEQt6Q8v2ro2qoR9aNyW?=
 =?us-ascii?Q?XE45jTGfi0N5FXIY3hT5ZgNaZ4+vZBUQ5FFJmzz5AQJTkIDffSdtz8XMXcna?=
 =?us-ascii?Q?OobAxE9blBSErL9UF/kqakbIixHv8xbtTI0D2wDE5OmoQ719lI2wjEg/FTuD?=
 =?us-ascii?Q?Eaps2JR1OjZdOoLz+DhP85wSqg05OMr8bdEeagQN2ZFM9Q/+M+eTe1A0u0h8?=
 =?us-ascii?Q?bc69dKzRF408ObOIBUoxA68eDjefTpSRNdz6W4Ls8Ef+w19nH7VSvX/5RqW1?=
 =?us-ascii?Q?8qexVLvsDwG0V7zWalDCoa+xoCWPmguYodTXpDZzjTscmELcbeUjW2Jgk/tW?=
 =?us-ascii?Q?gWejeMAAYC8l8lfxL7aIcIWUgehSB6DusTX7DZJ8wUtO/ap7YnyLFve81MdB?=
 =?us-ascii?Q?tCBWMuZM6PenzvNVyi3pDLGtCIXQlWNfEibpnqEP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48a07229-e271-4dd9-98b0-08db19a079d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 15:28:43.2353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cOWoBep7EMF4VeuvEHTPrmI2krI6govk4kijdlQea1A0AsRh9tVdiIgyN97KqJd+31PXuEXnzDObsewos4faTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5838
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Andrew!

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, February 28, 2023 10:19 AM
> To: Ken Sloat <ken.s@variscite.com>
> Cc: Michael Hennerich <michael.hennerich@analog.com>; Heiner Kallweit
> <hkallweit1@gmail.com>; Russell King <linux@armlinux.org.uk>; David S.
> Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v1] net: phy: adin: Add flags to disable enhanced lin=
k
> detection
>=20
> On Tue, Feb 28, 2023 at 03:13:59PM +0000, Ken Sloat wrote:
> > Hi Andrew,
> >
> > Thanks for your quick reply!
> >
> > > -----Original Message-----
> > > From: Andrew Lunn <andrew@lunn.ch>
> > > Sent: Tuesday, February 28, 2023 9:53 AM
> > > To: Ken Sloat <ken.s@variscite.com>
> > > Cc: Michael Hennerich <michael.hennerich@analog.com>; Heiner
> > > Kallweit <hkallweit1@gmail.com>; Russell King <linux@armlinux.org.uk>=
;
> David S.
> > > Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH v1] net: phy: adin: Add flags to disable
> > > enhanced link detection
> > >
> > > On Tue, Feb 28, 2023 at 09:40:56AM -0500, Ken Sloat wrote:
> > > > Enhanced link detection is an ADI PHY feature that allows for
> > > > earlier detection of link down if certain signal conditions are
> > > > met. This feature is for the most part enabled by default on the
> > > > PHY. This is not suitable for all applications and breaks the IEEE
> > > > standard as explained in the ADI datasheet.
> > > >
> > > > To fix this, add override flags to disable enhanced link detection
> > > > for 1000BASE-T and 100BASE-TX respectively by clearing any related
> > > > feature enable bits.
> > > >
> > > > This new feature was tested on an ADIN1300 but according to the
> > > > datasheet applies equally for 100BASE-TX on the ADIN1200.
> > > >
> > > > Signed-off-by: Ken Sloat <ken.s@variscite.com>
> > > Hi Ken
> > >
> > > > +static int adin_config_fld_en(struct phy_device *phydev)
> > >
> > > Could we have a better name please. I guess it means Fast Link Down,
> > > but the commit messages talks about Enhanced link detection. This
> > > function is also not enabling fast link down, but disabling it, so _e=
n seems
> wrong.
> > >
> > "Enhanced Link Detection" is the ADI term, but the associated register =
for
> controlling this feature is called "FLD_EN." I considered "ELD" as that m=
akes
> more sense language wise but it did not match the datasheet and did not
> want to invent a new term. I was not sure what the F was but perhaps you
> are right, as the link is brought down as part of this feature when condi=
tions
> are met. I am guessing then that this FLD is a carryover from some initia=
l
> name of the feature that was later re-branded.
> >
> > I am happy to change fld -> eld or something else that might make more
> sense for users and am open to any suggestions.
>=20
> The Marvell PHYs also support a fast link down mode, so i think using fas=
t link
> down everywhere, in the code and the commit message would be good.
> How about adin_fast_down_disable().
>=20
I am good with that. I'll probably also make mention in the comment along w=
ith that ADI's term for thoroughness.

What about for the bindings, how is something like "adi,disable-fast-down-1=
000base-t?"

> > > You need to document these two properties in the device tree binding.
> > >
> >
> > I already have a separate patch for this. I will send both patches
> > when I re-submit and CC additional parties.
>=20
> It is normal to submit them together as a patch set. What generally happe=
ns
> is that the DT maintainers ACK the documentation patch, and then it gets
> merged via the netdev tree.
>=20
Good to know thanks!

>    Andrew

Sincerely,
Ken Sloat
