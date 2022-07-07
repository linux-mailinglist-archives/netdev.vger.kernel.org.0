Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F1356AE2D
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 00:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236751AbiGGWPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 18:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236726AbiGGWPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 18:15:33 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5335C964
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 15:15:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u17-20020a258411000000b0066dfb22644eso13108469ybk.6
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 15:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Qo9mgLecrXCNDIXJiVYm+FhlZCagK4jOK5c/AYuo8h8=;
        b=FegujYy2kQAyegt/TngbyeIEeIJqZ2LqYA5msVJ83A+2KQC2TxVTNXzEgP6Bq0EGdJ
         fUacWemr8y3Gpiis+9TS0rKbURMuVplBqkNwIJ8p2o5Okxv9y3rPFiEBe3KZgj5FgUGG
         BHR23iZVq1u5uA0lTaPwTmnd3V6Tx5oPTwoyCX3zsFAoO6ipXksvhZU20l+HUkjKcw8v
         /kRPlsJaglUkT4Ccre874TRMFDQIaP2Fs4sTHFUXyh8DOGHyNQSW7jGnlYfIsxsxQ8Bs
         QHl1j+ZAYvo2Ut6cfLh+tIpavOXAsECOP2vv0JPJTpzBQ2psbiHytwz9jlhc4S6dWgDV
         wFFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Qo9mgLecrXCNDIXJiVYm+FhlZCagK4jOK5c/AYuo8h8=;
        b=a6RPGzKEyOKYJmJYwCg5arQnb3rTgTUbIhZrvJyB6Gz9/JywmdQ+s/NzCwUMmeOsuB
         EdHQzuigZxrBkr5yuCUdQJaMbTZgctDriXZGvTC8NNFkzciLZ7QEpVCUyQB1qpJ1ZijX
         I+hlOv5sIYNDICy1aI5i4QsvQnE+Cf6DEY8PiiSHqJzOUSvlpuA4PsN25PKuimYZ0Hss
         bGF8SEAwLGlZf7e1QMytZX5Ig4EAI1nENTKqAfWrnlkuYWR3LVST+KM8ddFvrqWNQZKy
         48Ff7XldbPlHNYKl1RcV9g50yt+ZjpPy1GAsI+COIxk2Y5glM1Luc32X8R+KI4/Xh6W2
         nrIA==
X-Gm-Message-State: AJIora8/swKQtnbY8WxnMEOMwJsd5BH+uL2QlFPdACMQ5FtRQxZ0YCrM
        6S63YEN4qjDGQ2RZSRH4DiaAdETrPy61Jw==
X-Google-Smtp-Source: AGRyM1vInS1G8LBikqKBDOu7ts9YSOKn9Wn/4Vtu5ngR6/0gEltO692faW2Ejyti43OKHpteKjuC7M3GHVm6mg==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:dd36:c013:75d8:a382])
 (user=mmandlik job=sendgmr) by 2002:a81:1e46:0:b0:31c:8205:2caa with SMTP id
 e67-20020a811e46000000b0031c82052caamr486426ywe.272.1657232129959; Thu, 07
 Jul 2022 15:15:29 -0700 (PDT)
Date:   Thu,  7 Jul 2022 15:15:14 -0700
Message-Id: <20220707151420.v3.1.Iaf638bb9f885f5880ab1b4e7ae2f73dd53a54661@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v3 1/3] Bluetooth: Add support for devcoredump
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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

Changes in v3:
- Add attribute to enable/disable and set default state to disabled

Changes in v2:
- Move hci devcoredump implementation to new files
- Move dump queue and dump work to hci_devcoredump struct
- Add CONFIG_DEV_COREDUMP conditional compile

 include/net/bluetooth/coredump.h | 110 +++++++
 include/net/bluetooth/hci_core.h |   5 +
 net/bluetooth/Makefile           |   2 +
 net/bluetooth/coredump.c         | 504 +++++++++++++++++++++++++++++++
 net/bluetooth/hci_core.c         |   9 +
 net/bluetooth/hci_sync.c         |   2 +
 6 files changed, 632 insertions(+)
 create mode 100644 include/net/bluetooth/coredump.h
 create mode 100644 net/bluetooth/coredump.c

diff --git a/include/net/bluetooth/coredump.h b/include/net/bluetooth/coredump.h
new file mode 100644
index 000000000000..db286a679eb7
--- /dev/null
+++ b/include/net/bluetooth/coredump.h
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2022 Google Corporation
+ */
+
+#ifndef __COREDUMP_H
+#define __COREDUMP_H
+
+#define DEVCOREDUMP_TIMEOUT	msecs_to_jiffies(10000)	/* 10 sec */
+
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
+ * @dmp_hdr: Create a dump header to identify controller/fw/driver info
+ * @notify_change: Notify driver when devcoredump state has changed
+ */
+struct hci_devcoredump {
+	bool		enabled;
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
+	u32		alloc_size;
+	char		*head;
+	char		*tail;
+	char		*end;
+
+	struct sk_buff_head	dump_q;
+	struct work_struct	dump_rx;
+	struct delayed_work	dump_timeout;
+
+	dmp_hdr_t	dmp_hdr;
+	notify_change_t	notify_change;
+};
+
+#ifdef CONFIG_DEV_COREDUMP
+
+void hci_devcoredump_reset(struct hci_dev *hdev);
+void hci_devcoredump_rx(struct work_struct *work);
+void hci_devcoredump_timeout(struct work_struct *work);
+int hci_devcoredump_register(struct hci_dev *hdev, dmp_hdr_t dmp_hdr,
+			     notify_change_t notify_change);
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
index 15237ee5f761..9ccc034c8fde 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -32,6 +32,7 @@
 #include <net/bluetooth/hci.h>
 #include <net/bluetooth/hci_sync.h>
 #include <net/bluetooth/hci_sock.h>
+#include <net/bluetooth/coredump.h>
 
 /* HCI priority */
 #define HCI_PRIO_MAX	7
@@ -582,6 +583,10 @@ struct hci_dev {
 	const char		*fw_info;
 	struct dentry		*debugfs;
 
+#ifdef CONFIG_DEV_COREDUMP
+	struct hci_devcoredump	dump;
+#endif
+
 	struct device		dev;
 
 	struct rfkill		*rfkill;
diff --git a/net/bluetooth/Makefile b/net/bluetooth/Makefile
index a52bba8500e1..4e894e452869 100644
--- a/net/bluetooth/Makefile
+++ b/net/bluetooth/Makefile
@@ -17,6 +17,8 @@ bluetooth-y := af_bluetooth.o hci_core.o hci_conn.o hci_event.o mgmt.o \
 	ecdh_helper.o hci_request.o mgmt_util.o mgmt_config.o hci_codec.o \
 	eir.o hci_sync.o
 
+bluetooth-$(CONFIG_DEV_COREDUMP) += coredump.o
+
 bluetooth-$(CONFIG_BT_BREDR) += sco.o
 bluetooth-$(CONFIG_BT_HS) += a2mp.o amp.o
 bluetooth-$(CONFIG_BT_LEDS) += leds.o
diff --git a/net/bluetooth/coredump.c b/net/bluetooth/coredump.c
new file mode 100644
index 000000000000..aa1ab42e7d4b
--- /dev/null
+++ b/net/bluetooth/coredump.c
@@ -0,0 +1,504 @@
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
+				    "(expect %u)",
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
+				    "(expect %u)",
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
+	bt_dev_info(hdev, "Devcoredump timeout with size %u (expect %u)",
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
+int hci_devcoredump_register(struct hci_dev *hdev, dmp_hdr_t dmp_hdr,
+			     notify_change_t notify_change)
+{
+	/* driver must implement dmp_hdr() function for bluetooth devcoredump */
+	if (!dmp_hdr)
+		return -EINVAL;
+
+	hci_dev_lock(hdev);
+	hdev->dump.dmp_hdr = dmp_hdr;
+	hdev->dump.notify_change = notify_change;
+	hdev->dump.supported = true;
+	hci_dev_unlock(hdev);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcoredump_register);
+
+int hci_devcoredump_init(struct hci_dev *hdev, u32 dmp_size)
+{
+	struct sk_buff *skb = NULL;
+
+	if (!hdev->dump.enabled || !hdev->dump.supported)
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
+	if (!hdev->dump.enabled || !hdev->dump.supported) {
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
+	if (!hdev->dump.enabled || !hdev->dump.supported)
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
+	if (!hdev->dump.enabled || !hdev->dump.supported)
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
+	if (!hdev->dump.enabled || !hdev->dump.supported)
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
index 05c13f639b94..743c5bdb8daa 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2516,14 +2516,23 @@ struct hci_dev *hci_alloc_dev_priv(int sizeof_priv)
 	INIT_WORK(&hdev->tx_work, hci_tx_work);
 	INIT_WORK(&hdev->power_on, hci_power_on);
 	INIT_WORK(&hdev->error_reset, hci_error_reset);
+#ifdef CONFIG_DEV_COREDUMP
+	INIT_WORK(&hdev->dump.dump_rx, hci_devcoredump_rx);
+#endif
 
 	hci_cmd_sync_init(hdev);
 
 	INIT_DELAYED_WORK(&hdev->power_off, hci_power_off);
+#ifdef CONFIG_DEV_COREDUMP
+	INIT_DELAYED_WORK(&hdev->dump.dump_timeout, hci_devcoredump_timeout);
+#endif
 
 	skb_queue_head_init(&hdev->rx_q);
 	skb_queue_head_init(&hdev->cmd_q);
 	skb_queue_head_init(&hdev->raw_q);
+#ifdef CONFIG_DEV_COREDUMP
+	skb_queue_head_init(&hdev->dump.dump_q);
+#endif
 
 	init_waitqueue_head(&hdev->req_wait_q);
 
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index e5602e209b63..a3d049b55b70 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3924,6 +3924,8 @@ int hci_dev_open_sync(struct hci_dev *hdev)
 		goto done;
 	}
 
+	hci_devcoredump_reset(hdev);
+
 	set_bit(HCI_RUNNING, &hdev->flags);
 	hci_sock_dev_event(hdev, HCI_DEV_OPEN);
 
-- 
2.37.0.rc0.161.g10f37bed90-goog

