Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73E11C676E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 07:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgEFF0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 01:26:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:38626 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgEFF0G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 01:26:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A0795AE2D;
        Wed,  6 May 2020 05:26:07 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 59B30602B9; Wed,  6 May 2020 07:26:04 +0200 (CEST)
Date:   Wed, 6 May 2020 07:26:04 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com>,
        syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com,
        Jarod Wilson <jarod@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jann Horn <jannh@google.com>
Subject: Re: [Patch net] net: fix a potential recursive NETDEV_FEAT_CHANGE
Message-ID: <20200506052604.GM5989@lion.mk-sys.cz>
References: <20200505215819.1997-1-xiyou.wangcong@gmail.com>
 <20200505222748.GQ8237@lion.mk-sys.cz>
 <CAM_iQpWf95vVC4dsWTuxCNbNLN6RAMJQYdNeB37VZMN2P2Xf2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpWf95vVC4dsWTuxCNbNLN6RAMJQYdNeB37VZMN2P2Xf2w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 03:35:27PM -0700, Cong Wang wrote:
> On Tue, May 5, 2020 at 3:27 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> > On Tue, May 05, 2020 at 02:58:19PM -0700, Cong Wang wrote:
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 522288177bbd..ece50ae346c3 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -8907,7 +8907,7 @@ static void netdev_sync_lower_features(struct net_device *upper,
> > >                       netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
> > >                                  &feature, lower->name);
> > >                       lower->wanted_features &= ~feature;
> > > -                     netdev_update_features(lower);
> > > +                     __netdev_update_features(lower);
> > >
> > >                       if (unlikely(lower->features & feature))
> > >                               netdev_WARN(upper, "failed to disable %pNF on %s!\n",
> >
> > Wouldn't this mean that when we disable LRO on a bond manually with
> > "ethtool -K", LRO will be also disabled on its slaves but no netlink
> > notification for them would be sent to userspace?
> 
> What netlink notification are you talking about?

There is ethtool notification sent by ethnl_netdev_event() and rtnetlink
notification sent by rtnetlink_event(). Both are triggered by
NETDEV_FEAT_CHANGE notifier so unless I missed something, when you
suppress the notifier, there will be no netlink notifications to
userspace.

Michal

> When we change features from top down, ->ndo_fix_features()
> does the work, in bonding case, it is bond_fix_features().
> I see no netlink notification either in bond_compute_features()
> or bond_fix_features().
> 
> Thanks.
