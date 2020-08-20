Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8375C24B1DC
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 11:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgHTJOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 05:14:41 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:37407 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbgHTJOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 05:14:06 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id acce9074;
        Thu, 20 Aug 2020 08:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=EmqNmAaP9d5tln4z5/gXHm1XFQk=; b=Y6iqPX
        WaA2oJk4rNuOxnfLhqF7entIN6S3kDv2hCqZN6B32nJzyTCpJKn5orL9UubNa2DI
        R4ROW/buKNsGHuLJ2JjDarVa80noHhUL+fROwzJFE6Aa6X0gUf2redFYk5Ed7bQE
        InRFtIq1qpCG0jmCPQW3KVCFSxrUeToVZo6rbt7wJZxDej/mSb+asVP0lIOfq78t
        9Qgt7MpdwfnnPcU0jSeBabsTzUqVAip1dmsIyhdu8xhUWKnNMMV+VVtOyIIcRH1F
        e3P+vz0OL60ERH3kkh9CtR53eJmqYq+2HbTnQL3H/GEWrKHLqJZ7u7iudRqzf9TE
        Q9O8Ysh4Alv2Jigw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c146ec0b (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 20 Aug 2020 08:47:37 +0000 (UTC)
Received: by mail-io1-f46.google.com with SMTP id b17so1452280ion.7;
        Thu, 20 Aug 2020 02:14:01 -0700 (PDT)
X-Gm-Message-State: AOAM530gpQXUighAJQfZ4nwkTikY5fS8iwwnouGjX0TMgJkTxOFKITa/
        3GWKzgzRals59LgjjnGxhqI0MPzBBIp47Y8vc1w=
X-Google-Smtp-Source: ABdhPJwrD+kMX381ZsNH5ZVv7XZpJr3WPE37RwgpGR8uD3r1z7iibyb0fdT8uJc3F2IdHO7K9Ylo+qHdlk4BWFZdUgE=
X-Received: by 2002:a6b:b211:: with SMTP id b17mr1793664iof.29.1597914841074;
 Thu, 20 Aug 2020 02:14:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200814.135546.2266851283177227377.davem@davemloft.net>
 <20200815074102.5357-1-Jason@zx2c4.com> <20200819.162247.527509541688231611.davem@davemloft.net>
In-Reply-To: <20200819.162247.527509541688231611.davem@davemloft.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 20 Aug 2020 11:13:49 +0200
X-Gmail-Original-Message-ID: <CAHmME9oBQu-k6VKJ5QzVLpE-ZuYoo=qHGKESj8JbxQhDq9QNrQ@mail.gmail.com>
Message-ID: <CAHmME9oBQu-k6VKJ5QzVLpE-ZuYoo=qHGKESj8JbxQhDq9QNrQ@mail.gmail.com>
Subject: Re: [PATCH net v6] net: xdp: account for layer 3 packets in generic
 skb handler
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Thomas Ptacek <thomas@sockpuppet.org>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        john.fastabend@gmail.com, Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 1:22 AM David Miller <davem@davemloft.net> wrote:
>
> From: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Date: Sat, 15 Aug 2020 09:41:02 +0200
>
> > A user reported that packets from wireguard were possibly ignored by XDP
> > [1]. Another user reported that modifying packets from layer 3
> > interfaces results in impossible to diagnose drops.
>
> Jason this really is a minefield.
>
> If you make everything look like ethernet, even when it isn't, that is
> a huge pile of worms.
>
> If the XDP program changes the fake ethernet header's protocol field,
> what will update the next protocol field in the wireguard
> encapsulation headers so that it matches?
>
> How do you support pushing VLAN headers as some XDP programs do?  What
> will undo the fake ethernet header and push the VLAN header into the
> right place, and set it's next protocol field correctly?
>
> And so on, and so forth...

Huh, that's an interesting set of considerations. It looks like after
the generic XDP program runs, there's a call to
skb_vlan_untag()->skb_reorder_vlan_header() if skb->protocol is 8021q
or 8021qad, which makes me think the stack will just do the right
thing? I'm probably overlooking some critical detail that you and
Jesper find clear. My understanding of the generic XDP handler for L2
packets is:

1. They arrive with skb->data pointing at L3, but skb->data - mac_len
is the L2 header.
2. This skb->data - mac_len pointer is what's passed to the eBPF executor.
3. When it's done, skb->data still points to the L3 data, but the eBPF
program might have pushed some things on before that or altered the
ethernet header.
4. If the ethernet header's h_proto is changed, so skb->protocol is
updated (along with the broadcast/multicast flag too).
5. The skb is passed onto the rest of the stack, with skb->data still
pointing to L3, but with L2 existing in the area just before
skb->data, just like how it came in.

This patch attempts to add L3 semantics that slightly modify the flow
for L3 packets:

1. They arrive with skb->data pointing at L3, with nothing coherent
before skb->data.
2. An ethernet header is pushed onto the packet, and then pulled off
again, so that skb->data points at L3 but skb->data - ETH_HLEN points
to the fake L2.
3. Steps 2-5 from the above flow now apply.

It seems like if an eBPF program pushes on a VLAN tag or changes the
protocol or does any other modification, it will be treated in exactly
the same way as the L2 packet above by the remaining parts of the
networking stack.

However, Jesper points out in his previous message (I think) that by
only calling skb_push(skb, ETH_HLEN), I'm not actually increasing the
head room enough for eBPF programs to safely tack on vlan tags and
other things. In other words, I need to increase the head room more,
beyond a measly ETH_HLEN. That seems like an easy change.

> With so many unanswered questions and unclear semantics the only
> reasonable approach right now is to reject L3 devices from having XDP
> programs attached at this time.

I don't know if there are _so_ many unanswered questions, but it seems
like there remain some unknowns, but Jesper has made a good suggestion
that I start going through that test suite and make sure that
everything works properly there. It might be that one test starts
failing catastrophically, and when I investigate I find that there's
not a very clear cut answer as to how to fix it, reinforcing your
point. Or, perhaps it will all kind of work nicely without scary or
fundamental changes required. Mostly out of my own curiosity, I'll
give it a try when I'm at my desk again and report back.

> Arguably the best answer is the hardest answer, which is that we
> expose device protocols and headers exactly how they are and don't try
> to pretend they are something else.  But it really means that XDP
> programs have to be written targetted to the attach point device type.
> And it also means we need a way to update skb->protocol properly,
> handle the pushing of new headers, etc.

That's actually where this patch started many months ago, with just a
simple change to quit trying to cast skb->data-mac_len to an ethhdr in
the case that it's an L3 packet. Of course indeed that didn't address
skb->protocol. And it also didn't help L3 packets _become_ L2 packets,
which might be desirable. And in general it would mean that no
existing XDP programs would work with it, as Toke pointed out. So I
think if the pseudo ethernet header winds up being actually doable and
consistent, that's probably the best approach. You seem skeptical that
it is actually consistent, and you're probably right. I'll let you
know if I notice otherwise though, once I get that test suite rolling.

Jason
