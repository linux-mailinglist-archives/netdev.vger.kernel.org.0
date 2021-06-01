Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56795397ADC
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 21:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234766AbhFATxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 15:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbhFATxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 15:53:45 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32421C061574;
        Tue,  1 Jun 2021 12:52:03 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso329020pjx.1;
        Tue, 01 Jun 2021 12:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rWU7CRZxplXFOpgpvVdYW2dajeZdrTc/4yvvUxOS/iA=;
        b=lqxaXVHZuJOAYq0bMUbZyQdtc+cBX92/Ejnd3emXOkn+2Dz6CULELMH/OZbRymyYd4
         WYFmXGFvZrENQ/StGFY4s4JogtLm4zUvkP4rqQL0YIVqK1zKRLewz7Zb952ey8JDuOhl
         wSgqCZcYfcGMB5GZ8HIKBwONwvb/0vwRpoc/KMFh4aknhq3FOdgXwHerZqTNcJpXQk/x
         q9VaBKzb2N71Fb3DyFu7awRMgKXYtV6uQ4SsbULw/gZDwHLuq8wMmfGqGeqidY8QYgA2
         0xx1wGHorKw2gxn3LN9YUkC42yF2IODRH2cSuKU/XJnOWjoJMNLjojOV73kXUMjRUsL8
         6p5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rWU7CRZxplXFOpgpvVdYW2dajeZdrTc/4yvvUxOS/iA=;
        b=ggWS/ve9YEBJ/ZMkv3WGPTyaHgym5rTH0ZNervEUQq54ldQ6VQY5olnQ6RSHdhki4S
         BrQiyQevNMZD94DBLynORes+1Bga6gbX4dseE/3iPrhOk1QHUnssi2pGaVKco/mZFvPJ
         mEDnvu9bR2tVfKurEEqqb27PiPDuR1TrBX1JI4zaM9H6+PcJydCuFz0e5DZCLKnCFaKV
         DUztYQnDLvSnPthORRTn5tXUEYgMkD60l0hsCNQfML2QsLFI0obcQwzGBrQwyiYdZ/T4
         ex/drFOEOPLMwTIjhV2KVr7Hasj3UQNh7N68XOT2D9ZYWP35P7kIfk01kC8QVopNihvj
         tgvQ==
X-Gm-Message-State: AOAM53317zjt/wyety57OQluQr020eVkKFXpdsqts/3+Z/+VCwJ/xCwt
        1iAJ3LHMz8/55224p2opt8Vp+eWZRVfObVvpK/0=
X-Google-Smtp-Source: ABdhPJyLuyHLh8nJqMd9ZVPmHRTd3nZxT+ADOn2EMuuAH6vV1BEEAxIAbD3/le608YEfG2t+6IuXLu+yQCXf6ODD+Rs=
X-Received: by 2002:a17:902:7043:b029:104:8fa9:7443 with SMTP id
 h3-20020a1709027043b02901048fa97443mr12968339plt.64.1622577122687; Tue, 01
 Jun 2021 12:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210531153410.93150-1-changbin.du@gmail.com> <20210531220128.26c0cb36@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210531220128.26c0cb36@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 1 Jun 2021 12:51:51 -0700
Message-ID: <CAM_iQpUEjBDK44=mD5shkmmoDYhmHQaSZtR34rLRkgd9wSWiQQ@mail.gmail.com>
Subject: Re: [PATCH] nsfs: fix oops when ns->ops is not provided
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Changbin Du <changbin.du@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 10:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 31 May 2021 23:34:10 +0800 Changbin Du wrote:
> > We should not create inode for disabled namespace. A disabled namespace
> > sets its ns->ops to NULL. Kernel could panic if we try to create a inode
> > for such namespace.
> >
> > Here is an example oops in socket ioctl cmd SIOCGSKNS when NET_NS is
> > disabled. Kernel panicked wherever nsfs trys to access ns->ops since the
> > proc_ns_operations is not implemented in this case.
> >
> > [7.670023] Unable to handle kernel NULL pointer dereference at virtual address 00000010
> > [7.670268] pgd = 32b54000
> > [7.670544] [00000010] *pgd=00000000
> > [7.671861] Internal error: Oops: 5 [#1] SMP ARM
> > [7.672315] Modules linked in:
> > [7.672918] CPU: 0 PID: 1 Comm: systemd Not tainted 5.13.0-rc3-00375-g6799d4f2da49 #16
> > [7.673309] Hardware name: Generic DT based system
> > [7.673642] PC is at nsfs_evict+0x24/0x30
> > [7.674486] LR is at clear_inode+0x20/0x9c
> >
> > So let's reject such request for disabled namespace.
> >
> > Signed-off-by: Changbin Du <changbin.du@gmail.com>
> > Cc: <stable@vger.kernel.org>
> > Cc: Cong Wang <xiyou.wangcong@gmail.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: David Laight <David.Laight@ACULAB.COM>
> > ---
> >  fs/nsfs.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/fs/nsfs.c b/fs/nsfs.c
> > index 800c1d0eb0d0..6c055eb7757b 100644
> > --- a/fs/nsfs.c
> > +++ b/fs/nsfs.c
> > @@ -62,6 +62,10 @@ static int __ns_get_path(struct path *path, struct ns_common *ns)
> >       struct inode *inode;
> >       unsigned long d;
> >
> > +     /* In case the namespace is not actually enabled. */
> > +     if (!ns->ops)
> > +             return -EOPNOTSUPP;
> > +
> >       rcu_read_lock();
> >       d = atomic_long_read(&ns->stashed);
> >       if (!d)
>
> I'm not sure why we'd pick runtime checks for something that can be
> perfectly easily solved at compilation time. Networking should not
> be asking for FDs for objects which don't exist.

Four reasons:

1) ioctl() is not a hot path, so performance is not a problem here.

2) There are 3 different places (tun has two more) that need the same
fix.

3) init_net always exits, except it does not have an ops when
CONFIG_NET_NS is disabled:

static __net_init int net_ns_net_init(struct net *net)
{
#ifdef CONFIG_NET_NS
        net->ns.ops = &netns_operations;
#endif
        return ns_alloc_inum(&net->ns);
}

4) *I think* other namespaces need this fix too, for instance
init_ipc_ns:

struct ipc_namespace init_ipc_ns = {
        .ns.count = REFCOUNT_INIT(1),
        .user_ns = &init_user_ns,
        .ns.inum = PROC_IPC_INIT_INO,
#ifdef CONFIG_IPC_NS
        .ns.ops = &ipcns_operations,
#endif
};

whose ns->ops is NULL too if disabled.

Thanks.
