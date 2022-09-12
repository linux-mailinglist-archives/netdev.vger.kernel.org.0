Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14915B5EE0
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 19:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiILRIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 13:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiILRIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 13:08:14 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2072.outbound.protection.outlook.com [40.107.21.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AE122BC0;
        Mon, 12 Sep 2022 10:08:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y2/OP9NWktb+3LIEpGVwoQ9UQGw891KOQTqlJp0W8KNXCF409Oevvkm0LHAzXklo9cXg2CFefCfZmtbPtDYXVnkQHtxQ2alObTm5JgsdhkyYp2eKiCuxqxHQZjZ1D/C/qS8/zCKJLeli6dYYf4G7yCQXwBBYrOO7Pi8JYGqigg/5W6AHhHnDhCGZb6WVjdpHrzeOsJOJ7+i9eJTDvjFoc9AHmyKw/lPO3NzWvt+VPbn+zo3QlyBFeTYMLh+1vTkUhYhAV9EGVu8ram7SHa7Buxwf6ajm83oXRWZUmmtZO0zBhQpfnvFEYrdekaRXrJgWfir8n5LbXf7RAA4HoK6/jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g+iD7g0w9xB2QWP5bCnb3ZaU02RRkiPFVw778YWVlfk=;
 b=KVjdH+h964BKOFxFTeUb4VbceYeF3n3EBzUBhLT1io/mOkWxfVEoqFvEwDWJ/b68quKQ/76yUx/6Rte6fWJhYhEBXVJjYJJkwuy2aiHlg34E7v7ovRnkyBQyRVY5D9us9W1CB1BMAdSPU2tYVh8Aiil4mLA7dIuYl7Th/AHPw3l5icCexP5fIQyMTJTReHcG7PzlVWmq0gP5HnSEn2UCiY4rHXnlgG3H5KhXntlbfpGwNYqRjdBE23A3AOcQ5PLZf7nYFdNWAw7gGeECAkz5Z1ldP6ZMoAbqq5EE1MjPK4RjTDV9oWhrwuk9qbpd1bAm2j18CJLbNLNVL1G7MUI1vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+iD7g0w9xB2QWP5bCnb3ZaU02RRkiPFVw778YWVlfk=;
 b=M1Bjaq/pHbFMFU9+NntnwE2J+82GZfIfJZZg+qY9/yUKlOQlbnSUvjdsGsE95cMZC4iKZ76HjRNoh5+ZJdNEOHdPssUPv7avMSs05MoOPtyOS7ayg5KCA2Av0Ys0Dnc88+BtynhcJpz0V3DTsueeHAkUBEpQUcyLCzvbnLSfvFI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6813.eurprd04.prod.outlook.com (2603:10a6:803:13c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 17:08:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 17:08:09 +0000
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
Subject: Re: [RFC v1 net-next 7/8] mfd: ocelot: add regmaps for ocelot_ext
Thread-Topic: [RFC v1 net-next 7/8] mfd: ocelot: add regmaps for ocelot_ext
Thread-Index: AQHYxhmBZYjSTVdDzkG5f4rICTpo5g==
Date:   Mon, 12 Sep 2022 17:08:09 +0000
Message-ID: <20220912170808.y4l4u2el7dozpx4j@skbuf>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-8-colin.foster@in-advantage.com>
 <20220911200244.549029-8-colin.foster@in-advantage.com>
In-Reply-To: <20220911200244.549029-8-colin.foster@in-advantage.com>
 <20220911200244.549029-8-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|VI1PR04MB6813:EE_
x-ms-office365-filtering-correlation-id: 963be214-1e6b-4f36-c513-08da94e15e30
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p1zAgOIDlgNHgNdbiy8+6CWah5GTUCvdVUMwTVyWU7mUPlt/zTxKFdOYoUDtthsMX6JrEHXXKzaqlyNa0peBg9v2KaSR2Y6bXuzE3j4/F3tuwNuD3VQFzUQJD78HH0xHO+BCvA0M+yZhntzFx2pBKSSIKFaSAO8Q0kCUOoR1ZLGIQcmmuGkfops+uCnKPVdOSvKjbCxEPm4qCMFWACZnFJMkefMAgKKiy3wJ/Wc6SaH/gDj4oxrQ2P9Rlu5tRJCeL31eoP9m2DDX6kkRTqjOLrCe/rJSSrLe3bj55D7r8+9MskItPEjW2HlWGVpvkNRa9EHD7MNrJ6p9mJ8DcnZwhCZoIOuhqHzDI1McIfP4mqGZLuHt/OqIT0yisUa8wsW8oKiLFMVOb3vcHF30+Z0dIPRZ/bsf5WdGyrZ/1VSYaZt0ajwB6r6kSONspQk3ORhj6VH9cCxiJ4z9rw0ADF3NXwJBlMrshlqBAKjTbzYEkRyaT8RFew4Vr7mBabLFwukzUm6pqWOkR2L5+0jNgF6t9VyMOd/oyabE8BwUWSTew/NsfR5SaZ9zxlJmWZU0GjGBvWhEXVeE0kAjXSps5VHfGUXPCRqRXMTAhDnXOxAlKxidjgxqpEddw5EAA9f/QIRLaZeJ44NGjt/AYZjVmEMB0QHkRCDqv8Pe/3PI7RrSlKVL7XeKcrdKfftAf6AXlN23pgUnhpkpVkD6twR+SQJUF81sSFm6gGRJGto+hPkZ0aOpnm2B1mMWT66W+4ABZM9mLE/j7XO9owtrgRNEZj3Yc9FRWSWDxewgfjdMs/5gpCc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230019)(4636009)(7916004)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199012)(6506007)(1076003)(6512007)(26005)(5660300002)(7416002)(91956017)(76116006)(86362001)(38100700002)(478600001)(8936002)(30864003)(66446008)(8676002)(66946007)(64756008)(66556008)(66476007)(6916009)(71200400001)(44832011)(316002)(38070700005)(4326008)(83380400001)(2906002)(9686003)(122000001)(966005)(33716001)(6486002)(54906003)(41300700001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?w178HfFPe/HfEAnH2scLItDlw3mryLVqA7SFfhiI+jFX5XwSnpbPWpbITG+J?=
 =?us-ascii?Q?PDNEDpgAHGuj19jyPd/tsoNlvTwP9ZJzL/6k8z/yzn2woi2e1zkkmC2G8fgk?=
 =?us-ascii?Q?eYsFP6m/Q2RXM4UAgwmKk3pkCZHkXYoSLYCB9+iY4LKAYUYqovhn4xn1XANS?=
 =?us-ascii?Q?Nqkb2dRWcHiJhu+u76xiCg+nQecgDUsdAbZBggn5npKhfpGmNt63DTVyZYEF?=
 =?us-ascii?Q?4OyEFcsR4Ye8+Qy4AiH4E3x8in5tfVl8WWqCcJ4VECXJ6W602brrpV3dHzvm?=
 =?us-ascii?Q?pgSBso6mUHApseJnIA8jGCXxWR5XrLJermTYkSflF60OU6Qnfgyi/23x1rnO?=
 =?us-ascii?Q?NI3xfe6RL1G0yOzlT8GcSWDSL+aX/qWwWF9bdGVRdl3kCp5HHI4XL3dPw1th?=
 =?us-ascii?Q?VqItABjASBNN+vPBekGweDR1LTcnjkEeLc+LofdsoXAfN9vkxgBg4MOhmx+6?=
 =?us-ascii?Q?6gyt5Rf3+l4Ao5M2g2oAMiOMODgl7m0fdK8muVyl8xBk08PffbF9QD2MWK72?=
 =?us-ascii?Q?0MJFG4NMPVwac3qklG9tJGuu7SG2HyC7AZs3+UsZJTWWHxf/ohHBOPqMXtBd?=
 =?us-ascii?Q?muiuFNEL7+5+xwKiL1YmbsdSAvmCJaxDVMY0TJEaW1RvstFABrYqFoiINr8x?=
 =?us-ascii?Q?qJcIlmAXaCgoyMfDj7rquVkYFD3rzNzwjcWi38QCrUR5FFuE0V3BkRbBd5QN?=
 =?us-ascii?Q?5UNKO9sgXDA54vOZViiXbpu1CyYnoE2eB+WiXww6u9jZzsKnGO/hYkys+JcK?=
 =?us-ascii?Q?lzsMzN5Ob7JQ+yw8Q6MmpqW5/1DlxTnEjNvhcXTH/dXH0irGs+3QeglzoXIk?=
 =?us-ascii?Q?XgaW6nwdYrVVHbrrb3XEbC0kIfHNqHUBUOlnE9/kWw3WSlieHL5bj5YB8Tgn?=
 =?us-ascii?Q?+aNgY3Or2fKefZVk1F2HvTX0ylPGc9BV00a4+BkIKTg5LxR7BLHVvhTFUBTo?=
 =?us-ascii?Q?O0W91WfdxMDy1imXF2atr69UVVNObPYw9trCYUpgv+aWPk93v3hekA6cvQa5?=
 =?us-ascii?Q?6D4vzpxq6fzUDijrfNTuIhzGpoimtChEEK7JsqpZKS/Wzrnhz+ODlAqIW2DW?=
 =?us-ascii?Q?ZeTMwAzwfguRzrymCRyIesff7ndVoEmQ7mTzoC0Tyhzt3ZNGRWdqijIZLV1I?=
 =?us-ascii?Q?Bmk1xUFZhrHKMYAob1ZvnT+N/SksHViGXtwpB1pF+KQyh1zRzdLIcU7uGJe8?=
 =?us-ascii?Q?Wey2hatDldhZ8VMM5oQqTgh06VIZw+A/Czs0Ua1YF57GS5gqiuGsaSbxW2Cm?=
 =?us-ascii?Q?vq5xqBw8LRrnIDv5enGmTlylddo8rC9i+km0G6HBiDFUUgUONNCDnz3Y5fBU?=
 =?us-ascii?Q?W+9ACM8y3KtrN9FsLz2x6RryOgoEiGltHtTRhU0zGGsCTpLvtKjzF+g2/lcJ?=
 =?us-ascii?Q?4UoYAOyXSYQz79QZDnJXOfb8rRw/wPuK5MF6hbtODwzjIrXXcPEMHheUh/2z?=
 =?us-ascii?Q?yxn6D/3phIPCkZU2xf2liens66VaJm5P3z6jJMfF5P80omqbypPF2zz+Gu+m?=
 =?us-ascii?Q?3x3ktSsZn33s9JyzkaWbNljtVcRqVWlatvT2OmW1sr4vopjyx/UCPi44cCgH?=
 =?us-ascii?Q?NncRHwmtePjWzjxUKM2OP0A+hEPV56rktnrUzpkw83vP92T+jtgjScpIOfnF?=
 =?us-ascii?Q?SQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <848D65C48A4B9840B5987CA62FDFB9D1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 963be214-1e6b-4f36-c513-08da94e15e30
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 17:08:09.4840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YMTsPlLG5k+WLvAKj+OvRbaB4gniS5RnoiCI50bz7Y/AR1uFrto5Y0ryEhNIoHZwBMmylEiPU1pmcwPNCjwVJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6813
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 11, 2022 at 01:02:43PM -0700, Colin Foster wrote:
> The Ocelot switch core driver relies heavily on a fixed array of resource=
s
> for both ports and peripherals. This is in contrast to existing periphera=
ls
> - pinctrl for example - which have a one-to-one mapping of driver <>
> resource. As such, these regmaps must be created differently so that
> enumeration-based offsets are preserved.
>=20
> Register the regmaps to the core MFD device unconditionally so they can b=
e
> referenced by the Ocelot switch / Felix DSA systems.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>=20
> v1 from previous RFC:
>     * New patch
>=20
> ---
>  drivers/mfd/ocelot-core.c  | 88 +++++++++++++++++++++++++++++++++++---
>  include/linux/mfd/ocelot.h |  5 +++
>  2 files changed, 88 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> index 1816d52c65c5..aa7fa21b354c 100644
> --- a/drivers/mfd/ocelot-core.c
> +++ b/drivers/mfd/ocelot-core.c
> @@ -34,16 +34,55 @@
> =20
>  #define VSC7512_MIIM0_RES_START		0x7107009c
>  #define VSC7512_MIIM1_RES_START		0x710700c0
> -#define VSC7512_MIIM_RES_SIZE		0x024
> +#define VSC7512_MIIM_RES_SIZE		0x00000024
> =20
>  #define VSC7512_PHY_RES_START		0x710700f0
> -#define VSC7512_PHY_RES_SIZE		0x004
> +#define VSC7512_PHY_RES_SIZE		0x00000004
> =20
>  #define VSC7512_GPIO_RES_START		0x71070034
> -#define VSC7512_GPIO_RES_SIZE		0x06c
> +#define VSC7512_GPIO_RES_SIZE		0x0000006c
> =20
>  #define VSC7512_SIO_CTRL_RES_START	0x710700f8
> -#define VSC7512_SIO_CTRL_RES_SIZE	0x100
> +#define VSC7512_SIO_CTRL_RES_SIZE	0x00000100

Split the gratuitous changes to _RES_SIZE to a separate patch please, as
they're just noise here?

> +
> +#define VSC7512_HSIO_RES_START		0x710d0000
> +#define VSC7512_HSIO_RES_SIZE		0x00000128
> +
> +#define VSC7512_ANA_RES_START		0x71880000
> +#define VSC7512_ANA_RES_SIZE		0x00010000
> +
> +#define VSC7512_QS_RES_START		0x71080000
> +#define VSC7512_QS_RES_SIZE		0x00000100
> +
> +#define VSC7512_QSYS_RES_START		0x71800000
> +#define VSC7512_QSYS_RES_SIZE		0x00200000
> +
> +#define VSC7512_REW_RES_START		0x71030000
> +#define VSC7512_REW_RES_SIZE		0x00010000
> +
> +#define VSC7512_SYS_RES_START		0x71010000
> +#define VSC7512_SYS_RES_SIZE		0x00010000
> +
> +#define VSC7512_S0_RES_START		0x71040000
> +#define VSC7512_S1_RES_START		0x71050000
> +#define VSC7512_S2_RES_START		0x71060000
> +#define VSC7512_S_RES_SIZE		0x00000400
> +
> +#define VSC7512_GCB_RES_START		0x71070000
> +#define VSC7512_GCB_RES_SIZE		0x0000022c
> +
> +#define VSC7512_PORT_0_RES_START	0x711e0000
> +#define VSC7512_PORT_1_RES_START	0x711f0000
> +#define VSC7512_PORT_2_RES_START	0x71200000
> +#define VSC7512_PORT_3_RES_START	0x71210000
> +#define VSC7512_PORT_4_RES_START	0x71220000
> +#define VSC7512_PORT_5_RES_START	0x71230000
> +#define VSC7512_PORT_6_RES_START	0x71240000
> +#define VSC7512_PORT_7_RES_START	0x71250000
> +#define VSC7512_PORT_8_RES_START	0x71260000
> +#define VSC7512_PORT_9_RES_START	0x71270000
> +#define VSC7512_PORT_10_RES_START	0x71280000
> +#define VSC7512_PORT_RES_SIZE		0x00010000
> =20
>  #define VSC7512_GCB_RST_SLEEP_US	100
>  #define VSC7512_GCB_RST_TIMEOUT_US	100000
> @@ -96,6 +135,34 @@ static const struct resource vsc7512_sgpio_resources[=
] =3D {
>  	DEFINE_RES_REG_NAMED(VSC7512_SIO_CTRL_RES_START, VSC7512_SIO_CTRL_RES_S=
IZE, "gcb_sio"),
>  };
> =20
> +const struct resource vsc7512_target_io_res[TARGET_MAX] =3D {
> +	[ANA] =3D DEFINE_RES_REG_NAMED(VSC7512_ANA_RES_START, VSC7512_ANA_RES_S=
IZE, "ana"),
> +	[QS] =3D DEFINE_RES_REG_NAMED(VSC7512_QS_RES_START, VSC7512_QS_RES_SIZE=
, "qs"),
> +	[QSYS] =3D DEFINE_RES_REG_NAMED(VSC7512_QSYS_RES_START, VSC7512_QSYS_RE=
S_SIZE, "qsys"),
> +	[REW] =3D DEFINE_RES_REG_NAMED(VSC7512_REW_RES_START, VSC7512_REW_RES_S=
IZE, "rew"),
> +	[SYS] =3D DEFINE_RES_REG_NAMED(VSC7512_SYS_RES_START, VSC7512_SYS_RES_S=
IZE, "sys"),
> +	[S0] =3D DEFINE_RES_REG_NAMED(VSC7512_S0_RES_START, VSC7512_S_RES_SIZE,=
 "s0"),
> +	[S1] =3D DEFINE_RES_REG_NAMED(VSC7512_S1_RES_START, VSC7512_S_RES_SIZE,=
 "s1"),
> +	[S2] =3D DEFINE_RES_REG_NAMED(VSC7512_S2_RES_START, VSC7512_S_RES_SIZE,=
 "s2"),
> +	[GCB] =3D DEFINE_RES_REG_NAMED(VSC7512_GCB_RES_START, VSC7512_GCB_RES_S=
IZE, "devcpu_gcb"),
> +	[HSIO] =3D DEFINE_RES_REG_NAMED(VSC7512_HSIO_RES_START, VSC7512_HSIO_RE=
S_SIZE, "hsio"),
> +};

EXPORT_SYMBOL is required, I believe, for when ocelot_ext is built as
module?

> +
> +const struct resource vsc7512_port_io_res[] =3D {
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_0_RES_START, VSC7512_PORT_RES_SIZE, "=
port0"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_1_RES_START, VSC7512_PORT_RES_SIZE, "=
port1"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_2_RES_START, VSC7512_PORT_RES_SIZE, "=
port2"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_3_RES_START, VSC7512_PORT_RES_SIZE, "=
port3"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_4_RES_START, VSC7512_PORT_RES_SIZE, "=
port4"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_5_RES_START, VSC7512_PORT_RES_SIZE, "=
port5"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_6_RES_START, VSC7512_PORT_RES_SIZE, "=
port6"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_7_RES_START, VSC7512_PORT_RES_SIZE, "=
port7"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_8_RES_START, VSC7512_PORT_RES_SIZE, "=
port8"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_9_RES_START, VSC7512_PORT_RES_SIZE, "=
port9"),
> +	DEFINE_RES_REG_NAMED(VSC7512_PORT_10_RES_START, VSC7512_PORT_RES_SIZE, =
"port10"),
> +	{}
> +};

Here too.

> +
>  static const struct mfd_cell vsc7512_devs[] =3D {
>  	{
>  		.name =3D "ocelot-pinctrl",
> @@ -127,7 +194,7 @@ static const struct mfd_cell vsc7512_devs[] =3D {
>  static void ocelot_core_try_add_regmap(struct device *dev,
>  				       const struct resource *res)
>  {
> -	if (dev_get_regmap(dev, res->name))
> +	if (!res->start || dev_get_regmap(dev, res->name))

I didn't understand at first what this extra condition here is for.
I don't think that adding this extra condition here is the clearest
way to deal with the sparsity of the vsc7512_target_io_res[] array, plus
it seems to indicate the masking of a more unclean code design.

I would propose an alternative below, at the caller site....

>  		return;
> =20
>  	ocelot_spi_init_regmap(dev, res);
> @@ -144,6 +211,7 @@ static void ocelot_core_try_add_regmaps(struct device=
 *dev,
> =20
>  int ocelot_core_init(struct device *dev)
>  {
> +	const struct resource *port_res;
>  	int i, ndevs;
> =20
>  	ndevs =3D ARRAY_SIZE(vsc7512_devs);
> @@ -151,6 +219,16 @@ int ocelot_core_init(struct device *dev)
>  	for (i =3D 0; i < ndevs; i++)
>  		ocelot_core_try_add_regmaps(dev, &vsc7512_devs[i]);
> =20
> +	/*
> +	 * Both the target_io_res and tbe port_io_res structs need to be refere=
nced directly by

s/tbe/the

> +	 * the ocelot_ext driver, so they can't be attached to the dev directly

I don't exactly understand the meaning of "they can't be attached to the
dev *directly*". You mean that the "struct mfd_cell vsc7512_devs[]" entry
for "mscc,vsc7512-ext-switch" will not have a "resources" property, right?
Better to say "using mfd_add_devices()" rather than "directly"?

> +	 */
> +	for (i =3D 0; i < TARGET_MAX; i++)
> +		ocelot_core_try_add_regmap(dev, &vsc7512_target_io_res[i]);

	/*
	 * vsc7512_target_io_res[] is a sparse array, skip the missing
	 * elements
	 */
	for (i =3D 0; i < TARGET_MAX; i++) {
		res =3D &vsc7512_target_io_res[i];
		if (!res->start)
			continue;

		ocelot_core_try_add_regmap(dev, res);
	}

Something interesting that I stumbled upon in Documentation/process/6.Follo=
wthrough.rst
was:

| Andrew Morton has suggested that every review comment which does not resu=
lt
| in a code change should result in an additional code comment instead; tha=
t
| can help future reviewers avoid the questions which came up the first tim=
e
| around.

so if you don't like my alternative, please at least do add a comment in
ocelot_core_try_add_regmap().

> +
> +	for (port_res =3D vsc7512_port_io_res; port_res->start; port_res++)
> +		ocelot_core_try_add_regmap(dev, port_res);
> +
>  	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs, nde=
vs, NULL, 0, NULL);
>  }
>  EXPORT_SYMBOL_NS(ocelot_core_init, MFD_OCELOT);
> diff --git a/include/linux/mfd/ocelot.h b/include/linux/mfd/ocelot.h
> index dd72073d2d4f..439ff5256cf0 100644
> --- a/include/linux/mfd/ocelot.h
> +++ b/include/linux/mfd/ocelot.h
> @@ -11,8 +11,13 @@
>  #include <linux/regmap.h>
>  #include <linux/types.h>
> =20
> +#include <soc/mscc/ocelot.h>
> +
>  struct resource;
> =20
> +extern const struct resource vsc7512_target_io_res[TARGET_MAX];
> +extern const struct resource vsc7512_port_io_res[];
> +
>  static inline struct regmap *
>  ocelot_regmap_from_resource_optional(struct platform_device *pdev,
>  				     unsigned int index,
> --=20
> 2.25.1
>

Actually I don't like this mechanism too much, if at all. I have 4 mutt
windows open right now, plus the previous mfd patch at:
https://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git/commit/?h=3Dib-=
mfd-net-pinctrl-6.0&id=3Df3e893626abeac3cdd9ba41d3395dc6c1b7d5ad6
to follow what is going on. So I'll copy some code from other places
here, to concentrate the discussion in a single place:

From patch 8/8:

> +static struct regmap *ocelot_ext_regmap_init(struct ocelot *ocelot,
> +					     struct resource *res)
> +{
> +	return dev_get_regmap(ocelot->dev->parent, res->name);
> +}

> +static const struct felix_info vsc7512_info =3D {
> +	.target_io_res			=3D vsc7512_target_io_res, // exported by drivers/mfd/=
ocelot-core.c
> +	.port_io_res			=3D vsc7512_port_io_res, // exported by drivers/mfd/ocel=
ot-core.c
> +	.init_regmap			=3D ocelot_ext_regmap_init,
> +};

From drivers/net/dsa/felix.c:

static int felix_init_structs(struct felix *felix, int num_phys_ports)
{
	for (i =3D 0; i < TARGET_MAX; i++) {
		struct regmap *target;

		if (!felix->info->target_io_res[i].name)
			continue;

		memcpy(&res, &felix->info->target_io_res[i], sizeof(res));
		res.flags =3D IORESOURCE_MEM;
		res.start +=3D felix->switch_base;
		res.end +=3D felix->switch_base;

		target =3D felix->info->init_regmap(ocelot, &res);
		if (IS_ERR(target)) {
			dev_err(ocelot->dev,
				"Failed to map device memory space\n");
			kfree(port_phy_modes);
			return PTR_ERR(target);
		}

		ocelot->targets[i] =3D target;
	}
}

So here's what I don't like. You export the resources from ocelot-mfd to
DSA, to get just their *string* names. Then you let the common code
create some bogus res.start and res.end in felix_init_structs(), which
you discard in felix->info->init_regmap() - ocelot_ext_regmap_init(),
and use just the name. You even discard the IORESOURCE_MEM flag, because
what you get back are IORESOURCE_REG resources. This is all very confusing.

So you need to retrieve a regmap for each ocelot target that you can.
Why don't you make it, via mfd_add_devices() and the "resources" array
of struct mfd_cell (i.e. the same mechanism as for every other peripheral),
such that the resources used by the DSA device have an index determined
by i =3D 0; i < TARGET_MAX; i++; platform_get_resource(dev, i, IORESOURCE_R=
EG)?
This way, DSA needs to know no more than the index of the resource it
asks for.

[ yes, you'll need to revert your own commit 242bd0c10bbd ("net: dsa:
  ocelot: felix: add interface for custom regmaps"), which I asked you
  about if you're sure if this is the final way in which DSA will get
  its regmaps. Then you'll need to provide a different felix->info
  operation, such as felix->info->regmap_from_mfd() or something, where
  just the index is provided. If that isn't provided by the switch, we
  "fall back" to the code that exists right now, which, when reverted,
  does create an actual resource, and directly calls ocelot_regmap_init()
  on it, to create an MMIO regmap from it ]=
