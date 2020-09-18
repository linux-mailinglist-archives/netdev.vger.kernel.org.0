Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2D126F2FB
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbgIRDDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:03:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727432AbgIRCFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:05:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 647C923600;
        Fri, 18 Sep 2020 02:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394703;
        bh=OaIXy9pjhG6VdpJctz+9+sMtzA7P+US57dK2OhFZ3jE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBCg/h906DTP2M2PxPXt14uEbxwMSicm6zK99WmwS5RLDvtKVJJfOgvE/grjF/9O1
         VN2Z2iTdYURVhvY60a0UmSVYJQTKtJ4b7lYiTLuI106ndzYj9nb67CN+p7CZv1AJfU
         EaUQY5Q9Yd94st9AjfLQjQm/nql9+PFu5lndgh6Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 189/330] r8169: improve RTL8168b FIFO overflow workaround
Date:   Thu, 17 Sep 2020 21:58:49 -0400
Message-Id: <20200918020110.2063155-189-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 6b02e407cbf8d421477ebb7792cd6380affcd313 ]

So far only the reset bit it set, but the handler executing the reset
is not scheduled. Therefore nothing will happen until some other action
schedules the handler. Improve this by ensuring that the handler is
scheduled.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6fa9852e3f97f..903212ad9bb2f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -6256,8 +6256,7 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 	if (unlikely(status & RxFIFOOver &&
 	    tp->mac_version == RTL_GIGA_MAC_VER_11)) {
 		netif_stop_queue(tp->dev);
-		/* XXX - Hack alert. See rtl_task(). */
-		set_bit(RTL_FLAG_TASK_RESET_PENDING, tp->wk.flags);
+		rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_PENDING);
 	}
 
 	rtl_irq_disable(tp);
-- 
2.25.1

