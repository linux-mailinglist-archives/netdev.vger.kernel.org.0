Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050E44E2488
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346439AbiCUKoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346437AbiCUKoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:44:05 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2132.outbound.protection.outlook.com [40.107.243.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4CC149647
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:42:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8ctc2em3unUeg3cKy7UfBnafmn1dM1vYYUz6vduQ3y4KKUa2668SX0KonZeNGtFlkR+1Oko6Q71N/TuOWU8ba0TbvgTyjvdHmz4kCkcV7hWJ+j+fRf2l8i3zmwsaoma3lHzAr1to1CirnXKlwej8VP0Jt7MsbKHGXnYlXLxAm6JVzhZaC71e0WwscfSDo+PCWepClFH8xcnfXVbYJE1nayiu311O/gRN0uViuS5BgcLxVwOhHdIR0MUoSUOipiruL6kXgG/NjTu2DfalRb2uhnDLB+bNrOwf4AA7fa69R4us1guKwzcJXxMvu6Ldb7megF1hqHohNDwFzcshHpynA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D76txMFUiBYznc6iHkRmbExZvdb47cjqHG3KPOXcD8w=;
 b=HviIBmZLQL3dBLM6BmMjSM3Fhgq8sGuyNXFs4KalyydRY0rYAZA7vXe71C1h33fjlFQMu9KrwtP6GEWYTeX3/jQjnTwt3qrnxoh+Z+VENR6Ys816wC8bpPbmUv8RUy+FsgIhETMXcT2fOcPEQZTv4lrKdqGfbH3rny3JgdOCmIjkvjSy/2kg1nNyFYUeq1fsylTK4UT/5v5biB6azPjKbzRRt4he3z6e9jFpLpmkGzhILLsbKwspjbdwGkMva0jspdTftxhV4tIRjhhl8hl6mQsKTVm49gTlCa4O2G5JS3Vd8mD1Hk6ajqCwRo6VWLlUYczER2FzdYcLqiOpEMcs1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D76txMFUiBYznc6iHkRmbExZvdb47cjqHG3KPOXcD8w=;
 b=KslvJV3HEWEOLsYg5WL+u0KmlXU249LYUVfckbIW2EpiW7Y73BDLaMVInFd+ZA+UZmWWdyc2kFcm5LQS+mY49L0n0kzuOAxp5QCCflIzBn8+yl9A3ekjwaLQvWpPR+iuusGJ143n6y/qJf1qT2L1aLehjq2qLSQOh83V0IUV3WY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1512.namprd13.prod.outlook.com (2603:10b6:903:12f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.15; Mon, 21 Mar
 2022 10:42:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113%4]) with mapi id 15.20.5102.015; Mon, 21 Mar 2022
 10:42:33 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Yinjun Zhang <yinjun.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next v2 05/10] nfp: move tx_ring->qcidx into cold data
Date:   Mon, 21 Mar 2022 11:42:04 +0100
Message-Id: <20220321104209.273535-6-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321104209.273535-1-simon.horman@corigine.com>
References: <20220321104209.273535-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0001.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a23c7167-64e4-4bcc-5699-08da0b278160
X-MS-TrafficTypeDiagnostic: CY4PR13MB1512:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB15120B575A1C2BFD1B011AFBE8169@CY4PR13MB1512.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +DdPpvo02hkBPUDDX9aS2EScz+jTNo9VwedSsdNL5J500MXdzBOUk2GVvEk944b0WE+zA4LaHC3nkXN5o3MsavxklfPPU1Y2QhAEFLTfnYoNAeujHCcanQgE+s1mZQjXOea/9NufM3YLYiHKgmVC4bXiHQNhHyFItX2AKNf00nst1mHhRvc3ZDd0XrxlwrNImPCUzIq+h0WKOwZn9rh2jppJhu49RTtgf0qIv4tEhTkyAlLDKxEwvE99OK3qhnokQzHsDYNkCzD794DtUuWGUYMstcqnhNiquz3RXDR1Po1eggfDyKqUz68uja5UmuSzo0PxmlQllxGMQVIwqjXs/JMDRxlvDhM2Fbtn6tfwvhYHIJKmwxwakT2ZXYO4B0BoHJKRWaBnH5kjSnF9dBpHsGIjabFBM5DpDNqxbwvVL3cDAmYxskhELhuYzUxGzXNP0IxtMbGg3VBj3GjgrfgK88bFKzNEYWg3VfAoXf3mnsdCuz7WUMvvPDbK5dZ8gCsbvDKPU5ccG5pkm8mlcYqtD6EBOw6XUeS+M4zqDqowu94yzFhF4eUCARJBMtjsgFhfvAuUOwWKfb98SF5hYQ5QOhAHMywLmlOCXSUhj7IL3acHzeVIRRlofWhZmnCighhM8JuqW0SB37H8H64wS3VYGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(396003)(376002)(366004)(346002)(8936002)(186003)(1076003)(6512007)(110136005)(6506007)(2906002)(8676002)(5660300002)(86362001)(52116002)(107886003)(6666004)(6486002)(44832011)(66946007)(4326008)(38100700002)(66556008)(2616005)(66476007)(316002)(83380400001)(508600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K0jbKtXHw37piHk1C/dazl1j8JqboU1m5ajR7+OFs6dFc+S6rnmkrA5+0KRq?=
 =?us-ascii?Q?ugY/c+nubpQ6nz86B0qU7JcqlSM159JH4gs0jdNGqL/tPzxZAQCIfYcQEWUC?=
 =?us-ascii?Q?vLLE6ZREuMfnzjkYL1GM6Ximbwa5KpVMZJFhWDf3jSgEuDYcsQ+ytPlNYnum?=
 =?us-ascii?Q?kXx25EVmwEq2a22QULeFD27khBLyk5Fl0hRzBUnxNUHnvd4iHbJAfAuQ1Uba?=
 =?us-ascii?Q?l+GJhTgbtw9kQpfLAqHwFUuCueHcO/qm1rkzp+7rXa9ZN2lGGWG7a/kR9rbB?=
 =?us-ascii?Q?VmvZvhBCk6XsBvo73F3oU6jq47k/60RkJ1JTk/dYw41vK63Wu0nP3smUDNgB?=
 =?us-ascii?Q?j+zrLsnCiNaKh6HN1OjchbSLsYYyXe1L2hCVVIV0XbfTclegmPAQnpbQfrnp?=
 =?us-ascii?Q?54cW0JpzlTwACA5l2ZtKHGKALLd9buOiM0l45NkruzMW2lCjHMkoFP8hbYFx?=
 =?us-ascii?Q?MyXV5V5Sjjp+g8pNor/zcxtrhTmoSMsIE6AV2MROwgJwbXQ8+vOFyAAdIqqc?=
 =?us-ascii?Q?JHEyXXSLbqCYQ8nggpO+BLvvoydjdMz8mFF7PvMC9DpIgZEE/8+4Tijo4hfC?=
 =?us-ascii?Q?cwPauAU+heL63+ccakVDwrYFe8CrKRcQVkwwnfgCXGC1UfBoxDBssJImGxK1?=
 =?us-ascii?Q?YdMgCnSlLmDNDUKEh9OtMk+vZIKsSPoUlTDRaoM8c4OUipIPZvj+0fdinxQ1?=
 =?us-ascii?Q?xCUkkDd53/S3o8mip+EGr/7hQ6C7yYqdfpKT0KzmTwKjwLIKbRZ2DUIVXE19?=
 =?us-ascii?Q?a9KSOUzTJBL2+QpoirPbKJV3sNnm77od5Bjm9Y15UGZpEmB0bvSOT/K+DQ2p?=
 =?us-ascii?Q?HA/AraXnep4UPdptA0E1Jiw70SDwTTV5t44Q0u0c5yHuZAK4SXO1X3wIyPQE?=
 =?us-ascii?Q?6Eb5sYDb9YZHoKAiMs3PmGmDZtT0FUzzyH8gMWFd1MgrtqntNzBCExZzqJM2?=
 =?us-ascii?Q?styt0ixLLVMOkrjOgZdfJO6D0JVTZSFqrZ39ZdMu8GhyqQcXAFm7yob/S18s?=
 =?us-ascii?Q?99LNYVCmgdLE4VerSxPGPXV0jH0ehigRD3cxD2QeEb0eLAUCndwZkpiyCoNO?=
 =?us-ascii?Q?6H8e01lBiT9MOeW5RyLy7RKsacAEKzdBIsp2T0K9OmwZPhIs8V4WXwu4hXDE?=
 =?us-ascii?Q?ylcF7Im4JwZcr5UiOT4IH/Mv+r+2q5evJnGV6hxcXRFO/q7qJnQeAszfcbKM?=
 =?us-ascii?Q?5fsTPGGsj2w7GbQ+qF5g/3hMD/8yPST7aneF47dPKJE2OU3vLpvr75ZXUD4w?=
 =?us-ascii?Q?l+gSPVqqN1rzEhPEDgmp91Qo/2E0eblRe0aQ/6boRfZsqgA4paIy6/ZZstTj?=
 =?us-ascii?Q?1LAXKsiEhfs+eIplXgOgTo1wuDC+MkdClpMwGZmmwUoHhW+pLrnoKItbT0sC?=
 =?us-ascii?Q?388As2TeK7+zrnEi6uK5Q+02X2ZdvNeP0ZNYbxeiU68HZrEYrAyoKdkkQgBO?=
 =?us-ascii?Q?ncCvLdxCGkcWt+W99GtzIplqQa9+MDd5UmFzOC0basVPtoXaJHmFtXMj1leq?=
 =?us-ascii?Q?kQtcn0DG/cMnF1g8CSGQN1HNsZi01zQ4lAIoGUpuCn8fR1ZPH9G78W2pSg?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a23c7167-64e4-4bcc-5699-08da0b278160
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 10:42:32.9488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RCsmrcqQ1wDNZc+27aw5eIPck0eQN1hebuAlqeJOzJt29eUC+IFgipHttr/Gsw3zGU9Q3qlrzmecwTGgE1YPqTyDa80DTawTsmvkNKf2UpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

QCidx is not used on fast path, move it to the lower cacheline.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index d4b82c893c2a..4e288b8f3510 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -125,7 +125,6 @@ struct nfp_nfd3_tx_buf;
  * struct nfp_net_tx_ring - TX ring structure
  * @r_vec:      Back pointer to ring vector structure
  * @idx:        Ring index from Linux's perspective
- * @qcidx:      Queue Controller Peripheral (QCP) queue index for the TX queue
  * @qcp_q:      Pointer to base of the QCP TX queue
  * @cnt:        Size of the queue in number of descriptors
  * @wr_p:       TX ring write pointer (free running)
@@ -135,6 +134,8 @@ struct nfp_nfd3_tx_buf;
  *		(used for .xmit_more delayed kick)
  * @txbufs:     Array of transmitted TX buffers, to free on transmit
  * @txds:       Virtual address of TX ring in host memory
+ *
+ * @qcidx:      Queue Controller Peripheral (QCP) queue index for the TX queue
  * @dma:        DMA address of the TX ring
  * @size:       Size, in bytes, of the TX ring (needed to free)
  * @is_xdp:	Is this a XDP TX ring?
@@ -143,7 +144,6 @@ struct nfp_net_tx_ring {
 	struct nfp_net_r_vector *r_vec;
 
 	u32 idx;
-	int qcidx;
 	u8 __iomem *qcp_q;
 
 	u32 cnt;
@@ -156,6 +156,9 @@ struct nfp_net_tx_ring {
 	struct nfp_nfd3_tx_buf *txbufs;
 	struct nfp_nfd3_tx_desc *txds;
 
+	/* Cold data follows */
+	int qcidx;
+
 	dma_addr_t dma;
 	size_t size;
 	bool is_xdp;
-- 
2.30.2

