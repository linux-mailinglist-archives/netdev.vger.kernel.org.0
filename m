Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A572B69C680
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbjBTIVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 03:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjBTIVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:21:11 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D999EFF24;
        Mon, 20 Feb 2023 00:21:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NzKHneT+iwfXVzHc7GCR0+/EiW5wosRDViVHEJb0YgBR15DTpHB8SotElk0lsfQB6vyvyqqN+ng8HBh/7HNKDfoTaLOL1410EbgEF0czHdW6Z4Twmg9BS3rclv+Svd8Pax7r5XkVT8ZLRl1aorQby1n/HhBHSO9NgK9gSnSZLZj4ougGE71m0uD5ZdHgO746zGg9M717SDadNO5qaJsSbCgXWC0VKlYLqMFWrqhr+n6lXQHEr23ymnpR6VgznixTtlsBNdBJC8L60hrxRFQ5RQnv6iqWJDd70Xo8H2g4PCE9vomsDb2GNQIZ9GQgDqYkUbnQcDYI2Qg9iUt1ZAI7kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jnNb9LmLRmykhRFlP89vIGtvKFKdR6/UriuD2u5kFhE=;
 b=FCMCElyZousjQtOxBMADtVmCgwGsz6W5xh0sfttxqm1sRIGjLvxFR5bK2mNL8rnUesr8Hq3/PE4Nl6H3y+rzNcFcfVOUXVu55eUggnnhv9YLOcolmFyTxfGTwgbL1ZwnP470jM8Q14bynoIgU8jPEbULi6BFBos0qLU5QLY+dp8Jmz1/0POp+LqEFXpM6itkGMkhO3xzlqLReTtxJtOl1O+ZaZzQBmaEVHEbi89NQbkqFujGsT+rIa9QXJrcF/YrJfaW76DUIL7DqEsVj9hvQFTL0gDILhDjv9/6rf7kf9Oq3T7FSI5DckX1MzxqJ5e5/EiMOE6fT6V2uQGtXFNGCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnNb9LmLRmykhRFlP89vIGtvKFKdR6/UriuD2u5kFhE=;
 b=C4d0qVuOgYqcsZYt9a60MrtVf6JQXyeiMJCDqUgarSGXPuZQa6PmOsuzk2hgYABOUVTvkknR3bF4HlAQjhHt0K6XOS6imcnemWZFxtWslTZltjqwFOPQOQQHkG3tmoCC/qVrP66BVhMJxZWimn3C6K7w3NeTbQ66nhz58sV5sSkO4UCERiUofkZwK6oiLMKIdo9b52FhHT5jWbiRnDLIxrPBHpLfM45bXBtHAW2/0UFnh4hzzZchi6Z2xIJ0hPyyMIgJB99wWlOaklK3L4MBbWJ7DQIKh37j+/nfZJCmlxzA4cXo/fYBefygv7QVqJBWh5JUNumgcM60dfHkpFdZ2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 08:21:05 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 08:21:05 +0000
Date:   Mon, 20 Feb 2023 10:20:59 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     rafael@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>,
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
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
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
Subject: Re: [PATCH v1 01/17] thermal/core: Add a thermal zone 'devdata'
 accessor
Message-ID: <Y/MtaoIm2XGkOhLp@shredder>
References: <20230219143657.241542-1-daniel.lezcano@linaro.org>
 <20230219143657.241542-2-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230219143657.241542-2-daniel.lezcano@linaro.org>
X-ClientProxiedBy: LO2P265CA0268.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB5040:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ab9eabf-ef60-4165-e93f-08db131b68f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mI8vJzPegRp/wOFzAbZmP5N8Z1atLFbxhZzp/ImlLWmqXkHxqEL2cY47QoW4YdlUvIfIkXQCJWv46okO5xDw34CZhgrQ8B9ZtnfH3LuhPWAs7YWCzVm9F5YpV3GyhQZPlGkFMZ0BZeY0SJparp0SsIOYvTEkVjjXHRka5GbsLc9gJqeO7XEOE7WhLJfMKxc7cSD+O3wNrkcJvOyB8DjTwrNF38JdkWQ3pJ0bLvxSNw3i4EOGj9P8mkczakUF2HA7X2aBW1xrcdSobfdWpV7wXa2w1AUcK+gZp53n2cafnu85hTa7A0oOJslVBplkQKsDIeOjvdhb2NGpa/VFD/3PGUTQxjscSXmQZk98JojRNRVqZWHD2wfFVefeITO+81IPEvX5z8XlijLpUh+j46ZTigong8uVlSy2KEhweeHXm2ARZL3p73CKg0411BSCVyQ8KpdzcdQGDp8wfPia3pTw2YLW/O/MffLGmfHDTm5C+MtDRwJYLBFbFEUxHpbyo8RDb8PoJwH4Gb/5yG52uvpV1aeCcmq11vCU7XiClUEeXnYR9FnUY3pe3UOH55spEKMjbYMrSUx+SutPc4kXrSa1KxO56C1ib/wpGcEgi3Z/lFmy7njxJAoOz3vwCpbYsqbCC2inHOR/tNLDMp1r/MNXmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(136003)(39860400002)(346002)(396003)(366004)(376002)(451199018)(9686003)(26005)(66899018)(8936002)(186003)(33716001)(6512007)(6506007)(86362001)(38100700002)(6666004)(2906002)(4744005)(5660300002)(6486002)(7406005)(7416002)(7366002)(7336002)(4326008)(6916009)(41300700001)(54906003)(66476007)(66556008)(8676002)(66946007)(83380400001)(478600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SH1h7FraJcXu3RWhoS7QUeoUnJ9D1BceWHVi/N6SY/q7NLqT8U0liib3wXld?=
 =?us-ascii?Q?mQC+zieQ77RUrEeEIyR//S9vQBeDElkkvfvgKShwu0h28uiQfOSjmXP7Tpzo?=
 =?us-ascii?Q?TJpZ1HGRrJVfmdbQrOPf0knfGugBbPcFK1opuQqcUJV23S91EQYY8tzKzyb7?=
 =?us-ascii?Q?K1WRrf4m5TT78ImNQP+hib43YMrsE8Wlg4eSu1NH9qmSKLKo9JToEY1xJLye?=
 =?us-ascii?Q?kMOETZwNfIrP8BJOedYBmZe+HmYFp42oAMlyghntWfwSM1LJZl6v9D2NDxUN?=
 =?us-ascii?Q?qIlDW0NdUttgc8sLphuzczrFplhpQhEuB2s/t/ys0fFb63tKA3QwjQa53gtU?=
 =?us-ascii?Q?4k1pQ66pcJA/5LRATzB27+8IKmj614HzKfboJryF+f0LAA+U+vD3idWuhFk7?=
 =?us-ascii?Q?C2SAqSLE5OcI8gZ3LWT65iqAU3dse2N5gK7nUDa0FDWnJRLi0bPIp4WMD1Fr?=
 =?us-ascii?Q?JdpriXFDvh+qvWVssr/aI0a+gBLsh8QJVWZ3ybgS4NaRYbn67kvv8Bp36Kie?=
 =?us-ascii?Q?vPK0KaXc3GFeIkScY8sGNI7cdIWor/CMrsJ4rmQ/cIsCN7rJLNGJWEmuDdH/?=
 =?us-ascii?Q?ANwarYlPqIbkH9vFoY5TVcHWVAlqBVW6DgUEBdutDvQ9kWXrEOXRK8ENZY9y?=
 =?us-ascii?Q?nT9CgFZKmmhgzXKEjQ/2JXvkrJ7hN0EzNPR7R6s8Jxl3FUeOHuVdFLhCTgll?=
 =?us-ascii?Q?vHs43jneY5eC4LHphRaqlV8yJVOkQWA7ye6KAru8rMEQfvnAIzwMp3lZKq9F?=
 =?us-ascii?Q?5p2RUHCQ9wEmAtPfmFOG0HSZokXsdQRL4T8n8WnaCYDeRY+OPYALxi17E/HV?=
 =?us-ascii?Q?UjaEQjxUWlHVMkrUwNPwedDDqgBKskj/U7wDSgnE633ep7ynemSvNgBEQ/wj?=
 =?us-ascii?Q?M3bMVzCYilW1QhVyDtXCLYJUqJuBhCBl+WWuONzGtofPsrgUTF9UeiRJyhhP?=
 =?us-ascii?Q?IEoPOCYgijPT20g1Gv+XGa1+PEDsalNU22gZowHgPmu7m2qV4ItqArZA6gDe?=
 =?us-ascii?Q?MJvzDI/oTvfpGzkvnVyQ7GXEpNJ2bXGbkBj8bpyqoQmGP+Rx0HCL+GXjULS2?=
 =?us-ascii?Q?+WOlsA9ik2EwgsEwzmZsSTSJQsqNIKLv16Lqqr3ua8svjuwChQjq5ee4EADW?=
 =?us-ascii?Q?ucj2HpW88U6fRDPlAE9eIXKe2iov2KvIvVsEIlKDCnPNrFTOLQ0wJcNZFMUY?=
 =?us-ascii?Q?ziqLKpndu5kYXnICmP/TMkk7i4iNuoKMNvDAWjVN+dTqpox0tAMDkIEpqD7C?=
 =?us-ascii?Q?qs0sYws0+J2YzTRd6rTHTaiDO9WuMZ+Txor1SfBJMh4ZQY1hyetPUqrTP6RD?=
 =?us-ascii?Q?tJSji783E6oTE4Qo7YPTkcu+ZEPnb4ZGpV58vbAU5MwpJdAxA0Zau/qcKxc8?=
 =?us-ascii?Q?PnAxQNI49KbusEldXurvhF2HWk1P6nEAYERSwDATTucnEbu7UiuuSIAj7IiD?=
 =?us-ascii?Q?RDYcLIlQBKbpz7L06HHfJADT718+pu3o0CRsdy9BN9apu3jZVY9+med12m9Q?=
 =?us-ascii?Q?p0PZtZs+GV2kj8awIQHllt/qH3XnWIzoLG292y5JmfIMDTscsBOdP7JVNmRp?=
 =?us-ascii?Q?q1AD28Ed/YaKqb0u0dZhglN33FlX/eRDXhhIwYzo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab9eabf-ef60-4165-e93f-08db131b68f0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 08:21:05.2782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MrIckAu5N4BilHmojlslhKNhGkWyxootFbR5M1lLnQqqxoFGvzjphcGe7i74tA8Q7GeRdFGWwDrP2i737EHqfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5040
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 19, 2023 at 03:36:41PM +0100, Daniel Lezcano wrote:
> The thermal zone device structure is exposed to the different drivers
> and obviously they access the internals while that should be
> restricted to the core thermal code.
> 
> In order to self-encapsulate the thermal core code, we need to prevent
> the drivers accessing directly the thermal zone structure and provide
> accessor functions to deal with.
> 
> Provide an accessor to the 'devdata' structure and make use of it in
> the different drivers.
> 
> No functional changes intended.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

For mlxsw:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
