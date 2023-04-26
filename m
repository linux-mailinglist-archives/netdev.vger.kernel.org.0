Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714306EEE49
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 08:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239554AbjDZGZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 02:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239553AbjDZGZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 02:25:50 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A0C30E0;
        Tue, 25 Apr 2023 23:25:48 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33Q64EO3000793;
        Tue, 25 Apr 2023 23:25:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=zeIeryuOiIUBXeGJD+J23mt64xIQ8+8w7Mz6CIqAYR4=;
 b=kOwwt0haqH8/GePWXfhj53H29FHEvKnI2GZartZIDIxIpbxHYV1Gw4gRNWZIu/JLrkKe
 jdGmUjJQ025IEWtb5n2PPwMzv78RJrOs6oSyHyYHUWAKvavRjd5HDC9ChU11OL1SaYRz
 9N1YPiCgAa1lDj5w13/DgT9YMuCUmRD99Xr1Oqgrmmj8rvWDt5usCdOlGYaBTckPVGSC
 8Up9DwiMrRorbqSsJ/UGDqn5Q+IF8mycMv7Lp2+a7yAItVllFdHb49knkETjrm5DVhkR
 WOz7ssoH0kq1mQiO6J2a0azHFqDWLHhjhxB1Oy10yY/gUw27W+WUvR9VzTVV5SbCIn2F 6A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3pdcw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 23:25:41 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 25 Apr
 2023 23:25:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 25 Apr 2023 23:25:39 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id A119C3F706D;
        Tue, 25 Apr 2023 23:25:36 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net PATCH v2 2/9] octeontx2-af: mcs: Write TCAM_DATA and TCAM_MASK registers at once
Date:   Wed, 26 Apr 2023 11:55:21 +0530
Message-ID: <20230426062528.20575-3-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230426062528.20575-1-gakula@marvell.com>
References: <20230426062528.20575-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: -FrAiUvODiWLm1JW16WFlHi1dnVxQxKB
X-Proofpoint-GUID: -FrAiUvODiWLm1JW16WFlHi1dnVxQxKB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_02,2023-04-25_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

As per hardware errata on CN10KB, all the four TCAM_DATA
and TCAM_MASK registers has to be written at once otherwise
write to individual registers will fail. Hence write to all
TCAM_DATA registers and then to all TCAM_MASK registers.

Fixes: cfc14181d497 ("octeontx2-af: cn10k: mcs: Manage the MCS block hardware resources")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
index 492baa0b594c..148417d633a5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -473,6 +473,8 @@ void mcs_flowid_entry_write(struct mcs *mcs, u64 *data, u64 *mask, int flow_id,
 		for (reg_id = 0; reg_id < 4; reg_id++) {
 			reg = MCSX_CPM_RX_SLAVE_FLOWID_TCAM_DATAX(reg_id, flow_id);
 			mcs_reg_write(mcs, reg, data[reg_id]);
+		}
+		for (reg_id = 0; reg_id < 4; reg_id++) {
 			reg = MCSX_CPM_RX_SLAVE_FLOWID_TCAM_MASKX(reg_id, flow_id);
 			mcs_reg_write(mcs, reg, mask[reg_id]);
 		}
@@ -480,6 +482,8 @@ void mcs_flowid_entry_write(struct mcs *mcs, u64 *data, u64 *mask, int flow_id,
 		for (reg_id = 0; reg_id < 4; reg_id++) {
 			reg = MCSX_CPM_TX_SLAVE_FLOWID_TCAM_DATAX(reg_id, flow_id);
 			mcs_reg_write(mcs, reg, data[reg_id]);
+		}
+		for (reg_id = 0; reg_id < 4; reg_id++) {
 			reg = MCSX_CPM_TX_SLAVE_FLOWID_TCAM_MASKX(reg_id, flow_id);
 			mcs_reg_write(mcs, reg, mask[reg_id]);
 		}
-- 
2.25.1

