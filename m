Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265333BCC8B
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhGFLTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232684AbhGFLS4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8F7561C22;
        Tue,  6 Jul 2021 11:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570178;
        bh=NK1C+OqojIwMpGe7AJKnUxjuIRKG0Oa2NtHXQG3auq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJ8m475ePWiDRGRNdLry6SRxnZ/UIvEdqciSU4418LUmfj2/O8bMWhe7STdJWd0lG
         yDJAlFOHGt7y0Kg5ONSm5l0DvJz0r3vCx5IC8bfcLdusybYLopNVA9NIhDwpHvSoAA
         Sgrx6BsP2NRIHYkTWAGrHIuQ5g8gENdoFeuecUwzj5FAb8Jpt94w2taH9SsWvXdfiU
         NUQXtJqsZ9hZ77rL6BVXFbW3rbDHMCXjUAMx5bFcRCxLZI4aHmUAuP9zTPUAWAdP5V
         THIeQT6G6P2L7Me9GhpU1y3JKcL7+638j4LjW4cT/ccLkT6WasJIUs9PV+YSdQpjjo
         GFCmX2MahlODw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 095/189] net: phy: realtek: add delay to fix RXC generation issue
Date:   Tue,  6 Jul 2021 07:12:35 -0400
Message-Id: <20210706111409.2058071-95-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

[ Upstream commit 6813cc8cfdaf401476e1a007cec8ae338cefa573 ]

PHY will delay about 11.5ms to generate RXC clock when switching from
power down to normal operation. Read/write registers would also cause RXC
become unstable and stop for a while during this process. Realtek engineer
suggests 15ms or more delay can workaround this issue.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 821e85a97367..7b99a3234c65 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -357,6 +357,19 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static int rtl821x_resume(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = genphy_resume(phydev);
+	if (ret < 0)
+		return ret;
+
+	msleep(20);
+
+	return 0;
+}
+
 static int rtl8211e_config_init(struct phy_device *phydev)
 {
 	int ret = 0, oldpage;
@@ -852,7 +865,7 @@ static struct phy_driver realtek_drvs[] = {
 		.config_intr	= &rtl8211f_config_intr,
 		.handle_interrupt = rtl8211f_handle_interrupt,
 		.suspend	= genphy_suspend,
-		.resume		= genphy_resume,
+		.resume		= rtl821x_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
 	}, {
-- 
2.30.2

