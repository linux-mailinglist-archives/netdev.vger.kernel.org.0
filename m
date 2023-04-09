Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36EF6DBF88
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 12:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjDIKpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 06:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDIKpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 06:45:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C34A4681
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 03:45:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9271060BEC
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 10:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C2CC433D2;
        Sun,  9 Apr 2023 10:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681037133;
        bh=b9HF4l5dijqYKui97yittnegROjisIi4nxToN4dxwLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SYxhZI4IkdGPhHB8+v5yDuu3Cn2cJmDLsMt705hKtBBa5OCRP9S4PkLbsjrvmfkWR
         iLAWOe+GJWARDFgB5cvl/sIlc0RdG4jghW3W3iBtuDYYX64LyGqLB0zUwKElJYeHLs
         v7KhajJT92QSKNWDcSQe2swvu6DpHa4ATIAmid1qiyBh0BtcKotH4Kt4FzPPkkmzYw
         Bw81nm0z94DEvG+9eRgnFo7oAPXb5DGnfzhgEddtuwwWr+VgeJScbDy72QVMIU4rN+
         s6mZtZdPE1cOk7um0o5OZXhyj91gnHbonBUdcQnJM+RqoL8RzcuUzRU7mN5S3O7Y9v
         sG41xItxDcdzA==
Date:   Sun, 9 Apr 2023 13:45:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Ahmed Zaki <ahmed.zaki@intel.com>,
        Arpana Arland <arpanax.arland@intel.com>
Subject: Re: [PATCH net 1/1] ice: identify aRFS flows using L3/L4 dissector
 info
Message-ID: <20230409104529.GQ14869@unreal>
References: <20230407210820.3046220-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407210820.3046220-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 02:08:20PM -0700, Tony Nguyen wrote:
> From: Ahmed Zaki <ahmed.zaki@intel.com>
> 
> The flow ID passed to ice_rx_flow_steer() is computed like this:
> 
>     flow_id = skb_get_hash(skb) & flow_table->mask;
> 
> With smaller aRFS tables (for example, size 256) and higher number of
> flows, there is a good chance of flow ID collisions where two or more
> different flows are using the same flow ID. This results in the aRFS
> destination queue constantly changing for all flows sharing that ID.
> 
> Use the full L3/L4 flow dissector info to identify the steered flow
> instead of the passed flow ID.
> 
> Fixes: 28bf26724fdb ("ice: Implement aRFS")
> Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
> Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_arfs.c | 44 +++++++++++++++++++++--
>  1 file changed, 41 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_arfs.c b/drivers/net/ethernet/intel/ice/ice_arfs.c
> index fba178e07600..d7ae64d21e01 100644
> --- a/drivers/net/ethernet/intel/ice/ice_arfs.c
> +++ b/drivers/net/ethernet/intel/ice/ice_arfs.c
> @@ -345,6 +345,44 @@ ice_arfs_build_entry(struct ice_vsi *vsi, const struct flow_keys *fk,
>  	return arfs_entry;
>  }
>  
> +/**
> + * ice_arfs_cmp - compare flow to a saved ARFS entry's filter info
> + * @fltr_info: filter info of the saved ARFS entry
> + * @fk: flow dissector keys
> + *
> + * Caller must hold arfs_lock if @fltr_info belongs to arfs_fltr_list
> + */
> +static bool
> +ice_arfs_cmp(struct ice_fdir_fltr *fltr_info, const struct flow_keys *fk)
> +{
> +	bool is_ipv4;
> +
> +	if (!fltr_info || !fk)
> +		return false;
> +
> +	is_ipv4 = (fltr_info->flow_type == ICE_FLTR_PTYPE_NONF_IPV4_UDP ||
> +		fltr_info->flow_type == ICE_FLTR_PTYPE_NONF_IPV4_TCP);
> +
> +	if (fk->basic.n_proto == htons(ETH_P_IP) && is_ipv4)
> +		return (fltr_info->ip.v4.proto == fk->basic.ip_proto &&
> +			fltr_info->ip.v4.src_port == fk->ports.src &&
> +			fltr_info->ip.v4.dst_port == fk->ports.dst &&
> +			fltr_info->ip.v4.src_ip == fk->addrs.v4addrs.src &&
> +			fltr_info->ip.v4.dst_ip == fk->addrs.v4addrs.dst);
> +	else if (fk->basic.n_proto == htons(ETH_P_IPV6) && !is_ipv4)
> +		return (fltr_info->ip.v6.proto == fk->basic.ip_proto &&
> +			fltr_info->ip.v6.src_port == fk->ports.src &&
> +			fltr_info->ip.v6.dst_port == fk->ports.dst &&
> +			!memcmp(&fltr_info->ip.v6.src_ip,
> +				&fk->addrs.v6addrs.src,
> +				sizeof(struct in6_addr)) &&
> +			!memcmp(&fltr_info->ip.v6.dst_ip,
> +				&fk->addrs.v6addrs.dst,
> +				sizeof(struct in6_addr)));

I'm confident that you can write this function more clear with
comparisons in one "return ..." instruction.

Thanks

> +
> +	return false;
> +}
> +
>  /**
>   * ice_arfs_is_perfect_flow_set - Check to see if perfect flow is set
>   * @hw: pointer to HW structure
> @@ -436,17 +474,17 @@ ice_rx_flow_steer(struct net_device *netdev, const struct sk_buff *skb,
>  
>  	/* choose the aRFS list bucket based on skb hash */
>  	idx = skb_get_hash_raw(skb) & ICE_ARFS_LST_MASK;
> +
>  	/* search for entry in the bucket */
>  	spin_lock_bh(&vsi->arfs_lock);
>  	hlist_for_each_entry(arfs_entry, &vsi->arfs_fltr_list[idx],
>  			     list_entry) {
> -		struct ice_fdir_fltr *fltr_info;
> +		struct ice_fdir_fltr *fltr_info = &arfs_entry->fltr_info;
>  
>  		/* keep searching for the already existing arfs_entry flow */
> -		if (arfs_entry->flow_id != flow_id)
> +		if (!ice_arfs_cmp(fltr_info, &fk))
>  			continue;
>  
> -		fltr_info = &arfs_entry->fltr_info;
>  		ret = fltr_info->fltr_id;
>  
>  		if (fltr_info->q_index == rxq_idx ||
> -- 
> 2.38.1
> 
