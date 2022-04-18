Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40E9505DA0
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 19:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347198AbiDRRrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 13:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241488AbiDRRr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 13:47:29 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4BF2DEC;
        Mon, 18 Apr 2022 10:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650303889; x=1681839889;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=D/Flz0ZSVs+oASuVLiQaVr825MaM3PoEU2QzN/vdta4=;
  b=gQ2i8eaLnvKMxOJrupKvZyeA458NpJICiXlhs16y0XvgygpiS/zxcdTN
   xaKfmVrmcxnkkenoFEWJUgJXztXQuHR2y7mLVyOBqDBMw0vVBpgp34z2Z
   aDzUEeqGnDWTcAns4VaKyVFQXkMG9+WeVpkbMgckFwYt1PfsOmfv+PDuL
   YMBbTAP+6lhjnuDtXwLX+knJWQyHIUcqplANucAiAMvK9RrM1UMHqf7cN
   42ESIs5uuG0rFshgonoazTmFZsqi3Ao92Jtc0f51I9GBlcnX9GILnDLyd
   vhwidiSpMAQ62bjqMrA9PYZa7RMTxohrD5gb72pKCQIX4e3oFRAWRyaak
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="288667288"
X-IronPort-AV: E=Sophos;i="5.90,270,1643702400"; 
   d="scan'208";a="288667288"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 10:44:37 -0700
X-IronPort-AV: E=Sophos;i="5.90,270,1643702400"; 
   d="scan'208";a="804372037"
Received: from alanadu-mobl2.amr.corp.intel.com (HELO vcostago-mobl3) ([10.251.2.172])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 10:44:36 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jeff Evanson <jeff.evanson@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     jeff.evanson@qsc.com, jeff.evanson@gmail.com
Subject: Re: [PATCH 2/2] Trigger proper interrupts in igc_xsk_wakeup
In-Reply-To: <20220415210546.11294-1-jeff.evanson@qsc.com>
References: <20220415210546.11294-1-jeff.evanson@qsc.com>
Date:   Mon, 18 Apr 2022 13:44:35 -0400
Message-ID: <87v8v6477g.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jeff Evanson <jeff.evanson@gmail.com> writes:

> in igc_xsk_wakeup, trigger the proper interrupt based on whether flags
> contains XDP_WAKEUP_RX and/or XDP_WAKEUP_TX
>
> Signed-off-by: Jeff Evanson <jeff.evanson@qsc.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_main.c | 36 +++++++++++++++++------
>  1 file changed, 27 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index a36a18c84aeb..d706de95dc06 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -6073,7 +6073,7 @@ static void igc_trigger_rxtxq_interrupt(struct igc_adapter *adapter,
>  int igc_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
>  {
>  	struct igc_adapter *adapter = netdev_priv(dev);
> -	struct igc_q_vector *q_vector;
> +	struct igc_q_vector *txq_vector = 0, *rxq_vector = 0;
>  	struct igc_ring *ring;
>  
>  	if (test_bit(__IGC_DOWN, &adapter->state))
> @@ -6082,17 +6082,35 @@ int igc_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
>  	if (!igc_xdp_is_enabled(adapter))
>  		return -ENXIO;
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

Two things:
 - My imagination was not able to produce a scenario where this commit
 would solve any problems. Can you explain better the case where the
 current code would cause the wrong interrupt to be generated (or miss
 generating an interrupt)? (this should be in the commit message)
 - I think that with this patch applied, there would cases (both TX and
 RX flags set) that we cause two writes into the EICS register. That
 could cause unnecessary wakeups.

>  
>  	return 0;
>  }
> -- 
> 2.17.1
>

Cheers,
-- 
Vinicius
