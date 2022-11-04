Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FBF618F79
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 05:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiKDE3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 00:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiKDE3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 00:29:48 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2115.outbound.protection.outlook.com [40.107.113.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA226248F8;
        Thu,  3 Nov 2022 21:29:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L32Fs0Jv4O1MM2XSk4jkdnAjP0tUGO1w/+P72G3zLH2XyyiBTJoxpstGzRfjVMYLQqFWAJZ8D7KfKoXO9KQwoZOcz0cwLOefOsraEhmPcw7vLuYQnbuSlZQJ11hoB+l8gDi3QmuC3DzXKp6oRFcASzze/PNCehc6lQO6OQ/qtbwnatO4/ZGs3W0GZppA1sYnIfm7EQjT7RakfuOoo3o6MRsOF2GEAg3kY3BJprnqZ1bB88iOkEFQk3VvaQolZikKxDVWkaRVc9y+x2tjZn6Q4IT5aQaoWHuD8LmW6yZMAaCfrUwAc2Gz0l/HS1XNNYhtLqEQBAvq3MwEAYLPFRbKfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8hgJq3fsfAaTROBukC8XUs3L4X+xGBu0MIUU4daZL8=;
 b=KvOD0vTZ0HZ0jzVG+yaT4OI2W5XRRCc8ly7/0rczGg2TJ6CyVlWNuE3iFDCAWczwbOz1MS7RBg1eNWD1kZ8BL2PZghvKLAyyWy9dE9ctwc75hV6LH3wohuBLEp8CMLNzqukbLagnqwCMZSWfrResoZNigMyro68dXMCgiYokM8R6Zb7nRZ3Fe0FNs7j83Z+N7xUrnDOQ51x5Cg2EWxdo1cwbPNLGsypkn7xB3iKpXX6gsyOVEcEpPV4HpvwLUjxoBHp+SOE7EJ6AqZL9AcG9EVnwvUaJo8fzeJHK3Ne3z1a1ypVk7/AefIFlN4RZOzy+F+w6F7qwWWQpaOKlb8h0uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8hgJq3fsfAaTROBukC8XUs3L4X+xGBu0MIUU4daZL8=;
 b=Q4wJUJF0J1PcX5KXB1Z2LOCl4+J/AhHyGvAKpHMiZL8hzcf6IweYjjlvhDgE/3rvUShr21qUIPVB4+P1HKyc7v5jSz5XHqiza4rpGt+wEXsbCr7LglcylpdQZqNVsjIavuUZ2mDEGA1O/paiAGRIkPV7ltbcr4eFmp+3DLGuZMY=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TY3PR01MB9746.jpnprd01.prod.outlook.com
 (2603:1096:400:22f::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 04:29:42 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::e28a:8db5:ee6a:34a8]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::e28a:8db5:ee6a:34a8%9]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 04:29:42 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Nathan Chancellor <nathan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH net-next] net: ethernet: renesas: Fix return type of
 rswitch_start_xmit()
Thread-Topic: [PATCH net-next] net: ethernet: renesas: Fix return type of
 rswitch_start_xmit()
Thread-Index: AQHY78/AL5gpWhL7fkeU297Crrw2Ea4uIPvQ
Date:   Fri, 4 Nov 2022 04:29:42 +0000
Message-ID: <TYBPR01MB53419352217D1C2FC8DFE1AED83B9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20221103220032.2142122-1-nathan@kernel.org>
In-Reply-To: <20221103220032.2142122-1-nathan@kernel.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TY3PR01MB9746:EE_
x-ms-office365-filtering-correlation-id: f92b574b-571f-4891-2240-08dabe1d3207
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yzhH2wdN5cS/ftOi+yJCPMfg0+oFURELavHzA5aKCrnP5t6/mu7ttqmiu4Y1Z+7DZF+FsOylFU94Q+J/HOQUNyaYSfch16Aj814htOTyfLa9/pcCmRL6JAtCl1e7FJgE0eWmPajlVXipa2OikJrSdV9u9nKIkPC+V8rIZ+6fuOzktro/vBXAJ7yHV1oisJmHbOYxhv7wZadt0HQFUhUT+wd4eQjFDWbrzWkeOB2Q3vYf93snCkndO9iU4GBlfzJUcuCHIpCbHujBl4oA3jBQsA75Iku1Gsm2HJekorLvqbPq3eANQMfl+Kd9pzI0rE5mDTqtl3ikVO32B/7DA+kMK0jwSA8UUOSmf0frJi9+5tJRgaLaji26cf8dgsN9eeasL5AvvbIKyOrd1LHj3ojMqOQwJTRfVpZYvZGQYD8+Uz2pIDMq9TVO9yxBv2g2T3NvEMYOolFhPKnPZ/2Jb49rOKN4e1P8JJdfIK8uBw8yy5YfKKIlZ6FBGNuhOSLw7ltJCDusYRYnFnZKzWv6ZR0yIe8r62v6s8r8IVjk2GP9f/yFWbtIsaFlNVqOVz3KEy7axG8OKEs+3XosDai1c/xXDuj75YBA4QG4HixCXeVI0EtTtwEezAHClTvgq80wawJ1BHO5aNvGbgcTgPIiM7kDl+DL0hQCKv+e69PAZZNyEcCE8R6u5ZZwHjJJpxTfRxZqzYqzqJo9ehwLRKdIBTXM0vk8RUASuMrJTyoaARpKdAETocuFcrKHRF5NtIyfSJn/8cJoA3qGb0QyxxsPFD0oS/b57S2hsHoRdSZMFFTwZi0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(38100700002)(7696005)(8936002)(41300700001)(52536014)(5660300002)(4326008)(33656002)(316002)(76116006)(64756008)(8676002)(66446008)(54906003)(66556008)(66946007)(2906002)(9686003)(66476007)(122000001)(6506007)(38070700005)(966005)(478600001)(7416002)(83380400001)(186003)(55016003)(71200400001)(86362001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?i+KaWJvgZ4Sr/Ith/Qb6A1V2oYugI+LaJA3zQ5gdyqoplNVicMPpqWDCKgQn?=
 =?us-ascii?Q?/l3oDzTXnSt/678Ti7Uh/vOPsYpBQGxtgH2mnalE0BduR1oM47C6+bik9sx7?=
 =?us-ascii?Q?eEPGGee8tigTS7mKqUN62EczAZR6VsVTmNQB6m8ddQKJzTGPVpONsFe/ENar?=
 =?us-ascii?Q?7xhLswxzKpIa8mT+ddqQVZYQr4yz0evV0ezNgE/xmyHSebfilclijSKdlGaj?=
 =?us-ascii?Q?mVCfpApCX2vVtklrIhcCX9H5GYEW9O81VMMAwLDJU/uiBvB01WewWm3yN8/M?=
 =?us-ascii?Q?GunEDWaRs5Q6G7o/Y8AosnoIQyVZzPCUGJeFQNNP2M/VXFnHtFwbXqSSwMWF?=
 =?us-ascii?Q?jcbHJoJIoISiPH6NcWa3TCDtnLFL/3TbQsO5pISH3sT8+hGeqdM4QYJxMQdZ?=
 =?us-ascii?Q?sZUwI4lnE56jDEMZHjhXUiPR05bkM9VvoUFYxTtk10FjXtH9oJQsZWi87I0+?=
 =?us-ascii?Q?sorLL/kvCaeTJ2X/RSwD+tJh6m5H1AmHHWUR3EjQiR0ylg2/EdMOQS6nS9wl?=
 =?us-ascii?Q?I+QeLiE4ppxnbprUU8z0ILKioA1V5SRiv4d/I8tbty59YvZ4UTEO13iMuUM+?=
 =?us-ascii?Q?gvj68V6WWneMoSCpXaPBiCc9GwYM3kVCwOlhM+kIhAn4g71flxrqQXfwV29C?=
 =?us-ascii?Q?F+y14H9bkeiaZoZOnPrXRHxkZNV2L2dKXTN5v5sehYznzNf7ZoWYS5sqWFbx?=
 =?us-ascii?Q?FhF3fh//WqZs2dMIosjc9X9J2rPD7l2997WnnzB0/YWID+YER/CYNXLrl0yt?=
 =?us-ascii?Q?/PQ1V0/vM1RxlsOdzxgo8AsSHAneSosRjZXfR1F04urW2P2WvSafqLzA+nBe?=
 =?us-ascii?Q?5qPRZm/rFOKEhO1VdA4zImukq4q3Ga6dFSZXAdJqY0rpcMI1e9BPkkz/QZJN?=
 =?us-ascii?Q?L0rnzlIFzZbVvl4gKHwClpHhESqhRw+6M5cCqSs9zB7Ezo436+Hd0erwky6k?=
 =?us-ascii?Q?bgLTyuZ9ZqTVa0MJjNpI+di+31sBLT5k0FL7dn0Ejy8KFrQxlZg/6Vpzk/X0?=
 =?us-ascii?Q?mu2fHYa4alX7tgxWu8Ly1HtOsgQhzWS4v4kQKt7IouGWQmttWHhH0DFifssK?=
 =?us-ascii?Q?unI5ItdxIt9tc0eF9NIvMW/gsS7Efyt4ErsaDH/GGQDt1MxfpCxjxTOXztSW?=
 =?us-ascii?Q?Krh1zMTLwX5QzDsDVZk3OjjTNmYS8EpQZu7li/oE5kiqUjC4ry4rUqT2TWix?=
 =?us-ascii?Q?g9o9N/APrlurn2jkG9/spM0OBEkSvMuc1JboLw37RPbTHk3tM3zwAOrFjhdx?=
 =?us-ascii?Q?AXzF0vGgWNKUrLdKAr1KTGP3kZAgYWC9RWsz/2uf9zg6p9AFonmKYBR9P2cF?=
 =?us-ascii?Q?NC83okdrSuJTHtuFX2SCnhT4W4FrwkY8OMOOuLbqs4gzPy7WHCPHDAHOKLiS?=
 =?us-ascii?Q?DmUqtiOfU2EY8Yb5Vi1FbWcuT95UkzwClY/sG8XsbbHJCkHTUTpkmRcFxEZn?=
 =?us-ascii?Q?ZVz8l1YN5Cy1YZrAIqkzHtztpwXXOCLhA9avvFTBNnzBw+KJrNdTVus+kR8F?=
 =?us-ascii?Q?CnqlDKR2rYKgNXuoDFgbtYQJAGzqD0nxuRXRqWwdszVM4c+eEEyMbO6l2p31?=
 =?us-ascii?Q?lErmVdz99CJ2zeX61I86UZbpyUh3nIFIkDJJsz5lYo+8McNj4O/t1Oh60VKL?=
 =?us-ascii?Q?MYMTLxHO0eFawNqVeB9/RWz5GhzrEN+QCOwbA/dvmdK89DP4ljOS6/IwtFyr?=
 =?us-ascii?Q?thSkXQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f92b574b-571f-4891-2240-08dabe1d3207
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2022 04:29:42.8378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X1IFrSBZdrrSdClkhFEeJNUTZbhBG/aunvUyIdxs9AiL9xdboTGJMy+7+GfSSRi2LuLhYyrtI0RWPOj4rL17NERpXSDa4dETVRmFMqOwdGVVvwCtBRSq7bL9cPqKKfVC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB9746
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Nathan,

> From: Nathan Chancellor, Sent: Friday, November 4, 2022 7:01 AM
>=20
> With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
> indirect call targets are validated against the expected function
> pointer prototype to make sure the call target is valid to help mitigate
> ROP attacks. If they are not identical, there is a failure at run time,
> which manifests as either a kernel panic or thread getting killed. A
> proposed warning in clang aims to catch these at compile time, which
> reveals:
>=20
>   drivers/net/ethernet/renesas/rswitch.c:1533:20: error: incompatible fun=
ction pointer types initializing 'netdev_tx_t
> (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(stru=
ct sk_buff *, struct net_device *)') with an
> expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror=
,-Wincompatible-function-pointer-types-strict]
>           .ndo_start_xmit =3D rswitch_start_xmit,
>                           ^~~~~~~~~~~~~~~~~~
>   1 error generated.
>=20
> ->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
> 'netdev_tx_t', not 'int'. Adjust the return type of rswitch_start_xmit()
> to match the prototype's to resolve the warning and CFI failure.
>=20
> Link: https://github.com/ClangBuiltLinux/linux/issues/1750
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---

Thank you for the patch!

Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Best regards,
Yoshihiro Shimoda

>  drivers/net/ethernet/renesas/rswitch.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/etherne=
t/renesas/rswitch.c
> index 20df2020d3e5..f0168fedfef9 100644
> --- a/drivers/net/ethernet/renesas/rswitch.c
> +++ b/drivers/net/ethernet/renesas/rswitch.c
> @@ -1390,7 +1390,7 @@ static int rswitch_stop(struct net_device *ndev)
>  	return 0;
>  };
>=20
> -static int rswitch_start_xmit(struct sk_buff *skb, struct net_device *nd=
ev)
> +static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_de=
vice *ndev)
>  {
>  	struct rswitch_device *rdev =3D netdev_priv(ndev);
>  	struct rswitch_gwca_queue *gq =3D rdev->tx_queue;
>=20
> base-commit: ef2dd61af7366e5a42e828fff04932e32eb0eacc
> --
> 2.38.1

