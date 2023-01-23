Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02ED9677B4B
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 13:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbjAWMli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 07:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjAWMle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 07:41:34 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2072.outbound.protection.outlook.com [40.107.101.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B49AF752;
        Mon, 23 Jan 2023 04:41:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JK67vP7J3asEvhRD4a2DWngcf3s/LXXhgr9qsbtXCjBh80BKebwDxQB9SrkJQc8j8Z4zTd+FViRC19oye8YluCj5lXMa1wp8+doTCwtkV2HldNV0GuctLmGpH9rRBH9aOUaHiKKbSuhs19SUc6P6+NFnf6frYYnTFgb1spHBW6cfpACEjSysuFkxDIGL0KEECMS8AWXCx7TNR8QaHyRXy8RvlQcSqVF3Yva7DL7s6+t8xIvGq1QyxXRwOgFZtHvY8csXMrAJJBZCXg5C5O+Gq+XD+bJFbdNLXF4VZblxjxIyvECrZfXwVcQttvND/JoZoGK0NMaPLhL6gB6RAXBjeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mRSaVxFcOi8Wl1iv8atBI/tuuzFR7OS9gWyi2TG+ubU=;
 b=KJcAGQ0iBq0eyWqgTgKAGjbHsPQpirX5G/G3mESVrxP3uqjhob6MKro94hIbtVGcn602WB+UgB8B0+5udr/gRsbZzBP2D7Rpp/QTT6WFjniofmd3ZceeLAmVTpfjvQXMf3TZFhbamkoK6ml2d8w5YwlB10yrpISCql07LYsiHnjPuxHqr5CvhTODurLOqUnOXvAG/cFT7mIGsUAfHZnbRCNbNMGrk8jXJilIh8juO6hEzggmNy+eWJGw7JbJTeQv5DdrkS2opPcgBeX2A+yV9dNyPNzkruVY9fzphVUlwhnkSsaPr8unIa+8RUx4rMmExBPQ8Ujy+fMOc5xuTLCGiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mRSaVxFcOi8Wl1iv8atBI/tuuzFR7OS9gWyi2TG+ubU=;
 b=LiTlvmo3znzh/HXNBcMDps7tsWOABaRbURxmbEgdNa0VC/rJ9yOYZ/8viF7laot9PhSG1dIvtrPkxDH4Wk8Lo/8e+00sMJVdgM4IpVeKPL0oow5dkYOFW5IXrF46R/y044y0L0rECv41quxiOF2zpFg93X2JNh7pqGmVPvsfvME=
Received: from DM6PR06CA0043.namprd06.prod.outlook.com (2603:10b6:5:54::20) by
 PH7PR12MB8427.namprd12.prod.outlook.com (2603:10b6:510:242::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.33; Mon, 23 Jan 2023 12:41:22 +0000
Received: from DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::a3) by DM6PR06CA0043.outlook.office365.com
 (2603:10b6:5:54::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Mon, 23 Jan 2023 12:41:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT096.mail.protection.outlook.com (10.13.173.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Mon, 23 Jan 2023 12:41:21 +0000
Received: from [10.254.241.50] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 23 Jan
 2023 06:40:51 -0600
Message-ID: <09534bb9-d9be-5433-5e7d-f9d40e30562e@amd.com>
Date:   Mon, 23 Jan 2023 13:40:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 10/13] mtd: spi-nor: Add stacked memories support in
 spi-nor
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
 <20230119185342.2093323-11-amit.kumar-mahapatra@amd.com>
From:   Michal Simek <michal.simek@amd.com>
In-Reply-To: <20230119185342.2093323-11-amit.kumar-mahapatra@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT096:EE_|PH7PR12MB8427:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e9c5c3b-0aec-4e63-6979-08dafd3f21f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0NW5ba5jP/DrG7urdbsxJP8ESK+qGITDafbDZBnUXEWDwWCvIlNwmvkzdc6q+K3BlsAoWk+vkwtVRKxAbHm1MH3gK+ARSTCSrDf9NU5KXRWHUorr+LzURvqgue+GShUiNTXjPFurfsUbMCm8lfIQhVaUK2WV4Q/nlrxMlrf3xQIZSYnwdB4TEGjidNNKGiyeqQgdr3Mqc+1EMyUK2PJWrdtNoVKQIEqiTFFPr1fZ2XaUn/MLbcG4gFhiJ+etfVxOa3QP33o8vOpT4d1XguBIRARf2KaOM106I7o8Ft5e/asSydcb4i1Up8JIinYCkQ45Mk360IZ/yNg+itbdborT6UeDCkWfLjHtDydqlWwXTSZkwfCI0xm6oEtazA+sa3x+G8bzemwzlLdTpqOYCqEgqlgstADo8Z2erjIipog65w3PC9SND4hWVlFx4VUVLhLXU+pVRodlrR0f9tmeFflfscoyTYThTWeZsqel1GZSU0kPfNm0ISMGrRgWlDLOj5161RjfdqtBlT8E3eP6nDFWsa1VcgwIj9XUMRQtgeW2ivZy83bJbD1Z/y97uhy37ny5wShWBcu3wKFbMISIhcftJ0JR6i9bDzznSQRDRznEBVBF71mss8gjBa4mUw9XqGARWiqtTQC+VSvvLLH5E0rGuVw/oo78cr+p9MWgXtYtBM+DDePrrjzBlqU3kr00htlQi/BPvMwALkDYdt76yaSor0vRRh+0HGRJ9YkgeDKiqsd6He6n1B/da1+uFHYQisrJrNBW9LB7Hz7Ziaou3blOu7FZKFP8UcDEoYWbEkGPNGCcopPOkN4iy1uUBnIyx+rmpkpA+rW/iXSkM2awLA6Y2KE+orrTK3TkGUB43KvHh7sYRWSLKUrtbAVMWm1XKNaI6zdrDZ6VKSGPHcz3IaopgA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199015)(36840700001)(46966006)(40470700004)(36756003)(31696002)(41300700001)(86362001)(356005)(921005)(81166007)(82740400003)(7416002)(5660300002)(7406005)(7336002)(8936002)(82310400005)(4326008)(2906002)(30864003)(44832011)(7366002)(7276002)(36860700001)(83380400001)(110136005)(478600001)(31686004)(16526019)(8676002)(26005)(53546011)(186003)(1191002)(40460700003)(40480700001)(70586007)(16576012)(70206006)(316002)(2616005)(54906003)(6666004)(336012)(426003)(47076005)(2101003)(43740500002)(84006005)(83996005)(36900700001)(41080700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 12:41:21.9020
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e9c5c3b-0aec-4e63-6979-08dafd3f21f1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8427
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
> Each flash that is connected in stacked mode should have a separate
> parameter structure. So, the flash parameter member(*params) of the spi_nor
> structure is changed to an array (*params[2]). The array is used to store
> the parameters of each flash connected in stacked configuration.
> 
> The current implementation assumes that a maximum of two flashes are
> connected in stacked mode and both the flashes are of same make but can
> differ in sizes. So, except the sizes all other flash parameters of both
> the flashes are identical.
> 
> SPI-NOR is not aware of the chip_select values, for any incoming request
> SPI-NOR will decide the flash index with the help of individual flash size
> and the configuration type (single/stacked). SPI-NOR will pass on the flash
> index information to the SPI core & SPI driver by setting the appropriate
> bit in nor->spimem->spi->cs_index_mask. For example, if nth bit of
> nor->spimem->spi->cs_index_mask is set then the driver would
> assert/de-assert spi->chip_slect[n].
> 
> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
> ---
>   drivers/mtd/spi-nor/core.c  | 282 +++++++++++++++++++++++++++++-------
>   drivers/mtd/spi-nor/core.h  |   4 +
>   drivers/mtd/spi-nor/otp.c   |   4 +-
>   include/linux/mtd/spi-nor.h |  12 +-
>   4 files changed, 246 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
> index 8a4a54bf2d0e..bb7326dc8b70 100644
> --- a/drivers/mtd/spi-nor/core.c
> +++ b/drivers/mtd/spi-nor/core.c
> @@ -1441,13 +1441,18 @@ static int spi_nor_erase_multi_sectors(struct spi_nor *nor, u64 addr, u32 len)
>   static int spi_nor_erase(struct mtd_info *mtd, struct erase_info *instr)
>   {
>   	struct spi_nor *nor = mtd_to_spi_nor(mtd);
> -	u32 addr, len;
> +	struct spi_nor_flash_parameter *params;
> +	u32 addr, len, offset, cur_cs_num = 0;
>   	uint32_t rem;
>   	int ret;
> +	u64 sz;
>   
>   	dev_dbg(nor->dev, "at 0x%llx, len %lld\n", (long long)instr->addr,
>   			(long long)instr->len);
>   
> +	params = spi_nor_get_params(nor, 0);
> +	sz = params->size;
> +
>   	if (spi_nor_has_uniform_erase(nor)) {
>   		div_u64_rem(instr->len, mtd->erasesize, &rem);
>   		if (rem)
> @@ -1465,26 +1470,30 @@ static int spi_nor_erase(struct mtd_info *mtd, struct erase_info *instr)
>   	if (len == mtd->size && !(nor->flags & SNOR_F_NO_OP_CHIP_ERASE)) {
>   		unsigned long timeout;
>   
> -		ret = spi_nor_write_enable(nor);
> -		if (ret)
> -			goto erase_err;
> +		while (cur_cs_num < SNOR_FLASH_CNT_MAX && params) {
> +			nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
> +			ret = spi_nor_write_enable(nor);
> +			if (ret)
> +				goto erase_err;
>   
> -		ret = spi_nor_erase_chip(nor);
> -		if (ret)
> -			goto erase_err;
> +			ret = spi_nor_erase_chip(nor);
> +			if (ret)
> +				goto erase_err;
>   
> -		/*
> -		 * Scale the timeout linearly with the size of the flash, with
> -		 * a minimum calibrated to an old 2MB flash. We could try to
> -		 * pull these from CFI/SFDP, but these values should be good
> -		 * enough for now.
> -		 */
> -		timeout = max(CHIP_ERASE_2MB_READY_WAIT_JIFFIES,
> -			      CHIP_ERASE_2MB_READY_WAIT_JIFFIES *
> -			      (unsigned long)(mtd->size / SZ_2M));
> -		ret = spi_nor_wait_till_ready_with_timeout(nor, timeout);
> -		if (ret)
> -			goto erase_err;
> +			/*
> +			 * Scale the timeout linearly with the size of the flash, with
> +			 * a minimum calibrated to an old 2MB flash. We could try to
> +			 * pull these from CFI/SFDP, but these values should be good
> +			 * enough for now.
> +			 */
> +			timeout = max(CHIP_ERASE_2MB_READY_WAIT_JIFFIES,
> +				      CHIP_ERASE_2MB_READY_WAIT_JIFFIES *
> +				      (unsigned long)(params->size / SZ_2M));
> +			ret = spi_nor_wait_till_ready_with_timeout(nor, timeout);
> +			if (ret)
> +				goto erase_err;
> +			cur_cs_num++;
> +		}
>   
>   	/* REVISIT in some cases we could speed up erasing large regions
>   	 * by using SPINOR_OP_SE instead of SPINOR_OP_BE_4K.  We may have set up
> @@ -1493,12 +1502,26 @@ static int spi_nor_erase(struct mtd_info *mtd, struct erase_info *instr)
>   
>   	/* "sector"-at-a-time erase */
>   	} else if (spi_nor_has_uniform_erase(nor)) {
> +		/* Determine the flash from which the operation need to start */
> +		while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (addr > sz - 1) && params) {
> +			cur_cs_num++;
> +			params = spi_nor_get_params(nor, cur_cs_num);
> +			sz += params->size;
> +		}
> +
>   		while (len) {
> +			nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
>   			ret = spi_nor_write_enable(nor);
>   			if (ret)
>   				goto erase_err;
>   
> -			ret = spi_nor_erase_sector(nor, addr);
> +			offset = addr;
> +			if (nor->flags & SNOR_F_HAS_STACKED) {
> +				params = spi_nor_get_params(nor, cur_cs_num);
> +				offset -= (sz - params->size);
> +			}
> +
> +			ret = spi_nor_erase_sector(nor, offset);
>   			if (ret)
>   				goto erase_err;
>   
> @@ -1508,13 +1531,45 @@ static int spi_nor_erase(struct mtd_info *mtd, struct erase_info *instr)
>   
>   			addr += mtd->erasesize;
>   			len -= mtd->erasesize;
> +
> +			/*
> +			 * Flash cross over condition in stacked mode.
> +			 */
> +			if ((nor->flags & SNOR_F_HAS_STACKED) && (addr > sz - 1)) {
> +				cur_cs_num++;
> +				params = spi_nor_get_params(nor, cur_cs_num);
> +				sz += params->size;
> +			}
>   		}
>   
>   	/* erase multiple sectors */
>   	} else {
> -		ret = spi_nor_erase_multi_sectors(nor, addr, len);
> -		if (ret)
> -			goto erase_err;
> +		u64 erase_len = 0;
> +
> +		/* Determine the flash from which the operation need to start */
> +		while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (addr > sz - 1) && params) {
> +			cur_cs_num++;
> +			params = spi_nor_get_params(nor, cur_cs_num);
> +			sz += params->size;
> +		}
> +		/* perform multi sector erase onec per Flash*/
> +		while (len) {
> +			erase_len = (len > (sz - addr)) ? (sz - addr) : len;
> +			offset = addr;
> +			nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
> +			if (nor->flags & SNOR_F_HAS_STACKED) {
> +				params = spi_nor_get_params(nor, cur_cs_num);
> +				offset -= (sz - params->size);
> +			}
> +			ret = spi_nor_erase_multi_sectors(nor, offset, erase_len);
> +			if (ret)
> +				goto erase_err;
> +			len -= erase_len;
> +			addr += erase_len;
> +			cur_cs_num++;
> +			params = spi_nor_get_params(nor, cur_cs_num);
> +			sz += params->size;
> +		}
>   	}
>   
>   	ret = spi_nor_write_disable(nor);
> @@ -1713,7 +1768,10 @@ static int spi_nor_read(struct mtd_info *mtd, loff_t from, size_t len,
>   			size_t *retlen, u_char *buf)
>   {
>   	struct spi_nor *nor = mtd_to_spi_nor(mtd);
> -	ssize_t ret;
> +	struct spi_nor_flash_parameter *params;
> +	ssize_t ret, read_len;
> +	u32 cur_cs_num = 0;
> +	u64 sz;
>   
>   	dev_dbg(nor->dev, "from 0x%08x, len %zd\n", (u32)from, len);
>   
> @@ -1721,9 +1779,23 @@ static int spi_nor_read(struct mtd_info *mtd, loff_t from, size_t len,
>   	if (ret)
>   		return ret;
>   
> +	params = spi_nor_get_params(nor, 0);
> +	sz = params->size;
> +
> +	/* Determine the flash from which the operation need to start */
> +	while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (from > sz - 1) && params) {
> +		cur_cs_num++;
> +		params = spi_nor_get_params(nor, cur_cs_num);
> +		sz += params->size;
> +	}
>   	while (len) {
>   		loff_t addr = from;
>   
> +		nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
> +		read_len = (len > (sz - addr)) ? (sz - addr) : len;
> +		params = spi_nor_get_params(nor, cur_cs_num);
> +		addr -= (sz - params->size);
> +
>   		addr = spi_nor_convert_addr(nor, addr);
>   
>   		ret = spi_nor_read_data(nor, addr, len, buf);
> @@ -1735,11 +1807,22 @@ static int spi_nor_read(struct mtd_info *mtd, loff_t from, size_t len,
>   		if (ret < 0)
>   			goto read_err;
>   
> -		WARN_ON(ret > len);
> +		WARN_ON(ret > read_len);
>   		*retlen += ret;
>   		buf += ret;
>   		from += ret;
>   		len -= ret;
> +
> +		/*
> +		 * Flash cross over condition in stacked mode.
> +		 *
> +		 */
> +		if ((nor->flags & SNOR_F_HAS_STACKED) && (from > sz - 1)) {
> +			cur_cs_num++;
> +			params = spi_nor_get_params(nor, cur_cs_num);
> +			sz += params->size;
> +		}
> +
>   	}
>   	ret = 0;
>   
> @@ -1759,13 +1842,22 @@ static int spi_nor_write(struct mtd_info *mtd, loff_t to, size_t len,
>   	struct spi_nor *nor = mtd_to_spi_nor(mtd);
>   	struct spi_nor_flash_parameter *params;
>   	size_t page_offset, page_remain, i;
> +	u32 page_size, cur_cs_num = 0;
>   	ssize_t ret;
> -	u32 page_size;
> +	u64 sz;
>   
>   	dev_dbg(nor->dev, "to 0x%08x, len %zd\n", (u32)to, len);
>   
>   	params = spi_nor_get_params(nor, 0);
>   	page_size = params->page_size;
> +	sz = params->size;
> +
> +	/* Determine the flash from which the operation need to start */
> +	while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (to > sz - 1) && params) {
> +		cur_cs_num++;
> +		params = spi_nor_get_params(nor, cur_cs_num);
> +		sz += params->size;
> +	}
>   
>   	ret = spi_nor_lock_and_prep(nor);
>   	if (ret)
> @@ -1790,6 +1882,10 @@ static int spi_nor_write(struct mtd_info *mtd, loff_t to, size_t len,
>   		/* the size of data remaining on the first page */
>   		page_remain = min_t(size_t, page_size - page_offset, len - i);
>   
> +		nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
> +		params = spi_nor_get_params(nor, cur_cs_num);
> +		addr -= (sz - params->size);
> +
>   		addr = spi_nor_convert_addr(nor, addr);
>   
>   		ret = spi_nor_write_enable(nor);
> @@ -1806,6 +1902,15 @@ static int spi_nor_write(struct mtd_info *mtd, loff_t to, size_t len,
>   			goto write_err;
>   		*retlen += written;
>   		i += written;
> +
> +		/*
> +		 * Flash cross over condition in stacked mode.
> +		 */
> +		if ((nor->flags & SNOR_F_HAS_STACKED) && ((to + i) > sz - 1)) {
> +			cur_cs_num++;
> +			params = spi_nor_get_params(nor, cur_cs_num);
> +			sz += params->size;
> +		}
>   	}
>   
>   write_err:
> @@ -1918,8 +2023,6 @@ int spi_nor_hwcaps_pp2cmd(u32 hwcaps)
>   static int spi_nor_spimem_check_op(struct spi_nor *nor,
>   				   struct spi_mem_op *op)
>   {
> -	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
> -
>   	/*
>   	 * First test with 4 address bytes. The opcode itself might
>   	 * be a 3B addressing opcode but we don't care, because
> @@ -1928,7 +2031,7 @@ static int spi_nor_spimem_check_op(struct spi_nor *nor,
>   	 */
>   	op->addr.nbytes = 4;
>   	if (!spi_mem_supports_op(nor->spimem, op)) {
> -		if (params->size > SZ_16M)
> +		if (nor->mtd.size > SZ_16M)
>   			return -EOPNOTSUPP;
>   
>   		/* If flash size <= 16MB, 3 address bytes are sufficient */
> @@ -2516,6 +2619,10 @@ static void spi_nor_init_fixup_flags(struct spi_nor *nor)
>   static void spi_nor_late_init_params(struct spi_nor *nor)
>   {
>   	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
> +	struct device_node *np = spi_nor_get_flash_node(nor);
> +	u64 flash_size[SNOR_FLASH_CNT_MAX];
> +	u32 idx = 0, i = 0;
> +	int rc;
>   
>   	if (nor->manufacturer && nor->manufacturer->fixups &&
>   	    nor->manufacturer->fixups->late_init)
> @@ -2533,6 +2640,36 @@ static void spi_nor_late_init_params(struct spi_nor *nor)
>   	 */
>   	if (nor->flags & SNOR_F_HAS_LOCK && !params->locking_ops)
>   		spi_nor_init_default_locking_ops(nor);
> +	/*
> +	 * The flashes that are connected in stacked mode should be of same make.
> +	 * Except the flash size all other properties are identical for all the
> +	 * flashes connected in stacked mode.
> +	 * The flashes that are connected in parallel mode should be identical.
> +	 */
> +	while (i < SNOR_FLASH_CNT_MAX) {
> +		rc = of_property_read_u64_index(np, "stacked-memories", idx, &flash_size[i]);
> +		if (rc == -EINVAL) {
> +			break;
> +		} else if (rc == -EOVERFLOW) {
> +			idx++;
> +		} else {
> +			idx++;
> +			i++;
> +			if (!(nor->flags & SNOR_F_HAS_STACKED))
> +				nor->flags |= SNOR_F_HAS_STACKED;
> +		}
> +	}
> +	if (nor->flags & SNOR_F_HAS_STACKED) {
> +		for (idx = 1; idx < SNOR_FLASH_CNT_MAX; idx++) {
> +			params = spi_nor_get_params(nor, idx);
> +			params = devm_kzalloc(nor->dev, sizeof(*params), GFP_KERNEL);
> +			if (params) {
> +				memcpy(params, spi_nor_get_params(nor, 0), sizeof(*params));
> +				params->size = flash_size[idx];
> +				spi_nor_set_params(nor, idx, params);
> +			}
> +		}
> +	}
>   }
>   
>   /**
> @@ -2741,22 +2878,36 @@ static int spi_nor_octal_dtr_enable(struct spi_nor *nor, bool enable)
>    */
>   static int spi_nor_quad_enable(struct spi_nor *nor)
>   {
> -	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
> +	struct spi_nor_flash_parameter *params;
> +	int err, idx;
>   
> -	if (!params->quad_enable)
> -		return 0;
> +	for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
> +		params = spi_nor_get_params(nor, idx);
> +		if (params) {
> +			if (!params->quad_enable)
> +				return 0;
>   
> -	if (!(spi_nor_get_protocol_width(nor->read_proto) == 4 ||
> -	      spi_nor_get_protocol_width(nor->write_proto) == 4))
> -		return 0;
> +			if (!(spi_nor_get_protocol_width(nor->read_proto) == 4 ||
> +			      spi_nor_get_protocol_width(nor->write_proto) == 4))
> +				return 0;
> +			/*
> +			 * Set the appropriate CS index before
> +			 * issuing the command.
> +			 */
> +			nor->spimem->spi->cs_index_mask = 0x01 << idx;
>   
> -	return params->quad_enable(nor);
> +			err = params->quad_enable(nor);
> +			if (err)
> +				return err;
> +		}
> +	}
> +	return err;
>   }
>   
>   static int spi_nor_init(struct spi_nor *nor)
>   {
> -	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
> -	int err;
> +	struct spi_nor_flash_parameter *params;
> +	int err, idx;
>   
>   	err = spi_nor_octal_dtr_enable(nor, true);
>   	if (err) {
> @@ -2797,9 +2948,19 @@ static int spi_nor_init(struct spi_nor *nor)
>   		 */
>   		WARN_ONCE(nor->flags & SNOR_F_BROKEN_RESET,
>   			  "enabling reset hack; may not recover from unexpected reboots\n");
> -		err = params->set_4byte_addr_mode(nor, true);
> -		if (err && err != -ENOTSUPP)
> -			return err;
> +		for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
> +			params = spi_nor_get_params(nor, idx);
> +			if (params) {
> +				/*
> +				 * Select the appropriate CS index before
> +				 * issuing the command.
> +				 */
> +				nor->spimem->spi->cs_index_mask = 0x01 << idx;
> +				err = params->set_4byte_addr_mode(nor, true);
> +				if (err && err != -ENOTSUPP)
> +					return err;
> +			}
> +		}
>   	}
>   
>   	return 0;
> @@ -2915,19 +3076,31 @@ void spi_nor_restore(struct spi_nor *nor)
>   {
>   	struct spi_nor_flash_parameter *params;
>   	int ret;
> +	int idx;
>   
>   	/* restore the addressing mode */
>   	if (nor->addr_nbytes == 4 && !(nor->flags & SNOR_F_4B_OPCODES) &&
>   	    nor->flags & SNOR_F_BROKEN_RESET) {
> -		params = spi_nor_get_params(nor, 0);
> -		ret = params->set_4byte_addr_mode(nor, false);
> -		if (ret)
> -			/*
> -			 * Do not stop the execution in the hope that the flash
> -			 * will default to the 3-byte address mode after the
> -			 * software reset.
> -			 */
> -			dev_err(nor->dev, "Failed to exit 4-byte address mode, err = %d\n", ret);
> +		for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
> +			params = spi_nor_get_params(nor, idx);
> +			if (params) {
> +				/*
> +				 * Select the appropriate CS index before
> +				 * issuing the command.
> +				 */
> +				nor->spimem->spi->cs_index_mask = 0x01 << idx;
> +				ret = params->set_4byte_addr_mode(nor, false);
> +				if (ret)
> +					/*
> +					 * Do not stop the execution in the hope that the flash
> +					 * will default to the 3-byte address mode after the
> +					 * software reset.
> +					 */
> +					dev_err(nor->dev,
> +						"Failed to exit 4-byte address mode, err = %d\n",
> +						ret);
> +			}
> +		}
>   	}
>   
>   	if (nor->flags & SNOR_F_SOFT_RESET)
> @@ -2995,6 +3168,8 @@ static void spi_nor_set_mtd_info(struct spi_nor *nor)
>   	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
>   	struct mtd_info *mtd = &nor->mtd;
>   	struct device *dev = nor->dev;
> +	u64 total_sz = 0;
> +	int idx;
>   
>   	spi_nor_set_mtd_locking_ops(nor);
>   	spi_nor_set_mtd_otp_ops(nor);
> @@ -3010,7 +3185,12 @@ static void spi_nor_set_mtd_info(struct spi_nor *nor)
>   		mtd->_erase = spi_nor_erase;
>   	mtd->writesize = params->writesize;
>   	mtd->writebufsize = params->page_size;
> -	mtd->size = params->size;
> +	for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
> +		params = spi_nor_get_params(nor, idx);
> +		if (params)
> +			total_sz += params->size;
> +	}
> +	mtd->size = total_sz;
>   	mtd->_read = spi_nor_read;
>   	/* Might be already set by some SST flashes. */
>   	if (!mtd->_write)
> diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
> index f03b55cf7e6f..e94107cc465e 100644
> --- a/drivers/mtd/spi-nor/core.h
> +++ b/drivers/mtd/spi-nor/core.h
> @@ -11,6 +11,9 @@
>   
>   #define SPI_NOR_MAX_ID_LEN	6
>   
> +/* In single configuration enable CS0 */
> +#define SPI_NOR_ENABLE_CS0     BIT(0)
> +
>   /* Standard SPI NOR flash operations. */
>   #define SPI_NOR_READID_OP(naddr, ndummy, buf, len)			\
>   	SPI_MEM_OP(SPI_MEM_OP_CMD(SPINOR_OP_RDID, 0),			\
> @@ -130,6 +133,7 @@ enum spi_nor_option_flags {
>   	SNOR_F_IO_MODE_EN_VOLATILE = BIT(11),
>   	SNOR_F_SOFT_RESET	= BIT(12),
>   	SNOR_F_SWP_IS_VOLATILE	= BIT(13),
> +	SNOR_F_HAS_STACKED      = BIT(14),
>   };
>   
>   struct spi_nor_read_command {
> diff --git a/drivers/mtd/spi-nor/otp.c b/drivers/mtd/spi-nor/otp.c
> index a9c0844d55ef..b8c7e085a90d 100644
> --- a/drivers/mtd/spi-nor/otp.c
> +++ b/drivers/mtd/spi-nor/otp.c
> @@ -11,8 +11,8 @@
>   
>   #include "core.h"
>   
> -#define spi_nor_otp_region_len(nor) ((nor)->params->otp.org->len)
> -#define spi_nor_otp_n_regions(nor) ((nor)->params->otp.org->n_regions)
> +#define spi_nor_otp_region_len(nor) ((nor)->params[0]->otp.org->len)
> +#define spi_nor_otp_n_regions(nor) ((nor)->params[0]->otp.org->n_regions)

I think this should be also converted to static inline functions and use
spi_nor_get_params(nor, 0); instead of using arrays.
Can be done on the top of this series if it is the only one problem with it.

Thanks,
Michal
