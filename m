Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4CA54C658
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 12:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346438AbiFOKj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 06:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345940AbiFOKj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 06:39:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B0250031;
        Wed, 15 Jun 2022 03:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655289596; x=1686825596;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pPDECs7UocnTpIM34N3OqawrSWQVQoJ4powjvN0e6Uk=;
  b=N9za8NCrSeBsGksXJ7oXxuoUG3+yfpNtlA4xR2Sj8/U5OFjJM5Y1JXBL
   fpSGui2gLDNVu4HG7ra/INnYDJhIT+061VsnmSed0WR23Ipnifb7uTsyM
   1vRm9ArAhMkeZsKhx8WKfGEVtWJL9v9slqR942gmKS5tsz9thiDjNTgb0
   /gNtxsdjqRvz+engxcEQ6K0Yv/DMoEbSzD1Lu3YR5C2b4bagFRZWe821R
   I6NvtytGLSeUgdOcIveF7q5gP9cmnwpkFkK2WOmmPgTSb6KvT1xXkONz7
   JOtkja9VahpfnNMMkIWYlz4MMSduF2vdu6r4HrdWuZtah5FAOpDQCfaIj
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="261940823"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="261940823"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 03:39:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="687234141"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 15 Jun 2022 03:39:54 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25FAdqvO004541;
        Wed, 15 Jun 2022 11:39:52 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com, bjorn@kernel.org
Subject: [PATCH v2 bpf-next 01/10] ice: allow toggling loopback mode via ndo_set_features callback
Date:   Wed, 15 Jun 2022 12:38:04 +0200
Message-Id: <20220615103804.1260221-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614174749.901044-2-maciej.fijalkowski@intel.com>
References: <20220614174749.901044-1-maciej.fijalkowski@intel.com> <20220614174749.901044-2-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Tue, 14 Jun 2022 19:47:40 +0200

> Add support for NETIF_F_LOOPBACK. Also, simplify checks throughout whole
> ice_set_features().
> 
> CC: Alexandr Lobakin <alexandr.lobakin@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 54 ++++++++++++++---------
>  1 file changed, 34 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index e1cae253412c..ab00b0361e87 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -3358,6 +3358,7 @@ static void ice_set_netdev_features(struct net_device *netdev)
>  	netdev->features |= netdev->hw_features;
>  
>  	netdev->hw_features |= NETIF_F_HW_TC;
> +	netdev->hw_features |= NETIF_F_LOOPBACK;
>  
>  	/* encap and VLAN devices inherit default, csumo and tso features */
>  	netdev->hw_enc_features |= dflt_features | csumo_features |
> @@ -5902,6 +5903,18 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
>  	return 0;
>  }
>  
> +static void ice_set_loopback(struct ice_pf *pf, struct net_device *netdev, bool ena)

I feel like the first argument is redundant in here since we can do

	const struct ice_netdev_priv *np = netdev_priv(netdev);
	struct ice_pf *pf = np->vsi->back;

But at the same time one function argument can be cheaper than two
jumps, so up to you.

> +{
> +	bool if_running = netif_running(netdev);
> +
> +	if (if_running)
> +		ice_stop(netdev);
> +	if (ice_aq_set_mac_loopback(&pf->hw, ena, NULL))
> +		dev_err(ice_pf_to_dev(pf), "Failed to toggle loopback state\n");

netdev_err() instead probably? I guess dev_err() is used for
consistency with the rest of ice_set_features(), but I'd recommend
using the former anyways.

> +	if (if_running)
> +		ice_open(netdev);
> +}
> +
>  /**
>   * ice_set_features - set the netdev feature flags
>   * @netdev: ptr to the netdev being adjusted
> @@ -5910,6 +5923,7 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
>  static int
>  ice_set_features(struct net_device *netdev, netdev_features_t features)
>  {
> +	netdev_features_t changed = netdev->features ^ features;
>  	struct ice_netdev_priv *np = netdev_priv(netdev);
>  	struct ice_vsi *vsi = np->vsi;
>  	struct ice_pf *pf = vsi->back;
> @@ -5917,37 +5931,33 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
>  
>  	/* Don't set any netdev advanced features with device in Safe Mode */
>  	if (ice_is_safe_mode(vsi->back)) {
> -		dev_err(ice_pf_to_dev(vsi->back), "Device is in Safe Mode - not enabling advanced netdev features\n");
> +		dev_err(ice_pf_to_dev(vsi->back),
> +			"Device is in Safe Mode - not enabling advanced netdev features\n");

This (I mean the whole ice_set_features() cleanup) deserves to be in
a separate patch to me. In can be a past of this series for sure.

>  		return ret;
>  	}
>  
>  	/* Do not change setting during reset */
>  	if (ice_is_reset_in_progress(pf->state)) {
> -		dev_err(ice_pf_to_dev(vsi->back), "Device is resetting, changing advanced netdev features temporarily unavailable.\n");
> +		dev_err(ice_pf_to_dev(vsi->back),
> +			"Device is resetting, changing advanced netdev features temporarily unavailable.\n");
>  		return -EBUSY;
>  	}
>  
>  	/* Multiple features can be changed in one call so keep features in
>  	 * separate if/else statements to guarantee each feature is checked
>  	 */
> -	if (features & NETIF_F_RXHASH && !(netdev->features & NETIF_F_RXHASH))
> -		ice_vsi_manage_rss_lut(vsi, true);
> -	else if (!(features & NETIF_F_RXHASH) &&
> -		 netdev->features & NETIF_F_RXHASH)
> -		ice_vsi_manage_rss_lut(vsi, false);
> +	if (changed & NETIF_F_RXHASH)
> +		ice_vsi_manage_rss_lut(vsi, !!(features & NETIF_F_RXHASH));
>  
>  	ret = ice_set_vlan_features(netdev, features);
>  	if (ret)
>  		return ret;
>  
> -	if ((features & NETIF_F_NTUPLE) &&
> -	    !(netdev->features & NETIF_F_NTUPLE)) {
> -		ice_vsi_manage_fdir(vsi, true);
> -		ice_init_arfs(vsi);
> -	} else if (!(features & NETIF_F_NTUPLE) &&
> -		 (netdev->features & NETIF_F_NTUPLE)) {
> -		ice_vsi_manage_fdir(vsi, false);
> -		ice_clear_arfs(vsi);
> +	if (changed & NETIF_F_NTUPLE) {
> +		bool ena = !!(features & NETIF_F_NTUPLE);
> +
> +		ice_vsi_manage_fdir(vsi, ena);
> +		ena ? ice_init_arfs(vsi) : ice_clear_arfs(vsi);
>  	}
>  
>  	/* don't turn off hw_tc_offload when ADQ is already enabled */
> @@ -5956,11 +5966,15 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
>  		return -EACCES;
>  	}
>  
> -	if ((features & NETIF_F_HW_TC) &&
> -	    !(netdev->features & NETIF_F_HW_TC))
> -		set_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
> -	else
> -		clear_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
> +	if (changed & NETIF_F_HW_TC) {
> +		bool ena = !!(features & NETIF_F_HW_TC);
> +
> +		ena ? set_bit(ICE_FLAG_CLS_FLOWER, pf->flags) :
> +		      clear_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
> +	}
> +
> +	if (changed & NETIF_F_LOOPBACK)
> +		ice_set_loopback(pf, netdev, !!(features & NETIF_F_LOOPBACK));
>  
>  	return 0;
>  }
> -- 
> 2.27.0

The rest is good, I like wiring up standard interfaces with the
existing hardware functionality :) Loopback mode is useful for
testing stuff.

Thanks!
Olek
