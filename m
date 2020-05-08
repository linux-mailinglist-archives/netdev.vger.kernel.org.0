Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E611CA7D4
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 12:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgEHKDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 06:03:01 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4300 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726761AbgEHKDB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 06:03:01 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A6B7C235A4DA758FA1D3;
        Fri,  8 May 2020 18:02:58 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Fri, 8 May 2020 18:02:50 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next v2] net: ethernet: ti: fix some return value check of cpsw_ale_create()
Date:   Fri, 8 May 2020 10:06:49 +0000
Message-ID: <20200508100649.1112-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200508021059.172001-1-weiyongjun1@huawei.com>
References: <20200508021059.172001-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cpsw_ale_create() can return both NULL and PTR_ERR(), but all of
the caller only check NULL for error handling. This patch convert
it to only return PTR_ERR() in all error cases, all the caller using
IS_ERR() install of NULL test.

Also fix a return negative error code from the cpsw_ale_create()
error handling case instead of 0 in am65_cpsw_nuss_probe().

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Fixes: 4b41d3436796 ("net: ethernet: ti: cpsw: allow untagged traffic on host port")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
v1 -> v2: fix cpsw_ale_create() to retuen PTR_ERR() in all places as Grygorii's suggest
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 3 ++-
 drivers/net/ethernet/ti/cpsw_ale.c       | 2 +-
 drivers/net/ethernet/ti/cpsw_priv.c      | 4 ++--
 drivers/net/ethernet/ti/netcp_ethss.c    | 4 ++--
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 8cdbb2b9b13a..5530d7ef77a6 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2074,8 +2074,9 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	ale_params.nu_switch_ale = true;
 
 	common->ale = cpsw_ale_create(&ale_params);
-	if (!common->ale) {
+	if (IS_ERR(common->ale)) {
 		dev_err(dev, "error initializing ale engine\n");
+		ret = ERR_PTR(common->ale);
 		goto err_of_clear;
 	}
 
diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 0374e6936091..8dc6be11b2ff 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -955,7 +955,7 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params *params)
 
 	ale = devm_kzalloc(params->dev, sizeof(*ale), GFP_KERNEL);
 	if (!ale)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	ale->p0_untag_vid_mask =
 		devm_kmalloc_array(params->dev, BITS_TO_LONGS(VLAN_N_VID),
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 9d098c802c6d..d940628bff8d 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -504,9 +504,9 @@ int cpsw_init_common(struct cpsw_common *cpsw, void __iomem *ss_regs,
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
index 9d6e27fb710e..28093923a7fb 100644
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
2.20.1



