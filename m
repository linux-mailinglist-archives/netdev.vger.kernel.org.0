Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B23635099
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 07:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbiKWGlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 01:41:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236082AbiKWGl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 01:41:27 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C67FF41B8
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 22:41:26 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NHBN7010LzRpMf;
        Wed, 23 Nov 2022 14:40:54 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 14:41:24 +0800
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 14:41:23 +0800
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
To:     <saeed@kernel.org>, <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <davem@davemloft.net>, <radhac@marvell.com>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pnalla@marvell.com>, <snilla@marvell.com>
CC:     <netdev@vger.kernel.org>, <yangyingliang@huawei.com>,
        <wangxiongfeng2@huawei.com>
Subject: [PATCH v2] octeontx2-af: Fix reference count issue in rvu_sdp_init()
Date:   Wed, 23 Nov 2022 14:59:19 +0800
Message-ID: <20221123065919.31499-1-wangxiongfeng2@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pci_get_device() will decrease the reference count for the *from*
parameter. So we don't need to call put_device() to decrease the
reference. Let's remove the put_device() in the loop and only decrease
the reference count of the returned 'pdev' for the last loop because it
will not be passed to pci_get_device() as input parameter. We don't need
to check if 'pdev' is NULL because it is already checked inside
pci_dev_put(). Also add pci_dev_put() for the error path.

Fixes: fe1939bb2340 ("octeontx2-af: Add SDP interface support")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Reviewed-by: Saeed Mahameed <saeed@kernel.org>
---
ChangeLog:
v1->v2:
   1. drop the 'if(pdev)' check because it is already checked inside pci_dev_put()
   2. add Reviewed-by tag
   3. CC all the blamed authors and maintainers
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
index b04fb226f708..ae50d56258ec 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
@@ -62,15 +62,18 @@ int rvu_sdp_init(struct rvu *rvu)
 		pfvf->sdp_info = devm_kzalloc(rvu->dev,
 					      sizeof(struct sdp_node_info),
 					      GFP_KERNEL);
-		if (!pfvf->sdp_info)
+		if (!pfvf->sdp_info) {
+			pci_dev_put(pdev);
 			return -ENOMEM;
+		}
 
 		dev_info(rvu->dev, "SDP PF number:%d\n", sdp_pf_num[i]);
 
-		put_device(&pdev->dev);
 		i++;
 	}
 
+	pci_dev_put(pdev);
+
 	return 0;
 }
 
-- 
2.20.1

