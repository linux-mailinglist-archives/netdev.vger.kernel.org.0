Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049771FC4F1
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 06:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgFQEAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 00:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726850AbgFQEAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 00:00:42 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F019C061797
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 21:00:40 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d66so477439pfd.6
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 21:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RsvMcHsmnffBvKI6AP/oNVNlaNqVVaqGHS4ozdYi5fw=;
        b=OW5MxIYO5PxouZCFtAIJP06VTA/ZOoEp+j/7PsjxG/bPK8Q+52HF4q+GNYPfxdj7CJ
         zpslw6D2LU6/PAHbqr3egVIP9w6C6wJkDhiE69IsrRNnjn5pxVmpHYJwa7Bz8a31gowr
         d8F+zWGt7NoDeBLnBcUnUoQ4lkrNTOzaSfido=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RsvMcHsmnffBvKI6AP/oNVNlaNqVVaqGHS4ozdYi5fw=;
        b=j4fKdqtS72oAbKEKvCsgJGYVEy1+dcJ2PLBf8agKJKiwDQKLCOED0YH5/D9q47/27f
         KJdPV5DcD0xDhXSHOeFv3O2e9nMpsbJWOmcUit6k1qkdl0bWkxv41NlpQ+oWSTuA/Ll9
         GYAu5jtCYnxZ5bJedX5rrZrACXzPzie2e0tVspfH+zLzv5w0hUY7qlGTxgylk7oPQfYm
         /gIPB/kCFfF90cwN5pptQhXdPHor8YtayYcuhka6U3INkWwBdrxeRDkaIxIxdeZM2X6n
         J1Jzy9YNdhVXRYqITUl6Yw16ZoAOAPHM0QBhVuTc+bS6PgTDsXl4O3cXa1y9kFjbBh8e
         SJ2Q==
X-Gm-Message-State: AOAM530F5igGVJN2UZtAeTG7/DxX44UJEazyY9vIRGcSpuNjsj2UdeyQ
        4CRRcsfV9TWCxmTcV/DQPAZg5w==
X-Google-Smtp-Source: ABdhPJwZ3TzSkhI6KAloL351yf0URoamj1q3VUbdzILd64s8LS3cwGkBzkWGczdOhsQWqeNSkf3Rug==
X-Received: by 2002:a05:6a00:2c3:: with SMTP id b3mr5269044pft.20.1592366439710;
        Tue, 16 Jun 2020 21:00:39 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id q1sm20013089pfk.132.2020.06.16.21.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 21:00:39 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     alainm@chromium.org, chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4/4] Bluetooth: Add get/set device flags mgmt op
Date:   Tue, 16 Jun 2020 21:00:22 -0700
Message-Id: <20200616210008.4.If379101eba01fd9f0903e04cc817eb2c8e7f7d96@changeid>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
In-Reply-To: <20200617040022.174448-1-abhishekpandit@chromium.org>
References: <20200617040022.174448-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the get device flags and set device flags mgmt ops and the device
flags changed event. Their behavior is described in detail in
mgmt-api.txt in bluez.

Sample btmon trace when a HID device is added (trimmed to 75 chars):

@ MGMT Command: Unknown (0x0050) plen 11        {0x0001} [hci0] 18:06:14.98
        90 c5 13 cd f3 cd 02 01 00 00 00                 ...........
@ MGMT Event: Unknown (0x002a) plen 15          {0x0004} [hci0] 18:06:14.98
        90 c5 13 cd f3 cd 02 01 00 00 00 01 00 00 00     ...............
@ MGMT Event: Unknown (0x002a) plen 15          {0x0003} [hci0] 18:06:14.98
        90 c5 13 cd f3 cd 02 01 00 00 00 01 00 00 00     ...............
@ MGMT Event: Unknown (0x002a) plen 15          {0x0002} [hci0] 18:06:14.98
        90 c5 13 cd f3 cd 02 01 00 00 00 01 00 00 00     ...............
@ MGMT Event: Command Compl.. (0x0001) plen 10  {0x0001} [hci0] 18:06:14.98
      Unknown (0x0050) plen 7
        Status: Success (0x00)
        90 c5 13 cd f3 cd 02                             .......
@ MGMT Command: Add Device (0x0033) plen 8      {0x0001} [hci0] 18:06:14.98
        LE Address: CD:F3:CD:13:C5:90 (Static)
        Action: Auto-connect remote device (0x02)
@ MGMT Event: Device Added (0x001a) plen 8      {0x0004} [hci0] 18:06:14.98
        LE Address: CD:F3:CD:13:C5:90 (Static)
        Action: Auto-connect remote device (0x02)
@ MGMT Event: Device Added (0x001a) plen 8      {0x0003} [hci0] 18:06:14.98
        LE Address: CD:F3:CD:13:C5:90 (Static)
        Action: Auto-connect remote device (0x02)
@ MGMT Event: Device Added (0x001a) plen 8      {0x0002} [hci0] 18:06:14.98
        LE Address: CD:F3:CD:13:C5:90 (Static)
        Action: Auto-connect remote device (0x02)
@ MGMT Event: Unknown (0x002a) plen 15          {0x0004} [hci0] 18:06:14.98
        90 c5 13 cd f3 cd 02 01 00 00 00 01 00 00 00     ...............
@ MGMT Event: Unknown (0x002a) plen 15          {0x0003} [hci0] 18:06:14.98
        90 c5 13 cd f3 cd 02 01 00 00 00 01 00 00 00     ...............
@ MGMT Event: Unknown (0x002a) plen 15          {0x0002} [hci0] 18:06:14.98
        90 c5 13 cd f3 cd 02 01 00 00 00 01 00 00 00     ...............
@ MGMT Event: Unknown (0x002a) plen 15          {0x0001} [hci0] 18:06:14.98
        90 c5 13 cd f3 cd 02 01 00 00 00 01 00 00 00     ...............

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>
---

 include/net/bluetooth/hci.h  |   1 +
 include/net/bluetooth/mgmt.h |  28 ++++++++
 net/bluetooth/hci_sock.c     |   1 +
 net/bluetooth/mgmt.c         | 134 +++++++++++++++++++++++++++++++++++
 4 files changed, 164 insertions(+)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 16ab6ce8788341..5e03aac76ad47f 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -259,6 +259,7 @@ enum {
 	HCI_MGMT_LOCAL_NAME_EVENTS,
 	HCI_MGMT_OOB_DATA_EVENTS,
 	HCI_MGMT_EXP_FEATURE_EVENTS,
+	HCI_MGMT_DEVICE_FLAGS_EVENTS,
 };
 
 /*
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index e515288f328f47..8e47b0c5fe52bb 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -720,6 +720,27 @@ struct mgmt_rp_set_exp_feature {
 #define MGMT_OP_SET_DEF_RUNTIME_CONFIG	0x004e
 #define MGMT_SET_DEF_RUNTIME_CONFIG_SIZE	0
 
+#define MGMT_OP_GET_DEVICE_FLAGS	0x004F
+#define MGMT_GET_DEVICE_FLAGS_SIZE	7
+struct mgmt_cp_get_device_flags {
+	struct mgmt_addr_info addr;
+} __packed;
+struct mgmt_rp_get_device_flags {
+	struct mgmt_addr_info addr;
+	__le32 supported_flags;
+	__le32 current_flags;
+} __packed;
+
+#define MGMT_OP_SET_DEVICE_FLAGS	0x0050
+#define MGMT_SET_DEVICE_FLAGS_SIZE	11
+struct mgmt_cp_set_device_flags {
+	struct mgmt_addr_info addr;
+	__le32 current_flags;
+} __packed;
+struct mgmt_rp_set_device_flags {
+	struct mgmt_addr_info addr;
+} __packed;
+
 #define MGMT_EV_CMD_COMPLETE		0x0001
 struct mgmt_ev_cmd_complete {
 	__le16	opcode;
@@ -951,3 +972,10 @@ struct mgmt_ev_exp_feature_changed {
 	__u8	uuid[16];
 	__le32	flags;
 } __packed;
+
+#define MGMT_EV_DEVICE_FLAGS_CHANGED		0x002a
+struct mgmt_ev_device_flags_changed {
+	struct mgmt_addr_info addr;
+	__le32 supported_flags;
+	__le32 current_flags;
+} __packed;
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index d5627967fc254f..a7903b6206620c 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1354,6 +1354,7 @@ static int hci_sock_bind(struct socket *sock, struct sockaddr *addr,
 			hci_sock_set_flag(sk, HCI_MGMT_SETTING_EVENTS);
 			hci_sock_set_flag(sk, HCI_MGMT_DEV_CLASS_EVENTS);
 			hci_sock_set_flag(sk, HCI_MGMT_LOCAL_NAME_EVENTS);
+			hci_sock_set_flag(sk, HCI_MGMT_DEVICE_FLAGS_EVENTS);
 		}
 		break;
 	}
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 6d996e5e5bcc2d..2805f662d85695 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -114,6 +114,8 @@ static const u16 mgmt_commands[] = {
 	MGMT_OP_SET_EXP_FEATURE,
 	MGMT_OP_READ_DEF_SYSTEM_CONFIG,
 	MGMT_OP_SET_DEF_SYSTEM_CONFIG,
+	MGMT_OP_GET_DEVICE_FLAGS,
+	MGMT_OP_SET_DEVICE_FLAGS,
 };
 
 static const u16 mgmt_events[] = {
@@ -154,6 +156,7 @@ static const u16 mgmt_events[] = {
 	MGMT_EV_EXT_INFO_CHANGED,
 	MGMT_EV_PHY_CONFIGURATION_CHANGED,
 	MGMT_EV_EXP_FEATURE_CHANGED,
+	MGMT_EV_DEVICE_FLAGS_CHANGED,
 };
 
 static const u16 mgmt_untrusted_commands[] = {
@@ -3853,6 +3856,122 @@ static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
 			       MGMT_STATUS_NOT_SUPPORTED);
 }
 
+#define SUPPORTED_DEVICE_FLAGS() ((1U << HCI_CONN_FLAG_MAX) - 1)
+
+static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
+			    u16 data_len)
+{
+	struct mgmt_cp_get_device_flags *cp = data;
+	struct mgmt_rp_get_device_flags rp;
+	struct bdaddr_list_with_flags *br_params;
+	struct hci_conn_params *params;
+	u32 supported_flags = SUPPORTED_DEVICE_FLAGS();
+	u32 current_flags = 0;
+	u8 status = MGMT_STATUS_INVALID_PARAMS;
+
+	bt_dev_dbg(hdev, "Get device flags %pMR (type 0x%x)\n",
+		   &cp->addr.bdaddr, cp->addr.type);
+
+	if (cp->addr.type == BDADDR_BREDR) {
+		br_params = hci_bdaddr_list_lookup_with_flags(&hdev->whitelist,
+							      &cp->addr.bdaddr,
+							      cp->addr.type);
+		if (!br_params)
+			goto done;
+
+		current_flags = br_params->current_flags;
+	} else {
+		params = hci_conn_params_lookup(hdev, &cp->addr.bdaddr,
+						le_addr_type(cp->addr.type));
+
+		if (!params)
+			goto done;
+
+		current_flags = params->current_flags;
+	}
+
+	bacpy(&rp.addr.bdaddr, &cp->addr.bdaddr);
+	rp.addr.type = cp->addr.type;
+	rp.supported_flags = cpu_to_le32(supported_flags);
+	rp.current_flags = cpu_to_le32(current_flags);
+
+	status = MGMT_STATUS_SUCCESS;
+
+done:
+	return mgmt_cmd_complete(sk, hdev->id, MGMT_OP_GET_DEVICE_FLAGS, status,
+				&rp, sizeof(rp));
+}
+
+static int device_flags_changed(struct hci_dev *hdev, bdaddr_t *bdaddr,
+				u8 bdaddr_type, u32 supported_flags,
+				u32 current_flags, struct sock *skip)
+{
+	struct mgmt_ev_device_flags_changed ev;
+
+	bacpy(&ev.addr.bdaddr, bdaddr);
+	ev.addr.type = bdaddr_type;
+	ev.supported_flags = cpu_to_le32(supported_flags);
+	ev.current_flags = cpu_to_le32(current_flags);
+
+	return mgmt_limited_event(MGMT_EV_DEVICE_FLAGS_CHANGED, hdev, &ev,
+				  sizeof(ev), HCI_MGMT_DEVICE_FLAGS_EVENTS,
+				  skip);
+}
+
+static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
+			    u16 len)
+{
+	struct mgmt_cp_set_device_flags *cp = data;
+	struct bdaddr_list_with_flags *br_params;
+	struct hci_conn_params *params;
+	u8 status = MGMT_STATUS_INVALID_PARAMS;
+	u32 supported_flags = SUPPORTED_DEVICE_FLAGS();
+	u32 current_flags = __le32_to_cpu(cp->current_flags);
+
+	bt_dev_dbg(hdev, "Set device flags %pMR (type 0x%x) = 0x%x",
+		   &cp->addr.bdaddr, cp->addr.type,
+		   __le32_to_cpu(current_flags));
+
+	if ((supported_flags | current_flags) != supported_flags) {
+		bt_dev_warn(hdev, "Bad flag given (0x%x) vs supported (0x%0x)",
+			    current_flags, supported_flags);
+		goto done;
+	}
+
+	if (cp->addr.type == BDADDR_BREDR) {
+		br_params = hci_bdaddr_list_lookup_with_flags(&hdev->whitelist,
+							      &cp->addr.bdaddr,
+							      cp->addr.type);
+
+		if (br_params) {
+			br_params->current_flags = current_flags;
+			status = MGMT_STATUS_SUCCESS;
+		} else {
+			bt_dev_warn(hdev, "No such BR/EDR device %pMR (0x%x)",
+				    &cp->addr.bdaddr, cp->addr.type);
+		}
+	} else {
+		params = hci_conn_params_lookup(hdev, &cp->addr.bdaddr,
+						le_addr_type(cp->addr.type));
+		if (params) {
+			params->current_flags = current_flags;
+			status = MGMT_STATUS_SUCCESS;
+		} else {
+			bt_dev_warn(hdev, "No such LE device %pMR (0x%x)",
+				    &cp->addr.bdaddr,
+				    le_addr_type(cp->addr.type));
+		}
+	}
+
+done:
+	if (status == MGMT_STATUS_SUCCESS)
+		device_flags_changed(hdev, &cp->addr.bdaddr, cp->addr.type,
+				     supported_flags, current_flags, sk);
+
+	return mgmt_cmd_complete(sk, hdev->id, MGMT_OP_SET_DEVICE_FLAGS, status,
+				 &cp->addr, sizeof(cp->addr));
+}
+
 static void read_local_oob_data_complete(struct hci_dev *hdev, u8 status,
 				         u16 opcode, struct sk_buff *skb)
 {
@@ -5970,7 +6089,9 @@ static int add_device(struct sock *sk, struct hci_dev *hdev,
 {
 	struct mgmt_cp_add_device *cp = data;
 	u8 auto_conn, addr_type;
+	struct hci_conn_params *params;
 	int err;
+	u32 current_flags = 0;
 
 	bt_dev_dbg(hdev, "sock %p", sk);
 
@@ -6038,12 +6159,19 @@ static int add_device(struct sock *sk, struct hci_dev *hdev,
 					MGMT_STATUS_FAILED, &cp->addr,
 					sizeof(cp->addr));
 		goto unlock;
+	} else {
+		params = hci_conn_params_lookup(hdev, &cp->addr.bdaddr,
+						addr_type);
+		if (params)
+			current_flags = params->current_flags;
 	}
 
 	hci_update_background_scan(hdev);
 
 added:
 	device_added(sk, hdev, &cp->addr.bdaddr, cp->addr.type, cp->action);
+	device_flags_changed(hdev, &cp->addr.bdaddr, cp->addr.type,
+			     SUPPORTED_DEVICE_FLAGS(), current_flags, NULL);
 
 	err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_ADD_DEVICE,
 				MGMT_STATUS_SUCCESS, &cp->addr,
@@ -7306,6 +7434,12 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
 						HCI_MGMT_UNTRUSTED },
 	{ set_def_system_config,   MGMT_SET_DEF_SYSTEM_CONFIG_SIZE,
 						HCI_MGMT_VAR_LEN },
+
+	{ NULL }, /* Read default runtime config */
+	{ NULL }, /* Set default runtime config */
+
+	{ get_device_flags,        MGMT_GET_DEVICE_FLAGS_SIZE },
+	{ set_device_flags,        MGMT_SET_DEVICE_FLAGS_SIZE },
 };
 
 void mgmt_index_added(struct hci_dev *hdev)
-- 
2.27.0.290.gba653c62da-goog

