Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52583BD040
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbhGFLdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234728AbhGFL2c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:28:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FB5961D66;
        Tue,  6 Jul 2021 11:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570415;
        bh=NK1C+OqojIwMpGe7AJKnUxjuIRKG0Oa2NtHXQG3auq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iHMmyzSMRw9qvpCjlC0dospDwRt7W7GJV7l5f/tAfq5lflLxBWIcrbWpl/FBt8KH2
         XBADejaFEmKwj1pvWVaRHAupfLUA/QblDFKc5Y7otBGGPjRzEbtmugSsrmhhDV0ihQ
         WAheasn6y0213sFGGq/sHTs2CACPmZ7Yp2QhkJQ6kRqWH7VeKBl3R/uDJcrzFzQgvY
         dHr/YmJDQMp2x7LBBp1NRDCm8JaAfEHuyTJx7b3PAX0zl2ygAE6OOU7EYi2g2wgzo6
         gjyOthRqCooFHCcoM2w8y81LW1mzrXFvgAytNVKejFHN2mTYvn7kwqczOOe3lzL10m
         QllIVpzhS0Dvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 081/160] net: phy: realtek: add delay to fix RXC generation issue
Date:   Tue,  6 Jul 2021 07:17:07 -0400
Message-Id: <20210706111827.2060499-81-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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

