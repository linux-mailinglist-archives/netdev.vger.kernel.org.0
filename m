Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBBC66D929
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235964AbjAQJDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236163AbjAQJBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:01:39 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2042.outbound.protection.outlook.com [40.107.8.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F82301BD;
        Tue, 17 Jan 2023 01:00:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4kmA4ppbE48RY20pir9rqom6TXte7e0OcLcSZ4j+yeKeogakHhGycsyrPiFN9IoEThczOPJ0fQCl8PxlYJ7jCotyhSSpoPkayoJUZgUmzJ/Ml4Lmjm6PLs4GtlQfVWRI45T6VCBdR7hEjD+Ot9yawelvGEwUnb6deROnWe/9H7FlV87AWqi9rosrN00E+QdXhXIcxAjvMfSsfuvGQrk0/ZFKHdWkbfmRMZpTiTpMzWxBl+hT9IhiwOEPG8WPB5JudqA/26SoBT477iQy7AhooPxmwHCGQk//jh4vxR9ZLtY/+VlR44nbrhMfUx5JsYGAvKgG/4cpTeqTgEYCX5rrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bs1ZF1mDEJBOdkygmSCDgG8eD2RKbuq8AxAGx4w4ZPk=;
 b=gVkD/WVVYxmsv/H+eNDX4CBkNe+5CvKrXK3xrae96BtcoBWl6MKgGKaT5KQiVgJ1Icfzn4c2UXtRt/20KKv0lELs50xaJiPMmMA8XjF0gqxL2FkPuhFqV2OHtD1yHRurImihbVXln4oQcV1GeSIFj3yFbXG7ffC0LCnelvGxKy5Z1QrtScPHpDh6XplxxGJ1bNpnRF30Lkq2ZRORT2xpmTkVzGP8rOtwxBA+ridQO9Jlvadpkj7ws8NjoGpmWnWylKw4C3OGHAlmQslnQY9UBZ6jfLgfOBTJoFNahUI33Zkjlh/asu496hNxaevG+s93bam94NGddtGl/tOzPNG7DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bs1ZF1mDEJBOdkygmSCDgG8eD2RKbuq8AxAGx4w4ZPk=;
 b=RNjtl7vGTfYJ+olpipV3uMD7C6Tcyf79xwNjHGiUVIdFa4v2WBK6eCgGXVZwIonFzDmpUR0fxXrisX8H5klcwwBW78dOUiqNMnKBzviLviw6NvzcLrhBMP6sM1r6cJ6nFoRZkq8TxPgx2TPihivxsMtAM2hA94WgbQpfLaYLd3o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by GV1PR04MB9182.eurprd04.prod.outlook.com (2603:10a6:150:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Tue, 17 Jan
 2023 09:00:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 09:00:08 +0000
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
Subject: [PATCH v3 net-next 06/12] net: ethtool: add helpers for aggregate statistics
Date:   Tue, 17 Jan 2023 10:59:41 +0200
Message-Id: <20230117085947.2176464-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
References: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|GV1PR04MB9182:EE_
X-MS-Office365-Filtering-Correlation-Id: 0acb89ad-de18-4eef-998d-08daf8693b9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: frOJ92ggop1Dg3tW2CxAgXINYYoBDPVRv+wY9DQsK8AR1OdUbmAmZy1SKZFANfcNlO8S1O716p0IGlDA1aXhPjQVGWnPXi9VTqM3DiU8eiFqI5MHN3K8CehUdRF9L5Vi6SzhINheNlmgQm6c9wjMsZ611TSP1sSWaWZRh52eaB5iwa0z/F1bdXfzjnimMqY7fad6ECwOEgEt56mov0ARTEyXaQGQnnnMBkNRW0J+YlTqQX/sDHPkI691a6ApuVn70m3MFxlfkBUcRlCPp2av4HDIGZKYw/rL1DOATqL2u2MYpvVjVHj9suBm/TcvBnNeRbF26niRMtEfQvzBLJhKqHcoqJhQZgiShGiqN9BK4HinkT9Yz288fC8AVvQ7TAcnsn7HJIhdPdBoK9D7hvgV9+pCLjkq/lKMj6F1hIXwHfgi8cH5zCvhB3j3zm5uA76gwLWY1qs3F341nR65nwJDzorMlxb4A1QYdfhR7HSvW+WogYc6PtyvMxD0l47u1WNAy1fhltJxxqFSm6hvCtLCR8yjdqi3bAmWXwYx78xqMM1SqBd3FJNXSOHTM9qbjh7acQ1IwzcZgLhrwqIKtvjWTevaEGPdOUacFqbgxrF1Iab/78NoZ0aKaF3RKXjIiUr3qpSECu/zcfTnx+u3b9eTGWXdGx7GgvTH0eFOheTI0HpHbDM+CvOePtvKUD2IoCHA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199015)(52116002)(26005)(6512007)(186003)(478600001)(6486002)(66556008)(66476007)(316002)(1076003)(6666004)(54906003)(66946007)(2616005)(8676002)(6506007)(6916009)(4326008)(38350700002)(8936002)(38100700002)(5660300002)(7416002)(41300700001)(83380400001)(44832011)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vhFYfnFQU2TCDgcU7WAe5An0LFXGda9svLoUg1ALQXpxdU+1pksZNaCt3SZD?=
 =?us-ascii?Q?H8FZ3V3mET41jnYDyWjqft0TTufIKM8NCzQKXBiW3CY3HUfPi75N5AWhdKUu?=
 =?us-ascii?Q?6gYzvy/fqK+FHPttx5bbUl6IFJrM7ijxXwbJ3fjqvBGKLaPYj8EaVFOZAjB/?=
 =?us-ascii?Q?SQXQemJl47OLmi0MCk+WHWPMHS3mkhfPhtyoenusIna6nYi7LKLbFlUz0yp/?=
 =?us-ascii?Q?V50jwaeyuGkoHEgziemdrgGrOzFhWr5MYUQnN5M6j/6d7Of29M6kc1HaATmn?=
 =?us-ascii?Q?INkkYziG0t1kVt4bIfYT7cGezKKePidsmV61IizLjGnw1Kh1e41njcgX/pSm?=
 =?us-ascii?Q?M6qRwnm59ty3wvEnsI75lPsC31WNbaAUy4k5G7I9zvqHUjeODJA9nyWH9brz?=
 =?us-ascii?Q?VCWzhxJLPfu80Ivec4ou+/Ftnhu7ytIdqnoGBCyuOzjU0kzhRrLO/jSMpSfW?=
 =?us-ascii?Q?KHabHTEpdiPOEMizQF742e8zorYKTU2D60N1ughmpHYIyQbSOD0YKU2ku61H?=
 =?us-ascii?Q?kdk9xwYXxY2R3FkIcIGh/EyQCztnaQRyWq5EM4Bzc/+Y8RyN5vegHgjiPcXy?=
 =?us-ascii?Q?b1tJbZPASIWQpN0xr0gENgrbMF8+l6MMh17qvk++K2VsKMG5dFnn+s1HMUNT?=
 =?us-ascii?Q?EkcZAsoOuKFxfCLWcJkAB+gkgB6AnlEuFwyLdLmpFCR/FhwOFJXd+HX/TYzE?=
 =?us-ascii?Q?jSsp/RYXIHkXdMv6QRibJmevciwaQ8GkhBeBTcceFmU1yVrLxoDVN0xt476T?=
 =?us-ascii?Q?Z2rBPYJ+fhZPdBKZ4WGN11VZSMwNeumhfsDiRoa9+i2VYbct2o+9NVwiC8xX?=
 =?us-ascii?Q?lVOhGgs401cRkfOJrdPXzz5hROshG3yC+92bj9bpxQd5zEntJWpDDUA/VkzG?=
 =?us-ascii?Q?j5QyuTEvD5TA9pyInrbl4SFlUKncZbSC+5jGokKV+gpB+TR1JIkLLxykpioT?=
 =?us-ascii?Q?wvOoL10EXmRlaB6RGoSLFxhlsTiSLJjBt8oV9n0f5Y/pCe0iPiHIlcFd0rLj?=
 =?us-ascii?Q?KP2waXSqO6CDb44OI2LFOoMXRgUmPV+DtEYglHZ/ffGbTgrSI+1kBgbRuVIQ?=
 =?us-ascii?Q?d2MbSEFjVFVx2nV3e9Gdd4IYw5LNEdWXpGaliaHcdF7kYbIIaM5jowvsaR/V?=
 =?us-ascii?Q?5mKeo5CUwWwDcGstAVxmPfbYWfiNyRpOecxhzksQQ+ze6YTS++aX88RwiE3W?=
 =?us-ascii?Q?3GVN3+j61e0yn56IPe3MimfwCYv5IW+iRat+NjokQwynhb92fI8iaE4mqLuS?=
 =?us-ascii?Q?KHvO7logRY1ou8dyY6NjelJdPXtuoHS57QKPE76EKY+Ls/A0x33RHOKkumn6?=
 =?us-ascii?Q?/9rWFDQQF2q4gtV8Vbu8enmmNlej8sWDrVkKr1/QgRcf1owZa0tKh0ePSApL?=
 =?us-ascii?Q?l7GozbGYUPRjlgQsL7BuAG95m0F0rdmbPUEsGJiWiye9xA9i8hxGbd3R/HJn?=
 =?us-ascii?Q?sqEVHQNCc8xry72ndy143SRryAwaMpRsCRx4CDjc0IwuV57rDBzxJMAwOdkj?=
 =?us-ascii?Q?P1+n1F9z6wswMi+ahu3+YHjQ4Drb+9O/dcL6MqaOf4kjI5lqiDsds3AEmnCe?=
 =?us-ascii?Q?jf+PfnvtUtPiSa2QHPJtc+2GSydSilJOvtNChd50aW/qj97LYgl3Q5dtMAGK?=
 =?us-ascii?Q?zQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0acb89ad-de18-4eef-998d-08daf8693b9a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 09:00:08.4244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gCa/tEZ22+bmg9aRLACjvVyKzoiot+61yYOklLShN17TmVo0UZbxTiDOmpGV5PX4vrZDEDGDsgZerKOuwzeCmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9182
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
v2->v3: adapt to ETHTOOL_STATS_SRC_* renaming
v1->v2: patch is new

 include/linux/ethtool.h | 100 ++++++++++++++++++-------------
 net/ethtool/stats.c     | 127 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 187 insertions(+), 40 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 0ccba6612190..6746dee5a3fd 100644
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
@@ -312,28 +307,30 @@ static inline void ethtool_stats_init(u64 *stats, unsigned int n)
  */
 struct ethtool_eth_mac_stats {
 	enum ethtool_mac_stats_src src;
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
@@ -341,7 +338,9 @@ struct ethtool_eth_mac_stats {
  */
 struct ethtool_eth_phy_stats {
 	enum ethtool_mac_stats_src src;
-	u64 SymbolErrorDuringCarrier;
+	struct_group(stats,
+		u64 SymbolErrorDuringCarrier;
+	);
 };
 
 /* Basic IEEE 802.3 MAC Ctrl statistics (30.3.3.*), not otherwise exposed
@@ -349,9 +348,11 @@ struct ethtool_eth_phy_stats {
  */
 struct ethtool_eth_ctrl_stats {
 	enum ethtool_mac_stats_src src;
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
@@ -372,8 +373,10 @@ struct ethtool_eth_ctrl_stats {
  */
 struct ethtool_pause_stats {
 	enum ethtool_mac_stats_src src;
-	u64 tx_pause_frames;
-	u64 rx_pause_frames;
+	struct_group(stats,
+		u64 tx_pause_frames;
+		u64 rx_pause_frames;
+	);
 };
 
 #define ETHTOOL_MAX_LANES	8
@@ -441,13 +444,15 @@ struct ethtool_rmon_hist_range {
  */
 struct ethtool_rmon_stats {
 	enum ethtool_mac_stats_src src;
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
@@ -981,6 +986,21 @@ ethtool_params_from_link_mode(struct ethtool_link_ksettings *link_ksettings,
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
index 26a70320e01d..7294be5855d4 100644
--- a/net/ethtool/stats.c
+++ b/net/ethtool/stats.c
@@ -440,3 +440,130 @@ const struct ethnl_request_ops ethnl_stats_request_ops = {
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
+	emac.src = ETHTOOL_MAC_STATS_SRC_EMAC;
+	pmac.src = ETHTOOL_MAC_STATS_SRC_PMAC;
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
+	emac.src = ETHTOOL_MAC_STATS_SRC_EMAC;
+	pmac.src = ETHTOOL_MAC_STATS_SRC_PMAC;
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
+	emac.src = ETHTOOL_MAC_STATS_SRC_EMAC;
+	pmac.src = ETHTOOL_MAC_STATS_SRC_PMAC;
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
+	emac.src = ETHTOOL_MAC_STATS_SRC_EMAC;
+	pmac.src = ETHTOOL_MAC_STATS_SRC_PMAC;
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
+	emac.src = ETHTOOL_MAC_STATS_SRC_EMAC;
+	pmac.src = ETHTOOL_MAC_STATS_SRC_PMAC;
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

