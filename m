Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3044048381A
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 21:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiACU4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 15:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiACU4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 15:56:00 -0500
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFF9C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 12:56:00 -0800 (PST)
Received: by mail-vk1-xa36.google.com with SMTP id j4so16797738vkr.12
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 12:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kBCv1hiVhuuOp+1hg/IIlyCmZYHEVIeQLXIAB0ScoQc=;
        b=k42xQLw+JNbk3cFjxgmKHfaPbImKtsZicapYBIK6L0nnU+wDnFwpOFs0CkDbpzBfvE
         WZD+qzLjUIz+u7YEJhRksPEUkaHjDNWnh3BptnYGVQm4UYvPtuwoOpctAIADd/Brdevw
         xdrib5l3CKvzZmWmCKHL7SP6saAc4MnmEU9ENQVtFehWGsJIvJAy1wIVkmPmIC7Ai2xu
         q8YZqGdJua/deUcv/bHil6p0nhMzEqlhG8BuxOSWYQ2Pk3xXKbAXOzgBPM1G3pg2TXeX
         /dXaz3446BJcUwRK2n6i7Eha7ADvttCsl6PLkU7ka1/6LZ7OOy9JokBa2Dn38tibEf5H
         quyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kBCv1hiVhuuOp+1hg/IIlyCmZYHEVIeQLXIAB0ScoQc=;
        b=e2/6n0mr8WxbAbRjGm0LhYVnOdg7cX6bMG9NeGrlEZJE6vmOOV9ILza3GH1kuR33O0
         TlY/cxBqvmoQa9mBh/skAVQ4TwEmPKv8eSiae3AUfUIKtc3Wb97HD/t2KJa8mMLpF7zq
         Ebp5O6/eN1CmbmJm/h1SCSJ14F0gxqFoUxfvrUULIV8LtOOLvIL2KIpg1TpAbvHPW9Mt
         hvdSQYE3Ct2pvHDucqROyRCeWPlh70t4PsokivYV04N15MYRlSytFHIK4gU8l9kRRsMP
         tg1gv6/YhdZmFswkr1REkmQHH3j+SdCTWGYD45BOm7xdfBv1Mpjobi25Hb61MNJMlfXN
         ZL9g==
X-Gm-Message-State: AOAM531weRfScT7Z664GbKooEmCYPPxjUBbicxa20rOk/oEoWTUqABLB
        P8w8qg1z66RM9bNG4PQ22rL3xB2zfokV5auuWDxwiQ==
X-Google-Smtp-Source: ABdhPJx15ZOGWrTLmHj+i3xcEeTDQfTjpItj5Ol4R9v8Zra8VzcC89dKmtXYti9oXVvKv7DSD70tn9ObzuYt+Yw+QdU=
X-Received: by 2002:ac5:c5c7:: with SMTP id g7mr14963612vkl.29.1641243359602;
 Mon, 03 Jan 2022 12:55:59 -0800 (PST)
MIME-Version: 1.0
References: <20220103171132.93456-1-andrew@lunn.ch> <20220103171132.93456-3-andrew@lunn.ch>
 <c67d22c7-2f1b-b619-b14e-2f5076b92a15@gmail.com>
In-Reply-To: <c67d22c7-2f1b-b619-b14e-2f5076b92a15@gmail.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Mon, 3 Jan 2022 15:55:23 -0500
Message-ID: <CA+FuTSewvc1k_JJtZc-NCZmo0y+mjradkP3mM7=1obA2LQFcWA@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 2/3] icmp: ICMPV6: Examine invoking packet for
 Segment Route Headers.
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 3, 2022 at 12:34 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/3/22 10:11 AM, Andrew Lunn wrote:
> > RFC8754 says:
> >
> > ICMP error packets generated within the SR domain are sent to source
> > nodes within the SR domain.  The invoking packet in the ICMP error
> > message may contain an SRH.  Since the destination address of a packet
> > with an SRH changes as each segment is processed, it may not be the
> > destination used by the socket or application that generated the
> > invoking packet.
> >
> > For the source of an invoking packet to process the ICMP error
> > message, the ultimate destination address of the IPv6 header may be
> > required.  The following logic is used to determine the destination
> > address for use by protocol-error handlers.
> >
> > *  Walk all extension headers of the invoking IPv6 packet to the
> >    routing extension header preceding the upper-layer header.
> >
> >    -  If routing header is type 4 Segment Routing Header (SRH)
> >
> >       o  The SID at Segment List[0] may be used as the destination
> >          address of the invoking packet.
> >
> > Mangle the skb so the network header points to the invoking packet
> > inside the ICMP packet. The seg6 helpers can then be used on the skb
> > to find any segment routing headers. If found, mark this fact in the
> > IPv6 control block of the skb, and store the offset into the packet of
> > the SRH. Then restore the skb back to its old state.
> >
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  include/linux/ipv6.h |  2 ++
> >  include/net/seg6.h   |  1 +
> >  net/ipv6/icmp.c      |  6 +++++-
> >  net/ipv6/seg6.c      | 30 ++++++++++++++++++++++++++++++
> >  4 files changed, 38 insertions(+), 1 deletion(-)
> >
>
> Reviewed-by: David Ahern <dsahern@kernel.org>
>
Reviewed-by: Willem de Bruijn <willemb@google.com>
