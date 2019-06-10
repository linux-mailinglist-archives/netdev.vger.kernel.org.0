Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B587E3BC56
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 21:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389046AbfFJTAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 15:00:16 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42019 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388544AbfFJTAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 15:00:15 -0400
Received: by mail-qt1-f195.google.com with SMTP id s15so11645093qtk.9;
        Mon, 10 Jun 2019 12:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DYGCcgIzNRgOnK2uYJS4UUOKGwEBja8jP4+71AJtuO0=;
        b=k7jMXpoNB7tftrdk5v1jb6fZEk5Fqeo3DHdjz8RAuHj0w0gpyBF0/VImwEe/W5HvdC
         bL+2Sc4lpSSqI2oPdVwxRS+JzrNVRcgT14Ne+pcvx7SmJPDAJiYM5Ab9awsdS4+Lddjp
         G/FSZoqMKmo9rRtFxrTVHNpy7P81rWKWfqx9ELG7G4yLSW8M8qo1XsMJ4IzYqze+JZ0z
         ZSBNdx0/jC7IRe5JmMlv10Tc9U3CsFNbcNQ5z1c5SKgEhJ3J9qvXCGqmv8vJVTA644sz
         syl/cRvx4dXaWfkRIfHQwVdPANprt4dMmI7KlKRfo0LigFo6OoNYiIWD7cQsEumTyN+O
         pGjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DYGCcgIzNRgOnK2uYJS4UUOKGwEBja8jP4+71AJtuO0=;
        b=dYcjyoEzaRdqUZQZ6tXjwhbJJa7I5vPPEvqWLVD95KwHGTHjYDYW09/xcj4evd/knX
         P8z/qCMyIXVPVJbAR8cp7/3MhTW74M8jYqOadlYmrmAsIKjBwK+DVaTEJPotRglsjqBK
         0K654u6xWFYad/PDVTy0saEgFwZFPYwD2QegUBrZeJLMAK8Y1GfOH3LUahj1JCFRjtC2
         dQFYfjHH8rm+o3aZ7eb/O8PDdf9rNSpI6AcBPoPuI+zlTLOG+wTO6077MAOs5JpqDv+3
         qdb/xrQ8DJNGkyzeoOhqKHWNyahtkf26TbI0omAlCEzRD4IAw4GYSzdicqv0TUlzJm/j
         +70A==
X-Gm-Message-State: APjAAAXKu2QDLR0SDA890jB9CKbR8k/wCDb/h3uMM0n875JbuQPyqCR9
        /yXPso1poH+O0jVKn8LBxfbUF9FLvUdL9JI6A4o=
X-Google-Smtp-Source: APXvYqxRHCyD/I8OlqUKWPrk0zoq7Q+e08ILTTNMItXDSzjMHnTfSg0B19FambpPsPGUXr1KTnIgKTMWndHo/UxWFTI=
X-Received: by 2002:ac8:2a63:: with SMTP id l32mr40774096qtl.117.1560193214620;
 Mon, 10 Jun 2019 12:00:14 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20190610161551eucas1p1f370190ee6d0d5e921de1a21f3da72df@eucas1p1.samsung.com>
 <20190610161546.30569-1-i.maximets@samsung.com>
In-Reply-To: <20190610161546.30569-1-i.maximets@samsung.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 10 Jun 2019 12:00:03 -0700
Message-ID: <CAEf4BzaJpWb+PakO2qmg-TQtOPKs=__4Vg=CksfqnarT0gtpqA@mail.gmail.com>
Subject: Re: [PATCH bpf v3] xdp: fix hang while unregistering device bound to
 xdp socket
To:     Ilya Maximets <i.maximets@samsung.com>
Cc:     Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 9:39 AM Ilya Maximets <i.maximets@samsung.com> wrote:
>
> Device that bound to XDP socket will not have zero refcount until the
> userspace application will not close it. This leads to hang inside
> 'netdev_wait_allrefs()' if device unregistering requested:
>
>   # ip link del p1
>   < hang on recvmsg on netlink socket >
>
>   # ps -x | grep ip
>   5126  pts/0    D+   0:00 ip link del p1
>
>   # journalctl -b
>
>   Jun 05 07:19:16 kernel:
>   unregister_netdevice: waiting for p1 to become free. Usage count = 1
>
>   Jun 05 07:19:27 kernel:
>   unregister_netdevice: waiting for p1 to become free. Usage count = 1
>   ...
>
> Fix that by implementing NETDEV_UNREGISTER event notification handler
> to properly clean up all the resources and unref device.
>
> This should also allow socket killing via ss(8) utility.
>
> Fixes: 965a99098443 ("xsk: add support for bind for Rx")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> ---
>
> Version 3:
>
>     * Declaration lines ordered from longest to shortest.
>     * Checking of event type moved to the top to avoid unnecessary
>       locking.
>
> Version 2:
>
>     * Completely re-implemented using netdev event handler.
>
>  net/xdp/xsk.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 64 insertions(+), 1 deletion(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index a14e8864e4fa..273a419a8c4d 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -693,6 +693,57 @@ static int xsk_mmap(struct file *file, struct socket *sock,
>                                size, vma->vm_page_prot);
>  }
>
> +static int xsk_notifier(struct notifier_block *this,
> +                       unsigned long msg, void *ptr)
> +{
> +       struct net_device *dev = netdev_notifier_info_to_dev(ptr);
> +       struct net *net = dev_net(dev);
> +       int i, unregister_count = 0;
> +       struct sock *sk;
> +
> +       switch (msg) {
> +       case NETDEV_UNREGISTER:
> +               mutex_lock(&net->xdp.lock);
> +               sk_for_each(sk, &net->xdp.list) {
> +                       struct xdp_sock *xs = xdp_sk(sk);
> +
> +                       mutex_lock(&xs->mutex);
> +                       if (dev != xs->dev) {
> +                               mutex_unlock(&xs->mutex);
> +                               continue;
> +                       }
> +
> +                       sk->sk_err = ENETDOWN;
> +                       if (!sock_flag(sk, SOCK_DEAD))
> +                               sk->sk_error_report(sk);
> +
> +                       /* Wait for driver to stop using the xdp socket. */
> +                       xdp_del_sk_umem(xs->umem, xs);
> +                       xs->dev = NULL;
> +                       synchronize_net();
> +
> +                       /* Clear device references in umem. */
> +                       xdp_put_umem(xs->umem);
> +                       xs->umem = NULL;
> +
> +                       mutex_unlock(&xs->mutex);
> +                       unregister_count++;
> +               }
> +               mutex_unlock(&net->xdp.lock);
> +
> +               if (unregister_count) {
> +                       /* Wait for umem clearing completion. */
> +                       synchronize_net();
> +                       for (i = 0; i < unregister_count; i++)
> +                               dev_put(dev);
> +               }
> +
> +               break;
> +       }
> +
> +       return NOTIFY_DONE;
> +}
> +
>  static struct proto xsk_proto = {
>         .name =         "XDP",
>         .owner =        THIS_MODULE,
> @@ -727,7 +778,8 @@ static void xsk_destruct(struct sock *sk)
>         if (!sock_flag(sk, SOCK_DEAD))
>                 return;
>
> -       xdp_put_umem(xs->umem);
> +       if (xs->umem)
> +               xdp_put_umem(xs->umem);

xpd_put_umem already checks for NULL umem, so you don't have to do it here.

>
>         sk_refcnt_debug_dec(sk);
>  }
> @@ -784,6 +836,10 @@ static const struct net_proto_family xsk_family_ops = {
>         .owner  = THIS_MODULE,
>  };
>
> +static struct notifier_block xsk_netdev_notifier = {
> +       .notifier_call  = xsk_notifier,
> +};
> +
>  static int __net_init xsk_net_init(struct net *net)
>  {
>         mutex_init(&net->xdp.lock);
> @@ -816,8 +872,15 @@ static int __init xsk_init(void)
>         err = register_pernet_subsys(&xsk_net_ops);
>         if (err)
>                 goto out_sk;
> +
> +       err = register_netdevice_notifier(&xsk_netdev_notifier);
> +       if (err)
> +               goto out_pernet;
> +
>         return 0;
>
> +out_pernet:
> +       unregister_pernet_subsys(&xsk_net_ops);
>  out_sk:
>         sock_unregister(PF_XDP);
>  out_proto:
> --
> 2.17.1
>
