Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED592D0619
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 17:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgLFQuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 11:50:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:48956 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbgLFQuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 11:50:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 97253ADF8;
        Sun,  6 Dec 2020 16:49:24 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 56AD360344; Sun,  6 Dec 2020 17:49:24 +0100 (CET)
Date:   Sun, 6 Dec 2020 17:49:24 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Limin Wang <lwang.nbl@gmail.com>
Subject: Re: LRO: creating vlan subports affects parent port's LRO settings
Message-ID: <20201206164924.baczz7eyxz6czro2@lion.mk-sys.cz>
References: <CACpdL32SRKb8hXzuF_APybip+hyxkXRYoxCW_OMhn0odRSQKuw@mail.gmail.com>
 <20201123162639.5d692198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKfmpSdv5onOGk=VtEO1fWxxhaVvi96Tz-wCFcNE5R9cdXNgkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfmpSdv5onOGk=VtEO1fWxxhaVvi96Tz-wCFcNE5R9cdXNgkg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 05, 2020 at 07:04:06PM -0500, Jarod Wilson wrote:
> On Mon, Nov 23, 2020 at 7:27 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 19 Nov 2020 20:37:27 -0500 Limin Wang wrote:
> > > Under relatively recent kernels (v4.4+), creating a vlan subport on a
> > > LRO supported parent NIC may turn LRO off on the parent port and
> > > further render its LRO feature practically unchangeable.
> >
> > That does sound like an oversight in commit fd867d51f889 ("net/core:
> > generic support for disabling netdev features down stack").
> >
> > Are you able to create a patch to fix this?
> 
> Something like this, perhaps? Completely untested copy-pasta'd
> theoretical patch:
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 8588ade790cb..a5ce372e02ba 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9605,8 +9605,10 @@ int __netdev_update_features(struct net_device *dev)
>         features = netdev_fix_features(dev, features);
> 
>         /* some features can't be enabled if they're off on an upper device */
> -       netdev_for_each_upper_dev_rcu(dev, upper, iter)
> -               features = netdev_sync_upper_features(dev, upper, features);
> +       netdev_for_each_upper_dev_rcu(dev, upper, iter) {
> +               if (netif_is_lag_master(upper) || netif_is_bridge_master(upper))
> +                       features = netdev_sync_upper_features(dev,
> upper, features);
> +       }
> 
>         if (dev->features == features)
>                 goto sync_lower;
> @@ -9633,8 +9635,10 @@ int __netdev_update_features(struct net_device *dev)
>         /* some features must be disabled on lower devices when disabled
>          * on an upper device (think: bonding master or bridge)
>          */
> -       netdev_for_each_lower_dev(dev, lower, iter)
> -               netdev_sync_lower_features(dev, lower, features);
> +       if (netif_is_lag_master(dev) || netif_is_bridge_master(dev)) {
> +               netdev_for_each_lower_dev(dev, lower, iter)
> +                       netdev_sync_lower_features(dev, lower, features);
> +       }
> 
>         if (!err) {
>                 netdev_features_t diff = features ^ dev->features;
> 
> I'm not sure what all other upper devices this excludes besides just
> vlan ports though, so perhaps safer add upper device types to not do
> feature sync on than to choose which ones to do them on?

I'm not sure excluding devices from feature sync is the right way,
whether it's an explicit list types or default. The logic still makes
sense to me. Couldn't we address the issue by either setting features in
NETIF_F_UPPER_DISABLES) by default for a new vlan (and probably macvlan)
device? Or perhaps inheriting their values from the lower device.

Michal
