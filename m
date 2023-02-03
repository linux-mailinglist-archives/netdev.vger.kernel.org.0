Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB6B688B7F
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 01:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbjBCALo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 19:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbjBCALj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 19:11:39 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2055.outbound.protection.outlook.com [40.107.21.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAEB7BE6A
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 16:11:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewz1cAzzWFUwX/Vm8Rucp2FmFiCtcV7rXCLtbqYsw2wBehZJyJlIuSFs/RZ49CPq1u/oYl8IOltB4QYLnZsuzMCvbvIRgQT4PrBC/bdPT3Wa10uiv5F+42dVkJnvyP0xcUzK+xLXlz2jL3VrN0WNnXj728bEPidlRFEUpinNBN6oy6FOZdIXbwUvMTcgD8fW9ZEPEbmGNk0rrT/aokUdr3jG1HKJYnwMLJjgAsxoBrUovEWfUKomgpbVEG0y6SsCPp+2bMl9SPMTgwtaIL7NtkosQg4PJ0QXu4XNT8VkeDUt0HS898BZMk4m5ul8e2Pbz79POWsb0UggReBk56lzCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YQqIi7H8HyPsz+gEJxBA09V3olQTtjLB/D4GvWvevZc=;
 b=WjI4QdYTYWS2s/zhSV06bGsX+XBY0zMro3GVD/vlvGz5oMxqjeeL2oX4J/06VUDBVMv6JqL+jzSx4mkhwlr6sPmrTqLcgh1cxq5Bt5rvQJx3tLUvv3wN5gG78HJ47asDVqoAYmHtRjQOAwmZ65tGhXygfwCNgOlUZMG2cn5WCbHYTnYJpZbyJAbzBdd96JOZgs2l6AhgFB+sy2RaaDnMemLzWpUUcD84vjvJ0la3FNH5w96n9KnJtNa0OdAMRgxBcjv86oKWswd1scfJE5qomcsWMJg+wrjWroVkQrmPHMvv7BjBNA3lJBhS8XZ9tiIjphEvhKRdPUkTCL0VokrDKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQqIi7H8HyPsz+gEJxBA09V3olQTtjLB/D4GvWvevZc=;
 b=qdTM78POCox10GAbmj7QcdJdH/7TlUWuR3PLAJKYJgJSX5SDn1npGK5oyX03m4gruigBTt36O3RRARM6uEw1KJS8B9ycTZFRM2gjbf44Dh0oDm5MPB8OGoemnNS9NcbxNwdemWali8mJBFRHPRAlMHMSwnHZ+g/M2rXvVR1DZWU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB7190.eurprd04.prod.outlook.com (2603:10a6:20b:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.23; Fri, 3 Feb
 2023 00:11:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 00:11:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 3/4] net: enetc: recalculate num_real_tx_queues when XDP program attaches
Date:   Fri,  3 Feb 2023 02:11:15 +0200
Message-Id: <20230203001116.3814809-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230203001116.3814809-1-vladimir.oltean@nxp.com>
References: <20230203001116.3814809-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0118.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB7190:EE_
X-MS-Office365-Filtering-Correlation-Id: c9e0e1cf-c1db-4c31-7fb9-08db057b3654
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jTtCxj944RSVuyXnt5hkOkBZBJONdlLjq87LBPiSyg5L4SEy0jEge4Fkps2EAwSuIonSGTdFzRmIm7aW1jlTG3N0eC373lREyOS3Smz5xjaxeuriW1Tk6EHLP0iBeuYtjqb7mGszj9KT3LJUsiLTpRpyRLyRZdeXJYE877bBZMxxAevkCX1SmCbwkVV8MwhwsJjHzbv/v4A/Bktf022l2CfkXyBRKJBn8C0B+jfAQri6CE5QGS5VgFYXqk+j/dekSYLLMrrfOGq7vFmPtA8VRg2pN4oTrGpRhXmUaRBgUpc6b/AdAsEGcYIyOkVJF8qbKiKG3rTIlAFm8ZKKIyYX2nI07jrT03JjFh3GFlOvMLWfkATDwVA2Y8bz+TWoJ6WN1N8dFdN1mc6RelWBAEOuTHChkC1e+FOCo/CboHlFBtbf5Be1WCNsWA/+AlP7d9GkRzZaujQsX/6xnzYNFp1iTJXTMf72NmtzEZ/a4PYa6ELfoR45URfUjzjblqM5xubm5TzxUdVQL9xxB9iIZfVOntkC8ivJMYsgabz0ubjxIx+K2yfVei9cL5UgTeTrKO+A1lzRPBae9i7sT6Y1Fm0MNUEWF1bkLxg5LEo3YyB+Cg0CH9u7eOiGpJJFPb3G3GQHjPA8tXSCWBzM8ygYPK9QHhWz5Q5E7egAg0IPGqfH68hAEnU9RU0B0Iwbq3TSDTHkvIiC1pAVAoHRi/8/YWtHOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(451199018)(38350700002)(6512007)(52116002)(36756003)(6486002)(44832011)(186003)(41300700001)(478600001)(38100700002)(316002)(6916009)(4326008)(54906003)(8676002)(66476007)(86362001)(66946007)(66556008)(8936002)(26005)(6506007)(5660300002)(6666004)(1076003)(83380400001)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e2R8aV7VuknKjx39kKyw31xQzqWYeKGRWbO1sqdEU/hmU+saBK4Uel5pwV/z?=
 =?us-ascii?Q?1Y4Xbf522TF7XpD0TUGAbrdMKbcpTHN4bGWV8jfgad4I2tlRKmMt4oEhFTV0?=
 =?us-ascii?Q?Xqe+RMnYs4zsof+sct0vQQGghknAHSqatejIvg0xMRLZr2kiX8mu3IIQjti9?=
 =?us-ascii?Q?6AF4eJZPpiRN+octDi1wqjJQKpTOhHKK2igiWLlplIJ0dNUF3An/STvs++VE?=
 =?us-ascii?Q?uVC0yGMSIggcLkvHQoXZCKl0mBRDEwtasj2ibgRoKIQcRQ+lLso2Lqag+e2M?=
 =?us-ascii?Q?2ibBlPUsMHrql8fXPWZsee8HM3au4MdnNthAJuPp93FGL9fYJxUGzcflsFkb?=
 =?us-ascii?Q?JDNKBwpxoy4ffPHWiPQzbtM34mHR6tmcJHemJEqcaLnQnnKw3567GjmkyadR?=
 =?us-ascii?Q?Szsn0606T7/UU/weX8A5knFF4yFl4tnzpclW0318T0GBdghtDV0lvfHMyzkE?=
 =?us-ascii?Q?ZMon3ZzJNdaVu2RNmw+4vxbD3I1yYe0rrXkYlOP+k08LWTt3jXDvhjsKwYwL?=
 =?us-ascii?Q?Q6BALfGm9qSqgVksksNKHOMlWjJgSSKTso4Qjiov7JXdPzxBbQvPGAC3lA50?=
 =?us-ascii?Q?RYjRX+ReVFAk8ujewCeLSjqAOs/0kmt+AVGWIcUjJAzrUFzBScVfmD33/j9O?=
 =?us-ascii?Q?99WGJN76Z9rM0/0GyEMBSS1EnLy1Qin+flrNH+KES7jiK0MZad96bu2Z5Q3O?=
 =?us-ascii?Q?tjX3GYHMF2+MrwNnoxfnkEoo5HT3c7o65DxMw1cZho70Glv3WkiibbnUx45w?=
 =?us-ascii?Q?o89Q1bJoPVoWPOGv0Fa9wP/kF0/2b3VQKzexaUEtvC5ca0rM2Hjrq+xVGpFm?=
 =?us-ascii?Q?Dd/t2rkdil6/6/UHa3ca3AfzcNWcYt9gh9/IaNgz5M0flXXmu1TPStqAsw8x?=
 =?us-ascii?Q?E7tp6BS3XXcEcVv203fnvlFlwtS7UqHc8FX9uDAHapBpFy7CaFIjVCVgQWw0?=
 =?us-ascii?Q?qZ2D6QfHugS4NVWxNp1khF/Nyt4x4/9Wc2t7/TUeRWxqg8y7s9vs3UogzyZF?=
 =?us-ascii?Q?5S9HoaVuf64jsW0UHUO+FLLysYtGa+kgzXezzyk5wZY0SCa81bLG2qeJuRlR?=
 =?us-ascii?Q?9SjqEbidIRnv6diyAI8mlJ11i1lURgVhVDHG7L9YJO8mSlEob1vHNP+8o+TI?=
 =?us-ascii?Q?smv5pw3dN0bHvIdwJZm8rlQUfPPAvb/pvbxumQ5pm4xjplI7s8Y5UZNdx4lp?=
 =?us-ascii?Q?8Cy2BFs1WN3MzhEdZul8/pLbeGCPc4MwikLlgcWiSODDQseD4jasLrzMFpTX?=
 =?us-ascii?Q?SMduqZkuMvch99oDXUB9XRDYso9q0r4RiLQ1I1wTO8R9FYnHKDvmtr3U4t+c?=
 =?us-ascii?Q?lisfyLbWXDqMgAUB00QY05d9FWNmnwJQoamVTGNmVjSjvGn2ddPrMe3l8TWg?=
 =?us-ascii?Q?i0X8eqyqwMJ6lJaPS0Y5AHD2O0oMONf0ggKjpQ3p0NNzetTH/bg27VQGpMYu?=
 =?us-ascii?Q?+uzgyO/+Ia4dzWXcHBmrDX5pJ+ZK1fj2O3inodnk+QAI9fLhKaRgeyVftEHx?=
 =?us-ascii?Q?IoEaQQrvlgR4yTjRzVu+7Qhq1k4bjHatftYXDH8TQA38B82Znn0nYLl+RDI2?=
 =?us-ascii?Q?N2tdZ7KyocVcwoXFtTomH7LwFLfEih9l/5z7FpycXTS+ejT2tXKwozzYYvWt?=
 =?us-ascii?Q?Cg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9e0e1cf-c1db-4c31-7fb9-08db057b3654
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 00:11:35.5399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AodVnJRXS//hyVA4SRG3mQhPfSAs7igl1gCYXPbko33gthMWLIJdH6ogm0M4mGdMrrUUaN1W5KhNgYufNXSghg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7190
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the blamed net-next commit, enetc_setup_xdp_prog() no longer goes
through enetc_open(), and therefore, the function which was supposed to
detect whether a BPF program exists (in order to crop some TX queues
from network stack usage), enetc_num_stack_tx_queues(), no longer gets
called.

We can move the netif_set_real_num_rx_queues() call to enetc_alloc_msix()
(probe time), since it is a runtime invariant. We can do the same thing
with netif_set_real_num_tx_queues(), and let enetc_reconfigure_xdp_cb()
explicitly recalculate and change the number of stack TX queues.

Fixes: c33bfaf91c4c ("net: enetc: set up XDP program under enetc_reconfigure()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 35 ++++++++++++--------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 5d7eeb1b5a23..e18a6c834eb4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2454,7 +2454,6 @@ int enetc_open(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct enetc_bdr_resource *tx_res, *rx_res;
-	int num_stack_tx_queues;
 	bool extended;
 	int err;
 
@@ -2480,16 +2479,6 @@ int enetc_open(struct net_device *ndev)
 		goto err_alloc_rx;
 	}
 
-	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
-
-	err = netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
-	if (err)
-		goto err_set_queues;
-
-	err = netif_set_real_num_rx_queues(ndev, priv->num_rx_rings);
-	if (err)
-		goto err_set_queues;
-
 	enetc_tx_onestep_tstamp_init(priv);
 	enetc_assign_tx_resources(priv, tx_res);
 	enetc_assign_rx_resources(priv, rx_res);
@@ -2498,8 +2487,6 @@ int enetc_open(struct net_device *ndev)
 
 	return 0;
 
-err_set_queues:
-	enetc_free_rx_resources(rx_res, priv->num_rx_rings);
 err_alloc_rx:
 	enetc_free_tx_resources(tx_res, priv->num_tx_rings);
 err_alloc_tx:
@@ -2683,9 +2670,18 @@ EXPORT_SYMBOL_GPL(enetc_setup_tc_mqprio);
 static int enetc_reconfigure_xdp_cb(struct enetc_ndev_priv *priv, void *ctx)
 {
 	struct bpf_prog *old_prog, *prog = ctx;
-	int i;
+	int num_stack_tx_queues;
+	int err, i;
 
 	old_prog = xchg(&priv->xdp_prog, prog);
+
+	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
+	err = netif_set_real_num_tx_queues(priv->ndev, num_stack_tx_queues);
+	if (err) {
+		xchg(&priv->xdp_prog, old_prog);
+		return err;
+	}
+
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
@@ -2906,6 +2902,7 @@ EXPORT_SYMBOL_GPL(enetc_ioctl);
 int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 {
 	struct pci_dev *pdev = priv->si->pdev;
+	int num_stack_tx_queues;
 	int first_xdp_tx_ring;
 	int i, n, err, nvec;
 	int v_tx_rings;
@@ -2982,6 +2979,16 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 		}
 	}
 
+	num_stack_tx_queues = enetc_num_stack_tx_queues(priv);
+
+	err = netif_set_real_num_tx_queues(priv->ndev, num_stack_tx_queues);
+	if (err)
+		goto fail;
+
+	err = netif_set_real_num_rx_queues(priv->ndev, priv->num_rx_rings);
+	if (err)
+		goto fail;
+
 	first_xdp_tx_ring = priv->num_tx_rings - num_possible_cpus();
 	priv->xdp_tx_ring = &priv->tx_ring[first_xdp_tx_ring];
 
-- 
2.34.1

