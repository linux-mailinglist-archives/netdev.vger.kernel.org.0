Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADC65BB46A
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 00:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiIPWgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 18:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiIPWgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 18:36:04 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60051.outbound.protection.outlook.com [40.107.6.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF10A3D34;
        Fri, 16 Sep 2022 15:36:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8PZJ/6kPYtZKLcXFwJJ2pk+mDsZS3eWKI2pEp+99yWfTPeO88v3zuoptTjNNvFqtmoCK8SjkVbCidMhNVnOziht+9JUHyP6c8PtsZ1xtYrReOqLRPrE0d/22He0i7qGzj4z2EAFIb4BOEC7WTYzRjhE8y6PbjOaDETdxQ+Qv3dHKGXouUNj4d56CEp5TEv9JmYbTHaaygXyXiXU4PcTjsUiLH20x2jzc8xk9FCdMSRQMTTx7OTdoZ7CFg4vPfkka7Pm9zDTY60GrMV5r2d++BLEWwJ7ZyG68lDzop3Ky9b7D0ixifrwQe5kexYxxmpaxsE9ixH/i0lxa3GvUKdg8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJ9hRMSv0ynNewljFm+KtVZ2KuXu1p4aiQk2qJu+EpQ=;
 b=SUJtAqCypFdAIUp0Iu3zL6QZGUEbDX5HIhWrQKZ/WJhIPzfX6QZF2L4bFlwy+5in5Kcb4EbapKU5AnirYnX/OOl18pNtIihyB0UbzCkbnsg3A2nJqOJ39vbLqZtgO2HMH11AICTmuiP2vooq6d9keavlrJvDRhiksENVCLSvj3YIl6OEW7UZUulfOwYi6UPdn2p/xiq7dUpThTujKerwamjOrKLVewpioakzklZa6M1KPlsSdLgKnV4MvMcC7XF8TvmB19s2lmdFHp5RZZsjFCcpdRw02GxEfLWgjL5vuUAHFNJpy/sj2Sddd2f+SvFjyalbm+Qyzu3zodKYP9UEiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJ9hRMSv0ynNewljFm+KtVZ2KuXu1p4aiQk2qJu+EpQ=;
 b=olLQ7CoCUS3u2jTrGqjqwV4HGhifhW+dCInNcXojMz9s2dsxzwIjrNFmUPvcLpfmd+6wwflYBrKorw+dDz+i68TTlqa0AdXDXxK71EDB3CgpM1E5CzMHPRwHJkUG7rs/zopOJD15f9Y6LfzczZm2AqZq40n2Zw7eL4W3VVm7DBc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS4PR04MB9340.eurprd04.prod.outlook.com (2603:10a6:20b:4e8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Fri, 16 Sep
 2022 22:36:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.016; Fri, 16 Sep 2022
 22:36:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 2/8] net: mscc: ocelot: expose regfield
 definition to be used by other drivers
Thread-Topic: [RFC v1 net-next 2/8] net: mscc: ocelot: expose regfield
 definition to be used by other drivers
Thread-Index: AQHYxhmAN1ERRaXlwk6n3S0yVpb9za3iW94AgABRUgA=
Date:   Fri, 16 Sep 2022 22:36:00 +0000
Message-ID: <20220916223600.aokvipptiwdheand@skbuf>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-3-colin.foster@in-advantage.com>
 <20220911200244.549029-3-colin.foster@in-advantage.com>
 <20220912154715.lrt4ynyhsfvdbyno@skbuf> <YyS2GHqAxczc73f+@euler>
In-Reply-To: <YyS2GHqAxczc73f+@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS4PR04MB9340:EE_
x-ms-office365-filtering-correlation-id: e406bb4b-ee9e-4b59-f6da-08da9833d4e4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 371x6iVilqwbh9pNB0I9PVK4B3Wa2TA7xJuWDMalxHmZ2++R7Tk0YLgpKhjQ/oiJSwXncYwGyNunDnsVHrdLdzyzIHCFtLhABfGpCE4Nfmz/laBCtlzgWYnTQ67e7ytz2iuax3nu7tSgx9WGAI8XvjI905Ph3iZcjed/LPs02fDuQGLtN/49CAR54JtbvVjbrNVil6/JIhIeDJSJ2wpMldbyDPlz+KIInoTjF3gLt6OsBMMJ24YxPWsAkftuvLIA3nAgreHPeDbZ0Ns4ibOungkMfV7oJKHLr/MF0WQKbqbj4kVPOKB+3Yr8KfIvwKeAGja9nZbCHaklmEZrYjjPJKL8Q30gfVZoAYoHtx/9ZqQ0jXGmvu74GlYL8MZIVNUWoUmxqD0d8Pj+BOqhOYxsbI+vSAwoc3+oK7shhzw29hkaK/5HG40yrvYrD80WRncRhN9pNcRwB09sGu3BOp0tqmYdCY6WIA6ORMZH7zulq8eccrUTekezatsp2plvq1sOI4EX/9xQcozxH8A+ZOu/BSs4GoRNItUClSE9qQyU/i0podp8ATJwopC+d/7nJCWIGFNgj7DqlajcWevvVAeLrNe8zdbBLExdkgmAYsPt3WC11ta/o9gtqw2TE14RP5acXw+xJc+CsAQZTWj3qWvkmBZMHabp4FZwIAEp8OInoTihPmCEQ0EaFnUpC0jB4hEypLKgxrL5bobPWY+aRqqgqg/GttT/A9uTm+Elw1R8ZG4bkOmXg7la847puV79ywROobAvGVopRHZ+3JNx1p7zxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(451199015)(4326008)(44832011)(66446008)(8676002)(64756008)(2906002)(76116006)(66946007)(66556008)(4744005)(6506007)(5660300002)(6512007)(33716001)(7416002)(66476007)(86362001)(8936002)(9686003)(26005)(38100700002)(122000001)(186003)(1076003)(3716004)(41300700001)(91956017)(38070700005)(6916009)(478600001)(54906003)(71200400001)(6486002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0dHoe9FOzweyCICAKBFYvDQgX2hqEbP7E3mgy+r2AtBn6k/1zHKZjNUEE5SZ?=
 =?us-ascii?Q?My9dSkAGiVNhweFRsnCW4YZbW45mDAT8jDdIxgZDaEyZ8hUGDfUNQSFzTyiN?=
 =?us-ascii?Q?o4ACoZT4FbvqjFCbeOOOY74IY8jYTURXTa9+KDBkRO9cKUPVOjLvjaXY5BqK?=
 =?us-ascii?Q?DwMg6sODW+IMMfl99E36l4vxe+1qgPBEC1lZ7xPVGlV+sf6uSe6g1Ca2wr3s?=
 =?us-ascii?Q?uuGZ79/BnBZSFR8qfYS3DleYra4H6wtKYgLV27bO92Xz1yCP2Vseusor1S+L?=
 =?us-ascii?Q?7VaesUiRpufrSu6dpHxR6VR5xzCZaTf32sjR1yr1YRGmT3/UuppmH9YA5Uhv?=
 =?us-ascii?Q?eTqVEvncYvTNhU8ZLM0e7aIlJcymlqAkj/w0A0rsQqHcj24Y3jyGdsUvLI88?=
 =?us-ascii?Q?aluiaVlVJUblhDbGCH2HF3Stcxu7SWesqXt7AgcDXoWQSuczGtgbxvVuEjdn?=
 =?us-ascii?Q?nJ2l5ar/bV4r8KL8/ofLDdtQPCz4do5BORzlro3xBULH7ETtImwlC9lJtsMC?=
 =?us-ascii?Q?0nyjYfjK2r8jZXxiV+GokpMPLbrpP0Q/wwGEU5gS509A6/zsm3L75K9SVGmQ?=
 =?us-ascii?Q?CebDBOgAziHxEFqE8d7YeqCbrgmuT1YjbifeC631WKitypzZlztYTPlPhe4r?=
 =?us-ascii?Q?wETblajG71w9OnKD78otARKaAPmeN3SJbKHHBu/wSb0pGeetqLeMcScj2gy7?=
 =?us-ascii?Q?qrSk1LAj15f9FU5krb3WQ3JX1Gn+lqOT08NV7JZbvdIHdiepYrPFQ+DWcQEI?=
 =?us-ascii?Q?vr8GugYkqyfQD9bdr9RCfTRDILhZuiqqE6oGH5mnZAkb+V3zh1eFkOBW0S1b?=
 =?us-ascii?Q?Bg//8fev07bvlWu3s0w3oCAPwR6tFV1FitiiudyS6I5ohllcRsjFQrmmWFgP?=
 =?us-ascii?Q?5fgtgEO25TtPN1UtACRwec9rv2bnOpmemKdMSHvMC/s5gxdkcfNr1245odwl?=
 =?us-ascii?Q?eFJ9RQzudgXsDQeYnMeEtWbf9ca33u7nf//2B8hMuLDpGMHBlD3XYSKnXwpD?=
 =?us-ascii?Q?GJPGk5/TtiuoNdFsyhALjFlNbkluao0qBu8A9eoiLydq8iEIVvyL5GTxBUP7?=
 =?us-ascii?Q?dkx1M8lVq1JPGmys1V/YYxudqAWiweUa3P5s8doIphphXWEsRhCWWDVSp8mc?=
 =?us-ascii?Q?gHj+iPl2z+IbcKU8BCbkNWnTfXtb5+yj1M/CFx4nnIUF5TMUjdQyRh+yE3G7?=
 =?us-ascii?Q?XmX0Zyn+r5OUbsdJ4YG7kBte+Tytm1ZSP4PU0UJz4U+Iid2d2hXJ0nYcQCC5?=
 =?us-ascii?Q?UxnsgYzd9rZfEVhT7D8NKUFiSnVTNEQ3esS4bJGuGzlSFlUvtAPafojw2z+z?=
 =?us-ascii?Q?25kxO8sPb4pIOnOm/llw4jr/K4wlPP6UjYapx3hV4EElRh5RLzrJL+leNCWk?=
 =?us-ascii?Q?GTIj9xMpvqavo0datR81lmt3GXQWCx5QR2z7BKU3V1qvSDVPNYGxnPu8c695?=
 =?us-ascii?Q?EQqRvBsR/2st7MsaAd1tUpyPaVcX167jYCMsxhjJEYZn+H+K3776cIi1JmVn?=
 =?us-ascii?Q?mv5LZa5h88ePgGHQW+J7yHMsshbTHmWTT40gF/N5lSa8V+GdinK+G1VKrrVe?=
 =?us-ascii?Q?H/AYVvBYgrsi5oiBGx6SNLHfsMtrd2MIHgV/dH3YQBKc1tVKRiZZKL4Qo9Hy?=
 =?us-ascii?Q?Hw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5F70ACAB9FB6C0408B05EA1F960AAD49@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e406bb4b-ee9e-4b59-f6da-08da9833d4e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2022 22:36:00.8563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xfjRzzTrbZNwr8Mp8dGP2AJDASlk06XbU252NWaD0qC4Q0VyrY0Q3+11+qUAVrCPKsQzlgsUSaqlFFLwnYTH2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9340
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 10:44:56AM -0700, Colin Foster wrote:
> I'm assuming you'll agree with my a-ha moment regarding ocelot_reset()
> being in the ocelot_lib.
>=20
> There might be a few others as well. Should I add them as more "export
> function X" commits, or squash them (and these already-reviewed commits)
> in a larger "export a bunch of resources and symbols" type commit to
> keep the patch count low?

Try to keep patches doing one thing and one thing well (and leave this
patch alone).=
