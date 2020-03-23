Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE6618FDF9
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 20:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgCWTpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 15:45:17 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35902 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgCWTpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 15:45:16 -0400
Received: by mail-pj1-f66.google.com with SMTP id nu11so323729pjb.1
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 12:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gz4rDOjXchjqPi1nEVVmXK3+btJI8g3SNGoz9O5jtbU=;
        b=FQCzKzSnrYYmQWC2CSbKEn/Y+a4mEjYl0yrAbXpAW6bEpGUFofnjCIVRVNdfJ6grza
         6NQAXeuDPyK+Lgcqz9xjCE+OjQeoi/IKhLMIn8k369vrvYlj3lEoYjsp7iQnSDAYAbwk
         qgOBdQop3YcOTsD60DA2yneHrqsE2QnNHNaJs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gz4rDOjXchjqPi1nEVVmXK3+btJI8g3SNGoz9O5jtbU=;
        b=n/pTQNDNo6GG7OaMZcSw7bvKUlNharUJwvmroyfSHVNUNMQ2pARI962KCuCI8g4I8r
         LrmqvrzaNqDqk9Y86WUiwJBF3unX6AtxnDvKPH1fzaJYFylv7ZK7VZhiORffpaGM8L6g
         SQnXA5k8JlLY2bscUrVoqBki8OffOGoT8utt5ABs76Hlf+6EphKuvAQL7QLkkgiqktff
         wCfl7t7la6cB32a9F6Kp2nWbuqV1/Udv7OwqhUWZ85Db+utzIk6Rf3erX3MmQza/Vz9I
         yJeHU4yDtbcfOLbV5FREk2aSqNAJOickE2uqwzS6Mwg91xf4K3s7SRqXEz+SoKClZxRx
         dmFw==
X-Gm-Message-State: ANhLgQ1xaqrBV3f62IMw+3HYdWOOWsa6ivCCn9lZYNoWliUIKj2c2Gxk
        m8pX0o/zh+eBJRlokV5uWZKwdA==
X-Google-Smtp-Source: ADFU+vtgxL11HS2OubBV8XWWkYQpV6F4ZBoCjXnruDl0thaI8CAUmp203GJx1kAPo9hxrSPL2dkAyw==
X-Received: by 2002:a17:90a:3188:: with SMTP id j8mr1058249pjb.82.1584992714874;
        Mon, 23 Mar 2020 12:45:14 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id s98sm344857pjb.46.2020.03.23.12.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 12:45:14 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v3 1/1] Bluetooth: Prioritize SCO traffic
Date:   Mon, 23 Mar 2020 12:45:07 -0700
Message-Id: <20200323124503.v3.1.I17e2220fd0c0822c76a15ef89b882fb4cfe3fe89@changeid>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
In-Reply-To: <20200323194507.90944-1-abhishekpandit@chromium.org>
References: <20200323194507.90944-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When scheduling TX packets, send all SCO/eSCO packets first, check for
pending SCO/eSCO packets after every ACL/LE packet and send them if any
are pending.  This is done to make sure that we can meet SCO deadlines
on slow interfaces like UART.

If we were to queue up multiple ACL packets without checking for a SCO
packet, we might miss the SCO timing. For example:

The time it takes to send a maximum size ACL packet (1024 bytes):
t = 10/8 * 1024 bytes * 8 bits/byte * 1 packet / baudrate
        where 10/8 is uart overhead due to start/stop bits per byte

Replace t = 3.75ms (SCO deadline), which gives us a baudrate of 2730666.

At a baudrate of 3000000, if we didn't check for SCO packets within 1024
bytes, we would miss the 3.75ms timing window.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

Changes in v3:
* Removed hci_sched_sync

Changes in v2:
* Refactor to check for SCO/eSCO after each ACL/LE packet sent
* Enabled SCO priority all the time and removed the sched_limit variable

 net/bluetooth/hci_core.c | 106 +++++++++++++++++++++------------------
 1 file changed, 57 insertions(+), 49 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index dbd2ad3a26ed..9e5d7662a047 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4239,6 +4239,54 @@ static void __check_timeout(struct hci_dev *hdev, unsigned int cnt)
 	}
 }
 
+/* Schedule SCO */
+static void hci_sched_sco(struct hci_dev *hdev)
+{
+	struct hci_conn *conn;
+	struct sk_buff *skb;
+	int quote;
+
+	BT_DBG("%s", hdev->name);
+
+	if (!hci_conn_num(hdev, SCO_LINK))
+		return;
+
+	while (hdev->sco_cnt && (conn = hci_low_sent(hdev, SCO_LINK, &quote))) {
+		while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
+			BT_DBG("skb %p len %d", skb, skb->len);
+			hci_send_frame(hdev, skb);
+
+			conn->sent++;
+			if (conn->sent == ~0)
+				conn->sent = 0;
+		}
+	}
+}
+
+static void hci_sched_esco(struct hci_dev *hdev)
+{
+	struct hci_conn *conn;
+	struct sk_buff *skb;
+	int quote;
+
+	BT_DBG("%s", hdev->name);
+
+	if (!hci_conn_num(hdev, ESCO_LINK))
+		return;
+
+	while (hdev->sco_cnt && (conn = hci_low_sent(hdev, ESCO_LINK,
+						     &quote))) {
+		while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
+			BT_DBG("skb %p len %d", skb, skb->len);
+			hci_send_frame(hdev, skb);
+
+			conn->sent++;
+			if (conn->sent == ~0)
+				conn->sent = 0;
+		}
+	}
+}
+
 static void hci_sched_acl_pkt(struct hci_dev *hdev)
 {
 	unsigned int cnt = hdev->acl_cnt;
@@ -4270,6 +4318,10 @@ static void hci_sched_acl_pkt(struct hci_dev *hdev)
 			hdev->acl_cnt--;
 			chan->sent++;
 			chan->conn->sent++;
+
+			/* Send pending SCO packets right away */
+			hci_sched_sco(hdev);
+			hci_sched_esco(hdev);
 		}
 	}
 
@@ -4354,54 +4406,6 @@ static void hci_sched_acl(struct hci_dev *hdev)
 	}
 }
 
-/* Schedule SCO */
-static void hci_sched_sco(struct hci_dev *hdev)
-{
-	struct hci_conn *conn;
-	struct sk_buff *skb;
-	int quote;
-
-	BT_DBG("%s", hdev->name);
-
-	if (!hci_conn_num(hdev, SCO_LINK))
-		return;
-
-	while (hdev->sco_cnt && (conn = hci_low_sent(hdev, SCO_LINK, &quote))) {
-		while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
-			BT_DBG("skb %p len %d", skb, skb->len);
-			hci_send_frame(hdev, skb);
-
-			conn->sent++;
-			if (conn->sent == ~0)
-				conn->sent = 0;
-		}
-	}
-}
-
-static void hci_sched_esco(struct hci_dev *hdev)
-{
-	struct hci_conn *conn;
-	struct sk_buff *skb;
-	int quote;
-
-	BT_DBG("%s", hdev->name);
-
-	if (!hci_conn_num(hdev, ESCO_LINK))
-		return;
-
-	while (hdev->sco_cnt && (conn = hci_low_sent(hdev, ESCO_LINK,
-						     &quote))) {
-		while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
-			BT_DBG("skb %p len %d", skb, skb->len);
-			hci_send_frame(hdev, skb);
-
-			conn->sent++;
-			if (conn->sent == ~0)
-				conn->sent = 0;
-		}
-	}
-}
-
 static void hci_sched_le(struct hci_dev *hdev)
 {
 	struct hci_chan *chan;
@@ -4436,6 +4440,10 @@ static void hci_sched_le(struct hci_dev *hdev)
 			cnt--;
 			chan->sent++;
 			chan->conn->sent++;
+
+			/* Send pending SCO packets right away */
+			hci_sched_sco(hdev);
+			hci_sched_esco(hdev);
 		}
 	}
 
@@ -4458,9 +4466,9 @@ static void hci_tx_work(struct work_struct *work)
 
 	if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
 		/* Schedule queues and send stuff to HCI driver */
-		hci_sched_acl(hdev);
 		hci_sched_sco(hdev);
 		hci_sched_esco(hdev);
+		hci_sched_acl(hdev);
 		hci_sched_le(hdev);
 	}
 
-- 
2.25.1.696.g5e7596f4ac-goog

