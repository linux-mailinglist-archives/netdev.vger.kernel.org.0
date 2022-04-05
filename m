Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7334E4F42F9
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242980AbiDEOXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386850AbiDEM6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 08:58:12 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C5DFA20E;
        Tue,  5 Apr 2022 05:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649160164; x=1680696164;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Em1VaGUrewSgKTmkX1bmv+/Hew0Z3wt3JfsEu2N6iYo=;
  b=apcWWOfJDkmpT6dOP/puv90eqqzcxbAS4mhmu2c0IqQOM2yYGfb9bEOm
   bDjRSBUbavPMaE+EP4eFGfRJPlNIyDKE6oJ9XoUb/LYPhn68E68lu9oZz
   vf5mA9x8hF9msnhNROnI4B9QoKK6R2rh6oh6VRZIgmsdZmgWhb0efG7zp
   gJ7f4wDLv+xQc1WypSTvCYHy/DhK8uLQa4/QsbxJ97BlZUv4No6xohWQN
   vc2JD+4FsnS6T/VCuLsNv0EEW1IY26BKwOtumHqsby9hJtPZy5GHer+yB
   /c24hvrFrJkSAx+MAb63bH6MEMHm1zNxCSiiqlwKbfhaikYg4D5wBXL/F
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="321425319"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="321425319"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 05:02:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="657909898"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 05 Apr 2022 05:02:40 -0700
Date:   Tue, 5 Apr 2022 14:02:39 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        netdev@vger.kernel.org, brouer@redhat.com, maximmi@nvidia.com
Subject: Re: [PATCH bpf-next 03/10] ice: xsk: terminate NAPI when XSK Rx
 queue gets full
Message-ID: <Ykwv36bPAkZOxdSl@boxer>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
 <20220405110631.404427-4-maciej.fijalkowski@intel.com>
 <20220405113403.3528655-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405113403.3528655-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 01:34:03PM +0200, Alexander Lobakin wrote:
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Date: Tue, 5 Apr 2022 13:06:24 +0200
> 
> > Correlate -ENOBUFS that was returned from xdp_do_redirect() with a XSK
> > Rx queue being full. In such case, terminate the softirq processing and
> > let the user space to consume descriptors from XSK Rx queue so that
> > there is room that driver can use later on.
> > 
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_txrx.h |  1 +
> >  drivers/net/ethernet/intel/ice/ice_xsk.c  | 25 +++++++++++++++--------
> >  2 files changed, 17 insertions(+), 9 deletions(-)
> 
> --- 8< ---
> 
> > @@ -551,15 +552,15 @@ ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
> >  		if (result == ICE_XDP_CONSUMED)
> >  			goto out_failure;
> >  		break;
> > +	case XDP_DROP:
> > +		result = ICE_XDP_CONSUMED;
> > +		break;
> >  	default:
> >  		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
> >  		fallthrough;
> >  	case XDP_ABORTED:
> >  out_failure:
> >  		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
> > -		fallthrough;
> > -	case XDP_DROP:
> > -		result = ICE_XDP_CONSUMED;
> >  		break;
> 
> So the result for %XDP_ABORTED will be %ICE_XDP_PASS now? Or I'm
> missing something :s

Yikes! I generally wanted to avoid the overwrite of result but still go
through the exception path.


Below should be fine if we add it to the current patch, but i'll double
check after the dinner.

Good catch as always, Alex :)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 143f6b6937bd..16c282b7050b 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -559,6 +559,7 @@ ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 		bpf_warn_invalid_xdp_action(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_ABORTED:
+		result = ICE_XDP_CONSUMED;
 out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		break;


> 
> >  	}
> >  
> > @@ -628,10 +629,16 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
> 
> --- 8< ---
> 
> > -- 
> > 2.33.1
> 
> Thanks,
> Al
