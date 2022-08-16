Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9271B596582
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbiHPW3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238013AbiHPW3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:29:44 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60064.outbound.protection.outlook.com [40.107.6.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3356760C0
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 15:29:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxva301pQnluhIkJt1o0wiwTeylt9PaJkb1PEUBh7hfNKfYyl5D3wtsW8DZce8f1hgSczO8ibbpcFdtGVMOyg/0Gb+Tl4JlyNwEWgyu8zU0Diel8n0OFuSK/xNgydlMKX7H1Qj8wAldVxg64B85mGEIxBlQb4j4b06M5/jbATrDSGTH1Ei5m9TlnoRmfbllDoHbvr8uLbZ6kbbm5xH94STxpmtyZbONZL/xInXcFxY3f9Z0egz9gfgabaGPBN5gkG5qwG/D7VUkRqQbvth187iGtBBCe+8gXHmZB+3NQlFT+bP9casQwD4UB6Dv/X6Wem+SGuLfXRWSaumDo1V4Tkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YiS/loU50rKJuHwMdqEWN3NZGIppkCdOKHnMrtZxw/4=;
 b=UiNNLVbUgDY+Yh6rD+5V3iSZtjPXic8dMwpXpy+d33OSMPhXGssT1OSfmpZetxVofcERd9enr597QPeVI3jnPBkZ/R/zB9s9XWTdPx2R6Hbr3YmKUUe0inrJ1VUi4aIJVJe/x5Y9mlHTBTYqFCG+onQqQDj/99q5OJ/bja93644ErEa7xJOYnMjTgCQBqvKHUq60TUc54WlvKQSCdsVYMzRTorOugNJylC3QDeKLPOGi6Cw+Arq5RhCsCZiXZwbzZUuJ6iSiM7J2nXCJT9o1awKpQ2+YHZ/thsVU0LrkACbmpts1ijHxkTyLaEZbzfnl4YcwfsEGDGE4YVz3ogIu6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YiS/loU50rKJuHwMdqEWN3NZGIppkCdOKHnMrtZxw/4=;
 b=GtsBgVw/d3/zfRhyK8LU9ZF1YkGoJNF0mHZo2Du6aHI5z5ykGKwXZFjp3mqEclwqWC6wVkykLFFgPubD+DlMim2iQ/nEDG1ToHwiqLY6G9SfynNYSJBV3JONmaEsn16NSgaelcgdd7A/2yxnN8k/A5+cyGc8naVbn/9P+oCUslg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8618.eurprd04.prod.outlook.com (2603:10a6:20b:439::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 22:29:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 22:29:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: [RFC PATCH net-next 6/7] net: enetc: expose some standardized ethtool counters
Date:   Wed, 17 Aug 2022 01:29:19 +0300
Message-Id: <20220816222920.1952936-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0021.eurprd05.prod.outlook.com
 (2603:10a6:800:92::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bafccc4-c3c6-479d-973c-08da7fd6cc3e
X-MS-TrafficTypeDiagnostic: AM9PR04MB8618:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +nRYyBaDU/KRGuZl74RtnX1sXDgC2NX2Cz7MSM66xnMu+KhPT6uJ9BOqJsy+bQETFUU9hO7e19KwaN7vy+zPX6pg3Lsefk7aMomEaAclciZLGW9aQBe7BVz9htNfcsnnuMBwEk41Bp+7sZFdNBqlTQEtf/BGzo5kA+rK8TeFV+OyoZYkz1yQ2VWZuHtskW0RxFMiMNQDYNgoQqT3OjRRpEdiN5NkkvGFvMI75ZIRJ91AUTIuw/7ul4AICzAvRyM8b3KsAa5ABlrCsl/zH0ke4Sf+m3xx9Ab5PqG/2B5M9RX17SpcF1iI7eJZZFF1O3vF/jjTee7nPqBcG4yk5ZtBtJPj0ZHHrugLycC4Y7KfNCAegWGUcFvIQusrbhvVKxKZH96D1QMHZfltH8rSZk/bTtsRmiWsmc4+7N36+eSfOCBpmLObgIAZgE+Jy7dmZK5CkVEwJ01WWg1VBbXwTYXEkPtcCvA54j3jp+oXm1eP0N6ZC/qQ3cOFDPyB9ItiO5858VMcWd8Pqv4ZZH1A7snP6ZnM9GCsO9emiHMWC13UPvdQh0QxM8tJh8fZF0a7Pg49vrDFqEqfBjHu4X8CW1oz3IB4EMRmuhT2MsosqCYe46NNpYa2phxZFcRYIDw0+RjgBi2lOZA4SDoSjVaitlOlS0klLsp8ncqiJe7MiZ66MCwuqoC6vk/NVjtW//hGohHpYbCsZouW9eJ1Xua805jX0MToCBqy6Bu5MVsNEMyiJ72lK1X1wqcFLnk1eZ+En+4E5PAgkg90SQyiwUkK8ZK+wp0IIUGpvdfv612+lm4PcpncuzoJy+8xbk3nKyI6l7UDAa2iZJz8MstV2AaX9dcJXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(66946007)(44832011)(316002)(1076003)(66556008)(8676002)(83380400001)(41300700001)(6666004)(6916009)(4326008)(2906002)(36756003)(54906003)(186003)(2616005)(38100700002)(26005)(38350700002)(6506007)(6512007)(66476007)(40140700001)(6486002)(8936002)(86362001)(478600001)(52116002)(5660300002)(44824005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+Jo/OPE4xUbEb1jRa2EqnCatPg5Ws+nOLTQarm/wXY08nVeQJZRt96uJcgJV?=
 =?us-ascii?Q?G+5gINm54ftAl3tUnJtZHcHUEC58RTaB1tDCZA8RaJVoDBsrtkEBTG2aw9jY?=
 =?us-ascii?Q?lR5+ASDI1qY7StgRX7RJG3jcroy3U1eQk7+eXtScIRw4LYX5N6GMXEW9ripZ?=
 =?us-ascii?Q?R85aqr2NriTTgsKRIM31M2tlurAFD9qMu4CbHDOFPSG5m3mVwGP+oHeyCjPC?=
 =?us-ascii?Q?NaXXB4JOZlCDY6NEVQ1QLkOnfN+dqLw8FCgfFSx4CZtwelENA4KIgX39Bpup?=
 =?us-ascii?Q?URlpZ+u+5gLRqkoDgiKkv+A1GtSlNzeNi7FWd2DdgHWIZyclzd6L6voH/j8o?=
 =?us-ascii?Q?7WJ+MQnQTi/WjTXl7Cp7/ELWJ5DJcBNdryNuDzmeO3trKUOz8tzK0O4lynGZ?=
 =?us-ascii?Q?Q7li0zAfimBtQKmTNvoAb7PqOsAILERqmfHNs3depApoLi7YTlMOYZjQ+B5E?=
 =?us-ascii?Q?iRucQ509MfYKP2h6bjZ2BRzcOXna1bRrJ8CKlsims2YBCXtdiKXcBUQy3WWO?=
 =?us-ascii?Q?qIY+TORlin4XVGK0et4PngHlfHbvmYBwdmju4KM4aSKHVC20AoPARtNt8Uom?=
 =?us-ascii?Q?yqXJDXZtIHGt1CkE2PcDhG2U9eQilrvGmNROe+LpdtzoqbUTTd0b2/y9QbIX?=
 =?us-ascii?Q?cYIpl62CaH0WGmOKwvJx0yEhWePzr98eZkTO4S6CkNUEEYlJs5BKenaNR1dW?=
 =?us-ascii?Q?GDx68RANWkf9lcGFcIuwqceiRu83cOIt9kN3/a/pTH1grOG1C4bqcINqMwEm?=
 =?us-ascii?Q?9w714tUUoKyJe92AD+ANNmkIIN+GDlxc38YDbtV9FX9g6osc9err/2jQJO/3?=
 =?us-ascii?Q?TUP5b23nSM3AtE+SpQ+uqMk6i9TUlZFkUMIhsCMp50bfSnkvwV3tg3iBWBrC?=
 =?us-ascii?Q?uh8Tfl154ZjmhT9s1nnaIOMsbs0dgkjuR1WScm5t3kpAY+zJE4M1aWc4bREQ?=
 =?us-ascii?Q?w4nFMGb2j8LD6blyWTxW9oWm/XXohT/1o4P4UwoiLOvJIsYaE04ANL1q/B73?=
 =?us-ascii?Q?aiTaUZiR0cTiaYfRSkxdqKeIG1i0o5Y+QcfNA3gEmTm5v7rAkklT00hbx7Og?=
 =?us-ascii?Q?SE+fRnB7ECKJB/mCToOcbTbATuOnpY2toqDFA28fOy+YtVtRaLpP8J3/ORfc?=
 =?us-ascii?Q?607co+nofhOYVJkRDdL2u4b6Wd9bn7cWyV+IyFCZ8l/aU4RvYJqxbNGbtJxn?=
 =?us-ascii?Q?qZZSLCNarSMscNCsqK1Ibt5AyAeMQjrC0E6oFWRqsrDkXa3z9/kF+m0RUULu?=
 =?us-ascii?Q?6N4sZ9Kjo1WAqARxAJYQJRuPxThDNkv0jxeDTAz9EqwlXVrzUhSxnYcTfYWh?=
 =?us-ascii?Q?jwTIMzyqu78Uh8Lrxj872CByvd0GHTZrFkHAwfWWd1maA16dgT6G5EdDLr7y?=
 =?us-ascii?Q?XJVqVxNLFptTzRY0TbH4gAAdpkShKlpjUNtA5VYVVj9y6R4+XMquHl40ZuQB?=
 =?us-ascii?Q?xlNnQrc/phn3fiw6LlNnoPFZ10CqxTGxJfuyEZQk8CgxeWsHrtqrk0ftwzpq?=
 =?us-ascii?Q?Ly0mO3W34Mis4UkY6hkaSHNUaienqmY6fN2x4qP4wuu3ziVjhHA1MzZXvah1?=
 =?us-ascii?Q?wVVZontjnnr8sjtcvasvkCY/TmEzxdmd55zmSDB0yXYF5HR1FYYfjeWOyoex?=
 =?us-ascii?Q?3w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bafccc4-c3c6-479d-973c-08da7fd6cc3e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 22:29:35.4916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JXvywexjR7fSxUmsVEu0BC8V0S9xA3aHtZ3hy/3pNXPwSpVI5gpbE8OkSdA//kZL+Lj+e7D3D9HlK4c8H+lDPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8618
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Structure the code in such a way that it can be reused later for the
pMAC statistics, by just changing the "mac" argument to 1.

Usage:
ethtool --include-statistics --show-pause eno2
ethtool -S eno0 --groups eth-mac
ethtool -S eno0 --groups eth-ctrl
ethtool -S eno0 --groups rmon

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../ethernet/freescale/enetc/enetc_ethtool.c  | 111 ++++++++++++++++++
 1 file changed, 111 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 236bb24ec999..25705b2c1be9 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -301,6 +301,113 @@ static void enetc_get_ethtool_stats(struct net_device *ndev,
 		data[o++] = enetc_port_rd(hw, enetc_port_counters[i].reg);
 }
 
+static void enetc_get_pause_stats(struct net_device *ndev,
+				  struct ethtool_pause_stats *pause_stats)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
+
+	pause_stats->tx_pause_frames = enetc_port_rd(hw, ENETC_PM_TXPF(0));
+	pause_stats->rx_pause_frames = enetc_port_rd(hw, ENETC_PM_RXPF(0));
+}
+
+static void enetc_mac_stats(struct enetc_hw *hw, int mac,
+			    struct ethtool_eth_mac_stats *s)
+{
+	s->FramesTransmittedOK = enetc_port_rd(hw, ENETC_PM_TFRM(mac));
+	s->SingleCollisionFrames = enetc_port_rd(hw, ENETC_PM_TSCOL(mac));
+	s->MultipleCollisionFrames = enetc_port_rd(hw, ENETC_PM_TMCOL(mac));
+	s->FramesReceivedOK = enetc_port_rd(hw, ENETC_PM_RFRM(mac));
+	s->FrameCheckSequenceErrors = enetc_port_rd(hw, ENETC_PM_RFCS(mac));
+	s->AlignmentErrors = enetc_port_rd(hw, ENETC_PM_RALN(mac));
+	s->OctetsTransmittedOK = enetc_port_rd(hw, ENETC_PM_TEOCT(mac));
+	s->FramesWithDeferredXmissions = enetc_port_rd(hw, ENETC_PM_TDFR(mac));
+	s->LateCollisions = enetc_port_rd(hw, ENETC_PM_TLCOL(mac));
+	s->FramesAbortedDueToXSColls = enetc_port_rd(hw, ENETC_PM_TECOL(mac));
+	s->FramesLostDueToIntMACXmitError = enetc_port_rd(hw, ENETC_PM_TERR(mac));
+	s->CarrierSenseErrors = enetc_port_rd(hw, ENETC_PM_TCRSE(mac));
+	s->OctetsReceivedOK = enetc_port_rd(hw, ENETC_PM_REOCT(mac));
+	s->FramesLostDueToIntMACRcvError = enetc_port_rd(hw, ENETC_PM_RDRNTP(mac));
+	s->MulticastFramesXmittedOK = enetc_port_rd(hw, ENETC_PM_TMCA(mac));
+	s->BroadcastFramesXmittedOK = enetc_port_rd(hw, ENETC_PM_TBCA(mac));
+	s->MulticastFramesReceivedOK = enetc_port_rd(hw, ENETC_PM_RMCA(mac));
+	s->BroadcastFramesReceivedOK = enetc_port_rd(hw, ENETC_PM_RBCA(mac));
+}
+
+static void enetc_ctrl_stats(struct enetc_hw *hw, int mac,
+			     struct ethtool_eth_ctrl_stats *s)
+{
+	s->MACControlFramesTransmitted = enetc_port_rd(hw, ENETC_PM_TCNP(mac));
+	s->MACControlFramesReceived = enetc_port_rd(hw, ENETC_PM_RCNP(mac));
+}
+
+static const struct ethtool_rmon_hist_range enetc_rmon_ranges[] = {
+	{   64,   64 },
+	{   65,  127 },
+	{  128,  255 },
+	{  256,  511 },
+	{  512, 1023 },
+	{ 1024, 1522 },
+	{ 1523, 9000 },
+	{},
+};
+
+static void enetc_rmon_stats(struct enetc_hw *hw, int mac,
+			     struct ethtool_rmon_stats *s,
+			     const struct ethtool_rmon_hist_range **ranges)
+{
+	s->undersize_pkts = enetc_port_rd(hw, ENETC_PM_RUND(mac));
+	s->oversize_pkts = enetc_port_rd(hw, ENETC_PM_ROVR(mac));
+	s->fragments = enetc_port_rd(hw, ENETC_PM_RFRG(mac));
+	s->jabbers = enetc_port_rd(hw, ENETC_PM_RJBR(mac));
+
+	s->hist[0] = enetc_port_rd(hw, ENETC_PM_R64(mac));
+	s->hist[1] = enetc_port_rd(hw, ENETC_PM_R127(mac));
+	s->hist[2] = enetc_port_rd(hw, ENETC_PM_R255(mac));
+	s->hist[3] = enetc_port_rd(hw, ENETC_PM_R511(mac));
+	s->hist[4] = enetc_port_rd(hw, ENETC_PM_R1023(mac));
+	s->hist[5] = enetc_port_rd(hw, ENETC_PM_R1522(mac));
+	s->hist[6] = enetc_port_rd(hw, ENETC_PM_R1523X(mac));
+
+	s->hist_tx[0] = enetc_port_rd(hw, ENETC_PM_T64(mac));
+	s->hist_tx[1] = enetc_port_rd(hw, ENETC_PM_T127(mac));
+	s->hist_tx[2] = enetc_port_rd(hw, ENETC_PM_T255(mac));
+	s->hist_tx[3] = enetc_port_rd(hw, ENETC_PM_T511(mac));
+	s->hist_tx[4] = enetc_port_rd(hw, ENETC_PM_T1023(mac));
+	s->hist_tx[5] = enetc_port_rd(hw, ENETC_PM_T1522(mac));
+	s->hist_tx[6] = enetc_port_rd(hw, ENETC_PM_T1523X(mac));
+
+	*ranges = enetc_rmon_ranges;
+}
+
+static void enetc_get_eth_mac_stats(struct net_device *ndev,
+				    struct ethtool_eth_mac_stats *mac_stats)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
+
+	enetc_mac_stats(hw, 0, mac_stats);
+}
+
+static void enetc_get_eth_ctrl_stats(struct net_device *ndev,
+				     struct ethtool_eth_ctrl_stats *ctrl_stats)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
+
+	enetc_ctrl_stats(hw, 0, ctrl_stats);
+}
+
+static void enetc_get_rmon_stats(struct net_device *ndev,
+				 struct ethtool_rmon_stats *rmon_stats,
+				 const struct ethtool_rmon_hist_range **ranges)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
+
+	enetc_rmon_stats(hw, 0, rmon_stats, ranges);
+}
+
 #define ENETC_RSSHASH_L3 (RXH_L2DA | RXH_VLAN | RXH_L3_PROTO | RXH_IP_SRC | \
 			  RXH_IP_DST)
 #define ENETC_RSSHASH_L4 (ENETC_RSSHASH_L3 | RXH_L4_B_0_1 | RXH_L4_B_2_3)
@@ -766,6 +873,10 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.get_sset_count = enetc_get_sset_count,
 	.get_strings = enetc_get_strings,
 	.get_ethtool_stats = enetc_get_ethtool_stats,
+	.get_pause_stats = enetc_get_pause_stats,
+	.get_rmon_stats = enetc_get_rmon_stats,
+	.get_eth_ctrl_stats = enetc_get_eth_ctrl_stats,
+	.get_eth_mac_stats = enetc_get_eth_mac_stats,
 	.get_rxnfc = enetc_get_rxnfc,
 	.set_rxnfc = enetc_set_rxnfc,
 	.get_rxfh_key_size = enetc_get_rxfh_key_size,
-- 
2.34.1

