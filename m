Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F412C628228
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 15:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236602AbiKNOQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 09:16:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiKNOQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 09:16:50 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EED24F19;
        Mon, 14 Nov 2022 06:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668435409; x=1699971409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VWZRwieL0MnAqoIr5PqiCwKsEkjOEOCAdig3LNLeXLs=;
  b=JInJL6fHxfszv6AIfgcM+yVBL9NrJyJD+ELjabrUwctUT9YV94hK4jjG
   rdmT+DShEDCxc+h9i8OZ6mLtCaN/FzKYKuOX/lvnr2qjKA1Qm2JId0LSe
   TV6uNGY4fGQF41iuoln8BR3gICXAXKfYJAG8O0I7ZVTzfPpDHUqrYVPSI
   Pcxks7ISMZD96XBLVSICsHfzzKwQZsdregvV1xRlokcY/cJ4JU2E4VAqV
   V4GFdX9VpJrNNxPuZiDKkU8uxhsthrdahxNB4+qN3LcDpqMvVKRaBk+SR
   6Snen+Vx1EWoq0musqDu/W7iZQybhlTmeZAg9cj2yC0mMTbb9My9GKrRl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="299494588"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="299494588"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 06:16:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="671573894"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="671573894"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 14 Nov 2022 06:16:46 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AEEGiQ8012563;
        Mon, 14 Nov 2022 14:16:44 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/5] net: lan966x: Add XDP_PACKET_HEADROOM
Date:   Mon, 14 Nov 2022 15:16:33 +0100
Message-Id: <20221114141633.699268-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221113111559.1028030-2-horatiu.vultur@microchip.com>
References: <20221113111559.1028030-1-horatiu.vultur@microchip.com> <20221113111559.1028030-2-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Sun, 13 Nov 2022 12:15:55 +0100

> Update the page_pool params to allocate XDP_PACKET_HEADROOM space as
> headroom for all received frames.
> This is needed for when the XDP_TX and XDP_REDIRECT are implemented.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---

[...]

> @@ -466,7 +472,8 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
>  
>  	skb_mark_for_recycle(skb);
>  
> -	skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status));
> +	skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status) + XDP_PACKET_HEADROOM);
> +	skb_pull(skb, XDP_PACKET_HEADROOM);

These two must be:

+	skb_reserve(skb, XDP_PACKET_HEADROOM);
 	skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status));

i.e. you only need to add reserve, and that's it. It's not only
faster, but also moves ::tail, which is essential.

>  
>  	lan966x_ifh_get_timestamp(skb->data, &timestamp);
>  

[...]

> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> @@ -44,8 +44,9 @@ int lan966x_xdp_run(struct lan966x_port *port, struct page *page, u32 data_len)
>  
>  	xdp_init_buff(&xdp, PAGE_SIZE << lan966x->rx.page_order,
>  		      &port->xdp_rxq);
> -	xdp_prepare_buff(&xdp, page_address(page), IFH_LEN_BYTES,
> -			 data_len - IFH_LEN_BYTES, false);
> +	xdp_prepare_buff(&xdp, page_address(page),
> +			 IFH_LEN_BYTES + XDP_PACKET_HEADROOM,
> +			 data_len - IFH_LEN_BYTES - XDP_PACKET_HEADROOM, false);

Are you sure you need to substract %XDP_PACKET_HEADROOM from
@data_len? I think @data_len is the frame length, so headroom is not
included?

>  	act = bpf_prog_run_xdp(xdp_prog, &xdp);
>  	switch (act) {
>  	case XDP_PASS:
> -- 
> 2.38.0

Thanks,
Olek
