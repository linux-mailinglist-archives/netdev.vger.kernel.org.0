Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4990C68C3E1
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 17:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjBFQxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 11:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjBFQxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 11:53:09 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2691117C
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 08:53:04 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 3CD2A61CC457B;
        Mon,  6 Feb 2023 17:53:01 +0100 (CET)
Message-ID: <6eed8aad-1520-5789-264e-b952b6ff4502@molgen.mpg.de>
Date:   Mon, 6 Feb 2023 17:53:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [Intel-wired-lan] [PATCH 1/1] ice: add support BIG TCP on IPv6
Content-Language: en-US
To:     Pawel Chmielewski <pawel.chmielewski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@osuosl.org
References: <20230206155912.2032457-1-pawel.chmielewski@intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230206155912.2032457-1-pawel.chmielewski@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Pawel,


Thank you for your patch.

Am 06.02.23 um 16:59 schrieb Pawel Chmielewski:
> This change enables sending BIG TCP packets on IPv6 in the ice driver using
> generic ipv6_hopopt_jumbo_remove helper for stripping HBH header.
> 
> Tested:
> netperf -t TCP_RR -H 2001:db8:0:f101::1  -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT
> 
> Results varied from one setup to another, but in every case we got lower
> latencies and increased transactions rate.

Please give some concrete examples nevertheless.


Kind regards,

Paul


> Signed-off-by: Pawel Chmielewski <pawel.chmielewski@intel.com>
> ---
>   drivers/net/ethernet/intel/ice/ice.h      | 2 ++
>   drivers/net/ethernet/intel/ice/ice_main.c | 2 ++
>   drivers/net/ethernet/intel/ice/ice_txrx.c | 3 +++
>   3 files changed, 7 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
> index 3d26ff4122e0..c774fdd482cd 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -122,6 +122,8 @@
>   
>   #define ICE_MAX_MTU	(ICE_AQ_SET_MAC_FRAME_SIZE_MAX - ICE_ETH_PKT_HDR_PAD)
>   
> +#define ICE_MAX_TSO_SIZE 131072
> +
>   #define ICE_UP_TABLE_TRANSLATE(val, i) \
>   		(((val) << ICE_AQ_VSI_UP_TABLE_UP##i##_S) & \
>   		  ICE_AQ_VSI_UP_TABLE_UP##i##_M)
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index 22b8ad058286..8c74a48ad0d3 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -3421,6 +3421,8 @@ static void ice_set_netdev_features(struct net_device *netdev)
>   	 * be changed at runtime
>   	 */
>   	netdev->hw_features |= NETIF_F_RXFCS;
> +
> +	netif_set_tso_max_size(netdev, ICE_MAX_TSO_SIZE);
>   }
>   
>   /**
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> index ccf09c957a1c..bef927afb766 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> @@ -2297,6 +2297,9 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
>   
>   	ice_trace(xmit_frame_ring, tx_ring, skb);
>   
> +	if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
> +		goto out_drop;
> +
>   	count = ice_xmit_desc_count(skb);
>   	if (ice_chk_linearize(skb, count)) {
>   		if (__skb_linearize(skb))
