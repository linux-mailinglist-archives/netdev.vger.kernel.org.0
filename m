Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E07C41ED
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 22:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfJAUqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 16:46:06 -0400
Received: from smtp2.cs.stanford.edu ([171.64.64.26]:33004 "EHLO
        smtp2.cs.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfJAUqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 16:46:06 -0400
Received: from mail-lf1-f46.google.com ([209.85.167.46]:33595)
        by smtp2.cs.Stanford.EDU with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <ouster@cs.stanford.edu>)
        id 1iFP25-0001U4-71
        for netdev@vger.kernel.org; Tue, 01 Oct 2019 13:46:06 -0700
Received: by mail-lf1-f46.google.com with SMTP id y127so11005800lfc.0
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 13:46:05 -0700 (PDT)
X-Gm-Message-State: APjAAAULEKxOBr2uHsPp7LKYR19oexe3bvyMUj4RB59HaS5M6Hy2CVam
        bfkVwuXsB7Nh6k7mfUbhibCl7t+scgPCyH0V40k=
X-Google-Smtp-Source: APXvYqwPGzfRuYB4oJr48eY4aBhSA91zsY4kCECNSui+vkb3PI/LkGHj+AlBGAltVeEMJP5PGr5zTfStUIsFRa326Gg=
X-Received: by 2002:ac2:5148:: with SMTP id q8mr15399481lfd.84.1569962764143;
 Tue, 01 Oct 2019 13:46:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAGXJAmwQw1ohc48NfAvMyNDpDgHGkdVO89Jo8B0j0TuMr7wLpA@mail.gmail.com>
 <CAGXJAmz5izfnamHA3Y_hU-AT1CX5K2MN=6BPjRXXcTCWvPeWng@mail.gmail.com>
 <01ac3ff4-4c06-7a6c-13fc-29ca9ed3ad88@gmail.com> <CAGXJAmxmJ-Vm379N4nbjXeQCAgY9ur53wmr0HZy23dQ_t++r-Q@mail.gmail.com>
 <f4520c32-3133-fb3b-034e-d492d40eb066@gmail.com> <CAGXJAmygtKtt18nKV6qRCKXfO93DoK4C2Gv_RaMuahsZG3TS6A@mail.gmail.com>
 <c5886aed-8448-fe62-b2a3-4ae8fe23e2a6@gmail.com> <CAGXJAmzHvKzKb1wzxtZK_KCu-pEQghznM4qmfzYmWeWR1CaJ7Q@mail.gmail.com>
 <47fef079-635d-483e-b530-943b2a55fc22@gmail.com>
In-Reply-To: <47fef079-635d-483e-b530-943b2a55fc22@gmail.com>
From:   John Ousterhout <ouster@cs.stanford.edu>
Date:   Tue, 1 Oct 2019 13:45:27 -0700
X-Gmail-Original-Message-ID: <CAGXJAmy7PTZOcwRz-mSiZJkEL4sJKWhkE8kisUZp8M=V1BBA3g@mail.gmail.com>
Message-ID: <CAGXJAmy7PTZOcwRz-mSiZJkEL4sJKWhkE8kisUZp8M=V1BBA3g@mail.gmail.com>
Subject: Re: BUG: sk_backlog.len can overestimate
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Score: -1.0
X-Spam-Level: 
X-Spam-Checker-Version: SpamAssassin on smtp2.cs.Stanford.EDU
X-Scan-Signature: de489deba0db33f9a2e3877e449c7d79
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 11:34 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> On 10/1/19 10:25 AM, John Ousterhout wrote:
> > On Tue, Oct 1, 2019 at 9:19 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >> ...
> >> Sorry, I have no idea what is the problem you see.
> >
> > OK, let me try again from the start. Consider two values:
> > * sk->sk_backlog.len
> > * The actual number of bytes in buffers in the current backlog list
> >
> > Now consider a series of propositions:
> >
> > 1. These two are not always the same. As packets get processed by
> > calling sk_backlog_rcv, they are removed from the backlog list, so the
> > actual amount of memory consumed by the backlog list drops. However,
> > sk->sk_backlog.len doesn't change until the entire backlog is cleared,
> > at which point it is reset to zero. So, there can be periods of time
> > where sk->sk_backlog.len overstates the actual memory consumption of
> > the backlog.
>
> Yes, this is done on purpose (and documented in __release_sock()
>
> Otherwise you could have a livelock situation, with user thread being
> trapped forever in system, and never return to user land.
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8eae939f1400326b06d0c9afe53d2a484a326871
>
>
> >
> > 2. The gap between sk->sk_backlog.len and actual backlog size can grow
> > quite large. This happens if new packets arrive while sk_backlog_rcv
> > is working. The socket is locked, so these new packets will be added
> > to the backlog, which will increase sk->sk_backlog_len. Under high
> > load, this could continue indefinitely: packets keep arriving, so the
> > backlog never empties, so sk->sk_backlog_len never gets reset.
> > However, packets are actually being processed from the backlog, so
> > it's possible that the actual size of the backlog isn't changing, yet
> > sk->sk_backlog.len continues to grow.
> >
> > 3. Eventually, the growth in sk->sk_backlog.len will be limited by the
> > "limit" argument to sk_add_backlog. When this happens, packets will be
> > dropped.
>
> _Exactly_ WAI
>
> >
> > 4. Now suppose I pass a value of 1000000 as the limit to
> > sk_add_backlog. It's possible that sk_add_backlog will reject my
> > request even though the backlog only contains a total of 10000 bytes.
> > The other 990000 bytes were present on the backlog at one time (though
> > not necessarily all at the same time), but they have been processed
> > and removed; __release_sock hasn't gotten around to updating
> > sk->sk_backlog.len, because it hasn't been able to completely clear
> > the backlog.
>
> WAI
>
> >
> > 5. Bottom line: under high load, a socket can be forced to drop
> > packets even though it never actually exceeded its memory budget. This
> > isn't a case of a sender trying to fool us; we fooled ourselves,
> > because of the delay in resetting sk->sk_backlog.len.
> >
> > Does this make sense?
>
> Yes, just increase your socket limits. setsockopt(...  SO_RCVBUF ...),
> and risk user threads having bigger socket syscall latencies, obviously.

OK, I think I understand where you are coming from now. However, I
have a comment and a suggestion.

Comment: the terminology here confused me. The problem is that
sk->sk_backlog.len isn't actually a "length" (e.g., # bytes currently
stored in the backlog). It's actually "the total number of bytes added
to the backlog since the last time it was completely cleared."
Unfortunately, this isn't documented. Same thing for the limit: the
goal isn't to to limit the amount of data in the backlog, it's to
limit the amount of data processed in one call to __release_sock.
Although I saw the comment in __release_sock, it didn't have quite
enough info to fully apprise me of the problem being solved.

Suggestion: although the code does solve the problem you mentioned, it
has the unpleasant side effect that it can cause packet drops. This is
unfortunate because the drops are most likely to happen in periods of
overload, which is when you'd really like not to waste work that has
already been done. Did you consider the possibility of returning from
__release_sock without processing the entire backlog? For example,
once __release_sock has processed a bunch of packets, why not take the
others and feed them back through the NAPI mechanism again, so they'll
be passed to the net_protocol.handler again?

> > By the way, I have actually observed this phenomenon in an
> > implementation of the Homa transport protocol.
> >
>
> Maybe this transport protocol should size correctly its sockets limits :)

But this isn't really about socket resource limits (though that is
conflated in the implementation); it's about limiting the time spent
in a single call to __release_sock, no?
