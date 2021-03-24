Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAE434828E
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbhCXUF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237906AbhCXUFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:05:10 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ECE8C061763;
        Wed, 24 Mar 2021 13:05:10 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id c204so18218937pfc.4;
        Wed, 24 Mar 2021 13:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=415I9Q2//om44EgT/R1VG6ftwnvfeEx2NhKqDCrMBY0=;
        b=ciGvS1x1y6xOeCjj+2Ncn8VcoYbqJVT6DugMnr55mcZphcLFEHc6N//CHcKaYyOGly
         k6YYd/3rLEYmfJpPHGaafug+3zX8a/yOIPayLa96YX7jVhQ/gzY8/4Rof9gBKZYhJQOq
         QMLhxv2A93R+ZTeejIvsCHN09lnNBv2McbPxCPYms83yTbaB6W14HB1oDMJhHPMgxKWQ
         whmvTZ3OzJqojwcgMcOGeGIt7RpXCis67jZ+PoPaAXwANujZ3Kz9S48HLCeYSjlT4MZk
         GtkKSWTxlR1ztIEmYhjG6pSwn5xRJPNnIWmOREQ4e7jmQkXSX1xHIYulLg9X9sQ7V4qa
         wJcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=415I9Q2//om44EgT/R1VG6ftwnvfeEx2NhKqDCrMBY0=;
        b=WA2UvzJR+w6rlMaQeRkVdgxQprtFyKdy+bpBN0CEmYSpv1CjWiqjGGZVjwZuai+d7L
         UWevao1zaUJfhQe/cJ4hByhK/fRxru4gzolO3/CyZZv7enG7Ob6h5I72bruRsV4MQ0UM
         Y2UAhwsW0/JOJLBRSngRCGhgE0dNX7hQBDakxixWk/17xIoddGxrSOC6MGjNpKm9sX1+
         4lwfR4evA9vDuKxDSUuJ33JzBhiwwpnzVOJCHnvzmCtjaRwHyVbukpoORwjXqYu8zKrM
         M0nHjCg5n+VS62kjXDFfU0iY8fK3gInapyz6KZFfjBuHTcQrkCR4Pr+Gf0POUIfHC8wr
         3NGw==
X-Gm-Message-State: AOAM532wugJEMzSdsA2wN5wYlaWAgDunK0wySA5g7KCP3XR6W0kqeymf
        Pp5T00xSNWcQJ+u2TvGs0gWfPVwS2+kVk0PkfLHgfq65K+nu4LQD
X-Google-Smtp-Source: ABdhPJwFoIGJg28JMPE1MXdmMMFGCM5OZA9rj4c+gGqQYMO74aTwWtcMX8O5EBzXS2GctbrCjmTwP35V0r44EW4wC5w=
X-Received: by 2002:a63:d842:: with SMTP id k2mr4342566pgj.428.1616616309778;
 Wed, 24 Mar 2021 13:05:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
 <20210323003808.16074-9-xiyou.wangcong@gmail.com> <b510f1da-1442-5297-db95-e21ac8b71042@huawei.com>
In-Reply-To: <b510f1da-1442-5297-db95-e21ac8b71042@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 24 Mar 2021 13:04:58 -0700
Message-ID: <CAM_iQpU4WTegg2eJRBvEcUHs=qGNKMzGswiH14LeLtEbVLMkkg@mail.gmail.com>
Subject: Re: [Patch bpf-next v6 08/12] udp: implement ->read_sock() for sockmap
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 11:31 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/3/23 8:38, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > This is similar to tcp_read_sock(), except we do not need
> > to worry about connections, we just need to retrieve skb
> > from UDP receive queue.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  include/net/udp.h   |  2 ++
> >  net/ipv4/af_inet.c  |  1 +
> >  net/ipv4/udp.c      | 35 +++++++++++++++++++++++++++++++++++
> >  net/ipv6/af_inet6.c |  1 +
> >  4 files changed, 39 insertions(+)
> >
> > diff --git a/include/net/udp.h b/include/net/udp.h
> > index df7cc1edc200..347b62a753c3 100644
> > --- a/include/net/udp.h
> > +++ b/include/net/udp.h
> > @@ -329,6 +329,8 @@ struct sock *__udp6_lib_lookup(struct net *net,
> >                              struct sk_buff *skb);
> >  struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
> >                                __be16 sport, __be16 dport);
> > +int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> > +               sk_read_actor_t recv_actor);
> >
> >  /* UDP uses skb->dev_scratch to cache as much information as possible and avoid
> >   * possibly multiple cache miss on dequeue()
> > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > index 1355e6c0d567..f17870ee558b 100644
> > --- a/net/ipv4/af_inet.c
> > +++ b/net/ipv4/af_inet.c
> > @@ -1070,6 +1070,7 @@ const struct proto_ops inet_dgram_ops = {
> >       .setsockopt        = sock_common_setsockopt,
> >       .getsockopt        = sock_common_getsockopt,
> >       .sendmsg           = inet_sendmsg,
> > +     .read_sock         = udp_read_sock,
> >       .recvmsg           = inet_recvmsg,
> >       .mmap              = sock_no_mmap,
> >       .sendpage          = inet_sendpage,
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 38952aaee3a1..a0adee3b1af4 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -1782,6 +1782,41 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
> >  }
> >  EXPORT_SYMBOL(__skb_recv_udp);
> >
> > +int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> > +               sk_read_actor_t recv_actor)
> > +{
> > +     int copied = 0;
> > +
> > +     while (1) {
> > +             int offset = 0, err;
> > +             struct sk_buff *skb;
> > +
> > +             skb = __skb_recv_udp(sk, 0, 1, &offset, &err);
> > +             if (!skb)
> > +                     break;
>
> Does above error handling need the below additional handling?
> It seems __skb_recv_udp() will return the error by parameter "err",
> if "copied == 0", does it need to return the error?

Not for skmsg case, because the return value is just unused:

static void sk_psock_verdict_data_ready(struct sock *sk)
{
        struct socket *sock = sk->sk_socket;
        read_descriptor_t desc;

        if (unlikely(!sock || !sock->ops || !sock->ops->read_sock))
                return;

        desc.arg.data = sk;
        desc.error = 0;
        desc.count = 1;

        sock->ops->read_sock(sk, &desc, sk_psock_verdict_recv);
}

Thanks.
