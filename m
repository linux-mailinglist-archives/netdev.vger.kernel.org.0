Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D97863EC2F
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 10:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiLAJTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 04:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLAJS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 04:18:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7027755AAF
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 01:18:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27488B81E6A
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 09:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB07C433D6;
        Thu,  1 Dec 2022 09:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669886334;
        bh=i6/eIbeI+RNnD8E5pw+ajxOfXqfBaqnj27TBZ59SLIA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lLS4b8XqCPwReq4za74bvFAPgIHaHHxL84RARZ2d/2Y3stwkXSZftiGGXnqHoD5/X
         gjViwkCqZy9ttlwt9dlMvfXs8ikvjI4oko+lLmZEaY4CPfWGTDf5De5fKMhrGMKPH3
         /ASyEa5nO/kf9tZh6Cu+Rb30DHiyykRPdmVHKjiY/BhhrG2j4NqWCwuTMxNnyiL/mg
         mALdL3p5Qa1CC1W2BBbC8SuT57Nm1GQAZZ1eVzJTzDLvYwhEjg0jLHGbjT1gxc0bTO
         UR12lSqeZlKACNIER2QpB3c+Ix59wSMinK2ARCZYlzfaNojBAGAlo8jcgX+MWYNhcm
         P6HJ0fHIRXFSA==
Date:   Thu, 1 Dec 2022 11:18:50 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next 08/14] ice: protect init and calibrating fields
 with spinlock
Message-ID: <Y4hxen0fOSVnXWbf@unreal>
References: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
 <20221130194330.3257836-9-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130194330.3257836-9-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 11:43:24AM -0800, Tony Nguyen wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> Ensure that the init and calibrating fields of the PTP Tx timestamp tracker
> structure are only modified under the spin lock. This ensures that the
> accesses are consistent and that new timestamp requests will either begin
> completely or get ignored.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_ptp.c | 55 ++++++++++++++++++++++--
>  drivers/net/ethernet/intel/ice/ice_ptp.h |  2 +-
>  2 files changed, 52 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
> index a7d950dd1264..0e39fed7cfca 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ptp.c
> +++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
> @@ -599,6 +599,42 @@ static u64 ice_ptp_extend_40b_ts(struct ice_pf *pf, u64 in_tstamp)
>  				     (in_tstamp >> 8) & mask);
>  }
>  
> +/**
> + * ice_ptp_is_tx_tracker_init - Check if the Tx tracker is initialized
> + * @tx: the PTP Tx timestamp tracker to check
> + *
> + * Check that a given PTP Tx timestamp tracker is initialized. Acquires the
> + * tx->lock spinlock.
> + */
> +static bool
> +ice_ptp_is_tx_tracker_init(struct ice_ptp_tx *tx)
> +{
> +	bool init;
> +
> +	spin_lock(&tx->lock);
> +	init = tx->init;
> +	spin_unlock(&tx->lock);
> +
> +	return init;

How this type of locking can be correct?
It doesn't protect anything and equal to do not have locking at all.

Thanks
