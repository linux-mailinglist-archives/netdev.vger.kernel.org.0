Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E145A65DC
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 16:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiH3OD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 10:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiH3ODZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 10:03:25 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF0BB656D
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 07:03:23 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-333a4a5d495so274977797b3.10
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 07:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=CGFO7OgH6voKrr9OjSAVstjT+ewzgyd3fQJOi9t59Jw=;
        b=CEQ6OgkpeQao9BJn46EsEZjy4nFnzmfweRq2svpbSiGNEjZ1ytgy5UTBnh6hcgLVp7
         6SqKfPrFCSo5bH2SW1rO1bps/y+pi7dTqZ8gd7IfS30gIXTmrvFzzSMnVfSCOuFbHCZm
         98y8y0a7X/l6VeVa46dhCsGkF95D4BYJW9DM0Iadr2tuUdX/X1lMbcoqUKnXSFsBlsNI
         c411DVsAq5mnm9JQu9YLO1Ybm1+m/Gb6pByG1bEaAZk0WxFsgbYfbOwELwMz0HqyK2S1
         bCRop03gUVo4gBaTPuLTabsYpEgcUKS9Y3xpnEacNkUK8YVSzJ+Y8RTr8M2x3vv+Egbj
         RNwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=CGFO7OgH6voKrr9OjSAVstjT+ewzgyd3fQJOi9t59Jw=;
        b=4zyg0dWjOgXxAbuluuuT1fMJ9d9c30uzDGXkwBWLNrxN2bJO9k2GKgxkcBLRsFzwkU
         Qb1b+TUSkJQOPVH8XoiCxCE6r4qb6y+nmJh7Qqdqt8ZsLfejuRrSS1ZJ6teRJJP0N6wm
         JvOgNnrn3Mu3A7CgWLscQfPVEZFuJDWHL9F3Jy918uDclK+M7zBTLYoLIjLvZoZszX/I
         QoOdGiJrZCS+B1cg6bX2HsC0iUYa1FIlWlZFy0k2/V6pRaH6y5XAk7qjhtvFDfmbe/nv
         Sa6lo2y3iE9eGhfG+7MWRqbIeeUpGL4tZKEM7NRG8Lobm//daKS1aX5kv6B+j0hSejsc
         uHzw==
X-Gm-Message-State: ACgBeo2r1C9QWegzm+qH8OSNvCRmBquQk0ylv63+N4A/AZxEhAMz9pTQ
        B3H2JEAyIZr2O6rE/UGyrGuJ6VTl3/+tIZ/tev9jS7ZyIIg=
X-Google-Smtp-Source: AA6agR4jqIJGQGNDCkSGigSnJUG0zByKin3MeQijGsdUmk1+9fNsem4YhJNAfu3ampv21GAIAr3rDkni6Z2cg54ph40=
X-Received: by 2002:a0d:c681:0:b0:33c:2e21:4756 with SMTP id
 i123-20020a0dc681000000b0033c2e214756mr13883934ywd.467.1661868202819; Tue, 30
 Aug 2022 07:03:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220830123345.1909199-1-chenzhen126@huawei.com>
In-Reply-To: <20220830123345.1909199-1-chenzhen126@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Aug 2022 07:03:11 -0700
Message-ID: <CANn89i+-v3Lzi851UKNWie8242y=760f-fiVELjPwSHduLyf5Q@mail.gmail.com>
Subject: Re: [PATCH] tcp: use linear buffer for small frames
To:     Zhen Chen <chenzhen126@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>, yanan@huawei.com,
        Caowangbao <caowangbao@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 5:37 AM Zhen Chen <chenzhen126@huawei.com> wrote:
>
> 472c2e07eef0 ("tcp: add one skb cache for tx") and related patches added a
> machanism to relax slab layer in tcp stack, by caching one skb per socket.
> The feature is disabled by default and the patch also dropped linear payload
> for small frames, which caused about 5% of performance regression for small
> packets because nic drivers would bother to deal with fraglist than before.

I do not think it is true. Which driver exhibits a 5% penalty exactly ?

I decided to not bring back this feature, and instead make TCP stack
less complex.

We want instead to have all TCP payload in page frags, there is still
a part to rewrite (MTU probing),
and maybe retransmit aggregation.

>
> As d8b81175e412 ("tcp: remove sk_{tr}x_skb_cache") reverted the whole
> machanism but skipped the linear part, just make the revert complete.
>
> Signed-off-by: Zhen Chen <chenzhen126@huawei.com>
> ---
>  net/ipv4/tcp.c | 28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index e5011c136fdb..0b6010051598 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1154,6 +1154,30 @@ int tcp_sendpage(struct sock *sk, struct page *page, int offset,
>  }
>  EXPORT_SYMBOL(tcp_sendpage);
>
> +/* Do not bother using a page frag for very small frames.
> + * But use this heuristic only for the first skb in write queue.
> + *
> + * Having no payload in skb->head allows better SACK shifting
> + * in tcp_shift_skb_data(), reducing sack/rack overhead, because
> + * write queue has less skbs.
> + * Each skb can hold up to MAX_SKB_FRAGS * 32Kbytes, or ~0.5 MB.
> + * This also speeds up tso_fragment(), since it wont fallback
> + * to tcp_fragment().
> + */
> +static int linear_payload_sz(bool first_skb)
> +{
> +       if (first_skb)
> +               return SKB_WITH_OVERHEAD(2048 - MAX_TCP_HEADER);
> +       return 0;
> +}
> +
> +static int select_size(bool first_skb, bool zc)
> +{
> +       if (zc)
> +               return 0;
> +       return linear_payload_sz(first_skb);
> +}
> +
>  void tcp_free_fastopen_req(struct tcp_sock *tp)
>  {
>         if (tp->fastopen_req) {
> @@ -1311,6 +1335,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>
>                 if (copy <= 0 || !tcp_skb_can_collapse_to(skb)) {
>                         bool first_skb;
> +                       int linear;
>
>  new_segment:
>                         if (!sk_stream_memory_free(sk))
> @@ -1322,7 +1347,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>                                         goto restart;
>                         }
>                         first_skb = tcp_rtx_and_write_queues_empty(sk);
> -                       skb = tcp_stream_alloc_skb(sk, 0, sk->sk_allocation,
> +                       linear = select_size(first_skb, zc);
> +                       skb = tcp_stream_alloc_skb(sk, linear, sk->sk_allocation,
>                                                    first_skb);
>                         if (!skb)
>                                 goto wait_for_space;
> --
> 2.23.0
>
