Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0D625EF6B
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 19:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgIFR5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 13:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbgIFR47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 13:56:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9700920639;
        Sun,  6 Sep 2020 17:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599415018;
        bh=0UX6GFlMtxv4vY+KdQ983Bbz1HpLcwbFRVFKEmpIJu8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KuRxEZ5pNwtx2JCWumo3dEfAB7LLU6TU+tSdeB4FCAU/lvd7sJnxFG0gcthIWPKw+
         B0Uj3f1JTzqny36CfNKZkfrG9To13fUhexeom84a1wt+6vKuuh5wl0iTDdNrbQEq7v
         zt+DJQI1PVv0HDSZMJsj/86T9ikx8WWZ0gxa2E3k=
Date:   Sun, 6 Sep 2020 10:56:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>
Cc:     ying.xue@windriver.com, netdev@vger.kernel.org, jmaloy@redhat.com,
        maloy@donjonn.com,
        syzbot+d5aa7e0385f6a5d0f4fd@syzkaller.appspotmail.com
Subject: Re: [net-next] tipc: fix a deadlock when flushing scheduled work
Message-ID: <20200906105656.0e997c96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200905044518.3282-1-hoang.h.le@dektech.com.au>
References: <20200905044518.3282-1-hoang.h.le@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Sep 2020 11:45:18 +0700 Hoang Huu Le wrote:
> In the commit fdeba99b1e58
> ("tipc: fix use-after-free in tipc_bcast_get_mode"), we're trying
> to make sure the tipc_net_finalize_work work item finished if it
> enqueued. But calling flush_scheduled_work() is not just affecting
> above work item but either any scheduled work. This has turned out
> to be overkill and caused to deadlock as syzbot reported:
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 5.9.0-rc2-next-20200828-syzkaller #0 Not tainted
> ------------------------------------------------------
> kworker/u4:6/349 is trying to acquire lock:
> ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: flush_workqueue+0xe1/0x13e0 kernel/workqueue.c:2777
> 
> but task is already holding lock:
> ffffffff8a879430 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xb10 net/core/net_namespace.c:565
> 
> [...]
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(pernet_ops_rwsem);
>                                lock(&sb->s_type->i_mutex_key#13);
>                                lock(pernet_ops_rwsem);
>   lock((wq_completion)events);
> 
>  *** DEADLOCK ***
> [...]
> 
> To fix the original issue, we replace above calling by introducing
> a bit flag. When a namespace cleaned-up, bit flag is set to zero and:
> - tipc_net_finalize functionial just does return immediately.
> - tipc_net_finalize_work does not enqueue into the scheduled work queue.

Is struct tipc_net not going to be freed right after tipc_exit_net()
returns? In that case you'd be back to UAF if the flag is in this
structure.

> @@ -110,10 +111,6 @@ static void __net_exit tipc_exit_net(struct net *net)
>  	tipc_detach_loopback(net);
>  	tipc_net_stop(net);
>  
> -	/* Make sure the tipc_net_finalize_work stopped
> -	 * before releasing the resources.
> -	 */
> -	flush_scheduled_work();
>  	tipc_bcast_stop(net);
>  	tipc_nametbl_stop(net);
>  	tipc_sk_rht_destroy(net);
> @@ -124,6 +121,9 @@ static void __net_exit tipc_exit_net(struct net *net)
>  
>  static void __net_exit tipc_pernet_pre_exit(struct net *net)
>  {
> +	struct tipc_net *tn = tipc_net(net);
> +
> +	clear_bit_unlock(0, &tn->net_exit_flag);
>  	tipc_node_pre_cleanup_net(net);
>  }
>  
> diff --git a/net/tipc/core.h b/net/tipc/core.h
> index 631d83c9705f..aa75882dd932 100644
> --- a/net/tipc/core.h
> +++ b/net/tipc/core.h
> @@ -143,6 +143,7 @@ struct tipc_net {
>  	/* TX crypto handler */
>  	struct tipc_crypto *crypto_tx;
>  #endif
> +	unsigned long net_exit_flag;
>  };
>  
>  static inline struct tipc_net *tipc_net(struct net *net)
> diff --git a/net/tipc/net.c b/net/tipc/net.c
> index 85400e4242de..8ad5b9ad89c0 100644
> --- a/net/tipc/net.c
> +++ b/net/tipc/net.c
> @@ -132,6 +132,9 @@ static void tipc_net_finalize(struct net *net, u32 addr)
>  {
>  	struct tipc_net *tn = tipc_net(net);
>  
> +	if (unlikely(!test_bit(0, &tn->net_exit_flag)))
> +		return;
> +
>  	if (cmpxchg(&tn->node_addr, 0, addr))
>  		return;
>  	tipc_set_node_addr(net, addr);
> @@ -153,8 +156,13 @@ static void tipc_net_finalize_work(struct work_struct *work)
>  
>  void tipc_sched_net_finalize(struct net *net, u32 addr)
>  {
> -	struct tipc_net_work *fwork = kzalloc(sizeof(*fwork), GFP_ATOMIC);
> +	struct tipc_net *tn = tipc_net(net);
> +	struct tipc_net_work *fwork;
> +
> +	if (unlikely(!test_bit(0, &tn->net_exit_flag)))
> +		return;
>  
> +	fwork = kzalloc(sizeof(*fwork), GFP_ATOMIC);
>  	if (!fwork)
>  		return;
>  	INIT_WORK(&fwork->work, tipc_net_finalize_work);

