Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67CA63C0B2
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbiK2NNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbiK2NMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:12:40 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359DF62053;
        Tue, 29 Nov 2022 05:11:30 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATBxjX1029859;
        Tue, 29 Nov 2022 05:09:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=+KtidaflBqjAhxFSqFSHrYRPWEVzDPWUz2thrstWYyA=;
 b=POhUfjQEJmPXrlTV/GScEzRzO8X+haoyMpdIyo7yPHzrx6meGbW/WLKUIrwo0Q8XpFE8
 H8/RRiQO8icbMGpIMEKWNkRZ7+urkEsHSsLGDhHHCyLsfTss6dDbWmiOu/67Dzseor1I
 DeWr1nUB2odtAJAzvVuO8P838EsU483OPaG8ubxqGnrQiWhEN7E4j3xElW/biuaVI+i0
 +PaRCMIRGxA6ZJdIbQ4m9cenAYgNTc0AzAdZ+FSJ74Y49GLl0w0qvuRF+0rIPfvH42Ef
 /Ye8S62GDiKRea7AJ/YBNeHbw2ctDbhIZMkxXCa/M1XExgbn3cyPVGklu54KgEwWLWzn QQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3m5a509ysx-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 05:09:51 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Nov
 2022 05:09:43 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Nov 2022 05:09:43 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id D6D4F3F7087;
        Tue, 29 Nov 2022 05:09:42 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lironh@marvell.com>, <aayarekar@marvell.com>,
        <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v2 4/9] octeon_ep: enhance control mailbox for VF support
Date:   Tue, 29 Nov 2022 05:09:27 -0800
Message-ID: <20221129130933.25231-5-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221129130933.25231-1-vburru@marvell.com>
References: <20221129130933.25231-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 0JmU0UWFWgSQoKKYihymuueFY3h-qF32
X-Proofpoint-GUID: 0JmU0UWFWgSQoKKYihymuueFY3h-qF32
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_08,2022-11-29_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enhance control mailbox protocol to support following
 - separate command and response queues
    * command queue to send control commands to firmware.
    * response queue to receive responses and notifications from
      firmware.
 - variable size messages using scatter/gather
 - VF support
    * extend control command structure to include vfid.
    * update APIs to accept VF ID.

Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
---
v1 -> v2:
 * modified the patch to work with device status "oct->status" removed.

 .../marvell/octeon_ep/octep_ctrl_mbox.c       | 318 +++++++++-------
 .../marvell/octeon_ep/octep_ctrl_mbox.h       | 102 ++---
 .../marvell/octeon_ep/octep_ctrl_net.c        | 349 ++++++++++++------
 .../marvell/octeon_ep/octep_ctrl_net.h        | 176 +++++----
 .../marvell/octeon_ep/octep_ethtool.c         |   7 +-
 .../ethernet/marvell/octeon_ep/octep_main.c   |  80 ++--
 6 files changed, 619 insertions(+), 413 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
index 39322e4dd100..cda252fc8f54 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
@@ -24,41 +24,49 @@
 /* Time in msecs to wait for message response */
 #define OCTEP_CTRL_MBOX_MSG_WAIT_MS			10
 
-#define OCTEP_CTRL_MBOX_INFO_MAGIC_NUM_OFFSET(m)	(m)
-#define OCTEP_CTRL_MBOX_INFO_BARMEM_SZ_OFFSET(m)	((m) + 8)
-#define OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(m)	((m) + 24)
-#define OCTEP_CTRL_MBOX_INFO_FW_STATUS_OFFSET(m)	((m) + 144)
-
-#define OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m)		((m) + OCTEP_CTRL_MBOX_INFO_SZ)
-#define OCTEP_CTRL_MBOX_H2FQ_PROD_OFFSET(m)		(OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m))
-#define OCTEP_CTRL_MBOX_H2FQ_CONS_OFFSET(m)		((OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m)) + 4)
-#define OCTEP_CTRL_MBOX_H2FQ_ELEM_SZ_OFFSET(m)		((OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m)) + 8)
-#define OCTEP_CTRL_MBOX_H2FQ_ELEM_CNT_OFFSET(m)		((OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m)) + 12)
-
-#define OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m)		((m) + \
-							 OCTEP_CTRL_MBOX_INFO_SZ + \
-							 OCTEP_CTRL_MBOX_H2FQ_INFO_SZ)
-#define OCTEP_CTRL_MBOX_F2HQ_PROD_OFFSET(m)		(OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m))
-#define OCTEP_CTRL_MBOX_F2HQ_CONS_OFFSET(m)		((OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m)) + 4)
-#define OCTEP_CTRL_MBOX_F2HQ_ELEM_SZ_OFFSET(m)		((OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m)) + 8)
-#define OCTEP_CTRL_MBOX_F2HQ_ELEM_CNT_OFFSET(m)		((OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m)) + 12)
-
-#define OCTEP_CTRL_MBOX_Q_OFFSET(m, i)			((m) + \
-							 (sizeof(struct octep_ctrl_mbox_msg) * (i)))
-
-static u32 octep_ctrl_mbox_circq_inc(u32 index, u32 mask)
+/* Size of mbox info in bytes */
+#define OCTEP_CTRL_MBOX_INFO_SZ				256
+/* Size of mbox host to fw queue info in bytes */
+#define OCTEP_CTRL_MBOX_H2FQ_INFO_SZ			16
+/* Size of mbox fw to host queue info in bytes */
+#define OCTEP_CTRL_MBOX_F2HQ_INFO_SZ			16
+
+#define OCTEP_CTRL_MBOX_TOTAL_INFO_SZ	(OCTEP_CTRL_MBOX_INFO_SZ + \
+					 OCTEP_CTRL_MBOX_H2FQ_INFO_SZ + \
+					 OCTEP_CTRL_MBOX_F2HQ_INFO_SZ)
+
+#define OCTEP_CTRL_MBOX_INFO_MAGIC_NUM(m)	(m)
+#define OCTEP_CTRL_MBOX_INFO_BARMEM_SZ(m)	((m) + 8)
+#define OCTEP_CTRL_MBOX_INFO_HOST_STATUS(m)	((m) + 24)
+#define OCTEP_CTRL_MBOX_INFO_FW_STATUS(m)	((m) + 144)
+
+#define OCTEP_CTRL_MBOX_H2FQ_INFO(m)	((m) + OCTEP_CTRL_MBOX_INFO_SZ)
+#define OCTEP_CTRL_MBOX_H2FQ_PROD(m)	(OCTEP_CTRL_MBOX_H2FQ_INFO(m))
+#define OCTEP_CTRL_MBOX_H2FQ_CONS(m)	((OCTEP_CTRL_MBOX_H2FQ_INFO(m)) + 4)
+#define OCTEP_CTRL_MBOX_H2FQ_SZ(m)	((OCTEP_CTRL_MBOX_H2FQ_INFO(m)) + 8)
+
+#define OCTEP_CTRL_MBOX_F2HQ_INFO(m)	((m) + \
+					 OCTEP_CTRL_MBOX_INFO_SZ + \
+					 OCTEP_CTRL_MBOX_H2FQ_INFO_SZ)
+#define OCTEP_CTRL_MBOX_F2HQ_PROD(m)	(OCTEP_CTRL_MBOX_F2HQ_INFO(m))
+#define OCTEP_CTRL_MBOX_F2HQ_CONS(m)	((OCTEP_CTRL_MBOX_F2HQ_INFO(m)) + 4)
+#define OCTEP_CTRL_MBOX_F2HQ_SZ(m)	((OCTEP_CTRL_MBOX_F2HQ_INFO(m)) + 8)
+
+static const u32 mbox_hdr_sz = sizeof(union octep_ctrl_mbox_msg_hdr);
+
+static u32 octep_ctrl_mbox_circq_inc(u32 index, u32 inc, u32 sz)
 {
-	return (index + 1) & mask;
+	return (index + inc) % sz;
 }
 
-static u32 octep_ctrl_mbox_circq_space(u32 pi, u32 ci, u32 mask)
+static u32 octep_ctrl_mbox_circq_space(u32 pi, u32 ci, u32 sz)
 {
-	return mask - ((pi - ci) & mask);
+	return sz - (abs(pi - ci) % sz);
 }
 
-static u32 octep_ctrl_mbox_circq_depth(u32 pi, u32 ci, u32 mask)
+static u32 octep_ctrl_mbox_circq_depth(u32 pi, u32 ci, u32 sz)
 {
-	return ((pi - ci) & mask);
+	return (abs(pi - ci) % sz);
 }
 
 int octep_ctrl_mbox_init(struct octep_ctrl_mbox *mbox)
@@ -73,172 +81,228 @@ int octep_ctrl_mbox_init(struct octep_ctrl_mbox *mbox)
 		return -EINVAL;
 	}
 
-	magic_num = readq(OCTEP_CTRL_MBOX_INFO_MAGIC_NUM_OFFSET(mbox->barmem));
+	magic_num = readq(OCTEP_CTRL_MBOX_INFO_MAGIC_NUM(mbox->barmem));
 	if (magic_num != OCTEP_CTRL_MBOX_MAGIC_NUMBER) {
-		pr_info("octep_ctrl_mbox : Invalid magic number %llx\n", magic_num);
+		pr_info("octep_ctrl_mbox : Invalid magic number %llx\n",
+			magic_num);
 		return -EINVAL;
 	}
 
-	status = readq(OCTEP_CTRL_MBOX_INFO_FW_STATUS_OFFSET(mbox->barmem));
+	status = readq(OCTEP_CTRL_MBOX_INFO_FW_STATUS(mbox->barmem));
 	if (status != OCTEP_CTRL_MBOX_STATUS_READY) {
 		pr_info("octep_ctrl_mbox : Firmware is not ready.\n");
 		return -EINVAL;
 	}
 
-	mbox->barmem_sz = readl(OCTEP_CTRL_MBOX_INFO_BARMEM_SZ_OFFSET(mbox->barmem));
+	mbox->barmem_sz = readl(OCTEP_CTRL_MBOX_INFO_BARMEM_SZ(mbox->barmem));
 
-	writeq(OCTEP_CTRL_MBOX_STATUS_INIT, OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(mbox->barmem));
+	writeq(OCTEP_CTRL_MBOX_STATUS_INIT,
+	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS(mbox->barmem));
 
-	mbox->h2fq.elem_cnt = readl(OCTEP_CTRL_MBOX_H2FQ_ELEM_CNT_OFFSET(mbox->barmem));
-	mbox->h2fq.elem_sz = readl(OCTEP_CTRL_MBOX_H2FQ_ELEM_SZ_OFFSET(mbox->barmem));
-	mbox->h2fq.mask = (mbox->h2fq.elem_cnt - 1);
-	mutex_init(&mbox->h2fq_lock);
+	mbox->h2fq.sz = readl(OCTEP_CTRL_MBOX_H2FQ_SZ(mbox->barmem));
+	mbox->h2fq.hw_prod = OCTEP_CTRL_MBOX_H2FQ_PROD(mbox->barmem);
+	mbox->h2fq.hw_cons = OCTEP_CTRL_MBOX_H2FQ_CONS(mbox->barmem);
+	mbox->h2fq.hw_q = mbox->barmem + OCTEP_CTRL_MBOX_TOTAL_INFO_SZ;
 
-	mbox->f2hq.elem_cnt = readl(OCTEP_CTRL_MBOX_F2HQ_ELEM_CNT_OFFSET(mbox->barmem));
-	mbox->f2hq.elem_sz = readl(OCTEP_CTRL_MBOX_F2HQ_ELEM_SZ_OFFSET(mbox->barmem));
-	mbox->f2hq.mask = (mbox->f2hq.elem_cnt - 1);
-	mutex_init(&mbox->f2hq_lock);
-
-	mbox->h2fq.hw_prod = OCTEP_CTRL_MBOX_H2FQ_PROD_OFFSET(mbox->barmem);
-	mbox->h2fq.hw_cons = OCTEP_CTRL_MBOX_H2FQ_CONS_OFFSET(mbox->barmem);
-	mbox->h2fq.hw_q = mbox->barmem +
-			  OCTEP_CTRL_MBOX_INFO_SZ +
-			  OCTEP_CTRL_MBOX_H2FQ_INFO_SZ +
-			  OCTEP_CTRL_MBOX_F2HQ_INFO_SZ;
-
-	mbox->f2hq.hw_prod = OCTEP_CTRL_MBOX_F2HQ_PROD_OFFSET(mbox->barmem);
-	mbox->f2hq.hw_cons = OCTEP_CTRL_MBOX_F2HQ_CONS_OFFSET(mbox->barmem);
-	mbox->f2hq.hw_q = mbox->h2fq.hw_q +
-			  ((mbox->h2fq.elem_sz + sizeof(union octep_ctrl_mbox_msg_hdr)) *
-			   mbox->h2fq.elem_cnt);
+	mbox->f2hq.sz = readl(OCTEP_CTRL_MBOX_F2HQ_SZ(mbox->barmem));
+	mbox->f2hq.hw_prod = OCTEP_CTRL_MBOX_F2HQ_PROD(mbox->barmem);
+	mbox->f2hq.hw_cons = OCTEP_CTRL_MBOX_F2HQ_CONS(mbox->barmem);
+	mbox->f2hq.hw_q = mbox->barmem +
+			  OCTEP_CTRL_MBOX_TOTAL_INFO_SZ +
+			  mbox->h2fq.sz;
 
 	/* ensure ready state is seen after everything is initialized */
 	wmb();
-	writeq(OCTEP_CTRL_MBOX_STATUS_READY, OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(mbox->barmem));
+	writeq(OCTEP_CTRL_MBOX_STATUS_READY,
+	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS(mbox->barmem));
 
 	pr_info("Octep ctrl mbox : Init successful.\n");
 
 	return 0;
 }
 
-int octep_ctrl_mbox_send(struct octep_ctrl_mbox *mbox, struct octep_ctrl_mbox_msg *msg)
+static int write_mbox_data(struct octep_ctrl_mbox_q *q, u32 *pi,
+			   u32 ci, void *buf, u32 w_sz)
+{
+	u32 cp_sz;
+	u8 __iomem *qbuf;
+
+	/* Assumption: Caller has ensured enough write space */
+	qbuf = (q->hw_q + *pi);
+	if (*pi < ci) {
+		/* copy entire w_sz */
+		memcpy_toio(qbuf, buf, w_sz);
+		*pi = octep_ctrl_mbox_circq_inc(*pi, w_sz, q->sz);
+	} else {
+		/* copy up to end of queue */
+		cp_sz = min((q->sz - *pi), w_sz);
+		memcpy_toio(qbuf, buf, cp_sz);
+		w_sz -= cp_sz;
+		*pi = octep_ctrl_mbox_circq_inc(*pi, cp_sz, q->sz);
+		if (w_sz) {
+			/* roll over and copy remaining w_sz */
+			buf += cp_sz;
+			qbuf = (q->hw_q + *pi);
+			memcpy_toio(qbuf, buf, w_sz);
+			*pi = octep_ctrl_mbox_circq_inc(*pi, w_sz, q->sz);
+		}
+	}
+
+	return 0;
+}
+
+int octep_ctrl_mbox_send(struct octep_ctrl_mbox *mbox,
+			 struct octep_ctrl_mbox_msg *msgs,
+			 int num)
 {
-	unsigned long timeout = msecs_to_jiffies(OCTEP_CTRL_MBOX_MSG_TIMEOUT_MS);
-	unsigned long period = msecs_to_jiffies(OCTEP_CTRL_MBOX_MSG_WAIT_MS);
+	struct octep_ctrl_mbox_msg_buf *sg;
+	struct octep_ctrl_mbox_msg *msg;
 	struct octep_ctrl_mbox_q *q;
-	unsigned long expire;
-	u64 *mbuf, *word0;
-	u8 __iomem *qidx;
-	u16 pi, ci;
-	int i;
+	u32 pi, ci, prev_pi, buf_sz, w_sz;
+	int m, s;
 
-	if (!mbox || !msg)
+	if (!mbox || !msgs)
 		return -EINVAL;
 
+	if (readq(OCTEP_CTRL_MBOX_INFO_FW_STATUS(mbox->barmem)) !=
+	    OCTEP_CTRL_MBOX_STATUS_READY)
+		return -EIO;
+
+	mutex_lock(&mbox->h2fq_lock);
 	q = &mbox->h2fq;
 	pi = readl(q->hw_prod);
 	ci = readl(q->hw_cons);
+	for (m = 0; m < num; m++) {
+		msg = &msgs[m];
+		if (!msg)
+			break;
 
-	if (!octep_ctrl_mbox_circq_space(pi, ci, q->mask))
-		return -ENOMEM;
-
-	qidx = OCTEP_CTRL_MBOX_Q_OFFSET(q->hw_q, pi);
-	mbuf = (u64 *)msg->msg;
-	word0 = &msg->hdr.word0;
-
-	mutex_lock(&mbox->h2fq_lock);
-	for (i = 1; i <= msg->hdr.sizew; i++)
-		writeq(*mbuf++, (qidx + (i * 8)));
-
-	writeq(*word0, qidx);
+		/* not enough space for next message */
+		if (octep_ctrl_mbox_circq_space(pi, ci, q->sz) <
+		    (msg->hdr.s.sz + mbox_hdr_sz))
+			break;
 
-	pi = octep_ctrl_mbox_circq_inc(pi, q->mask);
+		prev_pi = pi;
+		write_mbox_data(q, &pi, ci, (void *)&msg->hdr, mbox_hdr_sz);
+		buf_sz = msg->hdr.s.sz;
+		for (s = 0; ((s < msg->sg_num) && (buf_sz > 0)); s++) {
+			sg = &msg->sg_list[s];
+			w_sz = (sg->sz <= buf_sz) ? sg->sz : buf_sz;
+			write_mbox_data(q, &pi, ci, sg->msg, w_sz);
+			buf_sz -= w_sz;
+		}
+		if (buf_sz) {
+			/* we did not write entire message */
+			pi = prev_pi;
+			break;
+		}
+	}
 	writel(pi, q->hw_prod);
 	mutex_unlock(&mbox->h2fq_lock);
 
-	/* don't check for notification response */
-	if (msg->hdr.flags & OCTEP_CTRL_MBOX_MSG_HDR_FLAG_NOTIFY)
-		return 0;
+	return (m) ? m : -EAGAIN;
+}
 
-	expire = jiffies + timeout;
-	while (true) {
-		*word0 = readq(qidx);
-		if (msg->hdr.flags == OCTEP_CTRL_MBOX_MSG_HDR_FLAG_RESP)
-			break;
-		schedule_timeout_interruptible(period);
-		if (signal_pending(current) || time_after(jiffies, expire)) {
-			pr_info("octep_ctrl_mbox: Timed out\n");
-			return -EBUSY;
+static int read_mbox_data(struct octep_ctrl_mbox_q *q, u32 pi,
+			  u32 *ci, void *buf, u32 r_sz)
+{
+	u32 cp_sz;
+	u8 __iomem *qbuf;
+
+	/* Assumption: Caller has ensured enough read space */
+	qbuf = (q->hw_q + *ci);
+	if (*ci < pi) {
+		/* copy entire r_sz */
+		memcpy_fromio(buf, qbuf, r_sz);
+		*ci = octep_ctrl_mbox_circq_inc(*ci, r_sz, q->sz);
+	} else {
+		/* copy up to end of queue */
+		cp_sz = min((q->sz - *ci), r_sz);
+		memcpy_fromio(buf, qbuf, cp_sz);
+		r_sz -= cp_sz;
+		*ci = octep_ctrl_mbox_circq_inc(*ci, cp_sz, q->sz);
+		if (r_sz) {
+			/* roll over and copy remaining r_sz */
+			buf += cp_sz;
+			qbuf = (q->hw_q + *ci);
+			memcpy_fromio(buf, qbuf, r_sz);
+			*ci = octep_ctrl_mbox_circq_inc(*ci, r_sz, q->sz);
 		}
 	}
-	mbuf = (u64 *)msg->msg;
-	for (i = 1; i <= msg->hdr.sizew; i++)
-		*mbuf++ = readq(qidx + (i * 8));
 
 	return 0;
 }
 
-int octep_ctrl_mbox_recv(struct octep_ctrl_mbox *mbox, struct octep_ctrl_mbox_msg *msg)
+int octep_ctrl_mbox_recv(struct octep_ctrl_mbox *mbox,
+			 struct octep_ctrl_mbox_msg *msgs,
+			 int num)
 {
+	struct octep_ctrl_mbox_msg_buf *sg;
+	struct octep_ctrl_mbox_msg *msg;
 	struct octep_ctrl_mbox_q *q;
-	u32 count, pi, ci;
-	u8 __iomem *qidx;
-	u64 *mbuf;
-	int i;
+	u32 pi, ci, q_depth, r_sz, buf_sz, prev_ci;
+	int s, m;
 
-	if (!mbox || !msg)
+	if (!mbox || !msgs)
 		return -EINVAL;
 
+	if (readq(OCTEP_CTRL_MBOX_INFO_FW_STATUS(mbox->barmem)) !=
+	    OCTEP_CTRL_MBOX_STATUS_READY)
+		return -EIO;
+
+	mutex_lock(&mbox->f2hq_lock);
 	q = &mbox->f2hq;
 	pi = readl(q->hw_prod);
 	ci = readl(q->hw_cons);
-	count = octep_ctrl_mbox_circq_depth(pi, ci, q->mask);
-	if (!count)
-		return -EAGAIN;
-
-	qidx = OCTEP_CTRL_MBOX_Q_OFFSET(q->hw_q, ci);
-	mbuf = (u64 *)msg->msg;
-
-	mutex_lock(&mbox->f2hq_lock);
+	for (m = 0; m < num; m++) {
+		q_depth = octep_ctrl_mbox_circq_depth(pi, ci, q->sz);
+		if (q_depth < mbox_hdr_sz)
+			break;
 
-	msg->hdr.word0 = readq(qidx);
-	for (i = 1; i <= msg->hdr.sizew; i++)
-		*mbuf++ = readq(qidx + (i * 8));
+		msg = &msgs[m];
+		if (!msg)
+			break;
 
-	ci = octep_ctrl_mbox_circq_inc(ci, q->mask);
+		prev_ci = ci;
+		read_mbox_data(q, pi, &ci, (void *)&msg->hdr, mbox_hdr_sz);
+		buf_sz = msg->hdr.s.sz;
+		if (q_depth < (mbox_hdr_sz + buf_sz)) {
+			ci = prev_ci;
+			break;
+		}
+		for (s = 0; ((s < msg->sg_num) && (buf_sz > 0)); s++) {
+			sg = &msg->sg_list[s];
+			r_sz = (sg->sz <= buf_sz) ? sg->sz : buf_sz;
+			read_mbox_data(q, pi, &ci, sg->msg, r_sz);
+			buf_sz -= r_sz;
+		}
+		if (buf_sz) {
+			/* we did not read entire message */
+			ci = prev_ci;
+			break;
+		}
+	}
 	writel(ci, q->hw_cons);
-
 	mutex_unlock(&mbox->f2hq_lock);
 
-	if (msg->hdr.flags != OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ || !mbox->process_req)
-		return 0;
-
-	mbox->process_req(mbox->user_ctx, msg);
-	mbuf = (u64 *)msg->msg;
-	for (i = 1; i <= msg->hdr.sizew; i++)
-		writeq(*mbuf++, (qidx + (i * 8)));
-
-	writeq(msg->hdr.word0, qidx);
-
-	return 0;
+	return (m) ? m : -EAGAIN;
 }
 
 int octep_ctrl_mbox_uninit(struct octep_ctrl_mbox *mbox)
 {
 	if (!mbox)
 		return -EINVAL;
+	if (!mbox->barmem)
+		return -EINVAL;
 
-	writeq(OCTEP_CTRL_MBOX_STATUS_UNINIT,
-	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(mbox->barmem));
+	writeq(OCTEP_CTRL_MBOX_STATUS_INVALID,
+	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS(mbox->barmem));
 	/* ensure uninit state is written before uninitialization */
 	wmb();
 
 	mutex_destroy(&mbox->h2fq_lock);
 	mutex_destroy(&mbox->f2hq_lock);
 
-	writeq(OCTEP_CTRL_MBOX_STATUS_INVALID,
-	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(mbox->barmem));
-
 	pr_info("Octep ctrl mbox : Uninit successful.\n");
 
 	return 0;
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.h b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.h
index 2dc5753cfec6..6ee0345d4436 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.h
@@ -27,50 +27,39 @@
  * |-------------------------------------------|
  * |producer index (4 bytes)                   |
  * |consumer index (4 bytes)                   |
- * |element size (4 bytes)                     |
- * |element count (4 bytes)                    |
+ * |max element size (4 bytes)                 |
+ * |reserved (4 bytes)                         |
  * |===========================================|
  * |Fw to Host Queue info (16 bytes)           |
  * |-------------------------------------------|
  * |producer index (4 bytes)                   |
  * |consumer index (4 bytes)                   |
- * |element size (4 bytes)                     |
- * |element count (4 bytes)                    |
+ * |max element size (4 bytes)                 |
+ * |reserved (4 bytes)                         |
  * |===========================================|
- * |Host to Fw Queue                           |
+ * |Host to Fw Queue ((total size-288/2) bytes)|
  * |-------------------------------------------|
- * |((elem_sz + hdr(8 bytes)) * elem_cnt) bytes|
+ * |                                           |
  * |===========================================|
  * |===========================================|
- * |Fw to Host Queue                           |
+ * |Fw to Host Queue ((total size-288/2) bytes)|
  * |-------------------------------------------|
- * |((elem_sz + hdr(8 bytes)) * elem_cnt) bytes|
+ * |                                           |
  * |===========================================|
  */
 
 #define OCTEP_CTRL_MBOX_MAGIC_NUMBER			0xdeaddeadbeefbeefull
 
-/* Size of mbox info in bytes */
-#define OCTEP_CTRL_MBOX_INFO_SZ				256
-/* Size of mbox host to target queue info in bytes */
-#define OCTEP_CTRL_MBOX_H2FQ_INFO_SZ			16
-/* Size of mbox target to host queue info in bytes */
-#define OCTEP_CTRL_MBOX_F2HQ_INFO_SZ			16
-/* Size of mbox queue in bytes */
-#define OCTEP_CTRL_MBOX_Q_SZ(sz, cnt)			(((sz) + 8) * (cnt))
-/* Size of mbox in bytes */
-#define OCTEP_CTRL_MBOX_SZ(hsz, hcnt, fsz, fcnt)	(OCTEP_CTRL_MBOX_INFO_SZ + \
-							 OCTEP_CTRL_MBOX_H2FQ_INFO_SZ + \
-							 OCTEP_CTRL_MBOX_F2HQ_INFO_SZ + \
-							 OCTEP_CTRL_MBOX_Q_SZ(hsz, hcnt) + \
-							 OCTEP_CTRL_MBOX_Q_SZ(fsz, fcnt))
-
 /* Valid request message */
 #define OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ		BIT(0)
 /* Valid response message */
 #define OCTEP_CTRL_MBOX_MSG_HDR_FLAG_RESP		BIT(1)
 /* Valid notification, no response required */
 #define OCTEP_CTRL_MBOX_MSG_HDR_FLAG_NOTIFY		BIT(2)
+/* Valid custom message */
+#define OCTEP_CTRL_MBOX_MSG_HDR_FLAG_CUSTOM		BIT(3)
+
+#define OCTEP_CTRL_MBOX_MSG_DESC_MAX			4
 
 enum octep_ctrl_mbox_status {
 	OCTEP_CTRL_MBOX_STATUS_INVALID = 0,
@@ -81,31 +70,48 @@ enum octep_ctrl_mbox_status {
 
 /* mbox message */
 union octep_ctrl_mbox_msg_hdr {
-	u64 word0;
+	u64 words[2];
 	struct {
+		/* must be 0 */
+		u16 reserved1:15;
+		/* vf_idx is valid if 1 */
+		u16 is_vf:1;
+		/* sender vf index 0-(n-1), 0 if (is_vf==0) */
+		u16 vf_idx;
+		/* total size of message excluding header */
+		u32 sz;
 		/* OCTEP_CTRL_MBOX_MSG_HDR_FLAG_* */
 		u32 flags;
-		/* size of message in words excluding header */
-		u32 sizew;
-	};
+		/* identifier to match responses */
+		u16 msg_id;
+		u16 reserved2;
+	} s;
+};
+
+/* mbox message buffer */
+struct octep_ctrl_mbox_msg_buf {
+	u32 reserved1;
+	u16 reserved2;
+	/* size of buffer */
+	u16 sz;
+	/* pointer to message buffer */
+	void *msg;
 };
 
 /* mbox message */
 struct octep_ctrl_mbox_msg {
 	/* mbox transaction header */
 	union octep_ctrl_mbox_msg_hdr hdr;
-	/* pointer to message buffer */
-	void *msg;
+	/* number of sg buffer's */
+	int sg_num;
+	/* message buffer's */
+	struct octep_ctrl_mbox_msg_buf sg_list[OCTEP_CTRL_MBOX_MSG_DESC_MAX];
 };
 
 /* Mbox queue */
 struct octep_ctrl_mbox_q {
-	/* q element size, should be aligned to unsigned long */
-	u16 elem_sz;
-	/* q element count, should be power of 2 */
-	u16 elem_cnt;
-	/* q mask */
-	u16 mask;
+	/* size of queue buffer */
+	u32 sz;
 	/* producer address in bar mem */
 	u8 __iomem *hw_prod;
 	/* consumer address in bar mem */
@@ -115,16 +121,10 @@ struct octep_ctrl_mbox_q {
 };
 
 struct octep_ctrl_mbox {
-	/* host driver version */
-	u64 version;
 	/* size of bar memory */
 	u32 barmem_sz;
 	/* pointer to BAR memory */
 	u8 __iomem *barmem;
-	/* user context for callback, can be null */
-	void *user_ctx;
-	/* callback handler for processing request, called from octep_ctrl_mbox_recv */
-	int (*process_req)(void *user_ctx, struct octep_ctrl_mbox_msg *msg);
 	/* host-to-fw queue */
 	struct octep_ctrl_mbox_q h2fq;
 	/* fw-to-host queue */
@@ -146,22 +146,32 @@ int octep_ctrl_mbox_init(struct octep_ctrl_mbox *mbox);
 /* Send mbox message.
  *
  * @param mbox: non-null pointer to struct octep_ctrl_mbox.
+ * @param msgs: Array of non-null pointers to struct octep_ctrl_mbox_msg.
+ *             Caller should fill msg.sz and msg.desc.sz for each message.
+ * @param num: Size of msg array.
  *
- * return value: 0 on success, -errno on failure.
+ * return value: number of messages sent on success, -errno on failure.
  */
-int octep_ctrl_mbox_send(struct octep_ctrl_mbox *mbox, struct octep_ctrl_mbox_msg *msg);
+int octep_ctrl_mbox_send(struct octep_ctrl_mbox *mbox,
+			 struct octep_ctrl_mbox_msg *msgs,
+			 int num);
 
 /* Retrieve mbox message.
  *
  * @param mbox: non-null pointer to struct octep_ctrl_mbox.
+ * @param msgs: Array of non-null pointers to struct octep_ctrl_mbox_msg.
+ *             Caller should fill msg.sz and msg.desc.sz for each message.
+ * @param num: Size of msg array.
  *
- * return value: 0 on success, -errno on failure.
+ * return value: number of messages received on success, -errno on failure.
  */
-int octep_ctrl_mbox_recv(struct octep_ctrl_mbox *mbox, struct octep_ctrl_mbox_msg *msg);
+int octep_ctrl_mbox_recv(struct octep_ctrl_mbox *mbox,
+			 struct octep_ctrl_mbox_msg *msgs,
+			 int num);
 
 /* Uninitialize control mbox.
  *
- * @param ep: non-null pointer to struct octep_ctrl_mbox.
+ * @param mbox: non-null pointer to struct octep_ctrl_mbox.
  *
  * return value: 0 on success, -errno on failure.
  */
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
index 7c00c896ab98..715af1891d0d 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
@@ -8,134 +8,199 @@
 #include <linux/types.h>
 #include <linux/etherdevice.h>
 #include <linux/pci.h>
+#include <linux/wait.h>
 
 #include "octep_config.h"
 #include "octep_main.h"
 #include "octep_ctrl_net.h"
 
-int octep_get_link_status(struct octep_device *oct)
+static const u32 req_hdr_sz = sizeof(union octep_ctrl_net_req_hdr);
+static const u32 mtu_sz = sizeof(struct octep_ctrl_net_h2f_req_cmd_mtu);
+static const u32 mac_sz = sizeof(struct octep_ctrl_net_h2f_req_cmd_mac);
+static const u32 state_sz = sizeof(struct octep_ctrl_net_h2f_req_cmd_state);
+static const u32 link_info_sz = sizeof(struct octep_ctrl_net_link_info);
+static const u32 get_stats_sz = sizeof(struct octep_ctrl_net_h2f_req_cmd_get_stats);
+static atomic_t ctrl_net_msg_id;
+
+static void init_send_req(struct octep_ctrl_mbox_msg *msg, void *buf,
+			  u16 sz, int vfid)
 {
-	struct octep_ctrl_net_h2f_req req = {};
-	struct octep_ctrl_net_h2f_resp *resp;
-	struct octep_ctrl_mbox_msg msg = {};
-	int err;
+	msg->hdr.s.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
+	msg->hdr.s.msg_id = atomic_inc_return(&ctrl_net_msg_id) &
+			    GENMASK(sizeof(msg->hdr.s.msg_id) * BITS_PER_BYTE, 0);
+	msg->hdr.s.sz = req_hdr_sz + sz;
+	msg->sg_num = 1;
+	msg->sg_list[0].msg = buf;
+	msg->sg_list[0].sz = msg->hdr.s.sz;
+	if (vfid != OCTEP_CTRL_NET_INVALID_VFID) {
+		msg->hdr.s.is_vf = 1;
+		msg->hdr.s.vf_idx = vfid;
+	}
+}
 
-	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_STATUS;
-	req.link.cmd = OCTEP_CTRL_NET_CMD_GET;
+static int send_mbox_req(struct octep_device *oct,
+			 struct octep_ctrl_net_wait_data *d,
+			 bool wait_for_response)
+{
+	int err, ret;
 
-	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
-	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_STATE_REQ_SZW;
-	msg.msg = &req;
-	err = octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
-	if (err)
+	err = octep_ctrl_mbox_send(&oct->ctrl_mbox, &d->msg, 1);
+	if (err < 0)
 		return err;
 
-	resp = (struct octep_ctrl_net_h2f_resp *)&req;
-	return resp->link.state;
+	if (!wait_for_response)
+		return 0;
+
+	d->done = 0;
+	INIT_LIST_HEAD(&d->list);
+	list_add_tail(&d->list, &oct->ctrl_req_wait_list);
+	ret = wait_event_interruptible_timeout(oct->ctrl_req_wait_q,
+					       (d->done != 0),
+					       jiffies + msecs_to_jiffies(500));
+	list_del(&d->list);
+	if (ret == 0 || ret == 1)
+		return -EAGAIN;
+
+	/**
+	 * (ret == 0)  cond = false && timeout, return 0
+	 * (ret < 0) interrupted by signal, return 0
+	 * (ret == 1) cond = true && timeout, return 1
+	 * (ret >= 1) cond = true && !timeout, return 1
+	 */
+
+	if (d->data.resp.hdr.s.reply != OCTEP_CTRL_NET_REPLY_OK)
+		return -EAGAIN;
+
+	return 0;
 }
 
-void octep_set_link_status(struct octep_device *oct, bool up)
+int octep_ctrl_net_init(struct octep_device *oct)
 {
-	struct octep_ctrl_net_h2f_req req = {};
-	struct octep_ctrl_mbox_msg msg = {};
+	struct pci_dev *pdev = oct->pdev;
+	struct octep_ctrl_mbox *ctrl_mbox;
+	int ret;
+
+	init_waitqueue_head(&oct->ctrl_req_wait_q);
+	INIT_LIST_HEAD(&oct->ctrl_req_wait_list);
+
+	/* Initialize control mbox */
+	ctrl_mbox = &oct->ctrl_mbox;
+	ctrl_mbox->barmem = CFG_GET_CTRL_MBOX_MEM_ADDR(oct->conf);
+	ret = octep_ctrl_mbox_init(ctrl_mbox);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to initialize control mbox\n");
+		return ret;
+	}
+	oct->ctrl_mbox_ifstats_offset = ctrl_mbox->barmem_sz;
+
+	return 0;
+}
 
-	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_STATUS;
-	req.link.cmd = OCTEP_CTRL_NET_CMD_SET;
-	req.link.state = (up) ? OCTEP_CTRL_NET_STATE_UP : OCTEP_CTRL_NET_STATE_DOWN;
+int octep_ctrl_net_get_link_status(struct octep_device *oct, int vfid)
+{
+	struct octep_ctrl_net_wait_data d = {0};
+	struct octep_ctrl_net_h2f_req *req = &d.data.req;
+	int err;
 
-	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
-	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_STATE_REQ_SZW;
-	msg.msg = &req;
-	octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
+	init_send_req(&d.msg, (void *)req, state_sz, vfid);
+	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_STATUS;
+	req->link.cmd = OCTEP_CTRL_NET_CMD_GET;
+	err = send_mbox_req(oct, &d, true);
+	if (err < 0)
+		return err;
+
+	return d.data.resp.link.state;
 }
 
-void octep_set_rx_state(struct octep_device *oct, bool up)
+int octep_ctrl_net_set_link_status(struct octep_device *oct, int vfid, bool up,
+				   bool wait_for_response)
 {
-	struct octep_ctrl_net_h2f_req req = {};
-	struct octep_ctrl_mbox_msg msg = {};
+	struct octep_ctrl_net_wait_data d = {0};
+	struct octep_ctrl_net_h2f_req *req = &d.data.req;
 
-	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_RX_STATE;
-	req.link.cmd = OCTEP_CTRL_NET_CMD_SET;
-	req.link.state = (up) ? OCTEP_CTRL_NET_STATE_UP : OCTEP_CTRL_NET_STATE_DOWN;
+	init_send_req(&d.msg, req, state_sz, vfid);
+	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_STATUS;
+	req->link.cmd = OCTEP_CTRL_NET_CMD_SET;
+	req->link.state = (up) ? OCTEP_CTRL_NET_STATE_UP :
+				OCTEP_CTRL_NET_STATE_DOWN;
 
-	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
-	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_STATE_REQ_SZW;
-	msg.msg = &req;
-	octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
+	return send_mbox_req(oct, &d, wait_for_response);
 }
 
-int octep_get_mac_addr(struct octep_device *oct, u8 *addr)
+int octep_ctrl_net_set_rx_state(struct octep_device *oct, int vfid, bool up,
+				bool wait_for_response)
 {
-	struct octep_ctrl_net_h2f_req req = {};
-	struct octep_ctrl_net_h2f_resp *resp;
-	struct octep_ctrl_mbox_msg msg = {};
-	int err;
+	struct octep_ctrl_net_wait_data d = {0};
+	struct octep_ctrl_net_h2f_req *req = &d.data.req;
+
+	init_send_req(&d.msg, req, state_sz, vfid);
+	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_RX_STATE;
+	req->link.cmd = OCTEP_CTRL_NET_CMD_SET;
+	req->link.state = (up) ? OCTEP_CTRL_NET_STATE_UP :
+				OCTEP_CTRL_NET_STATE_DOWN;
 
-	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_MAC;
-	req.link.cmd = OCTEP_CTRL_NET_CMD_GET;
+	return send_mbox_req(oct, &d, wait_for_response);
+}
+
+int octep_ctrl_net_get_mac_addr(struct octep_device *oct, int vfid, u8 *addr)
+{
+	struct octep_ctrl_net_wait_data d = {0};
+	struct octep_ctrl_net_h2f_req *req = &d.data.req;
+	int err;
 
-	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
-	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_MAC_REQ_SZW;
-	msg.msg = &req;
-	err = octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
-	if (err)
+	init_send_req(&d.msg, req, mac_sz, vfid);
+	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_MAC;
+	req->link.cmd = OCTEP_CTRL_NET_CMD_GET;
+	err = send_mbox_req(oct, &d, true);
+	if (err < 0)
 		return err;
 
-	resp = (struct octep_ctrl_net_h2f_resp *)&req;
-	memcpy(addr, resp->mac.addr, ETH_ALEN);
+	memcpy(addr, d.data.resp.mac.addr, ETH_ALEN);
 
-	return err;
+	return 0;
 }
 
-int octep_set_mac_addr(struct octep_device *oct, u8 *addr)
+int octep_ctrl_net_set_mac_addr(struct octep_device *oct, int vfid, u8 *addr,
+				bool wait_for_response)
 {
-	struct octep_ctrl_net_h2f_req req = {};
-	struct octep_ctrl_mbox_msg msg = {};
+	struct octep_ctrl_net_wait_data d = {0};
+	struct octep_ctrl_net_h2f_req *req = &d.data.req;
 
-	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_MAC;
-	req.mac.cmd = OCTEP_CTRL_NET_CMD_SET;
-	memcpy(&req.mac.addr, addr, ETH_ALEN);
+	init_send_req(&d.msg, req, mac_sz, vfid);
+	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_MAC;
+	req->mac.cmd = OCTEP_CTRL_NET_CMD_SET;
+	memcpy(&req->mac.addr, addr, ETH_ALEN);
 
-	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
-	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_MAC_REQ_SZW;
-	msg.msg = &req;
-
-	return octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
+	return send_mbox_req(oct, &d, wait_for_response);
 }
 
-int octep_set_mtu(struct octep_device *oct, int mtu)
+int octep_ctrl_net_set_mtu(struct octep_device *oct, int vfid, int mtu,
+			   bool wait_for_response)
 {
-	struct octep_ctrl_net_h2f_req req = {};
-	struct octep_ctrl_mbox_msg msg = {};
-
-	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_MTU;
-	req.mtu.cmd = OCTEP_CTRL_NET_CMD_SET;
-	req.mtu.val = mtu;
+	struct octep_ctrl_net_wait_data d = {0};
+	struct octep_ctrl_net_h2f_req *req = &d.data.req;
 
-	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
-	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_MTU_REQ_SZW;
-	msg.msg = &req;
+	init_send_req(&d.msg, req, mtu_sz, vfid);
+	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_MTU;
+	req->mtu.cmd = OCTEP_CTRL_NET_CMD_SET;
+	req->mtu.val = mtu;
 
-	return octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
+	return send_mbox_req(oct, &d, wait_for_response);
 }
 
-int octep_get_if_stats(struct octep_device *oct)
+int octep_ctrl_net_get_if_stats(struct octep_device *oct, int vfid)
 {
 	void __iomem *iface_rx_stats;
 	void __iomem *iface_tx_stats;
-	struct octep_ctrl_net_h2f_req req = {};
-	struct octep_ctrl_mbox_msg msg = {};
+	struct octep_ctrl_net_wait_data d = {0};
+	struct octep_ctrl_net_h2f_req *req = &d.data.req;
 	int err;
 
-	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_GET_IF_STATS;
-	req.mac.cmd = OCTEP_CTRL_NET_CMD_GET;
-	req.get_stats.offset = oct->ctrl_mbox_ifstats_offset;
-
-	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
-	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_GET_STATS_REQ_SZW;
-	msg.msg = &req;
-	err = octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
-	if (err)
+	init_send_req(&d.msg, req, get_stats_sz, vfid);
+	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_GET_IF_STATS;
+	req->get_stats.offset = oct->ctrl_mbox_ifstats_offset;
+	err = send_mbox_req(oct, &d, true);
+	if (err < 0)
 		return err;
 
 	iface_rx_stats = oct->ctrl_mbox.barmem + oct->ctrl_mbox_ifstats_offset;
@@ -144,51 +209,115 @@ int octep_get_if_stats(struct octep_device *oct)
 	memcpy_fromio(&oct->iface_rx_stats, iface_rx_stats, sizeof(struct octep_iface_rx_stats));
 	memcpy_fromio(&oct->iface_tx_stats, iface_tx_stats, sizeof(struct octep_iface_tx_stats));
 
-	return err;
+	return 0;
 }
 
-int octep_get_link_info(struct octep_device *oct)
+int octep_ctrl_net_get_link_info(struct octep_device *oct, int vfid)
 {
-	struct octep_ctrl_net_h2f_req req = {};
+	struct octep_ctrl_net_wait_data d = {0};
+	struct octep_ctrl_net_h2f_req *req = &d.data.req;
 	struct octep_ctrl_net_h2f_resp *resp;
-	struct octep_ctrl_mbox_msg msg = {};
 	int err;
 
-	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_INFO;
-	req.mac.cmd = OCTEP_CTRL_NET_CMD_GET;
-
-	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
-	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_LINK_INFO_REQ_SZW;
-	msg.msg = &req;
-	err = octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
-	if (err)
+	init_send_req(&d.msg, req, link_info_sz, vfid);
+	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_INFO;
+	req->link_info.cmd = OCTEP_CTRL_NET_CMD_GET;
+	err = send_mbox_req(oct, &d, true);
+	if (err < 0)
 		return err;
 
-	resp = (struct octep_ctrl_net_h2f_resp *)&req;
+	resp = &d.data.resp;
 	oct->link_info.supported_modes = resp->link_info.supported_modes;
 	oct->link_info.advertised_modes = resp->link_info.advertised_modes;
 	oct->link_info.autoneg = resp->link_info.autoneg;
 	oct->link_info.pause = resp->link_info.pause;
 	oct->link_info.speed = resp->link_info.speed;
 
-	return err;
+	return 0;
 }
 
-int octep_set_link_info(struct octep_device *oct, struct octep_iface_link_info *link_info)
+int octep_ctrl_net_set_link_info(struct octep_device *oct, int vfid,
+				 struct octep_iface_link_info *link_info,
+				 bool wait_for_response)
 {
-	struct octep_ctrl_net_h2f_req req = {};
-	struct octep_ctrl_mbox_msg msg = {};
+	struct octep_ctrl_net_wait_data d = {0};
+	struct octep_ctrl_net_h2f_req *req = &d.data.req;
+
+	init_send_req(&d.msg, req, link_info_sz, vfid);
+	req->hdr.s.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_INFO;
+	req->link_info.cmd = OCTEP_CTRL_NET_CMD_SET;
+	req->link_info.info.advertised_modes = link_info->advertised_modes;
+	req->link_info.info.autoneg = link_info->autoneg;
+	req->link_info.info.pause = link_info->pause;
+	req->link_info.info.speed = link_info->speed;
+
+	return send_mbox_req(oct, &d, wait_for_response);
+}
+
+static int process_mbox_req(struct octep_device *oct,
+			    struct octep_ctrl_mbox_msg *msg)
+{
+	return 0;
+}
+
+static int process_mbox_resp(struct octep_device *oct,
+			     struct octep_ctrl_mbox_msg *msg)
+{
+	struct octep_ctrl_net_wait_data *pos, *n;
+
+	list_for_each_entry_safe(pos, n, &oct->ctrl_req_wait_list, list) {
+		if (pos->msg.hdr.s.msg_id == msg->hdr.s.msg_id) {
+			memcpy(&pos->data.resp,
+			       msg->sg_list[0].msg,
+			       msg->hdr.s.sz);
+			pos->done = 1;
+			wake_up_interruptible_all(&oct->ctrl_req_wait_q);
+			break;
+		}
+	}
+
+	return 0;
+}
+
+int octep_ctrl_net_recv_fw_messages(struct octep_device *oct)
+{
+	static u16 msg_sz = sizeof(union octep_ctrl_net_max_data);
+	union octep_ctrl_net_max_data data = {0};
+	struct octep_ctrl_mbox_msg msg = {0};
+	int ret;
+
+	msg.hdr.s.sz = msg_sz;
+	msg.sg_num = 1;
+	msg.sg_list[0].sz = msg_sz;
+	msg.sg_list[0].msg = &data;
+	while (true) {
+		/* mbox will overwrite msg.hdr.s.sz so initialize it */
+		msg.hdr.s.sz = msg_sz;
+		ret = octep_ctrl_mbox_recv(&oct->ctrl_mbox,
+					   (struct octep_ctrl_mbox_msg *)&msg,
+					   1);
+		if (ret <= 0)
+			break;
+
+		if (msg.hdr.s.flags & OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ)
+			process_mbox_req(oct, &msg);
+		else if (msg.hdr.s.flags & OCTEP_CTRL_MBOX_MSG_HDR_FLAG_RESP)
+			process_mbox_resp(oct, &msg);
+	}
+
+	return 0;
+}
+
+int octep_ctrl_net_uninit(struct octep_device *oct)
+{
+	struct octep_ctrl_net_wait_data *pos, *n;
+
+	list_for_each_entry_safe(pos, n, &oct->ctrl_req_wait_list, list)
+		pos->done = 1;
 
-	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_INFO;
-	req.link_info.cmd = OCTEP_CTRL_NET_CMD_SET;
-	req.link_info.info.advertised_modes = link_info->advertised_modes;
-	req.link_info.info.autoneg = link_info->autoneg;
-	req.link_info.info.pause = link_info->pause;
-	req.link_info.info.speed = link_info->speed;
+	wake_up_interruptible_all(&oct->ctrl_req_wait_q);
 
-	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
-	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_LINK_INFO_REQ_SZW;
-	msg.msg = &req;
+	octep_ctrl_mbox_uninit(&oct->ctrl_mbox);
 
-	return octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
+	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h
index f23b58381322..c68cdaa1738b 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h
@@ -7,6 +7,8 @@
 #ifndef __OCTEP_CTRL_NET_H__
 #define __OCTEP_CTRL_NET_H__
 
+#define OCTEP_CTRL_NET_INVALID_VFID	(-1)
+
 /* Supported commands */
 enum octep_ctrl_net_cmd {
 	OCTEP_CTRL_NET_CMD_GET = 0,
@@ -45,15 +47,18 @@ enum octep_ctrl_net_f2h_cmd {
 	OCTEP_CTRL_NET_F2H_CMD_LINK_STATUS,
 };
 
-struct octep_ctrl_net_req_hdr {
-	/* sender id */
-	u16 sender;
-	/* receiver id */
-	u16 receiver;
-	/* octep_ctrl_net_h2t_cmd */
-	u16 cmd;
-	/* reserved */
-	u16 rsvd0;
+union octep_ctrl_net_req_hdr {
+	u64 words[1];
+	struct {
+		/* sender id */
+		u16 sender;
+		/* receiver id */
+		u16 receiver;
+		/* octep_ctrl_net_h2t_cmd */
+		u16 cmd;
+		/* reserved */
+		u16 rsvd0;
+	} s;
 };
 
 /* get/set mtu request */
@@ -110,7 +115,7 @@ struct octep_ctrl_net_h2f_req_cmd_link_info {
 
 /* Host to fw request data */
 struct octep_ctrl_net_h2f_req {
-	struct octep_ctrl_net_req_hdr hdr;
+	union octep_ctrl_net_req_hdr hdr;
 	union {
 		struct octep_ctrl_net_h2f_req_cmd_mtu mtu;
 		struct octep_ctrl_net_h2f_req_cmd_mac mac;
@@ -121,15 +126,18 @@ struct octep_ctrl_net_h2f_req {
 	};
 } __packed;
 
-struct octep_ctrl_net_resp_hdr {
-	/* sender id */
-	u16 sender;
-	/* receiver id */
-	u16 receiver;
-	/* octep_ctrl_net_h2t_cmd */
-	u16 cmd;
-	/* octep_ctrl_net_reply */
-	u16 reply;
+union octep_ctrl_net_resp_hdr {
+	u64 words[1];
+	struct {
+		/* sender id */
+		u16 sender;
+		/* receiver id */
+		u16 receiver;
+		/* octep_ctrl_net_h2t_cmd */
+		u16 cmd;
+		/* octep_ctrl_net_reply */
+		u16 reply;
+	} s;
 };
 
 /* get mtu response */
@@ -152,7 +160,7 @@ struct octep_ctrl_net_h2f_resp_cmd_state {
 
 /* Host to fw response data */
 struct octep_ctrl_net_h2f_resp {
-	struct octep_ctrl_net_resp_hdr hdr;
+	union octep_ctrl_net_resp_hdr hdr;
 	union {
 		struct octep_ctrl_net_h2f_resp_cmd_mtu mtu;
 		struct octep_ctrl_net_h2f_resp_cmd_mac mac;
@@ -170,7 +178,7 @@ struct octep_ctrl_net_f2h_req_cmd_state {
 
 /* Fw to host request data */
 struct octep_ctrl_net_f2h_req {
-	struct octep_ctrl_net_req_hdr hdr;
+	union octep_ctrl_net_req_hdr hdr;
 	union {
 		struct octep_ctrl_net_f2h_req_cmd_state link;
 	};
@@ -178,122 +186,146 @@ struct octep_ctrl_net_f2h_req {
 
 /* Fw to host response data */
 struct octep_ctrl_net_f2h_resp {
-	struct octep_ctrl_net_resp_hdr hdr;
+	union octep_ctrl_net_resp_hdr hdr;
 };
 
-/* Size of host to fw octep_ctrl_mbox queue element */
-union octep_ctrl_net_h2f_data_sz {
+/* Max data size to be transferred over mbox */
+union octep_ctrl_net_max_data {
 	struct octep_ctrl_net_h2f_req h2f_req;
 	struct octep_ctrl_net_h2f_resp h2f_resp;
-};
-
-/* Size of fw to host octep_ctrl_mbox queue element */
-union octep_ctrl_net_f2h_data_sz {
 	struct octep_ctrl_net_f2h_req f2h_req;
 	struct octep_ctrl_net_f2h_resp f2h_resp;
 };
 
-/* size of host to fw data in words */
-#define OCTEP_CTRL_NET_H2F_DATA_SZW		((sizeof(union octep_ctrl_net_h2f_data_sz)) / \
-						 (sizeof(unsigned long)))
-
-/* size of fw to host data in words */
-#define OCTEP_CTRL_NET_F2H_DATA_SZW		((sizeof(union octep_ctrl_net_f2h_data_sz)) / \
-						 (sizeof(unsigned long)))
-
-/* size in words of get/set mtu request */
-#define OCTEP_CTRL_NET_H2F_MTU_REQ_SZW			2
-/* size in words of get/set mac request */
-#define OCTEP_CTRL_NET_H2F_MAC_REQ_SZW			2
-/* size in words of get stats request */
-#define OCTEP_CTRL_NET_H2F_GET_STATS_REQ_SZW		2
-/* size in words of get/set state request */
-#define OCTEP_CTRL_NET_H2F_STATE_REQ_SZW		2
-/* size in words of get/set link info request */
-#define OCTEP_CTRL_NET_H2F_LINK_INFO_REQ_SZW		4
-
-/* size in words of get mtu response */
-#define OCTEP_CTRL_NET_H2F_GET_MTU_RESP_SZW		2
-/* size in words of set mtu response */
-#define OCTEP_CTRL_NET_H2F_SET_MTU_RESP_SZW		1
-/* size in words of get mac response */
-#define OCTEP_CTRL_NET_H2F_GET_MAC_RESP_SZW		2
-/* size in words of set mac response */
-#define OCTEP_CTRL_NET_H2F_SET_MAC_RESP_SZW		1
-/* size in words of get state request */
-#define OCTEP_CTRL_NET_H2F_GET_STATE_RESP_SZW		2
-/* size in words of set state request */
-#define OCTEP_CTRL_NET_H2F_SET_STATE_RESP_SZW		1
-/* size in words of get link info request */
-#define OCTEP_CTRL_NET_H2F_GET_LINK_INFO_RESP_SZW	4
-/* size in words of set link info request */
-#define OCTEP_CTRL_NET_H2F_SET_LINK_INFO_RESP_SZW	1
+struct octep_ctrl_net_wait_data {
+	struct list_head list;
+	int done;
+	struct octep_ctrl_mbox_msg msg;
+	union {
+		struct octep_ctrl_net_h2f_req req;
+		struct octep_ctrl_net_h2f_resp resp;
+	} data;
+};
+
+/** Initialize data for ctrl net.
+ *
+ * @param oct: non-null pointer to struct octep_device.
+ *
+ * return value: 0 on success, -errno on error.
+ */
+int octep_ctrl_net_init(struct octep_device *oct);
 
 /** Get link status from firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
+ * @param vfid: Index of virtual function.
  *
  * return value: link status 0=down, 1=up.
  */
-int octep_get_link_status(struct octep_device *oct);
+int octep_ctrl_net_get_link_status(struct octep_device *oct, int vfid);
 
 /** Set link status in firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
+ * @param vfid: Index of virtual function.
  * @param up: boolean status.
+ * @param wait_for_response: poll for response.
+ *
+ * return value: 0 on success, -errno on failure
  */
-void octep_set_link_status(struct octep_device *oct, bool up);
+int octep_ctrl_net_set_link_status(struct octep_device *oct, int vfid, bool up,
+				   bool wait_for_response);
 
 /** Set rx state in firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
+ * @param vfid: Index of virtual function.
  * @param up: boolean status.
+ * @param wait_for_response: poll for response.
+ *
+ * return value: 0 on success, -errno on failure.
  */
-void octep_set_rx_state(struct octep_device *oct, bool up);
+int octep_ctrl_net_set_rx_state(struct octep_device *oct, int vfid, bool up,
+				bool wait_for_response);
 
 /** Get mac address from firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
+ * @param vfid: Index of virtual function.
  * @param addr: non-null pointer to mac address.
  *
  * return value: 0 on success, -errno on failure.
  */
-int octep_get_mac_addr(struct octep_device *oct, u8 *addr);
+int octep_ctrl_net_get_mac_addr(struct octep_device *oct, int vfid, u8 *addr);
 
 /** Set mac address in firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
+ * @param vfid: Index of virtual function.
  * @param addr: non-null pointer to mac address.
+ * @param wait_for_response: poll for response.
+ *
+ * return value: 0 on success, -errno on failure.
  */
-int octep_set_mac_addr(struct octep_device *oct, u8 *addr);
+int octep_ctrl_net_set_mac_addr(struct octep_device *oct, int vfid, u8 *addr,
+				bool wait_for_response);
 
 /** Set mtu in firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
+ * @param vfid: Index of virtual function.
  * @param mtu: mtu.
+ * @param wait_for_response: poll for response.
+ *
+ * return value: 0 on success, -errno on failure.
  */
-int octep_set_mtu(struct octep_device *oct, int mtu);
+int octep_ctrl_net_set_mtu(struct octep_device *oct, int vfid, int mtu,
+			   bool wait_for_response);
 
 /** Get interface statistics from firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
+ * @param vfid: Index of virtual function.
  *
  * return value: 0 on success, -errno on failure.
  */
-int octep_get_if_stats(struct octep_device *oct);
+int octep_ctrl_net_get_if_stats(struct octep_device *oct, int vfid);
 
 /** Get link info from firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
+ * @param vfid: Index of virtual function.
  *
  * return value: 0 on success, -errno on failure.
  */
-int octep_get_link_info(struct octep_device *oct);
+int octep_ctrl_net_get_link_info(struct octep_device *oct, int vfid);
 
 /** Set link info in firmware.
  *
  * @param oct: non-null pointer to struct octep_device.
+ * @param vfid: Index of virtual function.
+ * @param link_info: non-null pointer to struct octep_iface_link_info.
+ * @param wait_for_response: poll for response.
+ *
+ * return value: 0 on success, -errno on failure.
+ */
+int octep_ctrl_net_set_link_info(struct octep_device *oct,
+				 int vfid,
+				 struct octep_iface_link_info *link_info,
+				 bool wait_for_response);
+
+/** Poll for firmware messages and process them.
+ *
+ * @param oct: non-null pointer to struct octep_device.
+ */
+int octep_ctrl_net_recv_fw_messages(struct octep_device *oct);
+
+/** Uninitialize data for ctrl net.
+ *
+ * @param oct: non-null pointer to struct octep_device.
+ *
+ * return value: 0 on success, -errno on error.
  */
-int octep_set_link_info(struct octep_device *oct, struct octep_iface_link_info *link_info);
+int octep_ctrl_net_uninit(struct octep_device *oct);
 
 #endif /* __OCTEP_CTRL_NET_H__ */
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c
index 87ef129b269a..389042b57787 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ethtool.c
@@ -150,7 +150,7 @@ octep_get_ethtool_stats(struct net_device *netdev,
 	rx_packets = 0;
 	rx_bytes = 0;
 
-	octep_get_if_stats(oct);
+	octep_ctrl_net_get_if_stats(oct, OCTEP_CTRL_NET_INVALID_VFID);
 	iface_tx_stats = &oct->iface_tx_stats;
 	iface_rx_stats = &oct->iface_rx_stats;
 
@@ -283,7 +283,7 @@ static int octep_get_link_ksettings(struct net_device *netdev,
 	ethtool_link_ksettings_zero_link_mode(cmd, supported);
 	ethtool_link_ksettings_zero_link_mode(cmd, advertising);
 
-	octep_get_link_info(oct);
+	octep_ctrl_net_get_link_info(oct, OCTEP_CTRL_NET_INVALID_VFID);
 
 	advertised_modes = oct->link_info.advertised_modes;
 	supported_modes = oct->link_info.supported_modes;
@@ -439,7 +439,8 @@ static int octep_set_link_ksettings(struct net_device *netdev,
 	link_info_new.speed = cmd->base.speed;
 	link_info_new.autoneg = autoneg;
 
-	err = octep_set_link_info(oct, &link_info_new);
+	err = octep_ctrl_net_set_link_info(oct, OCTEP_CTRL_NET_INVALID_VFID,
+					   &link_info_new, true);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index c07588461030..32e2ca24849a 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -508,11 +508,10 @@ static int octep_open(struct net_device *netdev)
 	octep_napi_enable(oct);
 
 	oct->link_info.admin_up = 1;
-	octep_set_rx_state(oct, true);
-
-	ret = octep_get_link_status(oct);
-	if (!ret)
-		octep_set_link_status(oct, true);
+	octep_ctrl_net_set_rx_state(oct, OCTEP_CTRL_NET_INVALID_VFID, true,
+				    false);
+	octep_ctrl_net_set_link_status(oct, OCTEP_CTRL_NET_INVALID_VFID, true,
+				       false);
 	oct->poll_non_ioq_intr = false;
 
 	/* Enable the input and output queues for this Octeon device */
@@ -523,7 +522,7 @@ static int octep_open(struct net_device *netdev)
 
 	octep_oq_dbell_init(oct);
 
-	ret = octep_get_link_status(oct);
+	ret = octep_ctrl_net_get_link_status(oct, OCTEP_CTRL_NET_INVALID_VFID);
 	if (ret > 0)
 		octep_link_up(netdev);
 
@@ -553,14 +552,16 @@ static int octep_stop(struct net_device *netdev)
 
 	netdev_info(netdev, "Stopping the device ...\n");
 
+	octep_ctrl_net_set_link_status(oct, OCTEP_CTRL_NET_INVALID_VFID, false,
+				       false);
+	octep_ctrl_net_set_rx_state(oct, OCTEP_CTRL_NET_INVALID_VFID, false,
+				    false);
+
 	/* Stop Tx from stack */
 	netif_tx_stop_all_queues(netdev);
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
-	octep_set_link_status(oct, false);
-	octep_set_rx_state(oct, false);
-
 	oct->link_info.admin_up = 0;
 	oct->link_info.oper_up = 0;
 
@@ -762,7 +763,9 @@ static void octep_get_stats64(struct net_device *netdev,
 	struct octep_device *oct = netdev_priv(netdev);
 	int q;
 
-	octep_get_if_stats(oct);
+	if (netif_running(netdev))
+		octep_ctrl_net_get_if_stats(oct, OCTEP_CTRL_NET_INVALID_VFID);
+
 	tx_packets = 0;
 	tx_bytes = 0;
 	rx_packets = 0;
@@ -833,7 +836,8 @@ static int octep_set_mac(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	err = octep_set_mac_addr(oct, addr->sa_data);
+	err = octep_ctrl_net_set_mac_addr(oct, OCTEP_CTRL_NET_INVALID_VFID,
+					  addr->sa_data, true);
 	if (err)
 		return err;
 
@@ -853,7 +857,8 @@ static int octep_change_mtu(struct net_device *netdev, int new_mtu)
 	if (link_info->mtu == new_mtu)
 		return 0;
 
-	err = octep_set_mtu(oct, new_mtu);
+	err = octep_ctrl_net_set_mtu(oct, OCTEP_CTRL_NET_INVALID_VFID, new_mtu,
+				     true);
 	if (!err) {
 		oct->link_info.mtu = new_mtu;
 		netdev->mtu = new_mtu;
@@ -905,34 +910,8 @@ static void octep_ctrl_mbox_task(struct work_struct *work)
 {
 	struct octep_device *oct = container_of(work, struct octep_device,
 						ctrl_mbox_task);
-	struct net_device *netdev = oct->netdev;
-	struct octep_ctrl_net_f2h_req req = {};
-	struct octep_ctrl_mbox_msg msg;
-	int ret = 0;
-
-	msg.msg = &req;
-	while (true) {
-		ret = octep_ctrl_mbox_recv(&oct->ctrl_mbox, &msg);
-		if (ret)
-			break;
-
-		switch (req.hdr.cmd) {
-		case OCTEP_CTRL_NET_F2H_CMD_LINK_STATUS:
-			if (netif_running(netdev)) {
-				if (req.link.state) {
-					dev_info(&oct->pdev->dev, "netif_carrier_on\n");
-					netif_carrier_on(netdev);
-				} else {
-					dev_info(&oct->pdev->dev, "netif_carrier_off\n");
-					netif_carrier_off(netdev);
-				}
-			}
-			break;
-		default:
-			pr_info("Unknown mbox req : %u\n", req.hdr.cmd);
-			break;
-		}
-	}
+
+	octep_ctrl_net_recv_fw_messages(oct);
 }
 
 static const char *octep_devid_to_str(struct octep_device *oct)
@@ -956,7 +935,6 @@ static const char *octep_devid_to_str(struct octep_device *oct)
  */
 int octep_device_setup(struct octep_device *oct)
 {
-	struct octep_ctrl_mbox *ctrl_mbox;
 	struct pci_dev *pdev = oct->pdev;
 	int i, ret;
 
@@ -993,18 +971,9 @@ int octep_device_setup(struct octep_device *oct)
 
 	oct->pkind = CFG_GET_IQ_PKIND(oct->conf);
 
-	/* Initialize control mbox */
-	ctrl_mbox = &oct->ctrl_mbox;
-	ctrl_mbox->barmem = CFG_GET_CTRL_MBOX_MEM_ADDR(oct->conf);
-	ret = octep_ctrl_mbox_init(ctrl_mbox);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to initialize control mbox\n");
-		goto unsupported_dev;
-	}
-	oct->ctrl_mbox_ifstats_offset = OCTEP_CTRL_MBOX_SZ(ctrl_mbox->h2fq.elem_sz,
-							   ctrl_mbox->h2fq.elem_cnt,
-							   ctrl_mbox->f2hq.elem_sz,
-							   ctrl_mbox->f2hq.elem_cnt);
+	ret = octep_ctrl_net_init(oct);
+	if (ret)
+		return ret;
 
 	return 0;
 
@@ -1034,7 +1003,7 @@ static void octep_device_cleanup(struct octep_device *oct)
 		oct->mbox[i] = NULL;
 	}
 
-	octep_ctrl_mbox_uninit(&oct->ctrl_mbox);
+	octep_ctrl_net_uninit(oct);
 
 	oct->hw_ops.soft_reset(oct);
 	for (i = 0; i < OCTEP_MMIO_REGIONS; i++) {
@@ -1145,7 +1114,8 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->max_mtu = OCTEP_MAX_MTU;
 	netdev->mtu = OCTEP_DEFAULT_MTU;
 
-	err = octep_get_mac_addr(octep_dev, octep_dev->mac_addr);
+	err = octep_ctrl_net_get_mac_addr(octep_dev, OCTEP_CTRL_NET_INVALID_VFID,
+					  octep_dev->mac_addr);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to get mac address\n");
 		goto register_dev_err;
-- 
2.36.0

