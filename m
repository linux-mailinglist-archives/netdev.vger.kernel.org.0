Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B37B26100E
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 12:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbgIHKhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 06:37:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:37066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729595AbgIHKhZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 06:37:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 69E58AF3F;
        Tue,  8 Sep 2020 10:37:24 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5D0F460566; Tue,  8 Sep 2020 12:37:23 +0200 (CEST)
Date:   Tue, 8 Sep 2020 12:37:23 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "Kevin(Yudong) Yang" <yyd@google.com>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>
Subject: Re: [PATCH ethtool,v2] ethtool: add support show/set-time-stamping
Message-ID: <20200908103723.e4klmj5u6hvh6s4d@lion.mk-sys.cz>
References: <20200903140714.1781654-1-yyd@google.com>
 <20200907125312.evg6kio5dt3ar6c6@lion.mk-sys.cz>
 <CANn89iKZ19+AJOf5_5orPrUObYef+L-HrwF_Oay6o75ZbG7UhQ@mail.gmail.com>
 <20200907212542.rnwzu3cn24uewyk4@lion.mk-sys.cz>
 <CANn89iKyES49xnuQWDmAbg1gqkrzcoQvMfXD02GEhc2HBZ25GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKyES49xnuQWDmAbg1gqkrzcoQvMfXD02GEhc2HBZ25GA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 07:35:58AM +0200, Eric Dumazet wrote:
> On Mon, Sep 7, 2020 at 11:25 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> > On Mon, Sep 07, 2020 at 06:56:20PM +0200, Eric Dumazet wrote:
> > > On Mon, Sep 7, 2020 at 2:53 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> > > >
> > > > As I said in response to v1 patch, I don't like the idea of
> > > > adding a new ioctl interface to ethool when we are working on
> > > > replacing and deprecating the existing ones. Is there a strong
> > > > reason why this feature shouldn't be implemented using netlink?
> > >
> > > I do not think this is a fair request.
> > >
> > > All known kernels support the ioctl(), none of them support
> > > netlink so far.
> >
> > Several years ago, exactly the same was true for bonding, bridge or
> > vlan configuration: all known kernels supported ioctl() or sysfs
> > interfaces for them, none supported netlink at that point. By your
> > logic, the right course of action would have been using ioctl() and
> > sysfs for iproute2 support. Instead, rtnetlink interfaces were
> > implemented and used by iproute2. I believe it was the right choice.
> 
> Sure, but netlink does not yet provide the needed functionality for
> our use case.
> 
> netlink was a medium/long term plan, for the kernel side at least. I
> would totally understand and support a new iocl() in the kernel being
> blocked. (In fact I have blocked Kevin from adding a sysfs and advised
> to use existing ioctl())
> 
> Here we are not changing the kernel, we let ethtool use existing ABI
> and old kernels.
> 
> I think you are mixing your own long term plans with simply letting
> ethtool to meet existing kernel functionality.

In other words, the situation is exactly as it was with bridge
configuration back in 2014 or vlan configuration in 2007. There was
existing ioctl interface to configure them and no netlink interface. It
was also the same for bonding, except bonding was using sysfs and module
parameters, not ioctl.

But rather than using these existing interfaces for iproute2 support,
(rt)netlink interface was implemented and used by iproute2 instead.
I believe it was the right choice then and I believe it would be the
right choice now. That's why I'm asking for a strong reason not to add
and use a netlink based interface.

> > > Are you working on the netlink interface, or are you requesting us to
> > > implement it ?
> >
> > If it helps, I'm willing to write the kernel side.
> 
> Yes please, that would help, but will still require months of
> deployments at Google scale.
[...] 
> We do not have hwstamp_ctl deployed at this very moment, and for us it
> is simply much faster to deploy a new ethtool version than having to
> get security teams
> approval to install a new binary.
> 
> Honestly, if this was an option, we would not have even bothered
> writing ethtool support.
> 
> Now, you want netlink support instead of ioctl(), that is a very
> different scope and amount of work.

All this sounds as if the actual reason why you want this in ethtool -
and implemented using existing ioctl - were to provide a workaround for
your internal company processes which make it way harder to add a small
utility than to embed essentially the same code into another which has
been approved already. I understand that company processes sometimes
work like that (we have a customer who once asked us to patch kernel for
something that could be easily achieved by setting one sysctl on boot
becuse it was easier for them to deploy an updated kernel than to edit
a config file in their image) but I don't think this is a convincing
argument for upstream code inclusion.

> > Or both, if necessary, just to avoid adding another ioctl monument
> > that would have to be kept and maintained for many years, maybe
> > forever.
> 
> The kernel part is there, and lack of equivalent  netlink support
> means we have to keep it for ten years at least.

I meant the (proposed) userspace part. The kernel part is already there
and we cannot stop providing the SIOC[GS]HWTSTAMP ioctl any time soon.
But we don't have to use it in ethtool utility and I believe that rather
than using it, we should implement the feature via netlink from the
start to get all related benefits (extensibility, notifications, altname
support, dump support etc.).

BtW, I realized now that the way the patch is written, it would not
show the new information on systems with recent kernel supporting
ETHTOOL_MSG_TSINFO_GET netlink request (5.7 and newer) because then
ethtool >= 5.7 would use nl_tsinfo() rather than do_tsinfo().

Michal
