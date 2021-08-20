Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12F93F3573
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 22:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239103AbhHTUoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 16:44:01 -0400
Received: from mail-oln040093003004.outbound.protection.outlook.com ([40.93.3.4]:62407
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229697AbhHTUoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 16:44:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1PfUciT7A19Y1U41kuKku0xFNkdrN1HEeQuBbItbUMjVVwYThUQICjZu0GUFxjBHh3YSKSsI+siyDjxG1mVIth63BseZ4XOQoCyQ29psNsCig7erBZQyEdM2NNmi46fj+ExnwpoYhzVh5pDnGceynkvfdSZgB2wyco1vFqFiBlGUdiehoBu0g7mkGM/5H/2swjLrFF6L237t/4Pi7UgPiXWjz4IsYpz6q6Nue5jIk4qYNCGpZzS5RGOnz6wnDY5qjtmrQD7tpsxYQGKu+Wj0EnzKP+g56q4+5VAbNoAZJVdR5ERxUZLlni1eXfgQyxPwgLKH6ktAJar/4bFj18guQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SC5VqR1RQUcaTxz/oobcSc+OqiE3xuwxhBmLJsLpXUE=;
 b=UoUxIZB0yTCDZaQUHlVf96GUMJEfEky0Uacidw/N0syOnEX6DX76mg86XIc/6DtGJAhncb9sdvkDIxtoizIp6qY792Y7/DifpAd4A6Y2BckIFTUyOzHAI3VuOI4zSozQRrGzAdEYdUd4o6AhhQcicGiZN6OXzGtBVp3IMykp/c7xmOSUKUT6l3v2pPyz4/r+MRvx+w6e90Ey5NZ4QRf23RlR60MYeuEApf9dbr7Ja4Fy6b+mow8xw/5WtKJ1XvoDPNKTInvwgZ5B/P508F0WIXeFgw4lQlq+O3eih9QQxn/SVALZv2KWMEF+2R1x0EfCr6zxp6es2tCtCyGTN1aj0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SC5VqR1RQUcaTxz/oobcSc+OqiE3xuwxhBmLJsLpXUE=;
 b=ZYR6Oiie6OCPHG1lk4lU4kDTHBZdxvcytRqR0n1WmemCm5NurgytKL4V8+7bGPDlZd0MUo5CXov5OJsAlI5tmJ64fItprvPX8mYdJsr77iEFsxtnYamy27TMukb1cabFGD0IMDxrWAXEIGkEYlO6ghiSJO6NSQFdSu5XwqNwSjM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
 by DM6PR21MB1338.namprd21.prod.outlook.com (2603:10b6:5:175::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.1; Fri, 20 Aug
 2021 20:43:19 +0000
Received: from DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::c161:e92b:37a4:f5fc]) by DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::c161:e92b:37a4:f5fc%6]) with mapi id 15.20.4457.009; Fri, 20 Aug 2021
 20:43:19 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        paulros@microsoft.com, shacharr@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] mana: Add support for EQ sharing
Date:   Fri, 20 Aug 2021 13:42:49 -0700
Message-Id: <1629492169-11749-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1201CA0010.namprd12.prod.outlook.com
 (2603:10b6:301:4a::20) To DM6PR21MB1340.namprd21.prod.outlook.com
 (2603:10b6:5:175::19)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR1201CA0010.namprd12.prod.outlook.com (2603:10b6:301:4a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 20:43:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 507e5197-4d97-4fe6-e345-08d9641b244c
X-MS-TrafficTypeDiagnostic: DM6PR21MB1338:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM6PR21MB1338A0A92055D1813E409DA7ACC19@DM6PR21MB1338.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:338;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UwqKnlyR9AWFtFBzpNrupUxow6yrwDwQfjJBXhI9jvgBze3UfK0pil5RhkSudGhzlj5t+Pip5LhKDspf7SEaJ/VGyWV+NaNH6uXjqzjM2ZVd63DDdSSV3j/Iqcv+sjKLxjjBVSXeWcVCZ+PTMPa1WmvnBA2TuFqmi3MQg1B4WJd10ofyonGrKwtlKs1UUu+oXmmRphVGoOC4zkgGySoRDkVi2G7dx+2dym9j7geDCOEzoaveNQ7ISxjSmA0PVzO/s0vwIdFD7yhpWOqRxOvsx6VjDNE66qls1v6JpC8jLrPayWU1XZoti6vseuUQkS1TSjxRzkvvEsulxtjk15JNZc1gbJpzWuT0J/9cd0OIGi69AoQ5F8JKdGQ3g+IJCD4jC4EmjOp1RUUGHx67UKfoA8YV/gKbbbzrY3Cl3f+NY96qV4sqZSCjW9o0BNIij5L8i+ay/cOZSJQE+nVTcHbR+/2czSCwBvDIzUFs2A3+kGsC9KlPVcTxUOioVzF0bWs1B7Cjz1Kt9aHrXIIX79P9FfScaJeh50zU35S8+RjKBAhZ29jU6RI3Ee62Dt4fnpCSLdag02mFyoZh5laMnX9/T/5Dyym+bPDQ4EFUznKUihI5AF1+Cp9rM/x4deQm3UmVReeUYR5QHN0T/wOMUFXeNpJa5DF1KYPaJKIY2zkNfIGuXPveQpumW3TxUSjhcDVkCUaFwTcFR1t04bh/r5Fl7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1340.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(956004)(186003)(36756003)(508600001)(26005)(4326008)(2616005)(10290500003)(6506007)(38350700002)(38100700002)(6666004)(5660300002)(30864003)(316002)(2906002)(66476007)(52116002)(66946007)(66556008)(82950400001)(82960400001)(6512007)(83380400001)(8676002)(6486002)(8936002)(7846003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6Rxxs91hdTSpo5FMoL5EduZJaQO+8DMM5YgV3qXRYOuXP2Iwg4aIxWcaGYLy?=
 =?us-ascii?Q?OniffguJaV7II0GJ4kpXSffhFS2tVfOQT5jdpqNKRs9iqZEG8RUXoqF3Wrsz?=
 =?us-ascii?Q?R2QN800l0UVx4eOnsY39BVzDQdmxv6oV0/lct1yLU8LIH0QHTQAL4Jm9vtY/?=
 =?us-ascii?Q?aqNJBHXg2IVtMyoj5M6dfJinArbl/pOB5XvWet4fraUvDBraFhQ9umWTugUX?=
 =?us-ascii?Q?cIRbO6gbrOBND9YIIBp8j4K4YpQsCE2bnuPG8qOiOgN5xTjx7G3z/UJd+DJ8?=
 =?us-ascii?Q?1nuY0CSrmaKM0eutA310rr4syB9KFEgHZ1HnKZ5IibT85YwBZpoEYFPEyITT?=
 =?us-ascii?Q?9T3+ZcCl+EwdO9V8WFl5INMX9QM33OHnNxI2GZIg+HfDPexhmvnBKZmavCxk?=
 =?us-ascii?Q?hHgarbuZooO/MiZjDeN35ne9YvYUq+SJ0N3NMQN1KfDtZOKGdfvdR7RYvzKR?=
 =?us-ascii?Q?bsKEA10BdoXa6Q+wzlSmxFRFI4Nr8i/PABffauFBzN0iRmIV3XZaWxm6dFoD?=
 =?us-ascii?Q?ZeQxB9Im5BF/N+LmF2RXfKP98NnX5+T+tAucVeUe2YXdgsa44gbyi/M/VjUe?=
 =?us-ascii?Q?9xEkqOx0rg2gw1ZV36m0dCv3g3UNPkhR0/7ElCVmWBkWnxad/ip/ZHkQeEcI?=
 =?us-ascii?Q?ovFAzGyF0e91Pg98HBRYnpDp/02Ax9F6jELYJRuHVfrSpyqokzqiQUb7TbCB?=
 =?us-ascii?Q?zeLiWjMj4Am9+nNngZN6ww+uf5RwwHmaW29FSp+akXB1QOT939sO1e9s9IhM?=
 =?us-ascii?Q?FfxvIypeLUn8hq2xjr+t3kUQoyv3aBDu5F6DTztPrFwPN7uCJ51lRTXYxPaY?=
 =?us-ascii?Q?bu4OUCjlzodxglblHlDK7WgM9bx8vNWgJYb+0xMdfChXhuD04bumSzg3Qi1T?=
 =?us-ascii?Q?5Hsd27chJqf//lGrXC6Tc9HCTZUi/1WW9G8PHihuYghk5pipNfVh0DUKksrH?=
 =?us-ascii?Q?TmPzYuNU+6Cntm6P7k6hyIQ/bpqIQ4JfM8L5DuIXqbck2uY4IVTVjNZl+dUn?=
 =?us-ascii?Q?eusBDEd3fkIQHwdCrjlDXwk25k9XUm4oyRncNc1HLwj9YAv+vtMvY+qJQ50W?=
 =?us-ascii?Q?ZjFEddpFJ7N5INDhlCXrUtoZv/ADRqhMEu8B9wuBpJlcp6cdObhADZ/JbXd2?=
 =?us-ascii?Q?uouw9n9w7QZ9epFlN9MhuN7ssP1v8dO18BF87Wkm7Zw3DFWzgLX1okyZSiC5?=
 =?us-ascii?Q?uBQq/8BSZeMF3SyTghQ6y5zD4v63K0krkdObCwFP8ndr21vMTFKzwIx4uCu8?=
 =?us-ascii?Q?eUZZsYFLEmbSeXA7n+TybbdgJbFf8VsTfpXaipNOpwkCnOGVlkwFCY/edC/N?=
 =?us-ascii?Q?4k7sXX+VhjZuo/sdjy1S9dVn?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 507e5197-4d97-4fe6-e345-08d9641b244c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1340.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 20:43:18.9093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JsWlUiUmpuTJZlHq4lb1GbTnnt+rWxdGSPYIS3g+NtgiIm0Om8KB+Gpo6njJb6itMtnx1sJczwCaxHgyDJTSMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1338
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing code uses (1 + #vPorts * #Queues) MSIXs, which may exceed
the device limit.

Support EQ sharing, so that multiple vPorts can share the same set of
MSIXs.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/gdma.h    |  32 ++--
 .../net/ethernet/microsoft/mana/gdma_main.c   |  79 ++-------
 .../net/ethernet/microsoft/mana/hw_channel.c  |   2 +-
 drivers/net/ethernet/microsoft/mana/mana.h    |  29 ++--
 drivers/net/ethernet/microsoft/mana/mana_en.c | 162 ++++++++++--------
 5 files changed, 145 insertions(+), 159 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/drivers/net/ethernet/microsoft/mana/gdma.h
index 33e53d32e891..41ecd156e95f 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma.h
+++ b/drivers/net/ethernet/microsoft/mana/gdma.h
@@ -239,10 +239,8 @@ struct gdma_event {
 
 struct gdma_queue;
 
-#define CQE_POLLING_BUFFER 512
 struct mana_eq {
 	struct gdma_queue *eq;
-	struct gdma_comp cqe_poll[CQE_POLLING_BUFFER];
 };
 
 typedef void gdma_eq_callback(void *context, struct gdma_queue *q,
@@ -291,11 +289,6 @@ struct gdma_queue {
 			unsigned int msix_index;
 
 			u32 log2_throttle_limit;
-
-			/* NAPI data */
-			struct napi_struct napi;
-			int work_done;
-			int budget;
 		} eq;
 
 		struct {
@@ -319,9 +312,6 @@ struct gdma_queue_spec {
 			void *context;
 
 			unsigned long log2_throttle_limit;
-
-			/* Only used by the MANA device. */
-			struct net_device *ndev;
 		} eq;
 
 		struct {
@@ -406,7 +396,7 @@ void mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue);
 
 int mana_gd_poll_cq(struct gdma_queue *cq, struct gdma_comp *comp, int num_cqe);
 
-void mana_gd_arm_cq(struct gdma_queue *cq);
+void mana_gd_ring_cq(struct gdma_queue *cq, u8 arm_bit);
 
 struct gdma_wqe {
 	u32 reserved	:24;
@@ -496,16 +486,28 @@ enum {
 	GDMA_PROTOCOL_LAST	= GDMA_PROTOCOL_V1,
 };
 
+#define GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT BIT(0)
+
+#define GDMA_DRV_CAP_FLAGS1 GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT
+
+#define GDMA_DRV_CAP_FLAGS2 0
+
+#define GDMA_DRV_CAP_FLAGS3 0
+
+#define GDMA_DRV_CAP_FLAGS4 0
+
 struct gdma_verify_ver_req {
 	struct gdma_req_hdr hdr;
 
 	/* Mandatory fields required for protocol establishment */
 	u64 protocol_ver_min;
 	u64 protocol_ver_max;
-	u64 drv_cap_flags1;
-	u64 drv_cap_flags2;
-	u64 drv_cap_flags3;
-	u64 drv_cap_flags4;
+
+	/* Gdma Driver Capability Flags */
+	u64 gd_drv_cap_flags1;
+	u64 gd_drv_cap_flags2;
+	u64 gd_drv_cap_flags3;
+	u64 gd_drv_cap_flags4;
 
 	/* Advisory fields */
 	u64 drv_ver;
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 2f87bf90f8ec..6ed27dccd1c8 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -267,7 +267,7 @@ void mana_gd_wq_ring_doorbell(struct gdma_context *gc, struct gdma_queue *queue)
 			      queue->id, queue->head * GDMA_WQE_BU_SIZE, 1);
 }
 
-void mana_gd_arm_cq(struct gdma_queue *cq)
+void mana_gd_ring_cq(struct gdma_queue *cq, u8 arm_bit)
 {
 	struct gdma_context *gc = cq->gdma_dev->gdma_context;
 
@@ -276,7 +276,7 @@ void mana_gd_arm_cq(struct gdma_queue *cq)
 	u32 head = cq->head % (num_cqe << GDMA_CQE_OWNER_BITS);
 
 	mana_gd_ring_doorbell(gc, cq->gdma_dev->doorbell, cq->type, cq->id,
-			      head, SET_ARM_BIT);
+			      head, arm_bit);
 }
 
 static void mana_gd_process_eqe(struct gdma_queue *eq)
@@ -339,7 +339,6 @@ static void mana_gd_process_eq_events(void *arg)
 	struct gdma_queue *eq = arg;
 	struct gdma_context *gc;
 	struct gdma_eqe *eqe;
-	unsigned int arm_bit;
 	u32 head, num_eqe;
 	int i;
 
@@ -370,92 +369,54 @@ static void mana_gd_process_eq_events(void *arg)
 		eq->head++;
 	}
 
-	/* Always rearm the EQ for HWC. For MANA, rearm it when NAPI is done. */
-	if (mana_gd_is_hwc(eq->gdma_dev)) {
-		arm_bit = SET_ARM_BIT;
-	} else if (eq->eq.work_done < eq->eq.budget &&
-		   napi_complete_done(&eq->eq.napi, eq->eq.work_done)) {
-		arm_bit = SET_ARM_BIT;
-	} else {
-		arm_bit = 0;
-	}
-
 	head = eq->head % (num_eqe << GDMA_EQE_OWNER_BITS);
 
 	mana_gd_ring_doorbell(gc, eq->gdma_dev->doorbell, eq->type, eq->id,
-			      head, arm_bit);
-}
-
-static int mana_poll(struct napi_struct *napi, int budget)
-{
-	struct gdma_queue *eq = container_of(napi, struct gdma_queue, eq.napi);
-
-	eq->eq.work_done = 0;
-	eq->eq.budget = budget;
-
-	mana_gd_process_eq_events(eq);
-
-	return min(eq->eq.work_done, budget);
-}
-
-static void mana_gd_schedule_napi(void *arg)
-{
-	struct gdma_queue *eq = arg;
-	struct napi_struct *napi;
-
-	napi = &eq->eq.napi;
-	napi_schedule_irqoff(napi);
+			      head, SET_ARM_BIT);
 }
 
 static int mana_gd_register_irq(struct gdma_queue *queue,
 				const struct gdma_queue_spec *spec)
 {
 	struct gdma_dev *gd = queue->gdma_dev;
-	bool is_mana = mana_gd_is_mana(gd);
 	struct gdma_irq_context *gic;
 	struct gdma_context *gc;
 	struct gdma_resource *r;
 	unsigned int msi_index;
 	unsigned long flags;
-	int err;
+	struct device *dev;
+	int err = 0;
 
 	gc = gd->gdma_context;
 	r = &gc->msix_resource;
+	dev = gc->dev;
 
 	spin_lock_irqsave(&r->lock, flags);
 
 	msi_index = find_first_zero_bit(r->map, r->size);
-	if (msi_index >= r->size) {
+	if (msi_index >= r->size || msi_index >= gc->num_msix_usable) {
 		err = -ENOSPC;
 	} else {
 		bitmap_set(r->map, msi_index, 1);
 		queue->eq.msix_index = msi_index;
-		err = 0;
 	}
 
 	spin_unlock_irqrestore(&r->lock, flags);
 
-	if (err)
-		return err;
+	if (err) {
+		dev_err(dev, "Register IRQ err:%d, msi:%u rsize:%u, nMSI:%u",
+			err, msi_index, r->size, gc->num_msix_usable);
 
-	WARN_ON(msi_index >= gc->num_msix_usable);
+		return err;
+	}
 
 	gic = &gc->irq_contexts[msi_index];
 
-	if (is_mana) {
-		netif_napi_add(spec->eq.ndev, &queue->eq.napi, mana_poll,
-			       NAPI_POLL_WEIGHT);
-		napi_enable(&queue->eq.napi);
-	}
-
 	WARN_ON(gic->handler || gic->arg);
 
 	gic->arg = queue;
 
-	if (is_mana)
-		gic->handler = mana_gd_schedule_napi;
-	else
-		gic->handler = mana_gd_process_eq_events;
+	gic->handler = mana_gd_process_eq_events;
 
 	return 0;
 }
@@ -549,11 +510,6 @@ static void mana_gd_destroy_eq(struct gdma_context *gc, bool flush_evenets,
 
 	mana_gd_deregiser_irq(queue);
 
-	if (mana_gd_is_mana(queue->gdma_dev)) {
-		napi_disable(&queue->eq.napi);
-		netif_napi_del(&queue->eq.napi);
-	}
-
 	if (queue->eq.disable_needed)
 		mana_gd_disable_queue(queue);
 }
@@ -883,6 +839,11 @@ int mana_gd_verify_vf_version(struct pci_dev *pdev)
 	req.protocol_ver_min = GDMA_PROTOCOL_FIRST;
 	req.protocol_ver_max = GDMA_PROTOCOL_LAST;
 
+	req.gd_drv_cap_flags1 = GDMA_DRV_CAP_FLAGS1;
+	req.gd_drv_cap_flags2 = GDMA_DRV_CAP_FLAGS2;
+	req.gd_drv_cap_flags3 = GDMA_DRV_CAP_FLAGS3;
+	req.gd_drv_cap_flags4 = GDMA_DRV_CAP_FLAGS4;
+
 	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
 	if (err || resp.hdr.status) {
 		dev_err(gc->dev, "VfVerifyVersionOutput: %d, status=0x%x\n",
@@ -1201,10 +1162,8 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 	if (max_queues_per_port > MANA_MAX_NUM_QUEUES)
 		max_queues_per_port = MANA_MAX_NUM_QUEUES;
 
-	max_irqs = max_queues_per_port * MAX_PORTS_IN_MANA_DEV;
-
 	/* Need 1 interrupt for the Hardware communication Channel (HWC) */
-	max_irqs++;
+	max_irqs = max_queues_per_port + 1;
 
 	nvec = pci_alloc_irq_vectors(pdev, 2, max_irqs, PCI_IRQ_MSIX);
 	if (nvec < 0)
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 1a923fd99990..c1310ea1c216 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -304,7 +304,7 @@ static void mana_hwc_comp_event(void *ctx, struct gdma_queue *q_self)
 						&comp_data);
 	}
 
-	mana_gd_arm_cq(q_self);
+	mana_gd_ring_cq(q_self, SET_ARM_BIT);
 }
 
 static void mana_hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq *hwc_cq)
diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index a2c3f826f022..fc98a5ba5ed0 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -46,7 +46,7 @@ enum TRI_STATE {
 #define EQ_SIZE (8 * PAGE_SIZE)
 #define LOG2_EQ_THROTTLE 3
 
-#define MAX_PORTS_IN_MANA_DEV 16
+#define MAX_PORTS_IN_MANA_DEV 256
 
 struct mana_stats {
 	u64 packets;
@@ -225,6 +225,8 @@ struct mana_tx_comp_oob {
 
 struct mana_rxq;
 
+#define CQE_POLLING_BUFFER 512
+
 struct mana_cq {
 	struct gdma_queue *gdma_cq;
 
@@ -244,8 +246,13 @@ struct mana_cq {
 	 */
 	struct mana_txq *txq;
 
-	/* Pointer to a buffer which the CQ handler can copy the CQE's into. */
-	struct gdma_comp *gdma_comp_buf;
+	/* Buffer which the CQ handler can copy the CQE's into. */
+	struct gdma_comp gdma_comp_buf[CQE_POLLING_BUFFER];
+
+	/* NAPI data */
+	struct napi_struct napi;
+	int work_done;
+	int budget;
 };
 
 #define GDMA_MAX_RQE_SGES 15
@@ -315,6 +322,8 @@ struct mana_context {
 
 	u16 num_ports;
 
+	struct mana_eq *eqs;
+
 	struct net_device *ports[MAX_PORTS_IN_MANA_DEV];
 };
 
@@ -324,8 +333,6 @@ struct mana_port_context {
 
 	u8 mac_addr[ETH_ALEN];
 
-	struct mana_eq *eqs;
-
 	enum TRI_STATE rss_state;
 
 	mana_handle_t default_rxobj;
@@ -395,11 +402,11 @@ enum mana_command_code {
 struct mana_query_device_cfg_req {
 	struct gdma_req_hdr hdr;
 
-	/* Driver Capability flags */
-	u64 drv_cap_flags1;
-	u64 drv_cap_flags2;
-	u64 drv_cap_flags3;
-	u64 drv_cap_flags4;
+	/* MANA Nic Driver Capability flags */
+	u64 mn_drv_cap_flags1;
+	u64 mn_drv_cap_flags2;
+	u64 mn_drv_cap_flags3;
+	u64 mn_drv_cap_flags4;
 
 	u32 proto_major_ver;
 	u32 proto_minor_ver;
@@ -516,7 +523,7 @@ struct mana_cfg_rx_steer_resp {
 	struct gdma_resp_hdr hdr;
 }; /* HW DATA */
 
-#define MANA_MAX_NUM_QUEUES 16
+#define MANA_MAX_NUM_QUEUES 64
 
 #define MANA_SHORT_VPORT_OFFSET_MAX ((1U << 8) - 1)
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 83eb28c132f3..a41a7e7b2bd3 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -696,66 +696,56 @@ static void mana_destroy_wq_obj(struct mana_port_context *apc, u32 wq_type,
 			   resp.hdr.status);
 }
 
-static void mana_init_cqe_poll_buf(struct gdma_comp *cqe_poll_buf)
-{
-	int i;
-
-	for (i = 0; i < CQE_POLLING_BUFFER; i++)
-		memset(&cqe_poll_buf[i], 0, sizeof(struct gdma_comp));
-}
-
-static void mana_destroy_eq(struct gdma_context *gc,
-			    struct mana_port_context *apc)
+static void mana_destroy_eq(struct mana_context *ac)
 {
+	struct gdma_context *gc = ac->gdma_dev->gdma_context;
 	struct gdma_queue *eq;
 	int i;
 
-	if (!apc->eqs)
+	if (!ac->eqs)
 		return;
 
-	for (i = 0; i < apc->num_queues; i++) {
-		eq = apc->eqs[i].eq;
+	for (i = 0; i < gc->max_num_queues; i++) {
+		eq = ac->eqs[i].eq;
 		if (!eq)
 			continue;
 
 		mana_gd_destroy_queue(gc, eq);
 	}
 
-	kfree(apc->eqs);
-	apc->eqs = NULL;
+	kfree(ac->eqs);
+	ac->eqs = NULL;
 }
 
-static int mana_create_eq(struct mana_port_context *apc)
+static int mana_create_eq(struct mana_context *ac)
 {
-	struct gdma_dev *gd = apc->ac->gdma_dev;
+	struct gdma_dev *gd = ac->gdma_dev;
+	struct gdma_context *gc = gd->gdma_context;
 	struct gdma_queue_spec spec = {};
 	int err;
 	int i;
 
-	apc->eqs = kcalloc(apc->num_queues, sizeof(struct mana_eq),
-			   GFP_KERNEL);
-	if (!apc->eqs)
+	ac->eqs = kcalloc(gc->max_num_queues, sizeof(struct mana_eq),
+			  GFP_KERNEL);
+	if (!ac->eqs)
 		return -ENOMEM;
 
 	spec.type = GDMA_EQ;
 	spec.monitor_avl_buf = false;
 	spec.queue_size = EQ_SIZE;
 	spec.eq.callback = NULL;
-	spec.eq.context = apc->eqs;
+	spec.eq.context = ac->eqs;
 	spec.eq.log2_throttle_limit = LOG2_EQ_THROTTLE;
-	spec.eq.ndev = apc->ndev;
-
-	for (i = 0; i < apc->num_queues; i++) {
-		mana_init_cqe_poll_buf(apc->eqs[i].cqe_poll);
 
-		err = mana_gd_create_mana_eq(gd, &spec, &apc->eqs[i].eq);
+	for (i = 0; i < gc->max_num_queues; i++) {
+		err = mana_gd_create_mana_eq(gd, &spec, &ac->eqs[i].eq);
 		if (err)
 			goto out;
 	}
 
 	return 0;
 out:
-	mana_destroy_eq(gd->gdma_context, apc);
+	mana_destroy_eq(ac);
 	return err;
 }
 
@@ -790,7 +780,6 @@ static void mana_unmap_skb(struct sk_buff *skb, struct mana_port_context *apc)
 
 static void mana_poll_tx_cq(struct mana_cq *cq)
 {
-	struct gdma_queue *gdma_eq = cq->gdma_cq->cq.parent;
 	struct gdma_comp *completions = cq->gdma_comp_buf;
 	struct gdma_posted_wqe_info *wqe_info;
 	unsigned int pkt_transmitted = 0;
@@ -812,6 +801,9 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 	comp_read = mana_gd_poll_cq(cq->gdma_cq, completions,
 				    CQE_POLLING_BUFFER);
 
+	if (comp_read < 1)
+		return;
+
 	for (i = 0; i < comp_read; i++) {
 		struct mana_tx_comp_oob *cqe_oob;
 
@@ -863,7 +855,7 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 
 		mana_unmap_skb(skb, apc);
 
-		napi_consume_skb(skb, gdma_eq->eq.budget);
+		napi_consume_skb(skb, cq->budget);
 
 		pkt_transmitted++;
 	}
@@ -892,6 +884,8 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 
 	if (atomic_sub_return(pkt_transmitted, &txq->pending_sends) < 0)
 		WARN_ON_ONCE(1);
+
+	cq->work_done = pkt_transmitted;
 }
 
 static void mana_post_pkt_rxq(struct mana_rxq *rxq)
@@ -920,17 +914,13 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 	struct mana_stats *rx_stats = &rxq->stats;
 	struct net_device *ndev = rxq->ndev;
 	uint pkt_len = cqe->ppi[0].pkt_len;
-	struct mana_port_context *apc;
 	u16 rxq_idx = rxq->rxq_idx;
 	struct napi_struct *napi;
-	struct gdma_queue *eq;
 	struct sk_buff *skb;
 	u32 hash_value;
 
-	apc = netdev_priv(ndev);
-	eq = apc->eqs[rxq_idx].eq;
-	eq->eq.work_done++;
-	napi = &eq->eq.napi;
+	rxq->rx_cq.work_done++;
+	napi = &rxq->rx_cq.napi;
 
 	if (!buf_va) {
 		++ndev->stats.rx_dropped;
@@ -1083,6 +1073,7 @@ static void mana_poll_rx_cq(struct mana_cq *cq)
 static void mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
 {
 	struct mana_cq *cq = context;
+	u8 arm_bit;
 
 	WARN_ON_ONCE(cq->gdma_cq != gdma_queue);
 
@@ -1091,7 +1082,33 @@ static void mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
 	else
 		mana_poll_tx_cq(cq);
 
-	mana_gd_arm_cq(gdma_queue);
+	if (cq->work_done < cq->budget &&
+	    napi_complete_done(&cq->napi, cq->work_done)) {
+		arm_bit = SET_ARM_BIT;
+	} else {
+		arm_bit = 0;
+	}
+
+	mana_gd_ring_cq(gdma_queue, arm_bit);
+}
+
+static int mana_poll(struct napi_struct *napi, int budget)
+{
+	struct mana_cq *cq = container_of(napi, struct mana_cq, napi);
+
+	cq->work_done = 0;
+	cq->budget = budget;
+
+	mana_cq_handler(cq, cq->gdma_cq);
+
+	return min(cq->work_done, budget);
+}
+
+static void mana_schedule_napi(void *context, struct gdma_queue *gdma_queue)
+{
+	struct mana_cq *cq = context;
+
+	napi_schedule_irqoff(&cq->napi);
 }
 
 static void mana_deinit_cq(struct mana_port_context *apc, struct mana_cq *cq)
@@ -1116,12 +1133,18 @@ static void mana_deinit_txq(struct mana_port_context *apc, struct mana_txq *txq)
 
 static void mana_destroy_txq(struct mana_port_context *apc)
 {
+	struct napi_struct *napi;
 	int i;
 
 	if (!apc->tx_qp)
 		return;
 
 	for (i = 0; i < apc->num_queues; i++) {
+		napi = &apc->tx_qp[i].tx_cq.napi;
+		napi_synchronize(napi);
+		napi_disable(napi);
+		netif_napi_del(napi);
+
 		mana_destroy_wq_obj(apc, GDMA_SQ, apc->tx_qp[i].tx_object);
 
 		mana_deinit_cq(apc, &apc->tx_qp[i].tx_cq);
@@ -1136,7 +1159,8 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 static int mana_create_txq(struct mana_port_context *apc,
 			   struct net_device *net)
 {
-	struct gdma_dev *gd = apc->ac->gdma_dev;
+	struct mana_context *ac = apc->ac;
+	struct gdma_dev *gd = ac->gdma_dev;
 	struct mana_obj_spec wq_spec;
 	struct mana_obj_spec cq_spec;
 	struct gdma_queue_spec spec;
@@ -1188,7 +1212,6 @@ static int mana_create_txq(struct mana_port_context *apc,
 
 		/* Create SQ's CQ */
 		cq = &apc->tx_qp[i].tx_cq;
-		cq->gdma_comp_buf = apc->eqs[i].cqe_poll;
 		cq->type = MANA_CQ_TYPE_TX;
 
 		cq->txq = txq;
@@ -1197,8 +1220,8 @@ static int mana_create_txq(struct mana_port_context *apc,
 		spec.type = GDMA_CQ;
 		spec.monitor_avl_buf = false;
 		spec.queue_size = cq_size;
-		spec.cq.callback = mana_cq_handler;
-		spec.cq.parent_eq = apc->eqs[i].eq;
+		spec.cq.callback = mana_schedule_napi;
+		spec.cq.parent_eq = ac->eqs[i].eq;
 		spec.cq.context = cq;
 		err = mana_gd_create_mana_wq_cq(gd, &spec, &cq->gdma_cq);
 		if (err)
@@ -1239,7 +1262,10 @@ static int mana_create_txq(struct mana_port_context *apc,
 
 		gc->cq_table[cq->gdma_id] = cq->gdma_cq;
 
-		mana_gd_arm_cq(cq->gdma_cq);
+		netif_tx_napi_add(net, &cq->napi, mana_poll, NAPI_POLL_WEIGHT);
+		napi_enable(&cq->napi);
+
+		mana_gd_ring_cq(cq->gdma_cq, SET_ARM_BIT);
 	}
 
 	return 0;
@@ -1248,21 +1274,6 @@ static int mana_create_txq(struct mana_port_context *apc,
 	return err;
 }
 
-static void mana_napi_sync_for_rx(struct mana_rxq *rxq)
-{
-	struct net_device *ndev = rxq->ndev;
-	struct mana_port_context *apc;
-	u16 rxq_idx = rxq->rxq_idx;
-	struct napi_struct *napi;
-	struct gdma_queue *eq;
-
-	apc = netdev_priv(ndev);
-	eq = apc->eqs[rxq_idx].eq;
-	napi = &eq->eq.napi;
-
-	napi_synchronize(napi);
-}
-
 static void mana_destroy_rxq(struct mana_port_context *apc,
 			     struct mana_rxq *rxq, bool validate_state)
 
@@ -1270,13 +1281,19 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 	struct gdma_context *gc = apc->ac->gdma_dev->gdma_context;
 	struct mana_recv_buf_oob *rx_oob;
 	struct device *dev = gc->dev;
+	struct napi_struct *napi;
 	int i;
 
 	if (!rxq)
 		return;
 
+	napi = &rxq->rx_cq.napi;
+
 	if (validate_state)
-		mana_napi_sync_for_rx(rxq);
+		napi_synchronize(napi);
+
+	napi_disable(napi);
+	netif_napi_del(napi);
 
 	mana_destroy_wq_obj(apc, GDMA_RQ, rxq->rxobj);
 
@@ -1420,7 +1437,6 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 
 	/* Create RQ's CQ */
 	cq = &rxq->rx_cq;
-	cq->gdma_comp_buf = eq->cqe_poll;
 	cq->type = MANA_CQ_TYPE_RX;
 	cq->rxq = rxq;
 
@@ -1428,7 +1444,7 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	spec.type = GDMA_CQ;
 	spec.monitor_avl_buf = false;
 	spec.queue_size = cq_size;
-	spec.cq.callback = mana_cq_handler;
+	spec.cq.callback = mana_schedule_napi;
 	spec.cq.parent_eq = eq->eq;
 	spec.cq.context = cq;
 	err = mana_gd_create_mana_wq_cq(gd, &spec, &cq->gdma_cq);
@@ -1468,7 +1484,10 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 
 	gc->cq_table[cq->gdma_id] = cq->gdma_cq;
 
-	mana_gd_arm_cq(cq->gdma_cq);
+	netif_napi_add(ndev, &cq->napi, mana_poll, 1);
+	napi_enable(&cq->napi);
+
+	mana_gd_ring_cq(cq->gdma_cq, SET_ARM_BIT);
 out:
 	if (!err)
 		return rxq;
@@ -1486,12 +1505,13 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 static int mana_add_rx_queues(struct mana_port_context *apc,
 			      struct net_device *ndev)
 {
+	struct mana_context *ac = apc->ac;
 	struct mana_rxq *rxq;
 	int err = 0;
 	int i;
 
 	for (i = 0; i < apc->num_queues; i++) {
-		rxq = mana_create_rxq(apc, i, &apc->eqs[i], ndev);
+		rxq = mana_create_rxq(apc, i, &ac->eqs[i], ndev);
 		if (!rxq) {
 			err = -ENOMEM;
 			goto out;
@@ -1603,16 +1623,11 @@ static int mana_init_port(struct net_device *ndev)
 int mana_alloc_queues(struct net_device *ndev)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
-	struct gdma_dev *gd = apc->ac->gdma_dev;
 	int err;
 
-	err = mana_create_eq(apc);
-	if (err)
-		return err;
-
 	err = mana_create_vport(apc, ndev);
 	if (err)
-		goto destroy_eq;
+		return err;
 
 	err = netif_set_real_num_tx_queues(ndev, apc->num_queues);
 	if (err)
@@ -1638,8 +1653,6 @@ int mana_alloc_queues(struct net_device *ndev)
 
 destroy_vport:
 	mana_destroy_vport(apc);
-destroy_eq:
-	mana_destroy_eq(gd->gdma_context, apc);
 	return err;
 }
 
@@ -1716,8 +1729,6 @@ static int mana_dealloc_queues(struct net_device *ndev)
 
 	mana_destroy_vport(apc);
 
-	mana_destroy_eq(apc->ac->gdma_dev->gdma_context, apc);
-
 	return 0;
 }
 
@@ -1770,7 +1781,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	apc->ac = ac;
 	apc->ndev = ndev;
 	apc->max_queues = gc->max_num_queues;
-	apc->num_queues = min_t(uint, gc->max_num_queues, MANA_MAX_NUM_QUEUES);
+	apc->num_queues = gc->max_num_queues;
 	apc->port_handle = INVALID_MANA_HANDLE;
 	apc->port_idx = port_idx;
 
@@ -1841,6 +1852,10 @@ int mana_probe(struct gdma_dev *gd)
 	ac->num_ports = 1;
 	gd->driver_data = ac;
 
+	err = mana_create_eq(ac);
+	if (err)
+		goto out;
+
 	err = mana_query_device_cfg(ac, MANA_MAJOR_VERSION, MANA_MINOR_VERSION,
 				    MANA_MICRO_VERSION, &ac->num_ports);
 	if (err)
@@ -1890,6 +1905,9 @@ void mana_remove(struct gdma_dev *gd)
 
 		free_netdev(ndev);
 	}
+
+	mana_destroy_eq(ac);
+
 out:
 	mana_gd_deregister_device(gd);
 	gd->driver_data = NULL;
-- 
2.25.1

