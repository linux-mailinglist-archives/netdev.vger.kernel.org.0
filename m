Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3F59C4FE
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 19:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbfHYRG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 13:06:59 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37107 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbfHYRG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 13:06:58 -0400
Received: by mail-qt1-f196.google.com with SMTP id y26so15844493qto.4;
        Sun, 25 Aug 2019 10:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Otdcgcj+ExBxZnLRkNaCV+GkXEHH1zpuYwGW/FeJgQo=;
        b=u2pvdxUIxIPWXlGvJJf94ddEvbHbJoD200s4eBu21btr0l/YRSDH5IJ2h1xTtHXLQK
         IBbU+4SZ/QW7jBU+NUi+F44RvO9c9Jv/aQuF4S99yYiuEwtkUQmKj1fgeD7fdFfLWSZd
         9aPZGQHyTk1U0/fQtMn9e/pHmTVF+qHgv9ToQLiCJwB+uWTBfndd78D4MtXL3AfR5yP8
         oIPbFIr1tta0pBr4boM4toKnaJeTQ6D591j0JF4qVRCjAmRpIma0+yUXEzhycPI84vDe
         JBVAAvBTSmf3XD3F79Dqmu1CV/ybZ0ueg2aHiFHg4wAeEappSkke6v6ECDu4ID67dimw
         KGJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Otdcgcj+ExBxZnLRkNaCV+GkXEHH1zpuYwGW/FeJgQo=;
        b=dcxDUYPF99OAGSlpyZjiYvVzQN5eKPcZTUgtHPsJyA7bjpYqFGZMhfrtXyK6fGUOVl
         clstTfrFNj1JuMo5Qb6QlcsYfcNcOXE/6NI/6RdGtERLteu3eP9RZi5fnlpwmZXPlrze
         wtihUM6Fvysk6bhB0rxuYJS6Xx215BG06GRJxcAg3Uo24fDygIEak7JZYDOdh4xgNh+j
         42JefVVfT5i+/lpwqI+ZDwkHJdlkg6ST8Gcp1zRx20ArxQ7jpBTCczF6Oi+S5GrEDCZU
         zws3dy1L70aXgBd3Yfmf1LrpYW+URa5aKpAnP8RkT5vm+ce/fUvvMP3RYvawUqGYjlQG
         YU+Q==
X-Gm-Message-State: APjAAAXa9q5K4rEtFCPF54TvfKNGg89ZO7EpnjX8xgM+TwrZjiIPO6km
        ijTDo5B4oq2ThtTJ3q6YlEWSFU3Bc348dys2ZPk=
X-Google-Smtp-Source: APXvYqyBb5YTIyhIBqsRXHbZa6Enx3an9Zi4cXwbL1Mddz9sroVp0Tmtf3vD83bqvWJDzFMRC12Lp0cDdbgZ3VIR1sM=
X-Received: by 2002:ad4:50d1:: with SMTP id e17mr12498762qvq.9.1566752817464;
 Sun, 25 Aug 2019 10:06:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190822091306.20581-1-bjorn.topel@gmail.com> <20190822091306.20581-3-bjorn.topel@gmail.com>
 <E18E14E3-3EC2-4A74-BB51-726FCDDA3881@gmail.com>
In-Reply-To: <E18E14E3-3EC2-4A74-BB51-726FCDDA3881@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Sun, 25 Aug 2019 19:06:46 +0200
Message-ID: <CAJ+HfNgH=pcA3nZ7AN-bUh8dSQY3WM0EH75F0mnkLsmRWr+TDw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] xsk: add proper barriers and {READ,
 WRITE}_ONCE-correctness for state
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        Hillf Danton <hdanton@sina.com>,
        Ilya Maximets <i.maximets@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Aug 2019 at 18:46, Jonathan Lemon <jonathan.lemon@gmail.com> wro=
te:
>
>
>
> On 22 Aug 2019, at 2:13, Bj=C3=B6rn T=C3=B6pel wrote:
>
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > The state variable was read, and written outside the control mutex
> > (struct xdp_sock, mutex), without proper barriers and {READ,
> > WRITE}_ONCE correctness.
> >
> > In this commit this issue is addressed, and the state member is now
> > used a point of synchronization whether the socket is setup correctly
> > or not.
> >
> > This also fixes a race, found by syzcaller, in xsk_poll() where umem
> > could be accessed when stale.
> >
> > Suggested-by: Hillf Danton <hdanton@sina.com>
> > Reported-by: syzbot+c82697e3043781e08802@syzkaller.appspotmail.com
> > Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP
> > rings")
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > ---
> >  net/xdp/xsk.c | 57
> > ++++++++++++++++++++++++++++++++++++---------------
> >  1 file changed, 41 insertions(+), 16 deletions(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index f3351013c2a5..31236e61069b 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -162,10 +162,23 @@ static int __xsk_rcv_zc(struct xdp_sock *xs,
> > struct xdp_buff *xdp, u32 len)
> >       return err;
> >  }
> >
> > +static bool xsk_is_bound(struct xdp_sock *xs)
> > +{
> > +     if (READ_ONCE(xs->state) =3D=3D XSK_BOUND) {
> > +             /* Matches smp_wmb() in bind(). */
> > +             smp_rmb();
> > +             return true;
> > +     }
> > +     return false;
> > +}
> > +
> >  int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
> >  {
> >       u32 len;
> >
> > +     if (!xsk_is_bound(xs))
> > +             return -EINVAL;
> > +
> >       if (xs->dev !=3D xdp->rxq->dev || xs->queue_id !=3D
> > xdp->rxq->queue_index)
> >               return -EINVAL;
> >
> > @@ -362,6 +375,8 @@ static int xsk_sendmsg(struct socket *sock, struct
> > msghdr *m, size_t total_len)
> >       struct sock *sk =3D sock->sk;
> >       struct xdp_sock *xs =3D xdp_sk(sk);
> >
> > +     if (unlikely(!xsk_is_bound(xs)))
> > +             return -ENXIO;
> >       if (unlikely(!xs->dev))
> >               return -ENXIO;
>
> Can probably remove the xs->dev check now, replaced by checking
> xs->state, right?
>

Indeed! Thanks for catching; I'll send out a v2.


Bj=C3=B6rn

>
> >       if (unlikely(!(xs->dev->flags & IFF_UP)))
> > @@ -378,10 +393,15 @@ static unsigned int xsk_poll(struct file *file,
> > struct socket *sock,
> >                            struct poll_table_struct *wait)
> >  {
> >       unsigned int mask =3D datagram_poll(file, sock, wait);
> > -     struct sock *sk =3D sock->sk;
> > -     struct xdp_sock *xs =3D xdp_sk(sk);
> > -     struct net_device *dev =3D xs->dev;
> > -     struct xdp_umem *umem =3D xs->umem;
> > +     struct xdp_sock *xs =3D xdp_sk(sock->sk);
> > +     struct net_device *dev;
> > +     struct xdp_umem *umem;
> > +
> > +     if (unlikely(!xsk_is_bound(xs)))
> > +             return mask;
> > +
> > +     dev =3D xs->dev;
> > +     umem =3D xs->umem;
> >
> >       if (umem->need_wakeup)
> >               dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
> > @@ -417,10 +437,9 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
> >  {
> >       struct net_device *dev =3D xs->dev;
> >
> > -     if (!dev || xs->state !=3D XSK_BOUND)
> > +     if (xs->state !=3D XSK_BOUND)
> >               return;
> > -
> > -     xs->state =3D XSK_UNBOUND;
> > +     WRITE_ONCE(xs->state, XSK_UNBOUND);
> >
> >       /* Wait for driver to stop using the xdp socket. */
> >       xdp_del_sk_umem(xs->umem, xs);
> > @@ -495,7 +514,9 @@ static int xsk_release(struct socket *sock)
> >       local_bh_enable();
> >
> >       xsk_delete_from_maps(xs);
> > +     mutex_lock(&xs->mutex);
> >       xsk_unbind_dev(xs);
> > +     mutex_unlock(&xs->mutex);
> >
> >       xskq_destroy(xs->rx);
> >       xskq_destroy(xs->tx);
> > @@ -589,19 +610,18 @@ static int xsk_bind(struct socket *sock, struct
> > sockaddr *addr, int addr_len)
> >               }
> >
> >               umem_xs =3D xdp_sk(sock->sk);
> > -             if (!umem_xs->umem) {
> > -                     /* No umem to inherit. */
> > +             if (!xsk_is_bound(umem_xs)) {
> >                       err =3D -EBADF;
> >                       sockfd_put(sock);
> >                       goto out_unlock;
> > -             } else if (umem_xs->dev !=3D dev || umem_xs->queue_id !=
=3D qid) {
> > +             }
> > +             if (umem_xs->dev !=3D dev || umem_xs->queue_id !=3D qid) =
{
> >                       err =3D -EINVAL;
> >                       sockfd_put(sock);
> >                       goto out_unlock;
> >               }
> > -
> >               xdp_get_umem(umem_xs->umem);
> > -             xs->umem =3D umem_xs->umem;
> > +             WRITE_ONCE(xs->umem, umem_xs->umem);
> >               sockfd_put(sock);
> >       } else if (!xs->umem || !xdp_umem_validate_queues(xs->umem)) {
> >               err =3D -EINVAL;
> > @@ -626,10 +646,15 @@ static int xsk_bind(struct socket *sock, struct
> > sockaddr *addr, int addr_len)
> >       xdp_add_sk_umem(xs->umem, xs);
> >
> >  out_unlock:
> > -     if (err)
> > +     if (err) {
> >               dev_put(dev);
> > -     else
> > -             xs->state =3D XSK_BOUND;
> > +     } else {
> > +             /* Matches smp_rmb() in bind() for shared umem
> > +              * sockets, and xsk_is_bound().
> > +              */
> > +             smp_wmb();
> > +             WRITE_ONCE(xs->state, XSK_BOUND);
> > +     }
> >  out_release:
> >       mutex_unlock(&xs->mutex);
> >       rtnl_unlock();
> > @@ -869,7 +894,7 @@ static int xsk_mmap(struct file *file, struct
> > socket *sock,
> >       unsigned long pfn;
> >       struct page *qpg;
> >
> > -     if (xs->state !=3D XSK_READY)
> > +     if (READ_ONCE(xs->state) !=3D XSK_READY)
> >               return -EBUSY;
> >
> >       if (offset =3D=3D XDP_PGOFF_RX_RING) {
> > --
> > 2.20.1
