Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62631210FE0
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731948AbgGAP5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:57:22 -0400
Received: from mail.efficios.com ([167.114.26.124]:60692 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729308AbgGAP5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 11:57:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 29F0A2CF054;
        Wed,  1 Jul 2020 11:57:20 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id n4i1Skvkw3Cr; Wed,  1 Jul 2020 11:57:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id D1A952CEF1C;
        Wed,  1 Jul 2020 11:57:19 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com D1A952CEF1C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1593619039;
        bh=2gNuyFxYkFU3G0pIUnxco4R1vzlrucakNUN0ZbYnpzQ=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=CoXqzFoBIsS5aji2FBsF6WUCqE0+vjJMAUzTfQFsintkzvG3xfbb1vvLX6yZ7j6Sg
         w5YxpPLL9jZlWFy0gWRjO41AWaoU79LDYtyCeQZkj9rZNLPws5ndlM+faxMIqQ0D2s
         RZhWiBU26mxy90rMf1hsFBGw0ChTIxqgtE8vBxQRG6wOvciTjJqO9d/YV05k1vMlWO
         VWYEnxMrPvLwZ1/PSml7UuY+kMII0umhjq2tWPfA9qLU7XiHCekVN0n/234SeMFVc3
         wnBPd8fqF3KrIuRUuzxesaQFteMLT0BTvnKndKleSiMOfqcGy+6gY8z3ZdzlNBhErh
         J3Yqq8C3sxHBQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id scX2_Obhm3M8; Wed,  1 Jul 2020 11:57:19 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id B33BC2CF163;
        Wed,  1 Jul 2020 11:57:19 -0400 (EDT)
Date:   Wed, 1 Jul 2020 11:57:19 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <723842718.19296.1593619039697.JavaMail.zimbra@efficios.com>
In-Reply-To: <20200701155018.3502985-1-edumazet@google.com>
References: <20200701155018.3502985-1-edumazet@google.com>
Subject: Re: [PATCH net] tcp: md5: refine
 tcp_md5_do_add()/tcp_md5_hash_key() barriers
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3945 (ZimbraWebClient - FF77 (Linux)/8.8.15_GA_3928)
Thread-Topic: md5: refine tcp_md5_do_add()/tcp_md5_hash_key() barriers
Thread-Index: nDA90RXX/MdWqE7twVlTL8MpK8ikXg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jul 1, 2020, at 11:50 AM, Eric Dumazet edumazet@google.com wrote:

> My prior fix went a bit too far, according to Herbert and Mathieu.
> 
> Since we accept that concurrent TCP MD5 lookups might see inconsistent
> keys, we can use READ_ONCE()/WRITE_ONCE() instead of smp_rmb()/smp_wmb()
> 
> Clearing all key->key[] is needed to avoid possible KMSAN reports,
> if key->keylen is increased. Since tcp_md5_do_add() is not fast path,
> using __GFP_ZERO to clear all struct tcp_md5sig_key is simpler.
> 
> data_race() was added in linux-5.8 and will prevent KCSAN reports,
> this can safely be removed in stable backports, if data_race() is
> not yet backported.
> 
> Fixes: 6a2febec338d ("tcp: md5: add missing memory barriers in
> tcp_md5_do_add()/tcp_md5_hash_key()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> net/ipv4/tcp.c      |  4 +---
> net/ipv4/tcp_ipv4.c | 19 ++++++++++++++-----
> 2 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index
> f111660453241692a17c881dd6dc2910a1236263..c3af8180c7049d5c4987bf5c67e4aff2ed6967c9
> 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4033,11 +4033,9 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
> 
> int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key
> *key)
> {
> -	u8 keylen = key->keylen;
> +	u8 keylen = READ_ONCE(key->keylen); /* paired with WRITE_ONCE() in
> tcp_md5_do_add */
> 	struct scatterlist sg;
> 
> -	smp_rmb(); /* paired with smp_wmb() in tcp_md5_do_add() */
> -
> 	sg_init_one(&sg, key->key, keylen);
> 	ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
> 	return crypto_ahash_update(hp->md5_req);

I think we should change this to:

    return data_race(crypto_ahash_update(hp->md5_req));

because both sides can race on the data. Hopefully that would let
KCSAN know that deep within the ->update callback the data race
is OK (?)

Thanks,

Mathieu

> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index
> 99916fcc15ca0be12c2c133ff40516f79e6fdf7f..04bfcbbfee83aadf5bca0332275c57113abdbc75
> 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1111,12 +1111,21 @@ int tcp_md5_do_add(struct sock *sk, const union
> tcp_md5_addr *addr,
> 
> 	key = tcp_md5_do_lookup_exact(sk, addr, family, prefixlen, l3index);
> 	if (key) {
> -		/* Pre-existing entry - just update that one. */
> -		memcpy(key->key, newkey, newkeylen);
> +		/* Pre-existing entry - just update that one.
> +		 * Note that the key might be used concurrently.
> +		 * data_race() is telling kcsan that we do not care of
> +		 * key mismatches, since changing MD5 key on live flows
> +		 * can lead to packet drops.
> +		 */
> +		data_race(memcpy(key->key, newkey, newkeylen));
> 
> -		smp_wmb(); /* pairs with smp_rmb() in tcp_md5_hash_key() */
> +		/* Pairs with READ_ONCE() in tcp_md5_hash_key().
> +		 * Also note that a reader could catch new key->keylen value
> +		 * but old key->key[], this is the reason we use __GFP_ZERO
> +		 * at sock_kmalloc() time below these lines.
> +		 */
> +		WRITE_ONCE(key->keylen, newkeylen);
> 
> -		key->keylen = newkeylen;
> 		return 0;
> 	}
> 
> @@ -1132,7 +1141,7 @@ int tcp_md5_do_add(struct sock *sk, const union
> tcp_md5_addr *addr,
> 		rcu_assign_pointer(tp->md5sig_info, md5sig);
> 	}
> 
> -	key = sock_kmalloc(sk, sizeof(*key), gfp);
> +	key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
> 	if (!key)
> 		return -ENOMEM;
> 	if (!tcp_alloc_md5sig_pool()) {
> --
> 2.27.0.212.ge8ba1cc988-goog

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
