Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18EC92CA707
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 16:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391811AbgLAP0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 10:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390228AbgLAP0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 10:26:36 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4175C0613CF;
        Tue,  1 Dec 2020 07:25:55 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id k10so3727757wmi.3;
        Tue, 01 Dec 2020 07:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o2f46KUtKqf0AVXOs4jIM/L2suSdbEJEXaZ7rYGN1Qk=;
        b=NwSDRZP3EYEGMw8XPZpRFXbV+phNke39cl+3jMt2lQTWSCLcPELpgYGctIDtcy3LUu
         GRKAmOXsfaZsLkll0kGczMftUtvORfSgvTyO1rRpg2ahdYIyqkzSo0Xw64bHqJd1vtv5
         fJlvaja6b08e8aFsfC+NJjjRlsOvLqYhuNGz9GOPfnz3342KVGiJEc/E4iG4x+6Sfvl7
         ogrsw7oYZlC2M370aVkK2VUIhF00VOQq/XarHyhIH8Sydj3WOny4ujo6JNTqGlYjgbGH
         7jCTYY6R0MMDxS1UpIdlMFxICvGefGsWQTRTTCP+URtJ61LkC6pXXhU9rMTG0JzF7f3t
         WmXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o2f46KUtKqf0AVXOs4jIM/L2suSdbEJEXaZ7rYGN1Qk=;
        b=fUy2c+S2aHBqyiRb/om9uBPbqASK2jnBqnob0i3XcJ741BMRwTJVg+54M2VQrAW0W7
         wMHLrmVtgx6RyyBoqWRe0pAhX3w7F8zmcVZmkaklLUm94mZgtWWZLXbAeAZ8tLltK79t
         u9//pwOfPkQn1W7xpbW6EA7/5m+/jDO4d9cGBs2jUTpVo0bVyagKgsJltp9nOoZzjIzY
         h0szNnh8yBOxB1SVk2pd8xSvIuZCbgU7LzRbtlAN6s4e4wUcAct56tGRydypRICfCZYV
         UFblJbSB24cwlDA9g5Fb9aLdddbGoow42Y0Js4bs/9w1kd8TPYGIImJW1o6knSbLXsHJ
         lL/g==
X-Gm-Message-State: AOAM532xH8M+9GRHRSTzY+TM6w9RpsMVYK775h6UCBB5UeQ+lW5PxLpo
        YZJf4u9N+6zumT/P2xRMJbmf5XY7SO4=
X-Google-Smtp-Source: ABdhPJxeYd3AYZJs+3zaG9ZMVLzD/mZpdwnyVq7ExagUsN7zxzao+nr6pTdebphUtZyBIxdI0gof4A==
X-Received: by 2002:a7b:c05a:: with SMTP id u26mr3195889wmc.159.1606836354001;
        Tue, 01 Dec 2020 07:25:54 -0800 (PST)
Received: from [192.168.8.116] ([37.165.175.127])
        by smtp.gmail.com with ESMTPSA id u12sm264740wmu.28.2020.12.01.07.25.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Dec 2020 07:25:53 -0800 (PST)
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate
 TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        osa-contribution-log@amazon.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201201144418.35045-1-kuniyu@amazon.co.jp>
 <20201201144418.35045-4-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e47b903d-6e7c-a2a7-ccdf-d2c701986d4f@gmail.com>
Date:   Tue, 1 Dec 2020 16:25:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201201144418.35045-4-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/1/20 3:44 PM, Kuniyuki Iwashima wrote:
> This patch lets reuseport_detach_sock() return a pointer of struct sock,
> which is used only by inet_unhash(). If it is not NULL,
> inet_csk_reqsk_queue_migrate() migrates TCP_ESTABLISHED/TCP_SYN_RECV
> sockets from the closing listener to the selected one.
> 
> Listening sockets hold incoming connections as a linked list of struct
> request_sock in the accept queue, and each request has reference to a full
> socket and its listener. In inet_csk_reqsk_queue_migrate(), we only unlink
> the requests from the closing listener's queue and relink them to the head
> of the new listener's queue. We do not process each request and its
> reference to the listener, so the migration completes in O(1) time
> complexity. However, in the case of TCP_SYN_RECV sockets, we take special
> care in the next commit.
> 
> By default, the kernel selects a new listener randomly. In order to pick
> out a different socket every time, we select the last element of socks[] as
> the new listener. This behaviour is based on how the kernel moves sockets
> in socks[]. (See also [1])
> 
> Basically, in order to redistribute sockets evenly, we have to use an eBPF
> program called in the later commit, but as the side effect of such default
> selection, the kernel can redistribute old requests evenly to new listeners
> for a specific case where the application replaces listeners by
> generations.
> 
> For example, we call listen() for four sockets (A, B, C, D), and close the
> first two by turns. The sockets move in socks[] like below.
> 
>   socks[0] : A <-.      socks[0] : D          socks[0] : D
>   socks[1] : B   |  =>  socks[1] : B <-.  =>  socks[1] : C
>   socks[2] : C   |      socks[2] : C --'
>   socks[3] : D --'
> 
> Then, if C and D have newer settings than A and B, and each socket has a
> request (a, b, c, d) in their accept queue, we can redistribute old
> requests evenly to new listeners.
> 
>   socks[0] : A (a) <-.      socks[0] : D (a + d)      socks[0] : D (a + d)
>   socks[1] : B (b)   |  =>  socks[1] : B (b) <-.  =>  socks[1] : C (b + c)
>   socks[2] : C (c)   |      socks[2] : C (c) --'
>   socks[3] : D (d) --'
> 
> Here, (A, D) or (B, C) can have different application settings, but they
> MUST have the same settings at the socket API level; otherwise, unexpected
> error may happen. For instance, if only the new listeners have
> TCP_SAVE_SYN, old requests do not have SYN data, so the application will
> face inconsistency and cause an error.
> 
> Therefore, if there are different kinds of sockets, we must attach an eBPF
> program described in later commits.
> 
> Link: https://lore.kernel.org/netdev/CAEfhGiyG8Y_amDZ2C8dQoQqjZJMHjTY76b=KBkTKcBtA=dhdGQ@mail.gmail.com/
> Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  include/net/inet_connection_sock.h |  1 +
>  include/net/sock_reuseport.h       |  2 +-
>  net/core/sock_reuseport.c          | 10 +++++++++-
>  net/ipv4/inet_connection_sock.c    | 30 ++++++++++++++++++++++++++++++
>  net/ipv4/inet_hashtables.c         |  9 +++++++--
>  5 files changed, 48 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> index 7338b3865a2a..2ea2d743f8fc 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -260,6 +260,7 @@ struct dst_entry *inet_csk_route_child_sock(const struct sock *sk,
>  struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
>  				      struct request_sock *req,
>  				      struct sock *child);
> +void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk);
>  void inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
>  				   unsigned long timeout);
>  struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
> diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> index 0e558ca7afbf..09a1b1539d4c 100644
> --- a/include/net/sock_reuseport.h
> +++ b/include/net/sock_reuseport.h
> @@ -31,7 +31,7 @@ struct sock_reuseport {
>  extern int reuseport_alloc(struct sock *sk, bool bind_inany);
>  extern int reuseport_add_sock(struct sock *sk, struct sock *sk2,
>  			      bool bind_inany);
> -extern void reuseport_detach_sock(struct sock *sk);
> +extern struct sock *reuseport_detach_sock(struct sock *sk);
>  extern struct sock *reuseport_select_sock(struct sock *sk,
>  					  u32 hash,
>  					  struct sk_buff *skb,
> diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> index fd133516ac0e..60d7c1f28809 100644
> --- a/net/core/sock_reuseport.c
> +++ b/net/core/sock_reuseport.c
> @@ -216,9 +216,11 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
>  }
>  EXPORT_SYMBOL(reuseport_add_sock);
>  
> -void reuseport_detach_sock(struct sock *sk)
> +struct sock *reuseport_detach_sock(struct sock *sk)
>  {
>  	struct sock_reuseport *reuse;
> +	struct bpf_prog *prog;
> +	struct sock *nsk = NULL;
>  	int i;
>  
>  	spin_lock_bh(&reuseport_lock);
> @@ -242,8 +244,12 @@ void reuseport_detach_sock(struct sock *sk)
>  
>  		reuse->num_socks--;
>  		reuse->socks[i] = reuse->socks[reuse->num_socks];
> +		prog = rcu_dereference(reuse->prog);
>  
>  		if (sk->sk_protocol == IPPROTO_TCP) {
> +			if (reuse->num_socks && !prog)
> +				nsk = i == reuse->num_socks ? reuse->socks[i - 1] : reuse->socks[i];
> +
>  			reuse->num_closed_socks++;
>  			reuse->socks[reuse->max_socks - reuse->num_closed_socks] = sk;
>  		} else {
> @@ -264,6 +270,8 @@ void reuseport_detach_sock(struct sock *sk)
>  		call_rcu(&reuse->rcu, reuseport_free_rcu);
>  out:
>  	spin_unlock_bh(&reuseport_lock);
> +
> +	return nsk;
>  }
>  EXPORT_SYMBOL(reuseport_detach_sock);
>  
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index 1451aa9712b0..b27241ea96bd 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -992,6 +992,36 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
>  }
>  EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
>  
> +void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk)
> +{
> +	struct request_sock_queue *old_accept_queue, *new_accept_queue;
> +
> +	old_accept_queue = &inet_csk(sk)->icsk_accept_queue;
> +	new_accept_queue = &inet_csk(nsk)->icsk_accept_queue;
> +
> +	spin_lock(&old_accept_queue->rskq_lock);
> +	spin_lock(&new_accept_queue->rskq_lock);

Are you sure lockdep is happy with this ?

I would guess it should complain, because :

lock(A);
lock(B);
...
unlock(B);
unlock(A);

will fail when the opposite action happens eventually

lock(B);
lock(A);
...
unlock(A);
unlock(B);


> +
> +	if (old_accept_queue->rskq_accept_head) {
> +		if (new_accept_queue->rskq_accept_head)
> +			old_accept_queue->rskq_accept_tail->dl_next =
> +				new_accept_queue->rskq_accept_head;
> +		else
> +			new_accept_queue->rskq_accept_tail = old_accept_queue->rskq_accept_tail;
> +
> +		new_accept_queue->rskq_accept_head = old_accept_queue->rskq_accept_head;
> +		old_accept_queue->rskq_accept_head = NULL;
> +		old_accept_queue->rskq_accept_tail = NULL;
> +
> +		WRITE_ONCE(nsk->sk_ack_backlog, nsk->sk_ack_backlog + sk->sk_ack_backlog);
> +		WRITE_ONCE(sk->sk_ack_backlog, 0);
> +	}
> +
> +	spin_unlock(&new_accept_queue->rskq_lock);
> +	spin_unlock(&old_accept_queue->rskq_lock);
> +}
> +EXPORT_SYMBOL(inet_csk_reqsk_queue_migrate);

I fail to understand how the kernel can run fine right after this patch, before following patches are merged.

All request sockets in the socket accept queue MUST have their rsk_listener set to the listener,
this is how we designed things (each request socket has a reference taken on the listener)

We might even have some "BUG_ON(sk != req->rsk_listener);" in some places.

Since you splice list from old listener to the new one, without changing req->rsk_listener, bad things will happen.

I feel the order of your patches is not correct.


