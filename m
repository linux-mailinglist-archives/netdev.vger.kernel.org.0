Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373BC6C145A
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 15:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjCTOHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 10:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbjCTOHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 10:07:33 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2082.outbound.protection.outlook.com [40.107.247.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87A9158A9
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 07:07:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8m0JAawGbrPKxsyg3cIGOkcXcHMAgSFD87Ru8iwIZNCOODNXk357JlMrshkbgS5l2W9Vo1zOSZloUXrpdnczZ/HatXCWJPaF5vRrPYheuYYyzgDMfjvspAS/zcTNP3Lj/HytLOWe1hTQLcjjtpIy2sfPad53r/ISuPqwuJo635K3Zv0/CFfNgtEpZ2+7sox3gF4EL1HCjue0/OftuOptRc+xNvxyRwxqcCJfLyjDskOSaoIDlSkovq0ygqV3eGTHctWV3Q9+6kMnF5DFo8gIP/r53xsaRvr2mc/z0h1w7x/20AxJ8wpxFnhwPQ9yuTeduPpNQfkHtnR0Lx2t+cDQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0vT1TNU6WMGCINTM1HbyWbxB4fkFYO7O1SC/AduiO0=;
 b=Q3Evo9ZDNkDF5fwQJpSKNCwfccag4A4T9v47ANLj4djIWc33cH8qkLs3nEYa/YMLy2E9DYFUDSfOST/At3qM+2LuYALXHycnYxjuw7qXxzyjDEYuVfGyBLPIyyqPwbvDrUQxfMNQ4KyLqdmElza28D8scRQXkDBDVd5xl8BGYf9lKbKf3oTEAJBYC4qxXW74gl/vfWt1di4qatCacNVNL+PVYZk/0eOxJeHhzF3R1upxSCggNVvBazNKK2b/qkALWj9xrsM6U1qkc4xzeLL9dGJxzsf/jMwd3D06kImcvtvtW5HvBg7zQ1VEqS1EupapstYRLrVu50YoaXGXaXERHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0vT1TNU6WMGCINTM1HbyWbxB4fkFYO7O1SC/AduiO0=;
 b=m7tfrMO+HspGpIA/6UY83Pv8TS/IAyG8TBgEzEDvilsMoDVYiaS/Rz52n7VwcXQOe9vBkc79agH33IvOpd9Fj9iR98iGfGP6/oyZH2dRPU/GwhFkUuepN1xFgAyQh+WJ7Kp7/g8Tw8R1Q/1ME7Za5V4xoLTufWpsm6ibZm560ao=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM9PR04MB8471.eurprd04.prod.outlook.com (2603:10a6:20b:416::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 14:07:24 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::31d:b51c:db92:cb15]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::31d:b51c:db92:cb15%8]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 14:07:20 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH 1/1] net: stmmac: start PHY early in
 __stmmac_open
Thread-Topic: [EXT] Re: [PATCH 1/1] net: stmmac: start PHY early in
 __stmmac_open
Thread-Index: AQHZWEmdqZmCWENmKkSDQ+4hJZ0+A67986eAgAXF8wA=
Date:   Mon, 20 Mar 2023 14:07:20 +0000
Message-ID: <PAXPR04MB9185CF7EC5A94484EF8879CF89809@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20230316205449.1659395-1-shenwei.wang@nxp.com>
 <ZBOQecR6q5Xgr75F@shell.armlinux.org.uk>
In-Reply-To: <ZBOQecR6q5Xgr75F@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AM9PR04MB8471:EE_
x-ms-office365-filtering-correlation-id: 976f36a3-62cf-4d8b-ca3d-08db294c6b8d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nyjHk9maxS/RLQhQ8sH8R8+hr1RWyL8+LheeCA3l3U2y+jKEzZ6vC3cBr6tTyQo4sUyu49dv2Lg5sA1IOk9scp8o6ReWTv0exhtDKujX2RQoA31UFUyjkbk4oiVsRF4D3DmVpltkLg09tqHHx9InGzeEmA44Zhmd+MBUuICWv9HQb90QmhnTgsBfjlZMyEsp6RUzN5uuXi73q/pNLaGx/jFCouQw4GDXo2DPps7l8Vl5X0Ou7LfF2dGhjDsXqau1VRkklm8+pHhssZ1DXvZ8VE2jGRsnZK5izV6MlDA4nna7dMMDOK79x7PooNcPr1dOU7u4CSJR8HOyAZnaqnlvqOtFw3SiDJkZuvZXBy7x9emGqUNqNKe3sYTK2TA8/dXJXyHZMieS92gVake0YSdPmezN3syr9obRxkxwC53WMTuQUnb+p8AEJYdwCmRsbzXYJxC4opmIsfcb00IcdS7rsxY32G8YgRbxN+rVTboPKgcdii45rx64Fp3VcNjAJ5f0IievqYNcTd9iPJuc/xLJjrVOuS6Kybg+4FRqMV+lfa1k41ZjbicnAlFs6Jb659NltkzpApDPepq/xrrmPufo70CqJPHrJGlINgQZbQMcZwSqvirXUoqxn2HSREvE1ac5h39545sr4sua/EDZ7OtrMj5tII+FlzBVh1oHgXvnXlWsxvLJ7esSrA9zf2g5rFlv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(451199018)(38070700005)(86362001)(33656002)(4326008)(6916009)(66946007)(41300700001)(8936002)(52536014)(54906003)(8676002)(5660300002)(7416002)(64756008)(66446008)(76116006)(66556008)(45080400002)(44832011)(478600001)(66476007)(2906002)(71200400001)(83380400001)(38100700002)(55016003)(55236004)(186003)(316002)(53546011)(26005)(966005)(6506007)(7696005)(122000001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ga/glZdZ20riQk0oBI0WwvKxNDDLfToiSfXxcu5GRYfK1vKRRN+2l39gfdbQ?=
 =?us-ascii?Q?7gtpTTPi2qTQaN473ElFcvEJThYk9MZBSYQ8EHZXBLzBeMNPUp9v1/Ea0xFS?=
 =?us-ascii?Q?Qcputm3P1LaQe7HIKCMg4vtPMdXyAboPy41GLp81hneWDFhTgyO7Fmbi1RVt?=
 =?us-ascii?Q?QV+/68OaEBL9IJP1AoJtLjt3y4jgrwKIEttIqg+qGN6ygRsDFQLcw2V4sdVc?=
 =?us-ascii?Q?w8LOLs+9n8JTE6EDyRCGtYVUlxo5SCt9GX/wzMQQxK12dkTQX/HQKoj4nBlQ?=
 =?us-ascii?Q?qF36b+MwgxmRLZMz3RVdy5L6HqZke+WA0hEpMBUfuAf8YMeQnDyPF13XRbMe?=
 =?us-ascii?Q?wegPzV20MjaG3uX4dK4vzDlY2PLPAY/3GnTo5Nv1Fb9tHnMya0+o9ugmm669?=
 =?us-ascii?Q?+DT+HHtbfqHWlvJxPa2thl8LZuIoQJEhkFWyM+Ga05aowis7Qt2TPp+LZNHy?=
 =?us-ascii?Q?XoxBSvE7pNB3jY6mwg0OYHesjP6vLkogDEQszLXGhn10d5Krit8W6EHV4yiS?=
 =?us-ascii?Q?Z4+w9VMOmrsIjv5Zo/6ehYZ5rwwGu3FoeSmoEshCS7S0kF/hS4UbnTjq1+ge?=
 =?us-ascii?Q?5j9Y/6LJ3oV1+fBguZZZRmnq0hrCfZoOwqA4Oef3dpfiPJCi1eYxD2nOXJoj?=
 =?us-ascii?Q?h7hlEF60c/xvilb9VU2vuB5ixqAQWN8fY1J3wgCiIM51z5PBZdBAQBTFf/Cl?=
 =?us-ascii?Q?g/hj4X/os+1xv6nKZ2awsoa267EZJAVGcAB99L2POypNGDx2u68YHf/u/+jV?=
 =?us-ascii?Q?ebRjNzKXY/bVE+cS3cGVkJ9JArFGbJSKOehMBqTsaJasmzPEu7/qdRvQ4pXo?=
 =?us-ascii?Q?AbUaTRY6PsMXJsO3d6BKh5J/QSHdy5RS26kV7+LrKa+TM9z9vfab3UxW/UZ/?=
 =?us-ascii?Q?tYEVF3kKOkwN7uZuYVQ/4/wRPi2MZrmCMNe5pTd/npf5fNgK0GvcehH1IPeb?=
 =?us-ascii?Q?5xuuT2j+V0Bn0HOd7EySvJxAoQWCSPKA5393k6A/l7IHSsIA+7NvII2ZTxrq?=
 =?us-ascii?Q?whcyzoPIy5MkEFVOrYNesU/rJVYTuCCg80Fo3tRoE8KpcjXGM5AeaJb7Odyc?=
 =?us-ascii?Q?4T1Du9iUPBV/YaoS7iUZUpY2MHNQ6YKZIcs8Y1U9+K6velrYNUhCczNHBCee?=
 =?us-ascii?Q?HlJ4n1hdyj9lFPLKymI1DRjl/IDh8cFgZFM/5K8YRIMxUYjPEW9hBmylncB3?=
 =?us-ascii?Q?D2tMe3SMw9rN5iNskybjlbnySbhDJrhY0K+KRB56FvEoM5uX4qT34B5IAvwc?=
 =?us-ascii?Q?j0iXwSnxgu7R/d2bMRDUz3lHknQNWVMzMLd42Z6mybdWV8to2OibRwywTCnV?=
 =?us-ascii?Q?fK0ktQ6vT9mdM2rTURoSW9v9XQ2yYWB12KshrB+D9Af405Jy33RKkBlw6mxX?=
 =?us-ascii?Q?u7NgPIZkCPX+9ZrxIhptLqSEPgtphVMyC52BKj9Etx8XzjI5h36BraPOcgxS?=
 =?us-ascii?Q?9OWx9LxYmVAAlN44pg0sb4oNhPz3OqhwqgYDm6M4zBd0SIrskPouV5GBe3hA?=
 =?us-ascii?Q?2xYsu39qMSuNgWjUDRX0ksanEjeOigXn+81G+GSVKNDUlXd/vm9Z+UWaOClr?=
 =?us-ascii?Q?WEMqugJddh+98oE2mYkJrVdBzgQ9a/LlcNDtySxC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 976f36a3-62cf-4d8b-ca3d-08db294c6b8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 14:07:20.1596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NvHLDdYrN9OcKLQrZu7vDZcGeA1fXzkj/vmAJK6mmqLdVBRmzXeYVcZ+wWO2aws2AVtQkAP6VZ0Jwz5v5/ookw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8471
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: Thursday, March 16, 2023 4:56 PM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Maxime Coquelin <mcoquelin.stm32@gmail.com>;
> Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre Torgue
> <alexandre.torgue@foss.st.com>; Jose Abreu <joabreu@synopsys.com>;
> netdev@vger.kernel.org; linux-stm32@st-md-mailman.stormreply.com; linux-
> arm-kernel@lists.infradead.org; imx@lists.linux.dev
> Subject: [EXT] Re: [PATCH 1/1] net: stmmac: start PHY early in __stmmac_o=
pen
>=20
> Caution: EXT Email
>=20
> On Thu, Mar 16, 2023 at 03:54:49PM -0500, Shenwei Wang wrote:
> > By initializing the PHY and establishing the link before setting the
> > MAC relating configurations, this change ensures that the PHY is
> > operational before the MAC logic starts relying on it. This can
> > prevent synchronization errors and improve system stability.
> >
> > This change especially applies to the RMII mode, where the PHY may
> > drive the REF_CLK signal, which requires the PHY to be started and
> > operational before the MAC logic initializes.
> >
> > This change should not impact other modes of operation.
>=20
> NAK. A patch similar to this has already been sent.
>=20
> The problem with just moving this is that phylink can call the
> mac_link_up() method *before* phylink_start() has returned - and as this =
driver
> has not completed the setup, it doesn't expect the link to come up at tha=
t point.
>=20

Okay. Will fix the issue in another way.

Thanks,
Shenwei

> There are several issues with this driver wanting the PHY clock early, an=
d there
> have been two people working on addressing this previously, proposing two
> different changes to phylink.
>=20
> I sent them away to talk to each other and come back with a unified solut=
ion.
> Shock horror, they never came back.
>=20
> Now we seem to be starting again from the beginning.
>=20
> stmmac folk really need to get a handle on this so reviewers are not havi=
ng to
> NAK similar patches time and time again, resulting in the problem not bei=
ng
> solved.
>=20
> --
> RMK's Patch system:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.a=
r
> mlinux.org.uk%2Fdeveloper%2Fpatches%2F&data=3D05%7C01%7Cshenwei.wang
> %40nxp.com%7C23424b2776544630dbcc08db2669469c%7C686ea1d3bc2b4c6f
> a92cd99c5c301635%7C0%7C0%7C638146005820038948%7CUnknown%7CTWF
> pbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6
> Mn0%3D%7C3000%7C%7C%7C&sdata=3DyLeW5tBxRpYK%2B%2FjbwaFqigzjWHRq
> m89FAE3Z%2BlVM4s0%3D&reserved=3D0
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
