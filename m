Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC5165CDCA
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 08:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbjADHoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 02:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjADHol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 02:44:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC90193D7
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 23:44:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65254615AC
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 07:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB01C433D2;
        Wed,  4 Jan 2023 07:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672818279;
        bh=h24wcxowDUixLcnxVFAned/NXr5HQguOGq7JlZF1WeM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RA7sLnmos1U9OdrGz2Ef0EwqAFOFxZOAUZmo/OyYqf8noh+Mth0x4mJKR78oCgYxp
         rsuoXFYMBSEpMl4mQq4lZfkpfKGL12/vlJ4SiMPZfJGf6DqjgeBkSfXQLRt7HBjc56
         PdcpiSGgEnTrk4bYOqmm4oPYnxX9X/bO3pNQs+5EBm28o1ePTZrDbk7EyXlJ1CLnph
         HPGjS1wee8eFweKSz2HoY6eYYVU4Cjir+WO7JlUaNnITlZSyXndH1dvFK1jDR+wSFD
         wO4vR85yT8qj/i1w9HNk4Ejw/MHb6kncv+4cqrKKmrxma0JyDi2CH8gG3gae9B13Zh
         gL4B7UP32/N9Q==
Date:   Wed, 4 Jan 2023 09:44:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net v2 2/3] ice: Fix deadlock on the rtnl_mutex
Message-ID: <Y7UuY1J9vk0gFCG+@unreal>
References: <20230103230738.1102585-1-anthony.l.nguyen@intel.com>
 <20230103230738.1102585-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103230738.1102585-3-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 03:07:37PM -0800, Tony Nguyen wrote:
> From: Mateusz Palczewski <mateusz.palczewski@intel.com>
> 
> There is a deadlock on rtnl_mutex when attempting to take the lock
> in unregister_netdev() after it has already been taken by
> ethnl_set_channels(). This happened when unregister_netdev() was
> called inside of ice_vsi_rebuild().
> Fix that by removing the unregister_netdev() usage and replace it with
> ice_vsi_clear_rings() that deallocates the tx and rx rings for the VSI.
> 
> Fixes: df0f847915b4 ("ice: Move common functions out of ice_main.c part 6/7")
> Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_lib.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
> index 94aa834cd9a6..22bcb414546a 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
> @@ -3619,12 +3619,10 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
>  err_vectors:
>  	ice_vsi_free_q_vectors(vsi);
>  err_rings:
> -	if (vsi->netdev) {
> -		vsi->current_netdev_flags = 0;
> -		unregister_netdev(vsi->netdev);
> -		free_netdev(vsi->netdev);
> -		vsi->netdev = NULL;
> -	}
> +	ice_vsi_clear_rings(vsi);
> +	set_bit(ICE_RESET_FAILED, pf->state);
> +	kfree(coalesce);
> +	return ret;
>  err_vsi:

This is very odd error unwind idiom only to perform:
if (something)
   ice_vsi_clear_rings(vsi);
else
   ice_vsi_clear(vsi);

Please avoid putting "return ..." and same code in the middle of goto unwind.

Thanks

>  	ice_vsi_clear(vsi);
>  	set_bit(ICE_RESET_FAILED, pf->state);
> -- 
> 2.38.1
> 
