Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3E06E9D77
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 22:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbjDTUxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 16:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbjDTUxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 16:53:06 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DA44210;
        Thu, 20 Apr 2023 13:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682023983; x=1713559983;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3oKv+MxCwZehqIpjV/4yvDo2yY11Cg21wBOSJVXui/E=;
  b=CDF0WYd/oA11Slzzpod3SuliARZZlAGnXw8daDQoj+2nf1tQ7douq24N
   gqrqj0nY9Gohv0OCFakcmRuiPxyQ2jiKiG+G/k9Vw2mDlAg4tL/MkcFb5
   D1d+ovdp03UYxvYin9YNxy6Zh8R5ZJCRbKbdDSKELUO/1FNUVUiy5YA7R
   6/0XaYr03cM32LEkqRbD+LMDzeGERL7vKuGn7XoznxKvy5SLObmxLwGpE
   XcNxy9d29Cx8hWX26QtIRwe11yJ8JhXnAH8CNjaZLCpYFrlH4i9LDwcaa
   I/Jjvpdhvc10IBD8sV8iaujE7KCnuyu2OPjWzf4ktDAzVBxCtRwG+yhXT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="347744277"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="347744277"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 13:53:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="835910535"
X-IronPort-AV: E=Sophos;i="5.99,213,1677571200"; 
   d="scan'208";a="835910535"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 20 Apr 2023 13:53:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 13:53:01 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 13:53:01 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 13:53:01 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 13:53:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FSuCsmvWcqNRx0gYXRp9oD/dORxzU1/2ggQvXJ7HhtNXEp5NTO1BHzf77Jp5JrKzA4ZWXUy1USrg8CBXP2RG0OIbYzHHaV7oc09dcI+a/8vFEKg1ZCHChKpxEQ2AkAZXWcHiqfTBAHFkH4Vb5Zh1BWwZnoDA+Nibazcwwr4aLYq6zLmoVGfaZrdGN9++kx+cGrdPo0xu3cFIxa+VkctH0pp34LlMllYnPO4kLwrx7fbE9RNV0/zplMBu11eqyJJkvPQkrt9P24hT8mpqH0EllfLaMS1VPfxANxhMQDFhbmrec2tATbj2MUtkxCHyhkAsQEorDJ1DYhWbRJVwDYaiIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CLzS7V+qwE000Lo7GtR+uphZlbfNrjPtmGEeWizEnJo=;
 b=UCcVZ4GwqUJi55BGvoSgGDe7Hk9umlE8dlnF7YPXLf23wKwuqLcSYJndot1gEIhF7i88VNXuON4UyLU9Ip7rx/kBWJadhbS2fVArJQSF1QNDceiWuYEJpOzAc4Di/+ltuBG+cUWHh0gi3Pft3TV8FG1wVoSOhsfeqPu++tRnhpKdniYPAWxqRu8lxfXvmAmjKtgGlpNs23sNxe31vqy8SN2bgee8GNCC2JsdPOGGmMCNCZq7ThMXkAlMh/bznkWwZ8oc1d7eNTFzRVc/jX5JRn89KcjqIpew6WVMe30VSAkdTyKoAj7r7W08zV3eapcyaeLOimYtdLyvQcmQiuGQCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CO1PR11MB5027.namprd11.prod.outlook.com (2603:10b6:303:9d::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.22; Thu, 20 Apr 2023 20:52:59 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6319.021; Thu, 20 Apr 2023
 20:52:59 +0000
Date:   Thu, 20 Apr 2023 22:52:45 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <alexandr.lobakin@intel.com>
Subject: Re: [PATCH net-next] net: lan966x: Don't use xdp_frame when action
 is XDP_TX
Message-ID: <ZEGmHe2pyxwWiYRL@boxer>
References: <20230420121152.2737625-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230420121152.2737625-1-horatiu.vultur@microchip.com>
X-ClientProxiedBy: DU2PR04CA0215.eurprd04.prod.outlook.com
 (2603:10a6:10:2b1::10) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CO1PR11MB5027:EE_
X-MS-Office365-Filtering-Correlation-Id: c6d26caf-bfb1-4bf0-9d90-08db41e13954
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LbhG5xz8/jJ8JAeNNjR0wDOSx31N5kOa7qxcrF+6HsvyKvAGveiSW9BivqXHbMvtZTVG5b0HNxfnBKw+f75YJ1Dp/kW5Y2zY1u14m667RVDVe6vZvWcru7pZcgcVo8SXDXSIiVDxIfeCrh13itGVJ3VyuSd9scVB70VXq9wlog0q9FcHlQkXcimwiNuSytDCjEg+iuDtKV1n+1kZ2mO6T8ngvNKk1Qykf8V1pcrgJD4VxQ72uao9JtygsnzoftKqqyqgflLN85K3uggi4hoTtFsTFtWdFDvxjr1hzPu3ccvAU1Q20UQWS8EUo0ueDhhwLk4hLj8QAJ+b/FyHA6wj2hzspJjPJRPVTo/gMRxjARTo7oeOT+ee3id3XaeNVD3WTDl9aXVXRU03rDws/kuOxk2D/9KWXe7z5ncY57mq1GIcSzw5OlLHu6+LpDjnooEyG4dmtjOSbfggjKHpNVCYT8+t2Bdy4gjLjF9z6KtUQ01EsuOgQMqTn7ln5A+l613Qr/LKxgWGGXrquPOptfHfklz+3egnwx4y4a3JlOysgXk40I9Z/yXXgxRNIetphZ6H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199021)(186003)(6506007)(26005)(9686003)(6512007)(6666004)(6486002)(33716001)(86362001)(83380400001)(4326008)(5660300002)(41300700001)(7416002)(8936002)(66946007)(8676002)(6916009)(66476007)(107886003)(66556008)(38100700002)(2906002)(316002)(44832011)(478600001)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AWM82YGNhHZCK5vNKq5Ezf8bhg8TDRX5B6cTQKNt9s3wL/TLw9vhOdL6lfsn?=
 =?us-ascii?Q?EU41fcQhVz9s/NVNcllR3XiLuK78Glg+xmPjY7Sa7jkXQE59rKihxjKaWRLr?=
 =?us-ascii?Q?bSxcr4ETcIG8w8B1R7oag4mTJ3rwNGhAs54F8BesYEqOn52R0Ikthv8qKzZq?=
 =?us-ascii?Q?e4XDapYwMA4DgLw+tn6Ppqhg8wwtYlx1psf07L33a8FHvcNxBeO0r1HvhSWH?=
 =?us-ascii?Q?9P8dCG6nRKwvvtjSCgdNwexI5Cv22CZMWgvaXL+xRYT8dxYv1Nb19t2U8pn8?=
 =?us-ascii?Q?tc8J50ahT6JV3ekf7UUcDM/CD0GYtgifX3RE+ePtyNzdRoGJmEjrYCFlhjKa?=
 =?us-ascii?Q?H+ad/WXPcsLOZFcWE9xSnEtaO5EtCEqoAoNKUrGvZBK58M7Q3sWGAdjy5uC/?=
 =?us-ascii?Q?wmg860Hsmpgd1HYYBtF6U9HiHiiV0ZvNa6+fwks9v4kAw+HcoMZv/dX9Ku5N?=
 =?us-ascii?Q?d6QvTAbeqzzrc6J2XNbudfraSwbfobBoBpGTlnwPVj5WhSZk4dlzNppK7Qob?=
 =?us-ascii?Q?llKWS2BjABO5l2+kjear6fYR++q/ouQHRsKP6naGvp6HS6bRoaZ4zevsxR+s?=
 =?us-ascii?Q?NXvUBRsRbDWWKf1jXdEHENs3Lqa9DivubIE88NTLbufqR24ijsNjKi42luoi?=
 =?us-ascii?Q?MJBMT3h8izVdOdKZqPuDnY8jTSW8AY4RUzRIvr98kFq4qvLiZMK9034RaBsG?=
 =?us-ascii?Q?dHDPapJmkR4wTx+CNnQ+7acH6LsPQKFw+9iLnoSU7BEASnuB04pNmoSDYxKp?=
 =?us-ascii?Q?xIKSs3lqRisYay4gRqIo5zdrXIU4VXKgelrJWLse8xU+75yaFCJhlLsBymKr?=
 =?us-ascii?Q?7rCnNJfgOFVBrctPnN20e94WIAF+ew5F5JVuWkFEmNlWG+Gbdfwd0NZOC8bK?=
 =?us-ascii?Q?GYV9Ub2b9MDe31PFdcYB2LqFnR3JDYWBTPyFvefho4uuQdccytVeiyHfzQWq?=
 =?us-ascii?Q?Omhe9BbQJ9lB/VeBOY+Ovm5P/7h+TlH0dzJKSEj2wjtHUQP9emK++K4qzlOD?=
 =?us-ascii?Q?OIBODvjF57sMdzDcoCJoIJktjW8lU4EpGnEFqd8TphiMqqlR4knArs3zLhBi?=
 =?us-ascii?Q?HCQ4BWHg5pOg/tvYMuknltCSkqz/96DGeK1zhNy+SEcQFte0p9NqdHpwunR5?=
 =?us-ascii?Q?4Ae5J4u6FD381najs2E5Lmh/gV08nAzJ+aRVwu//rJBFY3M42Sg8VL8II+XR?=
 =?us-ascii?Q?QJ9yyRRaWx2IlzN3KrCKKZep/bsCVxoOtiA8AZ8YiyTcFn6XyaQqsZtGjpD5?=
 =?us-ascii?Q?JtUYkn0gGlD1S8hgkSh+L+EGa91/ArTcjYM3Sr1/H7QQrMcXwT0MipgeNRCu?=
 =?us-ascii?Q?XMgcVNovGE3DRcbuytVM1dLU3R+a8nKnAPTUsAwHxbNrKZ4Ehvg2dIrUC1V4?=
 =?us-ascii?Q?CJcL5ccZjINGSPBwQ2E1Kyl5D7qKA3Vemkgl/dcC8Rs4c4k03hrzJlnR5Lz3?=
 =?us-ascii?Q?HAHQ2mLz4+uMselmr9Ygq54zxryqOK7dJPrMojT/0DO6ZRXS+7OPYOrr3kyZ?=
 =?us-ascii?Q?KGV4YwfBp95C6iUjdCqNh0I8jv5XtqbWfJHHzzX8+6wJd88/LvMcFEXJr72H?=
 =?us-ascii?Q?Z4lOPaKO9hpLKgBe01OHlkPDfpWr8R5qVOUUVzUjA+2JpzZ3+XTmhNVGr/ET?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d26caf-bfb1-4bf0-9d90-08db41e13954
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 20:52:58.9832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rjt+sXYPAn676HtjqAi3Wt3HgYdiBx1P1ycU2xHxQ+GKqJkHDxmQuv9PEGVZEBwL6JtMw6LDE+0d4r5FjC0J7Irv6Znbl+vqclswF0uwPTQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5027
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 02:11:52PM +0200, Horatiu Vultur wrote:

'net: ' in patch subject is excessive to me

> When the action of an xdp program was XDP_TX, lan966x was creating
> a xdp_frame and use this one to send the frame back. But it is also
> possible to send back the frame without needing a xdp_frame, because
> it possible to send it back using the page.

s/it/it is

> And then once the frame is transmitted is possible to use directly
> page_pool_recycle_direct as lan966x is using page pools.
> This would save some CPU usage on this path.

i remember this optimization gave me noticeable perf improvement, would
you mind sharing it in % on your side?

> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../ethernet/microchip/lan966x/lan966x_fdma.c | 35 +++++++++++--------
>  .../ethernet/microchip/lan966x/lan966x_main.h |  2 ++
>  .../ethernet/microchip/lan966x/lan966x_xdp.c  | 11 +++---
>  3 files changed, 27 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> index 2ed76bb61a731..7947259e67e4e 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> @@ -390,6 +390,7 @@ static void lan966x_fdma_stop_netdev(struct lan966x *lan966x)
>  static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
>  {
>  	struct lan966x_tx *tx = &lan966x->tx;
> +	struct lan966x_rx *rx = &lan966x->rx;
>  	struct lan966x_tx_dcb_buf *dcb_buf;
>  	struct xdp_frame_bulk bq;
>  	struct lan966x_db *db;
> @@ -432,7 +433,8 @@ static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
>  			if (dcb_buf->xdp_ndo)
>  				xdp_return_frame_bulk(dcb_buf->data.xdpf, &bq);
>  			else
> -				xdp_return_frame_rx_napi(dcb_buf->data.xdpf);
> +				page_pool_recycle_direct(rx->page_pool,
> +							 dcb_buf->data.page);
>  		}
>  
>  		clear = true;
> @@ -702,6 +704,7 @@ static void lan966x_fdma_tx_start(struct lan966x_tx *tx, int next_to_use)
>  int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
>  			   struct xdp_frame *xdpf,
>  			   struct page *page,
> +			   u32 len,

agreed with Olek regarding arguments reduction here

>  			   bool dma_map)
>  {
>  	struct lan966x *lan966x = port->lan966x;
> @@ -722,6 +725,15 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
>  		goto out;
>  	}
>  
> +	/* Fill up the buffer */
> +	next_dcb_buf = &tx->dcbs_buf[next_to_use];
> +	next_dcb_buf->use_skb = false;
> +	next_dcb_buf->xdp_ndo = dma_map;

a bit misleading that xdp_ndo is a bool :P

> +	next_dcb_buf->len = len + IFH_LEN_BYTES;
> +	next_dcb_buf->used = true;
> +	next_dcb_buf->ptp = false;
> +	next_dcb_buf->dev = port->dev;
> +
>  	/* Generate new IFH */
>  	if (dma_map) {
>  		if (xdpf->headroom < IFH_LEN_BYTES) {
> @@ -736,16 +748,18 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
>  
>  		dma_addr = dma_map_single(lan966x->dev,
>  					  xdpf->data - IFH_LEN_BYTES,
> -					  xdpf->len + IFH_LEN_BYTES,
> +					  len + IFH_LEN_BYTES,
>  					  DMA_TO_DEVICE);
>  		if (dma_mapping_error(lan966x->dev, dma_addr)) {
>  			ret = NETDEV_TX_OK;
>  			goto out;
>  		}
>  
> +		next_dcb_buf->data.xdpf = xdpf;
> +
>  		/* Setup next dcb */
>  		lan966x_fdma_tx_setup_dcb(tx, next_to_use,
> -					  xdpf->len + IFH_LEN_BYTES,
> +					  len + IFH_LEN_BYTES,
>  					  dma_addr);
>  	} else {
>  		ifh = page_address(page) + XDP_PACKET_HEADROOM;
> @@ -756,25 +770,18 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
>  		dma_addr = page_pool_get_dma_addr(page);
>  		dma_sync_single_for_device(lan966x->dev,
>  					   dma_addr + XDP_PACKET_HEADROOM,
> -					   xdpf->len + IFH_LEN_BYTES,
> +					   len + IFH_LEN_BYTES,
>  					   DMA_TO_DEVICE);
>  
> +		next_dcb_buf->data.page = page;
> +
>  		/* Setup next dcb */
>  		lan966x_fdma_tx_setup_dcb(tx, next_to_use,
> -					  xdpf->len + IFH_LEN_BYTES,
> +					  len + IFH_LEN_BYTES,
>  					  dma_addr + XDP_PACKET_HEADROOM);
>  	}
>  
> -	/* Fill up the buffer */
> -	next_dcb_buf = &tx->dcbs_buf[next_to_use];
> -	next_dcb_buf->use_skb = false;
> -	next_dcb_buf->data.xdpf = xdpf;
> -	next_dcb_buf->xdp_ndo = dma_map;
> -	next_dcb_buf->len = xdpf->len + IFH_LEN_BYTES;
>  	next_dcb_buf->dma_addr = dma_addr;
> -	next_dcb_buf->used = true;
> -	next_dcb_buf->ptp = false;
> -	next_dcb_buf->dev = port->dev;
>  
>  	/* Start the transmission */
>  	lan966x_fdma_tx_start(tx, next_to_use);
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> index 851afb0166b19..59da35a2c93d4 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> @@ -243,6 +243,7 @@ struct lan966x_tx_dcb_buf {
>  	union {
>  		struct sk_buff *skb;
>  		struct xdp_frame *xdpf;
> +		struct page *page;
>  	} data;
>  	u32 len;
>  	u32 used : 1;
> @@ -544,6 +545,7 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev);
>  int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
>  			   struct xdp_frame *frame,
>  			   struct page *page,
> +			   u32 len,
>  			   bool dma_map);
>  int lan966x_fdma_change_mtu(struct lan966x *lan966x);
>  void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev);
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> index 2e6f486ec67d7..a8ad1f4e431cb 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> @@ -62,7 +62,7 @@ int lan966x_xdp_xmit(struct net_device *dev,
>  		struct xdp_frame *xdpf = frames[i];
>  		int err;
>  
> -		err = lan966x_fdma_xmit_xdpf(port, xdpf, NULL, true);
> +		err = lan966x_fdma_xmit_xdpf(port, xdpf, NULL, xdpf->len, true);
>  		if (err)
>  			break;
>  
> @@ -76,7 +76,6 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
>  {
>  	struct bpf_prog *xdp_prog = port->xdp_prog;
>  	struct lan966x *lan966x = port->lan966x;
> -	struct xdp_frame *xdpf;
>  	struct xdp_buff xdp;
>  	u32 act;
>  
> @@ -90,11 +89,9 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
>  	case XDP_PASS:
>  		return FDMA_PASS;
>  	case XDP_TX:
> -		xdpf = xdp_convert_buff_to_frame(&xdp);
> -		if (!xdpf)
> -			return FDMA_DROP;
> -
> -		return lan966x_fdma_xmit_xdpf(port, xdpf, page, false) ?
> +		return lan966x_fdma_xmit_xdpf(port, NULL, page,
> +					      data_len - IFH_LEN_BYTES,
> +					      false) ?
>  		       FDMA_DROP : FDMA_TX;
>  	case XDP_REDIRECT:
>  		if (xdp_do_redirect(port->dev, &xdp, xdp_prog))
> -- 
> 2.38.0
> 
