Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3172D5310
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 06:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgLJFQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 00:16:35 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:21420 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbgLJFQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 00:16:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607577392; x=1639113392;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=hSTAhXMYujFRUiLmquOUF//MlAXSEDqcrk2qXGA2lxo=;
  b=mXXgncsNBvei3bqbjMXiCO2LV0Dn6FlWDASKZnUH9X7pYR7qApwKYR7M
   YfIABCORBN4dq2TzNPCI62M78P4N9S/sBZZS+cZtwr0O5nz6DUKWi9lbJ
   VETUMfxEgXhDw6+zgGEQ9T3XO5syY5vPB8mteoafvEgcp+zxP6IqQAahk
   8=;
X-IronPort-AV: E=Sophos;i="5.78,407,1599523200"; 
   d="scan'208";a="71681466"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-76e0922c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 10 Dec 2020 05:15:48 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-76e0922c.us-west-2.amazon.com (Postfix) with ESMTPS id F2245A366C;
        Thu, 10 Dec 2020 05:15:47 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Dec 2020 05:15:47 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.214) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Dec 2020 05:15:42 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 05/11] tcp: Migrate TCP_NEW_SYN_RECV requests.
Date:   Thu, 10 Dec 2020 14:15:38 +0900
Message-ID: <20201210051538.23059-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201210000707.cxm2r57mbsq2p6uu@kafai-mbp.dhcp.thefacebook.com>
References: <20201210000707.cxm2r57mbsq2p6uu@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.214]
X-ClientProxiedBy: EX13D18UWC004.ant.amazon.com (10.43.162.77) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Wed, 9 Dec 2020 16:07:07 -0800
> On Tue, Dec 01, 2020 at 11:44:12PM +0900, Kuniyuki Iwashima wrote:
> > This patch renames reuseport_select_sock() to __reuseport_select_sock() and
> > adds two wrapper function of it to pass the migration type defined in the
> > previous commit.
> > 
> >   reuseport_select_sock          : BPF_SK_REUSEPORT_MIGRATE_NO
> >   reuseport_select_migrated_sock : BPF_SK_REUSEPORT_MIGRATE_REQUEST
> > 
> > As mentioned before, we have to select a new listener for TCP_NEW_SYN_RECV
> > requests at receiving the final ACK or sending a SYN+ACK. Therefore, this
> > patch also changes the code to call reuseport_select_migrated_sock() even
> > if the listening socket is TCP_CLOSE. If we can pick out a listening socket
> > from the reuseport group, we rewrite request_sock.rsk_listener and resume
> > processing the request.
> > 
> > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > ---
> >  include/net/inet_connection_sock.h | 12 +++++++++++
> >  include/net/request_sock.h         | 13 ++++++++++++
> >  include/net/sock_reuseport.h       |  8 +++----
> >  net/core/sock_reuseport.c          | 34 ++++++++++++++++++++++++------
> >  net/ipv4/inet_connection_sock.c    | 13 ++++++++++--
> >  net/ipv4/tcp_ipv4.c                |  9 ++++++--
> >  net/ipv6/tcp_ipv6.c                |  9 ++++++--
> >  7 files changed, 81 insertions(+), 17 deletions(-)
> > 
> > diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> > index 2ea2d743f8fc..1e0958f5eb21 100644
> > --- a/include/net/inet_connection_sock.h
> > +++ b/include/net/inet_connection_sock.h
> > @@ -272,6 +272,18 @@ static inline void inet_csk_reqsk_queue_added(struct sock *sk)
> >  	reqsk_queue_added(&inet_csk(sk)->icsk_accept_queue);
> >  }
> >  
> > +static inline void inet_csk_reqsk_queue_migrated(struct sock *sk,
> > +						 struct sock *nsk,
> > +						 struct request_sock *req)
> > +{
> > +	reqsk_queue_migrated(&inet_csk(sk)->icsk_accept_queue,
> > +			     &inet_csk(nsk)->icsk_accept_queue,
> > +			     req);
> > +	sock_put(sk);
> not sure if it is safe to do here.
> IIUC, when the req->rsk_refcnt is held, it also holds a refcnt
> to req->rsk_listener such that sock_hold(req->rsk_listener) is
> safe because its sk_refcnt is not zero.

I think it is safe to call sock_put() for the old listener here.

Without this patchset, at receiving the final ACK or retransmitting
SYN+ACK, if sk_state == TCP_CLOSE, sock_put(req->rsk_listener) is done
by calling reqsk_put() twice in inet_csk_reqsk_queue_drop_and_put(). And
then, we do `goto lookup;` and overwrite the sk.

In the v2 patchset, refcount_inc_not_zero() is done for the new listener in
reuseport_select_migrated_sock(), so we have to call sock_put() for the old
listener instead to free it properly.

---8<---
+struct sock *reuseport_select_migrated_sock(struct sock *sk, u32 hash,
+					    struct sk_buff *skb)
+{
+	struct sock *nsk;
+
+	nsk = __reuseport_select_sock(sk, hash, skb, 0, BPF_SK_REUSEPORT_MIGRATE_REQUEST);
+	if (nsk && likely(refcount_inc_not_zero(&nsk->sk_refcnt)))
+		return nsk;
+
+	return NULL;
+}
+EXPORT_SYMBOL(reuseport_select_migrated_sock);
---8<---
https://lore.kernel.org/netdev/20201207132456.65472-8-kuniyu@amazon.co.jp/


> > +	sock_hold(nsk);
> > +	req->rsk_listener = nsk;
> > +}
> > +
> 
> [ ... ]
> 
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index 361efe55b1ad..e71653c6eae2 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -743,8 +743,17 @@ static void reqsk_timer_handler(struct timer_list *t)
> >  	struct request_sock_queue *queue = &icsk->icsk_accept_queue;
> >  	int max_syn_ack_retries, qlen, expire = 0, resend = 0;
> >  
> > -	if (inet_sk_state_load(sk_listener) != TCP_LISTEN)
> > -		goto drop;
> > +	if (inet_sk_state_load(sk_listener) != TCP_LISTEN) {
> > +		sk_listener = reuseport_select_migrated_sock(sk_listener,
> > +							     req_to_sk(req)->sk_hash, NULL);
> > +		if (!sk_listener) {
> > +			sk_listener = req->rsk_listener;
> > +			goto drop;
> > +		}
> > +		inet_csk_reqsk_queue_migrated(req->rsk_listener, sk_listener, req);
> > +		icsk = inet_csk(sk_listener);
> > +		queue = &icsk->icsk_accept_queue;
> > +	}
> >  
> >  	max_syn_ack_retries = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_synack_retries;
> >  	/* Normally all the openreqs are young and become mature
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index e4b31e70bd30..9a9aa27c6069 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -1973,8 +1973,13 @@ int tcp_v4_rcv(struct sk_buff *skb)
> >  			goto csum_error;
> >  		}
> >  		if (unlikely(sk->sk_state != TCP_LISTEN)) {
> > -			inet_csk_reqsk_queue_drop_and_put(sk, req);
> > -			goto lookup;
> > +			nsk = reuseport_select_migrated_sock(sk, req_to_sk(req)->sk_hash, skb);
> > +			if (!nsk) {
> > +				inet_csk_reqsk_queue_drop_and_put(sk, req);
> > +				goto lookup;
> > +			}
> > +			inet_csk_reqsk_queue_migrated(sk, nsk, req);
> > +			sk = nsk;
> >  		}
> >  		/* We own a reference on the listener, increase it again
> >  		 * as we might lose it too soon.
> > diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> > index 992cbf3eb9e3..ff11f3c0cb96 100644
> > --- a/net/ipv6/tcp_ipv6.c
> > +++ b/net/ipv6/tcp_ipv6.c
> > @@ -1635,8 +1635,13 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
> >  			goto csum_error;
> >  		}
> >  		if (unlikely(sk->sk_state != TCP_LISTEN)) {
> > -			inet_csk_reqsk_queue_drop_and_put(sk, req);
> > -			goto lookup;
> > +			nsk = reuseport_select_migrated_sock(sk, req_to_sk(req)->sk_hash, skb);
> > +			if (!nsk) {
> > +				inet_csk_reqsk_queue_drop_and_put(sk, req);
> > +				goto lookup;
> > +			}
> > +			inet_csk_reqsk_queue_migrated(sk, nsk, req);
> > +			sk = nsk;
> >  		}
> >  		sock_hold(sk);
> For example, this sock_hold(sk).  sk here is req->rsk_listener.

After migration, this is for the new listener and it is safe because
refcount_inc_not_zero() for the new listener is called in
reuseport_select_migerate_sock().


> >  		refcounted = true;
> > -- 
> > 2.17.2 (Apple Git-113)

