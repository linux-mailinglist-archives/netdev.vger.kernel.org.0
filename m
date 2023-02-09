Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A81168FFE3
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 06:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjBIFa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 00:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBIFa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 00:30:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C24F2DE77
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 21:30:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15AF8B81FAB
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 05:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26224C433D2;
        Thu,  9 Feb 2023 05:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675920620;
        bh=uWW9dWpkbiGcWrVSQm1mz+11j5Dg0e8H4KXyOQIpb8E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=snKZxoxFzmqJLrxK+Df3USmMOEjNd1Otm5Mnwg7ZQ/uuHalrZVMDA7DZIRnepDNhg
         /h4zPkgxOZMfk69OSUZUE3FbcfoxYVZouTqssqgAGcOtV38ow+x0AgcJheVdBMfcl+
         4XURkbBC2zYl8S9lV+KV35hv9erbwVqqLJm0mxRHS/aXQ1o0UDWWy6tQr1yMHPEk/h
         97P9v7czahrQTDrzj6QRCJAJ91p4j8PuXuzD7DkHinaNkVk22LWSGrv4nz/upPoO90
         TqiNSMlXDeKwpISgy/5QmuwCPQvYNXsXtx6UGevFIB9HRsBASRnrleGfc+F2tYg1ar
         yy3sEq0nonMng==
Date:   Wed, 8 Feb 2023 21:30:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Cc:     intel-wired-lan@osuosl.org, vinicius.gomes@intel.com,
        naamax.meir@linux.intel.com, anthony.l.nguyen@intel.com,
        leon@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tee.min.tan@linux.intel.com,
        netdev@vger.kernel.org, sasha.neftin@intel.com
Subject: Re: [PATCH net-next v3] igc: offload queue max SDU from tc-taprio
Message-ID: <20230208213019.460d7163@kernel.org>
In-Reply-To: <20230208003327.29538-1-muhammad.husaini.zulkifli@intel.com>
References: <20230208003327.29538-1-muhammad.husaini.zulkifli@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Feb 2023 08:33:27 +0800 Muhammad Husaini Zulkifli wrote:
> From: Tan Tee Min <tee.min.tan@linux.intel.com>
> 
> Add support for configuring the max SDU for each Tx queue.
> If not specified, keep the default.

> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 0cc327294dfb5..38ad437957ada 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -1508,6 +1508,7 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
>  	__le32 launch_time = 0;
>  	u32 tx_flags = 0;
>  	unsigned short f;
> +	u32 max_sdu = 0;

This variable can be moved to the scope of the if() ?

>  	ktime_t txtime;
>  	u8 hdr_len = 0;
>  	int tso = 0;
> @@ -1527,6 +1528,14 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
>  		return NETDEV_TX_BUSY;
>  	}
>  
> +	if (tx_ring->max_sdu > 0) {
> +		max_sdu = tx_ring->max_sdu +
> +			  (skb_vlan_tagged(skb) ? VLAN_HLEN : 0);
> +
> +		if (skb->len > max_sdu)

You should increment some counter here. Otherwise it's a silent discard.

> +			goto skb_drop;
> +	}
> +
>  	if (!tx_ring->launchtime_enable)
>  		goto done;
>  
> @@ -1606,6 +1615,11 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
>  	dev_kfree_skb_any(first->skb);

first->skb is skb, as far as I can tell, you can reshuffle this code to
avoid adding the new return flow.

>  	first->skb = NULL;
>  
> +	return NETDEV_TX_OK;
> +
> +skb_drop:
> +	dev_kfree_skb_any(skb);
> +
>  	return NETDEV_TX_OK;
>  }

> @@ -6122,6 +6137,16 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
>  		}
>  	}
>  
> +	for (i = 0; i < adapter->num_tx_queues; i++) {
> +		struct igc_ring *ring = adapter->tx_ring[i];
> +		struct net_device *dev = adapter->netdev;
> +
> +		if (qopt->max_sdu[i])
> +			ring->max_sdu = qopt->max_sdu[i] + dev->hard_header_len;

why hard_header_len? Isn't it always ETH_HLEN?

> +		else
> +			ring->max_sdu = 0;
