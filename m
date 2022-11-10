Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D047D624378
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 14:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiKJNo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 08:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbiKJNoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 08:44:25 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2589C4D5E0
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 05:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668087864; x=1699623864;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xN2fMduQuvuDcANpZLhE401+lgc97SUOjafOsx/p7m0=;
  b=LKHD8VDcLEEsmY7/O6QSS8BLqFqxXUlFpppch3tkfyXljY9Vd1cUS7tz
   nLmKmPxn/pIw0k5brgVAqvyf8j7s4PsIH5SE60CQ2YgL4bW3X9CcCELIx
   oz9NUzP2zchepPJJwuQvZVZk+oRAGqHhqOFPzNZVB43k4w7WiDyT+EBMA
   I7zzTURS+/rK8CgdNWKXm8fjWFCVmgFbQodpqmcJe0F2xxBBzRj1pEVDE
   +hU97JTGfv8DaU0G4j826F4cNXbHIyZFnVnDgJIho5shLrJS62H7LaqMx
   bvoPF7GxBRj9Nx8n8w6RMOflt3IPyGiioE6bAeEH+6WB3n1NmMujTgGEE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="375555471"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="375555471"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 05:44:24 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="588178055"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="588178055"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 05:44:23 -0800
Date:   Thu, 10 Nov 2022 14:44:15 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: Re: [Intel-wired-lan] [PATCH net-next] ice: virtchnl rss hena support
Message-ID: <Y20ALyOpF2HbtuzU@localhost.localdomain>
References: <20221110130353.3040-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110130353.3040-1-wojciech.drewek@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 02:03:53PM +0100, Wojciech Drewek wrote:
> From: Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>
> 
> Add support for 2 virtchnl msgs:
> VIRTCHNL_OP_SET_RSS_HENA
> VIRTCHNL_OP_GET_RSS_HENA_CAPS
> 
> The first one allows VFs to clear all previously programmed
> RSS configuration and customize it. The second one returns
> the RSS HENA bits allowed by the hardware.
> 
> Introduce ice_err_to_virt_err which converts kernel
> specific errors to virtchnl errors.
> 
> Signed-off-by: Md Fahad Iqbal Polash <md.fahad.iqbal.polash@intel.com>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_vf_lib.c   |  24 ++++
>  .../ethernet/intel/ice/ice_vf_lib_private.h   |   1 +
>  drivers/net/ethernet/intel/ice/ice_virtchnl.c | 112 ++++++++++++++++++
>  drivers/net/ethernet/intel/ice/ice_virtchnl.h |   2 +
>  4 files changed, 139 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
> index dfcf23cc7e55..2eaaa452f847 100644
> --- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
> @@ -699,6 +699,30 @@ void ice_dis_vf_qs(struct ice_vf *vf)
>  	ice_set_vf_state_qs_dis(vf);
>  }
> 
[...]

looks good;
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Thanks
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
