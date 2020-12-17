Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF6A2DD86D
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729960AbgLQSdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:33:19 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21244 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728080AbgLQSdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 13:33:18 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BHIPTmS027002;
        Thu, 17 Dec 2020 10:30:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=43M/47gFEKR/WDfvU4oMdO7tv2WEzlESQApEb8KWowE=;
 b=drYaiE44evVk6Cxd3girmXigNrCPeJyJBmLoky4b8kPKeNcpKkgkJOawpCgPvlqva51a
 fLqx/3f0gO1n/eK8HzSTjjzqvnhKBNk8phHZaPqLiMJvHwUdIItCQmPtBYD08T0Dd7fG
 uEI/D5Lpch9d134Qizkrjapv7gmJ37O6jvUoVrXhJ8L+vkotb5+j13N61Fg12JyHnabw
 2OSi/fmedii4Jj8hGctrhrdIxSch2iAe0N7p45wEmct625fpRJg2BdFRI2bHrZY/F2wR
 pf3UK1oTKjHVn3utnNueprEN6dySvGniIZ88SaooKWfX2ioVvRHMuln0Jufbt0iDuW/J 0Q== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 35cx8tgnuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 10:30:26 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 10:30:24 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Dec 2020 10:30:24 -0800
Received: from stefan-pc.marvell.com (unknown [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 923713F7040;
        Thu, 17 Dec 2020 10:30:21 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net v2] net: mvpp2: Add TCAM entry to drop flow control pause frames
Date:   Thu, 17 Dec 2020 20:30:17 +0200
Message-ID: <1608229817-21951-1-git-send-email-stefanc@marvell.com>
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

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---

Changes in v2:
- Fix "fixes tag"

 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c | 34 ++++++++++++++++++++
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

