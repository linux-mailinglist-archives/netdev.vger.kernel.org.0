Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68309666038
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238228AbjAKQSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235533AbjAKQRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:17:46 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2080.outbound.protection.outlook.com [40.107.247.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D715FA0;
        Wed, 11 Jan 2023 08:17:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+x3qu/7kaj6nm2nJroPhotS4QTTJ6KAjH5vv/pdsPpD5fm/kKgPb2o47d+qlKHW7jZTK/kqicN8T83Z+jzkczvCDQ9ZcEdA4PqVnSgnM+zyky11qKdcrrglp0rUNnRl1PYiYN8SQc1CEv/oENh6R0kBRAn7sXFVAUqTF3n9oekogWaC89yngkoD6HwCeRH+3dCM1YegD5v93tYIlHjY9wPp4YWzGBbrXfrD++tKWwZTMg+3mPTfHSzGfbPTmCXjPtgnk4Oy/5EPr9fgT2UedPlXIhMpWy69JQv4lOETq1jlpXjHXRStlgdRZoI0Bam3ccVsW8n4IoJFtapTC45KPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+KIt1gxmewtqqj6relnLOGcy/Yqt8J2A6GF8RQ0THJI=;
 b=Im1ahf1G5wwCuDw5o+EDp2uCNKsLiFcMo1MFce2OezHbGLHgOqle65UbW13b7hXwuO2jB2NTAztZZWLIG8E7Wdm0A0g4ZNeUCcHiPVYXgJHIVG2PVfyAWaK2tZV9T8AhMM7XoHSVwJyApOLmtABHvmEkSrvAalGPxCYH8fKYjxKU4BnSravDuk34+9GhOjCzI3W0167YO8MFNsFWqx5aALng7HxcMfUiFJINIWMKqWzKa0kbx6pT2X152/jR4GD1rRF9vyIbysare8ui3qTB/E8iRxcogoMuUwSFMXN9ZkXLeDw1I2XU/TpwZTR4ZfKFqAErdrOKGYz1bN/0lXq+gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KIt1gxmewtqqj6relnLOGcy/Yqt8J2A6GF8RQ0THJI=;
 b=mJzFp4rQqMeliuIrwSBw/WJAoOB9cBDcS2+Sd0aqf9FxZhSwk/9/QHsm9m6zCxMTnZmKtqsSGauNxFiLMACAIHxIXITwNW6tIktz6ai7kFR7OWfcOKEnXy6qjTG3/hzQtn7pbfdPCOz6LDC/zyiUTGD8Jv9zwoc1C1W3CwPWoow=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8462.eurprd04.prod.outlook.com (2603:10a6:10:2cd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 16:17:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 16:17:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 06/12] net: ethtool: add helpers for aggregate statistics
Date:   Wed, 11 Jan 2023 18:17:00 +0200
Message-Id: <20230111161706.1465242-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8462:EE_
X-MS-Office365-Filtering-Correlation-Id: b5f777f5-225a-4ae8-0324-08daf3ef53a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z6RAZ0qj2M5Kgh7anVmitprA9R0EvKiz4vGXkQ/FuV8/EJ+IpPyMQTUryUBrsv+55E6qpH9m9XQREiudlxKZqJZAKfMlOtQRn2fRnMw/4vnIHK9lW+QHPw+my8eyyeKRbLuRTvS+EhfOaTEDcKWyHdr3rGIyulU1t+7vHtWlkApyLh/54v9ONGn7okQ2LUEpBxiGc1wqyT8DMS9dQQMXt+SUCk1TbJc2gtxNMNJvHQ4YsfjH7s4M+FWGCRyb23PbhLaKMSxl1dvsXYjRkPND1Um2qKbb6rvXWFV54yh33zHrW7fomwQ0z12dengknVXrI3trfBk8kI98p5ACWSgt3Egrm8AThv17ZEIiFu+/IiMuNhbFQsXQQYcX3pbcwMC0Dy1pQITyhKs5n4PfDsFOi0M+4qm5h8BCCG5agTv0syNvqR6bYE78qhQq5KR9TrgkGwRC4hO8KFsSNkXH/ixv2ZwiRN3pbNnuSXumYde4yNsGaj3cKcvkOIQOYBYvbV8gcI5o+SMcx0KIiz9yPlCiSX6GyA2QbJrZYYnO6vl0K7A+QmrcPS9udpIic2IG1nVNjFb4R1xSJZ08IfjPTfxQ4Cn59rXvrYQIeUlUImXLgHHvbKnnpPp2NjeGbBFBgMCQvQagOHF56pade/CL1gBgFeTOMHpIJw3GlIuaWC1DWyoYN2wltM/IwuQbur+PeU38
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(36756003)(26005)(186003)(8936002)(6666004)(6512007)(6486002)(6506007)(1076003)(2616005)(66946007)(5660300002)(66476007)(66556008)(52116002)(7416002)(6916009)(316002)(4326008)(86362001)(41300700001)(38100700002)(38350700002)(478600001)(54906003)(8676002)(83380400001)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bcXCX180VtXAR4bFRbr8ciL88AQkR8cJyPS3xSE2cxxzG3yJXRwL9Ea85z3u?=
 =?us-ascii?Q?QO5GAXmP79gWw3C/xhZjwBkQ1/xvNYymGOJZdvdJKPiUHMm9Qa+L17c2Ljpe?=
 =?us-ascii?Q?JJHx3evFzMqehsncI3R32XyJb5o8YaxFY4AANVLNu2XkGBvKyre79RB+iuwv?=
 =?us-ascii?Q?ZDIRcuD2fIdb7VURpJETspBmGzCD32e0ua2TBrgj0qL7XiQH8ZTSq6geQe6t?=
 =?us-ascii?Q?YiU+xjsjVwmK3H1Pv+xBS/F0zz2YdfH2cPWyQYZcd/wtmcgLZVWuUhLoYngd?=
 =?us-ascii?Q?OxVhVIg7PBaOIL1xWSFbj3K/kU+UiFLFdxoFW7RQ7VNUmlZcSd52l/LaiE2h?=
 =?us-ascii?Q?tWi1KUZui3AOhTP/1lOtJuTpMwFbzXiJEM3P44lqhY8WvsClXcsQlTB0/oSQ?=
 =?us-ascii?Q?cgJ/4Vh5wF3aqiBU2EJnEn0oGWLnUUnuG/fxxgTS+CFjZ86BWxYX9rQ0b3sf?=
 =?us-ascii?Q?hfHuaeFEPsSc2jk3sSOHTJFO00zoTkSzIP4b/0yvW06gWBvCXKKYtGsws08g?=
 =?us-ascii?Q?cwvnlAnbyUt1OIW5QvE0hwBypJCdLShZWxzV3X7XiKsCzgONZEFlFFeIA8ks?=
 =?us-ascii?Q?/CzcjN4nLkD70ktdxlIQTgXEQCyEUTPoWdB4DJtuhPskZ8tm1M7vUDGTqE5v?=
 =?us-ascii?Q?aea9UrIld/tpQqkQ3B5FItQCMyPr0LtttOecKtoRE0/DtKakJZnXOcDM7xrp?=
 =?us-ascii?Q?A+rGQ6bwtTVKnQB9tzhh4+2idJkigYXXKZxcoh39QQ2ftnLQ5vjiXNVLVyC7?=
 =?us-ascii?Q?B16TOuxs9CKbodgBywgDohjdB87+yzpFtrDDGxKZBnvyeTvvZo2yjFz/17sT?=
 =?us-ascii?Q?W0niPnPybtXCoyGV/HS0Js+tiEUVNkEmQF4uuKtn0f2Qfhd/m5fY4Vdt8M1+?=
 =?us-ascii?Q?lCIoeWq+KAgosboMT7nWej5iZs6HtJ7N4D3J9byRNAYRQ8LDNoK2QYFf+IRy?=
 =?us-ascii?Q?5CDsv+GQE5NvjMDAGxm98A0xCGfHqBSk0qYzsFyuA+gdz130omTpPjbktAKX?=
 =?us-ascii?Q?1qQPCBt4CXcscTdz9GStUFlJmp+2g1D2aQe8KQP5DdFkGnU2ps/CkNAlZc7i?=
 =?us-ascii?Q?rqkRCO1OU2CQEL74sz2ChkFBd5fOIOqLLj8n1wnERYmH/Ep4UArAZ6PXlR+f?=
 =?us-ascii?Q?Mgi3Tvc+pM8EU7X8RCipFV0WELoRCXGnxBT0Hh0h7nUfHjvDZTeskSNUs+a6?=
 =?us-ascii?Q?5qhNo6ogJ2cX+6rfe/sSV1mLQa8yuPsqvckGHOOhe9oj+SH7+A/taoN7KKbM?=
 =?us-ascii?Q?UJGyMf2fgBt0xrnuHd+XsQ+2kmuYB0OLtv5T6SRjy8tGt4AgTQ9cBa15rVpa?=
 =?us-ascii?Q?Q9NeIfrMV3RN2wDrIuGxgu/FLoZCT804lYKGqV8yvARMJAu6YJRkzUB4e9E4?=
 =?us-ascii?Q?Rw9zrbEh9bkmJtiyZ2fTP1kHW4oPqqgrAGZfKbN8HayBrXKBO3L0Pg29MnT7?=
 =?us-ascii?Q?nMiDWo++y+xEB8enqrYRIjjWvaY/fWRHAId2h2k92MEWwz13p3tbh7EIa4bz?=
 =?us-ascii?Q?ZbDgbOvT77DPYvygWeFdU91IPXxvo/GDnIzj/gKjpqD5hQImTk25gZsWpZU3?=
 =?us-ascii?Q?hit4WLFW/VD4aEIV5jkw0ghGXIaYDa/WlWyLh54uMWDsyszn+zNqjeGgWMcu?=
 =?us-ascii?Q?Fg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5f777f5-225a-4ae8-0324-08daf3ef53a2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 16:17:25.5018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a76+KaPK8yJleCMEZlZ3KLro3aoYArzb7xtHlPr9VJHR7y/FeEPWRMlkZ+dFSpyXwruFXc/PRrrHl9Sj0xn9EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8462
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_ABUSE_SURBL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a pMAC exists but the driver is unable to atomically query the
aggregate eMAC+pMAC statistics, the user should be given back at least
the sum of eMAC and pMAC counters queried separately.

This is a generic problem, so add helpers in ethtool to do this
operation, if the driver doesn't have a better way to report aggregate
stats. Do this in a way that does not require changes to these functions
when new stats are added (basically treat the structures as an array of
u64 values, except for the first element which is the stats source).

In include/linux/ethtool.h, there is already a section where helper
function prototypes should be placed. The trouble is, this section is
too early, before the definitions of struct ethtool_eth_mac_stats et.al.
Move that section at the end and append these new helpers to it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 include/linux/ethtool.h | 100 ++++++++++++++++++-------------
 net/ethtool/stats.c     | 127 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 187 insertions(+), 40 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 06672b76b2c6..01b1e34dc30e 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -106,11 +106,6 @@ enum ethtool_supported_ring_param {
 struct net_device;
 struct netlink_ext_ack;
 
-/* Some generic methods drivers may use in their ethtool_ops */
-u32 ethtool_op_get_link(struct net_device *dev);
-int ethtool_op_get_ts_info(struct net_device *dev, struct ethtool_ts_info *eti);
-
-
 /* Link extended state and substate. */
 struct ethtool_link_ext_state_info {
 	enum ethtool_link_ext_state link_ext_state;
@@ -302,28 +297,30 @@ static inline void ethtool_stats_init(u64 *stats, unsigned int n)
  */
 struct ethtool_eth_mac_stats {
 	enum ethtool_stats_src src;
-	u64 FramesTransmittedOK;
-	u64 SingleCollisionFrames;
-	u64 MultipleCollisionFrames;
-	u64 FramesReceivedOK;
-	u64 FrameCheckSequenceErrors;
-	u64 AlignmentErrors;
-	u64 OctetsTransmittedOK;
-	u64 FramesWithDeferredXmissions;
-	u64 LateCollisions;
-	u64 FramesAbortedDueToXSColls;
-	u64 FramesLostDueToIntMACXmitError;
-	u64 CarrierSenseErrors;
-	u64 OctetsReceivedOK;
-	u64 FramesLostDueToIntMACRcvError;
-	u64 MulticastFramesXmittedOK;
-	u64 BroadcastFramesXmittedOK;
-	u64 FramesWithExcessiveDeferral;
-	u64 MulticastFramesReceivedOK;
-	u64 BroadcastFramesReceivedOK;
-	u64 InRangeLengthErrors;
-	u64 OutOfRangeLengthField;
-	u64 FrameTooLongErrors;
+	struct_group(stats,
+		u64 FramesTransmittedOK;
+		u64 SingleCollisionFrames;
+		u64 MultipleCollisionFrames;
+		u64 FramesReceivedOK;
+		u64 FrameCheckSequenceErrors;
+		u64 AlignmentErrors;
+		u64 OctetsTransmittedOK;
+		u64 FramesWithDeferredXmissions;
+		u64 LateCollisions;
+		u64 FramesAbortedDueToXSColls;
+		u64 FramesLostDueToIntMACXmitError;
+		u64 CarrierSenseErrors;
+		u64 OctetsReceivedOK;
+		u64 FramesLostDueToIntMACRcvError;
+		u64 MulticastFramesXmittedOK;
+		u64 BroadcastFramesXmittedOK;
+		u64 FramesWithExcessiveDeferral;
+		u64 MulticastFramesReceivedOK;
+		u64 BroadcastFramesReceivedOK;
+		u64 InRangeLengthErrors;
+		u64 OutOfRangeLengthField;
+		u64 FrameTooLongErrors;
+	);
 };
 
 /* Basic IEEE 802.3 PHY statistics (30.3.2.1.*), not otherwise exposed
@@ -331,7 +328,9 @@ struct ethtool_eth_mac_stats {
  */
 struct ethtool_eth_phy_stats {
 	enum ethtool_stats_src src;
-	u64 SymbolErrorDuringCarrier;
+	struct_group(stats,
+		u64 SymbolErrorDuringCarrier;
+	);
 };
 
 /* Basic IEEE 802.3 MAC Ctrl statistics (30.3.3.*), not otherwise exposed
@@ -339,9 +338,11 @@ struct ethtool_eth_phy_stats {
  */
 struct ethtool_eth_ctrl_stats {
 	enum ethtool_stats_src src;
-	u64 MACControlFramesTransmitted;
-	u64 MACControlFramesReceived;
-	u64 UnsupportedOpcodesReceived;
+	struct_group(stats,
+		u64 MACControlFramesTransmitted;
+		u64 MACControlFramesReceived;
+		u64 UnsupportedOpcodesReceived;
+	);
 };
 
 /**
@@ -362,8 +363,10 @@ struct ethtool_eth_ctrl_stats {
  */
 struct ethtool_pause_stats {
 	enum ethtool_stats_src src;
-	u64 tx_pause_frames;
-	u64 rx_pause_frames;
+	struct_group(stats,
+		u64 tx_pause_frames;
+		u64 rx_pause_frames;
+	);
 };
 
 #define ETHTOOL_MAX_LANES	8
@@ -431,13 +434,15 @@ struct ethtool_rmon_hist_range {
  */
 struct ethtool_rmon_stats {
 	enum ethtool_stats_src src;
-	u64 undersize_pkts;
-	u64 oversize_pkts;
-	u64 fragments;
-	u64 jabbers;
-
-	u64 hist[ETHTOOL_RMON_HIST_MAX];
-	u64 hist_tx[ETHTOOL_RMON_HIST_MAX];
+	struct_group(stats,
+		u64 undersize_pkts;
+		u64 oversize_pkts;
+		u64 fragments;
+		u64 jabbers;
+
+		u64 hist[ETHTOOL_RMON_HIST_MAX];
+		u64 hist_tx[ETHTOOL_RMON_HIST_MAX];
+	);
 };
 
 #define ETH_MODULE_EEPROM_PAGE_LEN	128
@@ -959,6 +964,21 @@ ethtool_params_from_link_mode(struct ethtool_link_ksettings *link_ksettings,
  */
 int ethtool_get_phc_vclocks(struct net_device *dev, int **vclock_index);
 
+/* Some generic methods drivers may use in their ethtool_ops */
+u32 ethtool_op_get_link(struct net_device *dev);
+int ethtool_op_get_ts_info(struct net_device *dev, struct ethtool_ts_info *eti);
+
+void ethtool_aggregate_mac_stats(struct net_device *dev,
+				 struct ethtool_eth_mac_stats *mac_stats);
+void ethtool_aggregate_phy_stats(struct net_device *dev,
+				 struct ethtool_eth_phy_stats *phy_stats);
+void ethtool_aggregate_ctrl_stats(struct net_device *dev,
+				  struct ethtool_eth_ctrl_stats *ctrl_stats);
+void ethtool_aggregate_pause_stats(struct net_device *dev,
+				   struct ethtool_pause_stats *pause_stats);
+void ethtool_aggregate_rmon_stats(struct net_device *dev,
+				  struct ethtool_rmon_stats *rmon_stats);
+
 /**
  * ethtool_sprintf - Write formatted string to ethtool string data
  * @data: Pointer to start of string to update
diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
index 9238d99f560b..a38516181e46 100644
--- a/net/ethtool/stats.c
+++ b/net/ethtool/stats.c
@@ -437,3 +437,130 @@ const struct ethnl_request_ops ethnl_stats_request_ops = {
 	.reply_size		= stats_reply_size,
 	.fill_reply		= stats_fill_reply,
 };
+
+static u64 ethtool_stats_sum(u64 a, u64 b)
+{
+	if (a == ETHTOOL_STAT_NOT_SET)
+		return b;
+	if (b == ETHTOOL_STAT_NOT_SET)
+		return a;
+	return a + b;
+}
+
+/* Avoid modifying the aggregation procedure every time a new counter is added
+ * by treating the structures as an array of u64 statistics.
+ */
+static void ethtool_aggregate_stats(void *aggr_stats, const void *emac_stats,
+				    const void *pmac_stats, size_t stats_size,
+				    size_t stats_offset)
+{
+	size_t num_stats = stats_size / sizeof(u64);
+	const u64 *s1 = emac_stats + stats_offset;
+	const u64 *s2 = pmac_stats + stats_offset;
+	u64 *s = aggr_stats + stats_offset;
+	int i;
+
+	for (i = 0; i < num_stats; i++)
+		s[i] = ethtool_stats_sum(s1[i], s2[i]);
+}
+
+void ethtool_aggregate_mac_stats(struct net_device *dev,
+				 struct ethtool_eth_mac_stats *mac_stats)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	struct ethtool_eth_mac_stats pmac, emac;
+
+	memset(&emac, 0xff, sizeof(emac));
+	memset(&pmac, 0xff, sizeof(pmac));
+	emac.src = ETHTOOL_STATS_SRC_EMAC;
+	pmac.src = ETHTOOL_STATS_SRC_PMAC;
+
+	ops->get_eth_mac_stats(dev, &emac);
+	ops->get_eth_mac_stats(dev, &pmac);
+
+	ethtool_aggregate_stats(mac_stats, &emac, &pmac,
+				sizeof(mac_stats->stats),
+				offsetof(struct ethtool_eth_mac_stats, stats));
+}
+EXPORT_SYMBOL(ethtool_aggregate_mac_stats);
+
+void ethtool_aggregate_phy_stats(struct net_device *dev,
+				 struct ethtool_eth_phy_stats *phy_stats)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	struct ethtool_eth_phy_stats pmac, emac;
+
+	memset(&emac, 0xff, sizeof(emac));
+	memset(&pmac, 0xff, sizeof(pmac));
+	emac.src = ETHTOOL_STATS_SRC_EMAC;
+	pmac.src = ETHTOOL_STATS_SRC_PMAC;
+
+	ops->get_eth_phy_stats(dev, &emac);
+	ops->get_eth_phy_stats(dev, &pmac);
+
+	ethtool_aggregate_stats(phy_stats, &emac, &pmac,
+				sizeof(phy_stats->stats),
+				offsetof(struct ethtool_eth_phy_stats, stats));
+}
+EXPORT_SYMBOL(ethtool_aggregate_phy_stats);
+
+void ethtool_aggregate_ctrl_stats(struct net_device *dev,
+				  struct ethtool_eth_ctrl_stats *ctrl_stats)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	struct ethtool_eth_ctrl_stats pmac, emac;
+
+	memset(&emac, 0xff, sizeof(emac));
+	memset(&pmac, 0xff, sizeof(pmac));
+	emac.src = ETHTOOL_STATS_SRC_EMAC;
+	pmac.src = ETHTOOL_STATS_SRC_PMAC;
+
+	ops->get_eth_ctrl_stats(dev, &emac);
+	ops->get_eth_ctrl_stats(dev, &pmac);
+
+	ethtool_aggregate_stats(ctrl_stats, &emac, &pmac,
+				sizeof(ctrl_stats->stats),
+				offsetof(struct ethtool_eth_ctrl_stats, stats));
+}
+EXPORT_SYMBOL(ethtool_aggregate_ctrl_stats);
+
+void ethtool_aggregate_pause_stats(struct net_device *dev,
+				   struct ethtool_pause_stats *pause_stats)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	struct ethtool_pause_stats pmac, emac;
+
+	memset(&emac, 0xff, sizeof(emac));
+	memset(&pmac, 0xff, sizeof(pmac));
+	emac.src = ETHTOOL_STATS_SRC_EMAC;
+	pmac.src = ETHTOOL_STATS_SRC_PMAC;
+
+	ops->get_pause_stats(dev, &emac);
+	ops->get_pause_stats(dev, &pmac);
+
+	ethtool_aggregate_stats(pause_stats, &emac, &pmac,
+				sizeof(pause_stats->stats),
+				offsetof(struct ethtool_pause_stats, stats));
+}
+EXPORT_SYMBOL(ethtool_aggregate_pause_stats);
+
+void ethtool_aggregate_rmon_stats(struct net_device *dev,
+				  struct ethtool_rmon_stats *rmon_stats)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	const struct ethtool_rmon_hist_range *dummy;
+	struct ethtool_rmon_stats pmac, emac;
+
+	memset(&emac, 0xff, sizeof(emac));
+	memset(&pmac, 0xff, sizeof(pmac));
+	emac.src = ETHTOOL_STATS_SRC_EMAC;
+	pmac.src = ETHTOOL_STATS_SRC_PMAC;
+
+	ops->get_rmon_stats(dev, &emac, &dummy);
+	ops->get_rmon_stats(dev, &pmac, &dummy);
+
+	ethtool_aggregate_stats(rmon_stats, &emac, &pmac,
+				sizeof(rmon_stats->stats),
+				offsetof(struct ethtool_rmon_stats, stats));
+}
+EXPORT_SYMBOL(ethtool_aggregate_rmon_stats);
-- 
2.34.1

