Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5753FB55A
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236980AbhH3MDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:03:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237027AbhH3MBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 08:01:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A03EB61154;
        Mon, 30 Aug 2021 12:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324855;
        bh=sOcDb3H2CXjiS9xpKdmIHMAlAP6DiWdoQxdA9WNpa/s=;
        h=From:To:Cc:Subject:Date:From;
        b=A/1mFmWTvwd2UFuTtvdG55pZ4c5BRDr/2+RFDro3/bI8514zG4VsHm42QPzRqzhVe
         8PXtnSa7mTOm+KRWXLCjkDGstqvDijSAh7FDnAbZ4Mbn0TTFwbU7EOR7eU4frcuL1R
         nUJzTXy5gStWifTkQMOpLfiRotuwvk1s4CWuBGN1JjhVSDcKC+6p65X94fL4yVOnDy
         XwXlDtsrIpERnDOnNcyS/dcSdbc/Zc7Bpt6VAKKoOAaBF/flEVIdvj7Vy3jysm3W96
         Gc/80SzxJsYN3pANp6EFCRBfOjoGhyqnN0cEIrvR5FbEoy0NG9wrnpdnqF82Pxbs5D
         jJy4vEFaHKYaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shai Malin <smalin@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 1/5] qed: Fix the VF msix vectors flow
Date:   Mon, 30 Aug 2021 08:00:49 -0400
Message-Id: <20210830120053.1018205-1-sashal@kernel.org>
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
index 708117fc6f73..7669d36151c6 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -374,7 +374,12 @@ static int qed_enable_msix(struct qed_dev *cdev,
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

