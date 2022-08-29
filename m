Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559C55A56ED
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 00:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiH2WQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 18:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiH2WQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 18:16:02 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0846D575
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 15:16:00 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-3376851fe13so230798697b3.6
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 15:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=rqtjA3ycvFVDXfKtFrFvUJoaJ8uMW4Qj8zP4lq7xxuk=;
        b=Zcp7TuQVMdNRqCDTjABe+e6bbyC5h/8l5nChIUF6DqtmLLY4/dhuO1NlihVLDETkwP
         aJd+UJ/ZSS/3BBHWlVnVZiCVTfXAqB2g2pWyOIlilXfXOddpFdRFqNYSmjsaeCC2rzuP
         dXSPye/2e7cDvPehKkidIlm9/tprvWZYYSd4FQIeXaTUnD0f2kfuqiO+FFv+e7V7dfDH
         yN2eNXfaiahoymufGhWUbIn5ZST4qseZd91mOeQm6ZvI4X3gf7zXnNxwnOs9esX5wUw4
         cEjNu1w2xRloqmhhd5u/dOwN2mduw5qa/qq8gocJk3IMeCco/fzQQMT3/JoPKSkfz7kG
         WnwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=rqtjA3ycvFVDXfKtFrFvUJoaJ8uMW4Qj8zP4lq7xxuk=;
        b=TqMj17Pz1xLVCP/kngUujYUgRIPSF14EhAXbKIMP/RWy+4EhO+GPt9fNoKsXlRkQTJ
         DkBCN4DjjLpT/7zqWhgVRnINipIelsya6+pKlAUKGBRcma9Y6e6qMTW+BH7EbfrVrL39
         3s6KtBoQCHJkGHWqIRCCgamQhTVSXd7viM70WCeh8TTmTtGKo5n+vWsulJu/iV2UqUss
         E56e2OqcpMxi8KLQKl0e3V0joH5IlQgO6X9c1baPIzWxF+xGi4jhTKHKQw2BDi52Pges
         xLrt2/GJjLr8WLR5CdmwN7+hdnT4Sf1OqBIyiyzFppq5/uDj0k5b2KJujztpvWP71cjW
         Fzmg==
X-Gm-Message-State: ACgBeo0tEXDujrCSRxze7vZswuIpxvD+oIYuIZq8mZP7QtnqMUr/IsXI
        rlLma2jkBbsWM7qWJLdzibAb9th5zloqu6xxjwoERA==
X-Google-Smtp-Source: AA6agR42PMhqlidw+YU2MJU+wDfmio2UkR5G8PhTe+66ayL9PeCfHy2X4AoWBqPOLUQHO9ryU1vygZGwJryLUIUd7vw=
X-Received: by 2002:a25:7cc6:0:b0:67a:6a2e:3d42 with SMTP id
 x189-20020a257cc6000000b0067a6a2e3d42mr9800590ybc.231.1661811359012; Mon, 29
 Aug 2022 15:15:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220829114648.GA2409@debian>
In-Reply-To: <20220829114648.GA2409@debian>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 29 Aug 2022 15:15:47 -0700
Message-ID: <CANn89iLkfMUK8n5w00naST9J+KrLaAqqg2r0X9Sd-L0XzpLzSQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] net-next: frags: add inetpeer frag_mem tracking
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Martin KaFai Lau <kafai@fb.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-wpan@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
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

On Mon, Aug 29, 2022 at 4:48 AM Richard Gobert <richardbgobert@gmail.com> wrote:
>
> Track per-peer fragment memory usage, using the existing per-fqdir
> memory tracking logic.

This is a rather terse changelog.

We tried to get rid of any dependence over inetpeer, which is not
resistant against DDOS attacks.

So I would not add a new dependency.

Also, tracking memory per peer will not really help in case of bursts ?

>
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> ---
>  include/net/inet_frag.h                 | 11 ++------
>  include/net/inetpeer.h                  |  1 +
>  net/ieee802154/6lowpan/reassembly.c     |  2 +-
>  net/ipv4/inet_fragment.c                | 36 ++++++++++++++++++++-----
>  net/ipv4/inetpeer.c                     |  1 +
>  net/ipv4/ip_fragment.c                  |  4 +--
>  net/ipv6/netfilter/nf_conntrack_reasm.c |  2 +-
>  net/ipv6/reassembly.c                   |  2 +-
>  8 files changed, 38 insertions(+), 21 deletions(-)
>
> diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
> index 05d95fad8a1a..077a0ec78a58 100644
> --- a/include/net/inet_frag.h
> +++ b/include/net/inet_frag.h
> @@ -155,15 +155,8 @@ static inline long frag_mem_limit(const struct fqdir *fqdir)
>         return atomic_long_read(&fqdir->mem);
>  }
>
> -static inline void sub_frag_mem_limit(struct fqdir *fqdir, long val)
> -{
> -       atomic_long_sub(val, &fqdir->mem);
> -}
> -
> -static inline void add_frag_mem_limit(struct fqdir *fqdir, long val)
> -{
> -       atomic_long_add(val, &fqdir->mem);
> -}
> +void sub_frag_mem_limit(struct inet_frag_queue *q, long val);
> +void add_frag_mem_limit(struct inet_frag_queue *q, long val);
>
>  /* RFC 3168 support :
>   * We want to check ECN values of all fragments, do detect invalid combinations.
> diff --git a/include/net/inetpeer.h b/include/net/inetpeer.h
> index 74ff688568a0..1c602a706742 100644
> --- a/include/net/inetpeer.h
> +++ b/include/net/inetpeer.h
> @@ -41,6 +41,7 @@ struct inet_peer {
>         u32                     rate_tokens;    /* rate limiting for ICMP */
>         u32                     n_redirects;
>         unsigned long           rate_last;
> +       atomic_long_t           frag_mem;
>         /*
>          * Once inet_peer is queued for deletion (refcnt == 0), following field
>          * is not available: rid
> diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
> index a91283d1e5bf..0bf207e94082 100644
> --- a/net/ieee802154/6lowpan/reassembly.c
> +++ b/net/ieee802154/6lowpan/reassembly.c
> @@ -135,7 +135,7 @@ static int lowpan_frag_queue(struct lowpan_frag_queue *fq,
>                 fq->q.flags |= INET_FRAG_FIRST_IN;
>
>         fq->q.meat += skb->len;
> -       add_frag_mem_limit(fq->q.fqdir, skb->truesize);
> +       add_frag_mem_limit(&fq->q, skb->truesize);
>
>         if (fq->q.flags == (INET_FRAG_FIRST_IN | INET_FRAG_LAST_IN) &&
>             fq->q.meat == fq->q.len) {
> diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
> index c3ec1dbe7081..8b8d77d548d4 100644
> --- a/net/ipv4/inet_fragment.c
> +++ b/net/ipv4/inet_fragment.c
> @@ -250,6 +250,29 @@ void inet_frag_kill(struct inet_frag_queue *fq)
>  }
>  EXPORT_SYMBOL(inet_frag_kill);
>
> +static inline long peer_mem_limit(const struct inet_frag_queue *q)
> +{
> +       if (!q->peer)
> +               return 0;
> +       return atomic_long_read(&q->peer->frag_mem);
> +}
> +
> +void sub_frag_mem_limit(struct inet_frag_queue *q, long val)
> +{
> +       if (q->peer)
> +               atomic_long_sub(val, &q->peer->frag_mem);
> +       atomic_long_sub(val, &q->fqdir->mem);
> +}
> +EXPORT_SYMBOL(sub_frag_mem_limit);
> +
> +void add_frag_mem_limit(struct inet_frag_queue *q, long val)
> +{
> +       if (q->peer)
> +               atomic_long_add(val, &q->peer->frag_mem);
> +       atomic_long_add(val, &q->fqdir->mem);
> +}
> +EXPORT_SYMBOL(add_frag_mem_limit);
> +
>  static void inet_frag_destroy_rcu(struct rcu_head *head)
>  {
>         struct inet_frag_queue *q = container_of(head, struct inet_frag_queue,
> @@ -306,9 +329,8 @@ void inet_frag_destroy(struct inet_frag_queue *q)
>         sum_truesize = inet_frag_rbtree_purge(&q->rb_fragments);
>         sum = sum_truesize + f->qsize;
>
> +       sub_frag_mem_limit(q, sum);
>         inet_frag_free(q);
> -
> -       sub_frag_mem_limit(fqdir, sum);
>  }
>  EXPORT_SYMBOL(inet_frag_destroy);
>
> @@ -324,7 +346,7 @@ static struct inet_frag_queue *inet_frag_alloc(struct fqdir *fqdir,
>
>         q->fqdir = fqdir;
>         f->constructor(q, arg);
> -       add_frag_mem_limit(fqdir, f->qsize);
> +       add_frag_mem_limit(q, f->qsize);
>
>         timer_setup(&q->timer, f->frag_expire, 0);
>         spin_lock_init(&q->lock);
> @@ -483,7 +505,7 @@ void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
>
>         delta += head->truesize;
>         if (delta)
> -               add_frag_mem_limit(q->fqdir, delta);
> +               add_frag_mem_limit(q, delta);
>
>         /* If the first fragment is fragmented itself, we split
>          * it to two chunks: the first with data and paged part
> @@ -505,7 +527,7 @@ void *inet_frag_reasm_prepare(struct inet_frag_queue *q, struct sk_buff *skb,
>                 head->truesize += clone->truesize;
>                 clone->csum = 0;
>                 clone->ip_summed = head->ip_summed;
> -               add_frag_mem_limit(q->fqdir, clone->truesize);
> +               add_frag_mem_limit(q, clone->truesize);
>                 skb_shinfo(head)->frag_list = clone;
>                 nextp = &clone->next;
>         } else {
> @@ -575,7 +597,7 @@ void inet_frag_reasm_finish(struct inet_frag_queue *q, struct sk_buff *head,
>                         rbn = rbnext;
>                 }
>         }
> -       sub_frag_mem_limit(q->fqdir, sum_truesize);
> +       sub_frag_mem_limit(q, sum_truesize);
>
>         *nextp = NULL;
>         skb_mark_not_on_list(head);
> @@ -604,7 +626,7 @@ struct sk_buff *inet_frag_pull_head(struct inet_frag_queue *q)
>         if (head == q->fragments_tail)
>                 q->fragments_tail = NULL;
>
> -       sub_frag_mem_limit(q->fqdir, head->truesize);
> +       sub_frag_mem_limit(q, head->truesize);
>
>         return head;
>  }
> diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
> index e9fed83e9b3c..6e7325dba417 100644
> --- a/net/ipv4/inetpeer.c
> +++ b/net/ipv4/inetpeer.c
> @@ -216,6 +216,7 @@ struct inet_peer *inet_getpeer(struct inet_peer_base *base,
>                         p->dtime = (__u32)jiffies;
>                         refcount_set(&p->refcnt, 2);
>                         atomic_set(&p->rid, 0);
> +                       atomic_long_set(&p->frag_mem, 0);
>                         p->metrics[RTAX_LOCK-1] = INETPEER_METRICS_NEW;
>                         p->rate_tokens = 0;
>                         p->n_redirects = 0;
> diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
> index d0c22c41cf26..e35061f6aadb 100644
> --- a/net/ipv4/ip_fragment.c
> +++ b/net/ipv4/ip_fragment.c
> @@ -242,7 +242,7 @@ static int ip_frag_reinit(struct ipq *qp)
>         }
>
>         sum_truesize = inet_frag_rbtree_purge(&qp->q.rb_fragments);
> -       sub_frag_mem_limit(qp->q.fqdir, sum_truesize);
> +       sub_frag_mem_limit(&qp->q, sum_truesize);
>
>         qp->q.flags = 0;
>         qp->q.len = 0;
> @@ -339,7 +339,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
>         qp->q.mono_delivery_time = skb->mono_delivery_time;
>         qp->q.meat += skb->len;
>         qp->ecn |= ecn;
> -       add_frag_mem_limit(qp->q.fqdir, skb->truesize);
> +       add_frag_mem_limit(&qp->q, skb->truesize);
>         if (offset == 0)
>                 qp->q.flags |= INET_FRAG_FIRST_IN;
>
> diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
> index 7dd3629dd19e..11ce2335c584 100644
> --- a/net/ipv6/netfilter/nf_conntrack_reasm.c
> +++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
> @@ -269,7 +269,7 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
>         fq->ecn |= ecn;
>         if (payload_len > fq->q.max_size)
>                 fq->q.max_size = payload_len;
> -       add_frag_mem_limit(fq->q.fqdir, skb->truesize);
> +       add_frag_mem_limit(&fq->q, skb->truesize);
>
>         /* The first fragment.
>          * nhoffset is obtained from the first fragment, of course.
> diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
> index ff866f2a879e..cd4ba6cc956b 100644
> --- a/net/ipv6/reassembly.c
> +++ b/net/ipv6/reassembly.c
> @@ -197,7 +197,7 @@ static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
>         fq->q.mono_delivery_time = skb->mono_delivery_time;
>         fq->q.meat += skb->len;
>         fq->ecn |= ecn;
> -       add_frag_mem_limit(fq->q.fqdir, skb->truesize);
> +       add_frag_mem_limit(&fq->q, skb->truesize);
>
>         fragsize = -skb_network_offset(skb) + skb->len;
>         if (fragsize > fq->q.max_size)
> --
> 2.36.1
>
