Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0285C6A5B74
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 16:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjB1POG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 10:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjB1POF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 10:14:05 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2084.outbound.protection.outlook.com [40.107.6.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3316E15560;
        Tue, 28 Feb 2023 07:14:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljFcxT5uXW/TZQu9xJkYJDZRk6CPKVu8sz92b+UGRD9is9Cn5i6JrvVWGavfV3MsfvU6LeTrCdkn6GyyxXLbp59sVsZVRTz+pXbQrkuULbtqh8a+ARf+YnmQOEvtwkeFZ6/Od5wn5eXnIt3u1MmWAufQYkQGNq60HMjh1I+aYtQ0+UkJP1BGjGw+knM1AFSrwnjgdu66ff0V8GMcyDEQRuzpo5D8+ueXEKAp93d9zL85OwqTqjhNkAzGmQGvEYQ0T+ImSINMYBkMFppQr/tGiORsSdO7JnSdw4ZPQsorQgZCjrznsJxc6E4Ul/zgmsxC2fqtZMyHZ2fPeOty+SSVSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z9ocVR+INepJPXfmDoeKI3xakhY+tElQzbWi31nFuzs=;
 b=nEeAsDGTxvKMwj7ZRw2DPAtVPIknupguHneRzh57wDBEMHcaHhVM/tZqI1nWGSVxRoBFWDApkKK5fe+z8eRd8rcUt8+JTTRzFM9e4EmK8OSbG30A6z89h612xLqb70hhaccf5bya21COQ6IKxh/5pFSP1O33CCm30eq5v/cWJyEjwpeyQ87S/i59ju036u2F2k6uUTXwoXLwKq97vBbFneksSlzbIOdXlgqYMGsUm79ayYVKWfdMXrX81KU1+UclCZcR31oe+3iB4gPTlUf5ejhYpBpbEMhS8nyMkCayzSNWgPkI2wMd+QB+0xETb6XsFTp8CA+QQ052yX9t6Hy7NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9ocVR+INepJPXfmDoeKI3xakhY+tElQzbWi31nFuzs=;
 b=mJUg2h5m+VkqP7Xo6CYsguYjL2LSVX7Qbo/h3JMEiKJIMv0bYf25OhDc7RTnDCWS3rT+KgHa4tLu28neLI60fWNon4Ya8ZkUz5WPvLvnrgwyJ4sHT3tUsIOaXeos5ukSMgj2HRWvil48wOIb6zMflBQ42tZoUjw+EhYYENmHqAf5Zopy4hvEIU42q+mQ0fIoTa7L3l/1XCmfk4LZtKuz/sIjdkhkRDbS1cMt0X5ouVoMaIndvbMXPfB+hPqOy3viVDm9li44ZVlJ1A/6MlbQ6BrtjycnqCBeSib6+YBzbUd2KP/wkT5AzTCzdNqt4qb3yHos/FIh0O8e+jWcfC6YiQ==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by AS2PR08MB9102.eurprd08.prod.outlook.com (2603:10a6:20b:5fc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 15:13:59 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::27d4:87f6:273e:4a80]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::27d4:87f6:273e:4a80%7]) with mapi id 15.20.6134.025; Tue, 28 Feb 2023
 15:13:59 +0000
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
Thread-Index: AQHZS4L7Pv2IgKC+70qPmaRcnFBcv67kcbqAgAAD6KA=
Date:   Tue, 28 Feb 2023 15:13:59 +0000
Message-ID: <DU0PR08MB900305C9B7DD4460ED29F5FBECAC9@DU0PR08MB9003.eurprd08.prod.outlook.com>
References: <20230228144056.2246114-1-ken.s@variscite.com>
 <Y/4VV6MwM9xA/3KD@lunn.ch>
In-Reply-To: <Y/4VV6MwM9xA/3KD@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR08MB9003:EE_|AS2PR08MB9102:EE_
x-ms-office365-filtering-correlation-id: 3cfc3d8e-0b7b-478b-ac2c-08db199e6b30
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KEqbdA1OwbBWugFh72aq6e4lWTQR/nNgNkJcL5FkBWX3dvv2Ubpdelef5Lpk2dPkckjwwxHtNmaZEe1zsAeKhDDGvRaOsibXdtyPYUbnEUg1zfu3c67ZenBUi9O5OY4RDubsSFaf0QHqhGavl9NIC8bsGZe0+HgBdBC19BABx69njaq4csg9lb23NA3rRJUsFASC3N7tvGulrd6NVlLlFRKh2v3JSfpdiuSdCvuCJON+ro97QEwhOQcIgNaYyElxsbkCASUGjgW97dVm8SywoHkZuaMgga7kfZ3gnH3rBLC7P3HogDu/FzwwzQyudO/0XhtHDdEIVPHFS9BrNPAqNlO5F8oBk04PETr/291Im0q4bAiJhpG2c6L6DWLYcYw67XNoBWNRrW96TbmXJFNeCkrctdaiPAOuBWfS3Qb0+5pe13TeuZdM0TTovvJNLkc8HFYB9DUT09JWsPYU3xZdl3ZJ+8MUb1r9gwRdZDOmkz12VsYvUOxw0ICK/V+9pMYkTGwNED4VkP+5e2ePq/Sx0C/ik3tq5Q8TdJUCNjXlfivykY9s6DPxAb9e/+65Mz1IBboQxPNTuqkrTzuU9EYsQ/eQAR6lcLsyeTtjcxdnyE9mhk9QcVnMJRpmgjcec2eHbXv71BXzs0T70Gn/0Gt7WVcxQnSqWNnAkhl9h+PsS/IA8XNrVwjn74CjPmvRaqjy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(136003)(396003)(376002)(39840400004)(451199018)(54906003)(83380400001)(2906002)(316002)(186003)(9686003)(966005)(7696005)(26005)(33656002)(86362001)(107886003)(5660300002)(52536014)(122000001)(8936002)(55016003)(478600001)(38070700005)(38100700002)(41300700001)(53546011)(6506007)(71200400001)(66446008)(64756008)(8676002)(91956017)(66556008)(6916009)(66946007)(66476007)(4326008)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?UBpYQNnOtbqoYb/5tjhsHg3dMZi8Gn43uOqAlYysS20DF4Vt1RKDoGb6nw?=
 =?iso-8859-1?Q?WfFlwaNQTKSi8g+FLAZqRqpd7gAK2K1X372NVBOuEqCjJ/5mAXdKJnsm3z?=
 =?iso-8859-1?Q?aubXr4BVpYk7h9JDZYbokxC13/cx7v/aZ/gyqr4MSIJIebnBnvMOBMcRgA?=
 =?iso-8859-1?Q?nF/JFzKX+f7pVWExTz0pG+RNcYxQNelbKXuKmSLGWc9rbKjVEKVmmUQgeV?=
 =?iso-8859-1?Q?eOeGYM/z9FscnV0l/fmxLUhl/M39xU1rcTsEXQfOH97GK3Z2cp+qE/7KCe?=
 =?iso-8859-1?Q?2LOdC4fFLO95zBWAS/mI4xmfAAWpSv/u2xbfrZe2zeuX/wRoFMrkiPVh34?=
 =?iso-8859-1?Q?Hm9AcZeTEsxdvDDwacQHCGyKo2Ucb9ZT1ekAgIGQ6oTnDGvYftm6Kx4IGR?=
 =?iso-8859-1?Q?2LhJmfJ/XPn5v+V4KBhippw9c8ZPnILCKzz9XxmSGd/UQHJythWdN9FG6T?=
 =?iso-8859-1?Q?QEmyCiZfAaKAbt422aqvmGVIS37ZTWAtn1Nf3u6ekeOlxKFr3spSkaP4F4?=
 =?iso-8859-1?Q?H4yu6iUI5X+aSxOnzsCJDBfxHda+6TxjWKpaU85c9qKc2hweL9/J1epdG2?=
 =?iso-8859-1?Q?slt7EGEc2779G19616SWVS21CspS4x8zD40IdBTAc2upwiPB74hQ5uvaD6?=
 =?iso-8859-1?Q?QfCF2Z9917kfpI8AExKztbxeKSLWm/zvIGgZ6j2GL17CGQnr8P5yjFfBN7?=
 =?iso-8859-1?Q?tAPm2Jl+t628Qy9baczqBAs03KUOAB5QaVwcJi0T72j2VVwzyXkw4CzKA+?=
 =?iso-8859-1?Q?jjotRFgLEkDbChfYjHvG2bdydvWuKLmA75vsQG1i0TS63eqTERxNQsx7BA?=
 =?iso-8859-1?Q?ceS2ybmzAHkG/hcctEOco8n9I9CLXCzEn2h0RDlrf6jGVk8SOYBkDm4WnJ?=
 =?iso-8859-1?Q?/ySujDPN9GMmJYxvx5UT0cIcfkz/S2z76uN7GZMFlJ9k1FxvrNNBhu7z8Z?=
 =?iso-8859-1?Q?LYyM/8ypwK0yMvKq8Pu9FP6mu4xf6ZXmtCAV7bBb5sTLYE9LT0zcA/WIpr?=
 =?iso-8859-1?Q?MbD7qD9pjiqMFmniXX9e/cssjoRYWhZPlehpbN3+eY4/Hr2j8jSiW+Y6n8?=
 =?iso-8859-1?Q?oEQnmhQzAd1aitHoqdRHPR1qOlx3tJLA7gKijd4R/HNd4w5aMq6KiLbReo?=
 =?iso-8859-1?Q?qfU6wcIz0Fs5OcJYlPC4KL5cFI/PgYYVkEEYMmIIuijxbzgO9WPA5qALSy?=
 =?iso-8859-1?Q?JULHOvVSlRd+LyFojqXPr9a/+CLOHtA1rgCP6mL43oLJbOQmLfhqvQAziB?=
 =?iso-8859-1?Q?TsNq2bmSRP6p742motcJGhd+O/Oypo865tX4IeWcGF7bkDriHgBIg37UKR?=
 =?iso-8859-1?Q?zEDZUTyK43R0fCJ71VijnlYISxO3B8Jr781O6bwhKRpbGDZnNd3ktX4kkk?=
 =?iso-8859-1?Q?IxgsfBm8N7JV6bd98E9X1yzds6+lnR03tpTTg0k9HzrjlvYLyrKpYTFrUx?=
 =?iso-8859-1?Q?XHWRtlF9+tTQm5OW96fRzlneOg0quEKC1xMIcp0XXldxQc3hVrpJIdm9ie?=
 =?iso-8859-1?Q?MhWWxE1Gy5+GS6Bi5FGT/dAmIX2LhHvCXsg2pyUdImkHIvWbAy3Duou0uv?=
 =?iso-8859-1?Q?crar2S8CTdiz4T0efy2yfzLC5oI/fBYwwaOiK0/s9ofEZMxeUpJfhtzp2F?=
 =?iso-8859-1?Q?E6Qsbeh6vFmLM=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cfc3d8e-0b7b-478b-ac2c-08db199e6b30
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 15:13:59.6467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KoREDX5jNm3iVA8HyctYg8XlD0YXfxVioQ5n3BSwlcLP1vDcZWroOCcr7ZD9wfAW+fPcMQM8HTrZ6N81J4mmIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9102
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,=0A=
=0A=
Thanks for your quick reply!=0A=
=0A=
> -----Original Message-----=0A=
> From: Andrew Lunn <andrew@lunn.ch>=0A=
> Sent: Tuesday, February 28, 2023 9:53 AM=0A=
> To: Ken Sloat <ken.s@variscite.com>=0A=
> Cc: Michael Hennerich <michael.hennerich@analog.com>; Heiner Kallweit=0A=
> <hkallweit1@gmail.com>; Russell King <linux@armlinux.org.uk>; David S.=0A=
> Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;=0A=
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org=0A=
> Subject: Re: [PATCH v1] net: phy: adin: Add flags to disable enhanced lin=
k=0A=
> detection=0A=
> =0A=
> On Tue, Feb 28, 2023 at 09:40:56AM -0500, Ken Sloat wrote:=0A=
> > Enhanced link detection is an ADI PHY feature that allows for earlier=
=0A=
> > detection of link down if certain signal conditions are met. This=0A=
> > feature is for the most part enabled by default on the PHY. This is=0A=
> > not suitable for all applications and breaks the IEEE standard as=0A=
> > explained in the ADI datasheet.=0A=
> >=0A=
> > To fix this, add override flags to disable enhanced link detection for=
=0A=
> > 1000BASE-T and 100BASE-TX respectively by clearing any related feature=
=0A=
> > enable bits.=0A=
> >=0A=
> > This new feature was tested on an ADIN1300 but according to the=0A=
> > datasheet applies equally for 100BASE-TX on the ADIN1200.=0A=
> >=0A=
> > Signed-off-by: Ken Sloat <ken.s@variscite.com>=0A=
> Hi Ken=0A=
> =0A=
> > +static int adin_config_fld_en(struct phy_device *phydev)=0A=
> =0A=
> Could we have a better name please. I guess it means Fast Link Down, but=
=0A=
> the commit messages talks about Enhanced link detection. This function is=
=0A=
> also not enabling fast link down, but disabling it, so _en seems wrong.=
=0A=
> =0A=
"Enhanced Link Detection" is the ADI term, but the associated register for =
controlling this feature is called "FLD_EN." I considered "ELD" as that mak=
es more sense language wise but it did not match the datasheet and did not =
want to invent a new term. I was not sure what the F was but perhaps you ar=
e right, as the link is brought down as part of this feature when condition=
s are met. I am guessing then that this FLD is a carryover from some initia=
l name of the feature that was later re-branded.=0A=
=0A=
I am happy to change fld -> eld or something else that might make more sens=
e for users and am open to any suggestions.=0A=
=0A=
> > +{=0A=
> > +	struct device *dev =3D &phydev->mdio.dev;=0A=
> > +	int reg;=0A=
> > +=0A=
> > +	reg =3D phy_read_mmd(phydev, MDIO_MMD_VEND1,=0A=
> ADIN1300_FLD_EN_REG);=0A=
> > +	if (reg < 0)=0A=
> > +		return reg;=0A=
> > +=0A=
> > +	if (device_property_read_bool(dev, "adi,disable-fld-1000base-t"))=0A=
> =0A=
> You need to document these two properties in the device tree binding.=0A=
> =0A=
=0A=
I already have a separate patch for this. I will send both patches when I r=
e-submit and CC additional parties.=0A=
=0A=
> Please also take a read of=0A=
> https://www.kernel.org/doc/html/latest/process/maintainer-=0A=
> netdev.html#netdev-faq=0A=
> =0A=
>     Andrew=0A=
=0A=
Sincerely,=0A=
Ken Sloat=0A=
