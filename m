Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB16C106B07
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 11:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbfKVKkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 05:40:43 -0500
Received: from smtp.broadcom.com ([192.19.232.149]:40310 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1728919AbfKVKkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 05:40:42 -0500
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Nov 2019 05:40:41 EST
Received: from dhcp-10-123-153-22.dhcp.broadcom.net (bgccx-dev-host-lnx2.bec.broadcom.net [10.123.153.22])
        by relay.smtp.broadcom.com (Postfix) with ESMTP id 348EB1BB0C5;
        Fri, 22 Nov 2019 02:32:25 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.10.3 relay.smtp.broadcom.com 348EB1BB0C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1574418747;
        bh=GHcylQZvoUp6RDeJ08RGL2Df/VrfNllonsxxSxhGYQo=;
        h=From:To:Subject:Date:From;
        b=gUrC0nalChudx0z7GCogtLRVCFBdgZP+1SWw13OVMviVeKGGuIuMwEdQKI4NedNuZ
         +vPi6RFgNZA3kigq2y1ZrJUken0yzYG9eoouj1LgyJc8yNQgX1FoGrOGzV2Em0dqUZ
         9BKTzrsK6Gs7ei9hi3dGFRHlU1z66IDy04I0Js38=
From:   Kalesh A P <kalesh-anakkur.purayil@broadcom.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH net-next] be2net: gather more debug info and display on a tx-timeout
Date:   Fri, 22 Nov 2019 16:13:52 +0530
Message-Id: <20191122104352.3864-1-kalesh-anakkur.purayil@broadcom.com>
X-Mailer: git-send-email 2.10.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

In order to start recording the last few tx wqes and
tx completions, user has to set the msg level to non-zero
value using "ethtool -s ethX msglvl 1"

This patch does the following things:
1. record last 200 WQE information
2. record first 128 bytes of last 200 TX packets
3. record last 200 TX completion info
4. On TX timeout, log these information for debugging

Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>
---
 drivers/net/ethernet/emulex/benet/be.h      |  92 ++++++++++++++--------
 drivers/net/ethernet/emulex/benet/be_main.c | 116 ++++++++++++++++++++++++++++
 2 files changed, 174 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be.h b/drivers/net/ethernet/emulex/benet/be.h
index cf3e6f2..7a05adb 100644
--- a/drivers/net/ethernet/emulex/benet/be.h
+++ b/drivers/net/ethernet/emulex/benet/be.h
@@ -227,6 +227,60 @@ struct be_tx_stats {
 	struct u64_stats_sync sync_compl;
 };
 
+/* Macros to read/write the 'features' word of be_wrb_params structure.
+ */
+#define	BE_WRB_F_BIT(name)			BE_WRB_F_##name##_BIT
+#define	BE_WRB_F_MASK(name)			BIT_MASK(BE_WRB_F_##name##_BIT)
+
+#define	BE_WRB_F_GET(word, name)	\
+	(((word) & (BE_WRB_F_MASK(name))) >> BE_WRB_F_BIT(name))
+
+#define	BE_WRB_F_SET(word, name, val)	\
+	((word) |= (((val) << BE_WRB_F_BIT(name)) & BE_WRB_F_MASK(name)))
+
+/* Feature/offload bits */
+enum {
+	BE_WRB_F_CRC_BIT,		/* Ethernet CRC */
+	BE_WRB_F_IPCS_BIT,		/* IP csum */
+	BE_WRB_F_TCPCS_BIT,		/* TCP csum */
+	BE_WRB_F_UDPCS_BIT,		/* UDP csum */
+	BE_WRB_F_LSO_BIT,		/* LSO */
+	BE_WRB_F_LSO6_BIT,		/* LSO6 */
+	BE_WRB_F_VLAN_BIT,		/* VLAN */
+	BE_WRB_F_VLAN_SKIP_HW_BIT,	/* Skip VLAN tag (workaround) */
+	BE_WRB_F_OS2BMC_BIT		/* Send packet to the management ring */
+};
+
+/* The structure below provides a HW-agnostic abstraction of WRB params
+ * retrieved from a TX skb. This is in turn passed to chip specific routines
+ * during transmit, to set the corresponding params in the WRB.
+ */
+struct be_wrb_params {
+	u32 features;	/* Feature bits */
+	u16 vlan_tag;	/* VLAN tag */
+	u16 lso_mss;	/* MSS for LSO */
+};
+
+/* Store latest 200 occurrences */
+#define BE_TXQ_INFO_LEN		200
+#define PKT_DUMP_SIZE		128
+
+struct be_tx_pktinfo {
+	u16 head;
+	u16 tail;
+	u16 used;
+	struct be_wrb_params wqe_hdr;
+	u8 skb_data[PKT_DUMP_SIZE];
+	u32 len;
+	u32 skb_len;
+	bool valid;
+};
+
+struct be_tx_dump_cmpl {
+	u32 info[32];
+	bool valid;
+};
+
 /* Structure to hold some data of interest obtained from a TX CQE */
 struct be_tx_compl_info {
 	u8 status;		/* Completion status */
@@ -244,6 +298,10 @@ struct be_tx_obj {
 	u16 pend_wrb_cnt;	/* Number of WRBs yet to be given to HW */
 	u16 last_req_wrb_cnt;	/* wrb cnt of the last req in the Q */
 	u16 last_req_hdr;	/* index of the last req's hdr-wrb */
+	struct be_tx_pktinfo tx_pktinfo[BE_TXQ_INFO_LEN];
+	struct be_tx_dump_cmpl cmpl_info[BE_TXQ_INFO_LEN];
+	u32 tx_wqe_offset;
+	u32 tx_cmpl_idx;
 } ____cacheline_aligned_in_smp;
 
 /* Struct to remember the pages posted for rx frags */
@@ -444,40 +502,6 @@ struct be_hwmon {
 	u8 be_on_die_temp;  /* Unit: millidegree Celsius */
 };
 
-/* Macros to read/write the 'features' word of be_wrb_params structure.
- */
-#define	BE_WRB_F_BIT(name)			BE_WRB_F_##name##_BIT
-#define	BE_WRB_F_MASK(name)			BIT_MASK(BE_WRB_F_##name##_BIT)
-
-#define	BE_WRB_F_GET(word, name)	\
-	(((word) & (BE_WRB_F_MASK(name))) >> BE_WRB_F_BIT(name))
-
-#define	BE_WRB_F_SET(word, name, val)	\
-	((word) |= (((val) << BE_WRB_F_BIT(name)) & BE_WRB_F_MASK(name)))
-
-/* Feature/offload bits */
-enum {
-	BE_WRB_F_CRC_BIT,		/* Ethernet CRC */
-	BE_WRB_F_IPCS_BIT,		/* IP csum */
-	BE_WRB_F_TCPCS_BIT,		/* TCP csum */
-	BE_WRB_F_UDPCS_BIT,		/* UDP csum */
-	BE_WRB_F_LSO_BIT,		/* LSO */
-	BE_WRB_F_LSO6_BIT,		/* LSO6 */
-	BE_WRB_F_VLAN_BIT,		/* VLAN */
-	BE_WRB_F_VLAN_SKIP_HW_BIT,	/* Skip VLAN tag (workaround) */
-	BE_WRB_F_OS2BMC_BIT		/* Send packet to the management ring */
-};
-
-/* The structure below provides a HW-agnostic abstraction of WRB params
- * retrieved from a TX skb. This is in turn passed to chip specific routines
- * during transmit, to set the corresponding params in the WRB.
- */
-struct be_wrb_params {
-	u32 features;	/* Feature bits */
-	u16 vlan_tag;	/* VLAN tag */
-	u16 lso_mss;	/* MSS for LSO */
-};
-
 struct be_eth_addr {
 	unsigned char mac[ETH_ALEN];
 };
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 39eb7d5..c0e319b 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -1121,6 +1121,43 @@ static int be_ipv6_tx_stall_chk(struct be_adapter *adapter, struct sk_buff *skb)
 	return BE3_chip(adapter) && be_ipv6_exthdr_check(skb);
 }
 
+void be_record_tx_cmpl(struct be_tx_obj *txo,
+		       struct be_eth_tx_compl *cmpl)
+{
+	u32 offset = txo->tx_cmpl_idx;
+	struct be_tx_dump_cmpl *cmpl_dump = &txo->cmpl_info[offset];
+
+	memset(cmpl_dump, 0, sizeof(*cmpl_dump));
+
+	memcpy(&cmpl_dump->info, cmpl, sizeof(cmpl_dump->info));
+	cmpl_dump->valid = 1;
+
+	txo->tx_cmpl_idx = ((txo->tx_cmpl_idx + 1) % BE_TXQ_INFO_LEN);
+}
+
+void be_record_tx_wqes(struct be_tx_obj *txo,
+		       struct be_wrb_params *wrb_params,
+		       struct sk_buff *skb)
+{
+	u32 offset = txo->tx_wqe_offset;
+	struct be_tx_pktinfo *pkt_info = &txo->tx_pktinfo[offset];
+
+	memset(pkt_info, 0, sizeof(*pkt_info));
+
+	pkt_info->tail = txo->q.tail;
+	pkt_info->head = txo->q.head;
+	pkt_info->used = atomic_read(&txo->q.used);
+	pkt_info->valid = 1;
+	pkt_info->skb_len = skb->len;
+	pkt_info->len = min_t(u32, PKT_DUMP_SIZE, skb->len);
+
+	memcpy(&pkt_info->wqe_hdr, wrb_params, sizeof(*wrb_params));
+
+	memcpy(&pkt_info->skb_data, skb->data, pkt_info->len);
+
+	txo->tx_wqe_offset = ((txo->tx_wqe_offset + 1) % BE_TXQ_INFO_LEN);
+}
+
 static struct sk_buff *be_lancer_xmit_workarounds(struct be_adapter *adapter,
 						  struct sk_buff *skb,
 						  struct be_wrb_params
@@ -1399,6 +1436,10 @@ static netdev_tx_t be_xmit(struct sk_buff *skb, struct net_device *netdev)
 			skb_get(skb);
 	}
 
+	/* Dump TX WQEs and SKB data */
+	if (adapter->msg_enable)
+		be_record_tx_wqes(txo, &wrb_params, skb);
+
 	if (be_is_txq_full(txo)) {
 		netif_stop_subqueue(netdev, q_idx);
 		tx_stats(txo)->tx_stops++;
@@ -1417,6 +1458,75 @@ static netdev_tx_t be_xmit(struct sk_buff *skb, struct net_device *netdev)
 	return NETDEV_TX_OK;
 }
 
+void
+be_print_tx_wqes(struct be_adapter *adapter, struct be_tx_obj *txo)
+{
+	struct device *dev = &adapter->pdev->dev;
+	struct be_tx_pktinfo *pkt_info;
+	u8 *data;
+	int i, j;
+
+	dev_info(dev, "Dumping WQES of TXQ id %d\n", txo->q.id);
+
+	for (i = 0; i < BE_TXQ_INFO_LEN; i++) {
+		pkt_info = &txo->tx_pktinfo[i];
+		if (!pkt_info->valid)
+			continue;
+
+		dev_info(dev, "TXQ head %d tail %d used %d\n",
+			 pkt_info->head, pkt_info->tail, pkt_info->used);
+
+		dev_info(dev, "WRB params: feature:0x%x vlan_tag:0x%x lso_mss:0x%x\n",
+			 pkt_info->wqe_hdr.features, pkt_info->wqe_hdr.vlan_tag,
+			 pkt_info->wqe_hdr.lso_mss);
+
+		dev_info(dev, "SKB len: %d\n", pkt_info->skb_len);
+		data = pkt_info->skb_data;
+		for (j = 0 ; j < pkt_info->len; j++) {
+			printk("%02x ", data[j]);
+			if (j % 8 == 7)
+				printk(KERN_INFO "\n");
+		}
+	}
+}
+
+void
+be_print_tx_cmpls(struct be_adapter *adapter, struct be_tx_obj *txo)
+{
+	struct device *dev = &adapter->pdev->dev;
+	struct be_tx_dump_cmpl *cmpl_info;
+	int i;
+
+	dev_info(dev, "TX CQ id %d head %d tail %d used %d\n",
+		 txo->cq.id, txo->cq.head, txo->cq.tail,
+		 atomic_read(&txo->cq.used));
+
+	for (i = 0; i < BE_TXQ_INFO_LEN; i++) {
+		cmpl_info = &txo->cmpl_info[i];
+		if (!cmpl_info->valid)
+			continue;
+
+		printk(KERN_INFO "0x%x 0x%x 0x%x 0x%x\n",
+		       cmpl_info->info[0], cmpl_info->info[1],
+		       cmpl_info->info[2], cmpl_info->info[3]);
+	}
+}
+
+/* be_dump_info - Print tx-wqes, tx-cmpls and skb-data */
+void be_dump_info(struct be_adapter *adapter)
+{
+	struct be_tx_obj *txo;
+	int i;
+
+	if (!adapter->msg_enable)
+		return;
+
+	for_all_tx_queues(adapter, txo, i) {
+		be_print_tx_wqes(adapter, txo);
+		be_print_tx_cmpls(adapter, txo);
+	}
+}
+
 static void be_tx_timeout(struct net_device *netdev)
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
@@ -1429,6 +1539,8 @@ static void be_tx_timeout(struct net_device *netdev)
 	int status;
 	int i, j;
 
+	be_dump_info(adapter);
+
 	for_all_tx_queues(adapter, txo, i) {
 		dev_info(dev, "TXQ Dump: %d H: %d T: %d used: %d, qid: 0x%x\n",
 			 i, txo->q.head, txo->q.tail,
@@ -2719,6 +2831,10 @@ static struct be_tx_compl_info *be_tx_compl_get(struct be_adapter *adapter,
 	rmb();
 	be_dws_le_to_cpu(compl, sizeof(*compl));
 
+	/* Dump completion info */
+	if (adapter->msg_enable)
+		be_record_tx_cmpl(txo, compl);
+
 	txcp->status = GET_TX_COMPL_BITS(status, compl);
 	txcp->end_index = GET_TX_COMPL_BITS(wrb_index, compl);
 
-- 
2.10.1

