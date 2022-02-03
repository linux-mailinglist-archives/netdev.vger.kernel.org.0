Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5527E4A889A
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240172AbiBCQbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbiBCQbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:31:15 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A51C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 08:31:15 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id j2so10805766ybu.0
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 08:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H42to55yOhDlKsqJIVjap3K1IgLNSTsR60dR1A1e+U8=;
        b=saKRqxKS3dygZ8E/L3rbIoYk40zR2SdgwLIaVL32+gxHij4OmDbzgtjUVfQpY6j4H/
         R1kb99NqUSOhinkYcRs7i3335/+qAxAGuEkauTc3zwDXlvRxTpnjj+0UQ3bQzEJlG3Q2
         s/mXiN+fxHzoKSj1HZu9DlHslUvTjjco4L6EfO2VXfNrbVNUkP5J21IYBEDLVJgzX34r
         b9qtFJbhhxt8SSu7EFZijONI9kz/qG08Jh8tRSXJ3w9jUAYnkR0baK67MFtox7LX5e/1
         BLmgYYJ/kLGIPF5kiSHoo5MQ5CV5fs9yeMNEHidrNRnYvZytMliXRXkXE2t2pRK9tYx2
         Hzcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H42to55yOhDlKsqJIVjap3K1IgLNSTsR60dR1A1e+U8=;
        b=2UeTlGl+612sVmiypJIzKpf9WOM73bScA1QD5e9dkmimr/ix6i8RXsNxKp7aS8Ysm1
         RobbK1qfGv6bz3mGpF+5Bb2e1Po0z97CgDN+GVroY3HaLf8Ya9CKwKMs7Dg5914P53Oz
         tYcpkUo5TGMa23Q50a9j3V1UdmMRcIiBoV9CZ75bwt4Ss7V53fbDxUpU9j/nprYCqsU/
         JBOd4wGjXa7GkM4Mx80IWtcTbpSbmVhImeEoB/sPN7ptekR4zJsJgF1Px7UZWZf/VgXl
         Rq1WizBUzEA6LuCCzdR/wsRTvIR4DmPVX6LMnx62Sbz7puZZTWJ8voGWBjD/RF6Lqjdn
         1AjQ==
X-Gm-Message-State: AOAM5325mnIBnZwIAf8t5Tbnhv0yfrjYgkVitwdAZhXCwqe5OId/fKjR
        GTvi3DMDAJaNIhHUhMynM16Y1+GP4uAEs9qpv9jIF3EUtPnhQBXB
X-Google-Smtp-Source: ABdhPJyviILGgcDjPHmkKdIQYoseCTVp+CZLU7Z3GxRnYPL7QGCBoJRaYpN+YuWVodPoAR+oTWEfHy1cyFU4tKDYueo=
X-Received: by 2002:a81:c201:: with SMTP id z1mr5122465ywc.447.1643905873443;
 Thu, 03 Feb 2022 08:31:13 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-9-eric.dumazet@gmail.com> <cefef8b5dfd8f5944e74f5f6bf09692f4984db6a.camel@redhat.com>
In-Reply-To: <cefef8b5dfd8f5944e74f5f6bf09692f4984db6a.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 08:31:02 -0800
Message-ID: <CANn89iLmOwfYSKZk6_Qb5pv7=b_933k-=Pcb7OeST4yhB+xEtg@mail.gmail.com>
Subject: Re: [PATCH net-next 08/15] ipv6: Add hop-by-hop header to jumbograms
 in ip6_output
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 1:07 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Wed, 2022-02-02 at 17:51 -0800, Eric Dumazet wrote:
> > From: Coco Li <lixiaoyan@google.com>
> >
> > Instead of simply forcing a 0 payload_len in IPv6 header,
> > implement RFC 2675 and insert a custom extension header.
> >
> > Note that only TCP stack is currently potentially generating
> > jumbograms, and that this extension header is purely local,
> > it wont be sent on a physical link.
> >
> > This is needed so that packet capture (tcpdump and friends)
> > can properly dissect these large packets.
> >
> > Signed-off-by: Coco Li <lixiaoyan@google.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  include/linux/ipv6.h  |  1 +
> >  net/ipv6/ip6_output.c | 22 ++++++++++++++++++++--
> >  2 files changed, 21 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
> > index 1e0f8a31f3de175659dca9ecee9f97d8b01e2b68..d3fb87e1589997570cde9cb5d92b2222008a229d 100644
> > --- a/include/linux/ipv6.h
> > +++ b/include/linux/ipv6.h
> > @@ -144,6 +144,7 @@ struct inet6_skb_parm {
> >  #define IP6SKB_L3SLAVE         64
> >  #define IP6SKB_JUMBOGRAM      128
> >  #define IP6SKB_SEG6        256
> > +#define IP6SKB_FAKEJUMBO      512
> >  };
> >
> >  #if defined(CONFIG_NET_L3_MASTER_DEV)
> > diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> > index 0c6c971ce0a58b50f8a9349b8507dffac9c7818c..f78ba145620560e5d7cb25aaf16fec61ddd9ed40 100644
> > --- a/net/ipv6/ip6_output.c
> > +++ b/net/ipv6/ip6_output.c
> > @@ -180,7 +180,9 @@ static int __ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff
> >  #endif
> >
> >       mtu = ip6_skb_dst_mtu(skb);
> > -     if (skb_is_gso(skb) && !skb_gso_validate_network_len(skb, mtu))
> > +     if (skb_is_gso(skb) &&
> > +         !(IP6CB(skb)->flags & IP6SKB_FAKEJUMBO) &&
> > +         !skb_gso_validate_network_len(skb, mtu))
> >               return ip6_finish_output_gso_slowpath_drop(net, sk, skb, mtu);
>
> If I read correctly jumbogram with gso len not fitting the egress
> device MTU will not be fragmented, as opposed to plain old GSO packets.
> Am I correct? why fragmentation is not needed for jumbogram?

I guess we could add this validation in place.

Honestly, we do not expect BIG TCP being deployed in hostile
environments (host having devices with different MTU)

Fragmentation is evil and should be avoided at all costs.
