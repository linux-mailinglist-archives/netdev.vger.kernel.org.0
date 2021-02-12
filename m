Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853DD3198C9
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhBLD3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhBLD3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 22:29:44 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F706C061574;
        Thu, 11 Feb 2021 19:29:04 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id d20so2351601ilo.4;
        Thu, 11 Feb 2021 19:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zSg4XYUt1siEzVhspRTj8dvyyaA+pI87iLzXyWW27do=;
        b=sItZz8TXTChk3BA9ltftZXjWaz5WwLm6OWAZuIP7kETvC59u2SgL0xy3dlzPLVU7GV
         9zwmhzcIk5+25r/9sAgUcVWY0/gFvvkx9viMX4HF0EznNd827B9SL54D0Sd06y+fzfeo
         6I9BhYtcOUalbD/fyS4XI6Usbjf5aMmZCixvh6/UjA2Wqwcf6TH2oJKMPlCEyRB3Klbg
         gwIa8/gM0+0+B9mbri3Ebo3ftHJ1X0aCTBDblHdAEDrHGcejjaUQwucvN644u2pOXMox
         BRDg32tVuogfehoYmrxiI6uoFq5P0bMHnRuj0XICeDTdOPcwPFvm9IzDhpx288dsoWj6
         GMkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zSg4XYUt1siEzVhspRTj8dvyyaA+pI87iLzXyWW27do=;
        b=dgJmWyU0y6dH2TIJG70QC1ytv3NoLfoG+waZlBTBXlGwc90F/8jgeUZAjLmGXFTUp7
         ORgYEJ1kMFMHL8eTdqoniu7MOLyxGMdRxV5k6EHdczE/bK1u5+EcC2gDA+KimCkf426a
         6JOlA3vWZDpSK/AlebD0YHmHAF9KIE3Pr5ZBU92iFOjFqYeQvUyj5xoGC97SHZkVo965
         0pe6myY93zU2HA7kmjLo3e5yCayq9S2lAeANrn7a0bciqvT2PxiZR95IQF3Mm6+rWcWj
         h+MZbT41ai8cy8danqKK3OeQQxN2CnKBbtaCvtap6xOxTdfLCABfYZoatBjqlf8uJk+r
         fLcw==
X-Gm-Message-State: AOAM53210hForYj2GTtm7rXnlEzdtLdGiseJHD9MFIZG2YSVJfjBN4nd
        /85hfH6klkpcxTb8YOuwWD66i/KvxDoUBBbtNSc=
X-Google-Smtp-Source: ABdhPJxT63/7e1Pd7W2/NgRcjFzCOTJLCfMRi4p9vc8hw9LCknJvssFboeQFuSsLC8IiwGuLhjLOtw2NngKM4X393nc=
X-Received: by 2002:a05:6e02:f48:: with SMTP id y8mr900509ilj.97.1613100543408;
 Thu, 11 Feb 2021 19:29:03 -0800 (PST)
MIME-Version: 1.0
References: <20210211185220.9753-1-alobakin@pm.me> <20210211185220.9753-7-alobakin@pm.me>
In-Reply-To: <20210211185220.9753-7-alobakin@pm.me>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 11 Feb 2021 19:28:52 -0800
Message-ID: <CAKgT0Uc=_VereGioEPrvfT8-eL6odvs9PwNxywu4=UC1DPvRNQ@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 06/11] skbuff: remove __kfree_skb_flush()
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yonghong Song <yhs@fb.com>, zhudi <zhudi21@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Florian Westphal <fw@strlen.de>,
        Edward Cree <ecree.xilinx@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 10:57 AM Alexander Lobakin <alobakin@pm.me> wrote:
>
> This function isn't much needed as NAPI skb queue gets bulk-freed
> anyway when there's no more room, and even may reduce the efficiency
> of bulk operations.
> It will be even less needed after reusing skb cache on allocation path,
> so remove it and this way lighten network softirqs a bit.
>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

I'm wondering if you have any actual gains to show from this patch?

The reason why I ask is because the flushing was happening at the end
of the softirq before the system basically gave control back over to
something else. As such there is a good chance for the memory to be
dropped from the cache by the time we come back to it. So it may be
just as expensive if not more so than accessing memory that was just
freed elsewhere and placed in the slab cache.

> ---
>  include/linux/skbuff.h |  1 -
>  net/core/dev.c         |  7 +------
>  net/core/skbuff.c      | 12 ------------
>  3 files changed, 1 insertion(+), 19 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 0a4e91a2f873..0e0707296098 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -2919,7 +2919,6 @@ static inline struct sk_buff *napi_alloc_skb(struct napi_struct *napi,
>  }
>  void napi_consume_skb(struct sk_buff *skb, int budget);
>
> -void __kfree_skb_flush(void);
>  void __kfree_skb_defer(struct sk_buff *skb);
>
>  /**
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 321d41a110e7..4154d4683bb9 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4944,8 +4944,6 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
>                         else
>                                 __kfree_skb_defer(skb);
>                 }
> -
> -               __kfree_skb_flush();
>         }
>
>         if (sd->output_queue) {
> @@ -7012,7 +7010,6 @@ static int napi_threaded_poll(void *data)
>                         __napi_poll(napi, &repoll);
>                         netpoll_poll_unlock(have);
>
> -                       __kfree_skb_flush();
>                         local_bh_enable();
>
>                         if (!repoll)

So it looks like this is the one exception to my comment above. Here
we should probably be adding a "if (!repoll)" before calling
__kfree_skb_flush().

> @@ -7042,7 +7039,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
>
>                 if (list_empty(&list)) {
>                         if (!sd_has_rps_ipi_waiting(sd) && list_empty(&repoll))
> -                               goto out;
> +                               return;
>                         break;
>                 }
>
> @@ -7069,8 +7066,6 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
>                 __raise_softirq_irqoff(NET_RX_SOFTIRQ);
>
>         net_rps_action_and_irq_enable(sd);
> -out:
> -       __kfree_skb_flush();
>  }
>
>  struct netdev_adjacent {
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 1c6f6ef70339..4be2bb969535 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -838,18 +838,6 @@ void __consume_stateless_skb(struct sk_buff *skb)
>         kfree_skbmem(skb);
>  }
>
> -void __kfree_skb_flush(void)
> -{
> -       struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
> -
> -       /* flush skb_cache if containing objects */
> -       if (nc->skb_count) {
> -               kmem_cache_free_bulk(skbuff_head_cache, nc->skb_count,
> -                                    nc->skb_cache);
> -               nc->skb_count = 0;
> -       }
> -}
> -
>  static inline void _kfree_skb_defer(struct sk_buff *skb)
>  {
>         struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
> --
> 2.30.1
>
>
