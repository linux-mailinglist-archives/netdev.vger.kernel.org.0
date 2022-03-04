Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA024CDB42
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240456AbiCDRs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiCDRs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:48:56 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690216D3B3
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:48:04 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id f5so18310062ybg.9
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 09:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=geC609eANVIXabxMgb2mGi0bBzdrBOKrEVMS25Ipego=;
        b=KaPft3CLAZSjV4V2uNJS+VYi2QLZGeMVqZZ07I0D6rnWIKbyKzduRunlp1wJ8zijBN
         wXEl8+j2lsbgeXjxmItU/YvjchwcOF+GCk9Gsnv7dITnn7rpnTgAJ2yHv6WzDPO/D7iu
         TwUbPEkzJmRmKaqkgeiwI+ja4H0ExS9xKyDcu36XW0zVnGoKtZ0OUBAtEoH1tS01qplH
         sTNqHs+IyE+/0IxnUJ/WRDlJ+rk4vEhGG7h4tmveo/zAfDi3pmoEPA7u/TgfTmD1fYrj
         7JuuuHGrhCuKGXTBxRoVhWWRcLhFQs5ziORdDyN54XBsmgYqN6hhMnQYPc1+B0QVSEWW
         vxAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=geC609eANVIXabxMgb2mGi0bBzdrBOKrEVMS25Ipego=;
        b=YffUrftpkHKl4m4jTRM2Lc245QqS83M41qUzxGOhs9/mt+sIz9aOEp6q6hXvhtjbDJ
         bGzcuyENU4NVrfbI8ywZtBzKSMKuwQwEjVJBipYsLgM2tkbATDzb0RxOXqhWmNeZol0I
         PIRklfVh5BpWWQ7K9eYoOBsuIq4ePuKbQ0JlapdrYgKhBXBPCaYI4WbtmUqJiMDQP2oX
         GuyBSWtFqd635QIwZ1rT5o9bJDplfzlWKM3yCCr6eEtYnVYWyms42mF4BKMbo5spHPjp
         /qPnXFJ+vWKqCUTk+wFTSjT8Mch2AmhRvhlhyWfIbUUNH7uxFh2ZZ++pF04JQiW8mIlr
         vJGw==
X-Gm-Message-State: AOAM530ijL+Nr7DyK7XxuvBWn326YTUbXRrkfM3sJQaeMIxQaCS6CD0Q
        XvOQR84Zh8oMCPLSyNqAjmQjPeTOnUWDowHwsZDKvQ==
X-Google-Smtp-Source: ABdhPJyNzF5Xy0cSu2fEGnreXm/A6sk2+RLMuWKIa+t5SR6k721/McJcNG9Wsw9rq5DbAQDWFOkqTbW0Kdul/lJxXJw=
X-Received: by 2002:a25:f45:0:b0:628:b4c9:7a9f with SMTP id
 66-20020a250f45000000b00628b4c97a9fmr11315575ybp.55.1646416083246; Fri, 04
 Mar 2022 09:48:03 -0800 (PST)
MIME-Version: 1.0
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
 <20220303181607.1094358-9-eric.dumazet@gmail.com> <726720e6-cd28-646c-1ba3-576a258ae02e@kernel.org>
In-Reply-To: <726720e6-cd28-646c-1ba3-576a258ae02e@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Mar 2022 09:47:52 -0800
Message-ID: <CANn89iL2gXRsnC20a+=YJ+Ug=3x_jacmtL+S269_0g+E0wDYSQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 08/14] ipv6: Add hop-by-hop header to
 jumbograms in ip6_output
To:     David Ahern <dsahern@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 3, 2022 at 8:33 PM David Ahern <dsahern@kernel.org> wrote:
>
> On 3/3/22 11:16 AM, Eric Dumazet wrote:
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
>
>
> I am fairly certain I know how you are going to respond, but I will ask
> this anyways :-) :
>
> The networking stack as it stands today does not care that skb->len >
> 64kB and nothing stops a driver from setting max gso size to be > 64kB.
> Sure, packet socket apps (tcpdump) get confused but if the h/w supports
> the larger packet size it just works.

Observability is key. "just works" is a bold claim.

>
> The jumbogram header is getting adding at the L3/IPv6 layer and then
> removed by the drivers before pushing to hardware. So, the only benefit
> of the push and pop of the jumbogram header is for packet sockets and
> tc/ebpf programs - assuming those programs understand the header
> (tcpdump (libpcap?) yes, random packet socket program maybe not). Yes,
> it is a standard header so apps have a chance to understand the larger
> packet size, but what is the likelihood that random apps or even ebpf
> programs will understand it?

Can you explain to me what you are referring to by " random apps" exactly ?
TCP does not expose to user space any individual packet length.



>
> Alternative solutions to the packet socket (ebpf programs have access to
> skb->len) problem would allow IPv4 to join the Big TCP party. I am
> wondering how feasible an alternative solution is to get large packet
> sizes across the board with less overhead and changes.

You know, I think I already answered this question 6 months ago.

We need to carry an extra metadata to carry how much TCP payload is in a packet,
both on RX and TX side.

Adding an skb field for that was not an option for me.

Adding a 8 bytes header is basically free, the headers need to be in cpu caches
when the header is added/removed.

This is zero cost on current cpus, compared to the gains.

I think you focus on TSO side, which is only 25% of the possible gains
that BIG TCP was seeking for.

We covered both RX and TX with a common mechanism.
