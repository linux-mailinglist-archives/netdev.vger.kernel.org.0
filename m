Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40AFB17D4E8
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 17:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgCHQqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 12:46:09 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:58913 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgCHQqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 12:46:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1583685968; x=1615221968;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Vn43g9rma5I34YiDbCIt+z0qLpr+Zq7r8JoSHYiYKkY=;
  b=f8PNucQwHdgovrj8uxNa5RAg1NuxFjBcqZxPBjkSDJ+oaLyilTQ5Bukr
   Ujgb/FbbhEccQQ3ZJ58gK75SWneVFrRxpGThGru7EFRi+8otik96/dcdJ
   sPkFKjyigNdis8i+cRHYqbGkC/AbK7/5/u6RiPFc5L0rsZ013nL+0Vxmm
   8=;
IronPort-SDR: OF/lcTpablzlksr6UD1n+7fRziOHwI3u7l3YZnp0ztol6DbX+gP4F7s79NZXDI9+FoNamzJ5XU
 5hGQGcvr7UQQ==
X-IronPort-AV: E=Sophos;i="5.70,530,1574121600"; 
   d="scan'208";a="20268855"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 08 Mar 2020 16:46:06 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id D7B1CA1E13;
        Sun,  8 Mar 2020 16:46:04 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 8 Mar 2020 16:46:04 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.18) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 8 Mar 2020 16:46:00 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <eric.dumazet@gmail.com>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <kuznet@ms2.inr.ac.ru>, <netdev@vger.kernel.org>,
        <osa-contribution-log@amazon.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v3 net-next 2/4] tcp: bind(addr, 0) remove the SO_REUSEADDR restriction when ephemeral ports are exhausted.
Date:   Mon, 9 Mar 2020 01:45:56 +0900
Message-ID: <20200308164556.62453-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <CANn89iJeTzzO_Z81yaWYg+8TAqWe75Y=A4u5aN6xMYMxQ1ME-w@mail.gmail.com>
References: <CANn89iJeTzzO_Z81yaWYg+8TAqWe75Y=A4u5aN6xMYMxQ1ME-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.18]
X-ClientProxiedBy: EX13D30UWB003.ant.amazon.com (10.43.161.83) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 3 Mar 2020 10:16:56 -0800
> On Tue, Mar 3, 2020 at 9:53 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> > From:   Eric Dumazet <eric.dumazet@gmail.com>
> > Date:   Sun, 1 Mar 2020 20:49:49 -0800
> > > On 3/1/20 8:31 PM, Kuniyuki Iwashima wrote:
> > >> From:   Eric Dumazet <eric.dumazet@gmail.com>
> > >> Date:   Sun, 1 Mar 2020 19:42:25 -0800
> > >>> On 2/29/20 3:35 AM, Kuniyuki Iwashima wrote:
> > >>>> Commit aacd9289af8b82f5fb01bcdd53d0e3406d1333c7 ("tcp: bind() use stronger
> > >>>> condition for bind_conflict") introduced a restriction to forbid to bind
> > >>>> SO_REUSEADDR enabled sockets to the same (addr, port) tuple in order to
> > >>>> assign ports dispersedly so that we can connect to the same remote host.
> > >>>>
> > >>>> The change results in accelerating port depletion so that we fail to bind
> > >>>> sockets to the same local port even if we want to connect to the different
> > >>>> remote hosts.
> > >>>>
> > >>>> You can reproduce this issue by following instructions below.
> > >>>>   1. # sysctl -w net.ipv4.ip_local_port_range="32768 32768"
> > >>>>   2. set SO_REUSEADDR to two sockets.
> > >>>>   3. bind two sockets to (address, 0) and the latter fails.
> > >>>>
> > >>>> Therefore, when ephemeral ports are exhausted, bind(addr, 0) should
> > >>>> fallback to the legacy behaviour to enable the SO_REUSEADDR option and make
> > >>>> it possible to connect to different remote (addr, port) tuples.
> > >>>>
> > >>>> This patch allows us to bind SO_REUSEADDR enabled sockets to the same
> > >>>> (addr, port) only when all ephemeral ports are exhausted.
> > >>>>
> > >>>> The only notable thing is that if all sockets bound to the same port have
> > >>>> both SO_REUSEADDR and SO_REUSEPORT enabled, we can bind sockets to an
> > >>>> ephemeral port and also do listen().
> > >>>>
> > >>>> Fixes: aacd9289af8b ("tcp: bind() use stronger condition for bind_conflict")
> > >>>>
> > >>>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > >>>
> > >>> I am unsure about this, since this could double the time taken by this
> > >>> function, which is already very time consuming.
> > >>
> > >> This patch doubles the time on choosing a port only when all ephemeral ports
> > >> are exhausted, and this fallback behaviour can eventually decreases the time
> > >> on waiting for ports to be released. We cannot know when the ports are
> > >> released, so we may not be able to reuse ports without this patch. This
> > >> patch gives more chace and raises the probability to succeed to bind().
> > >>
> > >>> We added years ago IP_BIND_ADDRESS_NO_PORT socket option, so that the kernel
> > >>> has more choices at connect() time (instead of bind()) time to choose a source port.
> > >>>
> > >>> This considerably lowers time taken to find an optimal source port, since
> > >>> the kernel has full information (source address, destination address & port)
> > >>
> > >> I also think this option is usefull, but it does not allow us to reuse
> > >> ports that is reserved by bind(). This is because connect() can reuse ports
> > >> only when their tb->fastresue and tb->fastreuseport is -1. So we still
> > >> cannot fully utilize 4-tuples.
> > >
> > > The thing is : We do not want to allow active connections to use a source port
> > > that is used for passive connections.
> >
> > When calling bind(addr, 0) without these patches, this problem does not
> > occur. Certainly these patches could make it possible to do bind(addr, 0)
> > and listen() on the port which is already reserved by connect(). However,
> > whether these patches are applied or not, this problem can be occurred by
> > calling bind with specifying the port.
> >
> >
> > > Many supervisions use dump commands like "ss -t src :40000" to list all connections
> > > for a 'server' listening on port 40000,
> > > or use ethtool to direct all traffic for this port on a particular RSS queue.
> > >
> > > Some firewall setups also would need to be changed, since suddenly the port could
> > > be used by unrelated applications.
> >
> > I think these are on promise that the server application specifies the port
> > and we know which port is used in advance. Moreover the port nerver be used
> > by unrelated application suddenly. When connect() and listen() share the
> > port, listen() is always called after connect().
> >
> >
> > I would like to think about two sockets (sk1 and sk2) in three cases.
> >
> > 1st case: sk1 is in TCP_LISTEN.
> > In this case, sk2 cannot get the port and my patches does not change the behaviour.
> 
> Before being in TCP_LISTEN, it had to bind() on a sport.
> 
> Then _after_ reserving an exclusive sport, it can install whatever tc
> / iptables rule to implement additional security.
> 
> Before calling listen(), you do not want another socket being able to
> use the same sport.
> 
> There is no atomic bind()+listen()  or bind()+install_firewalling_rules+listen()
> 
> This is why after bind(), the kernel has to guarantee the chosen sport
> wont be used by other sockets.
> 
> Breaking this rule has a lot of implications.

I agree with this, but the current kernel can break the rule in the 2nd case,
and it rarely happens.


> > 2nd case: sk1 is in TCP_ESTABLISHED and call bind(addr, 40000) for sk2.
> > In this case, sk2 can get the port by specifying the port, so listen() of
> > sk2 can share the port with connect() of sk1. This is because reuseport_ok
> > is true, but my patches add changes only for when reuseport_ok is false.
> > Therefore, whether my patches are applied or not, this problem can happen.
> >
> > 3rd case: sk1 is in TCP_ESTABLISHED and call bind(addr, 0) for sk2.
> > In this case, sk2 come to be able to get the port with my patches if both
> > sockets have SO_REUSEADDR enabled.
> > So, listen() also can share the port with connect().
> >
> > However, I do not think this can be problem for two reasons:
> >   - the same problem already can happen in 2nd case, and the possibility of
> >     this case is lower than 2nd case because 3rd case is when the ports are exhausted.
> >   - I am unsure that there is supervisions that monitor the server
> >     applications which randomly select the ephemeral ports to listen on.
> >
> > Although this may be a stupid question, is there famous server software
> > that do bind(addr, 0) and listen() ?
> 
> I do not know, there are thousands of solutions using TCP, I can not
> make sure they won't break.
> It would take years to verify this.

I am sorry, I also cannot guarantee that these patches do not always break
the rule, so I should not have changed the current behaviour. I think this
should be verified by each user and we should give the chance to do it.


> > Hence, I think these patches are safe.
> 
> They are not.

I wanted to say that these patches are as (un)safe as the latest kernel.
Certainly they are not always safe. However if there are no such
applications, these patches can be safe and useful.

I will respin these again with a sysctl option in order to switch the
autobind behaviour.

Thank you.
