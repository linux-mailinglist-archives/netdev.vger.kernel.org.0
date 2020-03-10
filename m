Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C12CF17F139
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 08:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgCJHmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 03:42:43 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:19733 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgCJHmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 03:42:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1583826162; x=1615362162;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=EaMhV5jCwIi2qPvI0+mmha5aUD4NPpUCCafk13slFNs=;
  b=kZDqNydlpY+f50+ao7t5AlzrPA6TLv84UEwhmwvHNkleDFw9br8NecaU
   QEx8aPDNCMfkvUND0B+0ku2rdfxQHuUC8ev2I4TmY0lHkMetE06ZXw4e2
   H1K7uW1LZma1a+6ucsBpROviVvDb5rQP5e2PGCOoh2hF7N3Pfh9zIDJLB
   A=;
IronPort-SDR: 78X41/lB3bYnxQV9Kt8POW5W8aqqHccegyJPZK8CKEGPPoNbRXzEvCyo1qyOq+gf3fT94oCOxz
 J45Y7gvCQ4iw==
X-IronPort-AV: E=Sophos;i="5.70,535,1574121600"; 
   d="scan'208";a="31657066"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 10 Mar 2020 07:42:41 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id A3439A246E;
        Tue, 10 Mar 2020 07:42:40 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 10 Mar 2020 07:42:40 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.161.152) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 10 Mar 2020 07:42:35 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <eric.dumazet@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <kuznet@ms2.inr.ac.ru>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v4 net-next 4/5] net: Add net.ipv4.ip_autobind_reuse option.
Date:   Tue, 10 Mar 2020 16:42:32 +0900
Message-ID: <20200310074232.68275-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <50c321f8-1563-2b7a-4b14-f71f48858bfd@gmail.com>
References: <50c321f8-1563-2b7a-4b14-f71f48858bfd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.152]
X-ClientProxiedBy: EX13D13UWA004.ant.amazon.com (10.43.160.251) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Mon, 9 Mar 2020 21:05:24 -0700
> On 3/8/20 11:16 AM, Kuniyuki Iwashima wrote:
> > The two commits("tcp: bind(addr, 0) remove the SO_REUSEADDR restriction
> > when ephemeral ports are exhausted" and "tcp: Forbid to automatically bind
> > more than one sockets haveing SO_REUSEADDR and SO_REUSEPORT per EUID")
> > introduced the new feature to reuse ports with SO_REUSEADDR when all
> > ephemeral pors are exhausted. They allow connect() and listen() to share
> > ports in the following way.
> > 
> >   1. setsockopt(sk1, SO_REUSEADDR)
> >   2. setsockopt(sk2, SO_REUSEADDR)
> >   3. bind(sk1, saddr, 0)
> >   4. bind(sk2, saddr, 0)
> >   5. connect(sk1, daddr)
> >   6. listen(sk2)
> 
> Honestly, IP_BIND_ADDRESS_NO_PORT makes all these problems go away.
> 
> 
> >
> > In this situation, new socket cannot be bound to the port, but sharing
> > port between connect() and listen() may break some applications. The
> > ip_autobind_reuse option is false (0) by default and disables the feature.
> > If it is set true, we can fully utilize the 4-tuples.
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > ---
> >  Documentation/networking/ip-sysctl.txt | 7 +++++++
> >  include/net/netns/ipv4.h               | 1 +
> >  net/ipv4/inet_connection_sock.c        | 2 +-
> >  net/ipv4/sysctl_net_ipv4.c             | 7 +++++++
> >  4 files changed, 16 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> > index 5f53faff4e25..9506a67a33c4 100644
> > --- a/Documentation/networking/ip-sysctl.txt
> > +++ b/Documentation/networking/ip-sysctl.txt
> > @@ -958,6 +958,13 @@ ip_nonlocal_bind - BOOLEAN
> >  	which can be quite useful - but may break some applications.
> >  	Default: 0
> >  
> > +ip_autobind_reuse - BOOLEAN
> > +	By default, bind() does not select the ports automatically even if
> > +	the new socket and all sockets bound to the port have SO_REUSEADDR.
> > +	ip_autobind_reuse allows bind() to reuse the port and this is useful
> > +	when you use bind()+connect(), but may break some applications.
> 
> I would mention that the preferred solution is to use IP_BIND_ADDRESS_NO_PORT,
> which is fully supported, and that this sysctl should only be set by experts.

I will add these to description.


> > +	Default: 0
> > +
> >  ip_dynaddr - BOOLEAN
> >  	If set non-zero, enables support for dynamic addresses.
> >  	If set to a non-zero value larger than 1, a kernel log
> > diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> > index 08b98414d94e..154b8f01499b 100644
> > --- a/include/net/netns/ipv4.h
> > +++ b/include/net/netns/ipv4.h
> > @@ -101,6 +101,7 @@ struct netns_ipv4 {
> >  	int sysctl_ip_fwd_use_pmtu;
> >  	int sysctl_ip_fwd_update_priority;
> >  	int sysctl_ip_nonlocal_bind;
> > +	int sysctl_ip_autobind_reuse;
> >  	/* Shall we try to damage output packets if routing dev changes? */
> >  	int sysctl_ip_dynaddr;
> >  	int sysctl_ip_early_demux;
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index d27ed5fe7147..3b4f81790e3e 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -246,7 +246,7 @@ inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret, int *
> >  		goto other_half_scan;
> >  	}
> >  
> > -	if (!relax) {
> > +	if (net->ipv4.sysctl_ip_autobind_reuse && !relax) {
> >  		/* We still have a chance to connect to different destinations */
> >  		relax = true;
> >  		goto ports_exhausted;
> > diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> > index 9684af02e0a5..3b191764718b 100644
> > --- a/net/ipv4/sysctl_net_ipv4.c
> > +++ b/net/ipv4/sysctl_net_ipv4.c
> > @@ -775,6 +775,13 @@ static struct ctl_table ipv4_net_table[] = {
> >  		.mode		= 0644,
> >  		.proc_handler	= proc_dointvec
> >  	},
> > +	{
> > +		.procname	= "ip_autobind_reuse",
> > +		.data		= &init_net.ipv4.sysctl_ip_autobind_reuse,
> > +		.maxlen		= sizeof(int),
> > +		.mode		= 0644,
> > +		.proc_handler	= proc_dointvec
> 
> .proc_handler = proc_dointvec_minmax,
> .extra1         = SYSCTL_ZERO,
> .extra2         = SYSCTL_ONE,

I will fix this and respin patches.

Thank you.
