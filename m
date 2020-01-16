Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2F013ED99
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405573AbgAPRkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:40:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:57890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393653AbgAPRkk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:40:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEF3B2472E;
        Thu, 16 Jan 2020 17:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196440;
        bh=lgMIRPmKoi13KARQ1dGePxauG3B+flYS/UXmP+E1xdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=afA499yFYPGvz/MtRRG6V9Lew7RyuUlrz2LbaRzvipNWY8sUqnzXtxkbZhKgBf//L
         hIjSy5H5uFjPPMnOvYIdDyzHvY9xwiPSuM9/XbL7UE526Gt3UIwIQ/WdfTFqN3o3rT
         iM8G74DJWG8sgWRHdCjpTCVf2GJjGyumtVqGFIdc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 204/251] net: broadcom/bcmsysport: Fix signedness in bcm_sysport_probe()
Date:   Thu, 16 Jan 2020 12:35:53 -0500
Message-Id: <20200116173641.22137-164-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 25a584955f020d6ec499c513923fb220f3112d2b ]

The "priv->phy_interface" variable is an enum and in this context GCC
will treat it as unsigned so the error handling will never be
triggered.

Fixes: 80105befdb4b ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 95874c10c23b..e3b41af65d18 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1773,7 +1773,7 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 
 	priv->phy_interface = of_get_phy_mode(dn);
 	/* Default to GMII interface mode */
-	if (priv->phy_interface < 0)
+	if ((int)priv->phy_interface < 0)
 		priv->phy_interface = PHY_INTERFACE_MODE_GMII;
 
 	/* In the case of a fixed PHY, the DT node associated
-- 
2.20.1

