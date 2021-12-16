Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136434766E4
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 01:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbhLPAT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 19:19:58 -0500
Received: from mail-cusazlp17010007.outbound.protection.outlook.com ([40.93.13.7]:10796
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230469AbhLPAT6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 19:19:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbVmVvGRlnOEbuM7FjXVKl7Sq20FDSciN4f5cUeu8zYiw/fQ3ZFQ6iSUY901L+vqspqSh9/6fTpdONm7xDW4qqPJURMcqLxenyYE6ohSYVIymvP/UTFWDtH96u8i/BLur8GYulVVRMsPlPpubM4/H0vY7du7Vvc+3cyGFY3Kbmi1d+7UvtEDCJ//yuS+ALTc8nsImMkEqDWTOO48H+ptPNIfDC/677vFZujS13kfP6F7vjDZshn/p08wOcuJVLOaeC1eROBheDESmGDOGy8uM/rv26/c59Z8Wkuh8nD7iBNftg2S/FR2sYcGoP2vM3qu3w2X8mNPZCQFFftbpjtC8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/a6hCnNmJZh+5FewJJnPNALYmASr15OjMP6SaPVGeg=;
 b=PvRyDp2xfNwvKLGUkK0IFws/lAemIVfCR0AQ3kH1vAW7Y9PKcEAAJt9RLNzTrby0ereN84IlZjWs2nk3bVCTAWLfEfkUQNNIQwweMt8mkoAxWy6zzKaOr+XSnLUMrXhHbYcNP+DKNyKzuVZl6hZfF+nXoc90bcTcYBsyh+kUBiu15aSN3x6Nc7upwkOI4GW+t/sff9GyXXiE9Lk7ndyRcwoyFwHjw2bR7lXAQBMQZ1kWb/pSMCR29KNedon+7EeYHd+qUwkpVqcMpCjHROtsjaDxwtuYiC6yFsVrG9vjHI5lGaRbSCoyJzsxtHZBzZxaPveGN1YH1OU3y0eyNYQYkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/a6hCnNmJZh+5FewJJnPNALYmASr15OjMP6SaPVGeg=;
 b=hGKt7Cu0R4YSvIRS5QNHr1+HT24Xy57h5qJRqi4yR4SdseSx0c6SmOxbk1+9s0ELnnUX1xsLEm5EsiHBVUC1IJsegJnNnxS2XXrkGIWiuq+KyJcsYpXLAeEZ6ZqLIkq2OdBgRHVvhkol0Btd0FfMmNxnsrbwmE4bePYct9OAj/I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26) by CH2PR21MB1511.namprd21.prod.outlook.com
 (2603:10b6:610:88::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.7; Thu, 16 Dec
 2021 00:19:54 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::8124:8007:a2ad:813c]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::8124:8007:a2ad:813c%4]) with mapi id 15.20.4823.004; Thu, 16 Dec 2021
 00:19:54 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        haiyangz@microsoft.com, netdev@vger.kernel.org
Cc:     kys@microsoft.com, stephen@networkplumber.org, wei.liu@kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        shacharr@microsoft.com, paulros@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, Dexuan Cui <decui@microsoft.com>
Subject: [PATCH net-next] net: mana: Add RX fencing
Date:   Wed, 15 Dec 2021 16:17:48 -0800
Message-Id: <20211216001748.8751-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: MWHPR10CA0064.namprd10.prod.outlook.com
 (2603:10b6:300:2c::26) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15b1dae1-c3d5-4aef-3a1e-08d9c029c883
X-MS-TrafficTypeDiagnostic: CH2PR21MB1511:EE_
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <CH2PR21MB1511858C90E85D8BC240459ABF779@CH2PR21MB1511.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aSIJ0hjMbAZVJKPPmBZKd1bNctc08p7C9xDdbrLnu+J+iHEPWyh6tWg3CvlOpQB9CpaK3IH+zQJDlOrdPNx0SyjWbLLZrTE+6nAHuI0X9rs6S9gvL2wT5ei7zhPYk/mk7ClQTXlM0M3IMktGkmuMYyVQBebovXsIo8BDu4i34yXQdScWjafWTsHTns3UBuKBCW4ugQeihk/nSFor2povz7Mz4hsv4CArGA2yq7jigqu8+saZg5V8GSCcPYYPxSskxSMFr3ko/Ikw0+zk90/KpSvDfVofaDfq/co0oW4qiTwoZsc6FiiNAdtjNJXusa19FqETXogOIuIgRrfz/uzjUfxkORqbEfVvIyHUgDbDvojAMgYKJHCP124wl7+v57r6FPd0MnGl2LEH4d1gwQ9DipXEoN2CJYEjyTo19A2ZBvgZkjA6x+05jQXJ9CNEzLt7YvsDQZcgFzn8WaCufIT5AUPvx1JnVQIbU2gj30HEdXlMR41MYWgGMa7M1QiqfybOWKcD49cMkaLZdwU0PfOBLlfdHNutzd9VCMy4vdmYKaxLcWvn92y6++0D3qtFvs5AoAITMeBbHHtrLJWyTK3eWHscIy3BbC8iYV/jUYMQwDk008pavrTSQTgj/O8AJXkhm0c+yPXtywZQX8nPjYc65mxIB2UX9Xrhb7xs/q6SXpaQAlQGBqW0fDjbEm9dDHcB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(3450700001)(508600001)(10290500003)(6512007)(6486002)(36756003)(82950400001)(52116002)(82960400001)(6506007)(8676002)(316002)(66946007)(8936002)(38100700002)(6666004)(7416002)(66476007)(4326008)(66556008)(2906002)(86362001)(107886003)(2616005)(83380400001)(1076003)(186003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i8vzo57vwGkpK6isbF71OBVQrcUheLzquMAmss2uwe82z/ZCOrk2TY8JdVHv?=
 =?us-ascii?Q?2p8FE6D5SwsH+xBMzcKAvtWfDhj+coQhk3Q2t9YGSo35g23HOk5wA/hBUB9F?=
 =?us-ascii?Q?QqcqLhsXjemTEEtXH5Zeq/4CTIaZets+vQ0r92+soDMQ2TRWrmkH9faBIljQ?=
 =?us-ascii?Q?868zh0qh3HKYJkTHgXlPTBugg2+ZkBd92lSkjDzj/eC7yGgL7M9jNyhRHvUk?=
 =?us-ascii?Q?CBeGbPR7At4xbppLTP3eprMtkEoRgnBZzqIPrYAo+Uox7vkTrhKTt+7Lz2+J?=
 =?us-ascii?Q?lAT4jmUS7XCsGtx5sYSN+W0W7HxYH1M4dHjZUNxB2FUtejumi3a6FeHyey/2?=
 =?us-ascii?Q?ouTz7wVOYNuKHihRQC5QVO8jNfr49/3WlGsPA1621mlkEzN4sxBWh8o/A6QK?=
 =?us-ascii?Q?nbiBsyZrHi22iDfwDXQZf0uqTIgmtPv+OkY9a61Sw3MBPObG+SiI2lFbRll+?=
 =?us-ascii?Q?SLRF8jDwxeBOdFnvnwZbvAwHoPEiVTO2UmloSYlnyHMl/YZ9QwxlNO6gxtt5?=
 =?us-ascii?Q?1EhZVBPBZcKZ0cZaWXvHGUIn+NVIp2dFjBZxuZqTo6sq6hlv9NYS7Z4nQ7RR?=
 =?us-ascii?Q?OZmGcLMjJDlVG8CZWPtVW2QjTMLds71qcgluiE/f1RvXJmveIe9SY119FAcv?=
 =?us-ascii?Q?9Nq2a+QoaNGYPgQfuPE9yl6fNYAGjUjZDIhqtH66NiIEydq44de+oNT1i0So?=
 =?us-ascii?Q?JH20I5YY31RJ29AlJ+f7IbEWB4rM4O5ErYHY1mjsYkmQNAPQ4a2yqSNRxEUW?=
 =?us-ascii?Q?FBsOQf2xMZtnP2FTgAhLFIU2DpgAPNSQ9J9SNDGl4yyWACZdsT+1bGxYijQM?=
 =?us-ascii?Q?XEdeiQKu4oTx+NWw+n1rW2HUNsJREddPL/ezPWkJPB/6UEppGcJr5IpQN6lZ?=
 =?us-ascii?Q?RLymYFy5zp3LPgcBe/h++8zqArOn9KKlCuChh6+3FLZWTZPUZZRxaHdlWXkw?=
 =?us-ascii?Q?JSxU3N30KNWqS7xhhsXk3tTJGXiVdoE+/34oBLUQ2RI7Ye9fLUR5UgE+5+oq?=
 =?us-ascii?Q?6/Trg6krUWpDJKTdoRG21tHZgZ/NS3hZ4Z/UjmBQ5fg6SOR+Osrn1Cs8sF4u?=
 =?us-ascii?Q?QZgpMOkV2JVm1bqTbq6Yls52LGOpz7eR7TuurkPJiLS8RkK4xzPrZOEtUTkF?=
 =?us-ascii?Q?lxUZkhSuslr0c0cwKvnR8+XjMHUgu81RKjVEj90aDob/6fSUY34F7DyJugfM?=
 =?us-ascii?Q?GdS1i8BFApSZfzsi40zfmfcqa88AHnBwzFyMNcDgMDy8HDTXUvoff3exi2aZ?=
 =?us-ascii?Q?DFUNqJHkumZ8fiR3uV8WaTeKcFAq6fNDlu3192ZBTOBXqPO68uhZWjmjUwAe?=
 =?us-ascii?Q?xdU8DIhjHfcY/qScHmYbxlVeITJEcct823Z/6KwyeZHgM6MqbWiU7KIytNk/?=
 =?us-ascii?Q?xlcMuQeiTTJRdibExC555M6zOW/VkttbqA686BZIlEFhwj29O8Ky2tlxWGpJ?=
 =?us-ascii?Q?pc3jyTV+amnaqoAYZG0+5+wrFi2zJapqLhy186ykyl6pRKWUM6I8XiLzvriX?=
 =?us-ascii?Q?TFhJV9iCXv5JlSS6R59jwkCN9VDsp6yi1BUW0lQRBKwD/RnwFzxh9m9tu77o?=
 =?us-ascii?Q?3lGYbALQSPulgx4XaEnaMn/bnAVA5jQGMIlR2hPkVT8Xdq4eYpsUFREzE0Xr?=
 =?us-ascii?Q?biqd1zAcFL1q2z2arafzc+aublv46cKQJHeKSQn80P2eRd+jcLtBdDw4sOnE?=
 =?us-ascii?Q?xJPPbl2zkLA4BW6xbWmi996mpuY=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15b1dae1-c3d5-4aef-3a1e-08d9c029c883
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 00:19:54.5282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eDjPsIm8sKP4x1HrALXLiOoC9JwMAZ58ox/4jv7idM8u1E2TO0/wnwaOD+6HAed6/JLUbypR3nw/Q4/NHVMJ6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RX fencing allows the driver to know that any prior change to the RQs has
finished, e.g. when the RQs are disabled/enabled or the hashkey/indirection
table are changed, RX fencing is required.

Remove the previous workaround "ssleep(1)" and add the real support for
RX fencing as the PF driver supports the MANA_FENCE_RQ request now (any
old PF driver not supporting the request won't be used in production).

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana.h    |  2 +
 drivers/net/ethernet/microsoft/mana/mana_en.c | 69 +++++++++++++++++--
 2 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index 0c5553887b75..9a12607fb511 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -289,6 +289,8 @@ struct mana_rxq {
 
 	struct mana_cq rx_cq;
 
+	struct completion fence_event;
+
 	struct net_device *ndev;
 
 	/* Total number of receive buffers to be allocated */
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index c1d5a374b967..d37d35885579 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -750,6 +750,61 @@ static int mana_create_eq(struct mana_context *ac)
 	return err;
 }
 
+static int mana_fence_rq(struct mana_port_context *apc, struct mana_rxq *rxq)
+{
+	struct mana_fence_rq_resp resp = {};
+	struct mana_fence_rq_req req = {};
+	int err;
+
+	init_completion(&rxq->fence_event);
+
+	mana_gd_init_req_hdr(&req.hdr, MANA_FENCE_RQ,
+			     sizeof(req), sizeof(resp));
+	req.wq_obj_handle =  rxq->rxobj;
+
+	err = mana_send_request(apc->ac, &req, sizeof(req), &resp,
+				sizeof(resp));
+	if (err) {
+		netdev_err(apc->ndev, "Failed to fence RQ %u: %d\n",
+			   rxq->rxq_idx, err);
+		return err;
+	}
+
+	err = mana_verify_resp_hdr(&resp.hdr, MANA_FENCE_RQ, sizeof(resp));
+	if (err || resp.hdr.status) {
+		netdev_err(apc->ndev, "Failed to fence RQ %u: %d, 0x%x\n",
+			   rxq->rxq_idx, err, resp.hdr.status);
+		if (!err)
+			err = -EPROTO;
+
+		return err;
+	}
+
+	if (wait_for_completion_timeout(&rxq->fence_event, 10 * HZ) == 0) {
+		netdev_err(apc->ndev, "Failed to fence RQ %u: timed out\n",
+			   rxq->rxq_idx);
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+static void mana_fence_rqs(struct mana_port_context *apc)
+{
+	unsigned int rxq_idx;
+	struct mana_rxq *rxq;
+	int err;
+
+	for (rxq_idx = 0; rxq_idx < apc->num_queues; rxq_idx++) {
+		rxq = apc->rxqs[rxq_idx];
+		err = mana_fence_rq(apc, rxq);
+
+		/* In case of any error, use sleep instead. */
+		if (err)
+			msleep(100);
+	}
+}
+
 static int mana_move_wq_tail(struct gdma_queue *wq, u32 num_units)
 {
 	u32 used_space_old;
@@ -1023,7 +1078,7 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 		return;
 
 	case CQE_RX_OBJECT_FENCE:
-		netdev_err(ndev, "RX Fencing is unsupported\n");
+		complete(&rxq->fence_event);
 		return;
 
 	default:
@@ -1617,6 +1672,7 @@ int mana_config_rss(struct mana_port_context *apc, enum TRI_STATE rx,
 		    bool update_hash, bool update_tab)
 {
 	u32 queue_idx;
+	int err;
 	int i;
 
 	if (update_tab) {
@@ -1626,7 +1682,13 @@ int mana_config_rss(struct mana_port_context *apc, enum TRI_STATE rx,
 		}
 	}
 
-	return mana_cfg_vport_steering(apc, rx, true, update_hash, update_tab);
+	err = mana_cfg_vport_steering(apc, rx, true, update_hash, update_tab);
+	if (err)
+		return err;
+
+	mana_fence_rqs(apc);
+
+	return 0;
 }
 
 static int mana_init_port(struct net_device *ndev)
@@ -1773,9 +1835,6 @@ static int mana_dealloc_queues(struct net_device *ndev)
 		return err;
 	}
 
-	/* TODO: Implement RX fencing */
-	ssleep(1);
-
 	mana_destroy_vport(apc);
 
 	return 0;
-- 
2.20.1

