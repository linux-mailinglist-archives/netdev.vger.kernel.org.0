Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C8354CDE1
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 18:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348491AbiFOQL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 12:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348378AbiFOQLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 12:11:24 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673523525F;
        Wed, 15 Jun 2022 09:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655309483; x=1686845483;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IOVsDvWU65jSPs68nN4cdxBI0c0++5XZhoJUtcv5tXo=;
  b=FvNZdaBJCQ/4SQcf5HgF7omBAF9HPo9D8RF4rhb6D8oE41DEfUwwltRg
   kPMBKmco3XZ/B6f7hrgZz1PGTOVGfXwfJ8PSkAQxnWRKyCWFchjZKtamu
   GR1dmtxc34NNoNgcJ2v+CEdU3sB84e8uMlacZwtWBib7bQlKn3/g2J9YP
   XSNdm8J9tO9ahpOSygiQgrMiD4/ltJOCT8dfISRUE3G9IM4jfDP5nzP4+
   1zaBVoRAJokbXRuedYGd3T3fWBe+ItCDD7s52+x04kEUdqBIHdb+KwPgX
   guDg0exNwfBroWqs5ethOey4tLmfmybgYMxmkrHlvI+dm0d/4bxOzt8if
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="262036508"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="262036508"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 09:09:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="687380626"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga002.fm.intel.com with ESMTP; 15 Jun 2022 09:09:07 -0700
Date:   Wed, 15 Jun 2022 18:09:06 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com, bjorn@kernel.org
Subject: Re: [PATCH v2 bpf-next 01/10] ice: allow toggling loopback mode via
 ndo_set_features callback
Message-ID: <YqoEIii+rFgH10sU@boxer>
References: <20220614174749.901044-1-maciej.fijalkowski@intel.com>
 <20220614174749.901044-2-maciej.fijalkowski@intel.com>
 <20220615103804.1260221-1-alexandr.lobakin@intel.com>
 <YqnmTUpTgquVOsP5@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqnmTUpTgquVOsP5@boxer>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 04:01:51PM +0200, Maciej Fijalkowski wrote:
> On Wed, Jun 15, 2022 at 12:38:04PM +0200, Alexander Lobakin wrote:
> > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > Date: Tue, 14 Jun 2022 19:47:40 +0200
> > 
> > > Add support for NETIF_F_LOOPBACK. Also, simplify checks throughout whole
> > > ice_set_features().
> > > 
> > > CC: Alexandr Lobakin <alexandr.lobakin@intel.com>
> > > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > ---
> > >  drivers/net/ethernet/intel/ice/ice_main.c | 54 ++++++++++++++---------
> > >  1 file changed, 34 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> > > index e1cae253412c..ab00b0361e87 100644
> > > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > > @@ -3358,6 +3358,7 @@ static void ice_set_netdev_features(struct net_device *netdev)
> > >  	netdev->features |= netdev->hw_features;
> > >  
> > >  	netdev->hw_features |= NETIF_F_HW_TC;
> > > +	netdev->hw_features |= NETIF_F_LOOPBACK;
> > >  
> > >  	/* encap and VLAN devices inherit default, csumo and tso features */
> > >  	netdev->hw_enc_features |= dflt_features | csumo_features |
> > > @@ -5902,6 +5903,18 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
> > >  	return 0;
> > >  }
> > >  
> > > +static void ice_set_loopback(struct ice_pf *pf, struct net_device *netdev, bool ena)
> > 
> > I feel like the first argument is redundant in here since we can do
> > 
> > 	const struct ice_netdev_priv *np = netdev_priv(netdev);
> > 	struct ice_pf *pf = np->vsi->back;
> > 
> > But at the same time one function argument can be cheaper than two
> > jumps, so up to you.
> > 
> > > +{
> > > +	bool if_running = netif_running(netdev);
> > > +
> > > +	if (if_running)
> > > +		ice_stop(netdev);
> > > +	if (ice_aq_set_mac_loopback(&pf->hw, ena, NULL))
> > > +		dev_err(ice_pf_to_dev(pf), "Failed to toggle loopback state\n");
> > 
> > netdev_err() instead probably? I guess dev_err() is used for
> > consistency with the rest of ice_set_features(), but I'd recommend
> > using the former anyways.
> 
> So let's use netdev_err and drop the pf from arguments that are passed

brain fart, we need ice_hw ptr for ice_aq_set_mac_loopback(), so i'll pass
this then.

> 
> > 
> > > +	if (if_running)
> > > +		ice_open(netdev);
> > > +}
> > > +

(...)
