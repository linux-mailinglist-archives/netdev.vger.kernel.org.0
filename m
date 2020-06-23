Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46DD2053F1
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 15:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732859AbgFWNxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 09:53:55 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:65256 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732776AbgFWNxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 09:53:52 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NDp8Qh021767;
        Tue, 23 Jun 2020 06:53:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=RKQ2xCotOR6edEzzJ1eROvhMPtUKJ2saThGF8IxUU+M=;
 b=HehzIM1/eJmPjULvYCF/MaJLVoPAaZRkBOkc6sy9v6bJrKICAfEzPdISVcJkvILDF/HR
 bP5P6CtXUJyE+EkFHX/5rLlBCCCSuVZ08zMU6efwHLQR13uPkAwe53tDTT9khpWhZAFQ
 CoAymGAbnbGwHdPPmWMeV6HOVw0J1sXI0mTfP7TbsjYXaKoi9qS3nPlTsgS2sG8wAF09
 O4hNX8hXLiw+chF2YwBebMb/I+yy+hEd1g0Qq0wmyl633UJ81DgleASySuNlNNO1sUNh
 TIWaoCHShNJEgZSR48Zwbb1dNasV5t3lUY7EOQGwxK56qHW5bPXwIT7rOhln9q7toOP5 kw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 31shynwjh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 06:53:49 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Jun
 2020 06:53:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 23 Jun 2020 06:53:47 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.39.36])
        by maili.marvell.com (Postfix) with ESMTP id A50043F703F;
        Tue, 23 Jun 2020 06:53:43 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "Denis Bolotin" <denis.bolotin@marvell.com>,
        Tomer Tayar <tomer.tayar@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net 8/9] net: qed: reset ILT block sizes before recomputing to fix crashes
Date:   Tue, 23 Jun 2020 16:51:36 +0300
Message-ID: <20200623135136.3185-9-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623135136.3185-1-alobakin@marvell.com>
References: <20200623135136.3185-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_06:2020-06-23,2020-06-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sizes of all ILT blocks must be reset before ILT recomputing when
disabling clients, or memory allocation may exceed ILT shadow array
and provoke system crashes.

Fixes: 1408cc1fa48c ("qed: Introduce VFs")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index c0a769b5358c..08ba9d54ab63 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -465,6 +465,20 @@ static struct qed_ilt_cli_blk *qed_cxt_set_blk(struct qed_ilt_cli_blk *p_blk)
 	return p_blk;
 }
 
+static void qed_cxt_ilt_blk_reset(struct qed_hwfn *p_hwfn)
+{
+	struct qed_ilt_client_cfg *clients = p_hwfn->p_cxt_mngr->clients;
+	u32 cli_idx, blk_idx;
+
+	for (cli_idx = 0; cli_idx < MAX_ILT_CLIENTS; cli_idx++) {
+		for (blk_idx = 0; blk_idx < ILT_CLI_PF_BLOCKS; blk_idx++)
+			clients[cli_idx].pf_blks[blk_idx].total_size = 0;
+
+		for (blk_idx = 0; blk_idx < ILT_CLI_VF_BLOCKS; blk_idx++)
+			clients[cli_idx].vf_blks[blk_idx].total_size = 0;
+	}
+}
+
 int qed_cxt_cfg_ilt_compute(struct qed_hwfn *p_hwfn, u32 *line_count)
 {
 	struct qed_cxt_mngr *p_mngr = p_hwfn->p_cxt_mngr;
@@ -484,6 +498,11 @@ int qed_cxt_cfg_ilt_compute(struct qed_hwfn *p_hwfn, u32 *line_count)
 
 	p_mngr->pf_start_line = RESC_START(p_hwfn, QED_ILT);
 
+	/* Reset all ILT blocks at the beginning of ILT computing in order
+	 * to prevent memory allocation for irrelevant blocks afterwards.
+	 */
+	qed_cxt_ilt_blk_reset(p_hwfn);
+
 	DP_VERBOSE(p_hwfn, QED_MSG_ILT,
 		   "hwfn [%d] - Set context manager starting line to be 0x%08x\n",
 		   p_hwfn->my_id, p_hwfn->p_cxt_mngr->pf_start_line);
-- 
2.25.1

