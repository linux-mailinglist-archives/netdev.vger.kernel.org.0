Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B75CB148D2C
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 18:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389445AbgAXRqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 12:46:10 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40120 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387873AbgAXRqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 12:46:10 -0500
Received: by mail-pf1-f195.google.com with SMTP id q8so1462846pfh.7
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 09:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QHmrUbINS89CjIqKsQlggunX8AgiLFGErKDeupIdXj4=;
        b=OtHENZklLb94cxbVykCROvvrgP2b5pu7Y7kxL42IRGDA8VGvCyQwDkMFJi7SG5B1/r
         f7B2oATjry/nOfUCqMR3uLXB12xnPQnYgUSCCGV0pcoH7FttmD+luBx/XXez9mG0RIFg
         O4Hmiksa6dPGZLHoifEXencR9ySC5i+Rnhz1N+FKr3ilhjACLaq/o8gJ4Ag97d3HKD8O
         XJVyWr0quoRQK7vJ5QaWNP4MdfolwFmGr0UdmTrXlrxoyTmzvCbbZxOzDdBrAeI+jIPD
         mxA3Hz52l6d5UQCV5khMNk+WPudyZMT7Atkbk6KQ0nZDHh2igXBYkItTr1ptmGpwSqjZ
         WlRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QHmrUbINS89CjIqKsQlggunX8AgiLFGErKDeupIdXj4=;
        b=SGJVTyw6fJm1GLs/gzMzJqgPTS4bgYcpvEswJnI8+TrfkhPTpy2oEcoo8IekgdaydB
         BkX/TV7f/vOB+4mxYHQN5uphzGniap+AKJhJmv7A49yfw+4cwK+CTD8tG429Z/CHwnE9
         Te2IT9HBNit5rrU5Mby5Ri1rAuCYCGe8A4/BN7venFjOB0RAUxg3WO5mOgA9Kg3gHlMR
         KmeuXgGoFM9uSf5rThEmMJRV7IZdo19o8a2d2pXqf7cb3f6hUXIhL+8pvhn9rgGwGBp4
         NTZbVUpckhLkPqfA3W6wDI1knwArozuKeBRmNgro/o6qrLPb5VB/A2I1HvN+GjhTmroV
         enZQ==
X-Gm-Message-State: APjAAAVIcIQiqjBoJl6pRNG1//LeGiZCuR3/cFu+ZNV5+pGxwta7ZRDg
        2XYqndEBUjYsRBT8fmA9ADZ+Iaiofoo=
X-Google-Smtp-Source: APXvYqy47CtsdgvU01oAdpGiaMl9d1C6LCr0wRbYZevplQ18vzkSR6z9qAWn8DBvuoqP/AQsq0vR9g==
X-Received: by 2002:a63:946:: with SMTP id 67mr5142269pgj.277.1579887969000;
        Fri, 24 Jan 2020 09:46:09 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id w11sm7310849pgs.60.2020.01.24.09.46.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 Jan 2020 09:46:08 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Christina Jacob <cjacob@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Aleksey Makarov <amakarov@marvell.com>
Subject: [PATCH v5 02/17] octeontx2-pf: Mailbox communication with AF
Date:   Fri, 24 Jan 2020 23:15:40 +0530
Message-Id: <1579887955-22172-3-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

In the resource virtualization unit (RVU) each of the PF and AF
(admin function) share a 64KB of reserved memory region for
communication. This patch initializes PF <=> AF mailbox IRQs,
registers handlers for processing these communication messages.
Also adds support to process these messages in both directions
ie responses to PF initiated DOWN (PF => AF) messages and AF
initiated UP messages (AF => PF).

Mbox communication APIs and message formats are defined in AF driver
(drivers/net/ethernet/marvell/octeontx2/af), mbox.h from AF driver is
included here to avoid duplication.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Christina Jacob <cjacob@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Aleksey Makarov <amakarov@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  28 ++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   | 166 ++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 359 ++++++++++++++++++++-
 4 files changed, 552 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
index 622b803..339fde8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -5,6 +5,6 @@
 
 obj-$(CONFIG_OCTEONTX2_PF) += octeontx2_nicpf.o
 
-octeontx2_nicpf-y := otx2_pf.o
+octeontx2_nicpf-y := otx2_pf.o otx2_common.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
new file mode 100644
index 0000000..cbab325
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell OcteonTx2 RVU Ethernet driver
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+
+#include "otx2_reg.h"
+#include "otx2_common.h"
+
+#define M(_name, _id, _fn_name, _req_type, _rsp_type)			\
+int __weak								\
+otx2_mbox_up_handler_ ## _fn_name(struct otx2_nic *pfvf,		\
+				struct _req_type *req,			\
+				struct _rsp_type *rsp)			\
+{									\
+	/* Nothing to do here */					\
+	return 0;							\
+}									\
+EXPORT_SYMBOL(otx2_mbox_up_handler_ ## _fn_name);
+MBOX_UP_CGX_MESSAGES
+#undef M
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 9d52ab3..a21eaaf6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -13,6 +13,7 @@
 
 #include <linux/pci.h>
 
+#include <mbox.h>
 #include "otx2_reg.h"
 
 /* PCI device IDs */
@@ -20,12 +21,31 @@
 
 /* PCI BAR nos */
 #define PCI_CFG_REG_BAR_NUM                     2
+#define PCI_MBOX_BAR_NUM                        4
+
+#define NAME_SIZE                               32
+
+struct mbox {
+	struct otx2_mbox	mbox;
+	struct work_struct	mbox_wrk;
+	struct otx2_mbox	mbox_up;
+	struct work_struct	mbox_up_wrk;
+	struct otx2_nic		*pfvf;
+	void			*bbuf_base; /* Bounce buffer for mbox memory */
+	struct mutex		lock;	/* serialize mailbox access */
+	int			num_msgs; /* mbox number of messages */
+	int			up_num_msgs; /* mbox_up number of messages */
+};
 
 struct otx2_hw {
 	struct pci_dev		*pdev;
 	u16                     rx_queues;
 	u16                     tx_queues;
 	u16			max_queues;
+
+	/* MSI-X */
+	char			*irq_name;
+	cpumask_var_t           *affinity_mask;
 };
 
 struct otx2_nic {
@@ -35,6 +55,12 @@ struct otx2_nic {
 	struct otx2_hw		hw;
 	struct pci_dev		*pdev;
 	struct device		*dev;
+
+	/* Mbox */
+	struct mbox		mbox;
+	struct workqueue_struct *mbox_wq;
+
+	u16			pcifunc; /* RVU PF_FUNC */
 };
 
 /* Register read/write APIs */
@@ -74,4 +100,144 @@ static inline u64 otx2_read64(struct otx2_nic *nic, u64 offset)
 	return readq(addr);
 }
 
+/* Mbox bounce buffer APIs */
+static inline int otx2_mbox_bbuf_init(struct mbox *mbox, struct pci_dev *pdev)
+{
+	struct otx2_mbox *otx2_mbox;
+	struct otx2_mbox_dev *mdev;
+
+	mbox->bbuf_base = devm_kmalloc(&pdev->dev, MBOX_SIZE, GFP_KERNEL);
+	if (!mbox->bbuf_base)
+		return -ENOMEM;
+
+	/* Overwrite mbox mbase to point to bounce buffer, so that PF/VF
+	 * prepare all mbox messages in bounce buffer instead of directly
+	 * in hw mbox memory.
+	 */
+	otx2_mbox = &mbox->mbox;
+	mdev = &otx2_mbox->dev[0];
+	mdev->mbase = mbox->bbuf_base;
+
+	otx2_mbox = &mbox->mbox_up;
+	mdev = &otx2_mbox->dev[0];
+	mdev->mbase = mbox->bbuf_base;
+	return 0;
+}
+
+static inline void otx2_sync_mbox_bbuf(struct otx2_mbox *mbox, int devid)
+{
+	u16 msgs_offset = ALIGN(sizeof(struct mbox_hdr), MBOX_MSG_ALIGN);
+	void *hw_mbase = mbox->hwbase + (devid * MBOX_SIZE);
+	struct otx2_mbox_dev *mdev = &mbox->dev[devid];
+	struct mbox_hdr *hdr;
+	u64 msg_size;
+
+	if (mdev->mbase == hw_mbase)
+		return;
+
+	hdr = hw_mbase + mbox->rx_start;
+	msg_size = hdr->msg_size;
+
+	if (msg_size > mbox->rx_size - msgs_offset)
+		msg_size = mbox->rx_size - msgs_offset;
+
+	/* Copy mbox messages from mbox memory to bounce buffer */
+	memcpy(mdev->mbase + mbox->rx_start,
+	       hw_mbase + mbox->rx_start, msg_size + msgs_offset);
+}
+
+static inline void otx2_mbox_lock_init(struct mbox *mbox)
+{
+	mutex_init(&mbox->lock);
+}
+
+static inline void otx2_mbox_lock(struct mbox *mbox)
+{
+	mutex_lock(&mbox->lock);
+}
+
+static inline void otx2_mbox_unlock(struct mbox *mbox)
+{
+	mutex_unlock(&mbox->lock);
+}
+
+/* Mbox APIs */
+static inline int otx2_sync_mbox_msg(struct mbox *mbox)
+{
+	int err;
+
+	if (!otx2_mbox_nonempty(&mbox->mbox, 0))
+		return 0;
+	otx2_mbox_msg_send(&mbox->mbox, 0);
+	err = otx2_mbox_wait_for_rsp(&mbox->mbox, 0);
+	if (err)
+		return err;
+
+	return otx2_mbox_check_rsp_msgs(&mbox->mbox, 0);
+}
+
+static inline int otx2_sync_mbox_up_msg(struct mbox *mbox, int devid)
+{
+	int err;
+
+	if (!otx2_mbox_nonempty(&mbox->mbox_up, devid))
+		return 0;
+	otx2_mbox_msg_send(&mbox->mbox_up, devid);
+	err = otx2_mbox_wait_for_rsp(&mbox->mbox_up, devid);
+	if (err)
+		return err;
+
+	return otx2_mbox_check_rsp_msgs(&mbox->mbox_up, devid);
+}
+
+/* Use this API to send mbox msgs in atomic context
+ * where sleeping is not allowed
+ */
+static inline int otx2_sync_mbox_msg_busy_poll(struct mbox *mbox)
+{
+	int err;
+
+	if (!otx2_mbox_nonempty(&mbox->mbox, 0))
+		return 0;
+	otx2_mbox_msg_send(&mbox->mbox, 0);
+	err = otx2_mbox_busy_poll_for_rsp(&mbox->mbox, 0);
+	if (err)
+		return err;
+
+	return otx2_mbox_check_rsp_msgs(&mbox->mbox, 0);
+}
+
+#define M(_name, _id, _fn_name, _req_type, _rsp_type)                   \
+static struct _req_type __maybe_unused					\
+*otx2_mbox_alloc_msg_ ## _fn_name(struct mbox *mbox)                    \
+{									\
+	struct _req_type *req;						\
+									\
+	req = (struct _req_type *)otx2_mbox_alloc_msg_rsp(		\
+		&mbox->mbox, 0, sizeof(struct _req_type),		\
+		sizeof(struct _rsp_type));				\
+	if (!req)							\
+		return NULL;						\
+	req->hdr.sig = OTX2_MBOX_REQ_SIG;				\
+	req->hdr.id = _id;						\
+	return req;							\
+}
+
+MBOX_MESSAGES
+#undef M
+
+#define M(_name, _id, _fn_name, _req_type, _rsp_type)			\
+int									\
+otx2_mbox_up_handler_ ## _fn_name(struct otx2_nic *pfvf,		\
+				struct _req_type *req,			\
+				struct _rsp_type *rsp);			\
+
+MBOX_UP_CGX_MESSAGES
+#undef M
+
+#define	RVU_PFVF_PF_SHIFT	10
+#define	RVU_PFVF_PF_MASK	0x3F
+#define	RVU_PFVF_FUNC_SHIFT	0
+#define	RVU_PFVF_FUNC_MASK	0x3FF
+
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index d3af200..e21bc10 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -35,6 +35,322 @@ MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DRV_VERSION);
 MODULE_DEVICE_TABLE(pci, otx2_pf_id_table);
 
+enum {
+	TYPE_PFAF,
+	TYPE_PFVF,
+};
+
+static void otx2_queue_work(struct mbox *mw, struct workqueue_struct *mbox_wq,
+			    int first, int mdevs, u64 intr, int type)
+{
+	struct otx2_mbox_dev *mdev;
+	struct otx2_mbox *mbox;
+	struct mbox_hdr *hdr;
+	int i;
+
+	for (i = first; i < mdevs; i++) {
+		/* start from 0 */
+		if (!(intr & BIT_ULL(i - first)))
+			continue;
+
+		mbox = &mw->mbox;
+		mdev = &mbox->dev[i];
+		if (type == TYPE_PFAF)
+			otx2_sync_mbox_bbuf(mbox, i);
+		hdr = mdev->mbase + mbox->rx_start;
+		/* The hdr->num_msgs is set to zero immediately in the interrupt
+		 * handler to  ensure that it holds a correct value next time
+		 * when the interrupt handler is called.
+		 * pf->mbox.num_msgs holds the data for use in pfaf_mbox_handler
+		 * pf>mbox.up_num_msgs holds the data for use in
+		 * pfaf_mbox_up_handler.
+		 */
+		if (hdr->num_msgs) {
+			mw[i].num_msgs = hdr->num_msgs;
+			hdr->num_msgs = 0;
+			if (type == TYPE_PFAF)
+				memset(mbox->hwbase + mbox->rx_start, 0,
+				       ALIGN(sizeof(struct mbox_hdr),
+					     sizeof(u64)));
+
+			queue_work(mbox_wq, &mw[i].mbox_wrk);
+		}
+
+		mbox = &mw->mbox_up;
+		mdev = &mbox->dev[i];
+		if (type == TYPE_PFAF)
+			otx2_sync_mbox_bbuf(mbox, i);
+		hdr = mdev->mbase + mbox->rx_start;
+		if (hdr->num_msgs) {
+			mw[i].up_num_msgs = hdr->num_msgs;
+			hdr->num_msgs = 0;
+			if (type == TYPE_PFAF)
+				memset(mbox->hwbase + mbox->rx_start, 0,
+				       ALIGN(sizeof(struct mbox_hdr),
+					     sizeof(u64)));
+
+			queue_work(mbox_wq, &mw[i].mbox_up_wrk);
+		}
+	}
+}
+
+static void otx2_process_pfaf_mbox_msg(struct otx2_nic *pf,
+				       struct mbox_msghdr *msg)
+{
+	if (msg->id >= MBOX_MSG_MAX) {
+		dev_err(pf->dev,
+			"Mbox msg with unknown ID 0x%x\n", msg->id);
+		return;
+	}
+
+	if (msg->sig != OTX2_MBOX_RSP_SIG) {
+		dev_err(pf->dev,
+			"Mbox msg with wrong signature %x, ID 0x%x\n",
+			 msg->sig, msg->id);
+		return;
+	}
+
+	switch (msg->id) {
+	case MBOX_MSG_READY:
+		pf->pcifunc = msg->pcifunc;
+		break;
+	default:
+		if (msg->rc)
+			dev_err(pf->dev,
+				"Mbox msg response has err %d, ID 0x%x\n",
+				msg->rc, msg->id);
+		break;
+	}
+}
+
+static void otx2_pfaf_mbox_handler(struct work_struct *work)
+{
+	struct otx2_mbox_dev *mdev;
+	struct mbox_hdr *rsp_hdr;
+	struct mbox_msghdr *msg;
+	struct otx2_mbox *mbox;
+	struct mbox *af_mbox;
+	struct otx2_nic *pf;
+	int offset, id;
+
+	af_mbox = container_of(work, struct mbox, mbox_wrk);
+	mbox = &af_mbox->mbox;
+	mdev = &mbox->dev[0];
+	rsp_hdr = (struct mbox_hdr *)(mdev->mbase + mbox->rx_start);
+
+	offset = mbox->rx_start + ALIGN(sizeof(*rsp_hdr), MBOX_MSG_ALIGN);
+	pf = af_mbox->pfvf;
+
+	for (id = 0; id < af_mbox->num_msgs; id++) {
+		msg = (struct mbox_msghdr *)(mdev->mbase + offset);
+		otx2_process_pfaf_mbox_msg(pf, msg);
+		offset = mbox->rx_start + msg->next_msgoff;
+		mdev->msgs_acked++;
+	}
+
+	otx2_mbox_reset(mbox, 0);
+}
+
+static int otx2_process_mbox_msg_up(struct otx2_nic *pf,
+				    struct mbox_msghdr *req)
+{
+	/* Check if valid, if not reply with a invalid msg */
+	if (req->sig != OTX2_MBOX_REQ_SIG) {
+		otx2_reply_invalid_msg(&pf->mbox.mbox_up, 0, 0, req->id);
+		return -ENODEV;
+	}
+
+	switch (req->id) {
+#define M(_name, _id, _fn_name, _req_type, _rsp_type)			\
+	case _id: {							\
+		struct _rsp_type *rsp;					\
+		int err;						\
+									\
+		rsp = (struct _rsp_type *)otx2_mbox_alloc_msg(		\
+			&pf->mbox.mbox_up, 0,				\
+			sizeof(struct _rsp_type));			\
+		if (!rsp)						\
+			return -ENOMEM;					\
+									\
+		rsp->hdr.id = _id;					\
+		rsp->hdr.sig = OTX2_MBOX_RSP_SIG;			\
+		rsp->hdr.pcifunc = 0;					\
+		rsp->hdr.rc = 0;					\
+									\
+		err = otx2_mbox_up_handler_ ## _fn_name(		\
+			pf, (struct _req_type *)req, rsp);		\
+		return err;						\
+	}
+MBOX_UP_CGX_MESSAGES
+#undef M
+		break;
+	default:
+		otx2_reply_invalid_msg(&pf->mbox.mbox_up, 0, 0, req->id);
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static void otx2_pfaf_mbox_up_handler(struct work_struct *work)
+{
+	struct mbox *af_mbox = container_of(work, struct mbox, mbox_up_wrk);
+	struct otx2_mbox *mbox = &af_mbox->mbox_up;
+	struct otx2_mbox_dev *mdev = &mbox->dev[0];
+	struct otx2_nic *pf = af_mbox->pfvf;
+	int offset, id, devid = 0;
+	struct mbox_hdr *rsp_hdr;
+	struct mbox_msghdr *msg;
+
+	rsp_hdr = (struct mbox_hdr *)(mdev->mbase + mbox->rx_start);
+
+	offset = mbox->rx_start + ALIGN(sizeof(*rsp_hdr), MBOX_MSG_ALIGN);
+
+	for (id = 0; id < af_mbox->up_num_msgs; id++) {
+		msg = (struct mbox_msghdr *)(mdev->mbase + offset);
+
+		devid = msg->pcifunc & RVU_PFVF_FUNC_MASK;
+		/* Skip processing VF's messages */
+		if (!devid)
+			otx2_process_mbox_msg_up(pf, msg);
+		offset = mbox->rx_start + msg->next_msgoff;
+	}
+
+	otx2_mbox_msg_send(mbox, 0);
+}
+
+static irqreturn_t otx2_pfaf_mbox_intr_handler(int irq, void *pf_irq)
+{
+	struct otx2_nic *pf = (struct otx2_nic *)pf_irq;
+	struct mbox *mbox;
+
+	/* Clear the IRQ */
+	otx2_write64(pf, RVU_PF_INT, BIT_ULL(0));
+
+	mbox = &pf->mbox;
+	otx2_queue_work(mbox, pf->mbox_wq, 0, 1, 1, TYPE_PFAF);
+
+	return IRQ_HANDLED;
+}
+
+static void otx2_disable_mbox_intr(struct otx2_nic *pf)
+{
+	int vector = pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_AFPF_MBOX);
+
+	/* Disable AF => PF mailbox IRQ */
+	otx2_write64(pf, RVU_PF_INT_ENA_W1C, BIT_ULL(0));
+	free_irq(vector, pf);
+}
+
+static int otx2_register_mbox_intr(struct otx2_nic *pf, bool probe_af)
+{
+	struct otx2_hw *hw = &pf->hw;
+	struct msg_req *req;
+	char *irq_name;
+	int err;
+
+	/* Register mailbox interrupt handler */
+	irq_name = &hw->irq_name[RVU_PF_INT_VEC_AFPF_MBOX * NAME_SIZE];
+	snprintf(irq_name, NAME_SIZE, "RVUPFAF Mbox");
+	err = request_irq(pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_AFPF_MBOX),
+			  otx2_pfaf_mbox_intr_handler, 0, irq_name, pf);
+	if (err) {
+		dev_err(pf->dev,
+			"RVUPF: IRQ registration failed for PFAF mbox irq\n");
+		return err;
+	}
+
+	/* Enable mailbox interrupt for msgs coming from AF.
+	 * First clear to avoid spurious interrupts, if any.
+	 */
+	otx2_write64(pf, RVU_PF_INT, BIT_ULL(0));
+	otx2_write64(pf, RVU_PF_INT_ENA_W1S, BIT_ULL(0));
+
+	if (!probe_af)
+		return 0;
+
+	/* Check mailbox communication with AF */
+	req = otx2_mbox_alloc_msg_ready(&pf->mbox);
+	if (!req) {
+		otx2_disable_mbox_intr(pf);
+		return -ENOMEM;
+	}
+	err = otx2_sync_mbox_msg(&pf->mbox);
+	if (err) {
+		dev_warn(pf->dev,
+			 "AF not responding to mailbox, deferring probe\n");
+		otx2_disable_mbox_intr(pf);
+		return -EPROBE_DEFER;
+	}
+
+	return 0;
+}
+
+static void otx2_pfaf_mbox_destroy(struct otx2_nic *pf)
+{
+	struct mbox *mbox = &pf->mbox;
+
+	if (pf->mbox_wq) {
+		flush_workqueue(pf->mbox_wq);
+		destroy_workqueue(pf->mbox_wq);
+		pf->mbox_wq = NULL;
+	}
+
+	if (mbox->mbox.hwbase)
+		iounmap((void __iomem *)mbox->mbox.hwbase);
+
+	otx2_mbox_destroy(&mbox->mbox);
+	otx2_mbox_destroy(&mbox->mbox_up);
+}
+
+static int otx2_pfaf_mbox_init(struct otx2_nic *pf)
+{
+	struct mbox *mbox = &pf->mbox;
+	void __iomem *hwbase;
+	int err;
+
+	mbox->pfvf = pf;
+	pf->mbox_wq = alloc_workqueue("otx2_pfaf_mailbox",
+				      WQ_UNBOUND | WQ_HIGHPRI |
+				      WQ_MEM_RECLAIM, 1);
+	if (!pf->mbox_wq)
+		return -ENOMEM;
+
+	/* Mailbox is a reserved memory (in RAM) region shared between
+	 * admin function (i.e AF) and this PF, shouldn't be mapped as
+	 * device memory to allow unaligned accesses.
+	 */
+	hwbase = ioremap_wc(pci_resource_start(pf->pdev, PCI_MBOX_BAR_NUM),
+			    pci_resource_len(pf->pdev, PCI_MBOX_BAR_NUM));
+	if (!hwbase) {
+		dev_err(pf->dev, "Unable to map PFAF mailbox region\n");
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	err = otx2_mbox_init(&mbox->mbox, hwbase, pf->pdev, pf->reg_base,
+			     MBOX_DIR_PFAF, 1);
+	if (err)
+		goto exit;
+
+	err = otx2_mbox_init(&mbox->mbox_up, hwbase, pf->pdev, pf->reg_base,
+			     MBOX_DIR_PFAF_UP, 1);
+	if (err)
+		goto exit;
+
+	err = otx2_mbox_bbuf_init(mbox, pf->pdev);
+	if (err)
+		goto exit;
+
+	INIT_WORK(&mbox->mbox_wrk, otx2_pfaf_mbox_handler);
+	INIT_WORK(&mbox->mbox_up_wrk, otx2_pfaf_mbox_up_handler);
+	otx2_mbox_lock_init(&pf->mbox);
+
+	return 0;
+exit:
+	otx2_pfaf_mbox_destroy(pf);
+	return err;
+}
+
 static int otx2_set_real_num_queues(struct net_device *netdev,
 				    int tx_queues, int rx_queues)
 {
@@ -96,6 +412,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct otx2_nic *pf;
 	struct otx2_hw *hw;
 	int err, qcount;
+	int num_vec;
 
 	err = pcim_enable_device(pdev);
 	if (err) {
@@ -139,6 +456,17 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hw->tx_queues = qcount;
 	hw->max_queues = qcount;
 
+	num_vec = pci_msix_vec_count(pdev);
+	hw->irq_name = devm_kmalloc_array(&hw->pdev->dev, num_vec, NAME_SIZE,
+					  GFP_KERNEL);
+	if (!hw->irq_name)
+		goto err_free_netdev;
+
+	hw->affinity_mask = devm_kcalloc(&hw->pdev->dev, num_vec,
+					 sizeof(cpumask_var_t), GFP_KERNEL);
+	if (!hw->affinity_mask)
+		goto err_free_netdev;
+
 	/* Map CSRs */
 	pf->reg_base = pcim_iomap(pdev, PCI_CFG_REG_BAR_NUM, 0);
 	if (!pf->reg_base) {
@@ -151,20 +479,44 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_free_netdev;
 
+	err = pci_alloc_irq_vectors(hw->pdev, RVU_PF_INT_VEC_CNT,
+				    RVU_PF_INT_VEC_CNT, PCI_IRQ_MSIX);
+	if (err < 0) {
+		dev_err(dev, "%s: Failed to alloc %d IRQ vectors\n",
+			__func__, num_vec);
+		goto err_free_netdev;
+	}
+
+	/* Init PF <=> AF mailbox stuff */
+	err = otx2_pfaf_mbox_init(pf);
+	if (err)
+		goto err_free_irq_vectors;
+
+	/* Register mailbox interrupt */
+	err = otx2_register_mbox_intr(pf, true);
+	if (err)
+		goto err_mbox_destroy;
+
 	err = otx2_set_real_num_queues(netdev, hw->tx_queues, hw->rx_queues);
 	if (err)
-		goto err_free_netdev;
+		goto err_disable_mbox_intr;
 
 	netdev->netdev_ops = &otx2_netdev_ops;
 
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(dev, "Failed to register netdevice\n");
-		goto err_free_netdev;
+		goto err_disable_mbox_intr;
 	}
 
 	return 0;
 
+err_disable_mbox_intr:
+	otx2_disable_mbox_intr(pf);
+err_mbox_destroy:
+	otx2_pfaf_mbox_destroy(pf);
+err_free_irq_vectors:
+	pci_free_irq_vectors(hw->pdev);
 err_free_netdev:
 	pci_set_drvdata(pdev, NULL);
 	free_netdev(netdev);
@@ -184,9 +536,12 @@ static void otx2_remove(struct pci_dev *pdev)
 	pf = netdev_priv(netdev);
 
 	unregister_netdev(netdev);
+	otx2_disable_mbox_intr(pf);
+	otx2_pfaf_mbox_destroy(pf);
 	pci_free_irq_vectors(pf->pdev);
 	pci_set_drvdata(pdev, NULL);
 	free_netdev(netdev);
+
 	pci_release_regions(pdev);
 }
 
-- 
2.7.4

