Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF86865ECD4
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 14:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjAENUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 08:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233893AbjAENU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 08:20:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC9F63D06
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 05:19:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F9F0B81ABD
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFB7C433EF;
        Thu,  5 Jan 2023 13:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672924743;
        bh=oeiqTX+YktoVuCEksUYADqphwlZpszjcAzOZO0MUgZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a6mlhy57XL4NNdsfanSq8y9rXhWOQTlnSPehyeCmIZ+/cmcDmQliInZEyi2t7syr1
         qan+Kt132Hwei+/NPSla1LoVHJSAEWi9zXfQd+x9KLqrwC4Pip+0XBStSdgu3/VdAJ
         kBElWcf4WFdaISl8v6Xo3FxS/OCwTAHIAJ9xSQ1jB43hB6mEvNdVH7yflG108qTyxG
         C7jLnzNJyn0dNZ3pY9ZaUdcwkIIPabzzE1U7+HMid1pkMRO5plNpTJrXmrHvPKHuzf
         WlSAv1qIgwZlJl+S1RZPSd497E0hmODfbijcjD0/LiYWiXoljpbhr5LTPPsVggeTIn
         r3A96+7j7V+6Q==
Date:   Thu, 5 Jan 2023 15:18:58 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Mateusz Palczewski <mateusz.palczewski@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] ice: Fix deadlock on the rtnl_mutex
Message-ID: <Y7bOQoFJQUhsB1kC@unreal>
References: <20230105120518.29776-1-mateusz.palczewski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105120518.29776-1-mateusz.palczewski@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 07:05:18AM -0500, Mateusz Palczewski wrote:
> There is a deadlock on rtnl_mutex when attempting to take the lock
> in unregister_netdev() after it has already been taken by
> ethnl_set_channels(). This happened when unregister_netdev() was
> called inside of ice_vsi_rebuild().
> Fix that by removing the unregister_netdev() usage and replace it with
> ice_vsi_clear_rings() that deallocates the tx and rx rings for the VSI.
> 
> Fixes: df0f847915b4 ("ice: Move common functions out of ice_main.c part 6/7")
> Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
> ---
>  v2: Fixed goto unwind to remove code redundancy
> ---
>  drivers/net/ethernet/intel/ice/ice_lib.c | 35 ++++++++++++------------
>  1 file changed, 17 insertions(+), 18 deletions(-)
> 

I think that it will be beneficial to have lockdep trace in commit message too.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
