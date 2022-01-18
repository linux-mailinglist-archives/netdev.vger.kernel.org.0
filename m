Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D31D4919E6
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343983AbiARC5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345433AbiARCsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:48:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEEBC061574;
        Mon, 17 Jan 2022 18:39:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EC80B8123A;
        Tue, 18 Jan 2022 02:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA70C36AEF;
        Tue, 18 Jan 2022 02:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473568;
        bh=cW6i1+FYbM41Py1EygcwC6wNPoFKzRktOYZzcq8jPVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5FPIh/A58JQuc2hueBNz4txWTXcFj0xtSn6PpLUuOZQcJNiFTEAyVTpRerdo55CM
         EDU/cXFDi5iWURo7CXhs6V0sx4sizmo4N4goLVZ3Vm4bQnyaPUXmkuApV82BBGkK8y
         TS/E7E22KDV/XnX1cG2u/Xxnr0pzhDqLhqKKxNHBgu7/wcUV+bmV0m1M84soWmI38G
         AbWV9qqZc4aQN/VVfrGdOc6odp3bHHrqNQhe62HPZ/sEztsWePhH6UzD/NXSenrTwl
         3tr9agbf8UAHN8oS3DA7VAHywwrLoZCUksZVcKGYRjcQ3eBzhsbeew7SkhJuRQvA1O
         lZ4a4tsl6R5mg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, petrm@nvidia.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 171/188] mlxsw: pci: Avoid flow control for EMAD packets
Date:   Mon, 17 Jan 2022 21:31:35 -0500
Message-Id: <20220118023152.1948105-171-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit d43e4271747ace01a27a49a97a397cb4219f6487 ]

Locally generated packets ingress the device through its CPU port. When
the CPU port is congested and there are not enough credits in its
headroom buffer, packets can be dropped.

While this might be acceptable for data packets that traverse the
network, configuration packets exchanged between the host and the device
(EMADs) should not be subjected to this flow control.

The "sdq_lp" bit in the SDQ (Send Descriptor Queue) context allows the
host to instruct the device to treat packets sent on this queue as
"local processing" and always process them, regardless of the state of
the CPU port's headroom.

Add the definition of this bit and set it for the dedicated SDQ reserved
for the transmission of EMAD packets. This makes the "local processing"
bit in the WQE (Work Queue Element) redundant, so clear it.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/cmd.h | 12 ++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/pci.c |  6 +++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/cmd.h b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
index 392ce3cb27f72..51b260d54237e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/cmd.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
@@ -935,6 +935,18 @@ static inline int mlxsw_cmd_sw2hw_rdq(struct mlxsw_core *mlxsw_core,
  */
 MLXSW_ITEM32(cmd_mbox, sw2hw_dq, cq, 0x00, 24, 8);
 
+enum mlxsw_cmd_mbox_sw2hw_dq_sdq_lp {
+	MLXSW_CMD_MBOX_SW2HW_DQ_SDQ_LP_WQE,
+	MLXSW_CMD_MBOX_SW2HW_DQ_SDQ_LP_IGNORE_WQE,
+};
+
+/* cmd_mbox_sw2hw_dq_sdq_lp
+ * SDQ local Processing
+ * 0: local processing by wqe.lp
+ * 1: local processing (ignoring wqe.lp)
+ */
+MLXSW_ITEM32(cmd_mbox, sw2hw_dq, sdq_lp, 0x00, 23, 1);
+
 /* cmd_mbox_sw2hw_dq_sdq_tclass
  * SDQ: CPU Egress TClass
  * RDQ: Reserved
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 01c3235ab2bdf..d9f9cbba62465 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -285,6 +285,7 @@ static int mlxsw_pci_sdq_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
 			      struct mlxsw_pci_queue *q)
 {
 	int tclass;
+	int lp;
 	int i;
 	int err;
 
@@ -292,9 +293,12 @@ static int mlxsw_pci_sdq_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
 	q->consumer_counter = 0;
 	tclass = q->num == MLXSW_PCI_SDQ_EMAD_INDEX ? MLXSW_PCI_SDQ_EMAD_TC :
 						      MLXSW_PCI_SDQ_CTL_TC;
+	lp = q->num == MLXSW_PCI_SDQ_EMAD_INDEX ? MLXSW_CMD_MBOX_SW2HW_DQ_SDQ_LP_IGNORE_WQE :
+						  MLXSW_CMD_MBOX_SW2HW_DQ_SDQ_LP_WQE;
 
 	/* Set CQ of same number of this SDQ. */
 	mlxsw_cmd_mbox_sw2hw_dq_cq_set(mbox, q->num);
+	mlxsw_cmd_mbox_sw2hw_dq_sdq_lp_set(mbox, lp);
 	mlxsw_cmd_mbox_sw2hw_dq_sdq_tclass_set(mbox, tclass);
 	mlxsw_cmd_mbox_sw2hw_dq_log2_dq_sz_set(mbox, 3); /* 8 pages */
 	for (i = 0; i < MLXSW_PCI_AQ_PAGES; i++) {
@@ -1678,7 +1682,7 @@ static int mlxsw_pci_skb_transmit(void *bus_priv, struct sk_buff *skb,
 
 	wqe = elem_info->elem;
 	mlxsw_pci_wqe_c_set(wqe, 1); /* always report completion */
-	mlxsw_pci_wqe_lp_set(wqe, !!tx_info->is_emad);
+	mlxsw_pci_wqe_lp_set(wqe, 0);
 	mlxsw_pci_wqe_type_set(wqe, MLXSW_PCI_WQE_TYPE_ETHERNET);
 
 	err = mlxsw_pci_wqe_frag_map(mlxsw_pci, wqe, 0, skb->data,
-- 
2.34.1

