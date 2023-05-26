Return-Path: <netdev+bounces-5494-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0904C711CEC
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 03:43:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F47828163E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 01:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D72317CF;
	Fri, 26 May 2023 01:43:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A4817C9;
	Fri, 26 May 2023 01:43:42 +0000 (UTC)
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865DE189;
	Thu, 25 May 2023 18:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685065421; x=1716601421;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wpRwuf2+kdwjiLXFnyzN6H2+Sjnfx5JBcF0iQ+u/0Ps=;
  b=pgR5WRL3lxjIeZqxdtWWnp3c20VuZVYpamJLHz++mDFmLi5OHfS+dHT4
   vEVOLII4EKBJjIfByEUWJSwA++miaha5xK5eJAfWoTcJY5YWUo+FuW14S
   Jtc3wYQHyWmM9CUW1i2eiRoJlZlXOPki17KZTgIV4N5nDBnTghcP0SIwl
   0=;
X-IronPort-AV: E=Sophos;i="6.00,192,1681171200"; 
   d="scan'208";a="333622826"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 01:43:38 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com (Postfix) with ESMTPS id 48B42460FE;
	Fri, 26 May 2023 01:43:31 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 26 May 2023 01:43:31 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.100.20) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Fri, 26 May 2023 01:43:26 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <martin.lau@linux.dev>
CC: <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
	<daniel@iogearbox.net>, <davem@davemloft.net>, <dsahern@kernel.org>,
	<edumazet@google.com>, <haoluo@google.com>, <joe@cilium.io>,
	<joe@wand.net.nz>, <john.fastabend@gmail.com>, <jolsa@kernel.org>,
	<kafai@fb.com>, <kpsingh@kernel.org>, <kuba@kernel.org>,
	<linux-kernel@vger.kernel.org>, <lmb@isovalent.com>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>, <sdf@google.com>,
	<song@kernel.org>, <willemdebruijn.kernel@gmail.com>, <yhs@fb.com>,
	<kuniyu@amazon.com>
Subject: Re: [PATCH bpf-next 1/2] bpf, net: Support SO_REUSEPORT sockets with bpf_sk_assign
Date: Thu, 25 May 2023 18:43:17 -0700
Message-ID: <20230526014317.80715-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <7188429a-c380-14c8-57bb-9d05d3ba4e5e@linux.dev>
References: <7188429a-c380-14c8-57bb-9d05d3ba4e5e@linux.dev>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.100.20]
X-ClientProxiedBy: EX19D037UWB004.ant.amazon.com (10.13.138.84) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Martin KaFai Lau <martin.lau@linux.dev>
Date: Thu, 25 May 2023 16:42:46 -0700
> On 5/25/23 1:19 AM, Lorenz Bauer wrote:
> > diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
> > index 56f1286583d3..3ba4dc2703da 100644
> > --- a/include/net/inet6_hashtables.h
> > +++ b/include/net/inet6_hashtables.h
> > @@ -48,6 +48,13 @@ struct sock *__inet6_lookup_established(struct net *net,
> >   					const u16 hnum, const int dif,
> >   					const int sdif);
> >   
> > +struct sock *inet6_lookup_reuseport(struct net *net, struct sock *sk,
> > +				    struct sk_buff *skb, int doff,
> > +				    const struct in6_addr *saddr,
> > +				    __be16 sport,
> > +				    const struct in6_addr *daddr,
> > +				    unsigned short hnum);
> > +
> >   struct sock *inet6_lookup_listener(struct net *net,
> >   				   struct inet_hashinfo *hashinfo,
> >   				   struct sk_buff *skb, int doff,
> > @@ -85,14 +92,33 @@ static inline struct sock *__inet6_lookup_skb(struct inet_hashinfo *hashinfo,
> >   					      int iif, int sdif,
> >   					      bool *refcounted)
> >   {
> > -	struct sock *sk = skb_steal_sock(skb, refcounted);
> > -
> > +	bool prefetched;
> > +	struct sock *sk = skb_steal_sock(skb, refcounted, &prefetched);
> > +	struct net *net = dev_net(skb_dst(skb)->dev);
> > +	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
> > +
> > +	if (prefetched) {
> > +		struct sock *reuse_sk = inet6_lookup_reuseport(net, sk, skb, doff,
> 
> If sk is TCP_ESTABLISHED, I suspect sk->sk_reuseport is 1 (from sk_clone)?

Exactly, it will cause null-ptr-deref in reuseport_select_sock().
We may want to use rcu_access_pointer(sk->sk_reuseport_cb) in
each lookup_reuseport() instead of adding sk_state check ?


> 
> If it is, it should still work other than an extra inet6_ehashfn. Does it worth 
> an extra sk->sk_state check or it is overkill?
> 
> 
> > +							       &ip6h->saddr, sport,
> > +							       &ip6h->daddr, ntohs(dport));

