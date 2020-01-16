Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7CC13EF7B
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395320AbgAPSPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:15:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:41694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392819AbgAPR3n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:29:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A76A246FB;
        Thu, 16 Jan 2020 17:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195782;
        bh=GUiVFRULi9/DHKirBIopVTqMsuqLnxRqBwtYhWEoNZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AnR6DHLTYHE4TTuNl0zIO9qrCRbzxOrpuOrAf/Y6T4+CmMXZHURXWGIEnRcYh1JFp
         6UzQWPXzvGZeqMvv6p7cNewdDjudZ14qt1+Q/8rFv8uLLUsT/4arxsnXhhzx5rRWJ7
         GKl29EHEyI1sWuYhoA45ePz1vdeIaguUI/yOvvfw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 306/371] net: stmmac: dwmac-meson8b: Fix signedness bug in probe
Date:   Thu, 16 Jan 2020 12:22:58 -0500
Message-Id: <20200116172403.18149-249-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f10210517a2f37feea2edf85eb34c98977265c16 ]

The "dwmac->phy_mode" is an enum and in this context GCC treats it as
an unsigned int so the error handling is never triggered.

Fixes: 566e82516253 ("net: stmmac: add a glue driver for the Amlogic Meson 8b / GXBB DWMAC")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index 8be4b32544ef..d71d3c1c85ee 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -285,7 +285,7 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
 
 	dwmac->pdev = pdev;
 	dwmac->phy_mode = of_get_phy_mode(pdev->dev.of_node);
-	if (dwmac->phy_mode < 0) {
+	if ((int)dwmac->phy_mode < 0) {
 		dev_err(&pdev->dev, "missing phy-mode property\n");
 		ret = -EINVAL;
 		goto err_remove_config_dt;
-- 
2.20.1

