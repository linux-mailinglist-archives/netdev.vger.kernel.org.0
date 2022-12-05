Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA550642282
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 06:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbiLEFMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 00:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbiLEFL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 00:11:56 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50F413F01
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 21:11:54 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-3bf4ade3364so106814287b3.3
        for <netdev@vger.kernel.org>; Sun, 04 Dec 2022 21:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iBs2VHhUeXEwMaevAFFmuS310G7Iih4G+NBUptymOgA=;
        b=acAD9UjEMkRSWJ0wgwq+gnwODyuslo1SNtsUrrFWIXpVhAuagK67JSzW7uwYFt8R3E
         y907BqqoP3m6fMyWJGoTMjD3dn6WA1O48971fam6grCVu+0gTd1R0f1R1MAmSn4PHTu8
         POtmp85koYWlMRPuvechBOjzXOPVOj1dwxUjZb6y4oDylnYr/i2olX5U7USqHAoXvu0l
         FXYtqmCh5wFntK1vBk4TAcZAKrAs4tCkG8+v9qxNJ2PJ0+6EnXYXdjV9nyuIWBlaEGMd
         53Wgg5eWdYGCurqFFGNLFlFkcNFH8v7YobSMnoco4LDDfg0oPCiknpBPN4s/X2/5IzyI
         HDDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iBs2VHhUeXEwMaevAFFmuS310G7Iih4G+NBUptymOgA=;
        b=E/4nU2UnAXgD+XH7/95ca+/P+q0w9hJrm3g40HY0ETl9cly5RDVFrXzWnI2Szh7HVe
         +3vxEgHiKgcXrFWYvagb+IDcZhRVNrckC3G/+ff75QLE8QFNsw+sX/kQwjS30mzolTme
         aBvcYSVP7Ar8PetsvAcLB0B138dxXiWlr1ShMaNm6ErbSNaZKt1xiFjSfOHg0ZfSpWDc
         8txdvrCTcJebeo9t8B21ZYpKgZteGg8Jm/+ropG6EI+e3K+cRQXS08ybenNan6D50oKB
         BP8Inuy4Ow6Hdy4SJ6Lw0hIzkc9iENEAaVs1mi6cxMZRiY9CEXEGPVO9ARS3VvGPg6NT
         1bOA==
X-Gm-Message-State: ANoB5plpOotIXxpDCVs1ELR3Kpx+espaAnO1L20piDxcsv1Kilnu0yUV
        5RDXVWEdNrdpOQJ6nlwIySVrcblLWA7u64FW9W2F6g==
X-Google-Smtp-Source: AA0mqf5Kb3DRzriHUijzw3B9gcKdGBuyVT/U12RuzBOWp41hsaI4bBA2FN0yzZaVJL7svErs1xrTsrXV5CNYTW9Ap5s=
X-Received: by 2002:a81:4f46:0:b0:36c:aaa6:e571 with SMTP id
 d67-20020a814f46000000b0036caaa6e571mr10889133ywb.467.1670217113689; Sun, 04
 Dec 2022 21:11:53 -0800 (PST)
MIME-Version: 1.0
References: <20221202221213.236564-1-lixiaoyan@google.com>
In-Reply-To: <20221202221213.236564-1-lixiaoyan@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 5 Dec 2022 06:11:42 +0100
Message-ID: <CANn89iKg4MH9qbG6KdfN4-OXNKTd2bDoBSdoHGy==Ocg=HVzcg@mail.gmail.com>
Subject: Re: [RFC net-next v4 1/2] IPv6/GRO: generic helper to remove
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 2, 2022 at 11:12 PM Coco Li <lixiaoyan@google.com> wrote:
>
> IPv6/TCP and GRO stacks can build big TCP packets with an added
> temporary Hop By Hop header.
>
> Is GSO is not involved, then the temporary header needs to be removed in
> the driver. This patch provides a generic helper for drivers that need
> to modify their headers in place.
>
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> ---
>  include/net/ipv6.h     | 35 +++++++++++++++++++++++++++++++++++
>  net/ipv6/ip6_offload.c | 27 ++++-----------------------
>  2 files changed, 39 insertions(+), 23 deletions(-)
>
> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> index d383c895592a..08adec74f067 100644
> --- a/include/net/ipv6.h
> +++ b/include/net/ipv6.h
> @@ -500,6 +500,41 @@ static inline int ipv6_has_hopopt_jumbo(const struct sk_buff *skb)
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
> +
> +       skb->network_header += hophdr_len;
> +       skb->mac_header += hophdr_len;
> +
> +       h6 = ipv6_hdr(skb);
> +       h6->nexthdr = nexthdr;

Coco, I think you should test this patch on one of your host (no need
for bnxt NIC) and

ethtool -K eth1 tso off

Thanks.

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
