Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D6066602F
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbjAKQSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235408AbjAKQRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:17:41 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2080.outbound.protection.outlook.com [40.107.247.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C42B1EED5;
        Wed, 11 Jan 2023 08:17:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nISfIWYp9gjHM0yWd/RVkpDjl+YLgjQ2uYHB/cuUOJ8BCtVmr6aKvKhDVYYYH/ng3VXIMQjs7EdRbzvzn1tKxPGNrUeJJu05U4YyCGfFeWglSjgE8aB3NuIe7GA5gzEThv+ay+uurqOCkoRv6+lWAv8aFCyzB1gnOvpKVW9EIwK5E2W7NbqdVi/wPoMpIexKxpM0NJmA1j9ajQvySKtcbT41NMOV5lKKBR1mTVEj85kw+C7VKQayaFdwGtER0YcHiIV7c5hLi98cDrPNg/EVEceueV3ljxbqAm+S8QWzmyF7nTngCov9wRClUeY/M2641BIW7C1Znh6SL0qLudHcMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n5gtlDo9Zu/zdICZlMt4zyblurSebPPn8C34wmr0xHw=;
 b=K3LhjJfIbhgYjkbaRwwB7H3TSe5poe0bYEGT1CpqDC0uDCMXd2wIUGNXHw/1GVlkT4tx/Orhbqt+VWAmrp3FpyIeiRGqYLoRSzwtl95NlR6EjijAQT1YTZ39lQFYZ5D3Y70qa79VpjPXC0skxt5pXSiBKHczTuSHk0gPpDT2mPBl7SUnGSrM34nfDjhUXUPhaKfsEn44wVeJvIwsT22cJSXCaNcSB/5JQsoi+/8RvQxSpr+UEw3RD+L6hu+IF8WoNPZsDvSXCd+G9gVqOeTYw/HQ+jNjnjD0b7jkkakLzS+uOyts09TgZDznYGNR+tYGtufoD0+HYtf8r3QtYaIRvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5gtlDo9Zu/zdICZlMt4zyblurSebPPn8C34wmr0xHw=;
 b=eIE4sibsi8kH/WWc0lW0sTNdjA79HVIQ9rrTcinxLAn42sCosAp2XsyPhSuHRVMcgFo2G8+ZJ32V8cjfZyDkfCpebyVkvoTzsK5xtj0TG2op0PDweqqrdrVei4zoe4+/UrNA2AmkutDGjEXXYcSbHP7tPhMUfjhyF6ys50y6ZOM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8462.eurprd04.prod.outlook.com (2603:10a6:10:2cd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 16:17:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 16:17:22 +0000
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
Subject: [PATCH v2 net-next 04/12] net: ethtool: netlink: retrieve stats from multiple sources (eMAC, pMAC)
Date:   Wed, 11 Jan 2023 18:16:58 +0200
Message-Id: <20230111161706.1465242-5-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: b247e166-ffbe-4a24-0c93-08daf3ef51dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O8SXM24RebcI1bCmPXGFeYdCFEF5lrIKwAgl70As4ZwMJIaZoszKUEodRQD+Hj0T+YLrUzSSx1RiOkiQ5txflbaQ5Q68XXMBPneId8NCk6437zRyXZUWWpV/2sNMra100fFmVA0MPsECVFHo2CS8Wie/B7LN2neZGvhXP9WGMfPg/1+DyfUnVqFo5fIV7BTBV5HP2ckNRVdxO+vqzEkZTBAlrBsSU4Qfa/9tsIvCA/R4NuGHsj2LMuFkGcd1DaORrKwoUhG7+6MNZB0eRYmIAf87rLPDjk7kh1IIqjBBnlRPPPkyqE1MDqoezzHnGa2jU0/6bL+10mrokIWAUqrH6dph2Ccj+EmmeqxISQkHdbugOQGzTN4ZVSWw9UDzAjViedxAV99T42DomgIUdg5RnFWJAI9I7kr98ZY/8vtoy25qr1C6hwsPgdnFP2wIUjy25LuTIVx7f9yE9/Hv5kg/RcbS1onovHNxWO+ffV5OYgg2qMzN8H/eyzFfeQhwNtrSFzP5jGKRvBZvXplmjEMSVmm2bSCqy9gjXGJ+nYNRaRmxJR1NpWJDzPHQDvrnw9disQRHj1UpzrkK65p5IFWwqid0rFislFQxvQKrQW6fL35DNLSO9ejdR0+TwiQZLtzsHB3ZrH9h/5uFxfBPri0NdErf8U71GzJoHfOLAAbjaFOYry3kr5i9Sq2bNZnmYo2JUZ/7jXQSWdMD8b550MD1OPiLBk7BKrdjjoofU7z79Nk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(36756003)(26005)(186003)(8936002)(6666004)(6512007)(6486002)(6506007)(30864003)(1076003)(2616005)(66946007)(5660300002)(66476007)(66556008)(52116002)(7416002)(6916009)(316002)(4326008)(86362001)(41300700001)(38100700002)(38350700002)(478600001)(54906003)(8676002)(83380400001)(44832011)(2906002)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TDfRZYNQS3QHUpSIskNziV2+dFVOd+vdDdzFWi6YXnFK62XTb0w9LYSe3uU4?=
 =?us-ascii?Q?eYPR7b1kZ0rlSnbInmqDT47UbhSD6PvQ52qAUnxzSSG/8PMlw997Zx4DMSli?=
 =?us-ascii?Q?pTxy+QHkHIxQS/RruHToFPF1pT4QoA756TqJ1sf/Fyxt13K8V6gfNccY3GQ8?=
 =?us-ascii?Q?WwUkeRsvSwM3CavEeypy1e0z26xE375JYOLr/dDm+g94wLqlXhORKKIMHyJq?=
 =?us-ascii?Q?jX8GInmLg+qs5BJ5Vc/gjgM2QEEz6NO2qz1+hTb7XXT/uJtXfD6brrOVB+VK?=
 =?us-ascii?Q?kiyHNdbAyhXQgPvYJHu/bhyk+DdPp0YCeSVdNpRwrHoI5LWr4Xnhf8zaE+8H?=
 =?us-ascii?Q?7HkAKSnQ83HA7xpUHqvjPaPPTCOFsJgkjhxcne5oUw73UB5iSag7bvXMUWnz?=
 =?us-ascii?Q?pSqt3e+Ev2Ofx+iCu3qfgA+DVOzSP3xP2zwKdo0zFOlz2gRdEeAcXyEmtnWW?=
 =?us-ascii?Q?qGbTousSEkrty6qFPchRdXHLhZJ4zlpqcwp8/2C6+MpZlsogD/q8MYjj2JTD?=
 =?us-ascii?Q?vqJhKKp1iuYv1QOXhpWf+AYiXMWDBGkn+1plr9KeWXoX6IzcFC+WVOjXYnu+?=
 =?us-ascii?Q?IYbdJKIMTeXSM1kwomeGl8wwpnFrVgu+SMnId4mq0aKtitdG44MyviCo6cVP?=
 =?us-ascii?Q?iXec2EFaBzg/6tSKl/jhDnfXrrBE3iK87c8OU2zM60c4Sp8uNOgpuFfuTglw?=
 =?us-ascii?Q?/BPnpCX9fd2e4oLz6pWrtgOwXIaubAshrgS9mBwMm1cMlzClv5Y+uf8fGQRW?=
 =?us-ascii?Q?yQbOw9+nBwI+oVL42VjBtRSIwIcWmobcIjuuSvdDg3FiQGc1NalVbqanSBJN?=
 =?us-ascii?Q?ZlyJbhRoainf827GE6fi9jUR6SpGgnviGSO9AA1/CWfwQhQpURg4z+Z1bUx5?=
 =?us-ascii?Q?o2klM//JxrVrGwwx5vrGhxEzymMwFWc5Zqu29Dftn8uriXqrsDhhxmjZ8v/W?=
 =?us-ascii?Q?aCGrc2LlDqA4tnOeZtABCGkl7Hrl7XX2mGoSwClQ+y2TdT0AlzQqYQ7F5HAI?=
 =?us-ascii?Q?/fxeKr5P/fIMKcIhUghf1Z/e2Z+jobmNG/c23OJvK5Qhq4/jRzSv9jeCd4IR?=
 =?us-ascii?Q?zCpKJVtL02EPqeLRRaSeaImEjpf5/ky2VOY4w/JUMpin9XSYfu+g3BpYqAnA?=
 =?us-ascii?Q?svt+mKDY0RL+MjKU3HhnD/Y28fx69Aq+tgtYtdGmLQXdf6lO+hlFCp9/W0i2?=
 =?us-ascii?Q?SZn1CCpB40P68z+cV52IaVbt+jZF9wRF1vEn0OehWcmAvDs5QkScjav35yJm?=
 =?us-ascii?Q?x1d4ysTMRQEWTnP9XukX28mmP0YmcVbc4tM0AuzlReOGp/rP+ogh9yoIPDhm?=
 =?us-ascii?Q?x7Z6+EcMh6dKLOTHBXVgUwstHUW0dqcYK+a22QdmQ7Wg1IBg7Zdp2pJW/AmL?=
 =?us-ascii?Q?6vewh/X1TW6lwV61oU2f8WrgXNCvBxYJDwg947teFoYQX6GYXcnrRho5lA0a?=
 =?us-ascii?Q?6wF/su9x+71QWDNKoz0hJ7U1ILBxEGs1JswthUSNoz41ricv1JV1mKnHebTi?=
 =?us-ascii?Q?JMdOAKoXiduv2Zyzm8QDCq0itwVJz8k1y1cgTM5lK5iNUS9UwOG/Gtb9KbeM?=
 =?us-ascii?Q?qGENyO2HahvohnbzPI4FUQ3enCcHx+/5t3/ctBN+O5FrR53g0kXguyYPNWlj?=
 =?us-ascii?Q?AA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b247e166-ffbe-4a24-0c93-08daf3ef51dd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 16:17:22.5020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v1dbGJB/EupKsXh+8tTrfxSoH3z0BxmzH74ZHCIdK1zWV1kH3awdYBFaWu6WskSvcCe1N0lwa5eCXCml3+oHtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8462
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE 802.3-2018 clause 99 defines a MAC Merge sublayer which contains an
Express MAC and a Preemptable MAC. Both MACs are hidden to higher and
lower layers and visible as a single MAC (packet classification to eMAC
or pMAC on TX is done based on priority; classification on RX is done
based on SFD).

For devices which support a MAC Merge sublayer, it is desirable to
retrieve individual packet counters from the eMAC and the pMAC, as well
as aggregate statistics (their sum).

Introduce a new ETHTOOL_A_STATS_SRC attribute which is part of the
policy of ETHTOOL_MSG_STATS_GET and, and an ETHTOOL_A_PAUSE_STATS_SRC
which is part of the policy of ETHTOOL_MSG_PAUSE_GET (accepted when
ETHTOOL_FLAG_STATS is set in the common ethtool header). Both of these
take values from enum ethtool_stats_src, defaulting to "aggregate" in
the absence of the attribute.

Existing drivers do not need to pay attention to this enum which was
added to all driver-facing structures, just the ones which report the
MAC merge layer as supported.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new (Jakub's suggestion)

 include/linux/ethtool.h              |  9 ++++++
 include/uapi/linux/ethtool.h         | 18 +++++++++++
 include/uapi/linux/ethtool_netlink.h |  3 ++
 net/ethtool/common.h                 |  2 ++
 net/ethtool/mm.c                     | 15 +++++++++
 net/ethtool/netlink.h                |  4 +--
 net/ethtool/pause.c                  | 47 ++++++++++++++++++++++++++++
 net/ethtool/stats.c                  | 31 ++++++++++++++++--
 8 files changed, 125 insertions(+), 4 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 6336f105e667..06672b76b2c6 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -301,6 +301,7 @@ static inline void ethtool_stats_init(u64 *stats, unsigned int n)
  * via a more targeted API.
  */
 struct ethtool_eth_mac_stats {
+	enum ethtool_stats_src src;
 	u64 FramesTransmittedOK;
 	u64 SingleCollisionFrames;
 	u64 MultipleCollisionFrames;
@@ -329,6 +330,7 @@ struct ethtool_eth_mac_stats {
  * via a more targeted API.
  */
 struct ethtool_eth_phy_stats {
+	enum ethtool_stats_src src;
 	u64 SymbolErrorDuringCarrier;
 };
 
@@ -336,6 +338,7 @@ struct ethtool_eth_phy_stats {
  * via a more targeted API.
  */
 struct ethtool_eth_ctrl_stats {
+	enum ethtool_stats_src src;
 	u64 MACControlFramesTransmitted;
 	u64 MACControlFramesReceived;
 	u64 UnsupportedOpcodesReceived;
@@ -343,6 +346,8 @@ struct ethtool_eth_ctrl_stats {
 
 /**
  * struct ethtool_pause_stats - statistics for IEEE 802.3x pause frames
+ * @src: input field denoting whether stats should be queried from the eMAC or
+ *	pMAC (if the MM layer is supported). To be ignored otherwise.
  * @tx_pause_frames: transmitted pause frame count. Reported to user space
  *	as %ETHTOOL_A_PAUSE_STAT_TX_FRAMES.
  *
@@ -356,6 +361,7 @@ struct ethtool_eth_ctrl_stats {
  *	from the standard.
  */
 struct ethtool_pause_stats {
+	enum ethtool_stats_src src;
 	u64 tx_pause_frames;
 	u64 rx_pause_frames;
 };
@@ -407,6 +413,8 @@ struct ethtool_rmon_hist_range {
 
 /**
  * struct ethtool_rmon_stats - selected RMON (RFC 2819) statistics
+ * @src: input field denoting whether stats should be queried from the eMAC or
+ *	pMAC (if the MM layer is supported). To be ignored otherwise.
  * @undersize_pkts: Equivalent to `etherStatsUndersizePkts` from the RFC.
  * @oversize_pkts: Equivalent to `etherStatsOversizePkts` from the RFC.
  * @fragments: Equivalent to `etherStatsFragments` from the RFC.
@@ -422,6 +430,7 @@ struct ethtool_rmon_hist_range {
  * ranges is left to the driver.
  */
 struct ethtool_rmon_stats {
+	enum ethtool_stats_src src;
 	u64 undersize_pkts;
 	u64 oversize_pkts;
 	u64 fragments;
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 7ddc47a3fb32..16230dc6a8c1 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -711,6 +711,24 @@ enum ethtool_stringset {
 	ETH_SS_COUNT
 };
 
+/**
+ * enum ethtool_stats_src - source of ethtool statistics
+ * @ETHTOOL_STATS_SRC_AGGREGATE:
+ *	if device supports a MAC merge layer, this retrieves the aggregate
+ *	statistics of the eMAC and pMAC. Otherwise, it retrieves just the
+ *	statistics of the single (express) MAC.
+ * @ETHTOOL_STATS_SRC_EMAC:
+ *	if device supports a MM layer, this retrieves the eMAC statistics.
+ *	Otherwise, it retrieves the statistics of the single (express) MAC.
+ * @ETHTOOL_STATS_SRC_PMAC:
+ *	if device supports a MM layer, this retrieves the pMAC statistics.
+ */
+enum ethtool_stats_src {
+	ETHTOOL_STATS_SRC_AGGREGATE,
+	ETHTOOL_STATS_SRC_EMAC,
+	ETHTOOL_STATS_SRC_PMAC,
+};
+
 /**
  * enum ethtool_module_power_mode_policy - plug-in module power mode policy
  * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH: Module is always in high power mode.
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index e84a80957138..e938a7a50944 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -419,6 +419,7 @@ enum {
 	ETHTOOL_A_PAUSE_RX,				/* u8 */
 	ETHTOOL_A_PAUSE_TX,				/* u8 */
 	ETHTOOL_A_PAUSE_STATS,				/* nest - _PAUSE_STAT_* */
+	ETHTOOL_A_PAUSE_STATS_SRC,			/* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_PAUSE_CNT,
@@ -735,6 +736,8 @@ enum {
 
 	ETHTOOL_A_STATS_GRP,			/* nest - _A_STATS_GRP_* */
 
+	ETHTOOL_A_STATS_SRC,			/* u32 */
+
 	/* add new constants above here */
 	__ETHTOOL_A_STATS_CNT,
 	ETHTOOL_A_STATS_MAX = (__ETHTOOL_A_STATS_CNT - 1)
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index b1b9db810eca..28b8aaaf9bcb 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -54,4 +54,6 @@ int ethtool_get_module_info_call(struct net_device *dev,
 int ethtool_get_module_eeprom_call(struct net_device *dev,
 				   struct ethtool_eeprom *ee, u8 *data);
 
+bool __ethtool_dev_mm_supported(struct net_device *dev);
+
 #endif /* _ETHTOOL_COMMON_H */
diff --git a/net/ethtool/mm.c b/net/ethtool/mm.c
index 01a2acc40046..b99fdfa49a32 100644
--- a/net/ethtool/mm.c
+++ b/net/ethtool/mm.c
@@ -256,3 +256,18 @@ int ethnl_set_mm(struct sk_buff *skb, struct genl_info *info)
 	dev_put(dev);
 	return ret;
 }
+
+/* Returns whether a given device supports the MAC merge layer
+ * (has an eMAC and a pMAC). Must be called under rtnl_lock() and
+ * ethnl_ops_begin().
+ */
+bool __ethtool_dev_mm_supported(struct net_device *dev)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	struct ethtool_mm_state state = {};
+
+	if (ops && ops->get_mm)
+		ops->get_mm(dev, &state);
+
+	return state.supported;
+}
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index a8012dbe39bb..43d2a7c98a3d 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -397,7 +397,7 @@ extern const struct nla_policy ethnl_channels_get_policy[ETHTOOL_A_CHANNELS_HEAD
 extern const struct nla_policy ethnl_channels_set_policy[ETHTOOL_A_CHANNELS_COMBINED_COUNT + 1];
 extern const struct nla_policy ethnl_coalesce_get_policy[ETHTOOL_A_COALESCE_HEADER + 1];
 extern const struct nla_policy ethnl_coalesce_set_policy[ETHTOOL_A_COALESCE_MAX + 1];
-extern const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_HEADER + 1];
+extern const struct nla_policy ethnl_pause_get_policy[ETHTOOL_A_PAUSE_STATS_SRC + 1];
 extern const struct nla_policy ethnl_pause_set_policy[ETHTOOL_A_PAUSE_TX + 1];
 extern const struct nla_policy ethnl_eee_get_policy[ETHTOOL_A_EEE_HEADER + 1];
 extern const struct nla_policy ethnl_eee_set_policy[ETHTOOL_A_EEE_TX_LPI_TIMER + 1];
@@ -408,7 +408,7 @@ extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INF
 extern const struct nla_policy ethnl_fec_get_policy[ETHTOOL_A_FEC_HEADER + 1];
 extern const struct nla_policy ethnl_fec_set_policy[ETHTOOL_A_FEC_AUTO + 1];
 extern const struct nla_policy ethnl_module_eeprom_get_policy[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS + 1];
-extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1];
+extern const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_SRC + 1];
 extern const struct nla_policy ethnl_phc_vclocks_get_policy[ETHTOOL_A_PHC_VCLOCKS_HEADER + 1];
 extern const struct nla_policy ethnl_module_get_policy[ETHTOOL_A_MODULE_HEADER + 1];
 extern const struct nla_policy ethnl_module_set_policy[ETHTOOL_A_MODULE_POWER_MODE_POLICY + 1];
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index a8c113d244db..f3eac539f9a4 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -5,8 +5,12 @@
 
 struct pause_req_info {
 	struct ethnl_req_info		base;
+	enum ethtool_stats_src		src;
 };
 
+#define PAUSE_REQINFO(__req_base) \
+	container_of(__req_base, struct pause_req_info, base)
+
 struct pause_reply_data {
 	struct ethnl_reply_data		base;
 	struct ethtool_pauseparam	pauseparam;
@@ -19,13 +23,40 @@ struct pause_reply_data {
 const struct nla_policy ethnl_pause_get_policy[] = {
 	[ETHTOOL_A_PAUSE_HEADER]		=
 		NLA_POLICY_NESTED(ethnl_header_policy_stats),
+	[ETHTOOL_A_PAUSE_STATS_SRC]		=
+		NLA_POLICY_MAX(NLA_U32, ETHTOOL_STATS_SRC_PMAC),
 };
 
+static int pause_parse_request(struct ethnl_req_info *req_base,
+			       struct nlattr **tb,
+			       struct netlink_ext_ack *extack)
+{
+	struct pause_req_info *req_info = PAUSE_REQINFO(req_base);
+	enum ethtool_stats_src src = ETHTOOL_STATS_SRC_AGGREGATE;
+
+	if (tb[ETHTOOL_A_PAUSE_STATS_SRC]) {
+		if (!(req_base->flags & ETHTOOL_FLAG_STATS)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "ETHTOOL_FLAG_STATS must be set when requesting a source of stats");
+			return -EINVAL;
+		}
+
+		src = nla_get_u32(tb[ETHTOOL_A_PAUSE_STATS_SRC]);
+	}
+
+	req_info->src = src;
+
+	return 0;
+}
+
 static int pause_prepare_data(const struct ethnl_req_info *req_base,
 			      struct ethnl_reply_data *reply_base,
 			      struct genl_info *info)
 {
+	const struct pause_req_info *req_info = PAUSE_REQINFO(req_base);
 	struct pause_reply_data *data = PAUSE_REPDATA(reply_base);
+	struct netlink_ext_ack *extack = info->extack;
+	enum ethtool_stats_src src = req_info->src;
 	struct net_device *dev = reply_base->dev;
 	int ret;
 
@@ -34,14 +65,25 @@ static int pause_prepare_data(const struct ethnl_req_info *req_base,
 
 	ethtool_stats_init((u64 *)&data->pausestat,
 			   sizeof(data->pausestat) / 8);
+	data->pausestat.src = src;
 
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		return ret;
+
+	if ((src == ETHTOOL_STATS_SRC_EMAC || src == ETHTOOL_STATS_SRC_PMAC) &&
+	    !__ethtool_dev_mm_supported(dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Device does not support MAC merge layer");
+		ethnl_ops_complete(dev);
+		return -EOPNOTSUPP;
+	}
+
 	dev->ethtool_ops->get_pauseparam(dev, &data->pauseparam);
 	if (req_base->flags & ETHTOOL_FLAG_STATS &&
 	    dev->ethtool_ops->get_pause_stats)
 		dev->ethtool_ops->get_pause_stats(dev, &data->pausestat);
+
 	ethnl_ops_complete(dev);
 
 	return 0;
@@ -56,6 +98,7 @@ static int pause_reply_size(const struct ethnl_req_info *req_base,
 
 	if (req_base->flags & ETHTOOL_FLAG_STATS)
 		n += nla_total_size(0) +	/* _PAUSE_STATS */
+		     nla_total_size(sizeof(u32)) + /* _PAUSE_STATS_SRC */
 		     nla_total_size_64bit(sizeof(u64)) * ETHTOOL_PAUSE_STAT_CNT;
 	return n;
 }
@@ -77,6 +120,9 @@ static int pause_put_stats(struct sk_buff *skb,
 	const u16 pad = ETHTOOL_A_PAUSE_STAT_PAD;
 	struct nlattr *nest;
 
+	if (nla_put_u32(skb, ETHTOOL_A_PAUSE_STATS_SRC, pause_stats->src))
+		return -EMSGSIZE;
+
 	nest = nla_nest_start(skb, ETHTOOL_A_PAUSE_STATS);
 	if (!nest)
 		return -EMSGSIZE;
@@ -121,6 +167,7 @@ const struct ethnl_request_ops ethnl_pause_request_ops = {
 	.req_info_size		= sizeof(struct pause_req_info),
 	.reply_data_size	= sizeof(struct pause_reply_data),
 
+	.parse_request		= pause_parse_request,
 	.prepare_data		= pause_prepare_data,
 	.reply_size		= pause_reply_size,
 	.fill_reply		= pause_fill_reply,
diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
index a20e0a24ff61..9238d99f560b 100644
--- a/net/ethtool/stats.c
+++ b/net/ethtool/stats.c
@@ -7,6 +7,7 @@
 struct stats_req_info {
 	struct ethnl_req_info		base;
 	DECLARE_BITMAP(stat_mask, __ETHTOOL_STATS_CNT);
+	enum ethtool_stats_src		src;
 };
 
 #define STATS_REQINFO(__req_base) \
@@ -75,10 +76,12 @@ const char stats_rmon_names[__ETHTOOL_A_STATS_RMON_CNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_A_STATS_RMON_JABBER]		= "etherStatsJabbers",
 };
 
-const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_GROUPS + 1] = {
+const struct nla_policy ethnl_stats_get_policy[ETHTOOL_A_STATS_SRC + 1] = {
 	[ETHTOOL_A_STATS_HEADER]	=
 		NLA_POLICY_NESTED(ethnl_header_policy),
 	[ETHTOOL_A_STATS_GROUPS]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_STATS_SRC]		=
+		NLA_POLICY_MAX(NLA_U32, ETHTOOL_STATS_SRC_PMAC),
 };
 
 static int stats_parse_request(struct ethnl_req_info *req_base,
@@ -86,6 +89,7 @@ static int stats_parse_request(struct ethnl_req_info *req_base,
 			       struct netlink_ext_ack *extack)
 {
 	struct stats_req_info *req_info = STATS_REQINFO(req_base);
+	enum ethtool_stats_src src = ETHTOOL_STATS_SRC_AGGREGATE;
 	bool mod = false;
 	int err;
 
@@ -100,6 +104,11 @@ static int stats_parse_request(struct ethnl_req_info *req_base,
 		return -EINVAL;
 	}
 
+	if (tb[ETHTOOL_A_STATS_SRC])
+		src = nla_get_u32(tb[ETHTOOL_A_STATS_SRC]);
+
+	req_info->src = src;
+
 	return 0;
 }
 
@@ -109,6 +118,8 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 {
 	const struct stats_req_info *req_info = STATS_REQINFO(req_base);
 	struct stats_reply_data *data = STATS_REPDATA(reply_base);
+	struct netlink_ext_ack *extack = info->extack;
+	enum ethtool_stats_src src = req_info->src;
 	struct net_device *dev = reply_base->dev;
 	int ret;
 
@@ -116,11 +127,24 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 	if (ret < 0)
 		return ret;
 
+	if ((src == ETHTOOL_STATS_SRC_EMAC || src == ETHTOOL_STATS_SRC_PMAC) &&
+	    !__ethtool_dev_mm_supported(dev)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Device does not support MAC merge layer");
+		ethnl_ops_complete(dev);
+		return -EOPNOTSUPP;
+	}
+
 	/* Mark all stats as unset (see ETHTOOL_STAT_NOT_SET) to prevent them
 	 * from being reported to user space in case driver did not set them.
 	 */
 	memset(&data->stats, 0xff, sizeof(data->stats));
 
+	data->phy_stats.src = src;
+	data->mac_stats.src = src;
+	data->ctrl_stats.src = src;
+	data->rmon_stats.src = src;
+
 	if (test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask) &&
 	    dev->ethtool_ops->get_eth_phy_stats)
 		dev->ethtool_ops->get_eth_phy_stats(dev, &data->phy_stats);
@@ -143,8 +167,8 @@ static int stats_reply_size(const struct ethnl_req_info *req_base,
 			    const struct ethnl_reply_data *reply_base)
 {
 	const struct stats_req_info *req_info = STATS_REQINFO(req_base);
+	int len = nla_total_size(sizeof(u32)); /* _STATS_SRC */
 	unsigned int n_grps = 0, n_stats = 0;
-	int len = 0;
 
 	if (test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask)) {
 		n_stats += sizeof(struct ethtool_eth_phy_stats) / sizeof(u64);
@@ -379,6 +403,9 @@ static int stats_fill_reply(struct sk_buff *skb,
 	const struct stats_reply_data *data = STATS_REPDATA(reply_base);
 	int ret = 0;
 
+	if (nla_put_u32(skb, ETHTOOL_A_STATS_SRC, req_info->src))
+		return -EMSGSIZE;
+
 	if (!ret && test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask))
 		ret = stats_put_stats(skb, data, ETHTOOL_STATS_ETH_PHY,
 				      ETH_SS_STATS_ETH_PHY,
-- 
2.34.1

