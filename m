Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76AD5514B9
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 11:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240490AbiFTJsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 05:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239832AbiFTJsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 05:48:07 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B153892;
        Mon, 20 Jun 2022 02:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655718485; x=1687254485;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SaxizaGeV3EDQH4H5D12KU07TO02a3FkIdTLP1NdAzE=;
  b=eWFnAvWFaN6tLv7EdwosJ4MVQiOO3rMCJLNscMEwp8e8Y0vnf911ZRBR
   U0Kr703JnxQoGH+zVbtLuFGfIu22MGXo+D3BGH+6Xln+4gwJogb0CqFgV
   XRe2Y/tvNj6trLaeGssVHek7krFrFeIw8G7yulhzeFDSwKSPYQXYsbOaw
   T9UTZ8dQKGXd8bQLDzLYIpHN7rtPjeOyk44AX7xfi6hWZLURY50vzjOQu
   KashQq1n1TtPD5TPbcJnJom/B9O+uIV38qboxiW8w8jAfh4h4eKmrHPxO
   LZ5epEv9zVWiuB+WFBm1v+d6RUZo+iqGPs/XGp3ilJiEsT0OV24bGaubm
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="280909475"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="280909475"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 02:48:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="537605369"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga003.jf.intel.com with ESMTP; 20 Jun 2022 02:48:03 -0700
Date:   Mon, 20 Jun 2022 11:48:02 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org,
        Alexandr Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH v4 bpf-next 01/10] ice: compress branches in
 ice_set_features()
Message-ID: <YrBCUqE3iL1xDtjN@boxer>
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
 <20220616180609.905015-2-maciej.fijalkowski@intel.com>
 <62ad2e7b9ff11_24b342081a@john.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62ad2e7b9ff11_24b342081a@john.notmuch>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 06:46:35PM -0700, John Fastabend wrote:
> Maciej Fijalkowski wrote:
> > Instead of rather verbose comparison of current netdev->features bits vs
> > the incoming ones from user, let us compress them by a helper features
> > set that will be the result of netdev->features XOR features. This way,
> > current, extensive branches:
> > 
> > 	if (features & NETIF_F_BIT && !(netdev->features & NETIF_F_BIT))
> > 		set_feature(true);
> > 	else if (!(features & NETIF_F_BIT) && netdev->features & NETIF_F_BIT)
> > 		set_feature(false);
> > 
> > can become:
> > 
> > 	netdev_features_t changed = netdev->features ^ features;
> > 
> > 	if (changed & NETIF_F_BIT)
> > 		set_feature(!!(features & NETIF_F_BIT));
> > 
> > This is nothing new as currently several other drivers use this
> > approach, which I find much more convenient.
> 
> Looks good couple nits below. Up to you if you want to follow through
> on them or not I don't have a strong opinion. For what its worth the
> other intel drivers also do the 'netdev->features ^ features'
> assignment.
> 
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> 
> > 
> > CC: Alexandr Lobakin <alexandr.lobakin@intel.com>
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_main.c | 40 +++++++++++------------
> >  1 file changed, 19 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> > index e1cae253412c..23d1b1fc39fb 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > @@ -5910,44 +5910,41 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
> >  static int
> >  ice_set_features(struct net_device *netdev, netdev_features_t features)
> >  {
> > +	netdev_features_t changed = netdev->features ^ features;
> >  	struct ice_netdev_priv *np = netdev_priv(netdev);
> >  	struct ice_vsi *vsi = np->vsi;
> >  	struct ice_pf *pf = vsi->back;
> >  	int ret = 0;
> >  
> >  	/* Don't set any netdev advanced features with device in Safe Mode */
> > -	if (ice_is_safe_mode(vsi->back)) {
> > -		dev_err(ice_pf_to_dev(vsi->back), "Device is in Safe Mode - not enabling advanced netdev features\n");
> > +	if (ice_is_safe_mode(pf)) {
> > +		dev_err(ice_pf_to_dev(vsi->back),
> 
> bit of nitpicking but if you use pf in the 'if' above why not use it here
> as well and save a few keys. Also matches below then.

Hey John thanks for all of the input!
You're right above, I just forgot to change it to use 'pf' in
ice_pf_to_dev(). Will fix.

> 
> > +			"Device is in Safe Mode - not enabling advanced netdev features\n");
> >  		return ret;
> >  	}
> >  
> >  	/* Do not change setting during reset */
> >  	if (ice_is_reset_in_progress(pf->state)) {
> > -		dev_err(ice_pf_to_dev(vsi->back), "Device is resetting, changing advanced netdev features temporarily unavailable.\n");
> > +		dev_err(ice_pf_to_dev(pf),
> > +			"Device is resetting, changing advanced netdev features temporarily unavailable.\n");
> >  		return -EBUSY;
> >  	}
> >  
> 
> [...]
> 
> > @@ -5956,11 +5953,12 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
> >  		return -EACCES;
> >  	}
> >  
> > -	if ((features & NETIF_F_HW_TC) &&
> > -	    !(netdev->features & NETIF_F_HW_TC))
> > -		set_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
> > -	else
> > -		clear_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
> > +	if (changed & NETIF_F_HW_TC) {
> > +		bool ena = !!(features & NETIF_F_HW_TC);
> > +
> > +		ena ? set_bit(ICE_FLAG_CLS_FLOWER, pf->flags) :
> > +		      clear_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
> > +	}
> 
> Just a note you changed the logic slightly here. Above you always
> clear the bit. But, it looks like it doesn't matter caveat being
> I don't know what might happen in hardware.

I believe that previous logic was wrong due to the fact that in case
NETIF_F_HW_TC was set but in current ice_set_features() was not modified
then this setting would be lost.

> 
> >  
> >  	return 0;
> >  }
> > -- 
> > 2.27.0
> > 
> 
> 
