Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9323013EF7E
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392806AbgAPR3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:29:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392786AbgAPR3k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:29:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B895C24710;
        Thu, 16 Jan 2020 17:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195779;
        bh=PpAnb9dKSnBc8bpdqureyriJiQd1kSa+rr79qcBlmCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atA4yAnA0IiHHefPsDaarYsqf+0vJX8s29b0xMlDJEFSW3Hd4NfDE+mOT+ULSga3Y
         BwCVQmykpCK0BJdnYBnvDmGmO+Xg3g+YRw9JzXK12exymECthGfiPcru5dDJTIe0dp
         HbpV7FCIvwnoldAoyixi4Cj2DAe8uXtHMg1+V1io=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 304/371] net: hisilicon: Fix signedness bug in hix5hd2_dev_probe()
Date:   Thu, 16 Jan 2020 12:22:56 -0500
Message-Id: <20200116172403.18149-247-sashal@kernel.org>
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

[ Upstream commit 002dfe8085255b7bf1e0758c3d195c5412d35be9 ]

The "priv->phy_mode" variable is an enum and in this context GCC will
treat it as unsigned to the error handling will never trigger.

Fixes: 57c5bc9ad7d7 ("net: hisilicon: add hix5hd2 mac driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index aab6fb10af94..6adf6831d120 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -1202,7 +1202,7 @@ static int hix5hd2_dev_probe(struct platform_device *pdev)
 		goto err_free_mdio;
 
 	priv->phy_mode = of_get_phy_mode(node);
-	if (priv->phy_mode < 0) {
+	if ((int)priv->phy_mode < 0) {
 		netdev_err(ndev, "not find phy-mode\n");
 		ret = -EINVAL;
 		goto err_mdiobus;
-- 
2.20.1

