Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F18513E95
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 00:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352911AbiD1Wkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 18:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351604AbiD1Wkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 18:40:37 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4044F9D2
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 15:37:21 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2f16645872fso68431667b3.4
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 15:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Kq18k+A9z9fDbJsoWzCRz2ZQ7P5bfhjOWyLq2CnmyI=;
        b=PCWZLraXIgFTFShPo5MlBNj6eISV+sbB6V1WewdtqNDvhZop4NsjVxWaq94wS0Is+E
         Du0gdQd4tcQev5lZxYYtGx2sV4DV9HLM4w8RpxACbvD9zd/9pR7CkClR3d8elk85ZAIy
         nHDfBj8y2SRvNC2o43LNCTRxcfyo8CEzmWQUMB86BKZaKSz9EGw3RQ9Mpxkjab2Q5Xw6
         nPUcPCsJDHiUdztcoND10ld7hFMQOuzsjFaDhWpA3LmLr+6zoY8bHi4NKc8mLY+KWxbg
         cMKISI/tPXLYzU6V9eH4FoCbT90zZR7dZhjLT8FJNTTyvIgkx7RX/NPCuSJ90FmVbARV
         P2Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Kq18k+A9z9fDbJsoWzCRz2ZQ7P5bfhjOWyLq2CnmyI=;
        b=UpfOtL+wCylEYfl61Ozxmc+n/gTynLnpxDDk8407ApX53KCkseosLnXVjdryIlglEN
         J1pWurK3hmQ06mF/81e0b7Y3cCl2LoQeDf4IOk3zn8MM8MVXZaGI+DdF8l+0Npfe4aMB
         SsDFGT22GeTFpXx8sn1jWNEbvvKToord7+Es3hTM9lYW5hTq9xkideQ8E7mKMSJ7FWl3
         MJPNhY4hJoWxfEz8rywW80Pg7m1cWWRDzv8pPxHohp7YUXqIzZc9ft3rzY+AZWDnUXS7
         JaJJpjTaKZe6Eue+UtNxIzksvd4WzIm6wc6KpCjjkXnut/f6/8SdZFhZ1JsLKStHLrVb
         DX6A==
X-Gm-Message-State: AOAM531Q39Su+w5ZK/tYtV701lNP/4WF1howpc6qvX7KnDYpOzRQe1P1
        xZF6pYskDupQ0NTcHOxlLT0jiZNWnYsRfOCAOCdfBRepqeqcTWN/
X-Google-Smtp-Source: ABdhPJzO4k8D/5yy7/fKX9HTlt9qLrSCisvNh5+Ye72T4gKZlKElkSZUPNSMWXpOeTa3ZRv82rDgp4PrlLITiBnQ2us=
X-Received: by 2002:a81:5603:0:b0:2f8:3187:f37a with SMTP id
 k3-20020a815603000000b002f83187f37amr13888977ywb.255.1651185439944; Thu, 28
 Apr 2022 15:37:19 -0700 (PDT)
MIME-Version: 1.0
References: <064c8731-e7f9-c415-5d4d-141a559e2017@kernel.dk> <20220428151829.675f78b4@kernel.org>
In-Reply-To: <20220428151829.675f78b4@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 28 Apr 2022 15:37:08 -0700
Message-ID: <CANn89iLQLKc6rUaA8k9rTerXP3yhb0seQS4_K7WGVz1nDGKJ3g@mail.gmail.com>
Subject: Re: [PATCH] net: pass back data left in socket after receive
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 3:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 27 Apr 2022 13:49:34 -0600 Jens Axboe wrote:
> > This is currently done for CMSG_INQ, add an ability to do so via struct
> > msghdr as well and have CMSG_INQ use that too. If the caller sets
> > msghdr->msg_get_inq, then we'll pass back the hint in msghdr->msg_inq.
> >
> > Rearrange struct msghdr a bit so we can add this member while shrinking
> > it at the same time. On a 64-bit build, it was 96 bytes before this
> > change and 88 bytes afterwards.
> >
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> LGTM, but I said that once before..  Eric?

For some reason I have not received this patch to my primary email address.

This looks good, but needs to be rebased for net-next, see below ?

Also, maybe the title should reflect that it is really a TCP patch.

>
> FWIW the io_uring patch that uses it is here:
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-flags2
>
> > diff --git a/include/linux/socket.h b/include/linux/socket.h
> > index 6f85f5d957ef..12085c9a8544 100644
> > --- a/include/linux/socket.h
> > +++ b/include/linux/socket.h
> > @@ -50,6 +50,9 @@ struct linger {
> >  struct msghdr {
> >       void            *msg_name;      /* ptr to socket address structure */
> >       int             msg_namelen;    /* size of socket address structure */
> > +
> > +     int             msg_inq;        /* output, data left in socket */
> > +
> >       struct iov_iter msg_iter;       /* data */
> >
> >       /*
> > @@ -62,8 +65,9 @@ struct msghdr {
> >               void __user     *msg_control_user;
> >       };
> >       bool            msg_control_is_user : 1;
> > -     __kernel_size_t msg_controllen; /* ancillary data buffer length */
> > +     bool            msg_get_inq : 1;/* return INQ after receive */
> >       unsigned int    msg_flags;      /* flags on received message */
> > +     __kernel_size_t msg_controllen; /* ancillary data buffer length */
> >       struct kiocb    *msg_iocb;      /* ptr to iocb for async requests */
> >  };
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index cf18fbcbf123..78d79e26fb4d 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -2335,8 +2335,10 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
> >       if (sk->sk_state == TCP_LISTEN)
> >               goto out;
> >
> > -     if (tp->recvmsg_inq)
> > +     if (tp->recvmsg_inq) {
> >               *cmsg_flags = TCP_CMSG_INQ;
> > +             msg->msg_get_inq = 1;
> > +     }
> >       timeo = sock_rcvtimeo(sk, nonblock);
> >
> >       /* Urgent data needs to be handled specially. */
> > @@ -2559,7 +2561,7 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
> >  int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
> >               int flags, int *addr_len)
> >  {
> > -     int cmsg_flags = 0, ret, inq;
> > +     int cmsg_flags = 0, ret;
> >       struct scm_timestamping_internal tss;
> >
> >       if (unlikely(flags & MSG_ERRQUEUE))
> > @@ -2576,12 +2578,14 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
> >       release_sock(sk);
> >       sk_defer_free_flush(sk);

sk_defer_free_flush() has been removed in net-next.

> >
> > -     if (cmsg_flags && ret >= 0) {
> > +     if ((cmsg_flags || msg->msg_get_inq) && ret >= 0) {
> >               if (cmsg_flags & TCP_CMSG_TS)
> >                       tcp_recv_timestamp(msg, sk, &tss);
> > +             if (msg->msg_get_inq)
> > +                     msg->msg_inq = tcp_inq_hint(sk);
> >               if (cmsg_flags & TCP_CMSG_INQ) {
> > -                     inq = tcp_inq_hint(sk);
> > -                     put_cmsg(msg, SOL_TCP, TCP_CM_INQ, sizeof(inq), &inq);
> > +                     put_cmsg(msg, SOL_TCP, TCP_CM_INQ, sizeof(msg->msg_inq),
> > +                              &msg->msg_inq);
> >               }
> >       }
> >       return ret;
> >
>
