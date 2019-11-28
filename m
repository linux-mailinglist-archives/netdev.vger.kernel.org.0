Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C19C10C2CF
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 04:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbfK1DYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 22:24:17 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:32772 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727149AbfK1DYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 22:24:14 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 788D94B9CD;
        Thu, 28 Nov 2019 14:10:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mail_dkim; t=
        1574910611; bh=Cl/wowvmXOEHZUNtC64yXbBRXOZxkt+do4ooV8eAWLo=; b=U
        Is2qGcY5P1Ly0OG8G/op+be7RGaQy6r+ZaT4sDnK7JWDRC8pIvz+Yyvz4XzdNQMd
        9aRcKJVIzEd5J21AMvCSCJVnr5up0S8Z4WZtyQGkc3NQZ27Q31jQ4dDLvVMqTZsI
        zKmBLDOyMqCDV25Xpkus4UNCoS4nr7uSh8zld/OIm8=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RMQ2jDgjxGz1; Thu, 28 Nov 2019 14:10:11 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 5DFD34B9CE;
        Thu, 28 Nov 2019 14:10:11 +1100 (AEDT)
Received: from ubuntu.dek-tpc.internal (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id CDBF94B9CD;
        Thu, 28 Nov 2019 14:10:10 +1100 (AEDT)
From:   Tung Nguyen <tung.q.nguyen@dektech.com.au>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [tipc-discussion] [net v1 1/4] tipc: fix potential memory leak in __tipc_sendmsg()
Date:   Thu, 28 Nov 2019 10:10:05 +0700
Message-Id: <20191128031008.2045-2-tung.q.nguyen@dektech.com.au>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128031008.2045-1-tung.q.nguyen@dektech.com.au>
References: <20191128031008.2045-1-tung.q.nguyen@dektech.com.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When initiating a connection message to a server side, the connection
message is cloned and added to the socket write queue. However, if the
cloning is failed, only the socket write queue is purged. It causes
memory leak because the original connection message is not freed.

This commit fixes it by purging the list of connection message when
it cannot be cloned.

Fixes: 6787927475e5 ("tipc: buffer overflow handling in listener socket")
Reported-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
---
 net/tipc/socket.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index a1c8d722ca20..7baed2c2c93d 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1447,8 +1447,10 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 	rc = tipc_msg_build(hdr, m, 0, dlen, mtu, &pkts);
 	if (unlikely(rc != dlen))
 		return rc;
-	if (unlikely(syn && !tipc_msg_skb_clone(&pkts, &sk->sk_write_queue)))
+	if (unlikely(syn && !tipc_msg_skb_clone(&pkts, &sk->sk_write_queue))) {
+		__skb_queue_purge(&pkts);
 		return -ENOMEM;
+	}
 
 	trace_tipc_sk_sendmsg(sk, skb_peek(&pkts), TIPC_DUMP_SK_SNDQ, " ");
 	rc = tipc_node_xmit(net, &pkts, dnode, tsk->portid);
-- 
2.17.1

