Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97587440687
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 02:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhJ3A5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 20:57:14 -0400
Received: from mail-cusazon11021026.outbound.protection.outlook.com ([52.101.62.26]:8930
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231610AbhJ3A5M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 20:57:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bca8tdqOaN8NV7/fOidkJUkh6m0+dG5eNoZC4dlhTsKdVlQH0dbhWQcfwjng+baU2URuuxXrsWbrKIgSbzRvqBCPUpNwfXqNRg0aQQh42zFezuiFuh/K7tcjrwVCGNBP/ePwFCUNhgQADmrWItGbTrknh3eLrY1KaIrlQ6ECV79Qn6ygFDLDdTE3btyCpi8QHI1XmSayiNQDL3W9kjGzi7pni1U/oOZ34ec/8KwK3OCo6THyW9p2y/sFotY4XJ1dzoF+0iVDMZssH5Gkb+xJRK/vhcjeugxl6QHP5hhSZgr9K+SMyhWJrOY9RHn/6BGiYKqXfax1FAUWa1a0IBcHUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FnrhNOax15uLE7n6XSwfpqsmyQVBaNL/OlNqsg20ZjY=;
 b=G9Jl+QpA+4B/f9hVaY/kzV6k1zK4Nt2UdsaECjpTndXgUG5FbduL8+trwNC79zguePVVR6iAVFGyumHQUN29apRwRg37jgk7lxel2vBMjawe7cFxvUJ2fV/TTbbRJEW6qnOy/DHtPJOcbfzx1HsDWbDUG6OABGuFaVdZHH75iY+YtJs7XUkwRX8OexcDzHFBraqdu01sXyY/cuIDzL3WL5wLhwudqOaKSPoueIbcBoDxTl7DvqpDcB0RGtMzKiRvaNM2Ti7FeCIPjuA+4FAmnZ8YBBPhhWSAMTPppAghMJiHu+z5vDO+Zgl9Mq/lewvcCG2CaFsk61ZXpDwAaDP14g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FnrhNOax15uLE7n6XSwfpqsmyQVBaNL/OlNqsg20ZjY=;
 b=RRTpA0QW1c8+Cr+XWAkZTT2eGorL48ooBGyPTw08X6plIMeNkIR3t6fgG2ikZCfruQEbYXP3meC3AUXXiLtDupn2WdVeK+BUDtgjMBN2kG31zO7rZT8BMnnsKVh6dzXkbPTKSCohR+g/Nfe8J36XtgahA3YPCPhUOZFNKVG08Fg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM5PR2101MB1095.namprd21.prod.outlook.com (2603:10b6:4:a2::17)
 by DM5PR21MB0827.namprd21.prod.outlook.com (2603:10b6:3:a3::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.6; Sat, 30 Oct 2021 00:54:32 +0000
Received: from DM5PR2101MB1095.namprd21.prod.outlook.com
 ([fe80::c0b9:3e28:af1e:a828]) by DM5PR2101MB1095.namprd21.prod.outlook.com
 ([fe80::c0b9:3e28:af1e:a828%4]) with mapi id 15.20.4649.010; Sat, 30 Oct 2021
 00:54:32 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        haiyangz@microsoft.com, netdev@vger.kernel.org
Cc:     kys@microsoft.com, stephen@networkplumber.org, wei.liu@kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        shacharr@microsoft.com, paulros@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, Dexuan Cui <decui@microsoft.com>
Subject: [PATCH net-next 3/4] net: mana: Improve the HWC error handling
Date:   Fri, 29 Oct 2021 17:54:07 -0700
Message-Id: <20211030005408.13932-4-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211030005408.13932-1-decui@microsoft.com>
References: <20211030005408.13932-1-decui@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR22CA0002.namprd22.prod.outlook.com
 (2603:10b6:300:ef::12) To DM5PR2101MB1095.namprd21.prod.outlook.com
 (2603:10b6:4:a2::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:f:7661:5dff:fe6a:8a2b) by MWHPR22CA0002.namprd22.prod.outlook.com (2603:10b6:300:ef::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Sat, 30 Oct 2021 00:54:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 706f88b3-79e8-40f7-fa11-08d99b3fd596
X-MS-TrafficTypeDiagnostic: DM5PR21MB0827:
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR21MB0827C5A5E27346126590CBC0BF889@DM5PR21MB0827.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wQAb8G4gCxGsPJB+s4g9Jln2IAunem76OaDisBj/EGz1dgfSLEQdYQdE5scEXYmHOgBYEdu4Y77V6Y1gdcWlYYsbA9rnKb5i0GQmzsDWpl0Neu53nB4chjo352nxqzKIWeyUE6NJAByyauF2/OoKgebfUzIPpdzY8hgjiYGDH+Jge5frwDr51GQYCMA81cSw21lO2vzjQ84btyPrgLOgvrnDZ0uQsph7HOW0S4vZrZXMYvZWZIIRdtRpqJ40t3TiRwXDXdPbJY5D1xAlxh6INajwf6U2l2/r9WBvw9jQXWBFhovLa8viYOusNjfPHmpd9pdmL9SK+tisafVhce/LfBBpGNppmiYyUDrYAjmLBN/H00p8awHrAJ3IJMhL68b9fWfyUs/WPLin8AhagE3vfQU3kW+A0RRCMVSeZgl3S1oOUzuvZzFNITlOZvXBhZZxqQpLQBofIe2jkgs8J5OggVukFzTwrekdEGMaWyQ9Ofv6ah3ZCWUaR2HrnFbKPN1e1KMo5gJlcj5DYsoJyfJfF9dMY+LkHaZO5ghkjhoTMQg0gwyMJg1S5FnLHZ6H1MREChqp0CpeHuCJVOYFrhLWW9W9ChBVfaLaYgD9uPpues8bBQ8rN+Hzf/gOXESntv6jsWgD1wFVtCF8C8IwHUkHUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR2101MB1095.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(7696005)(86362001)(6486002)(1076003)(83380400001)(66556008)(66476007)(4326008)(107886003)(66946007)(8676002)(2616005)(5660300002)(6666004)(10290500003)(38100700002)(82950400001)(82960400001)(7416002)(36756003)(316002)(2906002)(186003)(8936002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5NLPWSE8ahPIykQQSr2daERN6f+R5rHc0N4w0VmqS+MqAM2M0dW/5FxlEMPz?=
 =?us-ascii?Q?rhz7h2EYBRxS3dOQg+Vgt8VmxPVaUr9ia3MQwNKWPwi6XCsTPVUL0ItreD0H?=
 =?us-ascii?Q?JfCajM441p3l2so4fHWnUQ7ebJjNxJdU/Y8rN49X8tIMDg4lSJCBG2i8znp3?=
 =?us-ascii?Q?NG6TFBz04fNe04J4JG8UUPy2VU1ZydD+esDGsOKoMFlki4WPG5VIZikqxLMQ?=
 =?us-ascii?Q?k13AqAs+f3l/DJIEgWcXeEFcPY4ua5e2hL9/IJd95jB4dIFZEOg/kUnrFNvh?=
 =?us-ascii?Q?SS/qTexOv49uJ2UNFPeisZkOSr1ly/vZkkHgOrAU4/9GBURoVCAA7iK7kMa2?=
 =?us-ascii?Q?bXPjdcknmLMF9Ffv9aQkgDBwA+FGKHKCF4iiQlkPh02Sd2tWI/hY4P+e6NV8?=
 =?us-ascii?Q?bqfjBNGQOUXYyTyqeFiFduIm/qKnBVsRL9MzQNJf+wBuAkxYlW+HZ4m39S23?=
 =?us-ascii?Q?jADp9UqsuhzDplaD0/UUCARAZ5zIQuT4o+gIcAAD80Tmmbhm93eRDc34k8CR?=
 =?us-ascii?Q?IfnGUXuiw1H8l27S2TKWtOQVxsMO9CVOXuYeTl6iRA4RmMbU9h7nGuodnZSD?=
 =?us-ascii?Q?vDnvX7HQahITaffcwvEWWCgT0Wzc5R39y6jGPZWx7GIH9Xk+4J43IugVIFL+?=
 =?us-ascii?Q?fVvzHnbk/9pd8CpdDDgVDi83CpaDew83QJsooH+NxxTSLuTtH92WE4YurAhI?=
 =?us-ascii?Q?vWYpyd6cEFwXpCtwOUvQfrj8HgQqwvRWmADr3IAGEbwqPRvw/4qE2r2Xdngz?=
 =?us-ascii?Q?ItVxowfgDe+sqpnsOM2wISOGwz4x95lhXXRkiNa4zN6bCpzAldrmUlfDwUJP?=
 =?us-ascii?Q?eKkqnssTSPWCrMWar9biiLbQ/GltH71aswYAoZTFprH0zKhkxq9oWCvjUDfO?=
 =?us-ascii?Q?/PRFOGf2ZGL5IAJFdMh8jNzMYA9oH14Kt6QILkG1Xgy/7CpV6naKnE96V2jI?=
 =?us-ascii?Q?tnDqtwM2+wwnMXSHA1f5IobCxT+YX7dbAP56A+OXvyAe9agffFMRI2iDZqe1?=
 =?us-ascii?Q?RQg49gW3uajtAKrw5/ujMRo3GrY/bIGGRIznLo15BGu5nVszj4PWJ5HzuZ8q?=
 =?us-ascii?Q?Ogp3EZ+2tq/cIvkd9/WEJjNsahkeKnD82DaqfN4K5q5f0ClRTQlmfMmBsXCx?=
 =?us-ascii?Q?tcHpJ1+5Jng13UJ2l88kp1MVlAao9InrLxKXafciUpY/jnO42j+ekidF750x?=
 =?us-ascii?Q?EhWd/mVgcm1K6nD5YRIHDJNL/mwaf4BtWQGRJx3ANKPD3x+xie333GgbMQev?=
 =?us-ascii?Q?duHO+KwQ5KLuA2zk5NcV6NoIzBFavAvcmG8y1mMC2LiDSBuxjDYG0Sjs/XNF?=
 =?us-ascii?Q?m32I7JjzvUbaPq9lNr4V4YGccM0FK6hxtEDxhugz+T9zkuEdKp5X90kv51Sn?=
 =?us-ascii?Q?oUu/XvZEbizGcO4jZau9Rxf7nuvCxr+Aigk1wqZNAFWZ36SULHeEhHlFkbZn?=
 =?us-ascii?Q?3Z4KBOq3ehYCQdzy5ZO+ABCd0vXbpuay5HTo3tMU/YtCENuA++k9/1s2Xj0n?=
 =?us-ascii?Q?O7APdI8sWXjDxhs8uIfEP2xiKEGwJa3hnAGpgZ1Mm5A320x3PDN0YAbGx+Xb?=
 =?us-ascii?Q?sbklU7FrSTAHGrHv82/LM+1z6WIjEXVLUkwGHeMwKYNDVYzOWYT76mbncrzT?=
 =?us-ascii?Q?tZzNR4sjabwiEY2JbQ010HNYW/Whz507Fg4gzSrEI36yvlVgtnVdc8UhroYD?=
 =?us-ascii?Q?N+DxB2tRx8Kqj9B7YYt09Sy8S+M=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 706f88b3-79e8-40f7-fa11-08d99b3fd596
X-MS-Exchange-CrossTenant-AuthSource: DM5PR2101MB1095.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2021 00:54:31.9571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lgO5GzHUK6H8nLcs334c9JULx87mNDLtk+fef1AURSufYqwrYSSQzi87hWedezgjnYobawFWaZG5pyC2hbaUuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0827
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when the HWC creation fails, the error handling is flawed,
e.g. if mana_hwc_create_channel() -> mana_hwc_establish_channel() fails,
the resources acquired in mana_hwc_init_queues() is not released.

Enhance mana_hwc_destroy_channel() to do the proper cleanup work and
call it accordingly.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 .../net/ethernet/microsoft/mana/gdma_main.c   |  4 --
 .../net/ethernet/microsoft/mana/hw_channel.c  | 71 ++++++++-----------
 2 files changed, 31 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 8a9ee2885f8c..599dfd5e6090 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1330,8 +1330,6 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 clean_up_gdma:
 	mana_hwc_destroy_channel(gc);
-	vfree(gc->cq_table);
-	gc->cq_table = NULL;
 remove_irq:
 	mana_gd_remove_irqs(pdev);
 unmap_bar:
@@ -1354,8 +1352,6 @@ static void mana_gd_remove(struct pci_dev *pdev)
 	mana_remove(&gc->mana);
 
 	mana_hwc_destroy_channel(gc);
-	vfree(gc->cq_table);
-	gc->cq_table = NULL;
 
 	mana_gd_remove_irqs(pdev);
 
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index c1310ea1c216..851de2b81fa4 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -309,9 +309,6 @@ static void mana_hwc_comp_event(void *ctx, struct gdma_queue *q_self)
 
 static void mana_hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq *hwc_cq)
 {
-	if (!hwc_cq)
-		return;
-
 	kfree(hwc_cq->comp_buf);
 
 	if (hwc_cq->gdma_cq)
@@ -448,9 +445,6 @@ static void mana_hwc_dealloc_dma_buf(struct hw_channel_context *hwc,
 static void mana_hwc_destroy_wq(struct hw_channel_context *hwc,
 				struct hwc_wq *hwc_wq)
 {
-	if (!hwc_wq)
-		return;
-
 	mana_hwc_dealloc_dma_buf(hwc, hwc_wq->msg_buf);
 
 	if (hwc_wq->gdma_wq)
@@ -623,6 +617,7 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
 	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
 
+	/* Both were set in mana_hwc_init_event_handler(). */
 	if (WARN_ON(cq->id >= gc->max_num_cqs))
 		return -EPROTO;
 
@@ -638,9 +633,6 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 				u32 max_req_msg_size, u32 max_resp_msg_size)
 {
-	struct hwc_wq *hwc_rxq = NULL;
-	struct hwc_wq *hwc_txq = NULL;
-	struct hwc_cq *hwc_cq = NULL;
 	int err;
 
 	err = mana_hwc_init_inflight_msg(hwc, q_depth);
@@ -653,44 +645,32 @@ static int mana_hwc_init_queues(struct hw_channel_context *hwc, u16 q_depth,
 	err = mana_hwc_create_cq(hwc, q_depth * 2,
 				 mana_hwc_init_event_handler, hwc,
 				 mana_hwc_rx_event_handler, hwc,
-				 mana_hwc_tx_event_handler, hwc, &hwc_cq);
+				 mana_hwc_tx_event_handler, hwc, &hwc->cq);
 	if (err) {
 		dev_err(hwc->dev, "Failed to create HWC CQ: %d\n", err);
 		goto out;
 	}
-	hwc->cq = hwc_cq;
 
 	err = mana_hwc_create_wq(hwc, GDMA_RQ, q_depth, max_req_msg_size,
-				 hwc_cq, &hwc_rxq);
+				 hwc->cq, &hwc->rxq);
 	if (err) {
 		dev_err(hwc->dev, "Failed to create HWC RQ: %d\n", err);
 		goto out;
 	}
-	hwc->rxq = hwc_rxq;
 
 	err = mana_hwc_create_wq(hwc, GDMA_SQ, q_depth, max_resp_msg_size,
-				 hwc_cq, &hwc_txq);
+				 hwc->cq, &hwc->txq);
 	if (err) {
 		dev_err(hwc->dev, "Failed to create HWC SQ: %d\n", err);
 		goto out;
 	}
-	hwc->txq = hwc_txq;
 
 	hwc->num_inflight_msg = q_depth;
 	hwc->max_req_msg_size = max_req_msg_size;
 
 	return 0;
 out:
-	if (hwc_txq)
-		mana_hwc_destroy_wq(hwc, hwc_txq);
-
-	if (hwc_rxq)
-		mana_hwc_destroy_wq(hwc, hwc_rxq);
-
-	if (hwc_cq)
-		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc_cq);
-
-	mana_gd_free_res_map(&hwc->inflight_msg_res);
+	/* mana_hwc_create_channel() will do the cleanup.*/
 	return err;
 }
 
@@ -718,6 +698,9 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 	gd->pdid = INVALID_PDID;
 	gd->doorbell = INVALID_DOORBELL;
 
+	/* mana_hwc_init_queues() only creates the required data structures,
+	 * and doesn't touch the HWC device.
+	 */
 	err = mana_hwc_init_queues(hwc, HW_CHANNEL_VF_BOOTSTRAP_QUEUE_DEPTH,
 				   HW_CHANNEL_MAX_REQUEST_SIZE,
 				   HW_CHANNEL_MAX_RESPONSE_SIZE);
@@ -743,42 +726,50 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 
 	return 0;
 out:
-	kfree(hwc);
+	mana_hwc_destroy_channel(gc);
 	return err;
 }
 
 void mana_hwc_destroy_channel(struct gdma_context *gc)
 {
 	struct hw_channel_context *hwc = gc->hwc.driver_data;
-	struct hwc_caller_ctx *ctx;
 
-	mana_smc_teardown_hwc(&gc->shm_channel, false);
+	if (!hwc)
+		return;
+
+	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
+	 * non-zero, the HWC worked and we should tear down the HWC here.
+	 */
+	if (gc->max_num_cqs > 0) {
+		mana_smc_teardown_hwc(&gc->shm_channel, false);
+		gc->max_num_cqs = 0;
+	}
 
-	ctx = hwc->caller_ctx;
-	kfree(ctx);
+	kfree(hwc->caller_ctx);
 	hwc->caller_ctx = NULL;
 
-	mana_hwc_destroy_wq(hwc, hwc->txq);
-	hwc->txq = NULL;
+	if (hwc->txq)
+		mana_hwc_destroy_wq(hwc, hwc->txq);
 
-	mana_hwc_destroy_wq(hwc, hwc->rxq);
-	hwc->rxq = NULL;
+	if (hwc->rxq)
+		mana_hwc_destroy_wq(hwc, hwc->rxq);
 
-	mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
-	hwc->cq = NULL;
+	if (hwc->cq)
+		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
 
 	mana_gd_free_res_map(&hwc->inflight_msg_res);
 
 	hwc->num_inflight_msg = 0;
 
-	if (hwc->gdma_dev->pdid != INVALID_PDID) {
-		hwc->gdma_dev->doorbell = INVALID_DOORBELL;
-		hwc->gdma_dev->pdid = INVALID_PDID;
-	}
+	hwc->gdma_dev->doorbell = INVALID_DOORBELL;
+	hwc->gdma_dev->pdid = INVALID_PDID;
 
 	kfree(hwc);
 	gc->hwc.driver_data = NULL;
 	gc->hwc.gdma_context = NULL;
+
+	vfree(gc->cq_table);
+	gc->cq_table = NULL;
 }
 
 int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
-- 
2.17.1

