Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23EA769CFB0
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 15:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbjBTOs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 09:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjBTOsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 09:48:51 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2116.outbound.protection.outlook.com [40.107.114.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0731A958;
        Mon, 20 Feb 2023 06:48:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKHpUCwNtL8Yo6xoXTncMgZfUXexGKt9xv2MpK1LMxMgNpEpLHaYS8Bhss7gSW9wnrnriuv8qOBBjklIbm9A8MDnRXMfMIXlnujynY3rXQJS8GeRWGRi3/Tx0i/9akkJS7P5Ux3m5nD/D+76xRCmRSwy5beLayKCbNKNVV7/8z+RkLngJnlT+BtT7bf0fK1csJLiLTF0+ctYY+V9Ff6sa3id0ltI/6A7B5qgjB3uk8N/x+7BX7RE2c3dD9HFT+gVECWqKiEifY+YtFw15IGoHs/xcRPoZju4/DFY4QSx4+Q8YvQC+zpWygXVXVSmuOrM0dS4dPfMHdWvODo2Fi/8PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pIuTBnLnQIudgCtj2bdotjgMlU4s0gBzV2WiGo0mugA=;
 b=TLqCvU5k5iCk0ooF1PaLp5T2QnM4gc6z7AgyqMU/ZKGzXXkmOGS6fmS6MdozHE67J+FMrj6phN0WpcaFvKWnFkkWm+RNBpzMUarLrkoLx5qvfHQgoPYvsOzVvEgZYxa5bQehyxs2xvJIpecIbTeviFL+d+we3AJizflFbc0CK+JaUUe9lZPbFkxGnl8Q3fzIO6wAgMXvCLAal/X/gYz/J7fycJ39OrgKrVGBKVNA+jcTQKQ6Mgya0IblegNqiBKPhSXz7KO5ZjD+JUirc+JevsAoiRptgcspxkLMGVhJvgdEy2vsgo/2FGN0FeCxaIpTGWI8FqMw4FLnfbck5X5yaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dm.renesas.com; dmarc=pass action=none
 header.from=dm.renesas.com; dkim=pass header.d=dm.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dm.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIuTBnLnQIudgCtj2bdotjgMlU4s0gBzV2WiGo0mugA=;
 b=ZazSW/8J76Ah2Ux5EbY+YVr8JSKweCxBpPv90CjPPdnrWZbWp8QJRZw9Fvu5RNHsce5Vi0PzWi9xcmoz0DvDJW2gq8nJ9czmGVTf4mAz6nvyPWbuItiyGKFSzdBPZsAxs4lpKe0EWKZGxnEhcWv78sMs+A37buoqXfSPEL8/Vuo=
Received: from OS3PR01MB8460.jpnprd01.prod.outlook.com (2603:1096:604:197::13)
 by OSZPR01MB8687.jpnprd01.prod.outlook.com (2603:1096:604:15e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 14:48:44 +0000
Received: from OS3PR01MB8460.jpnprd01.prod.outlook.com
 ([fe80::e332:554a:7:7135]) by OS3PR01MB8460.jpnprd01.prod.outlook.com
 ([fe80::e332:554a:7:7135%5]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 14:48:44 +0000
From:   DLG Adam Ward <DLG-Adam.Ward.opensource@dm.renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        DLG Adam Ward <DLG-Adam.Ward.opensource@dm.renesas.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
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
        =?utf-8?B?TmlrbGFzIFPDtmRlcmx1bmQ=?= 
        <niklas.soderlund@ragnatech.se>, Heiko Stuebner <heiko@sntech.de>,
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
Thread-Index: AQHZRG/HAV0yCC5B/ky2ximBKy+xBK7Xm3swgAAmkQCAACChEA==
Date:   Mon, 20 Feb 2023 14:48:44 +0000
Message-ID: <OS3PR01MB8460AADEFC7EA2F60936555AC2A49@OS3PR01MB8460.jpnprd01.prod.outlook.com>
References: <20230219143657.241542-1-daniel.lezcano@linaro.org>
 <20230219143657.241542-2-daniel.lezcano@linaro.org>
 <OS3PR01MB8460E7C2D1F9EEEDDC579FFEC2A49@OS3PR01MB8460.jpnprd01.prod.outlook.com>
 <CAMuHMdWFn+LbKE=77mRBfGqSu3x5qsk3X-pQVeu3uZXEejyRRg@mail.gmail.com>
In-Reply-To: <CAMuHMdWFn+LbKE=77mRBfGqSu3x5qsk3X-pQVeu3uZXEejyRRg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dm.renesas.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3PR01MB8460:EE_|OSZPR01MB8687:EE_
x-ms-office365-filtering-correlation-id: 1f3bfd92-71c7-42fb-6a8c-08db135190d2
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cur/nBWMflxuJyDQwWiXhvh0FhzYT77uoFNzRlEMOfrYZafOn1k73aRP9DQQVviRaF1Ts/Whb/lA5w+jEqPOp4Nt2nwsv+TwXtKlv+fBqZXLTvkGOpvEd3CrB0KAsdGuL7bbZH9bFfe2hqeYIAhsWVdvr4QRDRnI+87uF69KUny+cQd/0X72ppJJszuUrhoIs+vknNmFQFa+5DxmwTJCZLaetn8nnptm4mfZDoHCypscHqL6cgKIo5lp53gJfmHQ0oIPfR5hGumCDolg06UUoA82pOBwyLCAjDN8fqHFmuRh5BZi4GOe7hpKZHi4+UEXQulXVkL/AxA5mj0kGFZfaoDBf7s2vdBGY6+wBwg9t54aV+h+0WkrsVuLxYk836luU5x36v+LtSvqPGGJyDLbyXwqoY6yNmM1QNZ77riZb2gl52u3f4WHgTtwo45MpFR9s8twTCBCFC5f7V7PBshNY6s4r8qOUk1L5HMXso2eZY6TO6bgaC0fDiaMJgnw4qJzOJ/ZV6nk5K4xphbC745Y3Wr9/WATz2kg9pEmYn74iguFTHV+1BpMqquEDIcUHxIqKD8uJ/B/pVU+glT7rfbV2elvxM5A56pu2b1TcxzmmRhWzSiOVaAGzMUpQxwIU4gmra1y3YlCWZpaPWcloCxrjzCTBa8aQq3MgR0z2JwhMC7iOZnRZaYlrWJwrLFoNMT3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB8460.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(451199018)(54906003)(478600001)(110136005)(71200400001)(122000001)(38100700002)(86362001)(2906002)(4744005)(33656002)(38070700005)(316002)(41300700001)(52536014)(5660300002)(7336002)(7406005)(7366002)(83380400001)(8936002)(7416002)(55016003)(66446008)(4326008)(66556008)(8676002)(64756008)(66476007)(66946007)(66899018)(76116006)(26005)(186003)(53546011)(55236004)(966005)(6506007)(7696005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aWEva2ZEelNuT01DN0p5YWN4b2hFRFZPenB1T0dSdjhSViszWndKQkJpNFk3?=
 =?utf-8?B?bHBTS0VGMVFJTzQ3RU9LbWx5S2I0eWtLWkt1Nzl5Mkh0MEhJK3dXLytaLys5?=
 =?utf-8?B?Ny9sNy9rVSs4RlpYcG9zSCtGNzRYNjl3U2NkTGR3MEVuZE9QWkJIcC8zSWZv?=
 =?utf-8?B?UDQvUEJVckhwWVNFSkpuMnB1c1lUNW9iWGxRS0plOHJmTFN4MXZpbGlkMFUy?=
 =?utf-8?B?WkRqL3hPVTNRUXBNZW5VTTN2NXJZWkNueVIvZTZRd2dENTQ2OExaS25sQ2NV?=
 =?utf-8?B?ZHZCMlJDUHhiQit5VG0wZ3Z2MXVUTHJTRVhXcUxYTjJXUUQyZXM4S0lrbDRT?=
 =?utf-8?B?NTlqdk9JQXlrKzVkc3JxRmlSUUNnYnBTaEx0Q1d2UHd0dXBMYXhaZnFTNFJi?=
 =?utf-8?B?dG1oUE9zeUxiWHF1VXJvZU52M3FBM3orN0RIa2V5U2tnZ2U4N0hZVzhabWp6?=
 =?utf-8?B?b1ZMdnowUFVxZXI3QXJ4NG5remIzdWxsd2RJcnZnVmhvRFBhVTBTUHAzemVv?=
 =?utf-8?B?SENHb2xodTFLd3dnK0xnT3dST2ZaaDRxS2pBbzFsaEZ1OFFWV1JpSnE0QjhP?=
 =?utf-8?B?UmlBT1lSeTBiWndWeEpLSTVMSHA5akFGRE5wSUhIQkpGRzc0anQ3Nys5MUgv?=
 =?utf-8?B?NDNPeFFmYWc1RTZZMTN6Mlp4QkVqVmNlaWwxaTVCS3p6bzBLYWpnT3E0Qjha?=
 =?utf-8?B?dW56UWNkUUVJL3VUamJpdUlnZVBSdXVmb1NJYWhQQldzYjROZnEvWWVpTnA4?=
 =?utf-8?B?Mis3U2h1SDBYekJYV0JudW1MbXdkdkJ4aTV4TVd1NnhEcVI5YUFTK0hYMGpR?=
 =?utf-8?B?OXYrR0N1Z21JeDNTaFJydU9WN09SVlpRZC84WHVvQTd6YWt6NWxoZ0g5OUgv?=
 =?utf-8?B?OEErRkVxcDhMUkp4UDZKK3g5US9DUUJKdHFNWkxlc051Q3R0TklabXg1bWxC?=
 =?utf-8?B?T1Z2Q1ViSVNadFdIVFp1ZUN4VWtLcEVzQVdiTVo4ZHRUOUt4Rk9Sd3cwbVRF?=
 =?utf-8?B?YTU0WDF1cEdqbGhDVzdnQnBvTEdNTGlkOEpmS3lFcUhOeHJWYmYyeXlrenlK?=
 =?utf-8?B?L0hZRFdLTUlFTnVnS2t3ODlTcXowcjE3MG9vdi9SSXRvc1hIVlZiN2N3MkhM?=
 =?utf-8?B?WEl3Nkh2a0trOHFuMmRuUzFDVE9TUlBTZWFWcWM3bXhRNzQ5QUF4MVphcVhS?=
 =?utf-8?B?V2xKMHlqQ3ZnV1cwZzh6QjcrQTdLaVJQOE44eFhjcVBRS0J2eGVUcXllOHZZ?=
 =?utf-8?B?UEUvdFJIdjFPSHhsQ3BMQTVSTGY2YXRkZjY5aGd5dS9lYS9CN3BScUlMcm16?=
 =?utf-8?B?N2J6emhvcldTZmVnbFUvZEdjMWVqOTJuZ24veDM0MUo5VEI0K1NqUGpyUyth?=
 =?utf-8?B?NnpEc0xYSVBoUUFVVmh1bDFRejVFeXJuclljQVI3d0dXUjVBM1dDZHp6R2VC?=
 =?utf-8?B?TXJKbmpwRzNXQlRRUFVPQ0RyS3JiNXBQMDBYUXFiYlF6aWg3NE5COEdXRlZS?=
 =?utf-8?B?RnFXRFdTa3lpWFdsekxnakhMMDBGSkhCNmlrOXhvaGF5czJOUG9nZnNBZmJv?=
 =?utf-8?B?d1pCSnZobG8yc29mbWY1bUMxVHlJVWw1eExDZFBWcDBtTW9yWHZYV1ZGSmpa?=
 =?utf-8?B?WUxkd0x1amRwN3VIR2xwNHlnN3MxM01idGh1Wk4yUE5seVhQbVh2RU5pdkh4?=
 =?utf-8?B?emgxd2k2RnNuNW9qeVFkYkhVUjVyR01lWStIMFgwVG8yamxWSXZnMDlWTHlS?=
 =?utf-8?B?TG1sNXJmUU5VdVk5VFFJUmhILzBiaGFGelgzZXRRYzBNMzJ0NkNxT3lnYzh0?=
 =?utf-8?B?c3R1amRsZldhV3FFdkkvTmpWZUtXbS8vRVRLNHpuRUlRaXptbTgwN0lkVGVt?=
 =?utf-8?B?N0l5RGR2b3d4UjZoTTE5YjJxaTFlVzVPcEc4bjdacmh5V1EwZCswUkpyV2lV?=
 =?utf-8?B?eVRaWE9mZjZxQ2hMRE9hdUFSM1lmMCtTaVFMaks2TkZOZEJEbWg4aDZueEFj?=
 =?utf-8?B?Z1ZHT1VYZHZIb2RnZVZudUhFazN0SEM3aTFtYTV6NERweDJubG9GMEZ5TXBY?=
 =?utf-8?B?Vm9SemJKUGJsaEQ2RXMrYkcwTHh0UTJPYzVPSnVwbVNMUVZSN1FaZ0ZjS3kw?=
 =?utf-8?B?WWxlQVpVRnlQZkltcjJGazMzMjR4RW1wWHBZYjEvTTVPODZxTUg1KzRDWmRN?=
 =?utf-8?B?dmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: dm.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB8460.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f3bfd92-71c7-42fb-6a8c-08db135190d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2023 14:48:44.5887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XfGxfM+UvC7CceENOIaJ/wR0OogqGKQ2KvAhEXad9O1zZdROdMNjnsdjHedjxZpXXCRN9aHKE08DjA9zqFNu/M0yZY58laD5tT3c12AELiQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB8687
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAvMDIvMjAyMyAxMjoxOSwgR2VlcnQgVXl0dGVyaG9ldmVuIHdyb3RlOg0KDQo+TG9va3Mg
bGlrZSBEYW5pZWwgaGFzIGZvdW5kIHRoZSBuZXcgRGlhbG9nIG1haW50YWluZXIgaGUgd2FzIGxv
b2tpbmcgZm9yPyANCg0KTm90IHF1aXRlOyBJJ20ganVzdCBmaWxsaW5nIGluIGZvciBhIHdoaWxl
LCBhbG9uZ3NpZGUgb3RoZXIgZHV0aWVzLg0KDQo+VGltZSB0byB1cGRhdGUgTUFJTlRBSU5FUlM/
DQoNCldlbGwsIGluIG91ciBkZWZlbmNlLCBhbiBhdHRlbXB0IHdhcyBtYWRlIC0gYnV0IHByYWdt
YXRpc20gbG9zdCBvdXQgdG8gaWRlYWxpc206DQpodHRwczovL2xrbWwub3JnL2xrbWwvMjAyMi84
LzEvMjY0DQpGb3J0dW5hdGVseSwgdGhlIG9yaWdpbmFsIG1haWxpbmcgbGlzdCB3YXMgc3VzdGFp
bmVkIHRodXMgZmFyLi4uDQoNCkNoYW5nZXMgYXJlIHNldHRsaW5nIGRvd24gbm93LCBzbyB5ZXMs
IGEgcGF0Y2ggdG8gc3BsaXQgc3VwcG9ydCBieSBkZXZpY2UsIGFuZCBwcm92aWRlIG5hbWVzIGlu
IGFkZGl0aW9uIHRvIHRoZSBuZXcgbWFpbGluZyBsaXN0LCBpcyBpbmRlZWQgcGVuZGluZy4NCg0K
UmVnYXJkcywNCkFkYW0NCg0K
