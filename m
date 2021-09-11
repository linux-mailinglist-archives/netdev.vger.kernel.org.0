Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96BE4077B0
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 15:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236718AbhIKNTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 09:19:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237310AbhIKNRT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Sep 2021 09:17:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6358761283;
        Sat, 11 Sep 2021 13:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366015;
        bh=cmS4g843Gltb76grW7aT4uBUvV2MBjGRmvBoW9lwMUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsZpl7srvRFHmDpE3Wq3NYYF/if/hOK+TlG0xCsc6gFLepFc87o9YVCNLBpBSfUxj
         3YuJnvD+tJtet7KG76bFJf9iKpvEm956QeQ1tWHxhYeV6TKGGkAj8UgfucUaycqVQ9
         D9njejwOXcYq0OprZLSHfeukyVqkk5cIM1RqISQ7T4yuy0P99Bm8xKLiOSY60VZGDe
         80Yb4ULDZtmBffySiHkZmm7wFHxeizjjjmXfFQ7zfoWzgZHT52/iUueORBWAwwEExQ
         mHqbdTqDtRDK5PNWlyw3galoaIYWei+PhkbuC9x6y5XiBhjLUkjqDZe1+/sijAPLHU
         G7j2QTzFuQ+2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Smadar Fuks <smadarf@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 17/25] octeontx2-af: Add additional register check to rvu_poll_reg()
Date:   Sat, 11 Sep 2021 09:13:04 -0400
Message-Id: <20210911131312.285225-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131312.285225-1-sashal@kernel.org>
References: <20210911131312.285225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Smadar Fuks <smadarf@marvell.com>

[ Upstream commit 21274aa1781941884599a97ab59be7f8f36af98c ]

Check one more time before exiting the API with an error.
Fix API to poll at least twice, in case there are other high priority
tasks and this API doesn't get CPU cycles for multiple jiffies update.

In addition, increase timeout from usecs_to_jiffies(10000) to
usecs_to_jiffies(20000), to prevent the case that for CONFIG_100HZ
timeout will be a single jiffies.
A single jiffies results actual timeout that can be any time between
1usec and 10msec. To solve this, a value of usecs_to_jiffies(20000)
ensures that timeout is 2 jiffies.

Signed-off-by: Smadar Fuks <smadarf@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 644d28b0692b..c26652436c53 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -84,7 +84,8 @@ static void rvu_setup_hw_capabilities(struct rvu *rvu)
  */
 int rvu_poll_reg(struct rvu *rvu, u64 block, u64 offset, u64 mask, bool zero)
 {
-	unsigned long timeout = jiffies + usecs_to_jiffies(10000);
+	unsigned long timeout = jiffies + usecs_to_jiffies(20000);
+	bool twice = false;
 	void __iomem *reg;
 	u64 reg_val;
 
@@ -99,6 +100,15 @@ int rvu_poll_reg(struct rvu *rvu, u64 block, u64 offset, u64 mask, bool zero)
 		usleep_range(1, 5);
 		goto again;
 	}
+	/* In scenarios where CPU is scheduled out before checking
+	 * 'time_before' (above) and gets scheduled in such that
+	 * jiffies are beyond timeout value, then check again if HW is
+	 * done with the operation in the meantime.
+	 */
+	if (!twice) {
+		twice = true;
+		goto again;
+	}
 	return -EBUSY;
 }
 
-- 
2.30.2

