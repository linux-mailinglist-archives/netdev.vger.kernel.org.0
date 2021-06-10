Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388143A3756
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 00:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhFJWsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 18:48:03 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:2557 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhFJWsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 18:48:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1623365166; x=1654901166;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IefItx84lkfGf8yGsOjrDLaiwrRpeza0eCBp2p0p1F0=;
  b=gVtacbUwtaENMlM5Ip5Kc7iHx8sZewl72LsjVrA2k0jKFVOmUrkewxfQ
   xW2UuNeq0ppyh6+VYNS+W60o5Yzx5ICdvPw7GEkQSsn9N0/BYLykMLnmX
   hP6ERUFObsIBgKc2ibdedO2LIQNVg6e7JA4LmaEro/8wQCNcMwrLvE1Oy
   o=;
X-IronPort-AV: E=Sophos;i="5.83,264,1616457600"; 
   d="scan'208";a="6053252"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 10 Jun 2021 22:46:04 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id CEE39A216D;
        Thu, 10 Jun 2021 22:46:00 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 22:45:41 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.131) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 22:45:36 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <erdnetdev@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kafai@fb.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v7 bpf-next 05/11] tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Date:   Fri, 11 Jun 2021 07:45:33 +0900
Message-ID: <20210610224533.99525-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <612b0da4-1e3e-66b8-0902-f76840796f36@gmail.com>
References: <612b0da4-1e3e-66b8-0902-f76840796f36@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.131]
X-ClientProxiedBy: EX13D21UWB003.ant.amazon.com (10.43.161.212) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <erdnetdev@gmail.com>
Date:   Thu, 10 Jun 2021 20:20:11 +0200
> On 5/21/21 8:20 PM, Kuniyuki Iwashima wrote:
> > When we call close() or shutdown() for listening sockets, each child socket
> > in the accept queue are freed at inet_csk_listen_stop(). If we can get a
> > new listener by reuseport_migrate_sock() and clone the request by
> > inet_reqsk_clone(), we try to add it into the new listener's accept queue
> > by inet_csk_reqsk_queue_add(). If it fails, we have to call __reqsk_free()
> > to call sock_put() for its listener and free the cloned request.
> > 
> > After putting the full socket into ehash, tcp_v[46]_syn_recv_sock() sets
> > NULL to ireq_opt/pktopts in struct inet_request_sock, but ipv6_opt can be
> > non-NULL. So, we have to set NULL to ipv6_opt of the old request to avoid
> > double free.
> > 
> > Note that we do not update req->rsk_listener and instead clone the req to
> > migrate because another path may reference the original request. If we
> > protected it by RCU, we would need to add rcu_read_lock() in many places.
> > 
> > Link: https://lore.kernel.org/netdev/20201209030903.hhow5r53l6fmozjn@kafai-mbp.dhcp.thefacebook.com/
> > Suggested-by: Martin KaFai Lau <kafai@fb.com>
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > Acked-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  net/ipv4/inet_connection_sock.c | 71 ++++++++++++++++++++++++++++++++-
> >  1 file changed, 70 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index fa806e9167ec..07e97b2f3635 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -695,6 +695,53 @@ int inet_rtx_syn_ack(const struct sock *parent, struct request_sock *req)
> >  }
> >  EXPORT_SYMBOL(inet_rtx_syn_ack);
> >  
> > +static struct request_sock *inet_reqsk_clone(struct request_sock *req,
> > +					     struct sock *sk)
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
> 
> Not sure why you clear sk_refcnt here (it is set to 1 later)

I thought it was safer, but I'm fine to remove the line.


> 
> > +
> > +	nreq->rsk_listener = sk;
> > +
> > +	/* We need not acquire fastopenq->lock
> > +	 * because the child socket is locked in inet_csk_listen_stop().
> > +	 */
> > +	if (sk->sk_protocol == IPPROTO_TCP && tcp_rsk(nreq)->tfo_listener)
> > +		rcu_assign_pointer(tcp_sk(nreq->sk)->fastopen_rsk, nreq);
> > +
> > +	return nreq;
> > +}
> 
> Ouch, this is going to be hard to maintain...

How could I make it less hard ... ?


> 
> 
> 
> 
> > +
> > +static void reqsk_migrate_reset(struct request_sock *req)
> > +{
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +	inet_rsk(req)->ipv6_opt = NULL;
> > +#endif
> > +}
> > +
> >  /* return true if req was found in the ehash table */
> >  static bool reqsk_queue_unlink(struct request_sock *req)
> >  {
> > @@ -1036,14 +1083,36 @@ void inet_csk_listen_stop(struct sock *sk)
> >  	 * of the variants now.			--ANK
> >  	 */
> >  	while ((req = reqsk_queue_remove(queue, sk)) != NULL) {
> > -		struct sock *child = req->sk;
> > +		struct sock *child = req->sk, *nsk;
> > +		struct request_sock *nreq;
> >  
> >  		local_bh_disable();
> >  		bh_lock_sock(child);
> >  		WARN_ON(sock_owned_by_user(child));
> >  		sock_hold(child);
> >  
> > +		nsk = reuseport_migrate_sock(sk, child, NULL);
> > +		if (nsk) {
> > +			nreq = inet_reqsk_clone(req, nsk);
> > +			if (nreq) {
> > +				refcount_set(&nreq->rsk_refcnt, 1);
> > +
> > +				if (inet_csk_reqsk_queue_add(nsk, nreq, child)) {
> > +					reqsk_migrate_reset(req);
> > +				} else {
> > +					reqsk_migrate_reset(nreq);
> > +					__reqsk_free(nreq);
> > +				}
> > +
> > +				/* inet_csk_reqsk_queue_add() has already
> > +				 * called inet_child_forget() on failure case.
> > +				 */
> > +				goto skip_child_forget;
> > +			}
> > +		}
> > +
> >  		inet_child_forget(sk, req, child);
> > +skip_child_forget:
> >  		reqsk_put(req);
> >  		bh_unlock_sock(child);
> >  		local_bh_enable();
> > 
