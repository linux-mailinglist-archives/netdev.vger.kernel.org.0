Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284646234D2
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 21:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiKIUpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 15:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiKIUp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 15:45:28 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF6F14D14
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 12:45:27 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-3704852322fso173347407b3.8
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 12:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1WoLfUvABMA5gQmhvjTHVmxZYF7fwxBFUqJdE3n/PyI=;
        b=AOa2y5YfD4bm6+3azyeWOsxVP1M3UNk20oh029yoOZanCarxK/3gs8ZcnmtH2J6MXo
         fAzX9ixXn6oh70BLctM/+DZIv4c4Yi1kPXrxevYRPGXjoKAEm8FUqq/kuJWfV94XpnRg
         E3+Cme0ZX2a4C1IJWlNr8bbqXfta/+l7w3vn2uI7DWQxCSFWPql6gYuSmUyjNY7txYt/
         Mb4PDPqZ+kSJyR7PlaRwCrwSmOFAMt64ehKc3XTNOnCLnjbaT9O0eBfMmi2mwLDHLLqg
         Y1B/Jqeq7p5XCUI9qHhus9P1rY196EObDRK4cd2EDftjy663mTMJ1EsO1+2qAYOxc9zK
         UsuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1WoLfUvABMA5gQmhvjTHVmxZYF7fwxBFUqJdE3n/PyI=;
        b=ioeRQbwkKlZ4IMJxuwqykeS/TAUNdW5xRbsvLI0MTF/XZgqX6ruexpgUpBncbnVFDK
         ejKcBZfllzZUJxxwaH8wK03w6+iYNxxaOybWTdwPVZu1ZObf3Nu+evAkTAlVbTzsYGjw
         muj55JR9hixClcSw7PimSt3TgiBkL9G9NtVvRTc8CWodGyMPKg2xud4n0ccZzOX2HWNo
         /WHhdNacBuFbl5jg5xv483sNQK13sjs1UGYKULTxNQgPdWfbXiBkxyKiNKVtmfGZ2fgx
         pc8VYpgBVGyEAtiSVGpICvODMUhBwcfOjfc8s4umJoGxDV10LyxsSPHZRweHC41CxEbr
         UpaA==
X-Gm-Message-State: ACrzQf0U8TvvSbx73PHdSQIGBqbmn4QP5v97nGHQk7cG2zUT3X/0thXL
        n89ryqzOReY6LqTMZ5iiKUtg2dMJsn0zVnYNnxeJzQ==
X-Google-Smtp-Source: AMsMyM7NqVIZdvtDphFAgi3+HFVWcZjrb+V1Sc7ieOtnPChV7+X1diQjm9188Qde+bOzknT7UmypEZBPHApY2GdydeI=
X-Received: by 2002:a81:5a86:0:b0:36f:cece:6efd with SMTP id
 o128-20020a815a86000000b0036fcece6efdmr57220635ywb.489.1668026726738; Wed, 09
 Nov 2022 12:45:26 -0800 (PST)
MIME-Version: 1.0
References: <20221109014018.312181-1-liuhangbin@gmail.com> <49594248-1fd7-23e2-1f17-9af896cd25b0@gmail.com>
 <17540.1668026368@famine>
In-Reply-To: <17540.1668026368@famine>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 9 Nov 2022 12:45:15 -0800
Message-ID: <CANn89i+eZwb3+JO6oKavj5yTi74vaUY-=Pu4CaUbcq==ue9NCw@mail.gmail.com>
Subject: Re: [PATCHv3 net] bonding: fix ICMPv6 header handling when receiving
 IPv6 messages
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>,
        David Ahern <dsahern@kernel.org>
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

On Wed, Nov 9, 2022 at 12:39 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> >
> >
> >On 11/8/22 17:40, Hangbin Liu wrote:
> >> Currently, we get icmp6hdr via function icmp6_hdr(), which needs the skb
> >> transport header to be set first. But there is no rule to ask driver set
> >> transport header before netif_receive_skb() and bond_handle_frame(). So
> >> we will not able to get correct icmp6hdr on some drivers.
> >>
> >> Fix this by checking the skb length manually and getting icmp6 header based
> >> on the IPv6 header offset.
> >>
> >> Reported-by: Liang Li <liali@redhat.com>
> >> Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
> >> Acked-by: Jonathan Toppins <jtoppins@redhat.com>
> >> Reviewed-by: David Ahern <dsahern@kernel.org>
> >> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> >> ---
> >> v3: fix _hdr parameter warning reported by kernel test robot
> >> v2: use skb_header_pointer() to get icmp6hdr as Jay suggested.
> >> ---
> >>   drivers/net/bonding/bond_main.c | 9 +++++++--
> >>   1 file changed, 7 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> >> index e84c49bf4d0c..2c6356232668 100644
> >> --- a/drivers/net/bonding/bond_main.c
> >> +++ b/drivers/net/bonding/bond_main.c
> >> @@ -3231,12 +3231,17 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
> >>                     struct slave *slave)
> >>   {
> >>      struct slave *curr_active_slave, *curr_arp_slave;
> >> -    struct icmp6hdr *hdr = icmp6_hdr(skb);
> >>      struct in6_addr *saddr, *daddr;
> >> +    const struct icmp6hdr *hdr;
> >> +    struct icmp6hdr _hdr;
> >>      if (skb->pkt_type == PACKET_OTHERHOST ||
> >>          skb->pkt_type == PACKET_LOOPBACK ||
> >> -        hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
> >> +        ipv6_hdr(skb)->nexthdr != NEXTHDR_ICMP)
> >
> >
> >What makes sure IPv6 header is in skb->head (linear part of the skb) ?
>
>         Ah, missed that; skb_header_pointer() will take care of that
> (copying if necessary, not that it pulls the header), but it has to be
> called first.
>
>         This isn't a problem new to this patch, the original code
> doesn't pull or copy the header, either.

Quite frankly I would simply use

if (pskb_may_pull(skb, sizeof(struct ipv6hdr) + sizeof(struct icmp6hdr))
 instead of  skb_header_pointer()
because chances are high we will need the whole thing in skb->head later.

>
>         The equivalent function for ARP, bond_arp_rcv(), more or less
> inlines skb_header_pointer(), so it doesn't have this issue.
>
>         -J
>
> >
> >> +            goto out;
> >> +
> >> +    hdr = skb_header_pointer(skb, sizeof(struct ipv6hdr), sizeof(_hdr), &_hdr);
> >> +    if (!hdr || hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
> >>              goto out;
> >>      saddr = &ipv6_hdr(skb)->saddr;
>
> ---
>         -Jay Vosburgh, jay.vosburgh@canonical.com
