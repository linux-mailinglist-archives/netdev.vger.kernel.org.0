Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFD5713E3BF
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388474AbgAPRCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:02:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388462AbgAPRCp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8A912467C;
        Thu, 16 Jan 2020 17:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194164;
        bh=S8X1xJcjW3hguFRJhdG5X+h1/mJOR68raBbkBr9FXsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icb+tahqhjSU/a2/rFRjxe/T4/9Ul0SvqRkFTEFwDxGNoXlb1Bmb/YRW21h1s2RcO
         mNK4E3SX/BKHJdNUvVlHy2TMyRMa3DqGnq0PHGOVfAXO2miLgbAgUwQId3EsLYK3Ph
         +vf1s/oY/ANiiqH+5I2/R/4QcJYcpbTA9GSoCOj0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 245/671] net: sh_eth: fix a missing check of of_get_phy_mode
Date:   Thu, 16 Jan 2020 11:52:34 -0500
Message-Id: <20200116165940.10720-128-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit 035a14e71f27eefa50087963b94cbdb3580d08bf ]

of_get_phy_mode may fail and return a negative error code;
the fix checks the return value of of_get_phy_mode and
returns NULL of it fails.

Fixes: b356e978e92f ("sh_eth: add device tree support")
Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 5e3e6e262ba3..f20290c72412 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3129,12 +3129,16 @@ static struct sh_eth_plat_data *sh_eth_parse_dt(struct device *dev)
 	struct device_node *np = dev->of_node;
 	struct sh_eth_plat_data *pdata;
 	const char *mac_addr;
+	int ret;
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return NULL;
 
-	pdata->phy_interface = of_get_phy_mode(np);
+	ret = of_get_phy_mode(np);
+	if (ret < 0)
+		return NULL;
+	pdata->phy_interface = ret;
 
 	mac_addr = of_get_mac_address(np);
 	if (mac_addr)
-- 
2.20.1

