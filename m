Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42734FEFEA
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731440AbfKPQCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:02:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731119AbfKPPxE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:53:04 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5BCA21826;
        Sat, 16 Nov 2019 15:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919584;
        bh=55QJa0/qN3W+hhW2WiN2ehyXwX7TS3HfPxyJsp8ucvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R9vmQGk58HLX1xyx67Oj45H9Rnb0GLJbtS41DbNrjttiqiQPSIq0EIH/JZ0xs86Kj
         Ia5l36zm7u7VBOimoi83fUNKYNb8iKooT5wOSQbmd+fKPmg0Y6c9GGfPwk2eMLtdyC
         ZjmiVZ0hOct2dJQMPOH2VFpA0f2pHZ4N8jR7SIfM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 75/99] net: do not abort bulk send on BQL status
Date:   Sat, 16 Nov 2019 10:50:38 -0500
Message-Id: <20191116155103.10971-75-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
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
index 547b4daae5cad..c6fb7e61cb405 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2997,7 +2997,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *first, struct net_device *de
 		}
 
 		skb = next;
-		if (netif_xmit_stopped(txq) && skb) {
+		if (netif_tx_queue_stopped(txq) && skb) {
 			rc = NETDEV_TX_BUSY;
 			break;
 		}
-- 
2.20.1

