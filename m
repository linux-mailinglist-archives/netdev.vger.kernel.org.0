Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC6E390627
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 18:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhEYQGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 12:06:50 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58280 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230422AbhEYQGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 12:06:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14PG0s89019506;
        Tue, 25 May 2021 09:04:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=DGHll5mQSSb6B5JJsJVJhXgotbT3M2ufRWY0rxNnHhg=;
 b=RflbZgIlvP4V1iEoPSJU1mXXoZ+68/HBqNGeZAMHQ0X35CbIGSglNbTePNIwmqdnYHek
 ti1vSYMllgp0V40oVUwYfOnflEGkxHkn/eBDFycldOCKxrj0zmncZWn4a8kV2M6+hXd1
 wBi2IBb0+FlCjJkq4hBrLfmVquXyROb3T3MUyiSj7nKLptJjLeZemjLSiEjfS+TTA9bA
 s/XnnwjXUdX+T0V3rXPLYmswJ22mquB6Fe5EjVjquiGk53QSddo5wU4bJZ6jZO6vz5ql
 OkOCz9vY/efVReLrcauQ2aTtcenY/xMrmPPZ4sZPwRJ/jlZKavrbs1F/+iIeeOSHrfYR Fg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 38s0fes35u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 09:04:52 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 09:04:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 25 May 2021 09:04:51 -0700
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 6EFC43F703F;
        Tue, 25 May 2021 09:04:48 -0700 (PDT)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net] net: mvpp2: add buffer header handling in RX
Date:   Tue, 25 May 2021 19:04:41 +0300
Message-ID: <1621958681-7890-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: JIcBrC6vp_bn4iblFcFW9D8DKK2LokXu
X-Proofpoint-GUID: JIcBrC6vp_bn4iblFcFW9D8DKK2LokXu
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-25_07:2021-05-25,2021-05-25 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

If Link Partner sends frames larger than RX buffer size, MAC mark it
as oversize but still would pass it to the Packet Processor.
In this scenario, Packet Processor scatter frame between multiple buffers,
but only a single buffer would be returned to the Buffer Manager pool and
it would not refill the poll.

Patch add handling of oversize error with buffer header handling, so all
buffers would be returned to the Buffer Manager pool.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 22 ++++++++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 54 ++++++++++++++++----
 2 files changed, 67 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 8edba5e..4a61c90 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -993,6 +993,14 @@ enum mvpp22_ptp_packet_format {
 
 #define MVPP2_DESC_DMA_MASK	DMA_BIT_MASK(40)
 
+/* Buffer header info bits */
+#define MVPP2_B_HDR_INFO_MC_ID_MASK	0xfff
+#define MVPP2_B_HDR_INFO_MC_ID(info)	((info) & MVPP2_B_HDR_INFO_MC_ID_MASK)
+#define MVPP2_B_HDR_INFO_LAST_OFFS	12
+#define MVPP2_B_HDR_INFO_LAST_MASK	BIT(12)
+#define MVPP2_B_HDR_INFO_IS_LAST(info) \
+	   (((info) & MVPP2_B_HDR_INFO_LAST_MASK) >> MVPP2_B_HDR_INFO_LAST_OFFS)
+
 struct mvpp2_tai;
 
 /* Definitions */
@@ -1002,6 +1010,20 @@ struct mvpp2_rss_table {
 	u32 indir[MVPP22_RSS_TABLE_ENTRIES];
 };
 
+struct mvpp2_buff_hdr {
+	__le32 next_phys_addr;
+	__le32 next_dma_addr;
+	__le16 byte_count;
+	__le16 info;
+	__le16 reserved1;	/* bm_qset (for future use, BM) */
+	u8 next_phys_addr_high;
+	u8 next_dma_addr_high;
+	__le16 reserved2;
+	__le16 reserved3;
+	__le16 reserved4;
+	__le16 reserved5;
+};
+
 /* Shared Packet Processor resources */
 struct mvpp2 {
 	/* Shared registers' base addresses */
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d415447..f774dcf 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3840,6 +3840,35 @@ static void mvpp2_xdp_finish_tx(struct mvpp2_port *port, u16 txq_id, int nxmit,
 	return ret;
 }
 
+static void mvpp2_buff_hdr_pool_put(struct mvpp2_port *port, struct mvpp2_rx_desc *rx_desc,
+				    int pool, u32 rx_status)
+{
+	phys_addr_t phys_addr, phys_addr_next;
+	dma_addr_t dma_addr, dma_addr_next;
+	struct mvpp2_buff_hdr *buff_hdr;
+
+	phys_addr = mvpp2_rxdesc_dma_addr_get(port, rx_desc);
+	dma_addr = mvpp2_rxdesc_cookie_get(port, rx_desc);
+
+	do {
+		buff_hdr = (struct mvpp2_buff_hdr *)phys_to_virt(phys_addr);
+
+		phys_addr_next = le32_to_cpu(buff_hdr->next_phys_addr);
+		dma_addr_next = le32_to_cpu(buff_hdr->next_dma_addr);
+
+		if (port->priv->hw_version >= MVPP22) {
+			phys_addr_next |= ((u64)buff_hdr->next_phys_addr_high << 32);
+			dma_addr_next |= ((u64)buff_hdr->next_dma_addr_high << 32);
+		}
+
+		mvpp2_bm_pool_put(port, pool, dma_addr, phys_addr);
+
+		phys_addr = phys_addr_next;
+		dma_addr = dma_addr_next;
+
+	} while (!MVPP2_B_HDR_INFO_IS_LAST(le16_to_cpu(buff_hdr->info)));
+}
+
 /* Main rx processing */
 static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		    int rx_todo, struct mvpp2_rx_queue *rxq)
@@ -3886,14 +3915,6 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			MVPP2_RXD_BM_POOL_ID_OFFS;
 		bm_pool = &port->priv->bm_pools[pool];
 
-		/* In case of an error, release the requested buffer pointer
-		 * to the Buffer Manager. This request process is controlled
-		 * by the hardware, and the information about the buffer is
-		 * comprised by the RX descriptor.
-		 */
-		if (rx_status & MVPP2_RXD_ERR_SUMMARY)
-			goto err_drop_frame;
-
 		if (port->priv->percpu_pools) {
 			pp = port->priv->page_pool[pool];
 			dma_dir = page_pool_get_dma_dir(pp);
@@ -3905,6 +3926,18 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 					rx_bytes + MVPP2_MH_SIZE,
 					dma_dir);
 
+		/* Buffer header not supported */
+		if (rx_status & MVPP2_RXD_BUF_HDR)
+			goto err_drop_frame;
+
+		/* In case of an error, release the requested buffer pointer
+		 * to the Buffer Manager. This request process is controlled
+		 * by the hardware, and the information about the buffer is
+		 * comprised by the RX descriptor.
+		 */
+		if (rx_status & MVPP2_RXD_ERR_SUMMARY)
+			goto err_drop_frame;
+
 		/* Prefetch header */
 		prefetch(data);
 
@@ -3986,7 +4019,10 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		dev->stats.rx_errors++;
 		mvpp2_rx_error(port, rx_desc);
 		/* Return the buffer to the pool */
-		mvpp2_bm_pool_put(port, pool, dma_addr, phys_addr);
+		if (rx_status & MVPP2_RXD_BUF_HDR)
+			mvpp2_buff_hdr_pool_put(port, rx_desc, pool, rx_status);
+		else
+			mvpp2_bm_pool_put(port, pool, dma_addr, phys_addr);
 	}
 
 	rcu_read_unlock();
-- 
1.9.1

