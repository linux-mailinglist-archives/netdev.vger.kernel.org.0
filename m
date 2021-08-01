Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716EB3DCB17
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 12:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbhHAK1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 06:27:00 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17646 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231470AbhHAK1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 06:27:00 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 171AM11i011744;
        Sun, 1 Aug 2021 03:26:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=j1cc0t6HcOVwxZFsZoFpe1mcreiAB1gAQj6mvO/pmTs=;
 b=G8OWwh9cjZeeYl9BPzeiUUki3UDriTO3nWJMhMZkoSxKfhrhAJZAraLfPA54YT1Yts1F
 zdFWerChjNUX4EDLjBpI76SNMo6p+UtW1OAdqHqbEp5Ge6s6GPVlP7QWm8H5tUVdT/TP
 sl1qX4DeEhocsKj2Ik3yur8aAioCo7Smd23HntsD1m3x4/zOW6Yfnqbgvc4EHqZXDXTc
 SoCoi38KAvR7gTsJ9pF7Ni1kpsueJS7GlQe6Bho+gUfPEpKCeiMKasJ7CPBzhw1RMWOz
 EZC9b5b5rEPGdsEvrRROssS436Q0Yl90lVn39xU15IzOQVLBQpOqHlTEmjdwYt2PEgXZ 8w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a53vrahae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 01 Aug 2021 03:26:48 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 1 Aug
 2021 03:26:47 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Sun, 1 Aug 2021 03:26:45 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <aelior@marvell.com>, <smalin@marvell.com>, <malin1024@gmail.com>
Subject: [PATCH] qed: Skip DORQ attention handling during recovery
Date:   Sun, 1 Aug 2021 13:26:38 +0300
Message-ID: <20210801102638.20926-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: tRcq0Mx0QIwu-7g0GN_y8PHXo17eUF4X
X-Proofpoint-GUID: tRcq0Mx0QIwu-7g0GN_y8PHXo17eUF4X
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-31_14:2021-07-30,2021-07-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device recovery flow will reset the entire HW device, in that case
the DORQ HW block attention is redundant.

Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_int.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 578935f643b8..ab6d4f737316 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -464,12 +464,19 @@ static int qed_dorq_attn_int_sts(struct qed_hwfn *p_hwfn)
 	u32 int_sts, first_drop_reason, details, address, all_drops_reason;
 	struct qed_ptt *p_ptt = p_hwfn->p_dpc_ptt;
 
+	int_sts = qed_rd(p_hwfn, p_ptt, DORQ_REG_INT_STS);
+	if (int_sts == 0xdeadbeaf) {
+		DP_NOTICE(p_hwfn->cdev,
+			  "DORQ is being reset, skipping int_sts handler\n");
+
+		return 0;
+	}
+
 	/* int_sts may be zero since all PFs were interrupted for doorbell
 	 * overflow but another one already handled it. Can abort here. If
 	 * This PF also requires overflow recovery we will be interrupted again.
 	 * The masked almost full indication may also be set. Ignoring.
 	 */
-	int_sts = qed_rd(p_hwfn, p_ptt, DORQ_REG_INT_STS);
 	if (!(int_sts & ~DORQ_REG_INT_STS_DORQ_FIFO_AFULL))
 		return 0;
 
@@ -528,6 +535,9 @@ static int qed_dorq_attn_int_sts(struct qed_hwfn *p_hwfn)
 
 static int qed_dorq_attn_cb(struct qed_hwfn *p_hwfn)
 {
+	if (p_hwfn->cdev->recov_in_prog)
+		return 0;
+
 	p_hwfn->db_recovery_info.dorq_attn = true;
 	qed_dorq_attn_overflow(p_hwfn);
 
-- 
2.22.0

