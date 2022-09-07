Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB3F5B09B9
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiIGQH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiIGQHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:07:44 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5243BBD10B
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 09:06:49 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 130so16719954ybz.9
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 09:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=tegUFAqu4QFEqO2BPLPOS9gG1ztOXWQfjWyZiwj/6Xo=;
        b=hT0u+Z7VNWCdhYiFMzz00mZkOYax9N58iVk5xflRw+JIX1gQJGcuV9udxdJyGJAi0V
         Ly+/IlvnfSxnCZRz0rkpZMeAGOMQIvuQl1RBo9uFYopzS9PWaopITD60NNCReDRH4/NR
         RB3bqU+nNwMyuOxUY573Ia7VdToN1PCW2vT0Ki5lKunQOPzpOs8QzO2OXZTKoL1zpj4k
         3tZ9PwHvoP1R3GlPGCY+y8ULGNxPFJbBCHupost6yIGSXniulGTV9+w2p+v/PtrN4mxx
         FXFGcrW8efxLA4q/Oi2L0gUfrbeb9GO1piBahfwFP0Mts4818SMchVc9mJA0lkbYo7Bv
         DmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=tegUFAqu4QFEqO2BPLPOS9gG1ztOXWQfjWyZiwj/6Xo=;
        b=t6eLtpMARYiRtOhUl/p+ObsulVmoDOZmSzx2OKGPZ4NNL+awEVNdpDgc4orSrpz9yb
         OQDl2gAEMQSKvoTHnQXSyc13cvSa8ChdWLLocyUKNUxNpS3CwDr6qWwpe3ARSAC0wI+G
         Rrah/Nx1BPC9fQVf3eijOSTVG6WHDAeAAoEP7/U/fy9r2Xw0p4tRHie+RLvCqRs6iV0/
         FHNUV3JchxW6NTGK1Y+txsa1HUYz+VZ5gASUe56Aj04o5Qg9Rjd8V3zLmw8YxEWMnMjU
         HgIjkZOQtMa8pad/CwAVdxTqT5R27GsCgAHecnSS+0io0uDnIz6sFFYkA6lYsRkTnibZ
         Ka+Q==
X-Gm-Message-State: ACgBeo3fWLRlW5awS7H8QEzenSeR6AgosGaTG9T64YjHchT8FN1eY8It
        Uq8lEnCQI8zcFIy3kgOUGTeWVPS4XZHx/1mzaQVMLg==
X-Google-Smtp-Source: AA6agR7gs5N52PxWGz4u15ojhg7ySQ24I2ZON2mJh5yiNvivxhg5GewGJ5vnuVXUi66xOlGsl9jv3fOesbtTSlQpJk0=
X-Received: by 2002:a5b:888:0:b0:6ad:480c:9b66 with SMTP id
 e8-20020a5b0888000000b006ad480c9b66mr2163379ybq.231.1662566807984; Wed, 07
 Sep 2022 09:06:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220907122505.26953-1-wintera@linux.ibm.com>
In-Reply-To: <20220907122505.26953-1-wintera@linux.ibm.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 7 Sep 2022 09:06:36 -0700
Message-ID: <CANn89iLP15xQjmPHxvQBQ=bWbbVk4_41yLC8o5E97TQWFmRioQ@mail.gmail.com>
Subject: Re: [RFC net] tcp: Fix performance regression for request-response workloads
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        netdev <netdev@vger.kernel.org>, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>
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

On Wed, Sep 7, 2022 at 5:26 AM Alexandra Winter <wintera@linux.ibm.com> wrote:
>
> Since linear payload was removed even for single small messages,
> an additional page is required and we are measuring performance impact.
>
> 3613b3dbd1ad ("tcp: prepare skbs for better sack shifting")
> explicitely allowed "payload in skb->head for first skb put in the queue,
> to not impact RPC workloads."
> 472c2e07eef0 ("tcp: add one skb cache for tx")
> made that obsolete and removed it.
> When
> d8b81175e412 ("tcp: remove sk_{tr}x_skb_cache")
> reverted it, this piece was not reverted and not added back in.
>
> When running uperf with a request-response pattern with 1k payload
> and 250 connections parallel, we measure 13% difference in throughput
> for our PCI based network interfaces since 472c2e07eef0.
> (our IO MMU is sensitive to the number of mapped pages)



>
> Could you please consider allowing linear payload for the first
> skb in queue again? A patch proposal is appended below.

No.

Please add a work around in your driver.

You can increase throughput by 20% by premapping a coherent piece of
memory in which
you can copy small skbs (skb->head included)

Something like 256 bytes per slot in the TX ring.


>
> Kind regards
> Alexandra
>
> ---------------------------------------------------------------
>
> tcp: allow linear skb payload for first in queue
>
> Allow payload in skb->head for first skb in the queue,
> RPC workloads will benefit.
>
> Fixes: 472c2e07eef0 ("tcp: add one skb cache for tx")
> Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
> ---
>  net/ipv4/tcp.c | 39 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 37 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index e5011c136fdb..f7cbccd41d85 100644
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
> + * This also speeds up tso_fragment(), since it won't fallback
> + * to tcp_fragment().
> + */
> +static int linear_payload_sz(bool first_skb)
> +{
> +               if (first_skb)
> +                       return SKB_WITH_OVERHEAD(2048 - MAX_TCP_HEADER);
> +               return 0;
> +}
> +
> +static int select_size(bool first_skb, bool zc)
> +{
> +               if (zc)
> +                       return 0;
> +               return linear_payload_sz(first_skb);
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
> @@ -1322,7 +1347,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>                                         goto restart;
>                         }
>                         first_skb = tcp_rtx_and_write_queues_empty(sk);
> -                       skb = tcp_stream_alloc_skb(sk, 0, sk->sk_allocation,
> +                       linear = select_size(first_skb, zc);
> +                       skb = tcp_stream_alloc_skb(sk, linear,
> +                                                  sk->sk_allocation,
>                                                    first_skb);
>                         if (!skb)
>                                 goto wait_for_space;
> @@ -1344,7 +1371,15 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>                 if (copy > msg_data_left(msg))
>                         copy = msg_data_left(msg);
>
> -               if (!zc) {
> +               /* Where to copy to? */
> +               if (skb_availroom(skb) > 0 && !zc) {
> +                       /* We have some space in skb head. Superb! */
> +                       copy = min_t(int, copy, skb_availroom(skb));
> +                       err = skb_add_data_nocache(sk, skb, &msg->msg_iter,
> +                                                  copy);
> +                       if (err)
> +                               goto do_error;
> +               } else if (!zc) {
>                         bool merge = true;
>                         int i = skb_shinfo(skb)->nr_frags;
>                         struct page_frag *pfrag = sk_page_frag(sk);
> --
> 2.24.3 (Apple Git-128)
>
