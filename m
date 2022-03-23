Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAFC14E57BA
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343686AbiCWRlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240424AbiCWRlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:41:35 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D59D65801;
        Wed, 23 Mar 2022 10:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648057205; x=1679593205;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zJDagyibNbk8SsVd5xnyYaCfEE/tEBY6Q2NBuH6XAnc=;
  b=jMIRmujp71gB8GNDqUw13ovVkYpv1LWSOy2W5U7hR1sD488yF/2+/IQ/
   pmG8VBo9+xLwCjY15NCn0B24nWuHdhiqoPKTnBaDabS6Dc/Af7i4dYklC
   tfMLEoClyWtKYOuCYZirwPTeHDP9OWINIP8/txOiELlaxZGfuGjMqElt4
   KDPapIk82UoD4CXbGE359yIQiJLU0YvC54FAw1qw+lwhLNhzCwzEKl5EU
   tN1NIeSsLmeAsMRfSMpM0YeWnHCEg3ySxq6+qMxaCm743Mfz+M2+6BlUS
   8EuCe2Ea/y61mJH638UX6blZnEfHoeVVlt/K0ul/TkaUiP8CDtSYoxxhb
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="258140196"
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="258140196"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 10:39:18 -0700
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="561012724"
Received: from mszycik-mobl.ger.corp.intel.com (HELO [10.249.137.148]) ([10.249.137.148])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 10:39:13 -0700
Message-ID: <45b155ff-8e26-fa96-f89e-6a561de01abb@linux.intel.com>
Date:   Wed, 23 Mar 2022 18:39:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] ice: Clear default forwarding VSI during VSI release
Content-Language: en-US
To:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org
Cc:     poros@redhat.com, mschmidt@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Brett Creeley <brett.creeley@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220322142554.3253428-1-ivecera@redhat.com>
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
In-Reply-To: <20220322142554.3253428-1-ivecera@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22-Mar-22 15:25, Ivan Vecera wrote:
> VSI is set as default forwarding one when promisc mode is set for
> PF interface, when PF is switched to switchdev mode or when VF
> driver asks to enable allmulticast or promisc mode for the VF
> interface (when vf-true-promisc-support priv flag is off).
> The third case is buggy because in that case VSI associated with
> VF remains as default one after VF removal.
> 
> Reproducer:
> 1. Create VF
>    echo 1 > sys/class/net/ens7f0/device/sriov_numvfs
> 2. Enable allmulticast or promisc mode on VF
>    ip link set ens7f0v0 allmulticast on
>    ip link set ens7f0v0 promisc on
> 3. Delete VF
>    echo 0 > sys/class/net/ens7f0/device/sriov_numvfs
> 4. Try to enable promisc mode on PF
>    ip link set ens7f0 promisc on
> 
> Although it looks that promisc mode on PF is enabled the opposite
> is true because ice_vsi_sync_fltr() responsible for IFF_PROMISC
> handling first checks if any other VSI is set as default forwarding
> one and if so the function does not do anything. At this point
> it is not possible to enable promisc mode on PF without re-probe
> device.
> 
> To resolve the issue this patch clear default forwarding VSI
> during ice_vsi_release() when the VSI to be released is the default
> one.
> 
> Fixes: 01b5e89aab49 ("ice: Add VF promiscuous support")
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_lib.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
> index 53256aca27c7..20d755822d43 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
> @@ -3147,6 +3147,8 @@ int ice_vsi_release(struct ice_vsi *vsi)
>  		}
>  	}
>  
> +	if (ice_is_vsi_dflt_vsi(pf->first_sw, vsi))
> +		ice_clear_dflt_vsi(pf->first_sw);

It would probably be good to check `ice_clear_dflt_vsi` return code.

>  	ice_fltr_remove_all(vsi);
>  	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
>  	err = ice_rm_vsi_rdma_cfg(vsi->port_info, vsi->idx);
