Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466C92B44B5
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 14:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbgKPNaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 08:30:05 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27064 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727524AbgKPNaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 08:30:05 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGDQnjp028234;
        Mon, 16 Nov 2020 05:30:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=cl+gco20jtEDeG/jmJGGZgACrXQ/mMNL4wdOZQErDOs=;
 b=fd5y2403xIJfn/iA/6yU09wu/lHclBuSCHHQukUKYRBR8geH38wIRyHaWgh6hb08APrO
 E2z7rKK3brMBAtkVXSJgNvL/kkOPNTG3mTBi+wMCDtD8qUMDpIXhYPQTRLSRVt23xiz/
 JLFyH1VUv6f9YQAjq9EVJTcVGs9nkzBZd78L5b1YMJ9+HhDwRfcIhDZ46HxE+KnBRnR9
 lt1khQ+YCp5Z0ijzRu90AFEW7NFEEHp9xsb/aysamsSctupl0u0nJJ3/rFQ7nnUJEvTm
 T+Pmq/p7mSbFJlln9/BuTBZ1aUyKuK6rcZAGGXV5fnbRzpx2FMgCnqA/eeQmFO9jw3w1 7A== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 34tfmsd244-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 05:29:59 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 16 Nov
 2020 05:29:57 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 16 Nov
 2020 05:29:56 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 16 Nov 2020 05:29:56 -0800
Received: from NN-LT0065.marvell.com (NN-LT0065.marvell.com [10.193.39.198])
        by maili.marvell.com (Postfix) with ESMTP id C9D773F703F;
        Mon, 16 Nov 2020 05:29:54 -0800 (PST)
From:   Dmitry Bogdanov <dbogdanov@marvell.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Dmitry Bogdanov <dbogdanov@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>,
        Ariel Elior <aelior@marvell.com>
Subject: [PATCH net] qed: fix ILT configuration of SRC block
Date:   Mon, 16 Nov 2020 16:29:44 +0300
Message-ID: <20201116132944.2055-1-dbogdanov@marvell.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_05:2020-11-13,2020-11-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code refactoring of ILT configuration was not complete, the old
unused variables were used for the SRC block. That could lead to the memory
corruption by HW when rx filters are configured.
This patch completes that refactoring.

Fixes: 8a52bbab39c9 (qed: Debug feature: ilt and mdump)
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c | 4 ++--
 drivers/net/ethernet/qlogic/qed/qed_cxt.h | 3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index 0e4cd8890cff..0a22f8ce9a2c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -1647,9 +1647,9 @@ static void qed_src_init_pf(struct qed_hwfn *p_hwfn)
 		     ilog2(rounded_conn_num));
 
 	STORE_RT_REG_AGG(p_hwfn, SRC_REG_FIRSTFREE_RT_OFFSET,
-			 p_hwfn->p_cxt_mngr->first_free);
+			 p_hwfn->p_cxt_mngr->src_t2.first_free);
 	STORE_RT_REG_AGG(p_hwfn, SRC_REG_LASTFREE_RT_OFFSET,
-			 p_hwfn->p_cxt_mngr->last_free);
+			 p_hwfn->p_cxt_mngr->src_t2.last_free);
 }
 
 /* Timers PF */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.h b/drivers/net/ethernet/qlogic/qed/qed_cxt.h
index 8b64495f8745..056e79620a0e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.h
@@ -326,9 +326,6 @@ struct qed_cxt_mngr {
 
 	/* SRC T2 */
 	struct qed_src_t2 src_t2;
-	u32 t2_num_pages;
-	u64 first_free;
-	u64 last_free;
 
 	/* total number of SRQ's for this hwfn */
 	u32 srq_count;
-- 
2.25.1

