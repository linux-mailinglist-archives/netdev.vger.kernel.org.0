Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE663F412D
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 21:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbhHVTXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 15:23:44 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60516 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232828AbhHVTXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 15:23:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17MInZ2j017874;
        Sun, 22 Aug 2021 12:21:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=VeaaqVkI1Ssa1GuXyl3jJWdzre2Akr58UN3NF7vwkCs=;
 b=iY4PNdR5/gdldys6a2LgUnXudbDrrHt1cTNYWDwxYUWijBVBo7lN6U1N1ww+8tUnvNdE
 zgUu9O8MJe/1KV5YvJ9OCXTZqBHrt56BwWOwP40jnSkv/A8bmvHPCs6Vw+dJq0tizsbU
 EUDzK8YO1tMaNsfYFRYGz8K9gRRzLm7LR04NYLyPRK0IJxLf9fbs4i9Iors8xN1QVyQo
 ghhdNHXBWfzySkXJieY+WlqYj2FacILAp1Jg1IDXZpHZ8wIqBd2zMwVQL2NXfeVCrsAN
 ThkMQT1Y3gLDyWtsGKDPfcstaFpyx8jUR9jIpPtSXLb70ZP4fL1evqVxXRKFiY+0NGTm QQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3akj8dh89j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 22 Aug 2021 12:21:38 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.23; Sun, 22 Aug
 2021 12:21:37 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.23 via Frontend Transport; Sun, 22 Aug 2021 12:21:35 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <aelior@marvell.com>, <smalin@marvell.com>, <malin1024@gmail.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>
Subject: [PATCH] qed: Fix the VF msix vectors flow
Date:   Sun, 22 Aug 2021 22:21:14 +0300
Message-ID: <20210822192114.11622-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: q9QgRkVa2fBFcSdqbD739YhtI-Rr5bel
X-Proofpoint-ORIG-GUID: q9QgRkVa2fBFcSdqbD739YhtI-Rr5bel
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-22_04,2021-08-20_03,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For VFs we should return with an error in case we didn't get the exact
number of msix vectors as we requested.
Not doing that will lead to a crash when starting queues for this VF.

Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 6871d892eabf..15ef59aa34ff 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -615,7 +615,12 @@ static int qed_enable_msix(struct qed_dev *cdev,
 			rc = cnt;
 	}
 
-	if (rc > 0) {
+	/* For VFs, we should return with an error in case we didn't get the
+	 * exact number of msix vectors as we requested.
+	 * Not doing that will lead to a crash when starting queues for
+	 * this VF.
+	 */
+	if ((IS_PF(cdev) && rc > 0) || (IS_VF(cdev) && rc == cnt)) {
 		/* MSI-x configuration was achieved */
 		int_params->out.int_mode = QED_INT_MODE_MSIX;
 		int_params->out.num_vectors = rc;
-- 
2.22.0

