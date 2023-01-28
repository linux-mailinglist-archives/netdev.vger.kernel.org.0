Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B1F67F375
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbjA1BH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjA1BHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:07:55 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2089.outbound.protection.outlook.com [40.107.8.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180DA1ADCC
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:07:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDy/FGOJI43FQk96MquuuqrBPv3iFIiVhzsLInxsRM66QmKBQOCLcoHGVfa+xGNKyLMxCAzGeCYr01w0L+u+MXrJfxwzufj08uPDfvLHXF2hQ3d7G25tR/b1WGbndDmxWLDap3rKe1mo7vcEEM1k15p3XE3ywM2Hyhobhzg1BmJSELHkzKhOmAhnkHZQp7gQnafZD5kmXdzNvj28rcqLsO17jLCWzPybUAK1VKRIQVY3O5stbus9NEicRTIyJgTaEIo/ec+V7+YMw4yEYq6pXERDl6oVlJHWhEMRE3S+XOKJAtqirsU/uuC7162144EQVnGcM2lku6ZefdQ21oXT3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F/cwxpkDFqYRd0KtlBJqEIpYgzWS9S4gs3XH5G7eF/Y=;
 b=jzVm5pdljsNLoXlTcbSdaWlPNHamRI6nIWe3xJug/RX+sSTpO6254KDJ2aTAoz71OvTp0r9z8hhsCjAVn7qFpzMrqL3j9o+bgaS2gA/pLOQ07Mvkdgvna2Vhgfiki+DO31/244hNzqduTqJ8mLW/Jm/Mmym8IZJ0kuwVsuvyriyAqe3ON7YsLglx7rWiJ4IpsHuD5gbWf+HCDKHeHpE/gqsiDVsNNONLwDCLKa7GGfJAxSNrv72FZ6jf/iOSpU6828L/of3mr5FBz9n4LcrJYJgx1AnW9lKcxgSLZKNzyvUycYbmfB57GWnKkBnFp1qV34TCGrk2gMAZsp4QIQUpGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/cwxpkDFqYRd0KtlBJqEIpYgzWS9S4gs3XH5G7eF/Y=;
 b=kAB/OwOGyRxDnRwDYxrRd0BoiGrJlcWCJOTOcXp0DLP3XqZF0146AAf0ZDsjEVL5M/9sIj/tgbdnsKtRKOVgJFJ1tl9tzcMAjupWL/am1BeI2hvwLRIcmnBqLI04A9jJopu0glNldVrpX2GO4haU2OogMgrMikdu/t/x11VokQA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9203.eurprd04.prod.outlook.com (2603:10a6:102:222::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 01:07:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 01:07:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 02/15] net/sched: taprio: continue with other TXQs if one dequeue() failed
Date:   Sat, 28 Jan 2023 03:07:06 +0200
Message-Id: <20230128010719.2182346-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0128.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9203:EE_
X-MS-Office365-Filtering-Correlation-Id: e29e73b5-d047-487c-1181-08db00cc1361
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g+PBmDfmpsUyZSomwOyPacwm8XXiwxDq9u120qpx72/g6G6quDfkDAAf38JtcGk/tOwUUDjGCiBsVPxOem3c4fASqhHbH5b0Mv3o4wpUHa9VMRAkQorddIMn160UigXqWeg2DKp/+A8rIqtxxhG/vwk2ESnTQ2EpaKBhaPcCu6EO9sWZ3LOJ6EVja+0Jv+TACaMksatgFfmx69mVRoaBmfS5D55T3oYugI9mrCgLgVOpIJ8OxgyDkHoZ+pCx+952ID3tlngUaYuGE9V5gG4AIUHt+abtkSmJLe7H8S+bOdftRGc9UnBX96h0LtBG+C5vNd0h/2ti9t4zVGXBsWBPzIBwRSUl/nLA3Mj8OjpA9FRAZBDWBRglmEYyMXsekKbATJrwTWIEIsuD+RkbpiB2gku1HdCDHIUxbKPCWlY8wibPubWOjr/bWPM327gD1asOdR1/LOCxINGVv68tKy1uFMNK6VZbXWWSECWIIEXoI7OOs2RvkR33xdzsGWMTrQLT2ZvzQ7XsdEqQUfG/2Td//4GXrAxmVQjrpII/KuJV9qJij7qkTcp41KiCqWWatwKPrXa2cSa06kINbtiYW6bcb4HAETJveE5vzx8aa6n7nOtWfOH8zDK696hwwERPqSXOC3OxYeiZdhX5w5ErUu5kyBqK3JwGm4VWJ183X0pZkj1cDuztYUtGFsY8xAXgVt6fm115T/Wwomw4DUroA7670w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199018)(66899018)(186003)(36756003)(6506007)(1076003)(6512007)(26005)(38350700002)(5660300002)(38100700002)(44832011)(2906002)(6486002)(6666004)(52116002)(2616005)(86362001)(83380400001)(6916009)(4326008)(66946007)(54906003)(478600001)(66476007)(66556008)(316002)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1H75koATdtYicWa1la7SqljDcwc443ekPAd6fi+RopjYrwKtsCMTe21slrmB?=
 =?us-ascii?Q?Vp4zfe3AkJ7guPDfyH91eTbQy0oG0LHu48v1lk65o8ZaULkeFJguNBNtGVwm?=
 =?us-ascii?Q?TJuvEPfgCaIxoyi6pRSOMR1wPozeIEvvz7rnnFFR5GIu3eCSpqjOOmvR/9Xs?=
 =?us-ascii?Q?rZ5ZBm0pANNahuzE415Rac1tzKD3zHYcUbnPMo60VSZuYnO4HhDSeL7LgVV7?=
 =?us-ascii?Q?vc1vbe0wwKZwSlw4GGFBSsFN0zWX99fPViZaldLmJ0ep2MIe3yMO4onXR7G4?=
 =?us-ascii?Q?1veV9rWuoS7ZPO16ryFCHi09uf5QAAmLUosiI2JRAX0yoa4mvET/SAe9pFg9?=
 =?us-ascii?Q?2KKdRwtCCdDCrprXE+dPbvUVnKl4rutk7je0dHYGx9uszYyR4gPv6MA+AHZY?=
 =?us-ascii?Q?WhlsI5rQxsjmBk9OdnvJ8CtFuqXzw3h4O5Hme/LEhasreYRHPENFWAE2/G+q?=
 =?us-ascii?Q?qh4kNsDTBe4t/Tpr5w5f415o9tGV4ZRHS2KoTY2CggPCwlOZXr37unEzlCVr?=
 =?us-ascii?Q?NIL663K03J5vSzivmWIUxKiy1o5T5xyv7xp+BxiCJoEStHJJF5O1AYmSSXCY?=
 =?us-ascii?Q?jv+Z8Gt2lrZ0epVSz6husqaKT6ylm4H26NQ/+BS8jlMMBNoexEdGrrhgdttZ?=
 =?us-ascii?Q?US+hyiRWGg5ho5cAdNX79IyXGtlwUntmLPolqRFaG9hcMaaFoTIk8Uj7ixza?=
 =?us-ascii?Q?jlWfywbnoEpKPcnt+vBZnpS/0bh/XkO7q/TDDIw+lamVLVb9p1RnRU+ava90?=
 =?us-ascii?Q?QOcZze9wXGZ99u4zX4PIV3KPC2lWlAckDoZGfrNtjQxgzCJV7tkW7kE78gHa?=
 =?us-ascii?Q?6YUQMiI20uK8ZcXhbW0V+iXtb/nzMS44Ox0/hfkrdiN7aEbeQrlRiHuURg5u?=
 =?us-ascii?Q?JQYOu+C+npH1SU6GB5AcXHOekRTKMLvi9yjT3OM0XGnOPsfdE6Ap8pJi+k8K?=
 =?us-ascii?Q?ujtUELVM0D0yrNDe+I2MxgzIejGPWPA/J/2noAukq0NW6Fk/CY2+uceU4GRB?=
 =?us-ascii?Q?9fV09h33dOS4OA4nHQ0N4BIAnQ85TpbNq2y232XLx29pcIw0y6cvqqLBtjMN?=
 =?us-ascii?Q?89MYUe0+v6mD0Tc407l1rjkgw432NCKCxWN/4nnT/4oeszADt6JuheFUWfRf?=
 =?us-ascii?Q?Sma3JgUyMYGX4Jc6Mj8lc9AlSKnHj/dk+S3+JD9tMroPJrtQtQ5QMpl6GJWy?=
 =?us-ascii?Q?u/xul1CNpiw3WkkQB4KdXRIWGZQGubN860pOpaC44hwp1/lKv03ERhXTLQ0v?=
 =?us-ascii?Q?gtuxjxaOHBamUSjCDRY9sZB+yXJMvj/BROyGdku1z34jtszT4sNB83bb26/4?=
 =?us-ascii?Q?9eg92HE5eNG5pj9gKzNmU4gFGR61jshOJUlFKFaWC/T3DjtkFBGLyq4VacIJ?=
 =?us-ascii?Q?fvWdRvgMxwN6L75jA1JJCoN7OHja8d7W2GcF5RjAngQuUwFvxiLdpD7CBOUi?=
 =?us-ascii?Q?oQHnbJEv9imS2zkQnd3HkmlNuLcXqX8wrW1mcwjzQ2lTXvkGRkp+e+3gfPyJ?=
 =?us-ascii?Q?J8yKFOv61mRKDAluRZv12jRpP2LzhtcuSpZyloxNwlOZlDBcVSbDVEPM7kEW?=
 =?us-ascii?Q?eml9lUg9oZ2W0apCloncVb8Kw0FVr3MwrbQ8tCOcfNHEJAjOVTtv2CDuDyAi?=
 =?us-ascii?Q?0w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e29e73b5-d047-487c-1181-08db00cc1361
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 01:07:50.3076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pMsSVmwT8Tdj3dUk2zi4aUY/R6s0kI2rnOaOX1xgDvAdbVtPiZQy9/M+3YmN27PaW2cAjBNxKUPOHUEYUaap+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9203
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This changes the handling of an unlikely condition to not stop dequeuing
if taprio failed to dequeue the peeked skb in taprio_dequeue().

I've no idea when this can happen, but the only side effect seems to be
that the atomic_sub_return() call right above will have consumed some
budget. This isn't a big deal, since either that made us remain without
any budget (and therefore, we'd exit on the next peeked skb anyway), or
we could send some packets from other TXQs.

I'm making this change because in a future patch I'll be refactoring the
dequeue procedure to simplify it, and this corner case will have to go
away.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 375f445c1cfb..1504fdae723f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -585,7 +585,7 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 
 		skb = child->ops->dequeue(child);
 		if (unlikely(!skb))
-			goto done;
+			continue;
 
 skb_found:
 		qdisc_bstats_update(sch, skb);
-- 
2.34.1

