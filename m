Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46DC6415CD
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 11:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiLCK3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 05:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLCK3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 05:29:15 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2104.outbound.protection.outlook.com [40.107.113.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63205F48;
        Sat,  3 Dec 2022 02:29:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhYY1g+nxpScm9yhtPP4EFCieE1Kh4EYmaoqi50I8UKPbe97GOw+nsGKQKUVktiyLmtLizAkLXLGzvpQ8DUcrGi/5oxW82siy0f61OGuRcUmrCWfpA9psFaxpYdPxyuqyjrNO1hx4oLHydZFkBPBzSEKnSYu5Ne058Vta3LC9YmvKxAimOFX1XIALYPwMX8MWNAxtpSNYz53KQcNpVqCmFre2fr4+dDhFg5lIlJRSng3xXTL3JMcJHzx1YaX9y7DyvfxNt5BT812d6MSpNMb0B7oqE29b9NE+hf6NlpjknLKKMBfDkrJl+z/Bod0SXGgIRMK3YpuB1ldhjueNGYLtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9tlFCTwMr31Soa/yrS5Y/KSvQS6dN6aUxIA+qyim+g0=;
 b=ASc/6uWsZtu/ihbO8RD/77Jz2qEgQnLPBtF0c7Nl9zGCmBVEpEvXWVSlX8wGX/2QQEktzlBcFiPb1+bxlwdyDkeRr/aQLyHTjwP3HVfFcxG1b+kjHzTz9f9cBd3zx8wXSZb3YfZGPluHYdfCAV2Xle/s1GQYYqHGnIu1fkkaSjHeLngJoGXYIcJHnK1+7eQvsg2WwPpbI7i5/YVBhzWH4OhSMSxhnMHa0oYBTYdDKEbCpq02Rojz6P5jD5uxHKYyO8cx3YJaUiTRJRSHdIBghXU9exEfWD/8BIJocwMFRNkirl67YoFK74oAdMpMtghMijZxt4UPugszmJ4qO2dxMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tlFCTwMr31Soa/yrS5Y/KSvQS6dN6aUxIA+qyim+g0=;
 b=bTgeSU4J++qaGOMJPYxhCdC8Y4GzzDxMD/vTSfusWUiFsZNQcQHdGKaixblgA+Q+nuReecXvdITcShFYqac2rqTeKSJGSErxXglRfNr/+DH0unluW/lBlgvKRWHCfJvANYbWvZ1AkFZpzNrYuStncPUAhKoi6ZeFDbQNjy1lqkY=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB7826.jpnprd01.prod.outlook.com (2603:1096:604:177::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Sat, 3 Dec
 2022 10:29:09 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::2cfb:38d2:d52e:c8a3]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::2cfb:38d2:d52e:c8a3%4]) with mapi id 15.20.5880.011; Sat, 3 Dec 2022
 10:29:08 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "s.shtylyov@omp.ru" <s.shtylyov@omp.ru>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "phil.edworthy@renesas.com" <phil.edworthy@renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] ravb: Fix potential use-after-free in ravb_rx_gbeth()
Thread-Topic: [PATCH net] ravb: Fix potential use-after-free in
 ravb_rx_gbeth()
Thread-Index: AQHZBvnifjjXKLvqgUuypcFW2XI0pa5b8fDQ
Date:   Sat, 3 Dec 2022 10:29:08 +0000
Message-ID: <OS0PR01MB592214C639E060C5AD3A67BF86169@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20221203092941.10880-1-yuehaibing@huawei.com>
In-Reply-To: <20221203092941.10880-1-yuehaibing@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS0PR01MB5922:EE_|OS3PR01MB7826:EE_
x-ms-office365-filtering-correlation-id: 544154a6-0707-467f-94fb-08dad519360c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S19/KBxkx/yC5Hc+gdRrveDDw4D4iet09YYmLdCmgaKDI+ZTKINeSGvqVyUvkQugnuHV+88yt3MmrFUigZH1wqnRJVPvsXyldIZzwUHqZSv4GLOq5J1SwWH79Dlav+5eYX8FavZhYmVcpdI99cjnsmWQ2wf8M0exqRjmm1YZmCC6C/eVfCpS7HYhty9teYezfkyD9j3a+2lJIDAnroz/h6xeYQGsRO1nqfnooOxpuAPd2lw4qsFENBJZtwHNv+secO98bfTmc2NBnXSWPFUbhWwZQkxVbaFez0g/K1dFFXYi7xXcs/tsW65dzaXUPyRITjtj0SthFPpjdfdKOYx0zC/4rBqMxx5Iu7wEAHssobWvuAzYfdur9vZNfenadjGV4PRdRfWNxGM247C6lC1D/CJLrmJwF+CbPILXTlda+312wEe1Em1hBBgm1mH9aZx7s/l7eJLLRnqGn0gLovsP31mXU7E2hu8BQ7aRN6Yd24W4M4gUzyoa4if5wCK7LlrMf9GT7YLB8746wf1X1aZcNc+8YkOvKHvieR6R7Kug/J1TyAsFXNtrkrYaF26JGhHaR5ekDlQRYj+B6YVuN9AjBxPNGpe5yddWM3rURFCy10TpATf1x8dyJs7lJdWhvkWiPCb0EzDpx5OhDK4zsmsuqNBeMexplhos0xeyUDbj/cIKnaYPFvSjnTnroASo9Rs20lwx9OyOnx8aYJH8qTs6rQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(451199015)(38100700002)(33656002)(54906003)(55016003)(38070700005)(86362001)(478600001)(71200400001)(5660300002)(8936002)(2906002)(8676002)(66946007)(6636002)(76116006)(66556008)(66446008)(64756008)(66476007)(110136005)(316002)(4326008)(41300700001)(52536014)(83380400001)(122000001)(6506007)(7696005)(26005)(186003)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ogekbapocxOJPM0nUTFUINYpg6fLe3JD9FOrofDRc0DipwS48+ZCpWvOje68?=
 =?us-ascii?Q?fZAUhX34OMi5nii4zhb2fu7xMr0n9qcUPPVgaQwluJyNBuUUO05yc3LmtdG7?=
 =?us-ascii?Q?Yo3rmBGs1/j7GTaNFq1/4GTMrXgm11IDZ8ZuwDpCco5Vgwd1Ai6pIG/EegTu?=
 =?us-ascii?Q?A+4pqGhRw09R4yWRkLJIJiyJZJWxKVt++FUjhkNdh6rN88HUq5LYLcvwo43I?=
 =?us-ascii?Q?a7nb6Nin59BmtklGOqFo+wPa0LLcx5XD7wyOH/9KtsJnXV7t+ixOEvdF19xV?=
 =?us-ascii?Q?EoTWm2HO0DNqTFQhy7aguYlUDNwXxJRrCO+wjV5gXwuPAd9fyW5tk+XyxJ3M?=
 =?us-ascii?Q?ng0z+B7WMWct9syAsz+6dVQWQi+4TQBBSL5Gzut/inbZqpwl4KXn+Cogv+ql?=
 =?us-ascii?Q?ZbfHKEQzQXMA23EV12b1mmIsW8MYDk2H+OxhvqtI7s7jL9pmwdmtci+/phMz?=
 =?us-ascii?Q?C/Pc6fTCB88NNjusRnChjLwnJyFVenEkwZNun6wPxbl1b1lEnUUeGPPBrEJU?=
 =?us-ascii?Q?/iBW6pyA/nkBNN7nbXDdNkbjVaatVbyOoaFCc2lLslykfYdZRXQgyV2+b2ZA?=
 =?us-ascii?Q?SRT6bfMc7BO23E780QUkZc8Ea3YqLy6v9aJHSuR7Dx6toG0Hyj6abQHcnCvJ?=
 =?us-ascii?Q?YtNgiuy7KOvYKI6G/JQr3QeXAD32dXWfb91w3aRJAuETtiRhKdeDC6Lg4Axg?=
 =?us-ascii?Q?zNPhYMf/hvwv1LMvzvB9e3bTj3OSR+74tRQ9LJQL2QWrJxcg303LeEh0ra1w?=
 =?us-ascii?Q?vWVd5N96OETQO66h/OofcTwqE2NAOc5Y99S6PM8wvaGSiH73gcA2IqgqYz+v?=
 =?us-ascii?Q?Tx1+JM8AGweRztV9byShkl0axi1pTLSFm6cb1pYxI6Xkoo8eh+CvkNDWfO60?=
 =?us-ascii?Q?44ImWhxDiQJq6VGW6K+ZPGYS7raCLvsbyvKeqGHooWZ/y8rzSZ/2Gs3kEVvq?=
 =?us-ascii?Q?lGyNUAu6F7wZrMKXeMMygybx9w1pUa9T2b4babuUQ+CzVpt4RbhIgFpjreXz?=
 =?us-ascii?Q?5gakXfFzhTqH4qls7wCxnEAuq9Ev8JiEXloBR8B7ZTPYrvWo7MYhMBmnwI4y?=
 =?us-ascii?Q?bwkyJCkLMoA74x4bOcEP/s4wuwwYHZLFdUGkW43Q7sX6iGOhRSD3ixGhl1Eq?=
 =?us-ascii?Q?p5CToTEKF4vZ4iQ84lODLuNAf+q6v6eERKdT7NPv+vptifA+hOyn2SDO9MbR?=
 =?us-ascii?Q?qm+6KepZk3CEoTkM4iEgsS+bNOH04MHp84NWBrly5VcyZ7Hgrnzy9+bAbdiE?=
 =?us-ascii?Q?UcKyQOYr6H4wLBdiRgQWVVhJGKU8s+rus19RzIkwERzM2ouuJCpepWtkp8Xy?=
 =?us-ascii?Q?K95nmSE67tIbfN7CBpZknFiKFBaEnoWIB5ZCLsfZe2LSCaJMRdIul8GD2iOJ?=
 =?us-ascii?Q?UcX3gq9agNAJBI53FjUqnWX3VjCHGcq53/IJ96CG3isQwcTNB61M74HS1+XV?=
 =?us-ascii?Q?yJVO/S1FYiOUoBeh7XIT3Vjl/HNjphGycCfqbfGOuoNlQ8jliaMWvDDOlzUc?=
 =?us-ascii?Q?XhMQP8IBEf/+zTLdkWzLrikBGWb6Pe0sauB6Z2NKwMsKTiWttFoQFJ5cQsIv?=
 =?us-ascii?Q?hpXONdD6MEUWO+u6NPOehIcuDjdimYkNHZzFhzZG1yf5f5F2ULOwY7BB2agI?=
 =?us-ascii?Q?qA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 544154a6-0707-467f-94fb-08dad519360c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2022 10:29:08.3564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9txMPM9iJeytrUFmbaph765Vcvk8yXn2rZIad54U8yp3WqGRKmqODdV8WkZzRgFwKR83uVLYqGztPrL8j+JwaZD35yUYJplFBa8+Wtd2V8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB7826
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi YueHaibing,

Thanks for the feedback.

> Subject: [PATCH net] ravb: Fix potential use-after-free in
> ravb_rx_gbeth()
>=20
> The skb is delivered to napi_gro_receive() which may free it, after
> calling this, dereferencing skb may trigger use-after-free.

Can you please reconfirm the changes you have done is actually fixing any i=
ssue?=20
If yes, please provide the details.

Current code,

napi_gro_receive(&priv->napi[q], priv->rx_1st_skb);

- stats->rx_bytes +=3D priv->rx_1st_skb->len;
+ stats->rx_bytes +=3D pkt_len;

Note: I haven't tested your patch yet to see it cause any regression.

Cheers,
Biju

>=20
> Fixes: 1c59eb678cbd ("ravb: Fillup ravb_rx_gbeth() stub")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/renesas/ravb_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c
> b/drivers/net/ethernet/renesas/ravb_main.c
> index 6bc923326268..33f723a9f471 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -841,7 +841,7 @@ static bool ravb_rx_gbeth(struct net_device *ndev,
> int *quota, int q)
>  				napi_gro_receive(&priv->napi[q],
>  						 priv->rx_1st_skb);
>  				stats->rx_packets++;
> -				stats->rx_bytes +=3D priv->rx_1st_skb->len;
> +				stats->rx_bytes +=3D pkt_len;
>  				break;
>  			}
>  		}
> --
> 2.34.1

