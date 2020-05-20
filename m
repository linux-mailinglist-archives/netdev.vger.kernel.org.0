Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66601DA8AC
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 05:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbgETDiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 23:38:09 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4820 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726432AbgETDiH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 23:38:07 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0636ACF34B1CD2B57B0C;
        Wed, 20 May 2020 11:38:04 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Wed, 20 May 2020 11:37:56 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <netdev@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Wei Yongjun <weiyongjun1@huawei.com>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH 1/2 v3] net: ethernet: ti: fix some return value check of cpsw_ale_create()
Date:   Wed, 20 May 2020 11:41:15 +0800
Message-ID: <20200520034116.170946-2-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200520034116.170946-1-weiyongjun1@huawei.com>
References: <20200520034116.170946-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cpsw_ale_create() can return both NULL and PTR_ERR(), but all of
the caller only check NULL for error handling. This patch convert
it to only return PTR_ERR() in all error cases, and the caller using
IS_ERR() instead of NULL test.

Fixes: 4b41d3436796 ("net: ethernet: ti: cpsw: allow untagged traffic on host port")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/ti/cpsw_ale.c    | 2 +-
 drivers/net/ethernet/ti/cpsw_priv.c   | 4 ++--
 drivers/net/ethernet/ti/netcp_ethss.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

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

