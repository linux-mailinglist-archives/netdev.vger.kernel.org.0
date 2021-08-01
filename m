Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E374F3DCB15
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 12:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhHAKZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 06:25:24 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27476 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231518AbhHAKYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 06:24:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 171ANv6Q015561;
        Sun, 1 Aug 2021 03:23:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=Ib9kHgwnkFZrMK0aJR3bm+QD2/IxSk5s9omc7oqxWQw=;
 b=RkzDw8MyaHBAQslIInPNOaddhqk6Tg7ZES/uAwPdaZizgwq+gAuBugR9uEQ17SUUCfmE
 7B7z56JNxEF67JXREUutFQXqwn0BhtMUe3ctAVbhE82aidtH6OnF9LVxWkZVHCHF7GJ3
 FWAVv32vSlVTYAhbO8XGL2BaVYhWuxXdphiNQDwD0MNHWEav22USKCK3su4TQGz1K5X/
 nkT4Lwuzl1fETAUj/Ytu6w7OoeV+AIW2AfVWPP+qHJYFSvYUR28ssKCT57w+MYelA8qy
 dKEXT/BynwbJ5FAsViWqbtGy+N5qk6m5cavjpp5rG5XkSQv9S1+FaVNVfUqClrRgVq9N Pg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a53vrah3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 01 Aug 2021 03:23:57 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 1 Aug
 2021 03:23:56 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Sun, 1 Aug 2021 03:23:54 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <aelior@marvell.com>, <smalin@marvell.com>, <malin1024@gmail.com>
Subject: [PATCH] qed: Avoid db_recovery during recovery
Date:   Sun, 1 Aug 2021 13:23:40 +0300
Message-ID: <20210801102340.19660-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: GakdOEn0kNLADD69BzsdvYZ7qzDV5KGb
X-Proofpoint-GUID: GakdOEn0kNLADD69BzsdvYZ7qzDV5KGb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-31_14:2021-07-30,2021-07-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid calling the qed doorbell recovery - qed_db_rec_handler()
during device recovery.

Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index aa48b1b7eddc..6871d892eabf 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1215,6 +1215,10 @@ static void qed_slowpath_task(struct work_struct *work)
 
 	if (test_and_clear_bit(QED_SLOWPATH_PERIODIC_DB_REC,
 			       &hwfn->slowpath_task_flags)) {
+		/* skip qed_db_rec_handler during recovery/unload */
+		if (hwfn->cdev->recov_in_prog || !hwfn->slowpath_wq_active)
+			goto out;
+
 		qed_db_rec_handler(hwfn, ptt);
 		if (hwfn->periodic_db_rec_count--)
 			qed_slowpath_delayed_work(hwfn,
@@ -1222,6 +1226,7 @@ static void qed_slowpath_task(struct work_struct *work)
 						  QED_PERIODIC_DB_REC_INTERVAL);
 	}
 
+out:
 	qed_ptt_release(hwfn, ptt);
 }
 
-- 
2.22.0

