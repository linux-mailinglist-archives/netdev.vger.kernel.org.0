Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAB011392ED
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgAMN71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:59:27 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35155 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728734AbgAMN71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 08:59:27 -0500
Received: by mail-lj1-f194.google.com with SMTP id j1so10167342lja.2
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 05:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=XSi8i2Kt/EnemjdYBrbpnoQ4qWsZGk/zx9LWUXbD/B4=;
        b=Si/408Yhep/bGbyAvgzfjOPNfm4qFtbR1c+6s7ZpgqR59mS54QWrI8NOrhOjG06MS7
         cLrJkT3xtsSpSrXhjD1WzstPLpx9+yR+B3Rgf2GySE9BeHzDh76cbckU3aIon6KTDLxF
         n8/k8apWKjX7fdYNzWGX9rhyMxDod3DONzji8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=XSi8i2Kt/EnemjdYBrbpnoQ4qWsZGk/zx9LWUXbD/B4=;
        b=DXRiNyxeK9rh8AKYit5esOH/Pk8RrsybkJ6uO3Fx4HRPDkMb0sh/IESf8itaoW02u9
         vUUnrwcfP3lHWHucd1CWueYbQcllE4t6lAT/00boAYvcwsJBVBJGZ2IREbNRUKKlETPV
         N8d9povxFP8VdcawMLmDG8ICb06aYBl7dJzbTOwUoQwSy//5138DenZfy5lCbloEj94o
         CgUBi1V0R/soyBDmIsc7/Nh/9aMgzxxZJViZFwcqQqOL2/PyRaPAFGgX5e9ywRPSUDCB
         0Ud5DTzVb/5aLmfdb/sdjmimaxdOLHL4CQ5SRkOXiEArWYBCq1WO+E2KTnn112zbiP7S
         +IzA==
X-Gm-Message-State: APjAAAUUuix6LHfYD9EQJ/JTC941QhkEzePsNSVz/hEs+5BTfvgbe8SY
        VlWiqG4PuvSLg7UcgUp2kVikIg==
X-Google-Smtp-Source: APXvYqzNkw0Q184HcKUUTZ1aTMRthZfI7Ptt89lGmuW7rL9QakfPRieDU0cvvQlrmNgDH4ICprnLFg==
X-Received: by 2002:a2e:3608:: with SMTP id d8mr10831203lja.152.1578923964076;
        Mon, 13 Jan 2020 05:59:24 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id z13sm5843067lfi.69.2020.01.13.05.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 05:59:23 -0800 (PST)
References: <20200111061206.8028-1-john.fastabend@gmail.com> <20200111061206.8028-4-john.fastabend@gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, song@kernel.org, jonathan.lemon@gmail.com
Subject: Re: [bpf PATCH v2 3/8] bpf: sockmap/tls, push write_space updates through ulp updates
In-reply-to: <20200111061206.8028-4-john.fastabend@gmail.com>
Date:   Mon, 13 Jan 2020 14:59:22 +0100
Message-ID: <87o8v7sbid.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 11, 2020 at 07:12 AM CET, John Fastabend wrote:
> When sockmap sock with TLS enabled is removed we cleanup bpf/psock state
> and call tcp_update_ulp() to push updates to TLS ULP on top. However, we
> don't push the write_space callback up and instead simply overwrite the
> op with the psock stored previous op. This may or may not be correct so
> to ensure we don't overwrite the TLS write space hook pass this field to
> the ULP and have it fixup the ctx.
>
> This completes a previous fix that pushed the ops through to the ULP
> but at the time missed doing this for write_space, presumably because
> write_space TLS hook was added around the same time.
>
> Cc: stable@vger.kernel.org
> Fixes: 95fa145479fbc ("bpf: sockmap/tls, close can race with map free")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  include/linux/skmsg.h | 12 ++++++++----
>  include/net/tcp.h     |  6 ++++--
>  net/ipv4/tcp_ulp.c    |  6 ++++--
>  net/tls/tls_main.c    | 10 +++++++---
>  4 files changed, 23 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index b6afe01f8592..14d61bba0b79 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -359,17 +359,21 @@ static inline void sk_psock_restore_proto(struct sock *sk,
>  					  struct sk_psock *psock)
>  {
>  	sk->sk_prot->unhash = psock->saved_unhash;
> -	sk->sk_write_space = psock->saved_write_space;
>  
>  	if (psock->sk_proto) {
>  		struct inet_connection_sock *icsk = inet_csk(sk);
>  		bool has_ulp = !!icsk->icsk_ulp_data;
>  
> -		if (has_ulp)
> -			tcp_update_ulp(sk, psock->sk_proto);
> -		else
> +		if (has_ulp) {
> +			tcp_update_ulp(sk, psock->sk_proto,
> +				       psock->saved_write_space);
> +		} else {
>  			sk->sk_prot = psock->sk_proto;
> +			sk->sk_write_space = psock->saved_write_space;
> +		}
>  		psock->sk_proto = NULL;
> +	} else {
> +		sk->sk_write_space = psock->saved_write_space;
>  	}
>  }
>  
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index e460ea7f767b..e6f48384dc71 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -2147,7 +2147,8 @@ struct tcp_ulp_ops {
>  	/* initialize ulp */
>  	int (*init)(struct sock *sk);
>  	/* update ulp */
> -	void (*update)(struct sock *sk, struct proto *p);
> +	void (*update)(struct sock *sk, struct proto *p,
> +		       void (*write_space)(struct sock *sk));
>  	/* cleanup ulp */
>  	void (*release)(struct sock *sk);
>  	/* diagnostic */
> @@ -2162,7 +2163,8 @@ void tcp_unregister_ulp(struct tcp_ulp_ops *type);
>  int tcp_set_ulp(struct sock *sk, const char *name);
>  void tcp_get_available_ulp(char *buf, size_t len);
>  void tcp_cleanup_ulp(struct sock *sk);
> -void tcp_update_ulp(struct sock *sk, struct proto *p);
> +void tcp_update_ulp(struct sock *sk, struct proto *p,
> +		    void (*write_space)(struct sock *sk));
>  
>  #define MODULE_ALIAS_TCP_ULP(name)				\
>  	__MODULE_INFO(alias, alias_userspace, name);		\
> diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
> index 12ab5db2b71c..38d3ad141161 100644
> --- a/net/ipv4/tcp_ulp.c
> +++ b/net/ipv4/tcp_ulp.c
> @@ -99,17 +99,19 @@ void tcp_get_available_ulp(char *buf, size_t maxlen)
>  	rcu_read_unlock();
>  }
>  
> -void tcp_update_ulp(struct sock *sk, struct proto *proto)
> +void tcp_update_ulp(struct sock *sk, struct proto *proto,
> +		    void (*write_space)(struct sock *sk))
>  {
>  	struct inet_connection_sock *icsk = inet_csk(sk);
>  
>  	if (!icsk->icsk_ulp_ops) {
> +		sk->sk_write_space = write_space;
>  		sk->sk_prot = proto;
>  		return;
>  	}
>  
>  	if (icsk->icsk_ulp_ops->update)
> -		icsk->icsk_ulp_ops->update(sk, proto);
> +		icsk->icsk_ulp_ops->update(sk, proto, write_space);
>  }
>  
>  void tcp_cleanup_ulp(struct sock *sk)
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index dac24c7aa7d4..94774c0e5ff3 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -732,15 +732,19 @@ static int tls_init(struct sock *sk)
>  	return rc;
>  }
>  
> -static void tls_update(struct sock *sk, struct proto *p)
> +static void tls_update(struct sock *sk, struct proto *p,
> +		       void (*write_space)(struct sock *sk))
>  {
>  	struct tls_context *ctx;
>  
>  	ctx = tls_get_ctx(sk);
> -	if (likely(ctx))
> +	if (likely(ctx)) {
> +		ctx->sk_write_space = write_space;
>  		ctx->sk_proto = p;
> -	else
> +	} else {
>  		sk->sk_prot = p;
> +		sk->sk_write_space = write_space;
> +	}
>  }
>  
>  static int tls_get_info(const struct sock *sk, struct sk_buff *skb)

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
