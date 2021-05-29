Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5687394CA7
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 17:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhE2PPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 11:15:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229800AbhE2PPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 11:15:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622301250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fTOvoEAYR7CJVYjUZnymbtPcTYaNQE9/dqDMqvelCVk=;
        b=FjSmaxQUBqhFLQfwubBPAn+bQ/KhX29JPeG27fU/cil87UDG+ySYcWx/PmAn/pdqWGnGFS
        b6tU/+I74XxL8ur01QSOBZoOsVs0j6teZLLfzQYST1kZabOrQASU21OFItdCVL7khTeDiF
        5rV5XT9XpPL7xQP1yywEcUmk9Okqovs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-UE4oI3H0MFSVljLoswkg0w-1; Sat, 29 May 2021 11:14:06 -0400
X-MC-Unique: UE4oI3H0MFSVljLoswkg0w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4D56180FD65;
        Sat, 29 May 2021 15:14:04 +0000 (UTC)
Received: from ymir.virt.lab.eng.bos.redhat.com (virtlab420.virt.lab.eng.bos.redhat.com [10.19.152.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2769C1A881;
        Sat, 29 May 2021 15:14:02 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 1/3] tipc: eliminate redundant fields in struct tipc_sock
Date:   Sat, 29 May 2021 11:13:58 -0400
Message-Id: <20210529151400.781539-2-jmaloy@redhat.com>
In-Reply-To: <20210529151400.781539-1-jmaloy@redhat.com>
References: <20210529151400.781539-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We eliminate the redundant fields conn_type and conn_instance in
struct tipc_sock. On the connecting side, this information is already
present in the unused (after the connection is established) part of
the pre-allocated header, and on the accepting side, we put it there
when the new socket is created.

Reviewed-by: Xin Long <lucien.xin@gmail.com>
Tested-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/socket.c | 53 ++++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 53af72824c9c..cb2d9fffbc5d 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -73,9 +73,6 @@ struct sockaddr_pair {
 /**
  * struct tipc_sock - TIPC socket structure
  * @sk: socket - interacts with 'port' and with user via the socket API
- * @conn_type: TIPC type used when connection was established
- * @conn_instance: TIPC instance used when connection was established
- * @published: non-zero if port has one or more associated names
  * @max_pkt: maximum packet size "hint" used when building messages sent by port
  * @maxnagle: maximum size of msg which can be subject to nagle
  * @portid: unique port identity in TIPC socket hash table
@@ -106,11 +103,11 @@ struct sockaddr_pair {
  * @expect_ack: whether this TIPC socket is expecting an ack
  * @nodelay: setsockopt() TIPC_NODELAY setting
  * @group_is_open: TIPC socket group is fully open (FIXME)
+ * @published: true if port has one or more associated names
+ * @conn_addrtype: address type used when establishing connection
  */
 struct tipc_sock {
 	struct sock sk;
-	u32 conn_type;
-	u32 conn_instance;
 	u32 max_pkt;
 	u32 maxnagle;
 	u32 portid;
@@ -141,6 +138,7 @@ struct tipc_sock {
 	bool nodelay;
 	bool group_is_open;
 	bool published;
+	u8 conn_addrtype;
 };
 
 static int tipc_sk_backlog_rcv(struct sock *sk, struct sk_buff *skb);
@@ -1463,10 +1461,8 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 			return -EISCONN;
 		if (tsk->published)
 			return -EOPNOTSUPP;
-		if (atype == TIPC_SERVICE_ADDR) {
-			tsk->conn_type = ua->sa.type;
-			tsk->conn_instance = ua->sa.instance;
-		}
+		if (atype == TIPC_SERVICE_ADDR)
+			tsk->conn_addrtype = atype;
 		msg_set_syn(hdr, 1);
 	}
 
@@ -1783,10 +1779,10 @@ static int tipc_sk_anc_data_recv(struct msghdr *m, struct sk_buff *skb,
 		anc_data[2] = msg_nameupper(msg);
 		break;
 	case TIPC_CONN_MSG:
-		has_name = (tsk->conn_type != 0);
-		anc_data[0] = tsk->conn_type;
-		anc_data[1] = tsk->conn_instance;
-		anc_data[2] = tsk->conn_instance;
+		has_name = !!tsk->conn_addrtype;
+		anc_data[0] = msg_nametype(&tsk->phdr);
+		anc_data[1] = msg_nameinst(&tsk->phdr);
+		anc_data[2] = anc_data[1];
 		break;
 	default:
 		has_name = 0;
@@ -2750,8 +2746,9 @@ static int tipc_accept(struct socket *sock, struct socket *new_sock, int flags,
 
 	tsk_set_importance(new_sk, msg_importance(msg));
 	if (msg_named(msg)) {
-		new_tsock->conn_type = msg_nametype(msg);
-		new_tsock->conn_instance = msg_nameinst(msg);
+		new_tsock->conn_addrtype = TIPC_SERVICE_ADDR;
+		msg_set_nametype(&new_tsock->phdr, msg_nametype(msg));
+		msg_set_nameinst(&new_tsock->phdr, msg_nameinst(msg));
 	}
 
 	/*
@@ -3455,13 +3452,14 @@ void tipc_socket_stop(void)
 /* Caller should hold socket lock for the passed tipc socket. */
 static int __tipc_nl_add_sk_con(struct sk_buff *skb, struct tipc_sock *tsk)
 {
-	u32 peer_node;
-	u32 peer_port;
+	u32 peer_node, peer_port;
+	u32 conn_type, conn_instance;
 	struct nlattr *nest;
 
 	peer_node = tsk_peer_node(tsk);
 	peer_port = tsk_peer_port(tsk);
-
+	conn_type = msg_nametype(&tsk->phdr);
+	conn_instance = msg_nameinst(&tsk->phdr);
 	nest = nla_nest_start_noflag(skb, TIPC_NLA_SOCK_CON);
 	if (!nest)
 		return -EMSGSIZE;
@@ -3471,12 +3469,12 @@ static int __tipc_nl_add_sk_con(struct sk_buff *skb, struct tipc_sock *tsk)
 	if (nla_put_u32(skb, TIPC_NLA_CON_SOCK, peer_port))
 		goto msg_full;
 
-	if (tsk->conn_type != 0) {
+	if (tsk->conn_addrtype != 0) {
 		if (nla_put_flag(skb, TIPC_NLA_CON_FLAG))
 			goto msg_full;
-		if (nla_put_u32(skb, TIPC_NLA_CON_TYPE, tsk->conn_type))
+		if (nla_put_u32(skb, TIPC_NLA_CON_TYPE, conn_type))
 			goto msg_full;
-		if (nla_put_u32(skb, TIPC_NLA_CON_INST, tsk->conn_instance))
+		if (nla_put_u32(skb, TIPC_NLA_CON_INST, conn_instance))
 			goto msg_full;
 	}
 	nla_nest_end(skb, nest);
@@ -3866,9 +3864,9 @@ bool tipc_sk_filtering(struct sock *sk)
 	}
 
 	if (!tipc_sk_type_connectionless(sk)) {
-		type = tsk->conn_type;
-		lower = tsk->conn_instance;
-		upper = tsk->conn_instance;
+		type = msg_nametype(&tsk->phdr);
+		lower = msg_nameinst(&tsk->phdr);
+		upper = lower;
 	}
 
 	if ((_type && _type != type) || (_lower && _lower != lower) ||
@@ -3933,6 +3931,7 @@ int tipc_sk_dump(struct sock *sk, u16 dqueues, char *buf)
 {
 	int i = 0;
 	size_t sz = (dqueues) ? SK_LMAX : SK_LMIN;
+	u32 conn_type, conn_instance;
 	struct tipc_sock *tsk;
 	struct publication *p;
 	bool tsk_connected;
@@ -3953,8 +3952,10 @@ int tipc_sk_dump(struct sock *sk, u16 dqueues, char *buf)
 	if (tsk_connected) {
 		i += scnprintf(buf + i, sz - i, " %x", tsk_peer_node(tsk));
 		i += scnprintf(buf + i, sz - i, " %u", tsk_peer_port(tsk));
-		i += scnprintf(buf + i, sz - i, " %u", tsk->conn_type);
-		i += scnprintf(buf + i, sz - i, " %u", tsk->conn_instance);
+		conn_type = msg_nametype(&tsk->phdr);
+		conn_instance = msg_nameinst(&tsk->phdr);
+		i += scnprintf(buf + i, sz - i, " %u", conn_type);
+		i += scnprintf(buf + i, sz - i, " %u", conn_instance);
 	}
 	i += scnprintf(buf + i, sz - i, " | %u", tsk->published);
 	if (tsk->published) {
-- 
2.31.1

