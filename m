Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30F442569C
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241213AbhJGPdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 11:33:33 -0400
Received: from mail-eopbgr10059.outbound.protection.outlook.com ([40.107.1.59]:24805
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241048AbhJGPd2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 11:33:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gj9ldivj9a2E1b+N9ygDFXsU78bUxKRJadOpMzPmRAK+vR4otrA4ppmlwbrwGIp8FsQ6SJ8TtvanjKHZLk6EXsGt9Er/mTDB9vbyUUiJYTsGu8w+Dch+c42ONW1xLqkmfH46kAOSq/B6Hl5QPBUptYufZp6OKV2xKA4eh1BUiSuFmZLiagELfJRGotox7exodV+MywkmSL/cCiyQO2mlWXDrReApfypdQYS5sr6EKd5TXpjDLXZKx0kSEjQo3G32zYo1fcCodeWm+CHb9lihx+9tOGuholeGF2eT5JIX52/OKaYnhcRiisI3FTONT89Ldw2F6HBPkg68Dl+ebV8fog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SjcGTK64opzE1EEAluycPh24o8NqSmshqDU0633iBIQ=;
 b=cArTV1QO7iFal/4D0vT9btTy1BK42CQeADq4mZy6Q5Tw3HZdhArhyPA6LOEjjVbJMRX5timTpFfUecqLtIlQyvWZJdI/D6439eMEkxKoYdmJz2FY7WiMgjAzYOTpXjpbE26hnhmP2fs8sxHphwVcX9399F8/5FlRG7KA6GBO3lYnPfJ8h6u0cChYB4FxshIkot+mbBO4U2373r+HU4iwT9zvZBuTFh9oeoVr6/xe8z00CeQZ2lTneRK9MoKwr8+xkg0rKvmsdLxO1bUzSKlrvVkjfc1VryrZCoLs/3OBgyvrlsRADz0zG+xCNU+4/GyEkc0icG803N5Dy7ePGDAPCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SjcGTK64opzE1EEAluycPh24o8NqSmshqDU0633iBIQ=;
 b=d7g0l8FS9s65Xy8xjB9Z4IIMbE4zAK5fUar2ECWUVOR9Y1xLVoCqOjO9vQ2PmM73mcbLhet4T2Z2q+0FUxwPJXrTDKe9zi21Kytjz3kA+FIRE7gAj6wFa7UWuAnM8XfuTD0eB3z3dxuFpNmE9UNgXJW47wQLPg3hmYsFVkO69MY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM8PR04MB7410.eurprd04.prod.outlook.com
 (2603:10a6:20b:1d5::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Thu, 7 Oct
 2021 15:31:30 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 15:31:30 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 2/2] net: enetc: add support for software TSO
Date:   Thu,  7 Oct 2021 18:30:43 +0300
Message-Id: <20211007153043.2675008-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007153043.2675008-1-ioana.ciornei@nxp.com>
References: <20211007153043.2675008-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0017.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::30) To AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13)
MIME-Version: 1.0
Received: from yoga-910.localhost (188.26.53.217) by AM0PR02CA0017.eurprd02.prod.outlook.com (2603:10a6:208:3e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Thu, 7 Oct 2021 15:31:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: faf983ae-066d-4ef4-92d5-08d989a78929
X-MS-TrafficTypeDiagnostic: AM8PR04MB7410:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB74103B1D47CEF0A4D8D456E6E0B19@AM8PR04MB7410.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tDLJQCr8Xc8BjMh9frCmItaieBTsmy1PhqEj31abEEKBdMcyxi40LiO8yFpyhU3isflgE29DSsa0hBZ4GJK+zkvvu1MTR4NdEc8jgzQ4njNKscGvK29qWilI24nxK0gKhxYQjDHG1nSy0AxXP3P/Zm/4mWtKbAudkG82AMFd7LBQDN6f7eE3G+iT54vIt1NNdMDeqR6WqYufJNknNHF9kLKijEDQCMvu98wwQWXKplZbCIQHkbBtMQEr0+dqi0z37zQ83ay4ZJLsl4SEyEES2NS7yXouyMtoVhSipsTsoz6g4jM2bOlN4ibaGmSxh7EwJTpAOtVznsk47gnXtnS9oZznsF7fvjmbfQqlhecCFRfK4pm3+NVz6ML8iVb0cB0quN3YeEXyVIe/2ACmeC31UIa45P+jD5YVRa9gSAarmRxcqttJHrMSxGLU11NA8tS5AU5lH4MY561H+2jVA7J2WRfjwyMNgDGIsooApl9fCHCI74Cr/5xdVoCRiWm6YM3h/dC6tzyj+IHdCe39WlmYmTRXlHcM1sBikFbqpzIsUJ+NWfGxzFMyIudRKzqG9oBTkrbRVRh1YKarMMfCoESZCdRgvWop1kdPZUOYjarhXxpgesY4EIxO74HKUljNjyqCYG4HzY5z92Phos3/mfffYO2HF6Ux7CdW40g60YQ33JOay4X7stCe6jcdCdeaCjFgxBzoMkqsyr5LgcVSWzSJ4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(6506007)(6666004)(1076003)(26005)(316002)(66946007)(66476007)(66556008)(36756003)(508600001)(5660300002)(38100700002)(38350700002)(8676002)(4326008)(83380400001)(8936002)(6486002)(956004)(44832011)(186003)(30864003)(86362001)(2906002)(6512007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jrgPh3pbjX8rmYrqeURYQNUW7U9ZaoMbTRJ6GkvvW/kPShZ53I2QrG4We+9w?=
 =?us-ascii?Q?4Q5bCN7guqPAuaJFxHTvoYygRsjBvqX3Gj3oku2cAHt93qbOTkV8iJIfxGHP?=
 =?us-ascii?Q?Pv5o0Lr4WZDZG6V+6pQAEUE2TlBeOe8SmNrDdqkbPxbLr60K4ACiplhsKLfu?=
 =?us-ascii?Q?6J9DhC9Jn+SfSbpO4bHeT+8JkXrWB8NWvymGzJpT3E4TEPERUCWBnLIMMIm4?=
 =?us-ascii?Q?34FPGzLS9Im4rJnxqL0gPaFLfvybH8GiULeOCoSwXrwjrjrMHaWXe+/al5FO?=
 =?us-ascii?Q?py9N/h21sFnxFi+QDLZVmRB7ZUe3rzYaZWYIJKtpLbVbjz5DR8F7g6dBmKZh?=
 =?us-ascii?Q?51gXJ2KGE38VJOZ/JKcTxwbP2i8e/HGZuScxYfTR5klg9/tIbGMZW/uGJJdb?=
 =?us-ascii?Q?W/4TjBPaNTuyoVggfWd7AyUnKi6K0cXFPg1Hg/7zOuLf/3zX/WS99nTmpmln?=
 =?us-ascii?Q?AhqgO3Xt1/n8ZRM9ZtjpC6WWdsAkg3CgXNViZpCEhV1r55cQRSQ4w75/m1sQ?=
 =?us-ascii?Q?8+o7/AP/xRzXXJc6Uz+SmjpQlNf1X9MsRI+llLc7JejnB/vkI082jwZ+2APB?=
 =?us-ascii?Q?LcJqKSGpGtLN5iGl/XW3WDfCD0nxv+msXOTF9nmnPvLsUXB/pFB345zl58mq?=
 =?us-ascii?Q?sONYZidQScaj0tGja4pDOctKjWq0m8Ujgv/E6y+Ei9FeUC+rcfVy8N0nBuSX?=
 =?us-ascii?Q?cxbWGPiw3uMh7RRqp6m2XlCcKNefaPwyhJcQFkFA9CzANdYjg62CXLpfc1q/?=
 =?us-ascii?Q?XtYWV72oQUXRylAP5G2Nyxg0FKa8A9WRlAAKr/1LKfIZlMI9qVZtGQBJGm0g?=
 =?us-ascii?Q?sJYd2Mtbjq+GsIFcZvqBfGALP72ZRhw/3gR96VOLl9xXkAHEtvVrLtoy6pzS?=
 =?us-ascii?Q?HEqGQShxV1VwNClGJ37q4IZdQd3PcQSBBux3wlZRedhvF1NzJFBOMRmFv0j7?=
 =?us-ascii?Q?WxNr0nsNKgqR3HUbiXRFv4/FLet6ZyrPimTCc0yKJYtSHwmgIAxIhAxfVqBE?=
 =?us-ascii?Q?SPzTKI3H+cpYJotf0duCLmcMNy3mzUpzaWDP280ZjwrAXZpAkQXwz4Wq/VfP?=
 =?us-ascii?Q?nPMXXbwY7GrzNZN3TljC+QLxgyQsWq2yFqoKDt59IwBsRSb8b2UsI7T380+G?=
 =?us-ascii?Q?JhBZqi5o7g7xqF8x51ItLubWZBgayhx2htMwDJO81vPdORGE26F6vEy36+pR?=
 =?us-ascii?Q?hVlHkqoH5l8quL0iYgLGfEes5DoFeAmHtkBAC6rbqqBNKOmRsQH09AnLG7Lr?=
 =?us-ascii?Q?Lm8PiGMwnoXUCM+CJVv8SEpf46yqB63AlTPK203HhPeYeGXfuZahgHlXktNx?=
 =?us-ascii?Q?vWnAvKgLX81RmpkOH83pfJyT?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faf983ae-066d-4ef4-92d5-08d989a78929
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 15:31:30.6501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cwjV6aJDh7LJ14YpGZ3rRCLZGwSdsVRmiJTAU/Zs0t+/YYxNX/hknlcBefMSnO1AjdWwkGFjRtllNL0M48v9cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7410
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for driver level TSO in the enetc driver using
the TSO API.

Beside using the usual tso_build_hdr(), tso_build_data() this specific
implementation also has to compute the checksum, both IP and L4, for
each resulted segment. This is because the ENETC controller does not
support Tx checksum offload which is needed in order to take advantage
of TSO.

With the workaround for the ENETC MDIO erratum in place the Tx path of
the driver is forced to lock/unlock for each skb sent. This is why, even
though we are computing the checksum by hand we see the following
improvement in TCP termination on the LS1028A SoC, on a single A72 core
running at 1.3GHz:

before: 1.63 Gbits/sec
after:  2.34 Gbits/sec

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - add support for TSO over IPv6 (NETIF_F_TSO6 and csum compute)

 drivers/net/ethernet/freescale/enetc/enetc.c  | 319 ++++++++++++++++--
 drivers/net/ethernet/freescale/enetc/enetc.h  |   4 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   6 +-
 .../net/ethernet/freescale/enetc/enetc_vf.c   |   6 +-
 4 files changed, 311 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 17d8e04c10a8..09193b478ab3 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -8,6 +8,7 @@
 #include <linux/vmalloc.h>
 #include <linux/ptp_classify.h>
 #include <net/pkt_sched.h>
+#include <net/tso.h>
 
 static int enetc_num_stack_tx_queues(struct enetc_ndev_priv *priv)
 {
@@ -314,6 +315,255 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb)
 	return 0;
 }
 
+static void enetc_map_tx_tso_hdr(struct enetc_bdr *tx_ring, struct sk_buff *skb,
+				 struct enetc_tx_swbd *tx_swbd,
+				 union enetc_tx_bd *txbd, int *i, int hdr_len,
+				 int data_len)
+{
+	union enetc_tx_bd txbd_tmp;
+	u8 flags = 0, e_flags = 0;
+	dma_addr_t addr;
+
+	enetc_clear_tx_bd(&txbd_tmp);
+	addr = tx_ring->tso_headers_dma + *i * TSO_HEADER_SIZE;
+
+	if (skb_vlan_tag_present(skb))
+		flags |= ENETC_TXBD_FLAGS_EX;
+
+	txbd_tmp.addr = cpu_to_le64(addr);
+	txbd_tmp.buf_len = cpu_to_le16(hdr_len);
+
+	/* first BD needs frm_len and offload flags set */
+	txbd_tmp.frm_len = cpu_to_le16(hdr_len + data_len);
+	txbd_tmp.flags = flags;
+
+	/* For the TSO header we do not set the dma address since we do not
+	 * want it unmapped when we do cleanup. We still set len so that we
+	 * count the bytes sent.
+	 */
+	tx_swbd->len = hdr_len;
+	tx_swbd->do_twostep_tstamp = false;
+	tx_swbd->check_wb = false;
+
+	/* Actually write the header in the BD */
+	*txbd = txbd_tmp;
+
+	/* Add extension BD for VLAN */
+	if (flags & ENETC_TXBD_FLAGS_EX) {
+		/* Get the next BD */
+		enetc_bdr_idx_inc(tx_ring, i);
+		txbd = ENETC_TXBD(*tx_ring, *i);
+		tx_swbd = &tx_ring->tx_swbd[*i];
+		prefetchw(txbd);
+
+		/* Setup the VLAN fields */
+		enetc_clear_tx_bd(&txbd_tmp);
+		txbd_tmp.ext.vid = cpu_to_le16(skb_vlan_tag_get(skb));
+		txbd_tmp.ext.tpid = 0; /* < C-TAG */
+		e_flags |= ENETC_TXBD_E_FLAGS_VLAN_INS;
+
+		/* Write the BD */
+		txbd_tmp.ext.e_flags = e_flags;
+		*txbd = txbd_tmp;
+	}
+}
+
+static int enetc_map_tx_tso_data(struct enetc_bdr *tx_ring, struct sk_buff *skb,
+				 struct enetc_tx_swbd *tx_swbd,
+				 union enetc_tx_bd *txbd, char *data,
+				 int size, bool last_bd)
+{
+	union enetc_tx_bd txbd_tmp;
+	dma_addr_t addr;
+	u8 flags = 0;
+
+	enetc_clear_tx_bd(&txbd_tmp);
+
+	addr = dma_map_single(tx_ring->dev, data, size, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(tx_ring->dev, addr))) {
+		netdev_err(tx_ring->ndev, "DMA map error\n");
+		return -ENOMEM;
+	}
+
+	if (last_bd) {
+		flags |= ENETC_TXBD_FLAGS_F;
+		tx_swbd->is_eof = 1;
+	}
+
+	txbd_tmp.addr = cpu_to_le64(addr);
+	txbd_tmp.buf_len = cpu_to_le16(size);
+	txbd_tmp.flags = flags;
+
+	tx_swbd->dma = addr;
+	tx_swbd->len = size;
+	tx_swbd->dir = DMA_TO_DEVICE;
+
+	*txbd = txbd_tmp;
+
+	return 0;
+}
+
+static __wsum enetc_tso_hdr_csum(struct tso_t *tso, struct sk_buff *skb,
+				 char *hdr, int hdr_len, int *l4_hdr_len)
+{
+	char *l4_hdr = hdr + skb_transport_offset(skb);
+	int mac_hdr_len = skb_network_offset(skb);
+
+	if (tso->tlen != sizeof(struct udphdr)) {
+		struct tcphdr *tcph = (struct tcphdr *)(l4_hdr);
+
+		tcph->check = 0;
+	} else {
+		struct udphdr *udph = (struct udphdr *)(l4_hdr);
+
+		udph->check = 0;
+	}
+
+	/* Compute the IP checksum. This is necessary since tso_build_hdr()
+	 * already incremented the IP ID field.
+	 */
+	if (!tso->ipv6) {
+		struct iphdr *iph = (void *)(hdr + mac_hdr_len);
+
+		iph->check = 0;
+		iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
+	}
+
+	/* Compute the checksum over the L4 header. */
+	*l4_hdr_len = hdr_len - skb_transport_offset(skb);
+	return csum_partial(l4_hdr, *l4_hdr_len, 0);
+}
+
+static void enetc_tso_complete_csum(struct enetc_bdr *tx_ring, struct tso_t *tso,
+				    struct sk_buff *skb, char *hdr, int len,
+				    __wsum sum)
+{
+	char *l4_hdr = hdr + skb_transport_offset(skb);
+	__sum16 csum_final;
+
+	/* Complete the L4 checksum by appending the pseudo-header to the
+	 * already computed checksum.
+	 */
+	if (!tso->ipv6)
+		csum_final = csum_tcpudp_magic(ip_hdr(skb)->saddr,
+					       ip_hdr(skb)->daddr,
+					       len, ip_hdr(skb)->protocol, sum);
+	else
+		csum_final = csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
+					     &ipv6_hdr(skb)->daddr,
+					     len, ipv6_hdr(skb)->nexthdr, sum);
+
+	if (tso->tlen != sizeof(struct udphdr)) {
+		struct tcphdr *tcph = (struct tcphdr *)(l4_hdr);
+
+		tcph->check = csum_final;
+	} else {
+		struct udphdr *udph = (struct udphdr *)(l4_hdr);
+
+		udph->check = csum_final;
+	}
+}
+
+static int enetc_map_tx_tso_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb)
+{
+	int hdr_len, total_len, data_len;
+	struct enetc_tx_swbd *tx_swbd;
+	union enetc_tx_bd *txbd;
+	struct tso_t tso;
+	__wsum csum, csum2;
+	int count = 0, pos;
+	int err, i, bd_data_num;
+
+	/* Initialize the TSO handler, and prepare the first payload */
+	hdr_len = tso_start(skb, &tso);
+	total_len = skb->len - hdr_len;
+	i = tx_ring->next_to_use;
+
+	while (total_len > 0) {
+		char *hdr;
+
+		/* Get the BD */
+		txbd = ENETC_TXBD(*tx_ring, i);
+		tx_swbd = &tx_ring->tx_swbd[i];
+		prefetchw(txbd);
+
+		/* Determine the length of this packet */
+		data_len = min_t(int, skb_shinfo(skb)->gso_size, total_len);
+		total_len -= data_len;
+
+		/* prepare packet headers: MAC + IP + TCP */
+		hdr = tx_ring->tso_headers + i * TSO_HEADER_SIZE;
+		tso_build_hdr(skb, hdr, &tso, data_len, total_len == 0);
+
+		/* compute the csum over the L4 header */
+		csum = enetc_tso_hdr_csum(&tso, skb, hdr, hdr_len, &pos);
+		enetc_map_tx_tso_hdr(tx_ring, skb, tx_swbd, txbd, &i, hdr_len, data_len);
+		bd_data_num = 0;
+		count++;
+
+		while (data_len > 0) {
+			int size;
+
+			size = min_t(int, tso.size, data_len);
+
+			/* Advance the index in the BDR */
+			enetc_bdr_idx_inc(tx_ring, &i);
+			txbd = ENETC_TXBD(*tx_ring, i);
+			tx_swbd = &tx_ring->tx_swbd[i];
+			prefetchw(txbd);
+
+			/* Compute the checksum over this segment of data and
+			 * add it to the csum already computed (over the L4
+			 * header and possible other data segments).
+			 */
+			csum2 = csum_partial(tso.data, size, 0);
+			csum = csum_block_add(csum, csum2, pos);
+			pos += size;
+
+			err = enetc_map_tx_tso_data(tx_ring, skb, tx_swbd, txbd,
+						    tso.data, size,
+						    size == data_len);
+			if (err)
+				goto err_map_data;
+
+			data_len -= size;
+			count++;
+			bd_data_num++;
+			tso_build_data(skb, &tso, size);
+
+			if (unlikely(bd_data_num >= ENETC_MAX_SKB_FRAGS && data_len))
+				goto err_chained_bd;
+		}
+
+		enetc_tso_complete_csum(tx_ring, &tso, skb, hdr, pos, csum);
+
+		if (total_len == 0)
+			tx_swbd->skb = skb;
+
+		/* Go to the next BD */
+		enetc_bdr_idx_inc(tx_ring, &i);
+	}
+
+	tx_ring->next_to_use = i;
+	enetc_update_tx_ring_tail(tx_ring);
+
+	return count;
+
+err_map_data:
+	dev_err(tx_ring->dev, "DMA map error");
+
+err_chained_bd:
+	do {
+		tx_swbd = &tx_ring->tx_swbd[i];
+		enetc_free_tx_frame(tx_ring, tx_swbd);
+		if (i == 0)
+			i = tx_ring->bd_count;
+		i--;
+	} while (count--);
+
+	return 0;
+}
+
 static netdev_tx_t enetc_start_xmit(struct sk_buff *skb,
 				    struct net_device *ndev)
 {
@@ -332,26 +582,36 @@ static netdev_tx_t enetc_start_xmit(struct sk_buff *skb,
 
 	tx_ring = priv->tx_ring[skb->queue_mapping];
 
-	if (unlikely(skb_shinfo(skb)->nr_frags > ENETC_MAX_SKB_FRAGS))
-		if (unlikely(skb_linearize(skb)))
-			goto drop_packet_err;
+	if (skb_is_gso(skb)) {
+		if (enetc_bd_unused(tx_ring) < tso_count_descs(skb)) {
+			netif_stop_subqueue(ndev, tx_ring->index);
+			return NETDEV_TX_BUSY;
+		}
 
-	count = skb_shinfo(skb)->nr_frags + 1; /* fragments + head */
-	if (enetc_bd_unused(tx_ring) < ENETC_TXBDS_NEEDED(count)) {
-		netif_stop_subqueue(ndev, tx_ring->index);
-		return NETDEV_TX_BUSY;
-	}
+		enetc_lock_mdio();
+		count = enetc_map_tx_tso_buffs(tx_ring, skb);
+		enetc_unlock_mdio();
+	} else {
+		if (unlikely(skb_shinfo(skb)->nr_frags > ENETC_MAX_SKB_FRAGS))
+			if (unlikely(skb_linearize(skb)))
+				goto drop_packet_err;
+
+		count = skb_shinfo(skb)->nr_frags + 1; /* fragments + head */
+		if (enetc_bd_unused(tx_ring) < ENETC_TXBDS_NEEDED(count)) {
+			netif_stop_subqueue(ndev, tx_ring->index);
+			return NETDEV_TX_BUSY;
+		}
 
-	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		err = skb_checksum_help(skb);
-		if (err)
-			goto drop_packet_err;
+		if (skb->ip_summed == CHECKSUM_PARTIAL) {
+			err = skb_checksum_help(skb);
+			if (err)
+				goto drop_packet_err;
+		}
+		enetc_lock_mdio();
+		count = enetc_map_tx_buffs(tx_ring, skb);
+		enetc_unlock_mdio();
 	}
 
-	enetc_lock_mdio();
-	count = enetc_map_tx_buffs(tx_ring, skb);
-	enetc_unlock_mdio();
-
 	if (unlikely(!count))
 		goto drop_packet_err;
 
@@ -1499,15 +1759,30 @@ static int enetc_alloc_txbdr(struct enetc_bdr *txr)
 		return -ENOMEM;
 
 	err = enetc_dma_alloc_bdr(txr, sizeof(union enetc_tx_bd));
-	if (err) {
-		vfree(txr->tx_swbd);
-		return err;
-	}
+	if (err)
+		goto err_alloc_bdr;
+
+	txr->tso_headers = dma_alloc_coherent(txr->dev,
+					      txr->bd_count * TSO_HEADER_SIZE,
+					      &txr->tso_headers_dma,
+					      GFP_KERNEL);
+	if (err)
+		goto err_alloc_tso;
 
 	txr->next_to_clean = 0;
 	txr->next_to_use = 0;
 
 	return 0;
+
+err_alloc_tso:
+	dma_free_coherent(txr->dev, txr->bd_count * sizeof(union enetc_tx_bd),
+			  txr->bd_base, txr->bd_dma_base);
+	txr->bd_base = NULL;
+err_alloc_bdr:
+	vfree(txr->tx_swbd);
+	txr->tx_swbd = NULL;
+
+	return err;
 }
 
 static void enetc_free_txbdr(struct enetc_bdr *txr)
@@ -1519,6 +1794,10 @@ static void enetc_free_txbdr(struct enetc_bdr *txr)
 
 	size = txr->bd_count * sizeof(union enetc_tx_bd);
 
+	dma_free_coherent(txr->dev, txr->bd_count * TSO_HEADER_SIZE,
+			  txr->tso_headers, txr->tso_headers_dma);
+	txr->tso_headers = NULL;
+
 	dma_free_coherent(txr->dev, size, txr->bd_base, txr->bd_dma_base);
 	txr->bd_base = NULL;
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 08b283347d9c..fb39e406b7fc 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -112,6 +112,10 @@ struct enetc_bdr {
 	dma_addr_t bd_dma_base;
 	u8 tsd_enable; /* Time specific departure */
 	bool ext_en; /* enable h/w descriptor extensions */
+
+	/* DMA buffer for TSO headers */
+	char *tso_headers;
+	dma_addr_t tso_headers_dma;
 } ____cacheline_aligned_in_smp;
 
 static inline void enetc_bdr_idx_inc(struct enetc_bdr *bdr, int *i)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 1e3b2e191562..8281dd664f4e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -760,11 +760,13 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	ndev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
 			    NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
 			    NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_LOOPBACK |
-			    NETIF_F_HW_CSUM;
+			    NETIF_F_HW_CSUM | NETIF_F_TSO | NETIF_F_TSO6;
 	ndev->features = NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
 			 NETIF_F_HW_VLAN_CTAG_TX |
 			 NETIF_F_HW_VLAN_CTAG_RX |
-			 NETIF_F_HW_CSUM;
+			 NETIF_F_HW_CSUM | NETIF_F_TSO | NETIF_F_TSO6;
+	ndev->vlan_features = NETIF_F_SG | NETIF_F_HW_CSUM |
+			      NETIF_F_TSO | NETIF_F_TSO6;
 
 	if (si->num_rss)
 		ndev->hw_features |= NETIF_F_RXHASH;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index f2a0c0f9fe1d..df312c9f8243 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -123,11 +123,13 @@ static void enetc_vf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	ndev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
 			    NETIF_F_HW_VLAN_CTAG_TX |
 			    NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_CSUM;
+			    NETIF_F_HW_CSUM | NETIF_F_TSO | NETIF_F_TSO6;
 	ndev->features = NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
 			 NETIF_F_HW_VLAN_CTAG_TX |
 			 NETIF_F_HW_VLAN_CTAG_RX |
-			 NETIF_F_HW_CSUM;
+			 NETIF_F_HW_CSUM | NETIF_F_TSO | NETIF_F_TSO6;
+	ndev->vlan_features = NETIF_F_SG | NETIF_F_HW_CSUM |
+			      NETIF_F_TSO | NETIF_F_TSO6;
 
 	if (si->num_rss)
 		ndev->hw_features |= NETIF_F_RXHASH;
-- 
2.31.1

