Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC8847CE85
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 09:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243514AbhLVI4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 03:56:33 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:30161 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243502AbhLVI4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 03:56:32 -0500
Received: from kwepemi500004.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JJnDy442gz8vxL;
        Wed, 22 Dec 2021 16:54:10 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi500004.china.huawei.com (7.221.188.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 16:56:30 +0800
Received: from compute.localdomain (10.175.112.70) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 16:56:30 +0800
From:   Xu Jia <xujia39@huawei.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH net-next 1/2] xfrm: Add support for SM3 secure hash
Date:   Wed, 22 Dec 2021 17:06:58 +0800
Message-ID: <1640164019-42341-2-git-send-email-xujia39@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1640164019-42341-1-git-send-email-xujia39@huawei.com>
References: <1640164019-42341-1-git-send-email-xujia39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows IPsec to use SM3 HMAC authentication algorithm.

Signed-off-by: Xu Jia <xujia39@huawei.com>
---
 include/uapi/linux/pfkeyv2.h |  1 +
 net/xfrm/xfrm_algo.c         | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/uapi/linux/pfkeyv2.h b/include/uapi/linux/pfkeyv2.h
index d65b117..798ba9f 100644
--- a/include/uapi/linux/pfkeyv2.h
+++ b/include/uapi/linux/pfkeyv2.h
@@ -309,6 +309,7 @@ struct sadb_x_filter {
 #define SADB_X_AALG_SHA2_512HMAC	7
 #define SADB_X_AALG_RIPEMD160HMAC	8
 #define SADB_X_AALG_AES_XCBC_MAC	9
+#define SADB_X_AALG_SM3_256HMAC		10
 #define SADB_X_AALG_NULL		251	/* kame */
 #define SADB_AALG_MAX			251
 
diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index 4dae3ab..00b5444 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -341,6 +341,26 @@
 
 	.pfkey_supported = 0,
 },
+{
+	.name = "hmac(sm3)",
+	.compat = "sm3",
+
+	.uinfo = {
+		.auth = {
+			.icv_truncbits = 256,
+			.icv_fullbits = 256,
+		}
+	},
+
+	.pfkey_supported = 1,
+
+	.desc = {
+		.sadb_alg_id = SADB_X_AALG_SM3_256HMAC,
+		.sadb_alg_ivlen = 0,
+		.sadb_alg_minbits = 256,
+		.sadb_alg_maxbits = 256
+	}
+},
 };
 
 static struct xfrm_algo_desc ealg_list[] = {
-- 
1.8.3.1

