Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169FC5B3681
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 13:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbiIILiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 07:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiIILiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 07:38:17 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1423F1377A8;
        Fri,  9 Sep 2022 04:38:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I0t4G1Ea3mLQE6T7FxOZqjrMHsRAHGTPo/OuACDC79SZILLL0re+MgFlOdTs3yCnFkvoqLLGNH2oTRrn7dg7hc5VyD0b9k7LitKbYRKXkspPE3lFlkVG2IBeq1oLI4DCIiGP7/fUXQBYw0OIo24/mMAJcoh68c7izvaO2AsdxLFJIo9xccyGBoWWebvkbQdjI3LBPVvIteM/CR2NP60VamkrBJBso9I3bD2OxhdVgI1yMzebqp2RwIrrftLNCLdAQX+C+J1ZNFKhoJomoDJaLn4ezsx2RR6FTOHOfRQ4uJTyRsaJFhlJ5g1WEsun56jXLzXU5RJsQLWuok3XMSE6lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihxem9OyabiF4lDuRdQMYvcAOny0khCtC7fzy6Do63A=;
 b=HHuOLF5Va5Rl0GbK82WT2O1H6R9k47S6WzW+d792V45MDQFqhnzGXw/XpT2v+51GiZgklLAq0liAPJmNZdMUBmaeoSGtGE9/3VAy3/w6Yi0wG1bJiQw3jssfSNarkKW7MNBNYTA/bRSUK15cCR1ULsl+JPwcRojqSbsp7MD6BZyWu0z3cSu9n7AjlPRIf5BMutZCpPZFQ3JBFtsBfB9QLzD7qkJUD/W1Fjhf5HI9OeHUQK8MTT52nYFDTEmmn47CAWVtmc4tJ75hHc+IYkwL4K+mmfOvtS1rs3jP8ky28MBDKWvjTwbvUH8ma8BNqVLmzNgQeXHh5he8h/qlN3pC7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihxem9OyabiF4lDuRdQMYvcAOny0khCtC7fzy6Do63A=;
 b=sTaP4VkCYrmss8LbFPl0H9uYIZ0Bl7cKmiUpUC/IjQWRWProT6G0/r5MP8TyaYGbK/VIdvfpe9SKhgfEzLGNQc7C3DUUvSwdCPdU5YweWt3Xpn1tAqMNmToRKwmBNwRoJCDErUAqApIh2rgG4x0ahggr/UibjDFTY5u+yTFS5X8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6616.eurprd04.prod.outlook.com (2603:10a6:20b:fa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Fri, 9 Sep
 2022 11:38:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Fri, 9 Sep 2022
 11:38:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: enetc: expose some standardized ethtool counters
Date:   Fri,  9 Sep 2022 14:38:00 +0300
Message-Id: <20220909113800.55225-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220909113800.55225-1-vladimir.oltean@nxp.com>
References: <20220909113800.55225-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0074.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bc45f16-d51f-470f-df5c-08da9257c637
X-MS-TrafficTypeDiagnostic: AM6PR04MB6616:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M7P4EXvj4M19TKmZ0zZHrZtXbdXJoP22e8mgQTOKS1zGGHkYfuT5gVj32Z0wWuffIquhjul1VQXdBSe0q7R25UjOH92kJuCM6GXyIsD1eohLXkMEYiqCmw5OhzmO5flGJBW3/ahFo5775JtZsiAkj98JqLpvbFHlxyo43sAst2QlELYVl+IPRTsXxWOnWxXDdbJqLV9fRDvWqYUe0c6hmu0I17+wSEzkSjRX0XFa/ACdsbg7oj2thMlLigcaXFvlmt7l3gp9nSxMigiu28jMk5neChxJmjT7vz1xxzitz89SbHNCpEomuPbsiglOo+KJyRDTB9i7wU+0/NLL8Jl9GjFRKPQgECRuz06pbkGkrqduNLUht5cYBaOvRNGjX4NgsqwnDg8WD1kz/GRZoW0n5Jij+fvgxubVY5XcWbDovn6/tP8ZeMSfPHqRJKIJmwW79hC1Ud4UzjdUjJ/Ri8J7qAH4x1K3lWKqKqmEWet4fzxqzlncJz0KhNx/bq4Kl33xawi0y2ErNs0ovpGNwvlQf7C7Ud/gzWpy9qG/YLvrikkduW9rGNLICrXZddlQrlc2RaIyWUlLntQCB5AxxjVavrSY63hfGJ6IixYHr5z0cM5n/G8jqwcFz1wU/i+jcNa6sfqmqdGAWhv0RH8Ht1MTGRxP+Ek//RI4wu+PvpgDWIZF3V4HwmXSRtSkB9fihmrDDEd7J31jF5oJKgX0dq6WsDBl/UAwiCDOlgeektNMiuCFBjL2XH+W1OJJ/IZLd0gCzsLCwKeg3IGrwnRJHmyLXOscRXvrdyjydu3H3b6KR28=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(316002)(40140700001)(2616005)(83380400001)(66556008)(66476007)(4326008)(478600001)(36756003)(1076003)(186003)(44832011)(66946007)(2906002)(52116002)(6512007)(6486002)(5660300002)(6506007)(54906003)(8936002)(26005)(86362001)(6666004)(8676002)(41300700001)(6916009)(38350700002)(38100700002)(44824005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XOelKMmnIEGWV5j87YoVymV+GkwTMka0YZY69INuFknHdP9bc1ZHvkFJkYdo?=
 =?us-ascii?Q?O5hlJy2d0u5dikv+6LgcfKukQ6u7b2kxcQ2vhALlywBlcr8szP38driuOjHJ?=
 =?us-ascii?Q?k0KK5vzDku9mgmxIYwAe9sJcjnPZLUe7s6CCo8R4KmnEyNoSEJF2T8/C2qQN?=
 =?us-ascii?Q?2sQj9S7JaEKfImqeX+6o4s6pReB1aTy7AbEypTZ6g5r9vIvImiSDRgt5Bhna?=
 =?us-ascii?Q?4Cs10/f/d9RE82fvfldd+BzUVBVwN0C1X69c4rWRQgCFtm+TYQ8rIl4Zwa/c?=
 =?us-ascii?Q?wVLVqw5JCz3lCtkUN+9zftc7D6cUqxRfRu0iAB6XPE/b7YLqC/L9NhbFRGKI?=
 =?us-ascii?Q?llGEbbSVz8idgaGcjPLZ6Esb9lu2ECp/LJn6VqPwiJtm4RxXVCQoTc0qVwRE?=
 =?us-ascii?Q?GZ7s7qpnVeQryLJTXceXW1CkWkpVr2+xt1CnAzRiQ0Stwrn1VOcmNa3N9raL?=
 =?us-ascii?Q?S0SctzxDAukrANxsDOsQWqFI4CYy4ZmvgMbIunCAVuWBgrOfBNIAKjBi5AV2?=
 =?us-ascii?Q?qXSTX1nbpb5Z5zRuvsg4kTYGkBMVi1MpFMin6GYIwmx81+J5cPJDcJXt6/qC?=
 =?us-ascii?Q?yoZPbf2s7qO98Wn4ruWkQvEOHwlepGA/9d7Nc3NlLiHqiVO0bIhEsRVBtR9I?=
 =?us-ascii?Q?nVQTOmKSNjIpFtF/uzsBuqVFbtBIT/zkTJhFk3e2TuBH9LDiYL5cpm+WOnZs?=
 =?us-ascii?Q?9eZOBLRr/SZVW71c5cuIY9ECeHHCyzAhDd7cC0SVHp/ymTAN1H+fBsNfKNI3?=
 =?us-ascii?Q?2nnWSxrHVRQnCSKdz/EJNselxOw3b9ggxSM/AzCo7F9zJycCzx1aTrq9k7x9?=
 =?us-ascii?Q?gOe1Nm9vi634C9dZ2sKgfU/Sm7EhFQUOt0Dl8vCtJ17VrIp4UFVkzTg78zVS?=
 =?us-ascii?Q?V7Kdmm4B/ytCSE77mQ3ckRRVaux0G5v0f+ZMxKpBQKHPcZFC94UlrO+IBizK?=
 =?us-ascii?Q?EyPzOWu0o1fgIQDuh2XVNoRS8jlRJ3Hz/k7ELpfVUMBvCMz7BSoIvegwYik7?=
 =?us-ascii?Q?y9uuAkeBg19auN4gILZzS4atGG1bus6R/dXZSQGlzZOVgUrCZtd4TdiPd4P+?=
 =?us-ascii?Q?OP8vPvZGJRFspDUGYeEn0BBw+tBr++qJFkdLtvvJqUaP1xsLJAWnPAtA/0tT?=
 =?us-ascii?Q?6XFC8rb4p9QpWiZkj8bYvgjEqWFau9gs+jRYboVFBEevy6ktPINPNk7N1E1K?=
 =?us-ascii?Q?0BVIGEBenOPc8PPELl3762+UX8C40S1J2EHMsQrXnQAGU5DKufMTMq5/JJw2?=
 =?us-ascii?Q?TbHEBjxc0Jr8t7NcpLJ1Ti0fex5LTHktiKjlMmHw8LtOazERhkGtuV9hMKOg?=
 =?us-ascii?Q?HjwSO+aNu9P1RNnzaHNf8aiGHObaQbRpIeeBN3juLBzD3+kL1aYQXaTKiCdt?=
 =?us-ascii?Q?fqp0tKZvt8Mp/flbG246TIJ7i8I+A4WKYppUith9JQaprwfuvN+Y0pZkI/KT?=
 =?us-ascii?Q?+Ty0w+g0pWyE3W0y19hRTh+FUQqiLt9RRQAcOL5CtBDflanojP1KQOlDina9?=
 =?us-ascii?Q?At9nYp6jADqR/KeZG+bMTZWjpVcmFhI7/gV02zbxWiycRMcPGEL43pN6psld?=
 =?us-ascii?Q?UuuTBrSp00i9bJfZynwauctHCEwbY8N5wRJLreY6dJr5sDHdz9Dc8nH61cEf?=
 =?us-ascii?Q?+A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bc45f16-d51f-470f-df5c-08da9257c637
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 11:38:11.3269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8vbSokOy0dDXAsw7k1I6q//XaDqC+Pm9gI1YtvTLxRh2/5pfnHPVeYLUqrzkI84YOqUVffFmK0EIwBPT6Zw0Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6616
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
index b07139c97355..c8369e3752b0 100644
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
+	{ 1523, ENETC_MAC_MAXFRM_SIZE },
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

