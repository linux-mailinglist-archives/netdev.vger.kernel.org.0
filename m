Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B7C27979C
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 09:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgIZHnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 03:43:40 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29738 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729123AbgIZHnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 03:43:40 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08Q7c1q6025192;
        Sat, 26 Sep 2020 00:43:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=0bUIzYtcSw12b6u56jYJ+C9dPwj7iu0JGooFrQWqNYI=;
 b=AH5N8mFigfhwBqvep1GAJlQUtKeEzvtsri1KBIibNt3q1ardyNOwN0PsKv78XBuVu9eV
 wmPMiGKXB9w22/0LdmkaeUwebk5boi6lQTUjGthXRG96a3Ws8Q5Kd+/bxtPVGScqqK2o
 R4PgL/pzf0M53dYgDV+UwNtWw/CTv+cJsxSIb4LOlm9rX7aSoOtEAfaLrwrgYQxQJe47
 6Y0YapF21JcUigvRu1/hftEKp3EzBsTYYoJMFf9CAscOOJzfOeC2D3Amk6lG+sZ9l3Yj
 D9VgNxZ0IEEBPN7ozr13U0AkXdyeVNoTBLyADfbYaCwuyUUeYWKkB8FUUVS7yzDrZWgr Cg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33nfbqga6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 00:43:39 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 26 Sep
 2020 00:43:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 26 Sep 2020 00:43:38 -0700
Received: from cavium.com.marvell.com (unknown [10.29.8.35])
        by maili.marvell.com (Postfix) with ESMTP id 0CD4D3F703F;
        Sat, 26 Sep 2020 00:43:35 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <jerinj@marvell.com>, <davem@davemloft.net>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [net PATCH] octeontx2-pf: Fix synchnorization issue in mbox
Date:   Sat, 26 Sep 2020 12:37:54 +0530
Message-ID: <1601104074-1847-1-git-send-email-gakula@marvell.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_06:2020-09-24,2020-09-26 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

Mbox implementation in octeontx2 driver has three states
alloc, send and reset in mbox response. VF allocate and
sends message to PF for processing, PF ACKs them back and
reset the mbox memory. In some case we see synchronization
issue where after msgs_acked is incremented and before
mbox_reset API is called, if current execution is scheduled
out and a different thread is scheduled in which checks for
msgs_acked. Since the new thread sees msgs_acked == msgs_sent
it will try to allocate a new message and to send a new mbox
message to PF.Now if mbox_reset is scheduled in, PF will see
'0' in msgs_send.
This patch fixes the issue by calling mbox_reset before
incrementing msgs_acked flag for last processing message and
checks for valid message size.

Fixes: d424b6c02
("octeontx2-pf: Enable SRIOV and added VF mbox handling")

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.c     | 12 ++++++++++--
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h     |  1 +
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 11 ++++++-----
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c |  4 ++--
 4 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
index 387e33f..2718fe2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
@@ -17,7 +17,7 @@
 
 static const u16 msgs_offset = ALIGN(sizeof(struct mbox_hdr), MBOX_MSG_ALIGN);
 
-void otx2_mbox_reset(struct otx2_mbox *mbox, int devid)
+void __otx2_mbox_reset(struct otx2_mbox *mbox, int devid)
 {
 	void *hw_mbase = mbox->hwbase + (devid * MBOX_SIZE);
 	struct otx2_mbox_dev *mdev = &mbox->dev[devid];
@@ -26,13 +26,21 @@ void otx2_mbox_reset(struct otx2_mbox *mbox, int devid)
 	tx_hdr = hw_mbase + mbox->tx_start;
 	rx_hdr = hw_mbase + mbox->rx_start;
 
-	spin_lock(&mdev->mbox_lock);
 	mdev->msg_size = 0;
 	mdev->rsp_size = 0;
 	tx_hdr->num_msgs = 0;
 	tx_hdr->msg_size = 0;
 	rx_hdr->num_msgs = 0;
 	rx_hdr->msg_size = 0;
+}
+EXPORT_SYMBOL(__otx2_mbox_reset);
+
+void otx2_mbox_reset(struct otx2_mbox *mbox, int devid)
+{
+	struct otx2_mbox_dev *mdev = &mbox->dev[devid];
+
+	spin_lock(&mdev->mbox_lock);
+	__otx2_mbox_reset(mbox, devid);
 	spin_unlock(&mdev->mbox_lock);
 }
 EXPORT_SYMBOL(otx2_mbox_reset);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 6dfd0f9..ab43378 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -93,6 +93,7 @@ struct mbox_msghdr {
 };
 
 void otx2_mbox_reset(struct otx2_mbox *mbox, int devid);
+void __otx2_mbox_reset(struct otx2_mbox *mbox, int devid);
 void otx2_mbox_destroy(struct otx2_mbox *mbox);
 int otx2_mbox_init(struct otx2_mbox *mbox, void __force *hwbase,
 		   struct pci_dev *pdev, void __force *reg_base,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 5d620a3..2fb4567 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -370,8 +370,8 @@ static int otx2_forward_vf_mbox_msgs(struct otx2_nic *pf,
 		dst_mbox = &pf->mbox;
 		dst_size = dst_mbox->mbox.tx_size -
 				ALIGN(sizeof(*mbox_hdr), MBOX_MSG_ALIGN);
-		/* Check if msgs fit into destination area */
-		if (mbox_hdr->msg_size > dst_size)
+		/* Check if msgs fit into destination area and has valid size */
+		if (mbox_hdr->msg_size > dst_size || !mbox_hdr->msg_size)
 			return -EINVAL;
 
 		dst_mdev = &dst_mbox->mbox.dev[0];
@@ -526,10 +526,10 @@ static void otx2_pfvf_mbox_up_handler(struct work_struct *work)
 
 end:
 		offset = mbox->rx_start + msg->next_msgoff;
+		if (mdev->msgs_acked == (vf_mbox->up_num_msgs - 1))
+			__otx2_mbox_reset(mbox, 0);
 		mdev->msgs_acked++;
 	}
-
-	otx2_mbox_reset(mbox, vf_idx);
 }
 
 static irqreturn_t otx2_pfvf_mbox_intr_handler(int irq, void *pf_irq)
@@ -803,10 +803,11 @@ static void otx2_pfaf_mbox_handler(struct work_struct *work)
 		msg = (struct mbox_msghdr *)(mdev->mbase + offset);
 		otx2_process_pfaf_mbox_msg(pf, msg);
 		offset = mbox->rx_start + msg->next_msgoff;
+		if (mdev->msgs_acked == (af_mbox->num_msgs - 1))
+			__otx2_mbox_reset(mbox, 0);
 		mdev->msgs_acked++;
 	}
 
-	otx2_mbox_reset(mbox, 0);
 }
 
 static void otx2_handle_link_event(struct otx2_nic *pf)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 92a3db6..2f90f17 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -99,10 +99,10 @@ static void otx2vf_vfaf_mbox_handler(struct work_struct *work)
 		msg = (struct mbox_msghdr *)(mdev->mbase + offset);
 		otx2vf_process_vfaf_mbox_msg(af_mbox->pfvf, msg);
 		offset = mbox->rx_start + msg->next_msgoff;
+		if (mdev->msgs_acked == (af_mbox->num_msgs - 1))
+			__otx2_mbox_reset(mbox, 0);
 		mdev->msgs_acked++;
 	}
-
-	otx2_mbox_reset(mbox, 0);
 }
 
 static int otx2vf_process_mbox_msg_up(struct otx2_nic *vf,
-- 
2.7.4

