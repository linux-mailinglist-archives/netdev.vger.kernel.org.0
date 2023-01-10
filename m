Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB16663963
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjAJGfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjAJGfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:35:14 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39DA12AA7;
        Mon,  9 Jan 2023 22:35:10 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Nrgxm4C91zJrFC;
        Tue, 10 Jan 2023 14:33:48 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 10 Jan
 2023 14:35:04 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-bluetooth@vger.kernel.org>, <netdev@vger.kernel.org>,
        <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <brian.gix@intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH v2] Bluetooth: hci_sync: fix memory leak in hci_update_adv_data()
Date:   Tue, 10 Jan 2023 14:44:20 +0800
Message-ID: <20230110064420.3409168-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When hci_cmd_sync_queue() failed in hci_update_adv_data(), inst_ptr is
not freed, which will cause memory leak. ERR_PTR/PTR_ERR is used to
replace memory allocation to simplify code.

Fixes: 651cd3d65b0f ("Bluetooth: convert hci_update_adv_data to hci_sync")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
v2: Use ERR_PTR/PTR_ERR to replace memory allocation
---
 net/bluetooth/hci_sync.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 9e2d7e4b850c..8744bbecac9e 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6187,20 +6187,14 @@ int hci_get_random_address(struct hci_dev *hdev, bool require_privacy,
 
 static int _update_adv_data_sync(struct hci_dev *hdev, void *data)
 {
-	u8 instance = *(u8 *)data;
-
-	kfree(data);
+	u8 instance = PTR_ERR(data);
 
 	return hci_update_adv_data_sync(hdev, instance);
 }
 
 int hci_update_adv_data(struct hci_dev *hdev, u8 instance)
 {
-	u8 *inst_ptr = kmalloc(1, GFP_KERNEL);
-
-	if (!inst_ptr)
-		return -ENOMEM;
+	u8 *inst_ptr = ERR_PTR(instance);
 
-	*inst_ptr = instance;
 	return hci_cmd_sync_queue(hdev, _update_adv_data_sync, inst_ptr, NULL);
 }
-- 
2.34.1

