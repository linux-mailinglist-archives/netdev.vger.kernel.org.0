Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3834DD362
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 04:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbiCRDBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 23:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiCRDBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 23:01:02 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372EFF47E5;
        Thu, 17 Mar 2022 19:59:44 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KKTGY3CHmzfYvL;
        Fri, 18 Mar 2022 10:58:13 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Mar 2022 10:59:42 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <borisp@nvidia.com>, <john.fastabend@gmail.com>,
        <daniel@iogearbox.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 2/2] net/tls: optimize judgement processes in tls_set_device_offload()
Date:   Fri, 18 Mar 2022 11:17:26 +0800
Message-ID: <7515ae5d1e5d3f2358e7e5423647ce6cbef4c595.1647572976.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1647572976.git.william.xuanziyang@huawei.com>
References: <cover.1647572976.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        TVD_PH_BODY_ACCOUNTS_PRE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is known that priority setting HW offload when set tls TX/RX offload
by setsockopt(). Check netdevice whether support NETIF_F_HW_TLS_TX or
not at the later stages in the whole tls_set_device_offload() process,
some memory allocations have been done before that. We must release those
memory and return error if we judge the netdevice not support
NETIF_F_HW_TLS_TX. It is redundant.

Move NETIF_F_HW_TLS_TX judgement forward, and move start_marker_record
and offload_ctx memory allocation back slightly. Thus, we can get
simpler exception handling process.

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/tls/tls_device.c | 63 ++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index b932469ee69c..592199b8dd19 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1028,20 +1028,21 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	if (ctx->priv_ctx_tx)
 		return -EEXIST;
 
-	start_marker_record = kmalloc(sizeof(*start_marker_record), GFP_KERNEL);
-	if (!start_marker_record)
-		return -ENOMEM;
+	netdev = get_netdev_for_sock(sk);
+	if (!netdev) {
+		pr_err_ratelimited("%s: netdev not found\n", __func__);
+		return -EINVAL;
+	}
 
-	offload_ctx = kzalloc(TLS_OFFLOAD_CONTEXT_SIZE_TX, GFP_KERNEL);
-	if (!offload_ctx) {
-		rc = -ENOMEM;
-		goto free_marker_record;
+	if (!(netdev->features & NETIF_F_HW_TLS_TX)) {
+		rc = -EOPNOTSUPP;
+		goto release_netdev;
 	}
 
 	crypto_info = &ctx->crypto_send.info;
 	if (crypto_info->version != TLS_1_2_VERSION) {
 		rc = -EOPNOTSUPP;
-		goto free_offload_ctx;
+		goto release_netdev;
 	}
 
 	switch (crypto_info->cipher_type) {
@@ -1057,13 +1058,13 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 		break;
 	default:
 		rc = -EINVAL;
-		goto free_offload_ctx;
+		goto release_netdev;
 	}
 
 	/* Sanity-check the rec_seq_size for stack allocations */
 	if (rec_seq_size > TLS_MAX_REC_SEQ_SIZE) {
 		rc = -EINVAL;
-		goto free_offload_ctx;
+		goto release_netdev;
 	}
 
 	prot->version = crypto_info->version;
@@ -1077,7 +1078,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 			     GFP_KERNEL);
 	if (!ctx->tx.iv) {
 		rc = -ENOMEM;
-		goto free_offload_ctx;
+		goto release_netdev;
 	}
 
 	memcpy(ctx->tx.iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE, iv, iv_size);
@@ -1089,9 +1090,21 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 		goto free_iv;
 	}
 
+	start_marker_record = kmalloc(sizeof(*start_marker_record), GFP_KERNEL);
+	if (!start_marker_record) {
+		rc = -ENOMEM;
+		goto free_rec_seq;
+	}
+
+	offload_ctx = kzalloc(TLS_OFFLOAD_CONTEXT_SIZE_TX, GFP_KERNEL);
+	if (!offload_ctx) {
+		rc = -ENOMEM;
+		goto free_marker_record;
+	}
+
 	rc = tls_sw_fallback_init(sk, offload_ctx, crypto_info);
 	if (rc)
-		goto free_rec_seq;
+		goto free_offload_ctx;
 
 	/* start at rec_seq - 1 to account for the start marker record */
 	memcpy(&rcd_sn, ctx->tx.rec_seq, sizeof(rcd_sn));
@@ -1118,18 +1131,6 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	if (skb)
 		TCP_SKB_CB(skb)->eor = 1;
 
-	netdev = get_netdev_for_sock(sk);
-	if (!netdev) {
-		pr_err_ratelimited("%s: netdev not found\n", __func__);
-		rc = -EINVAL;
-		goto disable_cad;
-	}
-
-	if (!(netdev->features & NETIF_F_HW_TLS_TX)) {
-		rc = -EOPNOTSUPP;
-		goto release_netdev;
-	}
-
 	/* Avoid offloading if the device is down
 	 * We don't want to offload new flows after
 	 * the NETDEV_DOWN event
@@ -1167,20 +1168,20 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 
 release_lock:
 	up_read(&device_offload_lock);
-release_netdev:
-	dev_put(netdev);
-disable_cad:
 	clean_acked_data_disable(inet_csk(sk));
 	crypto_free_aead(offload_ctx->aead_send);
-free_rec_seq:
-	kfree(ctx->tx.rec_seq);
-free_iv:
-	kfree(ctx->tx.iv);
 free_offload_ctx:
 	kfree(offload_ctx);
 	ctx->priv_ctx_tx = NULL;
 free_marker_record:
 	kfree(start_marker_record);
+free_rec_seq:
+	kfree(ctx->tx.rec_seq);
+free_iv:
+	kfree(ctx->tx.iv);
+release_netdev:
+	dev_put(netdev);
+
 	return rc;
 }
 
-- 
2.25.1

