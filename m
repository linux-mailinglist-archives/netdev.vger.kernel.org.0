Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB9D3AF383
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbhFUSCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232050AbhFUSAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:00:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98D4D61378;
        Mon, 21 Jun 2021 17:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298062;
        bh=DJbuU0iVdzvixmCgXuaMqzrfETTxUAChdi8JE4WzplY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtMMimaZBBtEvZ9AYjp2YPXFhl/rEbycNzv1aNzb0rp7/B7ZE6DQ2x64+hzaNPVpu
         PLQdTuSJeNe9Nc3jQX5ueFIhU8yo9K7bt+d07Equ62vB+YkUGPbpn7WzipCtaebV8r
         jgje4GN6/pNwfiMq1D6oSRsVDZSjgTM4+PNge2i+g7OIRG+Ha3hfjuRquW46tKqo3j
         5I84M1udDwiIbNLo1L0VAC+iR29TuQd2y0q3cBGtE/9bqg0RGPWT4PJ+iDV0ZNVbYP
         F4qzvXlmaf4dYUD3JUFyS8jZi06O2Tgvp7kycAgx+S6DY13ceqxNdbX46IUHEB/ynJ
         JQvL3S2iUfmeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/26] ping: Check return value of function 'ping_queue_rcv_skb'
Date:   Mon, 21 Jun 2021 13:53:45 -0400
Message-Id: <20210621175400.735800-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175400.735800-1-sashal@kernel.org>
References: <20210621175400.735800-1-sashal@kernel.org>
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
index df6fbefe44d4..1c3d5d3702a1 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -963,6 +963,7 @@ bool ping_rcv(struct sk_buff *skb)
 	struct sock *sk;
 	struct net *net = dev_net(skb->dev);
 	struct icmphdr *icmph = icmp_hdr(skb);
+	bool rc = false;
 
 	/* We assume the packet has already been checked by icmp_rcv */
 
@@ -977,14 +978,15 @@ bool ping_rcv(struct sk_buff *skb)
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

