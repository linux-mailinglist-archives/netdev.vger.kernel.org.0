Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689346C81B2
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 16:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbjCXPpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 11:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjCXPph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 11:45:37 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B612C92
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 08:45:36 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id z11so1527056pfh.4
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 08:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679672736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZj0Vs3wh2/rgn+xmm+lkXUj+Qn97soLIs75BzCzAsw=;
        b=gmu7Vy/THAKSmJUWnfATXSpx8duLtaCLzfIbWMjOehkl4PNZ+dg2PBGI0mGeJGhL8/
         6syoXpo5B/rs9/R4fojDnkcT8FWZreiDf6S4cTCbUHHLgGt2ifkI1o3qpm25iWsQb1X1
         u8F6jCcLZ9cOgYIak1lptUP1LZoVaHr35thgqwxLGTPtG2hjDq+IO0kQHNu3Vu933yKm
         oxSgHxH9Hdg/JxqpUyRYVW3cih+va0gKnxpTGeXsncY8/7Myc0L3zDY5F0s9mr6uA+Aq
         AQ8lSUGqHjAOb7tjijxnaZGXtXj7rjzhQIZDIwQelgkaxM0HsyYs6x60Ytv1UZwddVZw
         irEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679672736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sZj0Vs3wh2/rgn+xmm+lkXUj+Qn97soLIs75BzCzAsw=;
        b=xsa5NL44WwHoFns9KXgUUYDhnKtBnAmxAcupvK4xf2HBA2rUMl7qB1OF/d6b0ZG4m1
         Hfm/h8j0X+qu8XPMkDH6FgW8Bx478SitSTuh/gnXTu5Of96tfACy0U27P3uLkRqz3U3i
         JZRSc6i28pQQbkleUDPNILtO3DFAmRDd5HKSW193h30d51rojpBUPgvVYD5dULgpuSdC
         HB9mD4fglEosqWaMVnql8+WuocjuZIqttrSBcq0VrYLvM6icbU4KXeDd29zdRMB1SR5p
         8+6be8XZ6Xccsd6DdxjPFwGif8vzzmBdPCE4LTQxSZ1ElEsrXn8U/m3lizzQS3mKRYyU
         42HQ==
X-Gm-Message-State: AAQBX9d90n6cdKx9rX7iCX9eSDbq4oN7Ve+i1o2n99JKy2PQvR/dVnmk
        ayMFYVDp/fH5lU0UyOh5wJu4caqt8XIINURlJTG73H1g
X-Google-Smtp-Source: AKy350ZsP+Kf+k6irlhNfGJWtNaEfBPEsveB0VxDL5w7DFs7sAxHDQxKe15FewOn+0pz8cX6RBaFF242ZbexcOBaEwY=
X-Received: by 2002:a05:6a00:2e9f:b0:628:1e57:afd7 with SMTP id
 fd31-20020a056a002e9f00b006281e57afd7mr1833835pfb.0.1679672736026; Fri, 24
 Mar 2023 08:45:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230322233028.269410-1-kuba@kernel.org> <5060c11df10c66f56b5ca7ec2ec92333252b084b.camel@gmail.com>
 <20230323200932.7cf30af5@kernel.org>
In-Reply-To: <20230323200932.7cf30af5@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 24 Mar 2023 08:45:23 -0700
Message-ID: <CAKgT0Ufv5Te668Y_tszQfuH0g_Zsn=oErQ8gAfX6FwHRUm+H3A@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, willemb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 8:09=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Thu, 23 Mar 2023 09:05:35 -0700 Alexander H Duyck wrote:
> > > +#define netif_tx_queue_try_stop(txq, get_desc, start_thrs)         \
> > > +   ({                                                              \
> > > +           int _res;                                               \
> > > +                                                                   \
> > > +           netif_tx_stop_queue(txq);                               \
> > > +                                                                   \
> > > +           smp_mb();                                               \
> > > +                                                                   \
> > > +           /* We need to check again in a case another             \
> > > +            * CPU has just made room available.                    \
> > > +            */                                                     \
> > > +           if (likely(get_desc < start_thrs)) {                    \
> > > +                   _res =3D 0;                                      =
 \
> > > +           } else {                                                \
> > > +                   netif_tx_start_queue(txq);                      \
> > > +                   _res =3D -1;                                     =
 \
> > > +           }                                                       \
> > > +           _res;                                                   \
> > > +   })                                                              \
> > > +
> >
> > The issue I see here is that with this being a macro it abstracts away
> > the relationship between get_desc and the memory barrier. At a minimum
> > I think we should be treating get_desc as a function instead of just
> > passing it and its arguments as a single value. Maybe something more
> > like how read_poll_timeout passes the "op" and then uses it as a
> > function with args passed seperately. What we want to avoid is passing
> > a precomuted value to this function as get_desc.
>
> The kdocs hopefully have enough warnings. The issue I see with
> read_poll_timeout() is that I always have to have the definition
> open side by side to match up the arguments. I wish there was
> a way the test that something is not an lval, but I couldn't
> find it :(
>
> Let's see if anyone gets this wrong, you can tell me "I told you so"?

The setup for it makes me really uncomfortable. Passing a function w/
arguments as an argument itself usually implies that it is called
first, not during.

> > In addition I think I would prefer to see _res initialized to the
> > likely value so that we can drop this to one case instead of having to
> > have two. Same thing for the macros below.
>
> Alright.
>
> > > +/**
> > > + * netif_tx_queue_maybe_stop() - locklessly stop a Tx queue, if need=
ed
> > > + * @txq:   struct netdev_queue to stop/start
> > > + * @get_desc:      get current number of free descriptors (see requi=
rements below!)
> > > + * @stop_thrs:     minimal number of available descriptors for queue=
 to be left
> > > + *         enabled
> > > + * @start_thrs:    minimal number of descriptors to re-enable the qu=
eue, can be
> > > + *         equal to @stop_thrs or higher to avoid frequent waking
> > > + *
> > > + * All arguments may be evaluated multiple times, beware of side eff=
ects.
> > > + * @get_desc must be a formula or a function call, it must always
> > > + * return up-to-date information when evaluated!
> > > + * Expected to be used from ndo_start_xmit, see the comment on top o=
f the file.
> > > + *
> > > + * Returns:
> > > + *  0 if the queue was stopped
> > > + *  1 if the queue was left enabled
> > > + * -1 if the queue was re-enabled (raced with waking)
> > > + */
> >
> > We may want to change the values here. The most likely case is "left
> > enabled" with that being the case we probably want to make that the 0
> > case. I would then probably make 1 the re-enabled case and -1 the
> > stopped case.
>
> I chose the return values this way because the important information is
> whether the queue was in fact stopped (in case the macro is used at the
> start of .xmit as a safety check). If stopped is zero caller can check
> !ret vs !!ret.
>
> Seems pretty normal for the kernel function called stop() to return 0
> if it did stop.

Except this isn't "stop", this is "maybe stop". Maybe we should just
do away with the stop/wake messaging and go with something such as a
RTS/CTS type setup. Basically this function is acting as a RTS to
verify that we have room on the ring to place the frame. If we don't
we are stopped. The "wake" function is on what is essentially the
receiving end on the other side of the hardware after it has DMAed the
frames and is providing the CTS signal back.

> > With that the decision tree becomes more straightforward as we would do
> > something like:
> >       if (result) {
> >               if (result < 0)
> >                       Increment stopped stat
> >                       return
> >               else
> >                       Increment restarted stat
> >       }
>
> Do you see a driver where it matters? ixgbe and co. use
> netif_tx_queue_try_stop() and again they just test stopped vs not stopped=
.

The thing is in order to make this work for the ixgbe patch you didn't
use the maybe_stop instead you went with the try_stop. If you replaced
the ixgbe_maybe_stop_tx with your maybe stop would have to do
something such as the code above to make it work. That is what I am
getting at. From what I can tell the only real difference between
ixgbe_maybe_stop_tx and your maybe_stop is that you avoided having to
move the restart_queue stat increment out.

The general thought is I would prefer to keep it so that 0 is the
default most likely case in both where the queue is enabled and is
still enabled. By moving the "take action" items into the 1/-1 values
then it becomes much easier to sort them out with 1 being a stat
increment and -1 being an indication to stop transmitting and prep for
watchdog hang if we don't clear this in the next watchdog period.

Also in general it makes it easier to understand if these all work
with the same logic.

> > In addition for readability we may want consider adding an enum simliar
> > to the netdev_tx enum as then we have the return types locked and
> > usable should we want to specifically pick out one.
>
> Hm, I thought people generally dislike the netdev_tx enum.
> Maybe it's just me.

The thought I had with the enum is to more easily connect the outcomes
with the sources. It would also help to prevent any confusion on what
is what. Having the two stop/wake functions return different values is
a potential source for errors since 0/1 means different things in the
different functions. Basically since we have 3 possible outcomes using
the enum would make it very clear what the mapping is between the two.

> > > +#define __netif_tx_queue_maybe_wake(txq, get_desc, start_thrs, down_=
cond) \
> > > +   ({                                                              \
> > > +           int _res;                                               \
> > > +                                                                   \
> > > +           if (likely(get_desc < start_thrs))                      \
> > > +                   _res =3D -1;                                     =
 \
> > > +           else                                                    \
> > > +                   _res =3D __netif_tx_queue_try_wake(txq, get_desc,=
 \
> > > +                                                    start_thrs,    \
> > > +                                                    down_cond);    \
> > > +           _res;                                                   \
> > > +   })
> > > +
> >
> > The likely here is probably not correct. In most cases the queue will
> > likely have enough descriptors to enable waking since Tx cleanup can
> > usually run pretty fast compared to the transmit path itself since it
> > can run without needing to take locks.
>
> Good catch, must be a copy paste from the other direction without
> inverting the likely.

Actually the original code had it there in ixgbe although the check
also included total_packets in it which implies that maybe the
assumption was that Tx cleanup wasn't occurring as often as Rx? Either
that or it was a carry-over and had a check for
__netif_subqueue_stopped included in there previously.
