Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1E7683056
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 16:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbjAaPBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 10:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbjAaPAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 10:00:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9472423124;
        Tue, 31 Jan 2023 07:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18B3761565;
        Tue, 31 Jan 2023 15:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EAE0C433D2;
        Tue, 31 Jan 2023 15:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177218;
        bh=ck5tqw9FEbpJWj1+WLah6xnAqqZGfcEuwF/xC2J1Jhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eu4jMPvd42+wq0Lby1ybUhzVpthIsngykDa69JWCbQ0yA+5mrZDlaVPhqA6RCRovG
         o+Ecwnq5sQ37E+O0qGMJM+un17/o7rRFsIj7I4kGZM2E6g8Wlovh35ZU582Yel7ybw
         pJbD0dK5gTQ6cafQqErNAA7D+9GumaPKCPcVjy8nwAYgVMcr6/2YAHjvOanNbQsf7e
         DwR0IdVb1crPeCPa7Z9zy7Tm4rqixXskK1rGngFo49usizvz1PzhVk2i6K3tR274Fa
         InePjKrssCr21xvxyS5oAD0dnHUecUG4OFxyMqVRSGK9vkD00E9FjrrR5VT6JfcEuV
         YKzZfwLYX1mrQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hyunwoo Kim <v4bel@theori.io>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, ms@dev.tdt.de,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 17/20] net/x25: Fix to not accept on connected socket
Date:   Tue, 31 Jan 2023 09:59:43 -0500
Message-Id: <20230131145946.1249850-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131145946.1249850-1-sashal@kernel.org>
References: <20230131145946.1249850-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hyunwoo Kim <v4bel@theori.io>

[ Upstream commit f2b0b5210f67c56a3bcdf92ff665fb285d6e0067 ]

When listen() and accept() are called on an x25 socket
that connect() succeeds, accept() succeeds immediately.
This is because x25_connect() queues the skb to
sk->sk_receive_queue, and x25_accept() dequeues it.

This creates a child socket with the sk of the parent
x25 socket, which can cause confusion.

Fix x25_listen() to return -EINVAL if the socket has
already been successfully connect()ed to avoid this issue.

Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/af_x25.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 3b55502b2965..5c7ad301d742 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -482,6 +482,12 @@ static int x25_listen(struct socket *sock, int backlog)
 	int rc = -EOPNOTSUPP;
 
 	lock_sock(sk);
+	if (sock->state != SS_UNCONNECTED) {
+		rc = -EINVAL;
+		release_sock(sk);
+		return rc;
+	}
+
 	if (sk->sk_state != TCP_LISTEN) {
 		memset(&x25_sk(sk)->dest_addr, 0, X25_ADDR_LEN);
 		sk->sk_max_ack_backlog = backlog;
-- 
2.39.0

