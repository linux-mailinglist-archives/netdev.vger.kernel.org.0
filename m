Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3F962D851
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 11:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239362AbiKQKow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 05:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239307AbiKQKos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 05:44:48 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3685B10564;
        Thu, 17 Nov 2022 02:44:45 -0800 (PST)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NCc3q161PzRpG1;
        Thu, 17 Nov 2022 18:44:23 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 18:44:44 +0800
Received: from ubuntu1804.huawei.com (10.67.174.175) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 18:44:43 +0800
From:   Lu Jialin <lujialin4@huawei.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        "Ilya Lesokhin" <ilyal@mellanox.com>
CC:     Lu Jialin <lujialin4@huawei.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH] net/tls: Fix possible UAF in tls_set_device_offload
Date:   Thu, 17 Nov 2022 18:41:32 +0800
Message-ID: <20221117104132.119843-1-lujialin4@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.175]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tls_set_device_offload(), the error path "goto release_lock" will
not remove start_marker_record->list from offload_ctx->records_list,
but start_marker_record will be freed, then list traversal may cause UAF.

This fixes the following smatch warning:

net/tls/tls_device.c:1241 tls_set_device_offload() warn: '&start_marker_record->list' not removed from list

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Lu Jialin <lujialin4@huawei.com>
---
 net/tls/tls_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index a03d66046ca3..2def20870c58 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1234,6 +1234,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	up_read(&device_offload_lock);
 	clean_acked_data_disable(inet_csk(sk));
 	crypto_free_aead(offload_ctx->aead_send);
+	list_del(&start_marker_record->list);
 free_offload_ctx:
 	kfree(offload_ctx);
 	ctx->priv_ctx_tx = NULL;
-- 
2.17.1

