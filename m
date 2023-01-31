Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA931682377
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 05:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjAaEnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 23:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjAaEmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 23:42:54 -0500
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2121.outbound.protection.outlook.com [40.107.117.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2642193E1;
        Mon, 30 Jan 2023 20:42:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lj8dudrUKAr/kwlYR51mULWoDH9p7tnzeC2S9NJ6o9WvkTJSkdRIUpnSngzoIpV4MtpKhRgE/cGJ05s+8mqOSXPIzQrnOIFun2ufrU7R6+J/NOCJCB6pNPWJvfb+LM8uebKjRVZ7IufR178pc5Bx+GmhnHqGXG1AbcnnbXPcVE3ipiyQTFJHgpR9SoIRKZ/n26gCbS6d9/uRkIqhCAb3mSqaSoeWfICZYQ7/sdYOG41qvcgYmj/a8zCAKEnM330nj+2SI8LEUnc1AYHVlgAUeTvpGDO8hwnl2QJB1V185tgDomMpyAptFOjgP24HVNucoT6rA21xKocQExIrMziz3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2za+eNBzhxUndtAVA0orYtDpvDoo5utSZXgpdNwFbgY=;
 b=lbFJA9lnrqZSyPyH937oCC+pBcm2nZMpnaczdceQRj1VRNgVj0tNfz1nxAwllcBp2aWHp+Pm3L12iTIlTYSOk0LgNymehivZxT0+DPb5B2IpA92odLmn2Un+hw6bYygKnrG2ym5Qg3DjtxGbJpywaG5JG5sgVGvNoiGcNXvgD2eafmH7GmB+J0vUz/NMcKtSSr04ejLrGOJZ4zpZCgR/s27NFy+jfWokIsRHnHRQRrjZellT1R2BmoqsN1dKCk5jrP2WVQdWP551mijK79hPI8tODjGI3Vc6FerdYAMHqpqkjf2peyrSRmTPLN3CT/BXFRsxljyS+Fo47zlSqdgJdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2za+eNBzhxUndtAVA0orYtDpvDoo5utSZXgpdNwFbgY=;
 b=m1lx4wgTlhnoQVTBr1kAYBk/fx3XmGhSjgWxlOtPvuZ1rU8XZDAYL8LnG1IMUeoAgm7tlQZNbl9nLBqmttN2oiqmE71Qg0nw8qzhYHCzzr+tAVlqfrwF7/7/Lp4QXoMDXkKQG2QttAoo2vM/IZMmoxHZI0xJuJ4WhsjMhEgSfNM=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS7PR01MB11681.jpnprd01.prod.outlook.com
 (2603:1096:604:249::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 04:42:01 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18%9]) with mapi id 15.20.6043.036; Tue, 31 Jan 2023
 04:42:01 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
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
Thread-Index: AQHZMltXgpqNi25oAEyoDsoqfmCDMa6yYD0AgAPiknCAAKGUgIAA4I7Q
Date:   Tue, 31 Jan 2023 04:42:00 +0000
Message-ID: <TYBPR01MB534169490DBB1A53CCCD743FD8D09@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230127142621.1761278-1-yoshihiro.shimoda.uh@renesas.com>
 <20230127142621.1761278-5-yoshihiro.shimoda.uh@renesas.com>
 <Y9PrDPPbtIClVtB4@shell.armlinux.org.uk>
 <TYBPR01MB534129FDE16A6DB654486671D8D39@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <Y9e05RJWrzFO7z4T@shell.armlinux.org.uk>
In-Reply-To: <Y9e05RJWrzFO7z4T@shell.armlinux.org.uk>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS7PR01MB11681:EE_
x-ms-office365-filtering-correlation-id: f76dcbf7-17db-4d3f-6049-08db03457e68
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /XwVEncAfI87dsBg9tBM6UEYNkAccIrftxdgpErK+DpOGX9WEwOuXS+4ZaRzguen2ge7dnNkgFLbHv4TNPi+xJPhxsSWYzkXcWODW5NvH3+MHf4/QyIXKa5Z1F7enOgF7rgLDNTHAtTrCpbD/+0+eFl1B4yGJSaxiHENlW5KbvX125qnwSIb4+9aXobd6cXc9em7iwJG1d8GH8iUsbf7wnbzr6lO4qSwrg3RyljucVyjtK2G6OeQ9WycVnkjdLTAjg0pfiNiL7qWGpunuTtbHpoI3dTCaGwoB3i9n6GxKHrqklPMnd76lsER8I3MSrct5Tfq7KPGNwKDQC+VBfim6kZOL1pqo27QlCHtT3JkwULwGytbbdTSMr3DjU0R8YineOjcfe17MH25p2JKALDYuEnktw6pg6vV91VTXBeQP8wGPZRyzebibP3AHcnSD8FDWJIuOumHmg+cgMy5wYVR0PGmlZue4kS1xg7JKcLJXf6lyudW0A78ByIHwoJFqk695NHrz5ebGER9h5qeLeCqs/LYFPIYYGmkcAqeipfRuWVLX5lVsSBxuHNvfoPgZggcVOU9b7Y9IA2H18sTVZYmp2YWIK4Vq+p2LYwKH2sbuUyqJ7WnbkX3033dCfNPlcbnze0t8f+/8rph72n7kqWJCzVWjq4wqf11WvumrOL2M/Qp+wJt1HULBGHEVaCZg5AKxOuppZYLn80/7npynT8zYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(396003)(346002)(366004)(451199018)(4326008)(41300700001)(66446008)(66946007)(76116006)(66556008)(64756008)(66476007)(8676002)(6916009)(186003)(8936002)(52536014)(316002)(2906002)(5660300002)(54906003)(478600001)(7696005)(71200400001)(9686003)(6506007)(7416002)(122000001)(33656002)(55016003)(38100700002)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?RQhmYV9rABQYy8dQlc2gpOubM/OEuzslSdTBs+BYMzQwveZ3JkeJCNT17U?=
 =?iso-8859-1?Q?A8/TqEUpLgxgYtPhHVygVs7U9dlzyj1jabH9VfHdDjJ+J2qhAy4bgdjWbG?=
 =?iso-8859-1?Q?iO80h9qTITeGuXB/S5/Q88buqk2qghE1Tq71g0ddeHehpRReglW8qUOaoy?=
 =?iso-8859-1?Q?Tn+k928r1hjOqOacLq6qgitnAHSbCYqARkfCzNk6h7yd0A4RBZoXN7Lx+y?=
 =?iso-8859-1?Q?/0PVWSpsXWq2Ze+J8xAIaU6jfVMpicfgVwN4sja9yeVIgf6HN5DG5+APTr?=
 =?iso-8859-1?Q?/3ZSvggm9mQ089F7jE9+O5Maak4bKezJzL6ez8XXGgC3DPLgdpZcAhqDEU?=
 =?iso-8859-1?Q?QRLP+trxB4a8Dq38EHbx9/dxB9Rby6vlJPBFLqZebL8PN0vdpGXIb7sIPS?=
 =?iso-8859-1?Q?6JQlEO9nXGYi2GzwCWqsoPc0Xiujk0boNo3RkyEe7ceFEAy0IMmrtC6DST?=
 =?iso-8859-1?Q?T7jWRIfPu67kwOixOMnnKZ3itcBISJG4Rf47rs4hZFuKQ8hgatuG4uXAH4?=
 =?iso-8859-1?Q?QLtCjNw9JTPCsc1oDF3ex19LyP9hps5rlPOAkTCSaQ4wGW0YbtH5w3FLCV?=
 =?iso-8859-1?Q?PDzqWXEPai5MtdWUv6fFHu3PbRQ2qWUZd1q19vHLMZpn29dXBPaZiwoq0H?=
 =?iso-8859-1?Q?XqMQ2qApvXdOtwSQffIEDyikyVXoPNmC8O6Gnxmwj5jqg/BMpFEt6rRsmm?=
 =?iso-8859-1?Q?9M1ifkoh2N1VMjkwsrDVN2a1o9GvqYE2FOK2ZcYaBl2c/EpqpjEsaz/4Zt?=
 =?iso-8859-1?Q?cSVxrTAII71WYf4zF6tlp1vr8kZag/YNXlEc3SgQQLdVOgXy/s0JXM+b+w?=
 =?iso-8859-1?Q?6B1w6vxobgSYv33uwQIda3of/PnhXzymbYin8bnm8uytLxYub+hUiv5RMP?=
 =?iso-8859-1?Q?1+HEPwvj9hG7MFBCsBF+B0TeC3bd2yTcbRcdKve5Ak7YX3mXyR8xeBh07h?=
 =?iso-8859-1?Q?q7pzDnfcBPpl1ZPrbm1liGatEf0Ep3FJ5uCGH3kdbEvyCtgCPS6WnB5hRJ?=
 =?iso-8859-1?Q?sHaAuYBBBFosGmyfUErLsLVNgnx8VHSWg9EFvzqiRoP41Y+8hG9/vUmez6?=
 =?iso-8859-1?Q?jOVXNukqxdOQ9XXWiyQ/RdY4/Mm6+Y2ZZEjAui2WD4SaecVYSufBunGiEr?=
 =?iso-8859-1?Q?gb2G82Yk/j9q0aXLIqUL3JENiD8Ow8Aopo3XmQMYrHI5Wrrqw+rpPZNuHt?=
 =?iso-8859-1?Q?TMiSNBml939/1k9ny6DVpJioz+o+WM05niMXn3r8cPrrn62I6jHQjixJrl?=
 =?iso-8859-1?Q?i/NdmcDkxknU4KHNXjlBEVnhCPvBy77kUiSjSisMMlNvzI68qmbYqXhPhK?=
 =?iso-8859-1?Q?gqd8mMukVT7YvIOArMM9cvf9AGlQ4p/3jot7d14ju58noSN/obBCQZtvtC?=
 =?iso-8859-1?Q?MX+q5YFXdI+8CdHsY51AF/Z1W7QWRFaWtHpn74OWTuxc8+SsBI3Lp4hN4+?=
 =?iso-8859-1?Q?NZm3GR64Jdjn+FIv6+ndpe9P4k7RTyRVaJARBPCVvAHce9KU38RwR2PeqS?=
 =?iso-8859-1?Q?6HJ/FVlPoTOpeFotSiA6TwfjFKucvH1Gpql3KmHKFlLk6FaHSMFkeLbfBe?=
 =?iso-8859-1?Q?/WtTkXjLVXMPwTmp4Wgh0mt5Rw5808i1ctHCXW64UWUZmGaj+PHa5pAE1H?=
 =?iso-8859-1?Q?U01ws/4GvgAUTf08Kt1fEAjI+popg3StPPwxPlELU1qgry+V2cLpeCM31O?=
 =?iso-8859-1?Q?3k/3DKJrTiLnOPQ57oE7bhELRa7aSywr/5GENsY6fo7JW8BT9IHJN06Jy1?=
 =?iso-8859-1?Q?XJiw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f76dcbf7-17db-4d3f-6049-08db03457e68
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 04:42:01.0828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zG6p7oM8G6SvYdojFN1rAy4YxIvZhLLWrykve0RVpzxbriveNzy2yBB8kJ2IK97GlEEQJ1kV5iHs64PTjAC3lhO4aQEzWgrvLb3psm4GeKoKCmpkGpHvjgOUiHLkvEDU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS7PR01MB11681
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

> From: Russell King, Sent: Monday, January 30, 2023 9:16 PM
>=20
> On Mon, Jan 30, 2023 at 05:52:15AM +0000, Yoshihiro Shimoda wrote:
> > Hi Russell,
> >
> > > From: Russell King, Sent: Saturday, January 28, 2023 12:18 AM
> > >
> > > On Fri, Jan 27, 2023 at 11:26:21PM +0900, Yoshihiro Shimoda wrote:
> > > > Some Ethernet PHYs (like marvell10g) will decide the host interface
> > > > mode by the media-side speed. So, the rswitch driver needs to
> > > > initialize one of the Ethernet SERDES (r8a779f0-eth-serdes) ports
> > > > after linked the Ethernet PHY up. The r8a779f0-eth-serdes driver ha=
s
> > > > .init() for initializing all ports and .power_on() for initializing
> > > > each port. So, add phy_power_{on,off} calling for it.
> > >
> > > So how does this work?
> >
> > This hardware has MDIO interfaces, and the MDIO can communicate the Eth=
ernet
> > PHY without the Ethernet SERDES initialization. And, the Ethernet PHY c=
an be
> > initialized, and media-side of the PHY works. So, this works.
>=20
> Ethernet PHYs can generally be communicated with irrespective of the
> serdes state, so that isn't the concern.
>=20
> What I'm trying to grasp is your decision making behind putting the
> serdes phy power control in the link_up/link_down functions, when
> doing so is fundamentally problematical if in-band mode is ever
> supported - and in-band mode has to be supported for things like
> fibre connections to work.

I understood it.

> > > 88x3310 can change it's MAC facing interface according to the speed
> > > negotiated on the media side, or it can use rate adaption mode, but
> > > if it's not a MACSEC device, the MAC must pace its transmission
> > > rate to that of the media side link.
> >
> > My platform has 88x2110 so that it's not a MACSEC device.
>=20
> ... which supports USXGMII, 10GBaseR, 5GBaseR, 2500BaseX and SGMII,
> possibly with rate adaption, and if it's not a MACSEC device, that
> rate adaption will likely require the MAC side to pace its
> transmission to the media speed.

I understood it.

> > > The former requires one to reconfigure the interface mode in
> > > mac_config(), which I don't see happening in this patch set.
> >
> > You're correct. This patch set doesn't have such reconfiguration
> > because this driver doesn't support such a feature (for now).
>=20
> Is this planned? When are we likely to see this code?

I'm afraid, but this is not planned.

> > > The latter requires some kind of configuration in mac_link_up()
> > > which I also don't see happening in this patch set.
> >
> > You're correct. This patch set doesn't have such configuration
> > in mac_link_up() because this hardware cannot change speed at
> > runtime (for now).
>=20
> the hardware can't even change between the various SGMII speeds?

Unfortunately, it's true. But, I'm sorry for my unclear explanation.
This is related to a hardware restriction which cannot changed
an internal mode if it enters "operation" mode once...
But, I heard that this restriction will be fixed on a new SoC revision.

> What
> kind of utterly crippled hardware implementation is this? You make it
> sound like the hardware designers don't have a clue what they're doing.
>=20
> > > So, I doubt this works properly.
> > >
> > > Also, I can't see any sign of any working DT configuration for this
> > > switch to even be able to review a use case - all there is in net-nex=
t
> > > is the basic description of the rswitch in a .dtsi and no users. It
> > > may be helpful if there was some visibility of its use, and why
> > > phylink is being used in this driver - because right now with phylink=
's
> > > MAC methods stubbed out in the way they are, and even after this patc=
h
> > > set, I see little point to this driver using phylink.
> >
> > In the latest net-next, r8a779f0-spider.dts is a user.
> >
> > In r8a779f0-spider-ether.dtsi:
> >
> <snip the URL>
> >
> > In r8a779f0-spider.dts:
> >
<snip the URL>
>=20
> So these configure the ports with PHYs on to use SGMII mode. No mention
> of any speed, yet you say that's configured at probe time? Do you just
> set them to 1G, and hope that the media side link negotiates to 1G
> speeds?

You're correct.

> That doesn't sound like a good idea to me.

I agreed. So, I will fix it somehow...

> > > Moreover, looking at the binding document, you don't even support SFP=
s
> > > or fixed link, which are really the two reasons to use phylink over
> > > phylib.
> >
> > You're correct. This hardware doesn't support SFPs or fixed link.
> >
> > I sent a patch at the first, I had used phylib and had added a new func=
tion
> > for setting the phy_dev->host_interfaces [1]. And then, Marek suggested
> > that I should use phylink instead of phylib. That's why this driver
> > is using phylink even if this doesn't support SFPs and fixed link.
> >
> `> [1]
> >
<snip the URL>
>=20
> [Adding Marek to the Cc]
>=20
> I'm afraid I don't agree with Marek given the state of this driver.
> His assertion is "there's an API for doing this" which is demonstrably
> false. If his assertion were true, then you wouldn't need to add the
> code to phylink to set phydev->host_interfaces for on-board PHYs.
>=20
> I'm not particularly happy about adding that to phylink, and now that
> I read your current rather poor implementation of phylink, I'm even
> less happy about it.

I understood it.

> > > Also, phylink only really makes sense if the methods in its _ops
> > > structures actually do something useful, because without that there
> > > can be no dynamic configuration of the system to suit what is
> > > connected.
> >
> > I think so. This rswitch doesn't need dynamic configuration,
> > but Marvell 88x2110 on my platform needs dynamic configuration.
> > That's why this driver uses phylink.
>=20
> Given that you use the 88x2110, and you've set the phy-mode to
> SGMII, it should support 10M, 100M and 1G speeds on the media
> side. Please test - and if not, I think the code which supports
> that should at the very least be part of this patch set - so we
> begin to see a proper implementation in the mac_* ops.

I got it.

> The reason for this is I utterly detest shoddy users of phylink, and
> I will ask people not to use phylink if they aren't prepared to
> implement it properly - because shoddy phylink users add greatly to
> my maintenance workload.

I understood it. I don't want to add your maintenance workload by my patch.

Best regards,
Yoshihiro Shimoda

