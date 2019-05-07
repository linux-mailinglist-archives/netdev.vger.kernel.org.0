Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B17D15BFC
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbfEGF7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728158AbfEGFgp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:36:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97C3520B7C;
        Tue,  7 May 2019 05:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207405;
        bh=wl5TuaET9VOElNIB4pAQ3YmM6xzvebkpLmf1Sbkd5Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfTMrXl0iMWNausytItP2gOUzpu92/mU3l1JgyFrNJH01v6mRspLjZI2H3JHiAiu5
         Vf4nE/978WV4t0piaZNi/pigMF1uzBSuk1mxYz9SFcG5W5AtcdAKyy0suIJd63CoO0
         Bkb7uGj8Fh26dIVknEYc0AQV7o835DtM1U9Ccgyg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 26/81] qede: fix write to free'd pointer error and double free of ptp
Date:   Tue,  7 May 2019 01:34:57 -0400
Message-Id: <20190507053554.30848-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 1dc2b3d65523780ed1972d446c76e62e13f3e8f5 ]

The err2 error return path calls qede_ptp_disable that cleans up
on an error and frees ptp. After this, the free'd ptp is dereferenced
when ptp->clock is set to NULL and the code falls-through to error
path err1 that frees ptp again.

Fix this by calling qede_ptp_disable and exiting via an error
return path that does not set ptp->clock or kfree ptp.

Addresses-Coverity: ("Write to pointer after free")
Fixes: 035744975aec ("qede: Add support for PTP resource locking.")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_ptp.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_ptp.c b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
index 013ff567283c..5e574c3b625e 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ptp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
@@ -490,18 +490,17 @@ int qede_ptp_enable(struct qede_dev *edev, bool init_tc)
 
 	ptp->clock = ptp_clock_register(&ptp->clock_info, &edev->pdev->dev);
 	if (IS_ERR(ptp->clock)) {
-		rc = -EINVAL;
 		DP_ERR(edev, "PTP clock registration failed\n");
+		qede_ptp_disable(edev);
+		rc = -EINVAL;
 		goto err2;
 	}
 
 	return 0;
 
-err2:
-	qede_ptp_disable(edev);
-	ptp->clock = NULL;
 err1:
 	kfree(ptp);
+err2:
 	edev->ptp = NULL;
 
 	return rc;
-- 
2.20.1

