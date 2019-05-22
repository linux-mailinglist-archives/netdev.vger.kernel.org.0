Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00FB126F8D
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731190AbfEVTYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731158AbfEVTYL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:24:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A5AD20879;
        Wed, 22 May 2019 19:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553050;
        bh=BSXp4+mOWCKrSZyMOhVM4A/sjRQADPOHjU+lnEEFvSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZQG2p1lWcGB76yKczr49LXxHPf3WF3muz0W9bHQBGNhJMpNa/3o5/lB5tgHVxi9y
         YvNlqzx2DeSDtAAkpCMiYDjT3tVL7teTTvse2088nVhKk8Ed3aKjlIktlGrkH//Mpn
         VT512UazPyIsg1ztMHlfEq7hlaLz3HYEZeYJUN4A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@gmail.com>,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 021/317] Bluetooth: Ignore CC events not matching the last HCI command
Date:   Wed, 22 May 2019 15:18:42 -0400
Message-Id: <20190522192338.23715-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: João Paulo Rechi Vita <jprvita@gmail.com>

[ Upstream commit f80c5dad7b6467b884c445ffea45985793b4b2d0 ]

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
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h |  1 +
 net/bluetooth/hci_core.c    |  5 +++++
 net/bluetooth/hci_event.c   | 12 ++++++++++++
 net/bluetooth/hci_request.c |  5 +++++
 net/bluetooth/hci_request.h |  1 +
 5 files changed, 24 insertions(+)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index c36dc1e20556a..60b7cbc0a6cb4 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -270,6 +270,7 @@ enum {
 	HCI_FORCE_BREDR_SMP,
 	HCI_FORCE_STATIC_ADDR,
 	HCI_LL_RPA_RESOLUTION,
+	HCI_CMD_PENDING,
 
 	__HCI_NUM_FLAGS,
 };
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 7352fe85674be..c25c664a25040 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4337,6 +4337,9 @@ void hci_req_cmd_complete(struct hci_dev *hdev, u16 opcode, u8 status,
 		return;
 	}
 
+	/* If we reach this point this event matches the last command sent */
+	hci_dev_clear_flag(hdev, HCI_CMD_PENDING);
+
 	/* If the command succeeded and there's still more commands in
 	 * this request the request is not yet complete.
 	 */
@@ -4447,6 +4450,8 @@ static void hci_cmd_work(struct work_struct *work)
 
 		hdev->sent_cmd = skb_clone(skb, GFP_KERNEL);
 		if (hdev->sent_cmd) {
+			if (hci_req_status_pend(hdev))
+				hci_dev_set_flag(hdev, HCI_CMD_PENDING);
 			atomic_dec(&hdev->cmd_cnt);
 			hci_send_frame(hdev, skb);
 			if (test_bit(HCI_RESET, &hdev->flags))
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index ac2826ce162b9..ef5ae4c7e286b 100644
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
index ca73d36cc1494..e9a95ed654915 100644
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
index 692cc8b133682..55b2050cc9ff0 100644
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

