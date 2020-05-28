Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66AD1E6036
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388768AbgE1L4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 07:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388746AbgE1L4b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:56:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A21EF20DD4;
        Thu, 28 May 2020 11:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590666990;
        bh=2+TLxM3G8QfbMlQcupi4uaoiUaXyEpZ8gudy8Moj2iY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=11ZU5ZtYuHUSQlv7qcPbzAlohhYmV3xxq5IzQd+a73VdlEF6QPw3X4J6Y1PUeRn5z
         kvzRFA3FeqMPXgndUFqvFqbuhFiGRq74526Sie2tfImLQz12ak+xgE5N6qYHFo90IX
         ieRR8Tev2Klrve3eIo+Upeh4w4UHLQDb/Qc6BOIU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 26/47] net: ethernet: ti: fix some return value check of cpsw_ale_create()
Date:   Thu, 28 May 2020 07:55:39 -0400
Message-Id: <20200528115600.1405808-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 3469660d1b15ccfdf7b33295c306b6298ca730aa ]

cpsw_ale_create() can return both NULL and PTR_ERR(), but all of
the caller only check NULL for error handling. This patch convert
it to only return PTR_ERR() in all error cases, and the caller using
IS_ERR() instead of NULL test.

Fixes: 4b41d3436796 ("net: ethernet: ti: cpsw: allow untagged traffic on host port")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw_ale.c    | 2 +-
 drivers/net/ethernet/ti/cpsw_priv.c   | 4 ++--
 drivers/net/ethernet/ti/netcp_ethss.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index ecdbde539eb7..4eb14b174c1a 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -917,7 +917,7 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params *params)
 
 	ale = devm_kzalloc(params->dev, sizeof(*ale), GFP_KERNEL);
 	if (!ale)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	ale->p0_untag_vid_mask =
 		devm_kmalloc_array(params->dev, BITS_TO_LONGS(VLAN_N_VID),
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 97a058ca60ac..d0b6c418a870 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -490,9 +490,9 @@ int cpsw_init_common(struct cpsw_common *cpsw, void __iomem *ss_regs,
 	ale_params.ale_ports		= CPSW_ALE_PORTS_NUM;
 
 	cpsw->ale = cpsw_ale_create(&ale_params);
-	if (!cpsw->ale) {
+	if (IS_ERR(cpsw->ale)) {
 		dev_err(dev, "error initializing ale engine\n");
-		return -ENODEV;
+		return PTR_ERR(cpsw->ale);
 	}
 
 	dma_params.dev		= dev;
diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index fb36115e9c51..fdbae734acce 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -3704,9 +3704,9 @@ static int gbe_probe(struct netcp_device *netcp_device, struct device *dev,
 		ale_params.nu_switch_ale = true;
 	}
 	gbe_dev->ale = cpsw_ale_create(&ale_params);
-	if (!gbe_dev->ale) {
+	if (IS_ERR(gbe_dev->ale)) {
 		dev_err(gbe_dev->dev, "error initializing ale engine\n");
-		ret = -ENODEV;
+		ret = PTR_ERR(gbe_dev->ale);
 		goto free_sec_ports;
 	} else {
 		dev_dbg(gbe_dev->dev, "Created a gbe ale engine\n");
-- 
2.25.1

