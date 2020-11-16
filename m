Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966E02B41D0
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 12:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgKPK53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 05:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728211AbgKPK53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 05:57:29 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E089BC0613CF;
        Mon, 16 Nov 2020 02:57:28 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id o15so18182395wru.6;
        Mon, 16 Nov 2020 02:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sGBtl7stE1Xi2ywmSUQe0vTOhmZYyoOAWUhdSHo6KUQ=;
        b=uEfKz5fnvp8a3FCQ/CUoX36/tnMKms1HN8pWmwsn4WcvyylAWO1NVKA8w+eQ8mBiG+
         8V55DA7WCwHSsEErgZQy7hlOTh26YL3w/cKjC+W/G+Tr9277iLIcOUenB8Q6t0jlURtp
         eZ+IWoekcStJKTYKBidJni3RB2zhUvLHT7s6G4/lJXkIyxPquXxXScU7NLEi2TNzst6S
         RaexM8/jttlcoEmWh2FLEKbe1U/mtwuxzeOK9hZsC5g1U8GmACmUpdCN6hOKS/U4TIXv
         9B5epSrWaI4rWV4+I2BruKzyUaBVx1NEFtau3FTyX7srTLKX3qgFHUDAdTqcW9z2lHui
         +7ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sGBtl7stE1Xi2ywmSUQe0vTOhmZYyoOAWUhdSHo6KUQ=;
        b=EAbLIoPQWELo4yAvl+K8jWCGEIaE9CFJ46C0oQs7wr/NNTjWVHehwRNN09Q08VWaOh
         KRhhVc+vfdv7gs05ckyeK65HOFtQ/2MtlfU16r3rjuNLiuk20bkQiRQIIpSBB/ya4dBe
         DGV4ZudsuT/kQn1BaWoQ14LWmWKw5ORr+ZjbPI7zcKHBNBhv99hNkodXnAqeQHxQi31X
         oD/t8hRZx8WVO8dYJzhHmC1cx4S+GFXK5O+sUpzmh/w2ouHkklX6IHCStAxm/QHu1zIo
         kfqXgvggSvZwNRlpXOuya9fUK5V7T8V5u0FoOwxb1fjVk76CScSFEUfxXf5ppX5C22Sk
         DKfw==
X-Gm-Message-State: AOAM533w31J3i7jNPEKnNXRmjIsAVSnSoVoDt5usLOGsOBLlHfZucUO6
        oR079b7EWgyuTtbXizfWx7qPYcIEvkg=
X-Google-Smtp-Source: ABdhPJyGkFEVHRfQepzCNGaZ0yGLTKwJKL7NTwjcJGaA79SbUYW9jOy73lisgBlqvZUxw5bOsoGskg==
X-Received: by 2002:adf:f08a:: with SMTP id n10mr18754749wro.260.1605524247317;
        Mon, 16 Nov 2020 02:57:27 -0800 (PST)
Received: from [192.168.8.114] ([37.167.85.62])
        by smtp.gmail.com with ESMTPSA id n9sm19273935wmd.4.2020.11.16.02.57.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 02:57:26 -0800 (PST)
Subject: Re: [PATCH v4] tcp: fix race condition when creating child sockets
 from syncookies
To:     Ricardo Dias <rdias@singlestore.com>, davem@davemloft.net,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201113190935.GA106934@rdias-suse-pc.lan>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f91c2d08-34dc-6fd6-1153-8c4a714377e7@gmail.com>
Date:   Mon, 16 Nov 2020 11:57:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201113190935.GA106934@rdias-suse-pc.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/13/20 8:09 PM, Ricardo Dias wrote:
> When the TCP stack is in SYN flood mode, the server child socket is
> created from the SYN cookie received in a TCP packet with the ACK flag
> set.
> 
> The child socket is created when the server receives the first TCP
> packet with a valid SYN cookie from the client. Usually, this packet
> corresponds to the final step of the TCP 3-way handshake, the ACK
> packet. But is also possible to receive a valid SYN cookie from the
> first TCP data packet sent by the client, and thus create a child socket
> from that SYN cookie.
> 
>


...

> Signed-off-by: Ricardo Dias <rdias@singlestore.com>
> ---



> +#endif
>  #include <net/secure_seq.h>
>  #include <net/ip.h>
>  #include <net/tcp.h>
> @@ -510,17 +513,27 @@ static u32 inet_sk_port_offset(const struct sock *sk)
>  					  inet->inet_dport);
>  }
>  
> -/* insert a socket into ehash, and eventually remove another one
> - * (The another one can be a SYN_RECV or TIMEWAIT
> +/* Insert a socket into ehash, and eventually remove another one
> + * (The another one can be a SYN_RECV or TIMEWAIT)
> + * If an existing socket already exists, it returns that socket
> + * through the esk parameter.
>   */
> -bool inet_ehash_insert(struct sock *sk, struct sock *osk)
> +bool inet_ehash_insert(struct sock *sk, struct sock *osk, struct sock **esk)
>  {
>  	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
>  	struct hlist_nulls_head *list;
>  	struct inet_ehash_bucket *head;
> -	spinlock_t *lock;
> +	const struct hlist_nulls_node *node;
> +	struct sock *_esk;

> +	spinlock_t *lock; /* protects hashinfo socket entry */
         Please do not add this comment, I find it confusing, and breaking reverse tree.

> +	struct net *net = sock_net(sk);
> +	const int dif = sk->sk_bound_dev_if;
> +	const int sdif = sk->sk_bound_dev_if;
>  	bool ret = true;
>  
> +	INET_ADDR_COOKIE(acookie, sk->sk_daddr, sk->sk_rcv_saddr);
> +	const __portpair ports = INET_COMBINED_PORTS(sk->sk_dport, sk->sk_num);
> +
>  	WARN_ON_ONCE(!sk_unhashed(sk));
>  
>  	sk->sk_hash = sk_ehashfn(sk);
> @@ -532,16 +545,49 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk)
>  	if (osk) {
>  		WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
>  		ret = sk_nulls_del_node_init_rcu(osk);
> +	} else if (esk) {

You could move here all the needed new variables, and also
     the INET_ADDR_COOKIE(...), const __portpair ports = ...;

This would allow to keep a nice reverse tree order, and keep scope small.

		const __portpair ports = INET_COMBINED_PORTS(sk->sk_dport, sk->sk_num);
		INET_ADDR_COOKIE(acookie, sk->sk_daddr, sk->sk_rcv_saddr);
		const int sdif = sk->sk_bound_dev_if;
		const int dif = sk->sk_bound_dev_if;
		const struct hlist_nulls_node *node;
		struct net *net = sock_net(sk);

Alternatively you could also move this code into a helper function.


               } else if (esk) {
                       *esk = inet_ehash_lookup_by_sk(sk, node);
               }

> +		sk_nulls_for_each_rcu(_esk, node, list) {
> +			if (_esk->sk_hash != sk->sk_hash)
> +				continue;
> +			if (sk->sk_family == AF_INET) {
> +				if (unlikely(INET_MATCH(_esk, net, acookie,
> +							sk->sk_daddr,
> +							sk->sk_rcv_saddr,
> +							ports, dif, sdif))) {
> +					refcount_inc(&_esk->sk_refcnt);
> +					goto found;
> +				}
> +			}
> +#if IS_ENABLED(CONFIG_IPV6)
> +			else if (sk->sk_family == AF_INET6) {
> +				if (unlikely(INET6_MATCH(_esk, net,
> +							 &sk->sk_v6_daddr,
> +							 &sk->sk_v6_rcv_saddr,
> +							 ports, dif, sdif))) {
> +					refcount_inc(&_esk->sk_refcnt);
> +					goto found;
> +				}
> +			}
> +#endif
> +		}
> +
>
