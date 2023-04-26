Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991536EEE86
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 08:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239397AbjDZGtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 02:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239542AbjDZGts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 02:49:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526C910EB
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 23:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1C6062321
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 06:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7987FC433D2;
        Wed, 26 Apr 2023 06:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682491786;
        bh=05Qxei+c9rVh3k+ab+XsF3LuJB+Pw5m0VNFNSgtpjuM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YTXggkBffKLk/o5HKBt5R5zL4oxPHY8ljiGv1dlXRJNNVN53fmhzcqBshukeqAtfG
         9wEGfgsY3aPoXyeIr7TwO3emxUR0tOQqI53oFRQQc0HGoD8xMU/XEU3ElSSxXBvOjQ
         lkM10JDW/0A8cLFeJUvWMlU8WSi5RiF5YT1212BBBWLfVjEX7nS/yDV1JXPnzC+Ylr
         gF2boOK3wdDJ8UJbNkxauwAp4G0mdCSvhFWuMiHAs7NkpFtJPO9clLrMJ1ziVe3aPG
         8MOy32e5tZcA7mwwNwX/fG7buQsPqoAjWzooQloehl7xh4PEtODMx+gMBZtZwByRhI
         3s8IhYrUc8zOg==
Date:   Wed, 26 Apr 2023 09:49:41 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Dawid Wesierski <dawidx.wesierski@intel.com>,
        Kamil Maziarz <kamil.maziarz@intel.com>,
        Jacob Keller <Jacob.e.keller@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net 2/3] ice: Fix ice VF reset during iavf initialization
Message-ID: <20230426064941.GF27649@unreal>
References: <20230425170127.2522312-1-anthony.l.nguyen@intel.com>
 <20230425170127.2522312-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425170127.2522312-3-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 10:01:26AM -0700, Tony Nguyen wrote:
> From: Dawid Wesierski <dawidx.wesierski@intel.com>
> 
> Fix the current implementation that causes ice_trigger_vf_reset()
> to start resetting the VF even when the VF is still resetting itself
> and initializing adminq. This leads to a series of -53 errors
> (failed to init adminq) from the IAVF.
> 
> Change the state of the vf_state field to be not active when the IAVF
> asks for a reset. To avoid issues caused by the VF being reset too
> early, make sure to wait until receiving the message on the message
> box to know the exact state of the IAVF driver.
> 
> Fixes: c54d209c78b8 ("ice: Wait for VF to be reset/ready before configuration")
> Signed-off-by: Dawid Wesierski <dawidx.wesierski@intel.com>
> Signed-off-by: Kamil Maziarz <kamil.maziarz@intel.com>
> Acked-by: Jacob Keller <Jacob.e.keller@intel.com>
> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_sriov.c    |  8 ++++----
>  drivers/net/ethernet/intel/ice/ice_vf_lib.c   | 19 +++++++++++++++++++
>  drivers/net/ethernet/intel/ice/ice_vf_lib.h   |  1 +
>  drivers/net/ethernet/intel/ice/ice_virtchnl.c |  1 +
>  4 files changed, 25 insertions(+), 4 deletions(-)

<...>

> -	ret = ice_check_vf_ready_for_cfg(vf);
> +	ret = ice_check_vf_ready_for_reset(vf);
>  	if (ret)
>  		goto out_put_vf;

<...>

> +/**
> + * ice_check_vf_ready_for_reset - check if VF is ready to be reset
> + * @vf: VF to check if it's ready to be reset
> + *
> + * The purpose of this function is to ensure that the VF is not in reset,
> + * disabled, and is both initialized and active, thus enabling us to safely
> + * initialize another reset.
> + */
> +int ice_check_vf_ready_for_reset(struct ice_vf *vf)
> +{
> +	int ret;
> +
> +	ret = ice_check_vf_ready_for_cfg(vf);
> +	if (!ret && !test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states))
> +		ret = -EAGAIN;

I don't know your driver enough to say how it is it possible to find VF
"resetting itself" and PF trying to reset VF at the same time.

But what I see is that ICE_VF_STATE_ACTIVE bit check is racy and you
don't really fix the root cause of calling to reset without proper locking.

Thanks

> +
> +	return ret;
> +}

<...>

>  	case VIRTCHNL_OP_RESET_VF:
> +		clear_bit(ICE_VF_STATE_ACTIVE, vf->vf_states);
>  		ops->reset_vf(vf);
>  		break;
>  	case VIRTCHNL_OP_ADD_ETH_ADDR:
> -- 
> 2.38.1
> 
