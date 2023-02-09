Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F400690754
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjBIL1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjBIL0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:26:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40946567D;
        Thu,  9 Feb 2023 03:20:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D5167CE2470;
        Thu,  9 Feb 2023 11:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1238CC433A4;
        Thu,  9 Feb 2023 11:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941584;
        bh=T1kifxKCcz36WRe+I26DJfv71M1mq8/SHh41hZWGDKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSmvBwcs09nxhb/DOwo8hWXAg9nlgBJDkrOOiNM2aXBP2hmNQOvG5+dSnDjgxM8jM
         ImQdyejQ3F3+uEK4jKzVfNDIkwz+17wX7WJVnnAypytcCw5IwKWCzB/tcQ5vhLrQ4q
         YcdOKCDun4tJY2Oru+geJcPXJqJ8fhOSmc3cn+g/kKjFKWbySp3aeJTOhx1hvGFmwk
         NtxmZMxFQ3a0/C7JUOOOyCbxzKiadl4l+1F7NFcnQd+mLHvn/1BZRtxrbzkcTkHZqV
         YcCQ9A8XJ2YdS0wW0G/qir4IULNVpuYesWx7lZMgpuhXiKGYQOeO9ndOslf3RiMrdE
         NBZGNep/PBCrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hyunwoo Kim <v4bel@theori.io>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/10] net/rose: Fix to not accept on connected socket
Date:   Thu,  9 Feb 2023 06:19:13 -0500
Message-Id: <20230209111921.1893095-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111921.1893095-1-sashal@kernel.org>
References: <20230209111921.1893095-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hyunwoo Kim <v4bel@theori.io>

[ Upstream commit 14caefcf9837a2be765a566005ad82cd0d2a429f ]

If you call listen() and accept() on an already connect()ed
rose socket, accept() can successfully connect.
This is because when the peer socket sends data to sendmsg,
the skb with its own sk stored in the connected socket's
sk->sk_receive_queue is connected, and rose_accept() dequeues
the skb waiting in the sk->sk_receive_queue.

This creates a child socket with the sk of the parent
rose socket, which can cause confusion.

Fix rose_listen() to return -EINVAL if the socket has
already been successfully connected, and add lock_sock
to prevent this issue.

Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20230125105944.GA133314@ubuntu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 95dda29058a0e..6fb158172ddc2 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -465,6 +465,12 @@ static int rose_listen(struct socket *sock, int backlog)
 {
 	struct sock *sk = sock->sk;
 
+	lock_sock(sk);
+	if (sock->state != SS_UNCONNECTED) {
+		release_sock(sk);
+		return -EINVAL;
+	}
+
 	if (sk->sk_state != TCP_LISTEN) {
 		struct rose_sock *rose = rose_sk(sk);
 
@@ -474,8 +480,10 @@ static int rose_listen(struct socket *sock, int backlog)
 		memset(rose->dest_digis, 0, AX25_ADDR_LEN * ROSE_MAX_DIGIS);
 		sk->sk_max_ack_backlog = backlog;
 		sk->sk_state           = TCP_LISTEN;
+		release_sock(sk);
 		return 0;
 	}
+	release_sock(sk);
 
 	return -EOPNOTSUPP;
 }
-- 
2.39.0

