Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853E71DA145
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgESTro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:47:44 -0400
Received: from ja.ssi.bg ([178.16.129.10]:54114 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726348AbgESTrn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 15:47:43 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 04JJkPnn004615;
        Tue, 19 May 2020 22:46:25 +0300
Date:   Tue, 19 May 2020 22:46:25 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Marco Angaroni <marcoangaroni@gmail.com>
cc:     Andrew Kim <kim.andrewsy@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "open list:IPVS" <netdev@vger.kernel.org>,
        "open list:IPVS" <lvs-devel@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>
Subject: Re: [PATCH] netfilter/ipvs: immediately expire UDP connections
 matching unavailable destination if expire_nodest_conn=1
In-Reply-To: <CANHHuCW6i0BjLRMYkfY8eZGZJZTnE-NO9EH+-gfH94cc6yYn1A@mail.gmail.com>
Message-ID: <alpine.LFD.2.21.2005192139500.3504@ja.home.ssi.bg>
References: <20200515013556.5582-1-kim.andrewsy@gmail.com> <20200517171654.8194-1-kim.andrewsy@gmail.com> <alpine.LFD.2.21.2005182027460.4524@ja.home.ssi.bg> <CABc050G-yW-frv0mCmg=hMnC4iOx9Ht2Zv8eoS1cxQ8uKX6NQw@mail.gmail.com>
 <CANHHuCW6i0BjLRMYkfY8eZGZJZTnE-NO9EH+-gfH94cc6yYn1A@mail.gmail.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811672-1121648160-1589917585=:3504"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-1121648160-1589917585=:3504
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

On Tue, 19 May 2020, Marco Angaroni wrote:

> Hi Andrew, Julian,
> 
> could you please confirm if/how this patch is changing any of the
> following behaviours, which I’m listing below as per my understanding
> ?
> 
> When expire_nodest is set and real-server is unavailable, at the
> moment the following happens to a packet going through IPVS:
> 
> a) TCP (or other connection-oriented protocols):
>    the packet is silently dropped, then the following retransmission
> causes the generation of a RST from the load-balancer to the client,
> which will then re-open a new TCP connection

	Yes. It seems we can not create new connection in
all cases, we should also check with is_new_conn().

	What we have is that two cases are possible depending on 
conn_reuse_mode, the state of existing connection and whether
netfilter conntrack is used:

	1. setup expire for old conn, then drop packet
	2. setup expire for old conn, then create new
	conn to schedule the packet

	When expiration is set, the timer will fire in the
next jiffie to remove the connection from hash table. Until
removed, the connection still can cause drops. Sometimes
we can simply create new connection with the same tuple,
so it is possible both connections to coexist for one jiffie
but the old connection is not reached on lookup.

> b) UDP:
>    the packet is silently dropped, then the following retransmission
> is rescheduled to a new real-server

	Yes, we drop while old conn is not expired yet

> c) UDP in OPS mode:
>    the packet is rescheduled to a new real-server, as no previous
> connection exists in IPVS connection table, and a new OPS connection
> is created (but it lasts only the time to transmit the packet)

	Yes, OPS is not affected.

> d) UDP in OPS mode + persistent-template:
>    the packet is rescheduled to a new real-server, as previous
> template-connection is invalidated, a new template-connection is
> created, and a new OPS connection is created (but it lasts only the
> time to transmit the packet)

	Yes, the existing template is ignored when its server
is unavailable.

> It seems to me that you are trying to optimize case a) and b),
> avoiding the first step where the packet is silently dropped and
> consequently avoiding the retransmission.
> And contextually expire also all the other connections pointing to the
> unavailable real-sever.

	The change will allow immediate scheduling in a new
connection for any protocol when netfilter conntrack is not
used:

- TCP: avoids retransmission for SYN
- UDP: reduces drops from 1 jiffie to 0 (no drops)

	But this single jiffie compared to the delay between
real server failure and the removal from the IPVS table can be
negligible. Of course, if real server is removed while it is
working, with this change we should not see any UDP drops.

> However I'm confused about the references to OPS mode.
> And why you need to expire all the connections at once: if you expire
> on a per connection basis, the client experiences the same behaviour
> (no more re-transmissions), but you avoid the complexities of a new
> thread.

	Such flushing can help when conntrack is used in which
case the cost is a retransmission or downtime for one jiffie.

> Maybe also the documentation of expire_nodest_conn sysctl should be updated.
> When it's stated:
> 
>         If this feature is enabled, the load balancer will expire the
>         connection immediately when a packet arrives and its
>         destination server is not available, then the client program
>         will be notified that the connection is closed
> 
> I think it should be at least "and the client program" instead of
> "then the client program".
> Or a more detailed explanation.

	Yes, if the packet is SYN we can create new connection.
If it is ACK, the retransmission will get RST.

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-1121648160-1589917585=:3504--
