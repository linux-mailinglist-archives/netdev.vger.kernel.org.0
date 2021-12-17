Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48950479209
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 17:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239434AbhLQQ4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 11:56:24 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50546 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235644AbhLQQ4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 11:56:24 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BHAhntW030897;
        Fri, 17 Dec 2021 08:56:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=5SavgyjTtx8dk4rUHFUsm/92sKwTcZyMFbR2hQu/3iE=;
 b=RwIB2ixdjOV+uFyJ66+sXaXJSsW0UHUsrNVikT95eKGdGeWKh3XglgDfPtWTH/XQ2Ix2
 D/NJvL+AW8vcb+PfMpjxRr1K2Og/D+NCjsqLcAJswVQyODUKa26XLxmFDuxwBRgnLqhl
 m47ZNYyC5oGtBi6lCAb3LjUJ8JY6usTnEHGcAQa0E4wPP+krRowCHIlfyM9cwxIsp39N
 jpc9XQTL2FKCIXBHcLt2xhJzgD8+7ggHleaXVEwURtcMf06GE84UYuvdhAM+Y9WQVbVB
 c05cQvkDwlfSjyuirdTdtYg9oV5PO5i/Mq1bCikyQgrrdXfG1+s6GZR72EVWnmPcOYQW gw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3d0s28h7dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 08:56:16 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 17 Dec
 2021 08:56:14 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 17 Dec 2021 08:56:14 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id AD1D53F7093;
        Fri, 17 Dec 2021 08:56:14 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1BHGuEmR000819;
        Fri, 17 Dec 2021 08:56:14 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1BHGuEUQ000818;
        Fri, 17 Dec 2021 08:56:14 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <palok@marvell.com>, <pkushwaha@marvell.com>
Subject: [PATCH v2 net-next 2/2] bnx2x: Invalidate fastpath HSI version for VFs
Date:   Fri, 17 Dec 2021 08:55:52 -0800
Message-ID: <20211217165552.746-2-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211217165552.746-1-manishc@marvell.com>
References: <20211217165552.746-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: FyEmiwP37bruH5qBWbdRoaX0jWkkoKix
X-Proofpoint-ORIG-GUID: FyEmiwP37bruH5qBWbdRoaX0jWkkoKix
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_06,2021-12-16_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 0a6890b9b4df ("bnx2x: Utilize FW 7.13.15.0.")
added validation for fastpath HSI versions for different
client init which was not meant for SR-IOV VF clients, which
resulted in firmware asserts when running VF clients with
different fastpath HSI version.

This patch along with the new firmware support in patch #1
fixes this behavior in order to not validate fastpath HSI
version for the VFs.

Fixes: 0a6890b9b4df ("bnx2x: Utilize FW 7.13.15.0.")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---

v1->v2:
------------

* Invalidate fastpath HSI version for VFs based on firmware capability,
  as now driver can also be compatible with older firmware too and only
  newer firmware has that capability to invalidate fastpath HSI version
  for the VFs.
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index 74a8931..11d15cd 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -758,9 +758,18 @@ static void bnx2x_vf_igu_reset(struct bnx2x *bp, struct bnx2x_virtf *vf)
 
 void bnx2x_vf_enable_access(struct bnx2x *bp, u8 abs_vfid)
 {
+	u16 abs_fid;
+
+	abs_fid = FW_VF_HANDLE(abs_vfid);
+
 	/* set the VF-PF association in the FW */
-	storm_memset_vf_to_pf(bp, FW_VF_HANDLE(abs_vfid), BP_FUNC(bp));
-	storm_memset_func_en(bp, FW_VF_HANDLE(abs_vfid), 1);
+	storm_memset_vf_to_pf(bp, abs_fid, BP_FUNC(bp));
+	storm_memset_func_en(bp, abs_fid, 1);
+
+	/* Invalidate fp_hsi version for vfs */
+	if (bp->fw_cap & FW_CAP_INVALIDATE_VF_FP_HSI)
+		REG_WR8(bp, BAR_XSTRORM_INTMEM +
+			    XSTORM_ETH_FUNCTION_INFO_FP_HSI_VALID_E2_OFFSET(abs_fid), 0);
 
 	/* clear vf errors*/
 	bnx2x_vf_semi_clear_err(bp, abs_vfid);
-- 
1.8.3.1

