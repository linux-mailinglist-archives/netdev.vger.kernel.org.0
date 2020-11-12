Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5842B0C98
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgKLS0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:26:38 -0500
Received: from mail-db8eur05on2047.outbound.protection.outlook.com ([40.107.20.47]:14881
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726631AbgKLS0g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 13:26:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmbRysXC/cbUDmkgy8keRqBD+8zbh3x6PmhhE1+cXEpNeP/LMWZAKlRva3i/vVS6b2ksI4yeXb7shixC/t/ST/Cb6b4Vzb+NvUcSnxTgxbM+PBwfb6PsDdEG80vgcppIO/OVL/PEat/PpcmRKU5PbTk8LJOYF3PBNdPBBG4RQ+tkARKB8PS0bEHy4UDEUJnGi6lK88JZkJpJWLJhk7yYkeJDUFldu4FW7SeQwf2Zhp+Qy3oRSBo2nJjAz6K77yFuah69bXF0R+wEqFs0vJ6iCJik/xiy2VP9TXDG+x5uW+m/AjVK9y0qk8bD4DGTAZQW4FoGr5noogvbYZPKBzZ/wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gx6ZZl1pQesD5zXEZ1Th6wxk3tD4znmByOJHT6sZ9Ww=;
 b=i6xyFPTrfKsQaph9L6wkrF4f34cx5bHc+Ju60j6J4acHoumcCRdZiuC9TnZHXENEeVNS2B6+b01v+OzNo4uj16XAIXcoN+0FfnIytXSsvyA96lofyQQsiPogHxmInPUlk+ZPhvl8I+5S0xow3h30P7ACls0RjU4EUhXFqRPvCu5MFR91Od6Vuhe65gQgvYEwKAP8wBIgqzqHDd5MYImCG+9R9hYtWYn8orfU4inwlEpFqwEEhgHTI7VHE/WmIo+5yN2T1lWgo9kO7Tl7fIvEaiVqq6CK7dnkbpytqlLKWfFRIhvcpGKgxSrK4zCopjR8e0pCLEWrarE2SNe5IpSdyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gx6ZZl1pQesD5zXEZ1Th6wxk3tD4znmByOJHT6sZ9Ww=;
 b=CyzzdcpdgL61c6VHb/6ooTTf0rELgF7nRYryFEbRqUyQ9mx/dh8EXg07A4apuUqeTI13AO/mQYxa4ZdSytBiH5c/qdEVthEK53BOBXIy1LU5IADeL/rDxaJkrZcimg2RXUnd4zRl5VQrdd1aygOe/L9h7AUBxaD5V0LBSLCxOK4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB5746.eurprd04.prod.outlook.com (2603:10a6:208:131::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.23; Thu, 12 Nov
 2020 18:26:31 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3541.025; Thu, 12 Nov 2020
 18:26:31 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net] enetc: Workaround for MDIO register access issue
Date:   Thu, 12 Nov 2020 20:26:08 +0200
Message-Id: <20201112182608.26177-1-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM3PR07CA0120.eurprd07.prod.outlook.com
 (2603:10a6:207:7::30) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM3PR07CA0120.eurprd07.prod.outlook.com (2603:10a6:207:7::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.21 via Frontend Transport; Thu, 12 Nov 2020 18:26:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0ed1cfec-7e1e-4c2f-d2e9-08d887387a31
X-MS-TrafficTypeDiagnostic: AM0PR04MB5746:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5746620F2354990AEF2AE33396E70@AM0PR04MB5746.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:541;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OJbEIuBo0ddgjAc7qmrr9IcgCs/o650wvnbtIa3T34rkeCnIJF7GK1T+DHJ7lnZoC+gp7D/YFzlFuCaG0D+q9cWnZrUyh+SJPI6b2E0jUn4ByD8hfpD6MQD+rqbnJs0PorfynQw6Qz04I3Po7Ru3xCcNkUibsJplgf/5HqfETPYQxz6yFhNhyVmKGhMON7LSWvHbmuz3gUcR5DkLlPL2GFFHiODmcISWxceRnOyAykJG3Wx7PpAu6r0kbRU4agt21TYY40LoKQ0WBRCHZ1Qbm5NG0ks8zuFkA3PUYuDaeRwK7o69sRag5IaNChT8EqV28UN4bx2wrW6FapRlE24Gng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(6486002)(86362001)(52116002)(6666004)(54906003)(8936002)(83380400001)(6916009)(1076003)(7696005)(2906002)(5660300002)(316002)(44832011)(8676002)(956004)(36756003)(2616005)(30864003)(186003)(66476007)(4326008)(66556008)(16526019)(26005)(478600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0ryb8l6zLtFUcX/XBLeMT/+51UFTf34wYbAxmT0TqH4XCEyTB3XNzhnwzHc8dK6QSYZ/WRzIFQpgnNwMVGREtew8l8OwP/h9mTx4929dw81QXGmIe7JQzI4wUwyvqFFFlbrnLDyKz98NL0LuFKFYqB8E3FweRNUXA8Ej86Fj1ArIZUIN6oJqa12e1QfLh2b+htjt3fyagGOQQcNWMAUFsirBqG/sSWLE/ELgSLq0MCBD98BR/ozKs3PWU//mEV8F2+4ZpPT2jR9MHIFlo/tNqj+g9RR6ewAcD7EYcLZNjNKmeu9M89Ni9LH88kFKaI4+U48+uV9azkEKNYwt7l0W/vqs6em98UpXBFm5nX09qMpj9N3aBP+2Zf2aWyIqEb2LZijpMN+vB1qsXEiiJLpkcSujnkWsEuvCuvqsbtljes1h/dFf4UuBDmtBGNw32ajP9R41edEGGSy9gUTm7nitqSefeSK6z42IuOMgwge2n7GXU6Tp6zHQ35PSm2MGcmo5RX36zEg7qKhLsofkUTzEDGTefcO6eDYLpI0sBtKc12njsdIO5IW5Q3Ms6XJLzFRADJsIeK48vQqWsNTRQo11gTV4rbIg+ezCmElb7Rd5qu2oYZZgBQ9YOAyMMDInUZUCbQKINPqXhWpKoy9B6s+ZTQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed1cfec-7e1e-4c2f-d2e9-08d887387a31
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2020 18:26:31.3577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f8/QiLaC5Vk7BAdicsv8Tlgk5BSTg7P0hteCCTFnkPIpHCmm9Y1YSByI5FRM4EWZJV8f/mEiibTrPVQU0xzu8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5746
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Marginean <alexandru.marginean@nxp.com>

Due to a hardware issue, an access to MDIO registers
that is concurrent with other ENETC register accesses
may lead to the MDIO access being dropped or corrupted.
The workaround introduces locking for all register accesses
to the ENETC register space.  To reduce performance impact,
a readers-writers locking scheme has been implemented.
The writer in this case is the MDIO access code (irrelevant
whether that MDIO access is a register read or write), and
the reader is any access code to non-MDIO ENETC registers.
Also, the datapath functions acquire the read lock fewer times
and use _hot accessors.  All the rest of the code uses the _wa
accessors which lock every register access.
The commit introducing MDIO support is -
commit ebfcb23d62ab ("enetc: Add ENETC PF level external MDIO support")
but due to subsequent refactoring this patch is applicable on
top of a later commit.

Fixes: 6517798dd343 ("enetc: Make MDIO accessors more generic and export to include/linux/fsl")

Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
v0: since initial "RFC" sent on net-next:
    - cleaned up w/a accessors, added comments in the code,
    lockdep checks, minor fixes
    - can be backported to 5.9 w/ trivial conflict in Kconfig

 drivers/net/ethernet/freescale/enetc/Kconfig  |   1 +
 drivers/net/ethernet/freescale/enetc/enetc.c  |  62 +++++++---
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 115 +++++++++++++++++-
 .../net/ethernet/freescale/enetc/enetc_mdio.c |   8 +-
 4 files changed, 161 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index 0fa18b00c49b..d99ea0f4e4a6 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -16,6 +16,7 @@ config FSL_ENETC
 config FSL_ENETC_VF
 	tristate "ENETC VF driver"
 	depends on PCI && PCI_MSI
+	select FSL_ENETC_MDIO
 	select PHYLINK
 	select DIMLIB
 	help
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 52be6e315752..fc2075ea57fe 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -33,7 +33,10 @@ netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev)
 		return NETDEV_TX_BUSY;
 	}
 
+	enetc_lock_mdio();
 	count = enetc_map_tx_buffs(tx_ring, skb, priv->active_offloads);
+	enetc_unlock_mdio();
+
 	if (unlikely(!count))
 		goto drop_packet_err;
 
@@ -239,7 +242,7 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb,
 	skb_tx_timestamp(skb);
 
 	/* let H/W know BD ring has been updated */
-	enetc_wr_reg(tx_ring->tpir, i); /* includes wmb() */
+	enetc_wr_reg_hot(tx_ring->tpir, i); /* includes wmb() */
 
 	return count;
 
@@ -262,12 +265,16 @@ static irqreturn_t enetc_msix(int irq, void *data)
 	struct enetc_int_vector	*v = data;
 	int i;
 
+	enetc_lock_mdio();
+
 	/* disable interrupts */
-	enetc_wr_reg(v->rbier, 0);
-	enetc_wr_reg(v->ricr1, v->rx_ictt);
+	enetc_wr_reg_hot(v->rbier, 0);
+	enetc_wr_reg_hot(v->ricr1, v->rx_ictt);
 
 	for_each_set_bit(i, &v->tx_rings_map, ENETC_MAX_NUM_TXQS)
-		enetc_wr_reg(v->tbier_base + ENETC_BDR_OFF(i), 0);
+		enetc_wr_reg_hot(v->tbier_base + ENETC_BDR_OFF(i), 0);
+
+	enetc_unlock_mdio();
 
 	napi_schedule(&v->napi);
 
@@ -334,19 +341,23 @@ static int enetc_poll(struct napi_struct *napi, int budget)
 
 	v->rx_napi_work = false;
 
+	enetc_lock_mdio();
+
 	/* enable interrupts */
-	enetc_wr_reg(v->rbier, ENETC_RBIER_RXTIE);
+	enetc_wr_reg_hot(v->rbier, ENETC_RBIER_RXTIE);
 
 	for_each_set_bit(i, &v->tx_rings_map, ENETC_MAX_NUM_TXQS)
-		enetc_wr_reg(v->tbier_base + ENETC_BDR_OFF(i),
-			     ENETC_TBIER_TXTIE);
+		enetc_wr_reg_hot(v->tbier_base + ENETC_BDR_OFF(i),
+				 ENETC_TBIER_TXTIE);
+
+	enetc_unlock_mdio();
 
 	return work_done;
 }
 
 static int enetc_bd_ready_count(struct enetc_bdr *tx_ring, int ci)
 {
-	int pi = enetc_rd_reg(tx_ring->tcir) & ENETC_TBCIR_IDX_MASK;
+	int pi = enetc_rd_reg_hot(tx_ring->tcir) & ENETC_TBCIR_IDX_MASK;
 
 	return pi >= ci ? pi - ci : tx_ring->bd_count - ci + pi;
 }
@@ -386,7 +397,10 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 
 	i = tx_ring->next_to_clean;
 	tx_swbd = &tx_ring->tx_swbd[i];
+
+	enetc_lock_mdio();
 	bds_to_clean = enetc_bd_ready_count(tx_ring, i);
+	enetc_unlock_mdio();
 
 	do_tstamp = false;
 
@@ -429,16 +443,20 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 			tx_swbd = tx_ring->tx_swbd;
 		}
 
+		enetc_lock_mdio();
+
 		/* BD iteration loop end */
 		if (is_eof) {
 			tx_frm_cnt++;
 			/* re-arm interrupt source */
-			enetc_wr_reg(tx_ring->idr, BIT(tx_ring->index) |
-				     BIT(16 + tx_ring->index));
+			enetc_wr_reg_hot(tx_ring->idr, BIT(tx_ring->index) |
+					 BIT(16 + tx_ring->index));
 		}
 
 		if (unlikely(!bds_to_clean))
 			bds_to_clean = enetc_bd_ready_count(tx_ring, i);
+
+		enetc_unlock_mdio();
 	}
 
 	tx_ring->next_to_clean = i;
@@ -515,8 +533,6 @@ static int enetc_refill_rx_ring(struct enetc_bdr *rx_ring, const int buff_cnt)
 	if (likely(j)) {
 		rx_ring->next_to_alloc = i; /* keep track from page reuse */
 		rx_ring->next_to_use = i;
-		/* update ENETC's consumer index */
-		enetc_wr_reg(rx_ring->rcir, i);
 	}
 
 	return j;
@@ -534,8 +550,8 @@ static void enetc_get_rx_tstamp(struct net_device *ndev,
 	u64 tstamp;
 
 	if (le16_to_cpu(rxbd->r.flags) & ENETC_RXBD_FLAG_TSTMP) {
-		lo = enetc_rd(hw, ENETC_SICTR0);
-		hi = enetc_rd(hw, ENETC_SICTR1);
+		lo = enetc_rd_reg_hot(hw->reg + ENETC_SICTR0);
+		hi = enetc_rd_reg_hot(hw->reg + ENETC_SICTR1);
 		rxbd = enetc_rxbd_ext(rxbd);
 		tstamp_lo = le32_to_cpu(rxbd->ext.tstamp);
 		if (lo <= tstamp_lo)
@@ -684,23 +700,31 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 		u32 bd_status;
 		u16 size;
 
+		enetc_lock_mdio();
+
 		if (cleaned_cnt >= ENETC_RXBD_BUNDLE) {
 			int count = enetc_refill_rx_ring(rx_ring, cleaned_cnt);
 
+			/* update ENETC's consumer index */
+			enetc_wr_reg_hot(rx_ring->rcir, rx_ring->next_to_use);
 			cleaned_cnt -= count;
 		}
 
 		rxbd = enetc_rxbd(rx_ring, i);
 		bd_status = le32_to_cpu(rxbd->r.lstatus);
-		if (!bd_status)
+		if (!bd_status) {
+			enetc_unlock_mdio();
 			break;
+		}
 
-		enetc_wr_reg(rx_ring->idr, BIT(rx_ring->index));
+		enetc_wr_reg_hot(rx_ring->idr, BIT(rx_ring->index));
 		dma_rmb(); /* for reading other rxbd fields */
 		size = le16_to_cpu(rxbd->r.buf_len);
 		skb = enetc_map_rx_buff_to_skb(rx_ring, i, size);
-		if (!skb)
+		if (!skb) {
+			enetc_unlock_mdio();
 			break;
+		}
 
 		enetc_get_offloads(rx_ring, rxbd, skb);
 
@@ -712,6 +736,7 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 
 		if (unlikely(bd_status &
 			     ENETC_RXBD_LSTATUS(ENETC_RXBD_ERR_MASK))) {
+			enetc_unlock_mdio();
 			dev_kfree_skb(skb);
 			while (!(bd_status & ENETC_RXBD_LSTATUS_F)) {
 				dma_rmb();
@@ -751,6 +776,8 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 
 		enetc_process_skb(rx_ring, skb);
 
+		enetc_unlock_mdio();
+
 		napi_gro_receive(napi, skb);
 
 		rx_frm_cnt++;
@@ -1225,6 +1252,7 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 	rx_ring->idr = hw->reg + ENETC_SIRXIDR;
 
 	enetc_refill_rx_ring(rx_ring, enetc_bd_unused(rx_ring));
+	enetc_wr(hw, ENETC_SIRXIDR, rx_ring->next_to_use);
 
 	/* enable ring */
 	enetc_rxbdr_wr(hw, idx, ENETC_RBMR, rbmr);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 17cf7c94fdb5..eb6bbf1113c7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -324,14 +324,100 @@ struct enetc_hw {
 	void __iomem *global;
 };
 
-/* general register accessors */
-#define enetc_rd_reg(reg)	ioread32((reg))
-#define enetc_wr_reg(reg, val)	iowrite32((val), (reg))
+/* ENETC register accessors */
+
+/* MDIO issue workaround (on LS1028A) -
+ * Due to a hardware issue, an access to MDIO registers
+ * that is concurrent with other ENETC register accesses
+ * may lead to the MDIO access being dropped or corrupted.
+ * To protect the MDIO accesses a readers-writers locking
+ * scheme is used, where the MDIO register accesses are
+ * protected by write locks to insure exclusivity, while
+ * the remaining ENETC registers are accessed under read
+ * locks since they only compete with MDIO accesses.
+ */
+extern rwlock_t enetc_mdio_lock;
+
+/* use this locking primitive only on the fast datapath to
+ * group together multiple non-MDIO register accesses to
+ * minimize the overhead of the lock
+ */
+static inline void enetc_lock_mdio(void)
+{
+	read_lock(&enetc_mdio_lock);
+}
+
+static inline void enetc_unlock_mdio(void)
+{
+	read_unlock(&enetc_mdio_lock);
+}
+
+/* use these accessors only on the fast datapath under
+ * the enetc_lock_mdio() locking primitive to minimize
+ * the overhead of the lock
+ */
+static inline u32 enetc_rd_reg_hot(void __iomem *reg)
+{
+	lockdep_assert_held(&enetc_mdio_lock);
+
+	return ioread32(reg);
+}
+
+static inline void enetc_wr_reg_hot(void __iomem *reg, u32 val)
+{
+	lockdep_assert_held(&enetc_mdio_lock);
+
+	iowrite32(val, reg);
+}
+
+/* internal helpers for the MDIO w/a */
+static inline u32 _enetc_rd_reg_wa(void __iomem *reg)
+{
+	u32 val;
+
+	enetc_lock_mdio();
+	val = ioread32(reg);
+	enetc_unlock_mdio();
+
+	return val;
+}
+
+static inline void _enetc_wr_reg_wa(void __iomem *reg, u32 val)
+{
+	enetc_lock_mdio();
+	iowrite32(val, reg);
+	enetc_unlock_mdio();
+}
+
+static inline u32 _enetc_rd_mdio_reg_wa(void __iomem *reg)
+{
+	unsigned long flags;
+	u32 val;
+
+	write_lock_irqsave(&enetc_mdio_lock, flags);
+	val = ioread32(reg);
+	write_unlock_irqrestore(&enetc_mdio_lock, flags);
+
+	return val;
+}
+
+static inline void _enetc_wr_mdio_reg_wa(void __iomem *reg, u32 val)
+{
+	unsigned long flags;
+
+	write_lock_irqsave(&enetc_mdio_lock, flags);
+	iowrite32(val, reg);
+	write_unlock_irqrestore(&enetc_mdio_lock, flags);
+}
+
 #ifdef ioread64
-#define enetc_rd_reg64(reg)	ioread64((reg))
+static inline u64 _enetc_rd_reg64(void __iomem *reg)
+{
+	return ioread64(reg);
+}
 #else
 /* using this to read out stats on 32b systems */
-static inline u64 enetc_rd_reg64(void __iomem *reg)
+static inline u64 _enetc_rd_reg64(void __iomem *reg)
 {
 	u32 low, high, tmp;
 
@@ -345,12 +431,29 @@ static inline u64 enetc_rd_reg64(void __iomem *reg)
 }
 #endif
 
+static inline u64 _enetc_rd_reg64_wa(void __iomem *reg)
+{
+	u64 val;
+
+	enetc_lock_mdio();
+	val = _enetc_rd_reg64(reg);
+	enetc_unlock_mdio();
+
+	return val;
+}
+
+/* general register accessors */
+#define enetc_rd_reg(reg)		_enetc_rd_reg_wa((reg))
+#define enetc_wr_reg(reg, val)		_enetc_wr_reg_wa((reg), (val))
 #define enetc_rd(hw, off)		enetc_rd_reg((hw)->reg + (off))
 #define enetc_wr(hw, off, val)		enetc_wr_reg((hw)->reg + (off), val)
-#define enetc_rd64(hw, off)		enetc_rd_reg64((hw)->reg + (off))
+#define enetc_rd64(hw, off)		_enetc_rd_reg64_wa((hw)->reg + (off))
 /* port register accessors - PF only */
 #define enetc_port_rd(hw, off)		enetc_rd_reg((hw)->port + (off))
 #define enetc_port_wr(hw, off, val)	enetc_wr_reg((hw)->port + (off), val)
+#define enetc_port_rd_mdio(hw, off)	_enetc_rd_mdio_reg_wa((hw)->port + (off))
+#define enetc_port_wr_mdio(hw, off, val)	_enetc_wr_mdio_reg_wa(\
+							(hw)->port + (off), val)
 /* global register accessors - PF only */
 #define enetc_global_rd(hw, off)	enetc_rd_reg((hw)->global + (off))
 #define enetc_global_wr(hw, off, val)	enetc_wr_reg((hw)->global + (off), val)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
index 48c32a171afa..ee0116ed4738 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
@@ -16,13 +16,13 @@
 
 static inline u32 _enetc_mdio_rd(struct enetc_mdio_priv *mdio_priv, int off)
 {
-	return enetc_port_rd(mdio_priv->hw, mdio_priv->mdio_base + off);
+	return enetc_port_rd_mdio(mdio_priv->hw, mdio_priv->mdio_base + off);
 }
 
 static inline void _enetc_mdio_wr(struct enetc_mdio_priv *mdio_priv, int off,
 				  u32 val)
 {
-	enetc_port_wr(mdio_priv->hw, mdio_priv->mdio_base + off, val);
+	enetc_port_wr_mdio(mdio_priv->hw, mdio_priv->mdio_base + off, val);
 }
 
 #define enetc_mdio_rd(mdio_priv, off) \
@@ -174,3 +174,7 @@ struct enetc_hw *enetc_hw_alloc(struct device *dev, void __iomem *port_regs)
 	return hw;
 }
 EXPORT_SYMBOL_GPL(enetc_hw_alloc);
+
+/* Lock for MDIO access errata on LS1028A */
+DEFINE_RWLOCK(enetc_mdio_lock);
+EXPORT_SYMBOL_GPL(enetc_mdio_lock);
-- 
2.17.1

