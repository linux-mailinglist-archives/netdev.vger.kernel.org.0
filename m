Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208E051405A
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 03:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354035AbiD2BpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 21:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbiD2BpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 21:45:02 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075FD60074;
        Thu, 28 Apr 2022 18:41:46 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KqFYq13l9zfb2d;
        Fri, 29 Apr 2022 09:40:47 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 29 Apr 2022 09:41:43 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 29 Apr
 2022 09:41:43 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <grygorii.strashko@ti.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
Subject: [PATCH v2] net: cpsw: add missing of_node_put() in cpsw_probe_dt()
Date:   Fri, 29 Apr 2022 09:53:37 +0800
Message-ID: <20220429015337.934328-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'tmp_node' need be put before returning from cpsw_probe_dt(),
so add missing of_node_put() in error path.

Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v2:
   add of_node_put() at label 'err_node_put'.
---
 drivers/net/ethernet/ti/cpsw_new.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index bd4b1528cf99..79e850fe4621 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1246,8 +1246,10 @@ static int cpsw_probe_dt(struct cpsw_common *cpsw)
 	data->slave_data = devm_kcalloc(dev, CPSW_SLAVE_PORTS_NUM,
 					sizeof(struct cpsw_slave_data),
 					GFP_KERNEL);
-	if (!data->slave_data)
+	if (!data->slave_data) {
+		of_node_put(tmp_node);
 		return -ENOMEM;
+	}
 
 	/* Populate all the child nodes here...
 	 */
@@ -1341,6 +1343,7 @@ static int cpsw_probe_dt(struct cpsw_common *cpsw)
 
 err_node_put:
 	of_node_put(port_np);
+	of_node_put(tmp_node);
 	return ret;
 }
 
-- 
2.25.1

