Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7633573932
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236553AbiGMOuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236603AbiGMOui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:50:38 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A423C148
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 07:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657723835; x=1689259835;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=amFu5oMYmIUnNdyvgpW7jA1WxPQ8qEubmc6b3tCJJvo=;
  b=mczIud8uwLhXODUCgh5yTybN46vn/D0XM2piY1/h2WpJFLyCp7jJOI1D
   hZWisAseYVOalIxBGethki5UYEsLsNyLaqvK0YBXv1K31M0fK0ojIXbM3
   7vBzItjebF+CU9mNP6Vq82RxikQUUFzOIJ1oNd8XKhJuFfadhjJJSvrGT
   M=;
X-IronPort-AV: E=Sophos;i="5.92,267,1650931200"; 
   d="scan'208";a="107893095"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-1box-2b-3386f33d.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 13 Jul 2022 14:39:36 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-1box-2b-3386f33d.us-west-2.amazon.com (Postfix) with ESMTPS id D091D816DF;
        Wed, 13 Jul 2022 14:39:34 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 13 Jul 2022 14:39:34 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.144) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 13 Jul 2022 14:39:32 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <subashab@codeaurora.org>
Subject: Re: [PATCH v3 net] tcp/udp: Make early_demux back namespacified.
Date:   Wed, 13 Jul 2022 07:39:24 -0700
Message-ID: <20220713143924.97429-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <e8e3986ef81121c51ff4543a9432374897542290.camel@redhat.com>
References: <e8e3986ef81121c51ff4543a9432374897542290.camel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.144]
X-ClientProxiedBy: EX13D20UWA003.ant.amazon.com (10.43.160.97) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Paolo Abeni <pabeni@redhat.com>
Date:   Wed, 13 Jul 2022 09:15:30 +0200
> Hi,
> 
> On Tue, 2022-07-12 at 11:51 -0700, Kuniyuki Iwashima wrote:
> > Commit e21145a9871a ("ipv4: namespacify ip_early_demux sysctl knob") made
> > it possible to enable/disable early_demux on a per-netns basis.  Then, we
> > introduced two knobs, tcp_early_demux and udp_early_demux, to switch it for
> > TCP/UDP in commit dddb64bcb346 ("net: Add sysctl to toggle early demux for
> > tcp and udp").  However, the .proc_handler() was wrong and actually
> > disabled us from changing the behaviour in each netns.
> > 
> > We can execute early_demux if net.ipv4.ip_early_demux is on and each proto
> > .early_demux() handler is not NULL.  When we toggle (tcp|udp)_early_demux,
> > the change itself is saved in each netns variable, but the .early_demux()
> > handler is a global variable, so the handler is switched based on the
> > init_net's sysctl variable.  Thus, netns (tcp|udp)_early_demux knobs have
> > nothing to do with the logic.  Whether we CAN execute proto .early_demux()
> > is always decided by init_net's sysctl knob, and whether we DO it or not is
> > by each netns ip_early_demux knob.
> > 
> > This patch namespacifies (tcp|udp)_early_demux again.  For now, the users
> > of the .early_demux() handler are TCP and UDP only, and they are called
> > directly to avoid retpoline.  So, we can remove the .early_demux() handler
> > from inet6?_protos and need not dereference them in ip6?_rcv_finish_core().
> > If another proto needs .early_demux(), we can restore it at that time.
> > 
> > Fixes: dddb64bcb346 ("net: Add sysctl to toggle early demux for tcp and udp")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> > v3:
> >   - Drop sysctl min/max fixes (Eric Dumazet)
> > 
> > v2: https://lore.kernel.org/netdev/20220712173801.39550-1-kuniyu@amazon.com/
> >   - Drop cleanups in tcp_v4_early_demux() (Eric Dumazet)
> > 
> > v1: https://lore.kernel.org/netdev/20220712163243.36014-1-kuniyu@amazon.com/
> > ---
> >  include/net/protocol.h     |  4 ---
> >  include/net/tcp.h          |  2 +-
> >  include/net/udp.h          |  2 +-
> >  net/ipv4/af_inet.c         | 14 ++-------
> >  net/ipv4/ip_input.c        | 37 ++++++++++++++----------
> >  net/ipv4/sysctl_net_ipv4.c | 59 ++------------------------------------
> >  net/ipv6/ip6_input.c       | 23 ++++++++-------
> >  net/ipv6/tcp_ipv6.c        |  9 ++----
> >  net/ipv6/udp.c             |  9 ++----
> >  9 files changed, 45 insertions(+), 114 deletions(-)
> > 
> > diff --git a/include/net/protocol.h b/include/net/protocol.h
> > index f51c06ae365f..6aef8cb11cc8 100644
> > --- a/include/net/protocol.h
> > +++ b/include/net/protocol.h
> > @@ -35,8 +35,6 @@
> >  
> >  /* This is used to register protocols. */
> >  struct net_protocol {
> > -	int			(*early_demux)(struct sk_buff *skb);
> > -	int			(*early_demux_handler)(struct sk_buff *skb);
> >  	int			(*handler)(struct sk_buff *skb);
> >  
> >  	/* This returns an error if we weren't able to handle the error. */
> > @@ -52,8 +50,6 @@ struct net_protocol {
> >  
> >  #if IS_ENABLED(CONFIG_IPV6)
> >  struct inet6_protocol {
> > -	void	(*early_demux)(struct sk_buff *skb);
> > -	void    (*early_demux_handler)(struct sk_buff *skb);
> >  	int	(*handler)(struct sk_buff *skb);
> >  
> >  	/* This returns an error if we weren't able to handle the error. */
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index 1e99f5c61f84..1636c55e798b 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -932,7 +932,7 @@ extern const struct inet_connection_sock_af_ops ipv6_specific;
> >  
> >  INDIRECT_CALLABLE_DECLARE(void tcp_v6_send_check(struct sock *sk, struct sk_buff *skb));
> >  INDIRECT_CALLABLE_DECLARE(int tcp_v6_rcv(struct sk_buff *skb));
> > -INDIRECT_CALLABLE_DECLARE(void tcp_v6_early_demux(struct sk_buff *skb));
> > +void tcp_v6_early_demux(struct sk_buff *skb);
> >  
> >  #endif
> >  
> > diff --git a/include/net/udp.h b/include/net/udp.h
> > index b83a00330566..bb4c227299cc 100644
> > --- a/include/net/udp.h
> > +++ b/include/net/udp.h
> > @@ -167,7 +167,7 @@ static inline void udp_csum_pull_header(struct sk_buff *skb)
> >  typedef struct sock *(*udp_lookup_t)(const struct sk_buff *skb, __be16 sport,
> >  				     __be16 dport);
> >  
> > -INDIRECT_CALLABLE_DECLARE(void udp_v6_early_demux(struct sk_buff *));
> > +void udp_v6_early_demux(struct sk_buff *skb);
> >  INDIRECT_CALLABLE_DECLARE(int udpv6_rcv(struct sk_buff *));
> >  
> >  struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
> > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > index 93da9f783bec..76e7a7ca6772 100644
> > --- a/net/ipv4/af_inet.c
> > +++ b/net/ipv4/af_inet.c
> > @@ -1710,24 +1710,14 @@ static const struct net_protocol igmp_protocol = {
> >  };
> >  #endif
> >  
> > -/* thinking of making this const? Don't.
> > - * early_demux can change based on sysctl.
> > - */
> > -static struct net_protocol tcp_protocol = {
> > -	.early_demux	=	tcp_v4_early_demux,
> > -	.early_demux_handler =  tcp_v4_early_demux,
> > +static const struct net_protocol tcp_protocol = {
> >  	.handler	=	tcp_v4_rcv,
> >  	.err_handler	=	tcp_v4_err,
> >  	.no_policy	=	1,
> >  	.icmp_strict_tag_validation = 1,
> >  };
> >  
> > -/* thinking of making this const? Don't.
> > - * early_demux can change based on sysctl.
> > - */
> > -static struct net_protocol udp_protocol = {
> > -	.early_demux =	udp_v4_early_demux,
> > -	.early_demux_handler =	udp_v4_early_demux,
> > +static const struct net_protocol udp_protocol = {
> >  	.handler =	udp_rcv,
> >  	.err_handler =	udp_err,
> >  	.no_policy =	1,
> > diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> > index b1165f717cd1..455ec0931ad8 100644
> > --- a/net/ipv4/ip_input.c
> > +++ b/net/ipv4/ip_input.c
> > @@ -312,14 +312,13 @@ static bool ip_can_use_hint(const struct sk_buff *skb, const struct iphdr *iph,
> >  	       ip_hdr(hint)->tos == iph->tos;
> >  }
> >  
> > -INDIRECT_CALLABLE_DECLARE(int udp_v4_early_demux(struct sk_buff *));
> > -INDIRECT_CALLABLE_DECLARE(int tcp_v4_early_demux(struct sk_buff *));
> > +int tcp_v4_early_demux(struct sk_buff *skb);
> > +int udp_v4_early_demux(struct sk_buff *skb);
> >  static int ip_rcv_finish_core(struct net *net, struct sock *sk,
> >  			      struct sk_buff *skb, struct net_device *dev,
> >  			      const struct sk_buff *hint)
> >  {
> >  	const struct iphdr *iph = ip_hdr(skb);
> > -	int (*edemux)(struct sk_buff *skb);
> >  	int err, drop_reason;
> >  	struct rtable *rt;
> >  
> > @@ -332,21 +331,29 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
> >  			goto drop_error;
> >  	}
> >  
> > -	if (net->ipv4.sysctl_ip_early_demux &&
> > +	if (READ_ONCE(net->ipv4.sysctl_ip_early_demux) &&
> >  	    !skb_dst(skb) &&
> >  	    !skb->sk &&
> >  	    !ip_is_fragment(iph)) {
> > -		const struct net_protocol *ipprot;
> > -		int protocol = iph->protocol;
> > -
> > -		ipprot = rcu_dereference(inet_protos[protocol]);
> > -		if (ipprot && (edemux = READ_ONCE(ipprot->early_demux))) {
> > -			err = INDIRECT_CALL_2(edemux, tcp_v4_early_demux,
> > -					      udp_v4_early_demux, skb);
> > -			if (unlikely(err))
> > -				goto drop_error;
> > -			/* must reload iph, skb->head might have changed */
> > -			iph = ip_hdr(skb);
> > +		switch (iph->protocol) {
> > +		case IPPROTO_TCP:
> > +			if (READ_ONCE(net->ipv4.sysctl_tcp_early_demux)) {
> > +				tcp_v4_early_demux(skb);
> > +
> > +				/* must reload iph, skb->head might have changed */
> > +				iph = ip_hdr(skb);
> > +			}
> > +			break;
> > +		case IPPROTO_UDP:
> > +			if (READ_ONCE(net->ipv4.sysctl_tcp_early_demux)) {
> 
> I'm sorry for the late feedback. The above should be
> 'sysctl_udp_early_demux'.
> 
> The same happens in the ipv6 case.

Thanks for catching this!
I'll fix that in the next spin.


> 
> Thanks!
> 
> Paolo
