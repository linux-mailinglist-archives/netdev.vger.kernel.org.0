Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D34B43BB12
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235630AbhJZTkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 15:40:46 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21994 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232476AbhJZTkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 15:40:45 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QI62ZF014837;
        Tue, 26 Oct 2021 12:38:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=c2si+QE7iJcIxk579go/1Wq6faMD2FCmKaeLetYxsmI=;
 b=M8KpCC/ajWn+DsW+ec+Y/GqEYG/zQuB4o7TG/KOfk2mAXx3EbwehAx3WBJfYjOu2pZu5
 nKDQMfbS/ah9NbPEvIszimGYXSdNiwOUxHakTjffKOYEfgAVI4MUGjLnT3NzEVYNloHC
 SSFy+y2NER2fWGNFQqSptk7HJHtYxR7ElCaHjvmKCk63dUXFZV9XAaIWHWBIwRgMz7nh
 +mK+guV4PqvthX2Ll83oZ9Xi6lYy8PY3k+ZWyJOFszqKw3hHu+uEdtjNKMLRvOm86lU7
 m5Nt89nl9ca82qO9l6AyidSLuCFSJq4Cfosf7nqIkX7oraDL74jepxlTvZjDTjAqlCOo FQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bxfv8jct9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 12:38:19 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 12:38:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 12:38:17 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3F60E3F7072;
        Tue, 26 Oct 2021 12:38:17 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19QJc9t8002707;
        Tue, 26 Oct 2021 12:38:09 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19QJbxad002706;
        Tue, 26 Oct 2021 12:37:59 -0700
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stable@vger.kernel.org>,
        <aelior@marvell.com>, <skalluru@marvell.com>,
        <malin1024@gmail.com>, <smalin@marvell.com>,
        <okulkarni@marvell.com>, <njavali@marvell.com>,
        <GR-everest-linux-l2@marvell.com>
Subject: [PATCH net-next 2/2] bnx2x: Invalidate fastpath HSI version for VFs
Date:   Tue, 26 Oct 2021 12:37:17 -0700
Message-ID: <20211026193717.2657-2-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211026193717.2657-1-manishc@marvell.com>
References: <20211026193717.2657-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: hcRz9Q3OwcrW7AIo6EPPL0j_CYzwUBwV
X-Proofpoint-ORIG-GUID: hcRz9Q3OwcrW7AIo6EPPL0j_CYzwUBwV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_05,2021-10-26_01,2020-04-07_01
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
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index 9c2f51f23035..b1817f5e6179 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -758,9 +758,17 @@ static void bnx2x_vf_igu_reset(struct bnx2x *bp, struct bnx2x_virtf *vf)
 
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
+	REG_WR8(bp,
+		BAR_XSTRORM_INTMEM + XSTORM_ETH_FUNCTION_INFO_FP_HSI_VALID_E2_OFFSET(abs_fid), 0);
 
 	/* clear vf errors*/
 	bnx2x_vf_semi_clear_err(bp, abs_vfid);
-- 
2.27.0

