Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD17459A46
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 03:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhKWC6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 21:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbhKWC6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 21:58:13 -0500
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C6EC061574;
        Mon, 22 Nov 2021 18:55:06 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1637636104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=52vdmk14dpjUPkwHwmBkYoj3RfviEUSB/FwUKCDqYOA=;
        b=lJf+sLFDljisSTLY4NzQk28i8It9VlEdR4aGCEXRzSXtCQNuyC8iWLmZUy2lPITAVJHWKe
        3QgwbA3u2FVcE88cipOpJnHJXfeKrCpf483/wrY0qhwViwXS2oqsTvpluWknuwM/RQZFUQ
        So3iBz4wAPDR6GxTgrDAXKqhUMsvKIM=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     eric.dumazet@gmail.com, dsahern@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next v2] neigh: introduce neigh_confirm() helper function
Date:   Tue, 23 Nov 2021 10:54:30 +0800
Message-Id: <20211123025430.22254-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add neigh_confirm() for the confirmed member in struct neighbour,
it can be called as an independent unit by other functions.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/net/arp.h       |  8 +-------
 include/net/ndisc.h     | 16 ++--------------
 include/net/neighbour.h | 11 +++++++++++
 include/net/sock.h      |  5 +----
 4 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/include/net/arp.h b/include/net/arp.h
index 4950191f6b2b..031374ac2f22 100644
--- a/include/net/arp.h
+++ b/include/net/arp.h
@@ -53,13 +53,7 @@ static inline void __ipv4_confirm_neigh(struct net_device *dev, u32 key)
 
 	rcu_read_lock_bh();
 	n = __ipv4_neigh_lookup_noref(dev, key);
-	if (n) {
-		unsigned long now = jiffies;
-
-		/* avoid dirtying neighbour */
-		if (READ_ONCE(n->confirmed) != now)
-			WRITE_ONCE(n->confirmed, now);
-	}
+	neigh_confirm(n);
 	rcu_read_unlock_bh();
 }
 
diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 04341d86585d..53cb8de0e589 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -411,13 +411,7 @@ static inline void __ipv6_confirm_neigh(struct net_device *dev,
 
 	rcu_read_lock_bh();
 	n = __ipv6_neigh_lookup_noref(dev, pkey);
-	if (n) {
-		unsigned long now = jiffies;
-
-		/* avoid dirtying neighbour */
-		if (READ_ONCE(n->confirmed) != now)
-			WRITE_ONCE(n->confirmed, now);
-	}
+	neigh_confirm(n);
 	rcu_read_unlock_bh();
 }
 
@@ -428,13 +422,7 @@ static inline void __ipv6_confirm_neigh_stub(struct net_device *dev,
 
 	rcu_read_lock_bh();
 	n = __ipv6_neigh_lookup_noref_stub(dev, pkey);
-	if (n) {
-		unsigned long now = jiffies;
-
-		/* avoid dirtying neighbour */
-		if (READ_ONCE(n->confirmed) != now)
-			WRITE_ONCE(n->confirmed, now);
-	}
+	neigh_confirm(n);
 	rcu_read_unlock_bh();
 }
 
diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 38a0c1d24570..55af812c3ed5 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -321,6 +321,17 @@ static inline struct neighbour *__neigh_lookup_noref(struct neigh_table *tbl,
 	return ___neigh_lookup_noref(tbl, tbl->key_eq, tbl->hash, pkey, dev);
 }
 
+static inline void neigh_confirm(struct neighbour *n)
+{
+	if (n) {
+		unsigned long now = jiffies;
+
+		/* avoid dirtying neighbour */
+		if (READ_ONCE(n->confirmed) != now)
+			WRITE_ONCE(n->confirmed, now);
+	}
+}
+
 void neigh_table_init(int index, struct neigh_table *tbl);
 int neigh_table_clear(int index, struct neigh_table *tbl);
 struct neighbour *neigh_lookup(struct neigh_table *tbl, const void *pkey,
diff --git a/include/net/sock.h b/include/net/sock.h
index a79fc772324e..e7c231373875 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2135,13 +2135,10 @@ static inline void sock_confirm_neigh(struct sk_buff *skb, struct neighbour *n)
 {
 	if (skb_get_dst_pending_confirm(skb)) {
 		struct sock *sk = skb->sk;
-		unsigned long now = jiffies;
 
-		/* avoid dirtying neighbour */
-		if (READ_ONCE(n->confirmed) != now)
-			WRITE_ONCE(n->confirmed, now);
 		if (sk && READ_ONCE(sk->sk_dst_pending_confirm))
 			WRITE_ONCE(sk->sk_dst_pending_confirm, 0);
+		neigh_confirm(n);
 	}
 }
 
-- 
2.32.0

