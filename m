Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D745633C04
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 13:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbiKVMEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 07:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbiKVMEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 07:04:44 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4E9DFA0;
        Tue, 22 Nov 2022 04:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669118684; x=1700654684;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xXOIRoWcqoS8ZJRdI+BWXomNeXdYk9vkQVnJJZI58wo=;
  b=eDRTCtUPgM3oHmkFJ9oozNUOG0kfbGHyw4nByX4RIlzLM1xcU78w0wzK
   HJ4+Cl+R7v1d1hSu8FkIoeAolEBD/ZhNtHfO1K4b6oKn+LBumVVqRIzWL
   T/E9rnvD59p0JJQDEVsUQSKd8MfpITuxiHvuRVOGTO+AHKvGHoZxsm3Rt
   tvdATN4ibTqW3XOAmXV21OPdlXxF/P4FKmPmrZoGbc5HMjU42W/fsbzcs
   YmXO7Edv+W6ywBmW3784NfUX8NQLKWwNKgGzFB6nZ69xmOSApzu0wDpJh
   aIUiCY47YZlBmvHAO+MOr5lO5PqEKIPaMnZdG/pLmlTCOwppawo4Hpu0Y
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="313828788"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="313828788"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 04:04:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="730371133"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="730371133"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Nov 2022 04:04:41 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AMC4dJ6007708;
        Tue, 22 Nov 2022 12:04:39 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v3 7/7] net: lan966x: Add support for XDP_REDIRECT
Date:   Tue, 22 Nov 2022 13:04:30 +0100
Message-Id: <20221122120430.419770-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121212850.3212649-8-horatiu.vultur@microchip.com>
References: <20221121212850.3212649-1-horatiu.vultur@microchip.com> <20221121212850.3212649-8-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Mon, 21 Nov 2022 22:28:50 +0100

> Extend lan966x XDP support with the action XDP_REDIRECT. This is similar
> with the XDP_TX, so a lot of functionality can be reused.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../ethernet/microchip/lan966x/lan966x_fdma.c | 83 +++++++++++++++----
>  .../ethernet/microchip/lan966x/lan966x_main.c |  1 +
>  .../ethernet/microchip/lan966x/lan966x_main.h | 10 ++-
>  .../ethernet/microchip/lan966x/lan966x_xdp.c  | 31 ++++++-
>  4 files changed, 109 insertions(+), 16 deletions(-)

[...]

> @@ -558,6 +575,10 @@ static int lan966x_fdma_napi_poll(struct napi_struct *napi, int weight)
>  		case FDMA_TX:
>  			lan966x_fdma_rx_advance_dcb(rx);
>  			continue;
> +		case FDMA_REDIRECT:
> +			lan966x_fdma_rx_advance_dcb(rx);
> +			redirect = true;
> +			continue;

I think you can save a couple lines here and avoid small code dup:

+		case FDMA_REDIRECT:
+			redirect = true;
+			fallthrough;
 		case FDMA_TX:
 			lan966x_fdma_rx_advance_dcb(rx);
 			continue;

The logics stays the same.

>  		case FDMA_DROP:
>  			lan966x_fdma_rx_free_page(rx);
>  			lan966x_fdma_rx_advance_dcb(rx);

[...]

> @@ -178,6 +180,7 @@ struct lan966x_tx_dcb_buf {
>  	struct net_device *dev;
>  	struct sk_buff *skb;
>  	struct xdp_frame *xdpf;
> +	bool xdp_ndo;

I suggest carefully inspecting this struct with pahole (or by just
printkaying its layout/sizes/offsets at runtime) and see if there's
any holes and how it could be optimized.
Also, it's just my personal preference, but it's not that unpopular:
I don't trust bools inside structures as they may surprise with
their sizes or alignment depending on the architercture. Considering
all the blah I wrote, I'd define it as:

struct lan966x_tx_dcb_buf {
	dma_addr_t dma_addr;		// can be 8 bytes on 32-bit plat
	struct net_device *dev;		// ensure natural alignment
	struct sk_buff *skb;
	struct xdp_frame *xdpf;
	u32 len;
	u32 xdp_ndo:1;			// put all your booleans here in
	u32 used:1;			// one u32
	...
};

BTW, we usually do union { skb, xdpf } since they're mutually
exclusive. And to distinguish between XDP and regular Tx you can use
one more bit/bool. This can also come handy later when you add XSk
support (you will be adding it, right? Please :P).

>  	int len;
>  	dma_addr_t dma_addr;
>  	bool used;

[...]

> -- 
> 2.38.0

Thanks,
Olek
