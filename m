Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216EA3407A5
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbhCROQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:16:44 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33240 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231553AbhCROQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:16:17 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IEEX2O027702;
        Thu, 18 Mar 2021 07:16:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=K05IV0kSuRw7P0MJtxO9KntzMNK9aI9S5uDbGoNj2Hk=;
 b=TItg7rpTNl9SVo3MLjCC77JfplZxEIivqSoA1MSdFcFVj8OQD6Jzryr5Ip2OTaXZlrUS
 eXIyRUMQxknBxvAYaN6L5ch6C8/Cc840U0/N/Aeot4fXSUyfsdifilzX+QUq6q92kZc1
 gk9Rqy6dOUQXNau53iPjksX8APbHm5DLyrwsLF40CEo6Uhos44j828sxlUfJQxI5wQCP
 mp3EQhtkmfMqH+eWKBnb468omEUgVqD6+XdM38wLqMn1b+P+tI8eQO2QKRbnEGPiTTkX
 V4M35rvNh879vNo5amaAyZ0gpiYtGWqThAt+Adeui9PpSnYj+NKEN2IglI+KHf+AWzVq 5w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 37c5bf0q6h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 07:16:12 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Mar
 2021 07:16:09 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 18 Mar 2021 07:16:09 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id A05EA3F7043;
        Thu, 18 Mar 2021 07:16:05 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [net PATCH v2 4/8] octeontx2-af: Return correct CGX RX fifo size
Date:   Thu, 18 Mar 2021 19:45:45 +0530
Message-ID: <20210318141549.2622-5-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210318141549.2622-1-hkelam@marvell.com>
References: <20210318141549.2622-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_07:2021-03-17,2021-03-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

CGX receive buffer size is a constant value and
cannot be read from CGX0 block always since
CGX0 may not enabled everytime. Hence return CGX
receive buffer size from first enabled CGX block
instead of CGX0.

Fixes: 6e54e1c5399a ("octeontx2-af: cn10K: MTU configuration")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.h    |  1 +
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c    | 18 ++++++++++++++++--
 .../marvell/octeontx2/af/rvu_debugfs.c         |  9 +++++----
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index fa6e46e36ae..76f399229dd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -678,6 +678,7 @@ void npc_read_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 			 u8 *intf, u8 *ena);
 bool is_mac_feature_supported(struct rvu *rvu, int pf, int feature);
 u32  rvu_cgx_get_fifolen(struct rvu *rvu);
+void *rvu_first_cgx_pdata(struct rvu *rvu);
 
 /* CPT APIs */
 int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index e668e482383..6e2bf4fcd29 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -89,6 +89,21 @@ void *rvu_cgx_pdata(u8 cgx_id, struct rvu *rvu)
 	return rvu->cgx_idmap[cgx_id];
 }
 
+/* Return first enabled CGX instance if none are enabled then return NULL */
+void *rvu_first_cgx_pdata(struct rvu *rvu)
+{
+	int first_enabled_cgx = 0;
+	void *cgxd = NULL;
+
+	for (; first_enabled_cgx < rvu->cgx_cnt_max; first_enabled_cgx++) {
+		cgxd = rvu_cgx_pdata(first_enabled_cgx, rvu);
+		if (cgxd)
+			break;
+	}
+
+	return cgxd;
+}
+
 /* Based on P2X connectivity find mapped NIX block for a PF */
 static void rvu_map_cgx_nix_block(struct rvu *rvu, int pf,
 				  int cgx_id, int lmac_id)
@@ -711,10 +726,9 @@ int rvu_mbox_handler_cgx_features_get(struct rvu *rvu,
 u32 rvu_cgx_get_fifolen(struct rvu *rvu)
 {
 	struct mac_ops *mac_ops;
-	int rvu_def_cgx_id = 0;
 	u32 fifo_len;
 
-	mac_ops = get_mac_ops(rvu_cgx_pdata(rvu_def_cgx_id, rvu));
+	mac_ops = get_mac_ops(rvu_first_cgx_pdata(rvu));
 	fifo_len = mac_ops ? mac_ops->fifo_len : 0;
 
 	return fifo_len;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index dc946953af0..b4c53b19f53 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -331,7 +331,6 @@ static int rvu_dbg_rvu_pf_cgx_map_display(struct seq_file *filp, void *unused)
 	struct rvu *rvu = filp->private;
 	struct pci_dev *pdev = NULL;
 	struct mac_ops *mac_ops;
-	int rvu_def_cgx_id = 0;
 	char cgx[10], lmac[10];
 	struct rvu_pfvf *pfvf;
 	int pf, domain, blkid;
@@ -339,7 +338,10 @@ static int rvu_dbg_rvu_pf_cgx_map_display(struct seq_file *filp, void *unused)
 	u16 pcifunc;
 
 	domain = 2;
-	mac_ops = get_mac_ops(rvu_cgx_pdata(rvu_def_cgx_id, rvu));
+	mac_ops = get_mac_ops(rvu_first_cgx_pdata(rvu));
+	/* There can be no CGX devices at all */
+	if (!mac_ops)
+		return 0;
 	seq_printf(filp, "PCI dev\t\tRVU PF Func\tNIX block\t%s\tLMAC\n",
 		   mac_ops->name);
 	for (pf = 0; pf < rvu->hw->total_pfs; pf++) {
@@ -1830,7 +1832,6 @@ static void rvu_dbg_cgx_init(struct rvu *rvu)
 {
 	struct mac_ops *mac_ops;
 	unsigned long lmac_bmap;
-	int rvu_def_cgx_id = 0;
 	int i, lmac_id;
 	char dname[20];
 	void *cgx;
@@ -1838,7 +1839,7 @@ static void rvu_dbg_cgx_init(struct rvu *rvu)
 	if (!cgx_get_cgxcnt_max())
 		return;
 
-	mac_ops = get_mac_ops(rvu_cgx_pdata(rvu_def_cgx_id, rvu));
+	mac_ops = get_mac_ops(rvu_first_cgx_pdata(rvu));
 	if (!mac_ops)
 		return;
 
-- 
2.17.1

