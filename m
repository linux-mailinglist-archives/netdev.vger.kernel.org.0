Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA22D66B4BA
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 00:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbjAOXRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 18:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbjAOXRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 18:17:02 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2054.outbound.protection.outlook.com [40.107.21.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC8B18179;
        Sun, 15 Jan 2023 15:17:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRIhJscrVzD5MsDLPgHIpYqGHnpceikj5kq9cTUR9tzc7Wl+W1M8qUEOtQtTMY33dZEEjbnqbDDHaaxJBK4arrRkQEl1K7G/2p0znW/FAgcNyMEEDMvuY2sMBOkrSfbrUmmiazuhztnIAH2zANh3S94D4flF0FazCBaDXWZml9vcmzf+PQ6A2XK+TgdDg60G9fQokPaPb+b58oJ5kLi7uzdFMc7OTSNa62ROYvLofQ4VnfAvmNCMVa5/EqbbzrhqZITkHvaBPYK+XAbSKgamaBbALzIV0ALdpthK1jyxxa7CdHNib/cWZPuXExbBI23IHY7FU3POxFHn/qlHKfnqGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hbtE+d4MxZYP22EBW5MnK69DvG4MyUQlxH5e2qasCu4=;
 b=J90vQZd87mOL49+bJRrbpTO3Al0gaRD/Gg2OgKyMmTxhcmdtHGol/ugAn1HcTnJJlKSh0y9tR6bnFvJoPEk+v3PjNyKZO+IRqf3Ch1qTjrsAcZ6V0/IF5ecMIN8Zmx10zg15vjms+Ell6rSZfDgTxrqACNeTbIG3AS+64NN9V1acdUiUAnvB5qu/navfG+HynKaIIy9C7H3rRdrzw39ocK4S/xnZw3QNreq9fTe+hIn3kXK6XdcZfqWCDEsVyJeco+pw+0hUb8/ZjAHuPOstLBOCIFf4H0dapmL28Tgpu8j5Q9tUuxZW+Xdcjgt+LNGhIwiL0lZN0U2Kn20Jb3xYbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hbtE+d4MxZYP22EBW5MnK69DvG4MyUQlxH5e2qasCu4=;
 b=U0gexikhFPljms/+aJ+JuWSWbwn7xH5cTaqI6T4ZFDl3Ux8Y83DcIzTNP4txl8YHau8h3GFYiXojxIfklplbx3nh7ypTt6S7RUZgkRzC+COi+Q27F9XN1vSen1AuF3qo7na7rkUbR6t0lwWLXhdZaXKvsicwu7cnkv5jWwiBEH0qYLoDwD/CVIVA+RY+Fhg3hzMV2hn1F3p/jdHk0L4ooZ93MOekkCs9yxMkpE7/GEDoZZqPcReKNswrc7oDW8MF8obhS9C26m00sHK/dgYhaPWD1vTNR24Oz3fOeib+NfhGlBvizkKY/96oNvL8ojn4Sgapke6jf1P6EZkHfLWqHQ==
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AS4PR08MB7951.eurprd08.prod.outlook.com (2603:10a6:20b:577::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Sun, 15 Jan
 2023 23:16:58 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee%5]) with mapi id 15.20.6002.012; Sun, 15 Jan 2023
 23:16:58 +0000
From:   Pierluigi Passaro <pierluigi.p@variscite.com>
To:     Lars-Peter Clausen <lars@metafoo.de>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Matityahu <eran.m@variscite.com>,
        Nate Drude <Nate.D@variscite.com>,
        Francesco Ferraro <francesco.f@variscite.com>,
        Pierluigi Passaro <pierluigi.passaro@gmail.com>
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Thread-Topic: [PATCH] net: mdio: force deassert MDIO reset signal
Thread-Index: AQHZKPvgQPO0npisDkSvgN3jEdgJF66fthyAgABQ/YCAAAm5gIAABmIAgAAEPoA=
Date:   Sun, 15 Jan 2023 23:16:57 +0000
Message-ID: <AM6PR08MB4376D91F2459E8610F0CCA59FFC09@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <Y8QzI2VUY6//uBa/@lunn.ch> <f691f339-9e50-b968-01e1-1821a2f696e7@metafoo.de>
 <CAJ=UCjUo3t+D9S=J_yEhxCOo5OMj3d-UW6Z6HdwY+O+Q6JO0+A@mail.gmail.com>
 <54dd8952-dd39-cab2-8716-cd59d3266d1a@metafoo.de>
In-Reply-To: <54dd8952-dd39-cab2-8716-cd59d3266d1a@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR08MB4376:EE_|AS4PR08MB7951:EE_
x-ms-office365-filtering-correlation-id: 04c68f0d-01a1-406a-0b1f-08daf74e9971
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y7AKNhO9QNx+USv7y+qjem+v4f46BMIGPeXEgkEnM0Qmg6SMQHZhu1pkn8YxjddHwQF/PqhQkPp3qwhH3Lf+DuIole35+CT3pfi+5+7ixX6/T8kjIVmlHRVO98OD0Bp3RfYRF/aZsKvdLMGIqRMQyXyHhIIVTaEczysxl86BiPBsGVbxNBQ9yeEJkOb6c5y6uHBnsOPhxGr5vC8AcD5FkZFWwemWikVQgceeF1dL37yV6yG5RmPevuXHV7LTQBFAQkZ8AbFqXl7nAGFg+jVruvOiSUCdSVULuSA73zRk46dATf3DTt306PnwwVs6bcJk6XuekGq+oBbG/rtZkPm6O81TwNUXoPSLH02v7T/SOAg1vzFAKQFuqF7vqKV96i306Nyv7Pf+Yd5jrVigB7I0uD516bYBDI4VGPERNOHWt7LEBRyaGQNHCMdFpt2drETd/xob+00z6Kctbws4PwROgZ/VzHqummb7k36vd3MO1C2N3SLHA+vqsKmJd/v2N8/VzTAnMr/YjaIKcKUSFw8nydN6MfdkKfid1cbWmJmbgi7AYFZRguUfIGVxsmMckoafUpFcq/lzeUzuGryVdw4Is82iMWDDlFX/Dnjs0kywk8h2+m0rD1/uZgw00YGtsNBrg+V8mGbUJvTVCPYqluHD9rTbmfxcos9YaCH6dMI2QuSeKI029rCuRtNguVBgfk8HmGJjcIQrFC5UC4EZ07Zgag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(396003)(346002)(39850400004)(451199015)(83380400001)(41300700001)(6916009)(66946007)(66446008)(66556008)(8676002)(4326008)(316002)(64756008)(66476007)(33656002)(38100700002)(54906003)(122000001)(38070700005)(86362001)(52536014)(5660300002)(76116006)(7416002)(8936002)(91956017)(186003)(9686003)(2906002)(6506007)(26005)(478600001)(7696005)(71200400001)(55016003)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?M/pq+joUR859BJzRo8lt7xjOF8M6bcF0NrsOpCNf7L3Zarx3+rSfV3HUdW?=
 =?iso-8859-1?Q?A62upMk9djtuER+lC6sUi6Z5lvOvJtOg8tQ70TkOkpCNyzdX0JTzlUMn7y?=
 =?iso-8859-1?Q?7/I4P+sV/S1Seg98O8QkLcQyUVNDuJCOj1p/xAVOGtnSvxUQDOCKeVp/If?=
 =?iso-8859-1?Q?dnfsx9c/rEG3WqrFOlIav7Y3Oux+TqVPbiDBnMrmtJIyf6d0d+NJk5GnCA?=
 =?iso-8859-1?Q?cVU8XDXgO2qaBhpoqUB94HzN94HolGz+h0RAZV6sBoxTr+Etd73SuyYMFE?=
 =?iso-8859-1?Q?vYOl4LQu0JVf+nvyGoQzAjGuAf0m5gKmrsCVIM3ameUaNFZ9nt3sYLUUOu?=
 =?iso-8859-1?Q?wPxKlQobUG29/r8I0WYbM49A1QYF5mqjmah62pOmWN+WRBveLJ45+qw7l8?=
 =?iso-8859-1?Q?52IJCVp40yGq8zY4++FftZYjC+I3wdoeRWO4JUTb1cZGOXgHGHfwfY3ZXd?=
 =?iso-8859-1?Q?nMZati1juHrUXP/P7TluQnVPWwhrO41Edn4tyQhbCKLs/j/Ga0XDsW33Zr?=
 =?iso-8859-1?Q?rQPLvtMn9oed9VY2+Kj06nk2s5xyX3FP1FgT+OKW5wE7xNMl0GaAO18PIC?=
 =?iso-8859-1?Q?69M3tdHqadDf7JE/f0NAuaBZwWgj98nPYUWO4Uke/WCcWOToFI0ksG+kss?=
 =?iso-8859-1?Q?N/vmKSUikr0+0KGLjd+Utamf6XMpyeXA6E8un46pRtOqHrWU9wZDv6wUy/?=
 =?iso-8859-1?Q?Xhnn28GRajSYLlhbUNnroZB03411gImrhd12I79He6UQjoJH8/B0RWvjY9?=
 =?iso-8859-1?Q?PiZYMqsZEMIc0+4Zy+snFIyVU74QhCwJHbJzkDzp12hLT0dzdP0jM6JbLI?=
 =?iso-8859-1?Q?ZRVtUjluWE7gGECT15bV1o/Zmyqwyg+4AB9CE1Fc4tD/cNxLfA598JGcMU?=
 =?iso-8859-1?Q?Vw3Q6tFMHQn9P0o++viMMn/0WEJ7VrLpqW3w3ZR0G1LH1EAj9CaAZa/oBw?=
 =?iso-8859-1?Q?EtubH8fQ935c40/meQCuOtOzvA+a1HtaNFtZTSI+P3KgIVbvukk7TAJPzg?=
 =?iso-8859-1?Q?OBo0n9NvMl4/55oO3elwjvVCvmpmVGas9skznfOReiHkhfPfJvDINFFN3i?=
 =?iso-8859-1?Q?mJEJPdsbAI0j/olRFGbzSoydNwjeNeUa2Ke1u2Jw56ZF8pSXsGM5vHZakz?=
 =?iso-8859-1?Q?d3vaS68lD7K50p+r8GCHGAhX1CsHGGrAJQa4A+Np2hWsuBtwJzHlB+Edi4?=
 =?iso-8859-1?Q?MP4MVuAh71mPmpMAtkNVydu3uUqMI80j9RI6Uyp6MLCRynxEnrX/io0vXs?=
 =?iso-8859-1?Q?28fmKX6L9m2wVQKjvIdThgmgrTOMKpFKA0pCKKHYkOPKf1CjMpWKCvKEcq?=
 =?iso-8859-1?Q?rInyVZErVMNXp2oWcb+tT43XAoyulZAUBJx8yyAdk5D+VUvWAKQ5TuTWzJ?=
 =?iso-8859-1?Q?psWoLr8GCd3SKTaiwiIfRBwY2+RHDGXtP/+NAbwg+Qqb9M5z2Msy+VTU4C?=
 =?iso-8859-1?Q?ZVkmPqNzFf0dDctTcqFArLeicNLdAgU3CLyzT5Fpsy5MAxb5Msj6h0DqGk?=
 =?iso-8859-1?Q?2VhEZNOH/RDSmV/46ct6xVpzjuUg8ovkGJnyIGY+IjJjo0VhP9vfdzkmP+?=
 =?iso-8859-1?Q?A2MDxOD57OyJ+v0XGbfUFFoV6kD8CnkQ+giV3t/gHnt9SXBt7TT0Ch/sxW?=
 =?iso-8859-1?Q?5lrXezG559n6ZmwNbp9mRO/5rg/ALfQ8iO?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4376.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04c68f0d-01a1-406a-0b1f-08daf74e9971
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2023 23:16:57.9866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VzZ50QXBy6MH/9G6VlleQ3YWveTxLfpLjMdHCarw/VbchPzOHC+IZf4lURi6lOiLIZXHhjClSVqo4n7LFKcnt2A3W4tbTwWcT1ZhLq7zG+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7951
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 15, 2023 at 11:56 PM Lars-Peter Clausen <lars@metafoo.de> wrote=
:=0A=
> On 1/15/23 14:33, Pierluigi Passaro wrote:=0A=
> > On Sun, Jan 15, 2023 at 10:59 PM Lars-Peter Clausen <lars@metafoo.de> w=
rote:=0A=
> >> On 1/15/23 09:08, Andrew Lunn wrote:=0A=
> >>> On Sun, Jan 15, 2023 at 05:10:06PM +0100, Pierluigi Passaro wrote:=0A=
> >>>> When the reset gpio is defined within the node of the device tree=0A=
> >>>> describing the PHY, the reset is initialized and managed only after=
=0A=
> >>>> calling the fwnode_mdiobus_phy_device_register function.=0A=
> >>>> However, before calling it, the MDIO communication is checked by the=
=0A=
> >>>> get_phy_device function.=0A=
> >>>> When this happen and the reset GPIO was somehow previously set down,=
=0A=
> >>>> the get_phy_device function fails, preventing the PHY detection.=0A=
> >>>> These changes force the deassert of the MDIO reset signal before=0A=
> >>>> checking the MDIO channel.=0A=
> >>>> The PHY may require a minimum deassert time before being responsive:=
=0A=
> >>>> use a reasonable sleep time after forcing the deassert of the MDIO=
=0A=
> >>>> reset signal.=0A=
> >>>> Once done, free the gpio descriptor to allow managing it later.=0A=
> >>> This has been discussed before. The problem is, it is not just a rese=
t=0A=
> >>> GPIO. There could also be a clock which needs turning on, a regulator=
,=0A=
> >>> and/or a linux reset controller. And what order do you turn these on?=
=0A=
> >>>=0A=
> >>> The conclusions of the discussion is you assume the device cannot be=
=0A=
> >>> found by enumeration, and you put the ID in the compatible. That is=
=0A=
> >>> enough to get the driver to load, and the driver can then turn=0A=
> >>> everything on in the correct order, with the correct delays, etc.=0A=
> >> I've been running into this same problem again and again over the past=
=0A=
> >> years.=0A=
> >>=0A=
> >> Specifying the ID as part of the compatible string works for clause 22=
=0A=
> >> PHYs, but for clause 45 PHYs it does not work. The code always wants t=
o=0A=
> >> read the ID from the PHY itself. But I do not understand things well=
=0A=
> >> enough to tell whether that's a fundamental restriction of C45 or just=
=0A=
> >> our implementation and the implementation can be changed to fix it.=0A=
> >>=0A=
> >> Do you have some thoughts on this?=0A=
> >>=0A=
> > IMHO, since the framework allows defining the reset GPIO, it does not s=
ound=0A=
> > reasonable to manage it only after checking if the PHY can communicate:=
=0A=
> > if the reset is asserted, the PHY cannot communicate at all.=0A=
> > This patch just ensures that, if the reset GPIO is defined, it's not as=
serted=0A=
> > while checking the communication.=0A=
>=0A=
> I fully agree with you and I think this is the right approach, cause it=
=0A=
> is required to make systems work. But I've seen two attempts in the past=
=0A=
> that did the very same thing and they always got rejected. I can't find=
=0A=
> the patches anymore, but I think one was maybe 2 years ago.=0A=
>=0A=
Rejection is always a chance ;)=0A=
As long I can understand the reasons, I can at least try improving this pat=
ch.=
