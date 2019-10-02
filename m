Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C31C4785
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 08:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbfJBGGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 02:06:49 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46593 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfJBGGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 02:06:49 -0400
Received: by mail-ot1-f67.google.com with SMTP id 89so8177779oth.13;
        Tue, 01 Oct 2019 23:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k8/NDdj1FsSI9iOybZeoLz0TTSwlT6lujExyKc1c6/c=;
        b=S3Opqdp76vICEN2dRBeSS3sbyYafFuj19tnCtlUaIfLpVdGV2HG0PbqDYzH3jBGdgi
         jokEfnmtO2wG3pM4x3MTldNVOz6TvS9qMpv8UGzy41FBz/5e13bdcJtAt2DsiEcPHL6N
         PA2AmrCBDwZv54nrCFV6sWNS72IDKd30hrDmrTNG9qRZEU2DUm9cwBScRZvbS+WUKJnn
         UxB4XnwyMf56TDTYoVuTmGW2itASWbddqZM16ZXpf9f9AZEZ9YBFLasqAbsivqAlNXia
         5d2TgnAunj8ETct/rJkv01pcXg05ktBQlzADmBOS60B+cRFZ+UhwF5VISGGaae+haFRn
         rs+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k8/NDdj1FsSI9iOybZeoLz0TTSwlT6lujExyKc1c6/c=;
        b=uMo42a/phxb/I+h5TWG3GIqTr+qgoI80HyPcdjWcFeNb8EkgxAf0zTWyuJqKjORBmr
         xZBZL4YeZVoguIi8aRmgyE0peg7e7d9q1QyPU6KGLyPgchjTVPShVTKfVGOKFnvdFCV9
         93eXsNFVsmUJ01jWeZQWEx/c3vTVnqykndJbY5HJm1CjkDhRZZh9f3nmvbxbSD6N1Evt
         LSfAOsv2VBQq2hyw1H89J2VXmK7TFflm1prWuJ29bLBCOpeHiVF4hkV6Uu2nyohv3yvc
         l3NTQaxu51HHPUxp1zuuQZwG92+nL6a5KoBTSoks/3EC6ZvhDskZk3Hqeb0v5xCKV+fX
         NGPQ==
X-Gm-Message-State: APjAAAXXQBRWSGx3rKtOOma2Fd9fj4iXjgpL+6304O0vlBoyR3QwjGqm
        Tm2Jg2zn/BDdJlU0QgWA0nmV/IACRDJz9j6UnMY=
X-Google-Smtp-Source: APXvYqzgH3awtHLgpN6j2jfIiv00x9RPH4zkOx68c2FazHxS4Lc0cICU+tLZ/K9BZXru15U0wyliMtukwV1ZleC2CSU=
X-Received: by 2002:a05:6830:1041:: with SMTP id b1mr1429752otp.30.1569996408324;
 Tue, 01 Oct 2019 23:06:48 -0700 (PDT)
MIME-Version: 1.0
References: <1569850212-4035-1-git-send-email-magnus.karlsson@intel.com> <20191001221948.GA10044@pc-63.home>
In-Reply-To: <20191001221948.GA10044@pc-63.home>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 2 Oct 2019 08:06:37 +0200
Message-ID: <CAJ8uoz2kfVSWnOkNzbL+D7tcOaoGxE3WnemY=QrbXyiDiO-bBg@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: fix crash in poll when device does not support ndo_xsk_wakeup
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 7:57 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Mon, Sep 30, 2019 at 03:30:12PM +0200, Magnus Karlsson wrote:
> > Fixes a crash in poll() when an AF_XDP socket is opened in copy mode
> > with the XDP_USE_NEED_WAKEUP flag set and the bound device does not
> > have ndo_xsk_wakeup defined. Avoid trying to call the non-existing ndo
> > and instead call the internal xsk sendmsg functionality to send
> > packets in the same way (from the application's point of view) as
> > calling sendmsg() in any mode or poll() in zero-copy mode would have
> > done. The application should behave in the same way independent on if
> > zero-copy mode or copy-mode is used.
> >
> > Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP rings")
> > Reported-by: syzbot+a5765ed8cdb1cca4d249@syzkaller.appspotmail.com
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Overall looks good, two very small nits:
>
> > ---
> >  net/xdp/xsk.c | 33 +++++++++++++++++++++++----------
> >  1 file changed, 23 insertions(+), 10 deletions(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index c2f1af3..a478d8ec 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -327,8 +327,7 @@ static void xsk_destruct_skb(struct sk_buff *skb)
> >       sock_wfree(skb);
> >  }
> >
> > -static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
> > -                         size_t total_len)
> > +static int xsk_generic_xmit(struct sock *sk)
> >  {
> >       u32 max_batch = TX_BATCH_SIZE;
> >       struct xdp_sock *xs = xdp_sk(sk);
> > @@ -394,22 +393,31 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
> >       return err;
> >  }
> >
> > -static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
> > +static int __xsk_sendmsg(struct socket *sock)
> >  {
> > -     bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
> >       struct sock *sk = sock->sk;
> >       struct xdp_sock *xs = xdp_sk(sk);
>
> Can't we just only pass xs as an argument to __xsk_sendmsg()? From
> below xsk_sendmsg() we eventually fetch xs anyway same as for the
> xsk_poll(), yet in __xsk_sendmsg() we pass sock (which is otherwise
> unused) and then we need to refetch sk and xs once again.

xs is enough for the zerocopy path, but I need sk for the generic skb
path. In any way, sock can be exterminated and the code simplified, as
you suggest. Will fix.

> > -     if (unlikely(!xsk_is_bound(xs)))
> > -             return -ENXIO;
> >       if (unlikely(!(xs->dev->flags & IFF_UP)))
> >               return -ENETDOWN;
> >       if (unlikely(!xs->tx))
> >               return -ENOBUFS;
> > +
> > +     return xs->zc ? xsk_zc_xmit(sk) : xsk_generic_xmit(sk);
> > +}
> > +
> > +static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
> > +{
> > +     bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
> > +     struct sock *sk = sock->sk;
> > +     struct xdp_sock *xs = xdp_sk(sk);
> > +
> > +     if (unlikely(!xsk_is_bound(xs)))
> > +             return -ENXIO;
> >       if (need_wait)
>
> Not directly related but since you touch this code, need_wait should
> be marked unlikely() as well.

Will fix.

Thanks: Magnus

> >               return -EOPNOTSUPP;
> >
> > -     return (xs->zc) ? xsk_zc_xmit(sk) : xsk_generic_xmit(sk, m, total_len);
> > +     return __xsk_sendmsg(sock);
> >  }
> >
> >  static unsigned int xsk_poll(struct file *file, struct socket *sock,
> > @@ -426,9 +434,14 @@ static unsigned int xsk_poll(struct file *file, struct socket *sock,
> >       dev = xs->dev;
> >       umem = xs->umem;
> >
> > -     if (umem->need_wakeup)
> > -             dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
> > -                                             umem->need_wakeup);
> > +     if (umem->need_wakeup) {
> > +             if (dev->netdev_ops->ndo_xsk_wakeup)
> > +                     dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
> > +                                                     umem->need_wakeup);
> > +             else
> > +                     /* Poll needs to drive Tx also in copy mode */
> > +                     __xsk_sendmsg(sock);
> > +     }
> >
> >       if (xs->rx && !xskq_empty_desc(xs->rx))
> >               mask |= POLLIN | POLLRDNORM;
> > --
> > 2.7.4
> >
