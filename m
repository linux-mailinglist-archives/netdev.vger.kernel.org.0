Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4ED4CCCB1
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 05:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237458AbiCDEyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 23:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbiCDEyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 23:54:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA063140ED
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 20:53:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73A8461B5C
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 04:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80509C340E9;
        Fri,  4 Mar 2022 04:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646369635;
        bh=bJhiQ1NkaYEHc+Jv68It+vxBLFk7DAyGdV2XCln1Bhc=;
        h=From:To:Cc:Subject:Date:From;
        b=uY4sY31ZyWjqzbET6qjka+OqZhqZi+iyY6HotBY4sp61qOrpJQYb36p4qCq1XVVLH
         n7YvzrRb7aoIZHvhk2oDHCvep33ZFi9G+O60VNAc0aBvlfapnIXtbqm+Py8pGqO+Iu
         vxXYrc3c6wfTS7bRaC6A8iuGZtsB8Hrrsm/ITY69nSzuyawZi7290V/0MvT+P9vorV
         pO8+ywO40j3lHWiu45+gbp29ySl1xDkwNDQ9S4xj/eJJjwYMWjL4bJmfGRG1Y3EtLu
         fNnXc3gzNR1NjZVE8FnllphgMMPo2+E0oOV1ftpurTR+vm0cHHa+gsrgm+gYYilxru
         d6BdaOtoCj5SA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, dsahern@gmail.com,
        menglong8.dong@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] skb: make drop reason booleanable
Date:   Thu,  3 Mar 2022 20:53:53 -0800
Message-Id: <20220304045353.1534702-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have a number of cases where function returns drop/no drop
decision as a boolean. Now that we want to report the reason
code as well we have to pass extra output arguments.

We can make the reason code evaluate correctly as bool.

I believe we're good to reorder the reasons as they are
reported to user space as strings.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
This patch implements what I suggested in review at some
point but which was not implemented. IDK if it wasn't
understood or the idea is bad?
---
 include/linux/skbuff.h |  1 +
 include/net/tcp.h      | 21 +++++++++++----------
 net/ipv4/tcp.c         | 21 +++++++++------------
 net/ipv4/tcp_ipv4.c    | 12 +++++++-----
 net/ipv6/tcp_ipv6.c    | 11 +++++++----
 5 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5445860e1ba6..b8e0652c0fb0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -314,6 +314,7 @@ struct sk_buff;
  * used to translate the reason to string.
  */
 enum skb_drop_reason {
+	SKB_OKAY = 0,
 	SKB_DROP_REASON_NOT_SPECIFIED,	/* drop reason is not specified */
 	SKB_DROP_REASON_NO_SOCKET,	/* socket not found */
 	SKB_DROP_REASON_PKT_TOO_SMALL,	/* packet size is too small */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index d486d7b6112d..467ed2dd32c9 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1674,10 +1674,11 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
 		return NULL;
 	return __tcp_md5_do_lookup(sk, l3index, addr, family);
 }
-bool tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
-			  enum skb_drop_reason *reason,
-			  const void *saddr, const void *daddr,
-			  int family, int dif, int sdif);
+
+enum skb_drop_reason
+tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
+		     const void *saddr, const void *daddr,
+		     int family, int dif, int sdif);
 
 
 #define tcp_twsk_md5_key(twsk)	((twsk)->tw_md5_key)
@@ -1688,13 +1689,13 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
 {
 	return NULL;
 }
-static inline bool tcp_inbound_md5_hash(const struct sock *sk,
-					const struct sk_buff *skb,
-					enum skb_drop_reason *reason,
-					const void *saddr, const void *daddr,
-					int family, int dif, int sdif)
+
+static inline enum skb_drop_reason
+tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
+		     const void *saddr, const void *daddr,
+		     int family, int dif, int sdif);
 {
-	return false;
+	return __SKB_OKAY;
 }
 #define tcp_twsk_md5_key(twsk)	NULL
 #endif
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 68f1236b2858..33e9e1e4d041 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4432,10 +4432,10 @@ int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5sig_key *ke
 EXPORT_SYMBOL(tcp_md5_hash_key);
 
 /* Called with rcu_read_lock() */
-bool tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
-			  enum skb_drop_reason *reason,
-			  const void *saddr, const void *daddr,
-			  int family, int dif, int sdif)
+enum skb_drop_reason
+tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
+		     const void *saddr, const void *daddr,
+		     int family, int dif, int sdif)
 {
 	/*
 	 * This gets called for each TCP segment that arrives
@@ -4462,18 +4462,16 @@ bool tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 
 	/* We've parsed the options - do we have a hash? */
 	if (!hash_expected && !hash_location)
-		return false;
+		return SKB_OKAY;
 
 	if (hash_expected && !hash_location) {
-		*reason = SKB_DROP_REASON_TCP_MD5NOTFOUND;
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
-		return true;
+		return SKB_DROP_REASON_TCP_MD5NOTFOUND;
 	}
 
 	if (!hash_expected && hash_location) {
-		*reason = SKB_DROP_REASON_TCP_MD5UNEXPECTED;
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5UNEXPECTED);
-		return true;
+		return SKB_DROP_REASON_TCP_MD5UNEXPECTED;
 	}
 
 	/* check the signature */
@@ -4481,7 +4479,6 @@ bool tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 						 NULL, skb);
 
 	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
-		*reason = SKB_DROP_REASON_TCP_MD5FAILURE;
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
 		if (family == AF_INET) {
 			net_info_ratelimited("MD5 Hash failed for (%pI4, %d)->(%pI4, %d)%s L3 index %d\n",
@@ -4495,9 +4492,9 @@ bool tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 					saddr, ntohs(th->source),
 					daddr, ntohs(th->dest), l3index);
 		}
-		return true;
+		return SKB_DROP_REASON_TCP_MD5FAILURE;
 	}
-	return false;
+	return SKB_OKAY;
 }
 EXPORT_SYMBOL(tcp_inbound_md5_hash);
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 411357ad9757..81694a354110 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1965,9 +1965,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		if (unlikely(tcp_inbound_md5_hash(sk, skb, &drop_reason,
-						  &iph->saddr, &iph->daddr,
-						  AF_INET, dif, sdif))) {
+		drop_reason = tcp_inbound_md5_hash(sk, skb,
+						   &iph->saddr, &iph->daddr,
+						   AF_INET, dif, sdif);
+		if (unlikely(drop_reason)) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
@@ -2041,8 +2042,9 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		goto discard_and_relse;
 	}
 
-	if (tcp_inbound_md5_hash(sk, skb, &drop_reason, &iph->saddr,
-				 &iph->daddr, AF_INET, dif, sdif))
+	drop_reason = tcp_inbound_md5_hash(sk, skb, &iph->saddr,
+					   &iph->daddr, AF_INET, dif, sdif);
+	if (drop_reason)
 		goto discard_and_relse;
 
 	nf_reset_ct(skb);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index cb2bb7d2e907..13678d3908fa 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1632,8 +1632,10 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		if (tcp_inbound_md5_hash(sk, skb, &drop_reason, &hdr->saddr,
-					 &hdr->daddr, AF_INET6, dif, sdif)) {
+		drop_reason = tcp_inbound_md5_hash(sk, skb,
+						   &hdr->saddr, &hdr->daddr,
+						   AF_INET6, dif, sdif);
+		if (drop_reason) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
@@ -1704,8 +1706,9 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		goto discard_and_relse;
 	}
 
-	if (tcp_inbound_md5_hash(sk, skb, &drop_reason, &hdr->saddr,
-				 &hdr->daddr, AF_INET6, dif, sdif))
+	drop_reason = tcp_inbound_md5_hash(sk, skb, &hdr->saddr, &hdr->daddr,
+					   AF_INET6, dif, sdif);
+	if (drop_reason)
 		goto discard_and_relse;
 
 	if (tcp_filter(sk, skb)) {
-- 
2.34.1

