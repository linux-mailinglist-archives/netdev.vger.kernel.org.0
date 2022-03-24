Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9035F4E617E
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 11:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349422AbiCXKJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 06:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349367AbiCXKJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 06:09:57 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451DC9F6DD;
        Thu, 24 Mar 2022 03:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648116503; x=1679652503;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=D4tQL9ezIGp1V+zUe7L+IBKQ/EYL74mA6PBzw54L6KI=;
  b=fMmpYofPELHd3fnINdisYuhoohCcA3nxScnKAdoJT3GpK5ZA6swnptF9
   qOI6FTUuL1yXqQ9gdhPyoPTM4akr2xiISnTh4eCePCPoA7wFhAornkipd
   9JrRSEN5ZKWShwN5vpNjECypH9kdRJAB2Ov7yza/t3jOy4mzzxS2pFVxl
   ck2jhI08XujgoiV6LYWm9BX7WbISboFWSSKCwC4XXupiRIy1JuuLpzGA4
   1qyjacvNnBxqEwGqd5xch1DQEGLswXrNQko5E93+4X6eHns49nwK1rUrS
   9KhIZb7xiZcSyWuuzYLqNbRKtsDuccZjLu2KY4rP99wWaqN4DVNfHlOjg
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="344769399"
X-IronPort-AV: E=Sophos;i="5.90,207,1643702400"; 
   d="scan'208";a="344769399"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2022 03:07:55 -0700
X-IronPort-AV: E=Sophos;i="5.90,207,1643702400"; 
   d="scan'208";a="561309848"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2022 03:07:52 -0700
Date:   Thu, 24 Mar 2022 03:09:25 -0400
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>, mschmidt@redhat.com,
        Brett Creeley <brett.creeley@intel.com>,
        open list <linux-kernel@vger.kernel.org>, poros@redhat.com,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH net] ice: Clear default forwarding VSI
 during VSI release
Message-ID: <YjwZJU7PIKCcndC1@localhost.localdomain>
References: <20220322142554.3253428-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322142554.3253428-1-ivecera@redhat.com>
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 03:25:54PM +0100, Ivan Vecera wrote:
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
>  	ice_fltr_remove_all(vsi);
>  	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
>  	err = ice_rm_vsi_rdma_cfg(vsi->port_info, vsi->idx);
Thanks for fixing it.
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

> -- 
> 2.34.1
> 
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
