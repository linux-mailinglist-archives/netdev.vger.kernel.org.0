Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 943C613F308
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407196AbgAPSjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:39:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:54662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390434AbgAPRMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:12:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29AE824690;
        Thu, 16 Jan 2020 17:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194737;
        bh=i8Mc8ktcBWCOaWcwPEM9+Ic2PxDRqnufU9bUQ91cDN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=op17xVgCJ1r5EIE5IyW3320APFQMEWp9sVJ/cf3u2Fr50RQD29e4qMlfFZJe3U7wa
         69PpZDCCNqk/e1VAYYrseupyw8uTCPJV7uQRL6M8EERLUsYTjJrS+l7cL+7Asam+jI
         uBGC2b03muE/5kO2vi9slKebHv0llscBuhWf74NM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 568/671] net: axienet: fix a signedness bug in probe
Date:   Thu, 16 Jan 2020 12:03:26 -0500
Message-Id: <20200116170509.12787-305-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 73e211e11be86715d66bd3c9d38b3c34b05fca9a ]

The "lp->phy_mode" is an enum but in this context GCC treats it as an
unsigned int so the error handling is never triggered.

Fixes: ee06b1728b95 ("net: axienet: add support for standard phy-mode binding")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 28764268a44f..b093f14eeec3 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1573,7 +1573,7 @@ static int axienet_probe(struct platform_device *pdev)
 		}
 	} else {
 		lp->phy_mode = of_get_phy_mode(pdev->dev.of_node);
-		if (lp->phy_mode < 0) {
+		if ((int)lp->phy_mode < 0) {
 			ret = -EINVAL;
 			goto free_netdev;
 		}
-- 
2.20.1

