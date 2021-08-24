Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397013F6359
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 18:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbhHXQwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 12:52:18 -0400
Received: from mail-centralus01namln1003.outbound.protection.outlook.com ([40.93.8.3]:59676
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233454AbhHXQwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 12:52:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rsyq2IsB5TtkU7w022S5FzHa2MN4pxzHuXHDf4a11jyyfyi0scqjLAN8C/q+soMAsFvh5JAxO4jguf9SG5wOm3sOiE+tgF+/rXARAoYTwEiOh5nHTnpl6lREibxTYDIgsNetlzvMGJTbIHf5PGOys0K5nO8mekBa47Q2eYR1bG+yBUHoW3PUrpyJNOHnVn0yICjzA0+3DWP+DimPwt7pdXAyWUqPL3PyD77I601+Mr3uZYpWvt0BjgIHcxnNoGmdIBB8qIf0OWajJJqSoi4m38A1+tg8pOFRuzC+f3pQxGdBJSJkOKviQ6Bnk6N2b3cmdm+HS3MY/x7RCLDKCxHfkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rnpFooEe3yqanIC8qztDi29xzpmO85kOlyGn9lug7VI=;
 b=BtOScOOSlxpvLtPTY4AXmDHOADpE6Gfl/SuVeaHuMIwwziGbHxbW/R2VmLtrHE5evTBrsY/9Ly9SA3trO2PJBAtgO1b6EoA2iym0DZpVb+65SfgFlGf405Z/JcK+Q8QCHUsRDb+gnD3QiVkfa5XhCNhp8ToCZEnIgQijVVIHW+TspHH81ibtRJgdrycltuDlG7jBfUFPvENZs3SWTrR5yXD6ZzIBBXNYWowvbXCGStCb0KDPb0MZt5MtBzRhDTHkLf7r21RxyJIaWuv51B+RZu6Kq1mPJgunrKJ36/6xyVFrxUY6GiYO21RJZAmfy+9Y3A/lJoW0pjXI2jTzXl6Vqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rnpFooEe3yqanIC8qztDi29xzpmO85kOlyGn9lug7VI=;
 b=AGvVzx2uyppWEy5NftDyNZKcwjQriBM9kEM+goPYCoJpUiom9t4LTYJDVDR7kWObAWkb5X3n9PXR8wh9+wj6nQqS4MlmhQf7iu+MHRbrIT5/YfGiclNDkChKG4AOWzSFuxvyTLBWIkIUXj9ULYNDHEcTzsYDlqpPAqm2PctsyZM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
 by DM5PR21MB1765.namprd21.prod.outlook.com (2603:10b6:4:a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.2; Tue, 24 Aug
 2021 16:46:53 +0000
Received: from DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::a09a:c9ba:8030:2247]) by DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::a09a:c9ba:8030:2247%9]) with mapi id 15.20.4478.005; Tue, 24 Aug 2021
 16:46:47 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        paulros@microsoft.com, shacharr@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2,net-next, 1/3] net: mana: Move NAPI from EQ to CQ
Date:   Tue, 24 Aug 2021 09:45:59 -0700
Message-Id: <1629823561-2261-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1629823561-2261-1-git-send-email-haiyangz@microsoft.com>
References: <1629823561-2261-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: CO2PR04CA0133.namprd04.prod.outlook.com (2603:10b6:104::11)
 To DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by CO2PR04CA0133.namprd04.prod.outlook.com (2603:10b6:104::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 16:46:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00dc4b74-0da1-4500-2055-08d9671ec33d
X-MS-TrafficTypeDiagnostic: DM5PR21MB1765:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR21MB176552071CA1A75C581B91B8ACC59@DM5PR21MB1765.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GpiA+fEe0MqD+6GPZoGPe6ESpxC/LATtllxtbyDmqADpFUsMBZd8jmvUARf8lRitXax92DyZnrs1MNmvsgKj+3y+o6Qi87DVIftYffoCukFb33L/TPf86+zMF/yyU1PxFJxtYvuU9oGH0qQrnZid8gUdYL0Al/WriaqzfjUBLQPN9qt1roCbOnYHmVUhjRH3toj8hIhEIXfr/k6Yi8eQmcCR3xI+oCmRKSK4E7MtgVsHFpX9B3UtwaP37wFG885sxa5nlP6Yn/bE6lwtX83g07l2S1E+Kh0KKo+C1f2al0WBGGQZtGKQdS3/kVLw20hANNzPwzneexFnHCUZIZ9+/iSQYxHTbbeKgKOOgXobV4zHySTnD/Q4kSC761Fq4l+oxty12XGP+pbzu7ymItzARdzYONJqqpQc9rbC5wg1pswLo2idwLfGc1tWbNpbgjzyFrRhiwvO6uyiBcfXaBz/FbVneGpGThPYb0bSINnpgHwoxCgrdiPukJRvPz1noLDabbFYhuQ7sLrj8hpouKCB3MO2VYIEE0aDR8duCI3lZIVv2pwZxDde2ehPfzdedsJp1e/gbiNEkoepNV5VjN0/Tbg5nVZx5QSJGFJLp1bT2zHUmgcqYDujCNK2SBQtrJNlLxt4uIT/WPB+xvuSH2x0JIWcwGr1XoyBcRQaajVwcV/04tKGtW/LkXxJuNQG9MuJ7CBXEL81vzPO2GzljvWr+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1340.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(82950400001)(5660300002)(30864003)(6486002)(316002)(10290500003)(82960400001)(956004)(6512007)(7846003)(36756003)(2616005)(38100700002)(66946007)(38350700002)(66556008)(66476007)(186003)(2906002)(26005)(6666004)(8676002)(83380400001)(4326008)(52116002)(6506007)(8936002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tvv/MMYmUHbp+OBS8oNtk7Pwex9I7KyFkpMjTXzW8/O8aq4M/o/AVjGDAsx8?=
 =?us-ascii?Q?iS3c/UI9q3iNprYERGHFuJsb3eGghEK6Ad3W9COnP2Drmw2xGV7Tp4FYe+5I?=
 =?us-ascii?Q?+xba749S61tXEoy2VnjE/L8guv6nP6KQi0VAAJQhz7wZ9cKTl44WP6VVEWL8?=
 =?us-ascii?Q?S+U1ID7gVR4ZnsuJ7y5iTCHOsQDxKlaNEhH2siKp1DPjONx35HsFhYAN1xdt?=
 =?us-ascii?Q?gUhBMAP6I5F8wXwjR1CsiY75rXYtXC/6bWnm4++7zyb3MeD/HWMwPArU4qcF?=
 =?us-ascii?Q?HAjkmuE2SLb0NR63yeAuwYSltU3kYXQdhlUvswFwXccPDzsO5PmsOLBdVq45?=
 =?us-ascii?Q?uhU6ilsuyikcNsjfQhGPI5/fi6h/6V0KGvXe6WQHLVZChJaOzJCoDl8gqSI1?=
 =?us-ascii?Q?+FwuhZknvJFD/oTdIdqrncgYX5C9MIJFIawJmsJIqHIBDq7ZhS/x9NXKW4az?=
 =?us-ascii?Q?luEWumeEnKRxCFYZbVmZ4BwfyWujkWGJ1PimhjATrAiLZvundvgk651/KTdV?=
 =?us-ascii?Q?9gzMvlFnJ/vlJamib/00zxRhTPDhKZB8+bRrk2pxThLErL8kQyAp5O1vWwhT?=
 =?us-ascii?Q?QJ+oURtrnZQ6PSE6f5b5cxfsdRTrT9RZa52y6YxCkmHCPK11pgE7ugPBISY/?=
 =?us-ascii?Q?bE9NtLDJQLCcWMfY3LuuKJqjxOyDeUzx7c+qm1Wo3Ff11JMagUQpsrlgGziK?=
 =?us-ascii?Q?g+WcUJlFxUsmgpTbnOFLD5qYMqpM8MvhLTSVF/vQIpnrWnuzAx94M7DPLbCI?=
 =?us-ascii?Q?DJ5ySLhrXpSoK3evS4UEVx1zpqp5cGtwpzWw44RRXbNaMnNc/TI3gn8IxLVA?=
 =?us-ascii?Q?ZRa1yX4gC7raNsSDUei0eURo0kRuXV2UHwaBO75SnQDh0nI2LyJMb355KiNd?=
 =?us-ascii?Q?eHolMAkg+pq1D7himlSbKYwEPaZVMnygVbjA+NS+694v7Vev4BELEULFETA6?=
 =?us-ascii?Q?k5z1bPeHvjPm4k+N/veWwvvYKCepT3qtXkr72sCha0pQzH0IGf3NLTbj7YsV?=
 =?us-ascii?Q?I2AYa3nK1K+EI/A2x9Pjuxr6t1TM3TV37csCP6aESLMU0cS40Uuv77uUCrlD?=
 =?us-ascii?Q?FBB7vy8pRsLMAkapziPeEbQoMXMO9Ec+Dgc6QVwKfp8CLUNfS4Jy+wT2NXux?=
 =?us-ascii?Q?hj/H7r4sXys5H4R7u3hweidLywk6+UssQqzhH2UqsQFm2SkqpDTKTSu+nVdT?=
 =?us-ascii?Q?3bIVRmZZcviJc4HUDHX78o8qsF7yq3wtJYwEPkX4cpFz/MCfG8V9Ad856QHm?=
 =?us-ascii?Q?ogtuitSAFvg2Hqq89VjvrsKW9PTeSFXG90kzcCGKcTZ0H7qHPQ2tLh6UzLcd?=
 =?us-ascii?Q?MMHupt7cwNyhWRFn+JL3JDdq?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00dc4b74-0da1-4500-2055-08d9671ec33d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1340.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 16:46:47.3939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xVeIX+FjFu8JsAgUJBS0QHTASBnWkuN8qMIMiRiPsBvFeSIE3S5518qdxJcsT6XhCA48adwDkpQPhKfSt++blA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB1765
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing code has NAPI threads polling on EQ directly. To prepare
for EQ sharing among vPorts, move NAPI from EQ to CQ so that one EQ
can serve multiple CQs from different vPorts.

The "arm bit" is only set when CQ processing is completed to reduce
the number of EQ entries, which in turn reduce the number of interrupts
on EQ.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
v2: Updates suggested by Dexuan Cui <decui@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/gdma.h    |   9 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   |  55 +---------
 .../net/ethernet/microsoft/mana/hw_channel.c  |   2 +-
 drivers/net/ethernet/microsoft/mana/mana.h    |  11 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 100 +++++++++++-------
 5 files changed, 74 insertions(+), 103 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/drivers/net/ethernet/microsoft/mana/gdma.h
index 33e53d32e891..ddbca64bab07 100644
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
@@ -406,7 +399,7 @@ void mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue);
 
 int mana_gd_poll_cq(struct gdma_queue *cq, struct gdma_comp *comp, int num_cqe);
 
-void mana_gd_arm_cq(struct gdma_queue *cq);
+void mana_gd_ring_cq(struct gdma_queue *cq, u8 arm_bit);
 
 struct gdma_wqe {
 	u32 reserved	:24;
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 2f87bf90f8ec..560472fa2d00 100644
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
 
@@ -370,48 +369,16 @@ static void mana_gd_process_eq_events(void *arg)
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
@@ -442,20 +409,11 @@ static int mana_gd_register_irq(struct gdma_queue *queue,
 
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
@@ -549,11 +507,6 @@ static void mana_gd_destroy_eq(struct gdma_context *gc, bool flush_evenets,
 
 	mana_gd_deregiser_irq(queue);
 
-	if (mana_gd_is_mana(queue->gdma_dev)) {
-		napi_disable(&queue->eq.napi);
-		netif_napi_del(&queue->eq.napi);
-	}
-
 	if (queue->eq.disable_needed)
 		mana_gd_disable_queue(queue);
 }
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
index a2c3f826f022..5341dbdb726e 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
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
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 83eb28c132f3..8643d8cf1d5a 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -696,14 +696,6 @@ static void mana_destroy_wq_obj(struct mana_port_context *apc, u32 wq_type,
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
 static void mana_destroy_eq(struct gdma_context *gc,
 			    struct mana_port_context *apc)
 {
@@ -746,8 +738,6 @@ static int mana_create_eq(struct mana_port_context *apc)
 	spec.eq.ndev = apc->ndev;
 
 	for (i = 0; i < apc->num_queues; i++) {
-		mana_init_cqe_poll_buf(apc->eqs[i].cqe_poll);
-
 		err = mana_gd_create_mana_eq(gd, &spec, &apc->eqs[i].eq);
 		if (err)
 			goto out;
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
@@ -1188,7 +1211,6 @@ static int mana_create_txq(struct mana_port_context *apc,
 
 		/* Create SQ's CQ */
 		cq = &apc->tx_qp[i].tx_cq;
-		cq->gdma_comp_buf = apc->eqs[i].cqe_poll;
 		cq->type = MANA_CQ_TYPE_TX;
 
 		cq->txq = txq;
@@ -1197,7 +1219,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 		spec.type = GDMA_CQ;
 		spec.monitor_avl_buf = false;
 		spec.queue_size = cq_size;
-		spec.cq.callback = mana_cq_handler;
+		spec.cq.callback = mana_schedule_napi;
 		spec.cq.parent_eq = apc->eqs[i].eq;
 		spec.cq.context = cq;
 		err = mana_gd_create_mana_wq_cq(gd, &spec, &cq->gdma_cq);
@@ -1239,7 +1261,10 @@ static int mana_create_txq(struct mana_port_context *apc,
 
 		gc->cq_table[cq->gdma_id] = cq->gdma_cq;
 
-		mana_gd_arm_cq(cq->gdma_cq);
+		netif_tx_napi_add(net, &cq->napi, mana_poll, NAPI_POLL_WEIGHT);
+		napi_enable(&cq->napi);
+
+		mana_gd_ring_cq(cq->gdma_cq, SET_ARM_BIT);
 	}
 
 	return 0;
@@ -1248,21 +1273,6 @@ static int mana_create_txq(struct mana_port_context *apc,
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
 
@@ -1270,13 +1280,19 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
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
 
@@ -1420,7 +1436,6 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 
 	/* Create RQ's CQ */
 	cq = &rxq->rx_cq;
-	cq->gdma_comp_buf = eq->cqe_poll;
 	cq->type = MANA_CQ_TYPE_RX;
 	cq->rxq = rxq;
 
@@ -1428,7 +1443,7 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	spec.type = GDMA_CQ;
 	spec.monitor_avl_buf = false;
 	spec.queue_size = cq_size;
-	spec.cq.callback = mana_cq_handler;
+	spec.cq.callback = mana_schedule_napi;
 	spec.cq.parent_eq = eq->eq;
 	spec.cq.context = cq;
 	err = mana_gd_create_mana_wq_cq(gd, &spec, &cq->gdma_cq);
@@ -1468,7 +1483,10 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 
 	gc->cq_table[cq->gdma_id] = cq->gdma_cq;
 
-	mana_gd_arm_cq(cq->gdma_cq);
+	netif_napi_add(ndev, &cq->napi, mana_poll, 1);
+	napi_enable(&cq->napi);
+
+	mana_gd_ring_cq(cq->gdma_cq, SET_ARM_BIT);
 out:
 	if (!err)
 		return rxq;
-- 
2.25.1

