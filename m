Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE9759EAD6
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 20:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbiHWSUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 14:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbiHWSTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 14:19:45 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9524697B22
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 09:36:28 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id n202so5824583iod.6
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 09:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=QKxgcx8I6GtA9HqQXaO4Kj4OiEIdCp0BQLrnhr/vdUw=;
        b=ge78yPRloQJ8Fa+fjDQ2D4fdZ2FwSZKmqCseVTXxQ6DypW+Ece51TleRi9hGn7/bDW
         eF3kvAvX2zMsg6NjNrdRDRSKS1o1ha5FHCk+ceBammzQ5nwXbigB7WT43Hu+tTRvjqbm
         ud+hMQfrTV2OiCbrTtwLcgw42DgPaBzb2V5UBaPOi2MEa8GrfmCOWoRZuxf6ehw02MQ4
         hOFyR4VVKWzmYUB84HGk6gINUbTtddRo1es/a5B9vnxFqVq+m1pxtOagdYik+7t4/eNG
         S1AdaWZrDmft3hV3hoerM6+bCcGDfpEQLb/bX9Id3rH1aweWTS8DP1F2SXzyhm3Uhhnu
         Mrfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=QKxgcx8I6GtA9HqQXaO4Kj4OiEIdCp0BQLrnhr/vdUw=;
        b=z7AmJiK3l6zVq8//qC4BF6x/wJvwc6gzFWf6nyzCGGJndMo+CiJ2J03RBbPe/D5SZM
         n7S2YVaGDixpI8A0s0bcyTUNiB4JKCMfFQg4+hWJW1cNMj6JFLxdcmqVUxX7ywxiYbte
         MAw+YH+do3nN6kKMNbifMMl//LDxj/lIIpA32tBKQRIquuUbhEjs7bIeeHs+/67yd9Dd
         Tnk2bju9WGk9X3uAh7M34ksprtDMcRiEwzv9OGzKSKy0YTV15vDxq4tm6Yb4sAQsVpm6
         nI/n64iwIZ+CWMnGIvFACXO4SBodmwVsDBdBWJnjweQWsw+A7S5l6hwHRAA1TrKhQQ1c
         KFHg==
X-Gm-Message-State: ACgBeo0kFj6lbl4rf0m/aNoZlteN8d3CuiU6Zoj+Bdx8GgCx1O9J/P1g
        NC9E24b5fTs6xrHHEF/6cuDNY3t9qQFMm3tu02d1kg==
X-Google-Smtp-Source: AA6agR7O/4HhExYj0bNfk3mm16AsYz+wpDjpMQNSOmVC0z5GtV0E3UeMv7JiBa6maYccegjBRCpQs0Hk8ebb2rMpPHE=
X-Received: by 2002:a05:6602:2e05:b0:689:4f74:9264 with SMTP id
 o5-20020a0566022e0500b006894f749264mr9694506iow.2.1661272587678; Tue, 23 Aug
 2022 09:36:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220823071034.GA56142@debian>
In-Reply-To: <20220823071034.GA56142@debian>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 23 Aug 2022 09:36:16 -0700
Message-ID: <CANn89iK2nSSVLkTq=d9-ZePVOr0KGy0Hm53u+iv7sutJXkNSrg@mail.gmail.com>
Subject: Re: [PATCH V2] net: gro: skb_gro_header helper function
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Dmitry Kozlov <xeb@mail.ru>,
        Roopa Prabhu <roopa@nvidia.com>,
        eng.alaamohamedsoliman.am@gmail.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        heikki.krogerus@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        iwienand@redhat.com, netdev <netdev@vger.kernel.org>
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

On Tue, Aug 23, 2022 at 12:11 AM Richard Gobert
<richardbgobert@gmail.com> wrote:
>
> Introduce a simple helper function to replace a common pattern.
> When accessing the GRO header, we fetch the pointer from frag0,
> then test its validity and fetch it from the skb when necessary.
>
> This leads to the pattern
> skb_gro_header_fast -> skb_gro_header_hard -> skb_gro_header_slow
> recurring many times throughout GRO code.
>
> This patch replaces these patterns with a single inlined function
> call, improving code readability.
>
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Please next time, add what has changed between V1 and V2, after the --- marker.

Thanks.


> ---
>  drivers/net/geneve.c           |  9 +++------
>  drivers/net/vxlan/vxlan_core.c |  9 +++------
>  include/net/gro.h              | 33 ++++++++++++++++++---------------
>  net/8021q/vlan_core.c          |  9 +++------
>  net/ethernet/eth.c             |  9 +++------
>  net/ipv4/af_inet.c             |  9 +++------
>  net/ipv4/fou.c                 |  9 +++------
>  net/ipv4/gre_offload.c         |  9 +++------
>  net/ipv4/tcp_offload.c         |  9 +++------
>  net/ipv6/ip6_offload.c         |  9 +++------
>  10 files changed, 45 insertions(+), 69 deletions(-)
>
> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> index 7962c37b3f14..01aa94776ce3 100644
> --- a/drivers/net/geneve.c
> +++ b/drivers/net/geneve.c
> @@ -503,12 +503,9 @@ static struct sk_buff *geneve_gro_receive(struct sock *sk,
>
>         off_gnv = skb_gro_offset(skb);
>         hlen = off_gnv + sizeof(*gh);
> -       gh = skb_gro_header_fast(skb, off_gnv);
> -       if (skb_gro_header_hard(skb, hlen)) {
> -               gh = skb_gro_header_slow(skb, hlen, off_gnv);
> -               if (unlikely(!gh))
> -                       goto out;
> -       }
> +       gh = skb_gro_header(skb, hlen, off_gnv);
> +       if (unlikely(!gh))
> +               goto out;
>
>         if (gh->ver != GENEVE_VER || gh->oam)
>                 goto out;
> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
> index c3285242f74f..1a47d04f5d1a 100644
> --- a/drivers/net/vxlan/vxlan_core.c
> +++ b/drivers/net/vxlan/vxlan_core.c
> @@ -713,12 +713,9 @@ static struct sk_buff *vxlan_gro_receive(struct sock *sk,
>
>         off_vx = skb_gro_offset(skb);
>         hlen = off_vx + sizeof(*vh);
> -       vh   = skb_gro_header_fast(skb, off_vx);
> -       if (skb_gro_header_hard(skb, hlen)) {
> -               vh = skb_gro_header_slow(skb, hlen, off_vx);
> -               if (unlikely(!vh))
> -                       goto out;
> -       }
> +       vh = skb_gro_header(skb, hlen, off_vx);
> +       if (unlikely(!vh))
> +               goto out;
>
>         skb_gro_postpull_rcsum(skb, vh, sizeof(struct vxlanhdr));
>
> diff --git a/include/net/gro.h b/include/net/gro.h
> index 867656b0739c..5bf15c212434 100644
> --- a/include/net/gro.h
> +++ b/include/net/gro.h
> @@ -160,6 +160,17 @@ static inline void *skb_gro_header_slow(struct sk_buff *skb, unsigned int hlen,
>         return skb->data + offset;
>  }
>
> +static inline void *skb_gro_header(struct sk_buff *skb,
> +                                       unsigned int hlen, unsigned int offset)
> +{
> +       void *ptr;
> +
> +       ptr = skb_gro_header_fast(skb, offset);
> +       if (skb_gro_header_hard(skb, hlen))
> +               ptr = skb_gro_header_slow(skb, hlen, offset);
> +       return ptr;
> +}
> +
>  static inline void *skb_gro_network_header(struct sk_buff *skb)
>  {
>         return (NAPI_GRO_CB(skb)->frag0 ?: skb->data) +
> @@ -301,12 +312,9 @@ static inline void *skb_gro_remcsum_process(struct sk_buff *skb, void *ptr,
>                 return ptr;
>         }
>
> -       ptr = skb_gro_header_fast(skb, off);
> -       if (skb_gro_header_hard(skb, off + plen)) {
> -               ptr = skb_gro_header_slow(skb, off + plen, off);
> -               if (!ptr)
> -                       return NULL;
> -       }
> +       ptr = skb_gro_header(skb, off + plen, off);
> +       if (!ptr)
> +               return NULL;
>
>         delta = remcsum_adjust(ptr + hdrlen, NAPI_GRO_CB(skb)->csum,
>                                start, offset);
> @@ -329,12 +337,9 @@ static inline void skb_gro_remcsum_cleanup(struct sk_buff *skb,
>         if (!grc->delta)
>                 return;
>
> -       ptr = skb_gro_header_fast(skb, grc->offset);
> -       if (skb_gro_header_hard(skb, grc->offset + sizeof(u16))) {
> -               ptr = skb_gro_header_slow(skb, plen, grc->offset);
> -               if (!ptr)
> -                       return;
> -       }
> +       ptr = skb_gro_header(skb, plen, grc->offset);
> +       if (!ptr)
> +               return;
>
>         remcsum_unadjust((__sum16 *)ptr, grc->delta);
>  }
> @@ -405,9 +410,7 @@ static inline struct udphdr *udp_gro_udphdr(struct sk_buff *skb)
>
>         off  = skb_gro_offset(skb);
>         hlen = off + sizeof(*uh);
> -       uh   = skb_gro_header_fast(skb, off);
> -       if (skb_gro_header_hard(skb, hlen))
> -               uh = skb_gro_header_slow(skb, hlen, off);
> +       uh   = skb_gro_header(skb, hlen, off);
>
>         return uh;
>  }
> diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
> index 5aa8144101dc..0beb44f2fe1f 100644
> --- a/net/8021q/vlan_core.c
> +++ b/net/8021q/vlan_core.c
> @@ -467,12 +467,9 @@ static struct sk_buff *vlan_gro_receive(struct list_head *head,
>
>         off_vlan = skb_gro_offset(skb);
>         hlen = off_vlan + sizeof(*vhdr);
> -       vhdr = skb_gro_header_fast(skb, off_vlan);
> -       if (skb_gro_header_hard(skb, hlen)) {
> -               vhdr = skb_gro_header_slow(skb, hlen, off_vlan);
> -               if (unlikely(!vhdr))
> -                       goto out;
> -       }
> +       vhdr = skb_gro_header(skb, hlen, off_vlan);
> +       if (unlikely(!vhdr))
> +               goto out;
>
>         type = vhdr->h_vlan_encapsulated_proto;
>
> diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
> index 62b89d6f54fd..e02daa74e833 100644
> --- a/net/ethernet/eth.c
> +++ b/net/ethernet/eth.c
> @@ -414,12 +414,9 @@ struct sk_buff *eth_gro_receive(struct list_head *head, struct sk_buff *skb)
>
>         off_eth = skb_gro_offset(skb);
>         hlen = off_eth + sizeof(*eh);
> -       eh = skb_gro_header_fast(skb, off_eth);
> -       if (skb_gro_header_hard(skb, hlen)) {
> -               eh = skb_gro_header_slow(skb, hlen, off_eth);
> -               if (unlikely(!eh))
> -                       goto out;
> -       }
> +       eh = skb_gro_header(skb, hlen, off_eth);
> +       if (unlikely(!eh))
> +               goto out;
>
>         flush = 0;
>
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 3ca0cc467886..1676e5b9e000 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1448,12 +1448,9 @@ struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
>
>         off = skb_gro_offset(skb);
>         hlen = off + sizeof(*iph);
> -       iph = skb_gro_header_fast(skb, off);
> -       if (skb_gro_header_hard(skb, hlen)) {
> -               iph = skb_gro_header_slow(skb, hlen, off);
> -               if (unlikely(!iph))
> -                       goto out;
> -       }
> +       iph = skb_gro_header(skb, hlen, off);
> +       if (unlikely(!iph))
> +               goto out;
>
>         proto = iph->protocol;
>
> diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
> index 025a33c1b04d..cb5bfb77944c 100644
> --- a/net/ipv4/fou.c
> +++ b/net/ipv4/fou.c
> @@ -323,12 +323,9 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
>         off = skb_gro_offset(skb);
>         len = off + sizeof(*guehdr);
>
> -       guehdr = skb_gro_header_fast(skb, off);
> -       if (skb_gro_header_hard(skb, len)) {
> -               guehdr = skb_gro_header_slow(skb, len, off);
> -               if (unlikely(!guehdr))
> -                       goto out;
> -       }
> +       guehdr = skb_gro_header(skb, len, off);
> +       if (unlikely(!guehdr))
> +               goto out;
>
>         switch (guehdr->version) {
>         case 0:
> diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
> index 07073fa35205..2b9cb5398335 100644
> --- a/net/ipv4/gre_offload.c
> +++ b/net/ipv4/gre_offload.c
> @@ -137,12 +137,9 @@ static struct sk_buff *gre_gro_receive(struct list_head *head,
>
>         off = skb_gro_offset(skb);
>         hlen = off + sizeof(*greh);
> -       greh = skb_gro_header_fast(skb, off);
> -       if (skb_gro_header_hard(skb, hlen)) {
> -               greh = skb_gro_header_slow(skb, hlen, off);
> -               if (unlikely(!greh))
> -                       goto out;
> -       }
> +       greh = skb_gro_header(skb, hlen, off);
> +       if (unlikely(!greh))
> +               goto out;
>
>         /* Only support version 0 and K (key), C (csum) flags. Note that
>          * although the support for the S (seq#) flag can be added easily
> diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
> index 30abde86db45..a844a0d38482 100644
> --- a/net/ipv4/tcp_offload.c
> +++ b/net/ipv4/tcp_offload.c
> @@ -195,12 +195,9 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
>
>         off = skb_gro_offset(skb);
>         hlen = off + sizeof(*th);
> -       th = skb_gro_header_fast(skb, off);
> -       if (skb_gro_header_hard(skb, hlen)) {
> -               th = skb_gro_header_slow(skb, hlen, off);
> -               if (unlikely(!th))
> -                       goto out;
> -       }
> +       th = skb_gro_header(skb, hlen, off);
> +       if (unlikely(!th))
> +               goto out;
>
>         thlen = th->doff * 4;
>         if (thlen < sizeof(*th))
> diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
> index d12dba2dd535..d37a8c97e6de 100644
> --- a/net/ipv6/ip6_offload.c
> +++ b/net/ipv6/ip6_offload.c
> @@ -219,12 +219,9 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
>
>         off = skb_gro_offset(skb);
>         hlen = off + sizeof(*iph);
> -       iph = skb_gro_header_fast(skb, off);
> -       if (skb_gro_header_hard(skb, hlen)) {
> -               iph = skb_gro_header_slow(skb, hlen, off);
> -               if (unlikely(!iph))
> -                       goto out;
> -       }
> +       iph = skb_gro_header_slow(skb, hlen, off);
> +       if (unlikely(!iph))
> +               goto out;
>
>         skb_set_network_header(skb, off);
>         skb_gro_pull(skb, sizeof(*iph));
> --
> 2.36.1
>
