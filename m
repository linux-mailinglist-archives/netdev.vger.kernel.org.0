Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E91C6CD921
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjC2MIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjC2MIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:08:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D315E4213
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 05:08:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 599DE61CE1
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 12:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC14C433D2;
        Wed, 29 Mar 2023 12:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680091710;
        bh=UzGC6tDTDGUxeW0M1jO9gMpPLpE3rlP/JJe3/7xxkKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OKGu/Msox737VhZcfREaAlo01WEpPLn5i748jIQi8ItPgeHold7P/C/G+RiuIDcmL
         ldYhO+c7pqfHomSRR5T0wLGWxVeN8eEp6622wWhCviIAqCFkAmnhE/wJCdBPHYz9c/
         mTUQX1SHF6otJd4zbFPJjwQhyOozpv3/VqWuv68Sf5NprqYVAPSNyLnlowp+1b4Njq
         poiUCYTmV7/qsai948AnwTj5pFYStE4TQDfdqDZLBf5ZndzkdlXY/tOnF0VkUVdVQA
         jbvZVfgOnLKRhyxOb6p2ZB8cHG8jED9Bgcs1yAqRxkO64LV+5q5D1XPuTFxhARJAG0
         Dg1lR1sznnfdA==
Date:   Wed, 29 Mar 2023 15:08:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Jakob Koschel <jkl820.git@gmail.com>,
        Arpana Arland <arpanax.arland@intel.com>
Subject: Re: [PATCH net 4/4] ice: fix invalid check for empty list in
 ice_sched_assoc_vsi_to_agg()
Message-ID: <20230329120826.GR831478@unreal>
References: <20230328172035.3904953-1-anthony.l.nguyen@intel.com>
 <20230328172035.3904953-5-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328172035.3904953-5-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 10:20:35AM -0700, Tony Nguyen wrote:
> From: Jakob Koschel <jkl820.git@gmail.com>
> 
> The code implicitly assumes that the list iterator finds a correct
> handle. If 'vsi_handle' is not found the 'old_agg_vsi_info' was
> pointing to an bogus memory location. For safety a separate list
> iterator variable should be used to make the != NULL check on
> 'old_agg_vsi_info' correct under any circumstances.
> 
> Additionally Linus proposed to avoid any use of the list iterator
> variable after the loop, in the attempt to move the list iterator
> variable declaration into the macro to avoid any potential misuse after
> the loop. Using it in a pointer comparison after the loop is undefined
> behavior and should be omitted if possible [1].
> 
> Fixes: 37c592062b16 ("ice: remove the VSI info from previous agg")
> Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
> Signed-off-by: Jakob Koschel <jkl820.git@gmail.com>
> Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_sched.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
