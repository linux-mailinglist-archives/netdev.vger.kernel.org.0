Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 846C913F30A
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390538AbgAPSje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:39:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390410AbgAPRMM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:12:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A494B24698;
        Thu, 16 Jan 2020 17:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194732;
        bh=Jkk9BBeYQ0OeLiIG3SfJOj/YsdJw4csXiPp2Uzx5mcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgXVZyjEzVdTCWsK8WZi99dALXIzM4oB/raqCNJhNREjDk+Okkim627hL+Ucyq+V2
         zuUMIaANXg+qz54IQ6M47N9FS6xEfWG4a035r+4U5W6VqVVQsleUMFM6YT+W46omnS
         fFEKPVrWyL1a4/DCwHKItt2nNERrHZaoSrhVpKGE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 565/671] net: netsec: Fix signedness bug in netsec_probe()
Date:   Thu, 16 Jan 2020 12:03:23 -0500
Message-Id: <20200116170509.12787-302-sashal@kernel.org>
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

[ Upstream commit bd55f8ddbc437c225391ca8f487e7ec10243c4cc ]

The "priv->phy_interface" variable is an enum and in this context GCC
will treat it as an unsigned int so the error handling is never
triggered.

Fixes: 533dd11a12f6 ("net: socionext: Add Synquacer NetSec driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/socionext/netsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index d9d0d03e4ce7..027367b9cc48 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1604,7 +1604,7 @@ static int netsec_probe(struct platform_device *pdev)
 			   NETIF_MSG_LINK | NETIF_MSG_PROBE;
 
 	priv->phy_interface = device_get_phy_mode(&pdev->dev);
-	if (priv->phy_interface < 0) {
+	if ((int)priv->phy_interface < 0) {
 		dev_err(&pdev->dev, "missing required property 'phy-mode'\n");
 		ret = -ENODEV;
 		goto free_ndev;
-- 
2.20.1

