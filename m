Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5864B7137
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241246AbiBOQCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 11:02:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241344AbiBOQBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 11:01:48 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D7ABDE59;
        Tue, 15 Feb 2022 08:01:37 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id i21so1455103oie.3;
        Tue, 15 Feb 2022 08:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ogIE3rqM/aOfUAnHNRtYtkVt8rOmyH3L5goPlP4kyqA=;
        b=VjxiXqR92mOimvY8Kw5ArZr35RSjXNFDBaNmcUBG1SFEP4QuaMk+syxkpkFqB4wGXc
         aKBox5mNxLjI4reb0tBBnfuQ1vQHz2ieL6s1f4eE1Yb7HCUXU3sTQnjOri6QmZDkAhZl
         6Xr5wYCYLvcWC2LrSSGnB3rN8+WIy/mNYewgjBTVxRxRp7wB9kO25Dihh0dZpDVN00nI
         cVOGpZ2J29bnIV8hIPau2rlr0rfVK3/h6jmNVXIfjtUcXH3QFkgKpc+Gel5r8VZ2Jvpg
         kQ4daCu+NI8jnUeHnPziITFJss5U+/pQzXTT9MHfNnY83pozojtZ86qOJH/QSA4jDAqe
         A42w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ogIE3rqM/aOfUAnHNRtYtkVt8rOmyH3L5goPlP4kyqA=;
        b=HCz1IX/jtm44+k+Vu6sOOTQlfTC7r3cEXp3TREOFJ6RD/KrVeIziToxdVnQrL73eSY
         tZgWzBP7EQ5s4apTcaD+EYXlf0wAND4FT2QU9CEJMtGYfMgJRcDQBCgNLqDKtx5+ONyW
         gv24swC5gQacNMhTQnkdCtBHDLrLV3zOWzWxZnvw8NrxVD+0cTwYGyxUYGscAD4v8xeJ
         DiJjPfsAg9vbwK1iZsADx1c1Jx0l6ZNSUyG5z05A4K81YveK4GjpWwqR3sRfi8rBXSwr
         e7Hp88MH2ZUc/VDgBaYplUqWntV4yaiN53i1bdnr8FC8NaGDOEFDnRejRPr+J0Q6j2w9
         7CuA==
X-Gm-Message-State: AOAM532o/iY+2qVhJe+KV7DXkIylXiNA3soQuT+s9dUJG8X/X/wQOhg0
        p5nCojM8F3v7ViArQGdrndQm4hGo74Mdsxs/awQ=
X-Google-Smtp-Source: ABdhPJw65k3dA+9fz3XLLBwaVdv9/sS7+jY5+T2JpRKIXdTTwMdeQ5b12JN4FpPn6Z9TWsNMEqstx3f3i09mRE6BwdI=
X-Received: by 2002:a05:6808:219c:b0:2ce:27e2:ecf1 with SMTP id
 be28-20020a056808219c00b002ce27e2ecf1mr1780773oib.129.1644940895203; Tue, 15
 Feb 2022 08:01:35 -0800 (PST)
MIME-Version: 1.0
References: <20220215103639.11739-1-kerneljasonxing@gmail.com> <CANn89iL8vOUOH9bZaiA-cKcms+PotuKCxv7LpVx3RF0dDDSnmg@mail.gmail.com>
In-Reply-To: <CANn89iL8vOUOH9bZaiA-cKcms+PotuKCxv7LpVx3RF0dDDSnmg@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 16 Feb 2022 00:00:58 +0800
Message-ID: <CAL+tcoA3CSBFeHFGyxrs8aQhN7=_vKyp3rmAvj+ObTXapJRNiw@mail.gmail.com>
Subject: Re: [PATCH] net: do not set SOCK_RCVBUF_LOCK if sk_rcvbuf isn't reduced
To:     Eric Dumazet <edumazet@google.com>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 11:25 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Feb 15, 2022 at 2:37 AM <kerneljasonxing@gmail.com> wrote:
> >
> > From: Jason Xing <xingwanli@kuaishou.com>
> >
> > Normally, user doesn't care the logic behind the kernel if they're
> > trying to set receive buffer via setsockopt. However, if the new value
> > of the receive buffer is not smaller than the initial value which is
> > sysctl_tcp_rmem[1] implemented in tcp_rcv_space_adjust(), the server's
> > wscale will shrink and then lead to the bad bandwidth. I think it is
> > not appropriate.
>
> Then do not use SO_RCVBUF ?
>
> It is working as intended really.
>
> >
> > Here are some numbers:
> > $ sysctl -a | grep rmem
> > net.core.rmem_default = 212992
> > net.core.rmem_max = 40880000
> > net.ipv4.tcp_rmem = 4096        425984  40880000
> >
> > Case 1
> > on the server side
> >     # iperf -s -p 5201
> > on the client side
> >     # iperf -c [client ip] -p 5201
> > It turns out that the bandwidth is 9.34 Gbits/sec while the wscale of
> > server side is 10. It's good.
> >
> > Case 2
> > on the server side
> >     #iperf -s -p 5201 -w 425984
> > on the client side
> >     # iperf -c [client ip] -p 5201
> > It turns out that the bandwidth is reduced to 2.73 Gbits/sec while the
> > wcale is 2, even though the receive buffer is not changed at all at the
> > very beginning.
>
> Great, you discovered auto tuning is working as intended.
>

Thanks.

> >
> > Therefore, I added one condition where only user is trying to set a
> > smaller rx buffer. After this patch is applied, the bandwidth of case 2
> > is recovered to 9.34 Gbits/sec.
> >
> > Fixes: e88c64f0a425 ("tcp: allow effective reduction of TCP's rcv-buffer via setsockopt")
>
> This commit has nothing to do with your patch or feature.
>
> > Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> > ---
> >  net/core/filter.c | 7 ++++---
> >  net/core/sock.c   | 8 +++++---
> >  2 files changed, 9 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 4603b7c..99f5d9c 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -4795,9 +4795,10 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
> >                 case SO_RCVBUF:
> >                         val = min_t(u32, val, sysctl_rmem_max);
> >                         val = min_t(int, val, INT_MAX / 2);
> > -                       sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
> > -                       WRITE_ONCE(sk->sk_rcvbuf,
> > -                                  max_t(int, val * 2, SOCK_MIN_RCVBUF));
> > +                       val = max_t(int, val * 2, SOCK_MIN_RCVBUF);
> > +                       if (val < sock_net(sk)->ipv4.sysctl_tcp_rmem[1])
> > +                               sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
> > +                       WRITE_ONCE(sk->sk_rcvbuf, val);
> >                         break;
> >                 case SO_SNDBUF:
> >                         val = min_t(u32, val, sysctl_wmem_max);
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index 4ff806d..e5e9cb0 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -923,8 +923,6 @@ static void __sock_set_rcvbuf(struct sock *sk, int val)
> >          * as a negative value.
> >          */
> >         val = min_t(int, val, INT_MAX / 2);
> > -       sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
> > -
> >         /* We double it on the way in to account for "struct sk_buff" etc.
> >          * overhead.   Applications assume that the SO_RCVBUF setting they make
> >          * will allow that much actual data to be received on that socket.
> > @@ -935,7 +933,11 @@ static void __sock_set_rcvbuf(struct sock *sk, int val)
> >          * And after considering the possible alternatives, returning the value
> >          * we actually used in getsockopt is the most desirable behavior.
> >          */
> > -       WRITE_ONCE(sk->sk_rcvbuf, max_t(int, val * 2, SOCK_MIN_RCVBUF));
> > +       val = max_t(int, val * 2, SOCK_MIN_RCVBUF);
> > +       if (val < sock_net(sk)->ipv4.sysctl_tcp_rmem[1])
> > +               sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
> > +
> > +       WRITE_ONCE(sk->sk_rcvbuf, val);
> >  }
> >
> >  void sock_set_rcvbuf(struct sock *sk, int val)
>
> You are breaking applications that want to set sk->sk_rcvbuf  to a fixed value,
> to control memory usage on millions of active sockets in a host.
>
> I think that you want new functionality, with new SO_ socket options,
> targeting net-next tree (No spurious FIxes: tag)
>

I agree with you.

> For instance letting an application set  or unset  SOCK_RCVBUF_LOCK
> would be more useful, and would not break applications.

I would like to change the title of the v2 patch while the title of
this version is a little bit misleading, say, "net: introduce
SO_RCVBUFAUTO to unset SOCK_RCVBUF_LOCK flag".

Eric, what do you think of the new name of this socket option, like
SO_RCVBUFAUTO?

Thanks,
Jason
