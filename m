Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94BA3C2C61
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 03:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhGJBYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 21:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhGJBYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 21:24:45 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B644CC0613DD;
        Fri,  9 Jul 2021 18:22:01 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id o139so17257031ybg.9;
        Fri, 09 Jul 2021 18:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WRSA3BEoyEiBnstDYuxLEg6I72njBeeCBAlhawGjK9s=;
        b=tyQfVnkT1/DjzHp1AKxqLhw0OiVW1i/+RajSoF/hxtVhR9YZKGvxcgwkrOFscTapAw
         ie3ZAPTcFeRyoOnCGnk4eSpkZVwUgnaoWf0JcPqofy/fEqnytbZLZaVmZOgg0a9hvFzH
         A/YmhzxSLVMN0hEhcr0kOv7u2eCBbWAa+ct3QS4iDRV4GMXCsNS/+j/+zhIPZ/kfp+xq
         HK6++UcYGyB81OSKh7GqpkDeDMw2TxftST2vizcaqeom+bNQZRFNvc/bBYvHL/1d92Wu
         3Lis8iuJYW2isMBvT0RZQL1YBX7hJlczSQSqTN39QlCbTxW1ziBQKAigUSigf4wo6Wsr
         WbTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WRSA3BEoyEiBnstDYuxLEg6I72njBeeCBAlhawGjK9s=;
        b=CHchx4vpwBwwhC+2CGFx7oKpulZ87f3UTtNbFxh3nqbLK3ByCXwwqNLdMTbIJjo/7l
         PZY+uDuJ6TUWs5HWnXq863PTzKbC1go+k6gL3eq6vzcfAc1bu65NsEvlAbPheab09s6W
         CLmzJSlvc5plg9QwJJu7dibyhVuvATpn066dDVL1X65aSxF8TPkwYuTL7IWzV3i/r81D
         ct04rR3xpz5MuNy8dhsjE+5JVY/LMIfAry6PkeEMuzJTqhJI4sxiHBrL9HDPgaFoTaUO
         AQ611W97IKkwIoltteW/U7WHQUw9sKkwvQ2I6R6ykB2HAXrM2u4y7wldBcMDeDqeXZz3
         ACpQ==
X-Gm-Message-State: AOAM531gf3Hx5UOrGq038pVZSxTsZTGp7lyz9YlTL7F5GVgP0YdorSrY
        OwoSL/wRO4yRpjH1O5UbZbudKdfDYq4nlvDe62A=
X-Google-Smtp-Source: ABdhPJxQ8FB1WsxfoM4yNpEPdTVmyiKFJFZ2WLwFLu/1AVV9amLxOKc+sdAe+QbBZv4kUn7lU17qh+c+LixgLxAQ7AI=
X-Received: by 2002:a25:1ec4:: with SMTP id e187mr49916836ybe.425.1625880120863;
 Fri, 09 Jul 2021 18:22:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzYuBYE1np+YwpwZT5_K5Zzed1NTPz57zbgn+0V5W1=nZg@mail.gmail.com>
 <1625876311.4655037-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1625876311.4655037-1-xuanzhuo@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 9 Jul 2021 18:21:49 -0700
Message-ID: <CAEf4BzZFEVeFxFa6-htb=r+BWnGj6LHOFh9EkUbVDaVDPRMnrQ@mail.gmail.com>
Subject: Re: [PATCH net v2] xdp, net: fix use-after-free in bpf_xdp_link_release
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Networking <netdev@vger.kernel.org>,
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
        Dust Li <dust.li@linux.alibaba.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 9, 2021 at 5:35 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> On Fri, 9 Jul 2021 14:56:26 -0700, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > On Fri, Jul 9, 2021 at 12:43 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Fri,  9 Jul 2021 10:55:25 +0800 Xuan Zhuo wrote:
> > > > The problem occurs between dev_get_by_index() and dev_xdp_attach_link().
> > > > At this point, dev_xdp_uninstall() is called. Then xdp link will not be
> > > > detached automatically when dev is released. But link->dev already
> > > > points to dev, when xdp link is released, dev will still be accessed,
> > > > but dev has been released.
> > > >
> > > > dev_get_by_index()        |
> > > > link->dev = dev           |
> > > >                           |      rtnl_lock()
> > > >                           |      unregister_netdevice_many()
> > > >                           |          dev_xdp_uninstall()
> > > >                           |      rtnl_unlock()
> > > > rtnl_lock();              |
> > > > dev_xdp_attach_link()     |
> > > > rtnl_unlock();            |
> > > >                           |      netdev_run_todo() // dev released
> > > > bpf_xdp_link_release()    |
> > > >     /* access dev.        |
> > > >        use-after-free */  |
> > > >
> > > > This patch adds a check of dev->reg_state in dev_xdp_attach_link(). If
> > > > dev has been called release, it will return -EINVAL.
> > >
> > > Please make sure to include a Fixes tag.
> > >
> > > I must say I prefer something closet to v1. Maybe put the if
> > > in the callee? Making ndo calls to unregistered netdevs is
> > > not legit, it will be confusing for a person reading this
> > > code to have to search callees to find where unregistered
> > > netdevs are rejected.
> >
> > So I'm a bit confused about the intended use of dev_get_by_index(). It
> > doesn't seem to be checking that device is unregistered and happily
> > returns dev with refcnt bumped even though device is going away. Is it
> > the intention that every caller of dev_get_by_index() needs to check
> > the state of the device *and* do any subsequent actions under the same
> > rtnl_lock/rtnl_unlock region? Seems a bit fragile. I suspect doing
> > this state check inside dev_get_by_index() would have unintended
> > consequences, though, right?
>
> In the function unregister_netdevice_many(), dev will be deleted from the linked
> list, so after this, dev_get_by_index() will not return dev. If it is not in
> rtnl_lock, subsequent use of dev is to check reg_state.
>

Ah, I see, makes sense, if we do dev lookup and attachment under the
same lock then we either won't get the device or at the time of
attachment it will be valid.

> So I think, maybe the version of v1 does not have the problem you mentioned.
> After calling rtnl_lock, we get dev from dev_get_by_index(). If it succeeds, we
> execute the following process, and if it fails, we return an error directly.
>
>
> >
> > BTW, seems like netlink code doesn't check the state of the device and
> > will report successful attachment to the dev that's unregistered? Is
> > this something we should fix as well?
>
> There is no such problem here, because all netlink operations are protected by
> rtnl_lock. In the protection of rtnl_lock, it is completely safe to get dev and
> attach link or prog.
>

Ok, I see, one big rtnl_lock saves netlink :)

>
> >
> > Xuan, if we do go with this approach, that dev->reg_state check should
> > probably be done in dev_xdp_attach() instead, which is called for both
> > bpf_link-based and bpf_prog-based XDP attachment.
>
> As mentioned above, since the entire bpf prog operation is protected by
> rtnl_lock, dev_xdp_attach() does not need to check the status of dev.
>
> >
> > If not, then the cleanest solution would be to make this check right
> > before dev_xdp_attach_link (though it's not clear what are we gaining
> > with that, if we ever have another user of dev_xdp_attach_link beside
> > bpf_xdp_link_attach, we'll probably miss similar situation), instead
> > of spreading out rtnl_unlock.
> >
> > BTW, regardless of the approach, we still need to do link->dev = NULL
> > if dev_xdp_attach_link() errors out.
>
> I think I understand what you mean now.

Yeah, this is a problem regardless.

Btw, I was also thinking to move dev_get_by_index right before
dev_xdp_attach_link inside a tight rntl_lock/rtnl_unlock region after
bpf_link is allocated, but that seems pretty bad if user,
intentionally or not, passes wrong ifindex. We'll be allocated a bunch
of unnecessary memory and deferring freeing it for no good reason. So
let's go with your v1 and link->dev = NULL to cover the clean up bug.
Thanks!

>
> Thanks.
>
> >
> >
> > >
> > > > Reported-by: Abaci <abaci@linux.alibaba.com>
> > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> > >
> > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > index c253c2aafe97..63c9a46ca853 100644
> > > > --- a/net/core/dev.c
> > > > +++ b/net/core/dev.c
> > > > @@ -9544,6 +9544,10 @@ static int dev_xdp_attach_link(struct net_device *dev,
> > > >                              struct netlink_ext_ack *extack,
> > > >                              struct bpf_xdp_link *link)
> > > >  {
> > > > +     /* ensure the dev state is ok */
> > > > +     if (dev->reg_state != NETREG_REGISTERED)
> > > > +             return -EINVAL;
> > > > +
> > > >       return dev_xdp_attach(dev, extack, link, NULL, NULL, link->flags);
> > > >  }
