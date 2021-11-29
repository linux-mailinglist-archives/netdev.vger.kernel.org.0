Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A69461672
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343781AbhK2Nf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:35:26 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40904 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230274AbhK2NdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:33:25 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AT7Z4Dp008095;
        Mon, 29 Nov 2021 05:30:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=wPcqmlrqVOy1zqdU7qD8kZaNaTapG/INAE8Q3b43pdc=;
 b=NQRKsB+qbxEui6lJq2vRl4yBAuvssN+C/xvhBQilI8AMTYmLp/1Uh47wWyWHzA3ylOjx
 IpZO4enncTs/RhVUj62LDifKnUPOD9fZxPwsqxj/tNB69zySq9ql+8xmlM5unZmmcZYy
 FSfHMr8UaZSKjIDq/6OOYBEpmFyvcWmZZjTx3Vf6dW/7uW1XZpaQ3psuJjj5XCkvuvZ2
 cvZ1qn/my4GWyOsKG09Q+fr8PqeB5Z+I6vxL1VXzCHk2L3WD2i1HivoEIS9pdUgAKqrV
 YIatXy/7APAPKOhfErTNriPeIy5I0thxChEKs1h8Zw8fPwrrhRXxA/n8TlCLcLgOBXWP Og== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3cmtkph4bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 05:30:06 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 29 Nov
 2021 05:29:57 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 29 Nov 2021 05:29:57 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3EA7D3F70B1;
        Mon, 29 Nov 2021 05:29:57 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1ATDTid8016088;
        Mon, 29 Nov 2021 05:29:44 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1ATDTT3R016087;
        Mon, 29 Nov 2021 05:29:29 -0800
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <irusskikh@marvell.com>,
        <dbezrukov@marvell.com>
Subject: [PATCH net 1/7] atlantic: Increase delay for fw transactions
Date:   Mon, 29 Nov 2021 05:28:23 -0800
Message-ID: <20211129132829.16038-2-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211129132829.16038-1-skalluru@marvell.com>
References: <20211129132829.16038-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: CTS-MVA3JXeBzRu33-YzWxNam_dvBoHd
X-Proofpoint-ORIG-GUID: CTS-MVA3JXeBzRu33-YzWxNam_dvBoHd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_08,2021-11-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbezrukov@marvell.com>

The max waiting period (of 1 ms) while reading the data from FW shared
buffer is too small for certain types of data (e.g., stats). There's a
chance that FW could be updating buffer at the same time and driver
would be unsuccessful in reading data. Firmware manual recommends to
have 1 sec timeout to fix this issue.

Fixes: 5cfd54d7dc186 ("net: atlantic: minimal A2 fw_ops")
Signed-off-by: Dmitry Bogdanov <dbezrukov@marvell.com>
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c  | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
index dd259c8f2f4f..b0e4119b9883 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
@@ -84,7 +84,7 @@ static int hw_atl2_shared_buffer_read_block(struct aq_hw_s *self,
 			if (cnt > AQ_A2_FW_READ_TRY_MAX)
 				return -ETIME;
 			if (tid1.transaction_cnt_a != tid1.transaction_cnt_b)
-				udelay(1);
+				mdelay(1);
 		} while (tid1.transaction_cnt_a != tid1.transaction_cnt_b);
 
 		hw_atl2_mif_shared_buf_read(self, offset, (u32 *)data, dwords);
@@ -339,8 +339,11 @@ static int aq_a2_fw_update_stats(struct aq_hw_s *self)
 {
 	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
 	struct statistics_s stats;
+	int err;
 
-	hw_atl2_shared_buffer_read_safe(self, stats, &stats);
+	err = hw_atl2_shared_buffer_read_safe(self, stats, &stats);
+	if (err)
+		return err;
 
 #define AQ_SDELTA(_N_, _F_) (self->curr_stats._N_ += \
 			stats.msm._F_ - priv->last_stats.msm._F_)
-- 
2.27.0

