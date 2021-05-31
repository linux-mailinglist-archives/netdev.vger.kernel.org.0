Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CD7395996
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 13:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbhEaLWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 07:22:20 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:55441 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230521AbhEaLWR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 07:22:17 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 14VBJfc3009627;
        Mon, 31 May 2021 13:19:41 +0200
Date:   Mon, 31 May 2021 13:19:40 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] ipv6: use prandom_u32() for ID generation
Message-ID: <20210531111940.GA9609@1wt.eu>
References: <20210529110746.6796-1-w@1wt.eu>
 <e4cc31c1fead46b3aa1132937a720da2@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4cc31c1fead46b3aa1132937a720da2@AcuMS.aculab.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 10:41:18AM +0000, David Laight wrote:
> The problem is that, on average, 1 in 2^32 packets will use
> the same id as the previous one.
> If a fragment of such a pair gets lost horrid things are
> likely to happen.
> Note that this is different from an ID being reused after a
> count of packets or after a time delay.

I'm well aware of this, as this is something we discussed already
for IPv4 and which I objected to for the same reason (except that
it's 1/2^16 there).

With that said, the differences with IPv4 are significant here,
because you won't fragment below 1280 bytes per packet, which
means the issue could happen every 5 terabytes of fragmented
losses (or reorders). I'd say that in the worst case you're
using load-balanced links with some funny LB algorithm that
ensures that every second fragment is sent on the same link
as the previous packet's first fragment. This is the case where
you could provoke a failure every 5 TB. But then you're still
subject to UDP's 16-bit checksumm so in practice you're seeing
a failure every 320 PB. Finally it's the same probability as
getting both TCP csum + Ethernet CRC correct on a failure,
except that here it applies only to large fragments while with
TCP/eth it applies to any packet.

> So you still need something to ensure IDs aren't reused immediately.

That's what I initially did for IPv4 but Amit could exploit this
specific property. For example it makes it easier to count flows
behind NAT when there is a guaranteed distance :-/  We even tried
with a smooth, non-linear distribution, but that made no difference,
it remained observable.

Another idea we had in mind was to keep small increments for local
networks and use full randoms only over routers (since fragments
are rare and terribly unreliable on the net), but that would involve
quite significant changes for very little benefit compared to the
current option in the end.

Regards,
Willy
