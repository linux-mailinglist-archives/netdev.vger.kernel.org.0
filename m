Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A1E2669E2
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgIKVHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbgIKVH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 17:07:29 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3FFC06179B
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 14:07:26 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d6so8267559pfn.9
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 14:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sVR9Vb4R3YNyl8BUOPHylCL5AwGFXPKzpdpN3YK2NSs=;
        b=FZmYI8NOZEYoS4h4TKsgjM8f5mBvp1E/CkXpw/byuJQC2or60GQAUwlWyuLGTTkWJQ
         JNnGYJKIc5H/aQXaI6IbuokuNfdvmasFv/rtyYq2+XzQXNe3A1LJcMnAE6X/8dCdYjs0
         co8QwfC3omuZdZ3TDGwfhIKMZ2mRCK5wWno0E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sVR9Vb4R3YNyl8BUOPHylCL5AwGFXPKzpdpN3YK2NSs=;
        b=Qi6teSM9qO+jDi1EerF/7RsSkSXjldztM8tC43R0QN5hwv+7VAn1/FqU1EwhxLIOsh
         JfkfNw+Ckk+6tuBT9cgzBZwbciU2s86zquvADVQk492WSkckL7k1YlkdvQWWDnUFbD3i
         gZLwQmsQM5MhECZkkT+PHwaxtP4b4rRhwG7NL1agch7DTg2oQEv03UzuJgbhMsmcxFJa
         pp6Qk9CdJonTztoVf0reWGjpfBj9mHSgcIkZ6jSpbCvDI5YReLdRJ6mB1afMHAdwC49z
         1lE7CeJyctcsAGHMdl//ItUNL+n8hi/s2VULtyTExjOtQ51yE8YZdepgRufA7eDTouP9
         0DhA==
X-Gm-Message-State: AOAM5335Fk2H9wR9SDAZvTGIgbRHd1HOPT6G5x1byNoAAWmiZpOEVQov
        8al+nfZnnKFuntPMQtnCtGfOzg==
X-Google-Smtp-Source: ABdhPJxlSSy9RxtXJFzD7hbrCJ7Ygdy35XD49t16Twl+/5tprqpPrs711fkwsdlgTW9P97QJhPKbFQ==
X-Received: by 2002:a63:5003:: with SMTP id e3mr3128100pgb.274.1599858445949;
        Fri, 11 Sep 2020 14:07:25 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:7220:84ff:fe09:2b94])
        by smtp.gmail.com with ESMTPSA id c128sm3308764pfb.126.2020.09.11.14.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 14:07:25 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 3/3] Bluetooth: Emit controller suspend and resume events
Date:   Fri, 11 Sep 2020 14:07:13 -0700
Message-Id: <20200911140700.v2.3.I905caec7d7bf0eb7a3ed9899b5afb9aebaf6f8a8@changeid>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200911210713.4066465-1-abhishekpandit@chromium.org>
References: <20200911210713.4066465-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Emit controller suspend and resume events when we are ready for suspend
and we've resumed from suspend.

The controller suspend event will report whatever suspend state was
successfully entered. The controller resume event will check the first
HCI event that was received after we finished preparing for suspend and,
if it was a connection event, store the address of the peer that caused
the event. If it was not a connection event, we mark the wake reason as
an unexpected event.

Here is a sample btmon trace with these events:

@ MGMT Event: Controller Suspended (0x002d) plen 1
        Suspend state: Page scanning and/or passive scanning (2)

@ MGMT Event: Controller Resumed (0x002e) plen 8
        Wake reason: Remote wake due to peer device connection (2)
        LE Address: CD:F3:CD:13:C5:9A (OUI CD-F3-CD)

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
---

Changes in v2: None

 include/net/bluetooth/hci_core.h |  3 ++
 include/net/bluetooth/mgmt.h     |  4 ++
 net/bluetooth/hci_core.c         | 26 +++++++++++-
 net/bluetooth/hci_event.c        | 73 ++++++++++++++++++++++++++++++++
 4 files changed, 105 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 02a6ee056b2374..9873e1c8cd163b 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -484,6 +484,9 @@ struct hci_dev {
 	enum suspended_state	suspend_state;
 	bool			scanning_paused;
 	bool			suspended;
+	u8			wake_reason;
+	bdaddr_t		wake_addr;
+	u8			wake_addr_type;
 
 	wait_queue_head_t	suspend_wait_q;
 	DECLARE_BITMAP(suspend_tasks, __SUSPEND_NUM_TASKS);
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index a4b8935e0db97a..6b55155e05e977 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -1042,3 +1042,7 @@ struct mgmt_ev_controller_resume {
 	__u8	wake_reason;
 	struct mgmt_addr_info addr;
 } __packed;
+
+#define MGMT_WAKE_REASON_NON_BT_WAKE		0x0
+#define MGMT_WAKE_REASON_UNEXPECTED		0x1
+#define MGMT_WAKE_REASON_REMOTE_WAKE		0x2
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index ef32b12f150cd1..8a2645a8330137 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3497,12 +3497,24 @@ static int hci_change_suspend_state(struct hci_dev *hdev,
 	return hci_suspend_wait_event(hdev);
 }
 
+static void hci_clear_wake_reason(struct hci_dev *hdev)
+{
+	hci_dev_lock(hdev);
+
+	hdev->wake_reason = 0;
+	bacpy(&hdev->wake_addr, BDADDR_ANY);
+	hdev->wake_addr_type = 0;
+
+	hci_dev_unlock(hdev);
+}
+
 static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 				void *data)
 {
 	struct hci_dev *hdev =
 		container_of(nb, struct hci_dev, suspend_notifier);
 	int ret = 0;
+	u8 state = BT_RUNNING;
 
 	/* If powering down, wait for completion. */
 	if (mgmt_powering_down(hdev)) {
@@ -3523,15 +3535,27 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 		 *  - Second, program event filter/whitelist and enable scan
 		 */
 		ret = hci_change_suspend_state(hdev, BT_SUSPEND_DISCONNECT);
+		if (!ret)
+			state = BT_SUSPEND_DISCONNECT;
 
 		/* Only configure whitelist if disconnect succeeded and wake
 		 * isn't being prevented.
 		 */
-		if (!ret && !(hdev->prevent_wake && hdev->prevent_wake(hdev)))
+		if (!ret && !(hdev->prevent_wake && hdev->prevent_wake(hdev))) {
 			ret = hci_change_suspend_state(hdev,
 						BT_SUSPEND_CONFIGURE_WAKE);
+			if (!ret)
+				state = BT_SUSPEND_CONFIGURE_WAKE;
+		}
+
+		hci_clear_wake_reason(hdev);
+		mgmt_suspending(hdev, state);
+
 	} else if (action == PM_POST_SUSPEND) {
 		ret = hci_change_suspend_state(hdev, BT_RUNNING);
+
+		mgmt_resuming(hdev, hdev->wake_reason, &hdev->wake_addr,
+			      hdev->wake_addr_type);
 	}
 
 done:
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 33d8458fdd4adc..a68be50097ac35 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6000,6 +6000,76 @@ static bool hci_get_cmd_complete(struct hci_dev *hdev, u16 opcode,
 	return true;
 }
 
+static void hci_store_wake_reason(struct hci_dev *hdev, u8 event,
+				  struct sk_buff *skb)
+{
+	struct hci_ev_le_advertising_info *adv;
+	struct hci_ev_le_direct_adv_info *direct_adv;
+	struct hci_ev_le_ext_adv_report *ext_adv;
+	const struct hci_ev_conn_complete *conn_complete = (void *)skb->data;
+	const struct hci_ev_conn_request *conn_request = (void *)skb->data;
+
+	hci_dev_lock(hdev);
+
+	/* If we are currently suspended and this is the first BT event seen,
+	 * save the wake reason associated with the event.
+	 */
+	if (!hdev->suspended || hdev->wake_reason)
+		goto unlock;
+
+	/* Default to remote wake. Values for wake_reason are documented in the
+	 * Bluez mgmt api docs.
+	 */
+	hdev->wake_reason = MGMT_WAKE_REASON_REMOTE_WAKE;
+
+	/* Once configured for remote wakeup, we should only wake up for
+	 * reconnections. It's useful to see which device is waking us up so
+	 * keep track of the bdaddr of the connection event that woke us up.
+	 */
+	if (event == HCI_EV_CONN_REQUEST) {
+		bacpy(&hdev->wake_addr, &conn_complete->bdaddr);
+		hdev->wake_addr_type = BDADDR_BREDR;
+	} else if (event == HCI_EV_CONN_COMPLETE) {
+		bacpy(&hdev->wake_addr, &conn_request->bdaddr);
+		hdev->wake_addr_type = BDADDR_BREDR;
+	} else if (event == HCI_EV_LE_META) {
+		struct hci_ev_le_meta *le_ev = (void *)skb->data;
+		u8 subevent = le_ev->subevent;
+		u8 *ptr = &skb->data[sizeof(*le_ev)];
+		u8 num_reports = *ptr;
+
+		if ((subevent == HCI_EV_LE_ADVERTISING_REPORT ||
+		     subevent == HCI_EV_LE_DIRECT_ADV_REPORT ||
+		     subevent == HCI_EV_LE_EXT_ADV_REPORT) &&
+		    num_reports) {
+			adv = (void *)(ptr + 1);
+			direct_adv = (void *)(ptr + 1);
+			ext_adv = (void *)(ptr + 1);
+
+			switch (subevent) {
+			case HCI_EV_LE_ADVERTISING_REPORT:
+				bacpy(&hdev->wake_addr, &adv->bdaddr);
+				hdev->wake_addr_type = adv->bdaddr_type;
+				break;
+
+			case HCI_EV_LE_DIRECT_ADV_REPORT:
+				bacpy(&hdev->wake_addr, &direct_adv->bdaddr);
+				hdev->wake_addr_type = direct_adv->bdaddr_type;
+				break;
+			case HCI_EV_LE_EXT_ADV_REPORT:
+				bacpy(&hdev->wake_addr, &ext_adv->bdaddr);
+				hdev->wake_addr_type = ext_adv->bdaddr_type;
+				break;
+			}
+		}
+	} else {
+		hdev->wake_reason = MGMT_WAKE_REASON_UNEXPECTED;
+	}
+
+unlock:
+	hci_dev_unlock(hdev);
+}
+
 void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct hci_event_hdr *hdr = (void *) skb->data;
@@ -6033,6 +6103,9 @@ void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
 
 	skb_pull(skb, HCI_EVENT_HDR_SIZE);
 
+	/* Store wake reason if we're suspended */
+	hci_store_wake_reason(hdev, event, skb);
+
 	switch (event) {
 	case HCI_EV_INQUIRY_COMPLETE:
 		hci_inquiry_complete_evt(hdev, skb);
-- 
2.28.0.618.gf4bc123cb7-goog

