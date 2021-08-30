Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7643FB4EE
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbhH3MAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236587AbhH3MAk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 08:00:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77DB361155;
        Mon, 30 Aug 2021 11:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324787;
        bh=D349oO5QEXvpIRCUTESb1cUfYEXErlCjDIDFbLtpT14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2QNP8iKgHLWdWRp3PR5K/KLnXWoGiMru2HuHEYTQbLCTgLlNSu4zEQU7y3f5K+CS
         CJEOQQ4+Tpak9DSimT7jnnnVZxpoMEIAx58xrLcTScAGP2Ox7mzp7esnyV1DDzgg8X
         RkUo+yoysAuO9JP63vh3ESq3HdF3eBmDIUJMpPQ7aeC5uIBryqz1P9qpI0/7tFIYan
         eJEQ6wKqt3TnM6YP7e+GwHQ2cBCHuPOhN/8fu10kAWVPwFaDL6Kiz5WVfWCyOszfwY
         4mnT177vO3vam3MDizEYhIUCjmLUntbY/hYXMTSKuZtRabsMay6Juhh4Q/ynoI9SKz
         1LXKVoOp4Trsw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shai Malin <smalin@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 03/14] qed: Fix the VF msix vectors flow
Date:   Mon, 30 Aug 2021 07:59:31 -0400
Message-Id: <20210830115942.1017300-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830115942.1017300-1-sashal@kernel.org>
References: <20210830115942.1017300-1-sashal@kernel.org>
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

