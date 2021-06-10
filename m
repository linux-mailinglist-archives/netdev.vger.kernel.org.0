Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EF93A32F8
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhFJSXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:23:13 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:41640 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhFJSXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:23:12 -0400
Received: by mail-wr1-f52.google.com with SMTP id o3so3336038wri.8;
        Thu, 10 Jun 2021 11:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Eqm4ERZ6h/WqHjEhJGoI0O+yCyk+QKdXa8kIv9Ki3oY=;
        b=DEXY7oJdM85vIOGwoOIIVmLNdMO7qybnn0lXygsKXhbL4fKQAwbPA2Weqep3H7ZymM
         d2YTpgzoRh33Jg/arpFtI+R8ISfPi/Imh4vAuAgzQI2ZycBxCfc09zmWimD3aC79Pk11
         W0TlG3HDXmS1BN3a3nivj7RaVur9CgGVut6jvPyk6zlO/O2lI4BW4l+CtVMmpxdq5+tu
         8xekqEsE3xoAZvIjoW+WG1Ximicaj2h4pZTEurWfX5hf86vTLE5V9OzINOqT51eKxbcE
         D8nf4+PfJrTJ5ODT82XM4Beoe4CYbfxhkypI4UFpWKVcLLoEJsDmHCjJTrEHQM2FGCN2
         a4zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Eqm4ERZ6h/WqHjEhJGoI0O+yCyk+QKdXa8kIv9Ki3oY=;
        b=rvzmszs7ErWGMwzq8np60oJcLMU9lFRBO92JdVtR8YIU9KOzFJ7q+wUS9ABK6Pws1Q
         yZuIuYb09sMwj9611u0p66NyDKOfbUr86jq2fFhHXCfgsKkCcuQdb43+DZOBEOc9Ojpd
         0RyGPT0YFWnsC219XqShqOuNO/z7yKKEBbQcNhEJhwhJd/H4WHUkPO4Ytrky8fEbFfUs
         SXm9/c/3a3puHfVlpxkGD4oyDVkOTteZhlZAG4oi+F2DZkhMjjeX1V9Y6aiewmUXPP0D
         kRKmvlUbU2KI4zTBQQS1Mw6flaUenuLjexkfr5bFyFHb8iYRjPy7Vxh9dD89avsPWmWr
         mOVA==
X-Gm-Message-State: AOAM5328GgJ05AqJx7wKGWai2k+8LMtuRsyAiDtCqCW/uzb36jD1rqay
        mbpqEQcpyvH48oeNz0ckMVEXGOJGJZ8=
X-Google-Smtp-Source: ABdhPJxkjsYkOzZE7mN3JZEckq5gTUdXaG7XdUEF3AHDGs9v4FmtXWlyUep2IkhqCa1nDfngmPbHdQ==
X-Received: by 2002:a5d:564a:: with SMTP id j10mr6956285wrw.171.1623349214816;
        Thu, 10 Jun 2021 11:20:14 -0700 (PDT)
Received: from [192.168.181.98] (228.18.23.93.rev.sfr.net. [93.23.18.228])
        by smtp.gmail.com with ESMTPSA id k12sm10280228wmr.2.2021.06.10.11.20.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 11:20:14 -0700 (PDT)
Subject: Re: [PATCH v7 bpf-next 05/11] tcp: Migrate
 TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210521182104.18273-1-kuniyu@amazon.co.jp>
 <20210521182104.18273-6-kuniyu@amazon.co.jp>
From:   Eric Dumazet <erdnetdev@gmail.com>
Message-ID: <612b0da4-1e3e-66b8-0902-f76840796f36@gmail.com>
Date:   Thu, 10 Jun 2021 20:20:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210521182104.18273-6-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/21/21 8:20 PM, Kuniyuki Iwashima wrote:
> When we call close() or shutdown() for listening sockets, each child socket
> in the accept queue are freed at inet_csk_listen_stop(). If we can get a
> new listener by reuseport_migrate_sock() and clone the request by
> inet_reqsk_clone(), we try to add it into the new listener's accept queue
> by inet_csk_reqsk_queue_add(). If it fails, we have to call __reqsk_free()
> to call sock_put() for its listener and free the cloned request.
> 
> After putting the full socket into ehash, tcp_v[46]_syn_recv_sock() sets
> NULL to ireq_opt/pktopts in struct inet_request_sock, but ipv6_opt can be
> non-NULL. So, we have to set NULL to ipv6_opt of the old request to avoid
> double free.
> 
> Note that we do not update req->rsk_listener and instead clone the req to
> migrate because another path may reference the original request. If we
> protected it by RCU, we would need to add rcu_read_lock() in many places.
> 
> Link: https://lore.kernel.org/netdev/20201209030903.hhow5r53l6fmozjn@kafai-mbp.dhcp.thefacebook.com/
> Suggested-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  net/ipv4/inet_connection_sock.c | 71 ++++++++++++++++++++++++++++++++-
>  1 file changed, 70 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index fa806e9167ec..07e97b2f3635 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -695,6 +695,53 @@ int inet_rtx_syn_ack(const struct sock *parent, struct request_sock *req)
>  }
>  EXPORT_SYMBOL(inet_rtx_syn_ack);
>  
> +static struct request_sock *inet_reqsk_clone(struct request_sock *req,
> +					     struct sock *sk)
> +{
> +	struct sock *req_sk, *nreq_sk;
> +	struct request_sock *nreq;
> +
> +	nreq = kmem_cache_alloc(req->rsk_ops->slab, GFP_ATOMIC | __GFP_NOWARN);
> +	if (!nreq) {
> +		/* paired with refcount_inc_not_zero() in reuseport_migrate_sock() */
> +		sock_put(sk);
> +		return NULL;
> +	}
> +
> +	req_sk = req_to_sk(req);
> +	nreq_sk = req_to_sk(nreq);
> +
> +	memcpy(nreq_sk, req_sk,
> +	       offsetof(struct sock, sk_dontcopy_begin));
> +	memcpy(&nreq_sk->sk_dontcopy_end, &req_sk->sk_dontcopy_end,
> +	       req->rsk_ops->obj_size - offsetof(struct sock, sk_dontcopy_end));
> +
> +	sk_node_init(&nreq_sk->sk_node);
> +	nreq_sk->sk_tx_queue_mapping = req_sk->sk_tx_queue_mapping;
> +#ifdef CONFIG_XPS
> +	nreq_sk->sk_rx_queue_mapping = req_sk->sk_rx_queue_mapping;
> +#endif
> +	nreq_sk->sk_incoming_cpu = req_sk->sk_incoming_cpu;
> +	refcount_set(&nreq_sk->sk_refcnt, 0);

Not sure why you clear sk_refcnt here (it is set to 1 later)

> +
> +	nreq->rsk_listener = sk;
> +
> +	/* We need not acquire fastopenq->lock
> +	 * because the child socket is locked in inet_csk_listen_stop().
> +	 */
> +	if (sk->sk_protocol == IPPROTO_TCP && tcp_rsk(nreq)->tfo_listener)
> +		rcu_assign_pointer(tcp_sk(nreq->sk)->fastopen_rsk, nreq);
> +
> +	return nreq;
> +}

Ouch, this is going to be hard to maintain...




> +
> +static void reqsk_migrate_reset(struct request_sock *req)
> +{
> +#if IS_ENABLED(CONFIG_IPV6)
> +	inet_rsk(req)->ipv6_opt = NULL;
> +#endif
> +}
> +
>  /* return true if req was found in the ehash table */
>  static bool reqsk_queue_unlink(struct request_sock *req)
>  {
> @@ -1036,14 +1083,36 @@ void inet_csk_listen_stop(struct sock *sk)
>  	 * of the variants now.			--ANK
>  	 */
>  	while ((req = reqsk_queue_remove(queue, sk)) != NULL) {
> -		struct sock *child = req->sk;
> +		struct sock *child = req->sk, *nsk;
> +		struct request_sock *nreq;
>  
>  		local_bh_disable();
>  		bh_lock_sock(child);
>  		WARN_ON(sock_owned_by_user(child));
>  		sock_hold(child);
>  
> +		nsk = reuseport_migrate_sock(sk, child, NULL);
> +		if (nsk) {
> +			nreq = inet_reqsk_clone(req, nsk);
> +			if (nreq) {
> +				refcount_set(&nreq->rsk_refcnt, 1);
> +
> +				if (inet_csk_reqsk_queue_add(nsk, nreq, child)) {
> +					reqsk_migrate_reset(req);
> +				} else {
> +					reqsk_migrate_reset(nreq);
> +					__reqsk_free(nreq);
> +				}
> +
> +				/* inet_csk_reqsk_queue_add() has already
> +				 * called inet_child_forget() on failure case.
> +				 */
> +				goto skip_child_forget;
> +			}
> +		}
> +
>  		inet_child_forget(sk, req, child);
> +skip_child_forget:
>  		reqsk_put(req);
>  		bh_unlock_sock(child);
>  		local_bh_enable();
> 
