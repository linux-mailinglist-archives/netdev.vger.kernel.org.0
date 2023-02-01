Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF62686329
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 10:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbjBAJwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 04:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbjBAJwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 04:52:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACD9474EF
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 01:52:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0212C6174E
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A8FC433D2;
        Wed,  1 Feb 2023 09:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675245159;
        bh=FL5Hc/psFJOez211nukTxziycK2h1ZhQugpsxiu4bUs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PI/ElzGv1NWnTzfXhzOrpdrqGQY1QLVT20cdN3GO+1tLv1B9rBaOE/Qhm7r4I1RgR
         MhONtQxkQ+ggH4w1W1J8fvY37acckmgL2qLGdt5YHrIEWp8RuBVb5Tm7cDdMk1YNCQ
         2WRTq+1GgldBVfuk944x1/cPm+3BK4B2sbXPveo1acwnTHcYzaP9t1DzKtGCQYL+by
         LyTyg4IOrtHu6MAV8xU3RmW3w9EUkY5Mtk9W0FF/lJT6midFqN0O9ieGmuCuNxwdAy
         1CPxznRd7/0eBS8UpNCOsjY7fRERo84jed13+8MA4mmWFTwhzclPxrgABf9N5ZRsuw
         32IPk8ejY4siQ==
Date:   Wed, 1 Feb 2023 11:52:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: Re: [PATCH net 5/6] ice: Fix off by one in ice_tc_forward_to_queue()
Message-ID: <Y9o2Y6wTSzhX+zAf@unreal>
References: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
 <20230131213703.1347761-6-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131213703.1347761-6-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 01:37:02PM -0800, Tony Nguyen wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
> 
> The > comparison should be >= to prevent reading one element beyond
> the end of the array.
> 
> The "vsi->num_rxq" is not strictly speaking the number of elements in
> the vsi->rxq_map[] array.  The array has "vsi->alloc_rxq" elements and
> "vsi->num_rxq" is less than or equal to the number of elements in the
> array.  The array is allocated in ice_vsi_alloc_arrays().  It's still
> an off by one but it might not access outside the end of the array.
> 
> Fixes: 143b86f346c7 ("ice: Enable RX queue selection using skbedit action")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Acked-by: Amritha Nambiar <amritha.nambiar@intel.com>
> Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_tc_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
