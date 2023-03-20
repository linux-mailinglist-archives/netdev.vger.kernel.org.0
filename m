Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6A06C214C
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjCTTYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjCTTXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:23:49 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20629.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0447B44F;
        Mon, 20 Mar 2023 12:16:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RACw5RYSyl7LZ9z6xbZiim5EEUL3YPeeyhf6eeSg+gNZ0YgQE6oiHVR0NI64bj0NQXm6TWWY43cg9NUcYZrVjg0RxyjOk42TYWXat4CD4tcsi4CNjRXxWxBePNsgfiKhgMdS0tqtAsDPvWimvRYfy9AWRfLxo+4TOq65+wgTfVbbx+On8W+fUqj4lcfbrD8wxl8cuwju3OG/YRazN5Azq/f9Fhdx3ncKqBYeZnl38vWhEbv3yemfNWJLolg1g3Yz3C1dc+tF1PwbtiD9UP4N5IXg5z9kVT9sJkOltZgfI3lDaFcPfWAqrwk8bTp4CuC82vWqrEy3eiLK4yIwudrg0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7aDunJbHc/3kZMWGnOKJzlXPYN3kjtGY+kOX1lrgU4=;
 b=lZuD4VHVKwr+qITlIihrz6aHwaEl/wNflZVnh+hAumO36CrYG69Gr1ASO3VohuZ5NG1Ek+HiOMGJ6ZuqSi1LnWFnl514hpZ7VW1EiPwb1fujytyMU7TURzvUIFD/enlxKSL3b6K4quKet9+xNhlMRzZYch7jesyCakR/igezn2Em1r6VtuheNGpiQVdQ8IIo9UnYLBWBnfPJbXinNJujOqG6Q/6MUGHZyXDPj8EUJ7WhmsT07bXnmzNe0cGBNPxapxz/K1ZhqVXBHLTbSWcnvfLl4K8lesRutRmopRUd8Zo5qyer0mU9AmMG0yL5/ddpf9jXFWs0hi6mV9iHq2Mybw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7aDunJbHc/3kZMWGnOKJzlXPYN3kjtGY+kOX1lrgU4=;
 b=5G2cFLNcVPuGlt3HAJkWQL0sWvXhRSODUZvxZnwtHwxRM2//BpBQHp6P/qQPyg2wVg8h9HVqZK7SVn5T0kca/X04AXP3kXEBLk+tFHHTrySDYlyPYRWQLjPiGBphfkXw4bMr92wRF7LiMMLzJ//0Ynh2RLtUaJkAbq+PB16AUaA=
Received: from BN7PR12MB2802.namprd12.prod.outlook.com (2603:10b6:408:25::33)
 by BN9PR12MB5099.namprd12.prod.outlook.com (2603:10b6:408:118::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 19:15:48 +0000
Received: from BN7PR12MB2802.namprd12.prod.outlook.com
 ([fe80::96c6:f419:e49a:1785]) by BN7PR12MB2802.namprd12.prod.outlook.com
 ([fe80::96c6:f419:e49a:1785%7]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 19:15:48 +0000
From:   "Mahapatra, Amit Kumar" <amit.kumar-mahapatra@amd.com>
To:     Jonas Gorski <jonas.gorski@gmail.com>
CC:     "broonie@kernel.org" <broonie@kernel.org>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>,
        "richard@nod.at" <richard@nod.at>,
        "vigneshr@ti.com" <vigneshr@ti.com>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "tudor.ambarus@microchip.com" <tudor.ambarus@microchip.com>,
        "pratyush@kernel.org" <pratyush@kernel.org>,
        "Mehta, Sanju" <Sanju.Mehta@amd.com>,
        "chin-ting_kuo@aspeedtech.com" <chin-ting_kuo@aspeedtech.com>,
        "clg@kaod.org" <clg@kaod.org>,
        "kdasu.kdev@gmail.com" <kdasu.kdev@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "rjui@broadcom.com" <rjui@broadcom.com>,
        "sbranden@broadcom.com" <sbranden@broadcom.com>,
        "eajames@linux.ibm.com" <eajames@linux.ibm.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "han.xu@nxp.com" <han.xu@nxp.com>,
        "john.garry@huawei.com" <john.garry@huawei.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "khilman@baylibre.com" <khilman@baylibre.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "haibo.chen@nxp.com" <haibo.chen@nxp.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "daniel@zonque.org" <daniel@zonque.org>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "robert.jarzmik@free.fr" <robert.jarzmik@free.fr>,
        "agross@kernel.org" <agross@kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        "andi@etezian.org" <andi@etezian.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "wens@csie.org" <wens@csie.org>,
        "jernej.skrabec@gmail.com" <jernej.skrabec@gmail.com>,
        "samuel@sholland.org" <samuel@sholland.org>,
        "masahisa.kojima@linaro.org" <masahisa.kojima@linaro.org>,
        "jaswinder.singh@linaro.org" <jaswinder.singh@linaro.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "l.stelmach@samsung.com" <l.stelmach@samsung.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "alex.aring@gmail.com" <alex.aring@gmail.com>,
        "stefan@datenfreihafen.org" <stefan@datenfreihafen.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "james.schulman@cirrus.com" <james.schulman@cirrus.com>,
        "david.rhodes@cirrus.com" <david.rhodes@cirrus.com>,
        "tanureal@opensource.cirrus.com" <tanureal@opensource.cirrus.com>,
        "rf@opensource.cirrus.com" <rf@opensource.cirrus.com>,
        "perex@perex.cz" <perex@perex.cz>,
        "tiwai@suse.com" <tiwai@suse.com>,
        "npiggin@gmail.com" <npiggin@gmail.com>,
        "christophe.leroy@csgroup.eu" <christophe.leroy@csgroup.eu>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "oss@buserror.net" <oss@buserror.net>,
        "windhl@126.com" <windhl@126.com>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "william.zhang@broadcom.com" <william.zhang@broadcom.com>,
        "kursad.oney@broadcom.com" <kursad.oney@broadcom.com>,
        "anand.gore@broadcom.com" <anand.gore@broadcom.com>,
        "rafal@milecki.pl" <rafal@milecki.pl>,
        "git (AMD-Xilinx)" <git@amd.com>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "andrew@aj.id.au" <andrew@aj.id.au>,
        "radu_nicolae.pirea@upb.ro" <radu_nicolae.pirea@upb.ro>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "fancer.lancer@gmail.com" <fancer.lancer@gmail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "jbrunet@baylibre.com" <jbrunet@baylibre.com>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "avifishman70@gmail.com" <avifishman70@gmail.com>,
        "tmaimon77@gmail.com" <tmaimon77@gmail.com>,
        "tali.perry1@gmail.com" <tali.perry1@gmail.com>,
        "venture@google.com" <venture@google.com>,
        "yuenn@google.com" <yuenn@google.com>,
        "benjaminfair@google.com" <benjaminfair@google.com>,
        "yogeshgaur.83@gmail.com" <yogeshgaur.83@gmail.com>,
        "konrad.dybcio@somainline.org" <konrad.dybcio@somainline.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-rpi-kernel@lists.infradead.org" 
        <linux-rpi-kernel@lists.infradead.org>,
        "linux-amlogic@lists.infradead.org" 
        <linux-amlogic@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-sunxi@lists.linux.dev" <linux-sunxi@lists.linux.dev>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>,
        "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "Michael.Hennerich@analog.com" <Michael.Hennerich@analog.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "michael@walle.cc" <michael@walle.cc>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "patches@opensource.cirrus.com" <patches@opensource.cirrus.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "amitrkcian2002@gmail.com" <amitrkcian2002@gmail.com>,
        "sbinding@opensource.cirrus.com" <sbinding@opensource.cirrus.com>
Subject: RE: [PATCH V6 09/15] spi: Add stacked and parallel memories support
 in SPI core
Thread-Topic: [PATCH V6 09/15] spi: Add stacked and parallel memories support
 in SPI core
Thread-Index: AQHZU3Y+7Ei9f6k/Bk2l8j/7u+VyTq73UGgAgAy8apA=
Date:   Mon, 20 Mar 2023 19:15:47 +0000
Message-ID: <BN7PR12MB2802FFB8112849DEB9C22FBFDC809@BN7PR12MB2802.namprd12.prod.outlook.com>
References: <20230310173217.3429788-1-amit.kumar-mahapatra@amd.com>
 <20230310173217.3429788-10-amit.kumar-mahapatra@amd.com>
 <CAOiHx==+gX-S43=Fd1jRu=t=Cy8=6dePbGDDmGRUFhq8dVCwGg@mail.gmail.com>
In-Reply-To: <CAOiHx==+gX-S43=Fd1jRu=t=Cy8=6dePbGDDmGRUFhq8dVCwGg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR12MB2802:EE_|BN9PR12MB5099:EE_
x-ms-office365-filtering-correlation-id: ce0c41a1-fdcd-40eb-032f-08db297782e5
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DdU8pHquhfJshv3esMaGDfWsulhxhBODKWCdFyS/L0omWJVaVtmKIRvG4iYeGqouaAgBP1/FhC2JMmAUUQZI8PobYxjTQzdpdyQrem32/1Igs32XV2wUHFBX8ujULvg/CKMvlCzKWs+svMQTsjstv075ZlpzHmzcmD1zw3IuiqOzVfa+XnIp1nxM7JWOFJFwlB9FQJUU5TVydUvbHm1DEkXOlywfdZ/NT5p1Ct7c60ErE1rPmKDTKbyofle48Wfi6M0xQYE5cxjTueXrToTtlliUaMrhJaF7lZ9pxPRMeOaN+SirYsvO+MkIdIgVjE2ljlNXnnzKxLoGFaEyUG9zWOpPb6DyzJ5LDROxFUlUH8iuHBnIsG41QtEv3JpW0d6ngXaIJbpD4PLxZrB9U98J3rDbIJhNiI6UAVK5Gk0Lt2EdRciAJz4/WkTDfEQHVXzGkIORaxQTNKVYwIv+Tn6GGKVv22ghnEMfCYSCIZk1QjyW2L0L8gzs2StbTUPVKgCnK6C/wv8Fn+B2gByWWqYWCT7ni0RafuF8676JQjtcFKeCVTv5mKY40gbBItIlau+RZ0PMxegs9LClcP2eDqKRlIt1tlZCCjm5aDwN2fZhO5VjG5RDCRatSIwMnzIzhuvP29B/e9FY3BSn7L/qk0wAjY3Ejm4//RfZcHsDJ/GrDwd/KrrsFZuy8VmAhtH4ugCAXuN3oM9WMbnfgsVwlpFBU8DW/NC4F62XkJnBWC7bktLiW+jd01M3mdv0qZ3PRWRKiaIyZeBxGyG1RpU8b2yYbTxGP36GHxtvYV03xVGTkRo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR12MB2802.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199018)(71200400001)(7696005)(316002)(54906003)(52536014)(9686003)(8936002)(26005)(53546011)(478600001)(4326008)(41300700001)(8676002)(45426003)(6916009)(186003)(6506007)(7366002)(7406005)(7276002)(7416002)(5660300002)(7336002)(30864003)(2906002)(83380400001)(33656002)(66446008)(122000001)(38100700002)(38070700005)(66476007)(76116006)(66556008)(66946007)(64756008)(55016003)(86362001)(21314003)(15866825006)(41080700001)(579004)(559001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?amlWbzRuNnluT2ZnL1ZMK0tybzdjdWV5MkRoWVlTZkR5VGRpcGRPRVFWYWo1?=
 =?utf-8?B?OW1TQ25FRmI5TVVVVVZUVldabTB0VlNSbHpqSnh3eTRkNFh5ZGo5ZlBnOUdX?=
 =?utf-8?B?Wm82U0poNlhIOFFVb09vN0xBem5BQ2R1elZuTTZOOUhTdEVDNFlmRnlQUnM1?=
 =?utf-8?B?ODYrZllNOTZua3M0Z3RmQ3NPSHk3NG1GVlE1a0FMeFlXU3lkOUpVOHU0dTFl?=
 =?utf-8?B?UnBnYjB6Z3Z2bk9pYUZCektLRGczdHhMaHdiYUtsT2U3dDh1MHFBdXlYYW9t?=
 =?utf-8?B?aWo1eGxNZHM1aEt6REtGRStzYnI1ekZsVnNSWUtZWGNQblBjT1Rtc1gycDY4?=
 =?utf-8?B?enpqVzMvWGdST0lBYWY2T3ZNSU9GQVc2ZFRwajRVOURES24zSzlzeWl3Y2ZO?=
 =?utf-8?B?WHZLaE14emcyVUUrdXVOZmJFcmxmNGpJWHBxbTNabzNpVjFDVUczVUhVeHdR?=
 =?utf-8?B?VWVLTm1LSjlLZG05ZTBwWVp5ZnBCTG1KcEcwTzBDZDROL0tpL1ZuMm80bHpr?=
 =?utf-8?B?bnZodEdtNzM4cnRkUjErZXMyT2RuSitVYllKRVdjVTJLaGg1bkNORmhWNktF?=
 =?utf-8?B?VFN0MDh4b0tNVG1tOWpYL2lxNzNPQWxPcHgzSEdtcmZ1cnlVc3RmaFpORDJu?=
 =?utf-8?B?YU5qV01yRitrNHlYdzdLWHBjRjd0Z05RcHZjYTBPS20ySCtsOWx0eCsvd3VI?=
 =?utf-8?B?d3p2d2VWWjVQa3A0U1pHbEFXcFU5bWk5anlVbWZrOTZvd2pWaEYwZnRWWVVo?=
 =?utf-8?B?cTNkMmVMZ202NTZKb3AxSTd0bUFHMWhBbTFGT1JwSGdaeXhuL2RSQnJZMHRS?=
 =?utf-8?B?VkFoUll4UmIxS3dhZkhVOW0zbFRlYUk4Q2ZyaUZuN0xOWTByc3oybGpEUUFC?=
 =?utf-8?B?b1QyYkRkUGhMQ0h0aEdqTXZEcEYvVmFNci8yRmVPL2VvMUJnS0lEeFp1V2dB?=
 =?utf-8?B?N2I5NjZZdU5hUTdhQUxxME1yaGp6UFpBMExDRmdJY0NmWkJxdDVkMjI1L3FX?=
 =?utf-8?B?aCsxd2NHS01qUVNXWldrajNlRWpZclYydEVBYjBsRDVqVTJVa3kycytpZldw?=
 =?utf-8?B?YkVIbkxDeFYvQTE2R1V4REt5M2hWY1EwR1lBLytSandRRlI1MldLK0s3MEZC?=
 =?utf-8?B?SEE5U0dIaC9RSHpDVFNiWklKemk5WTk1eGNEWXpYL0c5aG1ieCtDZ2lCdmNj?=
 =?utf-8?B?TzFucEp0MGZNaGVsVWJzWXh5Wmdtd0FTWm91cmhzNFRvdEQ0TVEzb0tVTmpL?=
 =?utf-8?B?L3N5ZUF5QklKZUZueEhxWGNKL0o3cWVNQ010V2FFQ2FKQ2tZRk4reXVHMFd0?=
 =?utf-8?B?TUF1QTZJTFJPRTZqZXVqNVR4c1FnUC9RdGN6a1ZYTk92OVNQR0FtemxXbm9r?=
 =?utf-8?B?dlRXVElKOVpxWEFLTWZFaFowenFEcVpwdXRlYWpPVzhDWWRaUjgvSVBURitV?=
 =?utf-8?B?WmkvUUFaUzNHbW9GZndabXR4b0Ywd2RPMXlqRkpiemNObHBWcFExMUxHTEZB?=
 =?utf-8?B?cVg2OTJhRjhPT3VqSHA2Zm5zemoyTjdCdm9oWi9IMmRVWE5PYzBVdllDZHJY?=
 =?utf-8?B?QTFmZHFVN2VicmNVTi9EK0ZCUkwrR1JHQXBrbXVGU0k4emFiQVFKYzZnTS9W?=
 =?utf-8?B?ZHdEc1hBNEpDelpyWFYvS05NSjRueDFIY0xCODZVa3FSYkV0ZUtGdDB0ZEFK?=
 =?utf-8?B?eWRydy9YSEU3Rko5dWR6MzkxMUZodEc1aWNSS3FORGU5d1d1NmduSnVuNW9n?=
 =?utf-8?B?djFFYXc0aFNndnZNTDJ4d2hoQWQzaFdXdzl2MllXbjB6QUdVKzl3aSs2dUhM?=
 =?utf-8?B?bGJxYitLWTA2R2ZCTFNRL0hLN3dUVEpIcUNwWXQ0YXJMaHB4Y2RDcUREMnpO?=
 =?utf-8?B?WGs4T2lSS3FCREJOMUQwUU9mdnF1WlAvR2w3ajM4d2NPR1M1MVZPOG51NjRL?=
 =?utf-8?B?SDJKRFNCSm5wL1VwbGpBdk9RL1lHbXZCNlRvNitTSDNhRVp1WmRsWXI4Tkxh?=
 =?utf-8?B?ODFGemhsYzEwMW8rUkJZb3JPcEFiZWlreWpSTDdNZ3h6TUZ4QVIrN3c2aEpZ?=
 =?utf-8?B?b25UNEF2UHhBUVNKK3NPbVplUXQ5RjJaS1VMOXp5aGpkK1FCUkI1UndBcXk1?=
 =?utf-8?Q?t2kw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR12MB2802.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce0c41a1-fdcd-40eb-032f-08db297782e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 19:15:47.6794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nRCy/3cWK55FL8X97bXvsdn6NvL6xiAsOiPaDkvTj8OVoIYFffDOVXJrFhwGOWlivu5PN/RPJwICp4I3Tg/a2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5099
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9uYXMgR29y
c2tpIDxqb25hcy5nb3Jza2lAZ21haWwuY29tPg0KPiBTZW50OiBTdW5kYXksIE1hcmNoIDEyLCAy
MDIzIDk6MzAgUE0NCj4gVG86IE1haGFwYXRyYSwgQW1pdCBLdW1hciA8YW1pdC5rdW1hci1tYWhh
cGF0cmFAYW1kLmNvbT4NCj4gQ2M6IGJyb29uaWVAa2VybmVsLm9yZzsgbWlxdWVsLnJheW5hbEBi
b290bGluLmNvbTsgcmljaGFyZEBub2QuYXQ7DQo+IHZpZ25lc2hyQHRpLmNvbTsgamljMjNAa2Vy
bmVsLm9yZzsgdHVkb3IuYW1iYXJ1c0BtaWNyb2NoaXAuY29tOw0KPiBwcmF0eXVzaEBrZXJuZWwu
b3JnOyBNZWh0YSwgU2FuanUgPFNhbmp1Lk1laHRhQGFtZC5jb20+OyBjaGluLQ0KPiB0aW5nX2t1
b0Bhc3BlZWR0ZWNoLmNvbTsgY2xnQGthb2Qub3JnOyBrZGFzdS5rZGV2QGdtYWlsLmNvbTsNCj4g
Zi5mYWluZWxsaUBnbWFpbC5jb207IHJqdWlAYnJvYWRjb20uY29tOyBzYnJhbmRlbkBicm9hZGNv
bS5jb207DQo+IGVhamFtZXNAbGludXguaWJtLmNvbTsgb2x0ZWFudkBnbWFpbC5jb207IGhhbi54
dUBueHAuY29tOw0KPiBqb2huLmdhcnJ5QGh1YXdlaS5jb207IHNoYXduZ3VvQGtlcm5lbC5vcmc7
IHMuaGF1ZXJAcGVuZ3V0cm9uaXguZGU7DQo+IG5hcm1zdHJvbmdAYmF5bGlicmUuY29tOyBraGls
bWFuQGJheWxpYnJlLmNvbTsNCj4gbWF0dGhpYXMuYmdnQGdtYWlsLmNvbTsgaGFpYm8uY2hlbkBu
eHAuY29tOyBsaW51cy53YWxsZWlqQGxpbmFyby5vcmc7DQo+IGRhbmllbEB6b25xdWUub3JnOyBo
YW9qaWFuLnpodWFuZ0BnbWFpbC5jb207IHJvYmVydC5qYXJ6bWlrQGZyZWUuZnI7DQo+IGFncm9z
c0BrZXJuZWwub3JnOyBiam9ybi5hbmRlcnNzb25AbGluYXJvLm9yZzsgaGVpa29Ac250ZWNoLmRl
Ow0KPiBrcnp5c3p0b2Yua296bG93c2tpQGxpbmFyby5vcmc7IGFuZGlAZXRlemlhbi5vcmc7DQo+
IG1jb3F1ZWxpbi5zdG0zMkBnbWFpbC5jb207IGFsZXhhbmRyZS50b3JndWVAZm9zcy5zdC5jb207
DQo+IHdlbnNAY3NpZS5vcmc7IGplcm5lai5za3JhYmVjQGdtYWlsLmNvbTsgc2FtdWVsQHNob2xs
YW5kLm9yZzsNCj4gbWFzYWhpc2Eua29qaW1hQGxpbmFyby5vcmc7IGphc3dpbmRlci5zaW5naEBs
aW5hcm8ub3JnOw0KPiByb3N0ZWR0QGdvb2RtaXMub3JnOyBtaW5nb0ByZWRoYXQuY29tOyBsLnN0
ZWxtYWNoQHNhbXN1bmcuY29tOw0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBlZHVtYXpldEBnb29n
bGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7DQo+IHBhYmVuaUByZWRoYXQuY29tOyBhbGV4LmFyaW5n
QGdtYWlsLmNvbTsgc3RlZmFuQGRhdGVuZnJlaWhhZmVuLm9yZzsNCj4ga3ZhbG9Aa2VybmVsLm9y
ZzsgamFtZXMuc2NodWxtYW5AY2lycnVzLmNvbTsgZGF2aWQucmhvZGVzQGNpcnJ1cy5jb207DQo+
IHRhbnVyZWFsQG9wZW5zb3VyY2UuY2lycnVzLmNvbTsgcmZAb3BlbnNvdXJjZS5jaXJydXMuY29t
Ow0KPiBwZXJleEBwZXJleC5jejsgdGl3YWlAc3VzZS5jb207IG5waWdnaW5AZ21haWwuY29tOw0K
PiBjaHJpc3RvcGhlLmxlcm95QGNzZ3JvdXAuZXU7IG1wZUBlbGxlcm1hbi5pZC5hdTsgb3NzQGJ1
c2Vycm9yLm5ldDsNCj4gd2luZGhsQDEyNi5jb207IHlhbmd5aW5nbGlhbmdAaHVhd2VpLmNvbTsN
Cj4gd2lsbGlhbS56aGFuZ0Bicm9hZGNvbS5jb207IGt1cnNhZC5vbmV5QGJyb2FkY29tLmNvbTsN
Cj4gYW5hbmQuZ29yZUBicm9hZGNvbS5jb207IHJhZmFsQG1pbGVja2kucGw7IGdpdCAoQU1ELVhp
bGlueCkNCj4gPGdpdEBhbWQuY29tPjsgbGludXgtc3BpQHZnZXIua2VybmVsLm9yZzsgbGludXgt
a2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gam9lbEBqbXMuaWQuYXU7IGFuZHJld0Bhai5pZC5h
dTsgcmFkdV9uaWNvbGFlLnBpcmVhQHVwYi5ybzsNCj4gbmljb2xhcy5mZXJyZUBtaWNyb2NoaXAu
Y29tOyBhbGV4YW5kcmUuYmVsbG9uaUBib290bGluLmNvbTsNCj4gY2xhdWRpdS5iZXpuZWFAbWlj
cm9jaGlwLmNvbTsgYmNtLWtlcm5lbC1mZWVkYmFjay1saXN0QGJyb2FkY29tLmNvbTsNCj4gZmFu
Y2VyLmxhbmNlckBnbWFpbC5jb207IGtlcm5lbEBwZW5ndXRyb25peC5kZTsgZmVzdGV2YW1AZ21h
aWwuY29tOw0KPiBsaW51eC1pbXhAbnhwLmNvbTsgamJydW5ldEBiYXlsaWJyZS5jb207DQo+IG1h
cnRpbi5ibHVtZW5zdGluZ2xAZ29vZ2xlbWFpbC5jb207IGF2aWZpc2htYW43MEBnbWFpbC5jb207
DQo+IHRtYWltb243N0BnbWFpbC5jb207IHRhbGkucGVycnkxQGdtYWlsLmNvbTsgdmVudHVyZUBn
b29nbGUuY29tOw0KPiB5dWVubkBnb29nbGUuY29tOyBiZW5qYW1pbmZhaXJAZ29vZ2xlLmNvbTsg
eW9nZXNoZ2F1ci44M0BnbWFpbC5jb207DQo+IGtvbnJhZC5keWJjaW9Ac29tYWlubGluZS5vcmc7
IGFsaW0uYWtodGFyQHNhbXN1bmcuY29tOw0KPiBsZGV3YW5nYW5AbnZpZGlhLmNvbTsgdGhpZXJy
eS5yZWRpbmdAZ21haWwuY29tOyBqb25hdGhhbmhAbnZpZGlhLmNvbTsNCj4gU2ltZWssIE1pY2hh
bCA8bWljaGFsLnNpbWVrQGFtZC5jb20+OyBsaW51eC1hc3BlZWRAbGlzdHMub3psYWJzLm9yZzsN
Cj4gb3BlbmJtY0BsaXN0cy5vemxhYnMub3JnOyBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJh
ZGVhZC5vcmc7IGxpbnV4LXJwaS0NCj4ga2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IGxpbnV4
LWFtbG9naWNAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgtDQo+IG1lZGlhdGVrQGxpc3RzLmlu
ZnJhZGVhZC5vcmc7IGxpbnV4LWFybS1tc21Admdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4gcm9j
a2NoaXBAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgtc2Ftc3VuZy1zb2NAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC0NCj4gc3RtMzJAc3QtbWQtbWFpbG1hbi5zdG9ybXJlcGx5LmNvbTsgbGludXgt
c3VueGlAbGlzdHMubGludXguZGV2OyBsaW51eC0NCj4gdGVncmFAdmdlci5rZXJuZWwub3JnOyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4gd3BhbkB2Z2VyLmtlcm5lbC5vcmc7IGxp
YmVydGFzLWRldkBsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC0NCj4gd2lyZWxlc3NAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC1tdGRAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGFyc0BtZXRhZm9vLmRl
Ow0KPiBNaWNoYWVsLkhlbm5lcmljaEBhbmFsb2cuY29tOyBsaW51eC1paW9Admdlci5rZXJuZWwu
b3JnOw0KPiBtaWNoYWVsQHdhbGxlLmNjOyBwYWxtZXJAZGFiYmVsdC5jb207IGxpbnV4LXJpc2N2
QGxpc3RzLmluZnJhZGVhZC5vcmc7DQo+IGFsc2EtZGV2ZWxAYWxzYS1wcm9qZWN0Lm9yZzsgcGF0
Y2hlc0BvcGVuc291cmNlLmNpcnJ1cy5jb207IGxpbnV4cHBjLQ0KPiBkZXZAbGlzdHMub3psYWJz
Lm9yZzsgYW1pdHJrY2lhbjIwMDJAZ21haWwuY29tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggVjYg
MDkvMTVdIHNwaTogQWRkIHN0YWNrZWQgYW5kIHBhcmFsbGVsIG1lbW9yaWVzDQo+IHN1cHBvcnQg
aW4gU1BJIGNvcmUNCj4gDQo+IEhpLA0KPiANCj4gT24gRnJpLCAxMCBNYXIgMjAyMyBhdCAxODoz
NywgQW1pdCBLdW1hciBNYWhhcGF0cmEgPGFtaXQua3VtYXItDQo+IG1haGFwYXRyYUBhbWQuY29t
PiB3cm90ZToNCj4gPg0KPiA+IEZvciBzdXBwb3J0aW5nIG11bHRpcGxlIENTIHRoZSBTUEkgZGV2
aWNlIG5lZWQgdG8gYmUgYXdhcmUgb2YgYWxsIHRoZQ0KPiA+IENTIHZhbHVlcy4gU28sIHRoZSAi
Y2hpcF9zZWxlY3QiIG1lbWJlciBpbiB0aGUgc3BpX2RldmljZSBzdHJ1Y3R1cmUgaXMNCj4gPiBu
b3cgYW4gYXJyYXkgdGhhdCBob2xkcyBhbGwgdGhlIENTIHZhbHVlcy4NCj4gPg0KPiA+IHNwaV9k
ZXZpY2Ugc3RydWN0dXJlIG5vdyBoYXMgYSAiY3NfaW5kZXhfbWFzayIgbWVtYmVyLiBUaGlzIGFj
dHMgYXMgYW4NCj4gPiBpbmRleCB0byB0aGUgY2hpcF9zZWxlY3QgYXJyYXkuIElmIG50aCBiaXQg
b2Ygc3BpLT5jc19pbmRleF9tYXNrIGlzDQo+ID4gc2V0IHRoZW4gdGhlIGRyaXZlciB3b3VsZCBh
c3NlcnQgc3BpLT5jaGlwX3NlbGVjdFtuXS4NCj4gPg0KPiA+IEluIHBhcmFsbGVsIG1vZGUgYWxs
IHRoZSBjaGlwIHNlbGVjdHMgYXJlIGFzc2VydGVkL2RlLWFzc2VydGVkDQo+ID4gc2ltdWx0YW5l
b3VzbHkgYW5kIGVhY2ggYnl0ZSBvZiBkYXRhIGlzIHN0b3JlZCBpbiBib3RoIGRldmljZXMsIHRo
ZQ0KPiA+IGV2ZW4gYml0cyBpbiBvbmUsIHRoZSBvZGQgYml0cyBpbiB0aGUgb3RoZXIuIFRoZSBz
cGxpdCBpcw0KPiA+IGF1dG9tYXRpY2FsbHkgaGFuZGxlZCBieSB0aGUgR1FTUEkgY29udHJvbGxl
ci4gVGhlIEdRU1BJIGNvbnRyb2xsZXINCj4gPiBzdXBwb3J0cyBhIG1heGltdW0gb2YgdHdvIGZs
YXNoZXMgY29ubmVjdGVkIGluIHBhcmFsbGVsIG1vZGUuIEENCj4gPiAibXVsdGktY3MtY2FwIiBm
bGFnIGlzIGFkZGVkIGluIHRoZSBzcGkgY29udHJvbnRyb2xsZXIgZGF0YSwgdGhyb3VnaA0KPiA+
IGN0bHItPm11bHRpLWNzLWNhcCB0aGUgc3BpIGNvcmUgd2lsbCBtYWtlIHN1cmUgdGhhdCB0aGUg
Y29udHJvbGxlciBpcw0KPiA+IGNhcGFibGUgb2YgaGFuZGxpbmcgbXVsdGlwbGUgY2hpcCBzZWxl
Y3RzIGF0IG9uY2UuDQo+ID4NCj4gPiBGb3Igc3VwcG9ydGluZyBtdWx0aXBsZSBDUyB2aWEgR1BJ
TyB0aGUgY3NfZ3Bpb2QgbWVtYmVyIG9mIHRoZQ0KPiA+IHNwaV9kZXZpY2Ugc3RydWN0dXJlIGlz
IG5vdyBhbiBhcnJheSB0aGF0IGhvbGRzIHRoZSBncGlvIGRlc2NyaXB0b3INCj4gPiBmb3IgZWFj
aCBjaGlwc2VsZWN0Lg0KPiA+DQo+ID4gTXVsdGkgQ1Mgc3VwcG9ydCB1c2luZyBHUElPIGlzIG5v
dCB0ZXN0ZWQgZHVlIHRvIHVuYXZhaWxhYmlsaXR5IG9mDQo+ID4gbmVjZXNzYXJ5IGhhcmR3YXJl
IHNldHVwLg0KPiANCj4gQ2FuIHlvdSBwaW5tdXggeW91ciBTUEkgY29udHJvbGxlcidzIChjcykg
cGlucyBhcyBHUElPPyBJZiBzbywgeW91IHNob3VsZCBiZQ0KPiBhYmxlIHVzZSB0aGF0IGZvciB0
ZXN0aW5nLg0KPiANCg0KWGlsaW54IENvbnRyb2xsZXIgZHJpdmVycyB0aGF0IHN1cHBvcnQgbXVs
dGkgY3MgYXJlIHJlZ2lzdGVyZWQgdW5kZXIgDQpzcGktbWVtIGZyYW1ld29yay4gU28gZXZlbiBp
ZiBJIG1vZGlmeSB0aGUgcGlubXV4IHRoZSBjaGlwIHNlbGVjdGlvbiANCndpbGwgbm90IGdvIHRo
cm91Z2ggdGhlIFNQSSBjb3JlLiANClNvLCB3ZSBjYW5ub3QgdGVzdCB0aGUgQ1MgR1BJTyBjaGFu
Z2VzIGluIFNQSSBjb3JlIG9uIG91ciBwbGF0Zm9ybXMuDQoNCj4gPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IEFtaXQgS3VtYXIgTWFoYXBhdHJhIDxhbWl0Lmt1bWFyLQ0KPiBtYWhhcGF0cmFAYW1kLmNv
bT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9zcGkvc3BpLmMgICAgICAgfCAyMjUgKysrKysrKysr
KysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLQ0KPiA+ICBpbmNsdWRlL2xpbnV4L3NwaS9z
cGkuaCB8ICAzNCArKysrLS0NCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAxODIgaW5zZXJ0aW9ucygr
KSwgNzcgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zcGkvc3Bp
LmMgYi9kcml2ZXJzL3NwaS9zcGkuYyBpbmRleA0KPiA+IGM3MjViNGJhYjdhZi4uNzQyYmQ2ODgz
ODFjIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvc3BpL3NwaS5jDQo+ID4gKysrIGIvZHJpdmVy
cy9zcGkvc3BpLmMNCj4gPiBAQCAtNjEyLDEwICs2MTIsMTcgQEAgc3RhdGljIGludCBzcGlfZGV2
X2NoZWNrKHN0cnVjdCBkZXZpY2UgKmRldiwNCj4gPiB2b2lkICpkYXRhKSAgew0KPiA+ICAgICAg
ICAgc3RydWN0IHNwaV9kZXZpY2UgKnNwaSA9IHRvX3NwaV9kZXZpY2UoZGV2KTsNCj4gPiAgICAg
ICAgIHN0cnVjdCBzcGlfZGV2aWNlICpuZXdfc3BpID0gZGF0YTsNCj4gPiAtDQo+ID4gLSAgICAg
ICBpZiAoc3BpLT5jb250cm9sbGVyID09IG5ld19zcGktPmNvbnRyb2xsZXIgJiYNCj4gPiAtICAg
ICAgICAgICBzcGlfZ2V0X2NoaXBzZWxlY3Qoc3BpLCAwKSA9PSBzcGlfZ2V0X2NoaXBzZWxlY3Qo
bmV3X3NwaSwgMCkpDQo+ID4gLSAgICAgICAgICAgICAgIHJldHVybiAtRUJVU1k7DQo+ID4gKyAg
ICAgICBpbnQgaWR4LCBud19pZHg7DQo+ID4gKw0KPiA+ICsgICAgICAgaWYgKHNwaS0+Y29udHJv
bGxlciA9PSBuZXdfc3BpLT5jb250cm9sbGVyKSB7DQo+ID4gKyAgICAgICAgICAgICAgIGZvciAo
aWR4ID0gMDsgaWR4IDwgU1BJX0NTX0NOVF9NQVg7IGlkeCsrKSB7DQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgZm9yIChud19pZHggPSAwOyBud19pZHggPCBTUElfQ1NfQ05UX01BWDsgbndf
aWR4KyspIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChzcGlfZ2V0
X2NoaXBzZWxlY3Qoc3BpLCBpZHgpID09DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgc3BpX2dldF9jaGlwc2VsZWN0KG5ld19zcGksIG53X2lkeCkpDQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtRUJVU1k7DQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgICAgfQ0KPiA+ICsgICAgICAgICAgICAgICB9DQo+IA0KPiBBRkFJ
Q1QgdW51c2VkIGNoaXAgc2VsZWN0cyBhcmUgaW5pdGlhbGl6ZWQgdG8gMCwgc28gYWxsIHNpbmds
ZSBjaGlwIHNlbGVjdCBkZXZpY2VzDQo+IHdvdWxkIGhhdmUgaXQgYXMgdGhlaXIgc2Vjb25kIG9u
ZS4gVGhpcyB3aWxsIHRoZW4gY2F1c2UgdGhpcyBjaGVjayB0byByZWplY3QNCj4gZXZlcnkgc2lu
Z2xlIGNoaXAgc2VsZWN0IGRldmljZSBhZnRlciB0aGUgZmlyc3Qgb25lLiBTbyB5b3UgZmlyc3Qg
bmVlZCB0byBtYWtlDQo+IHN1cmUgdG8gb25seSBjb21wYXJlIHZhbGlkIGNoaXAgc2VsZWN0cy4N
Cj4gDQo+IFNvIHRoZSBsb29wIGNvbmRpdGlvbiBzaG91bGQgYmUgc29tZXRoaW5nIGFsb25nIGlk
eCA8DQo+IHNwaV9nZXRfbnVtX2NoaXBzZWxlY3QoKSwgbm90IGlkeCA8IFNQSV9DU19DTlRfTUFY
Lg0KPiANCg0KQWdyZWVkLCB3aWxsIHVwZGF0ZSB0aGUgbG9vcCBjb25kaXRpb24gYXMgcGVyIG51
bV9jcy4NCg0KPiA+ICsgICAgICAgfQ0KPiA+ICAgICAgICAgcmV0dXJuIDA7DQo+ID4gIH0NCj4g
Pg0KPiA+IEBAIC02MjksNyArNjM2LDcgQEAgc3RhdGljIGludCBfX3NwaV9hZGRfZGV2aWNlKHN0
cnVjdCBzcGlfZGV2aWNlDQo+ID4gKnNwaSkgIHsNCj4gPiAgICAgICAgIHN0cnVjdCBzcGlfY29u
dHJvbGxlciAqY3RsciA9IHNwaS0+Y29udHJvbGxlcjsNCj4gPiAgICAgICAgIHN0cnVjdCBkZXZp
Y2UgKmRldiA9IGN0bHItPmRldi5wYXJlbnQ7DQo+ID4gLSAgICAgICBpbnQgc3RhdHVzOw0KPiA+
ICsgICAgICAgaW50IHN0YXR1cywgaWR4Ow0KPiA+DQo+ID4gICAgICAgICAvKg0KPiA+ICAgICAg
ICAgICogV2UgbmVlZCB0byBtYWtlIHN1cmUgdGhlcmUncyBubyBvdGhlciBkZXZpY2Ugd2l0aCB0
aGlzIEBADQo+ID4gLTYzOCw4ICs2NDUsNyBAQCBzdGF0aWMgaW50IF9fc3BpX2FkZF9kZXZpY2Uo
c3RydWN0IHNwaV9kZXZpY2UgKnNwaSkNCj4gPiAgICAgICAgICAqLw0KPiA+ICAgICAgICAgc3Rh
dHVzID0gYnVzX2Zvcl9lYWNoX2Rldigmc3BpX2J1c190eXBlLCBOVUxMLCBzcGksIHNwaV9kZXZf
Y2hlY2spOw0KPiA+ICAgICAgICAgaWYgKHN0YXR1cykgew0KPiA+IC0gICAgICAgICAgICAgICBk
ZXZfZXJyKGRldiwgImNoaXBzZWxlY3QgJWQgYWxyZWFkeSBpbiB1c2VcbiIsDQo+ID4gLSAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBzcGlfZ2V0X2NoaXBzZWxlY3Qoc3BpLCAwKSk7DQo+
ID4gKyAgICAgICAgICAgICAgIGRldl9lcnIoZGV2LCAiY2hpcHNlbGVjdCAlZCBhbHJlYWR5IGlu
IHVzZVxuIiwNCj4gPiArIHNwaV9nZXRfY2hpcHNlbGVjdChzcGksIDApKTsNCj4gDQo+IFRoZSBt
ZXNzYWdlIG1pZ2h0IGJlIG1pc2xlYWRpbmcgZm9yIG11bHRpIGNzIGRldmljZXMgd2hlcmUgdGhl
IGZpcnN0IG9uZSBpcw0KPiBmcmVlLCBidXQgdGhlIHNlY29uZCBvbmUgaXMgYWxyZWFkeSBpbiB1
c2UuDQo+IA0KPiBTbyBtYXliZSBtb3ZlIHRoaXMgZXJyb3IgbWVzc2FnZSBpbnRvIHNwaV9kZXZf
Y2hlY2soKSwgd2hlcmUgeW91IGhhdmUNCj4gdGhhdCBpbmZvcm1hdGlvbiBhdmFpbGFibGUuIFlv
dSB0aGVuIGV2ZW4gaGF2ZSB0aGUgY2hhbmNlIHRvIHN0YXRlIHdoYXQgaXMNCj4gdXNpbmcgdGhl
IENTIHRoZW4sIGJ1dCB0aGF0IG1pZ2h0IGJlIHNvbWV0aGluZyBmb3IgYSBkaWZmZXJlbnQgcGF0
Y2guDQo+IA0KPiANCg0KQWdyZWVkLCBJIHdpbGwgbW92ZSB0aGUgZXJyb3IgbWVzc2FnZSB0byBz
cGlfZGV2X2NoZWNrKCkuDQoNCj4gPiAgICAgICAgICAgICAgICAgcmV0dXJuIHN0YXR1czsNCj4g
PiAgICAgICAgIH0NCj4gPg0KPiA+IEBAIC02NDksOCArNjU1LDEwIEBAIHN0YXRpYyBpbnQgX19z
cGlfYWRkX2RldmljZShzdHJ1Y3Qgc3BpX2RldmljZSAqc3BpKQ0KPiA+ICAgICAgICAgICAgICAg
ICByZXR1cm4gLUVOT0RFVjsNCj4gPiAgICAgICAgIH0NCj4gPg0KPiA+IC0gICAgICAgaWYgKGN0
bHItPmNzX2dwaW9kcykNCj4gPiAtICAgICAgICAgICAgICAgc3BpX3NldF9jc2dwaW9kKHNwaSwg
MCwgY3Rsci0+Y3NfZ3Bpb2RzW3NwaV9nZXRfY2hpcHNlbGVjdChzcGksIDApXSk7DQo+ID4gKyAg
ICAgICBpZiAoY3Rsci0+Y3NfZ3Bpb2RzKSB7DQo+ID4gKyAgICAgICAgICAgICAgIGZvciAoaWR4
ID0gMDsgaWR4IDwgU1BJX0NTX0NOVF9NQVg7IGlkeCsrKQ0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgIHNwaV9zZXRfY3NncGlvZChzcGksIGlkeCwgY3Rsci0NCj4gPmNzX2dwaW9kc1tzcGlf
Z2V0X2NoaXBzZWxlY3Qoc3BpLCBpZHgpXSk7DQo+ID4gKyAgICAgICB9DQo+ID4NCj4gPiAgICAg
ICAgIC8qDQo+ID4gICAgICAgICAgKiBEcml2ZXJzIG1heSBtb2RpZnkgdGhpcyBpbml0aWFsIGkv
byBzZXR1cCwgYnV0IHdpbGwgQEANCj4gPiAtNjkwLDEzICs2OTgsMTUgQEAgaW50IHNwaV9hZGRf
ZGV2aWNlKHN0cnVjdCBzcGlfZGV2aWNlICpzcGkpICB7DQo+ID4gICAgICAgICBzdHJ1Y3Qgc3Bp
X2NvbnRyb2xsZXIgKmN0bHIgPSBzcGktPmNvbnRyb2xsZXI7DQo+ID4gICAgICAgICBzdHJ1Y3Qg
ZGV2aWNlICpkZXYgPSBjdGxyLT5kZXYucGFyZW50Ow0KPiA+IC0gICAgICAgaW50IHN0YXR1czsN
Cj4gPiArICAgICAgIGludCBzdGF0dXMsIGlkeDsNCj4gPg0KPiA+IC0gICAgICAgLyogQ2hpcHNl
bGVjdHMgYXJlIG51bWJlcmVkIDAuLm1heDsgdmFsaWRhdGUuICovDQo+ID4gLSAgICAgICBpZiAo
c3BpX2dldF9jaGlwc2VsZWN0KHNwaSwgMCkgPj0gY3Rsci0+bnVtX2NoaXBzZWxlY3QpIHsNCj4g
PiAtICAgICAgICAgICAgICAgZGV2X2VycihkZXYsICJjcyVkID49IG1heCAlZFxuIiwgc3BpX2dl
dF9jaGlwc2VsZWN0KHNwaSwgMCksDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgY3Rsci0+
bnVtX2NoaXBzZWxlY3QpOw0KPiA+IC0gICAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCj4g
PiArICAgICAgIGZvciAoaWR4ID0gMDsgaWR4IDwgU1BJX0NTX0NOVF9NQVg7IGlkeCsrKSB7DQo+
ID4gKyAgICAgICAgICAgICAgIC8qIENoaXBzZWxlY3RzIGFyZSBudW1iZXJlZCAwLi5tYXg7IHZh
bGlkYXRlLiAqLw0KPiA+ICsgICAgICAgICAgICAgICBpZiAoc3BpX2dldF9jaGlwc2VsZWN0KHNw
aSwgaWR4KSA+PSBjdGxyLT5udW1fY2hpcHNlbGVjdCkgew0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgIGRldl9lcnIoZGV2LCAiY3MlZCA+PSBtYXggJWRcbiIsIHNwaV9nZXRfY2hpcHNlbGVj
dChzcGksDQo+IGlkeCksDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjdGxy
LT5udW1fY2hpcHNlbGVjdCk7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIC1F
SU5WQUw7DQo+ID4gKyAgICAgICAgICAgICAgIH0NCj4gPiAgICAgICAgIH0NCj4gPg0KPiA+ICAg
ICAgICAgLyogU2V0IHRoZSBidXMgSUQgc3RyaW5nICovDQo+ID4gQEAgLTcxMywxMiArNzIzLDE1
IEBAIHN0YXRpYyBpbnQgc3BpX2FkZF9kZXZpY2VfbG9ja2VkKHN0cnVjdA0KPiA+IHNwaV9kZXZp
Y2UgKnNwaSkgIHsNCj4gPiAgICAgICAgIHN0cnVjdCBzcGlfY29udHJvbGxlciAqY3RsciA9IHNw
aS0+Y29udHJvbGxlcjsNCj4gPiAgICAgICAgIHN0cnVjdCBkZXZpY2UgKmRldiA9IGN0bHItPmRl
di5wYXJlbnQ7DQo+ID4gKyAgICAgICBpbnQgaWR4Ow0KPiA+DQo+ID4gLSAgICAgICAvKiBDaGlw
c2VsZWN0cyBhcmUgbnVtYmVyZWQgMC4ubWF4OyB2YWxpZGF0ZS4gKi8NCj4gPiAtICAgICAgIGlm
IChzcGlfZ2V0X2NoaXBzZWxlY3Qoc3BpLCAwKSA+PSBjdGxyLT5udW1fY2hpcHNlbGVjdCkgew0K
PiA+IC0gICAgICAgICAgICAgICBkZXZfZXJyKGRldiwgImNzJWQgPj0gbWF4ICVkXG4iLCBzcGlf
Z2V0X2NoaXBzZWxlY3Qoc3BpLCAwKSwNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICBjdGxy
LT5udW1fY2hpcHNlbGVjdCk7DQo+ID4gLSAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0K
PiA+ICsgICAgICAgZm9yIChpZHggPSAwOyBpZHggPCBTUElfQ1NfQ05UX01BWDsgaWR4KyspIHsN
Cj4gPiArICAgICAgICAgICAgICAgLyogQ2hpcHNlbGVjdHMgYXJlIG51bWJlcmVkIDAuLm1heDsg
dmFsaWRhdGUuICovDQo+ID4gKyAgICAgICAgICAgICAgIGlmIChzcGlfZ2V0X2NoaXBzZWxlY3Qo
c3BpLCBpZHgpID49IGN0bHItPm51bV9jaGlwc2VsZWN0KSB7DQo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICAgZGV2X2VycihkZXYsICJjcyVkID49IG1heCAlZFxuIiwgc3BpX2dldF9jaGlwc2Vs
ZWN0KHNwaSwNCj4gaWR4KSwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGN0
bHItPm51bV9jaGlwc2VsZWN0KTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4g
LUVJTlZBTDsNCj4gPiArICAgICAgICAgICAgICAgfQ0KPiA+ICAgICAgICAgfQ0KPiA+DQo+ID4g
ICAgICAgICAvKiBTZXQgdGhlIGJ1cyBJRCBzdHJpbmcgKi8NCj4gPiBAQCAtOTY2LDU4ICs5Nzks
MTE5IEBAIHN0YXRpYyB2b2lkIHNwaV9yZXNfcmVsZWFzZShzdHJ1Y3QNCj4gPiBzcGlfY29udHJv
bGxlciAqY3Rsciwgc3RydWN0IHNwaV9tZXNzYWdlICptZXMgIHN0YXRpYyB2b2lkDQo+ID4gc3Bp
X3NldF9jcyhzdHJ1Y3Qgc3BpX2RldmljZSAqc3BpLCBib29sIGVuYWJsZSwgYm9vbCBmb3JjZSkg
IHsNCj4gPiAgICAgICAgIGJvb2wgYWN0aXZhdGUgPSBlbmFibGU7DQo+ID4gKyAgICAgICB1MzIg
Y3NfbnVtID0gX19mZnMoc3BpLT5jc19pbmRleF9tYXNrKTsNCj4gPiArICAgICAgIGludCBpZHg7
DQo+ID4NCj4gPiAgICAgICAgIC8qDQo+ID4gLSAgICAgICAgKiBBdm9pZCBjYWxsaW5nIGludG8g
dGhlIGRyaXZlciAob3IgZG9pbmcgZGVsYXlzKSBpZiB0aGUgY2hpcCBzZWxlY3QNCj4gPiAtICAg
ICAgICAqIGlzbid0IGFjdHVhbGx5IGNoYW5naW5nIGZyb20gdGhlIGxhc3QgdGltZSB0aGlzIHdh
cyBjYWxsZWQuDQo+ID4gKyAgICAgICAgKiBJbiBwYXJhbGxlbCBtb2RlIGFsbCB0aGUgY2hpcCBz
ZWxlY3RzIGFyZSBhc3NlcnRlZC9kZS1hc3NlcnRlZA0KPiA+ICsgICAgICAgICogYXQgb25jZQ0K
PiA+ICAgICAgICAgICovDQo+ID4gLSAgICAgICBpZiAoIWZvcmNlICYmICgoZW5hYmxlICYmIHNw
aS0+Y29udHJvbGxlci0+bGFzdF9jcyA9PQ0KPiBzcGlfZ2V0X2NoaXBzZWxlY3Qoc3BpLCAwKSkg
fHwNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICghZW5hYmxlICYmIHNwaS0+Y29udHJvbGxl
ci0+bGFzdF9jcyAhPSBzcGlfZ2V0X2NoaXBzZWxlY3Qoc3BpLA0KPiAwKSkpICYmDQo+ID4gLSAg
ICAgICAgICAgKHNwaS0+Y29udHJvbGxlci0+bGFzdF9jc19tb2RlX2hpZ2ggPT0gKHNwaS0+bW9k
ZSAmDQo+IFNQSV9DU19ISUdIKSkpDQo+ID4gLSAgICAgICAgICAgICAgIHJldHVybjsNCj4gPiAt
DQo+ID4gLSAgICAgICB0cmFjZV9zcGlfc2V0X2NzKHNwaSwgYWN0aXZhdGUpOw0KPiA+IC0NCj4g
PiAtICAgICAgIHNwaS0+Y29udHJvbGxlci0+bGFzdF9jcyA9IGVuYWJsZSA/IHNwaV9nZXRfY2hp
cHNlbGVjdChzcGksIDApIDogLTE7DQo+ID4gLSAgICAgICBzcGktPmNvbnRyb2xsZXItPmxhc3Rf
Y3NfbW9kZV9oaWdoID0gc3BpLT5tb2RlICYgU1BJX0NTX0hJR0g7DQo+ID4gLQ0KPiA+IC0gICAg
ICAgaWYgKChzcGlfZ2V0X2NzZ3Bpb2Qoc3BpLCAwKSB8fCAhc3BpLT5jb250cm9sbGVyLT5zZXRf
Y3NfdGltaW5nKSAmJg0KPiAhYWN0aXZhdGUpDQo+ID4gLSAgICAgICAgICAgICAgIHNwaV9kZWxh
eV9leGVjKCZzcGktPmNzX2hvbGQsIE5VTEwpOw0KPiA+IC0NCj4gPiAtICAgICAgIGlmIChzcGkt
Pm1vZGUgJiBTUElfQ1NfSElHSCkNCj4gPiAtICAgICAgICAgICAgICAgZW5hYmxlID0gIWVuYWJs
ZTsNCj4gPiArICAgICAgIGlmICgoc3BpLT5jc19pbmRleF9tYXNrICYgU1BJX1BBUkFMTEVMX0NT
X01BU0spID09DQo+IFNQSV9QQVJBTExFTF9DU19NQVNLKSB7DQo+ID4gKyAgICAgICAgICAgICAg
IHNwaS0+Y29udHJvbGxlci0+bGFzdF9jc19tb2RlX2hpZ2ggPSBzcGktPm1vZGUgJg0KPiA+ICsg
U1BJX0NTX0hJR0g7DQo+ID4gKw0KPiA+ICsgICAgICAgICAgICAgICBpZiAoKHNwaV9nZXRfY3Nn
cGlvZChzcGksIDApIHx8ICFzcGktPmNvbnRyb2xsZXItPnNldF9jc190aW1pbmcpICYmDQo+ICFh
Y3RpdmF0ZSkNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBzcGlfZGVsYXlfZXhlYygmc3Bp
LT5jc19ob2xkLCBOVUxMKTsNCj4gPiArDQo+ID4gKyAgICAgICAgICAgICAgIGlmIChzcGktPm1v
ZGUgJiBTUElfQ1NfSElHSCkNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBlbmFibGUgPSAh
ZW5hYmxlOw0KPiA+ICsNCj4gPiArICAgICAgICAgICAgICAgaWYgKHNwaV9nZXRfY3NncGlvZChz
cGksIDApICYmIHNwaV9nZXRfY3NncGlvZChzcGksIDEpKSB7DQo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICAgaWYgKCEoc3BpLT5tb2RlICYgU1BJX05PX0NTKSkgew0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgLyoNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAqIEhpc3RvcmljYWxseSBBQ1BJIGhhcyBubyBtZWFucyBvZiB0aGUgR1BJTyBwb2xhcml0
eQ0KPiBhbmQNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqIHRodXMgdGhl
IFNQSVNlcmlhbEJ1cygpIHJlc291cmNlIGRlZmluZXMgaXQgb24gdGhlIHBlci0NCj4gY2hpcA0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICogYmFzaXMuIEluIG9yZGVyIHRv
IGF2b2lkIGEgY2hhaW4gb2YgbmVnYXRpb25zLCB0aGUgR1BJTw0KPiA+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICogcG9sYXJpdHkgaXMgY29uc2lkZXJlZCBiZWluZyBBY3RpdmUg
SGlnaC4gRXZlbiBmb3IgdGhlDQo+IGNhc2VzDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKiB3aGVuIF9EU0QoKSBpcyBpbnZvbHZlZCAoaW4gdGhlIHVwZGF0ZWQgdmVyc2lv
bnMgb2YNCj4gQUNQSSkNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqIHRo
ZSBHUElPIENTIHBvbGFyaXR5IG11c3QgYmUgZGVmaW5lZCBBY3RpdmUgSGlnaCB0bw0KPiBhdm9p
ZA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICogYW1iaWd1aXR5LiBUaGF0
J3Mgd2h5IHdlIHVzZSBlbmFibGUsIHRoYXQgdGFrZXMNCj4gU1BJX0NTX0hJR0gNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqIGludG8gYWNjb3VudC4NCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAqLw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgaWYgKGhhc19hY3BpX2NvbXBhbmlvbigmc3BpLT5kZXYpKSB7DQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGZvciAoaWR4ID0gMDsgaWR4IDwgU1BJ
X0NTX0NOVF9NQVg7IGlkeCsrKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGdwaW9kX3NldF92YWx1ZV9jYW5zbGVlcChzcGlfZ2V0X2NzZ3Bpb2Qo
c3BpLA0KPiBpZHgpLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAhZW5hYmxlKTsNCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIH0gZWxzZSB7DQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGZvciAoaWR4ID0gMDsgaWR4IDwgU1BJX0NTX0NOVF9NQVg7
IGlkeCsrKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIC8qIFBvbGFyaXR5IGhhbmRsZWQgYnkgR1BJTyBsaWJyYXJ5ICovDQo+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZ3Bpb2Rfc2V0X3ZhbHVlX2Nh
bnNsZWVwKHNwaV9nZXRfY3NncGlvZChzcGksDQo+IGlkeCksDQo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGFjdGl2YXRlKTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0NCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICB9DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgLyog
U29tZSBTUEkgbWFzdGVycyBuZWVkIGJvdGggR1BJTyBDUyAmIHNsYXZlX3NlbGVjdCAqLw0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgIGlmICgoc3BpLT5jb250cm9sbGVyLT5mbGFncyAmIFNQ
SV9NQVNURVJfR1BJT19TUykgJiYNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgc3Bp
LT5jb250cm9sbGVyLT5zZXRfY3MpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBzcGktPmNvbnRyb2xsZXItPnNldF9jcyhzcGksICFlbmFibGUpOw0KPiANCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICBlbHNlIGlmIChzcGktPmNvbnRyb2xsZXItPnNldF9jcykNCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNwaS0+Y29udHJvbGxlci0+c2V0X2NzKHNw
aSwgIWVuYWJsZSk7DQo+IA0KPiB0aGlzIGVsc2UgaWYgYmVsb25ncyB0byB0aGUgZm9sbG93aW5n
IGJyYWNlIGFzIHRoZSBlbHNlIG9mIHRoZSBpZg0KPiAoc3BpX2dldF9jc2dwaW9kKHNwaSwgMCkg
JiYgc3BpX2dldF9jc2dwaW9kKHNwaSwgMSkuIEN1cnJlbnRseSBpdCB3b3VsZCBtYWtlDQoNCkFn
cmVlZCwgd2lsbCBmaXggaXQgaW4gdGhlIG5leHQgc2VyaWVzLg0KDQo+IHRoZSBmaXJzdCBjaGVj
ayByZWR1bmRhbnQsIGFzIHRoZSBzZWNvbmQgY2FzZSB3b3VsZCBhbHdheXMgYmUgdHJ1ZSBpZiB0
aGUgZmlyc3QNCj4gb25lIGlzLg0KPiANCj4gQWN0dWFsbHkgc2hvdWxkbid0IHlvdSBpdGVyYXRl
IG92ZXIgdGhlIGNzJ3MgaGVyZSBpbiBjYXNlIG9uZSBpcyB1c2luZw0KPiBzZXRfY3MoKSBhbmQg
dGhlIG90aGVyIG9uZSBpcyBncGlvZD8gWW91IGNhbiBvbmx5IGdldCBoZXJlIGlmIGJvdGggYXJl
IGJhY2tlZA0KPiBieSBncGlvZHMuIEFuZCB5b3Ugd291bGQgb25seSBzZXQgdGhlIGZpcnN0IGNz
LCBidXQgbm90IHRoZSBzZWNvbmQgb25lLiBUaGUgLQ0KPiA+c2V0X2NzKCkgY2FsbGJhY2sgZG9l
c24ndCBhbGxvdyBzcGVjaWZ5aW5nIHdoaWNoIG9mIHRoZSAobXVsdGlwbGUpIGNzJ3Mgc2hvdWxk
DQo+IGJlIHNldCB0aG91Z2guDQo+DQogDQpBZnRlciBmaXhpbmcgdGhlIGVsc2UgaWYgaW5kZW50
YXRpb24gd2Ugd2lsbCBnZXQgaGVyZSBpZiBlaXRoZXIgb25lIG9mIHRoZQ0KIENTIHN1cHBvcnQg
Z3Bpb2Qgb3IgYm90aCB0aGUgQ1Mgc3VwcG9ydCBzZXRfY3MuIFllcywgb25lIGlzIHVzaW5nIHNl
dF9jcygpIA0KYW5kIHRoZSBvdGhlciBvbmUgaXMgZ3Bpb2QgdXNlIGNhc2UgaGFuZGxpbmcgaXMg
bWlzc2luZy4gSSBuZWVkIHRvIGl0ZXJhdGUgDQpvdmVyIHRoZSBDU+KAmXMgdG8gZmluZCB0aGUg
Q1MgR1BJTywgY2FsbCBncGlvZF9zZXRfdmFsdWVfY2Fuc2xlZXAgKCApIGFuZCANCnRoZW4gY2Fs
bCBzZXRfY3MoICkuIEluIHRoZSBzZXRfY3MoICkgZHJpdmVyIEFQSSB0aGUgZHJpdmVyIG5lZWRz
IHRvIGZpcnN0IGNoZWNrIA0KaWYgYW55IG9mIHRoZSBjc19pbmRleF9tYXNrIGVuYWJsZWQgQ1Mn
cyBpcyBub3QgYSBDUyBHUElPIGFuZCB0aGVuIGVuYWJsZSANCm9ubHkgdGhlIG5vbi1ncGlvIENT
LiANClBsZWFzZSBsZXQgbWUgeW91ciB0aG91Z2h0cyBvbiB0aGlzIGFwcHJvYWNoLg0KDQo+ID4g
KyAgICAgICAgICAgICAgIH0NCj4gPg0KPiA+IC0gICAgICAgaWYgKHNwaV9nZXRfY3NncGlvZChz
cGksIDApKSB7DQo+ID4gLSAgICAgICAgICAgICAgIGlmICghKHNwaS0+bW9kZSAmIFNQSV9OT19D
UykpIHsNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICAvKg0KPiA+IC0gICAgICAgICAgICAg
ICAgICAgICAgICAqIEhpc3RvcmljYWxseSBBQ1BJIGhhcyBubyBtZWFucyBvZiB0aGUgR1BJTyBw
b2xhcml0eSBhbmQNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICAgKiB0aHVzIHRoZSBTUElT
ZXJpYWxCdXMoKSByZXNvdXJjZSBkZWZpbmVzIGl0IG9uIHRoZSBwZXItY2hpcA0KPiA+IC0gICAg
ICAgICAgICAgICAgICAgICAgICAqIGJhc2lzLiBJbiBvcmRlciB0byBhdm9pZCBhIGNoYWluIG9m
IG5lZ2F0aW9ucywgdGhlIEdQSU8NCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICAgKiBwb2xh
cml0eSBpcyBjb25zaWRlcmVkIGJlaW5nIEFjdGl2ZSBIaWdoLiBFdmVuIGZvciB0aGUgY2FzZXMN
Cj4gPiAtICAgICAgICAgICAgICAgICAgICAgICAgKiB3aGVuIF9EU0QoKSBpcyBpbnZvbHZlZCAo
aW4gdGhlIHVwZGF0ZWQgdmVyc2lvbnMgb2YgQUNQSSkNCj4gPiAtICAgICAgICAgICAgICAgICAg
ICAgICAgKiB0aGUgR1BJTyBDUyBwb2xhcml0eSBtdXN0IGJlIGRlZmluZWQgQWN0aXZlIEhpZ2gg
dG8gYXZvaWQNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICAgKiBhbWJpZ3VpdHkuIFRoYXQn
cyB3aHkgd2UgdXNlIGVuYWJsZSwgdGhhdCB0YWtlcw0KPiBTUElfQ1NfSElHSA0KPiA+IC0gICAg
ICAgICAgICAgICAgICAgICAgICAqIGludG8gYWNjb3VudC4NCj4gPiAtICAgICAgICAgICAgICAg
ICAgICAgICAgKi8NCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICBpZiAoaGFzX2FjcGlfY29t
cGFuaW9uKCZzcGktPmRldikpDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBn
cGlvZF9zZXRfdmFsdWVfY2Fuc2xlZXAoc3BpX2dldF9jc2dwaW9kKHNwaSwgMCksDQo+ICFlbmFi
bGUpOw0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgIGVsc2UNCj4gPiAtICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIC8qIFBvbGFyaXR5IGhhbmRsZWQgYnkgR1BJTyBsaWJyYXJ5ICov
DQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBncGlvZF9zZXRfdmFsdWVfY2Fu
c2xlZXAoc3BpX2dldF9jc2dwaW9kKHNwaSwgMCksDQo+IGFjdGl2YXRlKTsNCj4gPiArICAgICAg
ICAgICAgICAgZm9yIChpZHggPSAwOyBpZHggPCBTUElfQ1NfQ05UX01BWDsgaWR4KyspIHsNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICBpZiAoc3BpX2dldF9jc2dwaW9kKHNwaSwgaWR4KSB8
fCAhc3BpLT5jb250cm9sbGVyLQ0KPiA+c2V0X2NzX3RpbWluZykgew0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgaWYgKGFjdGl2YXRlKQ0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBzcGlfZGVsYXlfZXhlYygmc3BpLT5jc19zZXR1cCwgTlVM
TCk7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBlbHNlDQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNwaV9kZWxheV9leGVjKCZzcGktPmNz
X2luYWN0aXZlLCBOVUxMKTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICB9DQo+IA0KPiBX
b24ndCB5b3UgZGVsYXkgdHdpY2UgaWYgYm90aCBDUydzIGFyZSBiYWNrZWQgYnkgZ3Bpb2QgKGFu
ZCB0aGUgY29udHJvbGxlcg0KPiBkb2VzIG5vdCBpbXBsZW1lbnQgc2V0X2NzX3RpbWluZyk/IFlv
dSBzaG91bGQgcHJvYmFibHkgYnJlYWsgYWZ0ZXIgdGhlDQo+IGZpcnN0IG9yIHNvLg0KPiANCg0K
VHJ1ZSwgSSB3aWxsIGFkZCBhIGNoZWNrIHRvIGF2b2lkIGV4dHJhIGRlbGF5Lg0KDQo+IEkgd29u
ZGVyIGlmIGl0IHdvdWxkIG1ha2VzIHNlbnNlIHRvIGhhdmUgYSBoZWxwZXIgZnVuY3Rpb24gdG8g
c2V0IGNzIHN0YXRlIHRvDQo+IGFsbCBjcydzIGluZGljYXRlZCBieSBjc19pbmRleF9tYXNrIHNv
IHlvdSBjYW4gc2hhcmUgbW9zdCBvZiB0aGUgbG9naWMNCj4gYmV0d2VlbiB0aGUgc2luZ2xlIGFu
ZCBtdWx0aSBjcyBwYXRocy4NCj4gDQo+IEN1cnJlbnRseSBpdCBzZWVtcyBib3RoIHBhdGhzIGhh
dmUgYSBsb3Qgb2YgY29kZSAoYW5kIGNvbW1lbnQpIGR1cGxpY2F0aW9uLA0KPiB3aXRoIHRoZSBk
aWZmZXJlbmNlIGJlaW5nIG9uZSBwYXRoIGlzIHRvdWNoaW5nIG9uZSBjcyBhbmQgdGhlIG90aGVy
IHR3byAob3INCj4gYWxsKS4NCj4gDQoNCkFncmVlZCwgd2lsbCB1cGRhdGUgdGhlIGxvZ2ljLg0K
DQo+ID4gICAgICAgICAgICAgICAgIH0NCj4gPiAtICAgICAgICAgICAgICAgLyogU29tZSBTUEkg
bWFzdGVycyBuZWVkIGJvdGggR1BJTyBDUyAmIHNsYXZlX3NlbGVjdCAqLw0KPiA+IC0gICAgICAg
ICAgICAgICBpZiAoKHNwaS0+Y29udHJvbGxlci0+ZmxhZ3MgJiBTUElfTUFTVEVSX0dQSU9fU1Mp
ICYmDQo+ID4gLSAgICAgICAgICAgICAgICAgICBzcGktPmNvbnRyb2xsZXItPnNldF9jcykNCj4g
PiArICAgICAgIH0gZWxzZSB7DQo+ID4gKyAgICAgICAgICAgICAgIC8qDQo+ID4gKyAgICAgICAg
ICAgICAgICAqIEF2b2lkIGNhbGxpbmcgaW50byB0aGUgZHJpdmVyIChvciBkb2luZyBkZWxheXMp
IGlmIHRoZSBjaGlwIHNlbGVjdA0KPiA+ICsgICAgICAgICAgICAgICAgKiBpc24ndCBhY3R1YWxs
eSBjaGFuZ2luZyBmcm9tIHRoZSBsYXN0IHRpbWUgdGhpcyB3YXMgY2FsbGVkLg0KPiA+ICsgICAg
ICAgICAgICAgICAgKi8NCj4gPiArICAgICAgICAgICAgICAgaWYgKCFmb3JjZSAmJiAoKGVuYWJs
ZSAmJiBzcGktPmNvbnRyb2xsZXItPmxhc3RfY3MgPT0NCj4gPiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHNwaV9nZXRfY2hpcHNlbGVjdChzcGksIGNzX251bSkpIHx8DQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAoIWVuYWJsZSAmJiBzcGktPmNvbnRyb2xsZXIt
Pmxhc3RfY3MgIT0NCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzcGlfZ2V0
X2NoaXBzZWxlY3Qoc3BpLCBjc19udW0pKSkgJiYNCj4gPiArICAgICAgICAgICAgICAgICAgIChz
cGktPmNvbnRyb2xsZXItPmxhc3RfY3NfbW9kZV9oaWdoID09DQo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgKHNwaS0+bW9kZSAmIFNQSV9DU19ISUdIKSkpDQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgcmV0dXJuOw0KPiA+ICsNCj4gPiArICAgICAgICAgICAgICAgdHJhY2Vfc3BpX3NldF9j
cyhzcGksIGFjdGl2YXRlKTsNCj4gPiArDQo+ID4gKyAgICAgICAgICAgICAgIHNwaS0+Y29udHJv
bGxlci0+bGFzdF9jcyA9IGVuYWJsZSA/IHNwaV9nZXRfY2hpcHNlbGVjdChzcGksIGNzX251bSkN
Cj4gOiAtMTsNCj4gPiArICAgICAgICAgICAgICAgc3BpLT5jb250cm9sbGVyLT5sYXN0X2NzX21v
ZGVfaGlnaCA9IHNwaS0+bW9kZSAmDQo+ID4gKyBTUElfQ1NfSElHSDsNCj4gPiArDQo+ID4gKyAg
ICAgICAgICAgICAgIGlmICgoc3BpX2dldF9jc2dwaW9kKHNwaSwgY3NfbnVtKSB8fCAhc3BpLT5j
b250cm9sbGVyLQ0KPiA+c2V0X2NzX3RpbWluZykgJiYgIWFjdGl2YXRlKQ0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgIHNwaV9kZWxheV9leGVjKCZzcGktPmNzX2hvbGQsIE5VTEwpOw0KPiA+
ICsNCj4gPiArICAgICAgICAgICAgICAgaWYgKHNwaS0+bW9kZSAmIFNQSV9DU19ISUdIKQ0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgIGVuYWJsZSA9ICFlbmFibGU7DQo+ID4gKw0KPiA+ICsg
ICAgICAgICAgICAgICBpZiAoc3BpX2dldF9jc2dwaW9kKHNwaSwgY3NfbnVtKSkgew0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgIGlmICghKHNwaS0+bW9kZSAmIFNQSV9OT19DUykpIHsNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC8qDQo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgKiBIaXN0b3JpY2FsbHkgQUNQSSBoYXMgbm8gbWVhbnMgb2YgdGhl
IEdQSU8gcG9sYXJpdHkNCj4gYW5kDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgKiB0aHVzIHRoZSBTUElTZXJpYWxCdXMoKSByZXNvdXJjZSBkZWZpbmVzIGl0IG9uIHRoZSBw
ZXItDQo+IGNoaXANCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqIGJhc2lz
LiBJbiBvcmRlciB0byBhdm9pZCBhIGNoYWluIG9mIG5lZ2F0aW9ucywgdGhlIEdQSU8NCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqIHBvbGFyaXR5IGlzIGNvbnNpZGVyZWQg
YmVpbmcgQWN0aXZlIEhpZ2guIEV2ZW4gZm9yIHRoZQ0KPiBjYXNlcw0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICogd2hlbiBfRFNEKCkgaXMgaW52b2x2ZWQgKGluIHRoZSB1
cGRhdGVkIHZlcnNpb25zIG9mDQo+IEFDUEkpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKiB0aGUgR1BJTyBDUyBwb2xhcml0eSBtdXN0IGJlIGRlZmluZWQgQWN0aXZlIEhp
Z2ggdG8NCj4gYXZvaWQNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqIGFt
YmlndWl0eS4gVGhhdCdzIHdoeSB3ZSB1c2UgZW5hYmxlLCB0aGF0IHRha2VzDQo+IFNQSV9DU19I
SUdIDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKiBpbnRvIGFjY291bnQu
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKi8NCj4gPiArICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGlmIChoYXNfYWNwaV9jb21wYW5pb24oJnNwaS0+ZGV2KSkN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZ3Bpb2Rfc2V0X3Zh
bHVlX2NhbnNsZWVwKHNwaV9nZXRfY3NncGlvZChzcGksDQo+IGNzX251bSksDQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAhZW5hYmxlKTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGVsc2UNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLyogUG9sYXJpdHkgaGFu
ZGxlZCBieSBHUElPIGxpYnJhcnkgKi8NCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgZ3Bpb2Rfc2V0X3ZhbHVlX2NhbnNsZWVwKHNwaV9nZXRfY3NncGlvZChzcGks
DQo+IGNzX251bSksDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBhY3RpdmF0ZSk7DQo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICAgfQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIC8qIFNvbWUgU1BJIG1hc3Rl
cnMgbmVlZCBib3RoIEdQSU8gQ1MgJiBzbGF2ZV9zZWxlY3QgKi8NCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgICBpZiAoKHNwaS0+Y29udHJvbGxlci0+ZmxhZ3MgJiBTUElfTUFTVEVSX0dQSU9f
U1MpICYmDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgIHNwaS0+Y29udHJvbGxlci0+
c2V0X2NzKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3BpLT5jb250cm9s
bGVyLT5zZXRfY3Moc3BpLCAhZW5hYmxlKTsNCj4gPiArICAgICAgICAgICAgICAgfSBlbHNlIGlm
IChzcGktPmNvbnRyb2xsZXItPnNldF9jcykgew0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAg
IHNwaS0+Y29udHJvbGxlci0+c2V0X2NzKHNwaSwgIWVuYWJsZSk7DQo+ID4gLSAgICAgICB9IGVs
c2UgaWYgKHNwaS0+Y29udHJvbGxlci0+c2V0X2NzKSB7DQo+ID4gLSAgICAgICAgICAgICAgIHNw
aS0+Y29udHJvbGxlci0+c2V0X2NzKHNwaSwgIWVuYWJsZSk7DQo+ID4gLSAgICAgICB9DQo+ID4g
KyAgICAgICAgICAgICAgIH0NCj4gPg0KPiA+IC0gICAgICAgaWYgKHNwaV9nZXRfY3NncGlvZChz
cGksIDApIHx8ICFzcGktPmNvbnRyb2xsZXItPnNldF9jc190aW1pbmcpIHsNCj4gPiAtICAgICAg
ICAgICAgICAgaWYgKGFjdGl2YXRlKQ0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgIHNwaV9k
ZWxheV9leGVjKCZzcGktPmNzX3NldHVwLCBOVUxMKTsNCj4gPiAtICAgICAgICAgICAgICAgZWxz
ZQ0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgIHNwaV9kZWxheV9leGVjKCZzcGktPmNzX2lu
YWN0aXZlLCBOVUxMKTsNCj4gPiArICAgICAgICAgICAgICAgaWYgKHNwaV9nZXRfY3NncGlvZChz
cGksIGNzX251bSkgfHwgIXNwaS0+Y29udHJvbGxlci0NCj4gPnNldF9jc190aW1pbmcpIHsNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICBpZiAoYWN0aXZhdGUpDQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBzcGlfZGVsYXlfZXhlYygmc3BpLT5jc19zZXR1cCwgTlVMTCk7
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgZWxzZQ0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgc3BpX2RlbGF5X2V4ZWMoJnNwaS0+Y3NfaW5hY3RpdmUsIE5VTEwpOw0K
PiA+ICsgICAgICAgICAgICAgICB9DQo+ID4gICAgICAgICB9DQo+ID4gIH0NCj4gPg0KPiA+IEBA
IC0yMjQ2LDggKzIzMjAsOCBAQCBzdGF0aWMgdm9pZCBvZl9zcGlfcGFyc2VfZHRfY3NfZGVsYXko
c3RydWN0DQo+ID4gZGV2aWNlX25vZGUgKm5jLCAgc3RhdGljIGludCBvZl9zcGlfcGFyc2VfZHQo
c3RydWN0IHNwaV9jb250cm9sbGVyICpjdGxyLA0KPiBzdHJ1Y3Qgc3BpX2RldmljZSAqc3BpLA0K
PiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBkZXZpY2Vfbm9kZSAqbmMpICB7
DQo+ID4gLSAgICAgICB1MzIgdmFsdWU7DQo+ID4gLSAgICAgICBpbnQgcmM7DQo+ID4gKyAgICAg
ICB1MzIgdmFsdWUsIGNzW1NQSV9DU19DTlRfTUFYXSA9IHswfTsNCj4gPiArICAgICAgIGludCBy
YywgaWR4Ow0KPiA+DQo+ID4gICAgICAgICAvKiBNb2RlIChjbG9jayBwaGFzZS9wb2xhcml0eS9l
dGMuKSAqLw0KPiA+ICAgICAgICAgaWYgKG9mX3Byb3BlcnR5X3JlYWRfYm9vbChuYywgInNwaS1j
cGhhIikpIEBAIC0yMzIwLDEzDQo+ID4gKzIzOTQsMjEgQEAgc3RhdGljIGludCBvZl9zcGlfcGFy
c2VfZHQoc3RydWN0IHNwaV9jb250cm9sbGVyICpjdGxyLCBzdHJ1Y3QNCj4gc3BpX2RldmljZSAq
c3BpLA0KPiA+ICAgICAgICAgfQ0KPiA+DQo+ID4gICAgICAgICAvKiBEZXZpY2UgYWRkcmVzcyAq
Lw0KPiA+IC0gICAgICAgcmMgPSBvZl9wcm9wZXJ0eV9yZWFkX3UzMihuYywgInJlZyIsICZ2YWx1
ZSk7DQo+ID4gLSAgICAgICBpZiAocmMpIHsNCj4gPiArICAgICAgIHJjID0gb2ZfcHJvcGVydHlf
cmVhZF92YXJpYWJsZV91MzJfYXJyYXkobmMsICJyZWciLCAmY3NbMF0sIDEsDQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFNQSV9DU19DTlRfTUFY
KTsNCj4gPiArICAgICAgIGlmIChyYyA8IDAgfHwgcmMgPiBjdGxyLT5udW1fY2hpcHNlbGVjdCkg
ew0KPiA+ICAgICAgICAgICAgICAgICBkZXZfZXJyKCZjdGxyLT5kZXYsICIlcE9GIGhhcyBubyB2
YWxpZCAncmVnJyBwcm9wZXJ0eSAoJWQpXG4iLA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAg
IG5jLCByYyk7DQo+ID4gICAgICAgICAgICAgICAgIHJldHVybiByYzsNCj4gPiArICAgICAgIH0g
ZWxzZSBpZiAoKG9mX3Byb3BlcnR5X3JlYWRfYm9vbChuYywgInBhcmFsbGVsLW1lbW9yaWVzIikp
ICYmDQo+ID4gKyAgICAgICAgICAgICAgICAgICghY3Rsci0+bXVsdGlfY3NfY2FwKSkgew0KPiA+
ICsgICAgICAgICAgICAgICBkZXZfZXJyKCZjdGxyLT5kZXYsICJTUEkgY29udHJvbGxlciBkb2Vz
bid0IHN1cHBvcnQgbXVsdGkgQ1NcbiIpOw0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gLUVJ
TlZBTDsNCj4gPiAgICAgICAgIH0NCj4gPiAtICAgICAgIHNwaV9zZXRfY2hpcHNlbGVjdChzcGks
IDAsIHZhbHVlKTsNCj4gPiArICAgICAgIGZvciAoaWR4ID0gMDsgaWR4IDwgcmM7IGlkeCsrKQ0K
PiA+ICsgICAgICAgICAgICAgICBzcGlfc2V0X2NoaXBzZWxlY3Qoc3BpLCBpZHgsIGNzW2lkeF0p
Ow0KPiA+ICsgICAgICAgLyogQnkgZGVmYXVsdCBzZXQgdGhlIHNwaS0+Y3NfaW5kZXhfbWFzayBh
cyAxICovDQo+ID4gKyAgICAgICBzcGktPmNzX2luZGV4X21hc2sgPSAweDAxOw0KPiA+DQo+ID4g
ICAgICAgICAvKiBEZXZpY2Ugc3BlZWQgKi8NCj4gPiAgICAgICAgIGlmICghb2ZfcHJvcGVydHlf
cmVhZF91MzIobmMsICJzcGktbWF4LWZyZXF1ZW5jeSIsICZ2YWx1ZSkpIEBADQo+ID4gLTM4NDYs
NiArMzkyOCw3IEBAIHN0YXRpYyBpbnQgX19zcGlfdmFsaWRhdGUoc3RydWN0IHNwaV9kZXZpY2Ug
KnNwaSwgc3RydWN0DQo+IHNwaV9tZXNzYWdlICptZXNzYWdlKQ0KPiA+ICAgICAgICAgc3RydWN0
IHNwaV9jb250cm9sbGVyICpjdGxyID0gc3BpLT5jb250cm9sbGVyOw0KPiA+ICAgICAgICAgc3Ry
dWN0IHNwaV90cmFuc2ZlciAqeGZlcjsNCj4gPiAgICAgICAgIGludCB3X3NpemU7DQo+ID4gKyAg
ICAgICB1MzIgY3NfbnVtID0gX19mZnMoc3BpLT5jc19pbmRleF9tYXNrKTsNCj4gPg0KPiA+ICAg
ICAgICAgaWYgKGxpc3RfZW1wdHkoJm1lc3NhZ2UtPnRyYW5zZmVycykpDQo+ID4gICAgICAgICAg
ICAgICAgIHJldHVybiAtRUlOVkFMOw0KPiA+IEBAIC0zODU4LDcgKzM5NDEsNyBAQCBzdGF0aWMg
aW50IF9fc3BpX3ZhbGlkYXRlKHN0cnVjdCBzcGlfZGV2aWNlICpzcGksDQo+IHN0cnVjdCBzcGlf
bWVzc2FnZSAqbWVzc2FnZSkNCj4gPiAgICAgICAgICAqIGNzX2NoYW5nZSBpcyBzZXQgZm9yIGVh
Y2ggdHJhbnNmZXIuDQo+ID4gICAgICAgICAgKi8NCj4gPiAgICAgICAgIGlmICgoc3BpLT5tb2Rl
ICYgU1BJX0NTX1dPUkQpICYmICghKGN0bHItPm1vZGVfYml0cyAmDQo+IFNQSV9DU19XT1JEKSB8
fA0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNwaV9nZXRf
Y3NncGlvZChzcGksIDApKSkgew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHNwaV9nZXRfY3NncGlvZChzcGksDQo+ID4gKyBjc19udW0pKSkgew0KPiANCj4g
V291bGRuJ3QgeW91IG5lZWQgdG8gY2hlY2sgZm9yIGFueSBvZiB0aGUgY3NfaW5kZXhfbWFzayBl
bmFibGVkIENTJ3MsIGFuZA0KPiBub3QganVzdCB0aGUgZmlyc3Qgb25lPyBBRkFJQ1QgeW91IHdv
dWxkIGN1cnJlbnRseSBmYWlsIHRvIGNhdGNoIGENCj4gU1BJX0NTX1dPUkQgdHJhbnNmZXIgd2l0
aCBib3RoIGNzIGVuYWJsZWQgd2hlcmUgdGhlIGZpcnN0IG9uZSBpcyBhDQo+IFNQSV9DU19XT1JE
IGNhcGFibGUgbmF0aXZlIENTIGFuZCB0aGUgc2Vjb25kIG9uZSBhIGdwaW9kLg0KPiANCg0KVGhh
dOKAmXMgdHJ1ZSwgSSB3aWxsIGFkZCBhIGxvb3AgYW5kIGNoZWNrIGZvciBlYWNoIG9mIHRoZSBj
c19pbmRleF9tYXNrIA0KZW5hYmxlZCBDUydzLg0KDQo+ID4gICAgICAgICAgICAgICAgIHNpemVf
dCBtYXhzaXplOw0KPiA+ICAgICAgICAgICAgICAgICBpbnQgcmV0Ow0KPiA+DQo+ID4gZGlmZiAt
LWdpdCBhL2luY2x1ZGUvbGludXgvc3BpL3NwaS5oIGIvaW5jbHVkZS9saW51eC9zcGkvc3BpLmgg
aW5kZXgNCj4gPiBiZGIzNWE5MWI0YmYuLjQ1MjY4MmFhMWEzOSAxMDA2NDQNCj4gPiAtLS0gYS9p
bmNsdWRlL2xpbnV4L3NwaS9zcGkuaA0KPiA+ICsrKyBiL2luY2x1ZGUvbGludXgvc3BpL3NwaS5o
DQo+ID4gQEAgLTE5LDYgKzE5LDExIEBADQo+ID4gICNpbmNsdWRlIDxsaW51eC9hY3BpLmg+DQo+
ID4gICNpbmNsdWRlIDxsaW51eC91NjRfc3RhdHNfc3luYy5oPg0KPiA+DQo+ID4gKy8qIE1heCBu
by4gb2YgQ1Mgc3VwcG9ydGVkIHBlciBzcGkgZGV2aWNlICovICNkZWZpbmUgU1BJX0NTX0NOVF9N
QVggMg0KPiA+ICsNCj4gPiArLyogY2hpcCBzZWxlY3QgbWFzayAqLw0KPiA+ICsjZGVmaW5lIFNQ
SV9QQVJBTExFTF9DU19NQVNLICAgKEJJVCgwKSB8IEJJVCgxKSkNCj4gPiAgc3RydWN0IGRtYV9j
aGFuOw0KPiA+ICBzdHJ1Y3Qgc29mdHdhcmVfbm9kZTsNCj4gPiAgc3RydWN0IHB0cF9zeXN0ZW1f
dGltZXN0YW1wOw0KPiA+IEBAIC0xNjYsNiArMTcxLDcgQEAgZXh0ZXJuIHZvaWQNCj4gc3BpX3Ry
YW5zZmVyX2NzX2NoYW5nZV9kZWxheV9leGVjKHN0cnVjdCBzcGlfbWVzc2FnZSAqbXNnLA0KPiA+
ICAgKiAgICAgZGVhc3NlcnRlZC4gSWYgQGNzX2NoYW5nZV9kZWxheSBpcyB1c2VkIGZyb20gQHNw
aV90cmFuc2ZlciwgdGhlbg0KPiB0aGUNCj4gPiAgICogICAgIHR3byBkZWxheXMgd2lsbCBiZSBh
ZGRlZCB1cC4NCj4gPiAgICogQHBjcHVfc3RhdGlzdGljczogc3RhdGlzdGljcyBmb3IgdGhlIHNw
aV9kZXZpY2UNCj4gPiArICogQGNzX2luZGV4X21hc2s6IEJpdCBtYXNrIG9mIHRoZSBhY3RpdmUg
Y2hpcHNlbGVjdChzKSBpbiB0aGUNCj4gPiArIGNoaXBzZWxlY3QgYXJyYXkNCj4gPiAgICoNCj4g
PiAgICogQSBAc3BpX2RldmljZSBpcyB1c2VkIHRvIGludGVyY2hhbmdlIGRhdGEgYmV0d2VlbiBh
biBTUEkgc2xhdmUNCj4gPiAgICogKHVzdWFsbHkgYSBkaXNjcmV0ZSBjaGlwKSBhbmQgQ1BVIG1l
bW9yeS4NCj4gPiBAQCAtMTgxLDcgKzE4Nyw3IEBAIHN0cnVjdCBzcGlfZGV2aWNlIHsNCj4gPiAg
ICAgICAgIHN0cnVjdCBzcGlfY29udHJvbGxlciAgICpjb250cm9sbGVyOw0KPiA+ICAgICAgICAg
c3RydWN0IHNwaV9jb250cm9sbGVyICAgKm1hc3RlcjsgICAgICAgIC8qIENvbXBhdGliaWxpdHkg
bGF5ZXIgKi8NCj4gPiAgICAgICAgIHUzMiAgICAgICAgICAgICAgICAgICAgIG1heF9zcGVlZF9o
ejsNCj4gPiAtICAgICAgIHU4ICAgICAgICAgICAgICAgICAgICAgIGNoaXBfc2VsZWN0Ow0KPiA+
ICsgICAgICAgdTggICAgICAgICAgICAgICAgICAgICAgY2hpcF9zZWxlY3RbU1BJX0NTX0NOVF9N
QVhdOw0KPiA+ICAgICAgICAgdTggICAgICAgICAgICAgICAgICAgICAgYml0c19wZXJfd29yZDsN
Cj4gPiAgICAgICAgIGJvb2wgICAgICAgICAgICAgICAgICAgIHJ0Ow0KPiA+ICAjZGVmaW5lIFNQ
SV9OT19UWCAgICAgIEJJVCgzMSkgICAgICAgICAvKiBObyB0cmFuc21pdCB3aXJlICovDQo+ID4g
QEAgLTIwMiw3ICsyMDgsNyBAQCBzdHJ1Y3Qgc3BpX2RldmljZSB7DQo+ID4gICAgICAgICB2b2lk
ICAgICAgICAgICAgICAgICAgICAqY29udHJvbGxlcl9kYXRhOw0KPiA+ICAgICAgICAgY2hhciAg
ICAgICAgICAgICAgICAgICAgbW9kYWxpYXNbU1BJX05BTUVfU0laRV07DQo+ID4gICAgICAgICBj
b25zdCBjaGFyICAgICAgICAgICAgICAqZHJpdmVyX292ZXJyaWRlOw0KPiA+IC0gICAgICAgc3Ry
dWN0IGdwaW9fZGVzYyAgICAgICAgKmNzX2dwaW9kOyAgICAgIC8qIENoaXAgc2VsZWN0IGdwaW8g
ZGVzYyAqLw0KPiA+ICsgICAgICAgc3RydWN0IGdwaW9fZGVzYyAgICAgICAgKmNzX2dwaW9kW1NQ
SV9DU19DTlRfTUFYXTsgICAgICAvKiBDaGlwIHNlbGVjdA0KPiBncGlvIGRlc2MgKi8NCj4gPiAg
ICAgICAgIHN0cnVjdCBzcGlfZGVsYXkgICAgICAgIHdvcmRfZGVsYXk7IC8qIEludGVyLXdvcmQg
ZGVsYXkgKi8NCj4gPiAgICAgICAgIC8qIENTIGRlbGF5cyAqLw0KPiA+ICAgICAgICAgc3RydWN0
IHNwaV9kZWxheSAgICAgICAgY3Nfc2V0dXA7DQo+ID4gQEAgLTIxMiw2ICsyMTgsMTMgQEAgc3Ry
dWN0IHNwaV9kZXZpY2Ugew0KPiA+ICAgICAgICAgLyogVGhlIHN0YXRpc3RpY3MgKi8NCj4gPiAg
ICAgICAgIHN0cnVjdCBzcGlfc3RhdGlzdGljcyBfX3BlcmNwdSAgKnBjcHVfc3RhdGlzdGljczsN
Cj4gPg0KPiA+ICsgICAgICAgLyogQml0IG1hc2sgb2YgdGhlIGNoaXBzZWxlY3QocykgdGhhdCB0
aGUgZHJpdmVyIG5lZWQgdG8gdXNlIGZyb20NCj4gPiArICAgICAgICAqIHRoZSBjaGlwc2VsZWN0
IGFycmF5LldoZW4gdGhlIGNvbnRyb2xsZXIgaXMgY2FwYWJsZSB0byBoYW5kbGUNCj4gPiArICAg
ICAgICAqIG11bHRpcGxlIGNoaXAgc2VsZWN0cyAmIG1lbW9yaWVzIGFyZSBjb25uZWN0ZWQgaW4g
cGFyYWxsZWwNCj4gPiArICAgICAgICAqIHRoZW4gbW9yZSB0aGFuIG9uZSBiaXQgbmVlZCB0byBi
ZSBzZXQgaW4gY3NfaW5kZXhfbWFzay4NCj4gPiArICAgICAgICAqLw0KPiA+ICsgICAgICAgdTMy
ICAgICAgICAgICAgICAgICAgICAgY3NfaW5kZXhfbWFzayA6IDI7DQo+IA0KPiBTUElfQ1NfQ05U
X01BWD8NCj4gDQoNCkFncmVlZCwgd2lsbCByZXBsYWNlIDIgd2l0aCBTUElfQ1NfQ05UX01BWC4N
Cg0KPiA+ICsNCj4gPiAgICAgICAgIC8qDQo+ID4gICAgICAgICAgKiBsaWtlbHkgbmVlZCBtb3Jl
IGhvb2tzIGZvciBtb3JlIHByb3RvY29sIG9wdGlvbnMgYWZmZWN0aW5nIGhvdw0KPiA+ICAgICAg
ICAgICogdGhlIGNvbnRyb2xsZXIgdGFsa3MgdG8gZWFjaCBjaGlwLCBsaWtlOg0KPiA+IEBAIC0y
NjgsMjIgKzI4MSwyMiBAQCBzdGF0aWMgaW5saW5lIHZvaWQgKnNwaV9nZXRfZHJ2ZGF0YShzdHJ1
Y3QNCj4gPiBzcGlfZGV2aWNlICpzcGkpDQo+ID4NCj4gPiAgc3RhdGljIGlubGluZSB1OCBzcGlf
Z2V0X2NoaXBzZWxlY3Qoc3RydWN0IHNwaV9kZXZpY2UgKnNwaSwgdTggaWR4KQ0KPiA+IHsNCj4g
PiAtICAgICAgIHJldHVybiBzcGktPmNoaXBfc2VsZWN0Ow0KPiA+ICsgICAgICAgcmV0dXJuIHNw
aS0+Y2hpcF9zZWxlY3RbaWR4XTsNCj4gPiAgfQ0KPiA+DQo+ID4gIHN0YXRpYyBpbmxpbmUgdm9p
ZCBzcGlfc2V0X2NoaXBzZWxlY3Qoc3RydWN0IHNwaV9kZXZpY2UgKnNwaSwgdTggaWR4LA0KPiA+
IHU4IGNoaXBzZWxlY3QpICB7DQo+ID4gLSAgICAgICBzcGktPmNoaXBfc2VsZWN0ID0gY2hpcHNl
bGVjdDsNCj4gPiArICAgICAgIHNwaS0+Y2hpcF9zZWxlY3RbaWR4XSA9IGNoaXBzZWxlY3Q7DQo+
ID4gIH0NCj4gPg0KPiA+ICBzdGF0aWMgaW5saW5lIHN0cnVjdCBncGlvX2Rlc2MgKnNwaV9nZXRf
Y3NncGlvZChzdHJ1Y3Qgc3BpX2RldmljZQ0KPiA+ICpzcGksIHU4IGlkeCkgIHsNCj4gPiAtICAg
ICAgIHJldHVybiBzcGktPmNzX2dwaW9kOw0KPiA+ICsgICAgICAgcmV0dXJuIHNwaS0+Y3NfZ3Bp
b2RbaWR4XTsNCj4gPiAgfQ0KPiA+DQo+ID4gIHN0YXRpYyBpbmxpbmUgdm9pZCBzcGlfc2V0X2Nz
Z3Bpb2Qoc3RydWN0IHNwaV9kZXZpY2UgKnNwaSwgdTggaWR4LA0KPiA+IHN0cnVjdCBncGlvX2Rl
c2MgKmNzZ3Bpb2QpICB7DQo+ID4gLSAgICAgICBzcGktPmNzX2dwaW9kID0gY3NncGlvZDsNCj4g
PiArICAgICAgIHNwaS0+Y3NfZ3Bpb2RbaWR4XSA9IGNzZ3Bpb2Q7DQo+ID4gIH0NCj4gPg0KPiA+
ICAvKioNCj4gPiBAQCAtMzg4LDYgKzQwMSw4IEBAIGV4dGVybiBzdHJ1Y3Qgc3BpX2RldmljZQ0K
PiAqc3BpX25ld19hbmNpbGxhcnlfZGV2aWNlKHN0cnVjdCBzcGlfZGV2aWNlICpzcGksIHU4IGNo
DQo+ID4gICAqIEBidXNfbG9ja19zcGlubG9jazogc3BpbmxvY2sgZm9yIFNQSSBidXMgbG9ja2lu
Zw0KPiA+ICAgKiBAYnVzX2xvY2tfbXV0ZXg6IG11dGV4IGZvciBleGNsdXNpb24gb2YgbXVsdGlw
bGUgY2FsbGVycw0KPiA+ICAgKiBAYnVzX2xvY2tfZmxhZzogaW5kaWNhdGVzIHRoYXQgdGhlIFNQ
SSBidXMgaXMgbG9ja2VkIGZvciBleGNsdXNpdmUNCj4gPiB1c2UNCj4gPiArICogQG11bHRpX2Nz
X2NhcDogaW5kaWNhdGVzIHRoYXQgdGhlIFNQSSBDb250cm9sbGVyIGNhbiBhc3NlcnQvZGUtYXNz
ZXJ0DQo+ID4gKyAqICAgICBtb3JlIHRoYW4gb25lIGNoaXAgc2VsZWN0IGF0IG9uY2UuDQo+ID4g
ICAqIEBzZXR1cDogdXBkYXRlcyB0aGUgZGV2aWNlIG1vZGUgYW5kIGNsb2NraW5nIHJlY29yZHMg
dXNlZCBieSBhDQo+ID4gICAqICAgICBkZXZpY2UncyBTUEkgY29udHJvbGxlcjsgcHJvdG9jb2wg
Y29kZSBtYXkgY2FsbCB0aGlzLiAgVGhpcw0KPiA+ICAgKiAgICAgbXVzdCBmYWlsIGlmIGFuIHVu
cmVjb2duaXplZCBvciB1bnN1cHBvcnRlZCBtb2RlIGlzIHJlcXVlc3RlZC4NCj4gPiBAQCAtNTg1
LDYgKzYwMCwxMyBAQCBzdHJ1Y3Qgc3BpX2NvbnRyb2xsZXIgew0KPiA+ICAgICAgICAgLyogRmxh
ZyBpbmRpY2F0aW5nIHRoYXQgdGhlIFNQSSBidXMgaXMgbG9ja2VkIGZvciBleGNsdXNpdmUgdXNl
ICovDQo+ID4gICAgICAgICBib29sICAgICAgICAgICAgICAgICAgICBidXNfbG9ja19mbGFnOw0K
PiA+DQo+ID4gKyAgICAgICAvKg0KPiA+ICsgICAgICAgICogRmxhZyBpbmRpY2F0aW5nIHRoYXQg
dGhlIHNwaS1jb250cm9sbGVyIGhhcyBtdWx0aSBjaGlwIHNlbGVjdA0KPiA+ICsgICAgICAgICog
Y2FwYWJpbGl0eSBhbmQgY2FuIGFzc2VydC9kZS1hc3NlcnQgbW9yZSB0aGFuIG9uZSBjaGlwIHNl
bGVjdA0KPiA+ICsgICAgICAgICogYXQgb25jZS4NCj4gPiArICAgICAgICAqLw0KPiA+ICsgICAg
ICAgYm9vbCAgICAgICAgICAgICAgICAgICAgbXVsdGlfY3NfY2FwOw0KPiANCj4gSSBhZG1pdCBJ
IGhhdmVuJ3QgZm9sbG93ZWQgdGhlIGZpcnN0IGl0ZXJhdGlvbnMsIGJ1dCBJcyB0aGVyZSBhIHJl
YXNvbiB0aGlzIGlzbid0IGENCj4gU1BJX1hYWCBmbGFnIGluIHNwaS5oPyBUaGVyZSBzZWVtIHRv
IGJlIHF1aXRlIGEgZmV3IGZyZWUgYml0cyBsZWZ0Lg0KPiANCg0KWWVzLCBpdCBjYW4gYmUgYSBT
UElfWFggZmxhZyBhcyB3ZWxsLiBJIHdpbGwgYWRkIGEgZmxhZyAmIHJlbW92ZSB0aGlzIA0Kc3Ry
dWN0dXJlIG1lbWJlci4NCg0KPiBJIHdvdWxkIHRoaW5rIG11bHRpX2NzIGNhbiBiZSBlbXVsYXRl
ZCAoc29tZXdoYXQpIHZpYSBncGlvZCBmb3IgdGhlIHNlY29uZA0KPiBDUyBhcyBsb25nIGFzIHRo
ZSBjb250cm9sbGVyIHN1cHBvcnRzIHNldF9jcygpIChhbmQgU1BJX05PX0NTPykuDQo+IA0KDQpJ
dCBpcyBub3QganVzdCBhYm91dCBoYW5kbGluZyB0aGUgQ1MncywgYnV0IHJhdGhlciB0aGlzIGZs
YWcgaW5kaWNhdGVzIA0KdGhhdCB0aGUgY29udHJvbGxlciBjYW4gY29tbXVuaWNhdGUgKHJlYWRp
bmcgJiB3cml0aW5nIGRhdGEpIHdpdGggDQpib3RoIHRoZSBkZXZpY2VzIHNpbXVsdGFuZW91c2x5
Lg0KDQpSZWdhcmRzLA0KQW1pdA0KDQo+ID4gKw0KPiA+ICAgICAgICAgLyogU2V0dXAgbW9kZSBh
bmQgY2xvY2ssIGV0YyAoc3BpIGRyaXZlciBtYXkgY2FsbCBtYW55IHRpbWVzKS4NCj4gPiAgICAg
ICAgICAqDQo+ID4gICAgICAgICAgKiBJTVBPUlRBTlQ6ICB0aGlzIG1heSBiZSBjYWxsZWQgd2hl
biB0cmFuc2ZlcnMgdG8gYW5vdGhlcg0KPiA+IC0tDQo+ID4gMi4yNS4xDQo+ID4NCj4gDQo+IFJl
Z2FyZHMNCj4gSm9uYXMNCg==
