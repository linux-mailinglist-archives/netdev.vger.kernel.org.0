Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52625C9805
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 07:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbfJCFqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 01:46:16 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59217 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727409AbfJCFqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 01:46:16 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D2A7322083;
        Thu,  3 Oct 2019 01:46:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 03 Oct 2019 01:46:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=nhrCK29SaMeP3cl4Y
        oQo5myt5ig+rC6EFtG9ztUDDFA=; b=0RH5HL1UhknBjvo/YeagCkoQDJiBjHhXr
        hvxLRlblcPRd8yM5aTfnoqbKl6tLw6B2dESWgVRWCKuxNyGdhWFdfGv80FolExJe
        CkryhYEf/RDMZuDd3earoxCDHrnxUAZGPJ7XeBcqyiXlps+abfL2OMcslw6WuHCI
        AWdt3afo4eYTqFvwn8Xxh9nr3N6MEFZKC4LDgIe4MxvnwkMvdBox4HYfquuQ7+Ub
        y8rdpn5QstlcqqBzrFXe91/Yx4W9Ff9FEOWbcV+Fk6HG0+n1jKHfFYc7u99sJOyZ
        J1L4tBuN3cUcHaRN2mj9+JWPVJsQnRnjY0oGv5bgLQmIs53TlLi/g==
X-ME-Sender: <xms:JYuVXUZV5gp52psZeKTjUI2hr3oWUm22xFT-EXmGzrkkpYhN60-DFg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeejgdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:JYuVXWqArqz4pW7VVhl0eEXJT2udDwx27mJrbt0EDSNaCPxVjOVjXA>
    <xmx:JYuVXZ0w5Ms-fzfagwWa1fllz-WxiPCB3f15rWte9kfEiS_0RcXrZQ>
    <xmx:JYuVXelI_OlkMUehgSoO9VoBH0nnwwXC57lAQIrdIeM1zNxeIOHCiw>
    <xmx:JouVXfR9-k1DqoXAzXEHDHVEWdTWr74kFOisyJE84vaVvVCnvm5DnA>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D1417D6005E;
        Thu,  3 Oct 2019 01:46:11 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next] mlxsw: PCI: Send EMAD traffic on a separate queue
Date:   Thu,  3 Oct 2019 08:44:49 +0300
Message-Id: <20191003054449.8659-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Currently mlxsw distributes sent traffic among all the available send
queues. That includes control traffic as well as EMADs, which are used for
configuration of the device.

However because all the queues have the same traffic class of 3, they all
end up being directed to the same traffic class buffer. If the control
traffic in the buffer cannot be serviced quickly enough, the EMAD traffic
might be shut out, which causes transient failures, typically in FDB
maintenance, counter upkeep and other periodic work.

To address this issue, dedicate SDQ 0 to EMAD traffic, with TC 0.
Distribute the control traffic among the remaining queues, which are left
with their current TC 3.

Suggested-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c    | 16 ++++++++++++++--
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h |  5 +++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 615455a21567..f1294b00efdf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -284,15 +284,18 @@ static dma_addr_t __mlxsw_pci_queue_page_get(struct mlxsw_pci_queue *q,
 static int mlxsw_pci_sdq_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
 			      struct mlxsw_pci_queue *q)
 {
+	int tclass;
 	int i;
 	int err;
 
 	q->producer_counter = 0;
 	q->consumer_counter = 0;
+	tclass = q->num == MLXSW_PCI_SDQ_EMAD_INDEX ? MLXSW_PCI_SDQ_EMAD_TC :
+						      MLXSW_PCI_SDQ_CTL_TC;
 
 	/* Set CQ of same number of this SDQ. */
 	mlxsw_cmd_mbox_sw2hw_dq_cq_set(mbox, q->num);
-	mlxsw_cmd_mbox_sw2hw_dq_sdq_tclass_set(mbox, 3);
+	mlxsw_cmd_mbox_sw2hw_dq_sdq_tclass_set(mbox, tclass);
 	mlxsw_cmd_mbox_sw2hw_dq_log2_dq_sz_set(mbox, 3); /* 8 pages */
 	for (i = 0; i < MLXSW_PCI_AQ_PAGES; i++) {
 		dma_addr_t mapaddr = __mlxsw_pci_queue_page_get(q, i);
@@ -963,6 +966,7 @@ static int mlxsw_pci_aqs_init(struct mlxsw_pci *mlxsw_pci, char *mbox)
 	eq_log2sz = mlxsw_cmd_mbox_query_aq_cap_log_max_eq_sz_get(mbox);
 
 	if (num_sdqs + num_rdqs > num_cqs ||
+	    num_sdqs < MLXSW_PCI_SDQS_MIN ||
 	    num_cqs > MLXSW_PCI_CQS_MAX || num_eqs != MLXSW_PCI_EQS_COUNT) {
 		dev_err(&pdev->dev, "Unsupported number of queues\n");
 		return -EINVAL;
@@ -1520,7 +1524,15 @@ static struct mlxsw_pci_queue *
 mlxsw_pci_sdq_pick(struct mlxsw_pci *mlxsw_pci,
 		   const struct mlxsw_tx_info *tx_info)
 {
-	u8 sdqn = tx_info->local_port % mlxsw_pci_sdq_count(mlxsw_pci);
+	u8 ctl_sdq_count = mlxsw_pci_sdq_count(mlxsw_pci) - 1;
+	u8 sdqn;
+
+	if (tx_info->is_emad) {
+		sdqn = MLXSW_PCI_SDQ_EMAD_INDEX;
+	} else {
+		BUILD_BUG_ON(MLXSW_PCI_SDQ_EMAD_INDEX != 0);
+		sdqn = 1 + (tx_info->local_port % ctl_sdq_count);
+	}
 
 	return mlxsw_pci_sdq_get(mlxsw_pci, sdqn);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
index e57e42e2d2b2..2b3aec482742 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
@@ -51,6 +51,11 @@
 #define MLXSW_PCI_EQ_ASYNC_NUM	0
 #define MLXSW_PCI_EQ_COMP_NUM	1
 
+#define MLXSW_PCI_SDQS_MIN	2 /* EMAD and control traffic */
+#define MLXSW_PCI_SDQ_EMAD_INDEX	0
+#define MLXSW_PCI_SDQ_EMAD_TC	0
+#define MLXSW_PCI_SDQ_CTL_TC	3
+
 #define MLXSW_PCI_AQ_PAGES	8
 #define MLXSW_PCI_AQ_SIZE	(MLXSW_PCI_PAGE_SIZE * MLXSW_PCI_AQ_PAGES)
 #define MLXSW_PCI_WQE_SIZE	32 /* 32 bytes per element */
-- 
2.21.0

