Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73F562FC4A
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 19:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242560AbiKRSRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 13:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235536AbiKRSRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 13:17:31 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0838E080
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 10:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668795450; x=1700331450;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m7nsEhfqAmwrYISgV9ZmDeuCY0A/t5nzSCf17JFTfxs=;
  b=X78s6pQlYkeZ0CJQ+HB+5ZtEgD6o8QXiHbHiIaQSR7qRllwBhTfxaRYX
   fsW1yYp/jAbrV+HH8qy76ZDyIp9iAshAM8GWtXE7JTAikIiB5DoW25kUS
   fuFOUq+v6VErTAw2Q4SMsZR5swIG/ZXReD+JqVZ5n2gipvo72/GrDZ9OC
   o=;
X-IronPort-AV: E=Sophos;i="5.96,175,1665446400"; 
   d="scan'208";a="281591143"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-af372327.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 18:10:53 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-af372327.us-west-2.amazon.com (Postfix) with ESMTPS id EA7486103D;
        Fri, 18 Nov 2022 18:10:51 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 18 Nov 2022 18:10:51 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.14) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Fri, 18 Nov 2022 18:10:48 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <pabeni@redhat.com>
CC:     <cpaasch@apple.com>, <davem@davemloft.net>, <dsahern@kernel.org>,
        <edumazet@google.com>, <fw@strlen.de>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>, <mptcp@lists.linux.dev>,
        <netdev@vger.kernel.org>, <peter.krystad@linux.intel.com>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v1 net] net: Return errno in sk->sk_prot->get_port().
Date:   Fri, 18 Nov 2022 10:10:40 -0800
Message-ID: <20221118181041.5393-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <d55e881a95e144e82b90225d6834e99fb9a91248.camel@redhat.com>
References: <d55e881a95e144e82b90225d6834e99fb9a91248.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D46UWC002.ant.amazon.com (10.43.162.67) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Paolo Abeni <pabeni@redhat.com>
Date:   Fri, 18 Nov 2022 10:35:07 +0100
> On Thu, 2022-11-17 at 10:47 -0800, Kuniyuki Iwashima wrote:
> > We assume the correct errno is -EADDRINUSE when sk->sk_prot->get_port()
> > fails, so some ->get_port() functions return just 1 on failure and the
> > callers return -EADDRINUSE instead.
> > 
> > However, mptcp_get_port() can return -EINVAL.  Let's not ignore the error.
> 
> Note that such return value is on a WARN_ON_ONCE() check. I think such
> condition is actually an overzealot error checking and we could
> possibly/likelly remove it in the future.
> 
> Still the change below IMHO makes the code cleaner, so I'm not
> opposing. Possibly could be targeting net-next instead.

Even without this patch we can catch the error as -EADDRINUSE, and I don't
have strong preference, so I'll respin for net-next.

Thank you.


> 
> Thanks,
> 
> Paolo
> 
> > Note the only exception is inet_autobind(), all of whose callers return
> > -EAGAIN instead.
> > 
> > Fixes: cec37a6e41aa ("mptcp: Handle MP_CAPABLE options for outgoing connections")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  net/ipv4/af_inet.c              | 4 ++--
> >  net/ipv4/inet_connection_sock.c | 7 ++++---
> >  net/ipv4/ping.c                 | 2 +-
> >  net/ipv4/udp.c                  | 2 +-
> >  net/ipv6/af_inet6.c             | 4 ++--
> >  5 files changed, 10 insertions(+), 9 deletions(-)
> > 
> > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > index 4728087c42a5..4799eb55c830 100644
> > --- a/net/ipv4/af_inet.c
> > +++ b/net/ipv4/af_inet.c
> > @@ -522,9 +522,9 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
> >  	/* Make sure we are allowed to bind here. */
> >  	if (snum || !(inet->bind_address_no_port ||
> >  		      (flags & BIND_FORCE_ADDRESS_NO_PORT))) {
> > -		if (sk->sk_prot->get_port(sk, snum)) {
> > +		err = sk->sk_prot->get_port(sk, snum);
> > +		if (err) {
> >  			inet->inet_saddr = inet->inet_rcv_saddr = 0;
> > -			err = -EADDRINUSE;
> >  			goto out_release_sock;
> >  		}
> >  		if (!(flags & BIND_FROM_BPF)) {
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index 4e84ed21d16f..4a34bc7cb15e 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -471,11 +471,11 @@ int inet_csk_get_port(struct sock *sk, unsigned short snum)
> >  	bool reuse = sk->sk_reuse && sk->sk_state != TCP_LISTEN;
> >  	bool found_port = false, check_bind_conflict = true;
> >  	bool bhash_created = false, bhash2_created = false;
> > +	int ret = -EADDRINUSE, port = snum, l3mdev;
> >  	struct inet_bind_hashbucket *head, *head2;
> >  	struct inet_bind2_bucket *tb2 = NULL;
> >  	struct inet_bind_bucket *tb = NULL;
> >  	bool head2_lock_acquired = false;
> > -	int ret = 1, port = snum, l3mdev;
> >  	struct net *net = sock_net(sk);
> >  
> >  	l3mdev = inet_sk_bound_l3mdev(sk);
> > @@ -1186,7 +1186,7 @@ int inet_csk_listen_start(struct sock *sk)
> >  {
> >  	struct inet_connection_sock *icsk = inet_csk(sk);
> >  	struct inet_sock *inet = inet_sk(sk);
> > -	int err = -EADDRINUSE;
> > +	int err;
> >  
> >  	reqsk_queue_alloc(&icsk->icsk_accept_queue);
> >  
> > @@ -1202,7 +1202,8 @@ int inet_csk_listen_start(struct sock *sk)
> >  	 * after validation is complete.
> >  	 */
> >  	inet_sk_state_store(sk, TCP_LISTEN);
> > -	if (!sk->sk_prot->get_port(sk, inet->inet_num)) {
> > +	err = sk->sk_prot->get_port(sk, inet->inet_num);
> > +	if (!err) {
> >  		inet->inet_sport = htons(inet->inet_num);
> >  
> >  		sk_dst_reset(sk);
> > diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> > index bde333b24837..bb9854c2b7a1 100644
> > --- a/net/ipv4/ping.c
> > +++ b/net/ipv4/ping.c
> > @@ -138,7 +138,7 @@ int ping_get_port(struct sock *sk, unsigned short ident)
> >  
> >  fail:
> >  	spin_unlock(&ping_table.lock);
> > -	return 1;
> > +	return -EADDRINUSE;
> >  }
> >  EXPORT_SYMBOL_GPL(ping_get_port);
> >  
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 6a320a614e54..b30137f48fff 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -234,7 +234,7 @@ int udp_lib_get_port(struct sock *sk, unsigned short snum,
> >  {
> >  	struct udp_hslot *hslot, *hslot2;
> >  	struct udp_table *udptable = sk->sk_prot->h.udp_table;
> > -	int    error = 1;
> > +	int error = -EADDRINUSE;
> >  	struct net *net = sock_net(sk);
> >  
> >  	if (!snum) {
> > diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> > index 024191004982..7b0cd54da452 100644
> > --- a/net/ipv6/af_inet6.c
> > +++ b/net/ipv6/af_inet6.c
> > @@ -409,10 +409,10 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
> >  	/* Make sure we are allowed to bind here. */
> >  	if (snum || !(inet->bind_address_no_port ||
> >  		      (flags & BIND_FORCE_ADDRESS_NO_PORT))) {
> > -		if (sk->sk_prot->get_port(sk, snum)) {
> > +		err = sk->sk_prot->get_port(sk, snum);
> > +		if (err) {
> >  			sk->sk_ipv6only = saved_ipv6only;
> >  			inet_reset_saddr(sk);
> > -			err = -EADDRINUSE;
> >  			goto out;
> >  		}
> >  		if (!(flags & BIND_FROM_BPF)) {
> 
