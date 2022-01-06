Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BAE4861E8
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237284AbiAFJOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:14:06 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:37810 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237200AbiAFJOB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 04:14:01 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A0E4F2063E;
        Thu,  6 Jan 2022 10:13:59 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CcdrNAFpKcbm; Thu,  6 Jan 2022 10:13:59 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 68DB72065D;
        Thu,  6 Jan 2022 10:13:58 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 574D480004A;
        Thu,  6 Jan 2022 10:13:58 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 6 Jan 2022 10:13:58 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 6 Jan
 2022 10:13:57 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 774EA3183032; Thu,  6 Jan 2022 10:13:54 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 5/7] xfrm: Add support for SM3 secure hash
Date:   Thu, 6 Jan 2022 10:13:48 +0100
Message-ID: <20220106091350.3038869-6-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220106091350.3038869-1-steffen.klassert@secunet.com>
References: <20220106091350.3038869-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Jia <xujia39@huawei.com>

This patch allows IPsec to use SM3 HMAC authentication algorithm.

Signed-off-by: Xu Jia <xujia39@huawei.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/uapi/linux/pfkeyv2.h |  1 +
 net/xfrm/xfrm_algo.c         | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/uapi/linux/pfkeyv2.h b/include/uapi/linux/pfkeyv2.h
index d65b11785260..798ba9ffd48c 100644
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
index 4dae3ab8d030..00b5444a4d86 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -341,6 +341,26 @@ static struct xfrm_algo_desc aalg_list[] = {
 
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
2.25.1

