Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131173AF289
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbhFURzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232089AbhFURyq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:54:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 314606120D;
        Mon, 21 Jun 2021 17:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297945;
        bh=tN4sJoaHF2b7ngaVviE9C1wZZuAEleFWNq88DkBuFi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdoQ1/ifu/lnxAxa7RRVh4cmbu5I+7WMRwxJeCZEcuIFvtyPFCoi3IyLa3uRnVCXZ
         pL0RLqcXaDeWsJjtEZ1A4jKpSnozK0kVNmwIeQBt23eCcpiYqXQRx31BatSwNYyWEm
         xxjH5g8NakkILOxrh8rdXpNvtyOdbH1omKzqb6ufkEjLJMWA+ZjKtHaKiuIcdL7b6B
         W8BdDYyHMJFDVQhFm0Mctb31YK8NcJyqm/KEnZWbTGS+MEcFNcmP4GDGO1Ga4K7hR0
         900Ks/Ida4mHv5vJLRV63lodV4juOCjjWGHTJBD8CYHPiWlSawkJj1Y5NciiNXAoGJ
         0kgpF/b1A2Qyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 17/39] ping: Check return value of function 'ping_queue_rcv_skb'
Date:   Mon, 21 Jun 2021 13:51:33 -0400
Message-Id: <20210621175156.735062-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
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
index 8b943f85fff9..ea22768f76b8 100644
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

