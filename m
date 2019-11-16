Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F8EFEDB2
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 16:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbfKPPqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:46:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729277AbfKPPqE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:04 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3DCC20833;
        Sat, 16 Nov 2019 15:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919164;
        bh=0ptIyz2rwTGU2srGHJGqVEpxkJkoXMIW8fkoSVCQ1YI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0WkOjB+FkjbZcSnJuSCV3ZaylgPrPkD6cbvzVyPPzUZv1IcS+zxsGK+ejVu07MLxA
         i286l6d4B4Jo5e1iGVPfpJ4mNfv0bhcZa1iYcbVCEsC19TUtAmU0wx+3uR/fKE9wu4
         QiNNNBUsF2zKocpTog1pVPlOcNOTcFn7yTkWezdI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 171/237] net: hns3: bugfix for hclge_mdio_write and hclge_mdio_read
Date:   Sat, 16 Nov 2019 10:40:06 -0500
Message-Id: <20191116154113.7417-171-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit 1c12493809924deda6c0834cb2f2c5a6dc786390 ]

When there is a PHY, the driver needs to complete some operations through
MDIO during reset reinitialization, so HCLGE_STATE_CMD_DISABLE is more
suitable than HCLGE_STATE_RST_HANDLING to prevent the MDIO operation from
being sent during the hardware reset.

Fixes: b50ae26c57cb ("net: hns3: never send command queue message to IMP when reset)
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
index 398971a062f47..03491e8ebb730 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
@@ -54,7 +54,7 @@ static int hclge_mdio_write(struct mii_bus *bus, int phyid, int regnum,
 	struct hclge_desc desc;
 	int ret;
 
-	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
+	if (test_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state))
 		return 0;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_MDIO_CONFIG, false);
@@ -92,7 +92,7 @@ static int hclge_mdio_read(struct mii_bus *bus, int phyid, int regnum)
 	struct hclge_desc desc;
 	int ret;
 
-	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
+	if (test_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state))
 		return 0;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_MDIO_CONFIG, true);
-- 
2.20.1

