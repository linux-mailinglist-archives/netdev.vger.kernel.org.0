Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C866CFB32
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjC3GFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjC3GFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:05:31 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F88735B7
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 23:05:28 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id i36-20020a635424000000b0050f93a35888so5060001pgb.17
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 23:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680156327;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ULXOCg7j+JQOpcZkcxg+uH5jRvKSfcjhPNmmj9e1JqE=;
        b=cg4bKeQClLfxQNPbgt8gmyyxItw7QvYc9s00JKaPy6g8+kvdm5cvdF917xdnzCibRq
         XuDuAAzetwT9ffJoIOC32gO7QkVVC+WTJSkbr3RUZOb8fZw0qnhg8Ne57b6GVp9Yq7uc
         1h7sAb9CNVjFAAWAfADi5a3tmy6IUKayCdxWwG///tVjmGVaC2b8G3rerfX8CJZglc7C
         6Ko8lrTvfHFjqGlLz4tRkkrdggXpXkY6/iIam7swcQHztqvn67fnJcwSP4Us43T2O5l1
         4t4d2AiJZI/SajjfzZKJdq/y+7Hnlc4iKFhSSFA1aIXvbX0v8ouYjVLogNOj7U4kkWYL
         8c/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680156327;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ULXOCg7j+JQOpcZkcxg+uH5jRvKSfcjhPNmmj9e1JqE=;
        b=uTUbDQXW+FacfcDqXQ/9GNTDsrcZk1CDq4zq1t7dKDyMy0Ju4SsH6G0i9hEf0QWEQS
         uYuta8U7g0QBgvGcVYHZDbZ2R8oqCpWlc0JcUWpUj0ZJqJQARKs7wUp6gzaXu8eUuIIT
         0dUsTyzSG6rLJR0qEmfDwFi/DepAojfFWPdtbFw+xympeRKOhHbHKDGUYljWmLR+u9Rh
         Vj/YQGr06I+we793mx2usnIr+1K8xfLC9RFkpMwzxxpHAVyJQz55RDHxt1NZErz2g+Fb
         vCmPZER4dyfoDX8PjRMtytVGnni3K/oyRNn9bQKpsY84c++76ETBq2A2IX5RKXcg+kGJ
         OAQg==
X-Gm-Message-State: AAQBX9dRASW1hrNM4N2Wmu/zBfjX2aleDaxRwnFJtPNEBT0gmXmW6NhG
        mpLhZN2oVWlbgy1Ak5N4I3WCmGcvLOKH2A==
X-Google-Smtp-Source: AKy350brwM2rD2/6DIZ3Wl/hyNpTjmkvWChbz7zs8o5wWgsSXJAEcbx2sQWCzfylzLsSGfYJRvx7Vb/7gioQYQ==
X-Received: from mmandlik-cloudtop.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:2893])
 (user=mmandlik job=sendgmr) by 2002:a63:4458:0:b0:50b:e3da:6bb7 with SMTP id
 t24-20020a634458000000b0050be3da6bb7mr6162981pgk.2.1680156327475; Wed, 29 Mar
 2023 23:05:27 -0700 (PDT)
Date:   Wed, 29 Mar 2023 23:05:20 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230329230447.v12.1.I9b4e4818bab450657b19cda3497d363c9baa616e@changeid>
Subject: [PATCH v12 1/4] Bluetooth: Add support for hci devcoredump
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

Changes in v12:
- Add timeout to struct hci_devcoredump
- Use cancel_work() instead of cancel_work_sync() in hci_devcd_timeout()
- Handle timeout in hci_devcd_rx()

Changes in v11:
- Fix formatting/indentation

Changes in v10:
- Fix compiler warnings

Changes in v9:
- Use scnprintf instead of snprintf
- Remove unnecessary out-of-memory logs
- Add a function for each devcoredump state
- Use skb_pull_data whenever possible
- Rename hci_devcoredump_*() to hci_devcd_*()

Changes in v8:
- Update hci_devcoredump_mkheader() and .dmp_hdr() to use skb

Changes in v6:
- Remove #ifdef from .c and move to function in .h as per suggestion
- Remove coredump_enabled from hci_devcoredump struct since the sysfs
  flag related change has been abandoned

Changes in v5:
- No changes in v5

Changes in v4:
- Add .enabled() and .coredump() to hci_devcoredump struct

Changes in v3:
- Add attribute to enable/disable and set default state to disabled

Changes in v2:
- Move hci devcoredump implementation to new files
- Move dump queue and dump work to hci_devcoredump struct
- Add CONFIG_DEV_COREDUMP conditional compile

 include/net/bluetooth/coredump.h | 116 +++++++
 include/net/bluetooth/hci_core.h |  14 +
 net/bluetooth/Makefile           |   2 +
 net/bluetooth/coredump.c         | 535 +++++++++++++++++++++++++++++++
 net/bluetooth/hci_core.c         |   1 +
 net/bluetooth/hci_sync.c         |   2 +
 6 files changed, 670 insertions(+)
 create mode 100644 include/net/bluetooth/coredump.h
 create mode 100644 net/bluetooth/coredump.c

diff --git a/include/net/bluetooth/coredump.h b/include/net/bluetooth/coredump.h
new file mode 100644
index 000000000000..72f51b587a04
--- /dev/null
+++ b/include/net/bluetooth/coredump.h
@@ -0,0 +1,116 @@
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
+ * @timeout: Indicates a timeout for collecting the devcoredump
+ *
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
+		HCI_DEVCOREDUMP_TIMEOUT,
+	} state;
+
+	unsigned long	timeout;
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
+void hci_devcd_reset(struct hci_dev *hdev);
+void hci_devcd_rx(struct work_struct *work);
+void hci_devcd_timeout(struct work_struct *work);
+
+int hci_devcd_register(struct hci_dev *hdev, coredump_t coredump,
+		       dmp_hdr_t dmp_hdr, notify_change_t notify_change);
+int hci_devcd_init(struct hci_dev *hdev, u32 dump_size);
+int hci_devcd_append(struct hci_dev *hdev, struct sk_buff *skb);
+int hci_devcd_append_pattern(struct hci_dev *hdev, u8 pattern, u32 len);
+int hci_devcd_complete(struct hci_dev *hdev);
+int hci_devcd_abort(struct hci_dev *hdev);
+
+#else
+
+static inline void hci_devcd_reset(struct hci_dev *hdev) {}
+static inline void hci_devcd_rx(struct work_struct *work) {}
+static inline void hci_devcd_timeout(struct work_struct *work) {}
+
+static inline int hci_devcd_register(struct hci_dev *hdev, coredump_t coredump,
+				     dmp_hdr_t dmp_hdr,
+				     notify_change_t notify_change)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int hci_devcd_init(struct hci_dev *hdev, u32 dump_size)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int hci_devcd_append(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int hci_devcd_append_pattern(struct hci_dev *hdev,
+					   u8 pattern, u32 len)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int hci_devcd_complete(struct hci_dev *hdev)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int hci_devcd_abort(struct hci_dev *hdev)
+{
+	return -EOPNOTSUPP;
+}
+
+#endif /* CONFIG_DEV_COREDUMP */
+
+#endif /* __COREDUMP_H */
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 9488671c1219..300aaac84adf 100644
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
 
+static inline void hci_devcd_setup(struct hci_dev *hdev)
+{
+#ifdef CONFIG_DEV_COREDUMP
+	INIT_WORK(&hdev->dump.dump_rx, hci_devcd_rx);
+	INIT_DELAYED_WORK(&hdev->dump.dump_timeout, hci_devcd_timeout);
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
index 000000000000..8b0ee2dfe093
--- /dev/null
+++ b/net/bluetooth/coredump.c
@@ -0,0 +1,535 @@
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
+#define DBG_UNEXPECTED_STATE() \
+	bt_dev_dbg(hdev, \
+		   "Unexpected packet (%d) for state (%d). ", \
+		   hci_dmp_cb(skb)->pkt_type, hdev->dump.state)
+
+#define MAX_DEVCOREDUMP_HDR_SIZE	512	/* bytes */
+
+static int hci_devcd_update_hdr_state(char *buf, size_t size, int state)
+{
+	int len = 0;
+
+	if (!buf)
+		return 0;
+
+	len = scnprintf(buf, size, "Bluetooth devcoredump\nState: %d\n", state);
+
+	return len + 1; /* scnprintf adds \0 at the end upon state rewrite */
+}
+
+/* Call with hci_dev_lock only. */
+static int hci_devcd_update_state(struct hci_dev *hdev, int state)
+{
+	bt_dev_dbg(hdev, "Updating devcoredump state from %d to %d.",
+		   hdev->dump.state, state);
+
+	hdev->dump.state = state;
+
+	return hci_devcd_update_hdr_state(hdev->dump.head,
+					  hdev->dump.alloc_size, state);
+}
+
+static int hci_devcd_mkheader(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	char dump_start[] = "--- Start dump ---\n";
+	char hdr[80];
+	int hdr_len;
+
+	hdr_len = hci_devcd_update_hdr_state(hdr, sizeof(hdr),
+					     HCI_DEVCOREDUMP_IDLE);
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
+static void hci_devcd_notify(struct hci_dev *hdev, int state)
+{
+	if (hdev->dump.notify_change)
+		hdev->dump.notify_change(hdev, state);
+}
+
+/* Call with hci_dev_lock only. */
+void hci_devcd_reset(struct hci_dev *hdev)
+{
+	hdev->dump.head = NULL;
+	hdev->dump.tail = NULL;
+	hdev->dump.alloc_size = 0;
+
+	hci_devcd_update_state(hdev, HCI_DEVCOREDUMP_IDLE);
+
+	cancel_delayed_work(&hdev->dump.dump_timeout);
+	skb_queue_purge(&hdev->dump.dump_q);
+}
+
+/* Call with hci_dev_lock only. */
+static void hci_devcd_free(struct hci_dev *hdev)
+{
+	if (hdev->dump.head)
+		vfree(hdev->dump.head);
+
+	hci_devcd_reset(hdev);
+}
+
+/* Call with hci_dev_lock only. */
+static int hci_devcd_alloc(struct hci_dev *hdev, u32 size)
+{
+	hdev->dump.head = vmalloc(size);
+	if (!hdev->dump.head)
+		return -ENOMEM;
+
+	hdev->dump.alloc_size = size;
+	hdev->dump.tail = hdev->dump.head;
+	hdev->dump.end = hdev->dump.head + size;
+
+	hci_devcd_update_state(hdev, HCI_DEVCOREDUMP_IDLE);
+
+	return 0;
+}
+
+/* Call with hci_dev_lock only. */
+static bool hci_devcd_copy(struct hci_dev *hdev, char *buf, u32 size)
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
+static bool hci_devcd_memset(struct hci_dev *hdev, u8 pattern, u32 len)
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
+static int hci_devcd_prepare(struct hci_dev *hdev, u32 dump_size)
+{
+	struct sk_buff *skb;
+	int dump_hdr_size;
+	int err = 0;
+
+	skb = alloc_skb(MAX_DEVCOREDUMP_HDR_SIZE, GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	dump_hdr_size = hci_devcd_mkheader(hdev, skb);
+
+	if (hci_devcd_alloc(hdev, dump_hdr_size + dump_size)) {
+		err = -ENOMEM;
+		goto hdr_free;
+	}
+
+	/* Insert the device header */
+	if (!hci_devcd_copy(hdev, skb->data, skb->len)) {
+		bt_dev_err(hdev, "Failed to insert header");
+		hci_devcd_free(hdev);
+
+		err = -ENOMEM;
+		goto hdr_free;
+	}
+
+hdr_free:
+	kfree_skb(skb);
+
+	return err;
+}
+
+static void hci_devcd_handle_pkt_init(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	u32 *dump_size;
+
+	if (hdev->dump.state != HCI_DEVCOREDUMP_IDLE) {
+		DBG_UNEXPECTED_STATE();
+		return;
+	}
+
+	if (skb->len != sizeof(*dump_size)) {
+		bt_dev_dbg(hdev, "Invalid dump init pkt");
+		return;
+	}
+
+	dump_size = skb_pull_data(skb, sizeof(*dump_size));
+	if (!*dump_size) {
+		bt_dev_err(hdev, "Zero size dump init pkt");
+		return;
+	}
+
+	if (hci_devcd_prepare(hdev, *dump_size)) {
+		bt_dev_err(hdev, "Failed to prepare for dump");
+		return;
+	}
+
+	hci_devcd_update_state(hdev, HCI_DEVCOREDUMP_ACTIVE);
+	queue_delayed_work(hdev->workqueue, &hdev->dump.dump_timeout,
+			   hdev->dump.timeout);
+}
+
+static void hci_devcd_handle_pkt_skb(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
+		DBG_UNEXPECTED_STATE();
+		return;
+	}
+
+	if (!hci_devcd_copy(hdev, skb->data, skb->len))
+		bt_dev_dbg(hdev, "Failed to insert skb");
+}
+
+static void hci_devcd_handle_pkt_pattern(struct hci_dev *hdev,
+					 struct sk_buff *skb)
+{
+	struct hci_devcoredump_skb_pattern *pattern;
+
+	if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
+		DBG_UNEXPECTED_STATE();
+		return;
+	}
+
+	if (skb->len != sizeof(*pattern)) {
+		bt_dev_dbg(hdev, "Invalid pattern skb");
+		return;
+	}
+
+	pattern = skb_pull_data(skb, sizeof(*pattern));
+
+	if (!hci_devcd_memset(hdev, pattern->pattern, pattern->len))
+		bt_dev_dbg(hdev, "Failed to set pattern");
+}
+
+static void hci_devcd_handle_pkt_complete(struct hci_dev *hdev,
+					  struct sk_buff *skb)
+{
+	u32 dump_size;
+
+	if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
+		DBG_UNEXPECTED_STATE();
+		return;
+	}
+
+	hci_devcd_update_state(hdev, HCI_DEVCOREDUMP_DONE);
+	dump_size = hdev->dump.tail - hdev->dump.head;
+
+	bt_dev_info(hdev, "Devcoredump complete with size %u (expect %zu)",
+		    dump_size, hdev->dump.alloc_size);
+
+	dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size, GFP_KERNEL);
+}
+
+static void hci_devcd_handle_pkt_abort(struct hci_dev *hdev,
+				       struct sk_buff *skb)
+{
+	u32 dump_size;
+
+	if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
+		DBG_UNEXPECTED_STATE();
+		return;
+	}
+
+	hci_devcd_update_state(hdev, HCI_DEVCOREDUMP_ABORT);
+	dump_size = hdev->dump.tail - hdev->dump.head;
+
+	bt_dev_info(hdev, "Devcoredump aborted with size %u (expect %zu)",
+		    dump_size, hdev->dump.alloc_size);
+
+	/* Emit a devcoredump with the available data */
+	dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size, GFP_KERNEL);
+}
+
+/* Bluetooth devcoredump state machine.
+ *
+ * Devcoredump states:
+ *
+ *      HCI_DEVCOREDUMP_IDLE: The default state.
+ *
+ *      HCI_DEVCOREDUMP_ACTIVE: A devcoredump will be in this state once it has
+ *              been initialized using hci_devcd_init(). Once active, the driver
+ *              can append data using hci_devcd_append() or insert a pattern
+ *              using hci_devcd_append_pattern().
+ *
+ *      HCI_DEVCOREDUMP_DONE: Once the dump collection is complete, the drive
+ *              can signal the completion using hci_devcd_complete(). A
+ *              devcoredump is generated indicating the completion event and
+ *              then the state machine is reset to the default state.
+ *
+ *      HCI_DEVCOREDUMP_ABORT: The driver can cancel ongoing dump collection in
+ *              case of any error using hci_devcd_abort(). A devcoredump is
+ *              still generated with the available data indicating the abort
+ *              event and then the state machine is reset to the default state.
+ *
+ *      HCI_DEVCOREDUMP_TIMEOUT: A timeout timer for HCI_DEVCOREDUMP_TIMEOUT sec
+ *              is started during devcoredump initialization. Once the timeout
+ *              occurs, the driver is notified, a devcoredump is generated with
+ *              the available data indicating the timeout event and then the
+ *              state machine is reset to the default state.
+ *
+ * The driver must register using hci_devcd_register() before using the hci
+ * devcoredump APIs.
+ */
+void hci_devcd_rx(struct work_struct *work)
+{
+	struct hci_dev *hdev = container_of(work, struct hci_dev, dump.dump_rx);
+	struct sk_buff *skb;
+	int start_state;
+
+	while ((skb = skb_dequeue(&hdev->dump.dump_q))) {
+		/* Return if timeout occurs. The timeout handler function
+		 * hci_devcd_timeout() will report the available dump data.
+		 */
+		if (hdev->dump.state == HCI_DEVCOREDUMP_TIMEOUT) {
+			kfree_skb(skb);
+			return;
+		}
+
+		hci_dev_lock(hdev);
+		start_state = hdev->dump.state;
+
+		switch (hci_dmp_cb(skb)->pkt_type) {
+		case HCI_DEVCOREDUMP_PKT_INIT:
+			hci_devcd_handle_pkt_init(hdev, skb);
+			break;
+
+		case HCI_DEVCOREDUMP_PKT_SKB:
+			hci_devcd_handle_pkt_skb(hdev, skb);
+			break;
+
+		case HCI_DEVCOREDUMP_PKT_PATTERN:
+			hci_devcd_handle_pkt_pattern(hdev, skb);
+			break;
+
+		case HCI_DEVCOREDUMP_PKT_COMPLETE:
+			hci_devcd_handle_pkt_complete(hdev, skb);
+			break;
+
+		case HCI_DEVCOREDUMP_PKT_ABORT:
+			hci_devcd_handle_pkt_abort(hdev, skb);
+			break;
+
+		default:
+			bt_dev_dbg(hdev, "Unknown packet (%d) for state (%d). ",
+				   hci_dmp_cb(skb)->pkt_type, hdev->dump.state);
+			break;
+		}
+
+		hci_dev_unlock(hdev);
+		kfree_skb(skb);
+
+		/* Notify the driver about any state changes before resetting
+		 * the state machine
+		 */
+		if (start_state != hdev->dump.state)
+			hci_devcd_notify(hdev, hdev->dump.state);
+
+		/* Reset the state machine if the devcoredump is complete */
+		hci_dev_lock(hdev);
+		if (hdev->dump.state == HCI_DEVCOREDUMP_DONE ||
+		    hdev->dump.state == HCI_DEVCOREDUMP_ABORT)
+			hci_devcd_reset(hdev);
+		hci_dev_unlock(hdev);
+	}
+}
+EXPORT_SYMBOL(hci_devcd_rx);
+
+void hci_devcd_timeout(struct work_struct *work)
+{
+	struct hci_dev *hdev = container_of(work, struct hci_dev,
+					    dump.dump_timeout.work);
+	u32 dump_size;
+
+	hci_devcd_notify(hdev, HCI_DEVCOREDUMP_TIMEOUT);
+
+	hci_dev_lock(hdev);
+
+	cancel_work(&hdev->dump.dump_rx);
+
+	hci_devcd_update_state(hdev, HCI_DEVCOREDUMP_TIMEOUT);
+
+	dump_size = hdev->dump.tail - hdev->dump.head;
+	bt_dev_info(hdev, "Devcoredump timeout with size %u (expect %zu)",
+		    dump_size, hdev->dump.alloc_size);
+
+	/* Emit a devcoredump with the available data */
+	dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size, GFP_KERNEL);
+
+	hci_devcd_reset(hdev);
+
+	hci_dev_unlock(hdev);
+}
+EXPORT_SYMBOL(hci_devcd_timeout);
+
+int hci_devcd_register(struct hci_dev *hdev, coredump_t coredump,
+		       dmp_hdr_t dmp_hdr, notify_change_t notify_change)
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
+	hdev->dump.timeout = DEVCOREDUMP_TIMEOUT;
+	hci_dev_unlock(hdev);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcd_register);
+
+static inline bool hci_devcd_enabled(struct hci_dev *hdev)
+{
+	return hdev->dump.supported;
+}
+
+int hci_devcd_init(struct hci_dev *hdev, u32 dump_size)
+{
+	struct sk_buff *skb;
+
+	if (!hci_devcd_enabled(hdev))
+		return -EOPNOTSUPP;
+
+	skb = alloc_skb(sizeof(dump_size), GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_INIT;
+	skb_put_data(skb, &dump_size, sizeof(dump_size));
+
+	skb_queue_tail(&hdev->dump.dump_q, skb);
+	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcd_init);
+
+int hci_devcd_append(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	if (!skb)
+		return -ENOMEM;
+
+	if (!hci_devcd_enabled(hdev)) {
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
+EXPORT_SYMBOL(hci_devcd_append);
+
+int hci_devcd_append_pattern(struct hci_dev *hdev, u8 pattern, u32 len)
+{
+	struct hci_devcoredump_skb_pattern p;
+	struct sk_buff *skb;
+
+	if (!hci_devcd_enabled(hdev))
+		return -EOPNOTSUPP;
+
+	skb = alloc_skb(sizeof(p), GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
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
+EXPORT_SYMBOL(hci_devcd_append_pattern);
+
+int hci_devcd_complete(struct hci_dev *hdev)
+{
+	struct sk_buff *skb;
+
+	if (!hci_devcd_enabled(hdev))
+		return -EOPNOTSUPP;
+
+	skb = alloc_skb(0, GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_COMPLETE;
+
+	skb_queue_tail(&hdev->dump.dump_q, skb);
+	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcd_complete);
+
+int hci_devcd_abort(struct hci_dev *hdev)
+{
+	struct sk_buff *skb;
+
+	if (!hci_devcd_enabled(hdev))
+		return -EOPNOTSUPP;
+
+	skb = alloc_skb(0, GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_ABORT;
+
+	skb_queue_tail(&hdev->dump.dump_q, skb);
+	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcd_abort);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 334e308451f5..393b317ae68f 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2544,6 +2544,7 @@ struct hci_dev *hci_alloc_dev_priv(int sizeof_priv)
 	INIT_DELAYED_WORK(&hdev->cmd_timer, hci_cmd_timeout);
 	INIT_DELAYED_WORK(&hdev->ncmd_timer, hci_ncmd_timeout);
 
+	hci_devcd_setup(hdev);
 	hci_request_setup(hdev);
 
 	hci_init_sysfs(hdev);
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 561a519a11bd..2448423912fd 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4722,6 +4722,8 @@ int hci_dev_open_sync(struct hci_dev *hdev)
 		goto done;
 	}
 
+	hci_devcd_reset(hdev);
+
 	set_bit(HCI_RUNNING, &hdev->flags);
 	hci_sock_dev_event(hdev, HCI_DEV_OPEN);
 
-- 
2.40.0.348.gf938b09366-goog

