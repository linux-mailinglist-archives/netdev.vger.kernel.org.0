Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07CC2181A82
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 14:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbgCKNzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 09:55:55 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51907 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729745AbgCKNzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 09:55:52 -0400
Received: by mail-wm1-f65.google.com with SMTP id a132so2205761wme.1
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 06:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=HYy1iFsw5dP0llgymR9IjcBgXqRO6QhQTbXUDxRyBJk=;
        b=m9CiBff2BLh9SMcStjsXltKajFKQt2VixB8u/t1gwstGN5Pt3OpG6DqsKVB+QbUDyH
         N1wI0SakZqWAHWSnU/dUk7tk1Ve6Y6QXl24KzsJLnylhdyWmsQ1UZCIjbOXh7cGCOiHU
         ODLYh2oCDbagEPvMA/o+VXcmzqm9HZjSn4uG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=HYy1iFsw5dP0llgymR9IjcBgXqRO6QhQTbXUDxRyBJk=;
        b=I34B7enWgdyrTjFUecHOAT3Ujn3ztdhaWS+qWWjDcbL3G2ipw30w4MY23nPVg3IebR
         4yZTg6eNYEsQo/uuEHvg5Vmq+zkNSjoelZdKvOtbr+KgoVqHOezukbwTXpHnoGoPv6rD
         1Pj2Bf5zGPGMyl7pD4KhZxZWjnrWtWWZSE+tnwFnTB3d/NXyQ6XLJHDefN4P1UYnl/6j
         H2CckRG9sLkXBKBpf0CyTl1EEyIxSIB/JNXMHOhQD/naJAx4AmrtOPRGYXPNN/v/ypA6
         QjJKxLbQm9AfsUH43UGEBQHfzvnRJz36gJCCi8kdhl3ejQQ7LO+DvprYlJj2wZKjG3CG
         xcQQ==
X-Gm-Message-State: ANhLgQ1OvCra1CL/2TftFU0EgdFm0LcSvfneC6n/LRsYVR/Sk9/4K5Mk
        hyy6DRL1wJcO2qTtEGII5anFmg==
X-Google-Smtp-Source: ADFU+vvtCO4yJX7EcoGaYZf1s6nhDdZr4yLmSwU6WJ3x1R9fSf6pkAMO1ChjkcygEpbVqNBBcpqvXA==
X-Received: by 2002:a1c:c906:: with SMTP id f6mr4056966wmb.16.1583934949066;
        Wed, 11 Mar 2020 06:55:49 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id x13sm8401596wmj.5.2020.03.11.06.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 06:55:48 -0700 (PDT)
References: <20200310174711.7490-1-lmb@cloudflare.com> <20200310174711.7490-4-lmb@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] bpf: convert sock map and hash to map_copy_value
In-reply-to: <20200310174711.7490-4-lmb@cloudflare.com>
Date:   Wed, 11 Mar 2020 14:55:47 +0100
Message-ID: <87v9nbxafw.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, Mar 10, 2020 at 06:47 PM CET, Lorenz Bauer wrote:
> Migrate sockmap and sockhash to use map_copy_value instead of
> map_lookup_elem_sys_only.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  net/core/sock_map.c | 48 ++++++++++++++++++++++++++++++---------------
>  1 file changed, 32 insertions(+), 16 deletions(-)
>
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index a7075b3b4489..03e04426cd21 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -344,19 +344,34 @@ static void *sock_map_lookup(struct bpf_map *map, void *key)
>  	return __sock_map_lookup_elem(map, *(u32 *)key);
>  }
>
> -static void *sock_map_lookup_sys(struct bpf_map *map, void *key)
> +static int __sock_map_copy_value(struct bpf_map *map, struct sock *sk,
> +				 void *value)
> +{
> +	switch (map->value_size) {
> +	case sizeof(u64):
> +		sock_gen_cookie(sk);
> +		*(u64 *)value = atomic64_read(&sk->sk_cookie);

You could use sock_gen_cookie return value to merge the two above
statements into one. sock_gen_cookie also reads out the value.

> +		return 0;
> +
> +	default:
> +		return -ENOSPC;
> +	}
> +}
> +
> +static int sock_map_copy_value(struct bpf_map *map, void *key, void *value)
>  {
>  	struct sock *sk;
> +	int ret = -ENOENT;
>
> -	if (map->value_size != sizeof(u64))
> -		return ERR_PTR(-ENOSPC);
> -
> +	rcu_read_lock();
>  	sk = __sock_map_lookup_elem(map, *(u32 *)key);
>  	if (!sk)
> -		return ERR_PTR(-ENOENT);
> +		goto out;
>
> -	sock_gen_cookie(sk);
> -	return &sk->sk_cookie;
> +	ret = __sock_map_copy_value(map, sk, value);
> +out:
> +	rcu_read_unlock();
> +	return ret;
>  }
>
>  static int __sock_map_delete(struct bpf_stab *stab, struct sock *sk_test,
> @@ -636,7 +651,7 @@ const struct bpf_map_ops sock_map_ops = {
>  	.map_alloc		= sock_map_alloc,
>  	.map_free		= sock_map_free,
>  	.map_get_next_key	= sock_map_get_next_key,
> -	.map_lookup_elem_sys_only = sock_map_lookup_sys,
> +	.map_copy_value		= sock_map_copy_value,
>  	.map_update_elem	= sock_map_update_elem,
>  	.map_delete_elem	= sock_map_delete_elem,
>  	.map_lookup_elem	= sock_map_lookup,
> @@ -1030,19 +1045,20 @@ static void sock_hash_free(struct bpf_map *map)
>  	kfree(htab);
>  }
>
> -static void *sock_hash_lookup_sys(struct bpf_map *map, void *key)
> +static int sock_hash_copy_value(struct bpf_map *map, void *key, void *value)
>  {
>  	struct sock *sk;
> +	int ret = -ENOENT;
>
> -	if (map->value_size != sizeof(u64))
> -		return ERR_PTR(-ENOSPC);
> -
> +	rcu_read_lock();
>  	sk = __sock_hash_lookup_elem(map, key);
>  	if (!sk)
> -		return ERR_PTR(-ENOENT);
> +		goto out;
>
> -	sock_gen_cookie(sk);
> -	return &sk->sk_cookie;
> +	ret = __sock_map_copy_value(map, sk, value);
> +out:
> +	rcu_read_unlock();
> +	return ret;
>  }
>
>  static void *sock_hash_lookup(struct bpf_map *map, void *key)
> @@ -1139,7 +1155,7 @@ const struct bpf_map_ops sock_hash_ops = {
>  	.map_update_elem	= sock_hash_update_elem,
>  	.map_delete_elem	= sock_hash_delete_elem,
>  	.map_lookup_elem	= sock_hash_lookup,
> -	.map_lookup_elem_sys_only = sock_hash_lookup_sys,
> +	.map_copy_value		= sock_hash_copy_value,
>  	.map_release_uref	= sock_hash_release_progs,
>  	.map_check_btf		= map_check_no_btf,
>  };
