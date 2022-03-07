Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F134CF5AF
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 10:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237089AbiCGJaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 04:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238545AbiCGJ3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 04:29:18 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1E013DC9;
        Mon,  7 Mar 2022 01:27:35 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2278tPG8021320;
        Mon, 7 Mar 2022 01:26:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Pf+ejItSEH6tATxhQTe8KSCZcJ5xNbDJmEM/Eizzn3g=;
 b=PnGtAOeAzX2q0g20SxwiwVUo/t6U68X360LCOM4ZzxXL0JMKWiXjcB7dgM1E7nBJX9De
 kHER6ouxZ96Hyp5Cj2IDMWGzgMlMTGKj+PObQMXgRpASnzbQ8/eCJj8ukJpCQUCW/YaN
 eZcOrRQDKq+XKW13aYbc2KCLK8MHwVFGKal6jmBpsGiUzVIyk8/29EEO2rd0xztos+DF
 nCPzfDhhdtUhdsk9FgzZu3v1iiepS18De7xq/zVUJNBoXxyREfiFnYjDYpMleR3lN66U
 ZxI4W1bZ2btP01ALqKYzrzKSud0YKqch0HDT7QrtjdZGVsSqEGQkNom9ayiCQK42JI7U HQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3em63sxck7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 01:26:51 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Mar
 2022 01:26:50 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Mar 2022 01:26:50 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 14C2F3F7040;
        Mon,  7 Mar 2022 01:26:50 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <vburru@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <corbet@lwn.net>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Abhijit Ayarekar <aayarekar@marvell.com>,
        Satananda Burla <sburla@marvell.com>
Subject: [PATCH v3 3/7] octeon_ep: Add mailbox for control commands
Date:   Mon, 7 Mar 2022 01:26:42 -0800
Message-ID: <20220307092646.17156-4-vburru@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220307092646.17156-1-vburru@marvell.com>
References: <20220307092646.17156-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: quT1oek9jX3GxtxUPuxrVAKk5b9meN2-
X-Proofpoint-GUID: quT1oek9jX3GxtxUPuxrVAKk5b9meN2-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_01,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add mailbox between host and NIC to send control commands from host to
NIC and receive responses and notifications from NIC to host driver,
like link status update.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
Signed-off-by: Satananda Burla <sburla@marvell.com>
---
V2 -> V3: no change.

V1 -> V2:
  - created by dividing PATCH 1/4 of original patch series.

 .../marvell/octeon_ep/octep_ctrl_mbox.c       | 178 +++++++++++++++++-
 .../marvell/octeon_ep/octep_ctrl_net.c        | 100 +++++++++-
 2 files changed, 270 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
index 72a60c2a3cf0..f2101b9f2532 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
@@ -65,20 +65,190 @@ static inline u32 octep_ctrl_mbox_circq_depth(u32 pi, u32 ci, u32 mask)
 
 int octep_ctrl_mbox_init(struct octep_ctrl_mbox *mbox)
 {
-	return -EINVAL;
+	u64 version, magic_num, status;
+
+	if (!mbox)
+		return -EINVAL;
+
+	if (!mbox->barmem) {
+		pr_info("octep_ctrl_mbox : Invalid barmem %p\n", mbox->barmem);
+		return -EINVAL;
+	}
+
+	magic_num = readq(OCTEP_CTRL_MBOX_INFO_MAGIC_NUM_OFFSET(mbox->barmem));
+	if (magic_num != OCTEP_CTRL_MBOX_MAGIC_NUMBER) {
+		pr_info("octep_ctrl_mbox : Invalid magic number %llx\n", magic_num);
+		return -EINVAL;
+	}
+
+	version = readq(OCTEP_CTRL_MBOX_INFO_FW_VERSION_OFFSET(mbox->barmem));
+	if (version != OCTEP_DRV_VERSION) {
+		pr_info("octep_ctrl_mbox : Firmware version mismatch %llx != %x\n",
+			version, OCTEP_DRV_VERSION);
+		return -EINVAL;
+	}
+
+	status = readq(OCTEP_CTRL_MBOX_INFO_FW_STATUS_OFFSET(mbox->barmem));
+	if (status != OCTEP_CTRL_MBOX_STATUS_READY) {
+		pr_info("octep_ctrl_mbox : Firmware is not ready.\n");
+		return -EINVAL;
+	}
+
+	mbox->barmem_sz = readl(OCTEP_CTRL_MBOX_INFO_BARMEM_SZ_OFFSET(mbox->barmem));
+
+	writeq(mbox->version, OCTEP_CTRL_MBOX_INFO_HOST_VERSION_OFFSET(mbox->barmem));
+	writeq(OCTEP_CTRL_MBOX_STATUS_INIT, OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(mbox->barmem));
+
+	mbox->h2fq.elem_cnt = readl(OCTEP_CTRL_MBOX_H2FQ_ELEM_CNT_OFFSET(mbox->barmem));
+	mbox->h2fq.elem_sz = readl(OCTEP_CTRL_MBOX_H2FQ_ELEM_SZ_OFFSET(mbox->barmem));
+	mbox->h2fq.mask = (mbox->h2fq.elem_cnt - 1);
+	mutex_init(&mbox->h2fq_lock);
+
+	mbox->f2hq.elem_cnt = readl(OCTEP_CTRL_MBOX_F2HQ_ELEM_CNT_OFFSET(mbox->barmem));
+	mbox->f2hq.elem_sz = readl(OCTEP_CTRL_MBOX_F2HQ_ELEM_SZ_OFFSET(mbox->barmem));
+	mbox->f2hq.mask = (mbox->f2hq.elem_cnt - 1);
+	mutex_init(&mbox->f2hq_lock);
+
+	mbox->h2fq.hw_prod = OCTEP_CTRL_MBOX_H2FQ_PROD_OFFSET(mbox->barmem);
+	mbox->h2fq.hw_cons = OCTEP_CTRL_MBOX_H2FQ_CONS_OFFSET(mbox->barmem);
+	mbox->h2fq.hw_q = mbox->barmem +
+			  OCTEP_CTRL_MBOX_INFO_SZ +
+			  OCTEP_CTRL_MBOX_H2FQ_INFO_SZ +
+			  OCTEP_CTRL_MBOX_F2HQ_INFO_SZ;
+
+	mbox->f2hq.hw_prod = OCTEP_CTRL_MBOX_F2HQ_PROD_OFFSET(mbox->barmem);
+	mbox->f2hq.hw_cons = OCTEP_CTRL_MBOX_F2HQ_CONS_OFFSET(mbox->barmem);
+	mbox->f2hq.hw_q = mbox->h2fq.hw_q +
+			  ((mbox->h2fq.elem_sz + sizeof(union octep_ctrl_mbox_msg_hdr)) *
+			   mbox->h2fq.elem_cnt);
+
+	/* ensure ready state is seen after everything is initialized */
+	wmb();
+	writeq(OCTEP_CTRL_MBOX_STATUS_READY, OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(mbox->barmem));
+
+	pr_info("Octep ctrl mbox : Init successful.\n");
+
+	return 0;
 }
 
 int octep_ctrl_mbox_send(struct octep_ctrl_mbox *mbox, struct octep_ctrl_mbox_msg *msg)
 {
-	return -EINVAL;
+	unsigned long timeout = msecs_to_jiffies(OCTEP_CTRL_MBOX_MSG_TIMEOUT_MS);
+	unsigned long period = msecs_to_jiffies(OCTEP_CTRL_MBOX_MSG_WAIT_MS);
+	unsigned long expire;
+	struct octep_ctrl_mbox_q *q;
+	u16 pi, ci;
+	u64 *mbuf, *qidx, *word0;
+	int i;
+
+	if (!mbox || !msg)
+		return -EINVAL;
+
+	q = &mbox->h2fq;
+	pi = readl(q->hw_prod);
+	ci = readl(q->hw_cons);
+
+	if (!octep_ctrl_mbox_circq_space(pi, ci, q->mask))
+		return -ENOMEM;
+
+	qidx = OCTEP_CTRL_MBOX_Q_OFFSET(q->hw_q, pi);
+	mbuf = (u64 *)msg->msg;
+	word0 = &msg->hdr.word0;
+
+	mutex_lock(&mbox->h2fq_lock);
+	for (i = 1; i <= msg->hdr.sizew; i++)
+		writeq(*mbuf++, (qidx + i));
+
+	writeq(*word0, qidx);
+
+	pi = octep_ctrl_mbox_circq_inc(pi, q->mask);
+	writel(pi, q->hw_prod);
+	mutex_unlock(&mbox->h2fq_lock);
+
+	/* don't check for notification response */
+	if (msg->hdr.flags & OCTEP_CTRL_MBOX_MSG_HDR_FLAG_NOTIFY)
+		return 0;
+
+	expire = jiffies + timeout;
+	while (true) {
+		*word0 = readq(qidx);
+		if (msg->hdr.flags == OCTEP_CTRL_MBOX_MSG_HDR_FLAG_RESP)
+			break;
+		schedule_timeout_interruptible(period);
+		if (signal_pending(current) || time_after(jiffies, expire)) {
+			pr_info("octep_ctrl_mbox: Timed out\n");
+			return -EBUSY;
+		}
+	}
+	mbuf = (u64 *)msg->msg;
+	for (i = 1; i <= msg->hdr.sizew; i++)
+		*mbuf++ = readq(qidx + i);
+
+	return 0;
 }
 
 int octep_ctrl_mbox_recv(struct octep_ctrl_mbox *mbox, struct octep_ctrl_mbox_msg *msg)
 {
-	return -EINVAL;
+	struct octep_ctrl_mbox_q *q;
+	u32 count, pi, ci;
+	u64 *qidx, *mbuf;
+	int i;
+
+	if (!mbox || !msg)
+		return -EINVAL;
+
+	q = &mbox->f2hq;
+	pi = readl(q->hw_prod);
+	ci = readl(q->hw_cons);
+	count = octep_ctrl_mbox_circq_depth(pi, ci, q->mask);
+	if (!count)
+		return -EAGAIN;
+
+	qidx = OCTEP_CTRL_MBOX_Q_OFFSET(q->hw_q, ci);
+	mbuf = (u64 *)msg->msg;
+
+	mutex_lock(&mbox->f2hq_lock);
+
+	msg->hdr.word0 = readq(qidx);
+	for (i = 1; i <= msg->hdr.sizew; i++)
+		*mbuf++ = readq(qidx + i);
+
+	ci = octep_ctrl_mbox_circq_inc(ci, q->mask);
+	writel(ci, q->hw_cons);
+
+	mutex_unlock(&mbox->f2hq_lock);
+
+	if (msg->hdr.flags != OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ || !mbox->process_req)
+		return 0;
+
+	mbox->process_req(mbox->user_ctx, msg);
+	mbuf = (u64 *)msg->msg;
+	for (i = 1; i <= msg->hdr.sizew; i++)
+		writeq(*mbuf++, (qidx + i));
+
+	writeq(msg->hdr.word0, qidx);
+
+	return 0;
 }
 
 int octep_ctrl_mbox_uninit(struct octep_ctrl_mbox *mbox)
 {
-	return -EINVAL;
+	if (!mbox)
+		return -EINVAL;
+
+	writeq(OCTEP_CTRL_MBOX_STATUS_UNINIT,
+	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(mbox->barmem));
+	/* ensure uninit state is written before uninitialization */
+	wmb();
+
+	mutex_destroy(&mbox->h2fq_lock);
+	mutex_destroy(&mbox->f2hq_lock);
+
+	writeq(OCTEP_CTRL_MBOX_STATUS_INVALID,
+	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(mbox->barmem));
+	writeq(0, OCTEP_CTRL_MBOX_INFO_HOST_VERSION_OFFSET(mbox->barmem));
+
+	pr_info("Octep ctrl mbox : Uninit successful.\n");
+
+	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
index 021f888d8f6d..c3aca7b2775b 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
@@ -15,28 +15,120 @@
 
 int octep_get_link_status(struct octep_device *oct)
 {
-	return 0;
+	struct octep_ctrl_net_h2f_req req = {};
+	struct octep_ctrl_net_h2f_resp *resp;
+	struct octep_ctrl_mbox_msg msg = {};
+	int err;
+
+	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_STATUS;
+	req.link.cmd = OCTEP_CTRL_NET_CMD_GET;
+
+	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
+	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_STATE_REQ_SZW;
+	msg.msg = &req;
+	err = octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
+	if (err)
+		return err;
+
+	resp = (struct octep_ctrl_net_h2f_resp *)&req;
+	return resp->link.state;
 }
 
 void octep_set_link_status(struct octep_device *oct, bool up)
 {
+	struct octep_ctrl_net_h2f_req req = {};
+	struct octep_ctrl_mbox_msg msg = {};
+
+	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_STATUS;
+	req.link.cmd = OCTEP_CTRL_NET_CMD_SET;
+	req.link.state = (up) ? OCTEP_CTRL_NET_STATE_UP : OCTEP_CTRL_NET_STATE_DOWN;
+
+	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
+	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_STATE_REQ_SZW;
+	msg.msg = &req;
+	octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
 }
 
 void octep_set_rx_state(struct octep_device *oct, bool up)
 {
+	struct octep_ctrl_net_h2f_req req = {};
+	struct octep_ctrl_mbox_msg msg = {};
+
+	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_RX_STATE;
+	req.link.cmd = OCTEP_CTRL_NET_CMD_SET;
+	req.link.state = (up) ? OCTEP_CTRL_NET_STATE_UP : OCTEP_CTRL_NET_STATE_DOWN;
+
+	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
+	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_STATE_REQ_SZW;
+	msg.msg = &req;
+	octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
 }
 
 int octep_get_mac_addr(struct octep_device *oct, u8 *addr)
 {
-	return -1;
+	struct octep_ctrl_net_h2f_req req = {};
+	struct octep_ctrl_net_h2f_resp *resp;
+	struct octep_ctrl_mbox_msg msg = {};
+	int err;
+
+	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_MAC;
+	req.link.cmd = OCTEP_CTRL_NET_CMD_GET;
+
+	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
+	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_MAC_REQ_SZW;
+	msg.msg = &req;
+	err = octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
+	if (err)
+		return err;
+
+	resp = (struct octep_ctrl_net_h2f_resp *)&req;
+	memcpy(addr, resp->mac.addr, ETH_ALEN);
+
+	return err;
 }
 
 int octep_get_link_info(struct octep_device *oct)
 {
-	return -1;
+	struct octep_ctrl_net_h2f_req req = {};
+	struct octep_ctrl_net_h2f_resp *resp;
+	struct octep_ctrl_mbox_msg msg = {};
+	int err;
+
+	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_INFO;
+	req.mac.cmd = OCTEP_CTRL_NET_CMD_GET;
+
+	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
+	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_LINK_INFO_REQ_SZW;
+	msg.msg = &req;
+	err = octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
+	if (err)
+		return err;
+
+	resp = (struct octep_ctrl_net_h2f_resp *)&req;
+	oct->link_info.supported_modes = resp->link_info.supported_modes;
+	oct->link_info.advertised_modes = resp->link_info.advertised_modes;
+	oct->link_info.autoneg = resp->link_info.autoneg;
+	oct->link_info.pause = resp->link_info.pause;
+	oct->link_info.speed = resp->link_info.speed;
+
+	return err;
 }
 
 int octep_set_link_info(struct octep_device *oct, struct octep_iface_link_info *link_info)
 {
-	return -1;
+	struct octep_ctrl_net_h2f_req req = {};
+	struct octep_ctrl_mbox_msg msg = {};
+
+	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_INFO;
+	req.link_info.cmd = OCTEP_CTRL_NET_CMD_SET;
+	req.link_info.info.advertised_modes = link_info->advertised_modes;
+	req.link_info.info.autoneg = link_info->autoneg;
+	req.link_info.info.pause = link_info->pause;
+	req.link_info.info.speed = link_info->speed;
+
+	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
+	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_LINK_INFO_REQ_SZW;
+	msg.msg = &req;
+
+	return octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
 }
-- 
2.17.1

