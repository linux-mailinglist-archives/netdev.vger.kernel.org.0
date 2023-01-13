Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55510669594
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 12:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241246AbjAMLdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 06:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbjAMLcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 06:32:54 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2128.outbound.protection.outlook.com [40.107.223.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B37574F7
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 03:07:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGdC+iZnqE6pBGTqR2ILW4bS/oRWlppsSOdRGGHIBG7j2jx69h6WTmec0XuT+jjU0RDCV47iMAGYmiBuNKEexJdFRIfCrLiAIHNZDrtd9JmZ05TVqn8zWt4gaSqy174Na0h2fhAKmmCZXbtpUDCdGzyauwpE9SVtRYoxVumohS3NFAhG7gW0NZw1vXk6teMXHGbN7zkSmrPVizmQv24LKH/MQExoCvOpdW5wIk1ufc9h4elxfrCvSAgBLTPxYF9RtQErsmv2zRu1fcTSVsiRAmpTeBmjySYxIkHXpcpTZKIq3IRiQdps1oL5ZOmWjvm8sh0bcX6e22D1AeJYpwYPeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tmKmvbAmeVt0ttUYaid4xIwyA9d4j+EbA+UCtRErzcs=;
 b=L14oMPBFMzTmct4Fp1Np5zZ7fA0PhaqeZeKBQ6rHMNU+vUfTQvqZdf/BT1LxohhyhfBRDfv/HmxN0MqD4pguVKOE5lNjg3peUhVVaaHKX14nuCODYqlFb/txE6RsggwCtMZLXEdz/E9fJl/MWfutAHk9wsGxg1RQ+Z15oqPUTP2EfC6dLiED9mwvRWBUhJ0KfaZNutfmg+QIkplP9+hf7fhPSLOp27cmpulqXAKLzQuQD/qYUPQGSe1l4+zd4OuIeoG5PD34W4xzUqZm2BNNmNezwYZyDhoFo2mq1aM4fiGbCFi8etkMD2pEEoRRrHd6YMTO5EUhqbS4TMflUuPRbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmKmvbAmeVt0ttUYaid4xIwyA9d4j+EbA+UCtRErzcs=;
 b=oLGMFTlRFRN0tDzhVZLZSkdLBL0FZfK9+fo7Ea1NY1tpptKakTjH4cL8cOetgYS9WfTijUmhvCLo9YIxrumovpfKQN+eJdc5tUa10j4LsnfkcdU+181XslridyRCUPA+wC+v1V1u75mCI4LsAzrt06G9z46GkABNYRYWkjzBa8s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4065.namprd13.prod.outlook.com (2603:10b6:5:2af::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 13 Jan
 2023 11:07:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.5986.019; Fri, 13 Jan 2023
 11:07:40 +0000
Date:   Fri, 13 Jan 2023 12:07:13 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v8] net: ngbe: Add ngbe mdio bus driver.
Message-ID: <Y8E7YQmkRFBEwsjx@corigine.com>
References: <20230111111718.40745-1-mengyuanlou@net-swift.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111111718.40745-1-mengyuanlou@net-swift.com>
X-ClientProxiedBy: AM0PR06CA0085.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4065:EE_
X-MS-Office365-Filtering-Correlation-Id: 47f0e0e0-d3b3-490e-f5b2-08daf5566322
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PtYjQSFFNAoj58f5hJcI8/Xo3K6GLRsKfPJpRxEfmgyRdWwHJTBBytzr+rwegQpy/CXy7oxji9hekSxifhmwbvNRP7XroKkry84EZEQA1yPgfRafRbRY7ZjJhmNt4qEsvMt4rxyxfM7TQk+6UXWwZLsT7ShlzNBSJpcYsUgQSSXpawnax4oBGfJpn+oeKubW16f1QNuzAeFGkIwa7d1IhjR8dnbB8bX/dJOOpnpWMTVkcWV2PqEn9MmK2RYWcnJUFwwSo7WyF3+8SnGiblkfx7TcfbdiSkSwm+RuEXKAXUaay9M3I9B/yUgA5yR5Rxj4Hk2Zh1IsQJ/PiVIkW+8zJtMVB7f4B5c8bOkcOOdMd26w/IOt9rAO6m0kX8cv1xsGRlca905OyN8RMGsOmQM89sr8eBZciQs7jLC5guAvedVDjPWHD/AjORLNNh5v6qB3aSvQyY5q9MAO6I4ZykjAjBzr7qPCEtQjNCrqy8hHN+X7GPsHKzMHIQAH+/fPNoRddhnbr2T9RKDRdX3zCC8DfcLztSFOh2wntFccamKaBWcQfsL12mrJfM7qF2o4/c/mDfcistUF9NROrUu2YMa3vUmutA9wM7m6B/l2pbnkJrV96dnTH49F3dlFttwFLDwGFLl2dwFbpmfC0dVchRb4Qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(346002)(39840400004)(366004)(451199015)(38100700002)(6512007)(2906002)(41300700001)(44832011)(186003)(8936002)(86362001)(6506007)(5660300002)(4326008)(6916009)(6486002)(8676002)(66476007)(6666004)(66946007)(66556008)(2616005)(316002)(83380400001)(36756003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5cX6/ho2PcSNgAGdik58lj0FsrTpSnPDbGlg5rpQ6QhDaV6X4RYb9GWx6Bsv?=
 =?us-ascii?Q?nX1oSaZKlOq1xzbDesyg7ljhK73yZpHaleWky/VaPKWlD6QP+hXM7fH7AhJr?=
 =?us-ascii?Q?lKUzMHJkTHNKFKAcVO1R7dLoq5o0q+ORb8aiePUImorQ+PFy77NUhB/GXuKC?=
 =?us-ascii?Q?Bed1OMsNOltaLNX3ZGzKFy08u1HAGs187cMqzf3mKL9x9OWOfZFnep/7Ed9X?=
 =?us-ascii?Q?vrW7CVN215lWQjkVW1VlqB4/TqcI7pvLRvMVQOGcOguj4u1uR5PfngSK4wWe?=
 =?us-ascii?Q?mnigMc6kcrBnU1ty0QwxhdgX0X2IeYrUklcSdn9RYkDsK/9cjYHtYlVFkEtD?=
 =?us-ascii?Q?8VrqqP9NlMrUXz57nzbaQUg2+wveYs/9y1/IhPsQN2sf1TiLnySbu//BLX43?=
 =?us-ascii?Q?KUIzFmww5sSoBSv+IKe1V4oGtr1Zznhk55jIXFoLMq8tCN5gjEGspbl/gbG4?=
 =?us-ascii?Q?2e8xulYBb1eO6cBVqkWdIR/Xl/HwRxdgxsFrblRq111M1dha7gta+BQZW8hF?=
 =?us-ascii?Q?qvgmsLwMYjn0SStKyfxEQ1xcNcUViyOpSzQwr7sdzSw/bVOffhZPkkxPKXfN?=
 =?us-ascii?Q?eGw81+MyssL38P9GFo13EJmvC+auPvfM/+riRxKmF5CyxU+3AbhW6YxCylZh?=
 =?us-ascii?Q?mvoMaDRIce/lbmRVss1Cw0bIIz5gexsFjablVjnvxLD4gynPMPEZ6xd+sEwe?=
 =?us-ascii?Q?Ff7NGUwloysTnTOPRQjOBaYcJUIK76WWcYfDWP8TKwzh1OUenfx0sRHUTwSq?=
 =?us-ascii?Q?M8/dLZNfemMCA1sR/4XMC29ceC5T3FgcR79ScFr3CYEOOJHVLcfvMnP/JjKo?=
 =?us-ascii?Q?UqykXhBb7L64pM8D+Er4miYYbm1mHHlL5KWQD7gQYj2DpP+dSgM9oPGi0FII?=
 =?us-ascii?Q?z4e8ziuWQf3kSUUKlzzqmEpmXB2ENvPDgnMPYFnJyB5+BMB4I3+kqDcq6piS?=
 =?us-ascii?Q?k9QrbC0HA+CKQABDPhdYXBSq82TtqkTa5YUBdDM2gMuSI1YSUMoEPvZ+/dzD?=
 =?us-ascii?Q?G7cT99X+8Hqcwr3ksRxrWYnHmSmPG3IoMRtzxWROXtkyt5IRdrB+odcWZgPl?=
 =?us-ascii?Q?mL91RHLL4YXSlPxG49uzENKREj4GJYtcHwzmp1c/xsp+6Y50NOumETgE8suU?=
 =?us-ascii?Q?b9kEySkpVKZPcVAxAf399LyLfqieRcG3yw+j38Z6TYltstxENOEHWXE9M2+5?=
 =?us-ascii?Q?oFhcKCR5Is92r4/F5J7d4qyjgilRai766xeU+Z9wd2B7SjyL+/VUiLWaL7sP?=
 =?us-ascii?Q?rlfnFg8gtyIZ+U6sxZK8cLEt7NgfciKiTPBBz9N42IeuCPc/taMUtgYYJefx?=
 =?us-ascii?Q?0RFXmVYdRGQlDDlBK+Qp1Dl78vDGx4gyXPuWv0DmuaMySb6spf5BGH5EV4bD?=
 =?us-ascii?Q?oJA+LDhEnRRJ6JvCkcbTzuucZ/+D10AOexpT9jPy4bV5fOEi3vxDENntNSNJ?=
 =?us-ascii?Q?on3WZSOqx8tEQPbVuJVN8SYhINrNKgkQHjJhe6P6tiiO65f0C6852iJYd31P?=
 =?us-ascii?Q?6A/mzEFoQaQNTBchvkhkIsTELIm4BNeA1acJlO1erc37NBpmlkP39AgguCoK?=
 =?us-ascii?Q?z7NKl/BvNVU4AQGzEjIFSomsqdk5ix1qfQRWl0RlyfXlmkKjRQILrsmKMFqx?=
 =?us-ascii?Q?HONJr8iiu1aNyrF4juZrTBr0jNTQ+PS8ul98fUlTyaUT663/6/DUwKfo8zrP?=
 =?us-ascii?Q?jY1PBA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47f0e0e0-d3b3-490e-f5b2-08daf5566322
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 11:07:40.7292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S/G7JTD2TKFko5x7q8aDysoKVsIdLbhYm1/7hv0nrxYMm6YH92+UV3S+N0nOzZ0vssJJQH5P+FHxZ4tyBVuaehEeFpnQ287D5o/NAdrQY4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4065
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 07:17:18PM +0800, Mengyuan Lou wrote:
> Add mdio bus register for ngbe.
> The internal phy and external phy need to be handled separately.
> Add phy changed event detection.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Thanks Mengyuan Lou,

some minor feedback from my side.

...

> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> index a52908d01c9c..165f61698177 100644
> --- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
> +++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> @@ -133,11 +133,14 @@
>  /************************************* ETH MAC *****************************/
>  #define WX_MAC_TX_CFG                0x11000
>  #define WX_MAC_TX_CFG_TE             BIT(0)
> +#define WX_MAC_TX_CFG_SPEED_MASK     GENMASK(30, 29)
> +#define WX_MAC_TX_CFG_SPEED_1G       (0x3 << 29)

nit: can GENMASK() be used to define WX_MAC_TX_CFG_SPEED_1G too?

>  #define WX_MAC_RX_CFG                0x11004
>  #define WX_MAC_RX_CFG_RE             BIT(0)
>  #define WX_MAC_RX_CFG_JE             BIT(8)
>  #define WX_MAC_PKT_FLT               0x11008
>  #define WX_MAC_PKT_FLT_PR            BIT(0) /* promiscuous mode */
> +#define WX_MAC_WDG_TIMEOUT           0x1100C
>  #define WX_MAC_RX_FLOW_CTRL          0x11090
>  #define WX_MAC_RX_FLOW_CTRL_RFE      BIT(0) /* receive fc enable */
>  #define WX_MMC_CONTROL               0x11800

...

> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
> index 588de24b5e18..b9534d608d35 100644
> --- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
> @@ -39,16 +39,24 @@ int ngbe_eeprom_chksum_hostif(struct wx *wx)

...

> +void ngbe_sfp_modules_txrx_powerctl(struct wx *wx, bool swi)
> +{
> +	if (swi)
> +		/* gpio0 is used to power on control*/
> +		wr32(wx, NGBE_GPIO_DR, 0);
> +	else
> +		/* gpio0 is used to power off control*/
> +		wr32(wx, NGBE_GPIO_DR, NGBE_GPIO_DR_0);

nit: maybe this is nicer?

	wr32(wx, NGBE_GPIO_DR, swi ? 0 : NGBE_GPIO_DR_0);

...

> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> index f66513ddf6d9..ed52f80b5475 100644
> --- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c

...

> @@ -385,6 +411,11 @@ static int ngbe_probe(struct pci_dev *pdev,
>  	eth_hw_addr_set(netdev, wx->mac.perm_addr);
>  	wx_mac_set_default_filter(wx, wx->mac.perm_addr);
>  
> +	/* phy Interface Configuration */
> +	err = ngbe_mdio_init(wx);
> +	if (err)
> +		goto err_free_mac_table;

Should this branch to err_register, as is the case a few lines below?

> +
>  	err = register_netdev(netdev);
>  	if (err)
>  		goto err_register;

...

> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
> index 369d181930bc..612b9da2db8f 100644
> --- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
> @@ -60,6 +60,26 @@
>  #define NGBE_EEPROM_VERSION_L			0x1D
>  #define NGBE_EEPROM_VERSION_H			0x1E
>  
> +/* mdio access */
> +#define NGBE_MSCA				0x11200
> +#define NGBE_MSCA_RA(v)				((0xFFFF & (v)))
> +#define NGBE_MSCA_PA(v)				((0x1F & (v)) << 16)
> +#define NGBE_MSCA_DA(v)				((0x1F & (v)) << 21)
> +#define NGBE_MSCC				0x11204
> +#define NGBE_MSCC_DATA(v)			((0xFFFF & (v)))
> +#define NGBE_MSCC_CMD(v)			((0x3 & (v)) << 16)

nit: perhaps the above sould be cleaner when expressed
     using FILED_PREP and U16_MAX.

> +
> +enum NGBE_MSCA_CMD_value {
> +	NGBE_MSCA_CMD_RSV = 0,
> +	NGBE_MSCA_CMD_WRITE,
> +	NGBE_MSCA_CMD_POST_READ,
> +	NGBE_MSCA_CMD_READ,
> +};
> +
> +#define NGBE_MSCC_SADDR				BIT(18)
> +#define NGBE_MSCC_BUSY				BIT(22)
> +#define NGBE_MDIO_CLK(v)			((0x7 & (v)) << 19)

Ditto.

...
