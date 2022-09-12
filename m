Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51945B58E4
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 12:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiILK6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 06:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiILK6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 06:58:17 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2129.outbound.protection.outlook.com [40.107.113.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F592371A7;
        Mon, 12 Sep 2022 03:58:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dxl5n1L4LoxTwfBk0v2DNllaLuCyXI6xG5NeCDtK0OO3Qtl/0dpATSYDXU74MOQFqauIa6HqszZrrBS8oxuPinWsYOL23WZit4sCwaKuiukwEB8jBX0UHllzldSYMT06kpp6doTY/FYUn4d3b6Dwvvagvy15uHlIMlLtaNWcQYqYZWIPFfq7oVxb13cvuu/dEwferpnQX0cP9osDEJ0uMQ94TMuGpOlmLzJuMUZBtwuf0nL+cM71ee+VZ0VGB1BhUR4FmgUyZLQMpELKmOaCBTAtKuC87IkK8lYUuY0EpJDSfyzFjGEIkQLZTflppf/AxBmEvRZF57fCcI23aYH5KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v0AorKJclf23iSsyXUgilBkUnfC/kbejnOa1ZhBb+C0=;
 b=jcfGDpSWs2O9tXkNHFRDwls3NegH1kxzcOFCWM0pKPJ5ZIsipljWk3TmIfWWzP+aLXtbmMye2nYEw3nFw5v+h9zQs54lLmUipu1UbTv+eB1JxzoRHrApjGZ4guVq6bHbxXw15oBDWb/VqXIO/vKx6y7uPTlUZ9w2x4ldi8Kfjencl2RTOePuLdNyHQfssp+MTzjNsfiTvXwi9CPWSv+rVzqBcyntPV0j0d6Xa8TASfDSOpni8b8EF4JRtjey4oHPxb3cLBShf8Ju+bDsobRIeVutPXEfGmoHzKGOMIT9WdM7fsZvIhbZsNv7JPFxqraPSCRLBAeJhjSbBz0BJ4Pq2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0AorKJclf23iSsyXUgilBkUnfC/kbejnOa1ZhBb+C0=;
 b=P075PzXSY8gQuqdAF0H5csH9mI9LBNFDz5VHXIiI4F0qaRSNULsDTIar8wwqlGHz01zUcde8S//c7ceK19afQ7xyK7UXW73oc9BspRsvAkFETLVpM8x7Z429LENViFQUCp1payu0m3xLK0IPAuVGww7HYrnntMUV0Vrij58Zvic=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB5605.jpnprd01.prod.outlook.com (2603:1096:604:b5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Mon, 12 Sep
 2022 10:58:13 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c502:8f9f:ec5e:8e3f]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c502:8f9f:ec5e:8e3f%3]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 10:58:13 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH net-next] ravb: Add RZ/G2L MII interface support
Thread-Topic: [PATCH net-next] ravb: Add RZ/G2L MII interface support
Thread-Index: AQHYxpTxQ2A1OLplG0eNb3w7SI4izK3bn1zw
Date:   Mon, 12 Sep 2022 10:58:12 +0000
Message-ID: <OS0PR01MB5922C8A877A752596D767B9B86449@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220912104634.302264-1-biju.das.jz@bp.renesas.com>
In-Reply-To: <20220912104634.302264-1-biju.das.jz@bp.renesas.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OS3PR01MB5605:EE_
x-ms-office365-filtering-correlation-id: 3edfadd7-cb32-4c6f-97a3-08da94adb007
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s169JO1JAghljokjd3GNnMBIWjONuAJWlAludMYvuyMWw7bLqg16IOGXpWj4ULD8sGVdRBNK8UAteqmbF+MWpoDdewHKHI6V5OJt8w4a7lufqfQpRQXNBC4wPn6bX+x+jUcietwV82g9LIncCmdbVRDKue366RCpfffnJnfS93ipceQiHBMpdkT3U7Hm5I/UPyaNPFF7nVQfIMzZMWGlMi+726NTxZjWgtnJiYXpnfEaSI71UiWJOnc3y3GSUlj+PVWZJcfAt7oYm4eOXIMK9gpPLiJivvAQezsvNDspc3nYUqDkUYNxJkPkjvug/t1xPdyVzjIeQzeasASfYZ0uNCdV95cZq8yhm2tNaSe9yI4eTHmrtCMRDdhxsRSqcT3K/yDv8D4Jn236exQ7GJE7q8VDYmJz3yd+eTxSm62qU17I4mAYn0okbsnNrnV+CgCoxoLsClfuIKUlmmdg57ao9NY8MN8jUlMu2I4d5drzKRvCjY2VGPTFJl4UB2UoDIsPgo0ECLqWE1/Io4OwXM/kUlyxVreqqzumHDT8qF1FrnIxBGDFMfJkyJov1XUJ9bCZuNssa85Zog5aXwlumfroirW/ProJlsPTjw+giqU8Q9u+MZqPgnBDl99j1z/LqYw4JIeZhwq0UkJh36jz11l616wbaLGIFmT4m5twrQ8JsQrCfzI8zlRxbRapNqoerzOM/wuyeBG3SGFjEa+68fGh7FJOXn6y01XfBKQ6GGv+S+N21hCzihcKdskzaE7Gk5VxzSvlALgABWvGpEGP8Jn/EQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(33656002)(86362001)(38070700005)(122000001)(4326008)(38100700002)(64756008)(66946007)(76116006)(8676002)(66556008)(66476007)(66446008)(83380400001)(9686003)(71200400001)(26005)(7696005)(478600001)(107886003)(41300700001)(6506007)(316002)(54906003)(110136005)(186003)(55016003)(2906002)(5660300002)(8936002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wtL6fb5KAKZwUj0AkvXuNs5R/yKh6+/Mia9utZ0hDn6pJgbLYe4oU+LaR0Ob?=
 =?us-ascii?Q?qwa/YcNkyArb84Vut7N7aE85NPn5qXtiITjVoV6vowVZTXYz25wr2xM+4OUg?=
 =?us-ascii?Q?+WiRd+//u93NrdirmjPO2n3KIWJtXAXaHlipP49iFYZEOWY+71LkybxVhRVX?=
 =?us-ascii?Q?tVl0RbaZQAGLenREOanFys5XuOyNfubM/WuQZ7O/MZo7Ii90ZMNyyfvo53cK?=
 =?us-ascii?Q?JVLX8rGw3xWhTvuFEy2nCJPUKg+4igXivn8beG/Mh99tEOafSwvqt7Xr9eoU?=
 =?us-ascii?Q?1OZHWD86BtzdEyWco8r0BE7XrkqTdd6iDBPvMA72rb/fNpXFoQrKBWAcWGg/?=
 =?us-ascii?Q?YwRCgSezlEiocuKt2CNaRWiPaaiUkJTSUpQbq/wgJ3NgoyERLSn7jfu8McaU?=
 =?us-ascii?Q?dkyJFnpCBXRUB8F+xzMis6REk67wfvf99xQOs1lNmoSJjeI90jnJvGRv+JAu?=
 =?us-ascii?Q?0C5GsgLJD+nJ5YL18ViXZywbaYvOgffPY510MK9j9z9PoTug3wWM1OZ43FkS?=
 =?us-ascii?Q?Hj8FObH9FvmpZ1IOTT1GyZI394K4uTOUSQ4yxWB/pH4n1ItS4LGy1pDxa1/9?=
 =?us-ascii?Q?zqxXl8qjI+eOUnMMp9DddHg25GJHS9sa8Tn5a7dWkeJvryDVk60ZIEz80hc6?=
 =?us-ascii?Q?OaoYoTH3DVYA9EGoCqafi8872xZGovMWn5iPxqFVL3Q4PvMLjCA1sTt0hIYN?=
 =?us-ascii?Q?ejHRYIm6wudUseDsUHvfmUkg8UOjp+McOPSUwhViaHNrySpOao6ALro9BYiM?=
 =?us-ascii?Q?Dw9XccAIewllJaS09VzMT4veDLmkc7vnahpigddOzH27F+wmGPJhb36aX2te?=
 =?us-ascii?Q?sZby/odkO1OB6dgDcEYO97lf11zIt+541vgknTI9k5cpa+wfDJI4j4Vv/OSz?=
 =?us-ascii?Q?FDxw/6eARHAyDEg7WNKCstiBhkq0ETVSiW91PgeLVuTu8ZqNAj2x/FsGBBqL?=
 =?us-ascii?Q?QaW6U51Tv/NjswFzXOprb59hEVWp+8X6BbWMhbKKF58DGe4Nf4GAGUmzzlGV?=
 =?us-ascii?Q?2RyLB8psXkHJU26uLXhKavTa8WVUqA37gGKBOxXGiqxpNY5C+cS07Bu5r/jf?=
 =?us-ascii?Q?Ox8hkyxBY4Pni6HARcNvq+z7lFSiNMVIoYHzXCwMuE2FvIl1GHs9YUNkm8IW?=
 =?us-ascii?Q?PTbd588Qn8odTseqIZRWq5aqlAL33x0C4g+j6AjloA6a/CGwtKOqptE42/0+?=
 =?us-ascii?Q?35PMBWXVgWgpAQBIoBZAIx8qDX2oD9d16bi7/d2tf6gY/Dbt2xaRKk1Vh7IU?=
 =?us-ascii?Q?f8rnMXivY+lX4+77F6UIGpm/eMIfGCXq4evXWQLe24xlppS7U+l3gagkGR3/?=
 =?us-ascii?Q?f9bEY0vFWu5bvURi+bY95LJH7JU8FGE9HcIhJfEEadGcqjGWpbBf5NTjBP0b?=
 =?us-ascii?Q?8oRpyWgWPoKaT4dR4iKID0/K8ary5bBUIokHAsVuR4mTHaeqcF3jMqSCQMnV?=
 =?us-ascii?Q?EIpY0WgDVpqAQUrX7HhTTYgQq0Gut3BsynwMsrRTgU+HMc3JHvq+FJPAPKTh?=
 =?us-ascii?Q?q5lfPGqjdzbNsrIPjtItrqWxNBDUERH98lC2MH/Jx9j8G5cNqhNBh3pPXCL0?=
 =?us-ascii?Q?9j/G+fmco7zqx/p823jjgn5HKizpRFvRGr+s6LiF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3edfadd7-cb32-4c6f-97a3-08da94adb007
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 10:58:12.9262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xc0vUglTToOxK1RBTQT9vH/tZFSVMdUdv40jbFt27FtN3czte2WYOXIdZQ3FjPc43+7EDY1+1IPjtHMyqqC1Ye1VYR8vVLjNjkc0Dp5l1w4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5605
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

> Subject: [PATCH net-next] ravb: Add RZ/G2L MII interface support
>=20
> EMAC IP found on RZ/G2L Gb ethernet supports MII interface.
> This patch adds support for selecting MII interface mode.
>=20
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      | 5 +++++
>  drivers/net/ethernet/renesas/ravb_main.c | 8 +++++++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/renesas/ravb.h
> b/drivers/net/ethernet/renesas/ravb.h
> index b980bce763d3..c5ef43f06ea3 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -189,6 +189,7 @@ enum ravb_reg {
>  	PSR	=3D 0x0528,
>  	PIPR	=3D 0x052c,
>  	CXR31	=3D 0x0530,	/* RZ/G2L only */
> +	CXR35   =3D 0x0540,	/* RZ/G2L only */

Oops. I have sent v2 replacing spaces with tab.

Cheers,
Biju

>  	MPR	=3D 0x0558,
>  	PFTCR	=3D 0x055c,
>  	PFRCR	=3D 0x0560,
> @@ -965,6 +966,10 @@ enum CXR31_BIT {
>  	CXR31_SEL_LINK1	=3D 0x00000008,
>  };
>=20
> +enum CXR35_BIT {
> +	CXR35_SEL_MII	=3D 0x03E80002,
> +};
> +
>  enum CSR0_BIT {
>  	CSR0_TPE	=3D 0x00000010,
>  	CSR0_RPE	=3D 0x00000020,
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
> b/drivers/net/ethernet/renesas/ravb_main.c
> index b357ac4c56c5..6f6bf11995b0 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -540,7 +540,13 @@ static void ravb_emac_init_gbeth(struct net_device
> *ndev)
>  	/* E-MAC interrupt enable register */
>  	ravb_write(ndev, ECSIPR_ICDIP, ECSIPR);
>=20
> -	ravb_modify(ndev, CXR31, CXR31_SEL_LINK0 | CXR31_SEL_LINK1,
> CXR31_SEL_LINK0);
> +	if (priv->phy_interface =3D=3D PHY_INTERFACE_MODE_MII) {
> +		ravb_modify(ndev, CXR31, CXR31_SEL_LINK0 | CXR31_SEL_LINK1,
> 0);
> +		ravb_write(ndev, CXR35_SEL_MII, CXR35);
> +	} else {
> +		ravb_modify(ndev, CXR31, CXR31_SEL_LINK0 | CXR31_SEL_LINK1,
> +			    CXR31_SEL_LINK0);
> +	}
>  }
>=20
>  static void ravb_emac_init_rcar(struct net_device *ndev)
> --
> 2.25.1

