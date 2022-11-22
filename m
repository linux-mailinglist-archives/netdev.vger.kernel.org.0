Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87D3633B99
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbiKVLmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbiKVLlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:41:52 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A3015FE9;
        Tue, 22 Nov 2022 03:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669117150; x=1700653150;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q88Eu4PK7R3MLGJthijzTE5pAxdoXj6Hqb2J6jRm7T4=;
  b=A90p6j67BeXKtFGWt72zk0027CDdanMCtEn0vKF96QqC4tZNZ8VUII7E
   +Qd11wR3hQhBfogdsqdw4p/5jAjwBEQjRtKDJy2xopNRmUPR36O4laUp8
   VcMEfCHDMpnsFZX4RZlzftqredB5vRgcQ7LUiGRTSFgMtVK3GnJ90PPoM
   23CbcTTaMKstMFA+nAMJM4CNc4HLlj1KJ55Xus1mMHvJG0JBZLJsQdlXo
   k1jR0FE8MbBm/UfjsP2JyyaL1rx4IJGzMBH5qCy7eD1DE7yxb+mzHPjab
   dJ+VNTYvzgmZwDW+ae7dyzdYWHXHVY2hhQHI6i/AP67kmAdMvSeqV/Pc+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="314944044"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="314944044"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 03:39:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="730366358"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="730366358"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Nov 2022 03:39:06 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AMBd5vt002861;
        Tue, 22 Nov 2022 11:39:05 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v3 4/7] net: lan966x: Update rxq memory model
Date:   Tue, 22 Nov 2022 12:38:51 +0100
Message-Id: <20221122113851.418993-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121212850.3212649-5-horatiu.vultur@microchip.com>
References: <20221121212850.3212649-1-horatiu.vultur@microchip.com> <20221121212850.3212649-5-horatiu.vultur@microchip.com>
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
Date: Mon, 21 Nov 2022 22:28:47 +0100

> By default the rxq memory model is MEM_TYPE_PAGE_SHARED but to be able
> to reuse pages on the TX side, when the XDP action XDP_TX it is required
> to update the memory model to PAGE_POOL.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../net/ethernet/microchip/lan966x/lan966x_fdma.c  | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> index 384ed34197d58..483d1470c8362 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> @@ -78,8 +78,22 @@ static int lan966x_fdma_rx_alloc_page_pool(struct lan966x_rx *rx)
>  		.max_len = rx->max_mtu -
>  			   SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
>  	};
> +	struct lan966x_port *port;
> +	int i;
>  
>  	rx->page_pool = page_pool_create(&pp_params);
> +
> +	for (i = 0; i < lan966x->num_phys_ports; ++i) {
> +		if (!lan966x->ports[i])
> +			continue;
> +
> +		port = lan966x->ports[i];
> +
> +		xdp_rxq_info_unreg_mem_model(&port->xdp_rxq);

xdp_rxq_info_unreg_mem_model() can emit a splat if currently the
corresponding xdp_rxq_info is not registered[0]. Can't we face it
here if called from lan966x_fdma_init()?

> +		xdp_rxq_info_reg_mem_model(&port->xdp_rxq, MEM_TYPE_PAGE_POOL,
> +					   rx->page_pool);
> +	}
> +
>  	return PTR_ERR_OR_ZERO(rx->page_pool);
>  }
>  
> -- 
> 2.38.0

Thanks,
Olek
