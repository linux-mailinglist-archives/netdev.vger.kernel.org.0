Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD66634A04
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 23:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbiKVW1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 17:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235219AbiKVW1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 17:27:40 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C806414;
        Tue, 22 Nov 2022 14:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669156053; x=1700692053;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+a1FMXh8R+0J+PibPJ1Sk2P72HTDAzihBTakQszuTqM=;
  b=aTDcnbPEWdq6cCzpkLpX5/q3iUNpi+v1mQ7YgNMnZJiqCEXAv/H1KyFp
   B2dACqkLA8XMkWpptL5gFBRsUiVzTOMA5nnkxcLYKrFX2xm3kHlhD1rxz
   dzcBeXOL+qSoetx5xXfA+nXTheYAwQSptqwnL+bBE2hOk3+CfygFHeS65
   byhuRzHsu+hmiaLtqL3ywb9rVrzPb8NZPYc4H/r+Dq5j6AmtCHqhkqRnO
   KirEuiytLhDhtarIcAWYSyZELmy3ZgtCXtzL5WLv3dBDRM1E+tMndOLG1
   uY0Rqcx8bSNdExeIR884yF9FnLLbEr57p35IVSYn4g870qx0IRV0stPu9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="312627863"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="312627863"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 14:27:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="710357248"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="710357248"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 22 Nov 2022 14:27:25 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 14:27:25 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 14:27:25 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 14:27:25 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 14:27:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AX8hR1npQ0yJg0UF8O2QEN2rA8KGT8a2j+sV12vzvVAMtauGz4zkJQ6axw9bLmZbEGCcCq5exKQcb58fuhKkqOSxUGBcVpSF018nnCh7U/QOJzIvAEQjy3iV/HDZqTHWSbEqdJGNr2Rh874DEoWEDEhuXF5bIa9rDvhSxJsAvisnw56JgmkfwMNUDwbDqV5lvvW4Pq4Y+pR2ikw+plr5kfuSnYng3qFymvHcJUfOO8tCKHx9Hu6rqGX3yCtxxfQMZrx7TCpFwDDEky7FqtVsExS29t03YFyHHBrPmBpmiYYvzSlm2gDKSxP7LPLvtdq1nYBDcNamUyJWXYS3BE+MWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j7y/JAQr4vv/CUKUz8piOgvkDpOirXn6Wu+ccJ4wrm0=;
 b=Vz6DBPkuiYfmJKzpV0lefvRPf7n1rHe/lLOlmh8HcmXvs1AH7SKN+2pfWsmdsUHb3JnZ4v5ii1ax24PnxqxG12GwG2Cw1aEDJ/SOjga4I+6GX9GYfdTGlpCqn4EFNSI0a4gJ/iclVGNhA67YQXFixUoyCYB4LXQaOGrIEDH3stoYXD9A9BSXU57FI7Mo1LW2+RPisEp+1aTDDmvvd0YH32mz8kYtVY30T7xQm2ubLi+8BN067UJPvyLYpXS5ZhMV/Uzdy/JjrhJljAOHGYAthFjgWM0DaB34ybJNC5sTmksDEjvu7nFLqcfvD/jrEmA6soOhfE/b5LSM03FrViMm4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CH0PR11MB5708.namprd11.prod.outlook.com (2603:10b6:610:111::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 22:27:22 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Tue, 22 Nov 2022
 22:27:22 +0000
Date:   Tue, 22 Nov 2022 23:27:07 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <alexandr.lobakin@intel.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v4 6/7] net: lan966x: Add support for XDP_TX
Message-ID: <Y31Mu/hAxrmbn7Ws@boxer>
References: <20221122214413.3446006-1-horatiu.vultur@microchip.com>
 <20221122214413.3446006-7-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221122214413.3446006-7-horatiu.vultur@microchip.com>
X-ClientProxiedBy: FR2P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::16) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CH0PR11MB5708:EE_
X-MS-Office365-Filtering-Correlation-Id: fc494198-86ea-4a14-3e42-08daccd8b986
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N1+2ZCBCPkpa0S5HI689v36WaLvWePPb0USVLtPSfhQljQzWF9y9RplzlTjXPDEtByFHnc/WkkkGckWFB5do28gk8425EbbjqzmrTyTEdP5k8bvf0aYgroDL4cqjk9nDNdnRRZ8DgEQOHWEHykQpRu9mC4BlOevU63VUBz+tJbTeFAtfFPYLuJ2TLIoFjRVwGVGwbF4sffH9hZPeb/W54G7lj8fsXOVvNqR3VRqXVf9JOfiqN+etZzp3c3evge3KasY5IPQIosw/jsmZCfXC66aJRbJAMN2BEkA1RMReiREJ21YKL5PNq1PqWf+moaj4r0V5y63pf5xfapB9pUf2yssD7WnRfem3w3mgItRNbAAV0kA2hu47R+BM3m/yE2urI2EgCl7pji2f6u1EzPmmBWvNGu73DeqrC6WgjvKpmeHOpK78b8+4e9B6B2JAUsRkEHHFlF5m6KASZ5AYggwNYVDYvx2AD2ZKKi9Sa0uax1cWFvNxSIGEzOCUvbBEt6LI4dghCscPrsQNNjH/AXnQR3iVCBti1cD9NnNTNu0UZ+nIJpoigH6/wAgfjXPCwCYSdeYEjfFDdb04BKtoCfPwzLdpx6oX7M7Mwwl9j8r7rGuIhQ36z9xUXdgQk6J3pecz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(346002)(39860400002)(376002)(366004)(396003)(451199015)(66556008)(86362001)(41300700001)(66946007)(5660300002)(186003)(66476007)(6486002)(8936002)(8676002)(6666004)(7416002)(26005)(6512007)(478600001)(9686003)(44832011)(316002)(6506007)(6916009)(33716001)(82960400001)(4326008)(38100700002)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?11mzNBam+sjhUGqk7vrq99GxF/bk2w3JUToBj6gwrZDknl8dJfLxXzA5i9ox?=
 =?us-ascii?Q?0BLWNGXMtQ7kU10KJ4lEk15TFXq8q5qLdD70qumduaDF1nNAm4Qk5Cpk8g5B?=
 =?us-ascii?Q?Ess42eVD5qt0IMEQ91Q95pI1rmBqTyST19GBcpfQS3W3ANe/mDsYeVLzbHLP?=
 =?us-ascii?Q?B26/Q7/l7tNURAItGPVPaWFopT7AFtPKyCV8vSbGRGJRviL07jgsSFkat9aY?=
 =?us-ascii?Q?p7w2wC806PM/Y3Yq14GNumV4FN82pm6Yna8BS51diIiZn87RQBjQwl+3RJEc?=
 =?us-ascii?Q?lx/9/Uv5WX0A5zC2EDnBEfs+NBRAfKv6tpuO7Qqk5uG70ItJF9WtQo3JYgfH?=
 =?us-ascii?Q?cogEX7ZBRkZ3QufvzkJ4AdULWkh+md7V9XEZjFGJZj6PVY6xkUdPl19k2ihP?=
 =?us-ascii?Q?GVmea6fxHlCOu/Vh7PwJlD/qYMhqc6RDKeLyrY2BK35cufBHo6/heHOIPLct?=
 =?us-ascii?Q?9zAox3cbZwHEQXG1taiRwuoO0VsDMCkgtrLm/G1B7Jw3QgSJmflEjNgVALyt?=
 =?us-ascii?Q?qVzPvFSB2ELa7Lj38ZXzvEjqiIRYwJwJN+BtPy3Z8EVd8J7PQ2XHdvEKAPQl?=
 =?us-ascii?Q?c/Zjh6ADASA47apC6hvR5tpm5EPmHmMUC09ClZk6RHhcIypPo//arqfk43WC?=
 =?us-ascii?Q?da4uX8oOBRJPjdgbV5vmKAfTguAZF7tb/n0AW8SAPn/VZ3rBRPwd3sGJOOZL?=
 =?us-ascii?Q?obj6Zl12jPkvPSLMEnB7RhKr1xmq7lgMidbo4/jx8+6WiMj8FK3Yt0CZjZKy?=
 =?us-ascii?Q?mwowiahGURJ1XopAViY4lvDxbLatuB3m2APKrjqUyhZ4wqUAm+ydEXsSfAnr?=
 =?us-ascii?Q?TYWFB83Avt8JCyEAmPzIBPNSzhjhVtoLy8f5L3ydi9L/CikRlt2IHamBz2L2?=
 =?us-ascii?Q?qCzUPdHG3bLjc1GJi8J3HowYw5CwQVTSpgXrJ3eDl5KufYfwNGVyh0cRdFMq?=
 =?us-ascii?Q?0VR1gYe8Un9e/e3gm0WpF8cveFG50NN36Edf7aBZar9Ne9FN+ejT/GG/X4GW?=
 =?us-ascii?Q?DsxHUWjVd1U0KFV31Fr/gve44PgUX5szH7jLAfxD3NX9o9LKPLZ9ri92s9+M?=
 =?us-ascii?Q?zaexCnlk9VHzbJ5IALs1AwKeKDwj/7UkAiNTOzyf0JTDKz/8TzvN/8Po5Pcc?=
 =?us-ascii?Q?t1WVPt5m2XilDmFAqnYqHlXxuQa3chzs+rPyoXNTc8JYDa9arCa4smMe2vma?=
 =?us-ascii?Q?bbwOb+AcEk4CYZ3J/Vy6Abo1akdQcye64PZg4bnzuzTwctt3OYZ5ifF8+xed?=
 =?us-ascii?Q?VYJBddsnnuGfAWjvn2zsUxsGZKHJjGHRVvLoyhmZ6CnBvwZLONPlX503z9QU?=
 =?us-ascii?Q?4ZPSkGH6W/nDMOULrYVVzFPcVASUCTN1iNpYsSuLUFKU2RyXqwhCj4+dNY1S?=
 =?us-ascii?Q?xkgu+uw9cznp3mD0M/GEq67nf7EMKTiRlSWgXcPrUKCTmRISa6hJcvUZphHn?=
 =?us-ascii?Q?K3OkJeiOOB/pVTnAYc8ZnJYLapQR8AFyDmCkT5WkqqmMfhRN/NVm0HfMNldd?=
 =?us-ascii?Q?TTvUFIaC8451dz2c/Y4Yondemwp63YinBd1lHsh6LZbRRzaGSbZoKUlXRxO2?=
 =?us-ascii?Q?+uhqKQoIW0iJSltLp9hXofQM1k95tL9iTVswQjkf3rtfJswH0gL5rlZS/0Bg?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fc494198-86ea-4a14-3e42-08daccd8b986
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 22:27:22.5039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lSaP2BoXoTEUhfDdqSmgB6/IB4c5cjHFKZ9bLNGPrl4kn3evkxLtRRPg+cdubd+HlKnfKqM1S0Hj+VOyQhyNvSb4DSRgL6Et1dpAV8sPADA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5708
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 10:44:12PM +0100, Horatiu Vultur wrote:
> Extend lan966x XDP support with the action XDP_TX. In this case when the
> received buffer needs to execute XDP_TX, the buffer will be moved to the
> TX buffers. So a new RX buffer will be allocated.
> When the TX finish with the frame, it would give back the buffer to the
> page pool.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../ethernet/microchip/lan966x/lan966x_fdma.c | 78 +++++++++++++++++--
>  .../ethernet/microchip/lan966x/lan966x_main.c |  4 +-
>  .../ethernet/microchip/lan966x/lan966x_main.h |  8 ++
>  .../ethernet/microchip/lan966x/lan966x_xdp.c  |  8 ++
>  4 files changed, 90 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> index f8287a6a86ed5..23e1cad0f5d37 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> @@ -411,12 +411,18 @@ static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
>  		dcb_buf->dev->stats.tx_bytes += dcb_buf->len;
>  
>  		dcb_buf->used = false;
> -		dma_unmap_single(lan966x->dev,
> -				 dcb_buf->dma_addr,
> -				 dcb_buf->len,
> -				 DMA_TO_DEVICE);
> -		if (!dcb_buf->ptp)
> -			dev_kfree_skb_any(dcb_buf->skb);
> +		if (dcb_buf->skb) {
> +			dma_unmap_single(lan966x->dev,
> +					 dcb_buf->dma_addr,
> +					 dcb_buf->len,
> +					 DMA_TO_DEVICE);
> +
> +			if (!dcb_buf->ptp)
> +				napi_consume_skb(dcb_buf->skb, weight);
> +		}
> +
> +		if (dcb_buf->xdpf)
> +			xdp_return_frame_rx_napi(dcb_buf->xdpf);
>  
>  		clear = true;
>  	}
> @@ -549,6 +555,9 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
>  			lan966x_fdma_rx_free_page(rx);
>  			lan966x_fdma_rx_advance_dcb(rx);
>  			goto allocate_new;
> +		case FDMA_TX:
> +			lan966x_fdma_rx_advance_dcb(rx);
> +			continue;
>  		case FDMA_DROP:
>  			lan966x_fdma_rx_free_page(rx);
>  			lan966x_fdma_rx_advance_dcb(rx);
> @@ -670,6 +679,62 @@ static void lan966x_fdma_tx_start(struct lan966x_tx *tx, int next_to_use)
>  	tx->last_in_use = next_to_use;
>  }
>  
> +int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
> +			   struct xdp_frame *xdpf,
> +			   struct page *page)
> +{
> +	struct lan966x *lan966x = port->lan966x;
> +	struct lan966x_tx_dcb_buf *next_dcb_buf;
> +	struct lan966x_tx *tx = &lan966x->tx;
> +	dma_addr_t dma_addr;
> +	int next_to_use;
> +	__be32 *ifh;
> +	int ret = 0;
> +
> +	spin_lock(&lan966x->tx_lock);
> +
> +	/* Get next index */
> +	next_to_use = lan966x_fdma_get_next_dcb(tx);
> +	if (next_to_use < 0) {
> +		netif_stop_queue(port->dev);
> +		ret = NETDEV_TX_BUSY;
> +		goto out;
> +	}
> +
> +	/* Generate new IFH */
> +	ifh = page_address(page) + XDP_PACKET_HEADROOM;
> +	memset(ifh, 0x0, sizeof(__be32) * IFH_LEN);
> +	lan966x_ifh_set_bypass(ifh, 1);
> +	lan966x_ifh_set_port(ifh, BIT_ULL(port->chip_port));
> +
> +	dma_addr = page_pool_get_dma_addr(page);
> +	dma_sync_single_for_device(lan966x->dev, dma_addr + XDP_PACKET_HEADROOM,
> +				   xdpf->len + IFH_LEN_BYTES,
> +				   DMA_TO_DEVICE);
> +
> +	/* Setup next dcb */
> +	lan966x_fdma_tx_setup_dcb(tx, next_to_use, xdpf->len + IFH_LEN_BYTES,
> +				  dma_addr + XDP_PACKET_HEADROOM);
> +
> +	/* Fill up the buffer */
> +	next_dcb_buf = &tx->dcbs_buf[next_to_use];
> +	next_dcb_buf->skb = NULL;
> +	next_dcb_buf->xdpf = xdpf;
> +	next_dcb_buf->len = xdpf->len + IFH_LEN_BYTES;
> +	next_dcb_buf->dma_addr = dma_addr;
> +	next_dcb_buf->used = true;
> +	next_dcb_buf->ptp = false;
> +	next_dcb_buf->dev = port->dev;
> +
> +	/* Start the transmission */
> +	lan966x_fdma_tx_start(tx, next_to_use);
> +
> +out:
> +	spin_unlock(&lan966x->tx_lock);
> +
> +	return ret;
> +}
> +
>  int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
>  {
>  	struct lan966x_port *port = netdev_priv(dev);
> @@ -726,6 +791,7 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
>  	/* Fill up the buffer */
>  	next_dcb_buf = &tx->dcbs_buf[next_to_use];
>  	next_dcb_buf->skb = skb;
> +	next_dcb_buf->xdpf = NULL;
>  	next_dcb_buf->len = skb->len;
>  	next_dcb_buf->dma_addr = dma_addr;
>  	next_dcb_buf->used = true;
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> index 42be5d0f1f015..0b7707306da26 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> @@ -302,13 +302,13 @@ static int lan966x_port_ifh_xmit(struct sk_buff *skb,
>  	return NETDEV_TX_BUSY;
>  }
>  
> -static void lan966x_ifh_set_bypass(void *ifh, u64 bypass)
> +void lan966x_ifh_set_bypass(void *ifh, u64 bypass)
>  {
>  	packing(ifh, &bypass, IFH_POS_BYPASS + IFH_WID_BYPASS - 1,
>  		IFH_POS_BYPASS, IFH_LEN * 4, PACK, 0);
>  }
>  
> -static void lan966x_ifh_set_port(void *ifh, u64 bypass)
> +void lan966x_ifh_set_port(void *ifh, u64 bypass)
>  {
>  	packing(ifh, &bypass, IFH_POS_DSTS + IFH_WID_DSTS - 1,
>  		IFH_POS_DSTS, IFH_LEN * 4, PACK, 0);
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> index 81c0b11097ce2..ce8b2eb13a9aa 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> @@ -105,11 +105,13 @@ enum macaccess_entry_type {
>   * FDMA_PASS, frame is valid and can be used
>   * FDMA_ERROR, something went wrong, stop getting more frames
>   * FDMA_DROP, frame is dropped, but continue to get more frames
> + * FDMA_TX, frame is given to TX, but continue to get more frames
>   */
>  enum lan966x_fdma_action {
>  	FDMA_PASS = 0,
>  	FDMA_ERROR,
>  	FDMA_DROP,
> +	FDMA_TX,
>  };
>  
>  struct lan966x_port;
> @@ -176,6 +178,7 @@ struct lan966x_tx_dcb_buf {
>  	dma_addr_t dma_addr;
>  	struct net_device *dev;
>  	struct sk_buff *skb;
> +	struct xdp_frame *xdpf;

Couldn't you make an union out of skb and xdpf? I'd say these two are
mutually exclusive, no? I believe this would simplify some things.

>  	u32 len;
>  	u32 used : 1;
>  	u32 ptp : 1;
> @@ -360,6 +363,8 @@ bool lan966x_hw_offload(struct lan966x *lan966x, u32 port, struct sk_buff *skb);
>  
>  void lan966x_ifh_get_src_port(void *ifh, u64 *src_port);
>  void lan966x_ifh_get_timestamp(void *ifh, u64 *timestamp);
> +void lan966x_ifh_set_bypass(void *ifh, u64 bypass);
> +void lan966x_ifh_set_port(void *ifh, u64 bypass);
>  
>  void lan966x_stats_get(struct net_device *dev,
>  		       struct rtnl_link_stats64 *stats);
> @@ -460,6 +465,9 @@ u32 lan966x_ptp_get_period_ps(void);
>  int lan966x_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
>  
>  int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev);
> +int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
> +			   struct xdp_frame *frame,
> +			   struct page *page);
>  int lan966x_fdma_change_mtu(struct lan966x *lan966x);
>  void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev);
>  void lan966x_fdma_netdev_deinit(struct lan966x *lan966x, struct net_device *dev);
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> index a99657154cca4..e7998fef7048c 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> @@ -54,6 +54,7 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
>  {
>  	struct bpf_prog *xdp_prog = port->xdp_prog;
>  	struct lan966x *lan966x = port->lan966x;
> +	struct xdp_frame *xdpf;
>  	struct xdp_buff xdp;
>  	u32 act;
>  
> @@ -66,6 +67,13 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
>  	switch (act) {
>  	case XDP_PASS:
>  		return FDMA_PASS;
> +	case XDP_TX:
> +		xdpf = xdp_convert_buff_to_frame(&xdp);
> +		if (!xdpf)
> +			return FDMA_DROP;

I would generally challenge the need for xdp_frame in XDP_TX path. You
probably would be good to go with calling directly
page_pool_put_full_page() on cleaning side. This frame is not going to be
redirected so I don't see the need for carrying additional info. I'm
bringing this up as I was observing performance improvement on ice driver
when I decided to operate directly on xdp_buff for XDP_TX.

But it's of course up to you.

> +
> +		return lan966x_fdma_xmit_xdpf(port, xdpf, page) ?
> +		       FDMA_DROP : FDMA_TX;
>  	default:
>  		bpf_warn_invalid_xdp_action(port->dev, xdp_prog, act);
>  		fallthrough;
> -- 
> 2.38.0
> 
