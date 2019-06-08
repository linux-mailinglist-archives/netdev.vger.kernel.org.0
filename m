Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32B8239F01
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 13:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfFHLku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 07:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727890AbfFHLkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 07:40:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59EC4216C4;
        Sat,  8 Jun 2019 11:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994049;
        bh=ivRQXL0dg/2CSHy0v9lAxJbr0totU+Rlq9gzlrspaN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtLfqiYBe1dIF1JRu93gLSucqQleMz369aJ1gJlAvhZnsCvpBl7W1rmS0kGkXJtus
         l+RC8+BoFG7i/QW28lNAJ9zEgWRgauLs+e7+LamF6yhZqOGe2gN2usnscdC7h4mNd2
         Jv9zT613eo04bSumwmjguqtnw4Pryi30zjONNQhg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 37/70] net: aquantia: tx clean budget logic error
Date:   Sat,  8 Jun 2019 07:39:16 -0400
Message-Id: <20190608113950.8033-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
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
index e2ffb159cbe2..bf4aa7060f1a 100644
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

