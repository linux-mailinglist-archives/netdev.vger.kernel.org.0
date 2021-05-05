Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6122374BC8
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 01:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhEEXSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 19:18:09 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:45743 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhEEXSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 19:18:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1620256629; x=1651792629;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hgVYjX05dIZDp3W03Dv9fObThcUA/6lXJq3uHBn6rdg=;
  b=UCy93rE+X/e7hL5C/eHF6yqNCfeg7hK8pngSamkJm1c0bluVHtKoGqCp
   rDLVIftB2SXA9TEJUpxvem/piXNMIL89gIuyWsXrr7trBPgQfhdhPGDUN
   ucGtIfzeoWX6yusRUty6ubwaL42SCha2c29+qLhkJGGVQvxASSvLAQ2qO
   A=;
X-IronPort-AV: E=Sophos;i="5.82,276,1613433600"; 
   d="scan'208";a="931719952"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 05 May 2021 23:17:07 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id D52E1C07E1;
        Wed,  5 May 2021 23:17:04 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 May 2021 23:17:04 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.119) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 May 2021 23:16:59 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 bpf-next 06/11] tcp: Migrate TCP_NEW_SYN_RECV requests at retransmitting SYN+ACKs.
Date:   Thu, 6 May 2021 08:16:55 +0900
Message-ID: <20210505231655.45425-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505045618.flihfg3hcesdyfak@kafai-mbp.dhcp.thefacebook.com>
References: <20210505045618.flihfg3hcesdyfak@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.119]
X-ClientProxiedBy: EX13D16UWB004.ant.amazon.com (10.43.161.170) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Tue, 4 May 2021 21:56:18 -0700
> On Tue, Apr 27, 2021 at 12:46:18PM +0900, Kuniyuki Iwashima wrote:
> [ ... ]
> 
> > diff --git a/net/core/request_sock.c b/net/core/request_sock.c
> > index 82cf9fbe2668..08c37ecd923b 100644
> > --- a/net/core/request_sock.c
> > +++ b/net/core/request_sock.c
> > @@ -151,6 +151,7 @@ struct request_sock *reqsk_clone(struct request_sock *req, struct sock *sk)
> >  	memcpy(&nreq_sk->sk_dontcopy_end, &req_sk->sk_dontcopy_end,
> >  	       req->rsk_ops->obj_size - offsetof(struct sock, sk_dontcopy_end));
> >  
> > +	sk_node_init(&nreq_sk->sk_node);
> This belongs to patch 5.
> "rsk_refcnt" also needs to be 0 instead of staying uninitialized
> after reqsk_clone() returned.

I'll move this part to patch 5 and initialize refcnt as 0 in reqsk_clone()
like reqsk_alloc().


> 
> >  	nreq_sk->sk_tx_queue_mapping = req_sk->sk_tx_queue_mapping;
> >  #ifdef CONFIG_XPS
> >  	nreq_sk->sk_rx_queue_mapping = req_sk->sk_rx_queue_mapping;
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index 851992405826..dc984d1f352e 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -695,10 +695,20 @@ int inet_rtx_syn_ack(const struct sock *parent, struct request_sock *req)
> >  }
> >  EXPORT_SYMBOL(inet_rtx_syn_ack);
> >  
> > +static void reqsk_queue_migrated(struct request_sock_queue *queue,
> > +				 const struct request_sock *req)
> > +{
> > +	if (req->num_timeout == 0)
> > +		atomic_inc(&queue->young);
> > +	atomic_inc(&queue->qlen);
> > +}
> > +
> >  static void reqsk_migrate_reset(struct request_sock *req)
> >  {
> > +	req->saved_syn = NULL;
> > +	inet_rsk(req)->ireq_opt = NULL;
> >  #if IS_ENABLED(CONFIG_IPV6)
> > -	inet_rsk(req)->ipv6_opt = NULL;
> > +	inet_rsk(req)->pktopts = NULL;
> >  #endif
> >  }
> >  
> > @@ -741,16 +751,37 @@ EXPORT_SYMBOL(inet_csk_reqsk_queue_drop_and_put);
> >  
> >  static void reqsk_timer_handler(struct timer_list *t)
> >  {
> > -	struct request_sock *req = from_timer(req, t, rsk_timer);
> > -	struct sock *sk_listener = req->rsk_listener;
> > -	struct net *net = sock_net(sk_listener);
> > -	struct inet_connection_sock *icsk = inet_csk(sk_listener);
> > -	struct request_sock_queue *queue = &icsk->icsk_accept_queue;
> > +	struct request_sock *req = from_timer(req, t, rsk_timer), *nreq = NULL, *oreq = req;
> nit. This line is too long.
> Lets move the new "*nreq" and "*oreg" to a new line and keep the current
> "*req" line as is:
> 	struct request_sock *req = from_timer(req, t, rsk_timer);
> 	struct request_sock *oreq = req, *nreq = NULL;

I'll fix that.


> 
> > +	struct sock *sk_listener = req->rsk_listener, *nsk = NULL;
> "*nsk" can be moved into the following "!= TCP_LISTEN" case below.
> Keep the current "*sk_listener" line as is.

I'll move the nsk's definition.

Thank you.


> 
> > +	struct inet_connection_sock *icsk;
> > +	struct request_sock_queue *queue;
> > +	struct net *net;
> >  	int max_syn_ack_retries, qlen, expire = 0, resend = 0;
> >  
> > -	if (inet_sk_state_load(sk_listener) != TCP_LISTEN)
> > -		goto drop;
> > +	if (inet_sk_state_load(sk_listener) != TCP_LISTEN) {
> 
> 		struct sock *nsk;
> 
> > +		nsk = reuseport_migrate_sock(sk_listener, req_to_sk(req), NULL);
> > +		if (!nsk)
> > +			goto drop;
> > +
> > +		nreq = reqsk_clone(req, nsk);
> > +		if (!nreq)
> > +			goto drop;
> > +
> > +		/* The new timer for the cloned req can decrease the 2
> > +		 * by calling inet_csk_reqsk_queue_drop_and_put(), so
> > +		 * hold another count to prevent use-after-free and
> > +		 * call reqsk_put() just before return.
> > +		 */
> > +		refcount_set(&nreq->rsk_refcnt, 2 + 1);
> > +		timer_setup(&nreq->rsk_timer, reqsk_timer_handler, TIMER_PINNED);
> > +		reqsk_queue_migrated(&inet_csk(nsk)->icsk_accept_queue, req);
> > +
> > +		req = nreq;
> > +		sk_listener = nsk;
> > +	}
