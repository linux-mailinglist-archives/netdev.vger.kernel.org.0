Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE124B7341
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234691AbiBOPZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:25:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238727AbiBOPZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:25:54 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A458F988
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 07:25:44 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id p5so56882007ybd.13
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 07:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=857+qV47ddm8WE8KTWXLHPQ7djLUydmVO+RXbwgQrfk=;
        b=D/mNPmTVJktt/9sUx/SBEKcVTfsa+TjCn2lpj52UUTHad0PYCP5Y5GRCI5TsYp/Qb4
         +3GRI9/4MzexhaYzhS1sAqdgGVT0f+0MRLF/NNyIfoc/F4Gny6uGGwGZX5yY/oC69zyU
         q7sKT2+fhC81GUp9Tt55QBzS+BOkBsnQqsHYKpOfiPoQZ+Obe1Xgjr8O8vtBz+eAaMa4
         y3o7yKo5gCKZxcglyuEHZlXGeK4UGpDYUtiyhWlGWOVamG4O4oaeCRkDm2Zcpr2kGGK7
         l1pP12h2lndBiXfbkyBb2/wULR3aPBHDIuFoWjZGf3a7HZM2PbN3evJ5bxgQTp+mMTYf
         QD7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=857+qV47ddm8WE8KTWXLHPQ7djLUydmVO+RXbwgQrfk=;
        b=Ix/h7TjI/FqrPRojDTdrYU5g3rjgmx4EoPBfJ1Z+pZw3ZLdhoB0Q+Nf9sd6VEfwIpq
         ygI3um58xplygbX6xt0D8+/I/0Cm6qZAnXBoKbodLisudH37oH4sz0943rLDjT52CJQD
         ZQneB6T+ylqva/yk1rZBp+leHZViboVF2jsh7Y9s2ZEYa8Nx9pYXgA4q46yRZ5VmjHGE
         uNCjIUsuQODewUDDf8UfPHkKuQD8cNRDAXsFahESRCVx6oH/DkmC++h0GlAadKQyLTfQ
         ND1719y09yuyTLti4L1ukk9Fl+nIsT2Vgz4vQ6YdjuQfD55P5xqXNY84LDvg1zNZ70iB
         QeJQ==
X-Gm-Message-State: AOAM5303PrbjG0BM+icJTdRg4NXE2uer67WwMTUllsNQeTEiFi5ir/WT
        ok/N2cDTgy6OxZnnPw53swLu92YS5VumR3NIPvFimcGBu3pbcxbQDho=
X-Google-Smtp-Source: ABdhPJxk7mrbL3RMym2ruQfovDQ1leVFG4JQH55yguTM8qjJSu1NPA/AjTgXDZUUTMFqhfKeqlX581mdgioFNv/nHJw=
X-Received: by 2002:a81:ff05:: with SMTP id k5mr4176036ywn.474.1644938742804;
 Tue, 15 Feb 2022 07:25:42 -0800 (PST)
MIME-Version: 1.0
References: <20220215103639.11739-1-kerneljasonxing@gmail.com>
In-Reply-To: <20220215103639.11739-1-kerneljasonxing@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 15 Feb 2022 07:25:31 -0800
Message-ID: <CANn89iL8vOUOH9bZaiA-cKcms+PotuKCxv7LpVx3RF0dDDSnmg@mail.gmail.com>
Subject: Re: [PATCH] net: do not set SOCK_RCVBUF_LOCK if sk_rcvbuf isn't reduced
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Wei Wang <weiwan@google.com>,
        Alexander Aring <aahringo@redhat.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Florian Westphal <fw@strlen.de>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jason Xing <xingwanli@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 2:37 AM <kerneljasonxing@gmail.com> wrote:
>
> From: Jason Xing <xingwanli@kuaishou.com>
>
> Normally, user doesn't care the logic behind the kernel if they're
> trying to set receive buffer via setsockopt. However, if the new value
> of the receive buffer is not smaller than the initial value which is
> sysctl_tcp_rmem[1] implemented in tcp_rcv_space_adjust(), the server's
> wscale will shrink and then lead to the bad bandwidth. I think it is
> not appropriate.

Then do not use SO_RCVBUF ?

It is working as intended really.

>
> Here are some numbers:
> $ sysctl -a | grep rmem
> net.core.rmem_default = 212992
> net.core.rmem_max = 40880000
> net.ipv4.tcp_rmem = 4096        425984  40880000
>
> Case 1
> on the server side
>     # iperf -s -p 5201
> on the client side
>     # iperf -c [client ip] -p 5201
> It turns out that the bandwidth is 9.34 Gbits/sec while the wscale of
> server side is 10. It's good.
>
> Case 2
> on the server side
>     #iperf -s -p 5201 -w 425984
> on the client side
>     # iperf -c [client ip] -p 5201
> It turns out that the bandwidth is reduced to 2.73 Gbits/sec while the
> wcale is 2, even though the receive buffer is not changed at all at the
> very beginning.

Great, you discovered auto tuning is working as intended.

>
> Therefore, I added one condition where only user is trying to set a
> smaller rx buffer. After this patch is applied, the bandwidth of case 2
> is recovered to 9.34 Gbits/sec.
>
> Fixes: e88c64f0a425 ("tcp: allow effective reduction of TCP's rcv-buffer via setsockopt")

This commit has nothing to do with your patch or feature.

> Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> ---
>  net/core/filter.c | 7 ++++---
>  net/core/sock.c   | 8 +++++---
>  2 files changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 4603b7c..99f5d9c 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4795,9 +4795,10 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>                 case SO_RCVBUF:
>                         val = min_t(u32, val, sysctl_rmem_max);
>                         val = min_t(int, val, INT_MAX / 2);
> -                       sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
> -                       WRITE_ONCE(sk->sk_rcvbuf,
> -                                  max_t(int, val * 2, SOCK_MIN_RCVBUF));
> +                       val = max_t(int, val * 2, SOCK_MIN_RCVBUF);
> +                       if (val < sock_net(sk)->ipv4.sysctl_tcp_rmem[1])
> +                               sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
> +                       WRITE_ONCE(sk->sk_rcvbuf, val);
>                         break;
>                 case SO_SNDBUF:
>                         val = min_t(u32, val, sysctl_wmem_max);
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 4ff806d..e5e9cb0 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -923,8 +923,6 @@ static void __sock_set_rcvbuf(struct sock *sk, int val)
>          * as a negative value.
>          */
>         val = min_t(int, val, INT_MAX / 2);
> -       sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
> -
>         /* We double it on the way in to account for "struct sk_buff" etc.
>          * overhead.   Applications assume that the SO_RCVBUF setting they make
>          * will allow that much actual data to be received on that socket.
> @@ -935,7 +933,11 @@ static void __sock_set_rcvbuf(struct sock *sk, int val)
>          * And after considering the possible alternatives, returning the value
>          * we actually used in getsockopt is the most desirable behavior.
>          */
> -       WRITE_ONCE(sk->sk_rcvbuf, max_t(int, val * 2, SOCK_MIN_RCVBUF));
> +       val = max_t(int, val * 2, SOCK_MIN_RCVBUF);
> +       if (val < sock_net(sk)->ipv4.sysctl_tcp_rmem[1])
> +               sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
> +
> +       WRITE_ONCE(sk->sk_rcvbuf, val);
>  }
>
>  void sock_set_rcvbuf(struct sock *sk, int val)

You are breaking applications that want to set sk->sk_rcvbuf  to a fixed value,
to control memory usage on millions of active sockets in a host.

I think that you want new functionality, with new SO_ socket options,
targeting net-next tree (No spurious FIxes: tag)

For instance letting an application set  or unset  SOCK_RCVBUF_LOCK
would be more useful, and would not break applications.
