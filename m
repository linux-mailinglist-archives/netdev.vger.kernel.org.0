Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAA8675FEC
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 23:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjATWKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 17:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjATWKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 17:10:00 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FE5D0D81;
        Fri, 20 Jan 2023 14:09:42 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id e16so6980107ljn.3;
        Fri, 20 Jan 2023 14:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r7JMo/8jUy1YwCi30xnqBLGfAJQOml4Ba08RGnQLTpM=;
        b=e7Ogm9vHshuNm0fmYMOOMTQBjRIfYf9q3y75nC7pXX7JxBiHeQvNy0yUopH4PTKgTi
         50x8UUqqL1VWG9FvuLxk6sFpG8ZFqbicSXVw3esTESwyyOeHMB5LVYrdfOoVXc+ojukx
         hqMgQebY4dpx2rIBVv51iL4Ju8wPN7nQTs3StE90386JTPOVsFrTWS1XCRe5ZaQJj/Ad
         lCO1IXlbx4BKasOOlvYmIxmssHrPtHgh99AEsesKcgPF5RVCE65rG6Z3VglyILtfRQqt
         /1eqjUpQsUNAAHhztiznsJLgP14Mke7zUndI9VvhLYH3YYYx5EM1k8QCMladyU+dVVPq
         8C1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r7JMo/8jUy1YwCi30xnqBLGfAJQOml4Ba08RGnQLTpM=;
        b=HlduWYqOa5yfoka6O4SYgJrn6J8dUEOj6JFm+A22b+AGXb5o1aqvZIxqWGvXgdogVF
         Szx8zg5nZwfinAfCm5mlCjz+MHNj0E/oXR5MwZPklLOMqxHkWKq+rbsvHRAXEdWcCp42
         6u86H8Cfc4Ns7EKpp4Y29cGXS4BNxWyKjKeKIxPMgisGAD1sTe2Tlos6NTTX76jE5DM8
         GrE/Q9DcSNdRexG83kZUIJXwTTGdibYTSngXuHEmAHWW5jabgxFQV2Y+scLJsDORzje1
         B85JhgWfo0w7gJQ/yeNHxi3jxP7tnW0Y9QwkIVjKi5OTEY9l/6n7qJLs86HT2JwpYacX
         /aHg==
X-Gm-Message-State: AFqh2kq63EF3Je0+8Jq0E0RtNIENrY2LjX4mEkDDVoeR7v7sOhIkElta
        xJDKi4n9f2OJYJ6Uoo18E+hZWJu6pUjCPAdEjwPPP/dai6Q=
X-Google-Smtp-Source: AMrXdXsT+fIOKoxg6t5uKBfK4/Jl0IjZ54vG6SSY0YhbeY6uks905xPeZy4szEEgG7OW68et2YzM91+A9/dDv/ehjK8=
X-Received: by 2002:a2e:b94f:0:b0:28b:88b3:2ead with SMTP id
 15-20020a2eb94f000000b0028b88b32eadmr1397218ljs.293.1674252580252; Fri, 20
 Jan 2023 14:09:40 -0800 (PST)
MIME-Version: 1.0
References: <20230119013405.3870506-1-iam@sung-woo.kim> <CANn89iK6DZodENC8pR-toW_n5-VFyQR8X1XOuG9Lx1-kr1tmqQ@mail.gmail.com>
In-Reply-To: <CANn89iK6DZodENC8pR-toW_n5-VFyQR8X1XOuG9Lx1-kr1tmqQ@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 20 Jan 2023 14:09:28 -0800
Message-ID: <CABBYNZLifwiJdeKmH4Abpe_uU_1BaCCPhuaUH=DtGLqGNFHHpQ@mail.gmail.com>
Subject: Re: [PATCH] L2CAP: Fix null-ptr-deref in l2cap_sock_set_shutdown_cb
To:     Eric Dumazet <edumazet@google.com>
Cc:     Sungwoo Kim <iam@sung-woo.kim>, daveti@purdue.edu, wuruoyu@me.com,
        benquike@gmail.com, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:BLUETOOTH SUBSYSTEM" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kim, Eric,

On Wed, Jan 18, 2023 at 8:16 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Jan 19, 2023 at 2:35 AM Sungwoo Kim <iam@sung-woo.kim> wrote:
> >
> > The L2CAP socket shutdown invokes l2cap_sock_destruct without a lock
> > on conn->chan_lock, assigning NULL to chan->data *just before*
> > the l2cap_disconnect_req thread that accesses to chan->data.
>
> This is racy then ?
>
> > This patch prevent it by adding a null check for a workaround, instead
> > of fixing a lock.
>
> This would at least require some barriers I think.
>
> What about other _cb helpers also reading/using chan->data ?

Perhaps it would be a good idea to include the stack backtrace so we
can better understand it, at some point we might need to refactor or
locks to avoid circular dependencies.

> >
> > This bug is found by FuzzBT, a modified Syzkaller by Sungwoo Kim(me).
> > Ruoyu Wu(wuruoyu@me.com) and Hui Peng(benquike@gmail.com) has helped
> > the FuzzBT project.
> >
> > Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
>
> I would also add
>
> Fixes: 1bff51ea59a9 ("Bluetooth: fix use-after-free error in
> lock_sock_nested()")

+1

> > ---
> >  net/bluetooth/l2cap_sock.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> > index ca8f07f35..350c7afdf 100644
> > --- a/net/bluetooth/l2cap_sock.c
> > +++ b/net/bluetooth/l2cap_sock.c
> > @@ -1681,9 +1681,11 @@ static void l2cap_sock_set_shutdown_cb(struct l2cap_chan *chan)
> >  {
> >         struct sock *sk = chan->data;
> >
>
> Other similar fixes simply do:
>
>      if (!sk)
>           return;
>
> I would chose to use the same coding style in net/bluetooth/l2cap_sock.c

Yep, at least l2cap_sock_close_cb and l2cap_sock_shutdown do that already.

>
> > -       lock_sock(sk);
> > -       sk->sk_shutdown = SHUTDOWN_MASK;
> > -       release_sock(sk);
> > +       if (!sk) {
> > +               lock_sock(sk);
> > +               sk->sk_shutdown = SHUTDOWN_MASK;
> > +               release_sock(sk);
> > +       }
> >  }
> >
> >  static long l2cap_sock_get_sndtimeo_cb(struct l2cap_chan *chan)
> > --
> > 2.25.1
> >



-- 
Luiz Augusto von Dentz
