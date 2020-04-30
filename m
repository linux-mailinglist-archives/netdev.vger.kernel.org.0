Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD051BF854
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 14:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgD3Mlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 08:41:49 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16940 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726677AbgD3Mlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 08:41:49 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UCfHDe007452;
        Thu, 30 Apr 2020 05:41:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=P9RqNQ3ZW1xcDzu1No5qu1M4+LnuFtCTMBpM3v2W5+Y=;
 b=fn2/aw6XCaJmxijQHjtip6MRqz4sFlSl16MY4PjxVwozhgbQAMs/rh9elxLt8cts50m+
 YdgE9nUyBbN1vfzlFWIBo75JZY5lnfnZnSX7pG+yX6zk5PifuWyg97zcnkjOXFirjPY2
 PlQdtyUOXZr5kmcBapIbiEYpkouUh/qNn9X5uWXSAH04lg1W9bsNy4Td7Ne0EqFHfn6B
 nJ4yEA8tJKK2XG14uCYaSqcsv4Jbkjd9dJwLyaJnhwPXNyAuYgyvnr7RwIPBErkbzdm7
 A/wzaAVYQgSK688zsvfC/QRZ9MV/Xqegq2GdflsZ/45lx1rNzZkbZ68rlrE6llIum+co Ww== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 30mmqmx0af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 05:41:45 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Apr
 2020 05:41:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 30 Apr 2020 05:41:43 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 64BBD3F703F;
        Thu, 30 Apr 2020 05:41:43 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 03UCfhnc003031;
        Thu, 30 Apr 2020 05:41:43 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 03UCfgKg003022;
        Thu, 30 Apr 2020 05:41:42 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>, <mkalderon@marvell.com>
Subject: [PATCH net-next 1/1] qedr: Avoid DB recover entry deletion when device is not active.
Date:   Thu, 30 Apr 2020 05:41:10 -0700
Message-ID: <20200430124110.2964-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_08:2020-04-30,2020-04-30 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The doorbell (DB) recovery entries gets deleted by the QED driver when
QEDR device transition to non-active or dead state (e.g., during the
AER recovery phase). The patch adds driver changes to skip deleting
DB recovery entries from QEDR when the device is in non-active state.

Fixes: 731815e720ae ("qede: Add support for handling the pcie errors.")
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/infiniband/hw/qedr/verbs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index a5bd3ad..7e10f3b 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -672,6 +672,12 @@ static void qedr_db_recovery_del(struct qedr_dev *dev,
 				 void __iomem *db_addr,
 				 void *db_data)
 {
+	if (QEDR_DEAD(dev)) {
+		DP_VERBOSE(dev, QEDR_MSG_FAIL,
+			   "avoiding db rec since device is dead\n");
+		return 0;
+	}
+
 	if (!db_data) {
 		DP_DEBUG(dev, QEDR_MSG_INIT, "avoiding db rec since old lib\n");
 		return;
-- 
1.8.3.1

