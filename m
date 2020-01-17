Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE7B141301
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 22:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgAQV1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 16:27:41 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:38972 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729361AbgAQV1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 16:27:38 -0500
Received: by mail-pj1-f66.google.com with SMTP id e11so3891659pjt.4
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 13:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dX/yXK6iGHzCms4pl61rtiy1PGwacxrcd9Tk97W7YsY=;
        b=Pvg5bZcNdzM5pAw6eZyeKd+iwD+/Wc8Ds4gXDLa8Ait4HAK+v3N6lyvrZIOKc+cA/j
         OjWx4Q8wrkjDxMo0vwYwjZzlAUuLfKxrSG7T8z75QJ8vU/EXBTUuPSL1gSxr5mLV49hj
         HCDANuBi9waZGp7+doBXa6E0NNzP3iRSLfNps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dX/yXK6iGHzCms4pl61rtiy1PGwacxrcd9Tk97W7YsY=;
        b=hEcOcHn/QNdnsHuto58SjKndxvCpXCPlabRKM3OmJR/VnlLSWSzu50sVs0Ku5QOl+l
         RQ+LA/4ALM5kfPfUJQy9pS2ZsMUTAeDqvsdaarF1taFewK1UqjXtA2XBnICajiCqRfVg
         O+HLy7ZlJI1R9zFRT5VWGT4AEze97xBi/ADVl2RO1hfdue8z1lJTpEMNAD4nD9zoDW6/
         dZdLk3LH7+ET1K7uY15nYjUPisESOzl/tFIoTmj03oBbkkn/vElF+G09Ov7OXMDSYDCV
         YexYIeWi0U6RzYfUYFRSoqqOkm5fUfcgzND9f2G1gTGnaxztP0B+fGW6XXkdAAzz0qEm
         6MhQ==
X-Gm-Message-State: APjAAAX6lZHE8Pdbk7QfDSwTeD2TwVF0XRBTJJlbaUwgenTQMFUVTJRe
        GlWWJZFMPhEFRK/yEfy/4lw/arTht1Uatg==
X-Google-Smtp-Source: APXvYqwslGxdRr74On+Vps0DvyMpkZkcdh94uBscad3mS3VPMZeOUdw6vYpCI3buduc19L9K27E8UA==
X-Received: by 2002:a17:90b:258:: with SMTP id fz24mr7917727pjb.6.1579296457428;
        Fri, 17 Jan 2020 13:27:37 -0800 (PST)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id k5sm6999655pju.29.2020.01.17.13.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 13:27:37 -0800 (PST)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, luiz.dentz@gmail.com, alainm@chromium.org
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/2] Bluetooth: Add mgmt op set_wake_capable
Date:   Fri, 17 Jan 2020 13:27:04 -0800
Message-Id: <20200117132623.RFC.1.I797e2f4cb824299043e771f3ab9cef86ee09f4db@changeid>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
In-Reply-To: <20200117212705.57436-1-abhishekpandit@chromium.org>
References: <20200117212705.57436-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the system is suspended, only some connected Bluetooth devices
cause user input that should wake the system (mostly HID devices). Add
a list to keep track of devices that can wake the system and add
a management API to let userspace tell the kernel whether a device is
wake capable or not.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

 include/net/bluetooth/hci_core.h |  1 +
 include/net/bluetooth/mgmt.h     |  7 ++++++
 net/bluetooth/hci_core.c         |  1 +
 net/bluetooth/mgmt.c             | 42 ++++++++++++++++++++++++++++++++
 4 files changed, 51 insertions(+)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 89ecf0a80aa1..ce4bebcb0265 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -394,6 +394,7 @@ struct hci_dev {
 	struct list_head	mgmt_pending;
 	struct list_head	blacklist;
 	struct list_head	whitelist;
+	struct list_head	wakeable;
 	struct list_head	uuids;
 	struct list_head	link_keys;
 	struct list_head	long_term_keys;
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index a90666af05bd..283ba5320bdb 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -671,6 +671,13 @@ struct mgmt_cp_set_blocked_keys {
 } __packed;
 #define MGMT_OP_SET_BLOCKED_KEYS_SIZE 2
 
+#define MGMT_OP_SET_WAKE_CAPABLE	0x0047
+#define MGMT_SET_WAKE_CAPABLE_SIZE	8
+struct mgmt_cp_set_wake_capable {
+	struct mgmt_addr_info addr;
+	u8 wake_capable;
+} __packed;
+
 #define MGMT_EV_CMD_COMPLETE		0x0001
 struct mgmt_ev_cmd_complete {
 	__le16	opcode;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 1ca7508b6ca7..7057b9b65173 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3299,6 +3299,7 @@ struct hci_dev *hci_alloc_dev(void)
 	INIT_LIST_HEAD(&hdev->mgmt_pending);
 	INIT_LIST_HEAD(&hdev->blacklist);
 	INIT_LIST_HEAD(&hdev->whitelist);
+	INIT_LIST_HEAD(&hdev->wakeable);
 	INIT_LIST_HEAD(&hdev->uuids);
 	INIT_LIST_HEAD(&hdev->link_keys);
 	INIT_LIST_HEAD(&hdev->long_term_keys);
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 0dc610faab70..95092130f16c 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -106,7 +106,10 @@ static const u16 mgmt_commands[] = {
 	MGMT_OP_START_LIMITED_DISCOVERY,
 	MGMT_OP_READ_EXT_INFO,
 	MGMT_OP_SET_APPEARANCE,
+	MGMT_OP_GET_PHY_CONFIGURATION,
+	MGMT_OP_SET_PHY_CONFIGURATION,
 	MGMT_OP_SET_BLOCKED_KEYS,
+	MGMT_OP_SET_WAKE_CAPABLE,
 };
 
 static const u16 mgmt_events[] = {
@@ -4663,6 +4666,37 @@ static int set_fast_connectable(struct sock *sk, struct hci_dev *hdev,
 	return err;
 }
 
+static int set_wake_capable(struct sock *sk, struct hci_dev *hdev, void *data,
+			    u16 len)
+{
+	int err;
+	u8 status;
+	struct mgmt_cp_set_wake_capable *cp = data;
+	u8 addr_type = cp->addr.type == BDADDR_BREDR ?
+			       cp->addr.type :
+			       le_addr_type(cp->addr.type);
+
+	BT_DBG("Set wake capable %pMR (type 0x%x) = 0x%x\n", &cp->addr.bdaddr,
+	       addr_type, cp->wake_capable);
+
+	if (cp->wake_capable)
+		err = hci_bdaddr_list_add(&hdev->wakeable, &cp->addr.bdaddr,
+					  addr_type);
+	else
+		err = hci_bdaddr_list_del(&hdev->wakeable, &cp->addr.bdaddr,
+					  addr_type);
+
+	if (!err || err == -EEXIST || err == -ENOENT)
+		status = MGMT_STATUS_SUCCESS;
+	else
+		status = MGMT_STATUS_FAILED;
+
+	err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_SET_WAKE_CAPABLE, status,
+				cp, sizeof(*cp));
+
+	return err;
+}
+
 static void set_bredr_complete(struct hci_dev *hdev, u8 status, u16 opcode)
 {
 	struct mgmt_pending_cmd *cmd;
@@ -5791,6 +5825,13 @@ static int remove_device(struct sock *sk, struct hci_dev *hdev,
 			err = hci_bdaddr_list_del(&hdev->whitelist,
 						  &cp->addr.bdaddr,
 						  cp->addr.type);
+
+			/* Don't check result since it either succeeds or device
+			 * wasn't there (not wakeable or invalid params as
+			 * covered by deleting from whitelist).
+			 */
+			hci_bdaddr_list_del(&hdev->wakeable, &cp->addr.bdaddr,
+					    cp->addr.type);
 			if (err) {
 				err = mgmt_cmd_complete(sk, hdev->id,
 							MGMT_OP_REMOVE_DEVICE,
@@ -6990,6 +7031,7 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
 	{ set_phy_configuration,   MGMT_SET_PHY_CONFIGURATION_SIZE },
 	{ set_blocked_keys,	   MGMT_OP_SET_BLOCKED_KEYS_SIZE,
 						HCI_MGMT_VAR_LEN },
+	{ set_wake_capable,	   MGMT_SET_WAKE_CAPABLE_SIZE },
 };
 
 void mgmt_index_added(struct hci_dev *hdev)
-- 
2.25.0.341.g760bfbb309-goog

