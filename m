Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7B9522FB5
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbiEKJn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235441AbiEKJmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:42:17 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10053.outbound.protection.outlook.com [40.107.1.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DBC1CB29
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:42:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q5ke+O7d3Nyd8H5ZOE/hSCDvdJiqQVRkMwCVXqZPNNVAGL2vxJh7XkF/CL7OF5qza9wxUy4ED0Yri9BHRn7p8DxLqzFy/IujoT0eB7rTH5jF12IY4LkGDvdD1rg2RgpD0uNSRyckVMKadU6J8LxJ+unUCSC+B1wXVfqIj9NrzTg3xTZMjbNQGntEEmufv7ZlSN8zv2W/W6MRV3v/eDvGZUtby2yu+wtwe5p0uwRXSuWbAPpb6+sqyDlV+dO3V8t/7BtE93mKC1YKvRFMNANDwQ99f5GJmII+RpJnQq8DVS8eP+BrNavTJreQQLBcWtRG7MnDylyJzt9Y+ND6vsYcWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GACyZUtnBGhhFoMtfkru0ePCYuSnLSGSqcyrIP2Mx+s=;
 b=UwohP0sp5+iJiMO5N+jKbVKAtcs7pusDfo4hfnEUQXTdKuTbpkAWupeJeloS4lsGqYUIIA30bL5UfbMQyLTQNT9rRJ0MnXH4QXogAQc0hfyD2LlcruPv8e/fED1EpY3WR8c/wbw3dyMMU/TLG55MDpd0DY0T5NkWjs9KUhezd8NxZaIH2zkRhxFqv37L1s3DQlb2ZMPd8J1fq1/LxzVZCuVu2vyK4Sz0a+JoP/UKbi39ciLTAErtdZMMJRof0a9smcbjo0EbQ42GajjJwUuxIO11rhLpTuoa7eonh6c/v1pgaFYBhDCTamWF1E0GS6NFnjvlD46xwD1P1J2ntSLpSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GACyZUtnBGhhFoMtfkru0ePCYuSnLSGSqcyrIP2Mx+s=;
 b=qYFzHzgrWHe4NURrZEvAXdAhCvtliznFuamIJ1bWk68859cCjBjRmQwV7lJo5rZojAlXKfpckhXRd/9plzlkrzLGp7fjgsX1jNlba6meL18K8K9CFqvd7crPXiFEKLp9jlPhHVDCfCxB5BkivPUoTe9MTl8dAIb8D08N8ObctxE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7928.eurprd04.prod.outlook.com (2603:10a6:20b:2af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 09:42:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 09:42:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH v2 net-next] net: enetc: kill PHY-less mode for PFs
Date:   Wed, 11 May 2022 12:42:00 +0300
Message-Id: <20220511094200.558502-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:20b:50e::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8630a07-7daa-43b3-8afa-08da333284fe
X-MS-TrafficTypeDiagnostic: AS8PR04MB7928:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB79288B750EA37F184C9E584EE0C89@AS8PR04MB7928.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hmpbptxkGRhUV2SykmpT4yMOvrBhxs8igaXMOdtIrFhGZLfHCk5OWag0xjjV6wShK08XpsPhjhk3ajn6qVT59vKrLy/sxn7u7IhTjwQ5ImEi+GIr8pqULLT32KV+6TVhrDtYJaX1lEs0GF6Kfm+gfegbflyMExOIjPbInxyK8nNwiutaVYg/DMQdKrIDJmVbTS4KzRBECDg/DGSGkSWVBzi28ZKNzgKk+kgsNRHU1F7NrLoPYUenuzllY7GA14gpQ5gNw3wb0bk+k4YmKhSj9605Su9vuRy5mR4cuJf5soeuqfLqq6QgKv07I6oI9zTJhuV3bXAWJfY9l6UF3UTyJm5mfN8oalDUVASyk7gZSTWvfdm8RcSSm4v+g1fO+yXHLRAqU/v84DQ1q64uQX9I75WnNviueJiLiuG3z1+JCfPBtY+XqKrAdyJbWpt6NQ7R0/ke5IaVz9NcPuVCskTW54D1t/fMdithVM8Ah48QhoYNWfy0sD2DRZ0HS8AUpLOVm/OfTgzlfPAtawNKMKhpguu4ZaNPAOjMYxnkz1CU9afK19fLorH4ibAcQmPwX4f/QL2tSUyIuSwYywMOLnKvLN0F6x9xzdJ6sOMoxyBpVnbALQMBat9wimMBrRJ+FUabuFzaIh1jhirl0heiiHMFGGV6miI3RdY9Z57OX10PM/0mIEckcUZz5L3e2dFhFoHCUahmg0t30Nl0QRW8gc/9PQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(52116002)(6666004)(36756003)(83380400001)(44832011)(26005)(6512007)(316002)(508600001)(6486002)(54906003)(6916009)(2616005)(186003)(66946007)(66556008)(1076003)(66476007)(5660300002)(8676002)(2906002)(4326008)(86362001)(8936002)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YHKRqwbzZoYvpMNh0Tyfo9WrNPnVz+UbuL+x3/kw+Cn7LOgZr/r+okd0Jimi?=
 =?us-ascii?Q?Bb8a+9sGinxLbek93qLqcslyeeyqGf6P5hrfaIcY3PIy0+gKako3x7yF7s1n?=
 =?us-ascii?Q?6Z0K4U3btrySBF4q+cpcbVx8HIeZ+CWLB1YF7OMK+IsnQY/HQtJ4d8ekDPTk?=
 =?us-ascii?Q?FegQ7h5FHTeYOIkctH8IE6eSNZ8v6qGx0Q9uzLsi3M7sniVz9Hg20DoU/TNq?=
 =?us-ascii?Q?4GmxKz1sHUvxGFQ3UBMu2zGlIhfCkKiFENSGPyaybzQzZvDgiLhuztqdRDU+?=
 =?us-ascii?Q?dLsZEdO9R4yv2ZkW/jlkL0F239Y05nbQOBSs3i04rlbBgDz/yvGBt3YH6Jl8?=
 =?us-ascii?Q?I+gjLdZvLSl/mRsN5lLPMkHbokHW8IWv8052Ef/JZpBmnMMdm+6cAjZFbePF?=
 =?us-ascii?Q?ft7cGN4jaaysk7qe+O9paJPb5UZfbq8jY2fs0IKTzFOcSrACQlYomUx1SZVG?=
 =?us-ascii?Q?VeEQiDlmQVaWjS5lQu78W7+KqcqSv0xnbDs3rfrBxbP1AWo58zSHnqzN2btb?=
 =?us-ascii?Q?ZNolBQGgzx+YsfdG1Rusgl1kEL1MUakXkdi7fJg3yA8djhjYQYfLfqlnMagy?=
 =?us-ascii?Q?3wmhP2NJM/xI9Y0V7OhYAU0MfHqWsEn3t6Q4d0L+JCVYQTYiBO5SHpKPvj6U?=
 =?us-ascii?Q?g4hA96+CauZ2FlZNxnoTxtdbt6pCm9zRNVhQA12Qmf67bHcNnXzWWyStdDm8?=
 =?us-ascii?Q?LJ648Ndd2d3+Ur6D2ljiXrKsTAprkmdVQp+ZGQNCicDlzs3TO/9e12ugIJLg?=
 =?us-ascii?Q?UxUY0p4KosyeAF5+lOlcbWHlETTemSqTeAbupKmWP8JMXIB26M2wFfiVyIDK?=
 =?us-ascii?Q?ZKbFAEamrAnX0NVeQFsmntCWzNYAmHq6DEJn+gRDZGzbbuHje4MMaFJy5PTZ?=
 =?us-ascii?Q?fvL1rx58P1mBZpMkMDZcoPuvaRAUr1zugs+2t70dXewl2tXeoSCRVyMdj/am?=
 =?us-ascii?Q?TRYk9YvlFkV4cE6CAwQWXU06IMKJ9pzLag0jr7QMw9E1YAO7kRz8NNYP4HHe?=
 =?us-ascii?Q?mJYkcGIqpbSXGPH9TmBP7QLgwP4ahkyRThMf/bWqAm7AQXi5zuSxH6laHPWz?=
 =?us-ascii?Q?G5uEoJ87V3mJmM3FhbNTSXeO9V0yI548Rb36BPhk9YFkOuqM9E/iRgz3CTy/?=
 =?us-ascii?Q?RURFVUh49KwZ3Ph3vXYLtA5OiemnTl8EAKiiYLxNnI6QMd6C+muWcRVWpNB0?=
 =?us-ascii?Q?zesmKSxW9fuWRMikYBpv1R4n++6Tq9REbTbbC0dS989kj4nuWtQ3IAKbH067?=
 =?us-ascii?Q?hmv6NMnpXf314Yec/tUp6cYXHHth+3wKsQEojqu5XulUXMX0rPFRcKg5rimm?=
 =?us-ascii?Q?QgBuPZS0Xvw4vGt8jQSc5luzLByoP+MsDCl0pCRhDopT9x2WF2yJKVW6ZbAr?=
 =?us-ascii?Q?FDan5KsO4Pzez3qI5QsRckP+R7J6crL7O3N47RU7Ohf3rZDSAfx3kCYd4iov?=
 =?us-ascii?Q?1pUpqbThAJBnwITeH1lbe9r4bx+ulAA6JhhRp3julmZqpqRNBEPbjWOrVVvh?=
 =?us-ascii?Q?YFFiu3+mu/aqtFW4RDbP1zft1DgKS2R9VpypE16+xfwmhQu6ai+iaObjyRiq?=
 =?us-ascii?Q?w5WFLW7S2SoEhg2U2BnT3rDvp+9GoTcMzk53lnMg5jGBmQBLdOSz47kjGZy2?=
 =?us-ascii?Q?sgFipHZmMX3m+k6umTN8Q3NVeK4NeXm5hI3vd3qxi5YPcofQQ7EIR/j8K7WU?=
 =?us-ascii?Q?0lXFwLH1b4u72xSiYBCGx8yuUQtynF+KKitfrB7eTp5oTHV5UG2/UqivGTPy?=
 =?us-ascii?Q?kLhqvYcCESHvEM7BTE/srASES9ph5+A=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8630a07-7daa-43b3-8afa-08da333284fe
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 09:42:10.4157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZzncxfrKEHMn77Y9dhDsSwG6SiQQdfZhvn8dHL4dq/bNBFS4JrVYKHKIgkwcSbq6z/efolJ1T0YlbF12dSz3FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7928
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now, a PHY-less port (no phy-mode, no fixed-link, no phy-handle)
doesn't register with phylink, but calls netif_carrier_on() from
enetc_start().

This makes sense for a VF, but for a PF, this is braindead, because we
never call enetc_mac_enable() so the MAC is left inoperational.
Furthermore, commit 71b77a7a27a3 ("enetc: Migrate to PHYLINK and
PCS_LYNX") put the nail in the coffin because it removed the initial
netif_carrier_off() call done right after register_netdev().

Without that call, netif_carrier_on() does not call
linkwatch_fire_event(), so the operstate remains IF_OPER_UNKNOWN.

Just deny the broken configuration by requiring that a phy-mode is
present, and always register a PF with phylink.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: fix of_get_phy_mode() error path in enetc_pf_probe()

 .../net/ethernet/freescale/enetc/enetc_pf.c   | 24 +++++++++++--------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 7cccdf54359f..c4a0e836d4f0 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1105,8 +1105,7 @@ static int enetc_phylink_create(struct enetc_ndev_priv *priv,
 
 static void enetc_phylink_destroy(struct enetc_ndev_priv *priv)
 {
-	if (priv->phylink)
-		phylink_destroy(priv->phylink);
+	phylink_destroy(priv->phylink);
 }
 
 /* Initialize the entire shared memory for the flow steering entries
@@ -1273,16 +1272,20 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		goto err_alloc_msix;
 	}
 
-	if (!of_get_phy_mode(node, &pf->if_mode)) {
-		err = enetc_mdiobus_create(pf, node);
-		if (err)
-			goto err_mdiobus_create;
-
-		err = enetc_phylink_create(priv, node);
-		if (err)
-			goto err_phylink_create;
+	err = of_get_phy_mode(node, &pf->if_mode);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to read PHY mode\n");
+		goto err_phy_mode;
 	}
 
+	err = enetc_mdiobus_create(pf, node);
+	if (err)
+		goto err_mdiobus_create;
+
+	err = enetc_phylink_create(priv, node);
+	if (err)
+		goto err_phylink_create;
+
 	err = register_netdev(ndev);
 	if (err)
 		goto err_reg_netdev;
@@ -1294,6 +1297,7 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 err_phylink_create:
 	enetc_mdiobus_destroy(pf);
 err_mdiobus_create:
+err_phy_mode:
 	enetc_free_msix(priv);
 err_config_si:
 err_alloc_msix:
-- 
2.25.1

