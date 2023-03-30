Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C276D0E31
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbjC3S5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbjC3S5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:57:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95860CDF9
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:57:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37F8FB829FD
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 18:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF57C433EF;
        Thu, 30 Mar 2023 18:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680202621;
        bh=4RJd1IdA2kR1huaXVwlSHJWvCwTUzJg0W7oHFZRnCdU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Owq50qmbooXe0kWqCFfpJKy6yXai8+QLEC6giwK97VrJgB9TZtUKRbhpCbtGwe/OV
         GuZkrMM03LnSIILULbt0afu+iU50Ao8c0MdQK099rTf0QmAKVg7e3mWZHGPcCrrzr9
         L47dUJEQwcBC9kdQQtFgBJs331hx+o+y/po9dcO3Wg6Xzqr/+DUKYySu8tzFgNOiXX
         4GnvBHMOcbA3CIXZk+tuFpbeq5YVbVfTvK7A0rGHgN3q2RAXcLXWiGgoFxNCtqKQuJ
         kXGOif550CZUQ7rwm+7YWhoZg+RBKoAABgpYOrYHKEwaDt6bW54AZkV9I3Ql35upGD
         ZDASljLGH8o6Q==
Date:   Thu, 30 Mar 2023 21:56:56 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Emeel Hakim <ehakim@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Message-ID: <20230330185656.GZ831478@unreal>
References: <20230329122107.22658-1-ehakim@nvidia.com>
 <20230329122107.22658-2-ehakim@nvidia.com>
 <ZCROr7DhsoRyU1qP@hog>
 <20230329184201.GB831478@unreal>
 <ZCXEmUQgswOBoRqR@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCXEmUQgswOBoRqR@hog>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 07:19:21PM +0200, Sabrina Dubroca wrote:
> 2023-03-29, 21:42:01 +0300, Leon Romanovsky wrote:
> > On Wed, Mar 29, 2023 at 04:43:59PM +0200, Sabrina Dubroca wrote:
> > > 2023-03-29, 15:21:04 +0300, Emeel Hakim wrote:
> > > > Add support for MACsec offload operations for VLAN driver
> > > > to allow offloading MACsec when VLAN's real device supports
> > > > Macsec offload by forwarding the offload request to it.
> > > > 
> > > > Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
> > > > ---
> > > > V1 -> V2: - Consult vlan_features when adding NETIF_F_HW_MACSEC.
> > > 
> > > Uh? You're not actually doing that? You also dropped the
> > > changes to vlan_dev_fix_features without explaining why.
> > 
> > vlan_dev_fix_features() relies on real_dev->vlan_features which was set
> > in mlx5 part of this patch.
> > 
> >   643 static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
> >   644         netdev_features_t features)
> >   645 {
> >   ...
> >   649
> >   650         lower_features = netdev_intersect_features((real_dev->vlan_features |
> >   651                                                     NETIF_F_RXCSUM),
> >   652                                                    real_dev->features);
> > 
> > This part ensure that once real_dev->vlan_features and real_dev->features have NETIF_F_HW_MACSEC,
> > the returned features will include NETIF_F_HW_MACSEC too.
> 
> Ok, thanks.
> 
> But back to the issue of vlan_features, in vlan_dev_init: I'm not
> convinced NETIF_F_HW_MACSEC should be added to hw_features based on
> ->features. That would result in a new vlan device that can't offload
> macsec at all if it was created at the wrong time (while the lower
> device's macsec offload was temporarily disabled). 

Sorry, I'm new to this netdev features zoo, but if I read correctly 
Documentation/networking/netdev-features.rst, the ->features is the list
of enabled ones:

   29  2. netdev->features set contains features which are currently enabled
   30     for a device.  This should be changed only by network core or in
   31     error paths of ndo_set_features callback.

And user will have a chance to disable it for VLAN because it was added
to ->hw_features:

   24  1. netdev->hw_features set contains features whose state may possibly
   25     be changed (enabled or disabled) for a particular device by user's
   26     request.  This set should be initialized in ndo_init callback and not
   27     changed later.

So how can VLAN be created with NETIF_F_HW_MACSEC while real_dev mcasec
offload is disabled?

> AFAIU, vlandev->hw_features should be based on realdev->vlan_features. 

Is this macsec offloaded VLAN can be called "child VLAN device"?

   33  3. netdev->vlan_features set contains features whose state is inherited
   34     by child VLAN devices (limits netdev->features set).  This is currently
   35     used for all VLAN devices whether tags are stripped or inserted in
   36     hardware or software.

> I don't see a reason to advertise a feature in the vlan device if we
> won't ever be able to turn it on because it's not in ->vlan_features
> ("grmbl why can't I enable it, ethtool says it's here?!").
> 
> 
> Emeel, I'm not a maintainer, but I don't think you should be reposting
> until the existing discussion has settled down.
> 
> > > 
> > > [...]
> > > > @@ -572,6 +573,9 @@ static int vlan_dev_init(struct net_device *dev)
> > > >  			   NETIF_F_HIGHDMA | NETIF_F_SCTP_CRC |
> > > >  			   NETIF_F_ALL_FCOE;
> > > >  
> > > > +	if (real_dev->features & NETIF_F_HW_MACSEC)
> > > > +		dev->hw_features |= NETIF_F_HW_MACSEC;
> > > > +
> > > >  	dev->features |= dev->hw_features | NETIF_F_LLTX;
> > > >  	netif_inherit_tso_max(dev, real_dev);
> > > >  	if (dev->features & NETIF_F_VLAN_FEATURES)
> 
> -- 
> Sabrina
> 
