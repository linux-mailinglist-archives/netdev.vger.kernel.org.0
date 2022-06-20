Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474015514E9
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 11:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239727AbiFTJws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 05:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239208AbiFTJwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 05:52:43 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E2613E02;
        Mon, 20 Jun 2022 02:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655718763; x=1687254763;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jz6J8zx5qAS2kgB9qrwCYFPAGHMI/kxmUhA7Exg+caU=;
  b=S/i/f0AFJ8oSH0NOx7FGhliuNVkBSg338CdmEe5Dqs81rVcdCaQ+um05
   fpxd10Yai6SKXr76l63XrZBJn38hzxu2DSGpxL3gLBNqMJy5tNE97UJ8u
   1NWO5TJwKzw55WoCPsl0erc8EcYcyt6a0i/O4k8yQcfjBbe8RKA5LfudZ
   D/0JaAR9AMD/6vNZCoPlPGTbbH97W5MkL0w44mRWNMi4K7YfVIIKSMvH/
   NHQTDOORhD/3QGAPz9Fe6XpvctIjgQNGDRxXij8tR3N3R+vbSXtBSJPU9
   ti9sgyF2VX2qtob9fTLA7gwtZxCS3AcGo5UjFf+L1Z0Kee9NRQ2rfKMOy
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="280584019"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="280584019"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 02:52:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="561881894"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga006.jf.intel.com with ESMTP; 20 Jun 2022 02:52:21 -0700
Date:   Mon, 20 Jun 2022 11:52:20 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org,
        Alexandr Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH v4 bpf-next 02/10] ice: allow toggling loopback mode via
 ndo_set_features callback
Message-ID: <YrBDVBxjAHCTBw0w@boxer>
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
 <20220616180609.905015-3-maciej.fijalkowski@intel.com>
 <62ad3115619b0_24b342084c@john.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62ad3115619b0_24b342084c@john.notmuch>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 06:57:41PM -0700, John Fastabend wrote:
> Maciej Fijalkowski wrote:
> > Add support for NETIF_F_LOOPBACK. This feature can be set via:
> > $ ethtool -K eth0 loopback <on|off>
> > 
> > Feature can be useful for local data path tests.
> > 
> > CC: Alexandr Lobakin <alexandr.lobakin@intel.com>
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> 
> Patch looks fine one question about that ice_set_features() function
> though.
> 
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> 
> [...]
> 
> > +/**
> > + * ice_set_loopback - turn on/off loopback mode on underlying PF
> > + * @vsi: ptr to VSI
> > + * @ena: flag to indicate the on/off setting
> > + */
> > +static int
> > +ice_set_loopback(struct ice_vsi *vsi, bool ena)
> > +{
> > +	bool if_running = netif_running(vsi->netdev);
> > +	int ret;
> > +
> > +	if (if_running && !test_and_set_bit(ICE_VSI_DOWN, vsi->state)) {
> > +		ret = ice_down(vsi);
> > +		if (ret) {
> > +			netdev_err(vsi->netdev, "Preparing device to toggle loopback failed\n");
> > +			return ret;
> > +		}
> > +	}
> > +	ret = ice_aq_set_mac_loopback(&vsi->back->hw, ena, NULL);
> > +	if (ret)
> > +		netdev_err(vsi->netdev, "Failed to toggle loopback state\n");
> > +	if (if_running)
> > +		ret = ice_up(vsi);
> > +
> > +	return ret;
> > +}
> > +
> >  /**
> >   * ice_set_features - set the netdev feature flags
> >   * @netdev: ptr to the netdev being adjusted
> > @@ -5960,7 +5988,10 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
> >  		      clear_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
> >  	}
> >  
> > -	return 0;
> > +	if (changed & NETIF_F_LOOPBACK)
> > +		ret = ice_set_loopback(vsi, !!(features & NETIF_F_LOOPBACK));
> > +
> > +	return ret;
> 
> Unrelated to your patch, but because you are messing with 'ret' here a bit,
> how come you return 0 when ice_is_safe_mode() shouldn't you push that
> error up so the user who is doing the setting knows it didn't actually
> work?

Safe mode is the first thing checked in ice_set_features() and in case it
is set we give the message to user about it and return 0 immediately.

So did you miss the immediate exit or are you suggesting that for safe
mode we should return some error code, not 0 which is interpreted as
'successful' command execution?

> 
> >  }
> >  
> >  /**
> > -- 
> > 2.27.0
> > 
> 
> 
