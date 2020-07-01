Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA9D2101B9
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 04:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgGACCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 22:02:20 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35250 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgGACCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 22:02:20 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jqS4h-00058w-Ea; Wed, 01 Jul 2020 12:02:12 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 01 Jul 2020 12:02:11 +1000
Date:   Wed, 1 Jul 2020 12:02:11 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <edumazet@google.com>
Cc:     mathieu.desnoyers@efficios.com, davem@davemloft.net,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, ycheng@google.com, joraj@efficios.com
Subject: Re: [regression] TCP_MD5SIG on established sockets
Message-ID: <20200701020211.GA6875@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLPqtJG0iESCHF+RcOjo95ukan1oSzjkPjoSJgKpO2wSQ@mail.gmail.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> wrote:
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 810cc164f795f8e1e8ca747ed5df51bb20fec8a2..ecc0e3fabce8b03bef823cbfc5c1b0a9e24df124
> 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4034,9 +4034,12 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
> int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct
> tcp_md5sig_key *key)
> {
>        struct scatterlist sg;
> +       u8 keylen = key->keylen;
> 
> -       sg_init_one(&sg, key->key, key->keylen);
> -       ahash_request_set_crypt(hp->md5_req, &sg, NULL, key->keylen);
> +       smp_rmb(); /* paired with smp_wmb() in tcp_md5_do_add() */
> +
> +       sg_init_one(&sg, key->key, keylen);
> +       ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
>        return crypto_ahash_update(hp->md5_req);
> }
> EXPORT_SYMBOL(tcp_md5_hash_key);
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index ad6435ba6d72ffd8caf783bb25cad7ec151d6909..99916fcc15ca0be12c2c133ff40516f79e6fdf7f
> 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1113,6 +1113,9 @@ int tcp_md5_do_add(struct sock *sk, const union
> tcp_md5_addr *addr,
>        if (key) {
>                /* Pre-existing entry - just update that one. */
>                memcpy(key->key, newkey, newkeylen);
> +
> +               smp_wmb(); /* pairs with smp_rmb() in tcp_md5_hash_key() */
> +
>                key->keylen = newkeylen;
>                return 0;
>        }

This doesn't make sense.  Your smp_rmb only guarantees that you
see a version of key->key that's newer than keylen.  What if the
key got changed twice? You could still read more than what's in
the key (if that's what you're trying to protect against).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
