Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C581455463
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 06:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243144AbhKRFrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 00:47:03 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:36280 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243139AbhKRFrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 00:47:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637214243; x=1668750243;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ay8ZR0PXuPKuC2XChYPhgWXqj53aNF7+Hv0kWWr0c7Q=;
  b=ReLUDeQCH5zljNoP18vtcORCeEQTwjHU+oau26a1pbZuP3ZQ+cBiIoA7
   ji+FcK59yF8nRScX0O7USDpf2ktb8S5Zq6PgOqtNb4Os2aYSYdpjR9z2O
   hKMfa6cQSrDu+JSbDul6FrFf/pFHdijUWcKIMlyFE7DIScYGA1NfrGF4o
   E=;
X-IronPort-AV: E=Sophos;i="5.87,243,1631577600"; 
   d="scan'208";a="157415215"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-39fdda15.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 18 Nov 2021 05:44:02 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-39fdda15.us-west-2.amazon.com (Postfix) with ESMTPS id EE30B41783;
        Thu, 18 Nov 2021 05:44:00 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 18 Nov 2021 05:44:00 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.106) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 18 Nov 2021 05:43:57 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <kuniyu@amazon.co.jp>, <benh@amazon.com>, <eric.dumazet@gmail.com>,
        <kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 12/13] af_unix: Replace the big lock with small locks.
Date:   Thu, 18 Nov 2021 14:43:51 +0900
Message-ID: <20211118054351.9907-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211114012428.81743-13-kuniyu@amazon.co.jp>
References: <20211114012428.81743-13-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.106]
X-ClientProxiedBy: EX13D18UWC003.ant.amazon.com (10.43.162.237) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm resending this not to be missed because I sent this to myself by
mistake..
I'm sorry for bothering you.

From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Date:   Sun, 14 Nov 2021 10:24:27 +0900
> The hash table of AF_UNIX sockets is protected by the single lock.  This
> patch replaces it with per-hash locks.
[...]
> +static void unix_table_double_lock(unsigned int hash1, unsigned int hash2)
> +{
> +	/* hash1 and hash2 is never the same because
> +	 * one is between 0 and UNIX_HASH_SIZE - 1, and
> +	 * another is between UNIX_HASH_SIZE and UNIX_HASH_SIZE * 2.
> +	 */
> +	if (hash1 > hash2)
> +		swap(hash1, hash2);
> +
> +	spin_lock(&unix_table_locks[hash1]);
> +	spin_lock_nested(&unix_table_locks[hash2], SINGLE_DEPTH_NESTING);
> +}
> +
> +static void unix_table_double_unlock(unsigned int hash1, unsigned int hash2)
> +{
> +	spin_unlock(&unix_table_locks[hash1]);
> +	spin_unlock(&unix_table_locks[hash2]);
> +}

The status is "Changes Requested" on patchwork because of some newly added
sparse warnings.  There are two kinds of warnings.  One is about
unix_table_double_lock/unlock() and the other is about unix_seq_start/stop().

https://patchwork.hopto.org/static/nipa/579645/12617773/build_32bit/summary

---8<---
+../net/unix/af_unix.c:159:13: warning: context imbalance in 'unix_table_double_lock' - wrong count at exit
+../net/unix/af_unix.c:172:13: warning: context imbalance in 'unix_table_double_unlock' - unexpected unlock
+../net/unix/af_unix.c:1258:13: warning: context imbalance in 'unix_state_double_lock' - wrong count at exit
+../net/unix/af_unix.c:1276:17: warning: context imbalance in 'unix_state_double_unlock' - unexpected unlock
+../net/unix/af_unix.c:1579:9: warning: context imbalance in 'unix_stream_connect' - different lock contexts for basic block
+../net/unix/af_unix.c:1944:25: warning: context imbalance in 'unix_dgram_sendmsg' - unexpected unlock
+../net/unix/af_unix.c:3255:28: warning: context imbalance in 'unix_next_socket' - unexpected unlock
+../net/unix/af_unix.c:3284:28: warning: context imbalance in 'unix_seq_stop' - unexpected unlock
---8<---


We can avoid the former by adding these annotations, but it seems a little
bit redundant.  Also, there has already been the same kind of warnings for
unix_state_double_lock() without sparse annotations.

---8<---
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 89a844e7141b..b26a2ea26029 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -157,6 +157,8 @@ static unsigned int unix_abstract_hash(struct sockaddr_un *sunaddr,
 }
 
 static void unix_table_double_lock(unsigned int hash1, unsigned int hash2)
+	__acquires(unix_table_locks)
+	__acquires(unix_table_locks)
 {
 	/* hash1 and hash2 is never the same because
 	 * one is between 0 and UNIX_HASH_SIZE - 1, and
@@ -170,6 +172,8 @@ static void unix_table_double_lock(unsigned int hash1, unsigned int hash2)
 }
 
 static void unix_table_double_unlock(unsigned int hash1, unsigned int hash2)
+	__releases(unix_table_locks)
+	__releases(unix_table_locks)
 {
 	spin_unlock(&unix_table_locks[hash1]);
 	spin_unlock(&unix_table_locks[hash2]);
---8<---


[...]
> @@ -3216,7 +3235,7 @@ static struct sock *unix_next_socket(struct seq_file *seq,
>  				     struct sock *sk,
>  				     loff_t *pos)
>  {
> -	unsigned long bucket;
> +	unsigned long bucket = get_bucket(*pos);
>  
>  	while (sk > (struct sock *)SEQ_START_TOKEN) {
>  		sk = sk_next(sk);
> @@ -3227,12 +3246,13 @@ static struct sock *unix_next_socket(struct seq_file *seq,
>  	}
>  
>  	do {
> +		spin_lock(&unix_table_locks[bucket]);
>  		sk = unix_from_bucket(seq, pos);
>  		if (sk)
>  			return sk;
>  
>  next_bucket:
> -		bucket = get_bucket(*pos) + 1;
> +		spin_unlock(&unix_table_locks[bucket++]);
>  		*pos = set_bucket_offset(bucket, 1);
>  	} while (bucket < ARRAY_SIZE(unix_socket_table));
>  
> @@ -3240,10 +3260,7 @@ static struct sock *unix_next_socket(struct seq_file *seq,
>  }
>  
>  static void *unix_seq_start(struct seq_file *seq, loff_t *pos)
> -	__acquires(unix_table_lock)
>  {
> -	spin_lock(&unix_table_lock);
> -
>  	if (!*pos)
>  		return SEQ_START_TOKEN;
>  
> @@ -3260,9 +3277,11 @@ static void *unix_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>  }
>  
>  static void unix_seq_stop(struct seq_file *seq, void *v)
> -	__releases(unix_table_lock)
>  {
> -	spin_unlock(&unix_table_lock);
> +	struct sock *sk = v;
> +
> +	if (sk)
> +		spin_unlock(&unix_table_locks[sk->sk_hash]);
>  }
>  
>  static int unix_seq_show(struct seq_file *seq, void *v)
[...]

The latter happens by replacing the big lock with per-hash locks.
It moves spin_lock() from unix_seq_start() to unix_next_socket().
unix_next_socket() keeps holding a lock until it returns NULL, so Sparse
cannot understand the logic.  At least, we can add __releases annotation in
unix_seq_stop(), but it rather increases warnings.  And tcp_seq_stop() does
not have annotations.

Are these warnings acceptable, or is there any better way?
