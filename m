Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00A34247C8
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 22:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239325AbhJFUQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 16:16:09 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:61090
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232147AbhJFUQG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 16:16:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lsJj5myQJeq6XGVJy7gOlLFXlSneIfOlOlIoFxz/6c023vTbg5CiKmddNpGcctvJgIYBFoT+Rq9ces9g4PLl0fSH77jCwzGPSPf00Kjz5IdBgkHorXN8yp2PTogK5gYPA0TITSXnm20+jlAo3JFI5vve3QlzbtN1hmXrufzrmsc6oxxGbZFg9siV0YWAjGyKwR0nxGSDWFD4WVLxB/81+ZzYASOILsNENiHe7RrAsYIb+29f6o3P1sBqRv4fh49JJWQtRQ8/jfHxzlRPC22Lmw8N/k5atnSAVEeIb7AGTBzV+kslXeVACMH1R5/TzLulyeY5NeSCUcIH6rS133GrAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n9Z1RhzQ591tjChtmGSJSfyQiOvM1pOt4I1SFEVUNm4=;
 b=T/YvTMyhAgAx2pu/OHAjMLU1avE7LX37PmPnu9Xm0e+v1zaAB3HBLcTGvw8KroGiytmyp5/dCX4YoTfba+e2c0RWCAuDJn1dtsR1Xuu6XEtb3yM9A+3qN4iI4ofwuaPdTtv2779KxK8yRoDBDRK5hfkP6hxFMzxmSgYvc6H+WBhLGoSoOqnJvu/ZfRaZ9MdON95x/m5rlliKhdFr7seEtZ3VPDPTpyEd7g37ziNxltg0RS13m/SqIqkb8usrzNnEV9Kb0Di5CQcRnWZ4gfxZgGCxHvAEGhVDMUiqKxS0oXMVhnE8EYNcUADFjgoTsKhwtqQbp8kAD5uPilbHuf9TDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9Z1RhzQ591tjChtmGSJSfyQiOvM1pOt4I1SFEVUNm4=;
 b=g/ecgNnusZcDxZS7ekeDocWD3YLn5hVW8FJ8QxIA6Smq7Kh9pJ80WshH2aoQbbHgZoQ4rw83ImAqcZUMjqZVe5IemAFIHlqKhBH2DrBy4mR55VmBOnb7/5l9dIg3vCd0oiOnaXSK/rzrhVPjM8tKG9D83aedshhit2LJhtbXgUo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM8PR04MB7297.eurprd04.prod.outlook.com
 (2603:10a6:20b:1c5::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 6 Oct
 2021 20:14:12 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4566.022; Wed, 6 Oct 2021
 20:14:12 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/2] net: enetc: add support for software TSO
Date:   Wed,  6 Oct 2021 23:13:08 +0300
Message-Id: <20211006201308.2492890-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211006201308.2492890-1-ioana.ciornei@nxp.com>
References: <20211006201308.2492890-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P250CA0015.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::20) To AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13)
MIME-Version: 1.0
Received: from yoga-910.localhost (188.26.53.217) by AM9P250CA0015.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:21c::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Wed, 6 Oct 2021 20:14:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7d3b41d-529c-4239-4f0a-08d98905dcf0
X-MS-TrafficTypeDiagnostic: AM8PR04MB7297:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB729706AC3A22B3791C2E68A9E0B09@AM8PR04MB7297.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:660;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sGJ5z3h93sCIdG6mvZfWlvcPSyRP+2zFYrSyKm9PNFQ/+Dr3QgwT1sxyCSsOv0lVwJ7A4DXqPblx4lWjpo68EuBnOztc9mmDFxv9CoJ7GW5RlgXw/qClh3jM9UTEkO9Pwo6+RL1DWtDWZp/z1IMtzJDdtCgk/H4wp+W1PI6Xad4TxLzoRCaTK3FS/29r2CL/JXoyMgFfVqGyqY4ub6DL9o0lLlMJ5CokNRKcvOkucdWgN5xPX3TbTpmkOnY2ZDmXc0EiRq5bO0PZmkW3winU0cMsokMe0xVi5jblbUo85Sd2t2QHcgOHkjTOVDfFKjFTnlOAu9Vv0muizqyMhUxXGbPR9K58ebKr7pqHdTrQ9X9AhytT19rl27UG1qzZ6ryOyhEJSyWj4+wcTxFJqwLKHr2/3updjCaTlT0ACiw/chbFq2v++Qpp24bB4Gd+fIWgS0AeTZk86Zbq6TjKbV/8vvJQrdxBez9XaWEmHJHB5emE94n4umyTHqLmgbMNWkbJmfUwsLYPzIHkq5UUy5YjHMgeB1LfevXzUPqSWLWMP8C3wsoLr1VjLGYXwTYTl0LRFTZJiZ/CXtuk17YCxBgcXYYRRXjDN5B9m3LPK9cT6uk1G/2WVDVRQPjLDnjpc5kPxRxlV1Y7uDFDLMkePljh8gsSG/jChU7PvtXd/i948eNJWG45AWX2A5zIvJMMPDgmoHnq/s1GO15DNlXDYIVhYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(956004)(66946007)(2616005)(52116002)(83380400001)(4326008)(66476007)(66556008)(316002)(508600001)(186003)(6512007)(26005)(6506007)(2906002)(38350700002)(86362001)(38100700002)(6666004)(44832011)(8676002)(36756003)(30864003)(5660300002)(8936002)(6486002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lu8K/gjNTfZlYEXgF2PZKh5JKeavi/Z0kHf4ut4KC/ZSV+YlWhM4LHB2BHr3?=
 =?us-ascii?Q?DuApDn0j4CikkDqjnu/kkADhQTywONtucfKy3AzBKtkXn01dxhn4m3zqS3rC?=
 =?us-ascii?Q?GrvvwhN+UXYIWptEkk+UwwQuXVoSgzQi7ZKsh/XdK9E7KgBqbiIKixDlw3JM?=
 =?us-ascii?Q?J4dNc2MhTsQ8SalwVjlHExYS8JPG56o44DIS7a2JyoF/Lf9eCoSix6Jk3KJI?=
 =?us-ascii?Q?JSxkLfwQF6mkE1vyGuWHBFSGOMke6JGAwm0+1HgGahp1j6nO5/4QkWPGybwv?=
 =?us-ascii?Q?9oGAx2ZaogOVU0cqMpWekARv4gjAyYvdOriqQmRF7aFxyLWxXfEkfM2dxS+I?=
 =?us-ascii?Q?CvOY9gOn+RL72LibFl7GLgydwJ7tPEYcj8bvbo2WRuIMjhW2PQensBYLru9e?=
 =?us-ascii?Q?PovS0j5ZP8DAicKdnCV7qIUCnrwWCDT8TXL0rsgsg9Yb/Pmpx7C0whloaSQe?=
 =?us-ascii?Q?eiAUzFuUIQyXLtYW83Gos1zHgt/AaE1Qu21/Bfy33YVHve00Dl4fHxU+XV7R?=
 =?us-ascii?Q?5BSkQUZzUmSBq8/X0pUOUCz30lUtBxWpV7ylQZ4O5ohJeWCONvFEllC+za9y?=
 =?us-ascii?Q?K7Ei4bfFma56icwGkz8835DR/jCMdNaOB5LBJotJ69w2UMxHaPioNQ7ALHvK?=
 =?us-ascii?Q?tRwbhldMjma/L/8wRGmOov9G4reFG6ss1DYy+T92/NyfAPPkfCrMazokAqms?=
 =?us-ascii?Q?Nu8N4fVOMa/m4+ygUbeJIMdZndFVyeHMFaE8tcnvWPppbm6E0BMI8fs6dWQO?=
 =?us-ascii?Q?GOAcJys7hS/7HOSZWS+BXJhB1Qc7sEnBZGDv7RJ7ShWBGJlG1SgnddPtiFVz?=
 =?us-ascii?Q?lnvZouPy8arPTFmmIs6U8rAQiKJ9KVlX9WC/3AVUnvIGYYo9Gt+Wj79vdzE1?=
 =?us-ascii?Q?mEquWM9poM1+5DatePy83MZhYIKGdifkSP07ffqcNFvvHbUYOD6kuxvPoSqq?=
 =?us-ascii?Q?c1K+dHWyGQKSDfRp18CxVOfO00moR+KHxwIvLTPm/iTdb/iWKxCTfHbfIIy4?=
 =?us-ascii?Q?ZkFC8S+ysQHuQp9yX8WMU7DnfdfCTAmea13lOJLLLfkJMRz1y2qngE9XD5cl?=
 =?us-ascii?Q?Nn24DIEZU5G4kdBgdJ7CNGfMCxrbUFIMWMItwi+6CgJzFsSxD5jOS14QFk4R?=
 =?us-ascii?Q?c1OBh+bDL3SDQO+LlirhCo6kuwp72Na2+lDdUsRADwEndGqrMDmIP4P+czUz?=
 =?us-ascii?Q?aKOAbJDgdaUBinvOyF+dlPvKE/Ny+k3v57Six1X77bDtCDpzGhGTd5bwaErp?=
 =?us-ascii?Q?rxnwz4jE2yaKkez7zObdrXWC8cj7yBJd2sIThMq+BWtEJ7gco16J6Zpz0fpA?=
 =?us-ascii?Q?Kreduvazrhu8reQDWBJiAIOT?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d3b41d-529c-4239-4f0a-08d98905dcf0
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 20:14:12.6293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9nMwMstU/CriAR7y5w3TVzty4qovN2KvdlGekHEKgLs4K5mbWlK8OSvm3GvKd4veQ57OEqK2bRr6ieEmlOl6cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7297
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
 drivers/net/ethernet/freescale/enetc/enetc.c  | 276 +++++++++++++++++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   4 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   5 +-
 .../net/ethernet/freescale/enetc/enetc_vf.c   |   5 +-
 4 files changed, 274 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index a92bfd660f22..7a8e920725de 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -8,6 +8,7 @@
 #include <linux/vmalloc.h>
 #include <linux/ptp_classify.h>
 #include <net/pkt_sched.h>
+#include <net/tso.h>
 
 static int enetc_num_stack_tx_queues(struct enetc_ndev_priv *priv)
 {
@@ -314,6 +315,235 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb)
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
+__wsum enetc_tso_hdr_csum(struct tso_t *tso, struct sk_buff *skb, char *hdr,
+			  int hdr_len, int *l4_hdr_len)
+{
+	int mac_hdr_len = skb_network_offset(skb);
+	struct iphdr *iph = (void *)(hdr + mac_hdr_len);
+	struct tcphdr *tcph;
+	struct udphdr *udph;
+
+	if (tso->tlen == sizeof(struct udphdr)) {
+		udph = (struct udphdr *)(hdr + skb_transport_offset(skb));
+		udph->check = 0;
+	} else {
+		tcph = (struct tcphdr *)(hdr + skb_transport_offset(skb));
+		tcph->check = 0;
+	}
+
+	/* Compute the IP checksum. This is necessary since tso_build_hdr()
+	 * already incremented the IP ID field.
+	 */
+	iph->check = 0;
+	iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
+
+	/* Compute the checksum over the L4 header. */
+	*l4_hdr_len = hdr_len - skb_transport_offset(skb);
+	return csum_partial((char *)tcph, *l4_hdr_len, 0);
+}
+
+void enetc_tso_complete_csum(struct enetc_bdr *tx_ring, struct tso_t *tso, struct sk_buff *skb,
+			     char *hdr, int len, __wsum sum)
+{
+	struct tcphdr *tcph;
+
+	/* Complete the L4 checksum by appending the pseudo-header to the
+	 * already computed checksum.
+	 */
+	tcph = (struct tcphdr *)(hdr + skb_transport_offset(skb));
+	tcph->check = csum_tcpudp_magic(ip_hdr(skb)->saddr, ip_hdr(skb)->daddr,
+					len, ip_hdr(skb)->protocol, sum);
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
+	int err, i;
+
+	/* Check that we have enough BDs for this skb */
+	if (enetc_bd_unused(tx_ring) < tso_count_descs(skb)) {
+		if (net_ratelimit())
+			netdev_err(tx_ring->ndev, "Not enough BDs for TSO!\n");
+		return 0;
+	}
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
+			tso_build_data(skb, &tso, size);
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
@@ -342,14 +572,17 @@ static netdev_tx_t enetc_start_xmit(struct sk_buff *skb,
 		return NETDEV_TX_BUSY;
 	}
 
-	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		err = skb_csum_hwoffload_help(skb, 0);
-		if (err)
-			goto drop_packet_err;
-	}
-
 	enetc_lock_mdio();
-	count = enetc_map_tx_buffs(tx_ring, skb);
+	if (skb_is_gso(skb)) {
+		count = enetc_map_tx_tso_buffs(tx_ring, skb);
+	} else {
+		if (skb->ip_summed == CHECKSUM_PARTIAL) {
+			err = skb_csum_hwoffload_help(skb, 0);
+			if (err)
+				goto drop_packet_err;
+		}
+		count = enetc_map_tx_buffs(tx_ring, skb);
+	}
 	enetc_unlock_mdio();
 
 	if (unlikely(!count))
@@ -573,7 +806,7 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 		if (xdp_frame) {
 			xdp_return_frame(xdp_frame);
 		} else if (skb) {
-			if (unlikely(tx_swbd->skb->cb[0] &
+			if (unlikely(skb->cb[0] &
 				     ENETC_F_TX_ONESTEP_SYNC_TSTAMP)) {
 				/* Start work to release lock for next one-step
 				 * timestamping packet. And send one skb in
@@ -1499,15 +1732,30 @@ static int enetc_alloc_txbdr(struct enetc_bdr *txr)
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
@@ -1519,6 +1767,10 @@ static void enetc_free_txbdr(struct enetc_bdr *txr)
 
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
index 7ac276f8ee4f..024b610753f2 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -760,11 +760,12 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	ndev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
 			    NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
 			    NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_LOOPBACK |
-			    NETIF_F_IP_CSUM;
+			    NETIF_F_IP_CSUM | NETIF_F_TSO;
 	ndev->features = NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
 			 NETIF_F_HW_VLAN_CTAG_TX |
 			 NETIF_F_HW_VLAN_CTAG_RX |
-			 NETIF_F_IP_CSUM;
+			 NETIF_F_IP_CSUM | NETIF_F_TSO;
+	ndev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO;
 
 	if (si->num_rss)
 		ndev->hw_features |= NETIF_F_RXHASH;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 2166a436f818..b37a894f139c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -123,11 +123,12 @@ static void enetc_vf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	ndev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
 			    NETIF_F_HW_VLAN_CTAG_TX |
 			    NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_IP_CSUM;
+			    NETIF_F_IP_CSUM | NETIF_F_TSO;
 	ndev->features = NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
 			 NETIF_F_HW_VLAN_CTAG_TX |
 			 NETIF_F_HW_VLAN_CTAG_RX |
-			 NETIF_F_IP_CSUM;
+			 NETIF_F_IP_CSUM | NETIF_F_TSO;
+	ndev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO;
 
 	if (si->num_rss)
 		ndev->hw_features |= NETIF_F_RXHASH;
-- 
2.31.1

