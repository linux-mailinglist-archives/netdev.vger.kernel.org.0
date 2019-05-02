Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C600F1110D
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 04:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfEBCCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 22:02:22 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40153 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfEBCCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 22:02:22 -0400
Received: by mail-pl1-f193.google.com with SMTP id b3so273332plr.7;
        Wed, 01 May 2019 19:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n3dYpSr2wLyNBpaRIILn1VQ81Od2w4aatd1mSGJbDko=;
        b=bkp17jgf+JoMC+CQMSg3n7NO6QUPADlpQ1C4As2AXCdAMB9pm3xPMFrvIK9wk+RV32
         syk8dvutl09BHXMrkYvLBIvN8d9qUZr+pV/pQmnYHh9jXDrojvoF5XxQB6SIUloWscxD
         YoN1NPt6KI0zuz29WTRLAgzAQqfZG+QT8ucj0cKq6H+Ne4G+vm85XDcHKJUtqFIdy7IA
         fSj+5GF1apHpmTGXLMh28lM/WStm6EtTDeqXWpOz9sT+qsNEgEsWd1wSLSx8vZZ4zfyJ
         9MLvLXrsWMdOHvuub6Avn0as7KcUAn6gnjizZ8fHBIRqTAnLJj2DuLEyH4pW11gAYWAP
         GgmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n3dYpSr2wLyNBpaRIILn1VQ81Od2w4aatd1mSGJbDko=;
        b=JFkN8sEhR4+Va/dGmJbZsk5jC+xmL9zb+3NBSQA1iZkETHAPZzoEkuWYK/pUMwSBlB
         kwJiGQFDDKkN7n1f1DboJy/N24JZFuQM4z5s9YKLIod8G8kTsqZyUGKUcZsmrVSk/WcZ
         FwDVPICG5sUFA+5OzmGtLHaL/t8e49VtshiULkowLg8Bq1eO3NwTP/tGgdBVgrxe/n+z
         mdjCy8Jg7bQxL5s+X3w8mYU3R3TeQTC3ma5jlJTfaPEW7Q91ODGJhbIytqUNUd4hGHXG
         fuAX+fS1couXAGzCVZyysqI9j0AFsmMrheBkB5p4FuC+UA7u9N5CPljnc2Vgpdlmljrp
         s5fg==
X-Gm-Message-State: APjAAAWJCf2XOaeKjw+haD+i1D7lHUnkihKtule0I49gXVAxZ/56Hzu+
        cCPWOXvRcJNbCFTYsEh3zYXLF6/Wtx1aZQ==
X-Google-Smtp-Source: APXvYqwfCnovnUV0z8xKBDt7WZ8LZ9KD6puvhf0rUtYi5elzxuT6rBomUrgvSQqGNlYQ5zY4/i+QyA==
X-Received: by 2002:a17:902:263:: with SMTP id 90mr852952plc.257.1556762541512;
        Wed, 01 May 2019 19:02:21 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id t127sm13301152pfb.106.2019.05.01.19.02.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 19:02:20 -0700 (PDT)
From:   "=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?=" <jprvita@gmail.com>
X-Google-Original-From: =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     bgodavar@codeaurora.org, ytkim@qca.qualcomm.com,
        "David S . Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>
Subject: [PATCH v5] Bluetooth: Ignore CC events not matching the last HCI command
Date:   Thu,  2 May 2019 10:01:52 +0800
Message-Id: <20190502020152.2099-1-jprvita@endlessm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <A657D3D3-93D8-4F77-A143-72E921C552AE@holtmann.org>
References: <A657D3D3-93D8-4F77-A143-72E921C552AE@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit makes the kernel not send the next queued HCI command until
a command complete arrives for the last HCI command sent to the
controller. This change avoids a problem with some buggy controllers
(seen on two SKUs of QCA9377) that send an extra command complete event
for the previous command after the kernel had already sent a new HCI
command to the controller.

The problem was reproduced when starting an active scanning procedure,
where an extra command complete event arrives for the LE_SET_RANDOM_ADDR
command. When this happends the kernel ends up not processing the
command complete for the following commmand, LE_SET_SCAN_PARAM, and
ultimately behaving as if a passive scanning procedure was being
performed, when in fact controller is performing an active scanning
procedure. This makes it impossible to discover BLE devices as no device
found events are sent to userspace.

This problem is reproducible on 100% of the attempts on the affected
controllers. The extra command complete event can be seen at timestamp
27.420131 on the btmon logs bellow.

Bluetooth monitor ver 5.50
= Note: Linux version 5.0.0+ (x86_64)                                  0.352340
= Note: Bluetooth subsystem version 2.22                               0.352343
= New Index: 80:C5:F2:8F:87:84 (Primary,USB,hci0)               [hci0] 0.352344
= Open Index: 80:C5:F2:8F:87:84                                 [hci0] 0.352345
= Index Info: 80:C5:F2:8F:87:84 (Qualcomm)                      [hci0] 0.352346
@ MGMT Open: bluetoothd (privileged) version 1.14             {0x0001} 0.352347
@ MGMT Open: btmon (privileged) version 1.14                  {0x0002} 0.352366
@ MGMT Open: btmgmt (privileged) version 1.14                {0x0003} 27.302164
@ MGMT Command: Start Discovery (0x0023) plen 1       {0x0003} [hci0] 27.302310
        Address type: 0x06
          LE Public
          LE Random
< HCI Command: LE Set Random Address (0x08|0x0005) plen 6   #1 [hci0] 27.302496
        Address: 15:60:F2:91:B2:24 (Non-Resolvable)
> HCI Event: Command Complete (0x0e) plen 4                 #2 [hci0] 27.419117
      LE Set Random Address (0x08|0x0005) ncmd 1
        Status: Success (0x00)
< HCI Command: LE Set Scan Parameters (0x08|0x000b) plen 7  #3 [hci0] 27.419244
        Type: Active (0x01)
        Interval: 11.250 msec (0x0012)
        Window: 11.250 msec (0x0012)
        Own address type: Random (0x01)
        Filter policy: Accept all advertisement (0x00)
> HCI Event: Command Complete (0x0e) plen 4                 #4 [hci0] 27.420131
      LE Set Random Address (0x08|0x0005) ncmd 1
        Status: Success (0x00)
< HCI Command: LE Set Scan Enable (0x08|0x000c) plen 2      #5 [hci0] 27.420259
        Scanning: Enabled (0x01)
        Filter duplicates: Enabled (0x01)
> HCI Event: Command Complete (0x0e) plen 4                 #6 [hci0] 27.420969
      LE Set Scan Parameters (0x08|0x000b) ncmd 1
        Status: Success (0x00)
> HCI Event: Command Complete (0x0e) plen 4                 #7 [hci0] 27.421983
      LE Set Scan Enable (0x08|0x000c) ncmd 1
        Status: Success (0x00)
@ MGMT Event: Command Complete (0x0001) plen 4        {0x0003} [hci0] 27.422059
      Start Discovery (0x0023) plen 1
        Status: Success (0x00)
        Address type: 0x06
          LE Public
          LE Random
@ MGMT Event: Discovering (0x0013) plen 2             {0x0003} [hci0] 27.422067
        Address type: 0x06
          LE Public
          LE Random
        Discovery: Enabled (0x01)
@ MGMT Event: Discovering (0x0013) plen 2             {0x0002} [hci0] 27.422067
        Address type: 0x06
          LE Public
          LE Random
        Discovery: Enabled (0x01)
@ MGMT Event: Discovering (0x0013) plen 2             {0x0001} [hci0] 27.422067
        Address type: 0x06
          LE Public
          LE Random
        Discovery: Enabled (0x01)

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
---
 include/net/bluetooth/hci.h |  1 +
 net/bluetooth/hci_core.c    |  5 +++++
 net/bluetooth/hci_event.c   | 12 ++++++++++++
 net/bluetooth/hci_request.c |  5 +++++
 net/bluetooth/hci_request.h |  1 +
 5 files changed, 24 insertions(+)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index fbba43e9bef5..9a5330eed794 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -282,6 +282,7 @@ enum {
 	HCI_FORCE_BREDR_SMP,
 	HCI_FORCE_STATIC_ADDR,
 	HCI_LL_RPA_RESOLUTION,
+	HCI_CMD_PENDING,
 
 	__HCI_NUM_FLAGS,
 };
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index d6b2540ba7f8..f275c9905650 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4383,6 +4383,9 @@ void hci_req_cmd_complete(struct hci_dev *hdev, u16 opcode, u8 status,
 		return;
 	}
 
+	/* If we reach this point this event matches the last command sent */
+	hci_dev_clear_flag(hdev, HCI_CMD_PENDING);
+
 	/* If the command succeeded and there's still more commands in
 	 * this request the request is not yet complete.
 	 */
@@ -4493,6 +4496,8 @@ static void hci_cmd_work(struct work_struct *work)
 
 		hdev->sent_cmd = skb_clone(skb, GFP_KERNEL);
 		if (hdev->sent_cmd) {
+			if (hci_req_status_pend(hdev))
+				hci_dev_set_flag(hdev, HCI_CMD_PENDING);
 			atomic_dec(&hdev->cmd_cnt);
 			hci_send_frame(hdev, skb);
 			if (test_bit(HCI_RESET, &hdev->flags))
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 609fd6871c5a..8b893baf9bbe 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3404,6 +3404,12 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
 	hci_req_cmd_complete(hdev, *opcode, *status, req_complete,
 			     req_complete_skb);
 
+	if (hci_dev_test_flag(hdev, HCI_CMD_PENDING)) {
+		bt_dev_err(hdev,
+			   "unexpected event for opcode 0x%4.4x", *opcode);
+		return;
+	}
+
 	if (atomic_read(&hdev->cmd_cnt) && !skb_queue_empty(&hdev->cmd_q))
 		queue_work(hdev->workqueue, &hdev->cmd_work);
 }
@@ -3511,6 +3517,12 @@ static void hci_cmd_status_evt(struct hci_dev *hdev, struct sk_buff *skb,
 		hci_req_cmd_complete(hdev, *opcode, ev->status, req_complete,
 				     req_complete_skb);
 
+	if (hci_dev_test_flag(hdev, HCI_CMD_PENDING)) {
+		bt_dev_err(hdev,
+			   "unexpected event for opcode 0x%4.4x", *opcode);
+		return;
+	}
+
 	if (atomic_read(&hdev->cmd_cnt) && !skb_queue_empty(&hdev->cmd_q))
 		queue_work(hdev->workqueue, &hdev->cmd_work);
 }
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index ca73d36cc149..e9a95ed65491 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -46,6 +46,11 @@ void hci_req_purge(struct hci_request *req)
 	skb_queue_purge(&req->cmd_q);
 }
 
+bool hci_req_status_pend(struct hci_dev *hdev)
+{
+	return hdev->req_status == HCI_REQ_PEND;
+}
+
 static int req_run(struct hci_request *req, hci_req_complete_t complete,
 		   hci_req_complete_skb_t complete_skb)
 {
diff --git a/net/bluetooth/hci_request.h b/net/bluetooth/hci_request.h
index 692cc8b13368..55b2050cc9ff 100644
--- a/net/bluetooth/hci_request.h
+++ b/net/bluetooth/hci_request.h
@@ -37,6 +37,7 @@ struct hci_request {
 
 void hci_req_init(struct hci_request *req, struct hci_dev *hdev);
 void hci_req_purge(struct hci_request *req);
+bool hci_req_status_pend(struct hci_dev *hdev);
 int hci_req_run(struct hci_request *req, hci_req_complete_t complete);
 int hci_req_run_skb(struct hci_request *req, hci_req_complete_skb_t complete);
 void hci_req_add(struct hci_request *req, u16 opcode, u32 plen,
-- 
2.20.1

