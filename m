Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388945770ED
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbiGPSyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232347AbiGPSyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:54:11 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130050.outbound.protection.outlook.com [40.107.13.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BE31C935
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 11:54:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Up7emC2TSZGCWKK8EahOXBR8uN5T0IoKKsVSELGZeTSPl6RQl7o8sJc9c43rBmerMOVkCyqtNHEgfz5JK07HeBi4m5YLn6w5EpbsBY1GgCcsQlhzLA2tEBBiFrjcHn9rnHVbMGmNAMkx0KJzma40YKDo0ECfJgZRuCp3oy+wtCbMKOWc4sxlhl7XKnQxWJto4YIm2viDRvhkAIx3hJfZogmlbMoBKBgk2MHR3yXUyiJmIxM2CPJ9ooCV7r5y2hRitvjtmKMb7/HmLo1PDLt+vn2XP79jdh7xFx8/CvJkiuH1mR/VibMQRNQjHah0Kw23SfKTGmDmKSt4VYGtg+aS7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8rJMDHEOzrqOXuTOGapYmj/yc8azoGOnw8QVkEaf5mg=;
 b=LoAEScOb/mmWiBq59RUu0kwTR5rDPao4Z6erCzKKb6377Tp8RKzlxBmYOEc8zFb0gzpSAKtI47M/TITwefgzg7g+63Bpnerp8jiYL42GUIlpz7xC0Qw2zTHBOMq1WxQkHKgNkSwyFNQcfsyDOgXxm9VjOb7b/yJfj8gWvdlSAmec1bZZrjR2mpEXziex5HDRUx01S/n2cMJufME3rS6Oc8s3qt+diECNiO0u+06fb6kn0xrHCOmtjRis/KJYVWnnwbDCtW1N43HNaq4dfunUTsbu032Hlm8TaXzAUnYm1pZTz8uXnP7fPcXG6aMLolaWIf67+PSeMyCdVv0BKyAP+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rJMDHEOzrqOXuTOGapYmj/yc8azoGOnw8QVkEaf5mg=;
 b=pKB0Ju2r6twgsmLwmNVzXPMc26Iu7nH+iX90zirdn8uNVGe6K48m4RYj9r7DZk9luEOnPPWkwhdpb/4u/eUvQpZqVXyTLzGz9iUEHVwaE/NfjHDg4mwUCIOwNaDXE5H3T2QD0luPdYjM792KSiZEwDpp/dHAgC1USZl+s8NpoUE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB5311.eurprd04.prod.outlook.com (2603:10a6:803:60::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 18:54:06 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd%6]) with mapi id 15.20.5438.020; Sat, 16 Jul 2022
 18:54:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net 08/15] docs: net: dsa: document port_fast_age
Date:   Sat, 16 Jul 2022 21:53:37 +0300
Message-Id: <20220716185344.1212091-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0101.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::42) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb215bba-bea4-4d36-e0e5-08da675c8e97
X-MS-TrafficTypeDiagnostic: VI1PR04MB5311:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h4uPsvxaWCqm/7xeLJSiPJ7xOrziuJo/A3ADRVt0o4d2CEc+SkXwIvRlEdpSxmJMNdDsEBLg+GWDKRJyZxg7b/XMVayHl7yKhG9eIppzvrIE+CVZtPgFIq5E2C1jJznS1LWcyd+VBtfP4cwMxeWxIXRZy603PwKTUjXquvdfQiH35P0oy1WslSS0XYqcsLnsLx6MOhJMFE0bKbT/kxvjZQrl6rZ/tvzcPxWLybimXOXW+pn4wrmCQNpxlgAUucZQ1wreghExrjita8kIde/VX2gbiZ52fY0KVlEUs6uMnuCy2it2EsoilbPfWtX8QeOGCPTq1NoisB4K6IGU0u91AZ510sVwsvSV291Vp5K1EIFpE9JPC7nbnx6kKOe/0GjDh8/nQuM9AWtoiymxDfZLDgZ+no7AbT7UmnYpFYGO0FtIncjIB5VEOdvwOM4MIVAyOcIwUC/pz0MORG9iViBQCMK9GQliC0VoX/Tz389mMtbo5IqUrOLmKIbSh3bS+pntu3RTDMd6Sg0Lgfg2m7OjUjYGvE44FS1zK336dVKRx9dSZcPQxNGCdATsDffXXsmqSYZGqeVCn4yGO0OpvaF+wtSwgzLyK9M5TtmvxK1Hf52lNIY2NapiDbtwl/swrKpd2ug6mAbpg/G0jzzEO0w/5lZDuKhusap7mwBPaaKoNg3iGH27DS5yHBzk7JT5c2gqGmVLUJdhl6EId1OS+tRj+1pmdK/vZctxStO5GA2xzmURGCbmhugn7AHj7Iy1bXR20IXYRv5UblJj8na3NMoeEMCJ6EQURu6btg3d+veUOQb4DtCUw8xTfulpjATkD75C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(26005)(6506007)(6666004)(41300700001)(6512007)(52116002)(6486002)(478600001)(5660300002)(44832011)(8936002)(86362001)(2906002)(54906003)(316002)(6916009)(36756003)(66946007)(4326008)(8676002)(83380400001)(38350700002)(66476007)(1076003)(2616005)(66556008)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T9wkfIH54ObAuluOl3nV8aB9wI2oP/UgM8Gk5pNUddsbUHsenwzsDbhZCD3t?=
 =?us-ascii?Q?9cXYOd0NvIA1iGIwT2VswbJ9kc0TKLZEj/NtxRgPYKgW545oxFlldRZv68TT?=
 =?us-ascii?Q?7xTLHdLxt/PmKxNm+32qEW51WuqeMC2dHG+QAHyzCIzcEF3LiufK/wAOt2r6?=
 =?us-ascii?Q?O9Lma2NrdF4L6D26JzNhsRQOASRxQwCrk89xN5xfw8TfbZkXLPM6b8gIE1z6?=
 =?us-ascii?Q?YdQbuP8OlSDWX5WaVYdlc1bTvIVK7oW2rWjkJjujQTBttghzFTxCOy8J+cF7?=
 =?us-ascii?Q?gsDVlAb0JWeJq0zpuspFgenA2atoNJG0WsE/IDEEOV9iJ4P1ziQYauSJ5Zn0?=
 =?us-ascii?Q?aPvYVaL3H5HYdI5U0PHl3hZK+8d6P9JaVemXfBwdw0IvR88Hwniglm+AfkYo?=
 =?us-ascii?Q?WdmCNiQbRhNFqU3q6Lchds6AMk3CMfA3hKLHuAtiPlV3zOdD43jvBchbZhyZ?=
 =?us-ascii?Q?id7mIBjmIcSTXLaDqqyocEf+9H+rozzgCnB+iGw1q8FXk6GIhf+T6SkRC0oD?=
 =?us-ascii?Q?/kpf8p18SKQV9Bp/Yl0s76bbH5eBsMYq6ga74oBXkAcbMoTCNFlJm7GV/vx0?=
 =?us-ascii?Q?AmUN5pmBl73ND/1pwFLD1hC8HShjS/XIj0xcC/j4RY5iuIvT1JZlkpob/H+T?=
 =?us-ascii?Q?4og9ReIFx4tEcuCZbqkZwXwKflRen5byq/OfV+SK+nU5ErkzE6zOtpg0e8k7?=
 =?us-ascii?Q?DdcVHoRN7SJD2PjXPMRii2OOyvhsUWbtrx+7ac3Bpu47NMobW4Gjdq6zFUSt?=
 =?us-ascii?Q?iF4KQCj4BBYMcT8IhGrVntIgXwc0KOIpAubEv0FCNzMdp+Lk9J7QKxCNG5rt?=
 =?us-ascii?Q?j87H7HDEX2KAUEJEPrWp+IyKXSaOC1VDKbqyftOsEPD4efDltO3mKNZAsULJ?=
 =?us-ascii?Q?SBmcmq329vC8z/Ix17P4FdbEKzCDb9lQC5XTIcYfYKmbbtWkFlfQQo64jDsB?=
 =?us-ascii?Q?HEqDVaOYi92/uFaTuJLfDawdK8n9dmQUsHswNLK0vrWWqhSzSBKzZqt6T+aJ?=
 =?us-ascii?Q?So6U6Geos9cnBKsIyzyBXszEyiJjT7KRtffXfWmqmnjk+7herE8NVHAIzc4/?=
 =?us-ascii?Q?eDmx5gqfwnrlQejNUbHuG08aFrIRAIFpjpHpndY4TTQFaCY/rVBSKiD1QDMd?=
 =?us-ascii?Q?HY2p9nJDFqWCL1ZR8HXVe0gjCQQfBgL0/+a27RfoxkeFpYTHfqPc4K5v4ohf?=
 =?us-ascii?Q?YCWVmCEidLkRqNJtKEkzKVZ9njoN3WwUbcbg+gB6yvh8sQB3z6zhM391JVYT?=
 =?us-ascii?Q?ZMZlXLm1eP7+5gsksQDuF2FTwlg5Zca8wV3m6egXY1U86smt17YYPOtfESb0?=
 =?us-ascii?Q?dhiHa7lqrrJGu7RUT9tOIcAaNGysrebXcGa7oL1jzy2Yp4Qu7dLrZKzaDKpg?=
 =?us-ascii?Q?cfvX9oXVgwMTbj8tRNkVjfnrCjHujxTH3Kgn7/J53EzpeFWfmLWRjAyEw8sn?=
 =?us-ascii?Q?z4UxUYIVD37mQ5GCdkRyj5mPMpIeMYiCGrjqig2Zwd3Zj6YDTeAaFRwQOhpH?=
 =?us-ascii?Q?F263geY9k2JVmYHWSZlNRyG1cz9IC9gFRJYyQriwWFOv+DFnm8M9/FvKe8Qa?=
 =?us-ascii?Q?17UZP5CLiQc3rhP6uOxBKguQ4LZqKBhQUHdz3Ny9Lk5IylHuI20Z6ke92f3k?=
 =?us-ascii?Q?Iw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb215bba-bea4-4d36-e0e5-08da675c8e97
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 18:54:05.5816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N5CscRdUeJSwOfvG1uHLHQGetd60npLQE30Mzc6ZaPxQ4Q76DPGAx1BKtEBa6FNi+SRLIanwFVKdy6vYIl7XaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5311
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The provided information about FDB flushing is not really up to date.
The DSA core automatically calls port_fast_age() when necessary, and
drivers should just implement that rather than hooking it to
port_bridge_leave, port_stp_state_set and others.

Fixes: 732f794c1baf ("net: dsa: add port fast ageing")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index eade80ed226b..d83e61958e88 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -738,15 +738,11 @@ Bridge layer
 - ``port_bridge_leave``: bridge layer function invoked when a given switch port is
   removed from a bridge, this function should do what's necessary at the
   switch level to deny the leaving port from ingress/egress traffic from the
-  remaining bridge members. When the port leaves the bridge, it should be aged
-  out at the switch hardware for the switch to (re) learn MAC addresses behind
-  this port.
+  remaining bridge members.
 
 - ``port_stp_state_set``: bridge layer function invoked when a given switch port STP
   state is computed by the bridge layer and should be propagated to switch
-  hardware to forward/block/learn traffic. The switch driver is responsible for
-  computing a STP state change based on current and asked parameters and perform
-  the relevant ageing based on the intersection results
+  hardware to forward/block/learn traffic.
 
 - ``port_bridge_flags``: bridge layer function invoked when a port must
   configure its settings for e.g. flooding of unknown traffic or source address
@@ -775,6 +771,12 @@ Bridge layer
 - ``port_bridge_tx_fwd_unoffload``: bridge layer function invoked when a driver
   leaves a bridge port which had the TX forwarding offload feature enabled.
 
+- ``port_fast_age``: bridge layer function invoked when flushing the
+  dynamically learned FDB entries on the port is necessary. This is called when
+  transitioning from an STP state where learning should take place to an STP
+  state where it shouldn't, or when leaving a bridge, or when address learning
+  is turned off via ``port_bridge_flags``.
+
 Bridge VLAN filtering
 ---------------------
 
-- 
2.34.1

