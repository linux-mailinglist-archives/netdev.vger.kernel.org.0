Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B005B146624
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgAWK7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:59:15 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:62892 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729093AbgAWK7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:59:14 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00NAux3Q021434;
        Thu, 23 Jan 2020 02:59:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Q5u9rEPVyOP2CCWp2gnJwVwfJRYcSvNRxR3GTxUX1QE=;
 b=Tf+Q7sjSE4dNa4cO95qXVxpgqrYpUbI0iASKw463o31C9ThJDc4ECwtFWe7QBrOimbOE
 LZxoTNo70KYBNs0WT5QIFzmHf7NU16LVPHqpCuWOu0+aa30T0ePr1hcRO+0cataV/whL
 bPxD9tKjARlXcCzUOTTYfnUMUKO+6msWTSd+/yATRnysAjznY29qTIvXWyyMTKM9/Yvj
 EdY++OrXxUl8xenBLm/sXToi+y7N/SYamcAOZ6WTwzu8E/M4xXPfTk4LHdp0ei1uKepy
 heyUcoxRqcDLmOiONOcqYnf6vybpmeyXDJnUuI/y3qCVzuSFJQsKAVeM2nmqAhTLRNJl /g== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2xq4x4h308-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 Jan 2020 02:59:12 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Jan
 2020 02:59:11 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 23 Jan 2020 02:59:11 -0800
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id A5F713F7041;
        Thu, 23 Jan 2020 02:59:09 -0800 (PST)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 net-next 12/13] qed: rt init valid initialization changed
Date:   Thu, 23 Jan 2020 12:58:35 +0200
Message-ID: <20200123105836.15090-13-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200123105836.15090-1-michal.kalderon@marvell.com>
References: <20200123105836.15090-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-23_08:2020-01-23,2020-01-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The QM phase init tool can be invoked multiple times during
the driver lifetime. Part of the init comes from the runtime array.
The logic for setting the values did not init all values, basically
assuming the runtime array was all zeroes. But if it was invoked
multiple times, nobody was zeroing it after the first time.

In this change we zero the runtime array right after using it.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c      |  3 ---
 drivers/net/ethernet/qlogic/qed/qed_init_ops.c | 16 ++++++----------
 drivers/net/ethernet/qlogic/qed/qed_init_ops.h |  8 --------
 3 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index df97810b09b9..3fb73ce8c1d6 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -2106,9 +2106,6 @@ int qed_qm_reconf(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	if (!b_rc)
 		return -EINVAL;
 
-	/* clear the QM_PF runtime phase leftovers from previous init */
-	qed_init_clear_rt_data(p_hwfn);
-
 	/* prepare QM portion of runtime array */
 	qed_qm_init_pf(p_hwfn, p_ptt, false);
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_ops.c b/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
index 36f998c89e74..5a6e4ac4fef4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
@@ -74,15 +74,6 @@ void qed_init_iro_array(struct qed_dev *cdev)
 	cdev->iro_arr = iro_arr;
 }
 
-/* Runtime configuration helpers */
-void qed_init_clear_rt_data(struct qed_hwfn *p_hwfn)
-{
-	int i;
-
-	for (i = 0; i < RUNTIME_ARRAY_SIZE; i++)
-		p_hwfn->rt_data.b_valid[i] = false;
-}
-
 void qed_init_store_rt_reg(struct qed_hwfn *p_hwfn, u32 rt_offset, u32 val)
 {
 	p_hwfn->rt_data.init_val[rt_offset] = val;
@@ -106,7 +97,7 @@ static int qed_init_rt(struct qed_hwfn	*p_hwfn,
 {
 	u32 *p_init_val = &p_hwfn->rt_data.init_val[rt_offset];
 	bool *p_valid = &p_hwfn->rt_data.b_valid[rt_offset];
-	u16 i, segment;
+	u16 i, j, segment;
 	int rc = 0;
 
 	/* Since not all RT entries are initialized, go over the RT and
@@ -121,6 +112,7 @@ static int qed_init_rt(struct qed_hwfn	*p_hwfn,
 		 */
 		if (!b_must_dmae) {
 			qed_wr(p_hwfn, p_ptt, addr + (i << 2), p_init_val[i]);
+			p_valid[i] = false;
 			continue;
 		}
 
@@ -135,6 +127,10 @@ static int qed_init_rt(struct qed_hwfn	*p_hwfn,
 		if (rc)
 			return rc;
 
+		/* invalidate after writing */
+		for (j = i; j < i + segment; j++)
+			p_valid[j] = false;
+
 		/* Jump over the entire segment, including invalid entry */
 		i += segment;
 	}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_ops.h b/drivers/net/ethernet/qlogic/qed/qed_init_ops.h
index 555dd086796d..e9e8ade50ed3 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_ops.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_ops.h
@@ -80,14 +80,6 @@ int qed_init_alloc(struct qed_hwfn *p_hwfn);
  */
 void qed_init_free(struct qed_hwfn *p_hwfn);
 
-/**
- * @brief qed_init_clear_rt_data - Clears the runtime init array.
- *
- *
- * @param p_hwfn
- */
-void qed_init_clear_rt_data(struct qed_hwfn *p_hwfn);
-
 /**
  * @brief qed_init_store_rt_reg - Store a configuration value in the RT array.
  *
-- 
2.14.5

