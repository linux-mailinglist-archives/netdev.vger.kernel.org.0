Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC11C3977
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 17:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389730AbfJAPt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 11:49:28 -0400
Received: from smtp2.cs.stanford.edu ([171.64.64.26]:49652 "EHLO
        smtp2.cs.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbfJAPt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 11:49:28 -0400
Received: from mail-lj1-f169.google.com ([209.85.208.169]:36930)
        by smtp2.cs.Stanford.EDU with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <ouster@cs.stanford.edu>)
        id 1iFKP0-0000nY-Ly
        for netdev@vger.kernel.org; Tue, 01 Oct 2019 08:49:27 -0700
Received: by mail-lj1-f169.google.com with SMTP id l21so13936594lje.4
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 08:49:26 -0700 (PDT)
X-Gm-Message-State: APjAAAW0XmHO/HRdmWlo4xFT4qef1/p3NlCBJuQRd+FvrH2AtDTxxmtA
        kacle8D390+6X6CKB0cSpXepp/ggKmwc0YTdcFU=
X-Google-Smtp-Source: APXvYqwdWlQ22SugtPGCFPCnM+mAWw61t+K6hEdn+gOlyW8LFlw9ScvUr2pxUTLN3zghsIJulrn6HF430C+X7LrgNI4=
X-Received: by 2002:a2e:7d0d:: with SMTP id y13mr16515518ljc.170.1569944965591;
 Tue, 01 Oct 2019 08:49:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAGXJAmwQw1ohc48NfAvMyNDpDgHGkdVO89Jo8B0j0TuMr7wLpA@mail.gmail.com>
 <CAGXJAmz5izfnamHA3Y_hU-AT1CX5K2MN=6BPjRXXcTCWvPeWng@mail.gmail.com>
 <01ac3ff4-4c06-7a6c-13fc-29ca9ed3ad88@gmail.com> <CAGXJAmxmJ-Vm379N4nbjXeQCAgY9ur53wmr0HZy23dQ_t++r-Q@mail.gmail.com>
 <f4520c32-3133-fb3b-034e-d492d40eb066@gmail.com>
In-Reply-To: <f4520c32-3133-fb3b-034e-d492d40eb066@gmail.com>
From:   John Ousterhout <ouster@cs.stanford.edu>
Date:   Tue, 1 Oct 2019 08:48:49 -0700
X-Gmail-Original-Message-ID: <CAGXJAmygtKtt18nKV6qRCKXfO93DoK4C2Gv_RaMuahsZG3TS6A@mail.gmail.com>
Message-ID: <CAGXJAmygtKtt18nKV6qRCKXfO93DoK4C2Gv_RaMuahsZG3TS6A@mail.gmail.com>
Subject: Re: BUG: sk_backlog.len can overestimate
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Score: -1.0
X-Spam-Level: 
X-Spam-Checker-Version: SpamAssassin on smtp2.cs.Stanford.EDU
X-Scan-Signature: 1620fcb02ed1792cf65161168a9fe1e9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 6:53 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> On 9/30/19 5:41 PM, John Ousterhout wrote:
> > On Mon, Sep 30, 2019 at 5:14 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>
> >> On 9/30/19 4:58 PM, John Ousterhout wrote:
> >>> As of 4.16.10, it appears to me that sk->sk_backlog_len does not
> >>> provide an accurate estimate of backlog length; this reduces the
> >>> usefulness of the "limit" argument to sk_add_backlog.
> >>>
> >>> The problem is that, under heavy load, sk->sk_backlog_len can grow
> >>> arbitrarily large, even though the actual amount of data in the
> >>> backlog is small. This happens because __release_sock doesn't reset
> >>> the backlog length until it gets completely caught up. Under heavy
> >>> load, new packets can be arriving continuously  into the backlog
> >>> (which increases sk_backlog.len) while other packets are being
> >>> serviced. This can go on forever, so sk_backlog.len never gets reset
> >>> and it can become arbitrarily large.
> >>
> >> Certainly not.
> >>
> >> It can not grow arbitrarily large, unless a backport gone wrong maybe.
> >
> > Can you help me understand what would limit the growth of this value?
> > Suppose that new packets are arriving as quickly as they are
> > processed. Every time __release_sock calls sk_backlog_rcv, a new
> > packet arrives during the call, which is added to the backlog,
> > incrementing sk_backlog.len. However, sk_backlog_len doesn't get
> > decreased when sk_backlog_rcv completes, since the backlog hasn't
> > emptied (as you said, it's not "safe"). As a result, sk_backlog.len
> > has increased, but the actual backlog length is unchanged (one packet
> > was added, one was removed). Why can't this process repeat
> > indefinitely, until eventually sk_backlog.len reaches whatever limit
> > the transport specifies when it invokes sk_add_backlog? At this point
> > packets will be dropped by the transport even though the backlog isn't
> > actually very large.
>
> The process is bounded by socket sk_rcvbuf + sk_sndbuf
>
> bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
> {
>         u32 limit = sk->sk_rcvbuf + sk->sk_sndbuf;
>
>         ...
>         if (unlikely(sk_add_backlog(sk, skb, limit))) {
>             ...
>             __NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPBACKLOGDROP);
>         ...
> }
>
>
> Once the limit is reached, sk_backlog.len wont be touched, unless __release_sock()
> has processed the whole queue.

Sorry if I'm missing something obvious here, but when you say
"sk_backlog.len won't be touched", doesn't that mean that incoming
packets will have to be dropped? And can't this occur even though the
true size of the backlog might be way less than sk_rcvbuf + sk_sndbuf,
as I described above? It seems to me that the basic problem is that
sk_backlog.len could exceed any given limit, even though there aren't
actually that many bytes still left in the backlog.

> >>> Because of this, the "limit" argument to sk_add_backlog may not be
> >>> useful, since it could result in packets being discarded even though
> >>> the backlog is not very large.
> >>>
> >>
> >>
> >> You will have to study git log/history for the details, the limit _is_ useful,
> >> and we reset the limit in __release_sock() only when _safe_.
> >>
> >> Assuming you talk about TCP, then I suggest you use a more recent kernel.
> >>
> >> linux-5.0 got coalescing in the backlog queue, which helped quite a bit.
