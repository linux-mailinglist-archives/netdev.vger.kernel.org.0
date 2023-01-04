Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00FE65CD2E
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 07:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbjADGhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 01:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbjADGhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 01:37:01 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF16BF6C;
        Tue,  3 Jan 2023 22:37:00 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Nn0GP5F6gzRqmh;
        Wed,  4 Jan 2023 14:35:25 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 4 Jan
 2023 14:36:56 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-bluetooth@vger.kernel.org>, <netdev@vger.kernel.org>,
        <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH] Bluetooth: hci_conn: fix memory leak in hci_le_terminate_big() and hci_le_big_terminate()
Date:   Wed, 4 Jan 2023 14:46:23 +0800
Message-ID: <20230104064623.1140644-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When hci_cmd_sync_queue() failed in hci_le_terminate_big() or
hci_le_big_terminate(), the memory pointed by variable d is not freed,
which will cause memory leak. Add release process to error path.

Fixes: eca0ae4aea66 ("Bluetooth: Add initial implementation of BIS connections")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/bluetooth/hci_conn.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index d3e542c2fc3e..acf563fbdfd9 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -821,6 +821,7 @@ static void terminate_big_destroy(struct hci_dev *hdev, void *data, int err)
 static int hci_le_terminate_big(struct hci_dev *hdev, u8 big, u8 bis)
 {
 	struct iso_list_data *d;
+	int ret;
 
 	bt_dev_dbg(hdev, "big 0x%2.2x bis 0x%2.2x", big, bis);
 
@@ -831,8 +832,12 @@ static int hci_le_terminate_big(struct hci_dev *hdev, u8 big, u8 bis)
 	d->big = big;
 	d->bis = bis;
 
-	return hci_cmd_sync_queue(hdev, terminate_big_sync, d,
-				  terminate_big_destroy);
+	ret = hci_cmd_sync_queue(hdev, terminate_big_sync, d,
+				 terminate_big_destroy);
+	if (ret)
+		kfree(d);
+
+	return ret;
 }
 
 static int big_terminate_sync(struct hci_dev *hdev, void *data)
@@ -857,6 +862,7 @@ static int big_terminate_sync(struct hci_dev *hdev, void *data)
 static int hci_le_big_terminate(struct hci_dev *hdev, u8 big, u16 sync_handle)
 {
 	struct iso_list_data *d;
+	int ret;
 
 	bt_dev_dbg(hdev, "big 0x%2.2x sync_handle 0x%4.4x", big, sync_handle);
 
@@ -867,8 +873,12 @@ static int hci_le_big_terminate(struct hci_dev *hdev, u8 big, u16 sync_handle)
 	d->big = big;
 	d->sync_handle = sync_handle;
 
-	return hci_cmd_sync_queue(hdev, big_terminate_sync, d,
-				  terminate_big_destroy);
+	ret = hci_cmd_sync_queue(hdev, big_terminate_sync, d,
+				 terminate_big_destroy);
+	if (ret)
+		kfree(d);
+
+	return ret;
 }
 
 /* Cleanup BIS connection
-- 
2.34.1

