Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A401B2186
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgDUIZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:25:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59469 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726018AbgDUIZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 04:25:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587457501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jc5KcheIAuk6xPulm6IC5yABuGQMNBJejExnkGGOmuc=;
        b=eagVgQs11ADRg68bgNZnScyZdxiaROgPmkp0Z2o2e0bYLlqfrEnW6rqOuCsqaO4C0bMm5G
        R8icI0n9fyoxlVxxZKyLEz9SVwjYTJW8tU9VmPJZiGgstA9LhpQZ5dvEseiQnipFO6nSCg
        E8gvWdVpbJk6KLit2kD3pvga3rhvjlo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-BtOh7ILUOSO56wzQDEJcqg-1; Tue, 21 Apr 2020 04:24:57 -0400
X-MC-Unique: BtOh7ILUOSO56wzQDEJcqg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E662413F7;
        Tue, 21 Apr 2020 08:24:55 +0000 (UTC)
Received: from ovpn-115-18.ams2.redhat.com (ovpn-115-18.ams2.redhat.com [10.36.115.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 145181001938;
        Tue, 21 Apr 2020 08:24:53 +0000 (UTC)
Message-ID: <5f0a72a715fdfcd64119f0ad95b076570959fdf5.camel@redhat.com>
Subject: Re: [PATCH net 3/3] mptcp: drop req socket remote_key* fields
From:   Paolo Abeni <pabeni@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>,
        Florian Westphal <fw@strlen.de>
Date:   Tue, 21 Apr 2020 10:24:52 +0200
In-Reply-To: <alpine.OSX.2.22.394.2004201254570.98347@chall-mobl1.amr.corp.intel.com>
References: <cover.1587389294.git.pabeni@redhat.com>
         <0fc5ffc1b598e18e6c488331b0a756e45205f64b.1587389294.git.pabeni@redhat.com>
         <alpine.OSX.2.22.394.2004201254570.98347@chall-mobl1.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-04-20 at 13:05 -0700, Mat Martineau wrote:
> On Mon, 20 Apr 2020, Paolo Abeni wrote:
> 
> > We don't need them, as we can use the current ingress opt
> > data instead. Setting them in syn_recv_sock() may causes
> > inconsistent mptcp socket status, as per previous commit.
> > 
> > Fixes: cc7972ea1932 ("mptcp: parse and emit MP_CAPABLE option according to v1 spec")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> > net/mptcp/protocol.c |  8 +++++---
> > net/mptcp/protocol.h |  8 ++++----
> > net/mptcp/subflow.c  | 20 ++++++++++----------
> > 3 files changed, 19 insertions(+), 17 deletions(-)
> > 
> > diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> > index d275c1e827fe..58ad03fc1bbc 100644
> > --- a/net/mptcp/protocol.c
> > +++ b/net/mptcp/protocol.c
> > @@ -1345,7 +1345,9 @@ static struct ipv6_pinfo *mptcp_inet6_sk(const struct sock *sk)
> > }
> > #endif
> > 
> > -struct sock *mptcp_sk_clone(const struct sock *sk, struct request_sock *req)
> > +struct sock *mptcp_sk_clone(const struct sock *sk,
> > +			    const struct tcp_options_received *opt_rx,
> > +			    struct request_sock *req)
> > {
> > 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
> > 	struct sock *nsk = sk_clone_lock(sk, GFP_ATOMIC);
> > @@ -1383,9 +1385,9 @@ struct sock *mptcp_sk_clone(const struct sock *sk, struct request_sock *req)
> > 
> > 	msk->write_seq = subflow_req->idsn + 1;
> > 	atomic64_set(&msk->snd_una, msk->write_seq);
> > -	if (subflow_req->remote_key_valid) {
> > +	if (opt_rx->mptcp.mp_capable) {
> > 		msk->can_ack = true;
> > -		msk->remote_key = subflow_req->remote_key;
> > +		msk->remote_key = opt_rx->mptcp.sndr_key;
> > 		mptcp_crypto_key_sha(msk->remote_key, NULL, &ack_seq);
> > 		ack_seq++;
> > 		msk->ack_seq = ack_seq;
> > diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
> > index 67448002a2d7..a2b3048037d0 100644
> > --- a/net/mptcp/protocol.h
> > +++ b/net/mptcp/protocol.h
> > @@ -206,12 +206,10 @@ struct mptcp_subflow_request_sock {
> > 	struct	tcp_request_sock sk;
> > 	u16	mp_capable : 1,
> > 		mp_join : 1,
> > -		backup : 1,
> > -		remote_key_valid : 1;
> > +		backup : 1;
> > 	u8	local_id;
> > 	u8	remote_id;
> > 	u64	local_key;
> > -	u64	remote_key;
> > 	u64	idsn;
> > 	u32	token;
> > 	u32	ssn_offset;
> > @@ -332,7 +330,9 @@ void mptcp_proto_init(void);
> > int mptcp_proto_v6_init(void);
> > #endif
> > 
> > -struct sock *mptcp_sk_clone(const struct sock *sk, struct request_sock *req);
> > +struct sock *mptcp_sk_clone(const struct sock *sk,
> > +			    const struct tcp_options_received *opt_rx,
> > +			    struct request_sock *req);
> > void mptcp_get_options(const struct sk_buff *skb,
> > 		       struct tcp_options_received *opt_rx);
> > 
> > diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> > index 10090ca3d3e0..87c094702d63 100644
> > --- a/net/mptcp/subflow.c
> > +++ b/net/mptcp/subflow.c
> > @@ -133,7 +133,6 @@ static void subflow_init_req(struct request_sock *req,
> > 
> > 	subflow_req->mp_capable = 0;
> > 	subflow_req->mp_join = 0;
> > -	subflow_req->remote_key_valid = 0;
> > 
> > #ifdef CONFIG_TCP_MD5SIG
> > 	/* no MPTCP if MD5SIG is enabled on this socket or we may run out of
> > @@ -404,6 +403,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
> > 
> > 	pr_debug("listener=%p, req=%p, conn=%p", listener, req, listener->conn);
> > 
> > +	opt_rx.mptcp.mp_capable = 0;
> > 	if (tcp_rsk(req)->is_mptcp == 0)
> > 		goto create_child;
> > 
> > @@ -418,18 +418,14 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
> > 			goto create_msk;
> > 		}
> > 
> > -		opt_rx.mptcp.mp_capable = 0;
> > 		mptcp_get_options(skb, &opt_rx);
> > -		if (opt_rx.mptcp.mp_capable) {
> > -			subflow_req->remote_key = opt_rx.mptcp.sndr_key;
> > -			subflow_req->remote_key_valid = 1;
> > -		} else {
> > +		if (!opt_rx.mptcp.mp_capable) {
> > 			fallback = true;
> > 			goto create_child;
> > 		}
> > 
> > create_msk:
> > -		new_msk = mptcp_sk_clone(listener->conn, req);
> > +		new_msk = mptcp_sk_clone(listener->conn, &opt_rx, req);
> > 		if (!new_msk)
> > 			fallback = true;
> > 	} else if (subflow_req->mp_join) {
> > @@ -473,6 +469,13 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
> > 			mptcp_pm_new_connection(mptcp_sk(new_msk), 1);
> > 			ctx->conn = new_msk;
> > 			new_msk = NULL;
> > +
> > +			/* with OoO packets we can reach here without ingress
> > +			 * mpc option
> > +			 */
> > +			ctx->remote_key = opt_rx.mptcp.sndr_key;
> > +			ctx->fully_established = opt_rx.mptcp.mp_capable;
> > +			ctx->can_ack = opt_rx.mptcp.mp_capable;
> 
> If this code is reached without an incoming mpc option, it looks like 
> ctx->remote_key gets junk off the stack. Maybe this instead?

The idea here is to avoid additional conditional. The remote_key will
be used only after 'can_ack' becomes true, and the '!can_ack' condition
here is unlikely. Overall this should be faster and safe.

Thanks for checking,

Paolo

