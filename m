Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B004605F5
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 12:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236203AbhK1Ltv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 06:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244562AbhK1Lru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 06:47:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06FDC0613F4
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 03:43:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CAF760FC0
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 11:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3C0C004E1;
        Sun, 28 Nov 2021 11:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638099835;
        bh=soLv5LCBviCj3Y7A/CSeDw1o0EbpaON/cIftgxQOR2o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nZd7I1sEp3Vr3KMEFzOLzs5kSpAOM9GiOCz5j4yHzXzHALdWXyIEJ7r+TyHkz5234
         QAhzBlx5k7neGYL57V3VOQ90bFxPjaY9934K6m4VSYVMyyDRW3/aBkBpIwid4a04c7
         jNooBgb+FPx8YQICH9hi92jmnEjBWI6H4zWSKSa9AJN1yB0V6suyyDHVd85VdfXeN+
         VUGWYfyGMTXHPgzchADf+fPPXAzh/CAU/G4wo2EaSVhcikedmFuseEZshLCL/lVyAV
         qcF26FhgLoXjikAZsPxGnKxpRzhhpZWMhdow89pGOW8HvFKvoknTXoShkl3aYxTTIn
         3UUvC+acu5DCQ==
Date:   Sun, 28 Nov 2021 13:43:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next v3] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <YaNrd6+9V18ku+Vk@unreal>
References: <20211125165146.21298-1-lschlesinger@drivenets.com>
 <YaMwrajs8D5OJ3yS@unreal>
 <20211128111313.hjywmtmnipg4ul4f@kgollan-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211128111313.hjywmtmnipg4ul4f@kgollan-pc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 28, 2021 at 01:13:14PM +0200, Lahav Schlesinger wrote:
> On Sun, Nov 28, 2021 at 09:33:01AM +0200, Leon Romanovsky wrote:
> > CAUTION: External E-Mail - Use caution with links and attachments
> >
> >
> > On Thu, Nov 25, 2021 at 06:51:46PM +0200, Lahav Schlesinger wrote:
> > > Under large scale, some routers are required to support tens of thousands
> > > of devices at once, both physical and virtual (e.g. loopbacks, tunnels,
> > > vrfs, etc).
> > > At times such routers are required to delete massive amounts of devices
> > > at once, such as when a factory reset is performed on the router (causing
> > > a deletion of all devices), or when a configuration is restored after an
> > > upgrade, or as a request from an operator.
> > >
> > > Currently there are 2 means of deleting devices using Netlink:
> > > 1. Deleting a single device (either by ifindex using ifinfomsg::ifi_index,
> > > or by name using IFLA_IFNAME)
> > > 2. Delete all device that belong to a group (using IFLA_GROUP)
> > >
> > > Deletion of devices one-by-one has poor performance on large scale of
> > > devices compared to "group deletion":
> > > After all device are handled, netdev_run_todo() is called which
> > > calls rcu_barrier() to finish any outstanding RCU callbacks that were
> > > registered during the deletion of the device, then wait until the
> > > refcount of all the devices is 0, then perform final cleanups.
> > >
> > > However, calling rcu_barrier() is a very costly operation, each call
> > > taking in the order of 10s of milliseconds.
> > >
> > > When deleting a large number of device one-by-one, rcu_barrier()
> > > will be called for each device being deleted.
> > > As an example, following benchmark deletes 10K loopback devices,
> > > all of which are UP and with only IPv6 LLA being configured:
> > >
> > > 1. Deleting one-by-one using 1 thread : 243 seconds
> > > 2. Deleting one-by-one using 10 thread: 70 seconds
> > > 3. Deleting one-by-one using 50 thread: 54 seconds
> > > 4. Deleting all using "group deletion": 30 seconds
> > >
> > > Note that even though the deletion logic takes place under the rtnl
> > > lock, since the call to rcu_barrier() is outside the lock we gain
> > > some improvements.
> > >
> > > But, while "group deletion" is the fastest, it is not suited for
> > > deleting large number of arbitrary devices which are unknown a head of
> > > time. Furthermore, moving large number of devices to a group is also a
> > > costly operation.
> > >
> > > This patch adds support for passing an arbitrary list of ifindex of
> > > devices to delete with a new IFLA_IFINDEX_LIST attribute.
> > > This gives a more fine-grained control over which devices to delete,
> > > while still resulting in rcu_barrier() being called only once.
> > > Indeed, the timings of using this new API to delete 10K devices is
> > > the same as using the existing "group" deletion.
> > >
> > > The size constraints on the attribute means the API can delete at most
> > > 16382 devices in a single request.
> > >
> > > Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> > > ---
> > > v2 -> v3
> > >  - Rename 'ifindex_list' to 'ifindices', and pass it as int*
> > >  - Clamp 'ops' variable in second loop.
> > >
> > > v1 -> v2
> > >  - Unset 'len' of IFLA_IFINDEX_LIST in policy.
> > >  - Use __dev_get_by_index() instead of n^2 loop.
> > >  - Return -ENODEV if any ifindex is not present.
> > >  - Saved devices in an array.
> > >  - Fix formatting.
> > >
> > >  include/uapi/linux/if_link.h |  1 +
> > >  net/core/rtnetlink.c         | 50 ++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 51 insertions(+)
> > >
> > > diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> > > index eebd3894fe89..f950bf6ed025 100644
> > > --- a/include/uapi/linux/if_link.h
> > > +++ b/include/uapi/linux/if_link.h
> > > @@ -348,6 +348,7 @@ enum {
> > >       IFLA_PARENT_DEV_NAME,
> > >       IFLA_PARENT_DEV_BUS_NAME,
> > >
> > > +     IFLA_IFINDEX_LIST,
> > >       __IFLA_MAX
> > >  };
> > >
> > > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > > index fd030e02f16d..49d1a3954a01 100644
> > > --- a/net/core/rtnetlink.c
> > > +++ b/net/core/rtnetlink.c
> > > @@ -1880,6 +1880,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
> > >       [IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
> > >       [IFLA_NEW_IFINDEX]      = NLA_POLICY_MIN(NLA_S32, 1),
> > >       [IFLA_PARENT_DEV_NAME]  = { .type = NLA_NUL_STRING },
> > > +     [IFLA_IFINDEX_LIST]     = { .type = NLA_BINARY },
> > >  };
> > >
> > >  static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
> > > @@ -3050,6 +3051,52 @@ static int rtnl_group_dellink(const struct net *net, int group)
> > >       return 0;
> > >  }
> > >
> > > +static int rtnl_list_dellink(struct net *net, int *ifindices, int size)
> > > +{
> > > +     const int num_devices = size / sizeof(int);
> > > +     struct net_device **dev_list;
> > > +     LIST_HEAD(list_kill);
> > > +     int i, ret;
> > > +
> > > +     if (size <= 0 || size % sizeof(int))
> > > +             return -EINVAL;
> > > +
> > > +     dev_list = kmalloc_array(num_devices, sizeof(*dev_list), GFP_KERNEL);
> > > +     if (!dev_list)
> > > +             return -ENOMEM;
> > > +
> > > +     for (i = 0; i < num_devices; i++) {
> > > +             const struct rtnl_link_ops *ops;
> > > +             struct net_device *dev;
> > > +
> > > +             ret = -ENODEV;
> > > +             dev = __dev_get_by_index(net, ifindices[i]);
> > > +             if (!dev)
> > > +                     goto out_free;
> > > +
> > > +             ret = -EOPNOTSUPP;
> > > +             ops = dev->rtnl_link_ops;
> > > +             if (!ops || !ops->dellink)
> > > +                     goto out_free;
> >
> > I'm just curious, how does user know that specific device doesn't
> > have ->delink implementation? It is important to know because you
> > are failing whole batch deletion. At least for single delink, users
> > have chance to skip "failed" one and continue.
> >
> > Thanks
> 
> Hi Leon, I don't see any immediate way users can get this information.
> I do think that failing the whole request is better than silently
> ignoring such devices.

I don't have any preference here, probably "fail all" is the easiest
solution here.

Thanks

> 
> Perhaps an alternative is to return the unsupported device's name in an
> extack? To make NL_SET_ERR_MSG() support string formatting this will
> require changing netlink_ext_ack::_msg to be an array though (skimming
> over the calls to NL_SET_ERR_MSG(), a buffer of size say 128 should be
> large enough).
> 
> >
> > > +
> > > +             dev_list[i] = dev;
> > > +     }
> > > +
> > > +     for (i = 0; i < num_devices; i++) {
> > > +             struct net_device *dev = dev_list[i];
> > > +
> > > +             dev->rtnl_link_ops->dellink(dev, &list_kill);
> > > +     }
> > > +
> > > +     unregister_netdevice_many(&list_kill);
> > > +
> > > +     ret = 0;
> > > +
> > > +out_free:
> > > +     kfree(dev_list);
> > > +     return ret;
> > > +}
> > > +
> > >  int rtnl_delete_link(struct net_device *dev)
> > >  {
> > >       const struct rtnl_link_ops *ops;
> > > @@ -3102,6 +3149,9 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
> > >                                  tb[IFLA_ALT_IFNAME], NULL);
> > >       else if (tb[IFLA_GROUP])
> > >               err = rtnl_group_dellink(tgt_net, nla_get_u32(tb[IFLA_GROUP]));
> > > +     else if (tb[IFLA_IFINDEX_LIST])
> > > +             err = rtnl_list_dellink(tgt_net, nla_data(tb[IFLA_IFINDEX_LIST]),
> > > +                                     nla_len(tb[IFLA_IFINDEX_LIST]));
> > >       else
> > >               goto out;
> > >
> > > --
> > > 2.25.1
> > >
