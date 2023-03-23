Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABD76C7223
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 22:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbjCWVK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 17:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjCWVK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 17:10:28 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA14B1ADE0
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 14:10:25 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id ie7-20020a17090b400700b0023f06808981so1321907pjb.8
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 14:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679605825;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jZhVO8fhX5S0B6hNgwRSXbVhGLvceCnx/d0fQZ5dkvE=;
        b=mM2To+D3jZzdrRmU1EbS0ws+L3fj25/Sx4+JakFu2hEPtHAuCr67uKcAo/6FESSC/5
         vFlQyh7VJJW0+gGMn8KUv5ObCmanvY2H8YG+L4LxbWwmizTSZDTD622dKeC9oewzXpc5
         Ye8dotlqQNIbTBycyitvllpUpe7tDzPN3elN0aKDSAlMhdoRt3l7d/mlGara7y23Uc8O
         3+zjtxxrniIj7QEaDZz0OIBjz4WInRSKsI69nAUKGuzxRBAvJ6tjTth04+X68Wz/lWiU
         hqXukPzitQgEpW9xMvdRm10uSQNpVxPXctnHhrD42bnnqut0r4uwX+ranNZKBdshIWpm
         0mAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679605825;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jZhVO8fhX5S0B6hNgwRSXbVhGLvceCnx/d0fQZ5dkvE=;
        b=t4jAVPyNdRINmW0f6r7qeo0t7Zixv7wQSE3UbKVAQDN28RmTh6FfpKmM63cWWR22P8
         oMABbUyVVpRO497GqLPhPLZbuwj/Exl6thINtArUNhxzJQWX+BVHZIhBu4lLlJDlG3dq
         k0uRxQttsVJFqp5JRB6yge7FVClBJk16nbaZPvUtlTTOcvSV8er+uUo7XjoZdTN5DQ/X
         GegbYZ0HYo+Z8zRMZsDedyMEV4ZIDPx6kTaXI9OuaodplvpH7Z01s96CBTC/rGMUR4/z
         6P6Ja84KvT1G2CINyMvcYpmKwQSATSR/sUBcGT8032hLPcyynNPR1jt/eXnvhs7ZfQ3z
         p//Q==
X-Gm-Message-State: AO0yUKWPay4OlmP66W0lvh9Vw3J5KRs+JHcJNja7AfGR/RLG+LSxj4sK
        ZN/K5ObaVLZ8AWq/pavKDxchT2H562fTEg==
X-Google-Smtp-Source: AK7set/5CLZR79wGOQKwpn9DWMPdLVfHArqmRj1XQtt7KKbHuhf/eIzcen2yh/p64Rz4r3HCaAaPI8Iuy3OfrQ==
X-Received: from mmandlik-cloudtop.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:2893])
 (user=mmandlik job=sendgmr) by 2002:a65:6447:0:b0:50f:aafa:6bc9 with SMTP id
 s7-20020a656447000000b0050faafa6bc9mr2424029pgv.6.1679605824864; Thu, 23 Mar
 2023 14:10:24 -0700 (PDT)
Date:   Thu, 23 Mar 2023 14:10:15 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230323140942.v8.1.I9b4e4818bab450657b19cda3497d363c9baa616e@changeid>
Subject: [PATCH v8 1/4] Bluetooth: Add support for hci devcoredump
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
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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

Changes in v8:
- Update hci_devcoredump_mkheader() and .dmp_hdr() to use skb

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
 net/bluetooth/coredump.c         | 508 +++++++++++++++++++++++++++++++
 net/bluetooth/hci_core.c         |   1 +
 net/bluetooth/hci_sync.c         |   2 +
 6 files changed, 641 insertions(+)
 create mode 100644 include/net/bluetooth/coredump.h
 create mode 100644 net/bluetooth/coredump.c

diff --git a/include/net/bluetooth/coredump.h b/include/net/bluetooth/coredump.h
new file mode 100644
index 000000000000..168b1afb5c33
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
+typedef void (*dmp_hdr_t)(struct hci_dev *hdev, struct sk_buff *skb);
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
index 000000000000..c4bf408baef6
--- /dev/null
+++ b/net/bluetooth/coredump.c
@@ -0,0 +1,508 @@
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
+	int len = 0;
+
+	if (!buf)
+		return 0;
+
+	len = snprintf(buf, size, "Bluetooth devcoredump\nState: %d\n", state);
+
+	return len + 1; /* snprintf adds \0 at the end upon state rewrite */
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
+static int hci_devcoredump_mkheader(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	char dump_start[] = "--- Start dump ---\n";
+	char hdr[80];
+	int hdr_len;
+
+	hdr_len = hci_devcoredump_update_hdr_state(hdr, sizeof(hdr),
+						   HCI_DEVCOREDUMP_IDLE);
+	skb_put_data(skb, hdr, hdr_len);
+
+	if (hdev->dump.dmp_hdr)
+		hdev->dump.dmp_hdr(hdev, skb);
+
+	skb_put_data(skb, dump_start, strlen(dump_start));
+
+	return skb->len;
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
+	struct sk_buff *skb = NULL;
+	int dump_hdr_size;
+	int err = 0;
+
+	skb = alloc_skb(MAX_DEVCOREDUMP_HDR_SIZE, GFP_ATOMIC);
+	if (!skb) {
+		bt_dev_err(hdev, "Failed to allocate devcoredump prepare");
+		return -ENOMEM;
+	}
+
+	dump_hdr_size = hci_devcoredump_mkheader(hdev, skb);
+
+	if (hci_devcoredump_alloc(hdev, dump_hdr_size + dump_size)) {
+		err = -ENOMEM;
+		goto hdr_free;
+	}
+
+	/* Insert the device header */
+	if (!hci_devcoredump_copy(hdev, skb->data, skb->len)) {
+		bt_dev_err(hdev, "Failed to insert header");
+		hci_devcoredump_free(hdev);
+
+		err = -ENOMEM;
+		goto hdr_free;
+	}
+
+hdr_free:
+	if (skb)
+		kfree_skb(skb);
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
2.40.0.348.gf938b09366-goog

