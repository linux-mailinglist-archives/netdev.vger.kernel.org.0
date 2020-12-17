Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0622DD68F
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 18:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbgLQRsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 12:48:16 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44814 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728487AbgLQRsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 12:48:13 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BHHfON6008216;
        Thu, 17 Dec 2020 09:45:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=FiHsbapZZsHFF2s7cfb3WG2w+ikMFU1s/FrvpNvsWlo=;
 b=Fl5Xhp6DBG/s9/MQWYEg9sFmp43oqdIVJGFIolc6VdGeLTGtRLQl7mtNxhIcnCzmDVDa
 YmLukQ9EVlmnyEzqqnsVpsmaV+nYZP3E0ztnngTqptzhRiEWgl36BCBR2gjrQKBSZDnP
 nVIG5nyc039N2aHfq9so88SQgG9uOR6njWTs0L/wxTt1lhbmwDYVqBVJNVVJ5WPPs94Q
 lQOo43QlWDimtGwhntRqQb+dE7gMFNS93THV6+yNIrT63MxPUR6PROw5esACMMQyKYcg
 QpBWTKP7yQ5mV3eqHQCa0pSl9B+n0L0FSemKqfoagiTJXVwoT+s5mSq08Xl+yKAAQwj7 vA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35cx8tgf86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 09:45:22 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 09:45:20 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 09:45:20 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Dec 2020 09:45:20 -0800
Received: from stefan-pc.marvell.com (unknown [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 4321B3F7044;
        Thu, 17 Dec 2020 09:45:17 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net] net: mvpp2: Add TCAM entry to drop flow control pause frames
Date:   Thu, 17 Dec 2020 19:45:06 +0200
Message-ID: <1608227106-21394-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_13:2020-12-15,2020-12-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Issue:
Flow control frame used to pause GoP(MAC) was delivered to the CPU
and created a load on the CPU. Since XOFF/XON frames are used only
by MAC, these frames should be dropped inside MAC.

Fix:
According to 802.3-2012 - IEEE Standard for Ethernet pause frame
has unique destination MAC address 01-80-C2-00-00-01.
Add TCAM parser entry to track and drop pause frames by destination MAC.

Fixes: db9d7d36eecc ("net: mvpp2: Split the PPv2 driver to a dedicated directory")
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c | 34 ++++++++++++++++++++++++++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h |  2 +-
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index 1a272c2..3a9c747 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -405,6 +405,39 @@ static int mvpp2_prs_tcam_first_free(struct mvpp2 *priv, unsigned char start,
 	return -EINVAL;
 }
 
+/* Drop flow control pause frames */
+static void mvpp2_prs_drop_fc(struct mvpp2 *priv)
+{
+	struct mvpp2_prs_entry pe;
+	unsigned int len;
+	unsigned char da[ETH_ALEN] = {
+			0x01, 0x80, 0xC2, 0x00, 0x00, 0x01 };
+
+	memset(&pe, 0, sizeof(pe));
+
+	/* For all ports - drop flow control frames */
+	pe.index = MVPP2_PE_FC_DROP;
+	mvpp2_prs_tcam_lu_set(&pe, MVPP2_PRS_LU_MAC);
+
+	/* Set match on DA */
+	len = ETH_ALEN;
+	while (len--)
+		mvpp2_prs_tcam_data_byte_set(&pe, len, da[len], 0xff);
+
+	mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_DROP_MASK,
+				 MVPP2_PRS_RI_DROP_MASK);
+
+	mvpp2_prs_sram_bits_set(&pe, MVPP2_PRS_SRAM_LU_GEN_BIT, 1);
+	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_FLOWS);
+
+	/* Mask all ports */
+	mvpp2_prs_tcam_port_map_set(&pe, MVPP2_PRS_PORT_MASK);
+
+	/* Update shadow table and hw entry */
+	mvpp2_prs_shadow_set(priv, pe.index, MVPP2_PRS_LU_MAC);
+	mvpp2_prs_hw_write(priv, &pe);
+}
+
 /* Enable/disable dropping all mac da's */
 static void mvpp2_prs_mac_drop_all_set(struct mvpp2 *priv, int port, bool add)
 {
@@ -1168,6 +1201,7 @@ static void mvpp2_prs_mac_init(struct mvpp2 *priv)
 	mvpp2_prs_hw_write(priv, &pe);
 
 	/* Create dummy entries for drop all and promiscuous modes */
+	mvpp2_prs_drop_fc(priv);
 	mvpp2_prs_mac_drop_all_set(priv, 0, false);
 	mvpp2_prs_mac_promisc_set(priv, 0, MVPP2_PRS_L2_UNI_CAST, false);
 	mvpp2_prs_mac_promisc_set(priv, 0, MVPP2_PRS_L2_MULTI_CAST, false);
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h
index e22f6c8..4b68dd3 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h
@@ -129,7 +129,7 @@
 #define MVPP2_PE_VID_EDSA_FLTR_DEFAULT	(MVPP2_PRS_TCAM_SRAM_SIZE - 7)
 #define MVPP2_PE_VLAN_DBL		(MVPP2_PRS_TCAM_SRAM_SIZE - 6)
 #define MVPP2_PE_VLAN_NONE		(MVPP2_PRS_TCAM_SRAM_SIZE - 5)
-/* reserved */
+#define MVPP2_PE_FC_DROP		(MVPP2_PRS_TCAM_SRAM_SIZE - 4)
 #define MVPP2_PE_MAC_MC_PROMISCUOUS	(MVPP2_PRS_TCAM_SRAM_SIZE - 3)
 #define MVPP2_PE_MAC_UC_PROMISCUOUS	(MVPP2_PRS_TCAM_SRAM_SIZE - 2)
 #define MVPP2_PE_MAC_NON_PROMISCUOUS	(MVPP2_PRS_TCAM_SRAM_SIZE - 1)
-- 
1.9.1

