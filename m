Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A742113F315
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436934AbgAPSkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:40:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390397AbgAPRMJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:12:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36B842469C;
        Thu, 16 Jan 2020 17:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194728;
        bh=43bZk1u//lMlRxSTRt9S0p+Aq58XOf+eHUv5B4LBTy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0Gf76rEfd4ckSjQJDZs/8AWfqMB9KJsYRAK8A3Lgv9SwKi0/40rmVMc+WR93ZJn9
         hBGrvjV1Y0IQRwtyX+NjcWUA48A6pRhvsqpoo3VF4g+vM0bInFF79cjetoAM5Ua33y
         UK0q/yrD61ywj0B79IkhuIWjM61UTA3GhNWauYTM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 562/671] cxgb4: Signedness bug in init_one()
Date:   Thu, 16 Jan 2020 12:03:20 -0500
Message-Id: <20200116170509.12787-299-sashal@kernel.org>
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

[ Upstream commit 286183147666fb76c057836c57d86e9e6f508bca ]

The "chip" variable is an enum, and it's treated as unsigned int by GCC
in this context so the error handling isn't triggered.

Fixes: e8d452923ae6 ("cxgb4: clean up init_one")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index bb04c695ab9f..c81d6c330548 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -5452,7 +5452,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	whoami = t4_read_reg(adapter, PL_WHOAMI_A);
 	pci_read_config_word(pdev, PCI_DEVICE_ID, &device_id);
 	chip = t4_get_chip_type(adapter, CHELSIO_PCI_ID_VER(device_id));
-	if (chip < 0) {
+	if ((int)chip < 0) {
 		dev_err(&pdev->dev, "Device %d is not supported\n", device_id);
 		err = chip;
 		goto out_free_adapter;
-- 
2.20.1

