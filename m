Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1287C312E7F
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 11:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbhBHKC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 05:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbhBHJ5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 04:57:49 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA459C0617A9
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 01:48:42 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id a25so16219237ljn.0
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 01:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4vg5AOKdz4OrMu6Jjrf3UUawv7FBwCs33NORYyzFGLg=;
        b=Hs4vNpGB9J6X/ZJiBuja8dPoX7H/A1S4RbqkgG5fdRGV8MOL3+uKfrC0VCTsbKkNE3
         A2PWQUZ7X63ldND2RnR3k1m7KG2vSPKe4bSdqij54xqdvQdxa21Ay1PS9MtvWSp//7pV
         BMPdyZpLgo6wt7ditzrr5vwl30+ai3gX3WZ2I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4vg5AOKdz4OrMu6Jjrf3UUawv7FBwCs33NORYyzFGLg=;
        b=Xc1IIm0XUHNaxlovYMX2vktZXbsBFoZDedJtct88Ib6AOPdphWP+oNCOWzLm3KTs7F
         ZA5KPpfJNzHHmfkB2MLyj+jbvOvuhaRls2e9hz9P8C93WtUHBJCV+wn5fkwNPwQHjhl3
         XMBBPfg9Zpi73jSCZbbbSfVevr1siUYYivu1vmmt1b2Q4/eWguO2oN2xj4OB6K8oU2Io
         w6GMP4PeHKFz2YFI/+9oFNZF/AJK1AInoX5R86LxPQZxWCJl4vdCxI2ZntcsayZLRWW5
         Cm56S6wW6zCedj2fUKD5I/XVkeZJPLuh8jXQwIp5tIlefvKaFmG/U9q0F3b+PQ0WKEaN
         UmpA==
X-Gm-Message-State: AOAM532HSYXWpXR4xy43w+Znizyt8TOOMX5MY3j0WI3/12t5uuhUPmXm
        etRBcqx90y/62zPOu2948exC8zayAA0DNVQn+Ft7jw==
X-Google-Smtp-Source: ABdhPJyOph8kLVOxZWvTLh8pnsjRTenz89i0HdOYSTuR190pzH7whxCLCRUKXufuNb1iA2R6AwJokbcGx0geailvO+g=
X-Received: by 2002:a2e:9c8e:: with SMTP id x14mr8920566lji.83.1612777721168;
 Mon, 08 Feb 2021 01:48:41 -0800 (PST)
MIME-Version: 1.0
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com> <20210203041636.38555-9-xiyou.wangcong@gmail.com>
In-Reply-To: <20210203041636.38555-9-xiyou.wangcong@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 8 Feb 2021 09:48:30 +0000
Message-ID: <CACAyw9-is-sTBUyJnNsQBKga9eyKA8m6+qfS-hWBNipwqgaafg@mail.gmail.com>
Subject: Re: [Patch bpf-next 08/19] udp: implement ->read_sock() for sockmap
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Feb 2021 at 04:17, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/net/udp.h  |  2 ++
>  net/ipv4/af_inet.c |  1 +
>  net/ipv4/udp.c     | 34 ++++++++++++++++++++++++++++++++++
>  3 files changed, 37 insertions(+)
>
> diff --git a/include/net/udp.h b/include/net/udp.h
> index 13f9354dbd3e..b6b75cabf4e4 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -327,6 +327,8 @@ struct sock *__udp6_lib_lookup(struct net *net,
>                                struct sk_buff *skb);
>  struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
>                                  __be16 sport, __be16 dport);
> +int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> +                 sk_read_actor_t recv_actor);
>
>  /* UDP uses skb->dev_scratch to cache as much information as possible and avoid
>   * possibly multiple cache miss on dequeue()
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index d184d9379a92..4a4c6d3d2786 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1072,6 +1072,7 @@ const struct proto_ops inet_dgram_ops = {
>         .getsockopt        = sock_common_getsockopt,
>         .sendmsg           = inet_sendmsg,
>         .sendmsg_locked    = udp_sendmsg_locked,
> +       .read_sock         = udp_read_sock,
>         .recvmsg           = inet_recvmsg,
>         .mmap              = sock_no_mmap,
>         .sendpage          = inet_sendpage,
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 635e1e8b2968..6dffbcec0b51 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1792,6 +1792,40 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
>  }
>  EXPORT_SYMBOL(__skb_recv_udp);
>
> +int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> +                 sk_read_actor_t recv_actor)
> +{
> +       struct sk_buff *skb;
> +       int copied = 0, err;
> +
> +       while (1) {
> +               int offset = 0;
> +
> +               skb = __skb_recv_udp(sk, 0, 1, &offset, &err);

Seems like err isn't used outside of the loop, is that on purpose? If
yes, how about moving the declaration of err to be with offset. Maybe
rename to ignored?

> +               if (!skb)
> +                       break;
> +               if (offset < skb->len) {
> +                       int used;
> +                       size_t len;
> +
> +                       len = skb->len - offset;
> +                       used = recv_actor(desc, skb, offset, len);
> +                       if (used <= 0) {
> +                               if (!copied)
> +                                       copied = used;
> +                               break;
> +                       } else if (used <= len) {

In which case can used be > len?


> +                               copied += used;
> +                               offset += used;
> +                       }
> +               }
> +               if (!desc->count)
> +                       break;
> +       }
> +
> +       return copied;
> +}
> +
>  /*
>   *     This should be easy, if there is something there we
>   *     return it, otherwise we block.
> --
> 2.25.1
>


--
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
