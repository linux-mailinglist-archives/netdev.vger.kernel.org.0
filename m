Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C5F509716
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 08:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384616AbiDUGAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 02:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237590AbiDUGAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 02:00:32 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9047B6591;
        Wed, 20 Apr 2022 22:57:42 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KkRd22rYpzfYpM;
        Thu, 21 Apr 2022 13:56:54 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500023.china.huawei.com
 (7.185.36.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 21 Apr
 2022 13:57:40 +0800
From:   Peng Wu <wupeng58@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <huangguangbin2@huawei.com>, <shenyang39@huawei.com>,
        <lipeng321@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wupeng58@huawei.com>, <liwei391@huawei.com>
Subject: [PATCH] net: hns: Add missing fwnode_handle_put in hns_mac_init
Date:   Thu, 21 Apr 2022 05:53:44 +0000
Message-ID: <20220421055344.8102-1-wupeng58@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In one of the error paths of the device_for_each_child_node() loop
in hns_mac_init, add missing call to fwnode_handle_put.

Signed-off-by: Peng Wu <wupeng58@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
index 7edf8569514c..928d934cb21a 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
@@ -1065,19 +1065,23 @@ int hns_mac_init(struct dsaf_device *dsaf_dev)
 	device_for_each_child_node(dsaf_dev->dev, child) {
 		ret = fwnode_property_read_u32(child, "reg", &port_id);
 		if (ret) {
+			fwnode_handle_put(child);
 			dev_err(dsaf_dev->dev,
 				"get reg fail, ret=%d!\n", ret);
 			return ret;
 		}
 		if (port_id >= max_port_num) {
+			fwnode_handle_put(child);
 			dev_err(dsaf_dev->dev,
 				"reg(%u) out of range!\n", port_id);
 			return -EINVAL;
 		}
 		mac_cb = devm_kzalloc(dsaf_dev->dev, sizeof(*mac_cb),
 				      GFP_KERNEL);
-		if (!mac_cb)
+		if (!mac_cb) {
+			fwnode_handle_put(child);
 			return -ENOMEM;
+		}
 		mac_cb->fw_port = child;
 		mac_cb->mac_id = (u8)port_id;
 		dsaf_dev->mac_cb[port_id] = mac_cb;
-- 
2.17.1

