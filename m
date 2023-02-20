Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E759069C937
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 12:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbjBTLDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 06:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjBTLDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 06:03:35 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2132.outbound.protection.outlook.com [40.107.114.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAE57EE8;
        Mon, 20 Feb 2023 03:03:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpFN7U4rLsEBfAY8YwBcZQEMmbYTgXUY9a8+9q5lFA0gRmzyBXECsqcpeoPuNHM0ximSE9ge2zxmI9UnJSNfPvj13GPDrCyrWwJRdsUEDeOlFWslrJ1m9gP2bn9PSGk8/tgINKos+q4mG1yJk29llFr2loW2SDLuQxj1JeSkp/MhFzgG1nvXvCYrtdzIK0khvqL8hL5jhqJP6IfJgh/DJus6vQHKIWoXgGRxt44Y6wgJFa5AZmU/xacP5wgOBGc3g4sxQTANWBGpEmXRVTgEotRKC8+VVQtRpZSg9gE3L6aYIBzZy3aRqx/7Q+io7SqIOyAPNpBJM3yevcbEFClc5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sxdORYDv3Yb/huugWe4C5yo2RM/ujy63SPJMp8W9e/g=;
 b=aQDLHjfNzp2abHQqNOYNGZFyrz8SPYSqyr98FVZAiQ1P6itIqHK5IFwAsN6uueGXPzStpcF+k5F4Uq8vlti/ypNHMUDpTpkK81IoPejrsBJp6UxD3C4w+UIc1kFu9wl2e2h3jHaNE9GNloYxBnNBRCcPkAXI1A0UMFCpQmRp7u7nux65oww8BSKF28F6RglmA8Boe79Df5nFpjBGf2+g1EbRKEDhRcs3pV4YhNYgauO5iTJNIN6B23pUxMoIIhUv8G7n2QeE8Jlxe0suyRFo/Od3L04MwAvHrvt8786MOGBlTq+ATXuvz5VJxtCBI61ejPGVk7lS4ZG3MuIugTuECg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dm.renesas.com; dmarc=pass action=none
 header.from=dm.renesas.com; dkim=pass header.d=dm.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dm.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sxdORYDv3Yb/huugWe4C5yo2RM/ujy63SPJMp8W9e/g=;
 b=FjFnUXT61Yz6Prm5G9eJGXW/nu1hU8MvmjjEaCM9iAzfyQKjLJJxHjE2Bnx6RqR25QYmhzB2tUSCaKuHKRF5gM+zSyXbXMupA0c0UGzbnBr3fD44i5BmFcF5LlOYQawlW0QiV089S1zawQKOGSmC3Bf2Yf4MmIgL+y5jY4r8I+4=
Received: from OS3PR01MB8460.jpnprd01.prod.outlook.com (2603:1096:604:197::13)
 by TY3PR01MB11211.jpnprd01.prod.outlook.com (2603:1096:400:3d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 11:03:22 +0000
Received: from OS3PR01MB8460.jpnprd01.prod.outlook.com
 ([fe80::e332:554a:7:7135]) by OS3PR01MB8460.jpnprd01.prod.outlook.com
 ([fe80::e332:554a:7:7135%5]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 11:03:20 +0000
From:   DLG Adam Ward <DLG-Adam.Ward.opensource@dm.renesas.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        "rafael@kernel.org" <rafael@kernel.org>
CC:     "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Amit Kucheria <amitk@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Markus Mayer <mmayer@broadcom.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        =?iso-8859-1?Q?Niklas_S=F6derlund?= <niklas.soderlund@ragnatech.se>,
        Heiko Stuebner <heiko@sntech.de>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Talel Shenhar <talel@amazon.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        ye xingchen <ye.xingchen@zte.com.cn>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Tim Zimmermann <tim@linux4.de>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Jiang Jian <jiangjian@cdjrlc.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Balsam CHIHI <bchihi@baylibre.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        "open list:ACPI THERMAL DRIVER" <linux-acpi@vger.kernel.org>,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE MONITORING" <linux-hwmon@vger.kernel.org>,
        "open list:IIO SUBSYSTEM AND DRIVERS" <linux-iio@vger.kernel.org>,
        "open list:ARM/Allwinner sunXi SoC support" 
        <linux-sunxi@lists.linux.dev>,
        "open list:INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN)..." 
        <linux-input@vger.kernel.org>,
        "open list:CXGB4 ETHERNET DRIVER (CXGB4)" <netdev@vger.kernel.org>,
        "open list:INTEL WIRELESS WIFI LINK (iwlwifi)" 
        <linux-wireless@vger.kernel.org>,
        "moderated list:BROADCOM BCM2711/BCM2835 ARM ARCHITECTURE" 
        <linux-rpi-kernel@lists.infradead.org>,
        "open list:ARM/QUALCOMM SUPPORT" <linux-arm-msm@vger.kernel.org>,
        "open list:RENESAS R-CAR THERMAL DRIVERS" 
        <linux-renesas-soc@vger.kernel.org>,
        "open list:ARM/Rockchip SoC support" 
        <linux-rockchip@lists.infradead.org>,
        "open list:SAMSUNG THERMAL DRIVER" 
        <linux-samsung-soc@vger.kernel.org>,
        "open list:TEGRA ARCHITECTURE SUPPORT" <linux-tegra@vger.kernel.org>,
        "open list:TI BANDGAP AND THERMAL DRIVER" 
        <linux-omap@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: RE: [PATCH v1 01/17] thermal/core: Add a thermal zone 'devdata'
 accessor
Thread-Topic: [PATCH v1 01/17] thermal/core: Add a thermal zone 'devdata'
 accessor
Thread-Index: AQHZRG/HAV0yCC5B/ky2ximBKy+xBK7Xm3sw
Date:   Mon, 20 Feb 2023 11:03:20 +0000
Message-ID: <OS3PR01MB8460E7C2D1F9EEEDDC579FFEC2A49@OS3PR01MB8460.jpnprd01.prod.outlook.com>
References: <20230219143657.241542-1-daniel.lezcano@linaro.org>
 <20230219143657.241542-2-daniel.lezcano@linaro.org>
In-Reply-To: <20230219143657.241542-2-daniel.lezcano@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dm.renesas.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3PR01MB8460:EE_|TY3PR01MB11211:EE_
x-ms-office365-filtering-correlation-id: 788211f2-3989-4bbc-8f16-08db133213f2
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uCfhYzWDGNTVnEr4JJ5QwHA0cMrhv5MRkoTXepdpb7OlukecvhDtDs3+E+e6wXIPBpfh5rIF2jaAilrwUPwaib0RIfIq9OitosooRHZk14w9QSjrM9VGw8zPXdcAXq7/KeVIrsVAVQPM1sk7BoJRpj32HJfRNU7joVNwonc/+rJluFDzKkhpFhZwHT0S48IoKd6+kgEsUiEiZJIrzVdu19CkmV+vE2v/2POmDHU5hnlwQSRGk53DgUYtWB9OhyJfvW0bR2kSyqTCbEGZXu0UkwQEOt16a3xouwYPKjJX1e2OkpHk1IOGyH0PRdiuEXJshU2q4B2KCU0pDNmNFOvOrM05YqB4Owj4I9w61sPJfg8YOgS/bnYix4o6frxPBXwVpevjdMeTklVZYBgfeujv0jG+XnBqqUq1c0n2Gi+8ruRDlDVtGEZ9pHiw7MV0BVw6Vn+brUqLYNuW+qAq/ekQTeXcSmzGIqHxtkqatOM/f43vTSvhtA2Hxkq5UhAuejZ0gProyRs9v8p9cRo8FplZVOR+tjHyR0xtORzi1v8ocQLlcwR+dzOec84FCRBp+rIqQeyjvMoRoPZot/PkC5hE/yq7Fojt1hn5ehIpgfwzqFlSoWrSIT+Yrxe3oSd2gBvDhCgLGwwIfEE8j8uJD6uPISpampODqPVokHr2DdTw970kzYgzN4DfhJf3obdns5xXIHu7mI4xzwPEuAVJp0mL9A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB8460.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(396003)(346002)(39860400002)(136003)(451199018)(38100700002)(2906002)(9686003)(26005)(186003)(41300700001)(38070700005)(6506007)(4744005)(55236004)(122000001)(53546011)(66899018)(7366002)(7336002)(7416002)(5660300002)(7406005)(8936002)(52536014)(478600001)(33656002)(316002)(66946007)(76116006)(66556008)(86362001)(66446008)(8676002)(4326008)(64756008)(7696005)(66476007)(71200400001)(55016003)(83380400001)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?1XbjwtegscZo7kGLcEprJGXg72vK7xBbWWtC/M5D/Z22wJfLEqDMQKZ1dS?=
 =?iso-8859-1?Q?qe8NCGBMX+oBIhwXXREj5fYduP2MP1K76t+S69MHXPW3LXnKSzq3SLy5sj?=
 =?iso-8859-1?Q?4k3WpnIcd6mKHJwHuBqvCtX76/JBK/O1MYwG8tZv+M0g+s9IMPT4zFldo5?=
 =?iso-8859-1?Q?9wPkLCtvsesi+x/G3io5kplE40Of+3hecvDnlB4grl+bC8JDdd2ftGPK8Q?=
 =?iso-8859-1?Q?oWRjAksDJ3RrAOfEn25t94E4uL6cJjihgtaA7MmLnMrF9Hm8ajyIJnpZS/?=
 =?iso-8859-1?Q?KloiUidBLQ7TLdPHzj2nIn0r720qkgXE6SL4T4PzK7rjjtg7cURXtdqfc1?=
 =?iso-8859-1?Q?9j3HCCDvMvdTrb6n+sY1tFFeUflBQ9Dn7Up3zLG3q11UrklhhW/2csS/ei?=
 =?iso-8859-1?Q?+AJg1j2SS6O0JVJwNH0I7xz5ytnT5w1Brg9KOH0SGOvBYGTEZjaCWRbPB+?=
 =?iso-8859-1?Q?ejQofc7vPOzA0j9U1zdC0qcXxM8l0GdgppbuoSq04s2/2vNh2m1i0hA42q?=
 =?iso-8859-1?Q?MIuQ474Qo/YQHy5lkzA2BDNVN2x5/9ZxbAAoCDyXmElSd4gqdoyLLuYybW?=
 =?iso-8859-1?Q?kD9PwPiocuoSIgGeWiTAGILR/TGlBxGYZu5hdLsBlJBZ1vA+pGqWBPO5/3?=
 =?iso-8859-1?Q?GcFEO9UDAM7x6+xDaCu+rU6Bkc5sTNvXwI9arIaJRJoBoFVFH+ACKaWaAd?=
 =?iso-8859-1?Q?l59eA8Yk9SwvnnMi+nwhpFcDUnc2v0WHrS4KcIT73qaZ/axJWyhbozkkWX?=
 =?iso-8859-1?Q?U+wieQFgyS/r1+GP24d1Fha6CDaHQvsaUfYXo0j/d1QwIRb4TkDVt9DC3F?=
 =?iso-8859-1?Q?u7tk4jvjZ8sL9XLO1wBEZ0SBMP5mTIqML8Njs5hj/a+JUlWRoVgUJ6Cr9P?=
 =?iso-8859-1?Q?hZ1p3gxtMmHtLhrdYGLNHw8mcimUbnJ1i2wjweKYbFRTEinexJ0elB458J?=
 =?iso-8859-1?Q?dCqJDl8R55MpllB559aUvFsnHUChF7qynKa02MYjOwn5dA1v5ScHnfS2U/?=
 =?iso-8859-1?Q?2Bu7ArQnoBP5zRw6QRqZEEQ1XOEk+s8rnoJVXo/nrPMYoLy0XjmFucMFhl?=
 =?iso-8859-1?Q?NcJjMKu6Gkw67TGEJbqY+2JbYW/5I8m7BSjKwwhsW24oGtwW/DfXYMHI9b?=
 =?iso-8859-1?Q?/EHjdJpknMWiqjnqZIPPjh6DaBgdyJnNOgNikBUkVkoLxlNvFhgY1FWKrI?=
 =?iso-8859-1?Q?jFvBe6YhJDvXPnLkEYGhxk7eTtgP6GdBeGX2/CPn1/r8uqZ2ZYdyEcnIjk?=
 =?iso-8859-1?Q?GQVow9PKXpEvRuRd5Z8TMeoHX6tnF0ZwpdaLLNoh6GRuyKcI4+JMKdosyn?=
 =?iso-8859-1?Q?AYmTh9slFIMRc1mEFLlR8yxLlpmrSz4vAOZQYxqD+jDlbY/b/z3lFD6UhM?=
 =?iso-8859-1?Q?hd1kfHts4NtFbWtoXbY52sdza8Dw2x68MdxvsJD52GMiJ1y/qBRGjwP1Ex?=
 =?iso-8859-1?Q?AzEBm/0xQ+vCeZ/hdtKsAGhZHX1KWNuwLTt+Es9bboch9sYlDyyaKZwWLD?=
 =?iso-8859-1?Q?B8+rFRJNSr7TEbDgwnIjnpa9DJvrC2G6uce4slZMP/Y+CkAvj0g4y5W8aE?=
 =?iso-8859-1?Q?1R8md1xAMn3lP6Nr8WEjer07DvbPdZCvrTyEfU+mK3mxGilK6C5MahLq9b?=
 =?iso-8859-1?Q?4m7MYMjGuhyBWipldQxq45SeVYYjAY4IGYKRKQqeKJr8K6zQYi0UsdYQ?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: dm.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB8460.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 788211f2-3989-4bbc-8f16-08db133213f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2023 11:03:20.6544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yqnfzFAFLehgsME97tmK83Bee4AKD5t8sGglI5q05BlRF9+r9+i0Eyfe6pUV0TKqKoQLCzWj5rUqe2Hgle2XehsKYWozDDi/o9UJULWK8XM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB11211
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/02/23 14:37, Daniel Lezcano wrote:
>The thermal zone device structure is exposed to the different drivers and =
obviously they access the internals while that should be restricted to the =
core thermal code.
>
>In order to self-encapsulate the thermal core code, we need to prevent the=
 drivers accessing directly the thermal zone structure and provide accessor=
 functions to deal with.
>
>Provide an accessor to the 'devdata' structure and make use of it in the d=
ifferent drivers.
>No functional changes intended.
>
>Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>---
=20
>drivers/thermal/da9062-thermal.c                 |  2 +-

For da9062:

Reviewed-by: Adam Ward <DLG-Adam.Ward.opensource@dm.renesas.com>

