Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7B4B169491
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbgBWCXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:23:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:52834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728615AbgBWCXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:23:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1969221741;
        Sun, 23 Feb 2020 02:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424600;
        bh=/wvHWtSABa6XrGoPvgU/g74uNC1TiUDqH775k+bJX6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FtnXFnPoSR340Kj8gsqiTZHnj8uUJtm0GKp4DL9KWOk4Ueivx6Z+Ppzv/doU1coy0
         55JJVG3Jb78CzekPVn05jt+3t6Sa+gFnKFdSrGgYm773SUzkN08FY4+x/8/PtqpOqM
         CegqiAlsBES47kXJsqBZZKBofKSof/N++vlwN6EY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arthur Kiyanovski <akiyano@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 37/50] net: ena: fix corruption of dev_idx_to_host_tbl
Date:   Sat, 22 Feb 2020 21:22:22 -0500
Message-Id: <20200223022235.1404-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022235.1404-1-sashal@kernel.org>
References: <20200223022235.1404-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

[ Upstream commit e3f89f91e98ce07dc0f121a3b70d21aca749ba39 ]

The function ena_com_ind_tbl_convert_from_device() has an overflow
bug as explained below. Either way, this function is not needed at
all since we don't retrieve the indirection table from the device
at any point which means that this conversion is not needed.

The bug:
The for loop iterates over all io_sq_queues, when passing the actual
number of used queues the io_sq_queues[i].idx equals 0 since they are
uninitialized which results in the following code to be executed till
the end of the loop:

dev_idx_to_host_tbl[0] = i;

This results dev_idx_to_host_tbl[0] in being equal to
ENA_TOTAL_NUM_QUEUES - 1.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 28 -----------------------
 1 file changed, 28 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 8ab192cb26b74..74743fd8a1e0a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1281,30 +1281,6 @@ static int ena_com_ind_tbl_convert_to_device(struct ena_com_dev *ena_dev)
 	return 0;
 }
 
-static int ena_com_ind_tbl_convert_from_device(struct ena_com_dev *ena_dev)
-{
-	u16 dev_idx_to_host_tbl[ENA_TOTAL_NUM_QUEUES] = { (u16)-1 };
-	struct ena_rss *rss = &ena_dev->rss;
-	u8 idx;
-	u16 i;
-
-	for (i = 0; i < ENA_TOTAL_NUM_QUEUES; i++)
-		dev_idx_to_host_tbl[ena_dev->io_sq_queues[i].idx] = i;
-
-	for (i = 0; i < 1 << rss->tbl_log_size; i++) {
-		if (rss->rss_ind_tbl[i].cq_idx > ENA_TOTAL_NUM_QUEUES)
-			return -EINVAL;
-		idx = (u8)rss->rss_ind_tbl[i].cq_idx;
-
-		if (dev_idx_to_host_tbl[idx] > ENA_TOTAL_NUM_QUEUES)
-			return -EINVAL;
-
-		rss->host_rss_ind_tbl[i] = dev_idx_to_host_tbl[idx];
-	}
-
-	return 0;
-}
-
 static void ena_com_update_intr_delay_resolution(struct ena_com_dev *ena_dev,
 						 u16 intr_delay_resolution)
 {
@@ -2638,10 +2614,6 @@ int ena_com_indirect_table_get(struct ena_com_dev *ena_dev, u32 *ind_tbl)
 	if (!ind_tbl)
 		return 0;
 
-	rc = ena_com_ind_tbl_convert_from_device(ena_dev);
-	if (unlikely(rc))
-		return rc;
-
 	for (i = 0; i < (1 << rss->tbl_log_size); i++)
 		ind_tbl[i] = rss->host_rss_ind_tbl[i];
 
-- 
2.20.1

