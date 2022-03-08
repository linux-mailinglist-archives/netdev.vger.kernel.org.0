Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FBB4D185E
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 13:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbiCHMzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 07:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiCHMzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 07:55:21 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E134E473B7;
        Tue,  8 Mar 2022 04:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646744064; x=1678280064;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0T14saHEBTpCKfGqSe8NbuOhFvGpALcbihrkiXvDH9c=;
  b=iz3QlAKxiHsYCquHvqZHAaRs9TrkLJ0cm5TaZZ03CJiojYrLZMm75qYO
   5CT0+DulNjzxl6M8NugnF7u6knhLTOBhxj2AGMg2OqWGHPmt4ESv1Bhnu
   ecSHDgZm5Sd1KmsDTqQChTr+6Ee56EA2MwbUVXYPlTWvxse9Mae3zy/Fc
   ddQXvE8Uw2R+X2hpCaeJ4OvrdrKDrBuKtWySovJlqwAs8Ai+t0xxMmlXQ
   Yhgm3obJecNlAut6akgZDqsqTjftajyIMTFHTnblPRGJFXHsY7UUpVJ9x
   +9BMD/FDC4daDTd2ZitC9x0GFnBjaE33NqAFJmi77X49UZDw2DBsfaOHE
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="341106621"
X-IronPort-AV: E=Sophos;i="5.90,164,1643702400"; 
   d="scan'208";a="341106621"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 04:54:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,164,1643702400"; 
   d="scan'208";a="687910697"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 08 Mar 2022 04:54:22 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 228CsL1V001091;
        Tue, 8 Mar 2022 12:54:21 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, anthony.l.nguyen@intel.com, kuba@kernel.org,
        davem@davemloft.net, magnus.karlsson@intel.com,
        dan.carpenter@oracle.com
Subject: Re: [PATCH intel-net] ice: fix NULL pointer dereference in ice_update_vsi_tx_ring_stats()
Date:   Tue,  8 Mar 2022 13:51:59 +0100
Message-Id: <20220308125159.1843373-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307174739.55899-1-maciej.fijalkowski@intel.com>
References: <20220307174739.55899-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Mon, 7 Mar 2022 18:47:39 +0100

> It is possible to do NULL pointer dereference in routine that updates
> Tx ring stats. Currently only stats and bytes are updated when ring
> pointer is valid, but later on ring is accessed to propagate gathered Tx
> stats onto VSI stats.
> 
> Change the existing logic to move to next ring when ring is NULL.
> 
> Fixes: e72bba21355d ("ice: split ice_ring onto Tx/Rx separate structs")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index 289e5c99e313..d3f8b6468b92 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -6145,8 +6145,9 @@ ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi,
>  		u64 pkts = 0, bytes = 0;
>  
>  		ring = READ_ONCE(rings[i]);
> -		if (ring)
> -			ice_fetch_u64_stats_per_ring(&ring->syncp, ring->stats, &pkts, &bytes);
> +		if (!ring)
> +			continue;
> +		ice_fetch_u64_stats_per_ring(&ring->syncp, ring->stats, &pkts, &bytes);

Nice catch, thanks!

Acked-by: Alexander Lobakin <alexandr.lobakin@intel.com>

>  		vsi_stats->tx_packets += pkts;
>  		vsi_stats->tx_bytes += bytes;
>  		vsi->tx_restart += ring->tx_stats.restart_q;

                                   ^^^^
                                   lol

> -- 
> 2.33.1

Al
