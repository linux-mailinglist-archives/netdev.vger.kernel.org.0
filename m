Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51AA3FB512
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236809AbhH3MB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236733AbhH3MBA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 08:01:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50B3561155;
        Mon, 30 Aug 2021 12:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324807;
        bh=D349oO5QEXvpIRCUTESb1cUfYEXErlCjDIDFbLtpT14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jWzgykU3xRYrA3eZGU6YlJRLDZd+njog39WvN8woC0nYoA0V8EtwGKfTn/8izxDNm
         c7WzeA5yMjfkTBlJB+5BCt535ZeIrl+4cUW3NE+EtnUB1uInOg9THrUkiOyYzrV+Dq
         wqfe23qHU+myrvQkzJWp7uYA3io+Y6GNrtoHleaakFa2CQ1bb/WgQzzyI4tnuMYA7q
         ukgXO4Dka+QmUkaMmD11f560/u+VP9bw25J0OEbEkR7vneS6EX3KwqjizfXfBTrE+x
         L99APA9Ai5cp0pWbiLOGm8DNmpXSYRgyVpyOHVSmZBRVJJ1cd7YnLmnrTTvtM5DHeM
         YaDRUvuJYnHfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shai Malin <smalin@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/11] qed: Fix the VF msix vectors flow
Date:   Mon, 30 Aug 2021 07:59:54 -0400
Message-Id: <20210830120002.1017700-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830120002.1017700-1-sashal@kernel.org>
References: <20210830120002.1017700-1-sashal@kernel.org>
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
index 5bd58c65e163..6bb9ec98a12b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -616,7 +616,12 @@ static int qed_enable_msix(struct qed_dev *cdev,
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

