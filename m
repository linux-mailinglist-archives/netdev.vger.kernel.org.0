Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7582118DBAB
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 00:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbgCTXTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 19:19:38 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43753 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgCTXTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 19:19:37 -0400
Received: by mail-pl1-f194.google.com with SMTP id f8so3137285plt.10
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 16:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JBbo2a0i4CpeeOBbaJAqxpqZkTg0B0uov6ptYoUJLXE=;
        b=nTUt91ZEzn7KN+96nvAiwT5uJeEgtaFB6p/zLnXCPviaemLK3N6Rz9SbujG3zDvQxL
         i6iAKg68I+a+vYC5sGqSFLolNRnM+C9KLwK529/DTaVJH+grA8EA1PJP+20OGWW825rD
         yyIL+wuvLu/wj1YBafS8dlzz3teE8iQhI5ccE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JBbo2a0i4CpeeOBbaJAqxpqZkTg0B0uov6ptYoUJLXE=;
        b=BzLXgaCDQzb30YjlFPBlO0+wBIAMw0sfqmDT8Fgt8sjJN38OGzKDapzJ8seVCZAjj+
         +Az/r/9CLULjeV4tXz566gCFEJ5i8rGm+qUMNxcTxDYGn4xJtpA474DyUrH2PAjYBJHU
         CYK0dFymXvFrynrqbFr85TglLqc/pRMiBtOJpIaBTxvDfXuyw0lvB2KknXx1AykjD7nC
         ECb2DASbLJw6lpyhZCr/uL9sHsDQdB3Jn3p32i+G4R7J1PPc/z6kLUpd7Y/ExXfDay/t
         n9xpOFPVaHoQSn+jjIyybZmaKf9PZcOLm4Xx0BDopvb6SyKU1sZ1jfbH30K3Zsqnc95Y
         nEYA==
X-Gm-Message-State: ANhLgQ2ckRHupLgh4Qe6Oe+MuW5VjXm0fu7codzpub9MMXBjErziVWvg
        Jk68ii4xg14CHpAFxfZfYLeSrg==
X-Google-Smtp-Source: ADFU+vu36KI4hQQw1uYmd4xi1dI6lDNiSRM2UM3nk1wYDI7VYganw1JJLf3SF+zolVdWRJKZehzgFQ==
X-Received: by 2002:a17:902:9a45:: with SMTP id x5mr10286830plv.296.1584746376114;
        Fri, 20 Mar 2020 16:19:36 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id q26sm6530773pff.63.2020.03.20.16.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 16:19:35 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 1/1] Bluetooth: Prioritize SCO traffic
Date:   Fri, 20 Mar 2020 16:19:28 -0700
Message-Id: <20200320161922.v2.1.I17e2220fd0c0822c76a15ef89b882fb4cfe3fe89@changeid>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
In-Reply-To: <20200320231928.137720-1-abhishekpandit@chromium.org>
References: <20200320231928.137720-1-abhishekpandit@chromium.org>
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

Changes in v2:
* Refactor to check for SCO/eSCO after each ACL/LE packet sent
* Enabled SCO priority all the time and removed the sched_limit variable

 net/bluetooth/hci_core.c | 111 +++++++++++++++++++++------------------
 1 file changed, 61 insertions(+), 50 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index dbd2ad3a26ed..a29177e1a9d0 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4239,6 +4239,60 @@ static void __check_timeout(struct hci_dev *hdev, unsigned int cnt)
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
+static void hci_sched_sync(struct hci_dev *hdev)
+{
+	hci_sched_sco(hdev);
+	hci_sched_esco(hdev);
+}
+
 static void hci_sched_acl_pkt(struct hci_dev *hdev)
 {
 	unsigned int cnt = hdev->acl_cnt;
@@ -4270,6 +4324,9 @@ static void hci_sched_acl_pkt(struct hci_dev *hdev)
 			hdev->acl_cnt--;
 			chan->sent++;
 			chan->conn->sent++;
+
+			/* Send pending SCO packets right away */
+			hci_sched_sync(hdev);
 		}
 	}
 
@@ -4354,54 +4411,6 @@ static void hci_sched_acl(struct hci_dev *hdev)
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
@@ -4436,6 +4445,9 @@ static void hci_sched_le(struct hci_dev *hdev)
 			cnt--;
 			chan->sent++;
 			chan->conn->sent++;
+
+			/* Send pending SCO packets right away */
+			hci_sched_sync(hdev);
 		}
 	}
 
@@ -4458,9 +4470,8 @@ static void hci_tx_work(struct work_struct *work)
 
 	if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
 		/* Schedule queues and send stuff to HCI driver */
+		hci_sched_sync(hdev);
 		hci_sched_acl(hdev);
-		hci_sched_sco(hdev);
-		hci_sched_esco(hdev);
 		hci_sched_le(hdev);
 	}
 
-- 
2.25.1.696.g5e7596f4ac-goog

