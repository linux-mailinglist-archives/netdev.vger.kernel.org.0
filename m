Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFEE5A6CE1
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 17:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbfICP1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 11:27:07 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44557 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728122AbfICP1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 11:27:06 -0400
Received: by mail-qt1-f194.google.com with SMTP id u40so11795489qth.11;
        Tue, 03 Sep 2019 08:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2BslGMqR0B0fw9ANYmp3iM0FumCNAlK+G6wQM1eUVr0=;
        b=KsEg44dF0La+5x71xcdCIvvaAnFk5h+qDUFH0UzMq2Mynu+T9Y/Aco1g76RcbGl7j8
         T2VQn6SESvjzw9TLWv1vuFXWiFM+yu317D4xS65Vs30YCUTyrPvqfiYMU/HwAVlzkLR/
         Yr3bystimdNGdvbklTw3utuwQqrvcDM1LOg+JXKbuw80HbgMr3CsvohnX1oNCSsSh4IN
         IhVdLtIJ0qVNFHYmHvwtJo6kvcEG0tbpX2oi1siowNFUYwtgPTNBPM9uaiOH7RKmwH9A
         dZRClW/tvaC5AiFsVe+rFQInuW6Rd3Jg6gxfli/T7wRtCxkO75Iw+LCKtDnyDuCRbJl2
         9bUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2BslGMqR0B0fw9ANYmp3iM0FumCNAlK+G6wQM1eUVr0=;
        b=uL3icIX2ls4SbBr6U6W1pe0tYFMMBzDuF2XsQHOJLLBQyaUjSiBGHxTYNba8yrhI3i
         XOgdFXO8UGVxwp5PICRi/HRclByEVbcUGGaXU3fYV/fJyQlciA1UYC+d1uskF241t5FP
         nsW/yZTD8qLTfu4nOwCUerGO5afmjZaEK0VVSmZY6Wj/4FL6xL6xpYgbSYbpSRTsSYGh
         0Q6MTE7Pi7nvlIMnqAtKXZE45gmPvsn7m87qlslMFym+855Kcyt30e4lIGGDkRmiNAVN
         py/OSKfYAwl1ynQlnUdyIDLccsWHoU92ZrkfntEiKs/vzf9/w0yvYu9venw79epdEazp
         f9GA==
X-Gm-Message-State: APjAAAUOL1riyK733PpkRwEDlCjExB7sFH9bPK0ctvWSsWPSmrWgQveW
        2+OevugWAC+L9xM3gdfocI4+5lsrW5NDrKmiC8TgyRu4bbY=
X-Google-Smtp-Source: APXvYqx8jnmuK8yPpc9WctAL9AsNxm4uJhTZ7ZjNE8V92zLxCEZ3/5gDcbuOjgt3TyoBCNc5+wU6oslUOXnj8Ag49lM=
X-Received: by 2002:ac8:23b9:: with SMTP id q54mr8411417qtq.107.1567524425198;
 Tue, 03 Sep 2019 08:27:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190826061053.15996-1-bjorn.topel@gmail.com> <20190826061053.15996-3-bjorn.topel@gmail.com>
 <b580a3c0-c7c2-2191-997b-473ae65f977e@iogearbox.net>
In-Reply-To: <b580a3c0-c7c2-2191-997b-473ae65f977e@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 3 Sep 2019 17:26:53 +0200
Message-ID: <CAJ+HfNhWFAVzrLshMOts7nLBwK=6ythCeCAY6N-puhpi=RnSAw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/4] xsk: add proper barriers and {READ,
 WRITE}_ONCE-correctness for state
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        Hillf Danton <hdanton@sina.com>,
        Ilya Maximets <i.maximets@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Sep 2019 at 17:22, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 8/26/19 8:10 AM, Bj=C3=B6rn T=C3=B6pel wrote:
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
> > Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP r=
ings")
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Sorry for the delay.
>
> > ---
> >   net/xdp/xsk.c | 57 ++++++++++++++++++++++++++++++++++++--------------=
-
> >   1 file changed, 40 insertions(+), 17 deletions(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index f3351013c2a5..8fafa3ce3ae6 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -162,10 +162,23 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, stru=
ct xdp_buff *xdp, u32 len)
> >       return err;
> >   }
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
> >   int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
> >   {
> >       u32 len;
> >
> > +     if (!xsk_is_bound(xs))
> > +             return -EINVAL;
> > +
> >       if (xs->dev !=3D xdp->rxq->dev || xs->queue_id !=3D xdp->rxq->que=
ue_index)
> >               return -EINVAL;
> >
> > @@ -362,7 +375,7 @@ static int xsk_sendmsg(struct socket *sock, struct =
msghdr *m, size_t total_len)
> >       struct sock *sk =3D sock->sk;
> >       struct xdp_sock *xs =3D xdp_sk(sk);
> >
> > -     if (unlikely(!xs->dev))
> > +     if (unlikely(!xsk_is_bound(xs)))
> >               return -ENXIO;
> >       if (unlikely(!(xs->dev->flags & IFF_UP)))
> >               return -ENETDOWN;
> > @@ -378,10 +391,15 @@ static unsigned int xsk_poll(struct file *file, s=
truct socket *sock,
> >                            struct poll_table_struct *wait)
> >   {
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
> > @@ -417,10 +435,9 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
> >   {
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
> > @@ -495,7 +512,9 @@ static int xsk_release(struct socket *sock)
> >       local_bh_enable();
> >
> >       xsk_delete_from_maps(xs);
> > +     mutex_lock(&xs->mutex);
> >       xsk_unbind_dev(xs);
> > +     mutex_unlock(&xs->mutex);
> >
> >       xskq_destroy(xs->rx);
> >       xskq_destroy(xs->tx);
> > @@ -589,19 +608,18 @@ static int xsk_bind(struct socket *sock, struct s=
ockaddr *addr, int addr_len)
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
> > @@ -626,10 +644,15 @@ static int xsk_bind(struct socket *sock, struct s=
ockaddr *addr, int addr_len)
> >       xdp_add_sk_umem(xs->umem, xs);
> >
> >   out_unlock:
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
>
> You write with what this barrier matches/pairs, but would be useful for r=
eaders
> to have an explanation against what it protects. I presume to have things=
 like
> xs->umem public as you seem to guard it behind xsk_is_bound() in xsk_poll=
() and
> other cases? Would be great to have a detailed analysis of all this e.g. =
in the
> commit message so one wouldn't need to guess; right now it feels this is =
doing
> many things at once and w/o further explanation of why READ_ONCE() or oth=
ers are
> omitted sometimes. Would be great to get a lot more clarity into this, pe=
rhaps
> splitting it up a bit might also help.
>

I'll address that. Thanks for the review!


Bj=C3=B6rn

> > +             WRITE_ONCE(xs->state, XSK_BOUND);
> > +     }
>
> Thanks,
> Daniel
