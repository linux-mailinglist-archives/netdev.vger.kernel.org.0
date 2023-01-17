Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC0B670E22
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjAQXwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjAQXv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:51:58 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2082.outbound.protection.outlook.com [40.107.14.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912C24FAD6
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 15:03:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfauLUiTHP/2bXRIghIjcEdeoRHTrL225JEU2lGQ/sQx/N3v08m/+qGrizRSsQ77oKy8T/u24Pn5VfKMTBGo1rSOlageixQc0zfzy/iQqqqOoe4cDWom1eHpSaGoB5HGK0KVmN6r4ogSMAvIfMDfboadh6yHYps5AndBYTTNQ51eSo5/kmQgD01hwIKRSTCXzdPpq0TGhIdTvqESEZHy2pAjdDhaEskNigcZaB2Acp5z4G9qW2PEE5m9aIW4o3WrrIN6Men6kMH3OTbMoer9Bn2YvJN4bsvWTJawZx0oUgtZo02AbKguTy4pZH5STV7IoMcURuG/D/wPD8Hop45NGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMzGTwy5+BuPevJMxS+2UAZIp5EQFdmYZCjmCWbJ0aM=;
 b=gTF/NnwriLLKyV/bnGr3IOWszoq24jHP9vCbnHb40dK7r1klj8w+3X5lKN48cKoBDBe8k0LzYPHs25LlJ28+s1faELNBGzsMXfitVyB7vZP2IAY/AHjzfX766zQ//Achms93Hi2LKOLDmknHcTWAsZEkuKcPsqj12c77Y1w5QlnrBuWwTvOSIhbAFGdERKE5FFJrLrdhcU9bKqfuMI94T3PKX5Xlk0F3Akaw5ceTHydlmjk3d1XM9DWl6zIM77sec2z0pofjbVqQxFp1Yc6AXLcE6ZZV7Yq1n/q4wwYBi1FzW+owvywK78ZudJYRcWi9owaERhc/ZS2AjX0m8MyQSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMzGTwy5+BuPevJMxS+2UAZIp5EQFdmYZCjmCWbJ0aM=;
 b=Yrl+0EVBduUAhr1a97L19qkN+1HOVv8JU3Ix+CDM8MOSO4ab5altRCskWwUdH6Sidytw4IPp7+WYy3Bj+uw4nF631yCFaO3MtppXog/MAXBbbrxK24tA2MmDsBr1UxZFxI/BqTQLECyDBFc0UYz2kGiMQJRZkyPtcD0oGAkknLA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6808.eurprd04.prod.outlook.com (2603:10a6:20b:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 23:03:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 23:03:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 11/12] net: enetc: set up XDP program under enetc_reconfigure()
Date:   Wed, 18 Jan 2023 01:02:33 +0200
Message-Id: <20230117230234.2950873-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
References: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB6808:EE_
X-MS-Office365-Filtering-Correlation-Id: b9bbb65f-d37e-4193-eb4c-08daf8df07bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xX2Pm9WKRoN/7pwKTJJbt481Kc31R20uq7EY1jruA5vcoyHVZHGTtA9/RF91l8f80Tg3kKlLEjWztW9NjImQyF7+Nw+qNKVhcGjCwCod6NVGfGKmFi9ninbFGZir7WLfg/CSLbDmH4tYGYiA5Os9nca8keXBby4MSD5ciIV3VOc0/O3G9YA709QpFW6b1VpTpRWmfpu5tl/lzd8Ea11ArVC6Sp1ITWtqLAbhXwAo7E3S5kqgJPZvWi7L6lhZwn4k3ojZnYItV+XwhUTBh02+zyty4z5qDyC/JuJqS7OqPLG5WMTYB5f4XhTFGzuff62rJ2wAQ+3s2Vyro/sHUu4NQXxgY3Q6rrFhvQcij1IpKPIYrzmf2kKTIQpjpACr4ck/hAAzOCBK2xVZMafJTYJ70n0rvMEmNgTDG2zvnMBTs0Ip3t0vN5M6+F//sSpXIEWtOZO+ANhuOklAaY7QPhOlrMAAJWMyJcP1YeLTiITMGxA6zvOXmqQnbmG8FOGIhvUIu7BfKYpjXMxSQ/I8LcajItQsyaZ245/j8scVlV10htjfcKeL0Lgbrq0N2/YFWd599vHuHXqDGSyHsan0WcetSMEzncIniQkpHmnnm2cEQLmik3nP+wzPcgj/reSZ7MHhuEUIWCOC66cOm2bNEVVoJqzKbI5wZBHlFr69XPhD7VHCqaRTLrN3xzcR5KmZ/eAm13etgSEEkz2PVIkdAeHuJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199015)(86362001)(36756003)(38350700002)(6512007)(8936002)(44832011)(41300700001)(5660300002)(66556008)(66476007)(8676002)(66946007)(6916009)(316002)(4326008)(2906002)(2616005)(52116002)(83380400001)(38100700002)(186003)(478600001)(26005)(6666004)(6506007)(1076003)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SnafUWSN2SBCdjtvmBRPFJ+mCSi9gSD5pp+u1Hkrxz4SyHLmngeedfsu/n0r?=
 =?us-ascii?Q?8HsPX26x9gsT49Z8TqTUl812/WVOXUa3Z633I31zukGcwviwf7pV8yVjwK4c?=
 =?us-ascii?Q?KYn8MVnuFxUTWRSjp4rdphDOh4oUDctGjDsN8M6b/yWuZCnKKMWoJqfgA6C/?=
 =?us-ascii?Q?NX+CZQlSQbJsEK9XSvlYN2vKzd1bnk4Ilb8C07wZaN7lhm2RiuCvegt+FbKg?=
 =?us-ascii?Q?U6iLBzWD2IGEEu9sZ+lLYtFfcyMpbkGA3znrxk4i4HMcA1Oky/pY1LaYQA0m?=
 =?us-ascii?Q?R7H4Y/3+xLoapZ/oe5ETJpN4crO6zZ4ynkbea+JHNCDNoTnxw05qLTWSIXRp?=
 =?us-ascii?Q?QLISL7lPrPc3L8ub8PBkBdX3uU8H77J2Yu32d6xNFnx0Q2aXD4qXmjCQhs9Q?=
 =?us-ascii?Q?0aiHEX/SkJ466YaBH6Xlf6+4IenxzPIvoZJH7a7bTuw3dT0Xri//8WkJuecK?=
 =?us-ascii?Q?v/lR3LnV4l+LHIzMMHTVQ1Fo7NpLypQyBTnWZsMTUHzVK2Xauee/yKKneZan?=
 =?us-ascii?Q?F6UsU+d74ioFDoZtGEd4/DGP1uywKHmajCltDldYBG5Nwiil5AxgjFmTeb5C?=
 =?us-ascii?Q?e+5zfalH/sgeaaU4TBCQc0Ki8cdCDgV+Yf7uQsfipm2yB2W08bYLfDlvvGxD?=
 =?us-ascii?Q?ePaATC/U89sA7/HyMuzAa9fDcp5dY/qN9Ko9PTrmD8i/qq5m9jEDcRXgC3+K?=
 =?us-ascii?Q?nBlR4TE8PcLzqtUTEUt7DD0Cs2QKVplG5n6xDZPIvekBwLw17YKkA+2xVive?=
 =?us-ascii?Q?uuTDdB+5OHOfWbCSG24cDxfW09vBawFPHswI+9b4OWEUuJfX+Niepvi29QAp?=
 =?us-ascii?Q?d3c64xAGt8ZrXSXISDbj04zSs+VALnaRiabv43GHuYOl7hzLuM+5+aztFAXP?=
 =?us-ascii?Q?n0QRIw/SwOW0YXdN24ANMdD405XhZxaRQ4Or0xoW6+x1GIZsarehzcfW41zg?=
 =?us-ascii?Q?Q8SdrX4OMcDwRefmcpsL5HyPoIePULFjMZT9XUT4uLj8DkJlEsSEvhBr6RQu?=
 =?us-ascii?Q?rj2ciSODrwC3la6vQ1Nw5nF51LGF0Smx99AJPU/d1krq88CJdPjTvQuJRrBm?=
 =?us-ascii?Q?x7IuOkrYuPemw5T/w6F3wzZpvQHxrwqtVE4MLDt5vfSJulImVzR1rGWn3g3T?=
 =?us-ascii?Q?RQtypASMn/u1K+JDo22bdZ6EqTZq3TPuZlUbHY3eiLIm1U8o02opvwXq3Cww?=
 =?us-ascii?Q?W/wB1LgwShCbmaMq698hQYa5mmfiEOCeQlfbRVVe9kdju1OLkBAeT2EEgkpu?=
 =?us-ascii?Q?u8n7QRn6d9qiewr5vWUZc0HwVrQTFWUmrD9Bydv0NXIw4uv/QwH0t9+ibdo2?=
 =?us-ascii?Q?4i2lYyB3zpvjeq+VilnTd906w7zZ4fYcCwEtPYTijmumRbnVMl94hQmH6SUR?=
 =?us-ascii?Q?yGOuAiKoyRDoUreNud/XWv8adn4HZo/8yKWORcuDAs08rcXbYXy+aJovFADz?=
 =?us-ascii?Q?nmdOVJWAAtL7HO0D2KjMRgWoIB2b/K4/j8Wvgd4vyHrpdKrOc5D/jc3aX6hl?=
 =?us-ascii?Q?ydiMITOkwADZiupzcyFs5r5wLUBAaePzx5GPk8A09ysmWMW4j82e3kyJ5ahV?=
 =?us-ascii?Q?zZsefAQC//ucieDW7/VtGaxVzLUBtrddHq/q6n3eHlnXy/vBji7M9+zPYJS4?=
 =?us-ascii?Q?Dg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9bbb65f-d37e-4193-eb4c-08daf8df07bc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 23:03:22.1156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a7qXBRl/WPTJxrLUfscHqRAYnEIbvuMxc7QBT0mIoEL0dp6MEBz4vTSMukJZKRzRDXUmB8rGypaIVD7kLizs2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6808
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Offloading a BPF program to the RX path of the driver suffers from the
same problems as the PTP reconfiguration - improper error checking can
leave the driver in an invalid state, and the link on the PHY is lost.

Reuse the enetc_reconfigure() procedure, but here, we need to run some
code in the middle of the ring reconfiguration procedure - while the
interface is still down. Introduce a callback which makes that possible.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 51 ++++++++++++--------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index ce3319f55573..eeff69336a80 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2489,16 +2489,24 @@ int enetc_close(struct net_device *ndev)
 	return 0;
 }
 
-static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended)
+static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
+			     int (*cb)(struct enetc_ndev_priv *priv, void *ctx),
+			     void *ctx)
 {
 	struct enetc_bdr_resource *tx_res, *rx_res;
 	int err;
 
 	ASSERT_RTNL();
 
-	/* If the interface is down, do nothing. */
-	if (!netif_running(priv->ndev))
+	/* If the interface is down, run the callback right away,
+	 * without reconfiguration.
+	 */
+	if (!netif_running(priv->ndev)) {
+		if (cb)
+			cb(priv, ctx);
+
 		return 0;
+	}
 
 	tx_res = enetc_alloc_tx_resources(priv);
 	if (IS_ERR(tx_res)) {
@@ -2516,6 +2524,10 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended)
 	enetc_clear_bdrs(priv);
 	enetc_free_rxtx_rings(priv);
 
+	/* Interface is down, run optional callback now */
+	if (cb)
+		cb(priv, ctx);
+
 	enetc_assign_tx_resources(priv, tx_res);
 	enetc_assign_rx_resources(priv, rx_res);
 	enetc_setup_bdrs(priv, extended);
@@ -2586,21 +2598,11 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	return 0;
 }
 
-static int enetc_setup_xdp_prog(struct net_device *ndev, struct bpf_prog *prog,
-				struct netlink_ext_ack *extack)
+static int enetc_reconfigure_xdp_cb(struct enetc_ndev_priv *priv, void *ctx)
 {
-	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	struct bpf_prog *old_prog;
-	bool is_up;
+	struct bpf_prog *old_prog, *prog = ctx;
 	int i;
 
-	/* The buffer layout is changing, so we need to drain the old
-	 * RX buffers and seed new ones.
-	 */
-	is_up = netif_running(ndev);
-	if (is_up)
-		dev_close(ndev);
-
 	old_prog = xchg(&priv->xdp_prog, prog);
 	if (old_prog)
 		bpf_prog_put(old_prog);
@@ -2616,12 +2618,23 @@ static int enetc_setup_xdp_prog(struct net_device *ndev, struct bpf_prog *prog,
 			rx_ring->buffer_offset = ENETC_RXB_PAD;
 	}
 
-	if (is_up)
-		return dev_open(ndev, extack);
-
 	return 0;
 }
 
+static int enetc_setup_xdp_prog(struct net_device *ndev, struct bpf_prog *prog,
+				struct netlink_ext_ack *extack)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	bool extended;
+
+	extended = !!(priv->active_offloads & ENETC_F_RX_TSTAMP);
+
+	/* The buffer layout is changing, so we need to drain the old
+	 * RX buffers and seed new ones.
+	 */
+	return enetc_reconfigure(priv, extended, enetc_reconfigure_xdp_cb, prog);
+}
+
 int enetc_setup_bpf(struct net_device *ndev, struct netdev_bpf *bpf)
 {
 	switch (bpf->command) {
@@ -2755,7 +2768,7 @@ static int enetc_hwtstamp_set(struct net_device *ndev, struct ifreq *ifr)
 	if ((new_offloads ^ priv->active_offloads) & ENETC_F_RX_TSTAMP) {
 		bool extended = !!(new_offloads & ENETC_F_RX_TSTAMP);
 
-		err = enetc_reconfigure(priv, extended);
+		err = enetc_reconfigure(priv, extended, NULL, NULL);
 		if (err)
 			return err;
 	}
-- 
2.34.1

