Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281AA1AB636
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 05:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390887AbgDPD14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 23:27:56 -0400
Received: from mx.sdf.org ([205.166.94.20]:52995 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390005AbgDPD1z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 23:27:55 -0400
Received: from sdf.org (IDENT:lkml@faeroes.freeshell.org [205.166.94.9])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 03G3RbYQ025122
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Thu, 16 Apr 2020 03:27:37 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 03G3RZLv012120;
        Thu, 16 Apr 2020 03:27:35 GMT
Date:   Thu, 16 Apr 2020 03:27:35 GMT
Message-Id: <202004160327.03G3RZLv012120@sdf.org>
From:   George Spelvin <lkml@sdf.org>
Subject: [PATCH] tipc: Remove redundant tsk->published flag
To:     Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, netdev@vger.kernel.org
Cc:     lkml@sdf.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's supposed to always equal !list_empty(tsk->publications),
so just replace it with the latter.

I kept the tipc_sk_dump() output unchanged, but perhaps someone
who understands how that's used better would like to change it
to reflect the simplified structure accurately.

Signed-off-by: George Spelvin <lkml@sdf.org>
Cc: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: netdev@vger.kernel.org
---
I just happened to be looking at the code and noticed that
tsk->published could be reduced to a bool.  Then I noticed that
it could be deleted entirely.

It's a separate patch, but someone might want to move probe_unacked
to be with the rest of the bools so struct tipc_sock packs better.

 net/tipc/socket.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 1118e6815256..70cceb1782ff 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -73,7 +73,6 @@ struct sockaddr_pair {
  * @sk: socket - interacts with 'port' and with user via the socket API
  * @conn_type: TIPC type used when connection was established
  * @conn_instance: TIPC instance used when connection was established
- * @published: non-zero if port has one or more associated names
  * @max_pkt: maximum packet size "hint" used when building messages sent by port
  * @maxnagle: maximum size of msg which can be subject to nagle
  * @portid: unique port identity in TIPC socket hash table
@@ -96,7 +95,6 @@ struct tipc_sock {
 	struct sock sk;
 	u32 conn_type;
 	u32 conn_instance;
-	int published;
 	u32 max_pkt;
 	u32 maxnagle;
 	u32 portid;
@@ -1412,7 +1410,7 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 			return -EPIPE;
 		if (sk->sk_state != TIPC_OPEN)
 			return -EISCONN;
-		if (tsk->published)
+		if (!list_empty(&tsk->publications))
 			return -EOPNOTSUPP;
 		if (dest->addrtype == TIPC_ADDR_NAME) {
 			tsk->conn_type = dest->addr.name.name.type;
@@ -2824,7 +2822,6 @@ static int tipc_sk_publish(struct tipc_sock *tsk, uint scope,
 
 	list_add(&publ->binding_sock, &tsk->publications);
 	tsk->pub_count++;
-	tsk->published = 1;
 	return 0;
 }
 
@@ -2858,8 +2855,6 @@ static int tipc_sk_withdraw(struct tipc_sock *tsk, uint scope,
 				      publ->upper, publ->key);
 		rc = 0;
 	}
-	if (list_empty(&tsk->publications))
-		tsk->published = 0;
 	return rc;
 }
 
@@ -3743,7 +3738,6 @@ int tipc_nl_publ_dump(struct sk_buff *skb, struct netlink_callback *cb)
 bool tipc_sk_filtering(struct sock *sk)
 {
 	struct tipc_sock *tsk;
-	struct publication *p;
 	u32 _port, _sktype, _type, _lower, _upper;
 	u32 type = 0, lower = 0, upper = 0;
 
@@ -3767,14 +3761,12 @@ bool tipc_sk_filtering(struct sock *sk)
 	if (_sktype && _sktype != sk->sk_type)
 		return false;
 
-	if (tsk->published) {
-		p = list_first_entry_or_null(&tsk->publications,
-					     struct publication, binding_sock);
-		if (p) {
-			type = p->type;
-			lower = p->lower;
-			upper = p->upper;
-		}
+	if (!list_empty(&tsk->publications)) {
+		struct publication *p = list_first_entry(&tsk->publications,
+					    struct publication, binding_sock);
+		type = p->type;
+		lower = p->lower;
+		upper = p->upper;
 	}
 
 	if (!tipc_sk_type_connectionless(sk)) {
@@ -3847,7 +3839,7 @@ int tipc_sk_dump(struct sock *sk, u16 dqueues, char *buf)
 	size_t sz = (dqueues) ? SK_LMAX : SK_LMIN;
 	struct tipc_sock *tsk;
 	struct publication *p;
-	bool tsk_connected;
+	bool tsk_connected, tsk_published;
 
 	if (!sk) {
 		i += scnprintf(buf, sz, "sk data: (null)\n");
@@ -3868,8 +3860,9 @@ int tipc_sk_dump(struct sock *sk, u16 dqueues, char *buf)
 		i += scnprintf(buf + i, sz - i, " %u", tsk->conn_type);
 		i += scnprintf(buf + i, sz - i, " %u", tsk->conn_instance);
 	}
-	i += scnprintf(buf + i, sz - i, " | %u", tsk->published);
-	if (tsk->published) {
+	tsk_published = !list_empty(&tsk->publications);
+	i += scnprintf(buf + i, sz - i, " | %u", tsk_published);
+	if (tsk_published) {
 		p = list_first_entry_or_null(&tsk->publications,
 					     struct publication, binding_sock);
 		i += scnprintf(buf + i, sz - i, " %u", (p) ? p->type : 0);
-- 
2.26.1

