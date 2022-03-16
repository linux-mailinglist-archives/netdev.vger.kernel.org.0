Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2745D4DA8E6
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 04:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353454AbiCPDa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 23:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353450AbiCPDa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 23:30:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4FC53981F
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 20:29:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C464B81883
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 03:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1D1C340E8;
        Wed, 16 Mar 2022 03:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647401383;
        bh=EHpUZOZEiSgdMUuvgTA3olgt22btU1Oo1nMY3jQFWTE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JL2mUiNAEXaAZVMoavqE8Vos3KjDznn/zqzTw1uxjuHAswsgaholCygLE7b9qAax3
         wyfE0t3mgfJtsgLXcSqGfgd+S977ieTx3i8ZEhyRzz8k3KuQXtlyo2WOR6MMqQWz/c
         QsxWAis5fj/qkqQ8hpE59vIQQItlZ2hz83FYfv5Vod5X8svctbpLoxf2oLMf0uAJKW
         w6RpVGOyjmzV1i9RaiH1xW3F3N6c1Md+0DWnBvk2JMm0J0BZD3tsuRFcrt6weSCgom
         w4PJNQ9VJN+q45BMjCUVu9SbmhP/tdXR3UHso4yiaisgSX9c908qs2gyqNuDtHwfI7
         VtQepUxVP300w==
Date:   Tue, 15 Mar 2022 20:29:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 1/3] ice: fix NULL pointer dereference in
 ice_update_vsi_tx_ring_stats()
Message-ID: <20220315202941.64319c5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220315211225.2923496-2-anthony.l.nguyen@intel.com>
References: <20220315211225.2923496-1-anthony.l.nguyen@intel.com>
        <20220315211225.2923496-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Mar 2022 14:12:23 -0700 Tony Nguyen wrote:
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> It is possible to do NULL pointer dereference in routine that updates
> Tx ring stats. Currently only stats and bytes are updated when ring

s/stats/packets/ ?

> pointer is valid, but later on ring is accessed to propagate gathered Tx
> stats onto VSI stats.
> 
> Change the existing logic to move to next ring when ring is NULL.
> 
> Fixes: e72bba21355d ("ice: split ice_ring onto Tx/Rx separate structs")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Acked-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index 493942e910be..d4a7c39fd078 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -5962,8 +5962,9 @@ ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi,
>  		u64 pkts = 0, bytes = 0;
>  
>  		ring = READ_ONCE(rings[i]);

Not really related to this patch but why is there a read_once() here?
Aren't stats read under rtnl_lock? What is this protecting against?

> -		if (ring)
> -			ice_fetch_u64_stats_per_ring(&ring->syncp, ring->stats, &pkts, &bytes);
> +		if (!ring)
> +			continue;
> +		ice_fetch_u64_stats_per_ring(&ring->syncp, ring->stats, &pkts, &bytes);
