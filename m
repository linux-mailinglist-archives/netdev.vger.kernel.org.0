Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C47640EA7
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 20:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbiLBTny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 14:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiLBTnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 14:43:52 -0500
Received: from CY4PR02CU008-vft-obe.outbound.protection.outlook.com (mail-westcentralusazon11022018.outbound.protection.outlook.com [40.93.200.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43903E03E;
        Fri,  2 Dec 2022 11:43:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+oCIz/d8ALlUSo1QojlY0yh/UBndGiq5yn7GaCE8ZCGc49zCgtmuqp3OxC9nIBPMjcuCvoQSmmHlL12NN/1KJArJW0AoBv6KUB5UWVICl30YzdmMole+Lwf/KnL2QSgjveppck76ikmYzFM0N3VDS5fRPJAjrXJvukg29nJZlcPiImPVq7TXJi5soVualS7qlRfBDiQfS5HytFCnjng/qZuT71nYsCggeOIVEZBMDKg0MwNp8hiUJx/zObkrnn0UIbhNquekMKMub2FcXwCxmJp0bwx0/9WPYtPGZ06fbbW+aivTWur1+bIRzkCNgi4jmv376NgOJMIkC1KQfSMJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZKbNtspwaNKULw43rbPToEfbQh7CcgVkT3h4Pn5rWhQ=;
 b=jd9IYZgIIqSs+lvNsGuaKFDpztCglDSzrefTQlwgqylBUA41RYaIBnr7dlcX9k+4Acodkr7s1FOyicsFkxgLzqXoPTHufhsC0hz+LxjOq0zrnTaD5uXw1QQxWErqoIg4vtqpEcUVUn07pW2zsrQPXK8hCBejKRoAQV3qoX/qEGm1yWX29mngIsSw3SoH0aGAkVgqtNfv1cg1xil+cp+YzIPNfBkzUhQrFXl6h79XaWBby+m6n3YAjK6oUWJdyV0PQb2MWhfwzCkx/UWMpHxYTsk1XCP2m+v1FxLqdlqI3O8QyUto06VT0sUdoYXIHi8Dz9C9Unx5yeQz833ACDO0lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKbNtspwaNKULw43rbPToEfbQh7CcgVkT3h4Pn5rWhQ=;
 b=D3e3Mz2FH8vXYjeNa6dJOC2szQCCYGmE1dyzhtzxAbnWCor62ohomQU//NGaHlqI6OHvg/9dzvsD9Z1oZKZV/ZSjUtY5TxQEBVUMvFEnbnc4sN+8gJRtbiKbHmnm/CrWDq+zcutlKkBS3znTcValbLOKJELzSzrML9ghv+0c3v0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by LV2PR21MB3373.namprd21.prod.outlook.com (2603:10b6:408:14d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8; Fri, 2 Dec
 2022 19:43:49 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::5a1d:844d:e0aa:afb1]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::5a1d:844d:e0aa:afb1%6]) with mapi id 15.20.5901.008; Fri, 2 Dec 2022
 19:43:49 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        sthemmin@microsoft.com, paulros@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH net] net: mana: Fix race on per-CQ variable napi work_done
Date:   Fri,  2 Dec 2022 11:43:10 -0800
Message-Id: <1670010190-28595-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0325.namprd03.prod.outlook.com
 (2603:10b6:303:dd::30) To BY5PR21MB1443.namprd21.prod.outlook.com
 (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|LV2PR21MB3373:EE_
X-MS-Office365-Filtering-Correlation-Id: 344e6bed-edbf-46f5-4cf0-08dad49d878d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 90zRiOvGl6e4Y9t+mB3r4TbaViER52M+PbpYYRdWfbXnBniCbfu3tIEVLyrp8ETXMwoRfA05cBtTHh98XOj5FrrKnKz24QTDObBeJUHxGtROY+dLhAzoF5zW/DpMS9rl51Qsry+4jIFLLcSOFOCsoBmLEKh8cCVRqNcSWVyi1VlzQXRuHYLoxDKJNLxUaCUNyoytudGhtWfeNTUeV7Q1Opn0v+uqJh/ZlQifDDDjHxQu3QkkIp2cc08AzdtnbF83ZD7BZpkJYu53ICMz7/bYt+X05+KH0Mxy6wCiu8Ny+TIzG2Yk4QBvTaH+Z2Mtd80Xwps3nLoZ5vIwf3dTantykXv3WbkLxC1yFhlEfPMQ1AQeSOe344SeOwVzx+rfhpdSm6QjjBU2PjHBWnJUjDxck/jVoi7Dan/nLxUK7OtVTdjPMpcU8DrgbpFxLtvvPEzPI2Pyr2drwdZzkBP6gfHK1OZJRgorUyAAdp65/O+Qzhlv+eIFSdIvJwXYqqjvN2nPNLMyLeNguJr8X5ynVG6tY7M8k4+MB2PFeL+xDPy2cdHeyaFDutzVCwsM+jEXo+/urLIIf4zHIg3Ld5Kp9l2yunhlwS8mNaW7PFzp+/XAesFQ5isGQNcA1+Jwt5vrKGHR3AC+7p9IxwxC1YRkIvKGDpP+qv2sTZdOz7B5j9zPBpa8YNVIlRXJ7p3xclAQImW2beGceuIZkng94TvknqApE9HVx+w67IAOmGB8wjGLK2EgqGsFDl4NUk1JC8Gw1QRR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199015)(82950400001)(82960400001)(38350700002)(38100700002)(36756003)(66946007)(316002)(66556008)(8676002)(4326008)(66476007)(478600001)(6486002)(7846003)(6666004)(52116002)(10290500003)(26005)(6512007)(6506007)(2906002)(83380400001)(2616005)(186003)(41300700001)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IOnB+o9QCZ8VOzG/BCbtIfjk71wgAEYRHrVTjz1bEpDFaKircIfJ2UvedItD?=
 =?us-ascii?Q?ePBZPyQLiWguU1rtSOQpGroWYu8fSewb7RFgjlPGheWRWBKLD+3xFrGUqGKJ?=
 =?us-ascii?Q?2qlhuex1vG8bFo5JC4rYXzlETh0V7Rw96yRd7AGeLcZ5ThCy8NtxUu8t5riF?=
 =?us-ascii?Q?BnmnOynJemn4oV7Tk2tugXCHvJJwdRBnQLmU1PdiCN8KGaT63zx/v7xsBKfK?=
 =?us-ascii?Q?oeGAiL7SdTN29CHOlY3K4Onc0Wbnl1eyNZy8HPiAOSK9KrdkWG+oOVvh/kGl?=
 =?us-ascii?Q?pIqCjHYLUaq5V3o7r1Jvfr4En2NMBJoMT7SIZwp5Qt+ieVhk63TNC6b+2Vwt?=
 =?us-ascii?Q?eIXfpd4Ch2xe4DhvU40OL3EXrTUKRaIpDnnF0y2XRQxz1dmsxeKBQ/HLjuCw?=
 =?us-ascii?Q?DCQSke1V8IaKLv5hVX4INXaEWBNHTjpJA0Ge/xc7eeGbvRaf6kaLt5psbB1L?=
 =?us-ascii?Q?bmek+TAtig/UKFMMnA/8bhF9Ohr5CA7Wfuek0m8XZYMNBdfJNzWwwiQUyufk?=
 =?us-ascii?Q?rHYwOL9KMk+V6w3H29lENnXwa9Minbuy/cy3pQuFL6oW5fEaZ7+s8/HQXYG5?=
 =?us-ascii?Q?nOJsVcLu9Qe4jgTn+lBpbf82srt+UD8GIp4VNoi6oWEuE1ENLyfeIKiDjV3d?=
 =?us-ascii?Q?WEZJiByH9HdV4c6Iuz80KrMbzeONmagRBhubbPeuMhvBRkyS7SBooF2CZt+1?=
 =?us-ascii?Q?VOh952+fsaDLJbZqQlrd7cgHTdBq1NaimYFPU6hEb9OLxcz8eEgE2nNojH4Q?=
 =?us-ascii?Q?dKODqade4bNuaMaP3uQU4r63jTD/ycSoTLbSm1wFdBNACgMulyI6qF4MvmP+?=
 =?us-ascii?Q?LOlnInWKr2hwxkmktc4j27fFGsbmY4/cHpj42i9cG3cc3qrLWb3bFye8Rkgn?=
 =?us-ascii?Q?T79KH3KGH+TAu5FKsKKuZdyeHT4bn9+RRJf+ON5fuS/5rirtxqgchI0uf2Xt?=
 =?us-ascii?Q?cKSDLM1nWQ+pedu4wa/0Kq18XIAKQ4y50x17CtjbXMnPK0riGZz8Wdnpd3f3?=
 =?us-ascii?Q?7ZXvVBAnexSWxr3DYDTRSVOiNAW+faZQDRn7kYGOpW5nKii9Kk7NmMzYabxa?=
 =?us-ascii?Q?9rhw7mJusI7e64RMftDCVENpixEhhLEFxl04cx+t9R59X624ceeo6Js1IMRy?=
 =?us-ascii?Q?FD6IxmbjLJqPtJm9w78jQceK9vbDSpGp1Sy/s9rb+HTDHvTFHrv1jfDtfA+j?=
 =?us-ascii?Q?+NVHFRqgVCMHg+kHCeNFikmb16jJ/zNlv8cuLVeI3iB0PZYFiuW6NqWBLHyB?=
 =?us-ascii?Q?sKjowYpas5gWKqNM9/m8B8h/HTr2Ko53VhufGxOk6+0tHYnnD0HsyOMo6u8o?=
 =?us-ascii?Q?vcO3jJN6w3pzV4DVbLevRXmSyOLVCgiL8J41m69hNSBju9OWc7BISAsu4pK7?=
 =?us-ascii?Q?AY3WAjX5X6anIYcwKp1h+VTsH3vHAY30mr2cMzKU+Mue7/20qgxHw7r0NImq?=
 =?us-ascii?Q?Xb7AUAGp2nonfODaUaHw4ujVAMQ3k58eWd/n3fK4ClCvkNnJ189yLqqVnKCl?=
 =?us-ascii?Q?KshkJigKKSrG9EEL1bPx/XLTml8xeeKnb36D89Gt1E4Ae6dH6S/+razuTxIJ?=
 =?us-ascii?Q?V9WvXzfPRMlrNvmLLvoQHi4F6Ycxdwt9HEE+O3ab?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 344e6bed-edbf-46f5-4cf0-08dad49d878d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 19:43:48.8511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BBLnv5bYI+2tbrFiacQhnLROTYErSvAtaPEnPVkOb4dVQ2rWVF/iF7xY7QcwFPH7utK3Xa/OOTG/G1f0BiPu3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3373
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After calling napi_complete_done(), the NAPIF_STATE_SCHED bit may be
cleared, and another CPU can start napi thread and access per-CQ variable,
cq->work_done. If the other thread (for example, from busy_poll) sets
it to a value >= budget, this thread will continue to run when it should
stop, and cause memory corruption and panic.

To fix this issue, save the per-CQ work_done variable in a local variable
before napi_complete_done(), so it won't be corrupted by a possible
concurrent thread after napi_complete_done().

Also, add a flag bit to advertise to the NIC firmware: the NAPI work_done
variable race is fixed, so the driver is able to reliably support features
like busy_poll.

Cc: stable@vger.kernel.org
Fixes: e1b5683ff62e ("net: mana: Move NAPI from EQ to CQ")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/gdma.h    |  9 ++++++++-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 16 +++++++++++-----
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/drivers/net/ethernet/microsoft/mana/gdma.h
index 4a6efe6ada08..65c24ee49efd 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma.h
+++ b/drivers/net/ethernet/microsoft/mana/gdma.h
@@ -498,7 +498,14 @@ enum {
 
 #define GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT BIT(0)
 
-#define GDMA_DRV_CAP_FLAGS1 GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT
+/* Advertise to the NIC firmware: the NAPI work_done variable race is fixed,
+ * so the driver is able to reliably support features like busy_poll.
+ */
+#define GDMA_DRV_CAP_FLAG_1_NAPI_WKDONE_FIX BIT(2)
+
+#define GDMA_DRV_CAP_FLAGS1 \
+	(GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT | \
+	 GDMA_DRV_CAP_FLAG_1_NAPI_WKDONE_FIX)
 
 #define GDMA_DRV_CAP_FLAGS2 0
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 9259a74eca40..27a0f3af8aab 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1303,10 +1303,11 @@ static void mana_poll_rx_cq(struct mana_cq *cq)
 		xdp_do_flush();
 }
 
-static void mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
+static int mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
 {
 	struct mana_cq *cq = context;
 	u8 arm_bit;
+	int w;
 
 	WARN_ON_ONCE(cq->gdma_cq != gdma_queue);
 
@@ -1315,26 +1316,31 @@ static void mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
 	else
 		mana_poll_tx_cq(cq);
 
-	if (cq->work_done < cq->budget &&
-	    napi_complete_done(&cq->napi, cq->work_done)) {
+	w = cq->work_done;
+
+	if (w < cq->budget &&
+	    napi_complete_done(&cq->napi, w)) {
 		arm_bit = SET_ARM_BIT;
 	} else {
 		arm_bit = 0;
 	}
 
 	mana_gd_ring_cq(gdma_queue, arm_bit);
+
+	return w;
 }
 
 static int mana_poll(struct napi_struct *napi, int budget)
 {
 	struct mana_cq *cq = container_of(napi, struct mana_cq, napi);
+	int w;
 
 	cq->work_done = 0;
 	cq->budget = budget;
 
-	mana_cq_handler(cq, cq->gdma_cq);
+	w = mana_cq_handler(cq, cq->gdma_cq);
 
-	return min(cq->work_done, budget);
+	return min(w, budget);
 }
 
 static void mana_schedule_napi(void *context, struct gdma_queue *gdma_queue)
-- 
2.25.1

