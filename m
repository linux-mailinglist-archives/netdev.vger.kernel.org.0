Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDEC4E1EC1
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 02:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344004AbiCUBfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 21:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344001AbiCUBfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 21:35:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C9863FC
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 18:34:10 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y32-20020a25ad20000000b006339fb8e18cso8408417ybi.9
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 18:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ZeOLNklFdxO3u9OAvpBerkpzzU95+aAU0znuTpLngiQ=;
        b=d1jV4Cp37F7D9BCOUfHlmoTAXcJNeXJ40BNj0wskYrkpjYkINjYOZe9N7OKQihkRfB
         gP4rkkkd0BJ6jl2+dNIdkv1qBAKhtgplX5VyhaIZ0x4dCcFQyu77f3a8nt5MhnsTVxgU
         mVHtLKDioiNJmegqN2UyewB+XzCfU3IrlSNGcY9ScTPEOKlz7qs+n5zPWuvEGBO2UJuF
         4mH1WVf2xyNUa7SVWkfGsC0nt9ltuZgvOpLdB7KdV+i1u/uQ+Y+a3Jm6GT5TUp4frAW/
         zE0Gf6hOgeeATSbN67lbelakOnB/Wk92YEO1BPD+ctMS2ILTYHnqStgVX0TQOcB6xJUy
         qKjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ZeOLNklFdxO3u9OAvpBerkpzzU95+aAU0znuTpLngiQ=;
        b=2fsieBcNAbH4QAmxw2Qh97+/D5ONEhCfwWs3PneO8WvVXgvYuJaBvJaG1ALXYsdInD
         zDbQS6R9b5ugmDCVVTWE30Nr3XVswjj8gSeC09vnifNGoC+BYZg9XzpgWXW7ZIrE0Vbo
         g8YBk3ZzoD/UtM8l19KU65rOSNFZqb++07lzYbLGzljaCQqHS5PK4Tp3XFiSGLjV4cZW
         81W3MEBBpZKM9mOhIFhMiNUwE0TIKbKYdJ9U9H2iPlzd3AP8+9KomWz+XyckWaKmwSxy
         KpsjKW+/JuPcYqrNAVgHpi+0jHfgETZmr32afJSB7rRIev32O3qTJJUNQZs9RKcm6oCw
         g7mw==
X-Gm-Message-State: AOAM532TVaoh6ikHhinmmJ9X8OOEj51uliTF9Pyi6dDFwbxABFWNILJV
        6Yw8K1xu5n5DnLNAufxA0EX6NKC+BDdq7w==
X-Google-Smtp-Source: ABdhPJwT0bz490iHWFWNbNigVu4ofICo3mqLkt63BYyrYcWzYNdJeTC0hDh8faJQIrGbrXZnxIts4ihftVTL8Q==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:e0cb:81c1:7b8f:ab9f])
 (user=mmandlik job=sendgmr) by 2002:a5b:787:0:b0:624:107a:6c45 with SMTP id
 b7-20020a5b0787000000b00624107a6c45mr19279543ybq.24.1647826449307; Sun, 20
 Mar 2022 18:34:09 -0700 (PDT)
Date:   Sun, 20 Mar 2022 18:34:00 -0700
Message-Id: <20220320183225.1.Iaf638bb9f885f5880ab1b4e7ae2f73dd53a54661@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH 1/2] Bluetooth: Add support for devcoredump
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Manish Mandlik <mmandlik@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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

 include/net/bluetooth/hci_core.h |  51 ++++
 net/bluetooth/hci_core.c         | 496 +++++++++++++++++++++++++++++++
 net/bluetooth/hci_sync.c         |   2 +
 3 files changed, 549 insertions(+)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index d5377740e99c..818ba3a43e8c 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -118,6 +118,43 @@ enum suspended_state {
 	BT_SUSPEND_CONFIGURE_WAKE,
 };
 
+#define DEVCOREDUMP_TIMEOUT	msecs_to_jiffies(100000)	/* 100 sec */
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
+	u32		alloc_size;
+	char		*head;
+	char		*tail;
+	char		*end;
+
+	dmp_hdr_t	dmp_hdr;
+	notify_change_t	notify_change;
+};
+
 struct hci_conn_hash {
 	struct list_head list;
 	unsigned int     acl_num;
@@ -568,6 +605,11 @@ struct hci_dev {
 	const char		*fw_info;
 	struct dentry		*debugfs;
 
+	struct hci_devcoredump	dump;
+	struct sk_buff_head	dump_q;
+	struct work_struct	dump_rx;
+	struct delayed_work	dump_timeout;
+
 	struct device		dev;
 
 	struct rfkill		*rfkill;
@@ -1308,6 +1350,15 @@ static inline void hci_set_aosp_capable(struct hci_dev *hdev)
 #endif
 }
 
+int hci_devcoredump_register(struct hci_dev *hdev, dmp_hdr_t dmp_hdr,
+			     notify_change_t notify_change);
+int hci_devcoredump_init(struct hci_dev *hdev, u32 dmp_size);
+int hci_devcoredump_append(struct hci_dev *hdev, struct sk_buff *skb);
+int hci_devcoredump_append_pattern(struct hci_dev *hdev, u8 pattern, u32 len);
+int hci_devcoredump_complete(struct hci_dev *hdev);
+int hci_devcoredump_abort(struct hci_dev *hdev);
+void hci_devcoredump_reset(struct hci_dev *hdev);
+
 int hci_dev_open(__u16 dev);
 int hci_dev_close(__u16 dev);
 int hci_dev_do_close(struct hci_dev *hdev);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index b4782a6c1025..76dbb6b28870 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -28,6 +28,7 @@
 #include <linux/export.h>
 #include <linux/rfkill.h>
 #include <linux/debugfs.h>
+#include <linux/devcoredump.h>
 #include <linux/crypto.h>
 #include <linux/property.h>
 #include <linux/suspend.h>
@@ -2404,6 +2405,498 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 	return NOTIFY_DONE;
 }
 
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
+	cancel_delayed_work(&hdev->dump_timeout);
+	skb_queue_purge(&hdev->dump_q);
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
+static void hci_devcoredump_rx(struct work_struct *work)
+{
+	struct hci_dev *hdev = container_of(work, struct hci_dev, dump_rx);
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
+	while ((skb = skb_dequeue(&hdev->dump_q))) {
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
+			queue_delayed_work(hdev->workqueue, &hdev->dump_timeout,
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
+
+static void hci_devcoredump_timeout(struct work_struct *work)
+{
+	struct hci_dev *hdev = container_of(work, struct hci_dev,
+					    dump_timeout.work);
+	u32 dump_size;
+
+	hci_devcoredump_notify(hdev, HCI_DEVCOREDUMP_TIMEOUT);
+
+	hci_dev_lock(hdev);
+
+	cancel_work_sync(&hdev->dump_rx);
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
+	if (!hdev->dump.supported)
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
+	skb_queue_tail(&hdev->dump_q, skb);
+	queue_work(hdev->workqueue, &hdev->dump_rx);
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
+	if (!hdev->dump.supported) {
+		kfree_skb(skb);
+		return -EOPNOTSUPP;
+	}
+
+	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_SKB;
+
+	skb_queue_tail(&hdev->dump_q, skb);
+	queue_work(hdev->workqueue, &hdev->dump_rx);
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
+	if (!hdev->dump.supported)
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
+	skb_queue_tail(&hdev->dump_q, skb);
+	queue_work(hdev->workqueue, &hdev->dump_rx);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcoredump_append_pattern);
+
+int hci_devcoredump_complete(struct hci_dev *hdev)
+{
+	struct sk_buff *skb = NULL;
+
+	if (!hdev->dump.supported)
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
+	skb_queue_tail(&hdev->dump_q, skb);
+	queue_work(hdev->workqueue, &hdev->dump_rx);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcoredump_complete);
+
+int hci_devcoredump_abort(struct hci_dev *hdev)
+{
+	struct sk_buff *skb = NULL;
+
+	if (!hdev->dump.supported)
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
+	skb_queue_tail(&hdev->dump_q, skb);
+	queue_work(hdev->workqueue, &hdev->dump_rx);
+
+	return 0;
+}
+EXPORT_SYMBOL(hci_devcoredump_abort);
+
 /* Alloc HCI device */
 struct hci_dev *hci_alloc_dev_priv(int sizeof_priv)
 {
@@ -2511,14 +3004,17 @@ struct hci_dev *hci_alloc_dev_priv(int sizeof_priv)
 	INIT_WORK(&hdev->tx_work, hci_tx_work);
 	INIT_WORK(&hdev->power_on, hci_power_on);
 	INIT_WORK(&hdev->error_reset, hci_error_reset);
+	INIT_WORK(&hdev->dump_rx, hci_devcoredump_rx);
 
 	hci_cmd_sync_init(hdev);
 
 	INIT_DELAYED_WORK(&hdev->power_off, hci_power_off);
+	INIT_DELAYED_WORK(&hdev->dump_timeout, hci_devcoredump_timeout);
 
 	skb_queue_head_init(&hdev->rx_q);
 	skb_queue_head_init(&hdev->cmd_q);
 	skb_queue_head_init(&hdev->raw_q);
+	skb_queue_head_init(&hdev->dump_q);
 
 	init_waitqueue_head(&hdev->req_wait_q);
 
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 8f4c5698913d..ec03fa871ef0 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3877,6 +3877,8 @@ int hci_dev_open_sync(struct hci_dev *hdev)
 		goto done;
 	}
 
+	hci_devcoredump_reset(hdev);
+
 	set_bit(HCI_RUNNING, &hdev->flags);
 	hci_sock_dev_event(hdev, HCI_DEV_OPEN);
 
-- 
2.35.1.894.gb6a874cedc-goog

