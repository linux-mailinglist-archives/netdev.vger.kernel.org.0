Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 644CF1A0323
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgDGAGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727929AbgDGACK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:02:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08BD220936;
        Tue,  7 Apr 2020 00:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217730;
        bh=fJFGi6T4K+Duqo6Kk0lU0Jzj/CXZAnUEMHj1mfeAFuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BhDknfINzBk4RteC7cEKuJr7trNi452KZWZStsfqK+Hnnt3uQq49W+RLwNkWtJgKs
         zkAF5KXtenJcz42zUSEX+zmEr8xMMmgwjb3050TbxG/206BmJt+qyuaFe+dRQ7q3bQ
         ALZ5gCQNobfkrvg49jXYzbuZSLvRb/4eZVNqJQmk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 14/32] rxrpc: Fix sendmsg(MSG_WAITALL) handling
Date:   Mon,  6 Apr 2020 20:01:32 -0400
Message-Id: <20200407000151.16768-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000151.16768-1-sashal@kernel.org>
References: <20200407000151.16768-1-sashal@kernel.org>
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
index 1eccfb92c9e15..0fcf157aa09f8 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -71,8 +71,8 @@ static int rxrpc_wait_for_tx_window_waitall(struct rxrpc_sock *rx,
 
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

