Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984A5660BB9
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 03:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjAGCFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 21:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjAGCFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 21:05:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EFE84BD9;
        Fri,  6 Jan 2023 18:05:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3E1AB81F55;
        Sat,  7 Jan 2023 02:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4362C433D2;
        Sat,  7 Jan 2023 02:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673057127;
        bh=vuRooI/0IKFfiukBgQuJyic73OVaQ9W2FXk647mejH0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s0Dme05qM2ZOWJJtuYVBV/KCzIKMnKd7jYhnCnoLup+/RpRcogmN8KK4Zm5P5vm3D
         8MNgauXeyOS1FC41Kg88QYoj0r8jN/KQdDhpfDYlrDu1OSdrEVx4Jlmm7+nVzhh6yR
         Q7CXEY38gguw/W3ejNTxaS2BDj6lvvdo/Q0eR1U7lgKSkbj99EpZCrAIx60tnDrYwJ
         HEv0O2MrPDYloS+BjKkZ+tBQhjskm9BJl8XuG4pTJ+tN8xv7qMWNxUJgbON2mAKE4W
         KPEN+KfXZYzJIbvU+I4CbHO1v9vAvJHIw7F4SJGNI1sx9t9HwssiDbOXS0G0wKfH0b
         i8BTstgh2U7yA==
Date:   Fri, 6 Jan 2023 18:05:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 3/5] crypto/net/tcp: Use crypto_pool for TCP-MD5
Message-ID: <20230106180526.6e65b54d@kernel.org>
In-Reply-To: <20230103184257.118069-4-dima@arista.com>
References: <20230103184257.118069-1-dima@arista.com>
        <20230103184257.118069-4-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Jan 2023 18:42:55 +0000 Dmitry Safonov wrote:
> Use crypto_pool API that was designed with tcp_md5sig_pool in mind.
> The conversion to use crypto_pool will allow:
> - to reuse ahash_request(s) for different users
> - to allocate only one per-CPU scratch buffer rather than a new one for
>   each user
> - to have a common API for net/ users that need ahash on RX/TX fast path

>  config TCP_MD5SIG
>  	bool "TCP: MD5 Signature Option support (RFC2385)"
> -	select CRYPTO
> +	select CRYPTO_POOL

Are you sure we don't need to select CRYPTO any more?
select does not resolve dependencies.

>  	select CRYPTO_MD5
>  	help
>  	  RFC2385 specifies a method of giving MD5 protection to TCP sessions.

> @@ -749,29 +746,27 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
>  		daddr = &ip6h->daddr;
>  	}
>  
> -	hp = tcp_get_md5sig_pool();
> -	if (!hp)
> +	if (crypto_pool_get(tcp_md5_crypto_pool_id, (struct crypto_pool *)&hp))

&hp.base ? To avoid the cast

>  		goto clear_hash_noput;
> -	req = hp->md5_req;
>  
> -	if (crypto_ahash_init(req))
> +	if (crypto_ahash_init(hp.req))
>  		goto clear_hash;
>  
> -	if (tcp_v6_md5_hash_headers(hp, daddr, saddr, th, skb->len))
> +	if (tcp_v6_md5_hash_headers(&hp, daddr, saddr, th, skb->len))
>  		goto clear_hash;
> -	if (tcp_md5_hash_skb_data(hp, skb, th->doff << 2))
> +	if (tcp_md5_hash_skb_data(&hp, skb, th->doff << 2))
>  		goto clear_hash;
> -	if (tcp_md5_hash_key(hp, key))
> +	if (tcp_md5_hash_key(&hp, key))
>  		goto clear_hash;
> -	ahash_request_set_crypt(req, NULL, md5_hash, 0);
> -	if (crypto_ahash_final(req))
> +	ahash_request_set_crypt(hp.req, NULL, md5_hash, 0);
> +	if (crypto_ahash_final(hp.req))
>  		goto clear_hash;
>  
> -	tcp_put_md5sig_pool();
> +	crypto_pool_put();
>  	return 0;
>  
>  clear_hash:
> -	tcp_put_md5sig_pool();
> +	crypto_pool_put();
>  clear_hash_noput:
>  	memset(md5_hash, 0, 16);
>  	return 1;

