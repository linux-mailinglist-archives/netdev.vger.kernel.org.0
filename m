Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBDE1B16A3
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 22:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgDTUFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 16:05:43 -0400
Received: from mga04.intel.com ([192.55.52.120]:5555 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725918AbgDTUFn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 16:05:43 -0400
IronPort-SDR: c5uFNaCvkXW5kZ6chk2njoMUSb1IJgV+DlHimWciJbLP9RvopFAoePGK/ldmtE6v7lEJifySVy
 jfxRLyQfKTBQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 13:05:39 -0700
IronPort-SDR: 4RIdgRIZeMuNZ69C1wzMNay6G2NDMzz/yFB43K0u3RWOwywYoBtITsrL2EwktZyFnSTCZ4nIdi
 nmAPYvll0hjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="245471641"
Received: from chall-mobl1.amr.corp.intel.com ([10.255.231.110])
  by fmsmga007.fm.intel.com with ESMTP; 20 Apr 2020 13:05:38 -0700
Date:   Mon, 20 Apr 2020 13:05:37 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@chall-mobl1.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net 3/3] mptcp: drop req socket remote_key* fields
In-Reply-To: <0fc5ffc1b598e18e6c488331b0a756e45205f64b.1587389294.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.22.394.2004201254570.98347@chall-mobl1.amr.corp.intel.com>
References: <cover.1587389294.git.pabeni@redhat.com> <0fc5ffc1b598e18e6c488331b0a756e45205f64b.1587389294.git.pabeni@redhat.com>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, 20 Apr 2020, Paolo Abeni wrote:

> We don't need them, as we can use the current ingress opt
> data instead. Setting them in syn_recv_sock() may causes
> inconsistent mptcp socket status, as per previous commit.
>
> Fixes: cc7972ea1932 ("mptcp: parse and emit MP_CAPABLE option according to v1 spec")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c |  8 +++++---
> net/mptcp/protocol.h |  8 ++++----
> net/mptcp/subflow.c  | 20 ++++++++++----------
> 3 files changed, 19 insertions(+), 17 deletions(-)
>
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index d275c1e827fe..58ad03fc1bbc 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -1345,7 +1345,9 @@ static struct ipv6_pinfo *mptcp_inet6_sk(const struct sock *sk)
> }
> #endif
>
> -struct sock *mptcp_sk_clone(const struct sock *sk, struct request_sock *req)
> +struct sock *mptcp_sk_clone(const struct sock *sk,
> +			    const struct tcp_options_received *opt_rx,
> +			    struct request_sock *req)
> {
> 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
> 	struct sock *nsk = sk_clone_lock(sk, GFP_ATOMIC);
> @@ -1383,9 +1385,9 @@ struct sock *mptcp_sk_clone(const struct sock *sk, struct request_sock *req)
>
> 	msk->write_seq = subflow_req->idsn + 1;
> 	atomic64_set(&msk->snd_una, msk->write_seq);
> -	if (subflow_req->remote_key_valid) {
> +	if (opt_rx->mptcp.mp_capable) {
> 		msk->can_ack = true;
> -		msk->remote_key = subflow_req->remote_key;
> +		msk->remote_key = opt_rx->mptcp.sndr_key;
> 		mptcp_crypto_key_sha(msk->remote_key, NULL, &ack_seq);
> 		ack_seq++;
> 		msk->ack_seq = ack_seq;
> diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
> index 67448002a2d7..a2b3048037d0 100644
> --- a/net/mptcp/protocol.h
> +++ b/net/mptcp/protocol.h
> @@ -206,12 +206,10 @@ struct mptcp_subflow_request_sock {
> 	struct	tcp_request_sock sk;
> 	u16	mp_capable : 1,
> 		mp_join : 1,
> -		backup : 1,
> -		remote_key_valid : 1;
> +		backup : 1;
> 	u8	local_id;
> 	u8	remote_id;
> 	u64	local_key;
> -	u64	remote_key;
> 	u64	idsn;
> 	u32	token;
> 	u32	ssn_offset;
> @@ -332,7 +330,9 @@ void mptcp_proto_init(void);
> int mptcp_proto_v6_init(void);
> #endif
>
> -struct sock *mptcp_sk_clone(const struct sock *sk, struct request_sock *req);
> +struct sock *mptcp_sk_clone(const struct sock *sk,
> +			    const struct tcp_options_received *opt_rx,
> +			    struct request_sock *req);
> void mptcp_get_options(const struct sk_buff *skb,
> 		       struct tcp_options_received *opt_rx);
>
> diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> index 10090ca3d3e0..87c094702d63 100644
> --- a/net/mptcp/subflow.c
> +++ b/net/mptcp/subflow.c
> @@ -133,7 +133,6 @@ static void subflow_init_req(struct request_sock *req,
>
> 	subflow_req->mp_capable = 0;
> 	subflow_req->mp_join = 0;
> -	subflow_req->remote_key_valid = 0;
>
> #ifdef CONFIG_TCP_MD5SIG
> 	/* no MPTCP if MD5SIG is enabled on this socket or we may run out of
> @@ -404,6 +403,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
>
> 	pr_debug("listener=%p, req=%p, conn=%p", listener, req, listener->conn);
>
> +	opt_rx.mptcp.mp_capable = 0;
> 	if (tcp_rsk(req)->is_mptcp == 0)
> 		goto create_child;
>
> @@ -418,18 +418,14 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
> 			goto create_msk;
> 		}
>
> -		opt_rx.mptcp.mp_capable = 0;
> 		mptcp_get_options(skb, &opt_rx);
> -		if (opt_rx.mptcp.mp_capable) {
> -			subflow_req->remote_key = opt_rx.mptcp.sndr_key;
> -			subflow_req->remote_key_valid = 1;
> -		} else {
> +		if (!opt_rx.mptcp.mp_capable) {
> 			fallback = true;
> 			goto create_child;
> 		}
>
> create_msk:
> -		new_msk = mptcp_sk_clone(listener->conn, req);
> +		new_msk = mptcp_sk_clone(listener->conn, &opt_rx, req);
> 		if (!new_msk)
> 			fallback = true;
> 	} else if (subflow_req->mp_join) {
> @@ -473,6 +469,13 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
> 			mptcp_pm_new_connection(mptcp_sk(new_msk), 1);
> 			ctx->conn = new_msk;
> 			new_msk = NULL;
> +
> +			/* with OoO packets we can reach here without ingress
> +			 * mpc option
> +			 */
> +			ctx->remote_key = opt_rx.mptcp.sndr_key;
> +			ctx->fully_established = opt_rx.mptcp.mp_capable;
> +			ctx->can_ack = opt_rx.mptcp.mp_capable;

If this code is reached without an incoming mpc option, it looks like 
ctx->remote_key gets junk off the stack. Maybe this instead?

+			if (opt_rx.mptcp.mp_capable) {
+				ctx->remote_key = opt_rx.mptcp.sndr_key;
+				ctx->fully_established = 1;
+				ctx->can_ack = 1;
+			}


Mat

> 		} else if (ctx->mp_join) {
> 			struct mptcp_sock *owner;
>
> @@ -1152,9 +1155,6 @@ static void subflow_ulp_clone(const struct request_sock *req,
> 		 * is fully established only after we receive the remote key
> 		 */
> 		new_ctx->mp_capable = 1;
> -		new_ctx->fully_established = subflow_req->remote_key_valid;
> -		new_ctx->can_ack = subflow_req->remote_key_valid;
> -		new_ctx->remote_key = subflow_req->remote_key;
> 		new_ctx->local_key = subflow_req->local_key;
> 		new_ctx->token = subflow_req->token;
> 		new_ctx->ssn_offset = subflow_req->ssn_offset;
> -- 
> 2.21.1
>
>

--
Mat Martineau
Intel
