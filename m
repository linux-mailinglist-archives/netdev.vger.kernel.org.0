Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F4853ED7C
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 20:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiFFSEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 14:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiFFSDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 14:03:49 -0400
Received: from EX-PRD-EDGE02.vmware.com (EX-PRD-EDGE02.vmware.com [208.91.3.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADA51BD7D5;
        Mon,  6 Jun 2022 11:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:in-reply-to:mime-version:
      content-type;
    bh=yfiFBHS0DdQhUz04eMndislkSWwaoUlonL+u/bHmjUE=;
    b=cpbFFfSlk8xNbz04dMkq5RrnSA3/FWuhvth8VfXYuunro331tzqam/G6agBTde
      D3S5lwPFyx1ZhZqq4cXWj8/RfatsRuJm8jfImdpuWKIYTvAlMRwxrAwyUtrDc8
      4pP63J6+35LvOFYyKhOpuUegjtX7HsEZzyK/HNtxJDELlYs=
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX-PRD-EDGE02.vmware.com (10.188.245.7) with Microsoft SMTP Server id
 15.1.2308.14; Mon, 6 Jun 2022 11:03:36 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id D50EB202EE;
        Mon,  6 Jun 2022 11:03:41 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id CEC7BAA1E5; Mon,  6 Jun 2022 11:03:41 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 5/8] vmxnet3: add command to set ring buffer sizes
Date:   Mon, 6 Jun 2022 11:03:11 -0700
Message-ID: <20220606180316.27793-6-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220606180316.27793-1-doshir@vmware.com>
References: <20220606180316.27793-1-doshir@vmware.com>
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

This patch adds a new command to set ring buffer sizes. This is
required to pass the buffer size information to passthrough devices.
For performance reasons, with version7 and later, ring1 will contain
only mtu size buffers (bound to 3K). Packets > 3K will use both ring1
and ring2.

Also, ring sizes are round down to power of 2 and ring2 default
size is increased to 512.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_defs.h    | 11 +++++++
 drivers/net/vmxnet3/vmxnet3_drv.c     | 57 +++++++++++++++++++++++++++--------
 drivers/net/vmxnet3/vmxnet3_ethtool.c |  7 +++++
 drivers/net/vmxnet3/vmxnet3_int.h     |  3 +-
 4 files changed, 65 insertions(+), 13 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_defs.h b/drivers/net/vmxnet3/vmxnet3_defs.h
index 8d626611ab2d..415e4c9993ef 100644
--- a/drivers/net/vmxnet3/vmxnet3_defs.h
+++ b/drivers/net/vmxnet3/vmxnet3_defs.h
@@ -99,6 +99,9 @@ enum {
 	VMXNET3_CMD_SET_COALESCE,
 	VMXNET3_CMD_REGISTER_MEMREGS,
 	VMXNET3_CMD_SET_RSS_FIELDS,
+	VMXNET3_CMD_RESERVED4,
+	VMXNET3_CMD_RESERVED5,
+	VMXNET3_CMD_SET_RING_BUFFER_SIZE,
 
 	VMXNET3_CMD_FIRST_GET = 0xF00D0000,
 	VMXNET3_CMD_GET_QUEUE_STATUS = VMXNET3_CMD_FIRST_GET,
@@ -743,6 +746,13 @@ enum Vmxnet3_RSSField {
 	VMXNET3_RSS_FIELDS_ESPIP6 = 0x0020,
 };
 
+struct Vmxnet3_RingBufferSize {
+	__le16             ring1BufSizeType0;
+	__le16             ring1BufSizeType1;
+	__le16             ring2BufSizeType1;
+	__le16             pad;
+};
+
 /* If the command data <= 16 bytes, use the shared memory directly.
  * otherwise, use variable length configuration descriptor.
  */
@@ -750,6 +760,7 @@ union Vmxnet3_CmdInfo {
 	struct Vmxnet3_VariableLenConfDesc	varConf;
 	struct Vmxnet3_SetPolling		setPolling;
 	enum   Vmxnet3_RSSField                 setRssFields;
+	struct Vmxnet3_RingBufferSize           ringBufSize;
 	__le64					data[2];
 };
 
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 94ca3bc1d540..2ba263966989 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2681,6 +2681,23 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
 }
 
 static void
+vmxnet3_init_bufsize(struct vmxnet3_adapter *adapter)
+{
+	struct Vmxnet3_DriverShared *shared = adapter->shared;
+	union Vmxnet3_CmdInfo *cmdInfo = &shared->cu.cmdInfo;
+	unsigned long flags;
+
+	if (!VMXNET3_VERSION_GE_7(adapter))
+		return;
+
+	cmdInfo->ringBufSize = adapter->ringBufSize;
+	spin_lock_irqsave(&adapter->cmd_lock, flags);
+	VMXNET3_WRITE_BAR1_REG(adapter, VMXNET3_REG_CMD,
+			       VMXNET3_CMD_SET_RING_BUFFER_SIZE);
+	spin_unlock_irqrestore(&adapter->cmd_lock, flags);
+}
+
+static void
 vmxnet3_init_coalesce(struct vmxnet3_adapter *adapter)
 {
 	struct Vmxnet3_DriverShared *shared = adapter->shared;
@@ -2818,6 +2835,7 @@ vmxnet3_activate_dev(struct vmxnet3_adapter *adapter)
 		goto activate_err;
 	}
 
+	vmxnet3_init_bufsize(adapter);
 	vmxnet3_init_coalesce(adapter);
 	vmxnet3_init_rssfields(adapter);
 
@@ -2991,19 +3009,29 @@ static void
 vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
 {
 	size_t sz, i, ring0_size, ring1_size, comp_size;
-	if (adapter->netdev->mtu <= VMXNET3_MAX_SKB_BUF_SIZE -
-				    VMXNET3_MAX_ETH_HDR_SIZE) {
-		adapter->skb_buf_size = adapter->netdev->mtu +
-					VMXNET3_MAX_ETH_HDR_SIZE;
-		if (adapter->skb_buf_size < VMXNET3_MIN_T0_BUF_SIZE)
-			adapter->skb_buf_size = VMXNET3_MIN_T0_BUF_SIZE;
-
-		adapter->rx_buf_per_pkt = 1;
+	/* With version7 ring1 will have only T0 buffers */
+	if (!VMXNET3_VERSION_GE_7(adapter)) {
+		if (adapter->netdev->mtu <= VMXNET3_MAX_SKB_BUF_SIZE -
+					    VMXNET3_MAX_ETH_HDR_SIZE) {
+			adapter->skb_buf_size = adapter->netdev->mtu +
+						VMXNET3_MAX_ETH_HDR_SIZE;
+			if (adapter->skb_buf_size < VMXNET3_MIN_T0_BUF_SIZE)
+				adapter->skb_buf_size = VMXNET3_MIN_T0_BUF_SIZE;
+
+			adapter->rx_buf_per_pkt = 1;
+		} else {
+			adapter->skb_buf_size = VMXNET3_MAX_SKB_BUF_SIZE;
+			sz = adapter->netdev->mtu - VMXNET3_MAX_SKB_BUF_SIZE +
+						    VMXNET3_MAX_ETH_HDR_SIZE;
+			adapter->rx_buf_per_pkt = 1 + (sz + PAGE_SIZE - 1) / PAGE_SIZE;
+		}
 	} else {
-		adapter->skb_buf_size = VMXNET3_MAX_SKB_BUF_SIZE;
-		sz = adapter->netdev->mtu - VMXNET3_MAX_SKB_BUF_SIZE +
-					    VMXNET3_MAX_ETH_HDR_SIZE;
-		adapter->rx_buf_per_pkt = 1 + (sz + PAGE_SIZE - 1) / PAGE_SIZE;
+		adapter->skb_buf_size = min((int)adapter->netdev->mtu + VMXNET3_MAX_ETH_HDR_SIZE,
+					    VMXNET3_MAX_SKB_BUF_SIZE);
+		adapter->rx_buf_per_pkt = 1;
+		adapter->ringBufSize.ring1BufSizeType0 = adapter->skb_buf_size;
+		adapter->ringBufSize.ring1BufSizeType1 = 0;
+		adapter->ringBufSize.ring2BufSizeType1 = PAGE_SIZE;
 	}
 
 	/*
@@ -3019,6 +3047,11 @@ vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
 	ring1_size = (ring1_size + sz - 1) / sz * sz;
 	ring1_size = min_t(u32, ring1_size, VMXNET3_RX_RING2_MAX_SIZE /
 			   sz * sz);
+	/* For v7 and later, keep ring size power of 2 for UPT */
+	if (VMXNET3_VERSION_GE_7(adapter)) {
+		ring0_size = rounddown_pow_of_two(ring0_size);
+		ring1_size = rounddown_pow_of_two(ring1_size);
+	}
 	comp_size = ring0_size + ring1_size;
 
 	for (i = 0; i < adapter->num_rx_queues; i++) {
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index a755199f0176..b5568070b1b5 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -718,6 +718,13 @@ vmxnet3_set_ringparam(struct net_device *netdev,
 	new_rx_ring2_size = min_t(u32, new_rx_ring2_size,
 				  VMXNET3_RX_RING2_MAX_SIZE);
 
+	/* For v7 and later, keep ring size power of 2 for UPT */
+	if (VMXNET3_VERSION_GE_7(adapter)) {
+		new_tx_ring_size = rounddown_pow_of_two(new_tx_ring_size);
+		new_rx_ring_size = rounddown_pow_of_two(new_rx_ring_size);
+		new_rx_ring2_size = rounddown_pow_of_two(new_rx_ring2_size);
+	}
+
 	/* rx data ring buffer size has to be a multiple of
 	 * VMXNET3_RXDATA_DESC_SIZE_ALIGN
 	 */
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 5b495ef253e8..cb87731f5f1c 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -408,6 +408,7 @@ struct vmxnet3_adapter {
 	dma_addr_t pm_conf_pa;
 	dma_addr_t rss_conf_pa;
 	bool   queuesExtEnabled;
+	struct Vmxnet3_RingBufferSize     ringBufSize;
 	u32    devcap_supported[8];
 	u32    ptcap_supported[8];
 	u32    dev_caps[8];
@@ -449,7 +450,7 @@ struct vmxnet3_adapter {
 /* must be a multiple of VMXNET3_RING_SIZE_ALIGN */
 #define VMXNET3_DEF_TX_RING_SIZE    512
 #define VMXNET3_DEF_RX_RING_SIZE    1024
-#define VMXNET3_DEF_RX_RING2_SIZE   256
+#define VMXNET3_DEF_RX_RING2_SIZE   512
 
 #define VMXNET3_DEF_RXDATA_DESC_SIZE 128
 
-- 
2.11.0

