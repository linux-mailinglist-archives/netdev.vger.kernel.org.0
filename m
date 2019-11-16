Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A300FEEE8
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 16:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731569AbfKPPzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:55:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:37266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731558AbfKPPzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:55:16 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6C62218BA;
        Sat, 16 Nov 2019 15:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919715;
        bh=faAfye4U9NiBAVX4GKVcclxbx9Ur0Cd7sQHtZGt+ov0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2RjHV2kGM+rEwzIl72PLUuZEeOtAdvLlFTgYDJakdqyAC6phAmVf9wR+lB1JkLFOW
         ZaLBlFeIQ2L1k5EDuJtv43guX2kkKuHlgOyNIgttKVBThqThhLAWml0AWGANNxFswT
         J1Gub57ebuADy4WX6fkuZycwkSL3WetjtIVqqv+I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 58/77] net: do not abort bulk send on BQL status
Date:   Sat, 16 Nov 2019 10:53:20 -0500
Message-Id: <20191116155339.11909-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155339.11909-1-sashal@kernel.org>
References: <20191116155339.11909-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit fe60faa5063822f2d555f4f326c7dd72a60929bf ]

Before calling dev_hard_start_xmit(), upper layers tried
to cook optimal skb list based on BQL budget.

Problem is that GSO packets can end up comsuming more than
the BQL budget.

Breaking the loop is not useful, since requeued packets
are ahead of any packets still in the qdisc.

It is also more expensive, since next TX completion will
push these packets later, while skbs are not in cpu caches.

It is also a behavior difference with TSO packets, that can
break the BQL limit by a large amount.

Note that drivers should use __netdev_tx_sent_queue()
in order to have optimal xmit_more support, and avoid
useless atomic operations as shown in the following patch.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 18a5154e2f254..903c6242b4499 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2801,7 +2801,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *first, struct net_device *de
 		}
 
 		skb = next;
-		if (netif_xmit_stopped(txq) && skb) {
+		if (netif_tx_queue_stopped(txq) && skb) {
 			rc = NETDEV_TX_BUSY;
 			break;
 		}
-- 
2.20.1

