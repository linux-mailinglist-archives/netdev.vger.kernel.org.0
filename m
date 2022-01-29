Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0423F4A2B2E
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 03:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352128AbiA2CEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 21:04:47 -0500
Received: from mail-dm6nam12on2094.outbound.protection.outlook.com ([40.107.243.94]:28512
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1352136AbiA2CEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 21:04:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XlC+nrjT8qKoRTthr3c24tXw0CCJZgS1ZBaMXFMu/nhwTkGhnJ6KsTONBZWDiBA8P9axIR0YSjZMTAsTA1Wt+b0sDcjiT2IfknSlSJCpPWvQIA5D1F09/X/TEyRZJmj3TNT/vefutRkwFZxROR854VS0BUX+zatoIkPX5CqhoM0rk6kN/kIbRSc3bMAU/3ZM5HtESZsNQB7XspbRfkYa68h9AcrlN4Deuw1vnvItLsxmXs+XwL+s6Q1nHxnraAOP4MZnBZLnrqcYp98JRUUY/DGOMb0faN7y7hJX7k2ApoxKU19zehx+Kp8ivukQNtwxOC+EepfamvAjq1Wmb7mijA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBtUJ0WthM4WNS/PwB/119hMxcAj9Gvk1JO/v29ONRQ=;
 b=gRJ2kqpQHX91Gp2O8duo4N+Nlvit1chqhZPijTvuf9fnDX7Sn2erIWna7j081WY4IF7avv1pCX1+bsVQ28melrlD9/Dcoz4I8P0PQSDOxVudp4mdM1oqfQJDeBwLZOiID8QYslsHQwpyLfmL0jNZKmo8JN6W1wk/21TN1roVsr7HEbpJLn5O8ujEohZA8vqbquzIIM1gcpnTCTTab6rfNuv54pKZCoD8oKDDoPSVT7tB/1+zw4yy9/862JTO/tsSRkBWDDJP20ypABNexcONNbSByOXjQ8m5j0cLMIKvDTc6iKUx5lqVp5mB3iKei4VqS18lBZolrMFLZK7Z+5X8FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBtUJ0WthM4WNS/PwB/119hMxcAj9Gvk1JO/v29ONRQ=;
 b=Z2eD+DYLPyK9mBpO6bs7OcEl5wfWDoOMUQ7zzlG+a4DstmlRs9bX2Mo0iNQSM4ijl+Ya7hUOODfz0UJ+nkd9BOFaKFA7KMO3vRFOgqkUkt8cIvS8typ43FU71S9kjtz+wnnMsS8Az1mUAsFeWsfgu4LSRSAia7px3VmBHKfNiOw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
 by MWHPR21MB0191.namprd21.prod.outlook.com (2603:10b6:300:79::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.7; Sat, 29 Jan
 2022 02:04:40 +0000
Received: from DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::1d9b:cd14:e6bb:43fd]) by DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::1d9b:cd14:e6bb:43fd%6]) with mapi id 15.20.4951.007; Sat, 29 Jan 2022
 02:04:40 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        sthemmin@microsoft.com, paulros@microsoft.com,
        shacharr@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH net-next, 3/3] net: mana: Reuse XDP dropped page
Date:   Fri, 28 Jan 2022 18:03:38 -0800
Message-Id: <1643421818-14259-4-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1643421818-14259-1-git-send-email-haiyangz@microsoft.com>
References: <1643421818-14259-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0311.namprd03.prod.outlook.com
 (2603:10b6:303:dd::16) To DM6PR21MB1340.namprd21.prod.outlook.com
 (2603:10b6:5:175::19)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bf149a6-ed80-4069-7c9d-08d9e2cbb570
X-MS-TrafficTypeDiagnostic: MWHPR21MB0191:EE_
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-AtpMessageProperties: SA|SL
X-Microsoft-Antispam-PRVS: <MWHPR21MB0191BA8AFC8E1CDCBAAA9138AC239@MWHPR21MB0191.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K7r+T7CvNdaKP+AEatE9oyPgA8ifke7QLLdpV3YqCtQdXIlcnvVQ8rqkjlPUeUgB+ySJqMGuXzjcHC6HE3G1c3wmBd6/8LVCeRWbvQBpyabE7AM98gdr2yj0vOpbFVA75PaWABOsfAk4RleGD3Yk8nM5GYx3wYz15rSIV80UGhozEhtGIHDjaAw4ftVCtPkHwDv+Kx0b+iDBZXAm7+tznRY0IrFsFkxdkKZRgUoAG/MgmzE05v3DnKnYMBzdzMDwUEpkkFknrsKYlGzlIqpaNiB/YZr7oAi7+eItgYUYYxrCuyV1bXDWW1pNOk2EkqCp7Txy/4yferKkoEr7rItJRp/fqAuk9Ft72s+cNI1mHL9WjfnC8at3R2N8eqn8Bqa3itMJWeUzcU6sofEFfBUkp50vYI6ArC5wtXOyK983v+L2McXCh5mFsuYDj6bmWf5p+J6rEv6gDtttHF0g0lQe/11boXvUgsdj3MOhGmJI4qycjk6lh7PkXLHEV39XDgJnk09pwqI9wDKn/TCVHnZa5xeyedmBaGWkGm902EyfHLnf4OfI2vw7RJqkDFJAthoDq1tKM+nB3vDI35qjnILbyUUbzQEmcRHY8OMrEuZ3JMMEl74+gXd/YAGhajtcxe+3BUM0WWiQIQorA1kl1STYnKct1wBjZfv0auOuDdWQnBc8D0SRbYliLHbKoVtN2HoCx0PR/qkgOfmPExhp4Y9oGOCVvtTy58m7SwflNEEz1r1aqnOZZfSlPS9MMrQF7HiH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1340.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66946007)(4326008)(66476007)(8676002)(8936002)(5660300002)(38350700002)(38100700002)(82950400001)(316002)(82960400001)(186003)(6512007)(6506007)(26005)(2906002)(2616005)(508600001)(36756003)(7846003)(52116002)(83380400001)(6486002)(10290500003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P/NMUhZLGkiOollksnYXfl+7KCLAmIvzCnKvSqF0c7EQD6TC/c+FtdDvc6Ye?=
 =?us-ascii?Q?Gwta2ew/Xv48ybU2f4io3GpGH8TLZTKzUbrEGWRAfQ0deJxxPH2SaYGsW2Nm?=
 =?us-ascii?Q?1pQ6F5UDfxwxHWYm/fFQvWSdu03z17wDMXKz3zFm4rufa1PHOrpQG0XMlaq/?=
 =?us-ascii?Q?GVBYUbQ1vAeonj4X3PnQfucYM3X8SCDTcJ0j6IvRNWBTjbq4st/liuCNB+v+?=
 =?us-ascii?Q?jchF93D8NLddcmA4aJuoeBtyOgwasSDhBj1w1ofHav85kjwyx/e+Q5F8yfrz?=
 =?us-ascii?Q?z6baF1g4fnpoRQVP3H7eMu99h9EimJBz2vcXpzrw3N89YIejWLCAVvqV8+TO?=
 =?us-ascii?Q?dCFSBmCuCrQMUSsLsD4x1u0G9iOgQoahXnQmwaNVZFe/sZiQh4og5jc5Pq/w?=
 =?us-ascii?Q?F1INxY/EzIz2xKolToU/Te8+TBSbbolUQnMT9qauW2YAgVZUqSR/NDqvu6m7?=
 =?us-ascii?Q?Jhdnq97pF6j/1B844YM0nK03L6qdVrMsRfH6fYrqdPW5/GYgsgenlCD3fyY5?=
 =?us-ascii?Q?5KY3FM8YZFCVzh8MtEacrYm1xzO61viHgfnIpSgJ8g6C0OLRIkBbZWHGMPUj?=
 =?us-ascii?Q?H0atVX7F4AlAR7Rjw6oUKkthy2rgzhSlaH0WMcF0nb8n3aRIpGjLqiQi4a1W?=
 =?us-ascii?Q?f/e2zZ3scTmsTvfetrnGeBCHIjeEQ5JtbhbfAJk9U0UYTOEeGXdY7NHPoMfl?=
 =?us-ascii?Q?8MxdU5A6JlEL+KvBrosnLYPV5Ab+Dl3gjqfu7KeR/PlhnEY62JHuEC2PwtKp?=
 =?us-ascii?Q?qw3rrmx5+lexISICnJVWusiXA6Bx0VwoT1Iq30K8SBk8j79K3HsXLnuc4IGT?=
 =?us-ascii?Q?TTiNJcUzQpdaCNY+FjhzsQxnGJKqGvyH8Y/H6ibS9/3alv+SMdbTP+mMAeVA?=
 =?us-ascii?Q?7CYuJl5eiSbA9iPOtbz+z4BKgAr0VvQ2AQ+nNldtoUA57aBMDVZdEaNQH3VH?=
 =?us-ascii?Q?aUwisS1+mG9/wkfkMJO8qriGNFpTH2UwTonb4ArvIHFYI3Es+e3mnDdiW3L6?=
 =?us-ascii?Q?mXcSzJ2vXG3Q3eDZKS3hVXpTTSk0rg5hdwNZonNrGi1Mg8WR1Xhrpx8OxVpo?=
 =?us-ascii?Q?86wWOCTNC+vBll/igOU7+66Hytm2bbFIkQteogSOn8wttuAt6q6FXxA+HJTx?=
 =?us-ascii?Q?aFygfuf5aBo0+9ZUthmtWAplYPGBofQikJxglJQhLD1YSLpBo7d8RHPvhkuO?=
 =?us-ascii?Q?8d+jXIRpiXiqfEJK5gec0i1nvAhuMrmpsUOaHsb4iDXYkYViYIIVtY1F43ct?=
 =?us-ascii?Q?o04C+nvJlFdxHMbPGiA/iczBpPE38ZrGM9TBfPCJkNg7D9CkVl0G1PbZulNd?=
 =?us-ascii?Q?YGn0yMnZUCO9Y94Hoa14+hnmvHQtoEC7sVF5Hot6LV74tKpwyEu7EDkfQLue?=
 =?us-ascii?Q?kvZq9jpBgwkqyLpAmJoeqxik99xVEHkVRSa2a82U4Q+YvQu460nX6khpOnXJ?=
 =?us-ascii?Q?nSctnt04O6go3u79kiA+ZRs9Eax2OtKdY2HMOFYEsOSotVY5rVBfA9lwhKhc?=
 =?us-ascii?Q?d4dv7dSPzrFL55IHZrEtOSwsq/1dHuzbipLIpK5qP+8RBAN36cdtSazhigmo?=
 =?us-ascii?Q?IEfcgzu/YjeKJ/KQBdvISO5GE7TYh3Zfa+90sRtnY7AOvM7NxGrivkKsk1kb?=
 =?us-ascii?Q?n9zhGwQUZRXhhX7aED9beek=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bf149a6-ed80-4069-7c9d-08d9e2cbb570
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1340.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2022 02:04:40.0922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0qJ/rC6Di8Lefd7FgFIBglfWJcaSOrm3EW+ejmCWBJpfnzASaXNYHLHhIHxrEl8uDXHIxUI5t/02zjRcM5SZ+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0191
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reuse the dropped page in RX path to save page allocation
overhead.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana.h    |  1 +
 drivers/net/ethernet/microsoft/mana/mana_en.c | 15 +++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index 8ead960f898d..d36405af9432 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -310,6 +310,7 @@ struct mana_rxq {
 
 	struct bpf_prog __rcu *bpf_prog;
 	struct xdp_rxq_info xdp_rxq;
+	struct page *xdp_save_page;
 
 	/* MUST BE THE LAST MEMBER:
 	 * Each receive buffer has an associated mana_recv_buf_oob.
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 12067bf5b7d6..69e791e6abc4 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1059,7 +1059,9 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 	u64_stats_update_end(&rx_stats->syncp);
 
 drop:
-	free_page((unsigned long)buf_va);
+	WARN_ON_ONCE(rxq->xdp_save_page);
+	rxq->xdp_save_page = virt_to_page(buf_va);
+
 	++ndev->stats.rx_dropped;
 
 	return;
@@ -1116,7 +1118,13 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 	rxbuf_oob = &rxq->rx_oobs[curr];
 	WARN_ON_ONCE(rxbuf_oob->wqe_inf.wqe_size_in_bu != 1);
 
-	new_page = alloc_page(GFP_ATOMIC);
+	/* Reuse XDP dropped page if available */
+	if (rxq->xdp_save_page) {
+		new_page = rxq->xdp_save_page;
+		rxq->xdp_save_page = NULL;
+	} else {
+		new_page = alloc_page(GFP_ATOMIC);
+	}
 
 	if (new_page) {
 		da = dma_map_page(dev, new_page, XDP_PACKET_HEADROOM, rxq->datasize,
@@ -1403,6 +1411,9 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 
 	mana_deinit_cq(apc, &rxq->rx_cq);
 
+	if (rxq->xdp_save_page)
+		__free_page(rxq->xdp_save_page);
+
 	for (i = 0; i < rxq->num_rx_buf; i++) {
 		rx_oob = &rxq->rx_oobs[i];
 
-- 
2.25.1

