Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8239C5F19ED
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 07:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiJAFBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 01:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiJAFAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 01:00:46 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897817CAA3
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 22:00:38 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2914t4fE008458;
        Fri, 30 Sep 2022 22:00:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=RIBR5mFovNjPC5mo58PU3avD+zWNUUVvp/jcg51Dt1E=;
 b=X/ETeDHLNFd3UE+cWoIQKVZG571fpfUmaG5BqzFPlmWv05irbH8lLsl3hW3ZsTZYRPGj
 OmLtmutmpYiOJ84L1fxHH4OXy66GLkXNUKRrCy5xQkdzmo0HKzuo00BLOFomxRPIi0/e
 8J2/hWaufsHHgrOCR5dAm6JE/sqKuNWnPx7z9pgQpWOg8BUZomrbTrBXrjF3SIxZHM2j
 2F33B/6Q48k9JgvU2L7+nXe4TGjTJmg92jTx1eQxDe6svB/6imAWe5iT1QRJN5hl4FwK
 Vf+DuilJA9rzUtCFsS4KF9/bCHpdGrb6vZH4NoWo/76rsRyjUz237KaYfRJiDgq91ZF9 Ow== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3jw1rt9fkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 22:00:30 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 30 Sep
 2022 22:00:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 30 Sep 2022 22:00:28 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 666F73F70AF;
        Fri, 30 Sep 2022 22:00:25 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <naveenm@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Vamsi Attunuru <vattunuru@marvell.com>,
        "Subbaraya Sundeep" <sbhatta@marvell.com>
Subject: [net-next PATCH v3 6/8] octeontx2-af: cn10k: mcs: Handle MCS block interrupts
Date:   Sat, 1 Oct 2022 10:29:47 +0530
Message-ID: <1664600389-5758-7-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1664600389-5758-1-git-send-email-sbhatta@marvell.com>
References: <1664600389-5758-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: JHd8K72x4o1I1GGZixOkVUkNHO9gkHrd
X-Proofpoint-ORIG-GUID: JHd8K72x4o1I1GGZixOkVUkNHO9gkHrd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-01_03,2022-09-29_03,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

Hardware triggers an interrupt for events like PN wrap to zero,
PN crosses set threshold. This interrupt is received
by the MCS_AF. MCS AF then finds the PF/VF to which SA is mapped
and notifies them using mcs_intr_notify mbox message.

PF/VF using mcs_intr_cfg mbox can configure the list
of interrupts for which they want to receive the
notification from AF.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Vamsi Attunuru <vattunuru@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  38 +++
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    | 337 +++++++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/mcs.h    |  74 +++++
 .../ethernet/marvell/octeontx2/af/mcs_cnf10kb.c    |  86 +++++-
 .../net/ethernet/marvell/octeontx2/af/mcs_reg.h    | 168 ++++++++++
 .../net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c | 160 ++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   6 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   8 +
 8 files changed, 865 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index e01a705..8d5d5a0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -326,6 +326,7 @@ M(MCS_GET_SA_STATS,	0xa00f, mcs_get_sa_stats, mcs_stats_req, mcs_sa_stats)	\
 M(MCS_GET_PORT_STATS,	0xa010, mcs_get_port_stats, mcs_stats_req,		\
 				mcs_port_stats)					\
 M(MCS_CLEAR_STATS,	0xa011,	mcs_clear_stats, mcs_clear_stats, msg_rsp)	\
+M(MCS_INTR_CFG,		0xa012, mcs_intr_cfg, mcs_intr_cfg, msg_rsp)		\
 M(MCS_SET_LMAC_MODE,	0xa013, mcs_set_lmac_mode, mcs_set_lmac_mode, msg_rsp)	\
 M(MCS_SET_PN_THRESHOLD, 0xa014, mcs_set_pn_threshold, mcs_set_pn_threshold,	\
 				msg_rsp)					\
@@ -351,11 +352,15 @@ M(CGX_LINK_EVENT,	0xC00, cgx_link_event, cgx_link_info_msg, msg_rsp)
 #define MBOX_UP_CPT_MESSAGES						\
 M(CPT_INST_LMTST,	0xD00, cpt_inst_lmtst, cpt_inst_lmtst_req, msg_rsp)
 
+#define MBOX_UP_MCS_MESSAGES						\
+M(MCS_INTR_NOTIFY,	0xE00, mcs_intr_notify, mcs_intr_info, msg_rsp)
+
 enum {
 #define M(_name, _id, _1, _2, _3) MBOX_MSG_ ## _name = _id,
 MBOX_MESSAGES
 MBOX_UP_CGX_MESSAGES
 MBOX_UP_CPT_MESSAGES
+MBOX_UP_MCS_MESSAGES
 #undef M
 };
 
@@ -2084,4 +2089,37 @@ struct mcs_clear_stats {
 	u8 all;		/* All resources stats mapped to PF are cleared */
 };
 
+struct mcs_intr_cfg {
+	struct mbox_msghdr hdr;
+#define MCS_CPM_RX_SECTAG_V_EQ1_INT		BIT_ULL(0)
+#define MCS_CPM_RX_SECTAG_E_EQ0_C_EQ1_INT	BIT_ULL(1)
+#define MCS_CPM_RX_SECTAG_SL_GTE48_INT		BIT_ULL(2)
+#define MCS_CPM_RX_SECTAG_ES_EQ1_SC_EQ1_INT	BIT_ULL(3)
+#define MCS_CPM_RX_SECTAG_SC_EQ1_SCB_EQ1_INT	BIT_ULL(4)
+#define MCS_CPM_RX_PACKET_XPN_EQ0_INT		BIT_ULL(5)
+#define MCS_CPM_RX_PN_THRESH_REACHED_INT	BIT_ULL(6)
+#define MCS_CPM_TX_PACKET_XPN_EQ0_INT		BIT_ULL(7)
+#define MCS_CPM_TX_PN_THRESH_REACHED_INT	BIT_ULL(8)
+#define MCS_CPM_TX_SA_NOT_VALID_INT		BIT_ULL(9)
+#define MCS_BBE_RX_DFIFO_OVERFLOW_INT		BIT_ULL(10)
+#define MCS_BBE_RX_PLFIFO_OVERFLOW_INT		BIT_ULL(11)
+#define MCS_BBE_TX_DFIFO_OVERFLOW_INT		BIT_ULL(12)
+#define MCS_BBE_TX_PLFIFO_OVERFLOW_INT		BIT_ULL(13)
+#define MCS_PAB_RX_CHAN_OVERFLOW_INT		BIT_ULL(14)
+#define MCS_PAB_TX_CHAN_OVERFLOW_INT		BIT_ULL(15)
+	u64 intr_mask;		/* Interrupt enable mask */
+	u8 mcs_id;
+	u8 lmac_id;
+	u64 rsvd;
+};
+
+struct mcs_intr_info {
+	struct mbox_msghdr hdr;
+	u64 intr_mask;
+	int sa_id;
+	u8 mcs_id;
+	u8 lmac_id;
+	u64 rsvd;
+};
+
 #endif /* MBOX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
index 002ccb0..5ba618a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -797,6 +797,289 @@ int mcs_alloc_all_rsrc(struct mcs *mcs, u8 *flow_id, u8 *secy_id,
 	return 0;
 }
 
+static void cn10kb_mcs_tx_pn_wrapped_handler(struct mcs *mcs)
+{
+	struct mcs_intr_event event = { 0 };
+	struct rsrc_bmap *sc_bmap;
+	u64 val;
+	int sc;
+
+	sc_bmap = &mcs->tx.sc;
+
+	event.mcs_id = mcs->mcs_id;
+	event.intr_mask = MCS_CPM_TX_PACKET_XPN_EQ0_INT;
+
+	for_each_set_bit(sc, sc_bmap->bmap, mcs->hw->sc_entries) {
+		val = mcs_reg_read(mcs, MCSX_CPM_TX_SLAVE_SA_MAP_MEM_0X(sc));
+
+		if (mcs->tx_sa_active[sc])
+			/* SA_index1 was used and got expired */
+			event.sa_id = (val >> 9) & 0xFF;
+		else
+			/* SA_index0 was used and got expired */
+			event.sa_id = val & 0xFF;
+
+		event.pcifunc = mcs->tx.sa2pf_map[event.sa_id];
+		mcs_add_intr_wq_entry(mcs, &event);
+	}
+}
+
+static void cn10kb_mcs_tx_pn_thresh_reached_handler(struct mcs *mcs)
+{
+	struct mcs_intr_event event = { 0 };
+	struct rsrc_bmap *sc_bmap;
+	u64 val, status;
+	int sc;
+
+	sc_bmap = &mcs->tx.sc;
+
+	event.mcs_id = mcs->mcs_id;
+	event.intr_mask = MCS_CPM_TX_PN_THRESH_REACHED_INT;
+
+	/* TX SA interrupt is raised only if autorekey is enabled.
+	 * MCS_CPM_TX_SLAVE_SA_MAP_MEM_0X[sc].tx_sa_active bit gets toggled if
+	 * one of two SAs mapped to SC gets expired. If tx_sa_active=0 implies
+	 * SA in SA_index1 got expired else SA in SA_index0 got expired.
+	 */
+	for_each_set_bit(sc, sc_bmap->bmap, mcs->hw->sc_entries) {
+		val = mcs_reg_read(mcs, MCSX_CPM_TX_SLAVE_SA_MAP_MEM_0X(sc));
+		/* Auto rekey is enable */
+		if (!((val >> 18) & 0x1))
+			continue;
+
+		status = (val >> 21) & 0x1;
+
+		/* Check if tx_sa_active status had changed */
+		if (status == mcs->tx_sa_active[sc])
+			continue;
+		/* SA_index0 is expired */
+		if (status)
+			event.sa_id = val & 0xFF;
+		else
+			event.sa_id = (val >> 9) & 0xFF;
+
+		event.pcifunc = mcs->tx.sa2pf_map[event.sa_id];
+		mcs_add_intr_wq_entry(mcs, &event);
+	}
+}
+
+static void mcs_rx_pn_thresh_reached_handler(struct mcs *mcs)
+{
+	struct mcs_intr_event event = { 0 };
+	int sa, reg;
+	u64 intr;
+
+	/* Check expired SAs */
+	for (reg = 0; reg < (mcs->hw->sa_entries / 64); reg++) {
+		/* Bit high in *PN_THRESH_REACHEDX implies
+		 * corresponding SAs are expired.
+		 */
+		intr = mcs_reg_read(mcs, MCSX_CPM_RX_SLAVE_PN_THRESH_REACHEDX(reg));
+		for (sa = 0; sa < 64; sa++) {
+			if (!(intr & BIT_ULL(sa)))
+				continue;
+
+			event.mcs_id = mcs->mcs_id;
+			event.intr_mask = MCS_CPM_RX_PN_THRESH_REACHED_INT;
+			event.sa_id = sa + (reg * 64);
+			event.pcifunc = mcs->rx.sa2pf_map[event.sa_id];
+			mcs_add_intr_wq_entry(mcs, &event);
+		}
+	}
+}
+
+static void mcs_rx_misc_intr_handler(struct mcs *mcs, u64 intr)
+{
+	struct mcs_intr_event event = { 0 };
+
+	event.mcs_id = mcs->mcs_id;
+	event.pcifunc = mcs->pf_map[0];
+
+	if (intr & MCS_CPM_RX_INT_SECTAG_V_EQ1)
+		event.intr_mask = MCS_CPM_RX_SECTAG_V_EQ1_INT;
+	if (intr & MCS_CPM_RX_INT_SECTAG_E_EQ0_C_EQ1)
+		event.intr_mask |= MCS_CPM_RX_SECTAG_E_EQ0_C_EQ1_INT;
+	if (intr & MCS_CPM_RX_INT_SL_GTE48)
+		event.intr_mask |= MCS_CPM_RX_SECTAG_SL_GTE48_INT;
+	if (intr & MCS_CPM_RX_INT_ES_EQ1_SC_EQ1)
+		event.intr_mask |= MCS_CPM_RX_SECTAG_ES_EQ1_SC_EQ1_INT;
+	if (intr & MCS_CPM_RX_INT_SC_EQ1_SCB_EQ1)
+		event.intr_mask |= MCS_CPM_RX_SECTAG_SC_EQ1_SCB_EQ1_INT;
+	if (intr & MCS_CPM_RX_INT_PACKET_XPN_EQ0)
+		event.intr_mask |= MCS_CPM_RX_PACKET_XPN_EQ0_INT;
+
+	mcs_add_intr_wq_entry(mcs, &event);
+}
+
+static void mcs_tx_misc_intr_handler(struct mcs *mcs, u64 intr)
+{
+	struct mcs_intr_event event = { 0 };
+
+	if (!(intr & MCS_CPM_TX_INT_SA_NOT_VALID))
+		return;
+
+	event.mcs_id = mcs->mcs_id;
+	event.pcifunc = mcs->pf_map[0];
+
+	event.intr_mask = MCS_CPM_TX_SA_NOT_VALID_INT;
+
+	mcs_add_intr_wq_entry(mcs, &event);
+}
+
+static void mcs_bbe_intr_handler(struct mcs *mcs, u64 intr, enum mcs_direction dir)
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
+					  MCS_BBE_RX_PLFIFO_OVERFLOW_INT;
+
+		/* Notify the lmac_id info which ran into BBE fatal error */
+		event.lmac_id = i & 0x3ULL;
+		mcs_add_intr_wq_entry(mcs, &event);
+	}
+}
+
+static void mcs_pab_intr_handler(struct mcs *mcs, u64 intr, enum mcs_direction dir)
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
+		event.intr_mask = (dir == MCS_RX) ? MCS_PAB_RX_CHAN_OVERFLOW_INT :
+				  MCS_PAB_TX_CHAN_OVERFLOW_INT;
+
+		/* Notify the lmac_id info which ran into PAB fatal error */
+		event.lmac_id = i;
+		mcs_add_intr_wq_entry(mcs, &event);
+	}
+}
+
+static irqreturn_t mcs_ip_intr_handler(int irq, void *mcs_irq)
+{
+	struct mcs *mcs = (struct mcs *)mcs_irq;
+	u64 intr, cpm_intr, bbe_intr, pab_intr;
+
+	/* Disable and clear the interrupt */
+	mcs_reg_write(mcs, MCSX_IP_INT_ENA_W1C, BIT_ULL(0));
+	mcs_reg_write(mcs, MCSX_IP_INT, BIT_ULL(0));
+
+	/* Check which block has interrupt*/
+	intr = mcs_reg_read(mcs, MCSX_TOP_SLAVE_INT_SUM);
+
+	/* CPM RX */
+	if (intr & MCS_CPM_RX_INT_ENA) {
+		/* Check for PN thresh interrupt bit */
+		cpm_intr = mcs_reg_read(mcs, MCSX_CPM_RX_SLAVE_RX_INT);
+
+		if (cpm_intr & MCS_CPM_RX_INT_PN_THRESH_REACHED)
+			mcs_rx_pn_thresh_reached_handler(mcs);
+
+		if (cpm_intr & MCS_CPM_RX_INT_ALL)
+			mcs_rx_misc_intr_handler(mcs, cpm_intr);
+
+		/* Clear the interrupt */
+		mcs_reg_write(mcs, MCSX_CPM_RX_SLAVE_RX_INT, cpm_intr);
+	}
+
+	/* CPM TX */
+	if (intr & MCS_CPM_TX_INT_ENA) {
+		cpm_intr = mcs_reg_read(mcs, MCSX_CPM_TX_SLAVE_TX_INT);
+
+		if (cpm_intr & MCS_CPM_TX_INT_PN_THRESH_REACHED) {
+			if (mcs->hw->mcs_blks > 1)
+				cnf10kb_mcs_tx_pn_thresh_reached_handler(mcs);
+			else
+				cn10kb_mcs_tx_pn_thresh_reached_handler(mcs);
+		}
+
+		if (cpm_intr & MCS_CPM_TX_INT_SA_NOT_VALID)
+			mcs_tx_misc_intr_handler(mcs, cpm_intr);
+
+		if (cpm_intr & MCS_CPM_TX_INT_PACKET_XPN_EQ0) {
+			if (mcs->hw->mcs_blks > 1)
+				cnf10kb_mcs_tx_pn_wrapped_handler(mcs);
+			else
+				cn10kb_mcs_tx_pn_wrapped_handler(mcs);
+		}
+		/* Clear the interrupt */
+		mcs_reg_write(mcs, MCSX_CPM_TX_SLAVE_TX_INT, cpm_intr);
+	}
+
+	/* BBE RX */
+	if (intr & MCS_BBE_RX_INT_ENA) {
+		bbe_intr = mcs_reg_read(mcs, MCSX_BBE_RX_SLAVE_BBE_INT);
+		mcs_bbe_intr_handler(mcs, bbe_intr, MCS_RX);
+
+		/* Clear the interrupt */
+		mcs_reg_write(mcs, MCSX_BBE_RX_SLAVE_BBE_INT_INTR_RW, 0);
+		mcs_reg_write(mcs, MCSX_BBE_RX_SLAVE_BBE_INT, bbe_intr);
+	}
+
+	/* BBE TX */
+	if (intr & MCS_BBE_TX_INT_ENA) {
+		bbe_intr = mcs_reg_read(mcs, MCSX_BBE_TX_SLAVE_BBE_INT);
+		mcs_bbe_intr_handler(mcs, bbe_intr, MCS_TX);
+
+		/* Clear the interrupt */
+		mcs_reg_write(mcs, MCSX_BBE_TX_SLAVE_BBE_INT_INTR_RW, 0);
+		mcs_reg_write(mcs, MCSX_BBE_TX_SLAVE_BBE_INT, bbe_intr);
+	}
+
+	/* PAB RX */
+	if (intr & MCS_PAB_RX_INT_ENA) {
+		pab_intr = mcs_reg_read(mcs, MCSX_PAB_RX_SLAVE_PAB_INT);
+		mcs_pab_intr_handler(mcs, pab_intr, MCS_RX);
+
+		/* Clear the interrupt */
+		mcs_reg_write(mcs, MCSX_PAB_RX_SLAVE_PAB_INT_INTR_RW, 0);
+		mcs_reg_write(mcs, MCSX_PAB_RX_SLAVE_PAB_INT, pab_intr);
+	}
+
+	/* PAB TX */
+	if (intr & MCS_PAB_TX_INT_ENA) {
+		pab_intr = mcs_reg_read(mcs, MCSX_PAB_TX_SLAVE_PAB_INT);
+		mcs_pab_intr_handler(mcs, pab_intr, MCS_TX);
+
+		/* Clear the interrupt */
+		mcs_reg_write(mcs, MCSX_PAB_TX_SLAVE_PAB_INT_INTR_RW, 0);
+		mcs_reg_write(mcs, MCSX_PAB_TX_SLAVE_PAB_INT, pab_intr);
+	}
+
+	/* Enable the interrupt */
+	mcs_reg_write(mcs, MCSX_IP_INT_ENA_W1S, BIT_ULL(0));
+
+	return IRQ_HANDLED;
+}
+
 static void *alloc_mem(struct mcs *mcs, int n)
 {
 	return devm_kcalloc(mcs->dev, n, sizeof(u16), GFP_KERNEL);
@@ -859,6 +1142,56 @@ static int mcs_alloc_struct_mem(struct mcs *mcs, struct mcs_rsrc_map *res)
 	return 0;
 }
 
+static int mcs_register_interrupts(struct mcs *mcs)
+{
+	int ret = 0;
+
+	mcs->num_vec = pci_msix_vec_count(mcs->pdev);
+
+	ret = pci_alloc_irq_vectors(mcs->pdev, mcs->num_vec,
+				    mcs->num_vec, PCI_IRQ_MSIX);
+	if (ret < 0) {
+		dev_err(mcs->dev, "MCS Request for %d msix vector failed err:%d\n",
+			mcs->num_vec, ret);
+		return ret;
+	}
+
+	ret = request_irq(pci_irq_vector(mcs->pdev, MCS_INT_VEC_IP),
+			  mcs_ip_intr_handler, 0, "MCS_IP", mcs);
+	if (ret) {
+		dev_err(mcs->dev, "MCS IP irq registration failed\n");
+		goto exit;
+	}
+
+	/* MCS enable IP interrupts */
+	mcs_reg_write(mcs, MCSX_IP_INT_ENA_W1S, BIT_ULL(0));
+
+	/* Enable CPM Rx/Tx interrupts */
+	mcs_reg_write(mcs, MCSX_TOP_SLAVE_INT_SUM_ENB,
+		      MCS_CPM_RX_INT_ENA | MCS_CPM_TX_INT_ENA |
+		      MCS_BBE_RX_INT_ENA | MCS_BBE_TX_INT_ENA |
+		      MCS_PAB_RX_INT_ENA | MCS_PAB_TX_INT_ENA);
+
+	mcs_reg_write(mcs, MCSX_CPM_TX_SLAVE_TX_INT_ENB, 0x7ULL);
+	mcs_reg_write(mcs, MCSX_CPM_RX_SLAVE_RX_INT_ENB, 0x7FULL);
+
+	mcs_reg_write(mcs, MCSX_BBE_RX_SLAVE_BBE_INT_ENB, 0xff);
+	mcs_reg_write(mcs, MCSX_BBE_TX_SLAVE_BBE_INT_ENB, 0xff);
+
+	mcs_reg_write(mcs, MCSX_PAB_RX_SLAVE_PAB_INT_ENB, 0xff);
+	mcs_reg_write(mcs, MCSX_PAB_TX_SLAVE_PAB_INT_ENB, 0xff);
+
+	mcs->tx_sa_active = alloc_mem(mcs, mcs->hw->sc_entries);
+	if (!mcs->tx_sa_active)
+		goto exit;
+
+	return ret;
+exit:
+	pci_free_irq_vectors(mcs->pdev);
+	mcs->num_vec = 0;
+	return ret;
+}
+
 int mcs_get_blkcnt(void)
 {
 	struct mcs *mcs;
@@ -1229,6 +1562,10 @@ static int mcs_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Parser configuration */
 	mcs->mcs_ops->mcs_parser_cfg(mcs);
 
+	err = mcs_register_interrupts(mcs);
+	if (err)
+		goto exit;
+
 	list_add(&mcs->mcs_list, &mcs_list);
 	mutex_init(&mcs->stats_lock);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.h b/drivers/net/ethernet/marvell/octeontx2/af/mcs.h
index 28600ef..64dc2b8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.h
@@ -16,6 +16,7 @@
 #define MCSX_LINK_LMAC_BASE_MASK	GENMASK_ULL(11, 0)
 
 #define MCS_ID_MASK			0x7
+#define MCS_MAX_PFS                     128
 
 #define MCS_PORT_MODE_MASK		0x3
 #define MCS_PORT_FIFO_SKID_MASK		0x3F
@@ -42,6 +43,69 @@
 /* Reserved resources for default bypass entry */
 #define MCS_RSRC_RSVD_CNT		1
 
+/* MCS Interrupt Vector Enumeration */
+enum mcs_int_vec_e {
+	MCS_INT_VEC_MIL_RX_GBL		= 0x0,
+	MCS_INT_VEC_MIL_RX_LMACX	= 0x1,
+	MCS_INT_VEC_MIL_TX_LMACX	= 0x5,
+	MCS_INT_VEC_HIL_RX_GBL		= 0x9,
+	MCS_INT_VEC_HIL_RX_LMACX	= 0xa,
+	MCS_INT_VEC_HIL_TX_GBL		= 0xe,
+	MCS_INT_VEC_HIL_TX_LMACX	= 0xf,
+	MCS_INT_VEC_IP			= 0x13,
+	MCS_INT_VEC_CNT			= 0x14,
+};
+
+#define MCS_MAX_BBE_INT			8ULL
+#define MCS_BBE_INT_MASK		0xFFULL
+
+#define MCS_MAX_PAB_INT			4ULL
+#define MCS_PAB_INT_MASK		0xFULL
+
+#define MCS_BBE_RX_INT_ENA		BIT_ULL(0)
+#define MCS_BBE_TX_INT_ENA		BIT_ULL(1)
+#define MCS_CPM_RX_INT_ENA		BIT_ULL(2)
+#define MCS_CPM_TX_INT_ENA		BIT_ULL(3)
+#define MCS_PAB_RX_INT_ENA		BIT_ULL(4)
+#define MCS_PAB_TX_INT_ENA		BIT_ULL(5)
+
+#define MCS_CPM_TX_INT_PACKET_XPN_EQ0		BIT_ULL(0)
+#define MCS_CPM_TX_INT_PN_THRESH_REACHED	BIT_ULL(1)
+#define MCS_CPM_TX_INT_SA_NOT_VALID		BIT_ULL(2)
+
+#define MCS_CPM_RX_INT_SECTAG_V_EQ1		BIT_ULL(0)
+#define MCS_CPM_RX_INT_SECTAG_E_EQ0_C_EQ1	BIT_ULL(1)
+#define MCS_CPM_RX_INT_SL_GTE48			BIT_ULL(2)
+#define MCS_CPM_RX_INT_ES_EQ1_SC_EQ1		BIT_ULL(3)
+#define MCS_CPM_RX_INT_SC_EQ1_SCB_EQ1		BIT_ULL(4)
+#define MCS_CPM_RX_INT_PACKET_XPN_EQ0		BIT_ULL(5)
+#define MCS_CPM_RX_INT_PN_THRESH_REACHED	BIT_ULL(6)
+
+#define MCS_CPM_RX_INT_ALL	(MCS_CPM_RX_INT_SECTAG_V_EQ1 |		\
+				 MCS_CPM_RX_INT_SECTAG_E_EQ0_C_EQ1 |    \
+				 MCS_CPM_RX_INT_SL_GTE48 |		\
+				 MCS_CPM_RX_INT_ES_EQ1_SC_EQ1 |		\
+				 MCS_CPM_RX_INT_SC_EQ1_SCB_EQ1 |	\
+				 MCS_CPM_RX_INT_PACKET_XPN_EQ0 |	\
+				 MCS_CPM_RX_INT_PN_THRESH_REACHED)
+
+struct mcs_pfvf {
+	u64 intr_mask;	/* Enabled Interrupt mask */
+};
+
+struct mcs_intr_event {
+	u16 pcifunc;
+	u64 intr_mask;
+	u64 sa_id;
+	u8 mcs_id;
+	u8 lmac_id;
+};
+
+struct mcs_intrq_entry {
+	struct list_head node;
+	struct mcs_intr_event intr_event;
+};
+
 struct secy_mem_map {
 	u8 flow_id;
 	u8 secy;
@@ -82,11 +146,17 @@ struct mcs {
 	struct hwinfo		*hw;
 	struct mcs_rsrc_map	tx;
 	struct mcs_rsrc_map	rx;
+	u16                     pf_map[MCS_MAX_PFS]; /* List of PCIFUNC mapped to MCS */
 	u8			mcs_id;
 	struct mcs_ops		*mcs_ops;
 	struct list_head	mcs_list;
 	/* Lock for mcs stats */
 	struct mutex		stats_lock;
+	struct mcs_pfvf		*pf;
+	struct mcs_pfvf		*vf;
+	u16			num_vec;
+	void			*rvu;
+	u16			*tx_sa_active;
 };
 
 struct mcs_ops {
@@ -157,6 +227,8 @@ void cnf10kb_mcs_tx_sa_mem_map_write(struct mcs *mcs, struct mcs_tx_sc_sa_map *m
 void cnf10kb_mcs_flowid_secy_map(struct mcs *mcs, struct secy_mem_map *map, int dir);
 void cnf10kb_mcs_rx_sa_mem_map_write(struct mcs *mcs, struct mcs_rx_sc_sa_map *map);
 void cnf10kb_mcs_parser_cfg(struct mcs *mcs);
+void cnf10kb_mcs_tx_pn_thresh_reached_handler(struct mcs *mcs);
+void cnf10kb_mcs_tx_pn_wrapped_handler(struct mcs *mcs);
 
 /* Stats APIs */
 void mcs_get_sc_stats(struct mcs *mcs, struct mcs_sc_stats *stats, int id, int dir);
@@ -169,4 +241,6 @@ void mcs_clear_stats(struct mcs *mcs, u8 type, u8 id, int dir);
 int mcs_clear_all_stats(struct mcs *mcs, u16 pcifunc, int dir);
 int mcs_set_force_clk_en(struct mcs *mcs, bool set);
 
+int mcs_add_intr_wq_entry(struct mcs *mcs, struct mcs_intr_event *event);
+
 #endif /* MCS_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c
index 5ed5deb..7b62054 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c
@@ -93,18 +93,18 @@ void cnf10kb_mcs_tx_sa_mem_map_write(struct mcs *mcs, struct mcs_tx_sc_sa_map *m
 	reg = MCSX_CPM_TX_SLAVE_SA_MAP_MEM_0X(map->sc_id);
 	mcs_reg_write(mcs, reg, val);
 
-	if (map->rekey_ena) {
-		reg = MCSX_CPM_TX_SLAVE_AUTO_REKEY_ENABLE_0;
-		val = mcs_reg_read(mcs, reg);
+	reg = MCSX_CPM_TX_SLAVE_AUTO_REKEY_ENABLE_0;
+	val = mcs_reg_read(mcs, reg);
+
+	if (map->rekey_ena)
 		val |= BIT_ULL(map->sc_id);
-		mcs_reg_write(mcs, reg, val);
-	}
+	else
+		val &= ~BIT_ULL(map->sc_id);
 
-	if (map->sa_index0_vld)
-		mcs_reg_write(mcs, MCSX_CPM_TX_SLAVE_SA_INDEX0_VLDX(map->sc_id), BIT_ULL(0));
+	mcs_reg_write(mcs, reg, val);
 
-	if (map->sa_index1_vld)
-		mcs_reg_write(mcs, MCSX_CPM_TX_SLAVE_SA_INDEX1_VLDX(map->sc_id), BIT_ULL(0));
+	mcs_reg_write(mcs, MCSX_CPM_TX_SLAVE_SA_INDEX0_VLDX(map->sc_id), map->sa_index0_vld);
+	mcs_reg_write(mcs, MCSX_CPM_TX_SLAVE_SA_INDEX1_VLDX(map->sc_id), map->sa_index1_vld);
 
 	mcs_reg_write(mcs, MCSX_CPM_TX_SLAVE_TX_SA_ACTIVEX(map->sc_id), map->tx_sa_active);
 }
@@ -144,3 +144,71 @@ int mcs_set_force_clk_en(struct mcs *mcs, bool set)
 
 	return 0;
 }
+
+/* TX SA interrupt is raised only if autorekey is enabled.
+ * MCS_CPM_TX_SLAVE_SA_MAP_MEM_0X[sc].tx_sa_active bit gets toggled if
+ * one of two SAs mapped to SC gets expired. If tx_sa_active=0 implies
+ * SA in SA_index1 got expired else SA in SA_index0 got expired.
+ */
+void cnf10kb_mcs_tx_pn_thresh_reached_handler(struct mcs *mcs)
+{
+	struct mcs_intr_event event;
+	struct rsrc_bmap *sc_bmap;
+	unsigned long rekey_ena;
+	u64 val, sa_status;
+	int sc;
+
+	sc_bmap = &mcs->tx.sc;
+
+	event.mcs_id = mcs->mcs_id;
+	event.intr_mask = MCS_CPM_TX_PN_THRESH_REACHED_INT;
+
+	rekey_ena = mcs_reg_read(mcs, MCSX_CPM_TX_SLAVE_AUTO_REKEY_ENABLE_0);
+
+	for_each_set_bit(sc, sc_bmap->bmap, mcs->hw->sc_entries) {
+		/* Auto rekey is enable */
+		if (!test_bit(sc, &rekey_ena))
+			continue;
+		sa_status = mcs_reg_read(mcs, MCSX_CPM_TX_SLAVE_TX_SA_ACTIVEX(sc));
+		/* Check if tx_sa_active status had changed */
+		if (sa_status == mcs->tx_sa_active[sc])
+			continue;
+
+		/* SA_index0 is expired */
+		val = mcs_reg_read(mcs, MCSX_CPM_TX_SLAVE_SA_MAP_MEM_0X(sc));
+		if (sa_status)
+			event.sa_id = val & 0x7F;
+		else
+			event.sa_id = (val >> 7) & 0x7F;
+
+		event.pcifunc = mcs->tx.sa2pf_map[event.sa_id];
+		mcs_add_intr_wq_entry(mcs, &event);
+	}
+}
+
+void cnf10kb_mcs_tx_pn_wrapped_handler(struct mcs *mcs)
+{
+	struct mcs_intr_event event = { 0 };
+	struct rsrc_bmap *sc_bmap;
+	u64 val;
+	int sc;
+
+	sc_bmap = &mcs->tx.sc;
+
+	event.mcs_id = mcs->mcs_id;
+	event.intr_mask = MCS_CPM_TX_PACKET_XPN_EQ0_INT;
+
+	for_each_set_bit(sc, sc_bmap->bmap, mcs->hw->sc_entries) {
+		val = mcs_reg_read(mcs, MCSX_CPM_TX_SLAVE_SA_MAP_MEM_0X(sc));
+
+		if (mcs->tx_sa_active[sc])
+			/* SA_index1 was used and got expired */
+			event.sa_id = (val >> 7) & 0x7F;
+		else
+			/* SA_index0 was used and got expired */
+			event.sa_id = val & 0x7F;
+
+		event.pcifunc = mcs->tx.sa2pf_map[event.sa_id];
+		mcs_add_intr_wq_entry(mcs, &event);
+	}
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
index 12be9f9..c95a8b8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
@@ -276,6 +276,102 @@
 #define MCSX_BBE_RX_SLAVE_CAL_LEN			0x188ull
 #define MCSX_PAB_RX_SLAVE_FIFO_SKID_CFGX(a)		(0x290ull + (a) * 0x40ull)
 
+#define MCSX_BBE_RX_SLAVE_BBE_INT ({	\
+	u64 offset;			\
+					\
+	offset = 0xe00ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0x160ull;	\
+	offset; })
+
+#define MCSX_BBE_RX_SLAVE_BBE_INT_ENB ({	\
+	u64 offset;			\
+					\
+	offset = 0xe08ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0x168ull;	\
+	offset; })
+
+#define MCSX_BBE_RX_SLAVE_BBE_INT_INTR_RW ({	\
+	u64 offset;			\
+					\
+	offset = 0xe08ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0x178ull;	\
+	offset; })
+
+#define MCSX_BBE_TX_SLAVE_BBE_INT ({	\
+	u64 offset;			\
+					\
+	offset = 0x1278ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0x1e0ull;	\
+	offset; })
+
+#define MCSX_BBE_TX_SLAVE_BBE_INT_INTR_RW ({	\
+	u64 offset;			\
+					\
+	offset = 0x1278ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0x1f8ull;	\
+	offset; })
+
+#define MCSX_BBE_TX_SLAVE_BBE_INT_ENB ({	\
+	u64 offset;			\
+					\
+	offset = 0x1280ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0x1e8ull;	\
+	offset; })
+
+#define MCSX_PAB_RX_SLAVE_PAB_INT ({	\
+	u64 offset;			\
+					\
+	offset = 0x16f0ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0x260ull;	\
+	offset; })
+
+#define MCSX_PAB_RX_SLAVE_PAB_INT_ENB ({	\
+	u64 offset;			\
+					\
+	offset = 0x16f8ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0x268ull;	\
+	offset; })
+
+#define MCSX_PAB_RX_SLAVE_PAB_INT_INTR_RW ({	\
+	u64 offset;			\
+					\
+	offset = 0x16f8ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0x278ull;	\
+	offset; })
+
+#define MCSX_PAB_TX_SLAVE_PAB_INT ({	\
+	u64 offset;			\
+					\
+	offset = 0x2908ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0x380ull;	\
+	offset; })
+
+#define MCSX_PAB_TX_SLAVE_PAB_INT_ENB ({	\
+	u64 offset;			\
+					\
+	offset = 0x2910ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0x388ull;	\
+	offset; })
+
+#define MCSX_PAB_TX_SLAVE_PAB_INT_INTR_RW ({	\
+	u64 offset;			\
+					\
+	offset = 0x16f8ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0x398ull;	\
+	offset; })
+
 /* CPM registers */
 #define MCSX_CPM_RX_SLAVE_FLOWID_TCAM_DATAX(a, b) ({	\
 	u64 offset;					\
@@ -931,4 +1027,76 @@
 #define MCSX_CSE_TX_MEM_SLAVE_OUTPKTSSAENCRYPTEDX(a)	(0x21c40ull + (a) * 0x8ull)
 #define MCSX_CSE_TX_MEM_SLAVE_OUTPKTSSAPROTECTEDX(a)	(0x20c40ull + (a) * 0x8ull)
 
+#define MCSX_IP_INT ({			\
+	u64 offset;			\
+					\
+	offset = 0x80028ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0x60028ull;	\
+	offset; })
+
+#define MCSX_IP_INT_ENA_W1S ({		\
+	u64 offset;			\
+					\
+	offset = 0x80040ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0x60040ull;	\
+	offset; })
+
+#define MCSX_IP_INT_ENA_W1C ({		\
+	u64 offset;			\
+					\
+	offset = 0x80038ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0x60038ull;	\
+	offset; })
+
+#define MCSX_TOP_SLAVE_INT_SUM ({	\
+	u64 offset;			\
+					\
+	offset = 0xc20ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0xab8ull;	\
+	offset; })
+
+#define MCSX_TOP_SLAVE_INT_SUM_ENB ({	\
+	u64 offset;			\
+					\
+	offset = 0xc28ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0xac0ull;	\
+	offset; })
+
+#define MCSX_CPM_RX_SLAVE_RX_INT ({	\
+	u64 offset;			\
+					\
+	offset = 0x23c00ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0x0ad8ull;	\
+	offset; })
+
+#define MCSX_CPM_RX_SLAVE_RX_INT_ENB ({	\
+	u64 offset;			\
+					\
+	offset = 0x23c08ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0xae0ull;	\
+	offset; })
+
+#define MCSX_CPM_TX_SLAVE_TX_INT ({	\
+	u64 offset;			\
+					\
+	offset = 0x3d490ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0x54a0ull;	\
+	offset; })
+
+#define MCSX_CPM_TX_SLAVE_TX_INT_ENB ({	\
+	u64 offset;			\
+					\
+	offset = 0x3d498ull;		\
+	if (mcs->hw->mcs_blks > 1)	\
+		offset = 0x54a8ull;	\
+	offset; })
+
 #endif
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
index 939c9b6..fa8029a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
@@ -13,6 +13,25 @@
 #include "rvu.h"
 #include "lmac_common.h"
 
+#define M(_name, _id, _fn_name, _req_type, _rsp_type)			\
+static struct _req_type __maybe_unused					\
+*otx2_mbox_alloc_msg_ ## _fn_name(struct rvu *rvu, int devid)		\
+{									\
+	struct _req_type *req;						\
+									\
+	req = (struct _req_type *)otx2_mbox_alloc_msg_rsp(		\
+		&rvu->afpf_wq_info.mbox_up, devid, sizeof(struct _req_type), \
+		sizeof(struct _rsp_type));				\
+	if (!req)							\
+		return NULL;						\
+	req->hdr.sig = OTX2_MBOX_REQ_SIG;				\
+	req->hdr.id = _id;						\
+	return req;							\
+}
+
+MBOX_UP_MCS_MESSAGES
+#undef M
+
 int rvu_mbox_handler_mcs_set_lmac_mode(struct rvu *rvu,
 				       struct mcs_set_lmac_mode *req,
 				       struct msg_rsp *rsp)
@@ -30,6 +49,114 @@ int rvu_mbox_handler_mcs_set_lmac_mode(struct rvu *rvu,
 	return 0;
 }
 
+int mcs_add_intr_wq_entry(struct mcs *mcs, struct mcs_intr_event *event)
+{
+	struct mcs_intrq_entry *qentry;
+	u16 pcifunc = event->pcifunc;
+	struct rvu *rvu = mcs->rvu;
+	struct mcs_pfvf *pfvf;
+
+	/* Check if it is PF or VF */
+	if (pcifunc & RVU_PFVF_FUNC_MASK)
+		pfvf = &mcs->vf[rvu_get_hwvf(rvu, pcifunc)];
+	else
+		pfvf = &mcs->pf[rvu_get_pf(pcifunc)];
+
+	event->intr_mask &= pfvf->intr_mask;
+
+	/* Check PF/VF interrupt notification is enabled */
+	if (!(pfvf->intr_mask && event->intr_mask))
+		return 0;
+
+	qentry = kmalloc(sizeof(*qentry), GFP_ATOMIC);
+	if (!qentry)
+		return -ENOMEM;
+
+	qentry->intr_event = *event;
+	spin_lock(&rvu->mcs_intrq_lock);
+	list_add_tail(&qentry->node, &rvu->mcs_intrq_head);
+	spin_unlock(&rvu->mcs_intrq_lock);
+	queue_work(rvu->mcs_intr_wq, &rvu->mcs_intr_work);
+
+	return 0;
+}
+
+static int mcs_notify_pfvf(struct mcs_intr_event *event, struct rvu *rvu)
+{
+	struct mcs_intr_info *req;
+	int err, pf;
+
+	pf = rvu_get_pf(event->pcifunc);
+
+	req = otx2_mbox_alloc_msg_mcs_intr_notify(rvu, pf);
+	if (!req)
+		return -ENOMEM;
+
+	req->mcs_id = event->mcs_id;
+	req->intr_mask = event->intr_mask;
+	req->sa_id = event->sa_id;
+	req->hdr.pcifunc = event->pcifunc;
+	req->lmac_id = event->lmac_id;
+
+	otx2_mbox_msg_send(&rvu->afpf_wq_info.mbox_up, pf);
+	err = otx2_mbox_wait_for_rsp(&rvu->afpf_wq_info.mbox_up, pf);
+	if (err)
+		dev_warn(rvu->dev, "MCS notification to pf %d failed\n", pf);
+
+	return 0;
+}
+
+static void mcs_intr_handler_task(struct work_struct *work)
+{
+	struct rvu *rvu = container_of(work, struct rvu, mcs_intr_work);
+	struct mcs_intrq_entry *qentry;
+	struct mcs_intr_event *event;
+	unsigned long flags;
+
+	do {
+		spin_lock_irqsave(&rvu->mcs_intrq_lock, flags);
+		qentry = list_first_entry_or_null(&rvu->mcs_intrq_head,
+						  struct mcs_intrq_entry,
+						  node);
+		if (qentry)
+			list_del(&qentry->node);
+
+		spin_unlock_irqrestore(&rvu->mcs_intrq_lock, flags);
+		if (!qentry)
+			break; /* nothing more to process */
+
+		event = &qentry->intr_event;
+
+		mcs_notify_pfvf(event, rvu);
+		kfree(qentry);
+	} while (1);
+}
+
+int rvu_mbox_handler_mcs_intr_cfg(struct rvu *rvu,
+				  struct mcs_intr_cfg *req,
+				  struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	struct mcs_pfvf *pfvf;
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	/* Check if it is PF or VF */
+	if (pcifunc & RVU_PFVF_FUNC_MASK)
+		pfvf = &mcs->vf[rvu_get_hwvf(rvu, pcifunc)];
+	else
+		pfvf = &mcs->pf[rvu_get_pf(pcifunc)];
+
+	mcs->pf_map[0] = pcifunc;
+	pfvf->intr_mask = req->intr_mask;
+
+	return 0;
+}
+
 int rvu_mbox_handler_mcs_get_hw_info(struct rvu *rvu,
 				     struct msg_req *req,
 				     struct mcs_hw_info *rsp)
@@ -376,6 +503,7 @@ int rvu_mbox_handler_mcs_tx_sc_sa_map_write(struct rvu *rvu,
 
 	mcs = mcs_get_pdata(req->mcs_id);
 	mcs->mcs_ops->mcs_tx_sa_mem_map_write(mcs, req);
+	mcs->tx_sa_active[req->sc_id] = req->tx_sa_active;
 
 	return 0;
 }
@@ -723,7 +851,39 @@ int rvu_mcs_init(struct rvu *rvu)
 		mcs_install_flowid_bypass_entry(mcs);
 		for (lmac = 0; lmac < mcs->hw->lmac_cnt; lmac++)
 			mcs_set_lmac_mode(mcs, lmac, 0);
+
+		mcs->rvu = rvu;
+
+		/* Allocated memory for PFVF data */
+		mcs->pf = devm_kcalloc(mcs->dev, hw->total_pfs,
+				       sizeof(struct mcs_pfvf), GFP_KERNEL);
+		if (!mcs->pf)
+			return -ENOMEM;
+
+		mcs->vf = devm_kcalloc(mcs->dev, hw->total_vfs,
+				       sizeof(struct mcs_pfvf), GFP_KERNEL);
+		if (!mcs->vf)
+			return -ENOMEM;
+	}
+
+	/* Initialize the wq for handling mcs interrupts */
+	INIT_LIST_HEAD(&rvu->mcs_intrq_head);
+	INIT_WORK(&rvu->mcs_intr_work, mcs_intr_handler_task);
+	rvu->mcs_intr_wq = alloc_workqueue("mcs_intr_wq", 0, 0);
+	if (!rvu->mcs_intr_wq) {
+		dev_err(rvu->dev, "mcs alloc workqueue failed\n");
+		return -ENOMEM;
 	}
 
 	return err;
 }
+
+void rvu_mcs_exit(struct rvu *rvu)
+{
+	if (!rvu->mcs_intr_wq)
+		return;
+
+	flush_workqueue(rvu->mcs_intr_wq);
+	destroy_workqueue(rvu->mcs_intr_wq);
+	rvu->mcs_intr_wq = NULL;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 5d74641..3f5e09b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -24,8 +24,6 @@
 #define DRV_NAME	"rvu_af"
 #define DRV_STRING      "Marvell OcteonTX2 RVU Admin Function Driver"
 
-static int rvu_get_hwvf(struct rvu *rvu, int pcifunc);
-
 static void rvu_set_msix_offset(struct rvu *rvu, struct rvu_pfvf *pfvf,
 				struct rvu_block *block, int lf);
 static void rvu_clear_msix_offset(struct rvu *rvu, struct rvu_pfvf *pfvf,
@@ -419,7 +417,7 @@ void rvu_get_pf_numvfs(struct rvu *rvu, int pf, int *numvfs, int *hwvf)
 		*hwvf = cfg & 0xFFF;
 }
 
-static int rvu_get_hwvf(struct rvu *rvu, int pcifunc)
+int rvu_get_hwvf(struct rvu *rvu, int pcifunc)
 {
 	int pf, func;
 	u64 cfg;
@@ -3300,6 +3298,7 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_hwsetup:
 	rvu_cgx_exit(rvu);
 	rvu_fwdata_exit(rvu);
+	rvu_mcs_exit(rvu);
 	rvu_reset_all_blocks(rvu);
 	rvu_free_hw_resources(rvu);
 	rvu_clear_rvum_blk_revid(rvu);
@@ -3326,6 +3325,7 @@ static void rvu_remove(struct pci_dev *pdev)
 	rvu_flr_wq_destroy(rvu);
 	rvu_cgx_exit(rvu);
 	rvu_fwdata_exit(rvu);
+	rvu_mcs_exit(rvu);
 	rvu_mbox_destroy(&rvu->afpf_wq_info);
 	rvu_disable_sriov(rvu);
 	rvu_reset_all_blocks(rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 4aefe47..d0268c4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -508,6 +508,12 @@ struct rvu {
 
 	/* RVU switch implementation over NPC with DMAC rules */
 	struct rvu_switch	rswitch;
+
+	struct			work_struct mcs_intr_work;
+	struct			workqueue_struct *mcs_intr_wq;
+	struct list_head	mcs_intrq_head;
+	/* mcs interrupt queue lock */
+	spinlock_t		mcs_intrq_lock;
 };
 
 static inline void rvu_write64(struct rvu *rvu, u64 block, u64 offset, u64 val)
@@ -872,9 +878,11 @@ void rvu_switch_update_rules(struct rvu *rvu, u16 pcifunc);
 int rvu_npc_set_parse_mode(struct rvu *rvu, u16 pcifunc, u64 mode, u8 dir,
 			   u64 pkind, u8 var_len_off, u8 var_len_off_mask,
 			   u8 shift_dir);
+int rvu_get_hwvf(struct rvu *rvu, int pcifunc);
 
 /* CN10K MCS */
 int rvu_mcs_init(struct rvu *rvu);
 int rvu_mcs_flr_handler(struct rvu *rvu, u16 pcifunc);
+void rvu_mcs_exit(struct rvu *rvu);
 
 #endif /* RVU_H */
-- 
2.7.4

