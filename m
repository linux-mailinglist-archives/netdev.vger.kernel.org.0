Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A08106200
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfKVF50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:57:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729419AbfKVF5Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:57:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42CAF2070A;
        Fri, 22 Nov 2019 05:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402243;
        bh=I+9HfdYWanbujl1taV32XPKQTdpZAE/Rjg/alK72ODc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4wAq67/rxl1EMyMut9u+Ljf+JZnkEOv1Xsw7xF6Z/+6UNWlRb74F9gDQEw/ocUa0
         uBtqPSDsEDyxIKruIAs9lGmj8honqKc+J5o3y+9mAjkX/FXkFnadJohBTQvo1SO+2W
         LkFQ0R5I2XsdkWBYgpjyotT0wI3LOFOIjmM5FMF0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 088/127] atl1e: checking the status of atl1e_write_phy_reg
Date:   Fri, 22 Nov 2019 00:55:06 -0500
Message-Id: <20191122055544.3299-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit ff07d48d7bc0974d4f96a85a4df14564fb09f1ef ]

atl1e_write_phy_reg() could fail. The fix issues an error message when
it fails.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 4f7e195af0bc6..0d08039981b54 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -472,7 +472,9 @@ static void atl1e_mdio_write(struct net_device *netdev, int phy_id,
 {
 	struct atl1e_adapter *adapter = netdev_priv(netdev);
 
-	atl1e_write_phy_reg(&adapter->hw, reg_num & MDIO_REG_ADDR_MASK, val);
+	if (atl1e_write_phy_reg(&adapter->hw,
+				reg_num & MDIO_REG_ADDR_MASK, val))
+		netdev_err(netdev, "write phy register failed\n");
 }
 
 static int atl1e_mii_ioctl(struct net_device *netdev,
-- 
2.20.1

