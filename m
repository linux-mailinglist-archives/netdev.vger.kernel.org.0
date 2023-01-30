Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64D26805BF
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 06:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235676AbjA3FwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 00:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjA3FwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 00:52:19 -0500
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2120.outbound.protection.outlook.com [40.107.117.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98DB1C5A1;
        Sun, 29 Jan 2023 21:52:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZZjq7RB0PEdKrZTi72jc6z0PyFpXjItqa6wvL23mpq/abJ0XI5CP6yz8q+H4QepiQcecbwverd54KJVJY5n2/rQwX23c3I5+uxemi8IdrQ8ptgsGDaROB3BCt6/ydnnm07qQmegiM2/nLbGQHpC4uZyRtuaEOih7vbrIu3TFuQ8DvLsiuKQC25yd0gxGu4AS5RICcxVjpvyclUH2A1aO8IgslctZ91WRLfRo/xIYiGPsmM1AWk6JqAkhmmiNdjXPAYHZLizQHB8ifYm+CFo6vZ7YsJXdbqJYz6CwWLRJTS4AyXuQaKnBQtYQscC0vwhJ5MdbCRroekUtQgXR/mleQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gJ9lA1WqAQD6cDQpCdokNkTio2uso0WECXo6Tr83x8c=;
 b=eBA2yw4qJn7M5YoX+tkHZG9GYP34Ezyi8SPlFYfG7z/68d7f1+1S29Ckpfn5bURH0xLZ1g534XezWQFUlIHdMcMVYGwVE4hveJgwvqrM+xuuQWsi89vcOeBk8WasFHMkWaIXeYRNaWb5e2phyx8E+QHxqXBL8YyKr8Ur9i48rldmGdQtKofAYilx+lTh4ViKvxe3vC5s7cMMyenKUHkJ0BTwraEtNC71OJBwxaimjzwGJqrPjuq1oaDvNHeLWReS4yawN7uacy48Fhygoam1OoHCxkLJEJx6ruLzMSvgJ5cNMToVIRNvS/QKo43wGL0aR8f+sOwuNGt0IPTXHcT/UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gJ9lA1WqAQD6cDQpCdokNkTio2uso0WECXo6Tr83x8c=;
 b=eARpHD22Wq9gedcjDUwhIehoVzOARJNSiGIXxz0NB/FupkoEpMgPxM3OtY5PDYqq/VNPEvlsgQQxV1X/WJnFgBZZ8x686/5DN4nnYO46FKCJyEdm1YQWZGokQe6PByZyyZl2ad2gRESj43t5mNjxCDuEdVVdgYb1+AHqSw0C8gg=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TY3PR01MB11380.jpnprd01.prod.outlook.com
 (2603:1096:400:374::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Mon, 30 Jan
 2023 05:52:15 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18%9]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 05:52:15 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next v4 4/4] net: ethernet: renesas: rswitch: Add
 phy_power_{on,off}() calling
Thread-Topic: [PATCH net-next v4 4/4] net: ethernet: renesas: rswitch: Add
 phy_power_{on,off}() calling
Thread-Index: AQHZMltXgpqNi25oAEyoDsoqfmCDMa6yYD0AgAPiknA=
Date:   Mon, 30 Jan 2023 05:52:15 +0000
Message-ID: <TYBPR01MB534129FDE16A6DB654486671D8D39@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230127142621.1761278-1-yoshihiro.shimoda.uh@renesas.com>
 <20230127142621.1761278-5-yoshihiro.shimoda.uh@renesas.com>
 <Y9PrDPPbtIClVtB4@shell.armlinux.org.uk>
In-Reply-To: <Y9PrDPPbtIClVtB4@shell.armlinux.org.uk>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TY3PR01MB11380:EE_
x-ms-office365-filtering-correlation-id: 87ad8554-e913-452b-d84a-08db0286241e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1T4kAyoLdM5ir79hfVw3lP/d5TcoJ2zbSkACA3EeWabOcVItvfqLLYtvk3XW4j6kmjtHo3hqpu02uTquqJq7ZpUkmjlQrBSYTAeNZ97q2VKw3iWGFg5iqNxBacu/lVmi3G0AbwP81wvkldlAVCgxVyDNuj8f3CYS2uze2oefuhslBjgiHpaRLkTfC/Alfd6QVRlsFVBOvEnn2eTx5HOGBL2/k8NZu+8gRP3fx36xmE9YLAPqoAhnfsy7ed7xbbLvihy0KnUkvpKvUfkNeQt5hPYfvT4/jNlDMvY0aghR8WOBffCtLJAO+lLLoptzaycadG3wp0MDOeRm3ZXs9ITu6IyzK6TdXgO6MCGfZFQyP5gUwpiXSTxoiQiP0g2vqhzmTY054mID9OYZeMSevGa0vYj9xzYjc34U4KnIRxpR7GE/f11OF5YP1tzEUuxAe8Jpwcxs94OiSKQcgRnMT1lTbvzzFQ/86XRPwhuA9WtBhGsFaNf1BN+Sd9xU4aIBFkqFwmkuLsxW5ehYp1voQs7ffiNQsKorVub2IKIMhkeY0mSeXvkIEsKWVAbcx3cZ05HZrttWBHsWMNOvK3cebJT/RuBUPcK3oJd5X4l0UQGL+FUTpqtEPVjNOsN2ZD4JAoFK9oblDgYPVwPZl9nnCP0LAX3qxGKP6hJNXigJbaC0sjKVI2XprLHmRppUnnUjqM5nVTMYePxbX73QZjpmgFTm2dFNvcwEDQse6mZ/8JboSy//6hxRI01951W5Gv5aedODYGJSlGXH5Q51Zf6CMPLmwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(451199018)(9686003)(71200400001)(7696005)(186003)(6506007)(478600001)(2906002)(966005)(64756008)(66446008)(4326008)(66556008)(76116006)(54906003)(66476007)(8676002)(66946007)(6916009)(316002)(41300700001)(5660300002)(52536014)(8936002)(122000001)(38100700002)(86362001)(38070700005)(33656002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yqz06pp3ks68dZvmmGEu2Ubk9opuxagGsUnfi8sHZebFyBHlpBk1tz9U4nng?=
 =?us-ascii?Q?F8kysYMfdhgW1Zv2AezRDVVuQ21kFz/2bTLmOL9EHtRmXX02DvyjUhGsPcud?=
 =?us-ascii?Q?2h25QmYFEVjx4gbD2kz83q1fixxSoq1EBdrVYWAtqmLJv01Y9BKiQP4mcdtt?=
 =?us-ascii?Q?012mjvYsMJIpe9wy8/rRk4PGcEI4o4YBCLArpmakM0pdCx3UAqSWlSDnWSbK?=
 =?us-ascii?Q?KCcI4+mcork0i6m2sf5NykEkFJG0sWAtVqAa994jbfe8F8ddagBNCNT4aOFT?=
 =?us-ascii?Q?oRdGCBT852tR6sx8kzbJ8XcQY9oN6l9CKDw/dJ2XbtGgAcM0Ta780LzU1d23?=
 =?us-ascii?Q?kwJpoC2wiyK50QhUglxih38T0bBxt/eIR+R/jMoC7c1G3rqGIoOqeEhRS9Dl?=
 =?us-ascii?Q?eXu094Kvs3VatYkcF6hwj7OItKYrak9kT/sXUjBQGCywL1QvW1YgXnFzzRQo?=
 =?us-ascii?Q?whR8qO9azwGRSVTntVBSYUgB73Dg/hs0pbtoBBebfhJx2OX5JrbOdleJYxcy?=
 =?us-ascii?Q?1lG4W2W+YmKKyoRC4d8XDju2/9AuprxO0npHnf9w8TTwFsOdXp0YNscSVaHP?=
 =?us-ascii?Q?tvMU5/ii2qNuSp4MRj5/6HabOx2kgiwn4sr9ON/Rdsc82lMwEoh96fCYsFKc?=
 =?us-ascii?Q?l1U5A29IAo2llHUqUwYDPmXEgkqz0qoloYjgCK3kWgzxfayE6fEew9SKGBjl?=
 =?us-ascii?Q?tFhy6jrniB8QgOrFvfeJVjoz3ywNCC235/KrrPnO76SmW36qkFeO+C61221v?=
 =?us-ascii?Q?nYNyzyzE7TPElNrL4Vr8qlC+FbBmw4sZscUyxZ3c4CRJV04oaiMFmtpbZdva?=
 =?us-ascii?Q?VSAe5s2Us1GPScloUHwNuq7PenAWkHazxTJKuczFvK1OuQQakawGwaKbD6Wv?=
 =?us-ascii?Q?0swwlKvz0bc9UvU6y+OfPdbCp6V/lquow4wjtfeVsWEosV3hgd8UUrMtDwZa?=
 =?us-ascii?Q?UaOCPgagnnMlGUIVNQF6I3ZBjB+woZinaIgJZvaahumfHKrR2E7sgV9Chthi?=
 =?us-ascii?Q?1fYEFMRE6cJ2XFx0rMwRRF8LmjOXeOBeNRQ1u9SvTqDLAJVOIfaIcYI3QBRL?=
 =?us-ascii?Q?uNNSTHvecPtW5iNP75Ac7q4WZQ1lSrn8Jh4CJqLdAlVCnDv092vMTuvCp+Ub?=
 =?us-ascii?Q?zqehB0fIwdB59/6fN23nqFg2NP2IcZDb9S89Am6ds3WIPRqQ4P9l4UIJQzim?=
 =?us-ascii?Q?SNUHrkR8edTRuqrw483fL1zXkpqCOOV47VEtFNMsp2b+81QeDZShQ32NBY6A?=
 =?us-ascii?Q?gMIAzUHfgk43ocQf8uARuGxYcwxjyK71QU0yg3emrV0t1KJRY7V1pmq8Ur4T?=
 =?us-ascii?Q?NT/nqNBvdTaq4lfCKnrernxo6MGgyzBWkcUbVwWEvmEd1dQXLj1UApz0xQFz?=
 =?us-ascii?Q?7w80ppYI3DX4wEvh7F43WWvvBb9XXu6eWIPz4eOCftwcLCru1iKTppZz0zN9?=
 =?us-ascii?Q?rxxdvP1xKEsdCxphfKAc6g2zcx+S0PExYdTlgSr00NNzWcARvBEu+w7yxy1O?=
 =?us-ascii?Q?hWL9WCiUY9aXnHqZ2CdUWO3huDDlo9771wqxPlP9kS/JFyiIwS4wUojgNfRz?=
 =?us-ascii?Q?IcfsDwYwblXRWM01sCO2lDEX4act52dDi0D8UI9ZFUV+uVTwkrKoltMBiRy5?=
 =?us-ascii?Q?2oHPr556Tcp+U/5DCt5oJ9D9eiqVGP3xbeXnUb3loCDvrzdbZCxZa25Jk4vd?=
 =?us-ascii?Q?dJt0Hg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87ad8554-e913-452b-d84a-08db0286241e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 05:52:15.7619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BtIA7TcNJwKDtC6lN3QgtRAux9Y5wuspwn9llPnScYhETPxIPrhWehDsfhDdzTIqaBKA+JIMqC78IueHTytvEhIXA9EPPYsitkYgXLTaPqDklAHcTY43nrp76f5L4Eph
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB11380
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

> From: Russell King, Sent: Saturday, January 28, 2023 12:18 AM
>=20
> On Fri, Jan 27, 2023 at 11:26:21PM +0900, Yoshihiro Shimoda wrote:
> > Some Ethernet PHYs (like marvell10g) will decide the host interface
> > mode by the media-side speed. So, the rswitch driver needs to
> > initialize one of the Ethernet SERDES (r8a779f0-eth-serdes) ports
> > after linked the Ethernet PHY up. The r8a779f0-eth-serdes driver has
> > .init() for initializing all ports and .power_on() for initializing
> > each port. So, add phy_power_{on,off} calling for it.
>=20
> So how does this work?

This hardware has MDIO interfaces, and the MDIO can communicate the Etherne=
t
PHY without the Ethernet SERDES initialization. And, the Ethernet PHY can b=
e
initialized, and media-side of the PHY works. So, this works.

> 88x3310 can change it's MAC facing interface according to the speed
> negotiated on the media side, or it can use rate adaption mode, but
> if it's not a MACSEC device, the MAC must pace its transmission
> rate to that of the media side link.

My platform has 88x2110 so that it's not a MACSEC device.

> The former requires one to reconfigure the interface mode in
> mac_config(), which I don't see happening in this patch set.

You're correct. This patch set doesn't have such reconfiguration
because this driver doesn't support such a feature (for now).

However, this driver has configured the interface mode when
driver is probing.

> The latter requires some kind of configuration in mac_link_up()
> which I also don't see happening in this patch set.

You're correct. This patch set doesn't have such configuration
in mac_link_up() because this hardware cannot change speed at
runtime (for now).

However, this driver has configured the speed when driver is
probing.

> So, I doubt this works properly.
>=20
> Also, I can't see any sign of any working DT configuration for this
> switch to even be able to review a use case - all there is in net-next
> is the basic description of the rswitch in a .dtsi and no users. It
> may be helpful if there was some visibility of its use, and why
> phylink is being used in this driver - because right now with phylink's
> MAC methods stubbed out in the way they are, and even after this patch
> set, I see little point to this driver using phylink.

In the latest net-next, r8a779f0-spider.dts is a user.

In r8a779f0-spider-ether.dtsi:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/ar=
ch/arm64/boot/dts/renesas/r8a779f0-spider-ethernet.dtsi#n41

In r8a779f0-spider.dts:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/ar=
ch/arm64/boot/dts/renesas/r8a779f0-spider.dts#n10

> Moreover, looking at the binding document, you don't even support SFPs
> or fixed link, which are really the two reasons to use phylink over
> phylib.

You're correct. This hardware doesn't support SFPs or fixed link.

I sent a patch at the first, I had used phylib and had added a new function
for setting the phy_dev->host_interfaces [1]. And then, Marek suggested
that I should use phylink instead of phylib. That's why this driver
is using phylink even if this doesn't support SFPs and fixed link.

[1]
https://lore.kernel.org/netdev/20221019124100.41c9bbaf@dellmb/

> Also, phylink only really makes sense if the methods in its _ops
> structures actually do something useful, because without that there
> can be no dynamic configuration of the system to suit what is
> connected.

I think so. This rswitch doesn't need dynamic configuration,
but Marvell 88x2110 on my platform needs dynamic configuration.
That's why this driver uses phylink.

Best regards,
Yoshihiro Shimoda

