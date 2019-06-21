Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 327CE4ED68
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 18:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfFUQuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 12:50:20 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:41697 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfFUQuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 12:50:20 -0400
Received: by mail-wr1-f48.google.com with SMTP id c2so7236834wrm.8;
        Fri, 21 Jun 2019 09:50:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=29o6NeBy6wk9fZq+GCDjPDFoEyOe843RypgLINVpaWA=;
        b=eRne8zneqWGhKT6TJifm+876NHgWHmxlpeWS40Y1S9G7UCALthMxkNEpe+PpPFXgOX
         /3pSLjHQDiQ8mo6HUdw9lTAqi9+W7k2cyNZKG4SzRwITBqrpKtz1y7uF5RYDAsNRUhKK
         YdPtpPyFzrc0gtkhthl/ayJ822DviXkHYoHpb3xTW2IMNhEYvFWP0lTWwxmKT2MIIEq/
         ES5tFCwxg3hB5+ClgjdN/uLh9gTH3i1JFcJc1LEg7vmJFs1gYeqQ40xsvJcd6O0v3D+C
         gmwwBZ48RwTDfPQ5fuwM0xAnRBC6v2oFZQRVcmsso9OeMOA25LRdcp9r+4fuYXK2Ey2R
         Ctzg==
X-Gm-Message-State: APjAAAU8q6Mbni+HGydwK2MdpzOOQoW9V9Ty3OADOgm77mgrS0304iUm
        I+9FjWNjbEgZVeSVjUErHRywGHZtqmu3UahnFkw=
X-Google-Smtp-Source: APXvYqzg4INe1opdWapr3vXkBnv7WrpISXQjklvv3OaCr/dr2DAs9rYSS3wFj24DQJbQ9lBfxGJ22NYPRY2FLkz7Ymg=
X-Received: by 2002:adf:dbd2:: with SMTP id e18mr19511992wrj.110.1561135817682;
 Fri, 21 Jun 2019 09:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190618130050.8344-1-jakub@cloudflare.com> <20190618135258.spo6c457h6dfknt2@breakpoint.cc>
 <87sgs6ey43.fsf@cloudflare.com> <CAOftzPj6NWyWnz4JL-mXBaQUKAvQDtKJTrjZmrN4W5rqoy-W0A@mail.gmail.com>
 <CAGn+7TUmgsA8oKw-mM6S5iR4rmNt6sWxjUgw8=qSCHb=m0ROyg@mail.gmail.com>
In-Reply-To: <CAGn+7TUmgsA8oKw-mM6S5iR4rmNt6sWxjUgw8=qSCHb=m0ROyg@mail.gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Fri, 21 Jun 2019 09:50:06 -0700
Message-ID: <CAOftzPhGVeLpqbffLwBP8JCvY1t65-uXztEsZV0qJEQapywRgg@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/7] Programming socket lookup with BPF
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Joe Stringer <joe@wand.net.nz>, Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 1:44 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Fri, Jun 21, 2019, 00:20 Joe Stringer <joe@wand.net.nz> wrote:
>>
>> On Wed, Jun 19, 2019 at 2:14 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>> >
>> > Hey Florian,
>> >
>> > Thanks for taking a look at it.
>> >
>> > On Tue, Jun 18, 2019 at 03:52 PM CEST, Florian Westphal wrote:
>> > > Jakub Sitnicki <jakub@cloudflare.com> wrote:
>> > >>  - XDP programs using bpf_sk_lookup helpers, like load balancers, can't
>> > >>    find the listening socket to check for SYN cookies with TPROXY redirect.
>> > >
>> > > Sorry for the question, but where is the problem?
>> > > (i.e., is it with TPROXY or bpf side)?
>> >
>> > The way I see it is that the problem is that we have mappings for
>> > steering traffic into sockets split between two places: (1) the socket
>> > lookup tables, and (2) the TPROXY rules.
>> >
>> > BPF programs that need to check if there is a socket the packet is
>> > destined for have access to the socket lookup tables, via the mentioned
>> > bpf_sk_lookup helper, but are unaware of TPROXY redirects.
>> >
>> > For TCP we're able to look up from BPF if there are any established,
>> > request, and "normal" listening sockets. The listening sockets that
>> > receive connections via TPROXY are invisible to BPF progs.
>> >
>> > Why are we interested in finding all listening sockets? To check if any
>> > of them had SYN queue overflow recently and if we should honor SYN
>> > cookies.
>>
>> Why are they invisible? Can't you look them up with bpf_skc_lookup_tcp()?
>
>
> They are invisible in that sense that you can't look them up using the packet 4-tuple. You have to somehow make the XDP/TC progs aware of the TPROXY redirects to find the target sockets.

Isn't that what you're doing in the example from the cover letter
(reincluded below for reference), except with the new program type
rather than XDP/TC progs?

       switch (bpf_ntohl(ctx->local_ip4) >> 8) {
        case NET1:
                ctx->local_ip4 = bpf_htonl(IP4(127, 0, 0, 1));
                ctx->local_port = 81;
                return BPF_REDIRECT;
        case NET2:
                ctx->local_ip4 = bpf_htonl(IP4(127, 0, 0, 1));
                ctx->local_port = 82;
                return BPF_REDIRECT;
        }

That said, I appreciate that even if you find the sockets from XDP,
you'd presumably need some way to retain the socket reference beyond
XDP execution to convince the stack to guide the traffic into that
socket, which would be a whole other effort. For your use case it may
or may not make the most sense.
