Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6494A54680E
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 16:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244177AbiFJOIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 10:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239938AbiFJOIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 10:08:44 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7844D11A1E
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 07:08:41 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id e184so47193154ybf.8
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 07:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PyDV1j65Lx1TNpp+HfLz4mmPCTfG4DwRYS5sO/K+ka8=;
        b=Sdeh8Fo6066+bfOd2m5fJVKaFZzEJ7erlT2qu9MZfJRo/zyyp2dIeM0aBETQyXe1/s
         lJBndoNzAmI4C/EVWjalMxJ/QHsjyg6vZs+MkIxTG+htjfdgvXLvrUMxw9Sr2onWYxqB
         7WEG+czk++2nwPWU3DscC7pbaO5F650hxELX7M/WZHwZxlPa4FZYiNEbn9d4UY9fdFuD
         VJRyXq1wBbArx+Lev+T5fv1vBnwjTiLaFQ8MAYdZQazR0uonpnn1qWyloxZ7unMIE108
         ihpKkBbuJNB+Qs45XTDAef54IuzKgqopy6AgN2iqCl7g+7C73+0MFRA57QPiKBHZqUbX
         pD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PyDV1j65Lx1TNpp+HfLz4mmPCTfG4DwRYS5sO/K+ka8=;
        b=A//4hJXuLoGEC9USXA5+GKcRm1oSfuvyz1P0li/V3Qab4vnKXTt4kcIEGFVV3vsCoO
         TeqyJDrQW7WgpXeu5ITKwRWY4zhzmpA6lY24VjzeKV5O96/L0urj91gPLc+m8kedTQlc
         Xr6lxR45ZiqGWXIJHzK3fsMS+UO0t68L7Vg0vh5V2wyUgEZeM2hpL88KC6Xy6gkMprvI
         1cz8UyYcqXep3c90+kDQzQq6elUWIhEilUA1272gzlnroD1U4jGCjR60LWhoWO6ojJ6x
         fmFbCACu0n+MPznfujL9yINnqxezS1k0HOQ+5gCq9Z/X1hyid2lnvbg2Wcl2v/WFg+Xc
         zltw==
X-Gm-Message-State: AOAM531SmLDOJLJm24d9s4GOnsUt9yShbJDv9JwoIIp8IXVloc3MEB9I
        WZm42mYPEudhq9xYI68wvLei0gpOOrSQKucDY5M+8g==
X-Google-Smtp-Source: ABdhPJygPVRT7z0US6HV++lxmvLlfxhcHVO3Vgdal0mZt/+tPtS7Xx+Lc3STO5t1a7w3CvHR0oCFLEgO9ilfgHl16/Y=
X-Received: by 2002:a05:6902:c9:b0:641:1998:9764 with SMTP id
 i9-20020a05690200c900b0064119989764mr44237460ybs.427.1654870120190; Fri, 10
 Jun 2022 07:08:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220610103653.15261-1-zajec5@gmail.com>
In-Reply-To: <20220610103653.15261-1-zajec5@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 10 Jun 2022 07:08:28 -0700
Message-ID: <CANn89iLJwdKXcfCHuEkRT7tknsXpD=UgFh-f61M1UAL9b8JMJw@mail.gmail.com>
Subject: Re: [PATCH] net: gro: respect nf_conntrack_checksum for skipping csum verification
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     openwrt-devel@lists.openwrt.org,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Fri, Jun 10, 2022 at 3:37 AM Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> =
wrote:
>
> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> Netfilter allows disabling checksum verification of incoming packets by
> setting nf_conntrack_checksum variable. That feature is very useful for
> home routers which:
> 1. Most of the time just /forward/ network traffic
> 2. Have slow CPU(s) and csum calculation is a challenge
>
> Some projects like OpenWrt set nf_conntrack_checksum to 0 by default.
>
> It would be nice to allow similar optimization in the GRO code paths.
> This patch simply reuses nf_conntrack_checksum variable to skip
> skb_gro_checksum_validate() calls if applicable.
>

Problem is that GRO will be followed by TSO on the egress side.

TSO will generate segments with recomputed checksums for each one of them.

GRO only keeps one copy of the headers, so does not track original
checksums for all
segments at ingress side.

So if you want to use TSO, GRO has to validate checksums.

I am afraid this nf_conntrack_checksum idea can not be transposed to GRO.

> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> ---
> Hi guys,
>
> I'm not very familiar with net subsystem, please let me know if there is
> a better way of implementing such a feature.
> ---
>  net/ipv4/tcp_offload.c   | 3 +++
>  net/ipv6/tcpv6_offload.c | 3 +++
>  2 files changed, 6 insertions(+)
>
> diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
> index 30abde86db45..734a3c0f3d4a 100644
> --- a/net/ipv4/tcp_offload.c
> +++ b/net/ipv4/tcp_offload.c
> @@ -311,6 +311,9 @@ struct sk_buff *tcp4_gro_receive(struct list_head *he=
ad, struct sk_buff *skb)
>  {
>         /* Don't bother verifying checksum if we're going to flush anyway=
. */
>         if (!NAPI_GRO_CB(skb)->flush &&
> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)
> +           dev_net(skb->dev)->ct.sysctl_checksum &&
> +#endif
>             skb_gro_checksum_validate(skb, IPPROTO_TCP,
>                                       inet_gro_compute_pseudo)) {
>                 NAPI_GRO_CB(skb)->flush =3D 1;
> diff --git a/net/ipv6/tcpv6_offload.c b/net/ipv6/tcpv6_offload.c
> index 39db5a226855..2144afa56fa3 100644
> --- a/net/ipv6/tcpv6_offload.c
> +++ b/net/ipv6/tcpv6_offload.c
> @@ -18,6 +18,9 @@ struct sk_buff *tcp6_gro_receive(struct list_head *head=
, struct sk_buff *skb)
>  {
>         /* Don't bother verifying checksum if we're going to flush anyway=
. */
>         if (!NAPI_GRO_CB(skb)->flush &&
> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)
> +           dev_net(skb->dev)->ct.sysctl_checksum &&
> +#endif
>             skb_gro_checksum_validate(skb, IPPROTO_TCP,
>                                       ip6_gro_compute_pseudo)) {
>                 NAPI_GRO_CB(skb)->flush =3D 1;
> --
> 2.34.1
>
