Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7723FB52D
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237092AbhH3MB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236928AbhH3MBj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 08:01:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 656E461153;
        Mon, 30 Aug 2021 12:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324845;
        bh=4k3ueqBC6+FyS0/IPM9yYUQy0wgR+I6vFAKdUCTtQLM=;
        h=From:To:Cc:Subject:Date:From;
        b=VShZAXj6tFYaeHnBESP6ZnkP6bJNZYcfqDt4akqpXn3HlCLHF8yhdAa6UThXeon2m
         /GB83cMMarQwqQacLS8jeGlluBPv1VJ8OjQL+h8keJWQBvbFjvXjJ1NR/lkgtAoKgG
         pI3bDhzirqVb0YOTS633FZnPzP2YJ5OHpwHSmgPa0W6poiWntVcC30XhkcFThqpnro
         ccX7uzotRmpX8Df8PxTWeBP7gS9Dacc4uYJkjZO8HwLjjaEuKmv7Ktv8BRHmzgdxOL
         /DsIv3nQgw+F7QeXk+SOLE4Ghw3hzSiMNZ1csH84kpb6fboeosG04mquWXoL68JAzw
         Vu5UHgnV3QkBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shai Malin <smalin@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 1/7] qed: Fix the VF msix vectors flow
Date:   Mon, 30 Aug 2021 08:00:37 -0400
Message-Id: <20210830120043.1018096-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shai Malin <smalin@marvell.com>

[ Upstream commit b0cd08537db8d2fbb227cdb2e5835209db295a24 ]

For VFs we should return with an error in case we didn't get the exact
number of msix vectors as we requested.
Not doing that will lead to a crash when starting queues for this VF.

Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 52e747fd9c83..62d514b60e23 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -437,7 +437,12 @@ static int qed_enable_msix(struct qed_dev *cdev,
 			rc = cnt;
 	}
 
-	if (rc > 0) {
+	/* For VFs, we should return with an error in case we didn't get the
+	 * exact number of msix vectors as we requested.
+	 * Not doing that will lead to a crash when starting queues for
+	 * this VF.
+	 */
+	if ((IS_PF(cdev) && rc > 0) || (IS_VF(cdev) && rc == cnt)) {
 		/* MSI-x configuration was achieved */
 		int_params->out.int_mode = QED_INT_MODE_MSIX;
 		int_params->out.num_vectors = rc;
-- 
2.30.2

