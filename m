Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A982BC4416
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 01:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbfJAXCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 19:02:20 -0400
Received: from smtp1.cs.stanford.edu ([171.64.64.25]:42040 "EHLO
        smtp1.cs.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728555AbfJAXCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 19:02:20 -0400
Received: from mail-lj1-f173.google.com ([209.85.208.173]:43091)
        by smtp1.cs.Stanford.EDU with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <ouster@cs.stanford.edu>)
        id 1iFR9u-0004c9-QS
        for netdev@vger.kernel.org; Tue, 01 Oct 2019 16:02:19 -0700
Received: by mail-lj1-f173.google.com with SMTP id n14so15097991ljj.10
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 16:02:18 -0700 (PDT)
X-Gm-Message-State: APjAAAXnB8fV+4iq9pE9Xky0peQg5IwqCYZo7nxdl+0TcjeDrXT6PC2k
        e0un77MkryVv1+rfsTPdHGUjoFQ8m8TCio9/im4=
X-Google-Smtp-Source: APXvYqyklF+Ax9QgrnDKxLs0gBsdi3eqsZqfB08m32FxxgtFb9pF3qwP0eo817in14Q8soB+0xQcjuz1cX3eixv5BOw=
X-Received: by 2002:a2e:8941:: with SMTP id b1mr221383ljk.40.1569970937794;
 Tue, 01 Oct 2019 16:02:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAGXJAmwQw1ohc48NfAvMyNDpDgHGkdVO89Jo8B0j0TuMr7wLpA@mail.gmail.com>
 <CAGXJAmz5izfnamHA3Y_hU-AT1CX5K2MN=6BPjRXXcTCWvPeWng@mail.gmail.com>
 <01ac3ff4-4c06-7a6c-13fc-29ca9ed3ad88@gmail.com> <CAGXJAmxmJ-Vm379N4nbjXeQCAgY9ur53wmr0HZy23dQ_t++r-Q@mail.gmail.com>
 <f4520c32-3133-fb3b-034e-d492d40eb066@gmail.com> <CAGXJAmygtKtt18nKV6qRCKXfO93DoK4C2Gv_RaMuahsZG3TS6A@mail.gmail.com>
 <c5886aed-8448-fe62-b2a3-4ae8fe23e2a6@gmail.com> <CAGXJAmzHvKzKb1wzxtZK_KCu-pEQghznM4qmfzYmWeWR1CaJ7Q@mail.gmail.com>
 <47fef079-635d-483e-b530-943b2a55fc22@gmail.com> <CAGXJAmy7PTZOcwRz-mSiZJkEL4sJKWhkE8kisUZp8M=V1BBA3g@mail.gmail.com>
 <f572890a-ca31-e01a-e370-c8b3e3b51f5b@gmail.com>
In-Reply-To: <f572890a-ca31-e01a-e370-c8b3e3b51f5b@gmail.com>
From:   John Ousterhout <ouster@cs.stanford.edu>
Date:   Tue, 1 Oct 2019 16:01:41 -0700
X-Gmail-Original-Message-ID: <CAGXJAmyKLQR9Oa9KGPQ9cwYb2sYn-ZAcQa_fVdcunZtKpPRYjg@mail.gmail.com>
Message-ID: <CAGXJAmyKLQR9Oa9KGPQ9cwYb2sYn-ZAcQa_fVdcunZtKpPRYjg@mail.gmail.com>
Subject: Re: BUG: sk_backlog.len can overestimate
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Score: -1.0
X-Spam-Level: 
X-Spam-Checker-Version: SpamAssassin on smtp1.cs.Stanford.EDU
X-Scan-Signature: a11a15d02c0ec4233875b3872b0caebb
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 1:53 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> On 10/1/19 1:45 PM, John Ousterhout wrote:
>
> >
> > But this isn't really about socket resource limits (though that is
> > conflated in the implementation); it's about limiting the time spent
> > in a single call to __release_sock, no?
>
> The proxy used is memory usage, not time usage.

I apologize for being pedantic, but the proxy isn't memory usage; it's
actually "number of bytes added to the backlog since the last time it
was emptied". At the time the limit is hit, actual memory usage is
probably a lot less than the limit. This was the source of my
confusion, since I assumed you really *wanted* memory usage to be the
limit.


> cond_resched() or a preemptible kernel makes anything based on time flaky,
> you probably do not want to play with a time limit...
>
>
>
