Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2B56D8B55
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 02:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbjDFAAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 20:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbjDFAAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 20:00:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E2A7AA7
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 17:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69C0264131
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 00:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D518C433D2;
        Thu,  6 Apr 2023 00:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680739211;
        bh=adpXKpFzIcwzFZL3VggpO3JXGfmYDPgocAoA5cINAgo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IfMZJlcN4u09OfK/vB8ECSKL1m9lu3vu4BS83+ZVPqo2cRTOiA8kR04HVWUzi+E3V
         R/SHCoLVDD1XcCF5TbgZqRpkbj5Db+lVqWf5zsxWFvtU4UutRKywX8YJj2Po99zpRv
         FcUxk/B1b/J0IEcPAS7OkRzOWKTKhS/OOjEM0r8B/4c1zujtsQf3rJtuuITBPNSpws
         OxZiG40O7b/0JhXjll31wIupt0TvjYPgp8YtOFo91msw8Sasj3LsvlEC8FYtv9/k5U
         4814ugM9ovFmHL3bpLtrWJuBqj1JhPWOQ9nZ6Dekwuay+RU2dOLQyhnF+x4eSxI/eb
         /3EeyYXsu2E8g==
Date:   Wed, 5 Apr 2023 17:00:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Maxim Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v3 3/5] Add ndo_hwtstamp_get/set support to vlan
 code path
Message-ID: <20230405170010.1c989a8f@kernel.org>
In-Reply-To: <20230405180121.cefhbjlejuisywhk@skbuf>
References: <20230405063323.36270-1-glipus@gmail.com>
        <20230405094210.32c013a7@kernel.org>
        <20230405170322.epknfkxdupctg6um@skbuf>
        <20230405101323.067a5542@kernel.org>
        <20230405172840.onxjhr34l7jruofs@skbuf>
        <20230405104253.23a3f5de@kernel.org>
        <20230405180121.cefhbjlejuisywhk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Apr 2023 21:01:21 +0300 Vladimir Oltean wrote:
> - bonding is also DSA master when it has a DSA master as lower, so the
>   DSA master restriction has already run once - on the bonding device
>   itself

Huh, didn't know that.

> > The latter could be used for the first descend as well I'd presume.
> > And it can be exported for the use of more complex drivers like
> > bonding which want to walk the lowers themselves.
> >   
> > > - it requires cfg.flags & HWTSTAMP_FLAG_BONDED_PHC_INDEX to be set in
> > >   SET requests
> > > 
> > > - it sets cfg.flags | HWTSTAMP_FLAG_BONDED_PHC_INDEX in GET responses  
> > 
> > IIRC that was to indicate to user space that the real PHC may change
> > for this netdev so it needs to pay attention to netlink notifications.
> > Shouldn't apply to *vlans?  
> 
> No, this shouldn't apply to *vlans, but I didn't suggest that it should.

Good, so if we just target *vlans we don't have to worry.

> I don't think my proposal was clear enough, so here's some code
> (untested, written in email client).
> 
> static int macvlan_hwtstamp_get(struct net_device *dev,
> 				struct kernel_hwtstamp_config *cfg,
> 				struct netlink_ext_ack *extack)
> {
> 	struct net_device *real_dev = macvlan_dev_real_dev(dev);
> 
> 	return generic_hwtstamp_get_lower(real_dev, cfg, extack);
> }
> 
> static int macvlan_hwtstamp_set(struct net_device *dev,
> 				struct kernel_hwtstamp_config *cfg,
> 				struct netlink_ext_ack *extack)
> {
> 	struct net_device *real_dev = macvlan_dev_real_dev(dev);
> 
> 	return generic_hwtstamp_set_lower(real_dev, cfg, extack);
> }
> 
> static int vlan_hwtstamp_get(struct net_device *dev,
> 			     struct kernel_hwtstamp_config *cfg,
> 			     struct netlink_ext_ack *extack)
> {
> 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
> 
> 	return generic_hwtstamp_get_lower(real_dev, cfg, extack);
> }
> 
> static int vlan_hwtstamp_set(struct net_device *dev,
> 			     struct kernel_hwtstamp_config *cfg,
> 			     struct netlink_ext_ack *extack)
> {
> 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
> 
> 	return generic_hwtstamp_set_lower(real_dev, cfg, extack);
> }

I got that, but why wouldn't this not be better, as it avoids 
the 3 driver stubs? (also written in the MUA)

int net_lower_hwtstamp_set(struct net_device *dev,
			   struct kernel_hwtstamp_config *cfg,
			   struct netlink_ext_ack *extack)
{
	struct list_head *iter = dev->adj_list.lower.next;
	struct net_device *lower;
	
	lower = netdev_lower_get_next(dev, &iter);
	return generic_hwtstamp_set_lower(lower, cfg, extack);
}

> static int bond_hwtstamp_get(struct net_device *bond_dev,
> 			     struct kernel_hwtstamp_config *cfg,
> 			     struct netlink_ext_ack *extack)
> {
> 	struct bonding *bond = netdev_priv(bond_dev);
> 	struct net_device *real_dev = bond_option_active_slave_get_rcu(bond);
> 	int err;
> 
> 	if (!real_dev)
> 		return -EOPNOTSUPP;
> 
> 	err = generic_hwtstamp_get_lower(real_dev, cfg, extack);
> 	if (err)
> 		return err;
> 
> 	/* Set the BOND_PHC_INDEX flag to notify user space */
> 	cfg->flags |= HWTSTAMP_FLAG_BONDED_PHC_INDEX;
> 
> 	return 0;
> }
> 
> static int bond_hwtstamp_set(struct net_device *bond_dev,
> 			     struct kernel_hwtstamp_config *cfg,
> 			     struct netlink_ext_ack *extack)
> {
> 	struct bonding *bond = netdev_priv(bond_dev);
> 	struct net_device *real_dev = bond_option_active_slave_get_rcu(bond);
> 	int err;
> 
> 	if (!real_dev)
> 		return -EOPNOTSUPP;
> 
> 	if (!(cfg->flags & HWTSTAMP_FLAG_BONDED_PHC_INDEX))
> 		return -EOPNOTSUPP;
> 
> 	return generic_hwtstamp_set_lower(real_dev, cfg, extack);
> }
> 
> Doesn't seem in any way necessary to complicate things with the netdev
> adjacence lists?

What is the complication? We can add a "get first" helper maybe to hide
the oddities of the linking.

> > Yes, user space must be involved anyway, because the entire clock will
> > change. IMHO implementing the pass thru for timestamping requests on
> > bonding is checkbox engineering, kernel can't make it work
> > transparently. But nobody else spoke up when it was proposed so...  
> 
> ok, but that's a bit beside the point here.

You cut off the quote it was responding to so IDK if it is.
