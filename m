Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8DB6EBE5D
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 11:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjDWJzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 05:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjDWJzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 05:55:41 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C593270E;
        Sun, 23 Apr 2023 02:55:24 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33N6b0Io030485;
        Sun, 23 Apr 2023 02:55:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=2kJ+fvp1U0GA8fNiPeOrVqYJgSX9Lsvvjl1jDaiK8Lw=;
 b=YR3ypzrPC9woXhTzdRZJOX1DLXEj5IBqoqTqKU/yAYnDg3QEUDj+zBRG63L5m39rDCpx
 C0YZZoqeF86b/9isVQ4vdI73HrW5t5hRXn39bfu4t7trK6xOxK+Uzx7CGL86B0kNDCfb
 SBLibP/VP7pMA51WfFmnCKzE3dUabC+B6RoXLkBEeXjfFNfnNEdElgPO3S7NvACJmUs+
 DWjtkfk9/B9yx+jjQMAaJWGwa4Rhz/ck9n3sSZBy/DdpUf2RyT7D8cHBjQIktxLuv57M
 nahL5Yri5Q3NP723vCpAZxSpYcouaPn3K5FHy53uVZHGAdGE+ve+pjtPs2TSMpMgOnN1 9g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3p2pqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Apr 2023 02:55:16 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 23 Apr
 2023 02:55:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 23 Apr 2023 02:55:14 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 043D03F706D;
        Sun, 23 Apr 2023 02:55:10 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 4/9] octeontx2-af: mcs: Fix MCS block interrupt
Date:   Sun, 23 Apr 2023 15:24:49 +0530
Message-ID: <20230423095454.21049-5-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230423095454.21049-1-gakula@marvell.com>
References: <20230423095454.21049-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: wMi6Vce4dzMS6ZBPaquym9VsUe8eZ01u
X-Proofpoint-GUID: wMi6Vce4dzMS6ZBPaquym9VsUe8eZ01u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-23_06,2023-04-21_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On CN10KB, MCS IP vector number, BBE and PAB interrupt mask
got changed to support more block level interrupts.
To address this changes, this patch fixes the bbe and pab
interrupt handlers.

Fixes: 6c635f78c474 ("octeontx2-af: cn10k: mcs: Handle MCS block interrupts")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mcs.c   | 95 ++++++++-----------
 .../net/ethernet/marvell/octeontx2/af/mcs.h   | 26 +++--
 .../marvell/octeontx2/af/mcs_cnf10kb.c        | 63 ++++++++++++
 .../ethernet/marvell/octeontx2/af/mcs_reg.h   |  5 +-
 4 files changed, 119 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
index 148417d633a5..c43f19dfbd74 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -936,60 +936,42 @@ static void mcs_tx_misc_intr_handler(struct mcs *mcs, u64 intr)
 	mcs_add_intr_wq_entry(mcs, &event);
 }
 
-static void mcs_bbe_intr_handler(struct mcs *mcs, u64 intr, enum mcs_direction dir)
+void cn10kb_mcs_bbe_intr_handler(struct mcs *mcs, u64 intr,
+				 enum mcs_direction dir)
 {
-	struct mcs_intr_event event = { 0 };
-	int i;
+	u64 val, reg;
+	int lmac;
 
-	if (!(intr & MCS_BBE_INT_MASK))
+	if (!(intr & 0x6ULL))
 		return;
 
-	event.mcs_id = mcs->mcs_id;
-	event.pcifunc = mcs->pf_map[0];
+	if (intr & BIT_ULL(1))
+		reg = (dir == MCS_RX) ? MCSX_BBE_RX_SLAVE_DFIFO_OVERFLOW_0 :
+					MCSX_BBE_TX_SLAVE_DFIFO_OVERFLOW_0;
+	else
+		reg = (dir == MCS_RX) ? MCSX_BBE_RX_SLAVE_PLFIFO_OVERFLOW_0 :
+					MCSX_BBE_TX_SLAVE_PLFIFO_OVERFLOW_0;
+	val = mcs_reg_read(mcs, reg);
 
-	for (i = 0; i < MCS_MAX_BBE_INT; i++) {
-		if (!(intr & BIT_ULL(i)))
+	/* policy/data over flow occurred */
+	for (lmac = 0; lmac < mcs->hw->lmac_cnt; lmac++) {
+		if (!(val & BIT_ULL(lmac)))
 			continue;
-
-		/* Lower nibble denotes data fifo overflow interrupts and
-		 * upper nibble indicates policy fifo overflow interrupts.
-		 */
-		if (intr & 0xFULL)
-			event.intr_mask = (dir == MCS_RX) ?
-					  MCS_BBE_RX_DFIFO_OVERFLOW_INT :
-					  MCS_BBE_TX_DFIFO_OVERFLOW_INT;
-		else
-			event.intr_mask = (dir == MCS_RX) ?
-					  MCS_BBE_RX_PLFIFO_OVERFLOW_INT :
-					  MCS_BBE_TX_PLFIFO_OVERFLOW_INT;
-
-		/* Notify the lmac_id info which ran into BBE fatal error */
-		event.lmac_id = i & 0x3ULL;
-		mcs_add_intr_wq_entry(mcs, &event);
+		dev_warn(mcs->dev, "BEE:Policy or data overflow occurred on lmac:%d\n", lmac);
 	}
 }
 
-static void mcs_pab_intr_handler(struct mcs *mcs, u64 intr, enum mcs_direction dir)
+void cn10kb_mcs_pab_intr_handler(struct mcs *mcs, u64 intr,
+				 enum mcs_direction dir)
 {
-	struct mcs_intr_event event = { 0 };
-	int i;
+	int lmac;
 
-	if (!(intr & MCS_PAB_INT_MASK))
+	if (!(intr & 0xFFFFFULL))
 		return;
 
-	event.mcs_id = mcs->mcs_id;
-	event.pcifunc = mcs->pf_map[0];
-
-	for (i = 0; i < MCS_MAX_PAB_INT; i++) {
-		if (!(intr & BIT_ULL(i)))
-			continue;
-
-		event.intr_mask = (dir == MCS_RX) ? MCS_PAB_RX_CHAN_OVERFLOW_INT :
-				  MCS_PAB_TX_CHAN_OVERFLOW_INT;
-
-		/* Notify the lmac_id info which ran into PAB fatal error */
-		event.lmac_id = i;
-		mcs_add_intr_wq_entry(mcs, &event);
+	for (lmac = 0; lmac < mcs->hw->lmac_cnt; lmac++) {
+		if (intr & BIT_ULL(lmac))
+			dev_warn(mcs->dev, "PAB: overflow occurred on lmac:%d\n", lmac);
 	}
 }
 
@@ -998,9 +980,8 @@ static irqreturn_t mcs_ip_intr_handler(int irq, void *mcs_irq)
 	struct mcs *mcs = (struct mcs *)mcs_irq;
 	u64 intr, cpm_intr, bbe_intr, pab_intr;
 
-	/* Disable and clear the interrupt */
+	/* Disable  the interrupt */
 	mcs_reg_write(mcs, MCSX_IP_INT_ENA_W1C, BIT_ULL(0));
-	mcs_reg_write(mcs, MCSX_IP_INT, BIT_ULL(0));
 
 	/* Check which block has interrupt*/
 	intr = mcs_reg_read(mcs, MCSX_TOP_SLAVE_INT_SUM);
@@ -1047,7 +1028,7 @@ static irqreturn_t mcs_ip_intr_handler(int irq, void *mcs_irq)
 	/* BBE RX */
 	if (intr & MCS_BBE_RX_INT_ENA) {
 		bbe_intr = mcs_reg_read(mcs, MCSX_BBE_RX_SLAVE_BBE_INT);
-		mcs_bbe_intr_handler(mcs, bbe_intr, MCS_RX);
+		mcs->mcs_ops->mcs_bbe_intr_handler(mcs, bbe_intr, MCS_RX);
 
 		/* Clear the interrupt */
 		mcs_reg_write(mcs, MCSX_BBE_RX_SLAVE_BBE_INT_INTR_RW, 0);
@@ -1057,7 +1038,7 @@ static irqreturn_t mcs_ip_intr_handler(int irq, void *mcs_irq)
 	/* BBE TX */
 	if (intr & MCS_BBE_TX_INT_ENA) {
 		bbe_intr = mcs_reg_read(mcs, MCSX_BBE_TX_SLAVE_BBE_INT);
-		mcs_bbe_intr_handler(mcs, bbe_intr, MCS_TX);
+		mcs->mcs_ops->mcs_bbe_intr_handler(mcs, bbe_intr, MCS_TX);
 
 		/* Clear the interrupt */
 		mcs_reg_write(mcs, MCSX_BBE_TX_SLAVE_BBE_INT_INTR_RW, 0);
@@ -1067,7 +1048,7 @@ static irqreturn_t mcs_ip_intr_handler(int irq, void *mcs_irq)
 	/* PAB RX */
 	if (intr & MCS_PAB_RX_INT_ENA) {
 		pab_intr = mcs_reg_read(mcs, MCSX_PAB_RX_SLAVE_PAB_INT);
-		mcs_pab_intr_handler(mcs, pab_intr, MCS_RX);
+		mcs->mcs_ops->mcs_pab_intr_handler(mcs, pab_intr, MCS_RX);
 
 		/* Clear the interrupt */
 		mcs_reg_write(mcs, MCSX_PAB_RX_SLAVE_PAB_INT_INTR_RW, 0);
@@ -1077,14 +1058,15 @@ static irqreturn_t mcs_ip_intr_handler(int irq, void *mcs_irq)
 	/* PAB TX */
 	if (intr & MCS_PAB_TX_INT_ENA) {
 		pab_intr = mcs_reg_read(mcs, MCSX_PAB_TX_SLAVE_PAB_INT);
-		mcs_pab_intr_handler(mcs, pab_intr, MCS_TX);
+		mcs->mcs_ops->mcs_pab_intr_handler(mcs, pab_intr, MCS_TX);
 
 		/* Clear the interrupt */
 		mcs_reg_write(mcs, MCSX_PAB_TX_SLAVE_PAB_INT_INTR_RW, 0);
 		mcs_reg_write(mcs, MCSX_PAB_TX_SLAVE_PAB_INT, pab_intr);
 	}
 
-	/* Enable the interrupt */
+	/* Clear and enable the interrupt */
+	mcs_reg_write(mcs, MCSX_IP_INT, BIT_ULL(0));
 	mcs_reg_write(mcs, MCSX_IP_INT_ENA_W1S, BIT_ULL(0));
 
 	return IRQ_HANDLED;
@@ -1166,7 +1148,7 @@ static int mcs_register_interrupts(struct mcs *mcs)
 		return ret;
 	}
 
-	ret = request_irq(pci_irq_vector(mcs->pdev, MCS_INT_VEC_IP),
+	ret = request_irq(pci_irq_vector(mcs->pdev, mcs->hw->ip_vec),
 			  mcs_ip_intr_handler, 0, "MCS_IP", mcs);
 	if (ret) {
 		dev_err(mcs->dev, "MCS IP irq registration failed\n");
@@ -1185,11 +1167,11 @@ static int mcs_register_interrupts(struct mcs *mcs)
 	mcs_reg_write(mcs, MCSX_CPM_TX_SLAVE_TX_INT_ENB, 0x7ULL);
 	mcs_reg_write(mcs, MCSX_CPM_RX_SLAVE_RX_INT_ENB, 0x7FULL);
 
-	mcs_reg_write(mcs, MCSX_BBE_RX_SLAVE_BBE_INT_ENB, 0xff);
-	mcs_reg_write(mcs, MCSX_BBE_TX_SLAVE_BBE_INT_ENB, 0xff);
+	mcs_reg_write(mcs, MCSX_BBE_RX_SLAVE_BBE_INT_ENB, 0xFFULL);
+	mcs_reg_write(mcs, MCSX_BBE_TX_SLAVE_BBE_INT_ENB, 0xFFULL);
 
-	mcs_reg_write(mcs, MCSX_PAB_RX_SLAVE_PAB_INT_ENB, 0xff);
-	mcs_reg_write(mcs, MCSX_PAB_TX_SLAVE_PAB_INT_ENB, 0xff);
+	mcs_reg_write(mcs, MCSX_PAB_RX_SLAVE_PAB_INT_ENB, 0xFFFFFULL);
+	mcs_reg_write(mcs, MCSX_PAB_TX_SLAVE_PAB_INT_ENB, 0xFFFFFULL);
 
 	mcs->tx_sa_active = alloc_mem(mcs, mcs->hw->sc_entries);
 	if (!mcs->tx_sa_active) {
@@ -1200,7 +1182,7 @@ static int mcs_register_interrupts(struct mcs *mcs)
 	return ret;
 
 free_irq:
-	free_irq(pci_irq_vector(mcs->pdev, MCS_INT_VEC_IP), mcs);
+	free_irq(pci_irq_vector(mcs->pdev, mcs->hw->ip_vec), mcs);
 exit:
 	pci_free_irq_vectors(mcs->pdev);
 	mcs->num_vec = 0;
@@ -1497,6 +1479,7 @@ void cn10kb_mcs_set_hw_capabilities(struct mcs *mcs)
 	hw->lmac_cnt = 20;		/* lmacs/ports per mcs block */
 	hw->mcs_x2p_intf = 5;		/* x2p clabration intf */
 	hw->mcs_blks = 1;		/* MCS blocks */
+	hw->ip_vec = MCS_CN10KB_INT_VEC_IP; /* IP vector */
 }
 
 static struct mcs_ops cn10kb_mcs_ops = {
@@ -1505,6 +1488,8 @@ static struct mcs_ops cn10kb_mcs_ops = {
 	.mcs_tx_sa_mem_map_write	= cn10kb_mcs_tx_sa_mem_map_write,
 	.mcs_rx_sa_mem_map_write	= cn10kb_mcs_rx_sa_mem_map_write,
 	.mcs_flowid_secy_map		= cn10kb_mcs_flowid_secy_map,
+	.mcs_bbe_intr_handler		= cn10kb_mcs_bbe_intr_handler,
+	.mcs_pab_intr_handler		= cn10kb_mcs_pab_intr_handler,
 };
 
 static int mcs_probe(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -1605,7 +1590,7 @@ static void mcs_remove(struct pci_dev *pdev)
 
 	/* Set MCS to external bypass */
 	mcs_set_external_bypass(mcs, true);
-	free_irq(pci_irq_vector(pdev, MCS_INT_VEC_IP), mcs);
+	free_irq(pci_irq_vector(pdev, mcs->hw->ip_vec), mcs);
 	pci_free_irq_vectors(pdev);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.h b/drivers/net/ethernet/marvell/octeontx2/af/mcs.h
index 64dc2b80e15d..0f89dcb76465 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.h
@@ -43,24 +43,15 @@
 /* Reserved resources for default bypass entry */
 #define MCS_RSRC_RSVD_CNT		1
 
-/* MCS Interrupt Vector Enumeration */
-enum mcs_int_vec_e {
-	MCS_INT_VEC_MIL_RX_GBL		= 0x0,
-	MCS_INT_VEC_MIL_RX_LMACX	= 0x1,
-	MCS_INT_VEC_MIL_TX_LMACX	= 0x5,
-	MCS_INT_VEC_HIL_RX_GBL		= 0x9,
-	MCS_INT_VEC_HIL_RX_LMACX	= 0xa,
-	MCS_INT_VEC_HIL_TX_GBL		= 0xe,
-	MCS_INT_VEC_HIL_TX_LMACX	= 0xf,
-	MCS_INT_VEC_IP			= 0x13,
-	MCS_INT_VEC_CNT			= 0x14,
-};
+/* MCS Interrupt Vector */
+#define MCS_CNF10KB_INT_VEC_IP	0x13
+#define MCS_CN10KB_INT_VEC_IP	0x53
 
 #define MCS_MAX_BBE_INT			8ULL
 #define MCS_BBE_INT_MASK		0xFFULL
 
-#define MCS_MAX_PAB_INT			4ULL
-#define MCS_PAB_INT_MASK		0xFULL
+#define MCS_MAX_PAB_INT		8ULL
+#define MCS_PAB_INT_MASK	0xFULL
 
 #define MCS_BBE_RX_INT_ENA		BIT_ULL(0)
 #define MCS_BBE_TX_INT_ENA		BIT_ULL(1)
@@ -137,6 +128,7 @@ struct hwinfo {
 	u8 lmac_cnt;
 	u8 mcs_blks;
 	unsigned long	lmac_bmap; /* bitmap of enabled mcs lmac */
+	u16 ip_vec;
 };
 
 struct mcs {
@@ -165,6 +157,8 @@ struct mcs_ops {
 	void	(*mcs_tx_sa_mem_map_write)(struct mcs *mcs, struct mcs_tx_sc_sa_map *map);
 	void	(*mcs_rx_sa_mem_map_write)(struct mcs *mcs, struct mcs_rx_sc_sa_map *map);
 	void	(*mcs_flowid_secy_map)(struct mcs *mcs, struct secy_mem_map *map, int dir);
+	void	(*mcs_bbe_intr_handler)(struct mcs *mcs, u64 intr, enum mcs_direction dir);
+	void	(*mcs_pab_intr_handler)(struct mcs *mcs, u64 intr, enum mcs_direction dir);
 };
 
 extern struct pci_driver mcs_driver;
@@ -219,6 +213,8 @@ void cn10kb_mcs_tx_sa_mem_map_write(struct mcs *mcs, struct mcs_tx_sc_sa_map *ma
 void cn10kb_mcs_flowid_secy_map(struct mcs *mcs, struct secy_mem_map *map, int dir);
 void cn10kb_mcs_rx_sa_mem_map_write(struct mcs *mcs, struct mcs_rx_sc_sa_map *map);
 void cn10kb_mcs_parser_cfg(struct mcs *mcs);
+void cn10kb_mcs_pab_intr_handler(struct mcs *mcs, u64 intr, enum mcs_direction dir);
+void cn10kb_mcs_bbe_intr_handler(struct mcs *mcs, u64 intr, enum mcs_direction dir);
 
 /* CNF10K-B APIs */
 struct mcs_ops *cnf10kb_get_mac_ops(void);
@@ -229,6 +225,8 @@ void cnf10kb_mcs_rx_sa_mem_map_write(struct mcs *mcs, struct mcs_rx_sc_sa_map *m
 void cnf10kb_mcs_parser_cfg(struct mcs *mcs);
 void cnf10kb_mcs_tx_pn_thresh_reached_handler(struct mcs *mcs);
 void cnf10kb_mcs_tx_pn_wrapped_handler(struct mcs *mcs);
+void cnf10kb_mcs_bbe_intr_handler(struct mcs *mcs, u64 intr, enum mcs_direction dir);
+void cnf10kb_mcs_pab_intr_handler(struct mcs *mcs, u64 intr, enum mcs_direction dir);
 
 /* Stats APIs */
 void mcs_get_sc_stats(struct mcs *mcs, struct mcs_sc_stats *stats, int id, int dir);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c
index 7b6205414428..9f9b904ab2cd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c
@@ -13,6 +13,8 @@ static struct mcs_ops cnf10kb_mcs_ops   = {
 	.mcs_tx_sa_mem_map_write	= cnf10kb_mcs_tx_sa_mem_map_write,
 	.mcs_rx_sa_mem_map_write	= cnf10kb_mcs_rx_sa_mem_map_write,
 	.mcs_flowid_secy_map		= cnf10kb_mcs_flowid_secy_map,
+	.mcs_bbe_intr_handler		= cnf10kb_mcs_bbe_intr_handler,
+	.mcs_pab_intr_handler		= cnf10kb_mcs_pab_intr_handler,
 };
 
 struct mcs_ops *cnf10kb_get_mac_ops(void)
@@ -31,6 +33,7 @@ void cnf10kb_mcs_set_hw_capabilities(struct mcs *mcs)
 	hw->lmac_cnt = 4;		/* lmacs/ports per mcs block */
 	hw->mcs_x2p_intf = 1;		/* x2p clabration intf */
 	hw->mcs_blks = 7;		/* MCS blocks */
+	hw->ip_vec = MCS_CNF10KB_INT_VEC_IP; /* IP vector */
 }
 
 void cnf10kb_mcs_parser_cfg(struct mcs *mcs)
@@ -212,3 +215,63 @@ void cnf10kb_mcs_tx_pn_wrapped_handler(struct mcs *mcs)
 		mcs_add_intr_wq_entry(mcs, &event);
 	}
 }
+
+void cnf10kb_mcs_bbe_intr_handler(struct mcs *mcs, u64 intr,
+				  enum mcs_direction dir)
+{
+	struct mcs_intr_event event = { 0 };
+	int i;
+
+	if (!(intr & MCS_BBE_INT_MASK))
+		return;
+
+	event.mcs_id = mcs->mcs_id;
+	event.pcifunc = mcs->pf_map[0];
+
+	for (i = 0; i < MCS_MAX_BBE_INT; i++) {
+		if (!(intr & BIT_ULL(i)))
+			continue;
+
+		/* Lower nibble denotes data fifo overflow interrupts and
+		 * upper nibble indicates policy fifo overflow interrupts.
+		 */
+		if (intr & 0xFULL)
+			event.intr_mask = (dir == MCS_RX) ?
+					  MCS_BBE_RX_DFIFO_OVERFLOW_INT :
+					  MCS_BBE_TX_DFIFO_OVERFLOW_INT;
+		else
+			event.intr_mask = (dir == MCS_RX) ?
+					  MCS_BBE_RX_PLFIFO_OVERFLOW_INT :
+					  MCS_BBE_TX_PLFIFO_OVERFLOW_INT;
+
+		/* Notify the lmac_id info which ran into BBE fatal error */
+		event.lmac_id = i & 0x3ULL;
+		mcs_add_intr_wq_entry(mcs, &event);
+	}
+}
+
+void cnf10kb_mcs_pab_intr_handler(struct mcs *mcs, u64 intr,
+				  enum mcs_direction dir)
+{
+	struct mcs_intr_event event = { 0 };
+	int i;
+
+	if (!(intr & MCS_PAB_INT_MASK))
+		return;
+
+	event.mcs_id = mcs->mcs_id;
+	event.pcifunc = mcs->pf_map[0];
+
+	for (i = 0; i < MCS_MAX_PAB_INT; i++) {
+		if (!(intr & BIT_ULL(i)))
+			continue;
+
+		event.intr_mask = (dir == MCS_RX) ?
+				  MCS_PAB_RX_CHAN_OVERFLOW_INT :
+				  MCS_PAB_TX_CHAN_OVERFLOW_INT;
+
+		/* Notify the lmac_id info which ran into PAB fatal error */
+		event.lmac_id = i;
+		mcs_add_intr_wq_entry(mcs, &event);
+	}
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
index 7427e3b1490f..f3ab01fc363c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
@@ -276,7 +276,10 @@
 #define MCSX_BBE_RX_SLAVE_CAL_ENTRY			0x180ull
 #define MCSX_BBE_RX_SLAVE_CAL_LEN			0x188ull
 #define MCSX_PAB_RX_SLAVE_FIFO_SKID_CFGX(a)		(0x290ull + (a) * 0x40ull)
-
+#define MCSX_BBE_RX_SLAVE_DFIFO_OVERFLOW_0		0xe20
+#define MCSX_BBE_TX_SLAVE_DFIFO_OVERFLOW_0		0x1298
+#define MCSX_BBE_RX_SLAVE_PLFIFO_OVERFLOW_0		0xe40
+#define MCSX_BBE_TX_SLAVE_PLFIFO_OVERFLOW_0		0x12b8
 #define MCSX_BBE_RX_SLAVE_BBE_INT ({	\
 	u64 offset;			\
 					\
-- 
2.25.1

