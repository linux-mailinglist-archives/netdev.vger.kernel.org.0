Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5560E4F9746
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 15:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236533AbiDHNv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 09:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbiDHNv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 09:51:28 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C0622BF6;
        Fri,  8 Apr 2022 06:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649425761; x=1680961761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JHxUCB/6BRTe6TReGYNBtiqtMSGrnYkHBfI8LfQrgAc=;
  b=MkpuAuyrMLyJ1ArysSQdpCuaxLCiO6z0Sdoi/DxQ1w/mH9YZUjglsKMH
   ZrkSNIkanshoxM/3iMjLb/RR0nLooF2vKPMjAaLWUabNjaMR/S70uw0hY
   xtRkZRmpM1+T/H3lJKNiaOnpXWhdsY8eJiPgKOrIF7iNEBF7ydS6bPXWb
   4BkXBD706+QKUEQVis8tuE4oimpU/i+Mplqz53h/WLng0M4Qav4T+RPyL
   5yZbrKjOll54TE8eIzspyldle1MrVq6qHllQbSz6/vknpQoMQ91msjyML
   rfaMCw7NfEutKhEQ5f6BcxbnXjwdtUgxkpFrIA4o/Jhf4IB0OOTHWJ2F9
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="242189596"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="242189596"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 06:49:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="550507028"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 08 Apr 2022 06:49:16 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 238DnFvK003958;
        Fri, 8 Apr 2022 14:49:15 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        poros@redhat.com, mschmidt@redhat.com, jacob.e.keller@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Brett Creeley <brett@pensando.io>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH net v2] ice: Fix incorrect locking in ice_vc_process_vf_msg()
Date:   Fri,  8 Apr 2022 15:47:14 +0200
Message-Id: <20220408134714.1834349-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220401104052.1711721-1-ivecera@redhat.com>
References: <20220401104052.1711721-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>
Date: Fri,  1 Apr 2022 12:40:52 +0200

> Usage of mutex_trylock() in ice_vc_process_vf_msg() is incorrect
> because message sent from VF is ignored and never processed.
> 
> Use mutex_lock() instead to fix the issue. It is safe because this
> mutex is used to prevent races between VF related NDOs and
> handlers processing request messages from VF and these handlers
> are running in ice_service_task() context. Additionally move this
> mutex lock prior ice_vc_is_opcode_allowed() call to avoid potential
> races during allowlist acccess.
> 
> Fixes: e6ba5273d4ed ("ice: Fix race conditions between virtchnl handling and VF ndo ops")
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>

Hey Tony,

I guess you missed this one due to being on a vacation previously.
It's been previously reviewed IIRC, could you take it into
net-queue?

> ---
>  drivers/net/ethernet/intel/ice/ice_virtchnl.c | 21 +++++++------------
>  1 file changed, 7 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> index 3f1a63815bac..a465f3743ffc 100644
> --- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> +++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> @@ -3642,14 +3642,6 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
>  			err = -EINVAL;
>  	}
>  
> -	if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
> -		ice_vc_send_msg_to_vf(vf, v_opcode,
> -				      VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
> -				      0);
> -		ice_put_vf(vf);
> -		return;
> -	}
> -
>  error_handler:
>  	if (err) {
>  		ice_vc_send_msg_to_vf(vf, v_opcode, VIRTCHNL_STATUS_ERR_PARAM,
> @@ -3660,12 +3652,13 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
>  		return;
>  	}
>  
> -	/* VF is being configured in another context that triggers a VFR, so no
> -	 * need to process this message
> -	 */
> -	if (!mutex_trylock(&vf->cfg_lock)) {
> -		dev_info(dev, "VF %u is being configured in another context that will trigger a VFR, so there is no need to handle this message\n",
> -			 vf->vf_id);
> +	mutex_lock(&vf->cfg_lock);
> +
> +	if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
> +		ice_vc_send_msg_to_vf(vf, v_opcode,
> +				      VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
> +				      0);
> +		mutex_unlock(&vf->cfg_lock);
>  		ice_put_vf(vf);
>  		return;
>  	}
> -- 
> 2.35.1

Thanks,
Al
