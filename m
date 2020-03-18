Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 569D918A46B
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgCRUyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727562AbgCRUyM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62C7E208DB;
        Wed, 18 Mar 2020 20:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564852;
        bh=0H/mgTxHED+MukhexfpZh7oqusfR3tQHOtZTdFpL1OU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBcwzH5COnDrFrfuZF9N25HBgSesS2Y1HyQKXnr32vzZkMTYAW2qyrS/j96pTfkL1
         2e29u9Qg9iZ/y/Ts+UEY5+AGfvdFBO3ncNxB1Amz7PAalfB4cb68qRxyWDo2ZKZA5/
         /SjdhOHax5c1YOYEF45BEzDzBSTUSX6VrtSjH87c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 29/73] net: hns3: fix a not link up issue when fibre port supports autoneg
Date:   Wed, 18 Mar 2020 16:52:53 -0400
Message-Id: <20200318205337.16279-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 68e1006f618e509fc7869259fe83ceec4a95dac3 ]

When fibre port supports auto-negotiation, the IMP(Intelligent
Management Process) processes the speed of auto-negotiation
and the  user's speed separately.
For below case, the port will get a not link up problem.
step 1: disables auto-negotiation and sets speed to A, then
the driver's MAC speed will be updated to A.
step 2: enables auto-negotiation and MAC gets negotiated
speed B, then the driver's MAC speed will be updated to B
through querying in periodical task.
step 3: MAC gets new negotiated speed A.
step 4: disables auto-negotiation and sets speed to B before
periodical task query new MAC speed A, the driver will  ignore
the speed configuration.

This patch fixes it by skipping speed and duplex checking when
fibre port supports auto-negotiation.

Fixes: 22f48e24a23d ("net: hns3: add autoneg and change speed support for fibre port")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c01cf8ef69df9..d4652dea4569b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2417,10 +2417,12 @@ static int hclge_cfg_mac_speed_dup_hw(struct hclge_dev *hdev, int speed,
 
 int hclge_cfg_mac_speed_dup(struct hclge_dev *hdev, int speed, u8 duplex)
 {
+	struct hclge_mac *mac = &hdev->hw.mac;
 	int ret;
 
 	duplex = hclge_check_speed_dup(duplex, speed);
-	if (hdev->hw.mac.speed == speed && hdev->hw.mac.duplex == duplex)
+	if (!mac->support_autoneg && mac->speed == speed &&
+	    mac->duplex == duplex)
 		return 0;
 
 	ret = hclge_cfg_mac_speed_dup_hw(hdev, speed, duplex);
-- 
2.20.1

