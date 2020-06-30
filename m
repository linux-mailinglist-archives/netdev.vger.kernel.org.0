Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD292100B5
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 01:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgF3XrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 19:47:04 -0400
Received: from mail.efficios.com ([167.114.26.124]:40824 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbgF3XrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 19:47:03 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 7D56E2C835C;
        Tue, 30 Jun 2020 19:47:02 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id mVbGtM213tMx; Tue, 30 Jun 2020 19:47:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 3D9402C8472;
        Tue, 30 Jun 2020 19:47:02 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 3D9402C8472
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1593560822;
        bh=JZpBaj1ngv5v+CLHHxDDQ/dBFJ7ch0A+FK5gLZG1eeg=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=SbZfL5de2C5rucrJg2qMWP+VSKH32IzOjpAfVWvqRSltOkB4OhH9Hk3MJuoaRS9oz
         WdoJc9tiwqil1FzuhXwhfXV0fjqXm0ihtb0UlxY0zjYVOQ/dEbOAgLXPp0FMMO1ECD
         fAhvMnzycc1cw2PMOZpuD8R66xgreJQGRcb9jw9sgjG2qQXjz9tcwfzuqqOAHWsktq
         XAo5UcfqIJn5lBs0E0NjbHyWRxcZKPKpuuEq8Fbd6gFucfBM+DKq/7ZB+nkEf9eb6h
         wz0Boz+jnjVnqtRx+ShKVkg9RrhVrHylYTk+sqbTTM0QvsWofcoJKkbtiuhfxibY4s
         0t2iQvStn/oiQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id cDiSwPo_NedY; Tue, 30 Jun 2020 19:47:02 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 2B8072C846F;
        Tue, 30 Jun 2020 19:47:02 -0400 (EDT)
Date:   Tue, 30 Jun 2020 19:47:02 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1359584061.18162.1593560822147.JavaMail.zimbra@efficios.com>
In-Reply-To: <20200630234101.3259179-1-edumazet@google.com>
References: <20200630234101.3259179-1-edumazet@google.com>
Subject: Re: [PATCH net] tcp: md5: add missing memory barriers in
 tcp_md5_do_add()/tcp_md5_hash_key()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3945 (ZimbraWebClient - FF77 (Linux)/8.8.15_GA_3928)
Thread-Topic: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()
Thread-Index: 1T3kxl1XAVoSg61Ydxf+0IxBAFdIfA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jun 30, 2020, at 7:41 PM, Eric Dumazet edumazet@google.com wrote:

> MD5 keys are read with RCU protection, and tcp_md5_do_add()
> might update in-place a prior key.
> 
> Normally, typical RCU updates would allocate a new piece
> of memory. In this case only key->key and key->keylen might
> be updated, and we do not care if an incoming packet could
> see the old key, the new one, or some intermediate value,
> since changing the key on a live flow is known to be problematic
> anyway.

What makes it acceptable to observe an intermediate bogus key during the
transition ?

Thanks,

Mathieu

> 
> We only want to make sure that in the case key->keylen
> is changed, cpus in tcp_md5_hash_key() wont try to use
> uninitialized data, or crash because key->keylen was
> read twice to feed sg_init_one() and ahash_request_set_crypt()
> 
> Fixes: 9ea88a153001 ("tcp: md5: check md5 signature without socket lock")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
> net/ipv4/tcp.c      | 7 +++++--
> net/ipv4/tcp_ipv4.c | 3 +++
> 2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index
> 810cc164f795f8e1e8ca747ed5df51bb20fec8a2..f111660453241692a17c881dd6dc2910a1236263
> 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4033,10 +4033,13 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
> 
> int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key
> *key)
> {
> +	u8 keylen = key->keylen;
> 	struct scatterlist sg;
> 
> -	sg_init_one(&sg, key->key, key->keylen);
> -	ahash_request_set_crypt(hp->md5_req, &sg, NULL, key->keylen);
> +	smp_rmb(); /* paired with smp_wmb() in tcp_md5_do_add() */
> +
> +	sg_init_one(&sg, key->key, keylen);
> +	ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
> 	return crypto_ahash_update(hp->md5_req);
> }
> EXPORT_SYMBOL(tcp_md5_hash_key);
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index
> ad6435ba6d72ffd8caf783bb25cad7ec151d6909..99916fcc15ca0be12c2c133ff40516f79e6fdf7f
> 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1113,6 +1113,9 @@ int tcp_md5_do_add(struct sock *sk, const union
> tcp_md5_addr *addr,
> 	if (key) {
> 		/* Pre-existing entry - just update that one. */
> 		memcpy(key->key, newkey, newkeylen);
> +
> +		smp_wmb(); /* pairs with smp_rmb() in tcp_md5_hash_key() */
> +
> 		key->keylen = newkeylen;
> 		return 0;
> 	}
> --
> 2.27.0.212.ge8ba1cc988-goog

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
