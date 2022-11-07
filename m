Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F092561FA33
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 17:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiKGQoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 11:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbiKGQoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 11:44:18 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD7060C4;
        Mon,  7 Nov 2022 08:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667839458; x=1699375458;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vZZdcHv/04FUUUKqdZzjA0YQXyvdSkeYVYqoU/XlkcU=;
  b=ifTyBnBX6bjnpV1OJmEI6Jqt2npGHYn9EIHSMlrii/8e65btcR5HceSM
   7jWTd0KQYbMjZKjCugrod1JeevQAa1NVxztJW9uHr0cWc1JYYFmblVcbO
   rDo+IlVnJaoe2rKXCDaMgJXHwciaZ0cHU4qj3OY7jHYRe4M/6UMnSIt+L
   pgQZwWYgnbifImfI+XXlKpbXcvuQGUsrTK9xIUv7Dx2oprDDh4uSSFW1M
   VVV89O/MhklJZAPx1h+GoC6DrZJqDZeOPhGoB1hOtUBJn2wIcjNSxFc8p
   lRwfEl01SoGGBoj7oRi08Ot6z+HBDxF8JWmKjgN6vkIak185i2zBSSO3r
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="372580795"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="372580795"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 08:43:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="881137991"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="881137991"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 07 Nov 2022 08:43:54 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2A7GhqsW027365;
        Mon, 7 Nov 2022 16:43:53 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next v2 4/4] net: lan96x: Use page_pool API
Date:   Mon,  7 Nov 2022 17:40:55 +0100
Message-Id: <20221107164056.557894-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221106211154.3225784-5-horatiu.vultur@microchip.com>
References: <20221106211154.3225784-1-horatiu.vultur@microchip.com> <20221106211154.3225784-5-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Sun, 6 Nov 2022 22:11:54 +0100

> Use the page_pool API for allocation, freeing and DMA handling instead
> of dev_alloc_pages, __free_pages and dma_map_page.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../net/ethernet/microchip/lan966x/Kconfig    |  1 +
>  .../ethernet/microchip/lan966x/lan966x_fdma.c | 72 ++++++++++---------
>  .../ethernet/microchip/lan966x/lan966x_main.h |  3 +
>  3 files changed, 43 insertions(+), 33 deletions(-)

[...]

> @@ -84,6 +62,27 @@ static void lan966x_fdma_rx_add_dcb(struct lan966x_rx *rx,
>  	rx->last_entry = dcb;
>  }
>  
> +static int lan966x_fdma_rx_alloc_page_pool(struct lan966x_rx *rx)
> +{
> +	struct lan966x *lan966x = rx->lan966x;
> +	struct page_pool_params pp_params = {
> +		.order = rx->page_order,
> +		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> +		.pool_size = FDMA_DCB_MAX,
> +		.nid = NUMA_NO_NODE,
> +		.dev = lan966x->dev,
> +		.dma_dir = DMA_FROM_DEVICE,
> +		.offset = 0,
> +		.max_len = PAGE_SIZE << rx->page_order,

::max_len's primary purpose is to save time on DMA syncs.
First of all, you can substract
`SKB_DATA_ALIGN(sizeof(struct skb_shared_info))`, your HW never
writes to those last couple hundred bytes.
But I suggest calculating ::max_len basing on your current MTU
value. Let's say you have 16k pages and MTU of 1500, that is a huge
difference (except your DMA is always coherent, but I assume that's
not the case).

In lan966x_fdma_change_mtu() you do:

	max_mtu = lan966x_fdma_get_max_mtu(lan966x);
	max_mtu += IFH_LEN_BYTES;
	max_mtu += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
	max_mtu += VLAN_HLEN * 2;

`lan966x_fdma_get_max_mtu(lan966x) + IFH_LEN_BYTES + VLAN_HLEN * 2`
(ie 1536 for the MTU of 1500) is your max_len value actually, given
that you don't reserve any headroom (which is unfortunate, but I
guess you're working on this already, since XDP requires
%XDP_PACKET_HEADROOM).

> +	};
> +
> +	rx->page_pool = page_pool_create(&pp_params);
> +	if (IS_ERR(rx->page_pool))
> +		return PTR_ERR(rx->page_pool);
> +
> +	return 0;

	return PTR_ERR_OR_ZERO(rx->page_pool);

> +}
> +
>  static int lan966x_fdma_rx_alloc(struct lan966x_rx *rx)
>  {
>  	struct lan966x *lan966x = rx->lan966x;

[...]

> -- 
> 2.38.0

Thanks,
Olek
