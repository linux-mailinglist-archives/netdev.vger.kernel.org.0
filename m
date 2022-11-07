Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA26461F87F
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 17:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbiKGQKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 11:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbiKGQKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 11:10:08 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3DD254;
        Mon,  7 Nov 2022 08:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667837407; x=1699373407;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dl263rkNBj8b48IYJwzfP0ZueC9N+UN8KkOTivjUsv0=;
  b=Y/E+o6Zs/Y5aT2IrnIP/RRA+iG4kl4tU7J3eti4oMvZlHzY3e/8NAFGa
   wP+5O22bqEEQIWCBuwHHo/y6jAEO4O4ESWjScjKVoR4rJNyt9dEHyEZAO
   DXbACuaYr9nQnOhrnaq2fo9E4q5r1TD4BwzXrf+ScOaxZZImWTqM1GP/I
   89hmk4eLyjoZpsvxMTdEtY9ylNGJZThcOGZfzB7XGQCNt+fHnkOREk75+
   Nau8oWVlN0mTLaZB9tGuXT8yB4a3a4JJ+9VoWrbvbpHgOQlaiKFDhQUHH
   62HuD3KAYzJyRffW5RKC5JMUFob0W8n3/JvBitpVNmA/RnkwWaOfGwGWw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="290172341"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="290172341"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 08:10:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="699527391"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="699527391"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 07 Nov 2022 08:10:02 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2A7GA1Zg020372;
        Mon, 7 Nov 2022 16:10:01 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next v2 2/4] net: lan966x: Split function lan966x_fdma_rx_get_frame
Date:   Mon,  7 Nov 2022 17:06:56 +0100
Message-Id: <20221107160656.556195-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221106211154.3225784-3-horatiu.vultur@microchip.com>
References: <20221106211154.3225784-1-horatiu.vultur@microchip.com> <20221106211154.3225784-3-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Sun, 6 Nov 2022 22:11:52 +0100

> The function lan966x_fdma_rx_get_frame was unmapping the frame from
> device and check also if the frame was received on a valid port. And
> only after that it tried to generate the skb.
> Move this check in a different function, in preparation for xdp
> support. Such that xdp to be added here and the
> lan966x_fdma_rx_get_frame to be used only when giving the skb to upper
> layers.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../ethernet/microchip/lan966x/lan966x_fdma.c | 85 +++++++++++++------
>  .../ethernet/microchip/lan966x/lan966x_main.h |  9 ++
>  2 files changed, 69 insertions(+), 25 deletions(-)

[...]

> -static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx)
> +static int lan966x_fdma_rx_check_frame(struct lan966x_rx *rx, u64 *src_port)
>  {
>  	struct lan966x *lan966x = rx->lan966x;
> -	u64 src_port, timestamp;
>  	struct lan966x_db *db;
> -	struct sk_buff *skb;
>  	struct page *page;
>  
> -	/* Get the received frame and unmap it */
>  	db = &rx->dcbs[rx->dcb_index].db[rx->db_index];
>  	page = rx->page[rx->dcb_index][rx->db_index];
> +	if (unlikely(!page))
> +		return FDMA_ERROR;
>  
>  	dma_sync_single_for_cpu(lan966x->dev, (dma_addr_t)db->dataptr,
>  				FDMA_DCB_STATUS_BLOCKL(db->status),
>  				DMA_FROM_DEVICE);
>  
> +	dma_unmap_single_attrs(lan966x->dev, (dma_addr_t)db->dataptr,
> +			       PAGE_SIZE << rx->page_order, DMA_FROM_DEVICE,
> +			       DMA_ATTR_SKIP_CPU_SYNC);
> +
> +	lan966x_ifh_get_src_port(page_address(page), src_port);
> +	if (WARN_ON(*src_port >= lan966x->num_phys_ports))
> +		return FDMA_ERROR;
> +
> +	return FDMA_PASS;

How about making this function return s64, which would be "src_port
or negative error", and dropping the second argument @src_port (the
example of calling it below)?

> +}
> +
> +static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
> +						 u64 src_port)
> +{

[...]

> -		skb = lan966x_fdma_rx_get_frame(rx);
> +		counter++;
>  
> -		rx->page[rx->dcb_index][rx->db_index] = NULL;
> -		rx->dcb_index++;
> -		rx->dcb_index &= FDMA_DCB_MAX - 1;
> +		switch (lan966x_fdma_rx_check_frame(rx, &src_port)) {
> +		case FDMA_PASS:
> +			break;
> +		case FDMA_ERROR:
> +			lan966x_fdma_rx_free_page(rx);
> +			lan966x_fdma_rx_advance_dcb(rx);
> +			goto allocate_new;
> +		}

So, here you could do (if you want to keep the current flow)::

		src_port = lan966x_fdma_rx_check_frame(rx);
		switch (src_port) {
		case 0 .. S64_MAX: // for example
			break;
		case FDMA_ERROR:   // must be < 0
			lan_966x_fdma_rx_free_page(rx);
			...
		}

But given that the error path is very unlikely and cold, I would
prefer if-else over switch case:

		src_port = lan966x_fdma_rx_check_frame(rx);
		if (unlikely(src_port < 0)) {
			lan_966x_fdma_rx_free_page(rx);
			...
			goto allocate_new;
		}

>  
> +		skb = lan966x_fdma_rx_get_frame(rx, src_port);
> +		lan966x_fdma_rx_advance_dcb(rx);
>  		if (!skb)
> -			break;
> +			goto allocate_new;
>  
>  		napi_gro_receive(&lan966x->napi, skb);
> -		counter++;
>  	}
>  
> +allocate_new:
>  	/* Allocate new pages and map them */
>  	while (dcb_reload != rx->dcb_index) {
>  		db = &rx->dcbs[dcb_reload].db[rx->db_index];
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> index 4ec33999e4df6..464fb5e4a8ff6 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> @@ -100,6 +100,15 @@ enum macaccess_entry_type {
>  	ENTRYTYPE_MACV6,
>  };
>  
> +/* FDMA return action codes for checking if the frame is valid
> + * FDMA_PASS, frame is valid and can be used
> + * FDMA_ERROR, something went wrong, stop getting more frames
> + */
> +enum lan966x_fdma_action {
> +	FDMA_PASS = 0,
> +	FDMA_ERROR,
> +};
> +
>  struct lan966x_port;
>  
>  struct lan966x_db {
> -- 
> 2.38.0

Thanks,
Olek
