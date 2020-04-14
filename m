Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF68B1A79AC
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 13:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439370AbgDNLgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 07:36:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:52800 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439325AbgDNLgg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 07:36:36 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D8BDFF2A221BDC373A7D;
        Tue, 14 Apr 2020 19:36:30 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Tue, 14 Apr 2020
 19:36:24 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <stas.yakovlev@gmail.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] ipw2x00: make ipw_setup_deferred_work() void
Date:   Tue, 14 Apr 2020 20:02:51 +0800
Message-ID: <20200414120251.35869-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function actually needs no return value. So remove the unneeded
variable 'ret' and make it void.

This also fixes the following coccicheck warning:

drivers/net/wireless/intel/ipw2x00/ipw2200.c:10648:5-8: Unneeded
variable: "ret". Return "0" on line 10684

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 201a1eb0e2f6..923be3781c92 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -10640,10 +10640,8 @@ static void ipw_bg_link_down(struct work_struct *work)
 	mutex_unlock(&priv->mutex);
 }
 
-static int ipw_setup_deferred_work(struct ipw_priv *priv)
+static void ipw_setup_deferred_work(struct ipw_priv *priv)
 {
-	int ret = 0;
-
 	init_waitqueue_head(&priv->wait_command_queue);
 	init_waitqueue_head(&priv->wait_state);
 
@@ -10677,8 +10675,6 @@ static int ipw_setup_deferred_work(struct ipw_priv *priv)
 
 	tasklet_init(&priv->irq_tasklet,
 		     ipw_irq_tasklet, (unsigned long)priv);
-
-	return ret;
 }
 
 static void shim__set_security(struct net_device *dev,
@@ -11659,11 +11655,7 @@ static int ipw_pci_probe(struct pci_dev *pdev,
 	IPW_DEBUG_INFO("pci_resource_len = 0x%08x\n", length);
 	IPW_DEBUG_INFO("pci_resource_base = %p\n", base);
 
-	err = ipw_setup_deferred_work(priv);
-	if (err) {
-		IPW_ERROR("Unable to setup deferred work\n");
-		goto out_iounmap;
-	}
+	ipw_setup_deferred_work(priv);
 
 	ipw_sw_reset(priv, 1);
 
-- 
2.21.1

