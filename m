Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E288688B7D
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 01:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbjBCALg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 19:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbjBCALf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 19:11:35 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2059.outbound.protection.outlook.com [40.107.14.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4429A7B790
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 16:11:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZaevR1K3S2oeKPNl/M0RtDnIQASXEm+HJX55tbXqkoQ+ZJe8e1hzF1ew/PfLXTnqbySosBxq1Ca6XhuAVb3tx+ohnnyZ0gAWyFpoWlaJUmyl0X3913PHUaZbpzUozI9enJzOUiRiEac2ZBhOHNA6nkLRPiGhKRBzxpcwEfM7yFHdy+OQUgVt1ztzzQBziD7+XZxcf4/TarlRPPhRLI/3CxRAF6w8dAFLHCdRw81uf3BKGlTjqtgyY0qwmIb46AfDshHaefAqg6FQbcx+skLRxuEJ70BiENjPxQpRWjc9fMi11CAhQReRVlKhPDFCnAsX7GWIzSncW8q2j16Mqcnmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C7xZKmdjHhzPusb/UPJxUgYlITKMowgtfUKLvD8f9uM=;
 b=Az6h/V4+O+CDrw9yQo8nMubncygspnlXi0wR5ESYKU4Ujst68WIQscFx7jtA8cctaBK7jfg8T/JFIe4qUWGxv8idEeB/B5eur8/amJmgGR9HtisPygQ+WES30hXmjXOHEUdGABJ5xiblNypF7fKEuFCjzUzxUdIH9IDG0BW/4lLDclesGr4pgJnCqkv9qHjxqj64fV/EoOTPL3wO09aCX2JAPeSDNKGZ1zqxOe2t10DJMHjv/Foh0qSK+7hs5/c/UK9L6aGCH/wgPHsGBtcMFqQVztui+2hU8n8r4yCQmWvfP1A3JBxlS3LwhiMaW+Fd0wESrQU3T8FFwp0RqycNlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C7xZKmdjHhzPusb/UPJxUgYlITKMowgtfUKLvD8f9uM=;
 b=S/UHaiBBWF6baMlXNl01z7NUcnFAj8It+H3ZCnEjUFx1kHayorI/Qgy0s32gNwo06FD17M6gjBerpTF5Q5TR7vDVG30wrlYYiOm3siVzmggt398XnKzKidjtD+Iv7Ird13x8N2+V2rj2LKim1kuXwOgdmMmvaJWMPPqfU9gQom4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB9128.eurprd04.prod.outlook.com (2603:10a6:20b:44b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Fri, 3 Feb
 2023 00:11:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 00:11:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 1/4] net: enetc: simplify enetc_num_stack_tx_queues()
Date:   Fri,  3 Feb 2023 02:11:13 +0200
Message-Id: <20230203001116.3814809-2-vladimir.oltean@nxp.com>
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
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB9128:EE_
X-MS-Office365-Filtering-Correlation-Id: e5d0e618-9645-4fa9-4327-08db057b3405
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hon9HcnUFVPCYviX4TpJ27xrwvJWjxhzuP6NieQ2n6Fz192V+BNEFh8I9Lg6frB3Pe0d55TLHCFin7yFZ1RzVIaRqiOopP81XJ/miyVA5dAw8BPO5V0zFPAEczUAvkVRKitZRB5IA4ak3OLm2yfS/ErVVseAo8vNl28/P5tFbosjdddlGip7mUGfMNor8w1OMnwxOgbtbTc6oAc4oWGpdKCmqxYjf6QgOlM6gyI/O7rYulcuvN2AOA26+Wk44HpQgOukqUmA6vAewHecjn+Y8+eQHawgsObqgppJRfCg+Na06Q8gxjEZPh1TV6jrJXYfzcprBir7smykLRYuA2BnQzFhT3JpOjBq/Jl422iXb3dWrFJ7W0yeauBYVFVkwU6k3zi3VJGJQ79PY/NQzemLJdjT/kp5w8lSJBse5B7Muk7ubIDXa+vZZG8NCG/FAf2nO3QT98FexIoqruyPcGx70Q2/6cBTYol1LxADPKFtK9TXOI/eajde9LEDZav2tEd+oLMWmNsbO5KBW9R6UolvUXN3ZtTi3R6hX0NStfyg28f/+NPpumZVtTkxmaJbk82xRWM7YcIEPz+aR5WLMByP5xIPNYPcEV7o/5wT3pYoEsex1l4eic2UsFeY9sRlEayl2A1iur7S8HOeQEs/z8al9bgFYOo3XVvlNIwMvSv4SiPEGXd6IbxOOJvfRy5HFSdR3L5YiFU3t6orz3gGFIQuFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(451199018)(2906002)(44832011)(26005)(38100700002)(38350700002)(52116002)(36756003)(83380400001)(316002)(54906003)(2616005)(6666004)(6512007)(478600001)(186003)(66476007)(66946007)(6506007)(6916009)(1076003)(86362001)(8676002)(4326008)(8936002)(66556008)(5660300002)(41300700001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KgYoeEFww4dwiUnSzIrCb780Ft8E09m0OQRix2k+aoSfbMQrEbpYY4Ip31zs?=
 =?us-ascii?Q?Q/kotspxJ6gzJOXgbx6nqsAjtNF1HZ1L1+raki46iU8fGUKxlZNCce9pY5XF?=
 =?us-ascii?Q?l8HY9O8pQBVMFw+XrjqISn0Y/L6CoyI6oFwrwLA+nBEYcoTM/vdS6dzSwewc?=
 =?us-ascii?Q?L9lYy55HwAVCo3Lb/jPixy2XdoKofqQmvSmEJU5bwDMmyakdc0exyn64bXBO?=
 =?us-ascii?Q?BrSeOI0XvdyXSYYLHVtfsGaQfa1TfEnOKYlW5W3YEbVNEJUSvk5JAYnD8u5b?=
 =?us-ascii?Q?T2YURLWcMtVwwKCEIzt6EaCHRLsWuJ7P8WxDy6Bd384ASGV4VOwzN4MEOJRE?=
 =?us-ascii?Q?jqJHn/+j2iSQCnXQIYLkX3LATKAo5ozYB/kVm4NQP1wVvVZIS5l4caG0K3jq?=
 =?us-ascii?Q?L+fm9RKrHZTnVsqel1RAZmvkT906ByZ/zuqQoDA0NXvsc8hxFyF4Uq1k3tUl?=
 =?us-ascii?Q?w2qkbi5+jtWpRgSwmoRSAiP+95o2qhtKDpHieQT65x9uhREplwehX+C/a77L?=
 =?us-ascii?Q?OGrBclAffu+m9yJy0QuzjPk9n0HzAYq4Z4G5jalkmqHzVLg32Y3AadmnXt0z?=
 =?us-ascii?Q?vLdES4zogSiQCDVt7a/MA41MK8ixomWp4s6wq91zyAJucnsEJ62dBZe1cr4I?=
 =?us-ascii?Q?gsT4dkZPfiar46LBT/Za1txLLc7FwLt9fqo53TeziMsjFwgn8QveLpjS7OyM?=
 =?us-ascii?Q?TNNYtKwXCMLrkwMUgJFelf7Y/Qz7CGUzistNMpZHktobSYqHQJ5hB/d0FwR0?=
 =?us-ascii?Q?gFc9lzPoUfavy55kpQImyCnt1mRccGMZKeAVgQnikpLlMB2pnqttEfUfUvrS?=
 =?us-ascii?Q?EzaWr7pwUUfE2SrOsdCEabSa6xEoS8FUCzFYTbkk3DI7xeouhBn69VYpjdMZ?=
 =?us-ascii?Q?5WCsURiNoxhmGJAejk+4agQVoN/1Qmj5ccs+ocUN5Qj0SH2qHe83V0DRRnSW?=
 =?us-ascii?Q?BNXCx2ETLULtL4Py91b3hnaaSxFyropLSBTPPbmJuBKGbV2p35ko+SRngo3w?=
 =?us-ascii?Q?83N/b2mt+Imqox3ROHQHS2PiYxHNsajsi5nqBaS7bCvwcciHk5qRAacRKXIK?=
 =?us-ascii?Q?WZhQP+LoBb8UYRIrN05pLniTwYtGGOg+I81oP6esWGJuj8DnxWu5Vh6nNSgF?=
 =?us-ascii?Q?kRzW4kDAwMMcsWLTamUavp9CdvQeANPNiKmXQahPEBZ2Nw3Q08IlLgSt3tbJ?=
 =?us-ascii?Q?2lQJN11F+mPA+YSmxVPjgqDMLs6Xzb9J4EwepTwkgsdl1No/OfaRcKHaG0jJ?=
 =?us-ascii?Q?TUhjl+mjdBGwNAAfNHYgQaJ6ys09MyCRjo5Z+Nn6PqEr5W4hGdYJneldsrDW?=
 =?us-ascii?Q?pSAR3yJ88yLpirfZ5ilQaXh7tRodknktLs5vJ/aS16HUpVfvnUkn1JQyRaRK?=
 =?us-ascii?Q?aHlejmc1oJ8ZzuV2utWwiau+eWeq+ESjoe1LuaDo7kSwZIuq2uLmolbtrgNs?=
 =?us-ascii?Q?3pYtjsqY5tA2/xC/e3RpFVB4gSkijS/w9x0PZBFYay1mBz7Fv3twewGHoL4g?=
 =?us-ascii?Q?s4jnv57CaDa2LfFpB8fGk4Wx2ml4Bv4SCmHVrvaBo0fV4Ey26Blz7q5dOrzC?=
 =?us-ascii?Q?9Lz0C0Wi6KDRzWJrqrjS3l1UfdD4bIcIK6PrI61AUGTl3htbcQ5LsC+vyYKN?=
 =?us-ascii?Q?6w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5d0e618-9645-4fa9-4327-08db057b3405
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 00:11:33.1963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MLO0K1LKB76pvQ53l/K3jYjAtAyybRMlxgO9ZLkExFMXDwRTIhOzC8EbVgH9O03B8fuM3UT0MCAAf6CQX9iLWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9128
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We keep a pointer to the xdp_prog in the private netdev structure as
well; what's replicated per RX ring is done so just for more convenient
access from the NAPI poll procedure.

Simplify enetc_num_stack_tx_queues() by looking at priv->xdp_prog rather
than iterating through the information replicated per RX ring.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 159ae740ba3c..3a80f259b17e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -28,11 +28,9 @@ EXPORT_SYMBOL_GPL(enetc_port_mac_wr);
 static int enetc_num_stack_tx_queues(struct enetc_ndev_priv *priv)
 {
 	int num_tx_rings = priv->num_tx_rings;
-	int i;
 
-	for (i = 0; i < priv->num_rx_rings; i++)
-		if (priv->rx_ring[i]->xdp.prog)
-			return num_tx_rings - num_possible_cpus();
+	if (priv->xdp_prog)
+		return num_tx_rings - num_possible_cpus();
 
 	return num_tx_rings;
 }
-- 
2.34.1

