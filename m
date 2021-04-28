Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8935236D957
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 16:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240186AbhD1OOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 10:14:41 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:52686 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229961AbhD1OOl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 10:14:41 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 13SEDJpk007931;
        Wed, 28 Apr 2021 16:13:19 +0200
Date:   Wed, 28 Apr 2021 16:13:19 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Matt Corallo <netdev-list@mattcorallo.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Keyu Man <kman001@ucr.edu>
Subject: Re: [PATCH net-next] Reduce IP_FRAG_TIME fragment-reassembly timeout
 to 1s, from 30s
Message-ID: <20210428141319.GA7645@1wt.eu>
References: <d840ddcf-07a6-a838-abf8-b1d85446138e@bluematt.me>
 <CANn89i+L2DuD2+EMHzwZ=qYYKo1A9gw=nTTmh20GV_o9ADxe2Q@mail.gmail.com>
 <0cb19f7e-a9b3-58f8-6119-0736010f1326@bluematt.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cb19f7e-a9b3-58f8-6119-0736010f1326@bluematt.me>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 10:09:00AM -0400, Matt Corallo wrote:
> 
> 
> On 4/28/21 08:20, Eric Dumazet wrote:
> > This is going to break many use cases.
> > 
> > I can certainly say that in many cases, we need more than 1 second to
> > complete reassembly.
> > Some Internet users share satellite links with 600 ms RTT, not
> > everybody has fiber links in 2021.
> 
> I'm curious what RTT has to do with it? Frags aren't resent, so there's no
> RTT you need to wait for, the question is more your available bandwidth and
> how much packet reordering you see, which even for many sat links isn't zero
> anymore (better, in-flow packet reordering is becoming more and more rare!).

Regardless of retransmits, large RTTs are often an indication of buffer bloat
on the path, and this can take some fragments apart, even worse when you mix
this with multi-path routing where some fragments may take a short path and
others can take a congested one. In this case you'll note that the excessive
buffer time can become a non-negligible part of the observed RTT, hence the
indirect relation between the two.

Willy
