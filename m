Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B346506FFE
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 16:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241372AbiDSOXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 10:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353181AbiDSOWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 10:22:17 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8140013CDB;
        Tue, 19 Apr 2022 07:19:33 -0700 (PDT)
Received: from [192.168.0.7] (ip5f5ae90d.dynamic.kabel-deutschland.de [95.90.233.13])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7D81461CCD785;
        Tue, 19 Apr 2022 16:19:30 +0200 (CEST)
Message-ID: <b9804c40-3402-1dac-a9c0-db37a5360015@molgen.mpg.de>
Date:   Tue, 19 Apr 2022 16:19:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [Intel-wired-lan] [PATCH 2/2] Trigger proper interrupts in
 igc_xsk_wakeup
Content-Language: en-US
To:     Jeff Evanson <jeff.evanson@gmail.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeff.evanson@qsc.com
References: <20220415210546.11294-1-jeff.evanson@qsc.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220415210546.11294-1-jeff.evanson@qsc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jeff,


Thank you for your patch.


Am 15.04.22 um 23:05 schrieb Jeff Evanson:

1.  Add a From tag(?), so your company instead of gmail.com email is used?
2.  Please add a prefix to the commit message summary. See `git log 
--oneline drivers/net/ethernet/igc` for examples.

> in igc_xsk_wakeup, trigger the proper interrupt based on whether flags
> contains XDP_WAKEUP_RX and/or XDP_WAKEUP_TX

Nit. Please add a dot/period to the end of sentences.

Can you please add a paragraph on what system you experienced the 
problem, and how to verify your fix?

> Signed-off-by: Jeff Evanson <jeff.evanson@qsc.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_main.c | 36 +++++++++++++++++------
>   1 file changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index a36a18c84aeb..d706de95dc06 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -6073,7 +6073,7 @@ static void igc_trigger_rxtxq_interrupt(struct igc_adapter *adapter,
>   int igc_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
>   {
>   	struct igc_adapter *adapter = netdev_priv(dev);
> -	struct igc_q_vector *q_vector;
> +	struct igc_q_vector *txq_vector = 0, *rxq_vector = 0;

Should you use NULL instead of 0?


Kind regards,

Paul


>   	struct igc_ring *ring;
>   
>   	if (test_bit(__IGC_DOWN, &adapter->state))
> @@ -6082,17 +6082,35 @@ int igc_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
>   	if (!igc_xdp_is_enabled(adapter))
>   		return -ENXIO;
>   
> -	if (queue_id >= adapter->num_rx_queues)
> -		return -EINVAL;
> +	if (flags & XDP_WAKEUP_RX) {
> +		if (queue_id >= adapter->num_rx_queues)
> +			return -EINVAL;
>   
> -	ring = adapter->rx_ring[queue_id];
> +		ring = adapter->rx_ring[queue_id];
> +		if (!ring->xsk_pool)
> +			return -ENXIO;
>   
> -	if (!ring->xsk_pool)
> -		return -ENXIO;
> +		rxq_vector = ring->q_vector;
> +	}
> +
> +	if (flags & XDP_WAKEUP_TX) {
> +		if (queue_id >= adapter->num_tx_queues)
> +			return -EINVAL;
> +
> +		ring = adapter->tx_ring[queue_id];
> +		if (!ring->xsk_pool)
> +			return -ENXIO;
> +
> +		txq_vector = ring->q_vector;
> +	}
> +
> +	if (rxq_vector &&
> +	    !napi_if_scheduled_mark_missed(&rxq_vector->napi))
> +		igc_trigger_rxtxq_interrupt(adapter, rxq_vector);
>   
> -	q_vector = adapter->q_vector[queue_id];
> -	if (!napi_if_scheduled_mark_missed(&q_vector->napi))
> -		igc_trigger_rxtxq_interrupt(adapter, q_vector);
> +	if (txq_vector && txq_vector != rxq_vector &&
> +	    !napi_if_scheduled_mark_missed(&txq_vector->napi))
> +		igc_trigger_rxtxq_interrupt(adapter, txq_vector);
>   
>   	return 0;
>   }
