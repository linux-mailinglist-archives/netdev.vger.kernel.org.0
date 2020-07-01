Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A172112F0
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 20:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgGASnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 14:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgGASnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 14:43:07 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903E3C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 11:43:07 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id p4so18555850pgf.10
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 11:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=HV2qrYCyXvlD69oT1pEv+4sNYrnZj8gZpQMVRjXCOPI=;
        b=hF1ZlytJwh83DLeWvU6UMwIJP7NmpUIncOK+jSkQ3TQfl+14DVTw5u8WbVCr+yhT+f
         ubosHXJGw0lPWCypFBhkoPf5oAkJwpHKtLwHSLcJUnUVw5Ya+esVMdlVn7bc4ciP3xLJ
         AAIOjLxzGz01Jyud7vQg7yVzRDcN52OLIVB3dW5unq8ZPV/UO/KxREPAnV5UZ0/DNs15
         kW4Z0VZo1Um0Rwh1zKVjYKSWbr9nM+KO432OqBcxEFNHeAubiFUBkzhVcwGhse+5uJ9y
         OT9ci6B6xVO3Lywjor7AmAvAmDQtIQ4pTTdkyogek3ny3oqFhKJP9I/rNNGJoPjVZCwt
         lNbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=HV2qrYCyXvlD69oT1pEv+4sNYrnZj8gZpQMVRjXCOPI=;
        b=Jst9lPFkHrnOnJ1R+NtlgLE9yhw/96+VePxRgiLTW51dzekmMaauJkrhseE5Hy/u4l
         0SWVngwN5E50hv9tyjF82tHzrCsGNozRBD3avPwHWPZ2Xa+SyJ3F1wggX269Lhauq20h
         k8rz7jvyhfxB+Urlqyi9dibetpChsA3SniLzzZVbTSMN0onnDq+eO9h9A8m8qfT2uSZ1
         BhssanipFxcYJHLz7jLkFJ0NM/vGAe1sqj7eakELrbd7NmFWP0xfj0A0iklTZbuPWupc
         n0fOmP7NT1Zp+P1FuhFy/0HPF4hVTMTrGN3xCJWFf4R3eCjj7Zs0NJGu/qyCoWmGLQLY
         PaqA==
X-Gm-Message-State: AOAM531nfHNErNsDPyeBiD+gX+gnGyua0MdtytkaFVSVsC/oDkH0Hu7r
        w4rhvNqPwKbQIo3KV6Ux1dmTTe77SIJL6A==
X-Google-Smtp-Source: ABdhPJw5Taa/aqT0x7QtkeB8qcO9VsAojCB7QqR3NwxeG7BWf23lM709fKXFLGMvo/reNUfYTzrUwm/sWzd0Hg==
X-Received: by 2002:a63:a119:: with SMTP id b25mr20652616pgf.10.1593628987044;
 Wed, 01 Jul 2020 11:43:07 -0700 (PDT)
Date:   Wed,  1 Jul 2020 11:43:04 -0700
Message-Id: <20200701184304.3685065-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH v2 net] tcp: md5: refine tcp_md5_do_add()/tcp_md5_hash_key() barriers
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Marco Elver <elver@google.com>
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

v2: use data_race() both in tcp_md5_hash_key() and tcp_md5_do_add()

Fixes: 6a2febec338d ("tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Marco Elver <elver@google.com>
---
 net/ipv4/tcp.c      |  8 ++++----
 net/ipv4/tcp_ipv4.c | 19 ++++++++++++++-----
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f111660453241692a17c881dd6dc2910a1236263..c33f7c6aff8eea81d374644cd251bd2b96292651 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4033,14 +4033,14 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
 
 int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key *key)
 {
-	u8 keylen = key->keylen;
+	u8 keylen = READ_ONCE(key->keylen); /* paired with WRITE_ONCE() in tcp_md5_do_add */
 	struct scatterlist sg;
 
-	smp_rmb(); /* paired with smp_wmb() in tcp_md5_do_add() */
-
 	sg_init_one(&sg, key->key, keylen);
 	ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
-	return crypto_ahash_update(hp->md5_req);
+
+	/* We use data_race() because tcp_md5_do_add() might change key->key under us */
+	return data_race(crypto_ahash_update(hp->md5_req));
 }
 EXPORT_SYMBOL(tcp_md5_hash_key);
 
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

