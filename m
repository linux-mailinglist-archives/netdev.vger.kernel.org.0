Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EB95426D4
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbiFHGA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 02:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbiFHFtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 01:49:06 -0400
Received: from EX-PRD-EDGE02.vmware.com (ex-prd-edge02.vmware.com [208.91.3.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EF122BAD2;
        Tue,  7 Jun 2022 20:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:in-reply-to:mime-version:
      content-type;
    bh=Iek9hW54QhGw2V/2phmsOs4cdU2tFOpvP/eViuA1UH4=;
    b=QSAvjUitIkzuYEWf/jNEmVRPSVBQEn21x89YXAnLZ52l7UYJllvfhwO42pSVY/
      8TWryEEFrsPDCCdxnOxsgZbrGN7yw4KdEkaXEB9SkDqrx+slvBKIeo2A5jWhz7
      HCpdgwR5/62vm/uHf+B5lvDjF7R5NG/wHXHj2gX+rfV4FQc=
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX-PRD-EDGE02.vmware.com (10.188.245.7) with Microsoft SMTP Server id
 15.1.2308.14; Tue, 7 Jun 2022 20:23:58 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 1DB782032A;
        Tue,  7 Jun 2022 20:24:04 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id 1593DAA454; Tue,  7 Jun 2022 20:24:04 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 net-next 3/8] vmxnet3: add support for large passthrough BAR register
Date:   Tue, 7 Jun 2022 20:23:48 -0700
Message-ID: <20220608032353.964-4-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220608032353.964-1-doshir@vmware.com>
References: <20220608032353.964-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX-PRD-EDGE02.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For vmxnet3 to work in UPT mode, the BAR sizes have been increased.
The PT page has been extended to 2 pages and also includes OOB pages
as a part of PT BAR. This patch enhances vmxnet3 to use appropriate
BAR offsets based on the capability registered. To use new offsets,
VMXNET3_CAP_LARGE_BAR needs to be set by the device. If it is not set
then the device will use legacy PT page layout.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_defs.h    | 14 ++++++++++++--
 drivers/net/vmxnet3/vmxnet3_drv.c     | 25 ++++++++++++++++++++-----
 drivers/net/vmxnet3/vmxnet3_ethtool.c |  6 +++---
 drivers/net/vmxnet3/vmxnet3_int.h     |  3 +++
 4 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_defs.h b/drivers/net/vmxnet3/vmxnet3_defs.h
index 0157155ff677..8d626611ab2d 100644
--- a/drivers/net/vmxnet3/vmxnet3_defs.h
+++ b/drivers/net/vmxnet3/vmxnet3_defs.h
@@ -57,8 +57,18 @@ enum {
 	VMXNET3_REG_RXPROD2	= 0xA00	 /* Rx Producer Index for ring 2 */
 };
 
-#define VMXNET3_PT_REG_SIZE     4096	/* BAR 0 */
-#define VMXNET3_VD_REG_SIZE     4096	/* BAR 1 */
+/* For Large PT BAR, the following offset to DB register */
+enum {
+	VMXNET3_REG_LB_TXPROD   = 0x1000, /* Tx Producer Index */
+	VMXNET3_REG_LB_RXPROD   = 0x1400, /* Rx Producer Index for ring 1 */
+	VMXNET3_REG_LB_RXPROD2  = 0x1800, /* Rx Producer Index for ring 2 */
+};
+
+#define VMXNET3_PT_REG_SIZE         4096		/* BAR 0 */
+#define VMXNET3_LARGE_PT_REG_SIZE   8192		/* large PT pages */
+#define VMXNET3_VD_REG_SIZE         4096		/* BAR 1 */
+#define VMXNET3_LARGE_BAR0_REG_SIZE (4096 * 4096)	/* LARGE BAR 0 */
+#define VMXNET3_OOB_REG_SIZE        (4094 * 4096)	/* OOB pages */
 
 #define VMXNET3_REG_ALIGN       8	/* All registers are 8-byte aligned. */
 #define VMXNET3_REG_ALIGN_MASK  0x7
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index edc4f23d4965..93f237db463d 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1207,7 +1207,7 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 	if (tx_num_deferred >= le32_to_cpu(tq->shared->txThreshold)) {
 		tq->shared->txNumDeferred = 0;
 		VMXNET3_WRITE_BAR0_REG(adapter,
-				       VMXNET3_REG_TXPROD + tq->qid * 8,
+				       adapter->tx_prod_offset + tq->qid * 8,
 				       tq->tx_ring.next2fill);
 	}
 
@@ -1359,8 +1359,8 @@ static int
 vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 		       struct vmxnet3_adapter *adapter, int quota)
 {
-	static const u32 rxprod_reg[2] = {
-		VMXNET3_REG_RXPROD, VMXNET3_REG_RXPROD2
+	u32 rxprod_reg[2] = {
+		adapter->rx_prod_offset, adapter->rx_prod2_offset
 	};
 	u32 num_pkts = 0;
 	bool skip_page_frags = false;
@@ -2783,9 +2783,9 @@ vmxnet3_activate_dev(struct vmxnet3_adapter *adapter)
 
 	for (i = 0; i < adapter->num_rx_queues; i++) {
 		VMXNET3_WRITE_BAR0_REG(adapter,
-				VMXNET3_REG_RXPROD + i * VMXNET3_REG_ALIGN,
+				adapter->rx_prod_offset + i * VMXNET3_REG_ALIGN,
 				adapter->rx_queue[i].rx_ring[0].next2fill);
-		VMXNET3_WRITE_BAR0_REG(adapter, (VMXNET3_REG_RXPROD2 +
+		VMXNET3_WRITE_BAR0_REG(adapter, (adapter->rx_prod2_offset +
 				(i * VMXNET3_REG_ALIGN)),
 				adapter->rx_queue[i].rx_ring[1].next2fill);
 	}
@@ -3608,6 +3608,10 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 	if (VMXNET3_VERSION_GE_7(adapter)) {
 		adapter->devcap_supported[0] = VMXNET3_READ_BAR1_REG(adapter, VMXNET3_REG_DCR);
 		adapter->ptcap_supported[0] = VMXNET3_READ_BAR1_REG(adapter, VMXNET3_REG_PTCR);
+		if (adapter->devcap_supported[0] & (1UL << VMXNET3_CAP_LARGE_BAR)) {
+			adapter->dev_caps[0] = adapter->devcap_supported[0] &
+							(1UL << VMXNET3_CAP_LARGE_BAR);
+		}
 		if (adapter->dev_caps[0])
 			VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_DCR, adapter->dev_caps[0]);
 
@@ -3617,6 +3621,17 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 		spin_unlock_irqrestore(&adapter->cmd_lock, flags);
 	}
 
+	if (VMXNET3_VERSION_GE_7(adapter) &&
+	    adapter->dev_caps[0] & (1UL << VMXNET3_CAP_LARGE_BAR)) {
+		adapter->tx_prod_offset = VMXNET3_REG_LB_TXPROD;
+		adapter->rx_prod_offset = VMXNET3_REG_LB_RXPROD;
+		adapter->rx_prod2_offset = VMXNET3_REG_LB_RXPROD2;
+	} else {
+		adapter->tx_prod_offset = VMXNET3_REG_TXPROD;
+		adapter->rx_prod_offset = VMXNET3_REG_RXPROD;
+		adapter->rx_prod2_offset = VMXNET3_REG_RXPROD2;
+	}
+
 	if (VMXNET3_VERSION_GE_6(adapter)) {
 		spin_lock_irqsave(&adapter->cmd_lock, flags);
 		VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 458f2da1ebab..397b268f7bc5 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -520,7 +520,7 @@ vmxnet3_get_regs(struct net_device *netdev, struct ethtool_regs *regs, void *p)
 	for (i = 0; i < adapter->num_tx_queues; i++) {
 		struct vmxnet3_tx_queue *tq = &adapter->tx_queue[i];
 
-		buf[j++] = VMXNET3_READ_BAR0_REG(adapter, VMXNET3_REG_TXPROD +
+		buf[j++] = VMXNET3_READ_BAR0_REG(adapter, adapter->tx_prod_offset +
 						 i * VMXNET3_REG_ALIGN);
 
 		buf[j++] = VMXNET3_GET_ADDR_LO(tq->tx_ring.basePA);
@@ -548,9 +548,9 @@ vmxnet3_get_regs(struct net_device *netdev, struct ethtool_regs *regs, void *p)
 	for (i = 0; i < adapter->num_rx_queues; i++) {
 		struct vmxnet3_rx_queue *rq = &adapter->rx_queue[i];
 
-		buf[j++] =  VMXNET3_READ_BAR0_REG(adapter, VMXNET3_REG_RXPROD +
+		buf[j++] =  VMXNET3_READ_BAR0_REG(adapter, adapter->rx_prod_offset +
 						  i * VMXNET3_REG_ALIGN);
-		buf[j++] =  VMXNET3_READ_BAR0_REG(adapter, VMXNET3_REG_RXPROD2 +
+		buf[j++] =  VMXNET3_READ_BAR0_REG(adapter, adapter->rx_prod2_offset +
 						  i * VMXNET3_REG_ALIGN);
 
 		buf[j++] = VMXNET3_GET_ADDR_LO(rq->rx_ring[0].basePA);
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index a7c8f80702c2..a4f832f0ad5b 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -406,6 +406,9 @@ struct vmxnet3_adapter {
 	u32    devcap_supported[8];
 	u32    ptcap_supported[8];
 	u32    dev_caps[8];
+	u16    tx_prod_offset;
+	u16    rx_prod_offset;
+	u16    rx_prod2_offset;
 };
 
 #define VMXNET3_WRITE_BAR0_REG(adapter, reg, val)  \
-- 
2.11.0

