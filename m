Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBD0810C2D0
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 04:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfK1DYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 22:24:19 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:32783 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727141AbfK1DYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 22:24:14 -0500
X-Greylist: delayed 838 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Nov 2019 22:24:13 EST
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 205BB4B9CF;
        Thu, 28 Nov 2019 14:10:13 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mail_dkim; t=
        1574910613; bh=0fURPnsR9s3KVuwTUtvs/nX0SoQMyI2PmBYvhfsBQRw=; b=M
        PimndOPKkCpdz3JpBplUp54qvx2P8/hB6gP1MURXAfsuU3ypcuA7N9bYDs5b5+P/
        lEF6Evwx+xs6BSSovkwGX7YET5XZX9hf65LOfLPZB68yb1Z7ddl6uSCABxGa/dEc
        uhIrarpF9jJU9ZcyQBuDiOdO89xySIi6FZNGFDz4QM=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id K4wFSEkMsjKL; Thu, 28 Nov 2019 14:10:13 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 0587C4B9D0;
        Thu, 28 Nov 2019 14:10:13 +1100 (AEDT)
Received: from ubuntu.dek-tpc.internal (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 6C9314B9CF;
        Thu, 28 Nov 2019 14:10:12 +1100 (AEDT)
From:   Tung Nguyen <tung.q.nguyen@dektech.com.au>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [tipc-discussion] [net v1 3/4] tipc: fix wrong timeout input for tipc_wait_for_cond()
Date:   Thu, 28 Nov 2019 10:10:07 +0700
Message-Id: <20191128031008.2045-4-tung.q.nguyen@dektech.com.au>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128031008.2045-1-tung.q.nguyen@dektech.com.au>
References: <20191128031008.2045-1-tung.q.nguyen@dektech.com.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In function __tipc_shutdown(), the timeout value passed to
tipc_wait_for_cond() is not jiffies.

This commit fixes it by converting that value from milliseconds
to jiffies.

Fixes: 365ad353c256 ("tipc: reduce risk of user starvation during link congestion")
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
---
 net/tipc/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index fb5595081a05..da5fb84852a6 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -532,7 +532,7 @@ static void __tipc_shutdown(struct socket *sock, int error)
 	struct sock *sk = sock->sk;
 	struct tipc_sock *tsk = tipc_sk(sk);
 	struct net *net = sock_net(sk);
-	long timeout = CONN_TIMEOUT_DEFAULT;
+	long timeout = msecs_to_jiffies(CONN_TIMEOUT_DEFAULT);
 	u32 dnode = tsk_peer_node(tsk);
 	struct sk_buff *skb;
 
-- 
2.17.1

