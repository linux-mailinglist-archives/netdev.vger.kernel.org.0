Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1B26A8CC2
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 00:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjCBXP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 18:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjCBXPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 18:15:55 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A928580F6
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 15:15:53 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id m18-20020a17090a7f9200b002375a3cbc9bso286039pjl.9
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 15:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oebqMv4GM4Nz+vLWUOZbs38nKYzSza6yhLjASyIi2dE=;
        b=nHnQuwpIav0sZeWxiZvqzzvLXotDq5vx1WiX1obtpYlZSRHmaxWAhr8fw7gpjHlH3W
         Bq6Eer5h5RhNuM7IApgsPy6YxfF5ECm9uTB4pny1xTTXrNbH5PZjHdpkQyBryXuddfum
         BXM2L9km1ir2V3BPzckUzmryRt6uiqVkN00rpoJRP5wOU7jjcOijQPHyhg+S+mDOaveX
         vkbJAYJtooh5FVEpInx7tOsC+tx/EkD1NyE1QTvDxWxdl+R8EE4MMgatSIdWsjmi7VUz
         n2XuLJHUIuSuMYZReQYmTQO39YbFGA6IRgA1iljOw1V0gkWwGOW3cII/3leHkQ+9gm3f
         M/Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oebqMv4GM4Nz+vLWUOZbs38nKYzSza6yhLjASyIi2dE=;
        b=CqGSPR2N0FvYGl8iU6niCAvbEEo4mxne5p13fPUrsie3UPyVSFD+u+NwhQXAf2fjR/
         Guux9u826ogFZ9VN7vbhd194puo/10MDjgNBDh60avRdmck5mF84BRbZ2+23yIgF3PQn
         YfDHKpCyhuJubver52h8kdC22En/EKOQ5RsW/S0rDs+8eEPIvhDya7Q6ufgSQtHjvO0c
         yLi3lai3QVmpjlLxmcw9e83CIkHuJT1D9OeNiWfVa32dJU/Q5W4vXQLnKACsEpY3QR/4
         U0wamq4Zl2vV4zkiOr7aHA+G1ChzIb3oE2y9VdRnv61V5u+/2o6BzPpVSRS5LPu3wmwz
         1OVA==
X-Gm-Message-State: AO0yUKXE1ppsCLNtpIrn2c8XEdevVjG3F/F1hTGzUvmotlKeXTFJ8dyX
        lqxN1Igp+ijYd+S/0HnUfE7vnMytZGBmEQ==
X-Google-Smtp-Source: AK7set+sBDFoAxt9w05ySeS8K+2rDr8hC69eGdSqWz4TqLrKymQfOwJNzAftwNdsbx7wqsoSffFTqJ2PJc9WyA==
X-Received: from mmandlik-cloudtop.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:2893])
 (user=mmandlik job=sendgmr) by 2002:a17:903:449:b0:19a:87dd:9206 with SMTP id
 iw9-20020a170903044900b0019a87dd9206mr18646plb.0.1677798952662; Thu, 02 Mar
 2023 15:15:52 -0800 (PST)
Date:   Thu,  2 Mar 2023 15:15:44 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230302151413.v7.1.I9b4e4818bab450657b19cda3497d363c9baa616e@changeid>
Subject: [PATCH v7 1/4] Bluetooth: Add support for hci devcoredump
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Manish Mandlik <mmandlik@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

Add devcoredump APIs to hci core so that drivers only have to provide
the dump skbs instead of managing the synchronization and timeouts.

The devcoredump APIs should be used in the following manner:
 - hci_devcoredump_init is called to allocate the dump.
 - hci_devcoredump_append is called to append any skbs with dump data
   OR hci_devcoredump_append_pattern is called to insert a pattern.
 - hci_devcoredump_complete is called when all dump packets have been
   sent OR hci_devcoredump_abort is called to indicate an error and
   cancel an ongoing dump collection.

The high level APIs just prepare some skbs with the appropriate data and
queue it for the dump to process. Packets part of the crashdump can be
intercepted in the driver in interrupt context and forwarded directly to
the devcoredump APIs.

Internally, there are 5 states for the dump: idle, active, complete,
abort and timeout. A devcoredump will only be in active state after it
has been initialized. Once active, it accepts data to be appended,
patterns to be inserted (i.e. memset) and a completion event or an abort
event to generate a devcoredump. The timeout is initialized at the same
time the dump is initialized (defaulting to 10s) and will be cleared
either when the timeout occurs or the dump is complete or aborted.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Manish Mandlik <mmandlik@google.com>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

(no changes since v6)

Changes in v6:
- Remove #ifdef from .c and move to function in .h as per suggestion
- Remove coredump_enabled from hci_devcoredump struct since the sysfs
  flag related change has been abandoned

Changes in v4:
- Add .enabled() and .coredump() to hci_devcoredump struct

Changes in v3:
- Add attribute to enable/disable and set default state to disabled

Changes in v2:
- Move hci devcoredump implementation to new files
- Move dump queue and dump work to hci_devcoredump struct
- Add CONFIG_DEV_COREDUMP conditional compile

 include/net/bluetooth/coredump.h | 114 +++++++
 include/net/bluetooth/hci_core.h |  14 +
 net/bluetooth/Makefile           |   2 +
 net/bluetooth/coredump.c         | 515 +++++++++++++++++++++++++++++++
 net/bluetooth/hci_core.c         |   1 +
 net/bluetooth/hci_sync.c         |   2 +
 6 files changed, 648 insertions(+)
 create mode 100644 include/net/bluetooth/coredump.h
 create mode 100644 net/bluetooth/coredump.c

diff --git a/include/net/bluetooth/coredump.h b/include/net/bluetooth/coredump.h
new file mode 100644
index 000000000000..5da253527cfe
--- /dev/null
+++ b/include/net/bluetooth/coredump.h
@@ -0,0 +1,114 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2022 Google Corporation
+ */
+
+#ifndef __COREDUMP_H
+#define __COREDUMP_H
+
+#define DEVCOREDUMP_TIMEOUT	msecs_to_jiffies(10000)	/* 10 sec */
+
+typedef void (*coredump_t)(struct hci_dev *hdev);
+typedef int  (*dmp_hdr_t)(struct hci_dev *hdev, char *buf, size_t size);
+typedef void (*notify_change_t)(struct hci_dev *hdev, int state);
+
+/* struct hci_devcoredump - Devcoredump state
+ *
+ * @supported: Indicates if FW dump collection is supported by driver
+ * @state: Current state of dump collection
+ * @alloc_size: Total size of the dump
+ * @head: Start of the dump
+ * @tail: Pointer to current end of dump
+ * @end: head + alloc_size for easy comparisons
+ *
+ * @dump_q: Dump queue for state machine to process
+ * @dump_rx: Devcoredump state machine work
+ * @dump_timeout: Devcoredump timeout work
+ *
+ * @coredump: Called from the driver's .coredump() function.
+ * @dmp_hdr: Create a dump header to identify controller/fw/driver info
+ * @notify_change: Notify driver when devcoredump state has changed
+ */
+struct hci_devcoredump {
+	bool		supported;
+
+	enum devcoredump_state {
+		HCI_DEVCOREDUMP_IDLE,
+		HCI_DEVCOREDUMP_ACTIVE,
+		HCI_DEVCOREDUMP_DONE,
+		HCI_DEVCOREDUMP_ABORT,
+		HCI_DEVCOREDUMP_TIMEOUT
+	} state;
+
+	size_t		alloc_size;
+	char		*head;
+	char		*tail;
+	char		*end;
+
+	struct sk_buff_head	dump_q;
+	struct work_struct	dump_rx;
+	struct delayed_work	dump_timeout;
+
+	coredump_t		coredump;
+	dmp_hdr_t		dmp_hdr;
+	notify_change_t		notify_change;
+};
+
+#ifdef CONFIG_DEV_COREDUMP
+
+void hci_devcoredump_reset(struct hci_dev *hdev);
+void hci_devcoredump_rx(struct work_struct *work);
+void hci_devcoredump_timeout(struct work_struct *work);
+
+int hci_devcoredump_register(struct hci_dev *hdev, coredump_t coredump,
+			     dmp_hdr_t dmp_hdr, notify_change_t notify_change);
+int hci_devcoredump_init(struct hci_dev *hdev, u32 dmp_size);
+int hci_devcoredump_append(struct hci_dev *hdev, struct sk_buff *skb);
+int hci_devcoredump_append_pattern(struct hci_dev *hdev, u8 pattern, u32 len);
+int hci_devcoredump_complete(struct hci_dev *hdev);
+int hci_devcoredump_abort(struct hci_dev *hdev);
+
+#else
+
+static inline void hci_devcoredump_reset(struct hci_dev *hdev) {}
+static inline void hci_devcoredump_rx(struct work_struct *work) {}
+static inline void hci_devcoredump_timeout(struct work_struct *work) {}
+
+static inline int hci_devcoredump_register(struct hci_dev *hdev,
+					   coredump_t coredump,
+					   dmp_hdr_t dmp_hdr,
+					   notify_change_t notify_change)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int hci_devcoredump_init(struct hci_dev *hdev, u32 dmp_size)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int hci_devcoredump_append(struct hci_dev *hdev,
+					 struct sk_buff *skb)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int hci_devcoredump_append_pattern(struct hci_dev *hdev,
+						 u8 pattern, u32 len)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int hci_devcoredump_complete(struct hci_dev *hdev)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int hci_devcoredump_abort(struct hci_dev *hdev)
+{
+	return -EOPNOTSUPP;
+}
+
+#endif /* CONFIG_DEV_COREDUMP */
+
+#endif /* __COREDUMP_H */
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 9488671c1219..e405fd4d25db 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -32,6 +32,7 @@
 #include <net/bluetooth/hci.h>
 #include <net/bluetooth/hci_sync.h>
 #include <net/bluetooth/hci_sock.h>
+#include <net/bluetooth/coredump.h>
 
 /* HCI priority */
 #define HCI_PRIO_MAX	7
@@ -590,6 +591,10 @@ struct hci_dev {
 	const char		*fw_info;
 	struct dentry		*debugfs;
 
+#ifdef CONFIG_DEV_COREDUMP
+	struct hci_devcoredump	dump;
+#endif
+
 	struct device		dev;
 
 	struct rfkill		*rfkill;
@@ -1496,6 +1501,15 @@ static inline void hci_set_aosp_capable(struct hci_dev *hdev)
 #endif
 }
 
+static inline void hci_devcoredump_setup(struct hci_dev *hdev)
+{
+#ifdef CONFIG_DEV_COREDUMP
+	INIT_WORK(&hdev->dump.dump_rx, hci_devcoredump_rx);
+	INIT_DELAYED_WORK(&hdev->dump.dump_timeout, hci_devcoredump_timeout);
+	skb_queue_head_init(&hdev->dump.dump_q);
+#endif
+}
+
 int hci_dev_open(__u16 dev);
 int hci_dev_close(__u16 dev);
 int hci_dev_do_close(struct hci_dev *hdev);
diff --git a/net/bluetooth/Makefile b/net/bluetooth/Makefile
index 0e7b7db42750..141ac1fda0bf 100644
--- a/net/bluetooth/Makefile
+++ b/net/bluetooth/Makefile
@@ -17,6 +17,8 @@ bluetooth-y := af_bluetooth.o hci_core.o hci_conn.o hci_event.o mgmt.o \
 	ecdh_helper.o hci_request.o mgmt_util.o mgmt_config.o hci_codec.o \
 	eir.o hci_sync.o
 
+bluetooth-$(CONFIG_DEV_COREDUMP) += coredump.o
+
 bluetooth-$(CONFIG_BT_BREDR) += sco.o
 bluetooth-$(CONFIG_BT_LE) += iso.o
 bluetooth-$(CONFIG_BT_HS) += a2mp.o amp.o
diff --git a/net/bluetooth/coredump.c b/net/bluetooth/coredump.c
new file mode 100644
index 000000000000..ce9e36f77323
--- /dev/null
+++ b/net/bluetooth/coredump.c
@@ -0,0 +1,515 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2022 Google Corporation
+ */
+
+#include <linux/devcoredump.h>
+
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci_core.h>
+
+enum hci_devcoredump_pkt_type {
+	HCI_DEVCOREDUMP_PKT_INIT,
+	HCI_DEVCOREDUMP_PKT_SKB,
+	HCI_DEVCOREDUMP_PKT_PATTERN,
+	HCI_DEVCOREDUMP_PKT_COMPLETE,
+	HCI_DEVCOREDUMP_PKT_ABORT,
+};
+
+struct hci_devcoredump_skb_cb {
+	u16 pkt_type;
+};
+
+struct hci_devcoredump_skb_pattern {
+	u8 pattern;
+	u32 len;
+} __packed;
+
+#define hci_dmp_cb(skb)	((struct hci_devcoredump_skb_cb *)((skb)->cb))
+
+#define MAX_DEVCOREDUMP_HDR_SIZE	512	/* bytes */
+
+static int hci_devcoredump_update_hdr_state(char *buf, size_t size, int state)
+{
+	if (!buf)
+		return 0;
+
+	return snprintf(buf, size, "Bluetooth devcoredump\nState: %d\n", state);
+}
+
+/* Call with hci_dev_lock only. */
+static int hci_devcoredump_update_state(struct hci_dev *hdev, int state)
+{
+	hdev->dump.state = state;
+
+	return hci_devcoredump_update_hdr_state(hdev->dump.head,
+						hdev->dump.alloc_size, state);
+}
+
+static int hci_devcoredump_mkheader(struct hci_dev *hdev, char *buf,
+				    size_t buf_size)
+{
+	char *ptr = buf;
+	size_t rem = buf_size;
+	size_t read = 0;
+
+	read = hci_devcoredump_update_hdr_state(ptr, rem, HCI_DEVCOREDUMP_IDLE);
+	read += 1; /* update_hdr_state adds \0 at the end upon state rewrite */
+	rem -= read;
+	ptr += read;
+
+	if (hdev->dump.dmp_hdr) {
+		/* dmp_hdr() should return number of bytes written */
+		read = hdev->dump.dmp_hdr(hdev, ptr, rem);
+		rem -= read;
+		ptr += read;
+	}
+
+	read = snprintf(ptr, rem, "--- Start dump ---\n");
+	rem -= read;
+	ptr += read;
+
+	return buf_size - rem;
+}
+
+/* Do not call with hci_dev_lock since this calls driver code. */
+static void hci_devcoredump_notify(struct hci_dev *hdev, int state)
+{
+	if (hdev->dump.notify_change)
+		hdev->dump.notify_change(hdev, state);
+}
+
+/* Call with hci_dev_lock only. */
+void hci_devcoredump_reset(struct hci_dev *hdev)
+{
+	hdev->dump.head = NULL;
+	hdev->dump.tail = NULL;
+	hdev->dump.alloc_size = 0;
+
+	hci_devcoredump_update_state(hdev, HCI_DEVCOREDUMP_IDLE);
+
+	cancel_delayed_work(&hdev->dump.dump_timeout);
+	skb_queue_purge(&hdev->dump.dump_q);
+}
+
+/* Call with hci_dev_lock only. */
+static void hci_devcoredump_free(struct hci_dev *hdev)
+{
+	if (hdev->dump.head)
+		vfree(hdev->dump.head);
+
+	hci_devcoredump_reset(hdev);
+}
+
+/* Call with hci_dev_lock only. */
+static int hci_devcoredump_alloc(struct hci_dev *hdev, u32 size)
+{
+	hdev->dump.head = vmalloc(size);
+	if (!hdev->dump.head)
+		return -ENOMEM;
+
+	hdev->dump.alloc_size = size;
+	hdev->dump.tail = hdev->dump.head;
+	hdev->dump.end = hdev->dump.head + size;
+
+	hci_devcoredump_update_state(hdev, HCI_DEVCOREDUMP_IDLE);
+
+	return 0;
+}
+
+/* Call with hci_dev_lock only. */
+static bool hci_devcoredump_copy(struct hci_dev *hdev, char *buf, u32 size)
+{
+	if (hdev->dump.tail + size > hdev->dump.end)
+		return false;
+
+	memcpy(hdev->dump.tail, buf, size);
+	hdev->dump.tail += size;
+
+	return true;
+}
+
+/* Call with hci_dev_lock only. */
+static bool hci_devcoredump_memset(struct hci_dev *hdev, u8 pattern, u32 len)
+{
+	if (hdev->dump.tail + len > hdev->dump.end)
+		return false;
+
+	memset(hdev->dump.tail, pattern, len);
+	hdev->dump.tail += len;
+
+	return true;
+}
+
+/* Call with hci_dev_lock only. */
+static int hci_devcoredump_prepare(struct hci_dev *hdev, u32 dump_size)
+{
+	char *dump_hdr;
+	int dump_hdr_size;
+	u32 size;
+	int err = 0;
+
+	dump_hdr = vmalloc(MAX_DEVCOREDUMP_HDR_SIZE);
+	if (!dump_hdr) {
+		err = -ENOMEM;
+		goto hdr_free;
+	}
+
+	dump_hdr_size = hci_devcoredump_mkheader(hdev, dump_hdr,
+						 MAX_DEVCOREDUMP_HDR_SIZE);
+	size = dump_hdr_size + dump_size;
+
+	if (hci_devcoredump_alloc(hdev, size)) {
+		err = -ENOMEM;
+		goto hdr_free;
+	}
+
+	/* Insert the device header */
+	if (!hci_devcoredump_copy(hdev, dump_hdr, dump_hdr_size)) {
+		bt_dev_err(hdev, "Failed to insert header");
+		hci_devcoredump_free(hdev);
+
+		err = -ENOMEM;
+		goto hdr_free;
+	}
+
+hdr_free:
+	if (dump_hdr)
+		vfree(dump_hdr);
+
+	return err;
+}
+
+/* Bluetooth devcoredump state machine.
+ *
+ * Devcoredump states:
+ *
+ *      HCI_DEVCOREDUMP_IDLE: The default state.
+ *
+ *      HCI_DEVCOREDUMP_ACTIVE: A devcoredump will be in this state once it has
+ *              been initialized using hci_devcoredump_init(). Once active, the
+ *              driver can append data using hci_devcoredump_append() or insert
+ *              a pattern using hci_devcoredump_append_pattern().
+ *
+ *      HCI_DEVCOREDUMP_DONE: Once the dump collection is complete, the drive
+ *              can signal the completion using hci_devcoredump_complete(). A
+ *              devcoredump is generated indicating the completion event and
+ *              then the state machine is reset to the default state.
+ *
+ *      HCI_DEVCOREDUMP_ABORT: The driver can cancel ongoing dump collection in
+ *              case of any error using hci_devcoredump_abort(). A devcoredump
+ *              is still generated with the available data indicating the abort
+ *              event and then the state machine is reset to the default state.
+ *
+ *      HCI_DEVCOREDUMP_TIMEOUT: A timeout timer for HCI_DEVCOREDUMP_TIMEOUT sec
+ *              is started during devcoredump initialization. Once the timeout
+ *              occurs, the driver is notified, a devcoredump is generated with
+ *              the available data indicating the timeout event and then the
+ *              state machine is reset to the default state.
+ *
+ * The driver must register using hci_devcoredump_register() before using the
+ * hci devcoredump APIs.
+ */
+void hci_devcoredump_rx(struct work_struct *work)
+{
+	struct hci_dev *hdev = container_of(work, struct hci_dev, dump.dump_rx);
+	struct sk_buff *skb;
+	struct hci_devcoredump_skb_pattern *pattern;
+	u32 dump_size;
+	int start_state;
+
+#define DBG_UNEXPECTED_STATE() \
+		bt_dev_dbg(hdev, \
+			   "Unexpected packet (%d) for state (%d). ", \
+			   hci_dmp_cb(skb)->pkt_type, hdev->dump.state)
+
+	while ((skb = skb_dequeue(&hdev->dump.dump_q))) {
+		hci_dev_lock(hdev);
+		start_state = hdev->dump.state;
+
+		switch (hci_dmp_cb(skb)->pkt_type) {
+		case HCI_DEVCOREDUMP_PKT_INIT:
+			if (hdev->dump.state != HCI_DEVCOREDUMP_IDLE) {
+				DBG_UNEXPECTED_STATE();
+				goto loop_continue;
+			}
+
+			if (skb->len != sizeof(dump_size)) {
+				bt_dev_dbg(hdev, "Invalid dump init pkt");
+				goto loop_continue;
+			}
+
+			dump_size = *((u32 *)skb->data);
+			if (!dump_size) {
+				bt_dev_err(hdev, "Zero size dump init pkt");
+				goto loop_continue;
+			}
+
+			if (hci_devcoredump_prepare(hdev, dump_size)) {
+				bt_dev_err(hdev, "Failed to prepare for dump");
+				goto loop_continue;
+			}
+
+			hci_devcoredump_update_state(hdev,
+						     HCI_DEVCOREDUMP_ACTIVE);
+			queue_delayed_work(hdev->workqueue,
+					   &hdev->dump.dump_timeout,
+					   DEVCOREDUMP_TIMEOUT);
+			break;
+
+		case HCI_DEVCOREDUMP_PKT_SKB:
+			if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
+				DBG_UNEXPECTED_STATE();
+				goto loop_continue;
+			}
+
+			if (!hci_devcoredump_copy(hdev, skb->data, skb->len))
+				bt_dev_dbg(hdev, "Failed to insert skb");
+			break;
+
+		case HCI_DEVCOREDUMP_PKT_PATTERN:
+			if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
+				DBG_UNEXPECTED_STATE();
+				goto loop_continue;
+			}
+
+			if (skb->len != sizeof(*pattern)) {
+				bt_dev_dbg(hdev, "Invalid pattern skb");
+				goto loop_continue;
+			}
+
+			pattern = (void *)skb->data;
+
+			if (!hci_devcoredump_memset(hdev, pattern->pattern,
+						    pattern->len))
+				bt_dev_dbg(hdev, "Failed to set pattern");
+			break;
+
+		case HCI_DEVCOREDUMP_PKT_COMPLETE:
+			if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
+				DBG_UNEXPECTED_STATE();
+				goto loop_continue;
+			}
+
+			hci_devcoredump_update_state(hdev,
+						     HCI_DEVCOREDUMP_DONE);
+			dump_size = hdev->dump.tail - hdev->dump.head;
+
+			bt_dev_info(hdev,
+				    "Devcoredump complete with size %u "
+				    "(expect %zu)",
+				    dump_size, hdev->dump.alloc_size);
+
+			dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size,
+				      GFP_KERNEL);
+			break;
+
+		case HCI_DEVCOREDUMP_PKT_ABORT:
+			if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
+				DBG_UNEXPECTED_STATE();
+				goto loop_continue;
+			}
+
+			hci_devcoredump_update_state(hdev,
+						     HCI_DEVCOREDUMP_ABORT);
+			dump_size = hdev->dump.tail - hdev->dump.head;
+
+			bt_dev_info(hdev,
+				    "Devcoredump aborted with size %u "
+				    "(expect %zu)",
+				    dump_size, hdev->dump.alloc_size);
+
+			/* Emit a devcoredump with the available data */
+			dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size,
+				      GFP_KERNEL);
+			break;
+
+		default:
+			bt_dev_dbg(hdev,
+				   "Unknown packet (%d) for state (%d). ",
+				   hci_dmp_cb(skb)->pkt_type, hdev->dump.state);
+			break;
+		}
+
+loop_continue:
+		kfree_skb(skb);
+		hci_dev_unlock(hdev);
+
+		if (start_state != hdev->dump.state)
+			hci_devcoredump_notify(hdev, hdev->dump.state);
+
+		hci_dev_lock(hdev);
+		if (hdev->dump.state == HCI_DEVCOREDUMP_DONE ||
+		    hdev->dump.state == HCI_DEVCOREDUMP_ABORT)
+			hci_devcoredump_reset(hdev);
+		hci_dev_unlock(hdev);
+	}
+}
+EXPORT_SYMBOL(hci_devcoredump_rx);
+
+void hci_devcoredump_timeout(struct work_struct *work)
+{
+	struct hci_dev *hdev = container_of(work, struct hci_dev,
+					    dump.dump_timeout.work);
+	u32 dump_size;
+
+	hci_devcoredump_notify(hdev, HCI_DEVCOREDUMP_TIMEOUT);
+
+	hci_dev_lock(hdev);
+
+	cancel_work_sync(&hdev->dump.dump_rx);
+
+	hci_devcoredump_update_state(hdev, HCI_DEVCOREDUMP_TIMEOUT);
+	dump_size = hdev->dump.tail - hdev->dump.head;
+	bt_dev_info(hdev, "Devcoredump timeout with size %u (expect %zu)",
+		    dump_size, hdev->dump.alloc_size);
+
+	/* Emit a devcoredump with the available data */
+	dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size, GFP_KERNEL);
+
+	hci_devcoredump_reset(hdev);
+
+	hci_dev_unlock(hdev);
+}
+EXPORT_SYMBOL(hci_devcoredump_timeout);
+
+int hci_devcoredump_register(struct hci_dev *hdev, coredump_t coredump,
+			     dmp_hdr_t dmp_hdr, notify_change_t notify_change)
+{
+	/* Driver must implement coredump() and dmp_hdr() functions for
+	 * bluetooth devcoredump. The coredump() should trigger a coredump
+	 * event on the controller when the device's coredump sysfs entry is
+	 * written to. The dmp_hdr() should create a dump header to identify
+	 * the controller/fw/driver info.
+	 */
+	if (!coredump || !dmp_hdr)
+		return -EINVAL;
+
+	hci_dev_lock(hdev);
+	hdev->dump.coredump = coredump;
+	hdev->dump.dmp_hdr = dmp_hdr;
+	hdev->dump.notify_change = notify_change;
+	hdev->dump.supported = true;
+	hci_dev_unlock(hdev);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcoredump_register);
+
+static inline bool hci_devcoredump_enabled(struct hci_dev *hdev)
+{
+	return hdev->dump.supported;
+}
+
+int hci_devcoredump_init(struct hci_dev *hdev, u32 dmp_size)
+{
+	struct sk_buff *skb = NULL;
+
+	if (!hci_devcoredump_enabled(hdev))
+		return -EOPNOTSUPP;
+
+	skb = alloc_skb(sizeof(dmp_size), GFP_ATOMIC);
+	if (!skb) {
+		bt_dev_err(hdev, "Failed to allocate devcoredump init");
+		return -ENOMEM;
+	}
+
+	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_INIT;
+	skb_put_data(skb, &dmp_size, sizeof(dmp_size));
+
+	skb_queue_tail(&hdev->dump.dump_q, skb);
+	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcoredump_init);
+
+int hci_devcoredump_append(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	if (!skb)
+		return -ENOMEM;
+
+	if (!hci_devcoredump_enabled(hdev)) {
+		kfree_skb(skb);
+		return -EOPNOTSUPP;
+	}
+
+	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_SKB;
+
+	skb_queue_tail(&hdev->dump.dump_q, skb);
+	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcoredump_append);
+
+int hci_devcoredump_append_pattern(struct hci_dev *hdev, u8 pattern, u32 len)
+{
+	struct hci_devcoredump_skb_pattern p;
+	struct sk_buff *skb = NULL;
+
+	if (!hci_devcoredump_enabled(hdev))
+		return -EOPNOTSUPP;
+
+	skb = alloc_skb(sizeof(p), GFP_ATOMIC);
+	if (!skb) {
+		bt_dev_err(hdev, "Failed to allocate devcoredump pattern");
+		return -ENOMEM;
+	}
+
+	p.pattern = pattern;
+	p.len = len;
+
+	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_PATTERN;
+	skb_put_data(skb, &p, sizeof(p));
+
+	skb_queue_tail(&hdev->dump.dump_q, skb);
+	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcoredump_append_pattern);
+
+int hci_devcoredump_complete(struct hci_dev *hdev)
+{
+	struct sk_buff *skb = NULL;
+
+	if (!hci_devcoredump_enabled(hdev))
+		return -EOPNOTSUPP;
+
+	skb = alloc_skb(0, GFP_ATOMIC);
+	if (!skb) {
+		bt_dev_err(hdev, "Failed to allocate devcoredump complete");
+		return -ENOMEM;
+	}
+
+	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_COMPLETE;
+
+	skb_queue_tail(&hdev->dump.dump_q, skb);
+	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcoredump_complete);
+
+int hci_devcoredump_abort(struct hci_dev *hdev)
+{
+	struct sk_buff *skb = NULL;
+
+	if (!hci_devcoredump_enabled(hdev))
+		return -EOPNOTSUPP;
+
+	skb = alloc_skb(0, GFP_ATOMIC);
+	if (!skb) {
+		bt_dev_err(hdev, "Failed to allocate devcoredump abort");
+		return -ENOMEM;
+	}
+
+	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_ABORT;
+
+	skb_queue_tail(&hdev->dump.dump_q, skb);
+	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcoredump_abort);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 334e308451f5..37aa70192ccb 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2544,6 +2544,7 @@ struct hci_dev *hci_alloc_dev_priv(int sizeof_priv)
 	INIT_DELAYED_WORK(&hdev->cmd_timer, hci_cmd_timeout);
 	INIT_DELAYED_WORK(&hdev->ncmd_timer, hci_ncmd_timeout);
 
+	hci_devcoredump_setup(hdev);
 	hci_request_setup(hdev);
 
 	hci_init_sysfs(hdev);
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 561a519a11bd..e0423867ff19 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4722,6 +4722,8 @@ int hci_dev_open_sync(struct hci_dev *hdev)
 		goto done;
 	}
 
+	hci_devcoredump_reset(hdev);
+
 	set_bit(HCI_RUNNING, &hdev->flags);
 	hci_sock_dev_event(hdev, HCI_DEV_OPEN);
 
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

