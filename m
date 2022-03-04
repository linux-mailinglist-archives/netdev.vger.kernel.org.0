Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DF44CDD12
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 20:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiCDTBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 14:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiCDTBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 14:01:41 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CE01DB3D3
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 11:00:53 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id f4so6967370qvd.0
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 11:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=U/vJVye5j+rJahrmvHt8LuJ3wwXhI0uYuxP4S0tJHAs=;
        b=edmtIPML1DG3XSYAEtd2Zf6lVjM1QTCZywEDu15dU1cL+B0XGhHGhsKl3vjBtFJO1x
         c0fePhsl2WYtvGNfiulZ4LXhzgI5gPddpC56DecA1chYmVBPAFtyaCoFcGMoviLhsR2o
         9TEct2pzCCGouOULrdBlu0pURKACfetGAeWu2/ycgEc7AdYdArL8mFbmlm3fOqBspXes
         Hngknylp9xa63+PxPmucMvcY2A+mk1KuT2Bb6WpSJisJGGNd8Xpoe1q5hROMOf1lSrYF
         DPo03xJT2zpXYuyzKlZLx1CRFh6wn6K18G6cJbNTO2Pc82EwmzuAf7Uigz0gmsTJb/Vx
         5khA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=U/vJVye5j+rJahrmvHt8LuJ3wwXhI0uYuxP4S0tJHAs=;
        b=eJhBZRACmzir1/U9dZaqgyC+SUSYTMfp1Y1C+mR+Ki+aeizISQ8BecYfD6a7yc+ncs
         AmW0uY3swGKokoideoWZLEvcaQNVjph4F1MBHabNNFOu421xN1DPk1i3nu0R3smy4aoD
         p1QzlVb8uHhej0oWSpA12llbnHDcqQkkvpu8Nuyu1a9GM9fVr7rLWQLq1bkwgU+8sSDP
         6L/Y+8ecdT81KGQ5e0t5ND51FRtAq8IQAM946+Je6m5/oc7fKdNDuGi74RoxRhFkLDMS
         B5+Cy7pjq56PaRs3NlTZKQ94OreUxjNRB5Gx9ZKMNDysa9+VgfhgYqq5eu3Xobc4oRHz
         UMug==
X-Gm-Message-State: AOAM531ufjAk4vZdvPVDU1ojiZB5Bpe54tWZANiN+1gYli3ScqxwvBNB
        2BBMpPM22+oBtTZ9fQYIbOqh9JXQ+uM=
X-Google-Smtp-Source: ABdhPJwm4YC98mArvuyvnkcPuxN6BZnTs9gqcz/NtqDwb3F2f6Xm7WIH0VRsEF0lMupxGAu8WFsbNw==
X-Received: by 2002:a05:6214:d84:b0:435:2f91:8c3e with SMTP id e4-20020a0562140d8400b004352f918c3emr130629qve.106.1646420452355;
        Fri, 04 Mar 2022 11:00:52 -0800 (PST)
Received: from ?IPv6:2001:470:b:9c3:82ee:73ff:fe41:9a02? ([2001:470:b:9c3:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id f7-20020a05622a104700b002d4b318692esm3870917qte.31.2022.03.04.11.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 11:00:51 -0800 (PST)
Message-ID: <ea73ca6cb4569847d5f2b2a3a5e1f88d78ba1c1a.camel@gmail.com>
Subject: Re: [PATCH v2 net-next 08/14] ipv6: Add hop-by-hop header to
 jumbograms in ip6_output
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Date:   Fri, 04 Mar 2022 11:00:49 -0800
In-Reply-To: <CANn89i+qJmD9At7otrptkCpnqVUCNi6wXNYnKiwJ1jnse5qNgg@mail.gmail.com>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
         <20220303181607.1094358-9-eric.dumazet@gmail.com>
         <726720e6-cd28-646c-1ba3-576a258ae02e@kernel.org>
         <f478bb059d701b774b3d457eb5934f142a6044e8.camel@gmail.com>
         <CANn89i+qJmD9At7otrptkCpnqVUCNi6wXNYnKiwJ1jnse5qNgg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-03-04 at 09:09 -0800, Eric Dumazet wrote:
> On Fri, Mar 4, 2022 at 7:48 AM Alexander H Duyck
> <alexander.duyck@gmail.com> wrote:
> > 
> > On Thu, 2022-03-03 at 21:33 -0700, David Ahern wrote:
> > > On 3/3/22 11:16 AM, Eric Dumazet wrote:
> > > > From: Coco Li <lixiaoyan@google.com>
> > > > 
> > > > Instead of simply forcing a 0 payload_len in IPv6 header,
> > > > implement RFC 2675 and insert a custom extension header.
> > > > 
> > > > Note that only TCP stack is currently potentially generating
> > > > jumbograms, and that this extension header is purely local,
> > > > it wont be sent on a physical link.
> > > > 
> > > > This is needed so that packet capture (tcpdump and friends)
> > > > can properly dissect these large packets.
> > > > 
> > > 
> > > 
> > > I am fairly certain I know how you are going to respond, but I will ask
> > > this anyways :-) :
> > > 
> > > The networking stack as it stands today does not care that skb->len >
> > > 64kB and nothing stops a driver from setting max gso size to be > 64kB.
> > > Sure, packet socket apps (tcpdump) get confused but if the h/w supports
> > > the larger packet size it just works.
> > > 
> > > The jumbogram header is getting adding at the L3/IPv6 layer and then
> > > removed by the drivers before pushing to hardware. So, the only benefit
> > > of the push and pop of the jumbogram header is for packet sockets and
> > > tc/ebpf programs - assuming those programs understand the header
> > > (tcpdump (libpcap?) yes, random packet socket program maybe not). Yes,
> > > it is a standard header so apps have a chance to understand the larger
> > > packet size, but what is the likelihood that random apps or even ebpf
> > > programs will understand it?
> > > 
> > > Alternative solutions to the packet socket (ebpf programs have access to
> > > skb->len) problem would allow IPv4 to join the Big TCP party. I am
> > > wondering how feasible an alternative solution is to get large packet
> > > sizes across the board with less overhead and changes.
> > 
> > I agree that the header insertion and removal seems like a lot of extra
> > overhead for the sake of correctness. In the Microsoft case I am pretty
> > sure their LSOv2 supported both v4 and v6. I think we could do
> > something similar, we would just need to make certain the device
> > supports it and as such maybe it would make sense to implement it as a
> > gso type flag?
> > 
> > Could we handle the length field like we handle the checksum and place
> > a value in there that we know is wrong, but could be used to provide
> > additional data? Perhaps we could even use it to store the MSS in the
> > form of the length of the first packet so if examined, the packet would
> > look like the first frame of the flow with a set of trailing data.
> > 
> 
> I am a bit sad you did not give all this feedback back in August when
> I presented BIG TCP.
> 

As I recall, I was thinking along the same lines as what you have done
here, but Dave's question about including IPv4 does bring up an
interesting point. And the Microsoft version supported both.

> We did a lot of work in the last 6 months to implement, test all this,
> making sure this worked.
> 
> I am not sure I want to spend another 6 months implementing what you suggest.

I am not saying we have to do this. I am simply stating a "what if"
just to gauge this approach. You could think of it as thinking out
loud, but in written form.

> For instance, input path will not like packets larger than 64KB.
> 
> There is this thing trimming padding bytes, you probably do not want
> to mess with this.

I had overlooked the fact that this is being used on the input path,
the trimming would be an issue. I suppose the fact that the LSOv2
didn't have an Rx counterpart would be one reason for us to not
consider the IPv4 approach.

