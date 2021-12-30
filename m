Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542A64818C0
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhL3Cj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233482AbhL3Cj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:39:58 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95D8C061574;
        Wed, 29 Dec 2021 18:39:57 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id b13so92729249edd.8;
        Wed, 29 Dec 2021 18:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PzrDj5Q5BKAvVTZ1tIziavSlAYzc9I+fn3T9UdbJfFA=;
        b=Nky19qIJOBy9NxF6WXDiM5+bSuQ+/Yg96elrATX4TsJMNDQAspUDXRkEK8LbxDCTeo
         sB6qfTugj9QxAZrydFbS9hjwb19QNN0CIGCCwkJ+GgfsuwBFmm/WFxGm6MeRZbb2f+N5
         Mo3C6C5TZr0lfn+mQZbnyCxPrJjZ2uZao0Q4hJeYeeLyIbM5ZCSd3FrmOBtfYUvUw/iz
         oduhxA8NiMrspiHP4beJqayZej6B3mZsOsQsNzc7Zm7bCJCQtY0oYxrUyNx83HYxbPAt
         SqIN9Dtsaqk5HdXdl8POf5eKTgWBpH88b8JdDeiqSphda4TuFkuLPswXWivK9rsYypQi
         DGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PzrDj5Q5BKAvVTZ1tIziavSlAYzc9I+fn3T9UdbJfFA=;
        b=aVqg9X0k+FKEnaEnrTx7qMQfq806ui18wdVpYB47lYPbYvGg1BzT5LhRtuWEW8qcVT
         CESkJ3llQkvfN8nAyNRtIe9pRwpVjcGintXWPA13c2FW77t2DGDTfHk4iIbsr4STYyzj
         eNZqX8tkl8D0tvo5B/ux7h2M9ccumwllFs9EV5SlMUUDdVMuBst8EtRvZNRUWUamP667
         gExBnPQmm9a2BvHs1gt0GPsRtFygFH9A7KsMg9kZymtO6TMNNT5bMHbgpmrwon6t8xw2
         o81qFvQ+uC4ab9yTRkS8fy0LrnExvheucK9oUXw0r0POkijtrM1PP9V2hpqsJgjVCNgg
         Rx5Q==
X-Gm-Message-State: AOAM530V6VUE0znzf3dXb0KyQ8Z9IZZgH55+A6UVHR2XjYBcj95OsOWb
        W7CvlzIN4ztrjynRJUqmSNGnzUNZpP8qvanJPw4=
X-Google-Smtp-Source: ABdhPJwGPaCQDs1uo93PPULCVgXc9aIew7DoRE9diP3zqwiHQOl2hVm1ZteNjxph75Ag1j7CZ0ka00m/MNdh+629QnI=
X-Received: by 2002:a17:907:2da3:: with SMTP id gt35mr23727920ejc.704.1640831996357;
 Wed, 29 Dec 2021 18:39:56 -0800 (PST)
MIME-Version: 1.0
References: <20211229143205.410731-1-imagedong@tencent.com>
 <20211229143205.410731-3-imagedong@tencent.com> <c3582b56-905c-b6bf-e92e-e6d81ae9f2e0@gmail.com>
In-Reply-To: <c3582b56-905c-b6bf-e92e-e6d81ae9f2e0@gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 30 Dec 2021 10:36:46 +0800
Message-ID: <CADxym3ZfdbUszBvW4LJRzPkJwBaX2g_5+P1_i_BHPKhiatAXVA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: skb: use kfree_skb_with_reason() in tcp_v4_rcv()
To:     David Ahern <dsahern@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        David Ahern <dsahern@kernel.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        jonathan.lemon@gmail.com, alobakin@pm.me,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>, talalahmad@google.com,
        haokexin@gmail.com, Kees Cook <keescook@chromium.org>,
        Menglong Dong <imagedong@tencent.com>, atenart@kernel.org,
        bigeasy@linutronix.de, Wei Wang <weiwan@google.com>, arnd@arndb.de,
        vvs@virtuozzo.com, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 4:18 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 12/29/21 7:32 AM, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > Replace kfree_skb() with kfree_skb_with_reason() in tcp_v4_rcv().
> > Following drop reason are added:
> >
> > SKB_DROP_REASON_NO_SOCK
> > SKB_DROP_REASON_BAD_PACKET
> > SKB_DROP_REASON_TCP_CSUM
> >
> > After this patch, 'kfree_skb' event will print message like this:
> >
> > $           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
> > $              | |         |   |||||     |         |
> >           <idle>-0       [000] ..s1.    36.113438: kfree_skb: skbaddr=(____ptrval____) protocol=2048 location=(____ptrval____) reason: NO_SOCK
> >
> > The reason of skb drop is printed too.
> >
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  include/linux/skbuff.h     |  3 +++
> >  include/trace/events/skb.h |  3 +++
> >  net/ipv4/tcp_ipv4.c        | 10 ++++++++--
>
> your first patch set was targeting UDP and now you are starting with tcp?

Yeah, I think TCP is used more, which can be a good starting point. After
all, general protocols are all my target.

>
>
> >  3 files changed, 14 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 3620b3ff2154..f85db6c035d1 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -313,6 +313,9 @@ struct sk_buff;
> >   */
> >  enum skb_drop_reason {
> >       SKB_DROP_REASON_NOT_SPECIFIED,
> > +     SKB_DROP_REASON_NO_SOCK,
>
> SKB_DROP_REASON_NO_SOCKET
>
> > +     SKB_DROP_REASON_BAD_PACKET,
>
> SKB_DROP_REASON_PKT_TOO_SMALL
>
> User oriented messages, not code based.
>

Ok, get it!

Thanks!
Menglong Dong

>
> > +     SKB_DROP_REASON_TCP_CSUM,
> >       SKB_DROP_REASON_MAX,
> >  };
> >
> > diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
> > index cab1c08a30cd..b9ea6b4ed7ec 100644
> > --- a/include/trace/events/skb.h
> > +++ b/include/trace/events/skb.h
> > @@ -11,6 +11,9 @@
> >
> >  #define TRACE_SKB_DROP_REASON                                        \
> >       EM(SKB_DROP_REASON_NOT_SPECIFIED, NOT_SPECIFIED)        \
> > +     EM(SKB_DROP_REASON_NO_SOCK, NO_SOCK)                    \
> > +     EM(SKB_DROP_REASON_BAD_PACKET, BAD_PACKET)              \
> > +     EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)                  \
> >       EMe(SKB_DROP_REASON_MAX, HAHA_MAX)
> >
> >  #undef EM
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index ac10e4cdd8d0..03dc4c79b84b 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -1971,8 +1971,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
> >       const struct tcphdr *th;
> >       bool refcounted;
> >       struct sock *sk;
> > +     int drop_reason;
> >       int ret;
> >
> > +     drop_reason = 0;
>
>         drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
>
