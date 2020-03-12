Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 417FA18384C
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgCLSLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:11:05 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52709 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbgCLSLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:11:04 -0400
Received: by mail-pj1-f67.google.com with SMTP id f15so2873348pjq.2
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 11:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1jkZ7AJWeJX31pPItMtQ3M7DJKtphTFHpNhNX7Qly0U=;
        b=QoAb6gFKX7EfE1bIK+nwkeGcKII1LO23g2lG+2k9ljWhdBxBLx+6Krl+oiCa7RY6o0
         R3Bbn1pcxNUThhpZQb/I32tuTg7DwkutwXkw3C4aEAeYT1JyEpULlM0IvYXniJNOt0SM
         BiaSTyTiDsmdVoKDEZXNdp9xJMQn9nre+Smuo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1jkZ7AJWeJX31pPItMtQ3M7DJKtphTFHpNhNX7Qly0U=;
        b=ZfBpqUxevEDY196tRqcEbFpXhdEchEgi3IR7LNB7LY6RZ1swTVa01h8A5Fe7ibKKrn
         e6g8Bh56Ftqz5BFs4xzxqyS34OigSvYbpnTcpLJVyH7yQ/WV7ARD3GrWIKgfEn+Ha3Xi
         k2FbdsiUX769QTC299UIIwcw7gqiVfZsnMYpwKdBeHRzQgkg7mS76XHcrs0qQiDE7l9i
         MzBxAbtIy2aNYZkq8VO3C48o7zq821OWcSzYauLZq0WDLJ/ANBpdV7h+F/6W+11De8qC
         gixAHINpBX95mnxXjNU62KhhtsPOeouyfsZf4eIGgiyW4zuwlQ/skViokiVmm6PMfri9
         B/vQ==
X-Gm-Message-State: ANhLgQ0t5ZdWGmBhYdlJIM/rEvJkr72H6jfLvF74rQ9U1qwq8LTi9pUF
        sdYlCgy7rn34EiLYhBy9PXl1PQ==
X-Google-Smtp-Source: ADFU+vsw3NahFCEBMGteIDtAocT6JndFQtFXaZTMSfXyJ7YszBfVl6Cp8D1TwzxJuXr/PNcj+vWU4g==
X-Received: by 2002:a17:902:ba83:: with SMTP id k3mr8898506pls.26.1584036662845;
        Thu, 12 Mar 2020 11:11:02 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id b18sm56787876pfd.63.2020.03.12.11.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 11:11:02 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 1/1] Bluetooth: Prioritize SCO traffic on slow interfaces
Date:   Thu, 12 Mar 2020 11:10:55 -0700
Message-Id: <20200312111036.1.I17e2220fd0c0822c76a15ef89b882fb4cfe3fe89@changeid>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200312181055.94038-1-abhishekpandit@chromium.org>
References: <20200312181055.94038-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When scheduling TX packets, send all SCO/eSCO packets first and then
send only 1 ACL/LE packet in a loop while checking that there are no SCO
packets pending. This is done to make sure that we can meet SCO
deadlines on slow interfaces like UART. If we were to queue up multiple
ACL packets without checking for a SCO packet, we might miss the SCO
timing. For example:

The time it takes to send a maximum size ACL packet (1024 bytes):
t = 10/8 * 1024 bytes * 8 bits/byte * 1 packet / baudrate
        where 10/8 is uart overhead due to start/stop bits per byte

Replace t = 3.75ms (SCO deadline), which gives us a baudrate of 2730666
and is pretty close to a common baudrate of 3000000 used for BT. At this
baudrate, if we sent two 1024 byte ACL packets, we would miss the 3.75ms
timing window.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_core.c         | 91 +++++++++++++++++++++++++-------
 2 files changed, 73 insertions(+), 19 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index d4e28773d378..f636c89f1fe1 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -315,6 +315,7 @@ struct hci_dev {
 	__u8		ssp_debug_mode;
 	__u8		hw_error_code;
 	__u32		clock;
+	__u8		sched_limit;
 
 	__u16		devid_source;
 	__u16		devid_vendor;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index dbd2ad3a26ed..00a72265cd96 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4239,18 +4239,32 @@ static void __check_timeout(struct hci_dev *hdev, unsigned int cnt)
 	}
 }
 
-static void hci_sched_acl_pkt(struct hci_dev *hdev)
+/* Limit packets in flight when SCO/eSCO links are active. */
+static bool hci_sched_limit(struct hci_dev *hdev)
+{
+	return hdev->sched_limit && hci_conn_num(hdev, SCO_LINK);
+}
+
+static bool hci_sched_acl_pkt(struct hci_dev *hdev)
 {
 	unsigned int cnt = hdev->acl_cnt;
 	struct hci_chan *chan;
 	struct sk_buff *skb;
 	int quote;
+	bool sched_limit = hci_sched_limit(hdev);
+	bool resched = false;
 
 	__check_timeout(hdev, cnt);
 
 	while (hdev->acl_cnt &&
 	       (chan = hci_chan_sent(hdev, ACL_LINK, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
+
+		if (sched_limit && quote > 0) {
+			resched = true;
+			quote = 1;
+		}
+
 		while (quote-- && (skb = skb_peek(&chan->data_q))) {
 			BT_DBG("chan %p skb %p len %d priority %u", chan, skb,
 			       skb->len, skb->priority);
@@ -4271,19 +4285,26 @@ static void hci_sched_acl_pkt(struct hci_dev *hdev)
 			chan->sent++;
 			chan->conn->sent++;
 		}
+
+		if (resched && cnt != hdev->acl_cnt)
+			break;
 	}
 
-	if (cnt != hdev->acl_cnt)
+	if (hdev->acl_cnt == 0 && cnt != hdev->acl_cnt)
 		hci_prio_recalculate(hdev, ACL_LINK);
+
+	return resched;
 }
 
-static void hci_sched_acl_blk(struct hci_dev *hdev)
+static bool hci_sched_acl_blk(struct hci_dev *hdev)
 {
 	unsigned int cnt = hdev->block_cnt;
 	struct hci_chan *chan;
 	struct sk_buff *skb;
 	int quote;
 	u8 type;
+	bool sched_limit = hci_sched_limit(hdev);
+	bool resched = false;
 
 	__check_timeout(hdev, cnt);
 
@@ -4297,6 +4318,12 @@ static void hci_sched_acl_blk(struct hci_dev *hdev)
 	while (hdev->block_cnt > 0 &&
 	       (chan = hci_chan_sent(hdev, type, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
+
+		if (sched_limit && quote > 0) {
+			resched = true;
+			quote = 1;
+		}
+
 		while (quote > 0 && (skb = skb_peek(&chan->data_q))) {
 			int blocks;
 
@@ -4311,7 +4338,7 @@ static void hci_sched_acl_blk(struct hci_dev *hdev)
 
 			blocks = __get_blocks(hdev, skb);
 			if (blocks > hdev->block_cnt)
-				return;
+				return false;
 
 			hci_conn_enter_active_mode(chan->conn,
 						   bt_cb(skb)->force_active);
@@ -4325,33 +4352,39 @@ static void hci_sched_acl_blk(struct hci_dev *hdev)
 			chan->sent += blocks;
 			chan->conn->sent += blocks;
 		}
+
+		if (resched && cnt != hdev->block_cnt)
+			break;
 	}
 
-	if (cnt != hdev->block_cnt)
+	if (hdev->block_cnt == 0 && cnt != hdev->block_cnt)
 		hci_prio_recalculate(hdev, type);
+
+	return resched;
 }
 
-static void hci_sched_acl(struct hci_dev *hdev)
+static bool hci_sched_acl(struct hci_dev *hdev)
 {
 	BT_DBG("%s", hdev->name);
 
 	/* No ACL link over BR/EDR controller */
 	if (!hci_conn_num(hdev, ACL_LINK) && hdev->dev_type == HCI_PRIMARY)
-		return;
+		goto done;
 
 	/* No AMP link over AMP controller */
 	if (!hci_conn_num(hdev, AMP_LINK) && hdev->dev_type == HCI_AMP)
-		return;
+		goto done;
 
 	switch (hdev->flow_ctl_mode) {
 	case HCI_FLOW_CTL_MODE_PACKET_BASED:
-		hci_sched_acl_pkt(hdev);
-		break;
+		return hci_sched_acl_pkt(hdev);
 
 	case HCI_FLOW_CTL_MODE_BLOCK_BASED:
-		hci_sched_acl_blk(hdev);
-		break;
+		return hci_sched_acl_blk(hdev);
 	}
+
+done:
+	return false;
 }
 
 /* Schedule SCO */
@@ -4402,16 +4435,18 @@ static void hci_sched_esco(struct hci_dev *hdev)
 	}
 }
 
-static void hci_sched_le(struct hci_dev *hdev)
+static bool hci_sched_le(struct hci_dev *hdev)
 {
 	struct hci_chan *chan;
 	struct sk_buff *skb;
 	int quote, cnt, tmp;
+	bool sched_limit = hci_sched_limit(hdev);
+	bool resched = false;
 
 	BT_DBG("%s", hdev->name);
 
 	if (!hci_conn_num(hdev, LE_LINK))
-		return;
+		return resched;
 
 	cnt = hdev->le_pkts ? hdev->le_cnt : hdev->acl_cnt;
 
@@ -4420,6 +4455,12 @@ static void hci_sched_le(struct hci_dev *hdev)
 	tmp = cnt;
 	while (cnt && (chan = hci_chan_sent(hdev, LE_LINK, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
+
+		if (sched_limit && quote > 0) {
+			resched = true;
+			quote = 1;
+		}
+
 		while (quote-- && (skb = skb_peek(&chan->data_q))) {
 			BT_DBG("chan %p skb %p len %d priority %u", chan, skb,
 			       skb->len, skb->priority);
@@ -4437,6 +4478,9 @@ static void hci_sched_le(struct hci_dev *hdev)
 			chan->sent++;
 			chan->conn->sent++;
 		}
+
+		if (resched && cnt != tmp)
+			break;
 	}
 
 	if (hdev->le_pkts)
@@ -4444,24 +4488,33 @@ static void hci_sched_le(struct hci_dev *hdev)
 	else
 		hdev->acl_cnt = cnt;
 
-	if (cnt != tmp)
+	if (cnt == 0 && cnt != tmp)
 		hci_prio_recalculate(hdev, LE_LINK);
+
+	return resched;
 }
 
 static void hci_tx_work(struct work_struct *work)
 {
 	struct hci_dev *hdev = container_of(work, struct hci_dev, tx_work);
 	struct sk_buff *skb;
+	bool resched;
 
 	BT_DBG("%s acl %d sco %d le %d", hdev->name, hdev->acl_cnt,
 	       hdev->sco_cnt, hdev->le_cnt);
 
 	if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
 		/* Schedule queues and send stuff to HCI driver */
-		hci_sched_acl(hdev);
-		hci_sched_sco(hdev);
-		hci_sched_esco(hdev);
-		hci_sched_le(hdev);
+		do {
+			/* SCO and eSCO send all packets until emptied */
+			hci_sched_sco(hdev);
+			hci_sched_esco(hdev);
+
+			/* Acl and Le send based on quota (priority on ACL per
+			 * loop)
+			 */
+			resched = hci_sched_acl(hdev) || hci_sched_le(hdev);
+		} while (resched);
 	}
 
 	/* Send next queued raw (unknown type) packet */
-- 
2.25.1.481.gfbce0eb801-goog

