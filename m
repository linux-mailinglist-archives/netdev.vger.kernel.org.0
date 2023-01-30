Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEC46817DD
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236382AbjA3RkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238133AbjA3RkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:40:14 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FCC93CC
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:40:10 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-506609635cbso170000997b3.4
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tGuWP1c2Ds5NPIh/zwQX0rRX7oWK3Tt/K+KKpRm9lFs=;
        b=bLNT/QTPehDZagVeImbJEqio8o2eeJIP0vl9E6HRjB40ND02/SFe+2ayMIhIURrphe
         QEv7jfwYXe5owTN1bNfrb4qNdUuDeBcdqEfb/X3nYnNANtXFUCurlzgirDuC5dGnGJBr
         GNEm5HP6nQZu7Q57xQq4t44uNsGLjqTdxsrov8uYbzDPwt94Wwahqb3pNgYvWiztFxgv
         8l+9aB81wdR+tsdOJu9MqDNK4B/yvtD+11HAwqZ4faDqsmUokWsSOoo2pOXfSkUwVIJY
         cqbL5eYb6CxrO33aLdxxF1sU+c2HFREWtcj2PMD+oRVSTDFE2zZivhH8NC6Ubh5V3nl2
         TKcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tGuWP1c2Ds5NPIh/zwQX0rRX7oWK3Tt/K+KKpRm9lFs=;
        b=UeLn3TS68LFUk7xm/gdEfP50YjjGhYN6TcJJ0gasW0XxKhwbsmlO0wGBFgHdhlTt1w
         Q2geWzttZ4lO7VxztAE4xnswzybzwWIKB46ZoX7uU//MluRngUGMBo/Rf1PGJNhCpnfJ
         mwlwmnVCy69YR9TMI+FkGSWKFaL09pHys7D8oRilgadcOUu5pNFTytA59UgDMLbu27Kg
         M25rfTLCs4dVeQVf4FWop0ms3O3R9O8jfVA+lNvAt0toTOj4Lviz+6DnJgM8/BqrCECc
         GrPMkXI63iRY2Ki1GXosAImoV5i3Kh1WpmZY45eHWwbzQxaTcJ+GV3dWGMtHAf4mhKxh
         MRQQ==
X-Gm-Message-State: AFqh2kqaEmBED8TBcopCYhirsEoLpyVpZTzF9dDZAL/96f0N17rCcq5D
        mck+xlDZUnxxyugowkfBRjg5q+xCgePBmEaWZTEKhQ==
X-Google-Smtp-Source: AMrXdXspBnsvzUzzNRw7jPzFVqOiBRvIo9GZnPT8fQQktrocWK7H07IDSmTXyEGOcGtzaA/lMosiSf4CdAWiekzdLQs=
X-Received: by 2002:a81:98c7:0:b0:501:2069:ffb2 with SMTP id
 p190-20020a8198c7000000b005012069ffb2mr4845466ywg.124.1675100409856; Mon, 30
 Jan 2023 09:40:09 -0800 (PST)
MIME-Version: 1.0
References: <20230130130047.GA7913@debian> <20230130130752.GA8015@debian>
In-Reply-To: <20230130130752.GA8015@debian>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 30 Jan 2023 18:39:58 +0100
Message-ID: <CANn89i+Hs8837KvTrHE37NYrk=5vCYhDGYFu3MBm1dvXmS=KnQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] gro: optimise redundant parsing of packets
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        steffen.klassert@secunet.com, lixiaoyan@google.com,
        alexanderduyck@fb.com, leon@kernel.org, ye.xingchen@zte.com.cn,
        iwienand@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Mon, Jan 30, 2023 at 2:08 PM Richard Gobert <richardbgobert@gmail.com> wrote:
>
> Currently, the IPv6 extension headers are parsed twice: first in
> ipv6_gro_receive, and then again in ipv6_gro_complete.
>
> The field NAPI_GRO_CB(skb)->proto is used by GRO to hold the layer 4
> protocol type that comes after the IPv6 layer. I noticed that it is set
> in ipv6_gro_receive, but isn't used anywhere. By using this field, and
> also storing the size of the network header, we can avoid parsing
> extension headers a second time in ipv6_gro_complete.
>
> The implementation had to handle both inner and outer layers in case of
> encapsulation (as they can't use the same field).
>
> I've applied this optimisation to all base protocols (IPv6, IPv4,
> Ethernet). Then, I benchmarked this patch on my machine, using ftrace to
> measure ipv6_gro_complete's performance, and there was an improvement.

It seems your patch adds a lot of conditional checks, which will
alternate true/false
for encapsulated protocols.

So please give us raw numbers, ftrace is too heavy weight for such claims.



>
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> ---
>  include/net/gro.h      |  8 ++++++--
>  net/ethernet/eth.c     | 11 +++++++++--
>  net/ipv4/af_inet.c     |  8 +++++++-
>  net/ipv6/ip6_offload.c | 15 ++++++++++++---
>  4 files changed, 34 insertions(+), 8 deletions(-)
>
> diff --git a/include/net/gro.h b/include/net/gro.h
> index 7b47dd6ce94f..d364616cb930 100644
> --- a/include/net/gro.h
> +++ b/include/net/gro.h
> @@ -41,8 +41,8 @@ struct napi_gro_cb {
>         /* Number of segments aggregated. */
>         u16     count;
>
> -       /* Used in ipv6_gro_receive() and foo-over-udp */
> -       u16     proto;
> +       /* Used in eth_gro_receive() */
> +       __be16  network_proto;
>
>  /* Used in napi_gro_cb::free */
>  #define NAPI_GRO_FREE             1
> @@ -86,6 +86,10 @@ struct napi_gro_cb {
>
>         /* used to support CHECKSUM_COMPLETE for tunneling protocols */
>         __wsum  csum;
> +
> +       /* Used in inet and ipv6 _gro_receive() */
> +       u16     network_len;
> +       u8      transport_proto;
>  };
>
>  #define NAPI_GRO_CB(skb) ((struct napi_gro_cb *)(skb)->cb)
> diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
> index 2edc8b796a4e..d68ad90f0a9e 100644
> --- a/net/ethernet/eth.c
> +++ b/net/ethernet/eth.c
> @@ -439,6 +439,9 @@ struct sk_buff *eth_gro_receive(struct list_head *head, struct sk_buff *skb)
>                 goto out;
>         }
>
> +       if (!NAPI_GRO_CB(skb)->encap_mark)
> +               NAPI_GRO_CB(skb)->network_proto = type;
> +
>         skb_gro_pull(skb, sizeof(*eh));
>         skb_gro_postpull_rcsum(skb, eh, sizeof(*eh));
>
> @@ -456,12 +459,16 @@ EXPORT_SYMBOL(eth_gro_receive);
>  int eth_gro_complete(struct sk_buff *skb, int nhoff)
>  {
>         struct ethhdr *eh = (struct ethhdr *)(skb->data + nhoff);

Why initializing @eh here is needed ?
Presumably, for !skb->encapsulation, @eh would not be used.

> -       __be16 type = eh->h_proto;
> +       __be16 type;
>         struct packet_offload *ptype;
>         int err = -ENOSYS;
>
> -       if (skb->encapsulation)
> +       if (skb->encapsulation) {
>                 skb_set_inner_mac_header(skb, nhoff);
> +               type = eh->h_proto;
> +       } else {
> +               type = NAPI_GRO_CB(skb)->network_proto;
> +       }
>
>         ptype = gro_find_complete_by_type(type);
>         if (ptype != NULL)
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 6c0ec2789943..4401af7b3a15 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1551,6 +1551,9 @@ struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
>          * immediately following this IP hdr.
>          */
>
> +       if (!NAPI_GRO_CB(skb)->encap_mark)
> +               NAPI_GRO_CB(skb)->transport_proto = proto;
> +
>         /* Note : No need to call skb_gro_postpull_rcsum() here,
>          * as we already checked checksum over ipv4 header was 0
>          */
> @@ -1621,12 +1624,15 @@ int inet_gro_complete(struct sk_buff *skb, int nhoff)
>         __be16 newlen = htons(skb->len - nhoff);
>         struct iphdr *iph = (struct iphdr *)(skb->data + nhoff);
>         const struct net_offload *ops;
> -       int proto = iph->protocol;
> +       int proto;
>         int err = -ENOSYS;
>
>         if (skb->encapsulation) {
>                 skb_set_inner_protocol(skb, cpu_to_be16(ETH_P_IP));
>                 skb_set_inner_network_header(skb, nhoff);
> +               proto = iph->protocol;
> +       } else {
> +               proto = NAPI_GRO_CB(skb)->transport_proto;

I really doubt this change is needed.
We need to access iph->fields in the following lines.
Adding an else {} branch is adding extra code, and makes your patch
longer to review.

>         }
>
>         csum_replace2(&iph->check, iph->tot_len, newlen);
> diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
> index 00dc2e3b0184..79ba5882f576 100644
> --- a/net/ipv6/ip6_offload.c
> +++ b/net/ipv6/ip6_offload.c
> @@ -227,11 +227,14 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
>                 iph = ipv6_hdr(skb);
>         }
>
> -       NAPI_GRO_CB(skb)->proto = proto;

I guess you missed BIG  TCP ipv4 changes under review... ->proto is now used.

> -
>         flush--;
>         nlen = skb_network_header_len(skb);
>
> +       if (!NAPI_GRO_CB(skb)->encap_mark) {
> +               NAPI_GRO_CB(skb)->transport_proto = proto;
> +               NAPI_GRO_CB(skb)->network_len = nlen;
> +       }
> +
>         list_for_each_entry(p, head, list) {
>                 const struct ipv6hdr *iph2;
>                 __be32 first_word; /* <Version:4><Traffic_Class:8><Flow_Label:20> */
> @@ -358,7 +361,13 @@ INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
>                 iph->payload_len = htons(payload_len);
>         }
>
> -       nhoff += sizeof(*iph) + ipv6_exthdrs_len(iph, &ops);
> +       if (!skb->encapsulation) {
> +               ops = rcu_dereference(inet6_offloads[NAPI_GRO_CB(skb)->transport_proto]);
> +               nhoff += NAPI_GRO_CB(skb)->network_len;
> +       } else {
> +               nhoff += sizeof(*iph) + ipv6_exthdrs_len(iph, &ops);

IMO ipv6_exthdrs_len() is quite fast for the typical case where we
have no extension headers.

This new conditional check seems expensive to me.



> +       }
> +
>         if (WARN_ON(!ops || !ops->callbacks.gro_complete))
>                 goto out;
>
> --
> 2.36.1
>
