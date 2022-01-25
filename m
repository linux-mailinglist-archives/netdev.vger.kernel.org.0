Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CA149B2F1
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 12:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344102AbiAYLbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 06:31:23 -0500
Received: from mga18.intel.com ([134.134.136.126]:46033 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346881AbiAYL3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 06:29:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643110149; x=1674646149;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lQrfEXVLGpaNR1bzpdDKi/OjamQdZz/E9VEBgcj+KlQ=;
  b=eIiqLz8Ql92mRqRbvelNLgsf4KB6+vNZhDm8/Mrxl6/lN/rtuSb+XZPX
   MLYhmXLB4AI7jz2ylrWLpwS7eqiMn4Bd8OT+5LStl0AhBeYFkMTOVCrzt
   GtRLqLvQ/71pAgg6x9r1FDXxU5Hn2rjTqYkN2OA7kR+ztunZcZI9FUS3b
   ZW1RabOtFTDy39uljBlDGYNhTHu3bOLKNBpZgYINtmo/uVKNVBXmkAi83
   X+WFz07vS85ocrRcax0qwi0Lx9GMaz0+QuHPyNW0KTxVKTPfZ46/ZqlGx
   G/S82bJb37qAzNDM39p77FbBjSca2g5H2NBRPAnwGiMXbiE78WE9Fy4GI
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="229854657"
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="229854657"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 03:28:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="494964994"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga002.jf.intel.com with ESMTP; 25 Jan 2022 03:28:52 -0800
Date:   Tue, 25 Jan 2022 12:28:52 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com
Subject: Re: [PATCH bpf-next v4 2/8] ice: xsk: force rings to be sized to
 power of 2
Message-ID: <Ye/e9GqLkuekqFos@boxer>
References: <20220124165547.74412-1-maciej.fijalkowski@intel.com>
 <20220124165547.74412-3-maciej.fijalkowski@intel.com>
 <20220125112306.746139-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125112306.746139-1-alexandr.lobakin@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 12:23:06PM +0100, Alexander Lobakin wrote:
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Date: Mon, 24 Jan 2022 17:55:41 +0100
> 
> > With the upcoming introduction of batching to XSK data path,
> > performance wise it will be the best to have the ring descriptor count
> > to be aligned to power of 2.
> > 
> > Check if rings sizes that user is going to attach the XSK socket fulfill
> > the condition above. For Tx side, although check is being done against
> > the Tx queue and in the end the socket will be attached to the XDP
> > queue, it is fine since XDP queues get the ring->count setting from Tx
> > queues.
> > 
> > Suggested-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_xsk.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
> > index 2388837d6d6c..0350f9c22c62 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
> > @@ -327,6 +327,14 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
> >  	bool if_running, pool_present = !!pool;
> >  	int ret = 0, pool_failure = 0;
> >  
> > +	if (!is_power_of_2(vsi->rx_rings[qid]->count) ||
> > +	    !is_power_of_2(vsi->tx_rings[qid]->count)) {
> > +		netdev_err(vsi->netdev,
> > +			   "Please align ring sizes at idx %d to power of 2\n", qid);
> 
> Ideally I'd pass xdp->extack from ice_xdp() to print this message
> directly in userspace (note that NL_SET_ERR_MSG{,_MOD}() don't
> support string formatting, but the user already knows QID at this
> point).

I thought about that as well but it seemed to me kinda off to have a
single extack usage in here. Updating the rest of error paths in
ice_xsk_pool_setup() to make use of extack is a candidate for a separate
patch to me.

WDYT?

> 
> > +		pool_failure = -EINVAL;
> > +		goto failure;
> > +	}
> > +
> >  	if_running = netif_running(vsi->netdev) && ice_is_xdp_ena_vsi(vsi);
> >  
> >  	if (if_running) {
> > @@ -349,6 +357,7 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
> >  			netdev_err(vsi->netdev, "ice_qp_ena error = %d\n", ret);
> >  	}
> >  
> > +failure:
> >  	if (pool_failure) {
> >  		netdev_err(vsi->netdev, "Could not %sable buffer pool, error = %d\n",
> >  			   pool_present ? "en" : "dis", pool_failure);
> > -- 
> > 2.33.1
> 
> Thanks,
> Al
