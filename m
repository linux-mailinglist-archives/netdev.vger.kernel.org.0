Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7DF3FF088
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 17:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345948AbhIBPys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 11:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234405AbhIBPyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 11:54:44 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977A6C061575;
        Thu,  2 Sep 2021 08:53:45 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id bt14so5499895ejb.3;
        Thu, 02 Sep 2021 08:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wjiK60A2GTYsSOEiStHsCNnHBinVI+innS9X3/HkY6A=;
        b=NraQocpmXy8PTjNMammi7bWOsB3mOCLjofzO5D6yE4j0UEfSXtV9t8eK3MCC06Z4FF
         gu1h0LxZ9Ta9uNidVz3HwhUTe+zaAtnNZMVo59McGG3eseewVYXxWZg7zJWLpsaSGBaL
         Xq9kneXtXiLsEBes3e/0t0bFpFCO7Ur7VPjMKtJ8IHUxly3C4NNSTaFM1v3OGwr5qCJk
         xhmNTZYXmBq2RfffXni52BPeZH0OEYPgBIDXx+QpNFwzSUZ8MIFtTM378YtAzD6wAFJb
         yP7umI262k0GE9RK/sl5Fg9VLyf1XW3gzkqZ7yTAJYJ3Sk4jik1JF6wDso+gnrJrspod
         Wrhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wjiK60A2GTYsSOEiStHsCNnHBinVI+innS9X3/HkY6A=;
        b=H2JkYK4BP90eNo8HH+uq4exqxjJtdudPO/FI+cmTfbzb3jHCdqYlqCiyu3hI7s5bQp
         CqIqXghbjIz8oAosbLBlO9joSuT85w1BYgqMzccpO9R1+8UVlE9GxzqBIBJjQXcJamU9
         16AagyjnsvMihWFbxZUFB6Vph8TAI5mKHAK/XDvjeUde6iCMoTjX5UdR6kOE3UhubWN3
         fCk0VDoulXbCt5kghk3ocFWhOHNsUBoc3fKQUb4g13Y0PBitp7vvNaXmO3v5cEn1oyH6
         3nM7sU6E2yk3M0/WoltJHPYNsHAJXLiOOs8+JFj4mxO1qjaEnOpgXLAxYr1zA9fjabp/
         0b1g==
X-Gm-Message-State: AOAM533r/24T663ZK9h4K4NcxhIkqJrJdjHQHDlH90GloR1gq3GIzRtt
        ZoGQVZaBaQD1aaW7VsQ7yi9M0bEheTkr7qpXMrg=
X-Google-Smtp-Source: ABdhPJxqKevZRGoNwDtwRU3RcR/gmbyBQ32TVMKZV/NAsJVJwajeYZRoGCJOBrzDnSqzRQwqkvwJvm+zKEt+fjMVNE8=
X-Received: by 2002:a17:906:774f:: with SMTP id o15mr4594148ejn.200.1630598024011;
 Thu, 02 Sep 2021 08:53:44 -0700 (PDT)
MIME-Version: 1.0
References: <27f87dd8-f6e4-b2b0-2b3a-9378fddf147f@virtuozzo.com> <053307fc-cc3d-68f5-1994-fe447428b1f2@virtuozzo.com>
In-Reply-To: <053307fc-cc3d-68f5-1994-fe447428b1f2@virtuozzo.com>
From:   Christoph Paasch <christoph.paasch@gmail.com>
Date:   Thu, 2 Sep 2021 08:53:32 -0700
Message-ID: <CALMXkpbZ3R40XVTMOBF5Bhut9Yv_x=a682qg6gEsAMTT5TGhHQ@mail.gmail.com>
Subject: Re: [PATCH net-next v5] skb_expand_head() adjust skb->truesize incorrectly
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel@openvz.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Julian Wiedmann <jwi@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 4:12 AM Vasily Averin <vvs@virtuozzo.com> wrote:
>
> Christoph Paasch reports [1] about incorrect skb->truesize
> after skb_expand_head() call in ip6_xmit.
> This may happen because of two reasons:
> - skb_set_owner_w() for newly cloned skb is called too early,
> before pskb_expand_head() where truesize is adjusted for (!skb-sk) case.
> - pskb_expand_head() does not adjust truesize in (skb->sk) case.
> In this case sk->sk_wmem_alloc should be adjusted too.
>
> [1] https://lkml.org/lkml/2021/8/20/1082
>
> Fixes: f1260ff15a71 ("skbuff: introduce skb_expand_head()")
> Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
> v5: fixed else condition, thanks to Eric
>     reworked update of expanded skb,
>     added corresponding comments
> v4: decided to use is_skb_wmem() after pskb_expand_head() call
>     fixed 'return (EXPRESSION);' in os_skb_wmem according to Eric Dumazet
> v3: removed __pskb_expand_head(),
>     added is_skb_wmem() helper for skb with wmem-compatible destructors
>     there are 2 ways to use it:
>      - before pskb_expand_head(), to create skb clones
>      - after successfull pskb_expand_head() to change owner on extended skb.
> v2: based on patch version from Eric Dumazet,
>     added __pskb_expand_head() function, which can be forced
>     to adjust skb->truesize and sk->sk_wmem_alloc.
> ---
>  include/net/sock.h |  1 +
>  net/core/skbuff.c  | 63 ++++++++++++++++++++++++++++++++++++++++++++++--------
>  net/core/sock.c    |  8 +++++++
>  3 files changed, 63 insertions(+), 9 deletions(-)

Still the same issues around refcount as I reported in my other email.

Did you try running the syzkaller reproducer on your setup?


Christoph

>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 95b2577..173d58c 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1695,6 +1695,7 @@ struct sk_buff *sock_wmalloc(struct sock *sk, unsigned long size, int force,
>                              gfp_t priority);
>  void __sock_wfree(struct sk_buff *skb);
>  void sock_wfree(struct sk_buff *skb);
> +bool is_skb_wmem(const struct sk_buff *skb);
>  struct sk_buff *sock_omalloc(struct sock *sk, unsigned long size,
>                              gfp_t priority);
>  void skb_orphan_partial(struct sk_buff *skb);
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index f931176..29bb92e7 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1804,28 +1804,73 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>  {
>         int delta = headroom - skb_headroom(skb);
> +       int osize = skb_end_offset(skb);
> +       struct sk_buff *oskb = NULL;
> +       struct sock *sk = skb->sk;
>
>         if (WARN_ONCE(delta <= 0,
>                       "%s is expecting an increase in the headroom", __func__))
>                 return skb;
>
> -       /* pskb_expand_head() might crash, if skb is shared */
> +       delta = SKB_DATA_ALIGN(delta);
> +       /* pskb_expand_head() might crash, if skb is shared.
> +        * Also we should clone skb if its destructor does
> +        * not adjust skb->truesize and sk->sk_wmem_alloc
> +        */
>         if (skb_shared(skb)) {
>                 struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
>
> -               if (likely(nskb)) {
> -                       if (skb->sk)
> -                               skb_set_owner_w(nskb, skb->sk);
> -                       consume_skb(skb);
> -               } else {
> +               if (unlikely(!nskb)) {
>                         kfree_skb(skb);
> +                       return NULL;
>                 }
> +               oskb = skb;
>                 skb = nskb;
>         }
> -       if (skb &&
> -           pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
> +       if (pskb_expand_head(skb, delta, 0, GFP_ATOMIC)) {
>                 kfree_skb(skb);
> -               skb = NULL;
> +               kfree_skb(oskb);
> +               return NULL;
> +       }
> +       if (oskb) {
> +               if (sk)
> +                       skb_set_owner_w(skb, sk);
> +               consume_skb(oskb);
> +       } else if (sk && skb->destructor != sock_edemux) {
> +               bool ref, set_owner;
> +
> +               ref = false; set_owner = false;
> +               delta = osize - skb_end_offset(skb);
> +               /* skb_set_owner_w() calls current skb destructor.
> +                * It can decrease sk_wmem_alloc to 0 and release sk,
> +                * To prevnt it we increase sk_wmem_alloc earlier.
> +                * Another kind of destructors can release last sk_refcnt,
> +                * so it will be impossible to call sock_hold for !fullsock
> +                * Take extra sk_refcnt to prevent it.
> +                * Otherwise just increase truesize of expanded skb.
> +                */
> +               refcount_add(delta, &sk->sk_wmem_alloc);
> +               if (!is_skb_wmem(skb)) {
> +                       set_owner = true;
> +                       if (!sk_fullsock(sk) && IS_ENABLED(CONFIG_INET)) {
> +                               /* skb_set_owner_w can set sock_edemux */
> +                               ref = refcount_inc_not_zero(&sk->sk_refcnt);
> +                               if (!ref) {
> +                                       set_owner = false;
> +                                       WARN_ON(refcount_sub_and_test(delta, &sk->sk_wmem_alloc));
> +                               }
> +                       }
> +               }
> +               if (set_owner)
> +                       skb_set_owner_w(skb, sk);
> +#ifdef CONFIG_INET
> +               if (skb->destructor == sock_edemux) {
> +                       WARN_ON(refcount_sub_and_test(delta, &sk->sk_wmem_alloc));
> +                       if (ref)
> +                               WARN_ON(refcount_dec_and_test(&sk->sk_refcnt));
> +               }
> +#endif
> +               skb->truesize += delta;
>         }
>         return skb;
>  }
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 950f1e7..6cbda43 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2227,6 +2227,14 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
>  }
>  EXPORT_SYMBOL(skb_set_owner_w);
>
> +bool is_skb_wmem(const struct sk_buff *skb)
> +{
> +       return skb->destructor == sock_wfree ||
> +              skb->destructor == __sock_wfree ||
> +              (IS_ENABLED(CONFIG_INET) && skb->destructor == tcp_wfree);
> +}
> +EXPORT_SYMBOL(is_skb_wmem);
> +
>  static bool can_skb_orphan_partial(const struct sk_buff *skb)
>  {
>  #ifdef CONFIG_TLS_DEVICE
> --
> 1.8.3.1
>
