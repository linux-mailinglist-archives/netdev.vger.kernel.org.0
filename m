Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D2920C0E0
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 12:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgF0Kz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 06:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgF0KzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 06:55:21 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2551C03E97A
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 03:55:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id r17so12688747ybj.22
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 03:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hXel7qYEL2h1Ox+Ye8sns97da4WDPOmCvVF0B5at7tg=;
        b=Pe/l/66IdZ9Lhzaj9eGNNwOGtyoKPS5+ayyodjX+42TqFSoiWlvpqrB/p9k5YYLcGx
         ttDG/EP2vMoInr+UtV+EUo+x92YY6DEtGq8w6tDLfExc1vCpvpWZCVG91lytm7hvwalS
         AJqFno58PkUFYdTn2d3TrDctIZUeKYLvduUPNsWFUHMAKto/91T+wadonKz3hlMkSoV6
         ZCVADj60YQzugkuk7AzJlkHYgRkmL/TwwT2VOa7r7j9D5TR2oGyivZoVf3lxoR8NosP7
         nYDlu9/1fQ8tpcAk4qMpZOWBCVBEZQOk6GfadRY1m/F8ZSsITHn+X+zBHuIsfSFrcVZ/
         2Hmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hXel7qYEL2h1Ox+Ye8sns97da4WDPOmCvVF0B5at7tg=;
        b=cog/Le/el3tEwpChD80/ZwVMTpxoEVHUQ5nUbREjPyRR9UcBKOoSSKF6bVJG88rDWl
         DYJfLTgUyUiih0mLeuH60U1fMqrgMd3VyP+c48Zj7wbI7mcdVuL/yy+vsss+J3bPXQ0D
         ZKJ3kyHpjJPx2YbA/p20ylBZ3Istek8+AwIb/bvMjvl0rvFX1WnioXGcdCEKvI8WRRpo
         XRLVdIkDSTO5OoZowz8w7nY0h6QzQaDuRQuKdNxq2ZKQ6BlLaYYz/Q8wlJCenqtlQNAW
         FgS7O5hlD/VVct9PCEcubQoq3zQWD9CX1XAYuQJcy89IeHu0ptQd7qVFppB3rAqTxCHg
         4J9g==
X-Gm-Message-State: AOAM532G5fYGJE6A7d1X6TOGo53vk2ajM9zbdPv5uN4JETHx2nPWskIT
        zKvRgkzBgkm8oEPz0mU3il8wZiUa/zgH
X-Google-Smtp-Source: ABdhPJyPfy7s/+o4eZKfkw6mztV+uWshtdiNNkloy27vf3/MiJm62SV5aSN0AzbwPyJidtBVtIYWcok7HH8x
X-Received: by 2002:a25:80c7:: with SMTP id c7mr11756319ybm.357.1593255320973;
 Sat, 27 Jun 2020 03:55:20 -0700 (PDT)
Date:   Sat, 27 Jun 2020 18:54:36 +0800
In-Reply-To: <20200627105437.453053-1-apusaka@google.com>
Message-Id: <20200627185320.RFC.v1.1.Icea550bb064a24b89f2217cf19e35b4480a31afd@changeid>
Mime-Version: 1.0
References: <20200627105437.453053-1-apusaka@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [RFC PATCH v1 1/2] Bluetooth: queue ACL packets if no handle is found
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

There is a possibility that an ACL packet is received before we
receive the HCI connect event for the corresponding handle. If this
happens, we discard the ACL packet.

Rather than just ignoring them, this patch provides a queue for
incoming ACL packet without a handle. The queue is processed when
receiving a HCI connection event. If 2 seconds elapsed without
receiving the HCI connection event, assume something bad happened
and discard the queued packet.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

---

 include/net/bluetooth/hci_core.h |  8 +++
 net/bluetooth/hci_core.c         | 84 +++++++++++++++++++++++++++++---
 net/bluetooth/hci_event.c        |  2 +
 3 files changed, 88 insertions(+), 6 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 836dc997ff94..b69ecdd0d15a 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -270,6 +270,9 @@ struct adv_monitor {
 /* Default authenticated payload timeout 30s */
 #define DEFAULT_AUTH_PAYLOAD_TIMEOUT   0x0bb8
 
+/* Time to keep ACL packets without a corresponding handle queued (2s) */
+#define PENDING_ACL_TIMEOUT		msecs_to_jiffies(2000)
+
 struct amp_assoc {
 	__u16	len;
 	__u16	offset;
@@ -538,6 +541,9 @@ struct hci_dev {
 	struct delayed_work	rpa_expired;
 	bdaddr_t		rpa;
 
+	struct delayed_work	remove_pending_acl;
+	struct sk_buff_head	pending_acl_q;
+
 #if IS_ENABLED(CONFIG_BT_LEDS)
 	struct led_trigger	*power_led;
 #endif
@@ -1773,6 +1779,8 @@ void hci_le_start_enc(struct hci_conn *conn, __le16 ediv, __le64 rand,
 void hci_copy_identity_address(struct hci_dev *hdev, bdaddr_t *bdaddr,
 			       u8 *bdaddr_type);
 
+void hci_process_pending_acl(struct hci_dev *hdev, struct hci_conn *conn);
+
 #define SCO_AIRMODE_MASK       0x0003
 #define SCO_AIRMODE_CVSD       0x0000
 #define SCO_AIRMODE_TRANSP     0x0003
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 7959b851cc63..30780242c267 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1786,6 +1786,7 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	skb_queue_purge(&hdev->rx_q);
 	skb_queue_purge(&hdev->cmd_q);
 	skb_queue_purge(&hdev->raw_q);
+	skb_queue_purge(&hdev->pending_acl_q);
 
 	/* Drop last sent command */
 	if (hdev->sent_cmd) {
@@ -3518,6 +3519,78 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 	return NOTIFY_STOP;
 }
 
+static void hci_add_pending_acl(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	skb_queue_tail(&hdev->pending_acl_q, skb);
+
+	queue_delayed_work(hdev->workqueue, &hdev->remove_pending_acl,
+			   PENDING_ACL_TIMEOUT);
+}
+
+void hci_process_pending_acl(struct hci_dev *hdev, struct hci_conn *conn)
+{
+	struct sk_buff *skb, *tmp;
+	struct hci_acl_hdr *hdr;
+	u16 handle, flags;
+	bool reset_timer = false;
+
+	skb_queue_walk_safe(&hdev->pending_acl_q, skb, tmp) {
+		hdr = (struct hci_acl_hdr *)skb->data;
+		handle = __le16_to_cpu(hdr->handle);
+		flags  = hci_flags(handle);
+		handle = hci_handle(handle);
+
+		if (handle != conn->handle)
+			continue;
+
+		__skb_unlink(skb, &hdev->pending_acl_q);
+		skb_pull(skb, HCI_ACL_HDR_SIZE);
+
+		l2cap_recv_acldata(conn, skb, flags);
+		reset_timer = true;
+	}
+
+	if (reset_timer)
+		mod_delayed_work(hdev->workqueue, &hdev->remove_pending_acl,
+				 PENDING_ACL_TIMEOUT);
+}
+
+/* Remove the oldest pending ACL, and all pending ACLs with the same handle */
+static void hci_remove_pending_acl(struct work_struct *work)
+{
+	struct hci_dev *hdev;
+	struct sk_buff *skb, *tmp;
+	struct hci_acl_hdr *hdr;
+	u16 handle, oldest_handle;
+
+	hdev = container_of(work, struct hci_dev, remove_pending_acl.work);
+	skb = skb_dequeue(&hdev->pending_acl_q);
+
+	if (!skb)
+		return;
+
+	hdr = (struct hci_acl_hdr *)skb->data;
+	oldest_handle = hci_handle(__le16_to_cpu(hdr->handle));
+	kfree_skb(skb);
+
+	bt_dev_err(hdev, "ACL packet for unknown connection handle %d",
+		   oldest_handle);
+
+	skb_queue_walk_safe(&hdev->pending_acl_q, skb, tmp) {
+		hdr = (struct hci_acl_hdr *)skb->data;
+		handle = hci_handle(__le16_to_cpu(hdr->handle));
+
+		if (handle == oldest_handle) {
+			__skb_unlink(skb, &hdev->pending_acl_q);
+			kfree_skb(skb);
+		}
+	}
+
+	if (!skb_queue_empty(&hdev->pending_acl_q))
+		queue_delayed_work(hdev->workqueue, &hdev->remove_pending_acl,
+				   PENDING_ACL_TIMEOUT);
+}
+
 /* Alloc HCI device */
 struct hci_dev *hci_alloc_dev(void)
 {
@@ -3610,10 +3683,12 @@ struct hci_dev *hci_alloc_dev(void)
 	INIT_WORK(&hdev->suspend_prepare, hci_prepare_suspend);
 
 	INIT_DELAYED_WORK(&hdev->power_off, hci_power_off);
+	INIT_DELAYED_WORK(&hdev->remove_pending_acl, hci_remove_pending_acl);
 
 	skb_queue_head_init(&hdev->rx_q);
 	skb_queue_head_init(&hdev->cmd_q);
 	skb_queue_head_init(&hdev->raw_q);
+	skb_queue_head_init(&hdev->pending_acl_q);
 
 	init_waitqueue_head(&hdev->req_wait_q);
 	init_waitqueue_head(&hdev->suspend_wait_q);
@@ -4662,8 +4737,6 @@ static void hci_acldata_packet(struct hci_dev *hdev, struct sk_buff *skb)
 	struct hci_conn *conn;
 	__u16 handle, flags;
 
-	skb_pull(skb, HCI_ACL_HDR_SIZE);
-
 	handle = __le16_to_cpu(hdr->handle);
 	flags  = hci_flags(handle);
 	handle = hci_handle(handle);
@@ -4678,17 +4751,16 @@ static void hci_acldata_packet(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 
 	if (conn) {
+		skb_pull(skb, HCI_ACL_HDR_SIZE);
+
 		hci_conn_enter_active_mode(conn, BT_POWER_FORCE_ACTIVE_OFF);
 
 		/* Send to upper protocol */
 		l2cap_recv_acldata(conn, skb, flags);
 		return;
 	} else {
-		bt_dev_err(hdev, "ACL packet for unknown connection handle %d",
-			   handle);
+		hci_add_pending_acl(hdev, skb);
 	}
-
-	kfree_skb(skb);
 }
 
 /* SCO data packet */
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index e060fc9ebb18..108c6c102a6a 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2627,6 +2627,8 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 			hci_send_cmd(hdev, HCI_OP_CHANGE_CONN_PTYPE, sizeof(cp),
 				     &cp);
 		}
+
+		hci_process_pending_acl(hdev, conn);
 	} else {
 		conn->state = BT_CLOSED;
 		if (conn->type == ACL_LINK)
-- 
2.27.0.212.ge8ba1cc988-goog

