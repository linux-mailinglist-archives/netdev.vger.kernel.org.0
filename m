Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE0A2C3E87
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbfJAR0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:26:01 -0400
Received: from smtp2.cs.stanford.edu ([171.64.64.26]:59984 "EHLO
        smtp2.cs.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730071AbfJAR0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 13:26:01 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:44608)
        by smtp2.cs.Stanford.EDU with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <ouster@cs.stanford.edu>)
        id 1iFLuS-0004W8-FB
        for netdev@vger.kernel.org; Tue, 01 Oct 2019 10:26:01 -0700
Received: by mail-pg1-f170.google.com with SMTP id i14so10088664pgt.11
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 10:26:00 -0700 (PDT)
X-Gm-Message-State: APjAAAXZkttQqpScXyfZd7sM5IzfEN/tolx/vZxOBYwhWXDQhlmJF2yR
        nll84L/jzVWHtFD2hhKOfey7xOJ1dhheq/VwAw8=
X-Google-Smtp-Source: APXvYqwGMxnPrpfqIvqhbSoWst5YJj16SjU8ub+UK/xF6njFtS+SNjp8XJGvEtG+k+srggiPRP+MX5xzqAroMU56/ag=
X-Received: by 2002:a17:90a:a00f:: with SMTP id q15mr6779714pjp.120.1569950760210;
 Tue, 01 Oct 2019 10:26:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAGXJAmwQw1ohc48NfAvMyNDpDgHGkdVO89Jo8B0j0TuMr7wLpA@mail.gmail.com>
 <CAGXJAmz5izfnamHA3Y_hU-AT1CX5K2MN=6BPjRXXcTCWvPeWng@mail.gmail.com>
 <01ac3ff4-4c06-7a6c-13fc-29ca9ed3ad88@gmail.com> <CAGXJAmxmJ-Vm379N4nbjXeQCAgY9ur53wmr0HZy23dQ_t++r-Q@mail.gmail.com>
 <f4520c32-3133-fb3b-034e-d492d40eb066@gmail.com> <CAGXJAmygtKtt18nKV6qRCKXfO93DoK4C2Gv_RaMuahsZG3TS6A@mail.gmail.com>
 <c5886aed-8448-fe62-b2a3-4ae8fe23e2a6@gmail.com>
In-Reply-To: <c5886aed-8448-fe62-b2a3-4ae8fe23e2a6@gmail.com>
From:   John Ousterhout <ouster@cs.stanford.edu>
Date:   Tue, 1 Oct 2019 10:25:21 -0700
X-Gmail-Original-Message-ID: <CAGXJAmzHvKzKb1wzxtZK_KCu-pEQghznM4qmfzYmWeWR1CaJ7Q@mail.gmail.com>
Message-ID: <CAGXJAmzHvKzKb1wzxtZK_KCu-pEQghznM4qmfzYmWeWR1CaJ7Q@mail.gmail.com>
Subject: Re: BUG: sk_backlog.len can overestimate
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Score: -1.0
X-Spam-Level: 
X-Spam-Checker-Version: SpamAssassin on smtp2.cs.Stanford.EDU
X-Scan-Signature: 127ff6e1eac6b45a32dc112250ed777d
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 9:19 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> ...
> Sorry, I have no idea what is the problem you see.

OK, let me try again from the start. Consider two values:
* sk->sk_backlog.len
* The actual number of bytes in buffers in the current backlog list

Now consider a series of propositions:

1. These two are not always the same. As packets get processed by
calling sk_backlog_rcv, they are removed from the backlog list, so the
actual amount of memory consumed by the backlog list drops. However,
sk->sk_backlog.len doesn't change until the entire backlog is cleared,
at which point it is reset to zero. So, there can be periods of time
where sk->sk_backlog.len overstates the actual memory consumption of
the backlog.

2. The gap between sk->sk_backlog.len and actual backlog size can grow
quite large. This happens if new packets arrive while sk_backlog_rcv
is working. The socket is locked, so these new packets will be added
to the backlog, which will increase sk->sk_backlog_len. Under high
load, this could continue indefinitely: packets keep arriving, so the
backlog never empties, so sk->sk_backlog_len never gets reset.
However, packets are actually being processed from the backlog, so
it's possible that the actual size of the backlog isn't changing, yet
sk->sk_backlog.len continues to grow.

3. Eventually, the growth in sk->sk_backlog.len will be limited by the
"limit" argument to sk_add_backlog. When this happens, packets will be
dropped.

4. Now suppose I pass a value of 1000000 as the limit to
sk_add_backlog. It's possible that sk_add_backlog will reject my
request even though the backlog only contains a total of 10000 bytes.
The other 990000 bytes were present on the backlog at one time (though
not necessarily all at the same time), but they have been processed
and removed; __release_sock hasn't gotten around to updating
sk->sk_backlog.len, because it hasn't been able to completely clear
the backlog.

5. Bottom line: under high load, a socket can be forced to drop
packets even though it never actually exceeded its memory budget. This
isn't a case of a sender trying to fool us; we fooled ourselves,
because of the delay in resetting sk->sk_backlog.len.

Does this make sense?

By the way, I have actually observed this phenomenon in an
implementation of the Homa transport protocol.
