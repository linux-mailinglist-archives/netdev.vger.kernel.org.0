Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1B86CBB10
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbjC1JbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbjC1Jap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:30:45 -0400
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2ABD76B7;
        Tue, 28 Mar 2023 02:29:25 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VeseIEJ_1679995744;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VeseIEJ_1679995744)
          by smtp.aliyun-inc.com;
          Tue, 28 Mar 2023 17:29:04 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH 15/16] virtio_net: add APIs to register/unregister virtio driver
Date:   Tue, 28 Mar 2023 17:28:46 +0800
Message-Id: <20230328092847.91643-16-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
References: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: e880b402863c
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is prepare for separating vortio-related funcs.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/virtnet.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio/virtnet.c b/drivers/net/virtio/virtnet.c
index 75a74864c3fe..02989cace0fb 100644
--- a/drivers/net/virtio/virtnet.c
+++ b/drivers/net/virtio/virtnet.c
@@ -3146,6 +3146,16 @@ static struct virtio_driver virtio_net_driver = {
 #endif
 };
 
+int virtnet_register_virtio_driver(void)
+{
+	return register_virtio_driver(&virtio_net_driver);
+}
+
+void virtnet_unregister_virtio_driver(void)
+{
+	unregister_virtio_driver(&virtio_net_driver);
+}
+
 static __init int virtio_net_driver_init(void)
 {
 	int ret;
@@ -3154,7 +3164,7 @@ static __init int virtio_net_driver_init(void)
 	if (ret)
 		return ret;
 
-	ret = register_virtio_driver(&virtio_net_driver);
+	ret = virtnet_register_virtio_driver();
 	if (ret) {
 		virtnet_cpuhp_remove();
 		return ret;
@@ -3166,7 +3176,7 @@ module_init(virtio_net_driver_init);
 
 static __exit void virtio_net_driver_exit(void)
 {
-	unregister_virtio_driver(&virtio_net_driver);
+	virtnet_unregister_virtio_driver();
 	virtnet_cpuhp_remove();
 }
 module_exit(virtio_net_driver_exit);
-- 
2.32.0.3.g01195cf9f

