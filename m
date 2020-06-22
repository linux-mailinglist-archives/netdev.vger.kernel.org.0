Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEC020359C
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgFVLZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:25:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21000 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727955AbgFVLPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:15:02 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MB86JL013007;
        Mon, 22 Jun 2020 04:15:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=t61gr90XUmF1EdJfqxeNJL/nWPEZkaPM8vewOmDazWA=;
 b=cNClfcIJQH9lUoH0AJGTkuPV4yOaF783Am9LRQGLUkZKNq9KBdRfkA4zKUivu3Fcq3gj
 ZnVtl95AGQ3k2Ran0xy/RohWxVbAFOB3UOFR+hiWqTgiF689NQb/qhSoI3C8IpHAGlIf
 0OfP2TBSFppAqZgiqRPszbpUSf6h/ejtCejYyCUSFmR/lsXHA0RcsZctoqQ3qa2tLXc/
 0HGKv4Xp/4iWcnDaPLe8KeK1mnsQSNSYomyge1gg0c9sD3nYUKA6JBRDmm52VZ33x4+N
 d+oFwBOUpiOu0ALh+3UdkDKN0L4Z32rkcft6uS2LKCp3/ZtUfOkeza507Vixk4CugmEE 8A== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 31shynqpbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 04:14:59 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 04:14:58 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 04:14:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 04:14:57 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.39.36])
        by maili.marvell.com (Postfix) with ESMTP id B7E333F7041;
        Mon, 22 Jun 2020 04:14:53 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Yuval Mintz <yuval.mintz@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Ram Amrani" <ram.amrani@marvell.com>,
        Tomer Tayar <tomer.tayar@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 8/9] net: qed: reset ILT block sizes before recomputing to fix crashes
Date:   Mon, 22 Jun 2020 14:14:12 +0300
Message-ID: <20200622111413.7006-9-alobakin@marvell.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200622111413.7006-1-alobakin@marvell.com>
References: <20200622111413.7006-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_04:2020-06-22,2020-06-22 signatures=0
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
2.21.0

