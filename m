Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933B75FB16E
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 13:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiJKL2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 07:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiJKL2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 07:28:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3773B7F092
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 04:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665487696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aa9rEIaSn1XKnPUSEdi4rRdOmXJSmzcOUjeGaw5Yfa8=;
        b=Y3eSH9fzbBrbVAuU2QI2xBFupuDZOgcDb3KbR7X6iCEPWoHtbs96OAMgCVezMSL9ap6W5h
        vivZS6t63vOHGlL7BbcRrqCTkLsm6n5Yqg7s02vJxInnkkGcPtSaTn59YHjbA2gKqc8gsD
        MHrA7vwRNzTgU81pWTwg8z/xCvQ1WBA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-307-MbLm3B-XMF2koMUspfod_w-1; Tue, 11 Oct 2022 07:28:15 -0400
X-MC-Unique: MbLm3B-XMF2koMUspfod_w-1
Received: by mail-wm1-f72.google.com with SMTP id v191-20020a1cacc8000000b003bdf7b78dccso8319251wme.3
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 04:28:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aa9rEIaSn1XKnPUSEdi4rRdOmXJSmzcOUjeGaw5Yfa8=;
        b=SN1SFDgZNbI3hoxgeVLAv5tzcJnSi9dOR2XmCso4ZugyjhA6TOhFxS6TUREKSZNpAs
         oXTCN7mCZDPhvaN9DL2JgxkrhHwxinzqXF8vDup8q5/Kg2yaDC7sEYh+KQ4+uHQyknzV
         uBua8/4cxqWYj//2DkJv06nZ0kJKMKHh51uU9gWGFBdKtOJmqdSYPovtudsxLmwzdzQf
         JFERM72Pm9EymEfAvgvGU00hGmxnZl7yDSvl/REMPZ2w1PGWpFgdMRHSS4gKlzihH4lQ
         iV+YFEaturnh4N7HLVBLd16INQZPWJ2flnEzKOgRSpyXBNwA6/buKySklI/ho6lCCUTA
         7zLw==
X-Gm-Message-State: ACrzQf1buiFdeJNL+oXl5c5aVuX5Q9sgnaclrXLr48VY4oCLJgC98+yD
        5jpSt/wzXHN/32rc/OoueZuyFSV7wYwZBQD3UmWJiQp/qHvclE8M0ik9O5x71y8G/bPCggP0HHU
        +Czkcr6JeUVAyYxur
X-Received: by 2002:adf:ebcf:0:b0:22c:9eb4:d6f6 with SMTP id v15-20020adfebcf000000b0022c9eb4d6f6mr14757929wrn.251.1665487693675;
        Tue, 11 Oct 2022 04:28:13 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4hmahkxyUwJGtpeiLFWx/q2ULJ7bnP3bKOkB/1vC5wPnv42O7k6V8WN7yvieL5dBNizbCdOQ==
X-Received: by 2002:adf:ebcf:0:b0:22c:9eb4:d6f6 with SMTP id v15-20020adfebcf000000b0022c9eb4d6f6mr14757907wrn.251.1665487693369;
        Tue, 11 Oct 2022 04:28:13 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id c8-20020a05600c0a4800b003b4fdbb6319sm20569971wmq.21.2022.10.11.04.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 04:28:12 -0700 (PDT)
Message-ID: <a2e418db45228cdaf59e7679d81b2d0bcb657377.camel@redhat.com>
Subject: Re: [PATCH v1 net 2/3] soreuseport: Fix socket selection for
 SO_INCOMING_CPU.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>
Cc:     Craig Gallek <kraig@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kazuho Oku <kazuhooku@gmail.com>
Date:   Tue, 11 Oct 2022 13:28:11 +0200
In-Reply-To: <20221010174351.11024-3-kuniyu@amazon.com>
References: <20221010174351.11024-1-kuniyu@amazon.com>
         <20221010174351.11024-3-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-10-10 at 10:43 -0700, Kuniyuki Iwashima wrote:
> Kazuho Oku reported that setsockopt(SO_INCOMING_CPU) does not work
> with setsockopt(SO_REUSEPORT) for TCP since v4.6.
> 
> With the combination of SO_REUSEPORT and SO_INCOMING_CPU, we could
> build a highly efficient server application.
> 
> setsockopt(SO_INCOMING_CPU) associates a CPU with a TCP listener
> or UDP socket, and then incoming packets processed on the CPU will
> likely be distributed to the socket.  Technically, a socket could
> even receive packets handled on another CPU if no sockets in the
> reuseport group have the same CPU receiving the flow.
> 
> The logic exists in compute_score() so that a socket will get a higher
> score if it has the same CPU with the flow.  However, the score gets
> ignored after the cited two commits, which introduced a faster socket
> selection algorithm for SO_REUSEPORT.
> 
> This patch introduces a counter of sockets with SO_INCOMING_CPU in
> a reuseport group to check if we should iterate all sockets to find
> a proper one.  We increment the counter when
> 
>   * calling listen() if the socket has SO_INCOMING_CPU and SO_REUSEPORT
> 
>   * enabling SO_INCOMING_CPU if the socket is in a reuseport group
> 
> Also, we decrement it when
> 
>   * detaching a socket out of the group to apply SO_INCOMING_CPU to
>     migrated TCP requests
> 
>   * disabling SO_INCOMING_CPU if the socket is in a reuseport group
> 
> When the counter reaches 0, we can get back to the O(1) selection
> algorithm.
> 
> The overall changes are negligible for the non-SO_INCOMING_CPU case,
> and the only notable thing is that we have to update sk_incomnig_cpu
> under reuseport_lock.  Otherwise, the race below traps us in the O(n)
> algorithm even after disabling SO_INCOMING_CPU for all sockets in the
> group.
> 
>  cpu1 (setsockopt)               cpu2 (listen)
> +-----------------+             +-------------+
> 
> lock_sock(sk1)                  lock_sock(sk2)
> 
> reuseport_incoming_cpu_update(sk, val)
> .
> > - spin_lock_bh(&reuseport_lock)
> > 
> >   /* increment reuse->incoming_cpu, but
> >    * sk1->sk_incoming_cpu is still -1.
> >    */
> > - __reuseport_incoming_cpu_inc(sk1, reuse)
> > 
> > - spin_unlock_bh(&reuseport_lock)
> > 
> >                               spin_lock_bh(&reuseport_lock)
> >                               reuseport_grow(sk2, reuse)
> >                               .
> >                               | - more_socks_size = reuse->max_socks * 2U;
> >                               | - if (more_socks_size > U16_MAX &&
> >                               |       reuse->num_closed_socks)
> >                               |   .
> >                               |   `- __reuseport_detach_closed_sock(sk1, reuse)
> >                               |      .
> >                               |      ` - reuseport_incoming_cpu_dec(sk1, reuse)
> >                                          .
> >                                          `- if (sk1->sk_incoming_cpu >= 0)
> >                                             /* read shutdown()ed sk1's sk_incoming_cpu
> >                                              * without lock_sock(), and ... do nothing!
> `- WRITE_ONCE(sk1->incoming_cpu, 0)            *
>                                                * leak 1 count of reuse->incoming_cpu.
>                                                */
> 
>                                 spin_unlock_bh(&reuseport_lock)
> 
> Fixes: e32ea7e74727 ("soreuseport: fast reuseport UDP socket selection")
> Fixes: c125e80b8868 ("soreuseport: fast reuseport TCP socket selection")
> Reported-by: Kazuho Oku <kazuhooku@gmail.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  include/net/sock_reuseport.h |  2 +
>  net/core/sock.c              |  5 +-
>  net/core/sock_reuseport.c    | 88 ++++++++++++++++++++++++++++++++++--
>  3 files changed, 89 insertions(+), 6 deletions(-)
> 
> diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> index fe9779e6d90f..d69fbea3d6cb 100644
> --- a/include/net/sock_reuseport.h
> +++ b/include/net/sock_reuseport.h
> @@ -16,6 +16,7 @@ struct sock_reuseport {
>  	u16			max_socks;		/* length of socks */
>  	u16			num_socks;		/* elements in socks */
>  	u16			num_closed_socks;	/* closed elements in socks */
> +	u16			incoming_cpu;
>  	/* The last synq overflow event timestamp of this
>  	 * reuse->socks[] group.
>  	 */
> @@ -28,6 +29,7 @@ struct sock_reuseport {
>  	struct sock		*socks[];	/* array of sock pointers */
>  };
>  
> +void reuseport_incoming_cpu_update(struct sock *sk, int val);
>  extern int reuseport_alloc(struct sock *sk, bool bind_inany);
>  extern int reuseport_add_sock(struct sock *sk, struct sock *sk2,
>  			      bool bind_inany);
> diff --git a/net/core/sock.c b/net/core/sock.c
> index eeb6cbac6f49..ad67aba947e1 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1436,7 +1436,10 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
>  		break;
>  		}
>  	case SO_INCOMING_CPU:
> -		WRITE_ONCE(sk->sk_incoming_cpu, val);
> +		if (rcu_access_pointer(sk->sk_reuseport_cb))
> +			reuseport_incoming_cpu_update(sk, val);
> +		else
> +			WRITE_ONCE(sk->sk_incoming_cpu, val);

I woould call the helper regardless of sk->sk_reuseport_cb and let it
do the correct thing, will make the code simpler and possibly safer.

>  		break;
>  
>  	case SO_CNX_ADVICE:
> diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> index 5daa1fa54249..6f5cda58b2d4 100644
> --- a/net/core/sock_reuseport.c
> +++ b/net/core/sock_reuseport.c
> @@ -21,6 +21,64 @@ static DEFINE_IDA(reuseport_ida);
>  static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
>  			       struct sock_reuseport *reuse, bool bind_inany);
>  
> +static void __reuseport_incoming_cpu_inc(struct sock *sk, struct sock_reuseport *reuse)
> +{
> +	/* paired with READ_ONCE() in reuseport_select_sock_by_hash() */
> +	WRITE_ONCE(reuse->incoming_cpu, reuse->incoming_cpu + 1);
> +}

I find this helper name confusing (and I'm also horrible at picking
good names). Perhaps
__reuseport_use_cpu_inc()/__reuseport_use_cpu_dev() ?!?
> +
> +static void __reuseport_incoming_cpu_dec(struct sock *sk, struct sock_reuseport *reuse)
> +{
> +	/* paired with READ_ONCE() in reuseport_select_sock_by_hash() */
> +	WRITE_ONCE(reuse->incoming_cpu, reuse->incoming_cpu - 1);
> +}
> +
> +static void reuseport_incoming_cpu_inc(struct sock *sk, struct sock_reuseport *reuse)
> +{
> +	if (sk->sk_incoming_cpu >= 0)
> +		__reuseport_incoming_cpu_inc(sk, reuse);
> +}
> +
> +static void reuseport_incoming_cpu_dec(struct sock *sk, struct sock_reuseport *reuse)
> +{
> +	if (sk->sk_incoming_cpu >= 0)
> +		__reuseport_incoming_cpu_dec(sk, reuse);
> +}
> +
> +void reuseport_incoming_cpu_update(struct sock *sk, int val)
> +{
> +	struct sock_reuseport *reuse;
> +
> +	spin_lock_bh(&reuseport_lock);
> +	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> +					  lockdep_is_held(&reuseport_lock));
> +
> +	if (!reuse) {
> +		/* reuseport_grow() has detached a shutdown()ed
> +		 * sk, and sk_state is TCP_CLOSE, so no one can
> +		 * read this sk_incoming_cpu concurrently.
> +		 */
> +		sk->sk_incoming_cpu = val;
> +		goto out;
> +	}
> +
> +	/* This must be done under reuseport_lock to avoid a race with
> +	 * reuseport_grow(), which accesses sk->sk_incoming_cpu without
> +	 * lock_sock() when detaching a shutdown()ed sk.
> +	 *
> +	 * paired with READ_ONCE() in reuseport_select_sock_by_hash()
> +	 */
> +	WRITE_ONCE(sk->sk_incoming_cpu, val);
> +
> +	if (sk->sk_incoming_cpu < 0 && val >= 0)

I don't see how the above condition can be true given the previous
statement ?!?

Possibly you can use something alike:

	old_sk_incoming_cpu = sk->sk_incoming_cpu
	WRITE_ONCE(sk->sk_incoming_cpu, val);
	if (!reuse)
		goto out;

	if (old_sk_incoming_cpu < 0)
		reuseport_incoming_cpu_inc()

So that:
- can additonal avoid the '__' helper variants
- a single write statement, no need to optimize out the WRITE_ONCE in
the !reuse corner case

> +		__reuseport_incoming_cpu_inc(sk, reuse);
> +	else if (sk->sk_incoming_cpu >= 0 && val < 0)
> +		__reuseport_incoming_cpu_dec(sk, reuse);
> +
> +out:
> +	spin_unlock_bh(&reuseport_lock);
> +}
> +
>  static int reuseport_sock_index(struct sock *sk,
>  				const struct sock_reuseport *reuse,
>  				bool closed)
> @@ -48,6 +106,7 @@ static void __reuseport_add_sock(struct sock *sk,
>  	/* paired with smp_rmb() in reuseport_(select|migrate)_sock() */
>  	smp_wmb();
>  	reuse->num_socks++;
> +	reuseport_incoming_cpu_inc(sk, reuse);
>  }
>  
>  static bool __reuseport_detach_sock(struct sock *sk,
> @@ -60,6 +119,7 @@ static bool __reuseport_detach_sock(struct sock *sk,
>  
>  	reuse->socks[i] = reuse->socks[reuse->num_socks - 1];
>  	reuse->num_socks--;
> +	reuseport_incoming_cpu_dec(sk, reuse);
>  
>  	return true;
>  }
> @@ -70,6 +130,7 @@ static void __reuseport_add_closed_sock(struct sock *sk,
>  	reuse->socks[reuse->max_socks - reuse->num_closed_socks - 1] = sk;
>  	/* paired with READ_ONCE() in inet_csk_bind_conflict() */
>  	WRITE_ONCE(reuse->num_closed_socks, reuse->num_closed_socks + 1);
> +	reuseport_incoming_cpu_inc(sk, reuse);
>  }
>  
>  static bool __reuseport_detach_closed_sock(struct sock *sk,
> @@ -83,6 +144,7 @@ static bool __reuseport_detach_closed_sock(struct sock *sk,
>  	reuse->socks[i] = reuse->socks[reuse->max_socks - reuse->num_closed_socks];
>  	/* paired with READ_ONCE() in inet_csk_bind_conflict() */
>  	WRITE_ONCE(reuse->num_closed_socks, reuse->num_closed_socks - 1);
> +	reuseport_incoming_cpu_dec(sk, reuse);
>  
>  	return true;
>  }
> @@ -150,6 +212,7 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
>  	reuse->bind_inany = bind_inany;
>  	reuse->socks[0] = sk;
>  	reuse->num_socks = 1;
> +	reuseport_incoming_cpu_inc(sk, reuse);
>  	rcu_assign_pointer(sk->sk_reuseport_cb, reuse);
>  
>  out:
> @@ -193,6 +256,7 @@ static struct sock_reuseport *reuseport_grow(struct sock_reuseport *reuse)
>  	more_reuse->reuseport_id = reuse->reuseport_id;
>  	more_reuse->bind_inany = reuse->bind_inany;
>  	more_reuse->has_conns = reuse->has_conns;
> +	more_reuse->incoming_cpu = reuse->incoming_cpu;
>  
>  	memcpy(more_reuse->socks, reuse->socks,
>  	       reuse->num_socks * sizeof(struct sock *));
> @@ -442,18 +506,32 @@ static struct sock *run_bpf_filter(struct sock_reuseport *reuse, u16 socks,
>  static struct sock *reuseport_select_sock_by_hash(struct sock_reuseport *reuse,
>  						  u32 hash, u16 num_socks)
>  {
> +	struct sock *first_valid_sk = NULL;
>  	int i, j;
>  
>  	i = j = reciprocal_scale(hash, num_socks);
> -	while (reuse->socks[i]->sk_state == TCP_ESTABLISHED) {
> +	do {
> +		struct sock *sk = reuse->socks[i];
> +
> +		if (sk->sk_state != TCP_ESTABLISHED) {
> +			/* paired with WRITE_ONCE() in __reuseport_incoming_cpu_(inc|dec)() */
> +			if (!READ_ONCE(reuse->incoming_cpu))
> +				return sk;
> +
> +			/* paired with WRITE_ONCE() in reuseport_incoming_cpu_update() */
> +			if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
> +				return sk;
> +
> +			if (!first_valid_sk)
> +				first_valid_sk = sk;
> +		}
> +
>  		i++;
>  		if (i >= num_socks)
>  			i = 0;
> -		if (i == j)
> -			return NULL;
> -	}
> +	} while (i != j);
>  
> -	return reuse->socks[i];
> +	return first_valid_sk;
>  }
> 
IMHO this looks a bit too complex and possibly dangerous for -net. Have
you considered a net-next target?

Thanks,

Paolo

