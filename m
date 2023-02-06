Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A9568B8E4
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjBFJps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjBFJpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:45:47 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2077.outbound.protection.outlook.com [40.107.7.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4D6EFA2
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 01:45:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NuGeNnESIPX8em0cpZkRrluMRRAuVy+8hxmG5zi/K4nYSi36jxY6hu/qjEN4v0GJmZsTR54lR6vrMeCByHvFS0B2rSHiOZzMqvz5YKpaWAA4m4HbWHcZuhrhajXA7wr4YFlI+rCiwM3l9ier8QF3gQaIoGIaEYptQD6gVl9Bzz1Kk/i/5WTTSRRNXm7w0+Ss0EAyNTTZlLakcyZ4qE+B24zHf9TLjW6x3J1TBEeYT7cBtGH9OyiGHyAtvUMvzl/wvp+MPaenVGcu3rgG6gTJALTW9RW5hUZ+2aoe8IEN4NvDTT0uQW+03M3eBEBsDqJd1H0IivVQwpaX1C75iXKBZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v+bV3Hjl6/AE9ciWROTlHfJ8oBSRc86LXV/CMw86wS8=;
 b=mm2GZFjym/sy2ATmAIYHlTRxL69SgdrPnBdSwcJPJJ+Tqjb29hPxXE28RpCgLfsh1rQ70DzWi7xSi4xvXZmUzd/5MNUqnaCc3LJ6L2Dr57wGEE7YAzt1fU8ooNMkBIwX0EgHRJjy/zMH6hwdz3xbogNdkjD9ikJ9FY7t0HUZyLl8rEDA9Qq/jpHPdYQfJKrwGTccdu0Q6IHYbIAgPJgZ7Iixdb9Y28spkL+5uZ09eFQNtPNXsjyHQYNJw1EJzrH10LRledKh4KtRbnS3LBelps6Qc5c1QCkApf18XSkDOFX+cNEepqZ5wz8+f/b3XCY/pkkc+/fZJd/oZMpatNbGvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+bV3Hjl6/AE9ciWROTlHfJ8oBSRc86LXV/CMw86wS8=;
 b=CKDmFL+9aKoER/8IEo/MhLjiRjAb2YWiLvX7Or7tlRoB1fijZqX+O3pekqG9EvwYlIY48hMKqdilBusYLtTbx2swq5s4IvWYnHbxTH/B4scxLsrUYbWI3UwdXLdzIqjUSzFiEjI1o01OEBJFkjLasRwZrChvOx7+J5M5hB9J5os=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8108.eurprd04.prod.outlook.com (2603:10a6:10:25e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 09:45:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 09:45:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH v2 net-next 1/2] net: enetc: add support for MAC Merge layer
Date:   Mon,  6 Feb 2023 11:45:30 +0200
Message-Id: <20230206094531.444988-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0006.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8108:EE_
X-MS-Office365-Filtering-Correlation-Id: d64c150f-26bb-48ee-affa-08db0826e922
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FS2ulKboJgRodDz6LUb26Sngvdw8wUr2gZzjJz+aTp+q/fEfq2I1A1dv/FgWaT2UNZpl8XdnDC2fbpY9//CWuXPzLCu33AVjhYpvaxHx9axk2dyj7TLoQ4wDT1NGUr1YB3LpaphDJL32DRtCANiKKlJb+edx76iLHpColumqh+v30fO4KJibmqSeenB5cUNRHiebPPopzvo5qHAU7wxzhENc6jLtHeUElQB26wpEsNdMKFijXLUCQJlz+2a5D7EIP/kbG/FMHZHQ4Tssl1FGAyBAalYY5ap5v0ubz2eSWio3Ims2B89p1jDdoeNqG/wlkrwye2XRuWXxpuDAqBxEYl9mS/t2nEn8aJRalpW5RX3B3C+JjpSzOBmcOIoccppdzGIzrYO0l8FEIuN8gU+5nyhcmRpOjUzv0cUQWr9WB/tUNPre7u4x9AZxszkDD5/I/uLNpTuw+UNe5xufycaH0BuIREva7JgPDVQ4SvQWnn3Z4433KPtaSM7G9p44jJs1/7VTZN9WKr/lkX2qC4WJITnpYYk6vOWd44wpY/DBmzmlRVe14HmNVEQt/afHml0JcCD/48gftFCUg4J9jCuJSnLSjy0cSb7gKtHAy0iExeSvjzgdAIy70DomI1D/hMlq8/P7UtR4PbQwmBqHW2kvMRpNhmuiiauZy7iWZ6Rjktbx3x0OIBI4TTc5vW0MCIF7CPL6JSz5jYK3QU809rVgsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(346002)(39860400002)(376002)(396003)(451199018)(66476007)(6666004)(1076003)(6486002)(2616005)(478600001)(6506007)(8676002)(26005)(6512007)(186003)(4326008)(66556008)(66946007)(6916009)(316002)(52116002)(38350700002)(86362001)(36756003)(54906003)(38100700002)(83380400001)(5660300002)(44832011)(8936002)(41300700001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9wgQBEFMh20Ml53aPPKKnxKS6uFsgnXNC2Q9TJgR+UKfVz1ZCIRq9fYFbXwr?=
 =?us-ascii?Q?MVLXcEXr7x7yg99n3grvBdJUot3JIqh5P34Kbmry1o2EAwiDH1j59QYKuu6h?=
 =?us-ascii?Q?c2H0/GaA4Aj7y7yAikq1aEQ6zUbRpr1ykE2GMhsCPdTreDYgffewosDVF1GH?=
 =?us-ascii?Q?4M+qYF512K9HPVGgI1Xrcr/MEnbWpYzTR4H5/nXsoIDkPUrReWbCqBqz7je+?=
 =?us-ascii?Q?yllWwsJGe3+AxAfhhyec4Gwm1hKPNpfyD/uV+42vGsEXkxJDgrSvyolRG6H5?=
 =?us-ascii?Q?KF5xlFYIf2lt/mvj5T+//AUZUjgNBhZ9GLgKzLXLUEPUfsiheQfrrIXfoU88?=
 =?us-ascii?Q?3tOyIYK/U0eu55v9YOWrqQKryVmT4tzO7+X0TIiqu1y3STNmXpu4t7XoJ5bl?=
 =?us-ascii?Q?pvHtvNrzl3IGzKPDILNQtP5SVgEC1+WRCbjmkCV1ek8JQIi9pYxacl57Fsow?=
 =?us-ascii?Q?pKV73FuK/+b5h+6MMYs1YMuUWry6mkPymmg1iQDd3+pv5KFL4tClSDS5SGl7?=
 =?us-ascii?Q?OS++4zZrmKBij4lCWsEt81UIkbXj5M20sZ7kibT54CcQh2H63I7+tv2Zm44T?=
 =?us-ascii?Q?Aapp5x0uQ0jsQueR353Og9PBynuBEIyP45cSYtF9Tephfaa9jy6S2SMjR9u8?=
 =?us-ascii?Q?Uttv9o0jaxYwbCxUxQWJJBNX1t9oruO66gNEjXHTB99HihoXpBTpj6CZmDWk?=
 =?us-ascii?Q?TilPRp5rVuLZyvLCXgDgo39Qiu4kDakpANTZ67WkgNCw6zv0l7MM0KMO5ywR?=
 =?us-ascii?Q?WUyHiZTFqsscoceV6XYhyN/VlypxrdfsiX/oydFZau3bpPSInYYTaiwr9v9y?=
 =?us-ascii?Q?SFF2BqeMqUqucCEquLgiBqBEW41yQ6Ionymb42pxzzDKWiSvbQzn4FYr37Rj?=
 =?us-ascii?Q?MgDv7A6kFF4YZVMHKVXTgyK0EGAtJWeuM+J1UZTUSlclEcR0zq80gNRoBUFe?=
 =?us-ascii?Q?blnYUMz1EcrGR7a/BgXOgPpPKpz4Eo9ytL253wDiIwmVa1nrNFQZYRkGYJsz?=
 =?us-ascii?Q?u+sNXam719O27mQ9GLUTtUtEeuIrcRgHKXgWusoglx/KTMGZ2PaRchDX97ee?=
 =?us-ascii?Q?3+5XI57xRAr3mSOQsWIO99J4noe60/6QOmrhMUdDnO580gFLolA2uECOvE+j?=
 =?us-ascii?Q?4TOhKPasllZOBtuZ+KjVhidIyye9USu9oPfuKidmFJiFPFco+tYXJ30yZ5ov?=
 =?us-ascii?Q?dzP6ymLfw/TTPVs1n+oczkboogV+6bEkV14f1vY/bM2UdQqRlZOVNIGznXSW?=
 =?us-ascii?Q?UOqTmNu66HpxPJLcsXQhTXoUWL+8uZXz3WiLMZ9tOnvsgjhs3hURaIfRvJPR?=
 =?us-ascii?Q?g21vaIIGY7HK177bmevZOoyz227Thd569h3b3vv08iEMUb8sLCZTXs5iANPF?=
 =?us-ascii?Q?DXN6B5oQ0kWRx7Wj1/H3nFu5lu+lW4MAx+gzVtlDHYlQWhbUUF5rUGl/dtey?=
 =?us-ascii?Q?b1qdi+havK//UdQjWzJ9HGIXxstL0HRLGIkFdPSfXuOoou+aXQOi6oqiJBZe?=
 =?us-ascii?Q?lhuYbYSdUCNZ2DOAQVCgg90rKTbhhF5mvoQpdyAFHgr1HA5p+DrCIOqgTRV+?=
 =?us-ascii?Q?sJmBJiPQZd8NQEwGYPED3+NonKW+ooHAoKxEV43aM/8BhZgCP5QkdYfOr1om?=
 =?us-ascii?Q?EA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d64c150f-26bb-48ee-affa-08db0826e922
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 09:45:41.8232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWTxWRyLQxPUrW21GeBBPUHAmUluW+QWwYsFrheFKols+Brs8wvIoG3NsOvA7h2iWFQ3FbeHn2YeuKw55qBlsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8108
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
v1->v2:
- remove stray enetc_reset_ptcfpr() and enetc_set_ptcfpr() definitions
- move MM stats counter definitions to the other patch
- set state->verify_enabled in enetc_get_mm()
- add comment near ENETC_MMCSR_LPE in enetc_get_mm()
- add comment as to what mm_lock does
- add comment about enabling MAC Merge right away

 drivers/net/ethernet/freescale/enetc/enetc.h  |   8 +-
 .../ethernet/freescale/enetc/enetc_ethtool.c  | 144 ++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  19 ++-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  14 +-
 4 files changed, 182 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index e21d096c5a90..8010f31cd10d 100644
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
@@ -382,6 +382,11 @@ struct enetc_ndev_priv {
 
 	struct work_struct	tx_onestep_tstamp;
 	struct sk_buff_head	tx_skbs;
+
+	/* Serialize access to MAC Merge state between ethtool requests
+	 * and link state updates
+	 */
+	struct mutex		mm_lock;
 };
 
 /* Messaging */
@@ -427,6 +432,7 @@ int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 
 /* ethtool */
 void enetc_set_ethtool_ops(struct net_device *ndev);
+void enetc_mm_link_state_update(struct enetc_ndev_priv *priv, bool link);
 
 /* control buffer descriptor ring (CBDR) */
 int enetc_setup_cbdr(struct device *dev, struct enetc_hw *hw, int bd_count,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 05e2bad609c6..078259466833 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -863,6 +863,148 @@ static int enetc_set_link_ksettings(struct net_device *dev,
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
+	state->tx_enabled = !!(val & ENETC_MMCSR_LPE); /* mirror of MMCSR_ME */
+	state->tx_active = !!(val & ENETC_MMCSR_LPA);
+	state->verify_enabled = !(val & ENETC_MMCSR_VDIS);
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
+	/* If link is up, enable MAC Merge right away */
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
@@ -893,6 +1035,8 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.set_wol = enetc_set_wol,
 	.get_pauseparam = enetc_get_pauseparam,
 	.set_pauseparam = enetc_set_pauseparam,
+	.get_mm = enetc_get_mm,
+	.set_mm = enetc_set_mm,
 };
 
 static const struct ethtool_ops enetc_vf_ethtool_ops = {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 041df7d0ae81..7b93d09436c4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -222,7 +222,24 @@ enum enetc_bdr_type {TX, RX};
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

