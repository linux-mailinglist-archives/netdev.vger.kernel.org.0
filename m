Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 080281A0293
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgDGACn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728159AbgDGACk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:02:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B97720857;
        Tue,  7 Apr 2020 00:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217760;
        bh=jfwCsAvjDH3ZwiE9o8OYiI+Fbo15gpdgV44F0mGIzMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r24j7I6PwCWm5LIQQz7YINNCPckTpHCliEQkHL4gXG/Uk2PkxZyeYYJqDkSjcKcoN
         eoLuDYjmfe3WHJXp2bUYJAAgN7Ok/BCQp4iH8XWKVSmZJFWM2VIYzOPmtRKuubHSM2
         1sD5ugX0zvyVXFispUXkP119T/4cfaM4P8xY0XpU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/13] rxrpc: Fix sendmsg(MSG_WAITALL) handling
Date:   Mon,  6 Apr 2020 20:02:25 -0400
Message-Id: <20200407000234.17088-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000234.17088-1-sashal@kernel.org>
References: <20200407000234.17088-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 498b577660f08cef5d9e78e0ed6dcd4c0939e98c ]

Fix the handling of sendmsg() with MSG_WAITALL for userspace to round the
timeout for when a signal occurs up to at least two jiffies as a 1 jiffy
timeout may end up being effectively 0 if jiffies wraps at the wrong time.

Fixes: bc5e3a546d55 ("rxrpc: Use MSG_WAITALL to tell sendmsg() to temporarily ignore signals")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/sendmsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 68993439e1d91..7ee72053037a3 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -75,8 +75,8 @@ static int rxrpc_wait_for_tx_window_nonintr(struct rxrpc_sock *rx,
 
 	rtt = READ_ONCE(call->peer->rtt);
 	rtt2 = nsecs_to_jiffies64(rtt) * 2;
-	if (rtt2 < 1)
-		rtt2 = 1;
+	if (rtt2 < 2)
+		rtt2 = 2;
 
 	timeout = rtt2;
 	tx_start = READ_ONCE(call->tx_hard_ack);
-- 
2.20.1

