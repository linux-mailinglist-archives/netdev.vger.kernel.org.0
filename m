Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E5E11821B
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 09:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfLJIVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 03:21:20 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:33042 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726801AbfLJIVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 03:21:19 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 41EEA4BD39;
        Tue, 10 Dec 2019 19:21:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mail_dkim; t=
        1575966077; bh=JzqEo9PmNchVjaM9ANgUE9qBB65GuV47whoJpcTCXXk=; b=C
        Avm8TPW8I/HF4xLLRfYbBUNy3pIauR5O7PZXU1puS7rd+u+zjAc9xLl/uR9W2c5w
        w575zedq9lwvmpDUvClOUjD2L+3ZDai5iJqv31cC3GXKnnRn1ErhyJOyKW3lRT4o
        QMcPImB77IoljfJe7+jIYtfykHQWHlBIBkWycyn0Bs=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vqZ16qtxM8F5; Tue, 10 Dec 2019 19:21:17 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 15E634BD38;
        Tue, 10 Dec 2019 19:21:17 +1100 (AEDT)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id F05E54BD3A;
        Tue, 10 Dec 2019 19:21:15 +1100 (AEDT)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jon.maloy@ericsson.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net 3/4] tipc: fix retrans failure due to wrong destination
Date:   Tue, 10 Dec 2019 15:21:04 +0700
Message-Id: <20191210082105.23905-4-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191210082105.23905-1-tuong.t.lien@dektech.com.au>
References: <20191210082105.23905-1-tuong.t.lien@dektech.com.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a user message is sent, TIPC will check if the socket has faced a
congestion at link layer. If that happens, it will make a sleep to wait
for the congestion to disappear. This leaves a gap for other users to
take over the socket (e.g. multi threads) since the socket is released
as well. Also, in case of connectionless (e.g. SOCK_RDM), user is free
to send messages to various destinations (e.g. via 'sendto()'), then
the socket's preformatted header has to be updated correspondingly
prior to the actual payload message building.

Unfortunately, the latter action is done before the first action which
causes a condition issue that the destination of a certain message can
be modified incorrectly in the middle, leading to wrong destination
when that message is built. Consequently, when the message is sent to
the link layer, it gets stuck there forever because the peer node will
simply reject it. After a number of retransmission attempts, the link
is eventually taken down and the retransmission failure is reported.

This commit fixes the problem by rearranging the order of actions to
prevent the race condition from occurring, so the message building is
'atomic' and its header will not be modified by anyone.

Fixes: 365ad353c256 ("tipc: reduce risk of user starvation during link congestion")
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/socket.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 41688da233ab..6552f986774c 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1364,8 +1364,8 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 	struct tipc_msg *hdr = &tsk->phdr;
 	struct tipc_name_seq *seq;
 	struct sk_buff_head pkts;
-	u32 dport, dnode = 0;
-	u32 type, inst;
+	u32 dport = 0, dnode = 0;
+	u32 type = 0, inst = 0;
 	int mtu, rc;
 
 	if (unlikely(dlen > TIPC_MAX_USER_MSG_SIZE))
@@ -1418,23 +1418,11 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 		type = dest->addr.name.name.type;
 		inst = dest->addr.name.name.instance;
 		dnode = dest->addr.name.domain;
-		msg_set_type(hdr, TIPC_NAMED_MSG);
-		msg_set_hdr_sz(hdr, NAMED_H_SIZE);
-		msg_set_nametype(hdr, type);
-		msg_set_nameinst(hdr, inst);
-		msg_set_lookup_scope(hdr, tipc_node2scope(dnode));
 		dport = tipc_nametbl_translate(net, type, inst, &dnode);
-		msg_set_destnode(hdr, dnode);
-		msg_set_destport(hdr, dport);
 		if (unlikely(!dport && !dnode))
 			return -EHOSTUNREACH;
 	} else if (dest->addrtype == TIPC_ADDR_ID) {
 		dnode = dest->addr.id.node;
-		msg_set_type(hdr, TIPC_DIRECT_MSG);
-		msg_set_lookup_scope(hdr, 0);
-		msg_set_destnode(hdr, dnode);
-		msg_set_destport(hdr, dest->addr.id.ref);
-		msg_set_hdr_sz(hdr, BASIC_H_SIZE);
 	} else {
 		return -EINVAL;
 	}
@@ -1445,6 +1433,22 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 	if (unlikely(rc))
 		return rc;
 
+	if (dest->addrtype == TIPC_ADDR_NAME) {
+		msg_set_type(hdr, TIPC_NAMED_MSG);
+		msg_set_hdr_sz(hdr, NAMED_H_SIZE);
+		msg_set_nametype(hdr, type);
+		msg_set_nameinst(hdr, inst);
+		msg_set_lookup_scope(hdr, tipc_node2scope(dnode));
+		msg_set_destnode(hdr, dnode);
+		msg_set_destport(hdr, dport);
+	} else { /* TIPC_ADDR_ID */
+		msg_set_type(hdr, TIPC_DIRECT_MSG);
+		msg_set_lookup_scope(hdr, 0);
+		msg_set_destnode(hdr, dnode);
+		msg_set_destport(hdr, dest->addr.id.ref);
+		msg_set_hdr_sz(hdr, BASIC_H_SIZE);
+	}
+
 	__skb_queue_head_init(&pkts);
 	mtu = tipc_node_get_mtu(net, dnode, tsk->portid, false);
 	rc = tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
-- 
2.13.7

