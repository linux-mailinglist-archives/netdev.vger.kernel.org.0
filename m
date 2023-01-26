Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A16D67CB60
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbjAZMy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236452AbjAZMyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:54:38 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2067.outbound.protection.outlook.com [40.107.20.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72616DB14
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:54:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INKodDiV3UA3NGkp/m3+GNbSk3uKUuz2q/zaOipVCDBx6kr2N+PB2rNfoIEFhuniV1FmErS3QtolEAMpEpOl5kwsytSDUadzAxfDjTmr4L1hhp7Zwu0l2iqg6WoN0Y8QU3/L4n9qVxFUD96TK3N8UbZVD0a4Jw9iUhqBzATEzqB+XRX5Wb+FGr6w2fsBm2ir9VwJzjUQjXMiN2K7QuOM5MRFO8acShFCtR4okbG9KyMTmD3S99pJav7Aj8fhVjRsMxEbt8I0nexZ1GAcESjuwHIz218vlueM8qccagKNsG8T8RdKgdbHWowjFQ2kL1MzUjUDvtgU40QxRrdhyDxDjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ON679zPc6YqZLnxJtZrq8pWVB7vLF+2B0I4J3oXEo6A=;
 b=Hfmk+bbJXJH8d9HoNg0g+tfcCrVe6ia//XiA0KV392ydTwBjAg1o+ZV5YAwadYeCglGt8dltnAcby990w0WZlQ82wWbYLIRAwigfiNFLghVkzntTQ7Ti49RucS2370Nsz2+XzNUAYx5yxSU83GMTlBt1+5p1LEirX9wjq6elC+I7FePOWPBMUIOxy4fMHKCK5ToScxxxbCRSga+HUogtA4wj6qumgjUKhyr5WK80dsNwKuvyDpTDFmVL8a/No4pSCvL/F8zJIGipmKAr7nddBZT9ZfkIM+/ZZQo612Jbxbk3BWElC8nreMj11SxTOh4UF6+CBEudBQGEG8WsjUN88Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ON679zPc6YqZLnxJtZrq8pWVB7vLF+2B0I4J3oXEo6A=;
 b=JCp18l6WKlLfqMLTI7ZTixWDh7sAtfrpZLaRUWCIcGdmzAH2XRIkz1zr62/UkkTmnxMwWDp8q4nAAhip+OdE3FzAqvmZLyL+g4lfp+OHGQ83MJe2RejWCZul1CK+df9gvis+Zi5RdT4QJSDy65MjLu42VY7qQ8ytlggtFHbqswo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 12:53:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 12:53:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH v2 net-next 15/15] net/sched: taprio: only calculate gate mask per TXQ for igc, stmmac and tsnep
Date:   Thu, 26 Jan 2023 14:53:08 +0200
Message-Id: <20230126125308.1199404-16-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
References: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0123.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: f47081be-84e8-484d-c747-08daff9c5eac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /xeuYQPNxcy17tfGMEwhwjx+oy7P4Vtk4kmjWXhAlTpWArlfO2qQw0gWBbZqVCW4W+EACdTSImMOucJEEwPsMvIURABPLt1+eKnN0+pX2jq9EddqWQsOg+HWy+C/t1cjdAPagGErd0U5BUqqEnlGYZLmf6a4jgOWcD6lyf/cKQWeKYKdLbBXqzjIMuuTubdhzhhNwsTuWX8/OmjBt8di5+ODcXzTKSVmfLUuTNfrn7NGsHBLlnxt0eZ1Fa8550SpGGSd9vpbK5huxjXMPB+jFTNLdNyWBfqSdbcz6kddbKrs5oVlBr5b4T1mZdKrwXt0144f2QNfcnE/rszB9x63l5L0zYTV/RisVXAQg4i4308VZylB9WnXg283TUt6SoTr0Xy00IwMqtsXJ9P+wsMoTvydgHMlxHpUs3baey6jSvnznhdwmL6gsjQ5x2lXM8K1vILpntLRk4CXqQtl7tJdxIQTJ6y2eYJ1Fwj6UQ6YosNaOEp00GonqSYdn/zOcydY5S5znHLRxQYuBf307pOnUxn7QQHgCFpNogMUMXqsEtayAXXY1ijmtpb1EBv87mgrbGauuO9kItWCq4eJvptP+MngzjZi4r5RVpUUmPlWnJ/uqMWtF/zdhVITcnqstQG+0d0XnjsrUD290+0OiFiJmkTUIIkHqR1u6XKKiVwxlcNHwdZaVLhYkmSZt/o/cCMnQBr8Qr3LiIdP5j8IZyHRCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(451199018)(26005)(83380400001)(38350700002)(38100700002)(5660300002)(2906002)(7416002)(30864003)(41300700001)(86362001)(6506007)(8936002)(4326008)(44832011)(6666004)(316002)(186003)(6512007)(66476007)(66556008)(8676002)(2616005)(478600001)(54906003)(6916009)(36756003)(66946007)(6486002)(52116002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7KRGPwYtaA4twGVMwIUciMm37CvW0t5Ykls1Jpv/Ul9qfuRaBAQdC6Wn0IB2?=
 =?us-ascii?Q?lGXufvtfM+1hKSlzClm57tn+59HRGjNOfauO4fCQQ0lZNX6EwmJdTZINcrKc?=
 =?us-ascii?Q?ixUwYTOE3cOkvkpTkloed90WwPKWM2OfqOxC69YZOYf80+SqR4uEGbdR/R7k?=
 =?us-ascii?Q?bMt5h/eTuGvSbjxAtXOXzFMtemjbBOpSBaV0mvQX/d6WkZp+VVYPVJULFcsF?=
 =?us-ascii?Q?2qQIy5wjaJjZ7yrla/9Je9ZFtsAAIeQz3vTsu3WhYfke1jqIL0yVnsLgFCsB?=
 =?us-ascii?Q?9/C7gHqJG1JGP7AfjBtQ/7SnA8MVR8EPjdpoOUvgYu32a5gD3J50lwo+kaSB?=
 =?us-ascii?Q?K6xXHTxBTU1T8+rt2X+J74Ssxn6YP2HIxKibAlIuOsYKv6sDzZD/xqF5OGle?=
 =?us-ascii?Q?RYetykRcsoDF8+jtmzuDvtgI++uOtGbiKx6s6z4fWe5W7ADJdiwOAiHNaMhS?=
 =?us-ascii?Q?wjQYCQib95ruKTVEFzu3/4xCd7s+1LSLYyTjodKhJA+x5SN/WGMfhFeNDmgM?=
 =?us-ascii?Q?U+uQwxZQBxb4eIjpfVGyvZnL1U6j/RE6qN5UBB4JzgXXc+HZYfp/36cczC8w?=
 =?us-ascii?Q?I4l0Wly4uEEeBa956MixW3JnkLfnVKPlQeYeYGtkZAPb1IMMTN8RVypf6ydk?=
 =?us-ascii?Q?15o86etv1IsuXFHDjeYzXszHIWtKdYPBKwdpjIAQM1dNEFdrC8n/Uc1mnkE8?=
 =?us-ascii?Q?FuyJBUsVdzPmIoDYnc4dOQqKdIJkWGNaD8NbRTQn9Kkhph+Pwg81Kyc4Zz7A?=
 =?us-ascii?Q?4Ht3/YKkOeI4b9I9TBNBQtaIiSatTwENChhkX26o0DIr7c3Azsm3KXnQkwAW?=
 =?us-ascii?Q?9nf++jA30PdEkU4uKdTHGBP57JwtUSS5BYBMfz1b1TA2FZNBm8ysqW7bQPJv?=
 =?us-ascii?Q?KsV7znsidO7b6a8+nuMSkKVJ5R+4krATFLSDrQRK6xmMeMm8bxEKhVTSYqnC?=
 =?us-ascii?Q?smWmZO4RUduQ3GO4hy51H2HW7X6Gln8+8BUciUawKaL6phHnmTBfk5+Jy7Yt?=
 =?us-ascii?Q?G6yROKFjTbtNKhdNpj96q9K2cebauXN6ZHYuGzHA7WOxYuKiT/2DvfpB/4BR?=
 =?us-ascii?Q?Zr4ra9th1IE9AzISNiGMrGfilJs7NK/ryldUJI6hJN4STnkYg2ydAoY6GblX?=
 =?us-ascii?Q?1DMwYHUm2T3ilVgKF8IBkLqqIoSMF3XfmLP9RUe8qM5qgoBOHekwBm1T3Nv9?=
 =?us-ascii?Q?cCHYFSyPHqntxFKna2Vvb3+nCyAfAhxyH7rdaatzxhBZeJ/zt0AKOptiAniR?=
 =?us-ascii?Q?SJi8tbSuf+x8EQVmmbFw54ugmIPe/QMnLj8LZmxsmKWWxdgBYh9x1lkCAPqS?=
 =?us-ascii?Q?0TiLXUXTuBDYMqsNTOSekwdMz9sKbteEBT2uhDRuwffzrYojm064c6FbP5rq?=
 =?us-ascii?Q?Pzhp1zv0nr/BSsydJFtozJJE6TIswzJ0DvcwJwWp0YmNqCQ3q2+rjtlOBgeR?=
 =?us-ascii?Q?nOOb9W6pO2Jjy0O+D1oLjGJSK+J2kIPib5iF0scLZVMSOM2vHG2xXhrd5Odk?=
 =?us-ascii?Q?g7OcYB49QhV/L3n8gcwBtw/f/Iuu0cPeu9llthUfZA9+jRE256Y4uky6pKY9?=
 =?us-ascii?Q?6QpwKbOus0y+dZsxUaiCIYRG8xNoq3PVtUkpOOzozhOJgi17TrhbbfgfjsEC?=
 =?us-ascii?Q?zg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f47081be-84e8-484d-c747-08daff9c5eac
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 12:53:49.6583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SpCJtxxDCC7xddNaFPjgH58rQfejl5S1lkrLvBUMcMQ+ZkBQYRftQCOkvtHZ5No4gzxZXVPiMAnUmRWbQCPVrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 2 classes of in-tree drivers currently:

- those who act upon struct tc_taprio_sched_entry :: gate_mask as if it
  holds a bit mask of TXQs

- those who act upon the gate_mask as if it holds a bit mask of TCs

When it comes to the standard, IEEE 802.1Q-2018 does say this in the
second paragraph of section 8.6.8.4 Enhancements for scheduled traffic:

| A gate control list associated with each Port contains an ordered list
| of gate operations. Each gate operation changes the transmission gate
| state for the gate associated with each of the Port's traffic class
| queues and allows associated control operations to be scheduled.

In typically obtuse language, it refers to a "traffic class queue"
rather than a "traffic class" or a "queue". But careful reading of
802.1Q clarifies that "traffic class" and "queue" are in fact
synonymous (see 8.6.6 Queuing frames):

| A queue in this context is not necessarily a single FIFO data structure.
| A queue is a record of all frames of a given traffic class awaiting
| transmission on a given Bridge Port. The structure of this record is not
| specified.

i.o.w. their definition of "queue" isn't the Linux TX queue.

The gate_mask really is input into taprio via its UAPI as a mask of
traffic classes, but taprio_sched_to_offload() converts it into a TXQ
mask.

The breakdown of drivers which handle TC_SETUP_QDISC_TAPRIO is:

- hellcreek, felix, sja1105: these are DSA switches, it's not even very
  clear what TXQs correspond to, other than purely software constructs.
  For felix and sja1105, I can confirm that only the mqprio
  configuration with 8 TCs and 1 TXQ per TC makes sense. So it's fine to
  convert these to a gate mask per TC.

- enetc: I have the hardware and can confirm that the gate mask is per
  TC, and affects all TXQs (BD rings) configured for that priority.

- igc: in igc_save_qbv_schedule(), the gate_mask is clearly interpreted
  to be per-TXQ.

- tsnep: Gerhard Engleder clarifies that even though this hardware
  supports at most 1 TXQ per TC, the TXQ indices may be different from
  the TC values themselves, and it is the TXQ indices that matter to
  this hardware. So keep it per-TXQ as well.

- stmmac: I have a GMAC datasheet, and in the EST section it does
  specify that the gate events are per TXQ rather than per TC.

- lan966x: again, this is a switch, and while not a DSA one, the way in
  which it implements lan966x_mqprio_add() - by only allowing num_tc ==
  NUM_PRIO_QUEUES (8) - makes it clear to me that TXQs are a purely
  software construct here as well. They seem to map 1:1 with TCs.

- am65_cpsw: from looking at am65_cpsw_est_set_sched_cmds(), I get the
  impression that the fetch_allow variable is treated like a prio_mask.
  I haven't studied this driver's interpretation of the prio_tc_map, but
  that definitely sounds closer to a per-TC gate mask rather than a
  per-TXQ one.

Based on this breakdown, we have 6 drivers with a gate mask per TC and
3 with a gate mask per TXQ. So let's make the gate mask per TXQ the
opt-in and the gate mask per TC the default.

Benefit from the TC_QUERY_CAPS feature that Jakub suggested we add, and
query the device driver before calling the proper ndo_setup_tc(), and
figure out if it expects one or the other format.

Cc: Gerhard Engleder <gerhard@engleder-embedded.com>
Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: Siddharth Vadapalli <s-vadapalli@ti.com>
Cc: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- rewrite commit message
- also opt in stmmac and tsnep

 drivers/net/ethernet/engleder/tsnep_tc.c      | 21 +++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_main.c     | 23 +++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  5 ++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  2 ++
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 20 ++++++++++++++++
 include/net/pkt_sched.h                       |  1 +
 net/sched/sch_taprio.c                        | 11 ++++++---
 7 files changed, 80 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_tc.c b/drivers/net/ethernet/engleder/tsnep_tc.c
index c4c6e1357317..d083e6684f12 100644
--- a/drivers/net/ethernet/engleder/tsnep_tc.c
+++ b/drivers/net/ethernet/engleder/tsnep_tc.c
@@ -403,12 +403,33 @@ static int tsnep_taprio(struct tsnep_adapter *adapter,
 	return 0;
 }
 
+static int tsnep_tc_query_caps(struct tsnep_adapter *adapter,
+			       struct tc_query_caps_base *base)
+{
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		if (!adapter->gate_control)
+			return -EOPNOTSUPP;
+
+		caps->gate_mask_per_txq = true;
+
+		return 0;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 int tsnep_tc_setup(struct net_device *netdev, enum tc_setup_type type,
 		   void *type_data)
 {
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
 
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return tsnep_tc_query_caps(adapter, type_data);
 	case TC_SETUP_QDISC_TAPRIO:
 		return tsnep_taprio(adapter, type_data);
 	default:
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index e86b15efaeb8..cce1dea51f76 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6205,12 +6205,35 @@ static int igc_tsn_enable_cbs(struct igc_adapter *adapter,
 	return igc_tsn_offload_apply(adapter);
 }
 
+static int igc_tc_query_caps(struct igc_adapter *adapter,
+			     struct tc_query_caps_base *base)
+{
+	struct igc_hw *hw = &adapter->hw;
+
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		if (hw->mac.type != igc_i225)
+			return -EOPNOTSUPP;
+
+		caps->gate_mask_per_txq = true;
+
+		return 0;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			void *type_data)
 {
 	struct igc_adapter *adapter = netdev_priv(dev);
 
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return igc_tc_query_caps(adapter, type_data);
 	case TC_SETUP_QDISC_TAPRIO:
 		return igc_tsn_enable_qbv_scheduling(adapter, type_data);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 592b4067f9b8..16a7421715cb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -567,6 +567,7 @@ struct tc_cbs_qopt_offload;
 struct flow_cls_offload;
 struct tc_taprio_qopt_offload;
 struct tc_etf_qopt_offload;
+struct tc_query_caps_base;
 
 struct stmmac_tc_ops {
 	int (*init)(struct stmmac_priv *priv);
@@ -580,6 +581,8 @@ struct stmmac_tc_ops {
 			    struct tc_taprio_qopt_offload *qopt);
 	int (*setup_etf)(struct stmmac_priv *priv,
 			 struct tc_etf_qopt_offload *qopt);
+	int (*query_caps)(struct stmmac_priv *priv,
+			  struct tc_query_caps_base *base);
 };
 
 #define stmmac_tc_init(__priv, __args...) \
@@ -594,6 +597,8 @@ struct stmmac_tc_ops {
 	stmmac_do_callback(__priv, tc, setup_taprio, __args)
 #define stmmac_tc_setup_etf(__priv, __args...) \
 	stmmac_do_callback(__priv, tc, setup_etf, __args)
+#define stmmac_tc_query_caps(__priv, __args...) \
+	stmmac_do_callback(__priv, tc, query_caps, __args)
 
 struct stmmac_counters;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b7e5af58ab75..17a7ea1cb961 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5991,6 +5991,8 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 	struct stmmac_priv *priv = netdev_priv(ndev);
 
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return stmmac_tc_query_caps(priv, priv, type_data);
 	case TC_SETUP_BLOCK:
 		return flow_block_cb_setup_simple(type_data,
 						  &stmmac_block_cb_list,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 2cfb18cef1d4..9d55226479b4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -1107,6 +1107,25 @@ static int tc_setup_etf(struct stmmac_priv *priv,
 	return 0;
 }
 
+static int tc_query_caps(struct stmmac_priv *priv,
+			 struct tc_query_caps_base *base)
+{
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		if (!priv->dma_cap.estsel)
+			return -EOPNOTSUPP;
+
+		caps->gate_mask_per_txq = true;
+
+		return 0;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 const struct stmmac_tc_ops dwmac510_tc_ops = {
 	.init = tc_init,
 	.setup_cls_u32 = tc_setup_cls_u32,
@@ -1114,4 +1133,5 @@ const struct stmmac_tc_ops dwmac510_tc_ops = {
 	.setup_cls = tc_setup_cls,
 	.setup_taprio = tc_setup_taprio,
 	.setup_etf = tc_setup_etf,
+	.query_caps = tc_query_caps,
 };
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index ace8be520fb0..fd889fc4912b 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -176,6 +176,7 @@ struct tc_mqprio_qopt_offload {
 
 struct tc_taprio_caps {
 	bool supports_queue_max_sdu:1;
+	bool gate_mask_per_txq:1;
 };
 
 struct tc_taprio_sched_entry {
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 9cbc5c8ea6b1..175835514b2c 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1212,7 +1212,8 @@ static u32 tc_map_to_queue_mask(struct net_device *dev, u32 tc_mask)
 
 static void taprio_sched_to_offload(struct net_device *dev,
 				    struct sched_gate_list *sched,
-				    struct tc_taprio_qopt_offload *offload)
+				    struct tc_taprio_qopt_offload *offload,
+				    bool gate_mask_per_txq)
 {
 	struct sched_entry *entry;
 	int i = 0;
@@ -1226,7 +1227,11 @@ static void taprio_sched_to_offload(struct net_device *dev,
 
 		e->command = entry->command;
 		e->interval = entry->interval;
-		e->gate_mask = tc_map_to_queue_mask(dev, entry->gate_mask);
+		if (gate_mask_per_txq)
+			e->gate_mask = tc_map_to_queue_mask(dev,
+							    entry->gate_mask);
+		else
+			e->gate_mask = entry->gate_mask;
 
 		i++;
 	}
@@ -1290,7 +1295,7 @@ static int taprio_enable_offload(struct net_device *dev,
 	}
 	offload->enable = 1;
 	taprio_mqprio_qopt_reconstruct(dev, &offload->mqprio);
-	taprio_sched_to_offload(dev, sched, offload);
+	taprio_sched_to_offload(dev, sched, offload, caps.gate_mask_per_txq);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
 		offload->max_sdu[tc] = q->max_sdu[tc];
-- 
2.34.1

