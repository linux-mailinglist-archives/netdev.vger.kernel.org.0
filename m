Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C563BD5B7
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237982AbhGFMYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:24:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236435AbhGFLfV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBC0861C6A;
        Tue,  6 Jul 2021 11:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570616;
        bh=4wq+6xr6u201ec9VCBKH650shM95NMLWgbAR6Iwvqsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYlqbafK3EHKdLxmNsobnl1G/aqQGzjEjrYuPdLOlwMCAU2hB49cKnchX2r0KZKz9
         0+kHRFY9EX6awrfHZQ/sbDviGYsFwE3PyqeaaW0DHLS/JgG8QBKnZSUvsp+eqw/O20
         rUXEUXio6vmtzVd3WULxzB9bo+vlnu7NgyMFXiJb+8i0JW0O/X2sfY2UtfXbBnrEI1
         I3uPMzCMUfAnz99v6aqXQW21H6Mu07TVF+BSQ1d8DIy0pMMtQhyJeQ5mqCDpVAyXgJ
         FwuuQ7Vu61x0+QCcqBfc65R481ybK9xp5cs+5MW9PUSYQEjRuEL1p9J0fbhmH+Pig5
         JLdqMcZjm+UXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 072/137] net: phy: realtek: add delay to fix RXC generation issue
Date:   Tue,  6 Jul 2021 07:20:58 -0400
Message-Id: <20210706112203.2062605-72-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
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
index 575580d3ffe0..b4879306bb8a 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -246,6 +246,19 @@ static int rtl8211f_config_init(struct phy_device *phydev)
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
@@ -624,7 +637,7 @@ static struct phy_driver realtek_drvs[] = {
 		.ack_interrupt	= &rtl8211f_ack_interrupt,
 		.config_intr	= &rtl8211f_config_intr,
 		.suspend	= genphy_suspend,
-		.resume		= genphy_resume,
+		.resume		= rtl821x_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
 	}, {
-- 
2.30.2

