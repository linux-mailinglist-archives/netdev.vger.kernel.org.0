Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21FD1C7B04
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgEFUPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:15:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:46894 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbgEFUPS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 16:15:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C2692ABBD;
        Wed,  6 May 2020 20:15:19 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 90AA1602B9; Wed,  6 May 2020 22:15:16 +0200 (CEST)
Date:   Wed, 6 May 2020 22:15:16 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com>,
        syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com,
        Jarod Wilson <jarod@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jann Horn <jannh@google.com>
Subject: Re: [Patch net] net: fix a potential recursive NETDEV_FEAT_CHANGE
Message-ID: <20200506201516.GS5989@lion.mk-sys.cz>
References: <20200505215819.1997-1-xiyou.wangcong@gmail.com>
 <20200505222748.GQ8237@lion.mk-sys.cz>
 <CAM_iQpWf95vVC4dsWTuxCNbNLN6RAMJQYdNeB37VZMN2P2Xf2w@mail.gmail.com>
 <20200506052604.GM5989@lion.mk-sys.cz>
 <CAM_iQpWTW_O7WHx5-4BLXqiV3e-eYowGRv-aG-LRZmJwvdyt5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpWTW_O7WHx5-4BLXqiV3e-eYowGRv-aG-LRZmJwvdyt5A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 12:08:35PM -0700, Cong Wang wrote:
> On Tue, May 5, 2020 at 10:26 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> >
> > On Tue, May 05, 2020 at 03:35:27PM -0700, Cong Wang wrote:
> > > On Tue, May 5, 2020 at 3:27 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> > > > On Tue, May 05, 2020 at 02:58:19PM -0700, Cong Wang wrote:
> > > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > > index 522288177bbd..ece50ae346c3 100644
> > > > > --- a/net/core/dev.c
> > > > > +++ b/net/core/dev.c
> > > > > @@ -8907,7 +8907,7 @@ static void netdev_sync_lower_features(struct net_device *upper,
> > > > >                       netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
> > > > >                                  &feature, lower->name);
> > > > >                       lower->wanted_features &= ~feature;
> > > > > -                     netdev_update_features(lower);
> > > > > +                     __netdev_update_features(lower);
> > > > >
> > > > >                       if (unlikely(lower->features & feature))
> > > > >                               netdev_WARN(upper, "failed to disable %pNF on %s!\n",
> > > >
> > > > Wouldn't this mean that when we disable LRO on a bond manually with
> > > > "ethtool -K", LRO will be also disabled on its slaves but no netlink
> > > > notification for them would be sent to userspace?
> > >
> > > What netlink notification are you talking about?
> >
> > There is ethtool notification sent by ethnl_netdev_event() and rtnetlink
> > notification sent by rtnetlink_event(). Both are triggered by
> > NETDEV_FEAT_CHANGE notifier so unless I missed something, when you
> > suppress the notifier, there will be no netlink notifications to
> > userspace.
> 
> Oh, interesting, why ethtool_notify() can't be called directly, for example,
> in netdev_update_features()? To me, using a NETDEV_FEAT_CHANGE
> event handler seems unnecessary for ethtool netlink.

It is certainly an option and as this is the only use of netdev
notifiers in ethtool code, it might even be more convenient. I rather
felt that when the call of notifier chain is in netdev_features_change()
already, it would be cleaner to use it. But my point rather was that the
NETDEV_FEAT_CHANGE event is used for more than only feature propagation
between upper/lower devices so that suppressing it may have unwanted
side effects (ethtool notifications were of course the first example
that came to my mind).

> BTW, as pointed out by Jay, actually we only need to skip
> NETDEV_FEAT_CHANGE for failure case, so I will update my patch.

Sounds like a good idea. I was wondering about this myself yesterday but
I didn't have time to look into it deeper so I only realized the problem
would probably be a difference between features and wanted_features.

Michal
