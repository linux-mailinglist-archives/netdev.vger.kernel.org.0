Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB946683088
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 16:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbjAaPD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 10:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbjAaPCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 10:02:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D4F5529B;
        Tue, 31 Jan 2023 07:00:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B91861566;
        Tue, 31 Jan 2023 15:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AA8C433D2;
        Tue, 31 Jan 2023 15:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177248;
        bh=31PGigVaWwsYxdx0F+/sk0jL4EAU83tF/tnCicsEiYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s6YcLnKSzXabknbYXZNOTC722baf/3znSvSJeJZ0ZvrLxV0+TUNN0HQfEAvwjbaH/
         I9g/obPwWSJQBx1V+YBOvMfLh+rh2N9Ai76dGQKkCi7zj+8c/TqYd0xbHKlhIEV1K4
         bAbT1XmZMP3oKaXd8la1XNIJA39X5SPJ7z5JMQ08zx8I9eBl6HjUiU1CpWSf04Ja/n
         +IdSnfV+VTMkCs6lJVK+Yr/qP6RfIfnK5mF4z8WLHxWitAbiFVIutZU7if0s7S0/bq
         +SETBimdNULx9Tcrl+IrN2DAfmc3T2BeFD0Y0b5Lt/ckB9OWRjKv0MdJ6650JusRjX
         kZjCYseLeRwyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hyunwoo Kim <v4bel@theori.io>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, ms@dev.tdt.de,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 10/12] net/x25: Fix to not accept on connected socket
Date:   Tue, 31 Jan 2023 10:00:28 -0500
Message-Id: <20230131150030.1250104-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131150030.1250104-1-sashal@kernel.org>
References: <20230131150030.1250104-1-sashal@kernel.org>
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
index 3a171828638b..07f6206e7cb4 100644
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

