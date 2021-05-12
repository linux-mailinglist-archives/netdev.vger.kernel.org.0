Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5339E37ED07
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384992AbhELUGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 16:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241465AbhELSFi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 14:05:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 730C86143B;
        Wed, 12 May 2021 18:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842639;
        bh=eaFzXUGPD19UebBi6DqlyNQJbVt59XWMqXQiVNeK6Cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kosfwr6XPqiEB9PIlLyurCAV5UmRXRTYaruKrFRMnX3s6kI6bEjR6L847uYFeM0Xa
         jgZtrrfQLuWo8Pl1YlQFCzY6wxFRRUmV8pVzKb/mx1d/YKEwp0RpvtV9mgz76Qo/rJ
         119g3M+VlsjSis19CmHJbOC/t+rB0y5uRDgL4mpkROXnmuPbMoi7NNi18KYIDmy9pQ
         DBhbtmICsPxHAxmZcARS3Waw1tGhi01lj98LanHoOIfEDcXmlHIIHAWNYCz1XW5+4w
         Jo21uG/2UvTA87zSNh80nmdXhhb4JEp6DWaPMfhRM8C6hjJ2RZwnuwhyrAtRNP8SN4
         +q8YvBEOZOFsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 30/34] net:CXGB4: fix leak if sk_buff is not used
Date:   Wed, 12 May 2021 14:03:01 -0400
Message-Id: <20210512180306.664925-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180306.664925-1-sashal@kernel.org>
References: <20210512180306.664925-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit 52bfcdd87e83d9e69d22da5f26b1512ffc81deed ]

An sk_buff is allocated to send a flow control message, but it's not
sent in all cases: in case the state is not appropiate to send it or if
it can't be enqueued.

In the first of these 2 cases, the sk_buff was discarded but not freed,
producing a memory leak.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 3334c9e2152a..546301272271 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2559,12 +2559,12 @@ int cxgb4_ethofld_send_flowc(struct net_device *dev, u32 eotid, u32 tc)
 	spin_lock_bh(&eosw_txq->lock);
 	if (tc != FW_SCHED_CLS_NONE) {
 		if (eosw_txq->state != CXGB4_EO_STATE_CLOSED)
-			goto out_unlock;
+			goto out_free_skb;
 
 		next_state = CXGB4_EO_STATE_FLOWC_OPEN_SEND;
 	} else {
 		if (eosw_txq->state != CXGB4_EO_STATE_ACTIVE)
-			goto out_unlock;
+			goto out_free_skb;
 
 		next_state = CXGB4_EO_STATE_FLOWC_CLOSE_SEND;
 	}
@@ -2600,17 +2600,19 @@ int cxgb4_ethofld_send_flowc(struct net_device *dev, u32 eotid, u32 tc)
 		eosw_txq_flush_pending_skbs(eosw_txq);
 
 	ret = eosw_txq_enqueue(eosw_txq, skb);
-	if (ret) {
-		dev_consume_skb_any(skb);
-		goto out_unlock;
-	}
+	if (ret)
+		goto out_free_skb;
 
 	eosw_txq->state = next_state;
 	eosw_txq->flowc_idx = eosw_txq->pidx;
 	eosw_txq_advance(eosw_txq, 1);
 	ethofld_xmit(dev, eosw_txq);
 
-out_unlock:
+	spin_unlock_bh(&eosw_txq->lock);
+	return 0;
+
+out_free_skb:
+	dev_consume_skb_any(skb);
 	spin_unlock_bh(&eosw_txq->lock);
 	return ret;
 }
-- 
2.30.2

