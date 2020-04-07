Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 654791A034F
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgDGAIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:08:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726795AbgDGABZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA61720857;
        Tue,  7 Apr 2020 00:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217684;
        bh=uCDUcXmEwX5SSUfpabvQs8S1gdekkxZT6ihr0BNLMug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pfW+VS4sMb8Ipvjb61jX0bbHN5aL12raeeSS0aTdXpQCt3SEhtRJKtr9PvwCwvqrj
         WOCr2G2xYqprl+gC8Ynx/ZfxD+PxV01oGY/B77yZ4HXs+Fs8R/MpHKfFcNBV4cDB8q
         CNE7NiQiXT1N7afgHl43Ihqu91u3Rle/BuK76gSA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luo bin <luobin9@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 20/35] hinic: fix a bug of waitting for IO stopped
Date:   Mon,  6 Apr 2020 20:00:42 -0400
Message-Id: <20200407000058.16423-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000058.16423-1-sashal@kernel.org>
References: <20200407000058.16423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>

[ Upstream commit 96758117dc528e6d84bd23d205e8cf7f31eda029 ]

it's unreliable for fw to check whether IO is stopped, so driver
wait for enough time to ensure IO process is done in hw before
freeing resources

Signed-off-by: Luo bin <luobin9@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  | 51 +------------------
 1 file changed, 2 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 79b3d53f2fbfa..c7c75b772a866 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -360,50 +360,6 @@ static int wait_for_db_state(struct hinic_hwdev *hwdev)
 	return -EFAULT;
 }
 
-static int wait_for_io_stopped(struct hinic_hwdev *hwdev)
-{
-	struct hinic_cmd_io_status cmd_io_status;
-	struct hinic_hwif *hwif = hwdev->hwif;
-	struct pci_dev *pdev = hwif->pdev;
-	struct hinic_pfhwdev *pfhwdev;
-	unsigned long end;
-	u16 out_size;
-	int err;
-
-	if (!HINIC_IS_PF(hwif) && !HINIC_IS_PPF(hwif)) {
-		dev_err(&pdev->dev, "Unsupported PCI Function type\n");
-		return -EINVAL;
-	}
-
-	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
-
-	cmd_io_status.func_idx = HINIC_HWIF_FUNC_IDX(hwif);
-
-	end = jiffies + msecs_to_jiffies(IO_STATUS_TIMEOUT);
-	do {
-		err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
-					HINIC_COMM_CMD_IO_STATUS_GET,
-					&cmd_io_status, sizeof(cmd_io_status),
-					&cmd_io_status, &out_size,
-					HINIC_MGMT_MSG_SYNC);
-		if ((err) || (out_size != sizeof(cmd_io_status))) {
-			dev_err(&pdev->dev, "Failed to get IO status, ret = %d\n",
-				err);
-			return err;
-		}
-
-		if (cmd_io_status.status == IO_STOPPED) {
-			dev_info(&pdev->dev, "IO stopped\n");
-			return 0;
-		}
-
-		msleep(20);
-	} while (time_before(jiffies, end));
-
-	dev_err(&pdev->dev, "Wait for IO stopped - Timeout\n");
-	return -ETIMEDOUT;
-}
-
 /**
  * clear_io_resource - set the IO resources as not active in the NIC
  * @hwdev: the NIC HW device
@@ -423,11 +379,8 @@ static int clear_io_resources(struct hinic_hwdev *hwdev)
 		return -EINVAL;
 	}
 
-	err = wait_for_io_stopped(hwdev);
-	if (err) {
-		dev_err(&pdev->dev, "IO has not stopped yet\n");
-		return err;
-	}
+	/* sleep 100ms to wait for firmware stopping I/O */
+	msleep(100);
 
 	cmd_clear_io_res.func_idx = HINIC_HWIF_FUNC_IDX(hwif);
 
-- 
2.20.1

