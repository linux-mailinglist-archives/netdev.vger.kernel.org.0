Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECFEF62D334
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 07:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbiKQGHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 01:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239348AbiKQGG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 01:06:59 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2075.outbound.protection.outlook.com [40.107.95.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A2127CED;
        Wed, 16 Nov 2022 22:06:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UsX33gdtw9tFhPx9H/VCLLpugUxeau/rNqLb6C5V8xzJpIrBdEzGLYoCMzJeFXKrHscNbZg6DAuWJjvScvY9ETvg5GMPNJYp3776mMbauEwp9WvUpjLQUE51M+zwWVtWOTCjYHSVAZvgkt1SBlZmAyaf1ARf9JWMR0ho517yJbIdQVrQ083NaCKI5WvpjK/1gj1Yfwxjpw2eBVORHJhz0hIujGP25V8dJfVoE+pXM3yTIUHR5z8s0tqo0xLjc77btg6rX6uB0WymwqF0FhPfDlSOFEk1tctDtbwaQ2Ldm9FtXyZ2GeAvN13s9paH1qOE5avF5SA5QeVpFPC6yiRAiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1bpr23Rr8FDTW5Fo10Q/xz7A6SxH3xoxTtne/3HC0Zo=;
 b=Lg80KhXgR86QGZgfHFJv7Y1rN9eaJab0V42GyXqYWwO3AVZDBPOCPf9BE6Dsigx+VNmEP16zd7RfleEU10y91eke5KZRwLCBctMySFb2E0CgdTAFaEK3JvtTcFUvj5CxPfg4hnLPCc5b10tbJ/bGyTi1mHVJfDnqhJkkNPsSTNefwZtVpMwsDM3bHOCOOsYIrNT9mdKx2DQqUDzrQ+PwzVnreWgsbQAl39Fr7z+kz1cRpHOiKcQ5rollOuEOred9jYtDWZyjNT4Wv+ChWYMWyQmZq7TK1KCnHBXhnlNq1I5dEgOtHfxWXfBtW9i+moTh2u0Glt3jV0Frz0+gBtroPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1bpr23Rr8FDTW5Fo10Q/xz7A6SxH3xoxTtne/3HC0Zo=;
 b=f+YpgWYfG8b4h/RMW1EluP+KA4qpI+I8Pm+eq58OENU1MIt1kP/dvG4zduuBOknYQ6rg29VSaTLf2iJXsD9X8w5hNYJrb6lI+5vvlOJ2UpngQRBl92NDMyOPvgUIPtKRHA1UYkv5eXHfLeVHngr6UbZR4XRVd4uQRhbitc484XU=
Received: from MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15)
 by MN2PR12MB4240.namprd12.prod.outlook.com (2603:10b6:208:1d3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 17 Nov
 2022 06:06:55 +0000
Received: from MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::d6f4:81b:8a69:5b05]) by MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::d6f4:81b:8a69:5b05%3]) with mapi id 15.20.5813.019; Thu, 17 Nov 2022
 06:06:55 +0000
From:   "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
To:     Andy Chiu <andy.chiu@sifive.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "greentime.hu@sifive.com" <greentime.hu@sifive.com>
Subject: RE: [PATCH v4 net-next 2/3] net: axienet: set mdio clock according to
 bus-frequency
Thread-Topic: [PATCH v4 net-next 2/3] net: axienet: set mdio clock according
 to bus-frequency
Thread-Index: AQHY+jdroIC4G3FqZ0e/QxEBX/9LYa5CluXg
Date:   Thu, 17 Nov 2022 06:06:55 +0000
Message-ID: <MN0PR12MB5953F212091C214E13FE45D1B7069@MN0PR12MB5953.namprd12.prod.outlook.com>
References: <20221117034751.1347105-1-andy.chiu@sifive.com>
 <20221117034751.1347105-3-andy.chiu@sifive.com>
In-Reply-To: <20221117034751.1347105-3-andy.chiu@sifive.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB5953:EE_|MN2PR12MB4240:EE_
x-ms-office365-filtering-correlation-id: 56145ccf-be92-4499-7847-08dac861eddc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VN9BACqU2ATphr/ohmzcmXYH1zmZTFoss6KGzxxCxVweb7YR9QMu12TmlbsSiH5d5q8MzAf9W1c0vkjfRp+qvAAFPoxvaSfLjcyP9WYjKgr0bDB3M9F2dIgbSZrlU4SmfE9f66vfQ/0CNNoAIuc2DVrasJyIWlN3hsiZZOZunWhKAb2eqR4OXqNv/1z80Uj3amtIzISCb6ZvrMB6duiuMxu1kZrcYriqtPIVTwHZ0vGAhhtJaeCKt65K4YFoD+NxYW1Mu4Uiq7lIq/9xpPbpNhmT1Prx03JlZsxn1rKZzIm7ymAHD9JBbOuoYQyi5fh/gPtE7fth833M2dECMSrXznlMaYRDhODjFm4ZzPMtvz6+Yv/Evo3zEwEesXTWnlsR+nOud0WLQGPqsRy8QCQyqGzSGGd4nEiaJ3iSZrYcbVU3qvqVppS8OlwcFAcr1A4uvaOSOWHl3T1MaUieMyBqevODtLZYGjBUpCA2wwZRsTNnnDnR5tKdt1Ykrsxt6x0RYHO1Is2mDkvHd0/PxhGZJYlhrWNbKx2KJb/vJRoeRpaT4+hpQfv9PpAwydRIs5yMC9uqWtCyO29yWTbwz9Yq3ykuaO0WCgevHeUEPPI6LY5zNUDwobfDP6EK/O18gdF6P5G3qF8MozQYIP8rktR5kjVTIVKTctMGJFrpXoJutj7vcZyue9rl/5EaPTs8CeU95PGSC1kQWa4DyWYQoXRGqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5953.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199015)(71200400001)(478600001)(38070700005)(54906003)(110136005)(122000001)(6506007)(2906002)(9686003)(7696005)(64756008)(41300700001)(86362001)(8676002)(4326008)(38100700002)(66476007)(66556008)(66446008)(316002)(53546011)(76116006)(186003)(66946007)(7416002)(8936002)(52536014)(55016003)(5660300002)(33656002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?g6sj+LyVKJs8zgsWgzosr2vAAGth4dfhgcMj3qdXmDAGOPDVnHmGsRJiRtx1?=
 =?us-ascii?Q?gau1nYoLfVx9Mv/dytV0GMOe1Qy2AYpfOHTidcIFvp2XDvZwqP6NPA+0muYU?=
 =?us-ascii?Q?u9vxsAIiRe8K9XoD1auiupv8VRKLjBlZRmHI3IkPHazr2JNX2o+SsmKjQehY?=
 =?us-ascii?Q?QPGX4h72Cj7SKi4XhKZ2JSMhv+RQ2HdL+oLJuoDndBBIWG0LjtxwjlQlM9+1?=
 =?us-ascii?Q?QbiorZooDVsPIsJJa8ZKfvvM0VGg0fwYMgzB7Mzu/+i4XZNj6wIj0O/yLo23?=
 =?us-ascii?Q?UtFOnostyPScjCQIKHZvHy3MDbJhQ+t5MajyMErNXZzkSDLD4Iz7NMZ9i+LW?=
 =?us-ascii?Q?aZ7RuDyp4VwNxUR1dMPo7TLFfSLZhJVNF9TQ37C/MYx42FZZfWmZkuO2/RO4?=
 =?us-ascii?Q?ZQKh7ODwKWcbC30UcaOSET7VNyCXKIDMxA7d295g1LMHGAwHPkmcYZ5KaipT?=
 =?us-ascii?Q?GD4K/VlXYZUgfbwYYFnlyn5t9yEmwdZ1Fg7B4z3ZRN7jc7QMmSnyr5v8qHpO?=
 =?us-ascii?Q?ag5xci9XYPBp/swj8NFq5HjOLkZSPzeDTG+VJyy4E3nNGzzx6YIpMVTgiW9U?=
 =?us-ascii?Q?jWcxt+ucpKvDlcNloTVWicuyZtwn0zXnXzN6of067Bgqe/EuIUq6IxSWZf+q?=
 =?us-ascii?Q?qJ/d/diI1Qp+v10Mgv9OdKILaaLr1SwdFJPklzcZum7fXZ/j5iGa5rqTRhp/?=
 =?us-ascii?Q?ArtEcaK0vLeF9T8XSOJLfEQOU31Xg1wgVE2KgfEymsDeYEKusL9yBspGwA99?=
 =?us-ascii?Q?VaEF9zo9utHourDt1g+BZtTlmRHBv6Jm+WmCss70shCHjjJ15koCb35+7fi+?=
 =?us-ascii?Q?Zne8N/TmyYvLHxCRrO5OCwhTk2nW+dwunkUZJ5sktlvC/M6w2q/eoKshgdY2?=
 =?us-ascii?Q?pGVlTYppgDnfm2Yrs3HNL+GmmrciV/alcdB/LGBJsqB+3T3m4JNDXaNliGQG?=
 =?us-ascii?Q?RQcBlBZDwAnCXyRgBRKeIMV7iiYVAa1z8t0I9MC0FsxQ5ACjQ3ebqH8MWGop?=
 =?us-ascii?Q?Va18MHQ29+dWGvW13mG2AGsmX3PUHTlbv5EsILEAw6Itain0zn8D7fWEYUoV?=
 =?us-ascii?Q?oVzRfmAuVEnidKn2y0SFBtPOnigSD4RHXLTXyu5YmOLL2JRpj1mWxhacJuoV?=
 =?us-ascii?Q?zJnqCHtAX1VukIPcFEOSumQ8fTqxWNhgsnG+epNa2/xBxiijK18hkNF0tTVJ?=
 =?us-ascii?Q?FwaurgxWOJqjVEt4+kD9OqEChTTNGm+Ob8lU/miciNIiew5Rzbi3MT2pjGkY?=
 =?us-ascii?Q?XwJr9vGwDApvaHECzlDjpmEDBYwYM8LUu7Poztdww7+rg1a9YL3ygul2utZf?=
 =?us-ascii?Q?J4VQHYAZLf5ZLcwRBCbzJxsWQ3OI2iE9MCtR02zV+jbxxhlvqK/QkDJ1it5r?=
 =?us-ascii?Q?KIyIb+zeUnlMzwkBJT61JCyi6OrGHm9xvPZTPx+0bHibZUXJUfrwKM8qfNO3?=
 =?us-ascii?Q?FYjphTLnfNlmQ0W2d7M6T3RbPKHIB0eJoNCn2mQ/ykoEfZYmpsP8dnnoYcUj?=
 =?us-ascii?Q?me4dr8jt81B4ZqeWO9z7o/SykprbkvN+DpnM/1NPyPIlS+JabNWuxkeUYKfm?=
 =?us-ascii?Q?BsrmfExtdvAgy2E8LEcyyXeDew8Cd5bdNpRe+Cx+zjZqeBuJdvtVUvDoTcRV?=
 =?us-ascii?Q?buPfq0w+B7B5Ht6R/Eu0WgQqQpH9+Ws83/7OfR8RBTwM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5953.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56145ccf-be92-4499-7847-08dac861eddc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2022 06:06:55.3909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FPWv5Mmp+6WlBpTd4ILmza0NWE6qlF07QW4rDVMiN+gxQxH4rg6mD5KsJn8eyFuX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4240
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
> From: Andy Chiu <andy.chiu@sifive.com>
> Sent: Thursday, November 17, 2022 9:18 AM
> To: davem@davemloft.net; andrew@lunn.ch; kuba@kernel.org;
> michal.simek@xilinx.com; radhey.shyam.pandey@xilinx.com
> Cc: netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; robh+dt@kernel.org; pabeni@redhat.com;
> edumazet@google.com; andy.chiu@sifive.com; greentime.hu@sifive.com
> Subject: [PATCH v4 net-next 2/3] net: axienet: set mdio clock according t=
o
> bus-frequency
>=20
> CAUTION: This message has originated from an External Source. Please use
> proper judgment and caution when opening attachments, clicking links, or
> responding to this email.
>=20
>=20
> Some FPGA platforms have 80KHz MDIO bus frequency constraint when
> connecting Ethernet to its on-board external Marvell PHY. Thus, we may ha=
ve
> to set MDIO clock according to the DT. Otherwise, use the default
> 2.5 MHz, as specified by 802.3, if the entry is not present.
>=20
> Also, change MAX_MDIO_FREQ to DEFAULT_MDIO_FREQ because we may
> actually set MDIO bus frequency higher than 2.5MHz if undelying devices
> support it.
>=20
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  .../net/ethernet/xilinx/xilinx_axienet_mdio.c | 48 +++++++++++++------
>  1 file changed, 33 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
> index e1f51a071888..789a90997f4b 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
> @@ -17,7 +17,7 @@
>=20
>  #include "xilinx_axienet.h"
>=20
> -#define MAX_MDIO_FREQ          2500000 /* 2.5 MHz */
> +#define DEFAULT_MDIO_FREQ      2500000 /* 2.5 MHz */
>  #define DEFAULT_HOST_CLOCK     150000000 /* 150 MHz */
>=20
>  /* Wait till MDIO interface is ready to accept a new transaction.*/ @@ -
> 147,15 +147,18 @@ static int axienet_mdio_write(struct mii_bus *bus, int
> phy_id, int reg,
>  /**
>   * axienet_mdio_enable - MDIO hardware setup function
>   * @lp:                Pointer to axienet local data structure.
> + * @np:                Pointer to mdio device tree node.
>   *
>   * Return:     0 on success, -ETIMEDOUT on a timeout.

We are now also returning -EOVERFLOW. Please update the description.

>   *
>   * Sets up the MDIO interface by initializing the MDIO clock and enablin=
g the
>   * MDIO interface in hardware.
>   **/
> -static int axienet_mdio_enable(struct axienet_local *lp)
> +static int axienet_mdio_enable(struct axienet_local *lp, struct
> +device_node *np)
>  {
> +       u32 mdio_freq =3D DEFAULT_MDIO_FREQ;
>         u32 host_clock;
> +       u32 clk_div;
>=20
>         lp->mii_clk_div =3D 0;
>=20
> @@ -184,6 +187,12 @@ static int axienet_mdio_enable(struct axienet_local
> *lp)
>                             host_clock);
>         }
>=20
Binding 3/3 patch should be before this patch.=20

> +       if (np)
> +               of_property_read_u32(np, "clock-frequency", &mdio_freq);
> +       if (mdio_freq !=3D DEFAULT_MDIO_FREQ)
> +               netdev_info(lp->ndev, "Setting non-standard mdio bus freq=
uency
> to %u Hz\n",
> +                           mdio_freq);
> +
>         /* clk_div can be calculated by deriving it from the equation:
>          * fMDIO =3D fHOST / ((1 + clk_div) * 2)
>          *
> @@ -209,13 +218,20 @@ static int axienet_mdio_enable(struct axienet_local
> *lp)
>          * "clock-frequency" from the CPU
>          */
>=20
> -       lp->mii_clk_div =3D (host_clock / (MAX_MDIO_FREQ * 2)) - 1;
> +       clk_div =3D (host_clock / (mdio_freq * 2)) - 1;
>         /* If there is any remainder from the division of
> -        * fHOST / (MAX_MDIO_FREQ * 2), then we need to add
> +        * fHOST / (mdio_freq * 2), then we need to add
>          * 1 to the clock divisor or we will surely be above 2.5 MHz
>          */
> -       if (host_clock % (MAX_MDIO_FREQ * 2))
> -               lp->mii_clk_div++;
> +       if (host_clock % (mdio_freq * 2))
> +               clk_div++;
> +
> +       /* Check for overflow of mii_clk_div */
> +       if (clk_div & ~XAE_MDIO_MC_CLOCK_DIVIDE_MAX) {
> +               netdev_warn(lp->ndev, "MDIO clock divisor overflow\n");
> +               return -EOVERFLOW;
> +       }
> +       lp->mii_clk_div =3D (u8)clk_div;
>=20
>         netdev_dbg(lp->ndev,
>                    "Setting MDIO clock divisor to %u/%u Hz host clock.\n"=
, @@ -
> 242,10 +258,6 @@ int axienet_mdio_setup(struct axienet_local *lp)
>         struct mii_bus *bus;
>         int ret;
>=20
> -       ret =3D axienet_mdio_enable(lp);
> -       if (ret < 0)
> -               return ret;
> -
>         bus =3D mdiobus_alloc();
>         if (!bus)
>                 return -ENOMEM;
> @@ -261,15 +273,21 @@ int axienet_mdio_setup(struct axienet_local *lp)
>         lp->mii_bus =3D bus;
>=20
>         mdio_node =3D of_get_child_by_name(lp->dev->of_node, "mdio");
> +       ret =3D axienet_mdio_enable(lp, mdio_node);
> +       if (ret < 0)
> +               goto unregister;
>         ret =3D of_mdiobus_register(bus, mdio_node);
> +       if (ret)
> +               goto unregister;

Missing axienet_mdio_mdc_disable in error path.=20

Also return documentation of axienet_mdio_setup needs a update.

>         of_node_put(mdio_node);
> -       if (ret) {
> -               mdiobus_free(bus);
> -               lp->mii_bus =3D NULL;
> -               return ret;
> -       }
>         axienet_mdio_mdc_disable(lp);
>         return 0;
> +
> +unregister:
> +       of_node_put(mdio_node);
> +       mdiobus_free(bus);
> +       lp->mii_bus =3D NULL;
> +       return ret;
>  }
>=20
>  /**
> --
> 2.36.0

