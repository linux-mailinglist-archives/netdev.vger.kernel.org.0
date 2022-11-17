Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148B862E041
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 16:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239738AbiKQPqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 10:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239679AbiKQPqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 10:46:17 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A997616C;
        Thu, 17 Nov 2022 07:46:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8UHU6RI1ym+7N2tLIfE+ec44uRwGAnDX8d3B4ujh9WruCI7NkrTPzRAFDD2fcho37V3DpHpFWrzajp8QjyeUeTWuR2xyHZ3FiYOXqqux+LMaQdiYPLQ46kE2qdeqb3HiV3v9qRL4rD8hxhRARkfXdGKsnhvawaAL0EzAkevfGgG0cUhU53dG3Ew/AoCfSbCosQtJIdTmagJ+466PB76obU7S6JX4vaWABhm4b/XTO+PN03GNywRIL1IunvbJx8G76FVNF2lTszglfWwlsTORRYm4NwW0P8eVp3lGaRSWURHrfyIiRATE1uOIvPev2ubPfZ6E2aVoMY9uVmArbAGiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=egU7Ba1J27tnJsQpoQcccUij53PGcNmxpOqLDO+LQxo=;
 b=W43DTQIORo5NN98zlaEKrVvB4PyWeN/ToVY9E1/Q9SY00KLm7Uecv5D4yygvj2vir5jY8lsctd28nfdD/FlwxIo6fy/uo8/o45exntDROBgGfkk8Ix1rv971jD8ctGQqo3t6UDQ4r8PNknF2Ga/Ln/xPvqehdVGqDBu9/tk152UmGTUx798xmIYscuUQu9iRYmBxUA+Zvw0wXPgnmKOa7TgKYv26iWdOYciGBYT9SXHGrbJATy2KqwLGdQiZGzIGtBMjGOv80pNYeZgCErIPp1zcg7XpiaHJ5jPy5b95lbfqV82xxi5xpEaWOYaz+wCNSrWUPmy93HBukW+gmdwf+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egU7Ba1J27tnJsQpoQcccUij53PGcNmxpOqLDO+LQxo=;
 b=tLKJMAbn68CCEYD9gWoClnmYxdi3RBh/nGAOzdwmtnqR0Jz88JlJ1UZD+njJDOsuD7AecH+ttDzI8/5WM7djGFreJ4r7n35hyJ8PBiRrErDG45CHuxvmaed9oDKalvLYiUuLIe/8545y2ESugKfrJFvjV1gn0GvD2z+Z80QMU8k=
Received: from MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15)
 by CH0PR12MB5266.namprd12.prod.outlook.com (2603:10b6:610:d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Thu, 17 Nov
 2022 15:46:13 +0000
Received: from MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::d6f4:81b:8a69:5b05]) by MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::d6f4:81b:8a69:5b05%3]) with mapi id 15.20.5813.019; Thu, 17 Nov 2022
 15:46:12 +0000
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
Subject: RE: [PATCH v5 net-next 3/3] net: axienet: set mdio clock according to
 bus-frequency
Thread-Topic: [PATCH v5 net-next 3/3] net: axienet: set mdio clock according
 to bus-frequency
Thread-Index: AQHY+pr72wz7G9WmaEql3juQeu6NJK5DQd+A
Date:   Thu, 17 Nov 2022 15:46:12 +0000
Message-ID: <MN0PR12MB5953A3D424C01EF52F9D81F3B7069@MN0PR12MB5953.namprd12.prod.outlook.com>
References: <20221117154014.1418834-1-andy.chiu@sifive.com>
 <20221117154014.1418834-4-andy.chiu@sifive.com>
In-Reply-To: <20221117154014.1418834-4-andy.chiu@sifive.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB5953:EE_|CH0PR12MB5266:EE_
x-ms-office365-filtering-correlation-id: 3a61f6fd-415c-4c61-9605-08dac8b2dae5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +nQywGlyTT5TOuKCoeTT9BZWPDhdSJo75xS+mv2pHZ0wx62oqb9w/kPsv/rY4klvmUFBYm3807I0HyDN7fOX+VcXCk2txEswMgM6GifRRCXlQBFt5lfWkncL+Z+9ryKzcCWOXAaFlDONS6+r+em8frqUqlky55cxYR1rtxlCZ9w4YiIGsqH9ZIkBzjqoupfE9IckjSaqVglkpCq+M9jr8pM+gDswyq/XU0cV9lfva/tCNl90jAOV1IOTlBtjRJCE+v8+iyWiLscBnB8bRkStfe6zP4SwGBBB9R74D9lZ9oWTH5KYPQ+CPjQkEHudsGStn1dYYDOX2K/F1hLfoZZIO1mv8ExXQVgJCEatFr2JFr4tRrE3RuK4DZLjFQFHnVW48uXCwaK79llciQ8j4U3o9xPKCORit3KyJHVcOveQXiF8SB8YBjGC2y0rHH5b/aScKhIbcfSjrfNYeuo+LCc/gnGi36gUVOiDUePbKeQ7Hu/BUXR0s8RMghHqjy4DY+wzdzaw9n2vM59AC4y7HhB06wjqr8bhWZalA2eyy6Klj8526K6O7fG5DlLNmt0+Ie5SBkvSb6cNUmLmpAlrUjjiwCLoiaV4Rlp5GMsHMp1ZvUbbtwCXSKjAtvhCZN0FrUPHvrqEgRDAqMCFGfCDxDPf6aIHcBHnspF1PBhrUoGmwYaPm8bYNmvOCW5Fod+KI3DPwcv9jdKSc1GQMai+o9sCLg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5953.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199015)(478600001)(71200400001)(41300700001)(8936002)(66946007)(4326008)(66476007)(66446008)(76116006)(66556008)(8676002)(52536014)(9686003)(7416002)(33656002)(54906003)(5660300002)(186003)(6506007)(7696005)(110136005)(316002)(64756008)(53546011)(83380400001)(2906002)(86362001)(55016003)(122000001)(38070700005)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3D6WIfcI7zJXPLK8XUR2xaIC2mXcv28+KJEe407ZWqCgiDPoTnJWgtQ6WmCi?=
 =?us-ascii?Q?KIBp734keQ3ZrSHsosIlwYWQ3pVz2I3gpjz3VnJUBkvEsGhqZkmVow7A7Ws5?=
 =?us-ascii?Q?BNTO4l5AWSQI+OAmKWtWHrOH6qt5dXOiseJCsOXeOWqx0ivEjGPVcpfderd/?=
 =?us-ascii?Q?TWMu0IZavIX0Oqny8oT85tIR5giBWIKH6ABl1mpbg2wo+ss2X3uuPESSGjGo?=
 =?us-ascii?Q?mtsFIZnRVh7Z+EIlYH2gSBR6QfDaMLpEHmoU+V9dAITsPbqUzZKjEOUW7O9u?=
 =?us-ascii?Q?zwkHPRt7/eHqlIKllox34C+F02PqG9y5nAeQwp9tn1yIq9yrrtBk5yoOyTOa?=
 =?us-ascii?Q?vqIHToS/NAOGrvZ2QiSv4+z/UxuyIn7gF/fxRfelINT63YjCvapDIazm1qaa?=
 =?us-ascii?Q?W2tQTzLaGuyi94AXCUrXqkN64NFIZyagPCTjbitxXKdr3YDBP7em6d9svVQA?=
 =?us-ascii?Q?7pCNKCMeEBwT12H5yae9GJgwyBp08RBEScF5wlnaegb6L2CSCKBSoT2PBl/c?=
 =?us-ascii?Q?J0geDmSFIjF/5NWKZruq+sWIbuUJp/XGw+1rnpuRSiaZ0xjslRToZ87z2k5p?=
 =?us-ascii?Q?B4c5w7sb8apmF4Rc3le6bkdS0LvpyDB4kBGJN7P03CPAQwr9vfOfEDrO9jic?=
 =?us-ascii?Q?/DPYlGN1oxbws102JMJstH2j4uHq/32Myh0LsZtonU2I3bQfyziFZVR0UrQQ?=
 =?us-ascii?Q?uCnh1LFK61EuUPwBm5MdSpjaaxrbyU7ZCUSU2jVvgvD33W9OMfMErt52mJa2?=
 =?us-ascii?Q?HSbArzmkLSbvZFjMMC6zNYW1isPzgnAeSXsJF93OXnhEAnf2Ee+8iqOINx0u?=
 =?us-ascii?Q?vTMkM+ie9a/36O/oBGJb1qE0LA2vQC1LgYk8VJQCrrVCM1Eifp9x9yjI4eX0?=
 =?us-ascii?Q?LjuduIrKclI8XNYUktBH5yDnyhq86N/hRETRPSuaYla7H9Xoy1vPO+6e6RAa?=
 =?us-ascii?Q?2K33ldzpl+j08sNJIlgaNAShsxUm75+UtvOeIdNKbltEe2bwjY0ABf6/SMud?=
 =?us-ascii?Q?R4Q1sB6Z221w58UW+vSgNyhMlZGFC19rzGE/+3g8n9lVgAsYOZwgeE6TKWxJ?=
 =?us-ascii?Q?f/FmR0vGJyD3vqk+3Q6NY3c7DBY0c4sfoKggNMH3ZLDkZFN+D4xepfv80Ruv?=
 =?us-ascii?Q?E0cPGIoeTzPpmAmHuQJotxF/WMEj4f8T6e2AW+gxbbXcqKP9lTDGar/GaX/Y?=
 =?us-ascii?Q?GpP4X1/BJzyoPGSR21pDYlT3sczBLOELs+6/hYzxAiusCxOuM5dFjsgyuA8q?=
 =?us-ascii?Q?gBGtn0CLNPyQYI6y/9eKVK1o0MDUK9RtyA5319Qi2RErJ1HDsStu/pEuqxut?=
 =?us-ascii?Q?YZJM8BpZiNMjXVCeIB5Ee871YMyc230BegRBLE0b92mqMwLdG2SijRdvYeoV?=
 =?us-ascii?Q?HHS8XzUiFxU/Lbe/HrKDf/LlM4zPIhsK/arJN1vzS8wnrfgRWqHEHDB0Pp2F?=
 =?us-ascii?Q?8Q0ydn6PgXTO/jjIcv60RevfivW9R1VRDt4MDgKD4JCSlSlIP2HC25S9TWmi?=
 =?us-ascii?Q?2cprmzYgXII6YUpAbhy0q8fjKfmG5woLO0EHzkmlaq7BotZmolGX9GNGcL7s?=
 =?us-ascii?Q?LRT1bIYgQYwyh6mlvxN0gSlIy7KaEF44jxU4Yfh4TwRn3NCnTqH4IS/gD0wv?=
 =?us-ascii?Q?swDkxxB+xkWhTBPe+9pgiu0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5953.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a61f6fd-415c-4c61-9605-08dac8b2dae5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2022 15:46:12.8247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ie8vMIRQTWSorVjnyUU0iOoPHrtGrQxjCfy/h3TmPWuTq2TMn80kRkbqQRkESvLK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5266
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
> Sent: Thursday, November 17, 2022 9:10 PM
> To: davem@davemloft.net; andrew@lunn.ch; kuba@kernel.org;
> michal.simek@xilinx.com; radhey.shyam.pandey@xilinx.com
> Cc: netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; robh+dt@kernel.org; pabeni@redhat.com;
> edumazet@google.com; andy.chiu@sifive.com; greentime.hu@sifive.com
> Subject: [PATCH v5 net-next 3/3] net: axienet: set mdio clock according t=
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
> support it. And properly disable the mdio bus clock in error path.
>=20
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---
>  .../net/ethernet/xilinx/xilinx_axienet_mdio.c | 70 +++++++++++++------
>  1 file changed, 49 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
> index e1f51a071888..2f07fde361aa 100644
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
> 147,15 +147,20 @@ static int axienet_mdio_write(struct mii_bus *bus, int
> phy_id, int reg,
>  /**
>   * axienet_mdio_enable - MDIO hardware setup function
>   * @lp:                Pointer to axienet local data structure.
> + * @np:                Pointer to mdio device tree node.
>   *
> - * Return:     0 on success, -ETIMEDOUT on a timeout.
> + * Return:     0 on success, -ETIMEDOUT on a timeout, -EOVERFLOW on a
> clock
> + *             divisor overflow.
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
> +       int ret;
>=20
>         lp->mii_clk_div =3D 0;
>=20
> @@ -184,6 +189,12 @@ static int axienet_mdio_enable(struct axienet_local
> *lp)
>                             host_clock);
>         }
>=20
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
> @@ -209,29 +220,42 @@ static int axienet_mdio_enable(struct axienet_local
> *lp)
>          * "clock-frequency" from the CPU
>          */
>=20
> -       lp->mii_clk_div =3D (host_clock / (MAX_MDIO_FREQ * 2)) - 1;
> +       clk_div =3D (host_clock / (mdio_freq * 2)) - 1;
>         /* If there is any remainder from the division of
> -        * fHOST / (MAX_MDIO_FREQ * 2), then we need to add
> -        * 1 to the clock divisor or we will surely be above 2.5 MHz
> +        * fHOST / (mdio_freq * 2), then we need to add
> +        * 1 to the clock divisor or we will surely be
> +        * above the requested frequency
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
,
>                    lp->mii_clk_div, host_clock);
>=20
> -       axienet_iow(lp, XAE_MDIO_MC_OFFSET, lp->mii_clk_div |
> XAE_MDIO_MC_MDIOEN_MASK);
> +       axienet_mdio_mdc_enable(lp);
>=20
> -       return axienet_mdio_wait_until_ready(lp);
> +       ret =3D axienet_mdio_wait_until_ready(lp);
> +       if (ret)
> +               axienet_mdio_mdc_disable(lp);
> +
> +       return ret;
>  }
>=20
>  /**
>   * axienet_mdio_setup - MDIO setup function
>   * @lp:                Pointer to axienet local data structure.
>   *
> - * Return:     0 on success, -ETIMEDOUT on a timeout, -ENOMEM when
> - *             mdiobus_alloc (to allocate memory for mii bus structure) =
fails.
> + * Return:     0 on success, -ETIMEDOUT on a timeout, -EOVERFLOW on a
> clock
> + *             divisor overflow, -ENOMEM when mdiobus_alloc (to allocate
> + *             memory for mii bus structure) fails.
>   *
>   * Sets up the MDIO interface by initializing the MDIO clock.
>   * Register the MDIO interface.
> @@ -242,10 +266,6 @@ int axienet_mdio_setup(struct axienet_local *lp)
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
> @@ -261,15 +281,23 @@ int axienet_mdio_setup(struct axienet_local *lp)
>         lp->mii_bus =3D bus;
>=20
>         mdio_node =3D of_get_child_by_name(lp->dev->of_node, "mdio");
> +       ret =3D axienet_mdio_enable(lp, mdio_node);
> +       if (ret < 0)
> +               goto unregister;
>         ret =3D of_mdiobus_register(bus, mdio_node);
> +       if (ret)
> +               goto unregister_mdio_enabled;
>         of_node_put(mdio_node);
> -       if (ret) {
> -               mdiobus_free(bus);
> -               lp->mii_bus =3D NULL;
> -               return ret;
> -       }
>         axienet_mdio_mdc_disable(lp);
>         return 0;
> +
> +unregister_mdio_enabled:
> +       axienet_mdio_mdc_disable(lp);
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

Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
