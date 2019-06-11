Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487243C59C
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 10:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404607AbfFKIJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 04:09:59 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44400 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404073AbfFKIJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 04:09:59 -0400
Received: by mail-qk1-f195.google.com with SMTP id w187so7053865qkb.11;
        Tue, 11 Jun 2019 01:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cQ5mlxHCKg9OWIUg8k5qLquru5ZSr1owt2OS/5BIqsQ=;
        b=DTxjXUxcNj0hqtB0aDUcGm05f2wZiEdKbAJwjjEOnP8kdB2nRXIIumXO3BTfQYPNIT
         oSLM+QukntvA6HTPP4zO91ZtrqvBLUCtNz2fiQzzCv28ITo+m/nxVONriJildMjTW8CI
         a81IJMxr7Z3prsjcs8lZxXPkjvdDQf1vntEQ0kw416/BbcjC5KjWrixfSgG9NMODUPyi
         1q2Wc3OhdwauvwA67rntdIfTGDKHkzLH14rKE9Hsn8iaNWrNATsxwCA2p7NIqGPzpQx0
         LzrXTR8TeMUHsG12NIkewitWegKssb1oKSwz1RfaFsAH0ZHmpzR+Os3frr7DSw6syCnW
         OyrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cQ5mlxHCKg9OWIUg8k5qLquru5ZSr1owt2OS/5BIqsQ=;
        b=qqDy1+O7v37+WVZ63o5ntZdcbLk4RYOJpLuu4WfMBM0BaFMawvOH9ldCTxyqHBKOrL
         dcQ1EFZSyy+f5aLpJyIvQyXYKoun88fQnP+ULdbVRsTqrY3BheduI/5KEfzx/MJeiB/d
         0Fnc6AMGqPehCJc+gZWMY29BETwIU88Z2s+IFXTKvo27QOL1f5jrodWE0dXa3zSE8E9V
         yfqmhKirog9ZoeQFNy+RIaY68hN5p6JRAEkJzwlJkr1woXbLNflsN/GD3RZoCSylhkER
         7m9e39xRPZ4rDrAvoX/N02oq0o1i7HrAH6gtYBGMNBwRx4UY0xkOdR15Ep0MI0cRLYP9
         cEoQ==
X-Gm-Message-State: APjAAAV85ZIdS970xE8DkI6iOAqNWJ5tNUCZWTeHQ6WUcHAdFQ3UUt2c
        YdssoFr2JTHxRKI5+wcY9UruLeH8jGbgBE9ivUw=
X-Google-Smtp-Source: APXvYqx8a+xivpqNL+2FXmKPvQZ/Rj69SbjVWCoN9zXkojc00njOQtIIluyRue3jP7vqQSI9PCgr7fNeUiq8QC69cuk=
X-Received: by 2002:a05:620a:12c4:: with SMTP id e4mr8973515qkl.81.1560240597647;
 Tue, 11 Jun 2019 01:09:57 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20190610161551eucas1p1f370190ee6d0d5e921de1a21f3da72df@eucas1p1.samsung.com>
 <20190610161546.30569-1-i.maximets@samsung.com> <06C99519-64B9-4A91-96B9-0F99731E3857@gmail.com>
In-Reply-To: <06C99519-64B9-4A91-96B9-0F99731E3857@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 11 Jun 2019 10:09:45 +0200
Message-ID: <CAJ+HfNgdiutAwpnc3LDDEGXs2SFCu3UtMnao79sFNyZZpQ2ETw@mail.gmail.com>
Subject: Re: [PATCH bpf v3] xdp: fix hang while unregistering device bound to
 xdp socket
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Ilya Maximets <i.maximets@samsung.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jun 2019 at 22:49, Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> On 10 Jun 2019, at 9:15, Ilya Maximets wrote:
>
> > Device that bound to XDP socket will not have zero refcount until the
> > userspace application will not close it. This leads to hang inside
> > 'netdev_wait_allrefs()' if device unregistering requested:
> >
> >   # ip link del p1
> >   < hang on recvmsg on netlink socket >
> >
> >   # ps -x | grep ip
> >   5126  pts/0    D+   0:00 ip link del p1
> >
> >   # journalctl -b
> >
> >   Jun 05 07:19:16 kernel:
> >   unregister_netdevice: waiting for p1 to become free. Usage count = 1
> >
> >   Jun 05 07:19:27 kernel:
> >   unregister_netdevice: waiting for p1 to become free. Usage count = 1
> >   ...
> >
> > Fix that by implementing NETDEV_UNREGISTER event notification handler
> > to properly clean up all the resources and unref device.
> >
> > This should also allow socket killing via ss(8) utility.
> >
> > Fixes: 965a99098443 ("xsk: add support for bind for Rx")
> > Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> > ---
> >
> > Version 3:
> >
> >     * Declaration lines ordered from longest to shortest.
> >     * Checking of event type moved to the top to avoid unnecessary
> >       locking.
> >
> > Version 2:
> >
> >     * Completely re-implemented using netdev event handler.
> >
> >  net/xdp/xsk.c | 65
> > ++++++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 64 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index a14e8864e4fa..273a419a8c4d 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -693,6 +693,57 @@ static int xsk_mmap(struct file *file, struct
> > socket *sock,
> >                              size, vma->vm_page_prot);
> >  }
> >
> > +static int xsk_notifier(struct notifier_block *this,
> > +                     unsigned long msg, void *ptr)
> > +{
> > +     struct net_device *dev = netdev_notifier_info_to_dev(ptr);
> > +     struct net *net = dev_net(dev);
> > +     int i, unregister_count = 0;
> > +     struct sock *sk;
> > +
> > +     switch (msg) {
> > +     case NETDEV_UNREGISTER:
> > +             mutex_lock(&net->xdp.lock);
>
> The call is under the rtnl lock, and we're not modifying
> the list, so this mutex shouldn't be needed.
>

The list can, however, be modified outside the rtnl lock (e.g. at
socket creation). AFAIK the hlist cannot be traversed lock-less,
right?

>
> > +             sk_for_each(sk, &net->xdp.list) {
> > +                     struct xdp_sock *xs = xdp_sk(sk);
> > +
> > +                     mutex_lock(&xs->mutex);
> > +                     if (dev != xs->dev) {
> > +                             mutex_unlock(&xs->mutex);
> > +                             continue;
> > +                     }
> > +
> > +                     sk->sk_err = ENETDOWN;
> > +                     if (!sock_flag(sk, SOCK_DEAD))
> > +                             sk->sk_error_report(sk);
> > +
> > +                     /* Wait for driver to stop using the xdp socket. */
> > +                     xdp_del_sk_umem(xs->umem, xs);
> > +                     xs->dev = NULL;
> > +                     synchronize_net();
> Isn't this by handled by the unregister_count case below?
>

To clarify, setting dev to NULL and xdp_del_sk_umem() + sync makes
sure that a driver doesn't touch the Tx and Rx rings. Nothing can be
assumed about completion + fill ring (umem), until zero-copy has been
disabled via ndo_bpf.

> > +
> > +                     /* Clear device references in umem. */
> > +                     xdp_put_umem(xs->umem);
> > +                     xs->umem = NULL;
>
> This makes me uneasy.  We need to unregister the umem from
> the device (xdp_umem_clear_dev()) but this can remove the umem
> pages out from underneath the xsk.
>

Yes, this is scary. The socket is alive, and userland typically has
the fill/completion rings mmapped. Then the umem refcount is decreased
and can potentially free the umem (fill rings etc.), as Jonathan says,
underneath the xsk. Also, setting the xs umem/dev to zero, while the
socket is alive, would allow a user to re-setup the socket, which we
don't want to allow.

> Perhaps what's needed here is the equivalent of an unbind()
> call that just detaches the umem/sk from the device, but does
> not otherwise tear them down.
>

Yeah, I agree. A detached/zombie state is needed during the socket lifetime.

>
> > +                     mutex_unlock(&xs->mutex);
> > +                     unregister_count++;
> > +             }
> > +             mutex_unlock(&net->xdp.lock);
> > +
> > +             if (unregister_count) {
> > +                     /* Wait for umem clearing completion. */
> > +                     synchronize_net();
> > +                     for (i = 0; i < unregister_count; i++)
> > +                             dev_put(dev);
> > +             }
> > +
> > +             break;
> > +     }
> > +
> > +     return NOTIFY_DONE;
> > +}
> > +
> >  static struct proto xsk_proto = {
> >       .name =         "XDP",
> >       .owner =        THIS_MODULE,
> > @@ -727,7 +778,8 @@ static void xsk_destruct(struct sock *sk)
> >       if (!sock_flag(sk, SOCK_DEAD))
> >               return;
> >
> > -     xdp_put_umem(xs->umem);
> > +     if (xs->umem)
> > +             xdp_put_umem(xs->umem);
> Not needed - xdp_put_umem() already does a null check.
> --
> Jonathan
>
>
> >
> >       sk_refcnt_debug_dec(sk);
> >  }
> > @@ -784,6 +836,10 @@ static const struct net_proto_family
> > xsk_family_ops = {
> >       .owner  = THIS_MODULE,
> >  };
> >
> > +static struct notifier_block xsk_netdev_notifier = {
> > +     .notifier_call  = xsk_notifier,
> > +};
> > +
> >  static int __net_init xsk_net_init(struct net *net)
> >  {
> >       mutex_init(&net->xdp.lock);
> > @@ -816,8 +872,15 @@ static int __init xsk_init(void)
> >       err = register_pernet_subsys(&xsk_net_ops);
> >       if (err)
> >               goto out_sk;
> > +
> > +     err = register_netdevice_notifier(&xsk_netdev_notifier);
> > +     if (err)
> > +             goto out_pernet;
> > +
> >       return 0;
> >
> > +out_pernet:
> > +     unregister_pernet_subsys(&xsk_net_ops);
> >  out_sk:
> >       sock_unregister(PF_XDP);
> >  out_proto:
> > --
> > 2.17.1
