Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA006466F30
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 02:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377971AbhLCBnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 20:43:18 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:53613 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377968AbhLCBnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 20:43:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1638495594; x=1670031594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SC5WLpsetFc9SNsXuO1/rAy94miJ/5ojJLIk+X43Ttc=;
  b=tiqVk/z+WUUKYxD2fzQEmDy+3quPlhSl6g/ohiNQwUJgwYjA3YO9fT3e
   1crnTew632T0XAr1pz3r8jmuKUUvbxc/M+N8uB1WqlXb1eQ1fZCJ5hlAp
   RmoV0zVn33nzmnMRs4T3f5H1x/sN06Q7owwOs4zMKn5VOaatgfXX1NOGt
   4=;
X-IronPort-AV: E=Sophos;i="5.87,283,1631577600"; 
   d="scan'208";a="156333486"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 03 Dec 2021 01:39:52 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com (Postfix) with ESMTPS id F069941FC6;
        Fri,  3 Dec 2021 01:39:52 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Fri, 3 Dec 2021 01:39:52 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.59) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Fri, 3 Dec 2021 01:39:48 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <bigeasy@linutronix.de>
CC:     <eric.dumazet@gmail.com>, <kafai@fb.com>, <davem@davemloft.net>,
        <dsahern@kernel.org>, <efault@gmx.de>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <tglx@linutronix.de>,
        <yoshfuji@linux-ipv6.org>, Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Subject: Re: [PATCH net-next] tcp: Don't acquire inet_listen_hashbucket::lock with disabled BH.
Date:   Fri, 3 Dec 2021 10:39:34 +0900
Message-ID: <20211203013934.20645-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211130142302.ikcnjgo2xlbxbbl3@linutronix.de>
References: <20211130142302.ikcnjgo2xlbxbbl3@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.59]
X-ClientProxiedBy: EX13D49UWB001.ant.amazon.com (10.43.163.72) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date:   Tue, 30 Nov 2021 15:23:02 +0100
> Commit
>    9652dc2eb9e40 ("tcp: relax listening_hash operations")
> 
> removed the need to disable bottom half while acquiring
> listening_hash.lock. There are still two callers left which disable
> bottom half before the lock is acquired.
> 
> On PREEMPT_RT the softirqs are preemptible and local_bh_disable() acts
> as a lock to ensure that resources, that are protected by disabling
> bottom halves, remain protected.
> This leads to a circular locking dependency if the lock acquired with
> disabled bottom halves is also acquired with enabled bottom halves
> followed by disabling bottom halves. This is the reverse locking order.
> It has been observed with inet_listen_hashbucket::lock:
> 
> local_bh_disable() + spin_lock(&ilb->lock):
>   inet_listen()
>     inet_csk_listen_start()
>       sk->sk_prot->hash() := inet_hash()
> 	local_bh_disable()
> 	__inet_hash()
> 	  spin_lock(&ilb->lock);
> 	    acquire(&ilb->lock);
> 
> Reverse order: spin_lock(&ilb->lock) + local_bh_disable():
>   tcp_seq_next()
>     listening_get_next()
>       spin_lock(&ilb->lock);
> 	acquire(&ilb->lock);
> 
>   tcp4_seq_show()
>     get_tcp4_sock()
>       sock_i_ino()
> 	read_lock_bh(&sk->sk_callback_lock);
> 	  acquire(softirq_ctrl)	// <---- whoops
> 	  acquire(&sk->sk_callback_lock)
> 
> Drop local_bh_disable() around __inet_hash() which acquires
> listening_hash->lock. Split inet_unhash() and acquire the
> listen_hashbucket lock without disabling bottom halves; the inet_ehash
> lock with disabled bottom halves.
> 
> Reported-by: Mike Galbraith <efault@gmx.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Link: https://lkml.kernel.org/r/12d6f9879a97cd56c09fb53dee343cbb14f7f1f7.camel@gmx.de
> Link: https://lkml.kernel.org/r/X9CheYjuXWc75Spa@hirez.programming.kicks-ass.net

I think this patch is for the net tree and needs a Fixes: tag of the commit
mentioned in the description.
The patch itself looks good to me.

Acked-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

Also, added Eric and Martin on CC.


> ---
>  net/ipv4/inet_hashtables.c  | 53 ++++++++++++++++++++++---------------
>  net/ipv6/inet6_hashtables.c |  5 +---
>  2 files changed, 33 insertions(+), 25 deletions(-)
> 
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 75737267746f8..7bd1e10086f0a 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -637,7 +637,9 @@ int __inet_hash(struct sock *sk, struct sock *osk)
>  	int err = 0;
>  
>  	if (sk->sk_state != TCP_LISTEN) {
> +		local_bh_disable();
>  		inet_ehash_nolisten(sk, osk, NULL);
> +		local_bh_enable();
>  		return 0;
>  	}
>  	WARN_ON(!sk_unhashed(sk));
> @@ -669,45 +671,54 @@ int inet_hash(struct sock *sk)
>  {
>  	int err = 0;
>  
> -	if (sk->sk_state != TCP_CLOSE) {
> -		local_bh_disable();
> +	if (sk->sk_state != TCP_CLOSE)
>  		err = __inet_hash(sk, NULL);
> -		local_bh_enable();
> -	}
>  
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(inet_hash);
>  
> -void inet_unhash(struct sock *sk)
> +static void __inet_unhash(struct sock *sk, struct inet_listen_hashbucket *ilb)
>  {
> -	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
> -	struct inet_listen_hashbucket *ilb = NULL;
> -	spinlock_t *lock;
> -
>  	if (sk_unhashed(sk))
>  		return;
>  
> -	if (sk->sk_state == TCP_LISTEN) {
> -		ilb = &hashinfo->listening_hash[inet_sk_listen_hashfn(sk)];
> -		lock = &ilb->lock;
> -	} else {
> -		lock = inet_ehash_lockp(hashinfo, sk->sk_hash);
> -	}
> -	spin_lock_bh(lock);
> -	if (sk_unhashed(sk))
> -		goto unlock;
> -
>  	if (rcu_access_pointer(sk->sk_reuseport_cb))
>  		reuseport_stop_listen_sock(sk);
>  	if (ilb) {
> +		struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
> +
>  		inet_unhash2(hashinfo, sk);
>  		ilb->count--;
>  	}
>  	__sk_nulls_del_node_init_rcu(sk);
>  	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
> -unlock:
> -	spin_unlock_bh(lock);
> +}
> +
> +void inet_unhash(struct sock *sk)
> +{
> +	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
> +
> +	if (sk_unhashed(sk))
> +		return;
> +
> +	if (sk->sk_state == TCP_LISTEN) {
> +		struct inet_listen_hashbucket *ilb;
> +
> +		ilb = &hashinfo->listening_hash[inet_sk_listen_hashfn(sk)];
> +		/* Don't disable bottom halves while acquiring the lock to
> +		 * avoid circular locking dependency on PREEMPT_RT.
> +		 */
> +		spin_lock(&ilb->lock);
> +		__inet_unhash(sk, ilb);
> +		spin_unlock(&ilb->lock);
> +	} else {
> +		spinlock_t *lock = inet_ehash_lockp(hashinfo, sk->sk_hash);
> +
> +		spin_lock_bh(lock);
> +		__inet_unhash(sk, NULL);
> +		spin_unlock_bh(lock);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(inet_unhash);
>  
> diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
> index 67c9114835c84..0a2e7f2283911 100644
> --- a/net/ipv6/inet6_hashtables.c
> +++ b/net/ipv6/inet6_hashtables.c
> @@ -333,11 +333,8 @@ int inet6_hash(struct sock *sk)
>  {
>  	int err = 0;
>  
> -	if (sk->sk_state != TCP_CLOSE) {
> -		local_bh_disable();
> +	if (sk->sk_state != TCP_CLOSE)
>  		err = __inet_hash(sk, NULL);
> -		local_bh_enable();
> -	}
>  
>  	return err;
>  }
> -- 
> 2.34.1
> 
