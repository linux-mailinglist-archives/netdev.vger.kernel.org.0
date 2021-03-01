Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C6B328269
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 16:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236505AbhCAPZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 10:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237190AbhCAPY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 10:24:59 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12897C06178A
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 07:24:04 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id e7so26139599lft.2
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 07:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZYskYZzT8Mtp1aqVAhNLitpiaBzJZJjNc3PMfeChFeE=;
        b=ifLEH7oiOTkSu6An7ABltZuywSSOqxKGKHH5PRknfo9xivsabHYTtxT7d5ApetSt4S
         1TtgC9PmqYoz+mUcEIe+rlaOFcjxagjd7cKgdF/l4IVDj8YeFW1JUJ602wGR1plBiTZ0
         A8nhJUu+Coow60UM//HqWRrFDKrEXa0XH5ytU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZYskYZzT8Mtp1aqVAhNLitpiaBzJZJjNc3PMfeChFeE=;
        b=Wo52GeS0PIDI0r5krKK4AabjHRFSUoPMZHeKqZxiG0ONJ5Xk+K33CS2Q6l3+oepaPB
         au7pPfEnM7poObXviwCeyYcIdN3DryNj11il24mWjfBQQI4B7ElmUuKDOvWk/m7Q+1EE
         FqFqtjnwB/pAViHDvR5KvhIlk+8HpLD746WnUOf1i+CI+fDM/flsJY9Vmsek0Hc0K1PV
         cl9QpFaQ1Ct04KpjXySq4ZaINtuj2L9OR0GIf6C2RzMOG8OXyCfCnykO1YReIX0HUSki
         IrtDDbWge6I2xXhpuvmMcSyQmDhnHuU1jXYqBr/53lIj5z4CzEXedw/eFnyDY9a7GrfV
         p7nw==
X-Gm-Message-State: AOAM530dKsM4ltVlU3+Hpqg2RHJ8K58Qgr7ho8kpGk1/xbA2MmpRpwv/
        /rkflw41THqeZndUIn1FdGWKk42uQjVKZ/UistZKH425YiO5Dg==
X-Google-Smtp-Source: ABdhPJztpfcXFeS6zHf6xtTyl9R2bWKxqC6hpb/6JmEaHoDCrUfnDyIeAHXfjQnahQtgagtjaEPBG4v0gt6ip/iU39A=
X-Received: by 2002:a05:6512:33d1:: with SMTP id d17mr9862562lfg.13.1614612242464;
 Mon, 01 Mar 2021 07:24:02 -0800 (PST)
MIME-Version: 1.0
References: <20210223184934.6054-1-xiyou.wangcong@gmail.com> <20210223184934.6054-5-xiyou.wangcong@gmail.com>
In-Reply-To: <20210223184934.6054-5-xiyou.wangcong@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 1 Mar 2021 15:23:51 +0000
Message-ID: <CACAyw9-L9b+muEm2uFkBi-yRNY1enFGN7zLVvF7kOH2bjSb5+g@mail.gmail.com>
Subject: Re: [Patch bpf-next v7 4/9] skmsg: move sk_redir from TCP_SKB_CB to skb
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Feb 2021 at 18:49, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> Currently TCP_SKB_CB() is hard-coded in skmsg code, it certainly
> does not work for any other non-TCP protocols. We can move them to
> skb ext, but it introduces a memory allocation on fast path.
>
> Fortunately, we only need to a word-size to store all the information,
> because the flags actually only contains 1 bit so can be just packed
> into the lowest bit of the "pointer", which is stored as unsigned
> long.
>
> Inside struct sk_buff, '_skb_refdst' can be reused because skb dst is
> no longer needed after ->sk_data_ready() so we can just drop it.

Hi Cong Wang,

I saw this on patchwork:

include/linux/skbuff.h:932: warning: Function parameter or member
'_sk_redir' not described in 'sk_buff'
New warnings added
0a1
> include/linux/skbuff.h:932: warning: Function parameter or member '_sk_redir' not described in 'sk_buff'
Per-file breakdown

Source: https://patchwork.kernel.org/project/netdevbpf/patch/20210223184934.6054-5-xiyou.wangcong@gmail.com/

Maybe something to follow up on, I'm not sure what the conventions are here.


>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/linux/skbuff.h |  3 +++
>  include/linux/skmsg.h  | 38 ++++++++++++++++++++++++++++++++++++++
>  include/net/tcp.h      | 19 -------------------
>  net/core/skmsg.c       | 31 +++++++++++++++++++------------
>  net/core/sock_map.c    |  8 ++------
>  5 files changed, 62 insertions(+), 37 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 6d0a33d1c0db..bd84f799c952 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -755,6 +755,9 @@ struct sk_buff {
>                         void            (*destructor)(struct sk_buff *skb);
>                 };
>                 struct list_head        tcp_tsorted_anchor;
> +#ifdef CONFIG_NET_SOCK_MSG
> +               unsigned long           _sk_redir;
> +#endif
>         };
>
>  #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 22e26f82de33..e0de45527bb6 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -455,4 +455,42 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
>                 return false;
>         return !!psock->saved_data_ready;
>  }
> +
> +#if IS_ENABLED(CONFIG_NET_SOCK_MSG)
> +
> +/* We only have one bit so far. */
> +#define BPF_F_PTR_MASK ~(BPF_F_INGRESS)
> +
> +static inline bool skb_bpf_ingress(const struct sk_buff *skb)
> +{
> +       unsigned long sk_redir = skb->_sk_redir;
> +
> +       return sk_redir & BPF_F_INGRESS;
> +}
> +
> +static inline void skb_bpf_set_ingress(struct sk_buff *skb)
> +{
> +       skb->_sk_redir |= BPF_F_INGRESS;
> +}
> +
> +static inline void skb_bpf_set_redir(struct sk_buff *skb, struct sock *sk_redir,
> +                                    bool ingress)
> +{
> +       skb->_sk_redir = (unsigned long)sk_redir;
> +       if (ingress)
> +               skb->_sk_redir |= BPF_F_INGRESS;
> +}
> +
> +static inline struct sock *skb_bpf_redirect_fetch(const struct sk_buff *skb)
> +{
> +       unsigned long sk_redir = skb->_sk_redir;
> +
> +       return (struct sock *)(sk_redir & BPF_F_PTR_MASK);
> +}
> +
> +static inline void skb_bpf_redirect_clear(struct sk_buff *skb)
> +{
> +       skb->_sk_redir = 0;
> +}
> +#endif /* CONFIG_NET_SOCK_MSG */
>  #endif /* _LINUX_SKMSG_H */
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 947ef5da6867..075de26f449d 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -883,30 +883,11 @@ struct tcp_skb_cb {
>                         struct inet6_skb_parm   h6;
>  #endif
>                 } header;       /* For incoming skbs */
> -               struct {
> -                       __u32 flags;
> -                       struct sock *sk_redir;
> -               } bpf;
>         };
>  };
>
>  #define TCP_SKB_CB(__skb)      ((struct tcp_skb_cb *)&((__skb)->cb[0]))
>
> -static inline bool tcp_skb_bpf_ingress(const struct sk_buff *skb)
> -{
> -       return TCP_SKB_CB(skb)->bpf.flags & BPF_F_INGRESS;
> -}
> -
> -static inline struct sock *tcp_skb_bpf_redirect_fetch(struct sk_buff *skb)
> -{
> -       return TCP_SKB_CB(skb)->bpf.sk_redir;
> -}
> -
> -static inline void tcp_skb_bpf_redirect_clear(struct sk_buff *skb)
> -{
> -       TCP_SKB_CB(skb)->bpf.sk_redir = NULL;
> -}
> -
>  extern const struct inet_connection_sock_af_ops ipv4_specific;
>
>  #if IS_ENABLED(CONFIG_IPV6)
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 8822001ab3dc..409258367bea 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -525,7 +525,8 @@ static void sk_psock_backlog(struct work_struct *work)
>                 len = skb->len;
>                 off = 0;
>  start:
> -               ingress = tcp_skb_bpf_ingress(skb);
> +               ingress = skb_bpf_ingress(skb);
> +               skb_bpf_redirect_clear(skb);
>                 do {
>                         ret = -EIO;
>                         if (likely(psock->sk->sk_socket))
> @@ -631,7 +632,12 @@ void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
>
>  static void sk_psock_zap_ingress(struct sk_psock *psock)
>  {
> -       __skb_queue_purge(&psock->ingress_skb);
> +       struct sk_buff *skb;
> +
> +       while ((skb = __skb_dequeue(&psock->ingress_skb)) != NULL) {
> +               skb_bpf_redirect_clear(skb);
> +               kfree_skb(skb);
> +       }
>         __sk_psock_purge_ingress_msg(psock);
>  }
>
> @@ -754,7 +760,7 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
>         struct sk_psock *psock_other;
>         struct sock *sk_other;
>
> -       sk_other = tcp_skb_bpf_redirect_fetch(skb);
> +       sk_other = skb_bpf_redirect_fetch(skb);
>         /* This error is a buggy BPF program, it returned a redirect
>          * return code, but then didn't set a redirect interface.
>          */
> @@ -804,9 +810,10 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
>                  * TLS context.
>                  */
>                 skb->sk = psock->sk;
> -               tcp_skb_bpf_redirect_clear(skb);
> +               skb_dst_drop(skb);
> +               skb_bpf_redirect_clear(skb);
>                 ret = sk_psock_bpf_run(psock, prog, skb);
> -               ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
> +               ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
>                 skb->sk = NULL;
>         }
>         sk_psock_tls_verdict_apply(skb, psock->sk, ret);
> @@ -818,7 +825,6 @@ EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
>  static void sk_psock_verdict_apply(struct sk_psock *psock,
>                                    struct sk_buff *skb, int verdict)
>  {
> -       struct tcp_skb_cb *tcp;
>         struct sock *sk_other;
>         int err = -EIO;
>
> @@ -830,8 +836,7 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
>                         goto out_free;
>                 }
>
> -               tcp = TCP_SKB_CB(skb);
> -               tcp->bpf.flags |= BPF_F_INGRESS;
> +               skb_bpf_set_ingress(skb);
>
>                 /* If the queue is empty then we can submit directly
>                  * into the msg queue. If its not empty we have to
> @@ -892,9 +897,10 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
>         skb_set_owner_r(skb, sk);
>         prog = READ_ONCE(psock->progs.skb_verdict);
>         if (likely(prog)) {
> -               tcp_skb_bpf_redirect_clear(skb);
> +               skb_dst_drop(skb);
> +               skb_bpf_redirect_clear(skb);
>                 ret = sk_psock_bpf_run(psock, prog, skb);
> -               ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
> +               ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
>         }
>         sk_psock_verdict_apply(psock, skb, ret);
>  out:
> @@ -1011,9 +1017,10 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
>         skb_set_owner_r(skb, sk);
>         prog = READ_ONCE(psock->progs.skb_verdict);
>         if (likely(prog)) {
> -               tcp_skb_bpf_redirect_clear(skb);
> +               skb_dst_drop(skb);
> +               skb_bpf_redirect_clear(skb);
>                 ret = sk_psock_bpf_run(psock, prog, skb);
> -               ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
> +               ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
>         }
>         sk_psock_verdict_apply(psock, skb, ret);
>  out:
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 1a28a5c2c61e..dbfcd7006338 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -657,7 +657,6 @@ const struct bpf_func_proto bpf_sock_map_update_proto = {
>  BPF_CALL_4(bpf_sk_redirect_map, struct sk_buff *, skb,
>            struct bpf_map *, map, u32, key, u64, flags)
>  {
> -       struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
>         struct sock *sk;
>
>         if (unlikely(flags & ~(BPF_F_INGRESS)))
> @@ -667,8 +666,7 @@ BPF_CALL_4(bpf_sk_redirect_map, struct sk_buff *, skb,
>         if (unlikely(!sk || !sock_map_redirect_allowed(sk)))
>                 return SK_DROP;
>
> -       tcb->bpf.flags = flags;
> -       tcb->bpf.sk_redir = sk;
> +       skb_bpf_set_redir(skb, sk, flags & BPF_F_INGRESS);
>         return SK_PASS;
>  }
>
> @@ -1250,7 +1248,6 @@ const struct bpf_func_proto bpf_sock_hash_update_proto = {
>  BPF_CALL_4(bpf_sk_redirect_hash, struct sk_buff *, skb,
>            struct bpf_map *, map, void *, key, u64, flags)
>  {
> -       struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
>         struct sock *sk;
>
>         if (unlikely(flags & ~(BPF_F_INGRESS)))
> @@ -1260,8 +1257,7 @@ BPF_CALL_4(bpf_sk_redirect_hash, struct sk_buff *, skb,
>         if (unlikely(!sk || !sock_map_redirect_allowed(sk)))
>                 return SK_DROP;
>
> -       tcb->bpf.flags = flags;
> -       tcb->bpf.sk_redir = sk;
> +       skb_bpf_set_redir(skb, sk, flags & BPF_F_INGRESS);
>         return SK_PASS;
>  }
>
> --
> 2.25.1
>


-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
