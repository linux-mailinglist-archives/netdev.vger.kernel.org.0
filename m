Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B12A36EED9
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 19:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240974AbhD2RZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 13:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240955AbhD2RZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 13:25:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A57C06138D
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 10:24:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i201-20020a25d1d20000b02904ed4c01f82bso24534421ybg.20
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 10:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=sdjIWOwBuZx76GTYNbCd/NjUaSb8FhKvrsi/7M+KqDM=;
        b=C5FXEyOJsaXx+GdPGUIFOM8qU28pjjXCcDf092OTs2jHcmcmSbaI9avVw+RhRrjISr
         7vY25y9TkxwLFNyftNWRv3+tpJK6eslnesLc/ycwyjhHY40ZyCFCpWfhMpW6654tJHdJ
         D7Ll9YgYt+QTat2njidADFqwe2kF9WGIzdNb0Atmr1ZwkNEb72jhmYN4eDQtS7MQdGe5
         Wlv3bC8Y47u4kUxfGbSauFDwKoHn8zt67oCqKVEYlPyZoiD1rgiaP4fh1l509YoAxuzz
         VH1pWiMXSnKXLYOuA4+0u02NtDP+31Ile5IBtFQz+arVoQx52tDzhnkBuNUSh9N/7hKk
         nuOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=sdjIWOwBuZx76GTYNbCd/NjUaSb8FhKvrsi/7M+KqDM=;
        b=SOB+T/YsJrWNgKAmVPhKOnUVfVVq5r16GXlJkkox1bzN0O6Es1AEoYfpX1absJuDwr
         hQa+/C/YkYGl7sR3/Mc4u1iYo0fG5yXpfiOFjQ31PIVhgXt+b3MYnvL6+O6PBXfATKnN
         AyGfkYsVriw/AMYgeVnAkcuAqcU0pMEs8fawXNYGSBGA4mcSIGv3hv2ekdjUwZa5BiXF
         N/JFwGrBVRl5kE7gjMR320YV3axQ3+nWYEvOIIV8+Wq4ybd0Atz7UawrqxLWbHXA8LNJ
         7ZXB8VgUNDEjZbZ9ytgwsxNi5dYN52Km5jzqd8O+pE9kwyugn3gBofIon5C8b/dKwUe9
         iaMQ==
X-Gm-Message-State: AOAM530K1LhqsI7UC21w+tElLIGlqDzS80aM8X/ReS+qDp7KDgD1R6Pq
        j2CYhmxd8/3N/PFSJuUK8nr7K6ktwGX1ug==
X-Google-Smtp-Source: ABdhPJx7+GgKYUuTDuDMiGz/vs8l6iGhQG0hKqP2slynBXO3V1KqpOmGbu0bUPo7Dw1G/l17oGQkanvSDZ9xfw==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:56d:80fa:27b1:f5e7])
 (user=mmandlik job=sendgmr) by 2002:a5b:105:: with SMTP id
 5mr891831ybx.452.1619717066011; Thu, 29 Apr 2021 10:24:26 -0700 (PDT)
Date:   Thu, 29 Apr 2021 10:24:22 -0700
Message-Id: <20210429102415.v4.1.I14da3750a343d8d48921fffb7c6561337b6e6082@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v4] Bluetooth: Add ncmd=0 recovery handling
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Alain Michaud <alainm@chromium.org>,
        Manish Mandlik <mmandlik@google.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During command status or command complete event, the controller may set
ncmd=0 indicating that it is not accepting any more commands. In such a
case, host holds off sending any more commands to the controller. If the
controller doesn't recover from such condition, host will wait forever,
until the user decides that the Bluetooth is broken and may power cycles
the Bluetooth.

This patch triggers the hardware error to reset the controller and
driver when it gets into such state as there is no other wat out.

Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Manish Mandlik <mmandlik@google.com>
---

Changes in v4:
- Update comment in hci_ncmd_timeout
- Add a new inline function to handle cmd_cnt and timers

Changes in v3:
- Restructure ncmd_timer scheduling in hci_event.c
- Cancel delayed work in hci_dev_do_close
- Do not inject hw error during HCI_INIT
- Update comment, add log message while injecting hw error

Changes in v2:
- Emit the hardware error when ncmd=0 occurs

 include/net/bluetooth/hci.h      |  1 +
 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_core.c         | 22 ++++++++++++++++++++++
 net/bluetooth/hci_event.c        | 29 +++++++++++++++++++----------
 4 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index ea4ae551c426..c4b0650fb9ae 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -339,6 +339,7 @@ enum {
 #define HCI_PAIRING_TIMEOUT	msecs_to_jiffies(60000)	/* 60 seconds */
 #define HCI_INIT_TIMEOUT	msecs_to_jiffies(10000)	/* 10 seconds */
 #define HCI_CMD_TIMEOUT		msecs_to_jiffies(2000)	/* 2 seconds */
+#define HCI_NCMD_TIMEOUT	msecs_to_jiffies(4000)	/* 4 seconds */
 #define HCI_ACL_TX_TIMEOUT	msecs_to_jiffies(45000)	/* 45 seconds */
 #define HCI_AUTO_OFF_TIMEOUT	msecs_to_jiffies(2000)	/* 2 seconds */
 #define HCI_POWER_OFF_TIMEOUT	msecs_to_jiffies(5000)	/* 5 seconds */
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index ebdd4afe30d2..f14692b39fd5 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -470,6 +470,7 @@ struct hci_dev {
 	struct delayed_work	service_cache;
 
 	struct delayed_work	cmd_timer;
+	struct delayed_work	ncmd_timer;
 
 	struct work_struct	rx_work;
 	struct work_struct	cmd_work;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index b0d9c36acc03..e8b492ffb207 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1723,6 +1723,7 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	}
 
 	cancel_delayed_work(&hdev->power_off);
+	cancel_delayed_work(&hdev->ncmd_timer);
 
 	hci_request_cancel_all(hdev);
 	hci_req_sync_lock(hdev);
@@ -2769,6 +2770,24 @@ static void hci_cmd_timeout(struct work_struct *work)
 	queue_work(hdev->workqueue, &hdev->cmd_work);
 }
 
+/* HCI ncmd timer function */
+static void hci_ncmd_timeout(struct work_struct *work)
+{
+	struct hci_dev *hdev = container_of(work, struct hci_dev,
+					    ncmd_timer.work);
+
+	bt_dev_err(hdev, "Controller not accepting commands anymore: ncmd = 0");
+
+	/* During HCI_INIT phase no events can be injected if the ncmd timer
+	 * triggers since the procedure has its own timeout handling.
+	 */
+	if (test_bit(HCI_INIT, &hdev->flags))
+		return;
+
+	/* This is an irrecoverable state, inject hardware error event */
+	hci_reset_dev(hdev);
+}
+
 struct oob_data *hci_find_remote_oob_data(struct hci_dev *hdev,
 					  bdaddr_t *bdaddr, u8 bdaddr_type)
 {
@@ -3831,6 +3850,7 @@ struct hci_dev *hci_alloc_dev(void)
 	init_waitqueue_head(&hdev->suspend_wait_q);
 
 	INIT_DELAYED_WORK(&hdev->cmd_timer, hci_cmd_timeout);
+	INIT_DELAYED_WORK(&hdev->ncmd_timer, hci_ncmd_timeout);
 
 	hci_request_setup(hdev);
 
@@ -4068,6 +4088,8 @@ int hci_reset_dev(struct hci_dev *hdev)
 	hci_skb_pkt_type(skb) = HCI_EVENT_PKT;
 	skb_put_data(skb, hw_err, 3);
 
+	bt_dev_err(hdev, "Injecting HCI hardware error event");
+
 	/* Send Hardware Error to upper stack */
 	return hci_recv_frame(hdev, skb);
 }
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index cf2f4a0abdbd..479fdcb437e4 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3270,6 +3270,23 @@ static void hci_remote_features_evt(struct hci_dev *hdev,
 	hci_dev_unlock(hdev);
 }
 
+static inline void handle_cmd_cnt_and_timer(struct hci_dev *hdev,
+					    u16 opcode, u8 ncmd)
+{
+	if (opcode != HCI_OP_NOP)
+		cancel_delayed_work(&hdev->cmd_timer);
+
+	if (!test_bit(HCI_RESET, &hdev->flags)) {
+		if (ncmd) {
+			cancel_delayed_work(&hdev->ncmd_timer);
+			atomic_set(&hdev->cmd_cnt, 1);
+		} else {
+			schedule_delayed_work(&hdev->ncmd_timer,
+					      HCI_NCMD_TIMEOUT);
+		}
+	}
+}
+
 static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
 				 u16 *opcode, u8 *status,
 				 hci_req_complete_t *req_complete,
@@ -3632,11 +3649,7 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
 		break;
 	}
 
-	if (*opcode != HCI_OP_NOP)
-		cancel_delayed_work(&hdev->cmd_timer);
-
-	if (ev->ncmd && !test_bit(HCI_RESET, &hdev->flags))
-		atomic_set(&hdev->cmd_cnt, 1);
+	handle_cmd_cnt_and_timer(hdev, *opcode, ev->ncmd);
 
 	hci_req_cmd_complete(hdev, *opcode, *status, req_complete,
 			     req_complete_skb);
@@ -3737,11 +3750,7 @@ static void hci_cmd_status_evt(struct hci_dev *hdev, struct sk_buff *skb,
 		break;
 	}
 
-	if (*opcode != HCI_OP_NOP)
-		cancel_delayed_work(&hdev->cmd_timer);
-
-	if (ev->ncmd && !test_bit(HCI_RESET, &hdev->flags))
-		atomic_set(&hdev->cmd_cnt, 1);
+	handle_cmd_cnt_and_timer(hdev, *opcode, ev->ncmd);
 
 	/* Indicate request completion if the command failed. Also, if
 	 * we're not waiting for a special event and we get a success
-- 
2.31.1.527.g47e6f16901-goog

