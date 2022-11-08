Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC78621DD5
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiKHUnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiKHUm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:42:59 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DD668AD3;
        Tue,  8 Nov 2022 12:42:57 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A8H0a3h008588;
        Tue, 8 Nov 2022 12:42:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=umjx+vUWYzzNB/RrN+PUSAViiQ83pvhM/gTl84ULIPo=;
 b=Wb0CVB/TGkaBP6IFH9ke4enCjXRvDVKzMYD14COHWdwRfh9Js/TCrT2BSHPDGKWqQ6im
 WumGOi7hgDwVbmnTc0jKPWLm7LOXnsRhzzGD5qlN7DJdhSDrU/yP0xyXgBvhdTQUlJTp
 WGbhS1lldjTMx+yPQfU29JTxkSiVJi4P3G0YKCjC70TElgDZXBxeYlvpG+OYYKbRTrL2
 ZXch27PbSzfq5jzLiG37HQhBof5y+u9n5oKX35rtTJYAC6Xp9+MDP6rFTZV4v+6cwS9j
 UUYEr4ezjV6/6j+5NEGLGufqXuL1jvKLjE1WSRT3WUSkA1LVAb8fiEI9dUPYWo3YqKlq Wg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3kqu4vh06u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 12:42:49 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Nov
 2022 12:42:47 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Nov 2022 12:42:47 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 57B963F708A;
        Tue,  8 Nov 2022 12:42:47 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lironh@marvell.com>, <aayarekar@marvell.com>,
        <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>, Andrew Lunn <andrew@lunn.ch>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH net-next 2/8] octeon_ep_vf: add hardware configuration APIs
Date:   Tue, 8 Nov 2022 12:41:53 -0800
Message-ID: <20221108204209.23071-3-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221108204209.23071-1-vburru@marvell.com>
References: <20221108204209.23071-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: jHeSNQxLq9q8xQThxtUm_uOR-Qrp2pxY
X-Proofpoint-GUID: jHeSNQxLq9q8xQThxtUm_uOR-Qrp2pxY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement hardware resource init and shutdown helper APIs, like
hardware Tx/Rx queue init/enable/disable/reset.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Sathesh Edara <sedara@marvell.com>
Signed-off-by: Satananda Burla <sburla@marvell.com>
---
 .../marvell/octeon_ep_vf/octep_vf_cn9k.c      | 333 +++++++++++++++++-
 1 file changed, 332 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_cn9k.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_cn9k.c
index fae48a98694d..31edf5665670 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_cn9k.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_cn9k.c
@@ -13,9 +13,124 @@
 #include "octep_vf_main.h"
 #include "octep_vf_regs_cn9k.h"
 
+/* Dump useful hardware IQ/OQ CSRs for debug purpose */
+static void cn93_vf_dump_q_regs(struct octep_vf_device *oct, int qno)
+{
+	struct device *dev = &oct->pdev->dev;
+
+	dev_info(dev, "IQ-%d register dump\n", qno);
+	dev_info(dev, "R[%d]_IN_INSTR_DBELL[0x%llx]: 0x%016llx\n",
+		 qno, CN93_VF_SDP_R_IN_INSTR_DBELL(qno),
+		 octep_vf_read_csr64(oct, CN93_VF_SDP_R_IN_INSTR_DBELL(qno)));
+	dev_info(dev, "R[%d]_IN_CONTROL[0x%llx]: 0x%016llx\n",
+		 qno, CN93_VF_SDP_R_IN_CONTROL(qno),
+		 octep_vf_read_csr64(oct, CN93_VF_SDP_R_IN_CONTROL(qno)));
+	dev_info(dev, "R[%d]_IN_ENABLE[0x%llx]: 0x%016llx\n",
+		 qno, CN93_VF_SDP_R_IN_ENABLE(qno),
+		 octep_vf_read_csr64(oct, CN93_VF_SDP_R_IN_ENABLE(qno)));
+	dev_info(dev, "R[%d]_IN_INSTR_BADDR[0x%llx]: 0x%016llx\n",
+		 qno, CN93_VF_SDP_R_IN_INSTR_BADDR(qno),
+		 octep_vf_read_csr64(oct, CN93_VF_SDP_R_IN_INSTR_BADDR(qno)));
+	dev_info(dev, "R[%d]_IN_INSTR_RSIZE[0x%llx]: 0x%016llx\n",
+		 qno, CN93_VF_SDP_R_IN_INSTR_RSIZE(qno),
+		 octep_vf_read_csr64(oct, CN93_VF_SDP_R_IN_INSTR_RSIZE(qno)));
+	dev_info(dev, "R[%d]_IN_CNTS[0x%llx]: 0x%016llx\n",
+		 qno, CN93_VF_SDP_R_IN_CNTS(qno),
+		 octep_vf_read_csr64(oct, CN93_VF_SDP_R_IN_CNTS(qno)));
+	dev_info(dev, "R[%d]_IN_INT_LEVELS[0x%llx]: 0x%016llx\n",
+		 qno, CN93_VF_SDP_R_IN_INT_LEVELS(qno),
+		 octep_vf_read_csr64(oct, CN93_VF_SDP_R_IN_INT_LEVELS(qno)));
+	dev_info(dev, "R[%d]_IN_PKT_CNT[0x%llx]: 0x%016llx\n",
+		 qno, CN93_VF_SDP_R_IN_PKT_CNT(qno),
+		 octep_vf_read_csr64(oct, CN93_VF_SDP_R_IN_PKT_CNT(qno)));
+	dev_info(dev, "R[%d]_IN_BYTE_CNT[0x%llx]: 0x%016llx\n",
+		 qno, CN93_VF_SDP_R_IN_BYTE_CNT(qno),
+		 octep_vf_read_csr64(oct, CN93_VF_SDP_R_IN_BYTE_CNT(qno)));
+
+	dev_info(dev, "OQ-%d register dump\n", qno);
+	dev_info(dev, "R[%d]_OUT_SLIST_DBELL[0x%llx]: 0x%016llx\n",
+		 qno, CN93_VF_SDP_R_OUT_SLIST_DBELL(qno),
+		 octep_vf_read_csr64(oct, CN93_VF_SDP_R_OUT_SLIST_DBELL(qno)));
+	dev_info(dev, "R[%d]_OUT_CONTROL[0x%llx]: 0x%016llx\n",
+		 qno, CN93_VF_SDP_R_OUT_CONTROL(qno),
+		 octep_vf_read_csr64(oct, CN93_VF_SDP_R_OUT_CONTROL(qno)));
+	dev_info(dev, "R[%d]_OUT_ENABLE[0x%llx]: 0x%016llx\n",
+		 qno, CN93_VF_SDP_R_OUT_ENABLE(qno),
+		 octep_vf_read_csr64(oct, CN93_VF_SDP_R_OUT_ENABLE(qno)));
+	dev_info(dev, "R[%d]_OUT_SLIST_BADDR[0x%llx]: 0x%016llx\n",
+		 qno, CN93_VF_SDP_R_OUT_SLIST_BADDR(qno),
+		 octep_vf_read_csr64(oct, CN93_VF_SDP_R_OUT_SLIST_BADDR(qno)));
+	dev_info(dev, "R[%d]_OUT_SLIST_RSIZE[0x%llx]: 0x%016llx\n",
+		 qno, CN93_VF_SDP_R_OUT_SLIST_RSIZE(qno),
+		 octep_vf_read_csr64(oct, CN93_VF_SDP_R_OUT_SLIST_RSIZE(qno)));
+	dev_info(dev, "R[%d]_OUT_CNTS[0x%llx]: 0x%016llx\n",
+		 qno, CN93_VF_SDP_R_OUT_CNTS(qno),
+		 octep_vf_read_csr64(oct, CN93_VF_SDP_R_OUT_CNTS(qno)));
+	dev_info(dev, "R[%d]_OUT_INT_LEVELS[0x%llx]: 0x%016llx\n",
+		 qno, CN93_VF_SDP_R_OUT_INT_LEVELS(qno),
+		 octep_vf_read_csr64(oct, CN93_VF_SDP_R_OUT_INT_LEVELS(qno)));
+	dev_info(dev, "R[%d]_OUT_PKT_CNT[0x%llx]: 0x%016llx\n",
+		 qno, CN93_VF_SDP_R_OUT_PKT_CNT(qno),
+		 octep_vf_read_csr64(oct, CN93_VF_SDP_R_OUT_PKT_CNT(qno)));
+	dev_info(dev, "R[%d]_OUT_BYTE_CNT[0x%llx]: 0x%016llx\n",
+		 qno, CN93_VF_SDP_R_OUT_BYTE_CNT(qno),
+		 octep_vf_read_csr64(oct, CN93_VF_SDP_R_OUT_BYTE_CNT(qno)));
+}
+
+/* Reset Hardware Tx queue */
+static int cn93_vf_reset_iq(struct octep_vf_device *oct, int q_no)
+{
+	u64 val = 0ULL;
+
+	dev_dbg(&oct->pdev->dev, "Reset VF IQ-%d\n", q_no);
+
+	/* Disable the Tx/Instruction Ring */
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_IN_ENABLE(q_no), val);
+
+	/* clear the Instruction Ring packet/byte counts and doorbell CSRs */
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_IN_INT_LEVELS(q_no), val);
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_IN_PKT_CNT(q_no), val);
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_IN_BYTE_CNT(q_no), val);
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_IN_INSTR_BADDR(q_no), val);
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_IN_INSTR_RSIZE(q_no), val);
+
+	val = 0xFFFFFFFF;
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_IN_INSTR_DBELL(q_no), val);
+
+	val = octep_vf_read_csr64(oct, CN93_VF_SDP_R_IN_CNTS(q_no));
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_IN_CNTS(q_no), val & 0xFFFFFFFF);
+
+	return 0;
+}
+
+/* Reset Hardware Rx queue */
+static void cn93_vf_reset_oq(struct octep_vf_device *oct, int q_no)
+{
+	u64 val = 0ULL;
+
+	/* Disable Output (Rx) Ring */
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_OUT_ENABLE(q_no), val);
+
+	/* Clear count CSRs */
+	val = octep_vf_read_csr(oct, CN93_VF_SDP_R_OUT_CNTS(q_no));
+	octep_vf_write_csr(oct, CN93_VF_SDP_R_OUT_CNTS(q_no), val);
+
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_OUT_PKT_CNT(q_no), 0xFFFFFFFFFULL);
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_OUT_SLIST_DBELL(q_no), 0xFFFFFFFF);
+}
+
 /* Reset all hardware Tx/Rx queues */
 static void octep_vf_reset_io_queues_cn93(struct octep_vf_device *oct)
 {
+	struct pci_dev *pdev = oct->pdev;
+	int q;
+
+	dev_dbg(&pdev->dev, "Reset OCTEP_CN93 VF IO Queues\n");
+
+	for (q = 0; q < CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf); q++) {
+		cn93_vf_reset_iq(oct, q);
+		cn93_vf_reset_oq(oct, q);
+	}
 }
 
 /* Initialize configuration limits and initial active config */
@@ -47,78 +162,294 @@ static void octep_vf_init_config_cn93_vf(struct octep_vf_device *oct)
 /* Setup registers for a hardware Tx Queue  */
 static void octep_vf_setup_iq_regs_cn93(struct octep_vf_device *oct, int iq_no)
 {
+	struct octep_vf_iq *iq = oct->iq[iq_no];
+	u32 reset_instr_cnt;
+	u64 reg_val;
+
+	reg_val = octep_vf_read_csr64(oct, CN93_VF_SDP_R_IN_CONTROL(iq_no));
+
+	/* wait for IDLE to set to 1 */
+	if (!(reg_val & CN93_VF_R_IN_CTL_IDLE)) {
+		do {
+			reg_val = octep_vf_read_csr64(oct, CN93_VF_SDP_R_IN_CONTROL(iq_no));
+		} while (!(reg_val & CN93_VF_R_IN_CTL_IDLE));
+	}
+	reg_val |= CN93_VF_R_IN_CTL_RDSIZE;
+	reg_val |= CN93_VF_R_IN_CTL_IS_64B;
+	reg_val |= CN93_VF_R_IN_CTL_ESR;
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_IN_CONTROL(iq_no), reg_val);
+
+	/* Write the start of the input queue's ring and its size  */
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_IN_INSTR_BADDR(iq_no), iq->desc_ring_dma);
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_IN_INSTR_RSIZE(iq_no), iq->max_count);
+
+	/* Remember the doorbell & instruction count register addr for this queue */
+	iq->doorbell_reg = oct->mmio.hw_addr + CN93_VF_SDP_R_IN_INSTR_DBELL(iq_no);
+	iq->inst_cnt_reg = oct->mmio.hw_addr + CN93_VF_SDP_R_IN_CNTS(iq_no);
+	iq->intr_lvl_reg = oct->mmio.hw_addr + CN93_VF_SDP_R_IN_INT_LEVELS(iq_no);
+
+	/* Store the current instruction counter (used in flush_iq calculation) */
+	reset_instr_cnt = readl(iq->inst_cnt_reg);
+	writel(reset_instr_cnt, iq->inst_cnt_reg);
+
+	/* INTR_THRESHOLD is set to max(FFFFFFFF) to disable the INTR */
+	reg_val = CFG_GET_IQ_INTR_THRESHOLD(oct->conf) & 0xffffffff;
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_IN_INT_LEVELS(iq_no), reg_val);
 }
 
 /* Setup registers for a hardware Rx Queue  */
 static void octep_vf_setup_oq_regs_cn93(struct octep_vf_device *oct, int oq_no)
 {
+	struct octep_vf_oq *oq = oct->oq[oq_no];
+	u32 time_threshold = 0;
+	u64 oq_ctl = 0ULL;
+	u64 reg_val;
+
+	reg_val = octep_vf_read_csr64(oct, CN93_VF_SDP_R_OUT_CONTROL(oq_no));
+
+	/* wait for IDLE to set to 1 */
+	if (!(reg_val & CN93_VF_R_OUT_CTL_IDLE)) {
+		do {
+			reg_val = octep_vf_read_csr64(oct, CN93_VF_SDP_R_OUT_CONTROL(oq_no));
+		} while (!(reg_val & CN93_VF_R_OUT_CTL_IDLE));
+	}
+
+	reg_val &= ~(CN93_VF_R_OUT_CTL_IMODE);
+	reg_val &= ~(CN93_VF_R_OUT_CTL_ROR_P);
+	reg_val &= ~(CN93_VF_R_OUT_CTL_NSR_P);
+	reg_val &= ~(CN93_VF_R_OUT_CTL_ROR_I);
+	reg_val &= ~(CN93_VF_R_OUT_CTL_NSR_I);
+	reg_val &= ~(CN93_VF_R_OUT_CTL_ES_I);
+	reg_val &= ~(CN93_VF_R_OUT_CTL_ROR_D);
+	reg_val &= ~(CN93_VF_R_OUT_CTL_NSR_D);
+	reg_val &= ~(CN93_VF_R_OUT_CTL_ES_D);
+	reg_val |= (CN93_VF_R_OUT_CTL_ES_P);
+
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_OUT_CONTROL(oq_no), reg_val);
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_OUT_SLIST_BADDR(oq_no), oq->desc_ring_dma);
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_OUT_SLIST_RSIZE(oq_no), oq->max_count);
+
+	oq_ctl = octep_vf_read_csr64(oct, CN93_VF_SDP_R_OUT_CONTROL(oq_no));
+	oq_ctl &= ~0x7fffffULL;	//clear the ISIZE and BSIZE (22-0)
+	oq_ctl |= (oq->buffer_size & 0xffff);	//populate the BSIZE (15-0)
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_OUT_CONTROL(oq_no), oq_ctl);
+
+	/* Get the mapped address of the pkt_sent and pkts_credit regs */
+	oq->pkts_sent_reg = oct->mmio.hw_addr + CN93_VF_SDP_R_OUT_CNTS(oq_no);
+	oq->pkts_credit_reg = oct->mmio.hw_addr + CN93_VF_SDP_R_OUT_SLIST_DBELL(oq_no);
+
+	time_threshold = CFG_GET_OQ_INTR_TIME(oct->conf);
+	reg_val = ((u64)time_threshold << 32) | CFG_GET_OQ_INTR_PKT(oct->conf);
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_OUT_INT_LEVELS(oq_no), reg_val);
 }
 
 /* Setup registers for a VF mailbox */
 static void octep_vf_setup_mbox_regs_cn93(struct octep_vf_device *oct, int q_no)
 {
+	struct octep_vf_mbox *mbox = oct->mbox;
+
+	/* PF to VF DATA reg. VF reads from this reg */
+	mbox->mbox_read_reg = oct->mmio.hw_addr + CN93_VF_SDP_R_MBOX_PF_VF_DATA(q_no);
+
+	/* VF mbox interrupt reg */
+	mbox->mbox_int_reg = oct->mmio.hw_addr + CN93_VF_SDP_R_MBOX_PF_VF_INT(q_no);
+
+	/* VF to PF DATA reg. VF writes into this reg */
+	mbox->mbox_write_reg = oct->mmio.hw_addr + CN93_VF_SDP_R_MBOX_VF_PF_DATA(q_no);
+}
+
+/* Mailbox Interrupt handler */
+static void cn93_handle_vf_mbox_intr(struct octep_vf_device *oct)
+{
+	if (oct->mbox)
+		schedule_work(&oct->mbox->wk.work);
+	else
+		dev_err(&oct->pdev->dev, "cannot schedule work on invalid mbox\n");
 }
 
 /* Tx/Rx queue interrupt handler */
 static irqreturn_t octep_vf_ioq_intr_handler_cn93(void *data)
 {
+	struct octep_vf_ioq_vector *vector = (struct octep_vf_ioq_vector *)data;
+	struct octep_vf_oq *oq = vector->oq;
+	struct octep_vf_device *oct = vector->octep_vf_dev;
+	u64 reg_val = 0ULL;
+
+	/* Mailbox interrupt arrives along with interrupt of tx/rx ring pair 0 */
+	if (oq->q_no == 0) {
+		reg_val = octep_vf_read_csr64(oct, CN93_VF_SDP_R_MBOX_PF_VF_INT(0));
+		if (reg_val & CN93_VF_SDP_R_MBOX_PF_VF_INT_STATUS) {
+			cn93_handle_vf_mbox_intr(oct);
+			octep_vf_write_csr64(oct, CN93_VF_SDP_R_MBOX_PF_VF_INT(0), reg_val);
+		}
+	}
+	napi_schedule_irqoff(oq->napi);
 	return IRQ_HANDLED;
 }
 
 /* Re-initialize Octeon hardware registers */
 static void octep_vf_reinit_regs_cn93(struct octep_vf_device *oct)
 {
+	u32 i;
+
+	for (i = 0; i < CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf); i++)
+		oct->hw_ops.setup_iq_regs(oct, i);
+
+	for (i = 0; i < CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf); i++)
+		oct->hw_ops.setup_oq_regs(oct, i);
+
+	oct->hw_ops.enable_interrupts(oct);
+	oct->hw_ops.enable_io_queues(oct);
+
+	for (i = 0; i < CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf); i++)
+		writel(oct->oq[i]->max_count, oct->oq[i]->pkts_credit_reg);
 }
 
 /* Enable all interrupts */
 static void octep_vf_enable_interrupts_cn93(struct octep_vf_device *oct)
 {
+	int num_rings, q;
+	u64 reg_val;
+
+	num_rings = CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf);
+	for (q = 0; q < num_rings; q++) {
+		reg_val = octep_vf_read_csr64(oct, CN93_VF_SDP_R_IN_INT_LEVELS(q));
+		reg_val |= (0x1ULL << 62);
+		octep_vf_write_csr64(oct, CN93_VF_SDP_R_IN_INT_LEVELS(q), reg_val);
+
+		reg_val = octep_vf_read_csr64(oct, CN93_VF_SDP_R_OUT_INT_LEVELS(q));
+		reg_val |= (0x1ULL << 62);
+		octep_vf_write_csr64(oct, CN93_VF_SDP_R_OUT_INT_LEVELS(q), reg_val);
+	}
+	/* Enable PF to VF mbox interrupt by setting 2nd bit*/
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_MBOX_PF_VF_INT(0),
+			     CN93_VF_SDP_R_MBOX_PF_VF_INT_ENAB);
 }
 
 /* Disable all interrupts */
 static void octep_vf_disable_interrupts_cn93(struct octep_vf_device *oct)
 {
+	int num_rings, q;
+	u64 reg_val;
+
+	/* Disable PF to VF mbox interrupt by setting 2nd bit*/
+	if (oct->mbox)
+		octep_vf_write_csr64(oct, CN93_VF_SDP_R_MBOX_PF_VF_INT(0), 0x0);
+
+	num_rings = CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf);
+	for (q = 0; q < num_rings; q++) {
+		reg_val = octep_vf_read_csr64(oct, CN93_VF_SDP_R_IN_INT_LEVELS(q));
+		reg_val &= ~(0x1ULL << 62);
+		octep_vf_write_csr64(oct, CN93_VF_SDP_R_IN_INT_LEVELS(q), reg_val);
+
+		reg_val = octep_vf_read_csr64(oct, CN93_VF_SDP_R_OUT_INT_LEVELS(q));
+		reg_val &= ~(0x1ULL << 62);
+		octep_vf_write_csr64(oct, CN93_VF_SDP_R_OUT_INT_LEVELS(q), reg_val);
+	}
 }
 
 /* Get new Octeon Read Index: index of descriptor that Octeon reads next. */
 static u32 octep_vf_update_iq_read_index_cn93(struct octep_vf_iq *iq)
 {
-	return 0;
+	u32 pkt_in_done = readl(iq->inst_cnt_reg);
+	u32 last_done, new_idx;
+
+	last_done = pkt_in_done - iq->pkt_in_done;
+	iq->pkt_in_done = pkt_in_done;
+
+	new_idx = (iq->octep_vf_read_index + last_done) % iq->max_count;
+
+	return new_idx;
 }
 
 /* Enable a hardware Tx Queue */
 static void octep_vf_enable_iq_cn93(struct octep_vf_device *oct, int iq_no)
 {
+	u64 loop = HZ;
+	u64 reg_val;
+
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_IN_INSTR_DBELL(iq_no), 0xFFFFFFFF);
+
+	while (octep_vf_read_csr64(oct, CN93_VF_SDP_R_IN_INSTR_DBELL(iq_no)) &&
+	       loop--) {
+		schedule_timeout_interruptible(1);
+	}
+
+	reg_val = octep_vf_read_csr64(oct,  CN93_VF_SDP_R_IN_INT_LEVELS(iq_no));
+	reg_val |= (0x1ULL << 62);
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_IN_INT_LEVELS(iq_no), reg_val);
+
+	reg_val = octep_vf_read_csr64(oct, CN93_VF_SDP_R_IN_ENABLE(iq_no));
+	reg_val |= 0x1ULL;
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_IN_ENABLE(iq_no), reg_val);
 }
 
 /* Enable a hardware Rx Queue */
 static void octep_vf_enable_oq_cn93(struct octep_vf_device *oct, int oq_no)
 {
+	u64 reg_val = 0ULL;
+
+	reg_val = octep_vf_read_csr64(oct,  CN93_VF_SDP_R_OUT_INT_LEVELS(oq_no));
+	reg_val |= (0x1ULL << 62);
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_OUT_INT_LEVELS(oq_no), reg_val);
+
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_OUT_SLIST_DBELL(oq_no), 0xFFFFFFFF);
+
+	reg_val = octep_vf_read_csr64(oct, CN93_VF_SDP_R_OUT_ENABLE(oq_no));
+	reg_val |= 0x1ULL;
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_OUT_ENABLE(oq_no), reg_val);
 }
 
 /* Enable all hardware Tx/Rx Queues assigned to VF */
 static void octep_vf_enable_io_queues_cn93(struct octep_vf_device *oct)
 {
+	u8 q;
+
+	for (q = 0; q < CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf); q++) {
+		octep_vf_enable_iq_cn93(oct, q);
+		octep_vf_enable_oq_cn93(oct, q);
+	}
 }
 
 /* Disable a hardware Tx Queue assigned to VF */
 static void octep_vf_disable_iq_cn93(struct octep_vf_device *oct, int iq_no)
 {
+	u64 reg_val = 0ULL;
+
+	reg_val = octep_vf_read_csr64(oct, CN93_VF_SDP_R_IN_ENABLE(iq_no));
+	reg_val &= ~0x1ULL;
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_IN_ENABLE(iq_no), reg_val);
 }
 
 /* Disable a hardware Rx Queue assigned to VF */
 static void octep_vf_disable_oq_cn93(struct octep_vf_device *oct, int oq_no)
 {
+	u64 reg_val = 0ULL;
+
+	reg_val = octep_vf_read_csr64(oct, CN93_VF_SDP_R_OUT_ENABLE(oq_no));
+	reg_val &= ~0x1ULL;
+	octep_vf_write_csr64(oct, CN93_VF_SDP_R_OUT_ENABLE(oq_no), reg_val);
 }
 
 /* Disable all hardware Tx/Rx Queues assigned to VF */
 static void octep_vf_disable_io_queues_cn93(struct octep_vf_device *oct)
 {
+	int q = 0;
+
+	for (q = 0; q < CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf); q++) {
+		octep_vf_disable_iq_cn93(oct, q);
+		octep_vf_disable_oq_cn93(oct, q);
+	}
 }
 
 /* Dump hardware registers (including Tx/Rx queues) for debugging. */
 static void octep_vf_dump_registers_cn93(struct octep_vf_device *oct)
 {
+	u8 num_rings, q;
+
+	num_rings = CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf);
+	for (q = 0; q < num_rings; q++)
+		cn93_vf_dump_q_regs(oct, q);
 }
 
 /**
-- 
2.36.0

