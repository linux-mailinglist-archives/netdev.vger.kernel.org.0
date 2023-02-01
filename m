Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35430686FC4
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 21:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjBAUj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 15:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBAUjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 15:39:40 -0500
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2100.outbound.protection.outlook.com [40.107.117.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FD45CD26;
        Wed,  1 Feb 2023 12:39:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YKPvgyiA/JVgPYePBcO/hDmT6Xqa1CF6n+uyvzY39om10WsYTHzrUOAJlSmuU4nTQ13Nq2Ky8WodqUpwi/l+e9E56ubO1XImfVOfD5BdRRXl968B7Wi+t65A3FgDDjFabBOPjfJN6zSZo6jhsiqmZJNIn/s9SfhohsRUIY5Zu9ddQBpQtVGhbNcEqZxcoJwHy7tHuBy+W4Oi42xn6WsBmkmvMmsAhh1EXCix9Me3b3d0lzTuuV3r73vZs1TYs82fq6F8+VpymD3CYszYZnBBBfBpDnw9spTX41Fa0WMnbDooI7nHrjuTUM5RwGwmrnaEyzuElCmlaFpHIca+uEwRYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rmm4I1n3rEZ0avEfmKm3p8Gp3mppcDsF7P1GYCQyPxo=;
 b=oD+1W8vhmSR7wCsrjndTBarSNPgPcOZNU4mmRP6I72iA5C4z6cLcrpMIxN0exha9WH4L3UTETtkponm/J5RgDa9B9pbrj9G9VXtDo8X1fKO6Lz0TpcwmTSPdBeD6TUJjVKI4+QbdFfmKGRsxuYW1JtZC62bcAR+yjTML4BB8LM/MJLdmBqXj8xxBQQZL2tO+915fxqliMZIXtbsZfEW+Hk+2mNb28aM33+UgRBAfSTLDt1O5KU/d7pquji7MvPGcw36E1QxR3war2xKlmgy+DOu8gaOxgpxPFkBEAuvNEZjypeeyFyKD9oRNOFlky4GsuMpm/AkoMdb6hNC/PSKK7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rmm4I1n3rEZ0avEfmKm3p8Gp3mppcDsF7P1GYCQyPxo=;
 b=RyyEvIWWtBlVZsZ3zYw5PkZHa3tQ1TTA0sGp1xowCTrvOmbZG7xEHoupusS0ynNgt0mYPXDh3NW39C0Z9+xnJyLiAjM05AHKksXYhZODxj5QmfVr6ka5YQmWK+euYvuLxLxLX6bJJIps0wwOkM7kdpesqEM5V/EFH1hf49r8/1Y=
Received: from OSZPR01MB7019.jpnprd01.prod.outlook.com (2603:1096:604:13c::8)
 by OS3PR01MB6228.jpnprd01.prod.outlook.com (2603:1096:604:f1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Wed, 1 Feb
 2023 20:39:35 +0000
Received: from OSZPR01MB7019.jpnprd01.prod.outlook.com
 ([fe80::a249:60f:e09a:70bc]) by OSZPR01MB7019.jpnprd01.prod.outlook.com
 ([fe80::a249:60f:e09a:70bc%9]) with mapi id 15.20.6064.022; Wed, 1 Feb 2023
 20:39:35 +0000
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
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        Marc Zyngier <maz@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] wifi: ath11k: Use platform_get_irq() to get the
 interrupt
Thread-Topic: [PATCH v2 1/2] wifi: ath11k: Use platform_get_irq() to get the
 interrupt
Thread-Index: AQHZNl3qWoWF4hqjYEqUe1oE70EsXa66jOTQ
Date:   Wed, 1 Feb 2023 20:39:35 +0000
Message-ID: <OSZPR01MB701949307C9DFB0E064B74ACAAD19@OSZPR01MB7019.jpnprd01.prod.outlook.com>
References: <20230201084131.v2.1.I69cf3d56c97098287fe3a70084ee515098390b70@changeid>
In-Reply-To: <20230201084131.v2.1.I69cf3d56c97098287fe3a70084ee515098390b70@changeid>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSZPR01MB7019:EE_|OS3PR01MB6228:EE_
x-ms-office365-filtering-correlation-id: 6cede696-077e-4ff1-20eb-08db04946e07
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2fxPykS09IGczXfGedx90JXgzbexbH7IRBf7+M+GYeLal8JuhGVgnFOs4CIlFvGVmhXwWNMIhSlPQsHqsyeX2tflogoDBlDsPLQiQ1gdzM3LfTIsZ8zwdolZKyHNVru9k8HuwroHgCWgpGWmYu5RLrchly+qQZbliGens8BRP9ty8/47LIBS4ghN9WpXVIFWxCWSRjfoRxBped+71OpxeLewm8SyzF0T08w/TLgmZW/TG4uRcJR5KsNZm0Z5F3vUSOH7IfgqumnB7fRcj1z4NYZUEbjua2URGcziFFDVzBR5d9jLzJYPA51fd7KleOxDEwzVJ5skx9d1dteE1FcHlb+3Kolwnklq7F20qE/nYR87SIeaaGrKE/HjXDXsqpS5Sy6ReKMZlrkuVyki2kOEkNkadMf2n9TYUbJ1SensC320AohUPEv3u5zKCvSXcUQ64MJ1Nk78e1gTHLxnu/HBobsJYGBSSdixBZ0LloefmIosAl/mb7/9buhrSc/8FfRuo/LbEtsumkpmi3ZkqqqWBim5nmioDyPi6yyovZ+q4WYQajSYYwV7sQ7hpcNFckUynzlX4HJnWIXGR6IiP+Hym0m25GCoQMuyPIQcw/I3ZEvfvtrQx6tMQEUXVYO1H3WVt651aba/M+TV+oeR30k7vq5l3TWFSzjbgU5HhXshcE6Z9vpAHnK/rwJomqVFW+ex3FmUI+Z/ORazstEmdu3b3ZiNoTpeF29g+hsM1E4pZwY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB7019.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199018)(186003)(6506007)(478600001)(9686003)(71200400001)(26005)(7696005)(86362001)(38070700005)(110136005)(54906003)(33656002)(83380400001)(55016003)(316002)(76116006)(66446008)(66476007)(8676002)(4326008)(38100700002)(64756008)(66946007)(66556008)(52536014)(122000001)(41300700001)(5660300002)(7416002)(8936002)(2906002)(15583001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9+ZtP1yvCbquV6r5DZxrfYt6q0FZGZxjXvNLLFZ9UP0QzM/Px11l4FzgSR2h?=
 =?us-ascii?Q?8u8NXJnrFWLL1f5PSV89NA91zjksnt1dBJZ2EXRPjPVoZsVkbrjL1wI3eWTC?=
 =?us-ascii?Q?wSjqX2cob/mKF5hPctRxgKOqLftDJPHqJKDPjpaOPzRMBizKzJkPryfqqjFR?=
 =?us-ascii?Q?X9Qm32aJX7CC5WsmAM90pgeR7PRxXiY2lOUFzaQmMzSMShO93ov6egy9Gwc2?=
 =?us-ascii?Q?lZWfw7HUj+LRPh6gI5u0cIHceTOYhsbxQ1rI+cXGS2mAT1r+zimKgwLL++jc?=
 =?us-ascii?Q?lnDsWZ9VO3L6yDywJKMB6pnpnTsWM/IB7cXjBeOkIMNhaDStMdsDSmtp5w80?=
 =?us-ascii?Q?E+ZDqXOU7A4hAS/wtgNsU7MmhShNGWR1/3VNEqaOHY8lblRDrbyG+JLN0d1C?=
 =?us-ascii?Q?eq7XKA+1TafNiZFJFg1C5tHSE5j7NleEf0xXbgd9U29xDe6L1GIyy7n473sp?=
 =?us-ascii?Q?ro7Va37nsVEN7uXcaHTk4EFsZJgY39WIEjeSBJnkzl4mwg7FlilD84Xr+Zez?=
 =?us-ascii?Q?ZSRs7HV+x8n1zE7u+GvFQlYasVoWWoD5Jc5opul+6fvOe1lvG3hrWyEypxR+?=
 =?us-ascii?Q?qoptdjk4A1GYgngDdnzIsEW+7FBjFSSOuETBBFCSEBiMlkKPYg1WbglqNmB3?=
 =?us-ascii?Q?3TMTSqJVeroVaMB8kM23BzCYa8W6YRRug7VumXGGp1+lQNnagI1wW8RECfnt?=
 =?us-ascii?Q?XK0S/amiJzx8efj9z3QFuF0bj8dp9N/E60ZuDAVGyc4+FlVtWRRCG+hBaB2B?=
 =?us-ascii?Q?q99FM+/b6JZ5/f01IexeCo7rZmUdVP/+a0qa4dCrmDdogZk20O1QVCkrP7ib?=
 =?us-ascii?Q?W24Io4/W8MsQZ6ZKdydsuJQLUKQVQc9MVJEjsbKdKip71nqkAvqwOTKGJkr6?=
 =?us-ascii?Q?ZneeTaISf55zmN/wRoog9HFk50cVXD1Z2Lv2kPcw8Yox9wa/+nQaS8bQOmSm?=
 =?us-ascii?Q?xJ42b+XykS2f8a1/ILWVgAZr6urbTFDMLZhBvLWO18YMhZwakrgVYOR12qbU?=
 =?us-ascii?Q?SMDqKl7XhZfLoGS2IrMS5pS+E3NaiVS5fUMZvjVaTeFJjMMGYhrkYESa8b9s?=
 =?us-ascii?Q?xilPOUUA3dThRZ4bQOn47Nz6iXNlkTFdUEs1HgPf8XB5YbrROWQXuKg46053?=
 =?us-ascii?Q?9HV2hgYlGBRI6lo+e9d/7gfXdVx9PAgpfHLyrtdWAuOGkqLYlr8x+Xq4dFnm?=
 =?us-ascii?Q?H0PbgsmfXMT6x2HFR6tV9a1t/r3fcbp5O7PEq+b81adJxccwRTQV0IoFR/o1?=
 =?us-ascii?Q?o77rkI93xsDBCiMnxwWMpNdy2wL6OkHcnWG3MrqTNamysPcFq0rW7DphlX/P?=
 =?us-ascii?Q?Yf5vbxXYuoxitP2paT8ICexDEqh0/cAi7yJBRUAeoFWiacK6ga+f0HGm8ukQ?=
 =?us-ascii?Q?omdQzLPTc4oeuVgDoDmnWSLuVpe9SaD5aF5P2IFkQlGsNPrQ2p9dsCRkq+Wr?=
 =?us-ascii?Q?9tiPL/NHRoT5d8vFD8WF7pX35zPJ+adphzt4hJ56C4uIKe6nkvxAfSLGxqNa?=
 =?us-ascii?Q?7CWPsPpuR1C4aS8wfv8wY/2lunU8UzOovuz4M2XcYHaEKsEvIB18CKD6mkKg?=
 =?us-ascii?Q?p8NARP5jYsqysy/y6SYOFTUbKyhlC+6HOaqiusxb8nAxUUQSyeV8okbzGn8H?=
 =?us-ascii?Q?ERsg6SRd62S8d3y+zeQh0b4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB7019.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cede696-077e-4ff1-20eb-08db04946e07
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 20:39:35.0532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dwv1znjG1lHETeQ08DKSLmxgfL1jvQEPbElMN9QJKZ6S6Cn8+J1IGbhnCrMHvd/3MNqB0dMV4fHn6DUFf+cwvRgouBqLdVR+0pnWxhQ3UcdumnAUZMwaB0c9rI3V9GwZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6228
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
> interrupt"). ath11k seems to have been missed in this effort, though.
>=20
> Without this change, WiFi wasn't coming up on my Qualcomm sc7280-based ha=
rdware. Specifically,
> "platform_get_resource(pdev, IORESOURCE_IRQ, i)" was failing even for i=
=3D0.
>=20
> Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.1.0.1-00887-QCAMSLSWPLZ-1
>=20
> Fixes: a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from=
 DT core")
> Fixes: 00402f49d26f ("ath11k: Add support for WCN6750 device")
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Tested-by: Jun Yu <junyuu@chromium.org>
> ---
>=20
> Changes in v2:
> - Update commit message and point to patch that broke us (Jonas)
>=20
>  drivers/net/wireless/ath/ath11k/ahb.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>

Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Unrelated to this patch, I think you need to call dma_unamp_resource() in t=
he error path?

Cheers,
Prabhakar
=20
> diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless=
/ath/ath11k/ahb.c
> index d34a4d6325b2..f70a119bb5c8 100644
> --- a/drivers/net/wireless/ath/ath11k/ahb.c
> +++ b/drivers/net/wireless/ath/ath11k/ahb.c
> @@ -859,11 +859,11 @@ static int ath11k_ahb_setup_msi_resources(struct at=
h11k_base *ab)
>  	ab->pci.msi.ep_base_data =3D int_prop + 32;
>=20
>  	for (i =3D 0; i < ab->pci.msi.config->total_vectors; i++) {
> -		res =3D platform_get_resource(pdev, IORESOURCE_IRQ, i);
> -		if (!res)
> -			return -ENODEV;
> +		ret =3D platform_get_irq(pdev, i);
> +		if (ret < 0)
> +			return ret;
>=20
> -		ab->pci.msi.irqs[i] =3D res->start;
> +		ab->pci.msi.irqs[i] =3D ret;
>  	}
>=20
>  	set_bit(ATH11K_FLAG_MULTI_MSI_VECTORS, &ab->dev_flags);
> --
> 2.39.1.456.gfc5497dd1b-goog

