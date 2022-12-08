Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AB06466DE
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 03:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiLHCVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 21:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiLHCVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 21:21:37 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE354716DF
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 18:21:36 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-3e78d07ab4fso136275157b3.9
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 18:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aR88s3Ybl0DvsKtxthIky8N3akpynVM/kGiV7SX8Qbo=;
        b=B/xBlaIF+jNGf5iiBTKySZ+7r2wiB/6Xv26z88ota5t3XkT+7X3jaFadw+Q82Qq1P0
         chRs2VEEEuIHVszUV9iO786js+VI5QCkZaOa7MevzcJoWFIZ57z0HhX11ZZLuJ5X14gR
         sr6drNTXHEhi9WRx5ZRMcB1GRSgBHLx/f4zFnwlpW/tqzcOJmZfbt9lLChFr97uz23uc
         A/O+w/60sZ/qChHf12ohkzNBzMwLAxUf+lrI+7EgmLTzv6iugqzCVAUpcaIuZ9uSpAer
         +TUeVkG4BuvM0apTeklDKZzFz+HyOsWzs8xkxWZPVI6mwkfeLH2ZQZcea/0ZKlkQBl34
         b4rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aR88s3Ybl0DvsKtxthIky8N3akpynVM/kGiV7SX8Qbo=;
        b=YgPPb7VsvOsfpBuGM7hip4U239vrBV3dF3O+19sunbKA7SMNf8z25XHgAzuYMsv2Q2
         KMBn3VWvU/XM83EdIebNhAOgTFxtQ+cDDJz5H1kXH+upbGrr3+/b/Ph5d7Tpmz8ihFan
         DFuc3LQdrKJj6F4q0zvblfgvdN44+33X23T+kZGXCAdb+qazx61pQPa3NdcpyJyi3cfq
         ThzcwvPI5xgNP/n+SzTegHRXklCl68kd1Fvl1ynHL9k7j8V/JKhZwMmquPiIs5xUkW2D
         ZrppMoWjMcwfVC6B8bIAbYEdAcP5mflYcDSbUir2KTObVUqDHVHu1rw0UI8LGDSwUnYU
         XOvw==
X-Gm-Message-State: ANoB5pkNrOGjH6q0dHNP1vynkxdRdgULgUUFeWv0U0Yz+zPQWTgA3taz
        gPjWbMezO3vQPaVRVImgUHDqiiil/E6ADDEbSR1r7w==
X-Google-Smtp-Source: AA0mqf7xQ7rLKJrYh5a/tN47/NHtHo8yir8GaUwY1K2ECqfq0uO/K35W6r+Pk4UhT9NWj3cGe/hz1ww294pRASJKUnc=
X-Received: by 2002:a81:4f46:0:b0:36c:aaa6:e571 with SMTP id
 d67-20020a814f46000000b0036caaa6e571mr23216066ywb.467.1670466095559; Wed, 07
 Dec 2022 18:21:35 -0800 (PST)
MIME-Version: 1.0
References: <20221207225435.1273226-1-lixiaoyan@google.com>
In-Reply-To: <20221207225435.1273226-1-lixiaoyan@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 8 Dec 2022 03:21:24 +0100
Message-ID: <CANn89iLCUywiUVASmk0WtishPdURFSsMD4y7e=uuwz8hdQHLJw@mail.gmail.com>
Subject: Re: [PATCH net-next v5 1/2] IPv6/GRO: generic helper to remove
 temporary HBH/jumbo header in driver
To:     Coco Li <lixiaoyan@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 11:54 PM Coco Li <lixiaoyan@google.com> wrote:
>
> IPv6/TCP and GRO stacks can build big TCP packets with an added
> temporary Hop By Hop header.
>
> Is GSO is not involved, then the temporary header needs to be removed in
> the driver. This patch provides a generic helper for drivers that need
> to modify their headers in place.
>
> Tested:
> Compiled and ran with ethtool -K eth1 tso off
> Could send Big TCP packets
>
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> ---
>  include/net/ipv6.h     | 36 ++++++++++++++++++++++++++++++++++++
>  net/ipv6/ip6_offload.c | 27 ++++-----------------------
>  2 files changed, 40 insertions(+), 23 deletions(-)
>
> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> index d383c895592a..6dcf93a1ec14 100644
> --- a/include/net/ipv6.h
> +++ b/include/net/ipv6.h
> @@ -500,6 +500,42 @@ static inline int ipv6_has_hopopt_jumbo(const struct sk_buff *skb)
>         return jhdr->nexthdr;
>  }
>
> +/* Return 0 if HBH header is successfully removed
> + * Or if HBH removal is unnecessary (packet is not big TCP)
> + * Return error to indicate dropping the packet
> + */
> +static inline int ipv6_hopopt_jumbo_remove(struct sk_buff *skb)
> +{
> +       const int hophdr_len = sizeof(struct hop_jumbo_hdr);
> +       int nexthdr = ipv6_has_hopopt_jumbo(skb);
> +       struct ipv6hdr *h6;
> +
> +       if (!nexthdr)
> +               return 0;
> +
> +       if (skb_cow_head(skb, 0))
> +               return -1;
> +
> +       /* Remove the HBH header.
> +        * Layout: [Ethernet header][IPv6 header][HBH][L4 Header]
> +        */
> +       memmove(skb_mac_header(skb) + hophdr_len, skb_mac_header(skb),
> +               skb_network_header(skb) - skb_mac_header(skb) +
> +               sizeof(struct ipv6hdr));
> +
> +       if (unlikely(!pskb_may_pull(skb, hophdr_len)))
> +               return -1;

ipv6_has_hopopt_jumbo() had a stronger condition already.

if (skb_network_offset(skb) +
     sizeof(struct ipv6hdr) +
     sizeof(struct hop_jumbo_hdr) > skb_headlen(skb))
        return 0;

So this !pskb_may_pull(skb, hophdr_len) , especially if done after the
memmove(), is not needed.


> +
> +       __skb_pull(skb, hophdr_len);
> +       skb->network_header += hophdr_len;
> +       skb->mac_header += hophdr_len;
> +
> +       h6 = ipv6_hdr(skb);
> +       h6->nexthdr = nexthdr;
> +
> +       return 0;
> +}
> +
>  static inline bool ipv6_accept_ra(struct inet6_dev *idev)
>  {
>         /* If forwarding is enabled, RA are not accepted unless the special
> diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
> index 3ee345672849..00dc2e3b0184 100644
> --- a/net/ipv6/ip6_offload.c
> +++ b/net/ipv6/ip6_offload.c
> @@ -77,7 +77,7 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
>         struct sk_buff *segs = ERR_PTR(-EINVAL);
>         struct ipv6hdr *ipv6h;
>         const struct net_offload *ops;
> -       int proto, nexthdr;
> +       int proto, err;
>         struct frag_hdr *fptr;
>         unsigned int payload_len;
>         u8 *prevhdr;
> @@ -87,28 +87,9 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
>         bool gso_partial;
>
>         skb_reset_network_header(skb);
> -       nexthdr = ipv6_has_hopopt_jumbo(skb);
> -       if (nexthdr) {
> -               const int hophdr_len = sizeof(struct hop_jumbo_hdr);
> -               int err;
> -
> -               err = skb_cow_head(skb, 0);
> -               if (err < 0)
> -                       return ERR_PTR(err);
> -
> -               /* remove the HBH header.
> -                * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
> -                */
> -               memmove(skb_mac_header(skb) + hophdr_len,
> -                       skb_mac_header(skb),
> -                       ETH_HLEN + sizeof(struct ipv6hdr));
> -               skb->data += hophdr_len;
> -               skb->len -= hophdr_len;
> -               skb->network_header += hophdr_len;
> -               skb->mac_header += hophdr_len;
> -               ipv6h = (struct ipv6hdr *)skb->data;
> -               ipv6h->nexthdr = nexthdr;
> -       }
> +       err = ipv6_hopopt_jumbo_remove(skb);
> +       if (err)
> +               return ERR_PTR(err);
>         nhoff = skb_network_header(skb) - skb_mac_header(skb);
>         if (unlikely(!pskb_may_pull(skb, sizeof(*ipv6h))))
>                 goto out;
> --
> 2.39.0.rc0.267.gcb52ba06e7-goog
>
