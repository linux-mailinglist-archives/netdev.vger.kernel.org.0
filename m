Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABA43B6745
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 19:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhF1RJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 13:09:51 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7788 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232849AbhF1RJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 13:09:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15SH6MtO029721;
        Mon, 28 Jun 2021 10:07:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=m6n5ssAgUlXjGe0A9f/NpVOEnx/gEKf5r1ZkJ2e7BgU=;
 b=lGe3+HcOLA3R4a5riF4VF0c9oLr7boxD/KyxVhqWqXlIphtP12A01KhQhR5pze3yYjds
 HXRFRUuNsZV65l7+Q+U5ZyQwBknax7Bxv38L2T8eZchSQ0MZJNTZ5cQExocMw8WxRv6a
 dK/mLvfqYuefSziNHv6qsXGOA9NxxCcJdsjTEkxiTjluYInhSuhgeIAT0hG13bIijN6d
 sfxAdJRgN23WxnH0L5quWGaI7u/NN5oRHwLijEDx7arQ8UK8qzU0RnKB1E98JC9IC1PS
 BqjaI5sckWpzprUCQkItwc6R+13lXVEMraUCD0WQgbn3P5DWXXfGU1Wj4idyeOCiCiJx 3Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 39f11y3bpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 28 Jun 2021 10:07:04 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 28 Jun
 2021 10:07:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 28 Jun 2021 10:07:03 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id DB6B53F7067;
        Mon, 28 Jun 2021 10:06:59 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [net-next 1/3] octeontx2-af: DMAC filter support in MAC block
Date:   Mon, 28 Jun 2021 22:36:52 +0530
Message-ID: <20210628170654.22995-2-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210628170654.22995-1-hkelam@marvell.com>
References: <20210628170654.22995-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: BA_eIrJysKx8vX7qaU3pzCVb8IFtl3Fx
X-Proofpoint-ORIG-GUID: BA_eIrJysKx8vX7qaU3pzCVb8IFtl3Fx
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-28_14:2021-06-25,2021-06-28 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Kumar Kori <skori@marvell.com>

MAC block supports 32 dmac filters which are logically
divided among all attached LMACS.

For example MAC block0 having one LMAC then maximum supported
filters are 32 where as MAC block1 having 4 enabled LMACS
them maximum supported filteres are 8 for each LMAC.

This patch adds mbox handlers to add/delete/update mac entry
in DMAC filter table.

Signed-off-by: Sunil Kumar Kori <skori@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 263 +++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |   7 +
 .../marvell/octeontx2/af/lmac_common.h        |   5 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  48 +++-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   2 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 109 ++++++++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   3 +
 7 files changed, 420 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index fac6474ad694..5971e85162f1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -86,6 +86,22 @@ bool is_lmac_valid(struct cgx *cgx, int lmac_id)
 	return test_bit(lmac_id, &cgx->lmac_bmap);
 }
 
+/* Helper function to get sequential index
+ * given the enabled LMAC of a CGX
+ */
+static int get_sequence_id_of_lmac(struct cgx *cgx, int lmac_id)
+{
+	int tmp, id = 0;
+
+	for_each_set_bit(tmp, &cgx->lmac_bmap, MAX_LMAC_PER_CGX) {
+		if (tmp == lmac_id)
+			break;
+		id++;
+	}
+
+	return id;
+}
+
 struct mac_ops *get_mac_ops(void *cgxd)
 {
 	if (!cgxd)
@@ -211,37 +227,229 @@ static u64 mac2u64 (u8 *mac_addr)
 	return mac;
 }
 
+static void cfg2mac(u64 cfg, u8 *mac_addr)
+{
+	int i, index = 0;
+
+	for (i = ETH_ALEN - 1; i >= 0; i--, index++)
+		mac_addr[i] = (cfg >> (8 * index)) & 0xFF;
+}
+
 int cgx_lmac_addr_set(u8 cgx_id, u8 lmac_id, u8 *mac_addr)
 {
 	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
+	struct lmac *lmac = lmac_pdata(lmac_id, cgx_dev);
 	struct mac_ops *mac_ops;
+	int index, id;
 	u64 cfg;
 
+	/* access mac_ops to know csr_offset */
 	mac_ops = cgx_dev->mac_ops;
+
 	/* copy 6bytes from macaddr */
 	/* memcpy(&cfg, mac_addr, 6); */
 
 	cfg = mac2u64 (mac_addr);
 
-	cgx_write(cgx_dev, 0, (CGXX_CMRX_RX_DMAC_CAM0 + (lmac_id * 0x8)),
+	id = get_sequence_id_of_lmac(cgx_dev, lmac_id);
+
+	index = id * lmac->mac_to_index_bmap.max;
+
+	cgx_write(cgx_dev, 0, (CGXX_CMRX_RX_DMAC_CAM0 + (index * 0x8)),
 		  cfg | CGX_DMAC_CAM_ADDR_ENABLE | ((u64)lmac_id << 49));
 
 	cfg = cgx_read(cgx_dev, lmac_id, CGXX_CMRX_RX_DMAC_CTL0);
-	cfg |= CGX_DMAC_CTL0_CAM_ENABLE;
+	cfg |= (CGX_DMAC_CTL0_CAM_ENABLE | CGX_DMAC_BCAST_MODE |
+		CGX_DMAC_MCAST_MODE);
+	cgx_write(cgx_dev, lmac_id, CGXX_CMRX_RX_DMAC_CTL0, cfg);
+
+	return 0;
+}
+
+int cgx_lmac_addr_add(u8 cgx_id, u8 lmac_id, u8 *mac_addr)
+{
+	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
+	struct lmac *lmac = lmac_pdata(lmac_id, cgx_dev);
+	struct mac_ops *mac_ops;
+	int index, idx;
+	u64 cfg = 0;
+	int id;
+
+	if (!lmac)
+		return -ENODEV;
+
+	mac_ops = cgx_dev->mac_ops;
+	/* Get available index where entry is to be installed */
+	idx = rvu_alloc_rsrc(&lmac->mac_to_index_bmap);
+	if (idx < 0)
+		return idx;
+
+	id = get_sequence_id_of_lmac(cgx_dev, lmac_id);
+
+	index = id * lmac->mac_to_index_bmap.max + idx;
+
+	cfg = mac2u64 (mac_addr);
+	cfg |= CGX_DMAC_CAM_ADDR_ENABLE;
+	cfg |= ((u64)lmac_id << 49);
+	cgx_write(cgx_dev, 0, (CGXX_CMRX_RX_DMAC_CAM0 + (index * 0x8)), cfg);
+
+	cfg = cgx_read(cgx_dev, lmac_id, CGXX_CMRX_RX_DMAC_CTL0);
+	cfg |= (CGX_DMAC_BCAST_MODE | CGX_DMAC_CAM_ACCEPT);
+
+	if (is_multicast_ether_addr(mac_addr)) {
+		cfg &= ~GENMASK_ULL(2, 1);
+		cfg |= CGX_DMAC_MCAST_MODE_CAM;
+		lmac->mcast_filters_count++;
+	} else if (!lmac->mcast_filters_count) {
+		cfg |= CGX_DMAC_MCAST_MODE;
+	}
+
+	cgx_write(cgx_dev, lmac_id, CGXX_CMRX_RX_DMAC_CTL0, cfg);
+
+	return idx;
+}
+
+int cgx_lmac_addr_reset(u8 cgx_id, u8 lmac_id)
+{
+	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
+	struct lmac *lmac = lmac_pdata(lmac_id, cgx_dev);
+	struct mac_ops *mac_ops;
+	u8 index = 0, id;
+	u64 cfg;
+
+	if (!lmac)
+		return -ENODEV;
+
+	mac_ops = cgx_dev->mac_ops;
+	/* Restore index 0 to its default init value as done during
+	 * cgx_lmac_init
+	 */
+	set_bit(0, lmac->mac_to_index_bmap.bmap);
+
+	id = get_sequence_id_of_lmac(cgx_dev, lmac_id);
+
+	index = id * lmac->mac_to_index_bmap.max + index;
+	cgx_write(cgx_dev, 0, (CGXX_CMRX_RX_DMAC_CAM0 + (index * 0x8)), 0);
+
+	/* Reset CGXX_CMRX_RX_DMAC_CTL0 register to default state */
+	cfg = cgx_read(cgx_dev, lmac_id, CGXX_CMRX_RX_DMAC_CTL0);
+	cfg &= ~CGX_DMAC_CAM_ACCEPT;
+	cfg |= (CGX_DMAC_BCAST_MODE | CGX_DMAC_MCAST_MODE);
 	cgx_write(cgx_dev, lmac_id, CGXX_CMRX_RX_DMAC_CTL0, cfg);
 
 	return 0;
 }
 
+/* Allows caller to change macaddress associated with index
+ * in dmac filter table including index 0 reserved for
+ * interface mac address
+ */
+int cgx_lmac_addr_update(u8 cgx_id, u8 lmac_id, u8 *mac_addr, u8 index)
+{
+	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
+	struct mac_ops *mac_ops;
+	struct lmac *lmac;
+	u64 cfg;
+	int id;
+
+	lmac = lmac_pdata(lmac_id, cgx_dev);
+	if (!lmac)
+		return -ENODEV;
+
+	mac_ops = cgx_dev->mac_ops;
+	/* Validate the index */
+	if (index >= lmac->mac_to_index_bmap.max)
+		return -EINVAL;
+
+	/* ensure index is already set */
+	if (!test_bit(index, lmac->mac_to_index_bmap.bmap))
+		return -EINVAL;
+
+	id = get_sequence_id_of_lmac(cgx_dev, lmac_id);
+
+	index = id * lmac->mac_to_index_bmap.max + index;
+
+	cfg = cgx_read(cgx_dev, 0, (CGXX_CMRX_RX_DMAC_CAM0 + (index * 0x8)));
+	cfg &= ~CGX_RX_DMAC_ADR_MASK;
+	cfg |= mac2u64 (mac_addr);
+
+	cgx_write(cgx_dev, 0, (CGXX_CMRX_RX_DMAC_CAM0 + (index * 0x8)), cfg);
+	return 0;
+}
+
+int cgx_lmac_addr_del(u8 cgx_id, u8 lmac_id, u8 index)
+{
+	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
+	struct lmac *lmac = lmac_pdata(lmac_id, cgx_dev);
+	struct mac_ops *mac_ops;
+	u8 mac[ETH_ALEN];
+	u64 cfg;
+	int id;
+
+	if (!lmac)
+		return -ENODEV;
+
+	mac_ops = cgx_dev->mac_ops;
+	/* Validate the index */
+	if (index >= lmac->mac_to_index_bmap.max)
+		return -EINVAL;
+
+	/* Skip deletion for reserved index i.e. index 0 */
+	if (index == 0)
+		return 0;
+
+	rvu_free_rsrc(&lmac->mac_to_index_bmap, index);
+
+	id = get_sequence_id_of_lmac(cgx_dev, lmac_id);
+
+	index = id * lmac->mac_to_index_bmap.max + index;
+
+	/* Read MAC address to check whether it is ucast or mcast */
+	cfg = cgx_read(cgx_dev, 0, (CGXX_CMRX_RX_DMAC_CAM0 + (index * 0x8)));
+
+	cfg2mac(cfg, mac);
+	if (is_multicast_ether_addr(mac))
+		lmac->mcast_filters_count--;
+
+	if (!lmac->mcast_filters_count) {
+		cfg = cgx_read(cgx_dev, lmac_id, CGXX_CMRX_RX_DMAC_CTL0);
+		cfg &= ~GENMASK_ULL(2, 1);
+		cfg |= CGX_DMAC_MCAST_MODE;
+		cgx_write(cgx_dev, lmac_id, CGXX_CMRX_RX_DMAC_CTL0, cfg);
+	}
+
+	cgx_write(cgx_dev, 0, (CGXX_CMRX_RX_DMAC_CAM0 + (index * 0x8)), 0);
+
+	return 0;
+}
+
+int cgx_lmac_addr_max_entries_get(u8 cgx_id, u8 lmac_id)
+{
+	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
+	struct lmac *lmac = lmac_pdata(lmac_id, cgx_dev);
+
+	if (lmac)
+		return lmac->mac_to_index_bmap.max;
+
+	return 0;
+}
+
 u64 cgx_lmac_addr_get(u8 cgx_id, u8 lmac_id)
 {
 	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
+	struct lmac *lmac = lmac_pdata(lmac_id, cgx_dev);
 	struct mac_ops *mac_ops;
+	int index;
 	u64 cfg;
+	int id;
 
 	mac_ops = cgx_dev->mac_ops;
 
-	cfg = cgx_read(cgx_dev, 0, CGXX_CMRX_RX_DMAC_CAM0 + lmac_id * 0x8);
+	id = get_sequence_id_of_lmac(cgx_dev, lmac_id);
+
+	index = id * lmac->mac_to_index_bmap.max;
+
+	cfg = cgx_read(cgx_dev, 0, CGXX_CMRX_RX_DMAC_CAM0 + index * 0x8);
 	return cfg & CGX_RX_DMAC_ADR_MASK;
 }
 
@@ -297,35 +505,50 @@ int cgx_lmac_internal_loopback(void *cgxd, int lmac_id, bool enable)
 void cgx_lmac_promisc_config(int cgx_id, int lmac_id, bool enable)
 {
 	struct cgx *cgx = cgx_get_pdata(cgx_id);
+	struct lmac *lmac = lmac_pdata(lmac_id, cgx);
+	u16 max_dmac = lmac->mac_to_index_bmap.max;
 	struct mac_ops *mac_ops;
+	int index, i;
 	u64 cfg = 0;
+	int id;
 
 	if (!cgx)
 		return;
 
+	id = get_sequence_id_of_lmac(cgx, lmac_id);
+
 	mac_ops = cgx->mac_ops;
 	if (enable) {
 		/* Enable promiscuous mode on LMAC */
 		cfg = cgx_read(cgx, lmac_id, CGXX_CMRX_RX_DMAC_CTL0);
-		cfg &= ~(CGX_DMAC_CAM_ACCEPT | CGX_DMAC_MCAST_MODE);
-		cfg |= CGX_DMAC_BCAST_MODE;
+		cfg &= ~CGX_DMAC_CAM_ACCEPT;
+		cfg |= (CGX_DMAC_BCAST_MODE | CGX_DMAC_MCAST_MODE);
 		cgx_write(cgx, lmac_id, CGXX_CMRX_RX_DMAC_CTL0, cfg);
 
-		cfg = cgx_read(cgx, 0,
-			       (CGXX_CMRX_RX_DMAC_CAM0 + lmac_id * 0x8));
-		cfg &= ~CGX_DMAC_CAM_ADDR_ENABLE;
-		cgx_write(cgx, 0,
-			  (CGXX_CMRX_RX_DMAC_CAM0 + lmac_id * 0x8), cfg);
+		for (i = 0; i < max_dmac; i++) {
+			index = id * max_dmac + i;
+			cfg = cgx_read(cgx, 0,
+				       (CGXX_CMRX_RX_DMAC_CAM0 + index * 0x8));
+			cfg &= ~CGX_DMAC_CAM_ADDR_ENABLE;
+			cgx_write(cgx, 0,
+				  (CGXX_CMRX_RX_DMAC_CAM0 + index * 0x8), cfg);
+		}
 	} else {
 		/* Disable promiscuous mode */
 		cfg = cgx_read(cgx, lmac_id, CGXX_CMRX_RX_DMAC_CTL0);
 		cfg |= CGX_DMAC_CAM_ACCEPT | CGX_DMAC_MCAST_MODE;
 		cgx_write(cgx, lmac_id, CGXX_CMRX_RX_DMAC_CTL0, cfg);
-		cfg = cgx_read(cgx, 0,
-			       (CGXX_CMRX_RX_DMAC_CAM0 + lmac_id * 0x8));
-		cfg |= CGX_DMAC_CAM_ADDR_ENABLE;
-		cgx_write(cgx, 0,
-			  (CGXX_CMRX_RX_DMAC_CAM0 + lmac_id * 0x8), cfg);
+		for (i = 0; i < max_dmac; i++) {
+			index = id * max_dmac + i;
+			cfg = cgx_read(cgx, 0,
+				       (CGXX_CMRX_RX_DMAC_CAM0 + index * 0x8));
+			if ((cfg & CGX_RX_DMAC_ADR_MASK) != 0) {
+				cfg |= CGX_DMAC_CAM_ADDR_ENABLE;
+				cgx_write(cgx, 0,
+					  (CGXX_CMRX_RX_DMAC_CAM0 + index * 0x8),
+					  cfg);
+			}
+		}
 	}
 }
 
@@ -1234,6 +1457,15 @@ static int cgx_lmac_init(struct cgx *cgx)
 		}
 
 		lmac->cgx = cgx;
+		lmac->mac_to_index_bmap.max =
+				MAX_DMAC_ENTRIES_PER_CGX / cgx->lmac_count;
+		err = rvu_alloc_bitmap(&lmac->mac_to_index_bmap);
+		if (err)
+			return err;
+
+		/* Reserve first entry for default MAC address */
+		set_bit(0, lmac->mac_to_index_bmap.bmap);
+
 		init_waitqueue_head(&lmac->wq_cmd_cmplt);
 		mutex_init(&lmac->cmd_lock);
 		spin_lock_init(&lmac->event_cb_lock);
@@ -1274,6 +1506,7 @@ static int cgx_lmac_exit(struct cgx *cgx)
 			continue;
 		cgx->mac_ops->mac_pause_frm_config(cgx, lmac->lmac_id, false);
 		cgx_configure_interrupt(cgx, lmac, lmac->lmac_id, true);
+		kfree(lmac->mac_to_index_bmap.bmap);
 		kfree(lmac->name);
 		kfree(lmac);
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 12521262164a..0c613f83a41c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -23,6 +23,7 @@
 
 #define CGX_ID_MASK			0x7
 #define MAX_LMAC_PER_CGX		4
+#define MAX_DMAC_ENTRIES_PER_CGX	32
 #define CGX_FIFO_LEN			65536 /* 64K for both Rx & Tx */
 #define CGX_OFFSET(x)			((x) * MAX_LMAC_PER_CGX)
 
@@ -46,6 +47,7 @@
 #define CGXX_CMRX_RX_DMAC_CTL0		(0x1F8 + mac_ops->csr_offset)
 #define CGX_DMAC_CTL0_CAM_ENABLE	BIT_ULL(3)
 #define CGX_DMAC_CAM_ACCEPT		BIT_ULL(3)
+#define CGX_DMAC_MCAST_MODE_CAM		BIT_ULL(2)
 #define CGX_DMAC_MCAST_MODE		BIT_ULL(1)
 #define CGX_DMAC_BCAST_MODE		BIT_ULL(0)
 #define CGXX_CMRX_RX_DMAC_CAM0		(0x200 + mac_ops->csr_offset)
@@ -139,7 +141,11 @@ int cgx_get_rx_stats(void *cgxd, int lmac_id, int idx, u64 *rx_stat);
 int cgx_lmac_rx_tx_enable(void *cgxd, int lmac_id, bool enable);
 int cgx_lmac_tx_enable(void *cgxd, int lmac_id, bool enable);
 int cgx_lmac_addr_set(u8 cgx_id, u8 lmac_id, u8 *mac_addr);
+int cgx_lmac_addr_reset(u8 cgx_id, u8 lmac_id);
 u64 cgx_lmac_addr_get(u8 cgx_id, u8 lmac_id);
+int cgx_lmac_addr_add(u8 cgx_id, u8 lmac_id, u8 *mac_addr);
+int cgx_lmac_addr_del(u8 cgx_id, u8 lmac_id, u8 index);
+int cgx_lmac_addr_max_entries_get(u8 cgx_id, u8 lmac_id);
 void cgx_lmac_promisc_config(int cgx_id, int lmac_id, bool enable);
 void cgx_lmac_enadis_rx_pause_fwding(void *cgxd, int lmac_id, bool enable);
 int cgx_lmac_internal_loopback(void *cgxd, int lmac_id, bool enable);
@@ -165,4 +171,5 @@ u8 cgx_get_lmacid(void *cgxd, u8 lmac_index);
 unsigned long cgx_get_lmac_bmap(void *cgxd);
 void cgx_lmac_write(int cgx_id, int lmac_id, u64 offset, u64 val);
 u64 cgx_lmac_read(int cgx_id, int lmac_id, u64 offset);
+int cgx_lmac_addr_update(u8 cgx_id, u8 lmac_id, u8 *mac_addr, u8 index);
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index 45706fd87120..a0353384183c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -15,6 +15,7 @@
  * @cmd_lock:		Lock to serialize the command interface
  * @resp:		command response
  * @link_info:		link related information
+ * @mac_to_index_bmap:	Mac address to CGX table index mapping
  * @event_cb:		callback for linkchange events
  * @event_cb_lock:	lock for serializing callback with unregister
  * @cmd_pend:		flag set before new command is started
@@ -29,12 +30,14 @@ struct lmac {
 	struct mutex cmd_lock;
 	u64 resp;
 	struct cgx_link_user_info link_info;
+	struct rsrc_bmap mac_to_index_bmap;
 	struct cgx_event_cb event_cb;
 	/* lock for serializing callback with unregister */
 	spinlock_t event_cb_lock;
-	bool cmd_pend;
 	struct cgx *cgx;
+	u8 mcast_filters_count;
 	u8 lmac_id;
+	bool cmd_pend;
 	char *name;
 };
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 770d86262838..2fe2ef62ccf6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -163,7 +163,15 @@ M(CGX_SET_LINK_MODE,	0x214, cgx_set_link_mode, cgx_set_link_mode_req,\
 M(CGX_FEATURES_GET,	0x215, cgx_features_get, msg_req,		\
 			       cgx_features_info_msg)			\
 M(RPM_STATS,		0x216, rpm_stats, msg_req, rpm_stats_rsp)	\
- /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
+M(CGX_MAC_ADDR_ADD,	0x217, cgx_mac_addr_add, cgx_mac_addr_add_req,    \
+			       cgx_mac_addr_add_rsp)		\
+M(CGX_MAC_ADDR_DEL,	0x218, cgx_mac_addr_del, cgx_mac_addr_del_req,    \
+			       msg_rsp)		\
+M(CGX_MAC_MAX_ENTRIES_GET, 0x219, cgx_mac_max_entries_get, msg_req,    \
+				  cgx_max_dmac_entries_get_rsp)		\
+M(CGX_MAC_ADDR_RESET,	0x21A, cgx_mac_addr_reset, msg_req, msg_rsp)	\
+M(CGX_MAC_ADDR_UPDATE,	0x21B, cgx_mac_addr_update, cgx_mac_addr_update_req,    \
+			       msg_rsp)					\
 /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
 M(NPA_LF_ALLOC,		0x400, npa_lf_alloc,				\
 				npa_lf_alloc_req, npa_lf_alloc_rsp)	\
@@ -401,6 +409,38 @@ struct cgx_mac_addr_set_or_get {
 	u8 mac_addr[ETH_ALEN];
 };
 
+/* Structure for requesting the operation to
+ * add DMAC filter entry into CGX interface
+ */
+struct cgx_mac_addr_add_req {
+	struct mbox_msghdr hdr;
+	u8 mac_addr[ETH_ALEN];
+};
+
+/* Structure for response against the operation to
+ * add DMAC filter entry into CGX interface
+ */
+struct cgx_mac_addr_add_rsp {
+	struct mbox_msghdr hdr;
+	u8 index;
+};
+
+/* Structure for requesting the operation to
+ * delete DMAC filter entry from CGX interface
+ */
+struct cgx_mac_addr_del_req {
+	struct mbox_msghdr hdr;
+	u8 index;
+};
+
+/* Structure for response against the operation to
+ * get maximum supported DMAC filter entries
+ */
+struct cgx_max_dmac_entries_get_rsp {
+	struct mbox_msghdr hdr;
+	u8 max_dmac_filters;
+};
+
 struct cgx_link_user_info {
 	uint64_t link_up:1;
 	uint64_t full_duplex:1;
@@ -499,6 +539,12 @@ struct cgx_set_link_mode_rsp {
 	int status;
 };
 
+struct cgx_mac_addr_update_req {
+	struct mbox_msghdr hdr;
+	u8 mac_addr[ETH_ALEN];
+	u8 index;
+};
+
 #define RVU_LMAC_FEAT_FC		BIT_ULL(0) /* pause frames */
 #define RVU_LMAC_FEAT_PTP		BIT_ULL(1) /* precision time protocol */
 #define RVU_MAC_VERSION			BIT_ULL(2)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 9e5d9ba6f01e..32ce564c3872 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -656,6 +656,8 @@ void rvu_cgx_enadis_rx_bp(struct rvu *rvu, int pf, bool enable);
 int rvu_cgx_start_stop_io(struct rvu *rvu, u16 pcifunc, bool start);
 int rvu_cgx_nix_cuml_stats(struct rvu *rvu, void *cgxd, int lmac_id, int index,
 			   int rxtxflag, u64 *stat);
+void rvu_cgx_disable_dmac_entries(struct rvu *rvu, u16 pcifunc);
+
 /* NPA APIs */
 int rvu_npa_init(struct rvu *rvu);
 void rvu_npa_freemem(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 6e2bf4fcd29c..378915f557af 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -454,6 +454,31 @@ int rvu_cgx_config_rxtx(struct rvu *rvu, u16 pcifunc, bool start)
 	return 0;
 }
 
+void rvu_cgx_disable_dmac_entries(struct rvu *rvu, u16 pcifunc)
+{
+	int pf = rvu_get_pf(pcifunc);
+	int i = 0, lmac_count = 0;
+	u8 max_dmac_filters;
+	u8 cgx_id, lmac_id;
+	void *cgx_dev;
+
+	if (!is_cgx_config_permitted(rvu, pcifunc))
+		return;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	cgx_dev = cgx_get_pdata(cgx_id);
+	lmac_count = cgx_get_lmac_cnt(cgx_dev);
+	max_dmac_filters = MAX_DMAC_ENTRIES_PER_CGX / lmac_count;
+
+	for (i = 0; i < max_dmac_filters; i++)
+		cgx_lmac_addr_del(cgx_id, lmac_id, i);
+
+	/* As cgx_lmac_addr_del does not clear entry for index 0
+	 * so it needs to be done explicitly
+	 */
+	cgx_lmac_addr_reset(cgx_id, lmac_id);
+}
+
 int rvu_mbox_handler_cgx_start_rxtx(struct rvu *rvu, struct msg_req *req,
 				    struct msg_rsp *rsp)
 {
@@ -557,6 +582,63 @@ int rvu_mbox_handler_cgx_mac_addr_set(struct rvu *rvu,
 	return 0;
 }
 
+int rvu_mbox_handler_cgx_mac_addr_add(struct rvu *rvu,
+				      struct cgx_mac_addr_add_req *req,
+				      struct cgx_mac_addr_add_rsp *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	u8 cgx_id, lmac_id;
+	int rc = 0;
+
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return -EPERM;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	rc = cgx_lmac_addr_add(cgx_id, lmac_id, req->mac_addr);
+	if (rc >= 0) {
+		rsp->index = rc;
+		return 0;
+	}
+
+	return rc;
+}
+
+int rvu_mbox_handler_cgx_mac_addr_del(struct rvu *rvu,
+				      struct cgx_mac_addr_del_req *req,
+				      struct msg_rsp *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	u8 cgx_id, lmac_id;
+
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return -EPERM;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	return cgx_lmac_addr_del(cgx_id, lmac_id, req->index);
+}
+
+int rvu_mbox_handler_cgx_mac_max_entries_get(struct rvu *rvu,
+					     struct msg_req *req,
+				             struct cgx_max_dmac_entries_get_rsp
+					     *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	u8 cgx_id, lmac_id;
+
+	/* If msg is received from PFs(which are not mapped to CGX LMACs)
+	 * or VF then no entries are allocated for DMAC filters at CGX level.
+	 * So returning zero.
+	 */
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc)) {
+		rsp->max_dmac_filters = 0;
+		return 0;
+	}
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	rsp->max_dmac_filters = cgx_lmac_addr_max_entries_get(cgx_id, lmac_id);
+	return 0;
+}
+
 int rvu_mbox_handler_cgx_mac_addr_get(struct rvu *rvu,
 				      struct cgx_mac_addr_set_or_get *req,
 				      struct cgx_mac_addr_set_or_get *rsp)
@@ -953,3 +1035,30 @@ int rvu_mbox_handler_cgx_set_link_mode(struct rvu *rvu,
 	rsp->status = cgx_set_link_mode(cgxd, req->args, cgx_idx, lmac);
 	return 0;
 }
+
+int rvu_mbox_handler_cgx_mac_addr_reset(struct rvu *rvu, struct msg_req *req,
+					struct msg_rsp *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	u8 cgx_id, lmac_id;
+
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return -EPERM;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	return cgx_lmac_addr_reset(cgx_id, lmac_id);
+}
+
+int rvu_mbox_handler_cgx_mac_addr_update(struct rvu *rvu,
+					 struct cgx_mac_addr_update_req *req,
+					 struct msg_rsp *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	u8 cgx_id, lmac_id;
+
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return -EPERM;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	return cgx_lmac_addr_update(cgx_id, lmac_id, req->mac_addr, req->index);
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index d6f8210652c5..aeae37704428 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -346,6 +346,9 @@ static void nix_interface_deinit(struct rvu *rvu, u16 pcifunc, u8 nixlf)
 
 	/* Free and disable any MCAM entries used by this NIX LF */
 	rvu_npc_disable_mcam_entries(rvu, pcifunc, nixlf);
+
+	/* Disable DMAC filters used */
+	rvu_cgx_disable_dmac_entries(rvu, pcifunc);
 }
 
 int rvu_mbox_handler_nix_bp_disable(struct rvu *rvu,
-- 
2.17.1

