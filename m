Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0AC8661BDA
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 02:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbjAIBRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 20:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233682AbjAIBRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 20:17:37 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC08BEA;
        Sun,  8 Jan 2023 17:17:35 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NqwxY5RdGznVHt;
        Mon,  9 Jan 2023 09:16:01 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 9 Jan
 2023 09:17:33 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-bluetooth@vger.kernel.org>, <netdev@vger.kernel.org>,
        <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <brian.gix@intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH] Bluetooth: hci_sync: fix memory leak in hci_update_adv_data()
Date:   Mon, 9 Jan 2023 09:26:51 +0800
Message-ID: <20230109012651.3127529-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
not freed, which will cause memory leak. Add release process to error
path.

Fixes: 651cd3d65b0f ("Bluetooth: convert hci_update_adv_data to hci_sync")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/bluetooth/hci_sync.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 9e2d7e4b850c..1485501bd72f 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6197,10 +6197,15 @@ static int _update_adv_data_sync(struct hci_dev *hdev, void *data)
 int hci_update_adv_data(struct hci_dev *hdev, u8 instance)
 {
 	u8 *inst_ptr = kmalloc(1, GFP_KERNEL);
+	int ret;
 
 	if (!inst_ptr)
 		return -ENOMEM;
 
 	*inst_ptr = instance;
-	return hci_cmd_sync_queue(hdev, _update_adv_data_sync, inst_ptr, NULL);
+	ret = hci_cmd_sync_queue(hdev, _update_adv_data_sync, inst_ptr, NULL);
+	if (ret)
+		kfree(inst_ptr);
+
+	return ret;
 }
-- 
2.34.1

