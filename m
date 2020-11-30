Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249A92C8E1A
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 20:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgK3Tcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 14:32:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:3464 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726756AbgK3Tcf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 14:32:35 -0500
IronPort-SDR: l2dLwxAGGDg/b/tfZSNtSyFv07Co+GQg4B3XC/5qdEBLDhNey6tK1TsakNbTHnbJOUTs1V55c2
 olA9goYuvWzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="190886293"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="190886293"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 11:31:55 -0800
IronPort-SDR: 5HTOZJwSf90IU3UU/cY9XQYRfgBCovcJxLUX1r/++EewS8YmiNHJOMPMkGAp3nIYdN8kdmQRKd
 8S+z1hXbYlXg==
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="549235296"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.29.232]) ([10.209.29.232])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 11:31:54 -0800
Subject: Re: [PATCH] i40e: acquire VSI pointer only after VF is initialized
To:     Stefan Assmann <sassmann@kpanic.de>,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, lihong.yang@intel.com
References: <20201130131257.28856-1-sassmann@kpanic.de>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <263c6e31-62a3-e73d-6f63-23216b15fdd0@intel.com>
Date:   Mon, 30 Nov 2020 11:31:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201130131257.28856-1-sassmann@kpanic.de>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/30/2020 5:12 AM, Stefan Assmann wrote:
> This change simplifies the VF initialization check and also minimizes
> the delay between acquiring the VSI pointer and using it. As known by
> the commit being fixed, there is a risk of the VSI pointer getting
> changed. Therefore minimize the delay between getting and using the
> pointer.
> 
> Fixes: 9889707b06ac ("i40e: Fix crash caused by stress setting of VF MAC addresses")
> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>

Ok.

> ---
>  drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> index 729c4f0d5ac5..bf6034c3a6ea 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> @@ -4046,20 +4046,16 @@ int i40e_ndo_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
>  		goto error_param;
>  
>  	vf = &pf->vf[vf_id];
> -	vsi = pf->vsi[vf->lan_vsi_idx];
>  
>  	/* When the VF is resetting wait until it is done.
>  	 * It can take up to 200 milliseconds,
>  	 * but wait for up to 300 milliseconds to be safe.
> -	 * If the VF is indeed in reset, the vsi pointer has
> -	 * to show on the newly loaded vsi under pf->vsi[id].
> +	 * Acquire the vsi pointer only after the VF has been
> +	 * properly initialized.
>  	 */
>  	for (i = 0; i < 15; i++) {
> -		if (test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) {
> -			if (i > 0)
> -				vsi = pf->vsi[vf->lan_vsi_idx];
> +		if (test_bit(I40E_VF_STATE_INIT, &vf->vf_states))
>  			break;
> -		}
>  		msleep(20);
>  	}
>  	if (!test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) {
> @@ -4068,6 +4064,7 @@ int i40e_ndo_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
>  		ret = -EAGAIN;
>  		goto error_param;
>  	}
> +	vsi = pf->vsi[vf->lan_vsi_idx];
>  

Yea, this makes more sense to me.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  	if (is_multicast_ether_addr(mac)) {
>  		dev_err(&pf->pdev->dev,
> 
