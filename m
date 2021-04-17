Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE25362E4A
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 09:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhDQH2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 03:28:30 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:51799 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhDQH2a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 03:28:30 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 13H7RiqZ014175;
        Sat, 17 Apr 2021 09:27:44 +0200
Date:   Sat, 17 Apr 2021 09:27:44 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@gmail.com>, Florian Westphal <fw@strlen.de>,
        Keyu Man <kman001@ucr.edu>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhiyun Qian <zhiyunq@cs.ucr.edu>
Subject: Re: PROBLEM: DoS Attack on Fragment Cache
Message-ID: <20210417072744.GB14109@1wt.eu>
References: <02917697-4CE2-4BBE-BF47-31F58BC89025@hxcore.ol>
 <52098fa9-2feb-08ae-c24f-1e696076c3b9@gmail.com>
 <CANn89iL_V0WbeA-Zr29cLSp9pCsthkX9ze4W46gx=8-UeK2qMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iL_V0WbeA-Zr29cLSp9pCsthkX9ze4W46gx=8-UeK2qMg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 06:44:40AM +0200, Eric Dumazet wrote:
> On Sat, Apr 17, 2021 at 2:31 AM David Ahern <dsahern@gmail.com> wrote:
> >
> > [ cc author of 648700f76b03b7e8149d13cc2bdb3355035258a9 ]
> 
> I think this has been discussed already. There is no strategy that
> makes IP reassembly units immune to DDOS attacks.

For having tried to deal with this in the past as well, I agree with
this conclusion, which is also another good example of why fragments
should really be avoided as much as possible over hostile networks.

However I also found that random drops of previous entries is the
approach which seems to offer the most statistical opportunities to
legitimate traffic to still work under attack (albeit really poorly
considering that any lost fragment requires retransmission of the
whole series). In this case the chance for a packet to be successfully
reassembled would vary proportionally to the inverse of its number of
fragments, which reasonably limits the impact of attacks (without being
an ultimate solution of course).

> We added rb-tree and sysctls to let admins choose to use GB of RAM if
> they really care.

I agree that for those who care, the real solution is to make sure they
can store all the traffic they receive during a reassembly period.
Legitimate traffic mostly reassembles quickly so keeping 1 second of
traffic at 10 Gbps is only 1.25 GB of RAM after all...

Willy
