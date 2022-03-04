Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246D04CD9C7
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238009AbiCDRK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbiCDRK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:10:27 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0ED412222F
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:09:39 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id h126so18164411ybc.1
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 09:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AjWm2d6YueLrhyI8e42285gsJeLPRD/XTJSBKd/LzGM=;
        b=Ck6RER+r1+3Xs62NTYTSXfxGPAgx/W8rZb6bULJzsdAvwtuvSK+Gdb5fXEuSQdgEp9
         9Y14ZwC7bpFwB5R6r6ySUQOD7oxX5q0PMVLk/EIKYrsKmO7NRobjZpqC0BOevBuFN2IL
         oc/gE+yOxveiSRCPY2T6bahOrbfDrdESBg4639skDn3UTzOao5FCPi7As3PgcVQOAW2J
         IN7Rt6w9UWHKzWOO1ln8W2Y1dkP3ZysOz+qvep7cVbB/RFiW55ociNbEBxPAhjfDPpyG
         IP8kNvrhdJ/7o65TTFA9Q0VBMfz8YQdm6X1Xa9lfbKO2xvjWUNJWAEl4eGjny+ZlzC2+
         RlXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AjWm2d6YueLrhyI8e42285gsJeLPRD/XTJSBKd/LzGM=;
        b=Z6HuKI1m4H27IIY83SoZKohImSLgbGUm030swMHlBDxXXw8avaXghGZU05i2dcZpcl
         cwHEhiNvNZDOZ62HFehMxoNyRd/38SXGr5tkpzlovr9ipcWikdbpwsyAym2KkMzsbN3q
         YAXYJWpI5DjL+yNtpZvMwXk28vhbAgTiuveopWyGnYxyJMVDWKCmJcIyJPAUMKbYeAx1
         N+p6JUeaQN5cYbqcnZC0AkVZxqYasZcMve79papBxOQi79/xW/s7e8FkKeU6pWTU6tN2
         8k2Tc6Yf4atwF6Zqgv4FHB2kHiG4CepDXBl83S9KEQqWFQcTaPnxjLUHCAtKwo8gOF6+
         V6zQ==
X-Gm-Message-State: AOAM532y20n7xezUZahUVmT3hnrJ/gQV5V8osuO9c+GFi0eIoGKtatuj
        E+RiY3XvjGEr0fCURBKE6VJ4lmWZrFqz58I/J3Wn/w==
X-Google-Smtp-Source: ABdhPJzwAvHYIN/xItWTHS12C5zxKsZeSde0NaSeU8QVD+Fl7Ghec8eGfEp3aSDTExofhaDPZvjrJcNgWOrbDoda6Ec=
X-Received: by 2002:a25:8243:0:b0:628:a926:38ff with SMTP id
 d3-20020a258243000000b00628a92638ffmr12560906ybn.36.1646413778534; Fri, 04
 Mar 2022 09:09:38 -0800 (PST)
MIME-Version: 1.0
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
 <20220303181607.1094358-9-eric.dumazet@gmail.com> <726720e6-cd28-646c-1ba3-576a258ae02e@kernel.org>
 <f478bb059d701b774b3d457eb5934f142a6044e8.camel@gmail.com>
In-Reply-To: <f478bb059d701b774b3d457eb5934f142a6044e8.camel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Mar 2022 09:09:27 -0800
Message-ID: <CANn89i+qJmD9At7otrptkCpnqVUCNi6wXNYnKiwJ1jnse5qNgg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 08/14] ipv6: Add hop-by-hop header to
 jumbograms in ip6_output
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
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

On Fri, Mar 4, 2022 at 7:48 AM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, 2022-03-03 at 21:33 -0700, David Ahern wrote:
> > On 3/3/22 11:16 AM, Eric Dumazet wrote:
> > > From: Coco Li <lixiaoyan@google.com>
> > >
> > > Instead of simply forcing a 0 payload_len in IPv6 header,
> > > implement RFC 2675 and insert a custom extension header.
> > >
> > > Note that only TCP stack is currently potentially generating
> > > jumbograms, and that this extension header is purely local,
> > > it wont be sent on a physical link.
> > >
> > > This is needed so that packet capture (tcpdump and friends)
> > > can properly dissect these large packets.
> > >
> >
> >
> > I am fairly certain I know how you are going to respond, but I will ask
> > this anyways :-) :
> >
> > The networking stack as it stands today does not care that skb->len >
> > 64kB and nothing stops a driver from setting max gso size to be > 64kB.
> > Sure, packet socket apps (tcpdump) get confused but if the h/w supports
> > the larger packet size it just works.
> >
> > The jumbogram header is getting adding at the L3/IPv6 layer and then
> > removed by the drivers before pushing to hardware. So, the only benefit
> > of the push and pop of the jumbogram header is for packet sockets and
> > tc/ebpf programs - assuming those programs understand the header
> > (tcpdump (libpcap?) yes, random packet socket program maybe not). Yes,
> > it is a standard header so apps have a chance to understand the larger
> > packet size, but what is the likelihood that random apps or even ebpf
> > programs will understand it?
> >
> > Alternative solutions to the packet socket (ebpf programs have access to
> > skb->len) problem would allow IPv4 to join the Big TCP party. I am
> > wondering how feasible an alternative solution is to get large packet
> > sizes across the board with less overhead and changes.
>
> I agree that the header insertion and removal seems like a lot of extra
> overhead for the sake of correctness. In the Microsoft case I am pretty
> sure their LSOv2 supported both v4 and v6. I think we could do
> something similar, we would just need to make certain the device
> supports it and as such maybe it would make sense to implement it as a
> gso type flag?
>
> Could we handle the length field like we handle the checksum and place
> a value in there that we know is wrong, but could be used to provide
> additional data? Perhaps we could even use it to store the MSS in the
> form of the length of the first packet so if examined, the packet would
> look like the first frame of the flow with a set of trailing data.
>

I am a bit sad you did not give all this feedback back in August when
I presented BIG TCP.

We did a lot of work in the last 6 months to implement, test all this,
making sure this worked.

I am not sure I want to spend another 6 months implementing what you suggest.

For instance, input path will not like packets larger than 64KB.

There is this thing trimming padding bytes, you probably do not want
to mess with this.
