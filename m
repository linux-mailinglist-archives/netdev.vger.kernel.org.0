Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C6064C4B5
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 09:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237684AbiLNIJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 03:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237679AbiLNII7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 03:08:59 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2113.outbound.protection.outlook.com [40.107.113.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C281FCFF;
        Wed, 14 Dec 2022 00:08:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=klc2nqTCz2hhSl54DRVsrgwXCwqnPivH2qixPW0qI8ptmE+MoQDlduEiWrL1ta+UFlgFkma5Jaf/Yt4OHG0Vbg1jzgRHWVX81poaXc7PEDztcatvBgLgxg5yt1gB0u3T0sUPpIl1pcgO82GdHdX1xuuuy0maYNuthKFh+4ySOGawtQFXj/0DH/AyXJmmIXjAHX0QkdhsPbK+EqUnVZkZmNrC7qJm+IdLprufyhqAXySt/yeEbFQaUJl6UwE2j4jgRFsf7Yr/yVCsK+I/YQi+cP5lTD6E+Gc0a6RmvT01SGX6qpCrtAEdO41yiyPxgJRBMvsruUKe3x9r9qV7s7tAgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XtCKCPF8ZHCzzx7fKnQ+WpPRVxttKGkVuz8T3fBzGF4=;
 b=T+/ouqmwhTBlaUJKONH6r3psH+m7q9TOA53E9CiK9W7DIkPsuT5H0xaRjN4cJ27q425RsKH/7Bg4F647pWVmpx7I+E17NOP5XComkkhWZRplOdE3hWaj3neOVq6yUkuGwkFD09xbgXRNYuF0pBA/Esbho2VqPX+S8ZHrsXwKtV6aHHEpADjXOPfEBw3DkBu6vrq6C5VSXxl6Nv0flWbMN5UmzBjp+R1mxWFgqmh7sYPv0ZQ0bBRIY8UzFlI/Rxo71KbarosW6FQzS3QaWCTPBG3FmLuaz0zWWCUf8oNYSvU6b5yCVEzWf2JUgqb8pSws8NACTcvUYlragnx62d6FEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XtCKCPF8ZHCzzx7fKnQ+WpPRVxttKGkVuz8T3fBzGF4=;
 b=lGF7AKqRf24vptWZqFIDohOL7CUhSFXT2Is30rdlmWdMIX9Cnr+yVaOVBf6rIA9usxQrksy0MqZs9JOpM1vCrRKg9FTp7TVJeCMlgPYUilvcQ8pc6JzBO6SDKjmJJvaM8OK9WLez2pP/HQP9MnM+rhbSvQvgQU6DSwUhWwNoQ+M=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB8473.jpnprd01.prod.outlook.com (2603:1096:604:194::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 08:07:57 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::69ad:8673:1ba1:d7]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::69ad:8673:1ba1:d7%3]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 08:07:55 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Masaru Nagai <masaru.nagai.vx@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net-next] ravb: Fix "failed to switch device to config
 mode" message during unbind
Thread-Topic: [PATCH net-next] ravb: Fix "failed to switch device to config
 mode" message during unbind
Thread-Index: AQHZDtmipYXx67GR80mASzVGjQ8KR65s97CAgAANglA=
Date:   Wed, 14 Dec 2022 08:07:55 +0000
Message-ID: <OS0PR01MB5922BB03158ED90DD2B82DBE86E09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221213095938.1280861-1-biju.das.jz@bp.renesas.com>
 <Y5l2Ix2W8yPLycIB@unreal>
In-Reply-To: <Y5l2Ix2W8yPLycIB@unreal>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OS3PR01MB8473:EE_
x-ms-office365-filtering-correlation-id: 9967bec1-3b9d-4e4c-fc76-08daddaa4e77
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pTw02P4whNhLFd3Zvo1UBDgMlkiRAvMBfibvdQydYoBHybPW+/LenYWCnI/cR1JyMCsM2ZgjNtGMePxkhjn3wmI2Y/xY4oPIh/sEoorsh/K2b3JcRmxDvVoZCuIAL+S2r6dwbQ6hSS6NYfy88eELp2VAfXtHPcPH6qC4+EWkdDtJeGzliiDIBsVblAiP9eXS6njyy3dX5hmMQNQthMfj2IPWQ1DLQRvH9sJpsUONib/+y/vd6uh6QFZnjiJ1n2knTyo02MwQuCU/b50P87C9yCPUXsaeXc6hNPFobFleIX8OhXzzeAg3pyU1wNxYI6HvlnOF11gqeV5t3jp1G++W7vv7msuYCs3wMgae3qBzFJ4GtioA+LdiFQLkTwGAXdcjW11sw6E/zUHii5rM09rlSLICq6OeDUi4wpfJtIx1jNPop9RjDH7F0ngLDl9+0DlSDGqbd4/YwJ5Ou+l047LHFo3aiRPLCU6dtuackjlQsTKWgCOZBzChGbFGtBwxjQrmz8HjNFD7cwy7/vO6W8C2hnLMZS0+mxZzD+Nn0v2Lgcc9BOVwPkw/yd0B/T918NqjTMK6uwlNNa5C+X+kgz1cV5ojjkiuUKT2uiJvYDF2GIxYYFOkwtyqWddbZxx2kH6GXGhgz8lxpYohYMc0U4k6hMpoW9MrZrSW+iJOCagYk1sigJrnGNfed6Nodt31Xj0uDhBPp55vMtAi6EFBDwrv1FI13MuZZPg98tarciIj+UI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199015)(478600001)(26005)(966005)(186003)(54906003)(7696005)(6506007)(6916009)(316002)(86362001)(122000001)(38070700005)(55016003)(38100700002)(9686003)(33656002)(83380400001)(52536014)(8936002)(41300700001)(71200400001)(2906002)(15650500001)(5660300002)(7416002)(66446008)(66476007)(66556008)(4326008)(64756008)(8676002)(66946007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q/NfjABfkOTNnYFZ/0CCYnhWSIybWNngDafyp9utdyTaaa3Ly8N26ezfc0yK?=
 =?us-ascii?Q?6k2FB2sldFwYQ/kWGOaI8oBNngiMyiXSJuU2jEjmXhgi0PJqN7P+96ByZU6G?=
 =?us-ascii?Q?jGO90jxUIvBuy2RYAYFJEX4rE2VX1z9s1u03Qc9GRSripKgurwyy+XnPIee8?=
 =?us-ascii?Q?B5KN0LJIq3as5AY82Y/pF4PnGQ8b8iuHycg5z1T8wrsyEpdhgRqy5MTmmQ5V?=
 =?us-ascii?Q?8CWfWSPjyqdMJ3dCfvEBDHZlgjYY1RS+ly3UBJJEPcIuYhq088pD7q/+Wmn6?=
 =?us-ascii?Q?nlakxF/63Ezg6tHv247wUMogLrMlrErTR1mRGDET+vmiM2TuaihGrfg6sh6k?=
 =?us-ascii?Q?6FuWYeILgjw/KV78Hv+7JcLW67A2br8OVyPIT4pfJ3PDWEp+s5y2uFWhz0KI?=
 =?us-ascii?Q?zzURtcPhcw84BnV+iG0tUUoFjRKydKmxqbt+ihSZ2Ps/02ut2b+ANCZ30Zpb?=
 =?us-ascii?Q?nd/sh8Ol8/TQxV0JAFwem+1Q2QORX/dJEzgHU/QrgSo+FbefZZjD94JlZQwN?=
 =?us-ascii?Q?9Etnqi9a8W7jzd0KFRjJXTrsVcPi4IrjnXY9MzRX5gop7FbPBg+SYBFQLZDu?=
 =?us-ascii?Q?zXm/3uJ16JwObE3zkNfTH3RxyH3zixGVkinhtlJX1wdHM+4fxu8uc9liB3xE?=
 =?us-ascii?Q?R02Pb8nzZcvcawvitrhqvBdPAR4SSuM4+VUJJEQfWvi3a3tbWAHkJu7L7Uo+?=
 =?us-ascii?Q?nlDEvLh/FoVv7eoNIRpXrpgEkzUvBkcofCojQeOFSnaj5Ae1SzID5akW9qx1?=
 =?us-ascii?Q?q/VR2EW+mjQzQEBifk9dl7qfNYr3feHSTilWbZgxUlhXKT1Db6MvA5OnwjUs?=
 =?us-ascii?Q?kJ2tTxdLUBIBp+70BPdOhx486dd/UZvyszW6cPG4r72cSPo/I2a3GMMMb12a?=
 =?us-ascii?Q?XzHXfC+M2E5STxYtoXqQSaZHb2fSY5X219k+KM+qYr/OgbN/r4SLnUDQsGXf?=
 =?us-ascii?Q?HsKGFm0fnX3z37dF7QkD9A5kLP1DK5qDb5+6xC4+pe4J8NlrXiIZkCDxgeX4?=
 =?us-ascii?Q?AQiNf7yya3GeDqeB/4sPgRjVK13jED55de0JHqxLFCQOYmR2aU+9ElyLv+DR?=
 =?us-ascii?Q?tMwA/iKObAY4hTOYLzNIDN6OQ/wjLI9aezWWUVqe47alqAwhd0Ln+YlyQjnK?=
 =?us-ascii?Q?hB5tGiGSjuvPT3V1Tlii1u6GMzrqeyxTZQxgefnt8g0Xx1D/Nf/JRx4KiLzp?=
 =?us-ascii?Q?rSMFTdcP7KH0XG4t0zCcnPTL0LRb65HvXblpA7zmyMMttO7uKEQnUvtT0QmZ?=
 =?us-ascii?Q?nko9DMtIKF0peaLHdbw+DJdCwS+UH5vcu06h47eqWo+D/MRk7XTx29QnTKE2?=
 =?us-ascii?Q?diPOolI/XNCArrzGH0yvc96Cdy/DR6nN7x95eHPDduAJhCfJEivDKJanOOtX?=
 =?us-ascii?Q?jgCZaCFvC/VAkJVUaFRfHLrBoKv6G2snraYo3J9ts3TflMT22wmni5IZmajj?=
 =?us-ascii?Q?CUfGlZK69z/K6PbyHsrGf27/J7G4zDL8UmclV3KTs2QBijWeoMqcHpTYNvoc?=
 =?us-ascii?Q?/esWEEymHlBZLBZt69x0Ly6W+dzLrn2Xwz1Vup2XbNcP1PdbxkFgR8BOlKEq?=
 =?us-ascii?Q?JOKTZqBMI3zhbf08jPYBo0aMzcjwtzlsIKGHJYLyQxzoWKKXlE7Mb47RQR2Q?=
 =?us-ascii?Q?XA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9967bec1-3b9d-4e4c-fc76-08daddaa4e77
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 08:07:55.6386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ++5aAYc60caNUCySjgaQTzBJ0P1Rj2m4XwicRQoHCRjhBO5dFL1YgtHkU7QTreRDvNw5fQd+PfTRdMw7y0XS8PBWxmy3Rj1QnD5hJbgl0KU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB8473
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon Romanovsky,

Thanks for the feedback.

> Subject: Re: [PATCH net-next] ravb: Fix "failed to switch device to confi=
g
> mode" message during unbind
>=20
> On Tue, Dec 13, 2022 at 09:59:38AM +0000, Biju Das wrote:
> > This patch fixes the error "ravb 11c20000.ethernet eth0: failed to
> > switch device to config mode" during unbind.
> >
> > We are doing register access after pm_runtime_put_sync().
> >
> > We usually do cleanup in reverse order of init. Currently in remove(),
> > the "pm_runtime_put_sync" is not in reverse order.
> >
> > Probe
> > 	reset_control_deassert(rstc);
> > 	pm_runtime_enable(&pdev->dev);
> > 	pm_runtime_get_sync(&pdev->dev);
> >
> > remove
> > 	pm_runtime_put_sync(&pdev->dev);
> > 	unregister_netdev(ndev);
> > 	..
> > 	ravb_mdio_release(priv);
> > 	pm_runtime_disable(&pdev->dev);
> >
> > Consider the call to unregister_netdev()
> > unregister_netdev->unregister_netdevice_queue->rollback_registered_man
> > y that calls the below functions which access the registers after
> > pm_runtime_put_sync()
> >  1) ravb_get_stats
> >  2) ravb_close
> >
> > Fixes: a0d2f20650e8 ("Renesas Ethernet AVB PTP clock driver")
>=20
> I don't know how you came to this fixes line, but the more correct one is
> c156633f1353 ("Renesas Ethernet AVB driver proper")

I got the details from [1]. The file name is renamed immediately after c156=
633f1353.

So from Stable backporting point I feel [1] is better.

What do you think?

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/=
drivers/net/ethernet/renesas/ravb_main.c?h=3Dnext-20221214&id=3Da0d2f20650e=
81407d8e51ad2cbdc492861c74e9c

>=20
> Ant the title should need to be "PATCH net".
>=20
> When you resend the patch, feel free to add my tag.
>=20
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
