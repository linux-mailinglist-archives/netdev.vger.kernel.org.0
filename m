Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA1068AAB0
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 15:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjBDOyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 09:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjBDOyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 09:54:07 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2040.outbound.protection.outlook.com [40.107.15.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3BB11151
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 06:54:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWYhJYI0WWkgGJN6KNVDWc4IS1pC/G6cjHK197eIn0U8pLFTtu3OMelvKZyfzdgNfRKdxbOBbgyz/hELE9sJ1+zCdYpbnbgDfSEedhDwYJv8ZJRG44KpDz0QclNnd7Rc+zmEOPcSWUaCwHFrss9nwSYNT/1Wd4int0SK2iT1UNAavJkMfHwRsymAY0FQisHh50PY4NN83eim7kvf1cb3HoP1r73kUZQUVGHMCgmz2RK47eezIYGy9kDBc/mpUiV5+rRgLxkg2cUaT58C8vFCoOF6mKkzyldcNUkF8ggxjemvn+sP2dSMbutCH8FZxpWXXrDN2GAdlXifz/0XBuTqxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1fi/jbrQxXaUAeRDfGHcLXVXttcXbQnH7otz6DnBHPM=;
 b=YM+M10u/pBMvu7njGGPeGWMBpPnMXP36a0Bt0GbrPwpta9A+Wo0mQsB44AiZMTP8RVd3An3pz4edxhHwMmbGJIn8YE5wnFj2LNOCnCfLeWpE/HpfJRcNMehred6ANi7Xf34Tr9uG5uVRihY3E7S3ej1bQKijWgwOkaxsJu1W/fKqikCsjt9uwO25lqNkcMWJm6cbb+DnUl2GigmZhUHsJIBggOCLRlMakKYngyt3RDXRqgW0wQ2oZkM4EvtrsigEiE0no78Np8JF2JCnUn6f6GztarAo4W3Yc83+pRNVXBCyXCRUAcrxuQJFXSU1Yffdnh14E/jiYcQHDhDlU3OALA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1fi/jbrQxXaUAeRDfGHcLXVXttcXbQnH7otz6DnBHPM=;
 b=bGWPmLe5UqQJCkS0jsxdnZk8oVXJHUUQYels0MhVRhiUZcL5AJ+5yIJZhcbk5WeKXn+cr3XyR5bCLqT8bnQLhlrNT0nHz8HF/7ypGLvEsvzi2bzq23wUx7VGKOwDz2iJuT2PF7DInMTnQP56d6+v+aADIuu0bwgwkgdRNw//jjQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS1PR04MB9382.eurprd04.prod.outlook.com (2603:10a6:20b:4da::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 14:54:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 14:54:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH net-next 1/2] net: enetc: add support for MAC Merge layer
Date:   Sat,  4 Feb 2023 16:53:49 +0200
Message-Id: <20230204145350.1186825-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0076.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:78::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS1PR04MB9382:EE_
X-MS-Office365-Filtering-Correlation-Id: 99f4f233-3966-4e5a-2c17-08db06bfa73e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: poD+nnvcM0lAeecrqLFXGfJMZLzROSnPrsEavVthJdJwnbxT+tYOpHWsj1DNGFxRvHKjD4eJgPbD9vzKS5tmXWdw0/jz+r6EgrVre2Vyq9TvKWignW1gPyVa0EtDOM5e0CQ2mVvLugGjchqyOlTe3mQ+iYNyHuZ7crj5B22OVjtxLsqj5wuQbWRa6nATipfRljPbOpSQBDvoziGggD5C0726NcCpGhch8GDr2l89/gOdxo8wy11ShK3rUBKKU6hQHBz6G2RqqPyl6fUri/+1ymcHRhr9h0GaIIWtRSvw7VNHf+EEDKy2Zxebr/fIHVTGu+7Hr4BH4/OdIn2C6nnCS4TyLX0AA6hnpAObayjC3+ELyFxBscEGs4wnFTtR6QtNaVR1roc4ziXQOPD9hxRiZrPHfY4F6S57Hm48Fg64nI3Uo1XfN16ckB1/mLTCGG85KRgfp5TaYtVVAdYhPPKd9xck04zn477XI9YRIWRan5vfDela8pS4Q4hfYUlrKpNSBHR58y6Y+vHhSBKgOLl2bOaO5oPbQ8PDMfVE/MSCG1jygOIxSOBgo80GvmPOiR2mWJurISYwQjqTUwCr4khCj7u5LzO4m56vU8dQdXltsI5NYmgRX8Yqhk/XEcr72CYy0nAmz36zekJ9e5bWu+CDRnv6bMP9Q+ZiGVd1QXT7fJO8ofbEjknHm6+wyjy6RDOCOhyct4Mo0hOXXAU390EYOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199018)(66946007)(54906003)(316002)(66556008)(4326008)(8676002)(41300700001)(66476007)(6916009)(5660300002)(8936002)(38350700002)(38100700002)(86362001)(36756003)(1076003)(6506007)(186003)(26005)(6512007)(52116002)(6666004)(2906002)(44832011)(478600001)(6486002)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1r2dR4CsEPOXU1+NLSV8Qm5C3F0bbzjMtkFvFYU+hWwe2AEqI3LgSKSBzjDD?=
 =?us-ascii?Q?iG5SeQS5R1Zn7YDR0TcE6kRfRam56uu/T7tc/sr/M98uAeST23kORzmMUD7a?=
 =?us-ascii?Q?14iJfxiVXiaSbzUD/gdGEYaREJk3MzX5GH8Bz/FCQ/rs9mACuQBDXvfM+zDL?=
 =?us-ascii?Q?MbCQYp3wYfeLx4IKrHi6b8lsSXH70sLhccPYB9QIfcPUnIQeBqziEwcgA1ga?=
 =?us-ascii?Q?QSpmi2BAxbCTfm5+gWFz/L8GCxcBR3sxO4f46EZfoX9TBPVUftmsQCER6xXC?=
 =?us-ascii?Q?hW1MhtWIJupWogO8fHnaEsdUs/ZqZ01Zu6mQAwkeYt9b8W6C1aa0P4Fkv4Du?=
 =?us-ascii?Q?24AuNGv3keSnuLTn7t8xKwULTRtBwXxlD5m9dfu6+r/DJEphCitqehET38rI?=
 =?us-ascii?Q?twhF6CY6qI9W/3aJZ6yBcuReTMVRVXMqS4/UiLQFACh1f0Ln90OqsPdXQgLA?=
 =?us-ascii?Q?yslaWbvBj2twijytbY3XeMribd+UYVLGIonU6lMYEkZeyv+Ww1ZWIRLv9D7B?=
 =?us-ascii?Q?K3IEnepnl+wGRi81eV//pcWUjBO8D8f2nrOTLxdUjhazvFrW6HFuB+6VOfRj?=
 =?us-ascii?Q?alq2KVyW4q2hZn95FPHjrT7cn9R/484Ya/NMwrKSJ19aL52FBxRanH7kH0cb?=
 =?us-ascii?Q?dKEGwny3HDb+zjVniMFx0d82UKsJYdJKaidqO0s6k6K2vt3VVALaFJkhXS+x?=
 =?us-ascii?Q?Mj62N7mPsLDwR6w+Q03J765EV5MvN8e+4pemu6LKk8mBkKnA6X+cmdcuK9em?=
 =?us-ascii?Q?3bulp+3wHuk66QdF702FMCGOAXAP9B3f4TI1SEKWJvLQHp8FhyYYKMtTQEx2?=
 =?us-ascii?Q?z3sNAjsjKZxxkmPMzdSbWBTO+t5HheuUy0r4o1OiG3JXcLTriqwZJZ//buXN?=
 =?us-ascii?Q?Orr9sxHcrLZqso4gKa5xd6JutoRMCxEBDAuihJxALcpNgW2nZt7N0fAwdZeA?=
 =?us-ascii?Q?sgzA4YPMKo2B44T7cFWgspNNKmjhDpYB5zRuURzxCI+vwj77Nai2yHUOi/Js?=
 =?us-ascii?Q?lTu9M1fDcJK5wnmYuy1Z5EAlVgD+Izof60Lj50LlLRA2QoujMVEVr47K3XmL?=
 =?us-ascii?Q?uo/90ODuf6r7599KUTFupT6cmwLWLe3V9BDZ5TLlW3cQiXm4zqJIHAiEronS?=
 =?us-ascii?Q?0Q5XH1UHaXXXxYkxlvc+dTySo559agGqCH6RwVQQ1FJ4AOax+N1kJssfkdND?=
 =?us-ascii?Q?4aaNyEAi4MUx4qCWi+UT3vxgY34tJSeCzZSB2VQvpAyNFTXJjAU9kJN0Dzh7?=
 =?us-ascii?Q?qGIMEQNMOKHQuRhfLpcaSK8gkSB8lCPmQIJAku1XSds3hALB1+KXuyIBOnNz?=
 =?us-ascii?Q?IIDPSd9p55iLlyLtB46PeBFTnrfvOFVomSot1A0dFQocdGj5vzMXwBnwwkjF?=
 =?us-ascii?Q?eZt+PSKm0NqXyKXiYAXo+ArntslN7dRjNxsx4HxMG3RHubmyTT+rMKoiBQm+?=
 =?us-ascii?Q?y3TLedvmH+sdEKv5/PUyCI4A3bu0ej5+wCo1UnUGIaRrwJnHrZeHHqduvPMM?=
 =?us-ascii?Q?k0bb3gI93w7nU7jmBTOFjT5xZ1ECdPTJgimPbV2CEZxI7b8skxXwPaK0hfXI?=
 =?us-ascii?Q?W2SiEhzf76PuhRFWkgETRts5ENXBpyuaulHfzvfv443v9VE5ydEpLm4B4Q+x?=
 =?us-ascii?Q?Vw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99f4f233-3966-4e5a-2c17-08db06bfa73e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 14:54:02.0727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VNdnQTnogQFAIo9hn55bGbv/3BoZ3qaZvgYrt+vUNJF3Zk/+POnq+8ed5vYCmrB8D9FqRl6C7sS2LRMFoFo2Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9382
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PF driver support for viewing and changing the MAC Merge sublayer
parameters, and seeing the verification state machine's current state.
The verification handshake with the link partner is driven by hardware.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.h  |   7 +-
 .../ethernet/freescale/enetc/enetc_ethtool.c  | 142 ++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  25 ++-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  14 +-
 4 files changed, 185 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index e21d096c5a90..55231ee3228d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -314,7 +314,6 @@ struct psfp_cap {
 };
 
 #define ENETC_F_TX_TSTAMP_MASK	0xff
-/* TODO: more hardware offloads */
 enum enetc_active_offloads {
 	/* 8 bits reserved for TX timestamp types (hwtstamp_tx_types) */
 	ENETC_F_TX_TSTAMP		= BIT(0),
@@ -323,6 +322,7 @@ enum enetc_active_offloads {
 	ENETC_F_RX_TSTAMP		= BIT(8),
 	ENETC_F_QBV			= BIT(9),
 	ENETC_F_QCI			= BIT(10),
+	ENETC_F_QBU			= BIT(11),
 };
 
 enum enetc_flags_bit {
@@ -382,6 +382,8 @@ struct enetc_ndev_priv {
 
 	struct work_struct	tx_onestep_tstamp;
 	struct sk_buff_head	tx_skbs;
+
+	struct mutex		mm_lock;
 };
 
 /* Messaging */
@@ -427,6 +429,7 @@ int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 
 /* ethtool */
 void enetc_set_ethtool_ops(struct net_device *ndev);
+void enetc_mm_link_state_update(struct enetc_ndev_priv *priv, bool link);
 
 /* control buffer descriptor ring (CBDR) */
 int enetc_setup_cbdr(struct device *dev, struct enetc_hw *hw, int bd_count,
@@ -480,6 +483,8 @@ static inline void enetc_cbd_free_data_mem(struct enetc_si *si, int size,
 
 void enetc_reset_ptcmsdur(struct enetc_hw *hw);
 void enetc_set_ptcmsdur(struct enetc_hw *hw, u32 *queue_max_sdu);
+void enetc_reset_ptcfpr(struct enetc_hw *hw);
+void enetc_set_ptcfpr(struct enetc_hw *hw, u32 *fp_admin_status);
 
 #ifdef CONFIG_FSL_ENETC_QOS
 int enetc_qos_query_caps(struct net_device *ndev, void *type_data);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 05e2bad609c6..306d1e38cbb4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -863,6 +863,146 @@ static int enetc_set_link_ksettings(struct net_device *dev,
 	return phylink_ethtool_ksettings_set(priv->phylink, cmd);
 }
 
+static int enetc_get_mm(struct net_device *ndev, struct ethtool_mm_state *state)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_si *si = priv->si;
+	struct enetc_hw *hw = &si->hw;
+	u32 lafs, rafs, val;
+
+	if (!(si->hw_features & ENETC_SI_F_QBU))
+		return -EOPNOTSUPP;
+
+	mutex_lock(&priv->mm_lock);
+
+	val = enetc_port_rd(hw, ENETC_PFPMR);
+	state->pmac_enabled = !!(val & ENETC_PFPMR_PMACE);
+
+	val = enetc_port_rd(hw, ENETC_MMCSR);
+
+	switch (ENETC_MMCSR_GET_VSTS(val)) {
+	case 0:
+		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_DISABLED;
+		break;
+	case 2:
+		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_VERIFYING;
+		break;
+	case 3:
+		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED;
+		break;
+	case 4:
+		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_FAILED;
+		break;
+	case 5:
+	default:
+		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_UNKNOWN;
+		break;
+	}
+
+	rafs = ENETC_MMCSR_GET_RAFS(val);
+	state->tx_min_frag_size = ethtool_mm_frag_size_add_to_min(rafs);
+	lafs = ENETC_MMCSR_GET_LAFS(val);
+	state->rx_min_frag_size = ethtool_mm_frag_size_add_to_min(lafs);
+	state->tx_enabled = !!(val & ENETC_MMCSR_LPE);
+	state->tx_active = !!(val & ENETC_MMCSR_LPA);
+	state->verify_time = ENETC_MMCSR_GET_VT(val);
+	/* A verifyTime of 128 ms would exceed the 7 bit width
+	 * of the ENETC_MMCSR_VT field
+	 */
+	state->max_verify_time = 127;
+
+	mutex_unlock(&priv->mm_lock);
+
+	return 0;
+}
+
+static int enetc_set_mm(struct net_device *ndev, struct ethtool_mm_cfg *cfg,
+			struct netlink_ext_ack *extack)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_hw *hw = &priv->si->hw;
+	struct enetc_si *si = priv->si;
+	u32 val, add_frag_size;
+	int err;
+
+	if (!(si->hw_features & ENETC_SI_F_QBU))
+		return -EOPNOTSUPP;
+
+	err = ethtool_mm_frag_size_min_to_add(cfg->tx_min_frag_size,
+					      &add_frag_size, extack);
+	if (err)
+		return err;
+
+	mutex_lock(&priv->mm_lock);
+
+	val = enetc_port_rd(hw, ENETC_PFPMR);
+	if (cfg->pmac_enabled)
+		val |= ENETC_PFPMR_PMACE;
+	else
+		val &= ~ENETC_PFPMR_PMACE;
+	enetc_port_wr(hw, ENETC_PFPMR, val);
+
+	val = enetc_port_rd(hw, ENETC_MMCSR);
+
+	if (cfg->verify_enabled)
+		val &= ~ENETC_MMCSR_VDIS;
+	else
+		val |= ENETC_MMCSR_VDIS;
+
+	if (cfg->tx_enabled)
+		priv->active_offloads |= ENETC_F_QBU;
+	else
+		priv->active_offloads &= ~ENETC_F_QBU;
+
+	if (!!(priv->active_offloads & ENETC_F_QBU) &&
+	    !(val & ENETC_MMCSR_LINK_FAIL))
+		val |= ENETC_MMCSR_ME;
+
+	val &= ~ENETC_MMCSR_VT_MASK;
+	val |= ENETC_MMCSR_VT(cfg->verify_time);
+
+	val &= ~ENETC_MMCSR_RAFS_MASK;
+	val |= ENETC_MMCSR_RAFS(add_frag_size);
+
+	enetc_port_wr(hw, ENETC_MMCSR, val);
+
+	mutex_unlock(&priv->mm_lock);
+
+	return 0;
+}
+
+/* When the link is lost, the verification state machine goes to the FAILED
+ * state and doesn't restart on its own after a new link up event.
+ * According to 802.3 Figure 99-8 - Verify state diagram, the LINK_FAIL bit
+ * should have been sufficient to re-trigger verification, but for ENETC it
+ * doesn't. As a workaround, we need to toggle the Merge Enable bit to
+ * re-trigger verification when link comes up.
+ */
+void enetc_mm_link_state_update(struct enetc_ndev_priv *priv, bool link)
+{
+	struct enetc_hw *hw = &priv->si->hw;
+	u32 val;
+
+	mutex_lock(&priv->mm_lock);
+
+	val = enetc_port_rd(hw, ENETC_MMCSR);
+
+	if (link) {
+		val &= ~ENETC_MMCSR_LINK_FAIL;
+		if (priv->active_offloads & ENETC_F_QBU)
+			val |= ENETC_MMCSR_ME;
+	} else {
+		val |= ENETC_MMCSR_LINK_FAIL;
+		if (priv->active_offloads & ENETC_F_QBU)
+			val &= ~ENETC_MMCSR_ME;
+	}
+
+	enetc_port_wr(hw, ENETC_MMCSR, val);
+
+	mutex_unlock(&priv->mm_lock);
+}
+EXPORT_SYMBOL_GPL(enetc_mm_link_state_update);
+
 static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES |
@@ -893,6 +1033,8 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.set_wol = enetc_set_wol,
 	.get_pauseparam = enetc_get_pauseparam,
 	.set_pauseparam = enetc_set_pauseparam,
+	.get_mm = enetc_get_mm,
+	.set_mm = enetc_set_mm,
 };
 
 static const struct ethtool_ops enetc_vf_ethtool_ops = {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 041df7d0ae81..de2e0ee8cdcb 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -222,7 +222,30 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PSIVHFR0(n)	(0x1e00 + (n) * 8) /* n = SI index */
 #define ENETC_PSIVHFR1(n)	(0x1e04 + (n) * 8) /* n = SI index */
 #define ENETC_MMCSR		0x1f00
-#define ENETC_MMCSR_ME		BIT(16)
+#define ENETC_MMCSR_LINK_FAIL	BIT(31)
+#define ENETC_MMCSR_VT_MASK	GENMASK(29, 23) /* Verify Time */
+#define ENETC_MMCSR_VT(x)	(((x) << 23) & ENETC_MMCSR_VT_MASK)
+#define ENETC_MMCSR_GET_VT(x)	(((x) & ENETC_MMCSR_VT_MASK) >> 23)
+#define ENETC_MMCSR_TXSTS_MASK	GENMASK(22, 21) /* Merge Status */
+#define ENETC_MMCSR_GET_TXSTS(x) (((x) & ENETC_MMCSR_TXSTS_MASK) >> 21)
+#define ENETC_MMCSR_VSTS_MASK	GENMASK(20, 18) /* Verify Status */
+#define ENETC_MMCSR_GET_VSTS(x) (((x) & ENETC_MMCSR_VSTS_MASK) >> 18)
+#define ENETC_MMCSR_VDIS	BIT(17) /* Verify Disabled */
+#define ENETC_MMCSR_ME		BIT(16) /* Merge Enabled */
+#define ENETC_MMCSR_RAFS_MASK	GENMASK(9, 8) /* Remote Additional Fragment Size */
+#define ENETC_MMCSR_RAFS(x)	(((x) << 8) & ENETC_MMCSR_RAFS_MASK)
+#define ENETC_MMCSR_GET_RAFS(x)	(((x) & ENETC_MMCSR_RAFS_MASK) >> 8)
+#define ENETC_MMCSR_LAFS_MASK	GENMASK(4, 3) /* Local Additional Fragment Size */
+#define ENETC_MMCSR_GET_LAFS(x)	(((x) & ENETC_MMCSR_LAFS_MASK) >> 3)
+#define ENETC_MMCSR_LPA		BIT(2) /* Local Preemption Active */
+#define ENETC_MMCSR_LPE		BIT(1) /* Local Preemption Enabled */
+#define ENETC_MMCSR_LPS		BIT(0) /* Local Preemption Supported */
+#define ENETC_MMFAECR		0x1f08
+#define ENETC_MMFSECR		0x1f0c
+#define ENETC_MMFAOCR		0x1f10
+#define ENETC_MMFCRXR		0x1f14
+#define ENETC_MMFCTXR		0x1f18
+#define ENETC_MMHCR		0x1f1c
 #define ENETC_PTCMSDUR(n)	(0x2020 + (n) * 4) /* n = TC index [0..7] */
 
 #define ENETC_PMAC_OFFSET	0x1000
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 7facc7d5261e..97056dc3496d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1083,6 +1083,9 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
 	enetc_port_mac_wr(si, ENETC_PM0_CMD_CFG, cmd_cfg);
 
 	enetc_mac_enable(si, true);
+
+	if (si->hw_features & ENETC_SI_F_QBU)
+		enetc_mm_link_state_update(priv, true);
 }
 
 static void enetc_pl_mac_link_down(struct phylink_config *config,
@@ -1090,8 +1093,15 @@ static void enetc_pl_mac_link_down(struct phylink_config *config,
 				   phy_interface_t interface)
 {
 	struct enetc_pf *pf = phylink_to_enetc_pf(config);
+	struct enetc_si *si = pf->si;
+	struct enetc_ndev_priv *priv;
 
-	enetc_mac_enable(pf->si, false);
+	priv = netdev_priv(si->ndev);
+
+	if (si->hw_features & ENETC_SI_F_QBU)
+		enetc_mm_link_state_update(priv, false);
+
+	enetc_mac_enable(si, false);
 }
 
 static const struct phylink_mac_ops enetc_mac_phylink_ops = {
@@ -1284,6 +1294,8 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 
 	priv = netdev_priv(ndev);
 
+	mutex_init(&priv->mm_lock);
+
 	enetc_init_si_rings_params(priv);
 
 	err = enetc_alloc_si_resources(priv);
-- 
2.34.1

