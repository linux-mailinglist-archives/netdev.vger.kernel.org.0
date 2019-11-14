Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94683FBF9E
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 06:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfKNF1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 00:27:36 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45266 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbfKNF1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 00:27:36 -0500
Received: by mail-pf1-f193.google.com with SMTP id z4so3325640pfn.12
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 21:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5aSUgj2LHmedh28uWN2D0vXmn3zTrekdIuy519Fu0tE=;
        b=FWmee0+vT4/mn8yGQcrn1iKKHjkxyoWR9vdBc1+kqUMD4wsz8PuCD62RRGboNxEsTG
         xOQ5rnF0uIWKoBgcqenYYevhShPEdwz8KhX/RPgoTwIpcLorCqZnei6IHTeCy41UWsOV
         t1upNSUWktpNN5rPIVy//VemgyM94FOolDZ/uRzeUg3a2RMdVZqSwc9LShrhKml8hRPm
         k8Iu1zweTWDDqB4bMXYrJhc943IE2QawIbYITuZAp9W/PeVEonrXo3FYpfAGMOBQE5N/
         /1mexH/C0Ia1VL8J6wAVb3aqKahztOL4BE34uhhbIHcj2/ahYzm1OOmA6YFuyvXbVsNY
         sn2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5aSUgj2LHmedh28uWN2D0vXmn3zTrekdIuy519Fu0tE=;
        b=XjNSH5ODUHxfuN88VMKASLXognejcQ61O3zjAPC5jFKFKfyfO5Nktz/SN28NTvAPM5
         5HWNqZnx6y5etdNTrfeE/bHE84imerutpsYfD38ww+MV/CVTiaBtKzMH45M7FW/Y9mKM
         uVBjHGKVe2fhJtI++4owhG5IFrs/XYTmTO0EmWbiJKfK+GT+tO3MO5WgdwWhpmw7PBAn
         ofIHrhQeScInECG4koTJzOMWQnI/4rtBLeAsa/evDvpgze84W2Wz/qbd6pzqswBYmVHL
         gcDl5wCRPmxNM5KIJas/wQNIFQdqLrcDvm0+ZAOFPv2KSPAgBaydyGVBzrE45tBIw1Fi
         E+Ag==
X-Gm-Message-State: APjAAAWW6rN27LC577XF5/Ue7h8ZATJGaGeA74HC8gefa+pbfZNHfrV9
        pLD72ySOaqeVDrAzGC5Ubjkg8waqogs=
X-Google-Smtp-Source: APXvYqy07hNPcMiHT3A2kLJBQCSFNzl83ay2txyXAfJ03IugSVhq5cTXaVSMxHeTh9kyvNnfAvgTEQ==
X-Received: by 2002:a63:d916:: with SMTP id r22mr5362022pgg.45.1573709253860;
        Wed, 13 Nov 2019 21:27:33 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id a6sm4913261pja.30.2019.11.13.21.27.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 13 Nov 2019 21:27:33 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [PATCH v2 08/18] octeontx2-af: Add mbox API to validate all responses
Date:   Thu, 14 Nov 2019 10:56:23 +0530
Message-Id: <1573709193-15446-9-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Added a new mailbox API which goes through all responses
to check their IDs and response codes.

Also added logic to prevent queuing multiple works to
process the same mailbox message. This scenario happens
when AF is processing a PF's request and menawhile PF
sends ACK to AF sent UP message, then mbox_hdr->num_msgs
in the PF->AF DOWN mbox region will be nonzero and AF
will end up processing PF's request again. This is fixed
by taking a backup of num_msgs counter and clearing the
same in the mbox region before scheduling work.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.c | 47 ++++++++++++++++++++++--
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h |  1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c  | 32 ++++++++++++----
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h  |  2 +
 4 files changed, 70 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
index d6f9ed8..81c83d2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
@@ -236,8 +236,10 @@ struct mbox_msghdr *otx2_mbox_get_rsp(struct otx2_mbox *mbox, int devid,
 	struct otx2_mbox_dev *mdev = &mbox->dev[devid];
 	u16 msgs;
 
+	spin_lock(&mdev->mbox_lock);
+
 	if (mdev->num_msgs != mdev->msgs_acked)
-		return ERR_PTR(-ENODEV);
+		goto error;
 
 	for (msgs = 0; msgs < mdev->msgs_acked; msgs++) {
 		struct mbox_msghdr *pmsg = mdev->mbase + imsg;
@@ -245,18 +247,55 @@ struct mbox_msghdr *otx2_mbox_get_rsp(struct otx2_mbox *mbox, int devid,
 
 		if (msg == pmsg) {
 			if (pmsg->id != prsp->id)
-				return ERR_PTR(-ENODEV);
+				goto error;
+			spin_unlock(&mdev->mbox_lock);
 			return prsp;
 		}
 
-		imsg = pmsg->next_msgoff;
-		irsp = prsp->next_msgoff;
+		imsg = mbox->tx_start + pmsg->next_msgoff;
+		irsp = mbox->rx_start + prsp->next_msgoff;
 	}
 
+error:
+	spin_unlock(&mdev->mbox_lock);
 	return ERR_PTR(-ENODEV);
 }
 EXPORT_SYMBOL(otx2_mbox_get_rsp);
 
+int otx2_mbox_check_rsp_msgs(struct otx2_mbox *mbox, int devid)
+{
+	unsigned long ireq = mbox->tx_start + msgs_offset;
+	unsigned long irsp = mbox->rx_start + msgs_offset;
+	struct otx2_mbox_dev *mdev = &mbox->dev[devid];
+	int rc = -ENODEV;
+	u16 msgs;
+
+	spin_lock(&mdev->mbox_lock);
+
+	if (mdev->num_msgs != mdev->msgs_acked)
+		goto exit;
+
+	for (msgs = 0; msgs < mdev->msgs_acked; msgs++) {
+		struct mbox_msghdr *preq = mdev->mbase + ireq;
+		struct mbox_msghdr *prsp = mdev->mbase + irsp;
+
+		if (preq->id != prsp->id)
+			goto exit;
+		if (prsp->rc) {
+			rc = prsp->rc;
+			goto exit;
+		}
+
+		ireq = mbox->tx_start + preq->next_msgoff;
+		irsp = mbox->rx_start + prsp->next_msgoff;
+	}
+	rc = 0;
+exit:
+	spin_unlock(&mdev->mbox_lock);
+	return rc;
+}
+EXPORT_SYMBOL(otx2_mbox_check_rsp_msgs);
+
 int
 otx2_reply_invalid_msg(struct otx2_mbox *mbox, int devid, u16 pcifunc, u16 id)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 76a4575..25f0e6f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -103,6 +103,7 @@ struct mbox_msghdr *otx2_mbox_alloc_msg_rsp(struct otx2_mbox *mbox, int devid,
 					    int size, int size_rsp);
 struct mbox_msghdr *otx2_mbox_get_rsp(struct otx2_mbox *mbox, int devid,
 				      struct mbox_msghdr *msg);
+int otx2_mbox_check_rsp_msgs(struct otx2_mbox *mbox, int devid);
 int otx2_reply_invalid_msg(struct otx2_mbox *mbox, int devid,
 			   u16 pcifunc, u16 id);
 bool otx2_mbox_nonempty(struct otx2_mbox *mbox, int devid);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index cf8741d..f5e6aca 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1440,12 +1440,12 @@ static void __rvu_mbox_handler(struct rvu_work *mwork, int type)
 
 	/* Process received mbox messages */
 	req_hdr = mdev->mbase + mbox->rx_start;
-	if (req_hdr->num_msgs == 0)
+	if (mw->mbox_wrk[devid].num_msgs == 0)
 		return;
 
 	offset = mbox->rx_start + ALIGN(sizeof(*req_hdr), MBOX_MSG_ALIGN);
 
-	for (id = 0; id < req_hdr->num_msgs; id++) {
+	for (id = 0; id < mw->mbox_wrk[devid].num_msgs; id++) {
 		msg = mdev->mbase + offset;
 
 		/* Set which PF/VF sent this message based on mbox IRQ */
@@ -1471,13 +1471,14 @@ static void __rvu_mbox_handler(struct rvu_work *mwork, int type)
 		if (msg->pcifunc & RVU_PFVF_FUNC_MASK)
 			dev_warn(rvu->dev, "Error %d when processing message %s (0x%x) from PF%d:VF%d\n",
 				 err, otx2_mbox_id2name(msg->id),
-				 msg->id, devid,
+				 msg->id, rvu_get_pf(msg->pcifunc),
 				 (msg->pcifunc & RVU_PFVF_FUNC_MASK) - 1);
 		else
 			dev_warn(rvu->dev, "Error %d when processing message %s (0x%x) from PF%d\n",
 				 err, otx2_mbox_id2name(msg->id),
 				 msg->id, devid);
 	}
+	mw->mbox_wrk[devid].num_msgs = 0;
 
 	/* Send mbox responses to VF/PF */
 	otx2_mbox_msg_send(mbox, devid);
@@ -1523,14 +1524,14 @@ static void __rvu_mbox_up_handler(struct rvu_work *mwork, int type)
 	mdev = &mbox->dev[devid];
 
 	rsp_hdr = mdev->mbase + mbox->rx_start;
-	if (rsp_hdr->num_msgs == 0) {
+	if (mw->mbox_wrk_up[devid].up_num_msgs == 0) {
 		dev_warn(rvu->dev, "mbox up handler: num_msgs = 0\n");
 		return;
 	}
 
 	offset = mbox->rx_start + ALIGN(sizeof(*rsp_hdr), MBOX_MSG_ALIGN);
 
-	for (id = 0; id < rsp_hdr->num_msgs; id++) {
+	for (id = 0; id < mw->mbox_wrk_up[devid].up_num_msgs; id++) {
 		msg = mdev->mbase + offset;
 
 		if (msg->id >= MBOX_MSG_MAX) {
@@ -1560,6 +1561,7 @@ static void __rvu_mbox_up_handler(struct rvu_work *mwork, int type)
 		offset = mbox->rx_start + msg->next_msgoff;
 		mdev->msgs_acked++;
 	}
+	mw->mbox_wrk_up[devid].up_num_msgs = 0;
 
 	otx2_mbox_reset(mbox, devid);
 }
@@ -1697,14 +1699,28 @@ static void rvu_queue_work(struct mbox_wq_info *mw, int first,
 		mbox = &mw->mbox;
 		mdev = &mbox->dev[i];
 		hdr = mdev->mbase + mbox->rx_start;
-		if (hdr->num_msgs)
-			queue_work(mw->mbox_wq, &mw->mbox_wrk[i].work);
 
+		/*The hdr->num_msgs is set to zero immediately in the interrupt
+		 * handler to  ensure that it holds a correct value next time
+		 * when the interrupt handler is called.
+		 * pf->mbox.num_msgs holds the data for use in pfaf_mbox_handler
+		 * pf>mbox.up_num_msgs holds the data for use in
+		 * pfaf_mbox_up_handler.
+		 */
+
+		if (hdr->num_msgs) {
+			mw->mbox_wrk[i].num_msgs = hdr->num_msgs;
+			hdr->num_msgs = 0;
+			queue_work(mw->mbox_wq, &mw->mbox_wrk[i].work);
+		}
 		mbox = &mw->mbox_up;
 		mdev = &mbox->dev[i];
 		hdr = mdev->mbase + mbox->rx_start;
-		if (hdr->num_msgs)
+		if (hdr->num_msgs) {
+			mw->mbox_wrk_up[i].up_num_msgs = hdr->num_msgs;
+			hdr->num_msgs = 0;
 			queue_work(mw->mbox_wq, &mw->mbox_wrk_up[i].work);
+		}
 	}
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 63b6bbc..e81b0ed 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -63,6 +63,8 @@ struct rvu_debugfs {
 struct rvu_work {
 	struct	work_struct work;
 	struct	rvu *rvu;
+	int num_msgs;
+	int up_num_msgs;
 };
 
 struct rsrc_bmap {
-- 
2.7.4

