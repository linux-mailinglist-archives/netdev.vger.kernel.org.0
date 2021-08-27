Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF5D3F9898
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 13:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245088AbhH0LzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 07:55:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57400 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245011AbhH0LzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 07:55:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17RBHn9r013337;
        Fri, 27 Aug 2021 04:54:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=p5reHcFO9xyoZDVOOSeMNCUOAe1COgtJh/nCbuw4ZvQ=;
 b=HT9vEiNh5/aFHZ1QHtccw1Q3Dp2aS8cFxSoF/M1gRBRHNlAe3siBQfxB2PtjMq2ZQPGw
 R/GbjA+q4/9QXQuVUODvfBpkCCuNl1V55o8viv/IPcGnXVuvBnA1K1YiS9+pRq7jAVMV
 gOPvRvnU2WduO83YHCe83u9qIiF1a/btki9XkUMD5wDSRH41KccYpT4xIwESpt36AWnv
 gEqHBMeXWfff8UdbcmBz0mlHZfrsj7CEaUM6ej5Nme4iq2f9UIvicPYX/1nvgTMdiB/T
 3Pmx2UlPZQUMQBSMbv/obgtGF8dU9paMjTFE3mCkdjRWJ4XkTgSGjT2LJKdDgOcf5n7n xw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3apwgp0dvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 04:54:16 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 27 Aug
 2021 04:54:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 27 Aug 2021 04:54:14 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8EA6A3F7066;
        Fri, 27 Aug 2021 04:54:14 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17RBrxD8007009;
        Fri, 27 Aug 2021 04:53:59 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17RBrhTC007008;
        Fri, 27 Aug 2021 04:53:43 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <irusskikh@marvell.com>
Subject: [PATCH net 1/1] atlantic: Fix driver resume flow.
Date:   Fri, 27 Aug 2021 04:52:25 -0700
Message-ID: <20210827115225.6964-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: vB2MZtbXueEJygZe9S08e8RI3bjrcfk4
X-Proofpoint-ORIG-GUID: vB2MZtbXueEJygZe9S08e8RI3bjrcfk4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-27_04,2021-08-26_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver crashes when restoring from the Hibernate. In the resume flow,
driver need to clean up the older nic/vec objects and re-initialize them.

Fixes: 8aaa112a57c1d ("net: atlantic: refactoring pm logic")
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 59253846e885..f26d03735619 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -417,6 +417,9 @@ static int atl_resume_common(struct device *dev, bool deep)
 	pci_restore_state(pdev);
 
 	if (deep) {
+		/* Reinitialize Nic/Vecs objects */
+		aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
+
 		ret = aq_nic_init(nic);
 		if (ret)
 			goto err_exit;
-- 
2.27.0

