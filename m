Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2CAD6E9A31
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjDTRCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbjDTRCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:02:44 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2068.outbound.protection.outlook.com [40.107.249.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198A7E50;
        Thu, 20 Apr 2023 10:02:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/4EEtnRJ7hh/bhQv80630DK0ho98Kh9eAhxCPbwesPt+4HwULzDvH8iHNder35DZ+Chf0s9G3J/JvS6MG+6IWXlaRfo+TJSjoG9naGSD0EIXKosBij3AQw5bwuu3I2T/u3Ymo0VikiTVYbvt2wVGnIchYiFJzUBfzA3/o1iQd1iixabKtVcflw4+HoBbZUoaWa5/036bO8WFKOwqV4TPDLYgYraHp0jBuFojBye38rt44N8nXuzeEep7c/XCvwE3vmHYBl8/xmKMtDIkETo3XK6jxpbTYH+Mwz4KQII6LPRe/N3T/QPG90LC1aydRiesinxLyrI4ZuxfddH2ZRccg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cn5aSHXHMGsJ5IPi0MxRzbSthYR7ZRrCXlgwL+VJSF8=;
 b=ar1O/nLmEoR7hlHY16CaJ1aQ/7VTiTV63YDbwOZW09bmJLPXQtkHZE1C1jxD5/bJbiz0yiyRAhllYslOJI0F/mR+LJfXikAE8UVk7BYFEzq1fIqOc0ctNOBQrscAEt2dJbLKqlmb1xJk0Ldr04spYuJ3FtCzZUWaWfmA1faZt5sOjAjidb6VjfyCsIePiBoJSbP6x9/MyvdUhuxu+DddBcs8NDgkUI2265IssiVhAyGTei06v25Cx6wKW9MCkJPBsRtQsR/B9m3/BUrg7X7EXv1qe+eX7HR/CgjPeL2+IdNnZXyX3L5rHsaH8jJwxgNVaBrAQPb3bgaeTyAAjtXkpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cn5aSHXHMGsJ5IPi0MxRzbSthYR7ZRrCXlgwL+VJSF8=;
 b=k9DEltoa+Cnp9Kc6ERfTfN/ynL9NuE+N5/qkIlZJNbszmx6DBqg4YfqaBX5A8JsQGSTlgsp1VKWemAEzhmVSTDdMu3wNP/+YyrwLyzPc3qv6mlZ2SorWVvIqiVEox69iTBax/Mzm98apUCUKtucK3sHpCxbpAi1UjxWFrSdFeYY=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by DU2PR04MB8983.eurprd04.prod.outlook.com (2603:10a6:10:2e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 17:02:39 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::6f90:a64f:9d36:1868]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::6f90:a64f:9d36:1868%6]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 17:02:39 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Dan Carpenter <dan.carpenter@linaro.org>,
        Sean Anderson <sean.anderson@seco.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH net] net: dpaa: Fix uninitialized variable in dpaa_stop()
Thread-Topic: [PATCH net] net: dpaa: Fix uninitialized variable in dpaa_stop()
Thread-Index: AQHZc4Sx7CErmE6dpkSIMdOFoFcZM680bIVw
Date:   Thu, 20 Apr 2023 17:02:38 +0000
Message-ID: <AM6PR04MB3976BDE554983C8AF164A680EC639@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <8c9dc377-8495-495f-a4e5-4d2d0ee12f0c@kili.mountain>
In-Reply-To: <8c9dc377-8495-495f-a4e5-4d2d0ee12f0c@kili.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR04MB3976:EE_|DU2PR04MB8983:EE_
x-ms-office365-filtering-correlation-id: 39ab3313-23b5-41c8-6ab4-08db41c10c19
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZW0Pfi6AW4EjwF1gWx6NREOGh+WO3tHR4SslLXxYOxrv2mRTYOGDyRjNx+zPdcUd8sz7ha7n4lHhvZFYTmKtOJggWrqpZYmmqzyai7OvwbawCKaJ6IcrLO/8YHGjYhMu67CGMkWmkBeBqHw0ST5b8Fk5/GRYPudB6/u9KrXflitbW3kbScIhRx6nIZkh7kWT3ilNb4LqaLZkkF/LlNm9/2s2Kco68erVlB4EG2b+Os2+Nwyg6w9m+vidSlcy5RnHHkE3Y7MXSWBp436/mLkCQLc18ZZ5r6CG9B3O8Ha7+xvPXfKm5kBzOUNzJtj4UlO0ILYDNDR2tsk+nBm/lyGQRUw6Jijg2rDs7jn9gf8ERRw1jdWkxyYTQXB9l8c9pVKZqQ/WwfYyp/fC4Kl1xbkZMnNTDoTVQu+I4zu+DW627XuoUlZtDwRPmzaKXMBURBJFmrWH1/pZJH8jZixiUwCrA4U4RXeAFQpFF55ynyND9/ao0PDq6ifkWzv637s6xFwJp37xd5W/y5H3ouY3N62KU4E6udNF0fmRxreGXKZXB8NuyNZN9M7tvBBByTcbGclzIRvwWaAH58DKJbJVgMFmfj3i6CJ9oPVWDB2oBpVhClu55Om3ItVi+2Ga0uDDksg0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199021)(55016003)(66556008)(64756008)(66946007)(66446008)(4326008)(66476007)(478600001)(110136005)(316002)(54906003)(8936002)(5660300002)(8676002)(41300700001)(52536014)(122000001)(38100700002)(76116006)(53546011)(186003)(55236004)(83380400001)(71200400001)(7696005)(9686003)(26005)(6506007)(33656002)(86362001)(38070700005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/Nby1d2a9iRHtOO3t6qwPugcb4sNH4Hm+wHDD+Amlk+7AmWVYSvZKFDiaEo/?=
 =?us-ascii?Q?c8y6ALZM3Cf1nrBoYNKJHANcS4Q0nsD6YTY4jMjC4ikqCaCqIRfDJz2yGiVm?=
 =?us-ascii?Q?6WNlTALe2ULLZi9ViY3JTcD30xY4Z5xIgu1pqJeYKC7fPuMrH2lFnSL+2ylp?=
 =?us-ascii?Q?gTbxD6TyLjlHsDYjgQHXhG4MC4UC29XTyDCz7z2WQMqJwqmkvPcdmhEnUOIQ?=
 =?us-ascii?Q?dhvSt3FcMDO7y6KY52viMcJeYTfG1O+om9MXwty58cT5O7LgQzX1tVmW1mXh?=
 =?us-ascii?Q?huT3nlGKB2F5/UH5lSilISlFxiU9UfBc94P6M+BE4BJalY3TODTb+ZkuPkxE?=
 =?us-ascii?Q?fnGySkjH4ndLvGJI+iEYbMhu6zIdSZH6JLgEeUQxmM9ECcVrEAWmmPiu83qs?=
 =?us-ascii?Q?rqXjb2HTakK+X6Oa0vuDEHhPqIM52FTTDRIHM4mqcof0lIwcaOvG9X0yO0gB?=
 =?us-ascii?Q?sjD3l05Q1E8pnPsQiZbtKs4FlZqp53XIYbNDzX+w+0PtesQhhTsQ1lWgI0JP?=
 =?us-ascii?Q?tBRezGDK88FeQMg3T61D46R/CglJNqKR0ZCZHs9J+BvQ6hyi3m3aYdZatQhZ?=
 =?us-ascii?Q?V3XeEUio1tY9WPvvjheV5trQpVSt7GO77Fp+douhZ1V6MjxDwjuCMkrG7RQU?=
 =?us-ascii?Q?OXhkTKBndzxLSAPrwDVxIS3aDhiW5vcr3qn7dlnjdPVIS/WBP1eTcxhMIJps?=
 =?us-ascii?Q?Agn79Nj2N/x7zkcxjPZEJsXzUzsvea+nqZ6yEYsWllhIeD3Sk7eCu55EfW4X?=
 =?us-ascii?Q?A/X0HIPVjYleqelsoFW5xO88UhcsrVUd6KBbEeLlm4TwUmyYlfoM8pUqCkT0?=
 =?us-ascii?Q?O1tROpKcFknhdvT0uknCkz83waJs/kBqeVMPmTRMbhy4oQImb/QvQuId32iR?=
 =?us-ascii?Q?QCQdBx+ALstfID8BPJAyPMjZnKDc+jESfRpqn1v/+Rsu8X+xHB8SqKeMkYXi?=
 =?us-ascii?Q?H9LX7h/E34/F180Ul5a5HBvVYtyKTx2jNtQ0EcLXlkZpmTgA+YDQLZWOfdDi?=
 =?us-ascii?Q?lt9ugn7QIhubtgzzd6lpHOMpgT3BLKEWcAxK8aK6T7A7Icvn6JfLLC8b7VZQ?=
 =?us-ascii?Q?Pxq+5hzENU9dq+qkKLyweHPOfjFqRkQk3UevZmWWIWDcuTV4ePGiq5h3D3Iw?=
 =?us-ascii?Q?jwPTkuO5eIyLvlLlMHxMT2T69usadivUxvY58D8dmCKgZC5xhQWC7g1r6AxW?=
 =?us-ascii?Q?moKdF8YXEcM2P9MMBTQqurqKgxdK9hmyg2GFJnQ2fEB+IPWWLWuLcp6DPWna?=
 =?us-ascii?Q?XhPCBR1McPtEfHq1cXrsERacldbyKJbUiePJqwEMiIdYLUEbxk/NUVNelsxG?=
 =?us-ascii?Q?VstgJeU/+SfogzjgCFwlNY3rFbiX60w7Jlxgr0axpuAN7IfghRfv6qGpQ81x?=
 =?us-ascii?Q?gdArLa/AKikPid6CVKc6qkCUexaFwNT/5b3zmAUTjn7cK889wpSTJukRMOfG?=
 =?us-ascii?Q?qgz0tbDXbO2LEJZhTkPU8esfuFGKVXo7FZcb85IdZu5yaG5VxYVkMs8Hcp8U?=
 =?us-ascii?Q?2JL6+4McDbdZB1FvUQLS2KLKmykKicL7fOjOe/liCJmzpDVDY3puERu2fahd?=
 =?us-ascii?Q?co0ar64Qsoz1ayE5UR5vrofgKPVZubDMyMCDnSve?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39ab3313-23b5-41c8-6ab4-08db41c10c19
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 17:02:38.9966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k4Rm0DGLpKIwUrSqXtvQCIJHmKcS/u9i82FUvQEcT3zr6Lm1ABApyRzGHn0Be3fN3CbIgq3KE6K5anC8/gKzJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8983
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Dan Carpenter <dan.carpenter@linaro.org>
> Sent: 20 April 2023 15:36
> To: Sean Anderson <sean.anderson@seco.com>
> Cc: Madalin Bucur <madalin.bucur@nxp.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub Kicinski
> <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Camelia Alexandra
> Groza <camelia.groza@nxp.com>; netdev@vger.kernel.org; kernel-
> janitors@vger.kernel.org
> Subject: [PATCH net] net: dpaa: Fix uninitialized variable in dpaa_stop()
>=20
> The return value is not initialized on the success path.
>=20
> Fixes: 901bdff2f529 ("net: fman: Change return type of disable to void")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> Applies to net.
>=20
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 9318a2554056..f96196617121 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -299,7 +299,8 @@ static int dpaa_stop(struct net_device *net_dev)
>  {
>  	struct mac_device *mac_dev;
>  	struct dpaa_priv *priv;
> -	int i, err, error;
> +	int i, error;
> +	int err =3D 0;
>=20
>  	priv =3D netdev_priv(net_dev);
>  	mac_dev =3D priv->mac_dev;
> --
> 2.39.2

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>

Thank you!
