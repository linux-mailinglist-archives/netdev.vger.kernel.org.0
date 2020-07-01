Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D42210FB4
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731815AbgGAPuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgGAPuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 11:50:22 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BE4C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 08:50:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s90so26521276ybi.6
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 08:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=RG/Us6aZK/MneimX+UYU9JZLMriGZQZPMxQ/iH/I+Ic=;
        b=RiekDSZ1ysy4hSNCufjuBrd77W+YozMa/cc0DDO5XvB6AFBMKtdQeQqGuLY5awnntR
         DsVbqWbBAJN7C7fRYU5+gwXZz7aS2kB9PtSFbKC22FkIGMSN+XASSGxkNb9UlN7IZo48
         XAuBHUUOxSRTZbMRll/xtYx4g6rkv+iUiwtaESeamtgDCuGp8uBpGFfpDo7HE359wL/W
         C537Y0JZnVyVCUT7c8raPkgKZh+sYh6xfNqeNoBshfugET3rPXmPwxGhjTOj/Q3k3CsO
         gFaQ2zBkRvqk+DWY7liZxcw/Y5WQF82HkRTpvsYHeo3Etd+mKGpo5v1ZVBhhPfVpBFEg
         61eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=RG/Us6aZK/MneimX+UYU9JZLMriGZQZPMxQ/iH/I+Ic=;
        b=k5LZBHt8idWbF6nKZnZsgeAM2NEKu98/FvKNgNvLyiNROXqygGLN+2OU94XoyYy5Ik
         R949mz3mDqG84GMnb0marZKok8HjsH7YaZ600Vur5FH/Sk6B4EmccCTKv/31cHLr7njj
         7zp10SMC8JT4r42IzjrrZvI595nOH5zK9xuBEZxj+9Q2rRhG32qpfWCHdNO6bvRb5bZW
         OB/Cat9Tw32fsKhH42PoN7nBZxbMBO8UpaKSsn1BwR4k/MXCA0FlwKk3dEJTeRjjifxF
         TA8NQVAl2gGiIHgzF7S3o5Kkno0wQPqL7omcBnd662GtpgJKRvN/AzhNzkmfTWFa/nsB
         iiRQ==
X-Gm-Message-State: AOAM530GGakXLOqT51Hfr6s6iMoL+UbSlJgmyDBNPKUCwaT0XJebc7iT
        JFRbl0Avo6oFzfBdvdyQr6vJWl888WqrZg==
X-Google-Smtp-Source: ABdhPJxvFcHYT7KsFIckBC+9oLwOHdE7RP+C6HHTIZLPjKfkWzTnCkJvYdAB1kmxtXhbCh1ee6CSkEM6uftJ+g==
X-Received: by 2002:a5b:610:: with SMTP id d16mr41487507ybq.289.1593618621694;
 Wed, 01 Jul 2020 08:50:21 -0700 (PDT)
Date:   Wed,  1 Jul 2020 08:50:18 -0700
Message-Id: <20200701155018.3502985-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH net] tcp: md5: refine tcp_md5_do_add()/tcp_md5_hash_key() barriers
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My prior fix went a bit too far, according to Herbert and Mathieu.

Since we accept that concurrent TCP MD5 lookups might see inconsistent
keys, we can use READ_ONCE()/WRITE_ONCE() instead of smp_rmb()/smp_wmb()

Clearing all key->key[] is needed to avoid possible KMSAN reports,
if key->keylen is increased. Since tcp_md5_do_add() is not fast path,
using __GFP_ZERO to clear all struct tcp_md5sig_key is simpler.

data_race() was added in linux-5.8 and will prevent KCSAN reports,
this can safely be removed in stable backports, if data_race() is
not yet backported.

Fixes: 6a2febec338d ("tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 net/ipv4/tcp.c      |  4 +---
 net/ipv4/tcp_ipv4.c | 19 ++++++++++++++-----
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f111660453241692a17c881dd6dc2910a1236263..c3af8180c7049d5c4987bf5c67e4aff2ed6967c9 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4033,11 +4033,9 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
 
 int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key *key)
 {
-	u8 keylen = key->keylen;
+	u8 keylen = READ_ONCE(key->keylen); /* paired with WRITE_ONCE() in tcp_md5_do_add */
 	struct scatterlist sg;
 
-	smp_rmb(); /* paired with smp_wmb() in tcp_md5_do_add() */
-
 	sg_init_one(&sg, key->key, keylen);
 	ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
 	return crypto_ahash_update(hp->md5_req);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 99916fcc15ca0be12c2c133ff40516f79e6fdf7f..04bfcbbfee83aadf5bca0332275c57113abdbc75 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1111,12 +1111,21 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 
 	key = tcp_md5_do_lookup_exact(sk, addr, family, prefixlen, l3index);
 	if (key) {
-		/* Pre-existing entry - just update that one. */
-		memcpy(key->key, newkey, newkeylen);
+		/* Pre-existing entry - just update that one.
+		 * Note that the key might be used concurrently.
+		 * data_race() is telling kcsan that we do not care of
+		 * key mismatches, since changing MD5 key on live flows
+		 * can lead to packet drops.
+		 */
+		data_race(memcpy(key->key, newkey, newkeylen));
 
-		smp_wmb(); /* pairs with smp_rmb() in tcp_md5_hash_key() */
+		/* Pairs with READ_ONCE() in tcp_md5_hash_key().
+		 * Also note that a reader could catch new key->keylen value
+		 * but old key->key[], this is the reason we use __GFP_ZERO
+		 * at sock_kmalloc() time below these lines.
+		 */
+		WRITE_ONCE(key->keylen, newkeylen);
 
-		key->keylen = newkeylen;
 		return 0;
 	}
 
@@ -1132,7 +1141,7 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		rcu_assign_pointer(tp->md5sig_info, md5sig);
 	}
 
-	key = sock_kmalloc(sk, sizeof(*key), gfp);
+	key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
 	if (!key)
 		return -ENOMEM;
 	if (!tcp_alloc_md5sig_pool()) {
-- 
2.27.0.212.ge8ba1cc988-goog

