Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204AC65E656
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 09:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjAEIAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 03:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjAEIAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 03:00:38 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2109.outbound.protection.outlook.com [40.107.113.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8691EC43;
        Thu,  5 Jan 2023 00:00:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gveyth9IiDhHOKWqkoeJKfj3K8tATO3EYPB78X8bHFc7xXQIMAcDFqoRaVxDhg2jm7MqYJESfUPI1432ktYFsJ2JJzcG542/8TiZ9P5w9LujAKXkg4rekmiERBHf9HRjWn441yYWkBWEs8+iNU9G46nMLWqqCvwgfFFTH0yqtPfxBJKstvR6/nfoKWw2XZFxm9p3Gj2BMqLBWveTzn2lP8NmtXcOZbzt+MCm+xPCoJeNVYxhtqXxr3XyzodC8XzAK9+QjPmjhIC2mAAoNVWaVb+nesJVGcJ03v8c4lUgMw31jGe/urYlKnKDxjH+oTP2uVPcGD6tm3z7hn+dvk5kfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sWEdIXYkNO+w4gaAx58qROLioC2ejVjNJ44WRGGG+9o=;
 b=Efwz/E5FZQFrMSi6mVRavP/TwPSgcFWE5rNFV/nZNZkkENSSEjqkQing9uSkvOCk0rhTnK+OqDJKXr+x+zdv7VcvvK1Mofqwvyvmu6QCmAx/siQE1/PYxsyHVHwvn+077E1csiCK38n/W5uSgvo+ohzmVf+LW9YhAXFL6vgJLyx3QphD2yg1UiIsQrsgIaLxJq21z6KH6joDjx4kidquPwf76msGHHTdGSZrP6/2r26X0nrkz0zgOANt2fitE8g2wMuIMxwORuJ0+zmHEkXRvqPnaB+ze34slQ2gNawRUIwugPpPtKTVmjVVZvKSTL/4nCRZQqUi8/Ve9ljzeJvCgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWEdIXYkNO+w4gaAx58qROLioC2ejVjNJ44WRGGG+9o=;
 b=MIO57STJzQyPxsQ6rRCPIEjgaJJ0dj40vV6M1j/RyliK9xZEG0+o2fFzgdPsiEZORPYWyIO/kgweU+Sy0jjavz/G2nqvv/4UM46AqzCfTL8L1sEeIOp8nhPYijmFKfFTXyk/vEAFffosaWPX5lmHeCDel1tQJiJSfoFm9sfUZ2U=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYVPR01MB10668.jpnprd01.prod.outlook.com
 (2603:1096:400:29a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 08:00:34 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::3e61:3792:227e:5f18%9]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 08:00:34 +0000
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
Subject: RE: [PATCH net-next 1/3] net: phylink: Set host_interfaces for a
 non-sfp PHY
Thread-Topic: [PATCH net-next 1/3] net: phylink: Set host_interfaces for a
 non-sfp PHY
Thread-Index: AQHZGPm0v6d9IIa27kiLOOioWSRnVq6MgL0AgAMCGYA=
Date:   Thu, 5 Jan 2023 08:00:34 +0000
Message-ID: <TYBPR01MB5341DA774FC074368AE448B4D8FA9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20221226071425.3895915-1-yoshihiro.shimoda.uh@renesas.com>
 <20221226071425.3895915-2-yoshihiro.shimoda.uh@renesas.com>
 <Y7P7Sj/ZJ8V/9Pkq@shell.armlinux.org.uk>
In-Reply-To: <Y7P7Sj/ZJ8V/9Pkq@shell.armlinux.org.uk>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYVPR01MB10668:EE_
x-ms-office365-filtering-correlation-id: 2b6d539a-5bae-4c86-b6bf-08daeef2ec9c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SCwCE0KFnMhbr+BGhBFirJ6fPQ68Jo/GJwIM4MI4U/jwSzeB6mLmhufFuiVhM7MNOu5ZHqRMBjDyp30dG9tZjMpVdQ79yRGqPA6n0TbP9cGeaZbbke6ULYvYm9qn67vrH6HtsYXXPq/dGee/jAmWj06+4tFBUYJaQV7FsD9MeIRVAqlIrDfPlLvI3dss4mp+s0rfjkTeAViCxvR/lCjITdi52yP8JRnaeAHHjQ2OvaAghxALeHuP9wp3Clfh4OcnlDIy3qwoXoq2rKS+ssZIWkRRN9jqV1bSLPz4yBkwCio6E29McWO8r1ZaNijQfryXAxY28Fs5Tlx3z7x5FdgFRZSMxBQ/sI6cUH796+F82/otihk3BgPyHnpJzEBC23iQ6mmz7WOuEI/tbyPR9+SM6CpVNevRVkb68Eyj+gsiVadjCXepJjKwVaCNvDqqz4Dgi0Eokl1lJDoAWJLOsai8hofji/VZSpsqXPSTepDRZT2m6tINE3Ylz49FyjpTz7rGWy9VAJiNPDNWbHJDaJJ+GJ1WPlNRZrCUjGbQvoiPLaxAPoHAS12INDIg93kGOS8DBun64gnQkTZonrKsSZMitGfFQCJSX4Xq91K/KacMp1ppTcqkjOGwJzwuKCVsrEDy3uGDBSiVDjlA6CEYLr+gVmx0kN1mroZgJViUMOIdQacI3cw0rlXWoorXqYOGWYYBGfDy/OTq0AkLw5glWeDgmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(451199015)(478600001)(33656002)(5660300002)(38070700005)(86362001)(8676002)(2906002)(64756008)(76116006)(66446008)(66476007)(66946007)(52536014)(4326008)(122000001)(38100700002)(66556008)(6916009)(71200400001)(316002)(54906003)(186003)(41300700001)(55016003)(7696005)(8936002)(6506007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?t78F6256X1E1J+kgP8H4w7XuV1q+AgQW1FlU5h9ioFWgbLUHjPzyNqrefA7r?=
 =?us-ascii?Q?NoFcV/uJ4xbrn1J4UPIcXh6k8+EX7QC3B2q4zNWBFZEVixSXIeaMAuvIt94F?=
 =?us-ascii?Q?sY33SJ2EGZbhoAxy91R71ghTZdSPClBNvlCraWku1Drfg1kMi+7L/bkpjqWV?=
 =?us-ascii?Q?rpjSvzCLJTJ8wfAbadCigfulAQ4nhvQ/C2JzpwRqQv6kspMwnp8py46r0CPp?=
 =?us-ascii?Q?82aSrFanFCEZ6fggAEbeUIyV+vQCLgxTUuo1QxtdEbxdhKQlNART2b8wAZAa?=
 =?us-ascii?Q?gwqfxSjap9jzTgm5c15rA0T17gglbQxEAOlduyVNawCy6PmmtY6MuGdrLSNm?=
 =?us-ascii?Q?9xTddz3w6ZIuQurEmmToqdtQERX1XTliMZTDlASE72UDksk+ywvstQCTxEPa?=
 =?us-ascii?Q?dEc5DvNxi6h8ght7rE8EzXcHoPOvdr8xonF8l5QQo8E06JOfPHg/P2XwnXMb?=
 =?us-ascii?Q?8XcvxhJrFaMrF22JAUsfUQATOXQlUEBj+pwC7o/aSqmnYB73zekWmepFacPX?=
 =?us-ascii?Q?3iKMry4wKJ8XdRtMCZV53PyS8bB1yCs64YJ0NCNvyDjosglKLtczCtDNmOg6?=
 =?us-ascii?Q?Gppdo036wJTZwb+kl8v3vpgZIVKpFoia2ifMh5Lex9TFKPaYUB+xVikXvqOs?=
 =?us-ascii?Q?ZVQCCQdKYjIXWpDaSe+WVLqX4185j0CvlCZ0zb4RFTPUrbEOmmwMQk7rS4XY?=
 =?us-ascii?Q?VO4uhZMHLgpWvo2ylfYJy3XG91ysSpALFox1+RZNlWoC00kZ65kFCeKTRjet?=
 =?us-ascii?Q?grz8prkiP82GAlAAVZTyOMyJDJOZqw4B0W3lMuG3Z2BiAoXz6MUV0aFw7GEg?=
 =?us-ascii?Q?ZZ5Tm+ySAvlBGOXihMdkNjVgK4M7BJHuxg9KhvhMeZJWvqvLQ5srXBfIC7kY?=
 =?us-ascii?Q?HvJztRYBkNldo2BYkQKq8lN06YUDQFwSzYUbLtWl7LQtJ5pK9YZNkRBZK5WC?=
 =?us-ascii?Q?kgWcbpkTP4BnQdqcNYHTRdou2JOfX7ZkngAgrlAxREOaQnLJ6a70//daxJ2x?=
 =?us-ascii?Q?AoyOXrZkqvVUlOHgbDXhEUaJ5f9v0VrHXsBVs7BAvR6Zibow+DCbFPLhYjhh?=
 =?us-ascii?Q?Sf7Fxq2N77ri57oB4tu97Dn/raHwugjOuqEvF2wdA3URQHuqyDEAfKbOAnB8?=
 =?us-ascii?Q?iYuVttjjB1rww+qO3BfcxrRas4U1xC2OFN7MYPPzUBeG35Br1mu7/w5AX3Vc?=
 =?us-ascii?Q?HHYKqM15KT2N8r/MEx/hNVYrzQJuXUYMJMHNNnhZC1stlftPRss9E7z9qEmt?=
 =?us-ascii?Q?zg/w8m/tkSXjt41PJPYyYrafz+ed581fDdIJNPyUWbPTVldV0W2E6TTrvxnk?=
 =?us-ascii?Q?r8uj4KJBTVdcmwD8zQm8A983T3olIAfsYrClmC+be4egCJWogD3vtYECr8ea?=
 =?us-ascii?Q?Y875bcFxwNRiLQmzxDRcMqwXecJufvhku9BHaCFdVYz2uZw4K/ijK0vFBZdc?=
 =?us-ascii?Q?PIlv55oSKZ+1dvlocRuNpn0jDTx5mLovl+UWjJcqxZtYqSiRZRPpgv25mNge?=
 =?us-ascii?Q?1lGuM6iFq9ZRl3Clh+0t3LbMTGvVSVnNdjT3yYXCHPSORGCVtCZecOwBM8E+?=
 =?us-ascii?Q?e4289BiTaRXQ04Fo+Xt0fRUEQ6X82QUG7Hr4bBWHLP71Nh0fGTGr1Aw5xvY1?=
 =?us-ascii?Q?DSRp9cWYhUKSbK40EFuo+bUxCDEXRBaTvzsqmjpCsa+EqOq0bV6l5F/K6SuE?=
 =?us-ascii?Q?kW5E4Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b6d539a-5bae-4c86-b6bf-08daeef2ec9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2023 08:00:34.5067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uMJs+1wj37Ww5fLeMc369jdHifVBI8R6BwpD/JPtT0UCW+T5zQ5ecvLcAfkFXVt9948pOGmN611azHg0yviDdl6UzuACtF39oAq05IJmy9ktdnyN9Dw6GRzfwPk0pNPX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVPR01MB10668
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

> From: Russell King, Sent: Tuesday, January 3, 2023 6:54 PM
>=20
> On Mon, Dec 26, 2022 at 04:14:23PM +0900, Yoshihiro Shimoda wrote:
> > Set phy_dev->host_interfaces by pl->link_interface in
> > phylink_fwnode_phy_connect() for a non-sfp PHY.
> >
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > ---
> >  drivers/net/phy/phylink.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index 09cc65c0da93..1958d6cc9ef9 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -1809,6 +1809,7 @@ int phylink_fwnode_phy_connect(struct phylink *pl=
,
> >  		pl->link_interface =3D phy_dev->interface;
> >  		pl->link_config.interface =3D pl->link_interface;
> >  	}
> > +	__set_bit(pl->link_interface, phy_dev->host_interfaces);
>=20
> This is probably going to break Macchiatobin platforms, since we
> declare that the link mode there is 10GBASE-R, we'll end up with
> host_interfaces containing just this mode. This will cause the
> 88x3310 driver to select a rate matching interface mode, which the
> mvpp2 MAC can't support.
>=20
> If we want to fill host_interfaces in, then it needs to be filled in
> properly - and by that I mean with all the host interface modes that
> can be electrically supported - otherwise platforms will break.
>=20
> So, sorry, but NAK on this change.

Thank you for your review! I understood why NAK on this change:
---
static int mv3310_select_mactype(unsigned long *interfaces)
{
...
        else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
                 test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
                return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
...
        else if (test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
                return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH;
...
---
- On this change, since the interfaces is set to PHY_INTERFACE_MODE_10GBASE=
R only,
  this function will return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATC=
H.
- Without this change, since the host_interfaces value is zero, the mv3310_=
select_mactype()
  will not called.

I'll investigate phylink and marvell10 codes again.

Best regards,
Yoshihiro Shimoda

