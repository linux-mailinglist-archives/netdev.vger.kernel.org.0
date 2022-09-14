Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5C25B84A8
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiINJPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbiINJOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:14:04 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2065.outbound.protection.outlook.com [40.107.95.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31D27D1C0
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 02:06:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzV9yLQEz7lllYeJiQ8+MRJKwk1IrYx+zjnhmoF/z3Y2flv/thR6uvpxWnRS8Zu+X+LO/jwUt6KuPVajhWmPXuo9GDoD7cwTpnOPcIIXdpSBOsLkQPRFOauXd/0tZvxrJGwn9IDxBe4qkIy9pck1fKo8jbTN2khZc8QhNaxUKRJ9KCSjnvlD2znsafftdFPXn6n429cbYImSbiQ8aUQ/Xh4XkiKzPayid/wKy5iCEzD5520caNK0QW5X4HbGdudDqLTze++bnQzhOJkF6lTCpO5lo01J02XBELMZNWDY48m2dxHkC+4T/WciRrYSQ/eVgHtpF8/5qgZ+YPO23OUFgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7QgimevCk1emTKc7ncNDRX5E56rS7lnE7KLcn5Brgfs=;
 b=Jc8Q9HWObCu9zM5jxtEC3V4VWYIMdNAinxaLyF4P+57LNQK5KFxoSl2nKliaGCGUA2Yr22EhYERIk2BolSqRZJrBdjQ2wpmFJzRvE6H5mXfZyUER4ztaTf/n92nvrVUiTuba5MfPgehkZRC+tPQ3GzqtmvZ71DvFSu5CnzYSwF9Z1tSV9fFG0oern6R1reJ6wLU+mOAKQrQoqQon0ROQAOdV2PAG0l7xfkKB3Zk/IF9I12mcjeRJN68Pe/FtqZ8DU6kLUbCCRb3GVYrhV5dg/3+v0RHalytwg06PxyrtmCqXeGDwOngGMfBgP+28wuSTHLBKu40Zi5syeaXPK2cO2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QgimevCk1emTKc7ncNDRX5E56rS7lnE7KLcn5Brgfs=;
 b=m/7TWv0TRahO7qhiM5gv8qXZBBGLMDVv1sMif/mqn430qRJF5gt+uQtqREzVUJDzA5TYizGvPrSOiRpdfnWgstC6Y53wTUNszsY6kqika6iS8pd2bUs0EJ/E9I9DGsJ89ZasX+NkylRHmVMMhrtrPAgiOY+8iCp+WkLj032ej4ZwGDKi+OUgtHqPiZaTEFJ912UEkbPkZ8EPmzlFGHzD78GD7P2DElCETT9N5u7jzrzZgzPARAaADDkEiuqFbF0/Qqnlzh5aBocnj9OEsXuJTKhjOlTpnbLpp3Yc0fH4Ci5ud6I7rPUD+FGIXHnEYG2hCF3W0n2xWXQAx+sgvgfFZA==
Received: from BN0PR02CA0012.namprd02.prod.outlook.com (2603:10b6:408:e4::17)
 by SA0PR12MB4398.namprd12.prod.outlook.com (2603:10b6:806:9f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 14 Sep
 2022 09:05:46 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e4:cafe::42) by BN0PR02CA0012.outlook.office365.com
 (2603:10b6:408:e4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.14 via Frontend
 Transport; Wed, 14 Sep 2022 09:05:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 09:05:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 14 Sep
 2022 02:05:30 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 14 Sep 2022 02:05:30 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 14 Sep 2022 02:05:29 -0700
Received: from vdi.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Wed, 14 Sep 2022 02:05:27 -0700
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next 2/4] net/tls: Use cipher sizes structs
Date:   Wed, 14 Sep 2022 12:05:18 +0300
Message-ID: <20220914090520.4170-3-gal@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220914090520.4170-1-gal@nvidia.com>
References: <20220914090520.4170-1-gal@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT044:EE_|SA0PR12MB4398:EE_
X-MS-Office365-Filtering-Correlation-Id: 745b1ca4-809d-4c8b-2e0c-08da96304f3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pqR2NkYi+o8o3/DN0uqpjyUhQJRIAmemr8fgj24JfExmnnmag32r8ruxeBzp/KUAOJpFdLak6gPzqg0foYEQsHXIOSdy/hQ1VMdd2NRMOLssNwAi/8y9rPvnKm34Rq/91gWlZfANjOQCxDMHMT8oS2Nf5AzokZrkNrpN1YNFkOHyeeUeViH+rKHXHVGZHGNR/rPDiDV4BWyEegz5TbqlV+WhbqhSzY00MweUkl5lvOdfRSMfLkVqJ59ac8LRHk4Kfx3xrG1i/A1E/wmMwcgD4Mk9IqHf5NI7j/io797SO0j5MeS9T5pmTmq4BfEODKI14iEHaNxe9vtAlFsD9hsbMfAlU0YwU+eRtaYNJHKiuPTXt7eChsRQdcaPBidMpoai/iRKij/ndw94CghEwX7Qd4gVcHzP2fEhavZ8fbcX2K7csT24Kx/OZ62GSRzP/ikrDfMYcy6uafSoIlYMZ6UX2XknkQ1S9mbSwrOlls7W9+QqobrohuGglO47EFxbBuVNMPLr5wgz/JD1TOUHLnOVnOik8V5zI9b1LEHTD3I6Oq0ZCLSxAn4CmHQ1/l4/AopfOhBZk65eb8BqxsrPyAaXsh7E3fBJuAOQlx7YwuHv6UkCwTwgKrIw6rAjwiKBYXWAEjvipT6C/6NZJOv5MhVfUdYO7i/QQOANUj6eQ2unH/wNV8sOGnf2bGvaaLc3gvDEoQpSGP3i0NvR2vzlHqXW0KKnCTVDo97xU07fQVrKjG1bmhqfJfgtSb7Fd+KEDuEVbQnqELJTp1NXy9hh/mwC4A==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(356005)(2616005)(1076003)(110136005)(30864003)(316002)(36756003)(47076005)(4326008)(54906003)(186003)(426003)(82740400003)(83380400001)(40480700001)(7636003)(6666004)(7696005)(40460700003)(2906002)(41300700001)(70206006)(478600001)(26005)(336012)(70586007)(8676002)(107886003)(82310400005)(8936002)(36860700001)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 09:05:45.6190
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 745b1ca4-809d-4c8b-2e0c-08da96304f3b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4398
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the newly introduced cipher sizes structs instead of the repeated
switch cases churn.

Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 net/tls/tls_device.c          | 55 +++++++++++++-------------
 net/tls/tls_device_fallback.c | 72 +++++++++++++++++++++++------------
 2 files changed, 76 insertions(+), 51 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 0f983e5f7dde..3f8121b8125c 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -902,17 +902,27 @@ static void tls_device_core_ctrl_rx_resync(struct tls_context *tls_ctx,
 }
 
 static int
-tls_device_reencrypt(struct sock *sk, struct tls_sw_context_rx *sw_ctx)
+tls_device_reencrypt(struct sock *sk, struct tls_context *tls_ctx)
 {
+	struct tls_sw_context_rx *sw_ctx = tls_sw_ctx_rx(tls_ctx);
+	const struct tls_cipher_size_desc *cipher_sz;
 	int err, offset, copy, data_len, pos;
 	struct sk_buff *skb, *skb_iter;
 	struct scatterlist sg[1];
 	struct strp_msg *rxm;
 	char *orig_buf, *buf;
 
+	switch (tls_ctx->crypto_recv.info.cipher_type) {
+	case TLS_CIPHER_AES_GCM_128:
+		break;
+	default:
+		return -EINVAL;
+	}
+	cipher_sz = &tls_cipher_size_desc[tls_ctx->crypto_recv.info.cipher_type];
+
 	rxm = strp_msg(tls_strp_msg(sw_ctx));
-	orig_buf = kmalloc(rxm->full_len + TLS_HEADER_SIZE +
-			   TLS_CIPHER_AES_GCM_128_IV_SIZE, sk->sk_allocation);
+	orig_buf = kmalloc(rxm->full_len + TLS_HEADER_SIZE + cipher_sz->iv,
+			   sk->sk_allocation);
 	if (!orig_buf)
 		return -ENOMEM;
 	buf = orig_buf;
@@ -927,10 +937,8 @@ tls_device_reencrypt(struct sock *sk, struct tls_sw_context_rx *sw_ctx)
 
 	sg_init_table(sg, 1);
 	sg_set_buf(&sg[0], buf,
-		   rxm->full_len + TLS_HEADER_SIZE +
-		   TLS_CIPHER_AES_GCM_128_IV_SIZE);
-	err = skb_copy_bits(skb, offset, buf,
-			    TLS_HEADER_SIZE + TLS_CIPHER_AES_GCM_128_IV_SIZE);
+		   rxm->full_len + TLS_HEADER_SIZE + cipher_sz->iv);
+	err = skb_copy_bits(skb, offset, buf, TLS_HEADER_SIZE + cipher_sz->iv);
 	if (err)
 		goto free_buf;
 
@@ -941,7 +949,7 @@ tls_device_reencrypt(struct sock *sk, struct tls_sw_context_rx *sw_ctx)
 	else
 		err = 0;
 
-	data_len = rxm->full_len - TLS_CIPHER_AES_GCM_128_TAG_SIZE;
+	data_len = rxm->full_len - cipher_sz->tag;
 
 	if (skb_pagelen(skb) > offset) {
 		copy = min_t(int, skb_pagelen(skb) - offset, data_len);
@@ -1024,7 +1032,7 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx)
 		 * likely have initial fragments decrypted, and final ones not
 		 * decrypted. We need to reencrypt that single SKB.
 		 */
-		return tls_device_reencrypt(sk, sw_ctx);
+		return tls_device_reencrypt(sk, tls_ctx);
 	}
 
 	/* Return immediately if the record is either entirely plaintext or
@@ -1041,7 +1049,7 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx)
 	}
 
 	ctx->resync_nh_reset = 1;
-	return tls_device_reencrypt(sk, sw_ctx);
+	return tls_device_reencrypt(sk, tls_ctx);
 }
 
 static void tls_device_attach(struct tls_context *ctx, struct sock *sk,
@@ -1062,9 +1070,9 @@ static void tls_device_attach(struct tls_context *ctx, struct sock *sk,
 
 int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 {
-	u16 nonce_size, tag_size, iv_size, rec_seq_size, salt_size;
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
+	const struct tls_cipher_size_desc *cipher_sz;
 	struct tls_record_info *start_marker_record;
 	struct tls_offload_context_tx *offload_ctx;
 	struct tls_crypto_info *crypto_info;
@@ -1099,12 +1107,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 
 	switch (crypto_info->cipher_type) {
 	case TLS_CIPHER_AES_GCM_128:
-		nonce_size = TLS_CIPHER_AES_GCM_128_IV_SIZE;
-		tag_size = TLS_CIPHER_AES_GCM_128_TAG_SIZE;
-		iv_size = TLS_CIPHER_AES_GCM_128_IV_SIZE;
 		iv = ((struct tls12_crypto_info_aes_gcm_128 *)crypto_info)->iv;
-		rec_seq_size = TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE;
-		salt_size = TLS_CIPHER_AES_GCM_128_SALT_SIZE;
 		rec_seq =
 		 ((struct tls12_crypto_info_aes_gcm_128 *)crypto_info)->rec_seq;
 		break;
@@ -1112,31 +1115,31 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 		rc = -EINVAL;
 		goto release_netdev;
 	}
+	cipher_sz = &tls_cipher_size_desc[crypto_info->cipher_type];
 
 	/* Sanity-check the rec_seq_size for stack allocations */
-	if (rec_seq_size > TLS_MAX_REC_SEQ_SIZE) {
+	if (cipher_sz->rec_seq > TLS_MAX_REC_SEQ_SIZE) {
 		rc = -EINVAL;
 		goto release_netdev;
 	}
 
 	prot->version = crypto_info->version;
 	prot->cipher_type = crypto_info->cipher_type;
-	prot->prepend_size = TLS_HEADER_SIZE + nonce_size;
-	prot->tag_size = tag_size;
+	prot->prepend_size = TLS_HEADER_SIZE + cipher_sz->iv;
+	prot->tag_size = cipher_sz->tag;
 	prot->overhead_size = prot->prepend_size + prot->tag_size;
-	prot->iv_size = iv_size;
-	prot->salt_size = salt_size;
-	ctx->tx.iv = kmalloc(iv_size + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
-			     GFP_KERNEL);
+	prot->iv_size = cipher_sz->iv;
+	prot->salt_size = cipher_sz->salt;
+	ctx->tx.iv = kmalloc(cipher_sz->iv + cipher_sz->salt, GFP_KERNEL);
 	if (!ctx->tx.iv) {
 		rc = -ENOMEM;
 		goto release_netdev;
 	}
 
-	memcpy(ctx->tx.iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE, iv, iv_size);
+	memcpy(ctx->tx.iv + cipher_sz->salt, iv, cipher_sz->iv);
 
-	prot->rec_seq_size = rec_seq_size;
-	ctx->tx.rec_seq = kmemdup(rec_seq, rec_seq_size, GFP_KERNEL);
+	prot->rec_seq_size = cipher_sz->rec_seq;
+	ctx->tx.rec_seq = kmemdup(rec_seq, cipher_sz->rec_seq, GFP_KERNEL);
 	if (!ctx->tx.rec_seq) {
 		rc = -ENOMEM;
 		goto free_iv;
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index 7dfc8023e0f1..0d2b6518b877 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -54,13 +54,24 @@ static int tls_enc_record(struct aead_request *aead_req,
 			  struct scatter_walk *out, int *in_len,
 			  struct tls_prot_info *prot)
 {
-	unsigned char buf[TLS_HEADER_SIZE + TLS_CIPHER_AES_GCM_128_IV_SIZE];
+	unsigned char buf[TLS_HEADER_SIZE + MAX_IV_SIZE];
+	const struct tls_cipher_size_desc *cipher_sz;
 	struct scatterlist sg_in[3];
 	struct scatterlist sg_out[3];
+	unsigned int buf_size;
 	u16 len;
 	int rc;
 
-	len = min_t(int, *in_len, ARRAY_SIZE(buf));
+	switch (prot->cipher_type) {
+	case TLS_CIPHER_AES_GCM_128:
+		break;
+	default:
+		return -EINVAL;
+	}
+	cipher_sz = &tls_cipher_size_desc[prot->cipher_type];
+
+	buf_size = TLS_HEADER_SIZE + cipher_sz->iv;
+	len = min_t(int, *in_len, buf_size);
 
 	scatterwalk_copychunks(buf, in, len, 0);
 	scatterwalk_copychunks(buf, out, len, 1);
@@ -73,13 +84,11 @@ static int tls_enc_record(struct aead_request *aead_req,
 	scatterwalk_pagedone(out, 1, 1);
 
 	len = buf[4] | (buf[3] << 8);
-	len -= TLS_CIPHER_AES_GCM_128_IV_SIZE;
+	len -= cipher_sz->iv;
 
-	tls_make_aad(aad, len - TLS_CIPHER_AES_GCM_128_TAG_SIZE,
-		(char *)&rcd_sn, buf[0], prot);
+	tls_make_aad(aad, len - cipher_sz->tag, (char *)&rcd_sn, buf[0], prot);
 
-	memcpy(iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE, buf + TLS_HEADER_SIZE,
-	       TLS_CIPHER_AES_GCM_128_IV_SIZE);
+	memcpy(iv + cipher_sz->salt, buf + TLS_HEADER_SIZE, cipher_sz->iv);
 
 	sg_init_table(sg_in, ARRAY_SIZE(sg_in));
 	sg_init_table(sg_out, ARRAY_SIZE(sg_out));
@@ -90,7 +99,7 @@ static int tls_enc_record(struct aead_request *aead_req,
 
 	*in_len -= len;
 	if (*in_len < 0) {
-		*in_len += TLS_CIPHER_AES_GCM_128_TAG_SIZE;
+		*in_len += cipher_sz->tag;
 		/* the input buffer doesn't contain the entire record.
 		 * trim len accordingly. The resulting authentication tag
 		 * will contain garbage, but we don't care, so we won't
@@ -111,7 +120,7 @@ static int tls_enc_record(struct aead_request *aead_req,
 		scatterwalk_pagedone(out, 1, 1);
 	}
 
-	len -= TLS_CIPHER_AES_GCM_128_TAG_SIZE;
+	len -= cipher_sz->tag;
 	aead_request_set_crypt(aead_req, sg_in, sg_out, len, iv);
 
 	rc = crypto_aead_encrypt(aead_req);
@@ -299,11 +308,14 @@ static void fill_sg_out(struct scatterlist sg_out[3], void *buf,
 			int sync_size,
 			void *dummy_buf)
 {
+	const struct tls_cipher_size_desc *cipher_sz =
+		&tls_cipher_size_desc[tls_ctx->crypto_send.info.cipher_type];
+
 	sg_set_buf(&sg_out[0], dummy_buf, sync_size);
 	sg_set_buf(&sg_out[1], nskb->data + tcp_payload_offset, payload_len);
 	/* Add room for authentication tag produced by crypto */
 	dummy_buf += sync_size;
-	sg_set_buf(&sg_out[2], dummy_buf, TLS_CIPHER_AES_GCM_128_TAG_SIZE);
+	sg_set_buf(&sg_out[2], dummy_buf, cipher_sz->tag);
 }
 
 static struct sk_buff *tls_enc_skb(struct tls_context *tls_ctx,
@@ -315,7 +327,8 @@ static struct sk_buff *tls_enc_skb(struct tls_context *tls_ctx,
 	struct tls_offload_context_tx *ctx = tls_offload_ctx_tx(tls_ctx);
 	int tcp_payload_offset = skb_tcp_all_headers(skb);
 	int payload_len = skb->len - tcp_payload_offset;
-	void *buf, *iv, *aad, *dummy_buf;
+	const struct tls_cipher_size_desc *cipher_sz;
+	void *buf, *iv, *aad, *dummy_buf, *salt;
 	struct aead_request *aead_req;
 	struct sk_buff *nskb = NULL;
 	int buf_len;
@@ -324,20 +337,23 @@ static struct sk_buff *tls_enc_skb(struct tls_context *tls_ctx,
 	if (!aead_req)
 		return NULL;
 
-	buf_len = TLS_CIPHER_AES_GCM_128_SALT_SIZE +
-		  TLS_CIPHER_AES_GCM_128_IV_SIZE +
-		  TLS_AAD_SPACE_SIZE +
-		  sync_size +
-		  TLS_CIPHER_AES_GCM_128_TAG_SIZE;
+	switch (tls_ctx->crypto_send.info.cipher_type) {
+	case TLS_CIPHER_AES_GCM_128:
+		salt = tls_ctx->crypto_send.aes_gcm_128.salt;
+		break;
+	default:
+		return NULL;
+	}
+	cipher_sz = &tls_cipher_size_desc[tls_ctx->crypto_send.info.cipher_type];
+	buf_len = cipher_sz->salt + cipher_sz->iv + TLS_AAD_SPACE_SIZE +
+		  sync_size + cipher_sz->tag;
 	buf = kmalloc(buf_len, GFP_ATOMIC);
 	if (!buf)
 		goto free_req;
 
 	iv = buf;
-	memcpy(iv, tls_ctx->crypto_send.aes_gcm_128.salt,
-	       TLS_CIPHER_AES_GCM_128_SALT_SIZE);
-	aad = buf + TLS_CIPHER_AES_GCM_128_SALT_SIZE +
-	      TLS_CIPHER_AES_GCM_128_IV_SIZE;
+	memcpy(iv, salt, cipher_sz->salt);
+	aad = buf + cipher_sz->salt + cipher_sz->iv;
 	dummy_buf = aad + TLS_AAD_SPACE_SIZE;
 
 	nskb = alloc_skb(skb_headroom(skb) + skb->len, GFP_ATOMIC);
@@ -451,6 +467,7 @@ int tls_sw_fallback_init(struct sock *sk,
 			 struct tls_offload_context_tx *offload_ctx,
 			 struct tls_crypto_info *crypto_info)
 {
+	const struct tls_cipher_size_desc *cipher_sz;
 	const u8 *key;
 	int rc;
 
@@ -463,15 +480,20 @@ int tls_sw_fallback_init(struct sock *sk,
 		goto err_out;
 	}
 
-	key = ((struct tls12_crypto_info_aes_gcm_128 *)crypto_info)->key;
+	switch (crypto_info->cipher_type) {
+	case TLS_CIPHER_AES_GCM_128:
+		key = ((struct tls12_crypto_info_aes_gcm_128 *)crypto_info)->key;
+		break;
+	default:
+		return -EINVAL;
+	}
+	cipher_sz = &tls_cipher_size_desc[crypto_info->cipher_type];
 
-	rc = crypto_aead_setkey(offload_ctx->aead_send, key,
-				TLS_CIPHER_AES_GCM_128_KEY_SIZE);
+	rc = crypto_aead_setkey(offload_ctx->aead_send, key, cipher_sz->key);
 	if (rc)
 		goto free_aead;
 
-	rc = crypto_aead_setauthsize(offload_ctx->aead_send,
-				     TLS_CIPHER_AES_GCM_128_TAG_SIZE);
+	rc = crypto_aead_setauthsize(offload_ctx->aead_send, cipher_sz->tag);
 	if (rc)
 		goto free_aead;
 
-- 
2.25.1

