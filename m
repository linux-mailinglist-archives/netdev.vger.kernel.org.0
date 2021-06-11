Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C823A3F81
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 11:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhFKJxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 05:53:11 -0400
Received: from mail-eopbgr130082.outbound.protection.outlook.com ([40.107.13.82]:26804
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229480AbhFKJxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 05:53:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QfFPxI1KSdhtZ9ugE6AIdaRvU7YYsiGKq3jBOfM9mYRE4GQhJPuhQJz48f6qhoZq22yqt4zWEHbUWJixbGdt1o8XMDRgICpLn1IomSs2HfwhwDjmBfGLvC4FjIGQwvAw5Er2WbnCUli/TVcgWAEbsQ1lWSPnICnj/NeHdJIgdXX8WBKpZhwknppfuYgFoZFMImiLWALW8xLIaHs/z7mwJ2zEY3e4D3eJ7O+rldvpxJfEp0f5gCcZH8zGCGFl6nNZYcGsLD2OCiT1JTX/EjKT1k3kV5P9V9gZxU7HUL/iTC0kpBPLFNZ21QZA1dqGt2k4LLLuL822EvodX90MtmYNjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/kFpC6AKpGDWZva3XEgl88OHIBGvvirJzXiOAAKLfM=;
 b=oAnBOTwtHidV6TPSqJnHhi7i2+7p1trYdgnKEIIf5T1gA1kmBV95fuLFXCh739qvSg03sK9Mj9O86pe7DHDpLuLo6P/JNTQA2VkTnS5sUw8rVD4j4HbIosp/2Nsx3/skD6vNGVPqlzbcm20MRK31nlNgAF9djy4iYUPrDNx9uE9uLea5b0+EZPaS8eqoMc5NaT9VRfr++jmXEELbvFJ/wlRVqSA7mgjuiuYRCGAl/7r5pn/+oAiZZ9auPzK7CescsxfvbQ+kmtVUbf/O0vMGp5qLlvzhWTSebmtJb56c8SPvZrZ3jC51aImAPM9mxV4ETFCRCkhg7VlZT/ZO8FAUZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/kFpC6AKpGDWZva3XEgl88OHIBGvvirJzXiOAAKLfM=;
 b=ch0daKQuSUhSgVQAV4vT0Em2iWnMs7PvEbJZIR9b89A4OtGsOc081AurkIbAe1qenn9D6q3/RUi4ED3zblO0h6Z5dInDY+loph79mrPHEgNOdGpBOGE8q0ECrPntC4gIGA02dNjurmKnq/dT8H6J+lKLKWWdVQWmv63HjUcTzl0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5787.eurprd04.prod.outlook.com (2603:10a6:10:ac::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.25; Fri, 11 Jun
 2021 09:51:06 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4219.020; Fri, 11 Jun 2021
 09:51:06 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, frieder.schrempf@kontron.de,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 2/2] net: fec: add ndo_select_queue to fix TX bandwidth fluctuations
Date:   Fri, 11 Jun 2021 17:50:05 +0800
Message-Id: <20210611095005.3909-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210611095005.3909-1-qiangqing.zhang@nxp.com>
References: <20210611095005.3909-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGAP274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::17)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 09:51:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a62ed665-65ae-4f27-31ba-08d92cbe6ef4
X-MS-TrafficTypeDiagnostic: DB8PR04MB5787:
X-Microsoft-Antispam-PRVS: <DB8PR04MB5787A7BDDBCC9B091DA91098E6349@DB8PR04MB5787.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NxsayrAF3xVItpf3w1nxmei7SUEywbUy66lohzP8+hk6uZkj0Q+t4UUh7qUJUNN+DqrYHoiH4PF1iB2tDYxSeMVFy5CO95ZJGIWHbuQvyNy51i9J9F6NlDLn2+lp92yezLkVt6ntJr6WArPjin8SDX8h+2FVMS6hYvAUo3kj/yO8o9iC4ZMHBTblFb7gaosd+US4aY7DVry+E+6T37wwuHrXmJczQZOrhlisH4Z1TaW/T2ZOPQIZGcXyakudAmZR0K+dm7FHgjGwwjDp9sNJKJ1rLgwQq6oElAtL9fYDQAVZKHdAR5u8BWZ7gdjRJqy+xjcSs+l6YQJahPWgLeIB+be4xqQ5qe2uqpL2akJOYfxAGcxGEpvTZ43856vrtiAXDb6ofF6HwdRvMa7rwv7VKaXj9sY1u+zMjBXQkeFguE4XK7BhEzfME1WjQEj0Nl6X0sigdvJ320IngYnv4NN/oTCDWMrx6KUrcnuS/eJTe64Gb1CT2aFzfoDwtfpQ+ZqB5wKVv677UWDhdGM4hiVtaAOnVCW3TaQ3O7ly+/OLnYeQ+4aSCG/ERJ9LFPHEtFjZyMnXOnOCoO6i6ZqEkxxqeSXZfTEhRnrrtrdIwamSNzMm+jU6dGxbsZsiSKXu909FAqthunqCS0xu6Sko/44k2QUPWz2iFuI5SmNz2ZiXu50IWy6xTxiGpN86hR22/Apj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(366004)(39850400004)(376002)(6512007)(66476007)(52116002)(86362001)(478600001)(186003)(2906002)(16526019)(6486002)(38100700002)(6506007)(36756003)(38350700002)(5660300002)(2616005)(956004)(83380400001)(26005)(4326008)(316002)(1076003)(8936002)(8676002)(66946007)(66556008)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?en/3LgbdilayAH/nY0h6LTS+2DKwAaBJbyHVxy4zD66kZhBlzDC/QKZRwdCT?=
 =?us-ascii?Q?6y9nJuimKgP3fV/eawHEpOIDt+oeCnypvKdd8J1zNLc6b90/x6Kuqm+JSwCY?=
 =?us-ascii?Q?aM7tB7vAU8+20qKXwN2zfdyavjjFy1quRVNPEL7nR6/Dyuc/poL4mZ6aoYVM?=
 =?us-ascii?Q?i9u/UeryoXEvBDlEptStjrimn8r0LrTJAKWZVbjIBvilSmsVyG6qr2rw+FoJ?=
 =?us-ascii?Q?Qhx91ujRUSWViMZr4zCq2hObmBCaCInPsy88KsAG67CcAq9NFecmL3CS6fyx?=
 =?us-ascii?Q?lXpOn7HQ/36BrXH0Jf6LIQnxoOqMoAtrLUVXJT9bUAPv3Mx8klzuZaZpqwVP?=
 =?us-ascii?Q?c6BPXvihfKk+TiE/QdRPTHvEVMdyVK1MGzsSKNYINTYirqBYvZyt0iqRHJBw?=
 =?us-ascii?Q?t1cmN2k58fepTqJzATztLCJ6MopDMmlkGsxp2HoWcHdD1Rpe+ZirfJkf7X7V?=
 =?us-ascii?Q?jQ5ylywuneobzjBVgsXIiNz3ThcYn6uh8t43PLuKScVPdJwx9eTow0CBCJMK?=
 =?us-ascii?Q?pwzk/hZSkyCCAaR7baU4xVUVng36SjP25XGHEfaiYhkDOAArWUC39qQAc9e9?=
 =?us-ascii?Q?IeNRQ4VFDQXVhcMY0n4CzX/OxIgdRDDrTQFf/j+DxgK1jUKo3BDCTsJ5rQjs?=
 =?us-ascii?Q?ItBiWJlFT4IpgeqT/MKlgqg74E8e7zHUsLGwqzjrT5VO6PK8OnHj6WRrKlYW?=
 =?us-ascii?Q?lb069udLgxJrG0txqAhl9YaGpg7TNZhAYCvCoO+jEdMols81AKYtTU0nUsDp?=
 =?us-ascii?Q?mvR4ksmjXw/NIwL62MMApedsGskHtReLiyenjGa+JfYdvJ4U20sZCht5h8o1?=
 =?us-ascii?Q?4vdblusmp4wS4BhFe1RFqgcytcnjc4y8ajuqPvsnGoRdUMBZufy5aiZW/beH?=
 =?us-ascii?Q?7oOPRbqqHMZWUVEfBt8Z8sJW2EfnhS4sdv691pdXEER4kAbPDjou5Y9SNzC1?=
 =?us-ascii?Q?cRI0/84OEia6n0xKTguDDS1xp+lgYfhanWF1OVDNfu9Y8BuICBKpl/HFs1t+?=
 =?us-ascii?Q?hHv7ZgplMHtTAUnmVWZ32Wr6RJKTSNS1+lk8kJzNiaki6BRGR9sg00ZpHf1g?=
 =?us-ascii?Q?4L/ma30HzHMoYOhShGbCNy5IiPiM2igHpcJDDoSTcyqk+nXcqGGtuu4qdYq1?=
 =?us-ascii?Q?rJbmO2497IHeGc5Bg+2qkCMD3DkoaGxaCybmMk7UIOzyX4VuiLjqT1fYPATl?=
 =?us-ascii?Q?6VWV5537fMOgaBbLvJxn6KVqARYR8TxN7wc8hgnsz+Q2lQemyBhlC8t4AjlH?=
 =?us-ascii?Q?zLQdhuzsdTKwtighMLM89OKst86f8Til0dW62WeByckbLh6AKELC6nzSfhHg?=
 =?us-ascii?Q?o3TM4/wYyuDCalginXGIMdJ/?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a62ed665-65ae-4f27-31ba-08d92cbe6ef4
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 09:51:06.7975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0eS5ecQUzzh1bZ8kQ+MpknuBhw5CwNyOfkwqLkDxZzywKJDb+vEh6rtmnvJwcP54WM9h6SFs8ULMONsBgKIUJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5787
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

As we know that AVB is enabled by default, and the ENET IP design is
queue 0 for best effort, queue 1&2 for AVB Class A&B. Bandwidth of each
queue 1&2 set in driver is 50%, TX bandwidth fluctuated when selecting
tx queues randomly with FEC_QUIRK_HAS_AVB quirk available.

This patch adds ndo_select_queue callback to select queues for
transmitting to fix this issue. It will always return queue 0 if this is
not a vlan packet, and return queue 1 or 2 based on priority of vlan
packet.

You may complain that in fact we only use single queue for trasmitting
if we are not targeted to VLAN. Yes, but seems we have no choice, since
AVB is enabled when the driver probed, we can't switch this feature
dynamicly. After compare multiple queues to single queue, TX throughput
almost no improvement.

One way we can implemet is to configure the driver to multiple queues
with Round-robin scheme by default. Then add ndo_setup_tc callback to
enable/disable AVB feature for users. Unfortunately, ENET AVB IP seems
not follow the standard 802.1Qav spec. We only can program
DMAnCFG[IDLE_SLOPE] field to calculate bandwidth fraction. And idle
slope is restricted to certain valus (a total of 19). It's far away from
CBS QDisc implemented in Linux TC framework. If you strongly suggest to do
this, I think we only can support limited numbers of bandwidth and reject
others, but it's really urgly and wried.

With this patch, VLAN tagged packets route to queue 0/1/2 based on vlan
priority; VLAN untagged packets route to queue 0.

Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reported-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 32 +++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 98cd38379275..00d3fa8ed3a7 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -76,6 +76,8 @@ static void fec_enet_itr_coal_init(struct net_device *ndev);
 
 #define DRIVER_NAME	"fec"
 
+static const u16 fec_enet_vlan_pri_to_queue[8] = {0, 0, 1, 1, 1, 2, 2, 2};
+
 /* Pause frame feild and FIFO threshold */
 #define FEC_ENET_FCE	(1 << 5)
 #define FEC_ENET_RSEM_V	0x84
@@ -3240,10 +3242,40 @@ static int fec_set_features(struct net_device *netdev,
 	return 0;
 }
 
+static u16 fec_enet_get_raw_vlan_tci(struct sk_buff *skb)
+{
+	struct vlan_ethhdr *vhdr;
+	unsigned short vlan_TCI = 0;
+
+	if (skb->protocol == ntohs(ETH_P_ALL)) {
+		vhdr = (struct vlan_ethhdr *)(skb->data);
+		vlan_TCI = ntohs(vhdr->h_vlan_TCI);
+	}
+
+	return vlan_TCI;
+}
+
+static u16 fec_enet_select_queue(struct net_device *ndev, struct sk_buff *skb,
+				 struct net_device *sb_dev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	u16 vlan_tag;
+
+	if (!(fep->quirks & FEC_QUIRK_HAS_AVB))
+		return netdev_pick_tx(ndev, skb, NULL);
+
+	vlan_tag = fec_enet_get_raw_vlan_tci(skb);
+	if (!vlan_tag)
+		return vlan_tag;
+
+	return fec_enet_vlan_pri_to_queue[vlan_tag >> 13];
+}
+
 static const struct net_device_ops fec_netdev_ops = {
 	.ndo_open		= fec_enet_open,
 	.ndo_stop		= fec_enet_close,
 	.ndo_start_xmit		= fec_enet_start_xmit,
+	.ndo_select_queue       = fec_enet_select_queue,
 	.ndo_set_rx_mode	= set_multicast_list,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_tx_timeout		= fec_timeout,
-- 
2.17.1

