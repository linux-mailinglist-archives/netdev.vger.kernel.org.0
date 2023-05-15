Return-Path: <netdev+bounces-2813-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0876B704142
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 01:02:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33882281484
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 23:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A93F19E55;
	Mon, 15 May 2023 23:02:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C522FB2
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 23:02:25 +0000 (UTC)
X-Greylist: delayed 566 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 May 2023 16:02:20 PDT
Received: from out-25.mta0.migadu.com (out-25.mta0.migadu.com [IPv6:2001:41d0:1004:224b::19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6857F93D8
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 16:02:19 -0700 (PDT)
Message-ID: <0e1656dc-b67c-ec65-83a4-6709fb186061@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684191171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zLnDERJHjug7dAd+MXkM+9OUfYWGgTvS8O/k3Ot60w0=;
	b=c2duEDoDOpFX+h6ODvobu6/kHvGSZpLC5E+/ZRYDkZOHnmw/vtYn+t0Q/5jJDOg1CE1bLZ
	VY60LVjZ4glLAQ2YBoIiOYzCM63HyFOchysxBfZiREgwnxEAuGt0LPy2VyBJ4F8yfA95fn
	qhmMlbfRCgnWosBFZJTP/Z+MU85xWZM=
Date: Mon, 15 May 2023 15:52:42 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v1 2/5] net/smc: allow smc to negotiate protocols
 on policies
Content-Language: en-US
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
 kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
 ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, pabeni@redhat.com,
 song@kernel.org, sdf@google.com, haoluo@google.com, yhs@fb.com,
 edumazet@google.com, john.fastabend@gmail.com, kpsingh@kernel.org,
 jolsa@kernel.org, guwen@linux.alibaba.com
References: <1683872684-64872-1-git-send-email-alibuda@linux.alibaba.com>
 <1683872684-64872-3-git-send-email-alibuda@linux.alibaba.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <1683872684-64872-3-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/11/23 11:24 PM, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> As we all know, the SMC protocol is not suitable for all scenarios,
> especially for short-lived. However, for most applications, they cannot
> guarantee that there are no such scenarios at all. Therefore, apps
> may need some specific strategies to decide shall we need to use SMC
> or not.
> 
> Just like the congestion control implementation in TCP, this patch
> provides a generic negotiator implementation. If necessary,
> we can provide different protocol negotiation strategies for
> apps based on this implementation.
> 
> But most importantly, this patch provides the possibility of
> eBPF injection, allowing users to implement their own protocol
> negotiation policy in userspace.
> 
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
>   include/net/smc.h        |  32 +++++++++++
>   net/Makefile             |   1 +
>   net/smc/Kconfig          |  11 ++++
>   net/smc/af_smc.c         | 134 ++++++++++++++++++++++++++++++++++++++++++++++-
>   net/smc/smc_negotiator.c | 119 +++++++++++++++++++++++++++++++++++++++++
>   net/smc/smc_negotiator.h | 116 ++++++++++++++++++++++++++++++++++++++++
>   6 files changed, 412 insertions(+), 1 deletion(-)
>   create mode 100644 net/smc/smc_negotiator.c
>   create mode 100644 net/smc/smc_negotiator.h
> 
> diff --git a/include/net/smc.h b/include/net/smc.h
> index 6d076f5..191061c 100644
> --- a/include/net/smc.h
> +++ b/include/net/smc.h
> @@ -296,6 +296,8 @@ struct smc_sock {				/* smc sock container */
>   	atomic_t                queued_smc_hs;  /* queued smc handshakes */
>   	struct inet_connection_sock_af_ops		af_ops;
>   	const struct inet_connection_sock_af_ops	*ori_af_ops;
> +	/* protocol negotiator ops */
> +	const struct smc_sock_negotiator_ops *negotiator_ops;
>   						/* original af ops */
>   	int			sockopt_defer_accept;
>   						/* sockopt TCP_DEFER_ACCEPT
> @@ -316,4 +318,34 @@ struct smc_sock {				/* smc sock container */
>   						 */
>   };
>   
> +#ifdef CONFIG_SMC_BPF
> +/* BPF struct ops for smc protocol negotiator */
> +struct smc_sock_negotiator_ops {
> +
> +	struct list_head	list;
> +
> +	/* ops name */
> +	char		name[16];
> +	/* key for name */
> +	u32			key;
> +
> +	/* init with sk */
> +	void (*init)(struct sock *sk);
> +
> +	/* release with sk */
> +	void (*release)(struct sock *sk);
> +
> +	/* advice for negotiate */
> +	int (*negotiate)(struct sock *sk);
> +
> +	/* info gathering timing */
> +	void (*collect_info)(struct sock *sk, int timing);
> +
> +	/* module owner */
> +	struct module *owner;
> +};
> +#else
> +struct smc_sock_negotiator_ops {};
> +#endif
> +
>   #endif	/* _SMC_H */
> diff --git a/net/Makefile b/net/Makefile
> index 4c4dc53..222916a 100644
> --- a/net/Makefile
> +++ b/net/Makefile
> @@ -52,6 +52,7 @@ obj-$(CONFIG_TIPC)		+= tipc/
>   obj-$(CONFIG_NETLABEL)		+= netlabel/
>   obj-$(CONFIG_IUCV)		+= iucv/
>   obj-$(CONFIG_SMC)		+= smc/
> +obj-$(CONFIG_SMC_BPF)		+= smc/smc_negotiator.o >   obj-$(CONFIG_RFKILL)		+= rfkill/
>   obj-$(CONFIG_NET_9P)		+= 9p/
>   obj-$(CONFIG_CAIF)		+= caif/
> diff --git a/net/smc/Kconfig b/net/smc/Kconfig
> index 1ab3c5a..bdcc9f1 100644
> --- a/net/smc/Kconfig
> +++ b/net/smc/Kconfig
> @@ -19,3 +19,14 @@ config SMC_DIAG
>   	  smcss.
>   
>   	  if unsure, say Y.
> +
> +config SMC_BPF
> +	bool "SMC: support eBPF" if SMC


so smc_negotiator will always be in the kernel image even af_smc is compiled as 
a module? If the SMC_BPF needs to support af_smc as a module, proper 
implementation needs to be added to bpf_struct_ops to support module first. It 
is work-in-progress.

> +	depends on BPF_SYSCALL
> +	default n
> +	help
> +	  Supports eBPF to allows user mode participation in SMC's protocol process
> +	  via ebpf programs. Alternatively, obtain information about the SMC socks
> +	  through the ebpf program.
> +
> +	  If unsure, say N.
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 50c38b6..7406fd4 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -52,6 +52,7 @@
>   #include "smc_close.h"
>   #include "smc_stats.h"
>   #include "smc_tracepoint.h"
> +#include "smc_negotiator.h"
>   #include "smc_sysctl.h"
>   
>   static DEFINE_MUTEX(smc_server_lgr_pending);	/* serialize link group
> @@ -68,6 +69,119 @@
>   static void smc_tcp_listen_work(struct work_struct *);
>   static void smc_connect_work(struct work_struct *);
>   
> +#ifdef CONFIG_SMC_BPF
> +
> +/* Check if sock should use smc */
> +int smc_sock_should_select_smc(const struct smc_sock *smc)
> +{
> +	const struct smc_sock_negotiator_ops *ops;
> +	int ret;
> +
> +	rcu_read_lock();
> +	ops = READ_ONCE(smc->negotiator_ops);
> +
> +	/* No negotiator_ops supply or no negotiate func set,
> +	 * always pass it.
> +	 */
> +	if (!ops || !ops->negotiate) {

A smc_sock_negotiator_ops without ->negotiate? Is it useful at all to allow the 
register in the first place?

> +		rcu_read_unlock();
> +		return SK_PASS;
> +	}
> +
> +	ret = ops->negotiate((struct sock *)&smc->sk);
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
> +void smc_sock_perform_collecting_info(const struct smc_sock *smc, int timing)
> +{
> +	const struct smc_sock_negotiator_ops *ops;
> +
> +	rcu_read_lock();
> +	ops = READ_ONCE(smc->negotiator_ops);
> +
> +	if (!ops || !ops->collect_info) {
> +		rcu_read_unlock();
> +		return;
> +	}
> +
> +	ops->collect_info((struct sock *)&smc->sk, timing);
> +	rcu_read_unlock();
> +}
> +
> +int smc_sock_assign_negotiator_ops(struct smc_sock *smc, const char *name)
> +{
> +	struct smc_sock_negotiator_ops *ops;
> +	int ret = -EINVAL;
> +
> +	/* already set */
> +	if (READ_ONCE(smc->negotiator_ops))
> +		smc_sock_cleanup_negotiator_ops(smc, /* might be still referenced */ false);
> +
> +	/* Just for clear negotiator_ops */
> +	if (!name || !strlen(name))
> +		return 0;
> +
> +	rcu_read_lock();
> +	ops = smc_negotiator_ops_get_by_name(name);
> +	if (likely(ops)) {
> +		if (unlikely(!bpf_try_module_get(ops, ops->owner))) {
> +			ret = -EACCES;
> +		} else {
> +			WRITE_ONCE(smc->negotiator_ops, ops);
> +			/* make sure ops can be seen */
> +			smp_wmb();

This rcu_read_lock(), WRITE_ONCE, and smp_wmb() combo looks very suspicious. 
smc->negotiator_ops is protected by rcu (+refcnt) or lock_sock()?

I am going to stop reviewing here.

> +			if (ops->init)
> +				ops->init(&smc->sk);
> +			ret = 0;
> +		}
> +	}
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
> +void smc_sock_cleanup_negotiator_ops(struct smc_sock *smc, bool no_more)
> +{
> +	const struct smc_sock_negotiator_ops *ops;
> +
> +	ops = READ_ONCE(smc->negotiator_ops);
> +
> +	/* not all smc sock has negotiator_ops */
> +	if (!ops)
> +		return;
> +
> +	might_sleep();
> +
> +	/* Just ensure data integrity */
> +	WRITE_ONCE(smc->negotiator_ops, NULL);
> +	/* make sure NULL can be seen */
> +	smp_wmb();
> +	/* if the socks may have references to the negotiator ops to be removed.
> +	 * it means that we might need to wait for the readers of ops
> +	 * to complete. It's slow though.
> +	 */
> +	if (unlikely(!no_more))
> +		synchronize_rcu();
> +	if (ops->release)
> +		ops->release(&smc->sk);
> +	bpf_module_put(ops, ops->owner);
> +}
> +
> +void smc_sock_clone_negotiator_ops(struct sock *parent, struct sock *child)
> +{
> +	const struct smc_sock_negotiator_ops *ops;
> +
> +	rcu_read_lock();
> +	ops = READ_ONCE(smc_sk(parent)->negotiator_ops);
> +	if (ops && bpf_try_module_get(ops, ops->owner)) {
> +		smc_sk(child)->negotiator_ops = ops;
> +		if (ops->init)
> +			ops->init(child);
> +	}
> +	rcu_read_unlock();
> +}
> +#endif
> +
>   int smc_nl_dump_hs_limitation(struct sk_buff *skb, struct netlink_callback *cb)
>   {
>   	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
> @@ -166,6 +280,9 @@ static bool smc_hs_congested(const struct sock *sk)
>   	if (workqueue_congested(WORK_CPU_UNBOUND, smc_hs_wq))
>   		return true;
>   
> +	if (!smc_sock_should_select_smc(smc))
> +		return true;
> +
>   	return false;
>   }
>   
> @@ -320,6 +437,9 @@ static int smc_release(struct socket *sock)
>   	sock_hold(sk); /* sock_put below */
>   	smc = smc_sk(sk);
>   
> +	/* trigger info gathering if needed.*/
> +	smc_sock_perform_collecting_info(smc, SMC_SOCK_CLOSED_TIMING);
> +
>   	old_state = sk->sk_state;
>   
>   	/* cleanup for a dangling non-blocking connect */
> @@ -356,6 +476,9 @@ static int smc_release(struct socket *sock)
>   
>   static void smc_destruct(struct sock *sk)
>   {
> +	/* cleanup negotiator_ops if set */
> +	smc_sock_cleanup_negotiator_ops(smc_sk(sk), /* no longer used */ true);
> +
>   	if (sk->sk_state != SMC_CLOSED)
>   		return;
>   	if (!sock_flag(sk, SOCK_DEAD))
> @@ -1627,7 +1750,14 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
>   	}
>   
>   	smc_copy_sock_settings_to_clc(smc);
> -	tcp_sk(smc->clcsock->sk)->syn_smc = 1;
> +	/* accept out connection as SMC connection */
> +	if (smc_sock_should_select_smc(smc) == SK_PASS) {
> +		tcp_sk(smc->clcsock->sk)->syn_smc = 1;
> +	} else {
> +		tcp_sk(smc->clcsock->sk)->syn_smc = 0;
> +		smc_switch_to_fallback(smc, /* active fallback */ 0);
> +	}
> +
>   	if (smc->connect_nonblock) {
>   		rc = -EALREADY;
>   		goto out;
> @@ -1679,6 +1809,8 @@ static int smc_clcsock_accept(struct smc_sock *lsmc, struct smc_sock **new_smc)
>   	}
>   	*new_smc = smc_sk(new_sk);
>   
> +	smc_sock_clone_negotiator_ops(lsk, new_sk);
> +
>   	mutex_lock(&lsmc->clcsock_release_lock);
>   	if (lsmc->clcsock)
>   		rc = kernel_accept(lsmc->clcsock, &new_clcsock, SOCK_NONBLOCK);



