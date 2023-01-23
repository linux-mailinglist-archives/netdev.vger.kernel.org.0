Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D8D677B64
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 13:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjAWMpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 07:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjAWMpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 07:45:41 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2F122A1C;
        Mon, 23 Jan 2023 04:45:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZG87YLgNA4pwdSpxwkrlXaqYXfNCloNdreUbxTcuJZia7kf6nytNOzXLqaQ97UYSy732Fz2+8YNrN0EUkjzpqfxTcHiVLT0Y4tkRPgB1Bb3J/utaabeTdzBuQdgnLf74aCFa+q/Cc4dOHE9r/EiHqcIlrWhSgeScLMk1Wp2yFV83LW5ftRfskX3B8REQPiU5gvegGT4U8RYeCfxR7LN6jLIrModk+tNq+88zg74aexrQ5H+x73k7UcmFRIhb/mgKo7526bJwBDcW6Uqs0aC8gnZ30MlO8p44f1Kt7LbV5EuSJ7vR7O8S2TwLKDSY+gXD1mOAxtmKyVx+e5k70Xuhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Hc9W9e5hNCieEam24ig/h7vGFU0DMJc1GDd0LkOrj8=;
 b=lseX9ZjVMcXx6AQLM3asUsFshtvahYoFtNhMR3jzMlTV9B4fMGWLY30J8uJB8x6c3QtUQlwvHMJjjEAlYe7svdqqp8mfX8lcAoH3olBuHA0B4IyDrjgupCy9CoigVHKtvuEOfch0oPitzwqvdK5EPQnPXfiTc/HfIaf1/zI+JX0iGGZVE6piG7Krv8oRDP2cMFsga2dMsUWgo/bTA2o30O0AgfVT5OVbMoafJA9HkvbyS9LKuZWjQuJ7XLf8XNd5JIjmGyxOoxe+7XI6qn/MaPvMbprusIHplLVmNWc/1c3x5oALd3EC/+HCkyiJeMezpkY0j6IaSkk3wktGQz5xtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Hc9W9e5hNCieEam24ig/h7vGFU0DMJc1GDd0LkOrj8=;
 b=FMq1wZGZ00dVgdYfCxjl5S1a0crN842ZUbW83qGi/HUjpEMKIwxEcIHXV6cc6o2Whof+zfrfnx8qPnL1qPty4CqcVEmh1yELx9OtEqPGIzeg6fRkRQsLCjLri5g5aUaNyljEH/Heiw+Iw7XgrcIdy7SeE8xbN8fihuShq30KDwY=
Received: from BN1PR13CA0020.namprd13.prod.outlook.com (2603:10b6:408:e2::25)
 by MW4PR12MB7309.namprd12.prod.outlook.com (2603:10b6:303:22f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 12:45:30 +0000
Received: from BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::bc) by BN1PR13CA0020.outlook.office365.com
 (2603:10b6:408:e2::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.16 via Frontend
 Transport; Mon, 23 Jan 2023 12:45:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT016.mail.protection.outlook.com (10.13.176.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Mon, 23 Jan 2023 12:45:29 +0000
Received: from [10.254.241.50] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 23 Jan
 2023 06:44:58 -0600
Message-ID: <2f4171f8-badb-a33a-7ae6-c375d9d725c3@amd.com>
Date:   Mon, 23 Jan 2023 13:44:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 01/13] spi: Add APIs in spi core to set/get
 spi->chip_select and spi->cs_gpiod
Content-Language: en-US
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>,
        <broonie@kernel.org>, <miquel.raynal@bootlin.com>,
        <richard@nod.at>, <vigneshr@ti.com>, <jic23@kernel.org>,
        <tudor.ambarus@microchip.com>, <pratyush@kernel.org>,
        <sanju.mehta@amd.com>, <chin-ting_kuo@aspeedtech.com>,
        <clg@kaod.org>, <kdasu.kdev@gmail.com>, <f.fainelli@gmail.com>,
        <rjui@broadcom.com>, <sbranden@broadcom.com>,
        <eajames@linux.ibm.com>, <olteanv@gmail.com>, <han.xu@nxp.com>,
        <john.garry@huawei.com>, <shawnguo@kernel.org>,
        <s.hauer@pengutronix.de>, <narmstrong@baylibre.com>,
        <khilman@baylibre.com>, <matthias.bgg@gmail.com>,
        <haibo.chen@nxp.com>, <linus.walleij@linaro.org>,
        <daniel@zonque.org>, <haojian.zhuang@gmail.com>,
        <robert.jarzmik@free.fr>, <agross@kernel.org>,
        <bjorn.andersson@linaro.org>, <heiko@sntech.de>,
        <krzysztof.kozlowski@linaro.org>, <andi@etezian.org>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@foss.st.com>,
        <wens@csie.org>, <jernej.skrabec@gmail.com>, <samuel@sholland.org>,
        <masahisa.kojima@linaro.org>, <jaswinder.singh@linaro.org>,
        <rostedt@goodmis.org>, <mingo@redhat.com>,
        <l.stelmach@samsung.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <alex.aring@gmail.com>, <stefan@datenfreihafen.org>,
        <kvalo@kernel.org>, <thierry.reding@gmail.com>,
        <jonathanh@nvidia.com>, <skomatineni@nvidia.com>,
        <sumit.semwal@linaro.org>, <christian.koenig@amd.com>,
        <j.neuschaefer@gmx.net>, <vireshk@kernel.org>, <rmfrfs@gmail.com>,
        <johan@kernel.org>, <elder@kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <git@amd.com>, <linux-spi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <joel@jms.id.au>,
        <andrew@aj.id.au>, <radu_nicolae.pirea@upb.ro>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <claudiu.beznea@microchip.com>,
        <bcm-kernel-feedback-list@broadcom.com>, <fancer.lancer@gmail.com>,
        <kernel@pengutronix.de>, <festevam@gmail.com>, <linux-imx@nxp.com>,
        <jbrunet@baylibre.com>, <martin.blumenstingl@googlemail.com>,
        <avifishman70@gmail.com>, <tmaimon77@gmail.com>,
        <tali.perry1@gmail.com>, <venture@google.com>, <yuenn@google.com>,
        <benjaminfair@google.com>, <yogeshgaur.83@gmail.com>,
        <konrad.dybcio@somainline.org>, <alim.akhtar@samsung.com>,
        <ldewangan@nvidia.com>, <linux-aspeed@lists.ozlabs.org>,
        <openbmc@lists.ozlabs.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-amlogic@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-rockchip@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-sunxi@lists.linux.dev>, <linux-tegra@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wpan@vger.kernel.org>,
        <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <lars@metafoo.de>, <Michael.Hennerich@analog.com>,
        <linux-iio@vger.kernel.org>, <michael@walle.cc>,
        <palmer@dabbelt.com>, <linux-riscv@lists.infradead.org>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <greybus-dev@lists.linaro.org>, <linux-staging@lists.linux.dev>,
        <amitrkcian2002@gmail.com>
References: <20230119185342.2093323-1-amit.kumar-mahapatra@amd.com>
 <20230119185342.2093323-2-amit.kumar-mahapatra@amd.com>
From:   Michal Simek <michal.simek@amd.com>
In-Reply-To: <20230119185342.2093323-2-amit.kumar-mahapatra@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT016:EE_|MW4PR12MB7309:EE_
X-MS-Office365-Filtering-Correlation-Id: e0a4abaa-71e3-4b9c-4356-08dafd3fb58e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LdL7ODwPjNwLqL4zlXwEXOJTNmT13yPiJlDUkVlxEhCsLNzPduJOrmGw5A7a23LQZozesJcqSzVlJ/Grd2JKOOSvVjwL4lN6X+14Irt5QsUEsgJXI7U/si9FfrKC5YVU7QwL7cAaSnjXo6xHPRyLS8QxNN8gp/V54D1aRhJpGxXjQk0GR8qgraYFsbYP8VqIVLlXDn6OcoU3T6i65a4q0EKBDFRPYD33UO1Prg25z/yogONRvtS2gzWkWQdJxvSABX6WsOckNLFiPWSkAH+Vdnl9Y1awbyZfc3OXub2GSJ5DgswIzcms7JBHwCbtYuO6FdmnlZNqY2ltJhNheRGia5g89VJAYnObK6GIsytWpnQ89oFNkeVUQaKnU07ZdyjC7FYYesPDoy+o7EtHZlwCBhYDhUpAxjdKKQ8YyZwdQYeK69smSWB/9JslS/9TIE8vQygv4aCrrJZcliNYMVwQeCYteAc6PwxNp2pOqxZafGGfA4ID67g0v27HdO2MjRuFJOt1ZVDhXdOb68ZbvS6noVnpOoyNbE1fc4DUTzFM5RctmTGON2egUiQUo6KA8PFGtIFOOLmTutSQl+snumGnVksRqZtLCl5q0JICnxG+Z6UNaAH2TpjUglQI44iL7AeSx8RHx27rL7pMBzIhRjilktkfZ4rZ9MOHYiEiqp7svAOcarWViVfv1iEHMu1mto8kkG5F7HOE+XLKafB92/UIm914Vywt+NrtIDEu0WTVw0IYWtyseYlUW6oF5Pk7LluVZ0BrPTcZXQOIlI1HaAn/Yn0dfzhVl7VEDIcVNSej3pqcO3npANbPo7jdHRYUh6Px0f5aoFkI40Byc8ywS7oNM3wKmt3zSizWcksXSJuHNHsvQT7a79TeJ7CcMiW8TYRU54MAYUid1qiwzji8DM6fimK4pqjMt8zaHM+ZtF7ipTE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199015)(36840700001)(46966006)(40470700004)(2906002)(86362001)(40460700003)(36756003)(31696002)(82310400005)(426003)(47076005)(316002)(16576012)(54906003)(336012)(110136005)(81166007)(83380400001)(478600001)(966005)(1191002)(16526019)(186003)(53546011)(26005)(2616005)(7366002)(7406005)(7416002)(8936002)(7336002)(7276002)(5660300002)(921005)(356005)(40480700001)(44832011)(70206006)(4326008)(8676002)(36860700001)(70586007)(82740400003)(41300700001)(31686004)(43740500002)(36900700001)(41080700001)(2101003)(84006005)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 12:45:29.5706
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a4abaa-71e3-4b9c-4356-08dafd3fb58e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7309
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/19/23 19:53, Amit Kumar Mahapatra wrote:
> Supporting multi-cs in spi core and spi controller drivers would require
> the chip_select & cs_gpiod members of struct spi_device to be an array.
> But changing the type of these members to array would break the spi driver
> functionality. To make the transition smoother introduced four new APIs to
> get/set the spi->chip_select & spi->cs_gpiod and replaced all
> spi->chip_select and spi->cs_gpiod references in spi core with the API
> calls.
> While adding multi-cs support in further patches the chip_select & cs_gpiod
> members of the spi_device structure would be converted to arrays & the
> "idx" parameter of the APIs would be used as array index i.e.,
> spi->chip_select[idx] & spi->cs_gpiod[idx] respectively.
> 
> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
> ---
>   drivers/spi/spi.c       | 45 ++++++++++++++++++++---------------------
>   include/linux/spi/spi.h | 20 ++++++++++++++++++
>   2 files changed, 42 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 3cc7bb4d03de..38421e831a7d 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -604,7 +604,7 @@ static void spi_dev_set_name(struct spi_device *spi)
>   	}
>   
>   	dev_set_name(&spi->dev, "%s.%u", dev_name(&spi->controller->dev),
> -		     spi->chip_select);
> +		     spi_get_chipselect(spi, 0));
>   }
>   
>   static int spi_dev_check(struct device *dev, void *data)
> @@ -613,7 +613,7 @@ static int spi_dev_check(struct device *dev, void *data)
>   	struct spi_device *new_spi = data;
>   
>   	if (spi->controller == new_spi->controller &&
> -	    spi->chip_select == new_spi->chip_select)
> +	    spi_get_chipselect(spi, 0) == spi_get_chipselect(new_spi, 0))
>   		return -EBUSY;
>   	return 0;
>   }
> @@ -638,7 +638,7 @@ static int __spi_add_device(struct spi_device *spi)
>   	status = bus_for_each_dev(&spi_bus_type, NULL, spi, spi_dev_check);
>   	if (status) {
>   		dev_err(dev, "chipselect %d already in use\n",
> -				spi->chip_select);
> +				spi_get_chipselect(spi, 0));
>   		return status;
>   	}
>   
> @@ -649,7 +649,7 @@ static int __spi_add_device(struct spi_device *spi)
>   	}
>   
>   	if (ctlr->cs_gpiods)
> -		spi->cs_gpiod = ctlr->cs_gpiods[spi->chip_select];
> +		spi_set_csgpiod(spi, 0, ctlr->cs_gpiods[spi_get_chipselect(spi, 0)]);
>   
>   	/*
>   	 * Drivers may modify this initial i/o setup, but will
> @@ -692,8 +692,8 @@ int spi_add_device(struct spi_device *spi)
>   	int status;
>   
>   	/* Chipselects are numbered 0..max; validate. */
> -	if (spi->chip_select >= ctlr->num_chipselect) {
> -		dev_err(dev, "cs%d >= max %d\n", spi->chip_select,
> +	if (spi_get_chipselect(spi, 0) >= ctlr->num_chipselect) {
> +		dev_err(dev, "cs%d >= max %d\n", spi_get_chipselect(spi, 0),
>   			ctlr->num_chipselect);
>   		return -EINVAL;
>   	}
> @@ -714,8 +714,8 @@ static int spi_add_device_locked(struct spi_device *spi)
>   	struct device *dev = ctlr->dev.parent;
>   
>   	/* Chipselects are numbered 0..max; validate. */
> -	if (spi->chip_select >= ctlr->num_chipselect) {
> -		dev_err(dev, "cs%d >= max %d\n", spi->chip_select,
> +	if (spi_get_chipselect(spi, 0) >= ctlr->num_chipselect) {
> +		dev_err(dev, "cs%d >= max %d\n", spi_get_chipselect(spi, 0),
>   			ctlr->num_chipselect);
>   		return -EINVAL;
>   	}
> @@ -761,7 +761,7 @@ struct spi_device *spi_new_device(struct spi_controller *ctlr,
>   
>   	WARN_ON(strlen(chip->modalias) >= sizeof(proxy->modalias));
>   
> -	proxy->chip_select = chip->chip_select;
> +	spi_set_chipselect(proxy, 0, chip->chip_select);
>   	proxy->max_speed_hz = chip->max_speed_hz;
>   	proxy->mode = chip->mode;
>   	proxy->irq = chip->irq;
> @@ -970,24 +970,23 @@ static void spi_set_cs(struct spi_device *spi, bool enable, bool force)
>   	 * Avoid calling into the driver (or doing delays) if the chip select
>   	 * isn't actually changing from the last time this was called.
>   	 */
> -	if (!force && ((enable && spi->controller->last_cs == spi->chip_select) ||
> -				(!enable && spi->controller->last_cs != spi->chip_select)) &&
> +	if (!force && ((enable && spi->controller->last_cs == spi_get_chipselect(spi, 0)) ||
> +		       (!enable && spi->controller->last_cs != spi_get_chipselect(spi, 0))) &&
>   	    (spi->controller->last_cs_mode_high == (spi->mode & SPI_CS_HIGH)))
>   		return;
>   
>   	trace_spi_set_cs(spi, activate);
>   
> -	spi->controller->last_cs = enable ? spi->chip_select : -1;
> +	spi->controller->last_cs = enable ? spi_get_chipselect(spi, 0) : -1;
>   	spi->controller->last_cs_mode_high = spi->mode & SPI_CS_HIGH;
>   
> -	if ((spi->cs_gpiod || !spi->controller->set_cs_timing) && !activate) {
> +	if ((spi_get_csgpiod(spi, 0) || !spi->controller->set_cs_timing) && !activate)
>   		spi_delay_exec(&spi->cs_hold, NULL);
> -	}
>   
>   	if (spi->mode & SPI_CS_HIGH)
>   		enable = !enable;
>   
> -	if (spi->cs_gpiod) {
> +	if (spi_get_csgpiod(spi, 0)) {
>   		if (!(spi->mode & SPI_NO_CS)) {
>   			/*
>   			 * Historically ACPI has no means of the GPIO polarity and
> @@ -1000,10 +999,10 @@ static void spi_set_cs(struct spi_device *spi, bool enable, bool force)
>   			 * into account.
>   			 */
>   			if (has_acpi_companion(&spi->dev))
> -				gpiod_set_value_cansleep(spi->cs_gpiod, !enable);
> +				gpiod_set_value_cansleep(spi_get_csgpiod(spi, 0), !enable);
>   			else
>   				/* Polarity handled by GPIO library */
> -				gpiod_set_value_cansleep(spi->cs_gpiod, activate);
> +				gpiod_set_value_cansleep(spi_get_csgpiod(spi, 0), activate);
>   		}
>   		/* Some SPI masters need both GPIO CS & slave_select */
>   		if ((spi->controller->flags & SPI_MASTER_GPIO_SS) &&
> @@ -1013,7 +1012,7 @@ static void spi_set_cs(struct spi_device *spi, bool enable, bool force)
>   		spi->controller->set_cs(spi, !enable);
>   	}
>   
> -	if (spi->cs_gpiod || !spi->controller->set_cs_timing) {
> +	if (spi_get_csgpiod(spi, 0) || !spi->controller->set_cs_timing) {
>   		if (activate)
>   			spi_delay_exec(&spi->cs_setup, NULL);
>   		else
> @@ -2304,7 +2303,7 @@ static int of_spi_parse_dt(struct spi_controller *ctlr, struct spi_device *spi,
>   			nc, rc);
>   		return rc;
>   	}
> -	spi->chip_select = value;
> +	spi_set_chipselect(spi, 0, value);
>   
>   	/* Device speed */
>   	if (!of_property_read_u32(nc, "spi-max-frequency", &value))
> @@ -2423,7 +2422,7 @@ struct spi_device *spi_new_ancillary_device(struct spi_device *spi,
>   	strscpy(ancillary->modalias, "dummy", sizeof(ancillary->modalias));
>   
>   	/* Use provided chip-select for ancillary device */
> -	ancillary->chip_select = chip_select;
> +	spi_set_chipselect(ancillary, 0, chip_select);
>   
>   	/* Take over SPI mode/speed from SPI main device */
>   	ancillary->max_speed_hz = spi->max_speed_hz;
> @@ -2670,7 +2669,7 @@ struct spi_device *acpi_spi_device_alloc(struct spi_controller *ctlr,
>   	spi->mode		|= lookup.mode;
>   	spi->irq		= lookup.irq;
>   	spi->bits_per_word	= lookup.bits_per_word;
> -	spi->chip_select	= lookup.chip_select;
> +	spi_set_chipselect(spi, 0, lookup.chip_select);
>   
>   	return spi;
>   }
> @@ -3632,7 +3631,7 @@ static int spi_set_cs_timing(struct spi_device *spi)
>   	struct device *parent = spi->controller->dev.parent;
>   	int status = 0;
>   
> -	if (spi->controller->set_cs_timing && !spi->cs_gpiod) {
> +	if (spi->controller->set_cs_timing && !spi_get_csgpiod(spi, 0)) {
>   		if (spi->controller->auto_runtime_pm) {
>   			status = pm_runtime_get_sync(parent);
>   			if (status < 0) {
> @@ -3837,7 +3836,7 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
>   	 * cs_change is set for each transfer.
>   	 */
>   	if ((spi->mode & SPI_CS_WORD) && (!(ctlr->mode_bits & SPI_CS_WORD) ||
> -					  spi->cs_gpiod)) {
> +					  spi_get_csgpiod(spi, 0))) {
>   		size_t maxsize;
>   		int ret;
>   
> diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
> index 9a32495fbb1f..9b23a1d0dd0d 100644
> --- a/include/linux/spi/spi.h
> +++ b/include/linux/spi/spi.h
> @@ -263,6 +263,26 @@ static inline void *spi_get_drvdata(struct spi_device *spi)
>   	return dev_get_drvdata(&spi->dev);
>   }
>   
> +static inline u8 spi_get_chipselect(struct spi_device *spi, u8 idx)
> +{
> +	return spi->chip_select;
> +}
> +
> +static inline void spi_set_chipselect(struct spi_device *spi, u8 idx, u8 chipselect)
> +{
> +	spi->chip_select = chipselect;
> +}
> +
> +static inline struct gpio_desc *spi_get_csgpiod(struct spi_device *spi, u8 idx)
> +{
> +	return spi->cs_gpiod;
> +}
> +
> +static inline void spi_set_csgpiod(struct spi_device *spi, u8 idx, struct gpio_desc *csgpiod)
> +{
> +	spi->cs_gpiod = csgpiod;
> +}
> +
>   struct spi_message;
>   
>   /**

Lars suggested this style in v1 version of this patch here.
https://lore.kernel.org/all/12fe1b84-1981-bf56-9323-b7f5b698c196@metafoo.de/

That's why let me also add his
Suggested-by: Lars-Peter Clausen <lars@metafoo.de>

And
Reviewed-by: Michal Simek <michal.simek@amd.com>

Thanks,
Michal


