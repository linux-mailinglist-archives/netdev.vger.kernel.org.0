Return-Path: <netdev+bounces-5497-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 638D1711E23
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 04:50:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C55E9281673
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 02:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35B8717F4;
	Fri, 26 May 2023 02:50:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0851FCF;
	Fri, 26 May 2023 02:50:03 +0000 (UTC)
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276FD9C;
	Thu, 25 May 2023 19:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685069401; x=1716605401;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2k6LATmSEjQ87/ONfQdITiWFK2HdYH+jsh6Z7mJU0RU=;
  b=rqVSCh5RFLYceZrZi13CA08HAcoo16Ikn7eOGBuR8DwrXCScPNYCxMZg
   9nehmqWDYwj1uWkvqbEyZtfGEfLzEfFznDs2YfBUD9sCrNwtrfcy9gkIG
   TuYMzFPZXuMHVHjDa8sGpv/1/sR1kQWa+Q8WYhH5sYp9CCnttZVq6YtyS
   k=;
X-IronPort-AV: E=Sophos;i="6.00,192,1681171200"; 
   d="scan'208";a="287490348"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 02:49:53 +0000
Received: from EX19MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com (Postfix) with ESMTPS id 7B9408064D;
	Fri, 26 May 2023 02:49:50 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 26 May 2023 02:49:45 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.100.20) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 26 May 2023 02:49:40 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <kuniyu@amazon.com>
CC: <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
	<daniel@iogearbox.net>, <davem@davemloft.net>, <dsahern@kernel.org>,
	<edumazet@google.com>, <haoluo@google.com>, <joe@cilium.io>,
	<joe@wand.net.nz>, <john.fastabend@gmail.com>, <jolsa@kernel.org>,
	<kafai@fb.com>, <kpsingh@kernel.org>, <kuba@kernel.org>,
	<linux-kernel@vger.kernel.org>, <lmb@isovalent.com>, <martin.lau@linux.dev>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>, <sdf@google.com>,
	<song@kernel.org>, <willemdebruijn.kernel@gmail.com>, <yhs@fb.com>
Subject: Re: [PATCH bpf-next 1/2] bpf, net: Support SO_REUSEPORT sockets with bpf_sk_assign
Date: Thu, 25 May 2023 19:49:31 -0700
Message-ID: <20230526024931.88117-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230526014317.80715-1-kuniyu@amazon.com>
References: <20230526014317.80715-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.100.20]
X-ClientProxiedBy: EX19D032UWA004.ant.amazon.com (10.13.139.56) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Kuniyuki Iwashima <kuniyu@amazon.com>
Date: Thu, 25 May 2023 18:43:17 -0700
> From: Martin KaFai Lau <martin.lau@linux.dev>
> Date: Thu, 25 May 2023 16:42:46 -0700
> > On 5/25/23 1:19 AM, Lorenz Bauer wrote:
> > > diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
> > > index 56f1286583d3..3ba4dc2703da 100644
> > > --- a/include/net/inet6_hashtables.h
> > > +++ b/include/net/inet6_hashtables.h
> > > @@ -48,6 +48,13 @@ struct sock *__inet6_lookup_established(struct net *net,
> > >   					const u16 hnum, const int dif,
> > >   					const int sdif);
> > >   
> > > +struct sock *inet6_lookup_reuseport(struct net *net, struct sock *sk,
> > > +				    struct sk_buff *skb, int doff,
> > > +				    const struct in6_addr *saddr,
> > > +				    __be16 sport,
> > > +				    const struct in6_addr *daddr,
> > > +				    unsigned short hnum);
> > > +
> > >   struct sock *inet6_lookup_listener(struct net *net,
> > >   				   struct inet_hashinfo *hashinfo,
> > >   				   struct sk_buff *skb, int doff,
> > > @@ -85,14 +92,33 @@ static inline struct sock *__inet6_lookup_skb(struct inet_hashinfo *hashinfo,
> > >   					      int iif, int sdif,
> > >   					      bool *refcounted)
> > >   {
> > > -	struct sock *sk = skb_steal_sock(skb, refcounted);
> > > -
> > > +	bool prefetched;
> > > +	struct sock *sk = skb_steal_sock(skb, refcounted, &prefetched);
> > > +	struct net *net = dev_net(skb_dst(skb)->dev);
> > > +	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
> > > +
> > > +	if (prefetched) {
> > > +		struct sock *reuse_sk = inet6_lookup_reuseport(net, sk, skb, doff,
> > 
> > If sk is TCP_ESTABLISHED, I suspect sk->sk_reuseport is 1 (from sk_clone)?
> 
> Exactly, it will cause null-ptr-deref in reuseport_select_sock().

Sorry, this doesn't occur.  reuseport_select_sock() has null check.


> We may want to use rcu_access_pointer(sk->sk_reuseport_cb) in
> each lookup_reuseport() instead of adding sk_state check ?

And if someone has a weird program that creates multiple listeners and
disable SO_REUSEPORT for a listener that hits first in lhash2, checking
sk_reuseport_cb might not work ?  I hope no one does such though, checking
sk_reuseport and sk_state could be better.

> 
> 
> > 
> > If it is, it should still work other than an extra inet6_ehashfn. Does it worth 
> > an extra sk->sk_state check or it is overkill?
> > 
> > 
> > > +							       &ip6h->saddr, sport,
> > > +							       &ip6h->daddr, ntohs(dport));

