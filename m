Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4716054FD
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 03:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiJTB37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 21:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiJTB35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 21:29:57 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2130.outbound.protection.outlook.com [40.107.113.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE5A19422D;
        Wed, 19 Oct 2022 18:29:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UsJPa1guwzXLg1JexLSM0f/4yHBvVc6F65NnkKElADycgr0TgBqIFZcPdfLWhFCLCo5KRM1Bokkho8Bx0EHCxkc0RYdpIzAuxpgEAcZPcB4+2RpShM8R+HOtFyyWTnpZlvaw2O27ZzcXRVIkAoJ5ZMAOCMaWQbDYdmkwoxhgEC5RB09Jk0kbxfLfQM7OARv8XHFlZaP4CBQabXzLqMywFOPEDJCJfs+ACrvICx6nWbeqBNnl36x3nOAKUn/3s0pJuEBBQH0X5+QnXef89XZFdjBnkX+nAZBYKdR3PMNWH+69SLt8wWCZ3/Wcjde+3TABP69Ge+eVzGZJFj6xIerqog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FvfxmbjDIK2xVi+FP7z6N/JvhT/y4w2wmBq6i7CxUK0=;
 b=RiMHM/0aS6i8vso1pICZqRVZicU0eNXWXJvBlpepB02gcs4NBjTV1ZTMPPnf7Auu9oxKXzwIRbWxJjp4x6uMucNSxpcUA7PlOKXKrArJ9vsFDE4RCIH4bPDF6m0tXg8KKW5vrUUKTw15OdkTh17bGJZnULOjZFR/N7/0WeXeFiZ0tYVpdJE8SdaNiR++hp8g6LNk0r5FuU5OEIzHOmQKlF28zxOfRQDp9ZE/HQlISp0qo7gdj1SuJunNxMTi2dR99fhnh87YfeBFHeW9lYsdk0TEJF7p13/22m/oe0//9qo8/5150H/UMsJQNR4cjRPrLoaMw9q6qUAJ0WV1zETWnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FvfxmbjDIK2xVi+FP7z6N/JvhT/y4w2wmBq6i7CxUK0=;
 b=oXKjnyBAAFNfr8mS5pLUMcixI9Bqk0VayQKe5x44LDIoamtnheonFIct+923RA3YNlsEWS8ETZB0D/VmWPWnTqcpfRHxBiaaFIeu2JK1MZejofNK2ykiHcmxNKU4RL/cm0tMibKDlyy+LDhgBCa022TGj1E59bQOiLXSi6Anb7I=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TY3PR01MB9665.jpnprd01.prod.outlook.com
 (2603:1096:400:22d::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Thu, 20 Oct
 2022 01:26:28 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::51b0:c391:5c63:4af4]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::51b0:c391:5c63:4af4%3]) with mapi id 15.20.5723.034; Thu, 20 Oct 2022
 01:26:28 +0000
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
Subject: RE: [PATCH RFC 2/3] net: phy: marvell10g: Add host interface speed
 configuration
Thread-Topic: [PATCH RFC 2/3] net: phy: marvell10g: Add host interface speed
 configuration
Thread-Index: AQHY45fw9fp0Ss0XrE+szQ/ICWWuea4ViYGAgAATj4CAAOAH0A==
Date:   Thu, 20 Oct 2022 01:26:28 +0000
Message-ID: <TYBPR01MB53417818D601C95009FA8B56D82A9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20221019085052.933385-1-yoshihiro.shimoda.uh@renesas.com>
 <20221019085052.933385-3-yoshihiro.shimoda.uh@renesas.com>
 <20221019124839.33ad3458@dellmb> <Y0/mbzaUItB1BOzg@shell.armlinux.org.uk>
In-Reply-To: <Y0/mbzaUItB1BOzg@shell.armlinux.org.uk>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TY3PR01MB9665:EE_
x-ms-office365-filtering-correlation-id: 990bea61-b96a-42a3-e092-08dab23a1cd6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iybxpxsbE5A6XHDl7bJqhIB8dBd6yMy9gtc9s2BRffuFv/m8E+ocM7QLcDNc/2Vru9SM9dryRyVaSEX47dowr8bM98mF8zolTDqNk/t0Jn0tbaS1fzstTgTWeKE1OgpWuGp2lfq+x9FgtPp0pcYoUnZ4gKLNWjOa/QBdT5FfzpfCmYbZn/zNCI7hUxOmaKa/6h/v3Kc0sD19uwMSoB/mzY7hiPYiQ3D0ZUY8/sz7AAH6HXETUEGQPyhI+HEyDy70m49lcJzwWvxO+hNl/l7GBGIS62uuyCYneYGQdz+Gu0gsRXZFdMoxVqfrUXjun+uwVr959BB02+MsoIQNpeiuPc9PKprN7vdfHHOHtmvAxGdhfrqpFQ9qHIm/Dj2SB4iu/Kk6K8nPlAM+P06tTHt5J/oLjKDe32m6BgMmX+yeqgWpL6qinX0Us0s+kidztvYj0yBFNHXw+sRqFmOY0lRSEkos+uJ6P6aIUNeCtyxVx4AAj6HCIIAbg2oNhRAoDwKqHYmL+kTgovKpFGfAGLFlZSTBqgdFrABlRORoHslwmYujdLyt1vKo99BprqJB2i4JSuFpQOypbBWHsdLIZ2adzdkkBrmVoSFZoV6sBFtJ5ERoRDYtvxj5kOpDhO+ysHclpuPmxeeGPHwTFY8OT8+fgAh6UE4SVp698kdlO0qmNIK9b1d26t3un1Ra8N+89Die0HSaVUrYm461zFyDeKq290iUgjU/MURyyVTTR0NVS/kPhprU5xtj6AXmYVFXatVPTrL3FAk9+boO0RvBIjQpyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(39860400002)(366004)(136003)(451199015)(66574015)(38070700005)(86362001)(55016003)(33656002)(83380400001)(66556008)(38100700002)(122000001)(66946007)(5660300002)(64756008)(76116006)(54906003)(316002)(186003)(8676002)(66476007)(7416002)(71200400001)(7696005)(4326008)(2906002)(8936002)(6506007)(9686003)(478600001)(6916009)(66446008)(52536014)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?gEthV68GbItIdsINpdHH+bgtVe2jdfNg6WnxDJyU52Snzl0PmLbe/SmBu5?=
 =?iso-8859-1?Q?ph33teXSjI6gEb8U/7btDzd3SkuNLGhgXr4bMkTwCBH2ciVhrD+w3btdZd?=
 =?iso-8859-1?Q?FZ815SLhlwmDsCpRS7S/V7ZOI6VTjbR2k+evfQCObD45NILmDNxKWmz25e?=
 =?iso-8859-1?Q?SLYIWx6WqtALTZaXFpBqzW/QMqos74DXHW32xNIy3JTkO/PofZ0d+Odh9y?=
 =?iso-8859-1?Q?SrUfcBBGrGzUDGBjHXnqKVntyPm4SclrxSwW8ycNM0b4hg7gOEeg+bGOt5?=
 =?iso-8859-1?Q?kEbZIo4cRuZCpYrq9WYTegBnyPefuQGVUjrGVx9iXlRXLdDT/cerQsDmuZ?=
 =?iso-8859-1?Q?UAdY2do9Flv0nhKIkVR0kq+f0Das0rqms+n+012Z0WyedEGDuBBbT7a6XY?=
 =?iso-8859-1?Q?g6PxSBnwOWSL9u08Y0JMhvAhnizlBEHZu8go0JuznGbX+aNTjqe3sGDEuN?=
 =?iso-8859-1?Q?0BHHI4S2Payr2MFhjhY3an9ST+I2jVim7y3Qye0tfGmzvhF9VMKGWvJ1P0?=
 =?iso-8859-1?Q?XnVSuiyw7AcSg3wca1BtL0q4vU7hN+Xrxyjy/iXAbLf86Q8+DBvbnNdjSK?=
 =?iso-8859-1?Q?iEZMFy6RGC9qGJlIUMaPwbEL7cJngiiDNkh3yx8qZfg/IK6xhFgU/QrHTE?=
 =?iso-8859-1?Q?nHucXDZQgPzV22J8fCfqsACDvixWtEgfhkdnz8MihhfzjJv938Sf9f/Nud?=
 =?iso-8859-1?Q?uuTGVcMMrDDBltOcgzDh9ArHg9pqXMmqPHuPPKRsYJCN47f2+nH0uRFcTe?=
 =?iso-8859-1?Q?YaXq8r9io/aLUG5KYbMNr0xglIDnz2tcVDdDB+SU3daR2zMej2EUivFvVc?=
 =?iso-8859-1?Q?aTvwKCJg0Cf0tGpfj9EJb0gFrEHXaFo7TbBGDxdVD9kQxrHNCSK2uPiOrO?=
 =?iso-8859-1?Q?bQ9gXgBkEg3ELTpH+lj9ajimfM+3baEUmGDa08yDTgOyzOoIvYdjJrLnFX?=
 =?iso-8859-1?Q?Jj6yXcYpwUnR5RhzS1/9qra9dQvgT3kYLeTn1F3CIpSdwRU/Eq7bokzWCl?=
 =?iso-8859-1?Q?cadLJ48cQBPrferyjXv1RDNqLDqSHREKPvO3qB4r2PKQ7T0QqG4h4kDC5h?=
 =?iso-8859-1?Q?B4UH6bUDJa+GBGFTTlefTIHYLS/3f5wCdK4gC9cjCwRDVEYBLFH/CsRd00?=
 =?iso-8859-1?Q?yOsiF4t+bxoYevkNuuzcd3FkIjXyLiXI/zDs29oYEmXfVtGrzN6wkAXTqu?=
 =?iso-8859-1?Q?DenLnghhUhvnH9PQ+DNbqryrvL4VKEkObFDJdq48GPKzbsa/SYAZNIM5lT?=
 =?iso-8859-1?Q?WUL1sa3AidViTj8ak5FZXl41Id1RZ16Egi3TFhOlAJ4Ae3JhygNPUiCUcg?=
 =?iso-8859-1?Q?JAhGrYzRq6OeiVg/pWyZyVPw1scLrjnyZUJtLOWbx3Aa1oQ0yMqnbJcXTB?=
 =?iso-8859-1?Q?7avxoxO06bklTLJ92aEfjtn6iBb3/zCruNy7iPMRFk43TiC0siSjFo5caP?=
 =?iso-8859-1?Q?Q7SFWdpHiaPurW7/A1yX/li3HaGragfefamOKUFM+mbz9VsvJO3YOqRnRm?=
 =?iso-8859-1?Q?vYAJ5gVnfoG1QvxglAB8QXs1nqhv73zgeEapjlZih1ZIv1zTwyyq+Vw7fd?=
 =?iso-8859-1?Q?UHqON0S54yYEJowJgAwUT/mlah4SYSeaznUXxxPdjrWWQYU/45Zw6Os12L?=
 =?iso-8859-1?Q?ZLDt+IE7hukgmtPw9V4mZV6brfeN9D21Enh4fGAlBzERxuYzTKVnEnkztk?=
 =?iso-8859-1?Q?zVO7SAiQSI2N4haAjJCUUjxgeqAfbNeHBeKhkpEWe0352wB+8zWn4Jr9uA?=
 =?iso-8859-1?Q?zESQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 990bea61-b96a-42a3-e092-08dab23a1cd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 01:26:28.7881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhTxA6xMPtvjwH6iuJLJhVWCAHjra5q5CTPmZwfTtupGzqDmXLSHVg4krnRv+fDmmXJ9rJ26TvFOuQfAPrppsz2Z0io/vItWBNKNS560YXe7fCBOEih5FWfF4Y43a5Hw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB9665
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

> From: Russell King, Sent: Wednesday, October 19, 2022 8:59 PM
>=20
> On Wed, Oct 19, 2022 at 12:48:39PM +0200, Marek Beh=FAn wrote:
> > On Wed, 19 Oct 2022 17:50:51 +0900
> > Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> wrote:
> >
> > > Add support for selecting host speed mode. For now, only support
> > > 1000M bps.
> > >
> > > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > > ---
> > >  drivers/net/phy/marvell10g.c | 23 +++++++++++++++++++++++
> > >  1 file changed, 23 insertions(+)
> > >
> > > diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10=
g.c
> > > index 383a9c9f36e5..daf3242c6078 100644
> > > --- a/drivers/net/phy/marvell10g.c
> > > +++ b/drivers/net/phy/marvell10g.c
> > > @@ -101,6 +101,10 @@ enum {
> > >  	MV_AN_21X0_SERDES_CTRL2_AUTO_INIT_DIS	=3D BIT(13),
> > >  	MV_AN_21X0_SERDES_CTRL2_RUN_INIT	=3D BIT(15),
> > >
> > > +	MV_MOD_CONF		=3D 0xf000,
> > > +	MV_MOD_CONF_SPEED_MASK	=3D 0x00c0,
> > > +	MV_MOD_CONF_SPEED_1000	=3D BIT(7),
> > > +
> >
> > Where did you get these values from? My documentation says:
> >   Mode Configuration
> >   Device 31, Register 0xF000
> >   Bits
> >   7:6   Reserved  R/W  0x3  This must always be 11.
>=20
> The closest is from the 88x3310 documentation that indicates these are
> the default speed, which are used when the media side is down. There
> is a specific sequence to update these.
>=20
> However, as we seem to be talking about the 2110 here, that should be
> reflected in these definitions.

Yes, this is about 2110. So, I'll find other way for my environment somehow=
.

> Finally, using BIT() for definitions of a field which can be one of
> four possible values is not acceptable. BIT() is for single bits
> not for a multi-bit field which can take any possible value but just
> the value we're representing there just happens to have a single bit
> set.

I understood it. Thanks!

Best regards,
Yoshihiro Shimoda

> --
> RMK's Patch system:

