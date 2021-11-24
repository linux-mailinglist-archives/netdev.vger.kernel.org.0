Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E8B45C70A
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 15:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350923AbhKXOVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 09:21:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353039AbhKXOSS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 09:18:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2A1C60184;
        Wed, 24 Nov 2021 14:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637763308;
        bh=DiLmuDZJf9PD4Z6wSQpv2voDSGJpkrYORCPgeKbC6/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o4pL23XU8VU2CaWCxQyvK9d+47Xvyeq+it2x1C+ydcJRh8prYwdY1xc7PgMv2ryKD
         6DoZkHoQmpG1vGcYxNWUH2q4zQcVzfsSFgL/WLQ03MYlQBfc3bj/kh2x1ZrszuQpb/
         saNUdv5tJTrJKZcD0Oz4Nppcx14rIJhLaNzDXNWYjGczt4KcK4aHqiBrCnNsNmfsUC
         +wIobmEc13ZDXzlyL8tsE8AvyOWu4IWz0ZwrcUvgu/0SopWAYaUW3aXUinCQejPZ5c
         C6o9ugOUNSK5BcHGgH4BJoUm/H3j12HMj+HMbeIGtnG6k4uOZvyLSBHza7MIyKLT6Q
         ClcXNarTd9gTw==
Date:   Wed, 24 Nov 2021 06:15:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next] rtnetlink: Support fine-grained netdevice bulk
 deletion
Message-ID: <20211124061507.09fccc97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124075255.iloqmw4hrf6lv7nn@kgollan-pc>
References: <20211123123900.27425-1-lschlesinger@drivenets.com>
        <20211123200117.1c944493@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211124075255.iloqmw4hrf6lv7nn@kgollan-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 09:52:55 +0200 Lahav Schlesinger wrote:
> On Tue, Nov 23, 2021 at 08:01:17PM -0800, Jakub Kicinski wrote:
> > CAUTION: External E-Mail - Use caution with links and attachments

Sure.

> > On Tue, 23 Nov 2021 14:39:00 +0200 Lahav Schlesinger wrote:  
> > > Currently there are 2 means of deleting a netdevice using Netlink:
> > > 1. Deleting a single netdevice (either by ifindex using
> > > ifinfomsg::ifi_index, or by name using IFLA_IFNAME)
> > > 2. Delete all netdevice that belong to a group (using IFLA_GROUP)
> > >
> > > After all netdevice are handled, netdev_run_todo() is called, which
> > > calls rcu_barrier() to finish any outstanding RCU callbacks that were
> > > registered during the deletion of the netdevice, then wait until the
> > > refcount of all the devices is 0 and perform final cleanups.
> > >
> > > However, calling rcu_barrier() is a very costly operation, which takes
> > > in the order of ~10ms.
> > >
> > > When deleting a large number of netdevice one-by-one, rcu_barrier()
> > > will be called for each netdevice being deleted, causing the whole
> > > operation taking a long time.
> > >
> > > Following results are from benchmarking deleting 10K loopback devices,
> > > all of which are UP and with only IPv6 LLA being configured:  
> >
> > What's the use case for this?  
> 
> Deletion of 10K loopbacks was just as an example that uses the simplest
> interface type, to show the improvments that can be made in the
> rtnetlink framework, which in turn will have an effect on all interface
> types.
> Though I can see uses of deleting 10k loopbacks by means of doing a
> "factory default" on a large server, such servers can request deleting a
> large bulk of devices at once.

I'm sorry I don't understand. Please provide a clear use case.
I've never heard of "factory default on a large server".

Why can't groups be used?

This optimization requires addition of a uAPI, something we can't
change if it turns out it doesn't fit real uses. I've spent a month
cleaning up after your colleague who decided to put netdev->dev_addr 
on a tree, would be great to understand what your needs are before we
commit more time. 

> > > +     for_each_netdev_safe(net, dev, aux) {
> > > +             for (i = 0; i < size/sizeof(int); ++i) {  
> >
> > Can you not save the references while doing the previous loop?  
> 
> I didn't see any improvements on the timings by saving them (even
> compared to the n^2 loop on this patch), so I didn't want to introduce a
> new list to struct netdevice (using unreg_list seems unfitting here as it
> will collide with ops->dellink() below).

Allocate an array to save the pointers to, no need for lists.

> > Maybe we can allow multiple IFLA_IFINDEX instead?  
> 
> One problem is that it will cut down the number of ifindex that can be
> passed in a single message by half, given that each ifindex will require
> its own struct nlattr.

User space can send multiple messages. That'd be my preference at
least, I wonder what others think.

> Also, I didn't see any quick way of making __nla_validate_parse()
> support saving multiple instances of the same attribute in 'tb' instead
> of overwriting the last one each time, without adding extra overhead.

You can iterate over attributes with nla_for_each_attr(), that's pretty
clean.
