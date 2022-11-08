Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915DA620BEC
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 10:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbiKHJQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 04:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233723AbiKHJQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 04:16:44 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDE92FC19;
        Tue,  8 Nov 2022 01:16:42 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N62SY417RzpWKY;
        Tue,  8 Nov 2022 17:13:01 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 17:16:40 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <stefanha@redhat.com>, <sgarzare@redhat.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <davem@davemloft.net>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH] vhost/vsock: Fix error handling in vhost_vsock_init()
Date:   Tue, 8 Nov 2022 09:13:57 +0000
Message-ID: <20221108091357.115738-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A problem about modprobe vhost_vsock failed is triggered with the
following log given:

modprobe: ERROR: could not insert 'vhost_vsock': Device or resource busy

The reason is that vhost_vsock_init() returns misc_register() directly
without checking its return value, if misc_register() failed, it returns
without calling vsock_core_unregister() on vhost_transport, resulting the
vhost_vsock can never be installed later.
A simple call graph is shown as below:

 vhost_vsock_init()
   vsock_core_register() # register vhost_transport
   misc_register()
     device_create_with_groups()
       device_create_groups_vargs()
         dev = kzalloc(...) # OOM happened
   # return without unregister vhost_transport

Fix by calling vsock_core_unregister() when misc_register() returns error.

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Signed-off-by: Yuan Can <yuancan@huawei.com>
---
 drivers/vhost/vsock.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 5703775af129..10a7d23731fe 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -959,7 +959,14 @@ static int __init vhost_vsock_init(void)
 				  VSOCK_TRANSPORT_F_H2G);
 	if (ret < 0)
 		return ret;
-	return misc_register(&vhost_vsock_misc);
+
+	ret = misc_register(&vhost_vsock_misc);
+	if (ret) {
+		vsock_core_unregister(&vhost_transport.transport);
+		return ret;
+	}
+
+	return 0;
 };
 
 static void __exit vhost_vsock_exit(void)
-- 
2.17.1

