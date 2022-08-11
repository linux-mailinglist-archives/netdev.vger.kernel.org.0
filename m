Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E92D58F74A
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 07:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbiHKFf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 01:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbiHKFf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 01:35:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148871116D;
        Wed, 10 Aug 2022 22:35:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2A806117B;
        Thu, 11 Aug 2022 05:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF357C433C1;
        Thu, 11 Aug 2022 05:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660196125;
        bh=9cxQhldrF9v2L8GnWkwcor0z539jhUGWjh1BxFy61hU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rqgCRPoWqDws6xMtMlVdBewMSOjgJJBr5e7GYGX2EagKZ3s93OxEUeqdD+uNkRzY9
         qmPxfaV7oVX/e4NkJknzcFyiQPG6Vh5zA/mBZa0uBJPLJmfnqy0bEhfYB1jTx1xvm4
         UatWWkJmyyyCd4yy1wrXpiG8atYuNDL+pFtlI0n6avk161eUyiqiN12k/md8+5KxBG
         z35pep0Q/vWr055SwFHNemVS6EBw5w9mRAVLq+LA9PkHR8Wk8kil0n2qEe9aCH1IPN
         cOqFlKasfFjZPmp+nRiLgCouXcqJLZmNWwAh+uLJVSKmCUA1Mh+jFmkYCiKR0AoplD
         svMCFqGBsZm8g==
Date:   Wed, 10 Aug 2022 22:35:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next] net: lan743x: Fix the multi queue overflow
 issue
Message-ID: <20220810223523.426b5e22@kernel.org>
In-Reply-To: <20220809083628.650493-1-Raju.Lakkaraju@microchip.com>
References: <20220809083628.650493-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Aug 2022 14:06:28 +0530 Raju Lakkaraju wrote:
> Fix the Tx multi-queue overflow issue
> 
> Tx ring size of 128 (for TCP) provides ability to handle way more data than
> what Rx can (Rx buffers are constrained to one frame or even less during a
> dynamic mtu size change)
> 
> TX napi weight dependent of the ring size like it is now (ring size -1)
> because there is an express warning in the kernel about not registering weight
> values > NAPI_POLL_WEIGHT (currently 64)

I've read this message 3 times, I don't understand what you're saying.
Could you please rewrite it and add necessary details?

> diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> index a9a1dea6d731..d7c14ee7e413 100644
> --- a/drivers/net/ethernet/microchip/lan743x_main.c
> +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> @@ -2064,8 +2064,10 @@ static void lan743x_tx_frame_end(struct lan743x_tx *tx,
>  static netdev_tx_t lan743x_tx_xmit_frame(struct lan743x_tx *tx,
>  					 struct sk_buff *skb)
>  {
> +	struct lan743x_adapter *adapter = tx->adapter;
>  	int required_number_of_descriptors = 0;
>  	unsigned int start_frame_length = 0;
> +	netdev_tx_t retval = NETDEV_TX_OK;
>  	unsigned int frame_length = 0;
>  	unsigned int head_length = 0;
>  	unsigned long irq_flags = 0;
> @@ -2083,9 +2085,13 @@ static netdev_tx_t lan743x_tx_xmit_frame(struct lan743x_tx *tx,
>  		if (required_number_of_descriptors > (tx->ring_size - 1)) {
>  			dev_kfree_skb_irq(skb);
>  		} else {
> -			/* save to overflow buffer */
> -			tx->overflow_skb = skb;
> -			netif_stop_queue(tx->adapter->netdev);
> +			/* save how many descriptors we needed to restart the queue */
> +			tx->rqd_descriptors = required_number_of_descriptors;
> +			retval = NETDEV_TX_BUSY;
> +			if (is_pci11x1x_chip(adapter))
> +				netif_stop_subqueue(adapter->netdev, tx->channel_number);

Is tx->channel_number not 0 for devices other than pci11x1x ?
netif_stop_queue() is just an alias for queue 0 IIRC so
you can save all the ifs, most likely?

> +			else
> +				netif_stop_queue(adapter->netdev);
>  		}
>  		goto unlock;
>  	}
> @@ -2093,7 +2099,7 @@ static netdev_tx_t lan743x_tx_xmit_frame(struct lan743x_tx *tx,
>  	/* space available, transmit skb  */
>  	if ((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
>  	    (tx->ts_flags & TX_TS_FLAG_TIMESTAMPING_ENABLED) &&
> -	    (lan743x_ptp_request_tx_timestamp(tx->adapter))) {
> +	    (lan743x_ptp_request_tx_timestamp(adapter))) {

If this is a fix you should hold off on refactoring like adding the
local variable for adapter to make backports easier.

>  		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
>  		do_timestamp = true;
>  		if (tx->ts_flags & TX_TS_FLAG_ONE_STEP_SYNC)

> @@ -1110,7 +1109,7 @@ struct lan743x_tx_buffer_info {
>  	unsigned int    buffer_length;
>  };
>  
> -#define LAN743X_TX_RING_SIZE    (50)
> +#define LAN743X_TX_RING_SIZE    (128)

So the ring size is getting increased? I did not get that from the
commit message at all :S
