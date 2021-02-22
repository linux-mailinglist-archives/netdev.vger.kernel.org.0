Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6315132202B
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 20:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbhBVTaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 14:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbhBVT14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 14:27:56 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA65BC0617AA;
        Mon, 22 Feb 2021 11:27:16 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id q20so7199548pfu.8;
        Mon, 22 Feb 2021 11:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tt8kKDQWH1Fezn3VWHTDtINTZKBtrHB/EcW0kFcmEAI=;
        b=Dll0eaw37WydbTbdMvN5cUAloEt2MuzwkFu71mWn2AWuYBB1jkHwCkNWmzlzc8iy2T
         fSLFykC0ZrysaFjg3CJD3M9RMzVsg65mlWaJISW1c2NG9z0JpYWd2/q0/WTDRC4FSuXp
         K3oPLCgDZEWXOfGmZOVGuNp7eB+gpbZ7At+xVHsNvj3icEXFTTQwkEBHUAYBUAnW1PLU
         H6k2lUS+NKHj2quQcZz1/AmSUbeLhUjkJJH4LTgPnLpd2DtON+1wqLO3iGh+yhfSSAwN
         UM3A/U6460mUR8pxBK16MJFuZbv2FufqMf2Ih62ixQ3tWNVJU2xDNktsJd8fPdQSKoVM
         iRfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tt8kKDQWH1Fezn3VWHTDtINTZKBtrHB/EcW0kFcmEAI=;
        b=Ynqr8KxMX8xotyryfEr2LQy48hYUMSeF6YM5ET1v/SHtmAjF9jyUmcRHlqLkoQM/p3
         zkHmZiLvkHNuRaDEQhSgzhltX/VZanbG+1x7faQ+iEwSQBDtDSjCES+ESA3teVsCQhwJ
         Kt7jPlVMEDjdD42kDWMNy+0sjTgF7vdjvyTpq5WtcCnH19OtLpCQgMtWYQZGwGfoKtwU
         dSADkQn4hXK1ZqPzpDOUd4qbarCu1m8eJcsU6MCn+H/UrP1svbpFWcjGK4EZwr+BTaac
         MgtvClmL8itJpDQ2Otl4HAFOvb/XAry6v7wcbbVn75vEIZSbqQea7gZTWja64PRN4ezA
         OAew==
X-Gm-Message-State: AOAM530EjyUjjHxw4F6VdG63+MP+QRT1Ryd7P4bdUVo0w2uu+Fe2AeEB
        Z/abo+WRErKPehho48i+dnEUjGOggUnHWlw1lDU=
X-Google-Smtp-Source: ABdhPJzaczl+9nOgeDRtZm7H9MhyjbvtsvZgSBlLOfmd6eYji+qoawTctYNI04GAG5o8lAvKFZgfOXuEtlkGhyjX66Y=
X-Received: by 2002:a62:ed01:0:b029:1c8:c6c:16f0 with SMTP id
 u1-20020a62ed010000b02901c80c6c16f0mr15602502pfh.80.1614022036025; Mon, 22
 Feb 2021 11:27:16 -0800 (PST)
MIME-Version: 1.0
References: <20210220052924.106599-1-xiyou.wangcong@gmail.com>
 <20210220052924.106599-5-xiyou.wangcong@gmail.com> <87eeh847ko.fsf@cloudflare.com>
In-Reply-To: <87eeh847ko.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 22 Feb 2021 11:27:04 -0800
Message-ID: <CAM_iQpVS_sJy=sM31pHZVi6njZEAa7Hv_Bkt2sB7JcAjFw3guw@mail.gmail.com>
Subject: Re: [Patch bpf-next v6 4/8] skmsg: move sk_redir from TCP_SKB_CB to skb
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 4:20 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Sat, Feb 20, 2021 at 06:29 AM CET, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Currently TCP_SKB_CB() is hard-coded in skmsg code, it certainly
> > does not work for any other non-TCP protocols. We can move them to
> > skb ext, but it introduces a memory allocation on fast path.
> >
> > Fortunately, we only need to a word-size to store all the information,
> > because the flags actually only contains 1 bit so can be just packed
> > into the lowest bit of the "pointer", which is stored as unsigned
> > long.
> >
> > Inside struct sk_buff, '_skb_refdst' can be reused because skb dst is
> > no longer needed after ->sk_data_ready() so we can just drop it.
> >
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
>
> LGTM. I have some questions (below) that would help me confirm if I
> understand the changes, and what could be improved, if anything.
>
> Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
>
> >  include/linux/skbuff.h |  3 +++
> >  include/linux/skmsg.h  | 35 +++++++++++++++++++++++++++++++++++
> >  include/net/tcp.h      | 19 -------------------
> >  net/core/skmsg.c       | 32 ++++++++++++++++++++------------
> >  net/core/sock_map.c    |  8 ++------
> >  5 files changed, 60 insertions(+), 37 deletions(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 6d0a33d1c0db..bd84f799c952 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -755,6 +755,9 @@ struct sk_buff {
> >                       void            (*destructor)(struct sk_buff *skb);
> >               };
> >               struct list_head        tcp_tsorted_anchor;
> > +#ifdef CONFIG_NET_SOCK_MSG
> > +             unsigned long           _sk_redir;
> > +#endif
> >       };
> >
> >  #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
> > diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> > index e3bb712af257..fc234d507fd7 100644
> > --- a/include/linux/skmsg.h
> > +++ b/include/linux/skmsg.h
> > @@ -459,4 +459,39 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
> >               return false;
> >       return !!psock->saved_data_ready;
> >  }
> > +
> > +#if IS_ENABLED(CONFIG_NET_SOCK_MSG)
> > +static inline bool skb_bpf_ingress(const struct sk_buff *skb)
> > +{
> > +     unsigned long sk_redir = skb->_sk_redir;
> > +
> > +     return sk_redir & BPF_F_INGRESS;
> > +}
> > +
> > +static inline void skb_bpf_set_ingress(struct sk_buff *skb)
> > +{
> > +     skb->_sk_redir |= BPF_F_INGRESS;
> > +}
> > +
> > +static inline void skb_bpf_set_redir(struct sk_buff *skb, struct sock *sk_redir,
> > +                                  bool ingress)
> > +{
> > +     skb->_sk_redir = (unsigned long)sk_redir;
> > +     if (ingress)
> > +             skb->_sk_redir |= BPF_F_INGRESS;
> > +}
> > +
> > +static inline struct sock *skb_bpf_redirect_fetch(const struct sk_buff *skb)
> > +{
> > +     unsigned long sk_redir = skb->_sk_redir;
> > +
> > +     sk_redir &= ~0x1UL;
>
> We're using the enum when setting the bit flag, but a hardcoded constant
> when masking it. ~BPF_F_INGRESS would be more consistent here.

Well, here we need a mask, not a bit, but we don't have a mask yet,
hence I just use hard-coded 0x1. Does #define BPF_F_MASK 0x1UL
look any better?


>
> > +     return (struct sock *)sk_redir;
> > +}
> > +
> > +static inline void skb_bpf_redirect_clear(struct sk_buff *skb)
> > +{
> > +     skb->_sk_redir = 0;
> > +}
> > +#endif /* CONFIG_NET_SOCK_MSG */
> >  #endif /* _LINUX_SKMSG_H */
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index 947ef5da6867..075de26f449d 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -883,30 +883,11 @@ struct tcp_skb_cb {
> >                       struct inet6_skb_parm   h6;
> >  #endif
> >               } header;       /* For incoming skbs */
> > -             struct {
> > -                     __u32 flags;
> > -                     struct sock *sk_redir;
> > -             } bpf;
> >       };
> >  };
> >
> >  #define TCP_SKB_CB(__skb)    ((struct tcp_skb_cb *)&((__skb)->cb[0]))
> >
> > -static inline bool tcp_skb_bpf_ingress(const struct sk_buff *skb)
> > -{
> > -     return TCP_SKB_CB(skb)->bpf.flags & BPF_F_INGRESS;
> > -}
> > -
> > -static inline struct sock *tcp_skb_bpf_redirect_fetch(struct sk_buff *skb)
> > -{
> > -     return TCP_SKB_CB(skb)->bpf.sk_redir;
> > -}
> > -
> > -static inline void tcp_skb_bpf_redirect_clear(struct sk_buff *skb)
> > -{
> > -     TCP_SKB_CB(skb)->bpf.sk_redir = NULL;
> > -}
> > -
> >  extern const struct inet_connection_sock_af_ops ipv4_specific;
> >
> >  #if IS_ENABLED(CONFIG_IPV6)
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index 2d8bbb3fd87c..05b5af09ff42 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -494,6 +494,8 @@ static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb
> >  static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
> >                              u32 off, u32 len, bool ingress)
> >  {
> > +     skb_bpf_redirect_clear(skb);
>
> This is called to avoid leaking state in skb->_skb_refdst. Correct?

This is to teach kfree_skb() not to consider it as a valid _skb_refdst.

>
> I'm wondering why we're doing it every time sk_psock_handle_skb() gets
> invoked from the do/while loop in sk_psock_backlog(), instead of doing
> it once after reading ingress flag with skb_bpf_ingress()?

It should also work, I don't see much difference here, as we almost
always process a full skb, that is, ret == skb->len.


>
> > +
> >       if (!ingress) {
> >               if (!sock_writeable(psock->sk))
> >                       return -EAGAIN;
> > @@ -525,7 +527,7 @@ static void sk_psock_backlog(struct work_struct *work)
> >               len = skb->len;
> >               off = 0;
> >  start:
> > -             ingress = tcp_skb_bpf_ingress(skb);
> > +             ingress = skb_bpf_ingress(skb);
> >               do {
> >                       ret = -EIO;
> >                       if (likely(psock->sk->sk_socket))
> > @@ -631,7 +633,12 @@ void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
> >
> >  static void sk_psock_zap_ingress(struct sk_psock *psock)
> >  {
> > -     __skb_queue_purge(&psock->ingress_skb);
> > +     struct sk_buff *skb;
> > +
> > +     while ((skb = __skb_dequeue(&psock->ingress_skb)) != NULL) {
> > +             skb_bpf_redirect_clear(skb);
>
> I believe we clone the skb before enqueuing it psock->ingress_skb.
> Clone happens either in sk_psock_verdict_recv() or in __strp_recv().
> There are not other users holding a ref, so clearing the redirect seems
> unneeded. Unless I'm missing something?

Yes, skb dst is also cloned:

 980 static void __copy_skb_header(struct sk_buff *new, const struct
sk_buff *old)
 981 {
 982         new->tstamp             = old->tstamp;
 983         /* We do not copy old->sk */
 984         new->dev                = old->dev;
 985         memcpy(new->cb, old->cb, sizeof(old->cb));
 986         skb_dst_copy(new, old);

Also, if without this, dst_release() would complain again. I was not smart
enough to add it in the beginning, dst_release() taught me this lesson. ;)

>
> > +             kfree_skb(skb);
> > +     }
> >       __sk_psock_purge_ingress_msg(psock);
> >  }
> >
> > @@ -752,7 +759,7 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
> >       struct sk_psock *psock_other;
> >       struct sock *sk_other;
> >
> > -     sk_other = tcp_skb_bpf_redirect_fetch(skb);
> > +     sk_other = skb_bpf_redirect_fetch(skb);
> >       /* This error is a buggy BPF program, it returned a redirect
> >        * return code, but then didn't set a redirect interface.
> >        */
> > @@ -802,9 +809,10 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
> >                * TLS context.
> >                */
> >               skb->sk = psock->sk;
> > -             tcp_skb_bpf_redirect_clear(skb);
> > +             skb_dst_drop(skb);
> > +             skb_bpf_redirect_clear(skb);
>
> After skb_dst_drop(), skb->_skb_refdst is clear. So it seems the
> redirect_clear() is not needed. But I'm guessing it is being invoked
> to communicate the intention?

Technically true, but I prefer to call them explicitly, not to rely on the
fact skb->_skb_refdst shares the same storage with skb->_sk_redir,
which would also require some comments to explain.

Thanks.
