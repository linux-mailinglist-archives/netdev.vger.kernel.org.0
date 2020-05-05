Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49B61C63FA
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 00:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbgEEWfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 18:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728642AbgEEWfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 18:35:39 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288F6C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 15:35:39 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id j26so374902ots.0
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 15:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K9gluYt/ElUj2rL94yMK88vQNlOPO18qFhkDpl/aOI4=;
        b=lRaAV7lpDwRBpsVzeoR02ox70e9O4G0OLSesUgFK5LkV4n3FBee64FI5tRK22ZZFPJ
         L4oKMOwldhJMe7qBENQMl0EMa0uk/4q4CCskSVeJM1dENtmwFkufIVyy1ZRrZLG1uDX4
         U0UFpgjNRVIBScSlH5Zd+iZWm/oe5p9thwJ2Le07ZYoOJQBJBELp18yw9bZZ0HRNlg60
         thP92p2Mm8Asfe0jypBs8EBZnldXL1b383J2TNNOD2RBBD4kzOAFBdPw3+y+98moiIbO
         enzYogvC5uY4IYYCe5GaARtDbrp182Qt/nwUE5mJ4O93ItrYV1wtmqkj2rixiV1gwDDT
         cC2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K9gluYt/ElUj2rL94yMK88vQNlOPO18qFhkDpl/aOI4=;
        b=EgP/JN8s3ply7NP7jcQLCXNJNvN29Ky2Em+1zUPMMQA3x7EBb/96gd3jk0+HjJUsu6
         WUUCaVW+XcbZ+a5RrBpKwAGjTh91mo7lJm071JINK7euzTsYxe39/1452OumptLmgjxt
         fVffGh2N8X9q/BdarSRQ5JttC9Rn4MGkTGvf3V+aAtwxw9FZ2TbDiyBXap5EUS/1Fy2D
         vyCwWtbyzvPq/vKE0vL6syQJLVuYLZ84uodchZ59Vwo6i533gWttjC+qs7Ki4pjBAf96
         yMIFyVoECIwpovzALynGEyTtbgLbN8rWimXA/pHLRkqcc8TJ/nT1DZDEVWc7rJ6pvI4S
         HfzA==
X-Gm-Message-State: AGi0PuaNQalEQqEQtVY7SogUiUZrTBvsXM6xUahLpT62bc2kLdBLBEXP
        StTGt9K/pJf/mHQQCZZE9MAHhCIdHEURIX5puFI=
X-Google-Smtp-Source: APiQypJ8ijaZ5WHqaQFNxHGFvw7omF1+wZ7mRXtsVD1ducd3lcjzxyejBtftMX1P9BUp9F0F2Xz6LSaOBw5f/HRMcwE=
X-Received: by 2002:a9d:4a1:: with SMTP id 30mr3920401otm.319.1588718138531;
 Tue, 05 May 2020 15:35:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200505215819.1997-1-xiyou.wangcong@gmail.com> <20200505222748.GQ8237@lion.mk-sys.cz>
In-Reply-To: <20200505222748.GQ8237@lion.mk-sys.cz>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 5 May 2020 15:35:27 -0700
Message-ID: <CAM_iQpWf95vVC4dsWTuxCNbNLN6RAMJQYdNeB37VZMN2P2Xf2w@mail.gmail.com>
Subject: Re: [Patch net] net: fix a potential recursive NETDEV_FEAT_CHANGE
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com>,
        syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com,
        Jarod Wilson <jarod@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 3:27 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Tue, May 05, 2020 at 02:58:19PM -0700, Cong Wang wrote:
> > syzbot managed to trigger a recursive NETDEV_FEAT_CHANGE event
> > between bonding master and slave. I managed to find a reproducer
> > for this:
> >
> >   ip li set bond0 up
> >   ifenslave bond0 eth0
> >   brctl addbr br0
> >   ethtool -K eth0 lro off
> >   brctl addif br0 bond0
> >   ip li set br0 up
> >
> > When a NETDEV_FEAT_CHANGE event is triggered on a bonding slave,
> > it captures this and calls bond_compute_features() to fixup its
> > master's and other slaves' features. However, when syncing with
> > its lower devices by netdev_sync_lower_features() this event is
> > triggered again on slaves, so it goes back and forth recursively
> > until the kernel stack is exhausted.
> >
> > It is unnecessary to trigger it for a second time, because when
> > we update the features from top down, we rely on each
> > dev->netdev_ops->ndo_fix_features() to do the job, each stacked
> > device should implement it. NETDEV_FEAT_CHANGE event is necessary
> > when we update from bottom up, like in existing stacked device
> > implementations.
> >
> > Just calling __netdev_update_features() is sufficient to fix this
> > issue.
> >
> > Fixes: fd867d51f889 ("net/core: generic support for disabling netdev features down stack")
> > Reported-by: syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com
> > Reported-by: syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com
> > Cc: Jarod Wilson <jarod@redhat.com>
> > Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> > Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> > Cc: Jann Horn <jannh@google.com>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > ---
> >  net/core/dev.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 522288177bbd..ece50ae346c3 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -8907,7 +8907,7 @@ static void netdev_sync_lower_features(struct net_device *upper,
> >                       netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
> >                                  &feature, lower->name);
> >                       lower->wanted_features &= ~feature;
> > -                     netdev_update_features(lower);
> > +                     __netdev_update_features(lower);
> >
> >                       if (unlikely(lower->features & feature))
> >                               netdev_WARN(upper, "failed to disable %pNF on %s!\n",
>
> Wouldn't this mean that when we disable LRO on a bond manually with
> "ethtool -K", LRO will be also disabled on its slaves but no netlink
> notification for them would be sent to userspace?

What netlink notification are you talking about?

When we change features from top down, ->ndo_fix_features()
does the work, in bonding case, it is bond_fix_features().
I see no netlink notification either in bond_compute_features()
or bond_fix_features().

Thanks.
