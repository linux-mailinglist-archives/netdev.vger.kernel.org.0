Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0C13815AE
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 06:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbhEOEQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 00:16:03 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:63728 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhEOEQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 00:16:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1621052090; x=1652588090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+aZD1zLSq6chFtKoY8/utueoK2N/X9wi5QRRMf7pO34=;
  b=QGldav61X4tYft18xyZ1ahhO2ylD8JKzIE/Vi3UyJlbIR+hAgsxCZeV9
   LzRGKUlmXJER0S+J6OQizb/zeHevqbliAEZgFS40zeX3yxQBV3iDKjNtz
   7AES2oBWSf7+TpUHHssfNke4LCnccNf70iPIhNllI+CKmELOfteTrZ+5b
   E=;
X-IronPort-AV: E=Sophos;i="5.82,300,1613433600"; 
   d="scan'208";a="112350225"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 15 May 2021 04:14:48 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id BFE74A18DF;
        Sat, 15 May 2021 04:14:47 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 15 May 2021 04:14:47 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.28) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 15 May 2021 04:14:41 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 bpf-next 05/11] tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Date:   Sat, 15 May 2021 13:14:37 +0900
Message-ID: <20210515041438.81233-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210515010616.uy5szaoqvjrn4qfv@kafai-mbp>
References: <20210515010616.uy5szaoqvjrn4qfv@kafai-mbp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.28]
X-ClientProxiedBy: EX13D36UWB001.ant.amazon.com (10.43.161.84) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Fri, 14 May 2021 18:06:16 -0700
> On Mon, May 10, 2021 at 12:44:27PM +0900, Kuniyuki Iwashima wrote:
> > diff --git a/net/core/request_sock.c b/net/core/request_sock.c
> > index f35c2e998406..7879a3660c52 100644
> > --- a/net/core/request_sock.c
> > +++ b/net/core/request_sock.c
> > @@ -130,3 +130,42 @@ void reqsk_fastopen_remove(struct sock *sk, struct request_sock *req,
> >  out:
> >  	spin_unlock_bh(&fastopenq->lock);
> >  }
> > +
> > +struct request_sock *reqsk_clone(struct request_sock *req, struct sock *sk)
> > +{
> > +	struct sock *req_sk, *nreq_sk;
> > +	struct request_sock *nreq;
> > +
> > +	nreq = kmem_cache_alloc(req->rsk_ops->slab, GFP_ATOMIC | __GFP_NOWARN);
> > +	if (!nreq) {
> > +		/* paired with refcount_inc_not_zero() in reuseport_migrate_sock() */
> > +		sock_put(sk);
> > +		return NULL;
> > +	}
> > +
> > +	req_sk = req_to_sk(req);
> > +	nreq_sk = req_to_sk(nreq);
> > +
> > +	memcpy(nreq_sk, req_sk,
> > +	       offsetof(struct sock, sk_dontcopy_begin));
> > +	memcpy(&nreq_sk->sk_dontcopy_end, &req_sk->sk_dontcopy_end,
> > +	       req->rsk_ops->obj_size - offsetof(struct sock, sk_dontcopy_end));
> > +
> > +	sk_node_init(&nreq_sk->sk_node);
> > +	nreq_sk->sk_tx_queue_mapping = req_sk->sk_tx_queue_mapping;
> > +#ifdef CONFIG_XPS
> > +	nreq_sk->sk_rx_queue_mapping = req_sk->sk_rx_queue_mapping;
> > +#endif
> > +	nreq_sk->sk_incoming_cpu = req_sk->sk_incoming_cpu;
> > +	refcount_set(&nreq_sk->sk_refcnt, 0);
> > +
> > +	nreq->rsk_listener = sk;
> > +
> > +	/* We need not acquire fastopenq->lock
> > +	 * because the child socket is locked in inet_csk_listen_stop().
> > +	 */
> > +	if (tcp_rsk(nreq)->tfo_listener)
> Should IPPROTO_TCP be tested first like other similar situations
> in inet_connection_sock.c?

I've written this way because migration happens only in TCP for now, but I
agree that test of IPPROTO_TCP makes less error-prone in the future. So,
I'll test it first in the next spin.

Thank you!


> 
> Also, reqsk_clone() is only used in inet_connection_sock.c.
> Can it be moved to inet_connection_sock.c instead and renamed to
> inet_reqsk_clone()?

I'll do that.
