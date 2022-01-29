Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F474A2BA0
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 05:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352372AbiA2EhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 23:37:22 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:50572 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230242AbiA2EhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 23:37:21 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V35ExhL_1643431037;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V35ExhL_1643431037)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 29 Jan 2022 12:37:18 +0800
Date:   Sat, 29 Jan 2022 12:37:17 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, matthieu.baerts@tessares.net
Subject: Re: [PATCH v2 net-next 2/3] net/smc: Limits backlog connections
Message-ID: <YfTEfWBSCsxK0zyF@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <cover.1643380219.git.alibuda@linux.alibaba.com>
 <e22553bd881bcc3b455bad9d77b392ca3ced5c6e.1643380219.git.alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e22553bd881bcc3b455bad9d77b392ca3ced5c6e.1643380219.git.alibuda@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 10:44:37PM +0800, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> Current implementation does not handling backlog semantics, one
> potential risk is that server will be flooded by infinite amount
> connections, even if client was SMC-incapable.
> 
> This patch works to put a limit on backlog connections, referring to the
> TCP implementation, we divides SMC connections into two categories:
> 
> 1. Half SMC connection, which includes all TCP established while SMC not
> connections.
> 
> 2. Full SMC connection, which includes all SMC established connections.
> 
> For half SMC connection, since all half SMC connections starts with TCP
> established, we can achieve our goal by put a limit before TCP
> established. Refer to the implementation of TCP, this limits will based
> on not only the half SMC connections but also the full connections,
> which is also a constraint on full SMC connections.
> 
> For full SMC connections, although we know exactly where it starts, it's
> quite hard to put a limit before it. The easiest way is to block wait
> before receive SMC confirm CLC message, while it's under protection by
> smc_server_lgr_pending, a global lock, which leads this limit to the
> entire host instead of a single listen socket. Another way is to drop
> the full connections, but considering the cast of SMC connections, we
> prefer to keep full SMC connections.
> 
> Even so, the limits of full SMC connections still exists, see commits
> about half SMC connection below.
> 
> After this patch, the limits of backend connection shows like:
> 
> For SMC:
> 
> 1. Client with SMC-capability can makes 2 * backlog full SMC connections
>    or 1 * backlog half SMC connections and 1 * backlog full SMC
>    connections at most.
> 
> 2. Client without SMC-capability can only makes 1 * backlog half TCP
>    connections and 1 * backlog full TCP connections.
> 
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
> changelog:
> v2: fix compile warning
> ---
>  net/smc/af_smc.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>  net/smc/smc.h    |  4 ++++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 1b40304..66a0e64 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -73,6 +73,34 @@ static void smc_set_keepalive(struct sock *sk, int val)
>  	smc->clcsock->sk->sk_prot->keepalive(smc->clcsock->sk, val);
>  }
>  
> +static struct sock *smc_tcp_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
> +					  struct request_sock *req,
> +					  struct dst_entry *dst,
> +					  struct request_sock *req_unhash,
> +					  bool *own_req)
> +{
> +	struct smc_sock *smc;
> +
> +	smc = (struct smc_sock *)((uintptr_t)sk->sk_user_data & ~SK_USER_DATA_NOCOPY);
> +
> +	if (READ_ONCE(sk->sk_ack_backlog) + atomic_read(&smc->smc_pendings) >
> +				sk->sk_max_ack_backlog)
> +		goto drop;
> +
> +	if (sk_acceptq_is_full(&smc->sk)) {
> +		NET_INC_STATS(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
> +		goto drop;
> +	}
> +
> +	/* passthrough to origin syn recv sock fct */
> +	return smc->ori_af_ops->syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);

I am wondering if there would introduce more overhead, compared with
original implement?

> +
> +drop:
> +	dst_release(dst);
> +	tcp_listendrop(sk);
> +	return NULL;
> +}
> +
>  static struct smc_hashinfo smc_v4_hashinfo = {
>  	.lock = __RW_LOCK_UNLOCKED(smc_v4_hashinfo.lock),
>  };
> @@ -1491,6 +1519,9 @@ static void smc_listen_out(struct smc_sock *new_smc)
>  	struct smc_sock *lsmc = new_smc->listen_smc;
>  	struct sock *newsmcsk = &new_smc->sk;
>  
> +	if (tcp_sk(new_smc->clcsock->sk)->syn_smc)
> +		atomic_dec(&lsmc->smc_pendings);
> +
>  	if (lsmc->sk.sk_state == SMC_LISTEN) {
>  		lock_sock_nested(&lsmc->sk, SINGLE_DEPTH_NESTING);
>  		smc_accept_enqueue(&lsmc->sk, newsmcsk);
> @@ -2096,6 +2127,9 @@ static void smc_tcp_listen_work(struct work_struct *work)
>  		if (!new_smc)
>  			continue;
>  
> +		if (tcp_sk(new_smc->clcsock->sk)->syn_smc)
> +			atomic_inc(&lsmc->smc_pendings);
> +
>  		new_smc->listen_smc = lsmc;
>  		new_smc->use_fallback = lsmc->use_fallback;
>  		new_smc->fallback_rsn = lsmc->fallback_rsn;
> @@ -2163,6 +2197,15 @@ static int smc_listen(struct socket *sock, int backlog)
>  	smc->clcsock->sk->sk_data_ready = smc_clcsock_data_ready;
>  	smc->clcsock->sk->sk_user_data =
>  		(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
> +
> +	/* save origin ops */
> +	smc->ori_af_ops = inet_csk(smc->clcsock->sk)->icsk_af_ops;
> +
> +	smc->af_ops = *smc->ori_af_ops;
> +	smc->af_ops.syn_recv_sock = smc_tcp_syn_recv_sock;
> +
> +	inet_csk(smc->clcsock->sk)->icsk_af_ops = &smc->af_ops;

Consider to save syn_recv_sock this field only? There seems no need to
save this ops all.

Thank you,
Tony Lu
