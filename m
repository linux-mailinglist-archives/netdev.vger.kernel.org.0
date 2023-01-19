Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D26C673872
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjASM3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjASM16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:27:58 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2079.outbound.protection.outlook.com [40.107.14.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1531C457DD;
        Thu, 19 Jan 2023 04:27:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUpMWmw5bAQkgJEQuM4IE1M4j0a0eNpXl25PFK12i+h8bXzJB2rcRSkt1LQP0LvBkYL+Wbak28AtQLijCYatFxuW3TTKEQ9MZJ/iAKi4vIqJRItjP9p6tuVRasgbOBZ7z6DI3brCK1R1m1HMYFnKsQUa/ZUJuNw9Ro+3mO4ukmPHmOzGdIth/f52rNwIXCiLB9DfguZhe/nGN8nFpnD07Dk/p3KcMFJopgw3DWQkC2HlAky0DlnHuFRPTmqjowrScUWsjfkeswJWumtWVZsz3G/6M2O9I4PBoXyKGmNSM6QBkfJzbXYmkFVPHAXuyj0oIkMS/ZC+1VDfEScFaJOlKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RlTug8VnVJuExMcXrxSgCTUdzrxOKK8UQ3QgGJX0lWk=;
 b=nMNp0TeFj3ehC0zW3HrAnXcWbRFSanO7anI3GzbqDRp6N8hkmFMvc9pl6cyY/L+1ssx90nJBhA7DAsTvVyRw0TgXTRObXFWGeBSMARM2B9mt1GhrQN/ZU/9wVlJjgSEy55Jkl0YkPloUVE89Y3yjJksNPmXO+7DcoA5yAjvkzFZlYnACZHN7LX8eOwDtDcMX8QzP/c9tY3yfW1r1lFS9nlbQE+5v5M37WaxShMf9vuVp/F8HbaFw5l0oAmAqPspNefHV66m7+iFT/QblKZMHZIb41q6P//WVLiQeBGzy4+Bhw/0ZFaQ4OYuUfU23F/+Q5DJMRWHtz9r5cCGjr762sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RlTug8VnVJuExMcXrxSgCTUdzrxOKK8UQ3QgGJX0lWk=;
 b=KmoloQG6xaUQA1nuPAcA2sF8cm2xy2u9d9LcsmGAICyNboA4fy0XPE2DhAGCh8noZwMt+LTBX9Vd0RL9s5lG6+OUUbJ2QzaB59XZFefuW6vfAd6lF0jyGQr1kwl5mxKOyJdL/fK6g9BNQpub0Psi6cnqiO3aI8Yp7aVD3jeHlQ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9376.eurprd04.prod.outlook.com (2603:10a6:102:2b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 12:27:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 12:27:51 +0000
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
Subject: [PATCH v4 net-next 06/12] net: ethtool: add helpers for aggregate statistics
Date:   Thu, 19 Jan 2023 14:26:58 +0200
Message-Id: <20230119122705.73054-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230119122705.73054-1-vladimir.oltean@nxp.com>
References: <20230119122705.73054-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9376:EE_
X-MS-Office365-Filtering-Correlation-Id: b0706ed6-2d5c-43bc-0a3e-08dafa1894ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W8QNPCYJjLqvL9iF2xH7NowBEaowqr7ypARDvr4BLTyrLcXqO58ay+UD0oSGSTdzm2FSQeg+nB/GIbO4sJnS1f0QGLrJCwQqgTCoDzKcgAYSa9NaXWAfscF3DovtEvj13h1braLDNCI+s8xlyawIvYz64j2xb/h5cG+2lTCLunDU/5Fn80kngnSXwe92MJuHslxuVRQswHmRHs0VL7ueLB5qseworSF5j6tgurE72iSes8bsuonnin+uhRVvy3P5njJJRMmGk540FcGunMoLO8dL900xeAlZiEyuxjO/3x1bt7FMbkiPyV3y7O7QKz24GKCR8mC0atwjQzDsrJMrwQPw0DaAoErOiyuPXw5lJ5DUv33nQHvaGnaxpup6n4Ch1ey0g3NyOFZbt5EqdqNK5vWhfJoR3g+Zi1CWEIlyNU/fNZZYrEJMaqPq+VAoiauk30EMbl+Dks3iEV3L/nZPhICWyqa6VxyUp9TbWj5Ng/irOksl1fxeq9mKi+gnMAVCHDHOvYoLo7aC66TxJxyak+fcG1n4P9tOjq/YPdkAUq7v7gIYR/qeD1s2KIzj2jEDYNb0IzOp/8hy3k4PjDum9MNv2U2zEoQmvhubQZHXZrssPDFxRXbQfR3gK0Q0vwP7u/toEnN41nFdA5I8RNlnqr1DjB6JJULHQlhdELSeux3KKOF8izmVy+4M8aZoUA/I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199015)(6506007)(66946007)(66476007)(44832011)(66556008)(7416002)(8936002)(5660300002)(2906002)(38350700002)(38100700002)(316002)(54906003)(52116002)(86362001)(36756003)(4326008)(6486002)(478600001)(6916009)(41300700001)(8676002)(26005)(1076003)(6512007)(186003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i3rWvqJNAPBalo9RHQgAumAaOE13nGJckWZXmBqjvbThSK/MPQQ0T5F7VxU7?=
 =?us-ascii?Q?JZy/SIRTHgI+7ZVfj6/GDtYSw7WQCzK48EHpgb/Pa+NyfxkLBSE0V/GlWbgX?=
 =?us-ascii?Q?yAWvTejosSjZ7sgtmXjQbwFRpSEcsKw6wAeEPKirQ+baxXTQ0cY00MBafVrZ?=
 =?us-ascii?Q?Nkn0rl6cKGOLwPl53j+LrR0LGbIykn2LNn7oReqiEERiOPh1Xz/ag8HLJQH/?=
 =?us-ascii?Q?JqovZ75kTXK6QOgre+fTbHI/9qVw8yFvC25vLbMO6B7LshHkmdtIwNP3+cW7?=
 =?us-ascii?Q?HfCZjNUCQ7UjIfIbjsqQWffaflbZi70mpI/k9LyXQ8r9TKXY2rXAPT93yoEs?=
 =?us-ascii?Q?lAvP3PPQrgxcnOgTX4TjkYFOgy70O4rVhfDSijFnN8uQYAr5DvAXlTodoaQz?=
 =?us-ascii?Q?qDNz2/cnPmZ42UQxMeRXOmoSdKqmDYYkf2P1751LBzRsTg4DB7TyCynZAUN0?=
 =?us-ascii?Q?LgOnXDJxOeFtM36PSl+6D+MS+dUCR89OSehuphYPSU5jQZ9Y5zukjWIgW8ey?=
 =?us-ascii?Q?a9SwZcqI50laLAKhj4Az3I0o2p6rOuvrPDZUtVG50UaVC+txbeMgL7dd7NQB?=
 =?us-ascii?Q?K33BiotkRJeCe+XDssImKd1xJKcnHSGjF6Zk8HcCnR7QIhPZCm6gcAjxtMpi?=
 =?us-ascii?Q?zd8dQcscEg9k3bcGZvH6tuvQe/+C9V3ajhOEFmf78Afoq0tQb3Dfh5GlD0dJ?=
 =?us-ascii?Q?QxfiMCxMkIxflL1M3siGaZuZc8apJsQdN4LLvjy2YCxpmrL2tkDrnJZVCRRH?=
 =?us-ascii?Q?Og4DtgEz6bWeT6zpiCHmWyV6ut24k+5qdWzUYfO/4h9r8yuj2bnGvHn9/ya5?=
 =?us-ascii?Q?DtR4c1p0y0cYYyHyhEAFhEoiJmrda0BwgM3Ud7isTpRnVX4RtRAHNR+UCM7m?=
 =?us-ascii?Q?daLHkgRVI+tORqm2WeQ7+Iyavg2xFVbOqehEhbtqAP/TqfNz3Ni98Jf0n9MQ?=
 =?us-ascii?Q?JcEpiCSgWej/htPLgh3+HWUyc48+mGPXg6QmuIRkH2Kaa32/sw2+zvqs/kXG?=
 =?us-ascii?Q?SGxJNWg+gloncr+Eqz1l9Y5ddlfIOg90npTIO2ejnOZQqTyKEiWjoJCuAAfa?=
 =?us-ascii?Q?Ec424lgAXR4NpVwB8DGQb2Ej0pPv8CzbEQUgh8Ipqb582elF39k7hsjfTauE?=
 =?us-ascii?Q?LZQVa+0H6/VVmKA28QImVPgXuL4SEIsBTotH0UBQbPe/P27veh7HRMMOzhTG?=
 =?us-ascii?Q?HgAvTqoJx9IqQFQFOdBZR5VR4l4dbKdibQbQnqNAx+/E0AQPTkN1KiOYcWu3?=
 =?us-ascii?Q?DXhQaHRGqCnQ+462Q4ZvihEcJIV97hF1pz6bUL9GuZZpXpUOYQDP/mQiJ8Co?=
 =?us-ascii?Q?C7ZC50nAq4lxeAT2/2f/lsYhPPeQtume+Czqcs0CSer1uSpxMzb26ofnopnH?=
 =?us-ascii?Q?65mIP2robQK/JZ2bXk4fnWLzO/SORNu9bOwGajI8/D/8KJWOLI3pacyNNlOn?=
 =?us-ascii?Q?JnGNc+OiAT0Bsu8zAOF+r/IT8DDbkRc31SJXuvwSElziMxTNekMh7jsihoRA?=
 =?us-ascii?Q?NEdlEjGm3I8yhPg+/08adMEUAgeRoXrXxgUFMzQ5ucKgOFm6yUdt64h1UaHq?=
 =?us-ascii?Q?BXm2NaFXp2yyMvSNTix7gLcW2s97DLSELs43tgee++FStlzdA5vOgcqqJjyg?=
 =?us-ascii?Q?ZA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0706ed6-2d5c-43bc-0a3e-08dafa1894ce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 12:27:51.2786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eOZesaeWoDqD5eK9TKzIcgXjc4q9Dz79K0wsctVQo5yUcQrRPLuRbWPCulUbB/eI0en53tB4qDwj8FxsBToUWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9376
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
v3->v4: none
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

