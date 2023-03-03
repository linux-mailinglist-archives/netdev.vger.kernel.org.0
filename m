Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46796A96BA
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 12:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjCCLwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 06:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCCLwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 06:52:04 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2107.outbound.protection.outlook.com [40.107.212.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FC35CC39
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 03:52:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4BswoY0qPK1gSfeM/Vx5Kp2DmsRyX41dxRCspZRP2ApXOZkX5KcIu2h7kOaj5zWmU13mq08vYZ9zQVx4ggyoWcum4gpohnvUwpqc+H1PEPAsM/r/7nzSWEtpW9wqkkw2qqSgoqY81b2mLC32cxbuIsdyXHbcOTK6gc01qvotoUsKa5qQojHh2DJDGqKUyq52YVFyTpi2Qyr92IxDeNpLhG0BWyHnBajxiu3Nv81KFrbL72V1AtMRdV20XDTS/yTU+p192vNRG7VnHdHGsY6TdH3My3+K+WPmwAmVLgTfm8E1oPw5fxMiXs1yvBCdkfMSJnA0uOp6Qe1sbU4dsoaAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jq/FlyUpRNdZ/6fZE72TwzJl4RYPFDjVy1mUGChLNW8=;
 b=mtpB3GM+3V6+CX9KmkqvmcTsF/3hmMcTqRNi0F4Fxv8IAJE14Qa31PjKKqzrDQ5b7xbp8CpsS53SSn0Fk6p4XJEIVZcXIJYMjh9ZIN5/LEx4kH7sZQRQEiq3i+QnY5knW6LVW61BTOBVPxsOA1f2bCIy00Rzqfi5rlsE+JFs6RsjWUiH33C0ae+NEI5RbbSltnGiDgkoHlTnsrAEFWD49Uqywihro0LUyOopqMzvCpcjCQBHG+c+xR4A7A/kw4DmG9g5Iy45JA/DClbrV8fib+1Ep+Aa/WdevnLNf4fP8PSsy0u2TdXHFgOlxtzmEpSRcfY8i3/X8iD4QOG7fwtOHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jq/FlyUpRNdZ/6fZE72TwzJl4RYPFDjVy1mUGChLNW8=;
 b=HO0hLUqN2uh5dU3Tr3cgL3UtLHEwyb84okH/cVk1otvIY1gkJA4x/XjEAcZdmIC1kX44Ui6YeMwlzKXAnSx6cQ59hAPXOiHDUZuecwtMlJw0P72FHZKC8tpCgl5OCYkVZTmyZuZSxC+9/PI2z1UzjeM5+NtVfoWVyujX6rlLIkA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5974.namprd13.prod.outlook.com (2603:10b6:510:16d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Fri, 3 Mar
 2023 11:51:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.021; Fri, 3 Mar 2023
 11:51:58 +0000
Date:   Fri, 3 Mar 2023 12:51:48 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Arinzon <darinzon@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH RFC v2 net-next 2/4] net: ena: Add an option to configure
 large LLQ headers
Message-ID: <ZAHfVNAgzgEZNByU@corigine.com>
References: <20230302203045.4101652-1-shayagr@amazon.com>
 <20230302203045.4101652-3-shayagr@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302203045.4101652-3-shayagr@amazon.com>
X-ClientProxiedBy: AM0PR10CA0131.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::48) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5974:EE_
X-MS-Office365-Filtering-Correlation-Id: a2cbbe78-5737-42d5-c908-08db1bddb146
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bEjx1yNqsQxIEDQtdrMmS4++bJKBCfc8E45wi+XHmJDpFRifaGcq0GUZweYI99q41abo7T0+UQmQWLJ2h6tkRGuuHD8dCWBFZI+5GBLCSS6JaPcW4x2c8zup41SlGhzk5EPpQ0a3a8QY5pNzo9eBh0mJzNpQkx7JjEQ63xS8HeRsPwurn9JCO9cRJw/BFzM0sq7ObkcdoDDGjHHcu/l919Xbc9hf7Ifa1w1WVYlrn18h6uMURQM/AQShxWzgkNnphopx1DmPh3QmbFygSonFiFNg2VekYHMgO9a8wITEboVw1zRio8g1I3KFo7rJ2gf4XVNqAf4hQa31p2uvTQg8P70eqrrJgU+p6S57sTzdfhFh2Rc0Ez+jMX+4NBuE5rjyu9jYEJhPraSx2lraBkSkcq1ImZ6P5Te0o5Ioxcz97GKMKAVD6rm2tK+GT2w0+LjGCHueGUn8kNnDPeM294nPnZU9leBnUucrAHb3K1CQstWnU6SEBY+3No+ZybonqGmBiL8NFHdvz0kF13mMKLD3BYr2E/LKabuhd4i3BXTMAo/PnY7bgl2APKHA3wxOOmWOFEzutLTQS4xfuEWNiez7kiTgRb9f5nqVLrpKSB4ZDiuCHkaDNy4c004+ChlY7fBU5lPVKVYYsjheGundtv2qvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39840400004)(396003)(366004)(451199018)(86362001)(54906003)(36756003)(2616005)(66556008)(66476007)(186003)(66946007)(8936002)(41300700001)(8676002)(4326008)(6512007)(6486002)(6506007)(6666004)(316002)(5660300002)(38100700002)(478600001)(83380400001)(6916009)(2906002)(7416002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OBVH+g9d/e4XSV1NcwVXXBJoBan6zHIJbjE32FZpIOo0wS09Iix0xhbbWyPP?=
 =?us-ascii?Q?PY4N9i4+xq+1qNxS9pkwXkPM3Hivjs9ZeV3qDf23rFUx5EWT4YOTyx9cGSJG?=
 =?us-ascii?Q?u/JJfsvQeqgdJGHN0E+W16VPfdufqVpJI24zofZvp07UC4+c25mKL/+wn4hl?=
 =?us-ascii?Q?8tj54tJoanaDUzrwfM3gJChKMBr3rV/J1WPEpmKBuxoXuee7xt3C8yFFGp1y?=
 =?us-ascii?Q?wTE2GMO8fYRBpMkEE3M8sTYkoia3jt6tZbENJ32BXr2eH0j6W0QfXsWRDSU2?=
 =?us-ascii?Q?SrzOeEGG9XavI9//i4k3Mcx6tK4bUA6p5o1Gl19KXYo7NWtz8Cngr/N5WJOQ?=
 =?us-ascii?Q?5EKaFSFinxpB44JYoXzfcPneUp+IU2s75taS0nv6TWmS6rFiqW+7aTh1GFNk?=
 =?us-ascii?Q?m56Nuf09wlBS5OxSHUqecKmNPe0Q9/39pCKEziGDlOf++Fh+0ci06PSaA1n5?=
 =?us-ascii?Q?46cjpb03/KBTQ1CBnL+sDqXcjyZPvn4v1FUJdBuaJYDQ6mF2Pm0DYAIqynBk?=
 =?us-ascii?Q?GZbkm4zU8GAfjp21Jv9HHeYU1fEYhF0CGx8v++d/g/o0xr0xrV84+K6X/67a?=
 =?us-ascii?Q?btXf/GLK0c3v1mLCeM7BQE5RAQ15zeDvXHyg1Ni/HzWPi1dvNhW03NP4L9XZ?=
 =?us-ascii?Q?lfEqHHKlARnG5T4f6SNZax0LbZnCKBdTepFrxjTVr0pI1MFIoGOJCmBdviQS?=
 =?us-ascii?Q?YPSaMJEVUDKR76SEu8EbG1zyli5+3LRsis6kKkbXSMAdaAUqxtiQGhHlsrho?=
 =?us-ascii?Q?is+0BQEXdoySoSLQED3Q2tXxZe/I5fGIVIPw/THFwCTjSrKOQ0CclUwJBzP3?=
 =?us-ascii?Q?8F51NwW/k2R84tANcKJ1dpE4bXy1PBYPESbktiTKNR+MWbJNLUCIP0u/kiy1?=
 =?us-ascii?Q?c62rzcojsLYab41cqFpBCFD6dD5i6k/H4tHX4wRFl/y1wa2nZc+nXc9sHiPl?=
 =?us-ascii?Q?24fmlsoYTKAUTjLDoMoc+3M2P8jCYjOoplhM9tlw5Pz3i1TszHYZcEiML5qp?=
 =?us-ascii?Q?GLRe89zNRD5hPeXO/8+6g2zJMN5X6E67ZFaAanV0ZvEwSLE/do7Tr0uL6W96?=
 =?us-ascii?Q?xmhGi9mPGnIXQ2MrqWkRx/6tji1Recnl4BjcftfNkpvPcbQYjEFx1v8bCImP?=
 =?us-ascii?Q?dXR8YD80NzHR4sA3XQodNrAn6AoEy4PhcXotLMzHzkkB/JHDXWteEEgb/ejl?=
 =?us-ascii?Q?h5JqBdhs4gbEk2c0UNyonLcY/NbL6QWhiQNFNtH4m+nawnEiuUid2qG3xSGO?=
 =?us-ascii?Q?zTypXwU0Ru3AcvTNnQNEjOG7ARe97i7Icg85v7nQr/lHgaudlqNGvQLhjxth?=
 =?us-ascii?Q?GyvSE9UzOKfnNFkDGyxmy+gJfHfZumCFCQgxbAVbiPikNmEyk96C2D/qn75t?=
 =?us-ascii?Q?rIqxrD0SXCaRta/2y0+p64Qac7azlKFNHSu5n/paUWAlOd40ELEIGT0Tp7av?=
 =?us-ascii?Q?z0dkMBw2qiFGoEiV+fluWx6Go/Huoae3BcNkcxpbCoFaTQAlJwA34VGSlbKt?=
 =?us-ascii?Q?oe9Oi8FqrFd5MWWKWPrKqMfhR084Q1xT8O8pMWuFaUImqHdpmmOXMjztAjMv?=
 =?us-ascii?Q?miGq16zKyngejW0wAjvHWtZogez3XkFvZa7sWNNnJ/gDhFHJqgIr4iFAR8U1?=
 =?us-ascii?Q?YdnbYU1FNprr6wWO4on6sxPrrjm+JbDQERI8S6VSvCgHuox1QyM/5r9xRR15?=
 =?us-ascii?Q?zLUYmQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2cbbe78-5737-42d5-c908-08db1bddb146
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 11:51:58.1641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JHVe7TrysrQpqY+ppbwojYFotb16EAmXlVIKHRRVIQgLgLUu9deNJ4/6crhP5tvsmwz4yHhEZRtMZJpjl8Pw7yQ6a42pRw284L7eajdpZvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5974
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 10:30:43PM +0200, Shay Agroskin wrote:
> From: David Arinzon <darinzon@amazon.com>
> 
> Allow configuring the device with large LLQ headers. The Low Latency
> Queue (LLQ) allows the driver to write the first N bytes of the packet,
> along with the rest of the TX descriptors directly into device (N can be
> either 96 or 224 for large LLQ headers configuration).
> 
> Having L4 TCP/UDP headers contained in the first 96 bytes of the packet
> is required to get maximum performance from the device.
> 
> Signed-off-by: David Arinzon <darinzon@amazon.com>
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>

Overall this looks very nice to me, its a very interesting HW feature.

As this is an RFC I've made a few nit-picking comments inline.
Those not withstanding,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 100 ++++++++++++++-----
>  drivers/net/ethernet/amazon/ena/ena_netdev.h |   8 ++
>  2 files changed, 84 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index d3999db7c6a2..830d5be22aa9 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -44,6 +44,8 @@ static int ena_rss_init_default(struct ena_adapter *adapter);
>  static void check_for_admin_com_state(struct ena_adapter *adapter);
>  static void ena_destroy_device(struct ena_adapter *adapter, bool graceful);
>  static int ena_restore_device(struct ena_adapter *adapter);
> +static void ena_calc_io_queue_size(struct ena_adapter *adapter,
> +				   struct ena_com_dev_get_features_ctx *get_feat_ctx);
>  

FWIIW, I think it is nicer to move functions rather than provide forward
declarations. That could be done in a preparatory patch if you want
to avoid crowding out the intentions of this this patch.

>  static void ena_init_io_rings(struct ena_adapter *adapter,
>  			      int first_index, int count);
> @@ -3387,13 +3389,30 @@ static int ena_device_validate_params(struct ena_adapter *adapter,
>  	return 0;
>  }
>  
> -static void set_default_llq_configurations(struct ena_llq_configurations *llq_config)
> +static void set_default_llq_configurations(struct ena_adapter *adapter,
> +					   struct ena_llq_configurations *llq_config,
> +					   struct ena_admin_feature_llq_desc *llq)
>  {
> +	struct ena_com_dev *ena_dev = adapter->ena_dev;
> +
>  	llq_config->llq_header_location = ENA_ADMIN_INLINE_HEADER;
>  	llq_config->llq_stride_ctrl = ENA_ADMIN_MULTIPLE_DESCS_PER_ENTRY;
>  	llq_config->llq_num_decs_before_header = ENA_ADMIN_LLQ_NUM_DESCS_BEFORE_HEADER_2;
> -	llq_config->llq_ring_entry_size = ENA_ADMIN_LIST_ENTRY_SIZE_128B;
> -	llq_config->llq_ring_entry_size_value = 128;
> +
> +	adapter->large_llq_header_supported =
> +		!!(ena_dev->supported_features & (1 << ENA_ADMIN_LLQ));

nit: BIT(ENA_ADMIN_LLQ)

...

> @@ -3587,7 +3609,8 @@ static int ena_enable_msix_and_set_admin_interrupts(struct ena_adapter *adapter)
>  	return rc;
>  }
>  
> -static void ena_destroy_device(struct ena_adapter *adapter, bool graceful)
> +static
> +void ena_destroy_device(struct ena_adapter *adapter, bool graceful)

nit: this change seems unrelated to the rest of this patch.

>  {
>  	struct net_device *netdev = adapter->netdev;
>  	struct ena_com_dev *ena_dev = adapter->ena_dev;
> @@ -3633,7 +3656,8 @@ static void ena_destroy_device(struct ena_adapter *adapter, bool graceful)
>  	clear_bit(ENA_FLAG_DEVICE_RUNNING, &adapter->flags);
>  }
>  
> -static int ena_restore_device(struct ena_adapter *adapter)
> +static
> +int ena_restore_device(struct ena_adapter *adapter)

Ditto.

...

> @@ -4333,7 +4384,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	ena_dev->intr_moder_rx_interval = ENA_INTR_INITIAL_RX_INTERVAL_USECS;
>  	ena_dev->intr_delay_resolution = ENA_DEFAULT_INTR_DELAY_RESOLUTION;
>  	max_num_io_queues = ena_calc_max_io_queue_num(pdev, ena_dev, &get_feat_ctx);
> -	ena_calc_io_queue_size(adapter, &get_feat_ctx);
>  	if (unlikely(!max_num_io_queues)) {
>  		rc = -EFAULT;
>  		goto err_device_destroy;
> @@ -4366,6 +4416,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  			"Failed to query interrupt moderation feature\n");
>  		goto err_device_destroy;
>  	}
> +

nit: this change seems unrelated to the rest of this patch.

>  	ena_init_io_rings(adapter,
>  			  0,
>  			  adapter->xdp_num_queues +
> @@ -4486,6 +4537,7 @@ static void __ena_shutoff(struct pci_dev *pdev, bool shutdown)
>  	rtnl_lock(); /* lock released inside the below if-else block */
>  	adapter->reset_reason = ENA_REGS_RESET_SHUTDOWN;
>  	ena_destroy_device(adapter, true);
> +

Ditto.

>  	if (shutdown) {
>  		netif_device_detach(netdev);
>  		dev_close(netdev);

...
