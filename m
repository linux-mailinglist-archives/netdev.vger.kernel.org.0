Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 127C51356F9
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 11:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgAIKdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 05:33:35 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38728 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728448AbgAIKdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 05:33:35 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so6834126wrh.5
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 02:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=PQ++vjBtZFpbZ5vhUNmFbh7+x0gOXpjlJ1L44U/rr0I=;
        b=gOg28xh773Kv91RO5DuJ6yDTe8iX2YIwAroGOqjURQ7Qt19q++Udqx+3ZpUgbuA+E1
         huZQr3S/YGFe27gvto3qmN43tbqHS3Z1rj9e6X1ajdK7o2QF6CSBlXliAntK1NgEYbPj
         iPH/WV9alqPggIZsR8+DAlZZ/PwPKu9ZvdNFE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=PQ++vjBtZFpbZ5vhUNmFbh7+x0gOXpjlJ1L44U/rr0I=;
        b=ss5O5kwOJDas6DEeTF6MYI+3Djvd/Pvau5B/1A9l2956WcC2aKOHt6AtlyXp4J7Vvz
         oeHZg+CPczAbguKegGb4sn9Pkvco8ABJCdFgPNEisbITkZQQjX6aApo/jblsCrUlSW6E
         DIPuUOjZHHmjA1Ow3dN0lG55T97dWHGf3HyI2EpCMGOj9K4l+HH33VQfA3Hn1By/F8ub
         QdJJbnWuWEtM4+oQG5E8PaTeKblEhy/hpw9rXK6CYsnIuivmBG/1phbnbg0x9Oj+6+Q5
         PpNAAOWiYAv1TVm5jgw3ivygrKhjJpReUP+KRQj26EE6Sxgzx7Gn+8W5zn3XaNWgnEaZ
         3h2w==
X-Gm-Message-State: APjAAAUEdM+5HaITaxJFqAkkTp9WwAew1/4RSnI7iOGATkUPf3Rtd4D+
        YF9JC13hVeCqvw9yP5Hq6hmq6g==
X-Google-Smtp-Source: APXvYqxvDTJO+DGXoKt4xOvaTcNgga5xQJrpfeuS9ODtTpXcNuAYW8/QTjOvTEZ1s2Wc1mS7KQKgUA==
X-Received: by 2002:adf:ea4e:: with SMTP id j14mr10354600wrn.101.1578566012763;
        Thu, 09 Jan 2020 02:33:32 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id f1sm7607039wru.6.2020.01.09.02.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 02:33:32 -0800 (PST)
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2> <157851808101.1732.11616068811837364406.stgit@ubuntu3-kvm2>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [bpf PATCH 3/9] bpf: sockmap/tls, push write_space updates through ulp updates
In-reply-to: <157851808101.1732.11616068811837364406.stgit@ubuntu3-kvm2>
Date:   Thu, 09 Jan 2020 11:33:31 +0100
Message-ID: <87tv54syv8.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 10:14 PM CET, John Fastabend wrote:
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
> Fixes: 95fa145479fbc ("bpf: sockmap/tls, close can race with map free")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  include/linux/skmsg.h |   12 ++++++++----
>  include/net/tcp.h     |    6 ++++--
>  net/ipv4/tcp_ulp.c    |    6 ++++--
>  net/tls/tls_main.c    |   10 +++++++---
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

I'm wondering if we need the above fallback branch for no-ULP case?
tcp_update_ulp repeats the ULP check and has the same fallback. Perhaps
it can be reduced to:

	if (psock->sk_proto) {
		tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
		psock->sk_proto = NULL;
	} else {
		sk->sk_write_space = psock->saved_write_space;
	}

Then there's the question if it's okay to leave psock->sk_proto set and
potentially restore it more than once? Reading tls_update, the only user
ULP 'update' callback, it looks fine.

Can sk_psock_restore_proto be as simple as:

static inline void sk_psock_restore_proto(struct sock *sk,
					  struct sk_psock *psock)
{
	tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
}

... or am I missing something?

Asking becuase I have a patch [0] like this in the queue and haven't
seen issues with it during testing.

-jkbs

[0] https://github.com/jsitnicki/linux/commit/2d2152593c8e6c5f38548796501a81a6ba20b6dc

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
