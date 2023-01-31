Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4976830B8
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 16:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbjAaPFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 10:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbjAaPFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 10:05:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FC154200;
        Tue, 31 Jan 2023 07:02:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 402F3B81D56;
        Tue, 31 Jan 2023 15:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3957C4339C;
        Tue, 31 Jan 2023 15:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177291;
        bh=zv/BiT4SJmHw+pvsgQMRb+Bed+1Da39/4lKFFFRbc4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CaozNtmQsHNQp0CmuRPJI59lqLU7G08aamT+PedCGYf64SPMIZSHlOSkwp4F5MyI/
         D5vilR0KUt2VAzN/PEkeTQ6hJssiidBLxChNpoAfaUJtcdk0aobAyDmwmjmmEpgzK9
         j/HrwsTwYEhr35UVqRV9RkQcwgCQkpYrI4/uU21DjggOVL4Qj+0UJYBtdLyUwzZdVz
         wKeOhMvy+5+Y93ya10nMvmoKUomWrTlrQG0wutr9zxxzzsHANEbK5R4/oDEKuTYx/1
         d1b45xsJKbXW05QdZKRR1Au9J/ff1w2zA7d08VlC5V9WQAmyfcId6Bg/eimxOhsEZZ
         V6CVQHkIJR88Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hyunwoo Kim <v4bel@theori.io>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, ms@dev.tdt.de,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 3/3] net/x25: Fix to not accept on connected socket
Date:   Tue, 31 Jan 2023 10:01:26 -0500
Message-Id: <20230131150126.1250471-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131150126.1250471-1-sashal@kernel.org>
References: <20230131150126.1250471-1-sashal@kernel.org>
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
index e103ec39759f..73e293c3f2fb 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -496,6 +496,12 @@ static int x25_listen(struct socket *sock, int backlog)
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

