Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553B7210085
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 01:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgF3XlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 19:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgF3XlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 19:41:05 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D041C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 16:41:05 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id w18so14862507qvd.16
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 16:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qKAEXHGOkFXex5c7r1EBg/D4TNJkEbIG9k4XF0JPjuU=;
        b=pmyyxCbHpGFF/swWcGTTjtpKTFzLZuXOWsKOUXg29SGZWSeTKV3t3oF5gF2Zq73/iU
         Q/mEJ2k5punmH8r2vzYDacRNqw9xnRpG+WECqoygwrC2/XquLwLtshvT6OLqNgjFy9Zy
         vA75mZWrxfX+TXjU9LAThYQKeFiK/PFc7EzyabdSiRuXOMQgyfPkTG6uv+0xp9M+Gu00
         x+dbPW167zeRkz+Lp+Juq77rdTE1eD4lVv5yvPHiHkcieCbFQkBvKSWB9nYTN0ufYBNP
         FnvqyRRkK6zEZwdn/1fQRn3tC7+1WC3JIMVlegWC03GfmKyHJDnk+d3VeFlsbt+mfgFF
         Bsgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qKAEXHGOkFXex5c7r1EBg/D4TNJkEbIG9k4XF0JPjuU=;
        b=Gi+ZrJxx9XEcXHZu+BznjEqV6tYiCJRkMHWCx6+8JHnhQYzNXNXvB/Gn0kQOiTL0l3
         s8iykd6WqQeXEh2CzLieNdYpVhP2nzwHqm+OfH3VvgZPyiifOYnt4Tb7MXLI072kjHuE
         PqSyXUVlnrTqX+fggUp2zh7SPBYfTkTCFIwzQO4FKIYpclTqqbypm2VR/ZaDihB+hVzD
         PboFnw+dZvy/rpPkyejEE2Qpifql6WfF7+WaK/T3GE/b78wNHSE+/YL7wxsdDwVqfl1x
         J7wCOFmvO33x21zY/7idb113j0iFZMcAUQkMtvEjKZYv9LENLctoy8L7MK3o6ehg3AvI
         PWtg==
X-Gm-Message-State: AOAM530d3XAsaqHfBnEJPQEq8VRceVZNSkTgs9ohk0dkijmyP/9hP9pB
        olU5mXr427WPPAXyZ5JFS6GT+vbKQt5QZw==
X-Google-Smtp-Source: ABdhPJy9nbYdwE009T3ltQc40+v0m1zdQczbDugNjtqt5cBdIQU1EsfcP15wFdHuRumlmdc/CdJs3n4OBiWW0w==
X-Received: by 2002:a05:6214:13c6:: with SMTP id cg6mr22876994qvb.160.1593560464226;
 Tue, 30 Jun 2020 16:41:04 -0700 (PDT)
Date:   Tue, 30 Jun 2020 16:41:01 -0700
Message-Id: <20200630234101.3259179-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH net] tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MD5 keys are read with RCU protection, and tcp_md5_do_add()
might update in-place a prior key.

Normally, typical RCU updates would allocate a new piece
of memory. In this case only key->key and key->keylen might
be updated, and we do not care if an incoming packet could
see the old key, the new one, or some intermediate value,
since changing the key on a live flow is known to be problematic
anyway.

We only want to make sure that in the case key->keylen
is changed, cpus in tcp_md5_hash_key() wont try to use
uninitialized data, or crash because key->keylen was
read twice to feed sg_init_one() and ahash_request_set_crypt()

Fixes: 9ea88a153001 ("tcp: md5: check md5 signature without socket lock")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 net/ipv4/tcp.c      | 7 +++++--
 net/ipv4/tcp_ipv4.c | 3 +++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 810cc164f795f8e1e8ca747ed5df51bb20fec8a2..f111660453241692a17c881dd6dc2910a1236263 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4033,10 +4033,13 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
 
 int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key *key)
 {
+	u8 keylen = key->keylen;
 	struct scatterlist sg;
 
-	sg_init_one(&sg, key->key, key->keylen);
-	ahash_request_set_crypt(hp->md5_req, &sg, NULL, key->keylen);
+	smp_rmb(); /* paired with smp_wmb() in tcp_md5_do_add() */
+
+	sg_init_one(&sg, key->key, keylen);
+	ahash_request_set_crypt(hp->md5_req, &sg, NULL, keylen);
 	return crypto_ahash_update(hp->md5_req);
 }
 EXPORT_SYMBOL(tcp_md5_hash_key);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ad6435ba6d72ffd8caf783bb25cad7ec151d6909..99916fcc15ca0be12c2c133ff40516f79e6fdf7f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1113,6 +1113,9 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	if (key) {
 		/* Pre-existing entry - just update that one. */
 		memcpy(key->key, newkey, newkeylen);
+
+		smp_wmb(); /* pairs with smp_rmb() in tcp_md5_hash_key() */
+
 		key->keylen = newkeylen;
 		return 0;
 	}
-- 
2.27.0.212.ge8ba1cc988-goog

