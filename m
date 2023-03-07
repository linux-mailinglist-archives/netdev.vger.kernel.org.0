Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABDB56ADCF4
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjCGLLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbjCGLK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:10:59 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85933E09A;
        Tue,  7 Mar 2023 03:09:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5d+bSdHFz/WeDt6E9+NDkFLikvRUsXBQvaxH1J/riSWfx7rIgLUZ4u5pBtHM+jccBGdwwi+vCo4tV/u7a/GRHCSp4jnplhyhkRwDzdEYCyfQyJ9NaUEBHhC8MVTovXLRJKFACe0CD4XxkGtzyL8wvNSH2uE7bA1lPjzHvr3SSSz5OqAnsDtxV0kyudgFVOiwljugPaN8ImPlY9bQmj83b8fH/v24xt7JsqP+htX+iCjRfy5pX00+lDIRyeSb2hhT/AhyMbNGxqhDKoyQXT9EPgHqNmMtyGGrkXlLV5huV+mEWBm5gXh3J0YTPV15c1uwtjLMSgH2W4m93D0WBDi1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EHD+Vpjd5tNcCRoTDGhd35+SqFCuCTXSYA7mtdan5gM=;
 b=E9mfIoKObSlypkaamGJLOe2KkTaKytl69bloILm9EkroVHyClEGeaBSIe6T2QnoZxGXOua3CunKwblTdIR2awoNBqe+TYVk69Pd/RiB4tXQfD8pkh1s/xvaxaXgFy1AkdCGdt+AvcmIpp+kIhPTjfuGftQl3WKh6Lsl+fymhlKeWLt3s8GirUi/YfhUwTvwyZLLJzygFH+VHr55oInXxmZFgHR5wcvuxysh7iBAHEuozU22oEghAAbHECrideXe4HG/+MBXtb0o15I3IMRR5wbQnOxSzOeO9blTzBQfJOCvEDosoC032JBwepnYKZZ3vrXA4yGuTsqTvxMsT/g6UAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EHD+Vpjd5tNcCRoTDGhd35+SqFCuCTXSYA7mtdan5gM=;
 b=joceivhgLnBA0XHPJkEeZ6b/zH/BCTdOVfLYCnVU4U8i6kGUU2fdaYx9yk+FHUnSfPlDCIB6xrq26zkWBHq018BHb2kNNtOtEOlg4SxRq5MCQLLeNR8A2tZovCoMLYIUPNKcB8eC5zDofsgTAOOidXIQEQL4KbXe6NB731cHi58=
Received: from BN7PR12MB2802.namprd12.prod.outlook.com (2603:10b6:408:25::33)
 by DS0PR12MB8318.namprd12.prod.outlook.com (2603:10b6:8:f6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 11:09:41 +0000
Received: from BN7PR12MB2802.namprd12.prod.outlook.com
 ([fe80::96c6:f419:e49a:1785]) by BN7PR12MB2802.namprd12.prod.outlook.com
 ([fe80::96c6:f419:e49a:1785%7]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 11:09:41 +0000
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
        "amitrkcian2002@gmail.com" <amitrkcian2002@gmail.com>
Subject: RE: [PATCH V5 09/15] spi: Add stacked and parallel memories support
 in SPI core
Thread-Topic: [PATCH V5 09/15] spi: Add stacked and parallel memories support
 in SPI core
Thread-Index: AQHZUFDgolfpAHzRAEiHg/XQpMwU3q7uLAkAgAD9XyA=
Date:   Tue, 7 Mar 2023 11:09:41 +0000
Message-ID: <BN7PR12MB2802A2E7A193B8BC0073812BDCB79@BN7PR12MB2802.namprd12.prod.outlook.com>
References: <20230306172109.595464-1-amit.kumar-mahapatra@amd.com>
 <20230306172109.595464-10-amit.kumar-mahapatra@amd.com>
 <CAOiHx=nmsAh3ADL3s0eZKpEZJqCB_POi=8YjfxrHYLEbjRfwHg@mail.gmail.com>
In-Reply-To: <CAOiHx=nmsAh3ADL3s0eZKpEZJqCB_POi=8YjfxrHYLEbjRfwHg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR12MB2802:EE_|DS0PR12MB8318:EE_
x-ms-office365-filtering-correlation-id: 1be36a93-277a-4750-8061-08db1efc72de
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QQaRLzqTHAb+4iQlNZ/EPpKZwnDn2N5Nqw5yAuQJMozDjX9xxgQOpiqBwwEWAH6+IcPkPi78O/3/ftB/OZkNCRQ2ZPlhSWFwnQq+JhwLLaNobJVJPi7yPbZK0R6JWriRP9vF2kDZvtloJPHWjVWyOm4C2QUfF8d/j50sxw2mHL/YHqaPmD6MmiD17uCTJFcXm3zIW+Px5jk9aw3EgEKVs2mHm1gBbd5/nwRiGdRkTGAVgYACHU3UGJoBQSvGjRibN7AFNSgYocbmc2YP3xiCxMa1Vi6gXVf5l8Fcj0p4aF/FefEsF3Ym7U3Y9cNYElzspdlRncBPgtrii7fjhg+wtH4n9/oLTuYnFAxgHiAyCWGRD3KqKDlUT8fWjVVSR3QdgFvy6L24gSM6RiKS0RvM/1/I5kWBuw2HUlsFbjNBI8JOAx74YRJAAAIhFquxNvS/DtY+5J1LlK5WaAXzAAgBCpYGs5Crhcemazdn5Q2hlntmL9IKYq1oi+/d73ruKf8UBYTvX1eIyhZV3C+nspDSEaRVqTpV+7sCRZ8wWulbU56Y1vsRvjy1NJE33yol/9BIBTOxo0veK3mFt+718G3aGZwaOtJj/19qnxeMLz4UAm1Hqhv+XDVkk+/2sbXHqgRX3Rbf5BIUUoLc/T93pXod4e/6NyPpARdjDPU6pjasB92e9O0Mcub/sM60/OhSfRavInkCmKlr+NeSkG92w3xJP6nGWFY169nkFjIi6xEpk84jFM+J4LpvDfRo99sPPeyyHdUckV0kQYa5MA17KicoAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR12MB2802.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(451199018)(7406005)(7366002)(7336002)(8936002)(2906002)(7416002)(7276002)(5660300002)(52536014)(41300700001)(76116006)(83380400001)(4326008)(66476007)(66946007)(6916009)(66446008)(66556008)(8676002)(64756008)(54906003)(33656002)(7696005)(45426003)(71200400001)(53546011)(6506007)(478600001)(55016003)(86362001)(9686003)(316002)(186003)(122000001)(38100700002)(26005)(38070700005)(15866825006)(41080700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QU1oODMvWGhVMEZlY3VzL3czb0M0N0J4aHp5V3FraGlMZUFCSEVRRWVjR25o?=
 =?utf-8?B?ei9EbFdRMDc4WE9oOHBpd3g0aktLNGdtNDdYR1FDYzIrcmJKWVRTWEFmeTlO?=
 =?utf-8?B?UHgyM1F1OXh3eXJpZ0gxL1FFRmlnY2dTSCtCUWYxN3JRSFBnZ0JxekMxOEhX?=
 =?utf-8?B?clRVM3gwQTRoWFpCZWdpUFhGVUdSR3IxNkx2Qi8wSk9zTmJsYnZBK1gwSmYx?=
 =?utf-8?B?MDBSK1I2VDF6Z2ZGOFJpcmQ0N2ovVGNNUFJZS2JyaDZoU0t4T1lWVytUenNT?=
 =?utf-8?B?VUF1ZitJaUIxUW5Md3F6bzg4S2V6MkFTR3dJK1ZrdERNRWF1TTlyUTk0MFJ1?=
 =?utf-8?B?WnYvVnNUSFRNMDdOd3dxT1p1ZDlZRmhNMHpTQjhReERad1U2dTliTUtsbm1C?=
 =?utf-8?B?RmRENys0TmJGaFo5dk9RNzl3c0g3R2UxKzBLQXhZbUROV1FKa0E3ZkRHUEgv?=
 =?utf-8?B?Q0pobFBoWkRyZjZVanp0MzgxM0ZnMGFBQWMrZlY3SENOaE1FWitpZVZQVENI?=
 =?utf-8?B?bW5tdGg0RTRKRG1BK2hVVjFQMnk5NnEzZlRjbUlUdGpoUi9NTDFWTFE4bElu?=
 =?utf-8?B?a2lZL2FTRTFQV0hGSi9lYmUrVGorNHN1U01PbWV6aCsxU0FZajhsWCtzTHdZ?=
 =?utf-8?B?N3NsdytwYjNDNU83L1NicWNrekdQNEV2TldXc3pRM2ZkMUwwUFNxU0gzVnNl?=
 =?utf-8?B?Qm9wSnUzTHJtSUlkZU5tUFVtMEIyWE94Nm80clMrNkZrN3BIK3VLYzZYOEp6?=
 =?utf-8?B?SFMzeE9yNC84UXVVTzJQSXNieW1YZTNxa05ORXZCTWxlZFdlWjRQaWZGWGxS?=
 =?utf-8?B?SzhiWUxqMnIvZXhMcEhhcSt5amJ6cThxNUhhTjV0dlBvK1J6MnhBWXZ6Z3I5?=
 =?utf-8?B?NEd6QXdVQlRQMERJWnU5aGRPZ0JybS83aXpYN3g1aXU3ekhJdkVIbmhLZXRh?=
 =?utf-8?B?c3pQcnFLalYwbWdNV1dBOFB2TE0vQUpidXRQbkg5akZxYllJa2gwQ1g2d1Nh?=
 =?utf-8?B?eEEwYU5qTXc0YzRETEttd3hrUE40cFJKdCtLN0t6STM0YWR5R1BpL2NiMi9q?=
 =?utf-8?B?NDViK3VhVTNxZHFDN2JEVlZnZHBiOUFQRmV0SHllY1pGTE94QmhOeFYzdk5U?=
 =?utf-8?B?MWEwSmhWOGNIa0x3czFDRG9ac1VWOWtMR3JpQSsrbFZjMGZXeEVpbFU4ZHQr?=
 =?utf-8?B?NWNvMFFRTmlJejV2dk00T3V6S0FSc3NMSkNLRW9yODZTaVBEMTRKcGhac3J2?=
 =?utf-8?B?SFNnR3A1Y3hXZUNweit4MEU5WDJNSzRsRG0wVysrZi9pWVRXSGhhTmR2aUNk?=
 =?utf-8?B?ZnJaQ2Y1UWYxL0g2OHFYSDVwclJkakkyOElPUmhXMks0RG9vQXhjQk8xeW16?=
 =?utf-8?B?TFkyTmxscEo0SEE2QUxoa2lEZXhULytQaHV1Zm1iS3VqR1ZTbmQ0NW9laSt6?=
 =?utf-8?B?RzBORUordWNLcEV4cXBkR0dWVDFQRHE3dndhQkRBdU9SUGRWMERCckw5cjAy?=
 =?utf-8?B?OVM0R09jSDYvWlZxSXd0YmdMeURsSTdIdUFycDVQNWdNTGkrMzZtWUVpa2p5?=
 =?utf-8?B?bUxTMnhRby85NXUyNWgrNHdmMnNXeVhFb1JzLzJaMmNBZmorVzNPU25WU1hE?=
 =?utf-8?B?Sk9rNFNQVnlHcnZOUGZkdEpncGJ6M1hBYTJwWThmRlZ1b0RnWHBhTEJMRzVv?=
 =?utf-8?B?eGpldG1ZTlJVMXkySGlwbU9CanpneVcyb1pMOXNmc0o1alZvY295d2JoRngy?=
 =?utf-8?B?YjR2cEtwRnR0Zml2d2E3L3Y1eGp2ZDg5cjg5VkxwaDJIaWJtU0hpbklILzl1?=
 =?utf-8?B?TWhZWnJKQ0RVUGVONW9DdGhvZ1lrM2VGTC9zVVh5RmxBV0VzRXRKVWpBbXVC?=
 =?utf-8?B?ZUNwem9mUEdXSnpCVHphSHU1V1FNMS9OYm94SFAxRVNtR1E2WE1DdlVVMTB3?=
 =?utf-8?B?OGVZb0NITFFON2RZWTlnZThwdlEvVS9BSVdoUUtCcnErL0FFTElMRFJid3BP?=
 =?utf-8?B?SWExWFNNS2VyZ2FVZ0dlUkI5S2VoZUFLdkUxelRCeFNZL2lpQkxlZDJHMm1v?=
 =?utf-8?B?d2gyUldCQ1hJZXlqWkhsYkpkcjIwM25lZTdURmVGc2prMENjZVR1NHJYcTZC?=
 =?utf-8?Q?LF6w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR12MB2802.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1be36a93-277a-4750-8061-08db1efc72de
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2023 11:09:41.0364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YedORTt2l+HqYNCBBqjw4hda4bFuH8pd+9se3nq0kqbenONdmM7e0u/HmesZntBjnGiCvAJphxIrvgbPAmibaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8318
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9uYXMgR29y
c2tpIDxqb25hcy5nb3Jza2lAZ21haWwuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBNYXJjaCA3LCAy
MDIzIDE6MzEgQU0NCj4gVG86IE1haGFwYXRyYSwgQW1pdCBLdW1hciA8YW1pdC5rdW1hci1tYWhh
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
Lm9yZzsgYW1pdHJrY2lhbjIwMDJAZ21haWwuY29tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggVjUg
MDkvMTVdIHNwaTogQWRkIHN0YWNrZWQgYW5kIHBhcmFsbGVsIG1lbW9yaWVzDQo+IHN1cHBvcnQg
aW4gU1BJIGNvcmUNCj4gDQo+IEhpLA0KPiANCj4gT24gTW9uLCA2IE1hciAyMDIzIGF0IDE4OjI2
LCBBbWl0IEt1bWFyIE1haGFwYXRyYSA8YW1pdC5rdW1hci0NCj4gbWFoYXBhdHJhQGFtZC5jb20+
IHdyb3RlOg0KPiA+DQo+ID4gRm9yIHN1cHBvcnRpbmcgbXVsdGlwbGUgQ1MgdGhlIFNQSSBkZXZp
Y2UgbmVlZCB0byBiZSBhd2FyZSBvZiBhbGwgdGhlDQo+ID4gQ1MgdmFsdWVzLiBTbywgdGhlICJj
aGlwX3NlbGVjdCIgbWVtYmVyIGluIHRoZSBzcGlfZGV2aWNlIHN0cnVjdHVyZSBpcw0KPiA+IG5v
dyBhbiBhcnJheSB0aGF0IGhvbGRzIGFsbCB0aGUgQ1MgdmFsdWVzLg0KPiA+DQo+ID4gc3BpX2Rl
dmljZSBzdHJ1Y3R1cmUgbm93IGhhcyBhICJjc19pbmRleF9tYXNrIiBtZW1iZXIuIFRoaXMgYWN0
cyBhcyBhbg0KPiA+IGluZGV4IHRvIHRoZSBjaGlwX3NlbGVjdCBhcnJheS4gSWYgbnRoIGJpdCBv
ZiBzcGktPmNzX2luZGV4X21hc2sgaXMNCj4gPiBzZXQgdGhlbiB0aGUgZHJpdmVyIHdvdWxkIGFz
c2VydCBzcGktPmNoaXBfc2VsZWN0W25dLg0KPiA+DQo+ID4gSW4gcGFyYWxsZWwgbW9kZSBhbGwg
dGhlIGNoaXAgc2VsZWN0cyBhcmUgYXNzZXJ0ZWQvZGUtYXNzZXJ0ZWQNCj4gPiBzaW11bHRhbmVv
dXNseSBhbmQgZWFjaCBieXRlIG9mIGRhdGEgaXMgc3RvcmVkIGluIGJvdGggZGV2aWNlcywgdGhl
DQo+ID4gZXZlbiBiaXRzIGluIG9uZSwgdGhlIG9kZCBiaXRzIGluIHRoZSBvdGhlci4gVGhlIHNw
bGl0IGlzDQo+ID4gYXV0b21hdGljYWxseSBoYW5kbGVkIGJ5IHRoZSBHUVNQSSBjb250cm9sbGVy
LiBUaGUgR1FTUEkgY29udHJvbGxlcg0KPiA+IHN1cHBvcnRzIGEgbWF4aW11bSBvZiB0d28gZmxh
c2hlcyBjb25uZWN0ZWQgaW4gcGFyYWxsZWwgbW9kZS4gQQ0KPiA+ICJtdWx0aS1jcy1jYXAiIGZs
YWcgaXMgYWRkZWQgaW4gdGhlIHNwaSBjb250cm9udHJvbGxlciBkYXRhLCB0aHJvdWdoDQo+ID4g
Y3Rsci0+bXVsdGktY3MtY2FwIHRoZSBzcGkgY29yZSB3aWxsIG1ha2Ugc3VyZSB0aGF0IHRoZSBj
b250cm9sbGVyIGlzDQo+ID4gY2FwYWJsZSBvZiBoYW5kbGluZyBtdWx0aXBsZSBjaGlwIHNlbGVj
dHMgYXQgb25jZS4NCj4gPg0KPiA+IEZvciBzdXBwb3J0aW5nIG11bHRpcGxlIENTIHZpYSBHUElP
IHRoZSBjc19ncGlvZCBtZW1iZXIgb2YgdGhlDQo+ID4gc3BpX2RldmljZSBzdHJ1Y3R1cmUgaXMg
bm93IGFuIGFycmF5IHRoYXQgaG9sZHMgdGhlIGdwaW8gZGVzY3JpcHRvcg0KPiA+IGZvciBlYWNo
IGNoaXBzZWxlY3QuDQo+ID4NCj4gPiBNdWx0aSBDUyBzdXBwb3J0IHVzaW5nIEdQSU8gaXMgbm90
IHRlc3RlZCBkdWUgdG8gdW5hdmFpbGFiaWxpdHkgb2YNCj4gPiBuZWNlc3NhcnkgaGFyZHdhcmUg
c2V0dXAuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbWl0IEt1bWFyIE1haGFwYXRyYSA8YW1p
dC5rdW1hci0NCj4gbWFoYXBhdHJhQGFtZC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvc3Bp
L3NwaS5jICAgICAgIHwgMjEzICsrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0t
LS0NCj4gPiAgaW5jbHVkZS9saW51eC9zcGkvc3BpLmggfCAgMzQgKysrKystLQ0KPiA+ICAyIGZp
bGVzIGNoYW5nZWQsIDE3MyBpbnNlcnRpb25zKCspLCA3NCBkZWxldGlvbnMoLSkNCj4gPg0KPiA+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL3NwaS9zcGkuYyBiL2RyaXZlcnMvc3BpL3NwaS5jIGluZGV4
DQo+ID4gNTg2NmJmNTgxM2E0Li44ZWM3ZjU4ZmExMTEgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVy
cy9zcGkvc3BpLmMNCj4gPiArKysgYi9kcml2ZXJzL3NwaS9zcGkuYw0KPiA+IEBAIC02MTMsNyAr
NjEzLDggQEAgc3RhdGljIGludCBzcGlfZGV2X2NoZWNrKHN0cnVjdCBkZXZpY2UgKmRldiwgdm9p
ZA0KPiAqZGF0YSkNCj4gPiAgICAgICAgIHN0cnVjdCBzcGlfZGV2aWNlICpuZXdfc3BpID0gZGF0
YTsNCj4gPg0KPiA+ICAgICAgICAgaWYgKHNwaS0+Y29udHJvbGxlciA9PSBuZXdfc3BpLT5jb250
cm9sbGVyICYmDQo+ID4gLSAgICAgICAgICAgc3BpX2dldF9jaGlwc2VsZWN0KHNwaSwgMCkgPT0g
c3BpX2dldF9jaGlwc2VsZWN0KG5ld19zcGksIDApKQ0KPiA+ICsgICAgICAgICAgIHNwaV9nZXRf
Y2hpcHNlbGVjdChzcGksIDApID09IHNwaV9nZXRfY2hpcHNlbGVjdChuZXdfc3BpLCAwKSAmJg0K
PiA+ICsgICAgICAgICAgIHNwaV9nZXRfY2hpcHNlbGVjdChzcGksIDEpID09IHNwaV9nZXRfY2hp
cHNlbGVjdChuZXdfc3BpLA0KPiA+ICsgMSkpDQo+ID4gICAgICAgICAgICAgICAgIHJldHVybiAt
RUJVU1k7DQo+IA0KPiBUaGlzIHdpbGwgb25seSByZWplY3QgbmV3IGRldmljZXMgaWYgYm90aCBj
aGlwIHNlbGVjdHMgYXJlIGlkZW50aWNhbCwgYnV0IG5vdCBpZg0KPiB0aGV5IG9ubHkgc2hhcmUg
b25lLCBlLmcuIENTIDEgKyAyIHZzIDEgKyAzLCBvciAxICsgMiB2cyBvbmx5IDIsIG9yIGlmIHRo
ZSBvcmRlciBpcw0KPiBkaWZmZXJlbnQgKDEgKyAyIHZzIDIgKyAxIC0gaGF2ZW4ndCByZWFkIHRo
ZSBjb2RlIHRvbyBjbG9zZSB0byBrbm93IGlmIHRoaXMgaXMNCj4gYWxsb3dlZC9wb3NzaWJsZSku
DQoNCkFncmVlZCwgIHdpbGwgYWRkIGluIHRoZSBuZXh0IHNlcmllcy4NCg0KUmVnYXJkcywNCkFt
aXQNCj4gDQo+IFJlZ2FyZHMsDQo+IEpvbmFzDQo=
