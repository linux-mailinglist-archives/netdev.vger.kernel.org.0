Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C771B4861EA
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237290AbiAFJOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:14:08 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:37818 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237259AbiAFJOD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 04:14:03 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2002820654;
        Thu,  6 Jan 2022 10:14:01 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5bei8ONxgpQC; Thu,  6 Jan 2022 10:13:59 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B657B20646;
        Thu,  6 Jan 2022 10:13:58 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id A6C1E80004A;
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
        id 7BA1C3183042; Thu,  6 Jan 2022 10:13:54 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 6/7] xfrm: Add support for SM4 symmetric cipher algorithm
Date:   Thu, 6 Jan 2022 10:13:49 +0100
Message-ID: <20220106091350.3038869-7-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220106091350.3038869-1-steffen.klassert@secunet.com>
References: <20220106091350.3038869-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Jia <xujia39@huawei.com>

This patch adds SM4 encryption algorithm entry to ealg_list.

Signed-off-by: Xu Jia <xujia39@huawei.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/uapi/linux/pfkeyv2.h |  1 +
 net/xfrm/xfrm_algo.c         | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/uapi/linux/pfkeyv2.h b/include/uapi/linux/pfkeyv2.h
index 798ba9ffd48c..8abae1f6749c 100644
--- a/include/uapi/linux/pfkeyv2.h
+++ b/include/uapi/linux/pfkeyv2.h
@@ -330,6 +330,7 @@ struct sadb_x_filter {
 #define SADB_X_EALG_AES_GCM_ICV16	20
 #define SADB_X_EALG_CAMELLIACBC		22
 #define SADB_X_EALG_NULL_AES_GMAC	23
+#define SADB_X_EALG_SM4CBC		24
 #define SADB_EALG_MAX                   253 /* last EALG */
 /* private allocations should use 249-255 (RFC2407) */
 #define SADB_X_EALG_SERPENTCBC  252     /* draft-ietf-ipsec-ciph-aes-cbc-00 */
diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index 00b5444a4d86..094734fbec96 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -572,6 +572,27 @@ static struct xfrm_algo_desc ealg_list[] = {
 		.sadb_alg_maxbits = 288
 	}
 },
+{
+	.name = "cbc(sm4)",
+	.compat = "sm4",
+
+	.uinfo = {
+		.encr = {
+			.geniv = "echainiv",
+			.blockbits = 128,
+			.defkeybits = 128,
+		}
+	},
+
+	.pfkey_supported = 1,
+
+	.desc = {
+		.sadb_alg_id = SADB_X_EALG_SM4CBC,
+		.sadb_alg_ivlen	= 16,
+		.sadb_alg_minbits = 128,
+		.sadb_alg_maxbits = 256
+	}
+},
 };
 
 static struct xfrm_algo_desc calg_list[] = {
-- 
2.25.1

