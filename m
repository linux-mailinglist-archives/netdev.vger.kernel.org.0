Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596BC3C2BF9
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 02:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhGJAXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 20:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229846AbhGJAXQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 20:23:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73DFD61375;
        Sat, 10 Jul 2021 00:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625876432;
        bh=vrg4KIgrbtDn3MfmeJpKjQ2/woNprqcpscy3XtdLL6M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PAk3TpwzE1eiortDdHyvARIEooTzn36nYKIlEpnR++aprnhBUS0pBtvTi1RcHZprJ
         wHxwvQgtweDyt+D1cFKEyGwoOJWQ4tLY2fo04vVyCqJnLvDDqe6F/jwPo0OgORKjIQ
         KUcQkscorMuWxY7N1VbzwnZ6hJGqmCXUkSFSiRj19qEA2X3a7l58zwoiwhc8fyqfmU
         J675VZ+CER7cJinXCS6CREeUPhUYWP2ipvxYlRTscA//V9RnBbD2IJfJDGqaX7SGsv
         2gQD5FzoQTxzjplkmqIsURN2bNNekuuZzEPecEdUVgHqJGcYh+RA1W+p8VKxjJb/KR
         Vb6K5RB9+zwJw==
Date:   Fri, 9 Jul 2021 17:20:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        bpf <bpf@vger.kernel.org>, Abaci <abaci@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>
Subject: Re: [PATCH net v2] xdp, net: fix use-after-free in
 bpf_xdp_link_release
Message-ID: <20210709172030.29cf233e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEf4BzYuBYE1np+YwpwZT5_K5Zzed1NTPz57zbgn+0V5W1=nZg@mail.gmail.com>
References: <20210709025525.107314-1-xuanzhuo@linux.alibaba.com>
        <20210709124340.44bafef1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEf4BzYuBYE1np+YwpwZT5_K5Zzed1NTPz57zbgn+0V5W1=nZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Jul 2021 14:56:26 -0700 Andrii Nakryiko wrote:
> On Fri, Jul 9, 2021 at 12:43 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri,  9 Jul 2021 10:55:25 +0800 Xuan Zhuo wrote:  
> > > The problem occurs between dev_get_by_index() and dev_xdp_attach_link().
> > > At this point, dev_xdp_uninstall() is called. Then xdp link will not be
> > > detached automatically when dev is released. But link->dev already
> > > points to dev, when xdp link is released, dev will still be accessed,
> > > but dev has been released.
> > >
> > > dev_get_by_index()        |
> > > link->dev = dev           |
> > >                           |      rtnl_lock()
> > >                           |      unregister_netdevice_many()
> > >                           |          dev_xdp_uninstall()
> > >                           |      rtnl_unlock()
> > > rtnl_lock();              |
> > > dev_xdp_attach_link()     |
> > > rtnl_unlock();            |
> > >                           |      netdev_run_todo() // dev released
> > > bpf_xdp_link_release()    |
> > >     /* access dev.        |
> > >        use-after-free */  |
> > >
> > > This patch adds a check of dev->reg_state in dev_xdp_attach_link(). If
> > > dev has been called release, it will return -EINVAL.  
> >
> > Please make sure to include a Fixes tag.
> >
> > I must say I prefer something closet to v1. Maybe put the if
> > in the callee? Making ndo calls to unregistered netdevs is
> > not legit, it will be confusing for a person reading this
> > code to have to search callees to find where unregistered
> > netdevs are rejected.  
> 
> So I'm a bit confused about the intended use of dev_get_by_index(). It
> doesn't seem to be checking that device is unregistered and happily
> returns dev with refcnt bumped even though device is going away. Is it
> the intention that every caller of dev_get_by_index() needs to check
> the state of the device *and* do any subsequent actions under the same
> rtnl_lock/rtnl_unlock region? Seems a bit fragile.

It depends on the caller, right? Not all callers even take the rtnl
lock. AFAIU dev_get_by_index() gives the caller a ref'ed netdev object.
If all the caller cares about is the netdev state itself that's
perfectly fine. 

If caller has ordering requirements or needs to talk to the driver
chances are the lookup and all checks should be done under rtnl.
Or there must be some lock dependency on rtnl (take a lock which 
unregister netdev of the device of interest would also take).

In case of XDP we impose extra requirements on ourselves because we
want the driver code to be as simple as possible.

> I suspect doing this state check inside dev_get_by_index() would have
> unintended consequences, though, right?

It'd be moot, dev_get_by_index() is under RCU and unregister path syncs
RCU, but that doesn't guarantee anything if caller holds no locks.

> BTW, seems like netlink code doesn't check the state of the device and
> will report successful attachment to the dev that's unregistered? Is
> this something we should fix as well?

Entire rtnetlink is under rtnl_lock, and so is unregistering a netdev
so those paths can't race.

> Xuan, if we do go with this approach, that dev->reg_state check should
> probably be done in dev_xdp_attach() instead, which is called for both
> bpf_link-based and bpf_prog-based XDP attachment.
> 
> If not, then the cleanest solution would be to make this check right
> before dev_xdp_attach_link (though it's not clear what are we gaining
> with that, if we ever have another user of dev_xdp_attach_link beside
> bpf_xdp_link_attach, we'll probably miss similar situation), instead
> of spreading out rtnl_unlock.
> 
> BTW, regardless of the approach, we still need to do link->dev = NULL
> if dev_xdp_attach_link() errors out.
