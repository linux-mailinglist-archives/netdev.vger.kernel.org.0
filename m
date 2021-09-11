Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180A84076DE
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 15:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236072AbhIKNNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 09:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236040AbhIKNNb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Sep 2021 09:13:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A074461209;
        Sat, 11 Sep 2021 13:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365938;
        bh=IXbWypt5As8UY7h6vkc1duviLi7E8JcPnBivbbjE2ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xgd9QekaEyKA+3lkgLKxkpBVArQYpkJi4puqf/i/8P7jQUCfKWU2WP2jDIYMfgUaF
         mkw9aFT6iFDNOLCYHiidfb0iolQd89+A6MrzM4EF9rnQA8t1FK5BczGJ0pZz4JBtch
         OJECbN2sEOBUnNPI85hRTn3l0SewyjW5eG+Xaj3MyLsAlcjS4xh/g/6lg4OeBZNr+I
         1y0kj78lBX4cU3RUD3g4pj7NteB0q4uq8eL4tWWTSfWWssbYirEQGDLU+uK8JxGv3d
         WLV6Vn+AN4hU08ZXPozHL2rfAl8tJB0aYeyp4YNlXRVfOyCosVJqYo+uzwKH0aWBsa
         TpJ6iy88+CjMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Smadar Fuks <smadarf@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 21/32] octeontx2-af: Add additional register check to rvu_poll_reg()
Date:   Sat, 11 Sep 2021 09:11:38 -0400
Message-Id: <20210911131149.284397-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131149.284397-1-sashal@kernel.org>
References: <20210911131149.284397-1-sashal@kernel.org>
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
index 5fe277e354f7..c10cae78e79f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -92,7 +92,8 @@ static void rvu_setup_hw_capabilities(struct rvu *rvu)
  */
 int rvu_poll_reg(struct rvu *rvu, u64 block, u64 offset, u64 mask, bool zero)
 {
-	unsigned long timeout = jiffies + usecs_to_jiffies(10000);
+	unsigned long timeout = jiffies + usecs_to_jiffies(20000);
+	bool twice = false;
 	void __iomem *reg;
 	u64 reg_val;
 
@@ -107,6 +108,15 @@ int rvu_poll_reg(struct rvu *rvu, u64 block, u64 offset, u64 mask, bool zero)
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

