Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55042686FCE
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 21:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjBAUom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 15:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBAUok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 15:44:40 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2124.outbound.protection.outlook.com [40.107.255.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC03974C17;
        Wed,  1 Feb 2023 12:44:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Doi5xi2s9V8JixsIAufuKV8O0EgoZXrS2aIi8Hdcalm2N//1NEXIzPO7SyBTzDjeKnOueFiQ+c8wtNpYvpRvGQjkoKU2akDGFHY/jSicjiPKMiHOWpSQVgiasP+SY4/M4V13u+z9+Fwhdm5qiciHlkE7OgqAiSYsk96IZk4P3e35PSaysgDQUROMRdUHFe8br1qC4T8ZaojX+UtDv4Qmm06fWsrdf4qlV2yygqPcKxCPa+s2lwZt/DvHy5YN2Ly0Q0UauZ8ZIHFI8zGD0q5cxBXvysAjStaRZq9aMbAsw7ymhoJeH7nBfr2E/JIkspMrL7VUHNrnT3iVIgGv0NMkQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dxmJ0JoBTmnR7tKk6Z5RcPOCFxwnAp4vkwjOR6uF9sk=;
 b=DI32UXenrrgrqAFFbVoMlNzfF3oA4n4iMwZnTDw3Sm8S4VTkWYnPXHc3LajDl1YwOU0NNhYc2gTxMcIKGfxMeYY7X918eoF+dOwMoEPlwxax4MSrvM3TT8EA5YXkaJyfL3Mp1J/TXYHQAsxSKmNLSIR7V42oSzqhgLANSzXrXZ8XPpBGFXO7/poUFi62nAWWcRtqhQLcDi3SOFKgDDvGmX1Y1yypSMboov/3tImGdrKvc3pN4V/BllY9G4HW4A3XKNsF2+48cfiqPeTr/0LjSlcN0L3oaAYylQMFBT6sS2kZC6xBCoW0mGf7CgjBxtKEVqaS/G7cLfE549lHEMeC5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxmJ0JoBTmnR7tKk6Z5RcPOCFxwnAp4vkwjOR6uF9sk=;
 b=kYdlIGtCLkos1ESajvpRX99/HUR/btvOStsgmdSfi8WF97vkQEHnRGX9wbHcqgWt5EQ2h7tew41+glGfh99wmulzApuiX6080QvPDhyEziUk4kVSDaGCIye8Y+e6+y7TThu6paiHmd0Cly8Wa7X0ncMU61W+T3nVwsvvJ4QIK+c=
Received: from OSZPR01MB7019.jpnprd01.prod.outlook.com (2603:1096:604:13c::8)
 by TYWPR01MB9906.jpnprd01.prod.outlook.com (2603:1096:400:236::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Wed, 1 Feb
 2023 20:44:35 +0000
Received: from OSZPR01MB7019.jpnprd01.prod.outlook.com
 ([fe80::a249:60f:e09a:70bc]) by OSZPR01MB7019.jpnprd01.prod.outlook.com
 ([fe80::a249:60f:e09a:70bc%9]) with mapi id 15.20.6064.022; Wed, 1 Feb 2023
 20:44:35 +0000
From:   Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Douglas Anderson <dianders@chromium.org>,
        "ath11k@lists.infradead.org" <ath11k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Kalle Valo <kvalo@kernel.org>,
        "junyuu@chromium.org" <junyuu@chromium.org>,
        Youghandhar Chintala <quic_youghand@quicinc.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] wifi: ath5k: Use platform_get_irq() to get the
 interrupt
Thread-Topic: [PATCH v2 2/2] wifi: ath5k: Use platform_get_irq() to get the
 interrupt
Thread-Index: AQHZNl3rzcyQcazGiUq1wUEKfZMPgq66jmCw
Date:   Wed, 1 Feb 2023 20:44:35 +0000
Message-ID: <OSZPR01MB7019B1D2D0367354BF03F5D3AAD19@OSZPR01MB7019.jpnprd01.prod.outlook.com>
References: <20230201084131.v2.1.I69cf3d56c97098287fe3a70084ee515098390b70@changeid>
 <20230201084131.v2.2.Ic4f8542b0588d7eb4bc6e322d4af3d2064e84ff0@changeid>
In-Reply-To: <20230201084131.v2.2.Ic4f8542b0588d7eb4bc6e322d4af3d2064e84ff0@changeid>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSZPR01MB7019:EE_|TYWPR01MB9906:EE_
x-ms-office365-filtering-correlation-id: 3d93f5ff-7c63-49a9-96b2-08db04952119
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bNFgkzpeHvf4kJMiRMLp9ljyatI+Z0lINEb96ULDxcqrsCTTln2NtxPrIDIshacXroiEuV6ju13qxs2b/SsbD73+ReI4RNNS3XlKO8ejTiTBHk8AkijaW+62oGnxiZv4qyGmrFzVK0ONg1wAo8wU3yb5r7GnSMLuGTNZewkQ+TprfIABxU3tXJm3mLQbQQcEGhzXnF4qZligsIa+dlsl3pzJft4C6gcWbhaGIahPeYw01vwgeyQMBjz42f/l/hM8KGbIOWidAZPWN+HqRsDwzGNAm2Cbwje073gdyJ3oXCX6N4UXhqiECqFe05wswAS99LQq5PwL/PE4MNKM8qk2r5hNM6S8ojKmXe52nqm2Iogm0TE2ZW649PpM4cE8kympLRE8A4JWQ/+rZg3O9+jt8fUfYvJK2yN8x+jQ+6WWXN+bPi8gJRCyiiAChC+MYbCd+vAB8Pl5b8OSxFpr19fnOhAvTaxynIdHQ18HqElxiLx8FkAVjlzn2JD6kvb1cn/I8h+NJHIyNLfSZkYOKuDQEKRyEUUM9KEPXQQJZtCkQlpDu/HSMcQ2BlcF/iJxe1Fq5xKHLrXDrq2IcucLlDIrcIPVg5zopt7NJnD1BsTVkkbZq8rZyBPHjZwt9rwxlhJhik8cgw/wKz1DikARxOZIn0o+9gMkdyNEC6lCtAZn12SNveb7t2SGUEcQIxccegZG2WfVCTgLJwIDOHwgTjYZfRD3JZr95VD7auzI4dpG36BB2hf37hi6Mh5lZpqV4pR/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB7019.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199018)(4326008)(66556008)(110136005)(5660300002)(316002)(54906003)(52536014)(66446008)(64756008)(7416002)(2906002)(41300700001)(8676002)(76116006)(8936002)(66476007)(66946007)(71200400001)(7696005)(478600001)(186003)(6506007)(9686003)(26005)(83380400001)(33656002)(55016003)(38100700002)(86362001)(122000001)(38070700005)(32563001)(15583001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9J2DTYCC8Du7zQ0cti5J3+CRgMW4mVy4pQWbA5v19mIYSYTz9XxwdtlEzaXh?=
 =?us-ascii?Q?qbTiYCP3vzeKzPD+V55XK2ra5qWQYc7eCyzBEMwVWEMbCMrYhIC8Kf1Yiry5?=
 =?us-ascii?Q?KZegXuwX3+cl4DgVgPjkgqWejfOvk/S4rBJE2i6nxg+hkzu6VjeYBDJ0b/Uk?=
 =?us-ascii?Q?wcUlju9we3/msSBCk2VNlVI58Gec9tTgtJhkyVGiz6Uj45fL511dNm9iO3BM?=
 =?us-ascii?Q?uSD6ntDcPUKNJM81OuWIxkwuI70DjsBmwkcGtL2//WZGuvc+j0A/3rgGYDuT?=
 =?us-ascii?Q?eQjOA6Lgn/FYd2NeRyGclpibDrPEpFkGyoMjFfO1CYNkUaU2raEwl+k+Slnc?=
 =?us-ascii?Q?/6YxT1TPzZwJrKfczOFN7gDRH9xFn7py+5gmsIKpvavgkKduv/XhnqA5uVTQ?=
 =?us-ascii?Q?wxMEtkzuCIKoBYFkPfDHMNLQcRpTDGAE2atLtyA09b0OJs6SdKYrOPc/OF7b?=
 =?us-ascii?Q?sqxML0dmjj5cBk88Y0UP+H3SrwrkVcxDDO9gOq3xaITtVxVUIs8rWKOAvbFe?=
 =?us-ascii?Q?7fLF3eWBM9h34bvZ6JOYbtz10C8WnXX+L6eiMV61MATs8y/e5g3Yg8wXTBLF?=
 =?us-ascii?Q?Kb6pb6UZhTnlisHV22TzuHhpvGbTn7NzcFetFBsWHzqZjOP3EwJX25vCilcu?=
 =?us-ascii?Q?dBXAaeOBnbAzKH5B9IuyYnyPmOAr5mKWYhucOHP8oDCJ4fX51gjYhFDqnhAr?=
 =?us-ascii?Q?vb1Q74JjS7WJxjSux12LA743wmP407BeSYklDGkGLG93Tps+uWhUl1Aww3wC?=
 =?us-ascii?Q?L6wDKFKZcydxIQ6EvEBksHd3GGrKpF8Sn8QEPDnw2ZavkOQPqRPLtK/xBs+d?=
 =?us-ascii?Q?UiXWGxiyg98eQzN+YkTNyqHImzg1+K+rqcTq/J5cXZ8OnuF3OlzYf7sEvi2F?=
 =?us-ascii?Q?0ug334BmM3V/3gqjyA9nAWtri9ExifiVY4bnbcz+Er9XVhZx9iEPVwvhxBgk?=
 =?us-ascii?Q?UZZllhH0UmvaSVWs+SVW8Em8ngAZC8cJwKDoKFZl2RWQ5K0sJtckW3reswm9?=
 =?us-ascii?Q?6VHBbKT1sY3rr5I7VYpdLBBBncpBKrZKFSgJjOAarClmku8hA1H/umgMhw43?=
 =?us-ascii?Q?eOPQWRa8/uYE9ab1+bugCtqZhFWep1cTTqFiofnJwNt8zjiah4+7Q1qQuMFn?=
 =?us-ascii?Q?2JrEeQvHofpVmzrbJGtN+yn/SbrqXJ92FlGXLMNi7W7PuAFTqu84er0fjeNU?=
 =?us-ascii?Q?6FzbBmLfDMrS6xbEj8iq0ROZ7Gva22atoJnUEfSoAGmzGBtfN6e0mjM7+4ND?=
 =?us-ascii?Q?24wmP3dpRLgGrmxnhL59y6giAaxuQ3Zm5H14h/pKJZuQ97kVzn4YlkOXQJrf?=
 =?us-ascii?Q?Ex2XCsQjfL6f9G7ZV18sqc4CfZ3k3j84E+IguNEte4esANtTYrxvvSePvkxK?=
 =?us-ascii?Q?F2sFK5tcG04290ar5NzobWMT1uD2sodfHMTnwOGB5YM+GrZ7csTVl4bKb0h1?=
 =?us-ascii?Q?ofmaNpGD5OIMGxveGiqoI3fhnMnXinVDOi1ZZGWRPcp/E0itls7QRuz7abYG?=
 =?us-ascii?Q?DutLTObFvHhLz8znuttT/yZsyccX/+ZYteX60dm7L7yYGlz135F7uekRNlZg?=
 =?us-ascii?Q?AwueGGTWzj9pcDDjuvd+0HuE/fo22hcxCL0AaM1JIt93p440/QG6X5fUiOf2?=
 =?us-ascii?Q?voPHFU8mKmFlV6SzdK/t+fM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB7019.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d93f5ff-7c63-49a9-96b2-08db04952119
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 20:44:35.4551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9KoaUx7F5KEl7ZQsTuJHegWvmyOWPiyn4GCsO65M8kQxnHpy+AbfJOV6vKsMa3d8hZp9XlL/pxSPnE6oujR2m0cvGn0JUtgVL3OnlSHLX5NBzDsC0/KrKmdGQuKCQq4A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9906
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Douglas,

Thank you for the patch.

> Subject: [PATCH v2 2/2] wifi: ath5k: Use platform_get_irq() to get the in=
terrupt
>=20
> As of commit a1a2b7125e10 ("of/platform: Drop static setup of IRQ resourc=
e from DT core"), we need to
> use platform_get_irq() instead of
> platform_get_resource() to get our IRQs because
> platform_get_resource() simply won't get them anymore.
>=20
> This was already fixed in several other Atheros WiFi drivers, apparently =
in response to Zeal Robot
> reports. An example of another fix is commit 9503a1fc123d ("ath9k: Use pl=
atform_get_irq() to get the
> interrupt"). ath5k seems to have been missed in this effort, though.
>=20
> Fixes: a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from=
 DT core")
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> ---
> I'm not setup to actually test this, but I figured that I might as well g=
o all the way and fix all the
> instances of the same pattern that I found in the ath drivers since the o=
ld call was actually breaking
> me in ath11k. I did at least confirm that the code compiles for me.
>=20
> If folks would rather not land an untested patch like this, though, feel =
free to drop this and just
> land patch #1 as long as that one looks OK.
>=20
> Changes in v2:
> - Update commit message and point to patch that broke us (Jonas)
>=20
>  drivers/net/wireless/ath/ath5k/ahb.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>=20

Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Cheers,
Prabhakar

> diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/=
ath/ath5k/ahb.c
> index 2c9cec8b53d9..28a1e5eff204 100644
> --- a/drivers/net/wireless/ath/ath5k/ahb.c
> +++ b/drivers/net/wireless/ath/ath5k/ahb.c
> @@ -113,15 +113,13 @@ static int ath_ahb_probe(struct platform_device *pd=
ev)
>  		goto err_out;
>  	}
>=20
> -	res =3D platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> -	if (res =3D=3D NULL) {
> -		dev_err(&pdev->dev, "no IRQ resource found\n");
> -		ret =3D -ENXIO;
> +	irq =3D platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "no IRQ resource found: %d\n", irq);
> +		ret =3D irq;
>  		goto err_iounmap;
>  	}
>=20
> -	irq =3D res->start;
> -
>  	hw =3D ieee80211_alloc_hw(sizeof(struct ath5k_hw), &ath5k_hw_ops);
>  	if (hw =3D=3D NULL) {
>  		dev_err(&pdev->dev, "no memory for ieee80211_hw\n");
> --
> 2.39.1.456.gfc5497dd1b-goog

