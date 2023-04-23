Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFC46EC21A
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 21:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjDWTrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 15:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDWTrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 15:47:37 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E267E41;
        Sun, 23 Apr 2023 12:47:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUlBlRMUXdFmI8TE0PIbsElF2kW/ecJ5/P/rLRkF/cuNyFE04+41QcSGGVULpmojW8tWBgjLLX6EGC27+fyZPedZ/IclGFDbsAXBF3+ADmFqpbOD0sEhpek94sr4d3IshWWplUstp67lQHsoVmyE6i9tgxrp54AC6emiywSvVf1RwHeAhmKnTQqV276kxTLj8MkNlrL7Ufkyih6mQzyYFJfZ4dn84YrIKUdcBHzCrRGqtDPm6Vcaia0EgDPnD1vp4xAPGO9EINCtWTPPmHnzYp5C/dMycHcGnyAmP4vUaHJOMarZswdw9Ajo0qtDzL0RculUlGFplB+sSK3Zni+ajQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HfLAeziPNNrruF9DpeMldQ5ehwQenPf8Y9MxK6qnbus=;
 b=lduqDXPesLG09lBdbJy9Q9FwEmZpl239Ntk3CvWnCcf7f16Z8y+QNquM8IPesIIPayJ/SLsVZVojs80ZhpfzMaLnoepQvguvpmhlUHNom2+ui/erQxw5PYtLTw7OQpnt2Wg3DSGA79eolpz+MLp7qSsfIOusPZaGecCVvyytUAVqGqE0FgSKOiIz/XpV/8YvTUAQm13wiMDMj2F8a3jrd6Ti/3Ln3o2bG19ZdHz8fuV5wGqjfGUmKCf7fbT0leT+pW18OvcSupqHRyIyG2CT1RDu6bXW6fIRVMnqXNQwlfBdQlwdiGN+3VObnMeD7FIbB5O/nMZAXhoLogImkq7/Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HfLAeziPNNrruF9DpeMldQ5ehwQenPf8Y9MxK6qnbus=;
 b=d90rZHmXe+Ybjxq8fSEkBX9/NzfGEfIX5WQ2E/GTh0ScaK0XHzkOnO89xNGFPdYE6t6e6WigX/OEeWZq29V//a1q63jTKrVZmbIyN5IT4ZKR5iS4pjId+EpOxGnNl3EIqioq+mxl12c6HWeCEfnUc+c+j8K49AkAbW+jz+oBtZM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3735.namprd13.prod.outlook.com (2603:10b6:610:a3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Sun, 23 Apr
 2023 19:47:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Sun, 23 Apr 2023
 19:47:31 +0000
Date:   Sun, 23 Apr 2023 21:47:25 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, linux@armlinux.org.uk,
        jarkko.nikula@linux.intel.com, olteanv@gmail.com,
        andriy.shevchenko@linux.intel.com, hkallweit1@gmail.com,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v4 1/8] net: txgbe: Add software nodes to
 support phylink
Message-ID: <ZEWLTW0GbpRDaxZR@corigine.com>
References: <20230422045621.360918-1-jiawenwu@trustnetic.com>
 <20230422045621.360918-2-jiawenwu@trustnetic.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230422045621.360918-2-jiawenwu@trustnetic.com>
X-ClientProxiedBy: AM3PR07CA0108.eurprd07.prod.outlook.com
 (2603:10a6:207:7::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3735:EE_
X-MS-Office365-Filtering-Correlation-Id: 38958e4e-d1b2-4a87-5f14-08db443393c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tl3NbBJmfxfRix7dvdSg4Wddh/LJI5uvrTtu0BN9vH20k4NUrx6CankZB5dxP2cUiE3IuwAXuOGHmTf4vv3uMq1f/bPA9jXOBTU/KX4F2ODweQc7InNXSAeuyW7fOZILafDISD45c5yn1jYJI0UkLjMIcIH+cPmIM7GLTo02Dcj50FGxSy2s6il66Nh0wC9rug3rQNkmoQq2aB1cIsxpWjUz+MGVgLFPz+6+DjpUMrsVEDMO6f1k5pzo9gCSwwyXPl4vcY5tGwycNtwa6CPjYB1SBYkhVkPYr12ojGNsIGiI+UqWh2XCgAdWIRVCpYaWqB+JwsDHSbEMoznNQCtCwORClj/bGETQ+jIiNXio2d62RsthjUs8zA05361ygtoD6GylA0DiPV33WhLxy4CXx5CVQS0CxKU+1ubFpynWjXVsXDL7OoQToRdu7gkRp+f847jSsEenoSV7LLbDurrYaOEybXKtJW8Z7uPZYCT5JRLwZiwDZAryp6FwlKcbQbpiOcDSUX4xK7J2DYI6na6dgrU2PqEqlTUrQfM0vKLmzDZwwsbh9ll27MqexgsrWM5f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(39830400003)(136003)(396003)(451199021)(478600001)(86362001)(36756003)(186003)(6486002)(6506007)(6512007)(6666004)(4326008)(6916009)(66476007)(66556008)(316002)(44832011)(66946007)(2906002)(38100700002)(41300700001)(8676002)(8936002)(5660300002)(7416002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jRwihelTejnpbNQqH6pnrS+spF0iA8RyFwljh8QihbQ0G3jQymYRQ05A0dgL?=
 =?us-ascii?Q?sz50S8b0Xpw0SlNr9pcRDxA/DuZZSABIwgURZ+kxeWiPqjdBR8QZ5K8dyKMf?=
 =?us-ascii?Q?5DGnCA6ck/yFNkscu48iv8a9+KLUjXtXeUhtE+S9sT4DKc9T4x9gy/5ON/Xb?=
 =?us-ascii?Q?zO/kEH1RRxlLu4dK6a4ppIluGjxx/TaMeQD2L0L/sIQSJI7Gzsq53IEfvbOZ?=
 =?us-ascii?Q?TYh7IhyZ2iR7mFcC79JMrZLz1JQrqqSSjZzbXIjqJo3FxSGaFtMgPRLzp97c?=
 =?us-ascii?Q?bomnMKKwc6WVv12t+fcm+qLZq3dppaRRCoBdzg1o7rp30jxHGTGBf+SpKXLV?=
 =?us-ascii?Q?ISknUhB6Fmt6pAC7F6lHhS8Cy5Ad47aiRhiFTw4Hy0HTb68GldU/e8Smn5QU?=
 =?us-ascii?Q?K5/978IWF536USWRqY6WjOlKxKH+ZF3JAnxfD0bqlFuqjML8SV7FV/c7PVmK?=
 =?us-ascii?Q?242Y48v6qiXKtoR7E/z3/58ze5QNIpTNuEIsnh418PVWSQjK9i5MDc2RX4Rk?=
 =?us-ascii?Q?zngo6kT/7ONkehjxelWiuJ53tQ2AZpEwd8I4cDjFJcwZkl8X33zlzU3E4SRG?=
 =?us-ascii?Q?Xkhjc56nAKOEBuZawnElJpT2mINzOHqeS3eRcT3dnKxAP7VcP+GougkOdbO+?=
 =?us-ascii?Q?hZe65PgzqWfz/blJwUdeerU/M3bGgW7duueaZKbzCn2SNAGvh4l+WdB2NQXS?=
 =?us-ascii?Q?vSKJANQYZJC+gpK6SvNGwCGUQfbQKbMkp3iuLttXik9VojVEflDDMU0FXPMI?=
 =?us-ascii?Q?wAIYlkugROGUmcimFick3afEYZpEifVcNKWF/9zhSnmV/U6lmZakw/cJ3jtt?=
 =?us-ascii?Q?gm9QOB5Yi9Cn15aKr8Y1hXtjvMB1jdTijwviWeES6ZBM4KcdqjadQUx7uEFO?=
 =?us-ascii?Q?efhqYbZBHL7e49Lk6oLtrMyaEZP8Ehd3uTKSoFRhOeZuXnCdKUOnbxnL/g3v?=
 =?us-ascii?Q?K8N2yjWmE8irtZY75NYBe7QZWliy6g6YbNCqQsJThg+RzDY3pr7Z+hql+VUR?=
 =?us-ascii?Q?Dvw8K5zyZygQooZaNisBon1uYJkooZFTYNrNg7OdMlchBGLTTTqkSo5xoIOS?=
 =?us-ascii?Q?PSUt8Aoz10dlTorJ86mOYKgVx0Z/jsnRp4A9f/tBGXax+hxciNhDy3ixk2Jb?=
 =?us-ascii?Q?xGsACLPb5pHdvK5JLUy1O1aaH5YFufDuzev1mDowmPgwdOlGNS1A6G/qNJar?=
 =?us-ascii?Q?dLCP6+qQEt55VCNVVGg2hHt8IIgR+7DK6rlJYGsgqpePD6KccAlhyGK8vrzH?=
 =?us-ascii?Q?Lbsx4NL0MSpAqdcm16dKQY9yWmGmTNQ/HdIexGtpXgn/1GHI5+kFLLRE9ioc?=
 =?us-ascii?Q?x3d9FMVYDncx1Dc5+zFLbbsmm9KRH3xO5cXy9a3HhbASk3yEbWKdKzzOxtE1?=
 =?us-ascii?Q?e5Fo73+73Clw4zOYPmFI6NQOa9Nhy1jkyH9tlEMOgNYTl/jl/de/csASmd4r?=
 =?us-ascii?Q?BAEIUk5d2Po/TrRa9Dpdne5Oft2sNGw+kYWdjFIW9iCXGZbm1G1DtLlHYWhR?=
 =?us-ascii?Q?2UQnOQHn3+hZfLLBoAI1qNqNRWF5YCKEa8vFAeh1hIXD9d5rKlTvytBQftYm?=
 =?us-ascii?Q?WEajeYc7HHvG0Eh4ZND2nwBIakXFUxJtSwHp7a7KRqe6VfG1HFZZkp5b5nR6?=
 =?us-ascii?Q?RAkaxk8RyI03C02adynmYlybCZLZ5vM32R1yxlFPanWhcLFU/blsa8CQKA0A?=
 =?us-ascii?Q?HcIeWg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38958e4e-d1b2-4a87-5f14-08db443393c1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2023 19:47:31.7682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zA1rMrRi9GfujG3PLj72POU/OS1RdJ/k1pczNcLc6ahlD0UdQOaixp8TPJj+OX+9FFJMhwgUQnB5hrU20YdlnnnPdVet5Hz+w/cychpG1pI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3735
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 22, 2023 at 12:56:14PM +0800, Jiawen Wu wrote:
> Register software nodes for GPIO, I2C, SFP and PHYLINK. Define the
> device properties.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>

...

> @@ -513,6 +514,7 @@ static int txgbe_probe(struct pci_dev *pdev,
>  	struct net_device *netdev;
>  	int err, expected_gts;
>  	struct wx *wx = NULL;
> +	struct txgbe *txgbe;
>  
>  	u16 eeprom_verh = 0, eeprom_verl = 0, offset = 0;
>  	u16 eeprom_cfg_blkh = 0, eeprom_cfg_blkl = 0;
> @@ -663,10 +665,21 @@ static int txgbe_probe(struct pci_dev *pdev,
>  			 "0x%08x", etrack_id);
>  	}
>  
> -	err = register_netdev(netdev);
> +	txgbe = devm_kzalloc(&pdev->dev, sizeof(*txgbe), GFP_KERNEL);
> +	if (!txgbe)
> +		return -ENOMEM;

Hi Jiawen,

I strongly suspect this needs to be a goto to unwind.
Probably goto err_release_hw.

> +
> +	txgbe->wx = wx;
> +	wx->priv = txgbe;
> +
> +	err = txgbe_init_phy(txgbe);
>  	if (err)
>  		goto err_release_hw;
>  
> +	err = register_netdev(netdev);
> +	if (err)
> +		goto err_remove_phy;
> +
>  	pci_set_drvdata(pdev, wx);
>  
>  	netif_tx_stop_all_queues(netdev);
> @@ -694,6 +707,8 @@ static int txgbe_probe(struct pci_dev *pdev,
>  
>  	return 0;
>  
> +err_remove_phy:
> +	txgbe_remove_phy(txgbe);
>  err_release_hw:
>  	wx_clear_interrupt_scheme(wx);
>  	wx_control_hw(wx, false);

...
