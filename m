Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65D9D15CC6
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 08:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfEGFdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:33:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726933AbfEGFdf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:33:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 338FB20C01;
        Tue,  7 May 2019 05:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207214;
        bh=LjxB1Lru9467AZRQOnDIBzkG0WGD7dNK/6BFLWulqgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtRrFWiVSqC9YHhP6DIkoA4W4AcSXNUOdfYmrM+8h2O2lLtjXPamCepZOo8FhatuB
         TYVaMyQr6WGFdAbd0/MlUGYlKQpHMRGhyKBL9JIzkhNjG25qQhwK1VCmJkvNdovrvw
         2WQdIIP51ubVbCdoX5jD+Qr0oytjwJuqY2FiNpPg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 30/99] qede: fix write to free'd pointer error and double free of ptp
Date:   Tue,  7 May 2019 01:31:24 -0400
Message-Id: <20190507053235.29900-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
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
index 5f3f42a25361..bddb2b5982dc 100644
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

