Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4E23AF359
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbhFUR7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232969AbhFUR4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:56:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 533BA613BA;
        Mon, 21 Jun 2021 17:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298004;
        bh=czxlNgSmgLtmy5hOkuFB+H+M24dKVJYCwvBhq0HoFUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxq1+I3t/qaRK0YcQsL0+EEfIpUwj9lZ/clvcOjFotyUoq6zZWp/hSHyIVDh77GTW
         cUral0Gjxxf9TCYUaprIo36O03ZwmcBhJBrXbNpEEBxeZiRPFP1PHvHSj45b4/Fu2O
         /aV1zUuk2PDx9NywF48w0XDBr8MFJyjF90q800vaxkoNhYKG6YTxhyEz7BBsEbqjIv
         47uAAx6tGfud04V309pT1P/AztMWNvsC+peCcAvnZlbLa03Zsc1q/fhVZb4PhF0ZZa
         3KYl71xQCcOMffN4ZaLbS3DvuIe1PxRyyd5kX/qga1pQxZBMs+gcWjpm39S/Xgst1Z
         gHjw/g2EbBtfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 16/35] ping: Check return value of function 'ping_queue_rcv_skb'
Date:   Mon, 21 Jun 2021 13:52:41 -0400
Message-Id: <20210621175300.735437-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175300.735437-1-sashal@kernel.org>
References: <20210621175300.735437-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit 9d44fa3e50cc91691896934d106c86e4027e61ca ]

Function 'ping_queue_rcv_skb' not always return success, which will
also return fail. If not check the wrong return value of it, lead to function
`ping_rcv` return success.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ping.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 248856b301c4..8ce8b7300b9d 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -952,6 +952,7 @@ bool ping_rcv(struct sk_buff *skb)
 	struct sock *sk;
 	struct net *net = dev_net(skb->dev);
 	struct icmphdr *icmph = icmp_hdr(skb);
+	bool rc = false;
 
 	/* We assume the packet has already been checked by icmp_rcv */
 
@@ -966,14 +967,15 @@ bool ping_rcv(struct sk_buff *skb)
 		struct sk_buff *skb2 = skb_clone(skb, GFP_ATOMIC);
 
 		pr_debug("rcv on socket %p\n", sk);
-		if (skb2)
-			ping_queue_rcv_skb(sk, skb2);
+		if (skb2 && !ping_queue_rcv_skb(sk, skb2))
+			rc = true;
 		sock_put(sk);
-		return true;
 	}
-	pr_debug("no socket, dropping\n");
 
-	return false;
+	if (!rc)
+		pr_debug("no socket, dropping\n");
+
+	return rc;
 }
 EXPORT_SYMBOL_GPL(ping_rcv);
 
-- 
2.30.2

