Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184A3546956
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiFJPX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242530AbiFJPX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:23:27 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DD9265;
        Fri, 10 Jun 2022 08:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654874606; x=1686410606;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=glIcZYEpCCn8cT+dDB8yKz+nWwgekOqE9hCVmv8xyfY=;
  b=V6aH37SVIduX/8Cg+ZifM6IZ1ICNNskiP2YBF8GLDVi7UdlQtjoDbkIr
   YoxcCMybQwCx/ibRSuBPUunRmJ8jlkWXJ6Il8GPU8+7wSfytKfElEjcIo
   XNGPOEk5VGXgMzIgHBf8EH7+R45/+hrGY7RZZfAyN9Jx+ewbMf9k3GLbM
   4Wi7C0KRiBLXKtlWxDx52v1T+PaZK1xw1LdurKFsC8SP+WXZiu0NL/ym9
   m9l60d9Kig6nvImo8qA5UUfkfKsv5I8OpIppEcKHCd8hzHMyVZKhsSWox
   0Ml9Mi/YO2OJkpU4PPMcDWWLJS7vKrUoCjdMQbaRPMA+Wqkrzk896BGUd
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="278457392"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="278457392"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 08:23:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="534121619"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 10 Jun 2022 08:23:23 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25AFNMam018155;
        Fri, 10 Jun 2022 16:23:22 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com, bjorn@kernel.org
Subject: Re: [PATCH bpf-next 01/10] ice: introduce priv-flag for toggling loopback mode
Date:   Fri, 10 Jun 2022 17:22:16 +0200
Message-Id: <20220610152216.923385-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220610150923.583202-2-maciej.fijalkowski@intel.com>
References: <20220610150923.583202-1-maciej.fijalkowski@intel.com> <20220610150923.583202-2-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Fri, 10 Jun 2022 17:09:14 +0200

> Add a knob that will allow user to turn the underlying net device into
> loopback mode. The use case for this will be the AF_XDP ZC tests. Once
> the device is in loopback mode, then it will be possible from AF_XDP
> perspective to see if zero copy implementations in drivers work
> properly.
> 
> The code for interaction with admin queue is reused from ethtool's
> loopback test.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h         |  1 +
>  drivers/net/ethernet/intel/ice/ice_ethtool.c | 17 +++++++++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
> index 60453b3b8d23..90c066f3782b 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -487,6 +487,7 @@ enum ice_pf_flags {
>  	ICE_FLAG_PLUG_AUX_DEV,
>  	ICE_FLAG_MTU_CHANGED,
>  	ICE_FLAG_GNSS,			/* GNSS successfully initialized */
> +	ICE_FLAG_LOOPBACK,

I'do for %NETIF_F_LOOPBACK, should work in here, too :)

>  	ICE_PF_FLAGS_NBITS		/* must be last */
>  };
>  
> diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> index 1e71b70f0e52..cfc3c5e36907 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> +++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> @@ -166,6 +166,7 @@ static const struct ice_priv_flag ice_gstrings_priv_flags[] = {
>  	ICE_PRIV_FLAG("mdd-auto-reset-vf", ICE_FLAG_MDD_AUTO_RESET_VF),
>  	ICE_PRIV_FLAG("vf-vlan-pruning", ICE_FLAG_VF_VLAN_PRUNING),
>  	ICE_PRIV_FLAG("legacy-rx", ICE_FLAG_LEGACY_RX),
> +	ICE_PRIV_FLAG("loopback", ICE_FLAG_LOOPBACK),
>  };
>  
>  #define ICE_PRIV_FLAG_ARRAY_SIZE	ARRAY_SIZE(ice_gstrings_priv_flags)
> @@ -1288,6 +1289,22 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
>  			ice_up(vsi);
>  		}
>  	}
> +
> +	if (test_bit(ICE_FLAG_LOOPBACK, change_flags)) {
> +		if (!test_bit(ICE_FLAG_LOOPBACK, orig_flags)) {
> +			/* Enable MAC loopback in firmware */
> +			if (ice_aq_set_mac_loopback(&pf->hw, true, NULL)) {
> +				dev_err(dev, "Failed to enable loopback\n");
> +				ret = -ENXIO;
> +			}
> +		} else {
> +			/* Disable MAC loopback in firmware */
> +			if (ice_aq_set_mac_loopback(&pf->hw, false, NULL)) {
> +				dev_err(dev, "Failed to disable loopback\n");
> +				ret = -ENXIO;
> +			}
> +		}
> +	}
>  	/* don't allow modification of this flag when a single VF is in
>  	 * promiscuous mode because it's not supported
>  	 */
> -- 
> 2.27.0

Thanks,
Olek
