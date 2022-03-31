Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B971D4EDA4D
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 15:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236676AbiCaNQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 09:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236639AbiCaNQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 09:16:20 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44E5427FE;
        Thu, 31 Mar 2022 06:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648732472; x=1680268472;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oR/AUSp/9k7pPI88MrXUg7hk4K/wyRXv3H2I8+Swez0=;
  b=NYxndSLwUHoeDmY+K5xOM35OAzK9Pw5NvaER3XWjZcj+dqdMJ+1QKLjV
   4+1s9n5q57FNrS3Gb8YqdJCgNH3Xy2+B1lWwRmQKxix/lC7muzucAdLVv
   7CYGDXB43aH3cnXM3Kt7tvXxh0YlVVCKI5GqtGJo+Qw5yprlIbpmPOZu1
   I13CqoME3MbUJ/4FCySFJ2TkKVLKjvmKf/JIPFpMVSPwcGOlbtscsBQGs
   A6NY+8d1k+lhYdaYz0Ce5oFcERLofLv2kMNSKpfC1Ct8rmZXRFimG+xTO
   l6ukqcCj3rVEsXPGxbwO1KwlQS/1lEhaoVNeXQynmBj7maE8/MRuJq+XM
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="259545445"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="259545445"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 06:14:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="503744395"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga003.jf.intel.com with ESMTP; 31 Mar 2022 06:14:30 -0700
Date:   Thu, 31 Mar 2022 15:14:29 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>, mschmidt@redhat.com,
        Brett Creeley <brett.creeley@intel.com>,
        open list <linux-kernel@vger.kernel.org>, poros@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH net] ice: Fix incorrect locking in
 ice_vc_process_vf_msg()
Message-ID: <YkWpNVXYEBo/u3dm@boxer>
References: <20220331105005.2580771-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331105005.2580771-1-ivecera@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 12:50:04PM +0200, Ivan Vecera wrote:
> Usage of mutex_trylock() in ice_vc_process_vf_msg() is incorrect
> because message sent from VF is ignored and never processed.
> 
> Use mutex_lock() instead to fix the issue. It is safe because this

We need to know what is *the* issue in the first place.
Could you please provide more context what is being fixed to the readers
that don't have an access to bugzilla?

Specifically, what is the case that ignoring a particular message when
mutex is already held is a broken behavior?

> mutex is used to prevent races between VF related NDOs and
> handlers processing request messages from VF and these handlers
> are running in ice_service_task() context.
> 
> Fixes: e6ba5273d4ed ("ice: Fix race conditions between virtchnl handling and VF ndo ops")
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_virtchnl.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> index 3f1a63815bac..9bf5bb008128 100644
> --- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> +++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> @@ -3660,15 +3660,7 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
>  		return;
>  	}
>  
> -	/* VF is being configured in another context that triggers a VFR, so no
> -	 * need to process this message
> -	 */
> -	if (!mutex_trylock(&vf->cfg_lock)) {
> -		dev_info(dev, "VF %u is being configured in another context that will trigger a VFR, so there is no need to handle this message\n",
> -			 vf->vf_id);
> -		ice_put_vf(vf);
> -		return;
> -	}
> +	mutex_lock(&vf->cfg_lock);
>  
>  	switch (v_opcode) {
>  	case VIRTCHNL_OP_VERSION:
> -- 
> 2.34.1
> 
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
