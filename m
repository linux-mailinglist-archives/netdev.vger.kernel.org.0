Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD2433D0C4
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236231AbhCPJ1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:27:53 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37212 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233289AbhCPJ1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:27:38 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G9QJGs020134;
        Tue, 16 Mar 2021 02:27:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=tAr03vwYRwSaf/dVR2GM9hYb2umlXw9LTqLhioVpGoE=;
 b=H4VBIZqr8BKVJhG8Aj99ld0f8BbL+bbQoKe+mB5BnQNov76ohq/xq6wNxvtMXwR7cX20
 l4/5Cd1CBK6na6EJxgeZynrHXeb7wxMPAruYIsvpspc3plQGl11eax95kY5Fz1ZFfBrP
 kqGNoctsUhNs4yqp7qEfNnNyjCbVAQdY+f45jqNQrgIuYp2Q/9leA2VIiJif1lE62nb9
 Sdm/veGjYhJTGZGLX+19DKydkvBd+NdEK7IE4a2jCBs+ujcqCDtxXS1NH/Y8ano0ft+K
 lRmC97PB+uuWDdYCaTD6jLqzoULBL2Wb4UBHXbbylDuGhnXHyQav9EW7j6j/djvDJ8Le AA== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0a-0016f401.pphosted.com with ESMTP id 378umtfrbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 02:27:36 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 16 Mar 2021 05:27:35 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Mar 2021 05:27:35 -0400
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id CF4883F7040;
        Tue, 16 Mar 2021 02:27:31 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH 5/9] octeontx2-af: Return correct CGX RX fifo size
Date:   Tue, 16 Mar 2021 14:57:09 +0530
Message-ID: <1615886833-71688-6-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
References: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_03:2021-03-15,2021-03-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

CGX receive buffer size is a constant value and
cannot be read from CGX0 block always since
CGX0 may not enabled everytime. Hence return CGX
receive buffer size from first enabled CGX block
instead of CGX0.

Fixes: 6e54e1c5("octeontx2-af: cn10K: MTU configuration")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h        |  1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 18 ++++++++++++++++--
 .../net/ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  9 +++++----
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index fa6e46e..76f3992 100644
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
index e668e48..6e2bf4f 100644
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
index dc94695..b4c53b19 100644
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
2.7.4

