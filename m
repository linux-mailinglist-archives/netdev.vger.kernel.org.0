Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E3F2F3143
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389865AbhALM5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 07:57:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389784AbhALM5O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0558B2312D;
        Tue, 12 Jan 2021 12:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456160;
        bh=jdW8erxa86DlQqrhQtS+N8JoPjUyTmy+sdSjQnA5l10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0bCi0c2s8rFH6rxOZ4QAVLpocMFGXyiTIgHD+wcHZ8PQJ29LCr+fiTULIikOSQ4g
         /FICrbowkxB9Gbqhmbrf1ENhFeIl4mAX+9Hh6YEmuvvbLyBor2DaAOU9r6vA0McXVd
         XDajJvEOv1IRHwRHreIjaSH1v3cubG5WUG/HwusuS2FCr6sQIrSuGt5paLabrzl9bm
         PBmu14cEttFSgL6ik8co6oapJtGDGrqaNIA7r8U9IzdZi4Bn5NTkA+5amLskcpBokR
         gxixrhmLnS+3PyY+WH0ZnRdICXiqwWP5AcgP6yFICU0VUhZLiY5qoIpiuCeWuQHulh
         UVNLf+UkEyyAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@dell.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Yijun Shen <Yijun.shen@dell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 18/51] e1000e: Only run S0ix flows if shutdown succeeded
Date:   Tue, 12 Jan 2021 07:55:00 -0500
Message-Id: <20210112125534.70280-18-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mario Limonciello <mario.limonciello@dell.com>

[ Upstream commit 808e0d8832cc81738f3e8df12dff0688352baf50 ]

If the shutdown failed, the part will be thawed and running
S0ix flows will put it into an undefined state.

Reported-by: Alexander Duyck <alexander.duyck@gmail.com>
Reviewed-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
Tested-by: Yijun Shen <Yijun.shen@dell.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 128ab6898070e..6588f5d4a2be8 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6970,13 +6970,14 @@ static __maybe_unused int e1000e_pm_suspend(struct device *dev)
 	e1000e_pm_freeze(dev);
 
 	rc = __e1000_shutdown(pdev, false);
-	if (rc)
+	if (rc) {
 		e1000e_pm_thaw(dev);
-
-	/* Introduce S0ix implementation */
-	if (hw->mac.type >= e1000_pch_cnp &&
-	    !e1000e_check_me(hw->adapter->pdev->device))
-		e1000e_s0ix_entry_flow(adapter);
+	} else {
+		/* Introduce S0ix implementation */
+		if (hw->mac.type >= e1000_pch_cnp &&
+		    !e1000e_check_me(hw->adapter->pdev->device))
+			e1000e_s0ix_entry_flow(adapter);
+	}
 
 	return rc;
 }
-- 
2.27.0

