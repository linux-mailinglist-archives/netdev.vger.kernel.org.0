Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 423FE39DC4
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 13:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbfFHLnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 07:43:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728801AbfFHLnf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 07:43:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D40542168B;
        Sat,  8 Jun 2019 11:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994214;
        bh=VGQ3nTj9VgA/BJ8LC7D+7GRpevYOXm3z1Gff8jlbOEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zHMFqCTX+zgKUb2rVdSMzKCnXWcbnL599pXTcni/iy9vYIDU3I0klDdbf56+qxZJf
         70wNshqjJ/KwXVVgiz2Mg56U5NpFlji508c8L3Vm4dUE9AXqI6QXR2CSYXLhx0Ocvv
         eH/bv/0PtM2Nr7nxAyA9JIeDjMwDYTtS3P1OZblg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 24/49] net: aquantia: tx clean budget logic error
Date:   Sat,  8 Jun 2019 07:42:05 -0400
Message-Id: <20190608114232.8731-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114232.8731-1-sashal@kernel.org>
References: <20190608114232.8731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <Igor.Russkikh@aquantia.com>

[ Upstream commit 31bafc49a7736989e4c2d9f7280002c66536e590 ]

In case no other traffic happening on the ring, full tx cleanup
may not be completed. That may cause socket buffer to overflow
and tx traffic to stuck until next activity on the ring happens.

This is due to logic error in budget variable decrementor.
Variable is compared with zero, and then post decremented,
causing it to become MAX_INT. Solution is remove decrementor
from the `for` statement and rewrite it in a clear way.

Fixes: b647d3980948e ("net: aquantia: Add tx clean budget and valid budget handling logic")
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 6f3312350cac..b3c7994d73eb 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -139,10 +139,10 @@ void aq_ring_queue_stop(struct aq_ring_s *ring)
 bool aq_ring_tx_clean(struct aq_ring_s *self)
 {
 	struct device *dev = aq_nic_get_dev(self->aq_nic);
-	unsigned int budget = AQ_CFG_TX_CLEAN_BUDGET;
+	unsigned int budget;
 
-	for (; self->sw_head != self->hw_head && budget--;
-		self->sw_head = aq_ring_next_dx(self, self->sw_head)) {
+	for (budget = AQ_CFG_TX_CLEAN_BUDGET;
+	     budget && self->sw_head != self->hw_head; budget--) {
 		struct aq_ring_buff_s *buff = &self->buff_ring[self->sw_head];
 
 		if (likely(buff->is_mapped)) {
@@ -167,6 +167,7 @@ bool aq_ring_tx_clean(struct aq_ring_s *self)
 
 		buff->pa = 0U;
 		buff->eop_index = 0xffffU;
+		self->sw_head = aq_ring_next_dx(self, self->sw_head);
 	}
 
 	return !!budget;
-- 
2.20.1

