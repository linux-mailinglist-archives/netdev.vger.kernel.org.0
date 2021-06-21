Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010AB3AF404
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbhFUSGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233950AbhFUSC4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:02:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADEA26140A;
        Mon, 21 Jun 2021 17:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298126;
        bh=0k/dbRhB3OSnM4i6+Q1qXH5roZi+Qm4SlE6OQ0FRZN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDXrAk2mRgkmEodrjd/hrFeaa+qv5ETB/X4Pd2D8wassdRUxji1LrzQhyrSVT2+SJ
         jd4pdqvjCAyHygLhFfGS78VDT3XougU32fdI4O2wM6eDuoKflMMyfhDMy0Q1wtR1bh
         pzHbZPdhQSFNfdygXnifToSv5oYPvT6KgW25lt/5soSHSlebnlq2mOYKiVwocX1aDL
         GNnUCSBOA+iL5L/xTJ3uDiRo885+fnK5l7rtqclp+I3N6dAgrFs+kL0wSXQMeAjre1
         mmCFIJubldG5IheAr6GRZksddmIK4d3n+WA1lgXvMTVpu2Cu/saZM2btE03sXGf3R3
         k+jtYmg1Y0l3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/13] ping: Check return value of function 'ping_queue_rcv_skb'
Date:   Mon, 21 Jun 2021 13:55:10 -0400
Message-Id: <20210621175519.736255-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175519.736255-1-sashal@kernel.org>
References: <20210621175519.736255-1-sashal@kernel.org>
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
index 186fdf0922d2..aab141c4a389 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -978,6 +978,7 @@ bool ping_rcv(struct sk_buff *skb)
 	struct sock *sk;
 	struct net *net = dev_net(skb->dev);
 	struct icmphdr *icmph = icmp_hdr(skb);
+	bool rc = false;
 
 	/* We assume the packet has already been checked by icmp_rcv */
 
@@ -992,14 +993,15 @@ bool ping_rcv(struct sk_buff *skb)
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

