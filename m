Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26EEAC3962
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 17:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389639AbfJAPpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 11:45:11 -0400
Received: from smtp3.cs.stanford.edu ([171.64.64.27]:42296 "EHLO
        smtp3.cs.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbfJAPpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 11:45:11 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:43404)
        by smtp3.cs.Stanford.EDU with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <ouster@cs.stanford.edu>)
        id 1iFKKs-0007uK-3e
        for netdev@vger.kernel.org; Tue, 01 Oct 2019 08:45:10 -0700
Received: by mail-lj1-f177.google.com with SMTP id n14so13872058ljj.10
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 08:45:10 -0700 (PDT)
X-Gm-Message-State: APjAAAVjHTJQOdMCk9BoCIc0+ssxlouhbyJW/H950524tiW89H8zvLov
        mro9qRWSiedgcuVFSOt4REX9iM6ORH8dMkeTuFE=
X-Google-Smtp-Source: APXvYqws9wVV88Acuut4Q2E2fjVV4eTOu57/Z+cSdcPo/WMYYIWE97HvrE/Js12COGPvrazWzIeOIRHQLPN7DAs8RYs=
X-Received: by 2002:a2e:b1ce:: with SMTP id e14mr17131692lja.135.1569944709055;
 Tue, 01 Oct 2019 08:45:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAGXJAmwQw1ohc48NfAvMyNDpDgHGkdVO89Jo8B0j0TuMr7wLpA@mail.gmail.com>
 <CAGXJAmz5izfnamHA3Y_hU-AT1CX5K2MN=6BPjRXXcTCWvPeWng@mail.gmail.com> <01ac3ff4-4c06-7a6c-13fc-29ca9ed3ad88@gmail.com>
In-Reply-To: <01ac3ff4-4c06-7a6c-13fc-29ca9ed3ad88@gmail.com>
From:   John Ousterhout <ouster@cs.stanford.edu>
Date:   Tue, 1 Oct 2019 08:44:32 -0700
X-Gmail-Original-Message-ID: <CAGXJAmxfSw3jN6fYae4MeOcgrSMODrBeGF91AsNWWJX1V-ftrw@mail.gmail.com>
Message-ID: <CAGXJAmxfSw3jN6fYae4MeOcgrSMODrBeGF91AsNWWJX1V-ftrw@mail.gmail.com>
Subject: Re: BUG: sk_backlog.len can overestimate
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Score: -1.0
X-Spam-Level: 
X-Spam-Checker-Version: SpamAssassin on smtp3.cs.Stanford.EDU
X-Scan-Signature: ae35470b07fbe4e2dbb6b33d1de23969
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 5:14 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> On 9/30/19 4:58 PM, John Ousterhout wrote:
> > As of 4.16.10, it appears to me that sk->sk_backlog_len does not
> > provide an accurate estimate of backlog length; this reduces the
> > usefulness of the "limit" argument to sk_add_backlog.
> >
> > The problem is that, under heavy load, sk->sk_backlog_len can grow
> > arbitrarily large, even though the actual amount of data in the
> > backlog is small. This happens because __release_sock doesn't reset
> > the backlog length until it gets completely caught up. Under heavy
> > load, new packets can be arriving continuously  into the backlog
> > (which increases sk_backlog.len) while other packets are being
> > serviced. This can go on forever, so sk_backlog.len never gets reset
> > and it can become arbitrarily large.
>
> Certainly not.
>
> It can not grow arbitrarily large, unless a backport gone wrong maybe.

Can you help me understand what would limit the growth of this value?
Suppose that new packets are arriving as quickly as they are
processed. Every time __release_sock calls sk_backlog_rcv, a new
packet arrives during the call, which is added to the backlog,
incrementing sk_backlog.len. However, sk_backlog_len doesn't get
decreased when sk_backlog_rcv completes, since the backlog hasn't
emptied (as you said, it's not "safe"). As a result, sk_backlog.len
has increased, but the actual backlog length is unchanged (one packet
was added, one was removed). Why can't this process repeat
indefinitely, until eventually sk_backlog.len reaches whatever limit
the transport specifies when it invokes sk_add_backlog? At this point
packets will be dropped by the transport even though the backlog isn't
actually very large.

> > Because of this, the "limit" argument to sk_add_backlog may not be
> > useful, since it could result in packets being discarded even though
> > the backlog is not very large.
> >
>
>
> You will have to study git log/history for the details, the limit _is_ useful,
> and we reset the limit in __release_sock() only when _safe_.
>
> Assuming you talk about TCP, then I suggest you use a more recent kernel.
>
> linux-5.0 got coalescing in the backlog queue, which helped quite a bit.
