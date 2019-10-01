Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67184C3967
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 17:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389335AbfJAPrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 11:47:11 -0400
Received: from smtp3.cs.stanford.edu ([171.64.64.27]:43490 "EHLO
        smtp3.cs.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbfJAPrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 11:47:11 -0400
Received: from mail-lf1-f51.google.com ([209.85.167.51]:40864)
        by smtp3.cs.Stanford.EDU with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <ouster@cs.stanford.edu>)
        id 1iFKMm-0008Ef-RP
        for netdev@vger.kernel.org; Tue, 01 Oct 2019 08:47:10 -0700
Received: by mail-lf1-f51.google.com with SMTP id d17so10286415lfa.7
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 08:47:08 -0700 (PDT)
X-Gm-Message-State: APjAAAV/IWavtL03Uq1qkOAJqfJ6X6gL9j1UcpNUx5PgXZjmwo+fQmeQ
        HDVGr7uSwnk0KJq+RQiA0imPmMLdVFH04DMi/6k=
X-Google-Smtp-Source: APXvYqyR4pAxDssE8Twg2Uw4tfAL7zG5e2aQvzGcn1FoCtGPT9IMptaQn3lDHbalpZtZbxtIOi7jduSrJwcsLgbi3wE=
X-Received: by 2002:ac2:5148:: with SMTP id q8mr14632889lfd.84.1569944827787;
 Tue, 01 Oct 2019 08:47:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAGXJAmwQw1ohc48NfAvMyNDpDgHGkdVO89Jo8B0j0TuMr7wLpA@mail.gmail.com>
 <CAGXJAmz5izfnamHA3Y_hU-AT1CX5K2MN=6BPjRXXcTCWvPeWng@mail.gmail.com>
 <01ac3ff4-4c06-7a6c-13fc-29ca9ed3ad88@gmail.com> <CAGXJAmxmJ-Vm379N4nbjXeQCAgY9ur53wmr0HZy23dQ_t++r-Q@mail.gmail.com>
 <f4520c32-3133-fb3b-034e-d492d40eb066@gmail.com>
In-Reply-To: <f4520c32-3133-fb3b-034e-d492d40eb066@gmail.com>
From:   John Ousterhout <ouster@cs.stanford.edu>
Date:   Tue, 1 Oct 2019 08:46:31 -0700
X-Gmail-Original-Message-ID: <CAGXJAmz5aDcEv_t18uqPHpBK6sJaZaN-_NyfPJcyPGMCm63rsw@mail.gmail.com>
Message-ID: <CAGXJAmz5aDcEv_t18uqPHpBK6sJaZaN-_NyfPJcyPGMCm63rsw@mail.gmail.com>
Subject: Fwd: BUG: sk_backlog.len can overestimate
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Score: -1.0
X-Spam-Level: 
X-Spam-Checker-Version: SpamAssassin on smtp3.cs.Stanford.EDU
X-Scan-Signature: 2ecb59bd28923317bd193fe54b7794cd
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(I accidentally dropped netdev on my earlier message... here is Eric's
response, which also didn't go to the group)

---------- Forwarded message ---------
From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, Sep 30, 2019 at 6:53 PM
Subject: Re: BUG: sk_backlog.len can overestimate
To: John Ousterhout <ouster@cs.stanford.edu>

On 9/30/19 5:41 PM, John Ousterhout wrote:
> On Mon, Sep 30, 2019 at 5:14 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 9/30/19 4:58 PM, John Ousterhout wrote:
>>> As of 4.16.10, it appears to me that sk->sk_backlog_len does not
>>> provide an accurate estimate of backlog length; this reduces the
>>> usefulness of the "limit" argument to sk_add_backlog.
>>>
>>> The problem is that, under heavy load, sk->sk_backlog_len can grow
>>> arbitrarily large, even though the actual amount of data in the
>>> backlog is small. This happens because __release_sock doesn't reset
>>> the backlog length until it gets completely caught up. Under heavy
>>> load, new packets can be arriving continuously  into the backlog
>>> (which increases sk_backlog.len) while other packets are being
>>> serviced. This can go on forever, so sk_backlog.len never gets reset
>>> and it can become arbitrarily large.
>>
>> Certainly not.
>>
>> It can not grow arbitrarily large, unless a backport gone wrong maybe.
>
> Can you help me understand what would limit the growth of this value?
> Suppose that new packets are arriving as quickly as they are
> processed. Every time __release_sock calls sk_backlog_rcv, a new
> packet arrives during the call, which is added to the backlog,
> incrementing sk_backlog.len. However, sk_backlog_len doesn't get
> decreased when sk_backlog_rcv completes, since the backlog hasn't
> emptied (as you said, it's not "safe"). As a result, sk_backlog.len
> has increased, but the actual backlog length is unchanged (one packet
> was added, one was removed). Why can't this process repeat
> indefinitely, until eventually sk_backlog.len reaches whatever limit
> the transport specifies when it invokes sk_add_backlog? At this point
> packets will be dropped by the transport even though the backlog isn't
> actually very large.

The process is bounded by socket sk_rcvbuf + sk_sndbuf

bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
{
        u32 limit = sk->sk_rcvbuf + sk->sk_sndbuf;

        ...
        if (unlikely(sk_add_backlog(sk, skb, limit))) {
            ...
            __NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPBACKLOGDROP);
        ...
}


Once the limit is reached, sk_backlog.len wont be touched, unless
__release_sock()
has processed the whole queue.


>
>>>
>>> Because of this, the "limit" argument to sk_add_backlog may not be
>>> useful, since it could result in packets being discarded even though
>>> the backlog is not very large.
>>>
>>
>>
>> You will have to study git log/history for the details, the limit _is_ useful,
>> and we reset the limit in __release_sock() only when _safe_.
>>
>> Assuming you talk about TCP, then I suggest you use a more recent kernel.
>>
>> linux-5.0 got coalescing in the backlog queue, which helped quite a bit.
