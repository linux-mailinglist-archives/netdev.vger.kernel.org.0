Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2986D4F8114
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 15:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343789AbiDGN6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 09:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343738AbiDGN6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 09:58:19 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30089.outbound.protection.outlook.com [40.107.3.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78261168D3;
        Thu,  7 Apr 2022 06:56:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Au8SAFKXwSp3+0hie+BrEXLnA55CqV4n79aDFxFvxNT3Rz50uBuimV4pTdutv2Ff9euBrqTWBNyz+Gs1xsQblhgSbrPMlEkQwQrDpxrG8uPfOfyBaOUpO78YxfTg7dLXenLtQELuRnDgA2tEPuLAtjNN3YoO2AbzdJ2c0/CSGCBvvBNNtnQfgcql7zrJ01zjLU1NEBqPhjJDVQnznucpz6KP+g6ndA5/ZDxGZ64Ankh8GGwWHb1/AiRqxFbjutziG6rRLUoUPOHxpHAbAcwCe3Jx8t+O8BNGzcuYXyMVr8Pf/6V2GiqwKztZvXFT35H0ItOpOwB20KGvdEUWIZhCpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nt/zEvBNu8lKONeoWh70oWrEMBEw98/aRpeGEr2yKWc=;
 b=Szkelk+fSzckhzsez/LrRshsPPUwtelYrQdRegAdtPMd+AMjhYDenPHN5TJV/G9x0DWSDuXMW9mlV4qRRA0C7hRprRFTN/SPnkiv3Idq8TNutea6aWi2vXt688U1+ui47FtBAswrVzqJv6dWoTPsODYcm5bLflN+akRwDIVKIxdssa80xk77CAUkXDURr7KHyzJ9L2clgKdrZc8XoFaBs8LbJ35gIlKJkY5kogA1iNHIgi5kNEumyRX86novtWJvojJ9OioC4NGRPJdk3oQni+KtQzXM2QmreAZj6Q85+fudw8NLr+bMIlkmKAR939xZ5ofqFHD7hkS6SpONc3E9+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nt/zEvBNu8lKONeoWh70oWrEMBEw98/aRpeGEr2yKWc=;
 b=aGxT7GGy+pxZ0HXDeGMQB0kjJSBufxcCXNIwHROO9p9mOIbcAmw3hEywCDgd9UfzgOqKkUM6vCRnZEXVgv7oXRm5zYBA1poo4DXjkBaySMD3JNgF+rqWIeNJyg9k89wDtgLFc9RGu0ZHZsEEO8x5JT1jV+XzY8BmUJiMa34+n6s=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB6PR0402MB2918.eurprd04.prod.outlook.com (2603:10a6:4:9a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 13:56:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Thu, 7 Apr 2022
 13:56:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: felix: suppress -EPROBE_DEFER errors
Thread-Topic: [PATCH net-next] net: dsa: felix: suppress -EPROBE_DEFER errors
Thread-Index: AQHYSoBPV1WtqVE8g0+FLgf3++d+o6zkeXuA
Date:   Thu, 7 Apr 2022 13:56:13 +0000
Message-ID: <20220407135613.rlblrckb2h633bps@skbuf>
References: <20220407130625.190078-1-michael@walle.cc>
In-Reply-To: <20220407130625.190078-1-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d43a718d-b7a4-4591-7cb0-08da189e611a
x-ms-traffictypediagnostic: DB6PR0402MB2918:EE_
x-microsoft-antispam-prvs: <DB6PR0402MB29186BA68589B34C869D07B0E0E69@DB6PR0402MB2918.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hr8TIX7hFgAjRSt8Dxf30ulOFM+KvipkByC/Ss7KGkKK/rJNq3hBWDn0IOMQDyBdK6qvUvL78U1PjMccA9owR3SkwKYbZBYhLQs2BgzNx6WbFBiCP2EfRT7oZHI3G+Xkw0Ruyh+P+lSUrJ2zYkI3TLjtqS8uxyB1X+l1WBqpbFTMnSBKXAV+OkYkq4NFoRHzbuBUeLOr4H0nTkPa8ZknLNoTRPz8ox24Jovh90Qx7ZEU6yg6sahvPglLDANSrqJqn0rAYab56D8FLkkQ13n+zudSbU+hGIDBeUpgu/clRa1lmArw+3tQNSYYm2JxBB5+TgjE/oNIhvKVV7MQOaNdU2P/jvmsULvq+TqG/b4jUG3pSYjIvjKwS633eW890qmZebseXbLmtmlj6Qkfqzbak38TSFy3skYs9KUOKtqMoxc9vWLm08FHSd/sq9i8o7TgQ+OKJeA81pJBeDcu1hGbHlaE5CNh7UJu9NP1PnXo9+UNovSxIUtdqVJbfOdoLH1Fjd7G//nM2pDzs9xvg5VpITn5M0RAQsm1Rmxg3VTO0NZ0sNquSqOEnRwg7ab05YSxtusZmArloNcJvL2rMSXu3nNNEkHWjLM48itGUN+L2KldIsfgvVOqIk3IFqZ+GAzXohgTiA0hsVoXUnIoD3DYdzatQGDxuRptCdZtfoM0QgzMmK+b+e370jox7LbI07LMWcsXyNnNcwXz35umiVXODA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6506007)(2906002)(33716001)(9686003)(44832011)(7416002)(5660300002)(8936002)(66556008)(64756008)(66446008)(66476007)(86362001)(122000001)(38100700002)(8676002)(76116006)(4326008)(66946007)(26005)(83380400001)(186003)(1076003)(508600001)(316002)(54906003)(6916009)(38070700005)(6486002)(71200400001)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rJYLk3iV3ZVrrIRQjCeWfk63BPYWqpsAcu5ebCgJpG6gWjDaIVrS46HJMut5?=
 =?us-ascii?Q?xmsBeQzJrVH4RMxEHKe8TuSmdnhwwd0v0EA+p+XPg9Zc9jK2ljzkkdcyASXI?=
 =?us-ascii?Q?JNy9eS8RilFG3bxyVVkDkrilV3EBRS7vGemmA8SjXcVxvlbbDKYIgaNWCPQR?=
 =?us-ascii?Q?n9ooBhxxXKlWXtYFQXxgCGIhrATHY5dFLe5t9QqwEzHwDs9mGQzBwH4xrv+0?=
 =?us-ascii?Q?CIvLoF6ZcTv200oBPDVGXYZ1TymhVL42LrlXslciMypWSw7Rzy1yxcYgG5Oj?=
 =?us-ascii?Q?758a1V5TBmujjLRk+GG78pa12zAkDoU32cbr+FWzVC/RgI8ItKqJvrCCFFKb?=
 =?us-ascii?Q?OU1AIL+DGUUPfL7xIut9ykqrjExVWXgEEbyhzwLBnXme02RfBov8w+v06O6I?=
 =?us-ascii?Q?cI28Q+N/gQOYISRAR4HpiANdRPuOQinV/eMnMkAs5wi4SYKkJS3UpWjeQEyl?=
 =?us-ascii?Q?y3x7SLTVV6JHc+A5PjWaEtoT8O/AZIkrSQTP1CL7lNw0oNCv+OwK0vQIVc1J?=
 =?us-ascii?Q?6/dmZQ7lwftRr2LEEKw8X6clFeFragt5/sgL2CboX7ifDuG2JXlNvaepdvwG?=
 =?us-ascii?Q?LmiCDNvccUBsU1a8VjjLgpig8O2xtpj0RE/VFmT6wzSKluWOetJ56dEByQAy?=
 =?us-ascii?Q?sUwVRlJsxY81XfQq58wJR6DcwWH/0332MksP61WidjOnBcennWUcXKudXwIX?=
 =?us-ascii?Q?6dIjVDVVCfh89cw1L5DYTNYaj04CvqtBGDLhXOPdJ8BGfhkuMZUqCfiVNUMz?=
 =?us-ascii?Q?Dnd9V/E1df01fFYnvJRqOOnimPUzyrMG3zDJ0HC3l68ov2tuLdiFYlZ5tNaZ?=
 =?us-ascii?Q?he/8LtLXNwRRLBip0h11vklFlZ0fw+v0iZz5EkvpdwM995RVdf7e3mSzh0m6?=
 =?us-ascii?Q?dXrR4q1GB+6Ob9x0Q8GTowOND851KVA5E29DauWYM0vY5dfZahXE8mv5Qc2c?=
 =?us-ascii?Q?Oie9buX9D37Oz9aMhB6+Tt0bSAgnexOKaUtVgk6XC8ibYB65nMeO9DdcFOqr?=
 =?us-ascii?Q?ru31chCfir2kUxJntbGWSHirM0jiMnCBDIW8KPI2MpN44/kJd3yGi8DhtRKf?=
 =?us-ascii?Q?HDLfuKprLWQtOvrz/wJkE/qQfDVNrntw7f4lP9AosmfbJwHhT2Z2M75LOUEd?=
 =?us-ascii?Q?AsP8tUaV0POAyK1eS62XiKos2dv2ILuIk7Eq3jcRn2pL9cmLVmlBYg0ycuIg?=
 =?us-ascii?Q?8o1s54j8Cx9kH6k2k5s8qK1UQQGau3uwPNsx13nNKSlR1vllirBn9no6aLCt?=
 =?us-ascii?Q?6Wu9MM6hYLQHW5NYH9LSOt/ZgyZDZX7ANqoST2kVB/5mevducetI1pBNBZcy?=
 =?us-ascii?Q?dW+2Ox8J6mgQLw66dTlVEo5x4OumT9mX7j+lMhQ3NLtg3st0EI1bX5R/fTuP?=
 =?us-ascii?Q?txCzdvpNzC7Q/Fou4JjeRHHi9ktZwhhaaUtkpPwvI+ziuao+EYL2jaE/Asw5?=
 =?us-ascii?Q?OOVo3C9PPH3Y4JX6W4rLpqwpIk9g0tnImvfZ3Mm70fkygF7VqQNsE5ZuRzm6?=
 =?us-ascii?Q?2h1ryfIyI2kzQes4JF1AIvueHEArYw8FOM5P7v/rFFOAHdgN/a9Xkl6yS1Ke?=
 =?us-ascii?Q?G3P4bCESZJNTKqOXY9YrtoArLjnNQrxk1lCxC0FuVpuYE1YUi8uXG25S4/QQ?=
 =?us-ascii?Q?CjIQu4P8KP9d1pIYl0Df28Y1EygWWpapkVljXLQbdvq5JGb5Tw0YBdswD36s?=
 =?us-ascii?Q?TodrmtEaJZfe3S0fjjMxkBygT+EtwQO3Rj65w1GQBwFHl2OgZIfNlLZJOeLH?=
 =?us-ascii?Q?C0STBukAUmyFe1ke1HRLhDAcKt6ISoc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23A71A0806DCF1419C2A5AD9514C015A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d43a718d-b7a4-4591-7cb0-08da189e611a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2022 13:56:13.8434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XCDIfsm1kx5v43Momw5+s5AFFSBTXaOGu5lYQGSwDL6UxUGP0b1ukrUclLQYD064tBv/xQ/mN/1Huf9Ahi0NvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2918
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 03:06:25PM +0200, Michael Walle wrote:
> Due to missing prerequisites the probe of the felix switch might be
> deferred:
> [    4.435305] mscc_felix 0000:00:00.5: Failed to register DSA switch: -5=
17
>=20
> It's not an error. Use dev_err_probe() to demote the error to a debug
> message. While at it, replace all the dev_err()'s in the probe with
> dev_err_probe().
>=20
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

Please limit the dev_err_probe() to dsa_register_switch(). The resource
that is missing is the DSA master, see of_find_net_device_by_node().
The others cannot possibly return -EPROBE_DEFER.

>=20
> Should this be a patch with a Fixes tag?

Whichever way you wish, no preference.

>=20
>  drivers/net/dsa/ocelot/felix_vsc9959.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/oce=
lot/felix_vsc9959.c
> index 8d382b27e625..1f8c4c6de01b 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -2268,14 +2268,14 @@ static int felix_pci_probe(struct pci_dev *pdev,
> =20
>  	err =3D pci_enable_device(pdev);
>  	if (err) {
> -		dev_err(&pdev->dev, "device enable failed\n");
> +		dev_err_probe(&pdev->dev, err, "device enable failed\n");
>  		goto err_pci_enable;
>  	}
> =20
>  	felix =3D kzalloc(sizeof(struct felix), GFP_KERNEL);
>  	if (!felix) {
>  		err =3D -ENOMEM;
> -		dev_err(&pdev->dev, "Failed to allocate driver memory\n");
> +		dev_err_probe(&pdev->dev, err, "Failed to allocate driver memory\n");
>  		goto err_alloc_felix;
>  	}
> =20
> @@ -2293,7 +2293,7 @@ static int felix_pci_probe(struct pci_dev *pdev,
>  					&felix_irq_handler, IRQF_ONESHOT,
>  					"felix-intb", ocelot);
>  	if (err) {
> -		dev_err(&pdev->dev, "Failed to request irq\n");
> +		dev_err_probe(&pdev->dev, err, "Failed to request irq\n");
>  		goto err_alloc_irq;
>  	}
> =20
> @@ -2316,7 +2316,7 @@ static int felix_pci_probe(struct pci_dev *pdev,
> =20
>  	err =3D dsa_register_switch(ds);
>  	if (err) {
> -		dev_err(&pdev->dev, "Failed to register DSA switch: %d\n", err);
> +		dev_err_probe(&pdev->dev, err, "Failed to register DSA switch\n");
>  		goto err_register_ds;
>  	}
> =20
> --=20
> 2.30.2
>=
