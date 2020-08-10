Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E542410BF
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 21:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbgHJTJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 15:09:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728613AbgHJTJm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 15:09:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25A8821775;
        Mon, 10 Aug 2020 19:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086581;
        bh=F31uPowNJjNMfFMctdd2MXIKeA3ecNKO28u5QHm02Fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0JC5oDXRUUsbxy8nPGVQYqdSevENv0OcMenER7Ero9fNbnH2yomiHOXreEq+jUcyh
         K27dW5ypNDFxpYELYYCqWQ5kxHo2sL3boz0p5ivBJPfip1E5ufMJUq2Xm4d/8WeuDa
         4nxEjpIHFxIb+ge016FzV7ogDcxIOr3IsFw+OrAs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 31/64] net: phy: mscc: restore the base page in vsc8514/8584_config_init
Date:   Mon, 10 Aug 2020 15:08:26 -0400
Message-Id: <20200810190859.3793319-31-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810190859.3793319-1-sashal@kernel.org>
References: <20200810190859.3793319-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>

[ Upstream commit 6119dda34e5d0821959e37641b287576826b6378 ]

In the vsc8584_config_init and vsc8514_config_init, the base page is set
to 'GPIO', configuration is done, and the page is never explicitly
restored to the standard page. No bug was triggered as it turns out
helpers called in those config_init functions do modify the base page,
and set it back to standard. But that is dangerous and any modification
to those functions would introduce bugs. This patch fixes this, to
improve maintenance, by restoring the base page to 'standard' once
'GPIO' accesses are completed.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 5ddc44f87eaf0..8f5f2586e7849 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1379,6 +1379,11 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	if (ret)
 		goto err;
 
+	ret = phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+			     MSCC_PHY_PAGE_STANDARD);
+	if (ret)
+		goto err;
+
 	if (!phy_interface_is_rgmii(phydev)) {
 		val = PROC_CMD_MCB_ACCESS_MAC_CONF | PROC_CMD_RST_CONF_PORT |
 			PROC_CMD_READ_MOD_WRITE_PORT;
@@ -1751,7 +1756,11 @@ static int vsc8514_config_init(struct phy_device *phydev)
 	val &= ~MAC_CFG_MASK;
 	val |= MAC_CFG_QSGMII;
 	ret = phy_base_write(phydev, MSCC_PHY_MAC_CFG_FASTLINK, val);
+	if (ret)
+		goto err;
 
+	ret = phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+			     MSCC_PHY_PAGE_STANDARD);
 	if (ret)
 		goto err;
 
-- 
2.25.1

