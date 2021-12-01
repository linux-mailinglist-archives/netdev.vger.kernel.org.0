Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8574643BD
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 01:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345560AbhLAAGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 19:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345515AbhLAAGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 19:06:21 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A631C061746;
        Tue, 30 Nov 2021 16:03:01 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b11so16222259pld.12;
        Tue, 30 Nov 2021 16:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bk82bxXbJxygZ2/esoOJbOmQoFQoDGqBukGE9+ZJoh8=;
        b=OtchV4cxxWBQC+QfB8/iGifrLXlf4YE9ULLNSpMNTDuK0I9AoLPaqJJ1aLjOGkLyuR
         +ohqjyI+OBr7cQXvoQgOV7YGsaQ+2ky+prIq58mP4sXXc6azhrj3wUzqwvIbjrJoR7i6
         L8CP3I/kX4aTNMMVtsVUgr4VTnYl0DpHZHmKQS7pnmdEd0Gojn+O4bW0OXNm5Vv83fLi
         Si+hEPJWC5i1jughk/p0VhNdT9xKyE0n3xDMNLcprqnkn8+aSzc1XgDuo8uYg7aNTEwU
         i0+DCg4LJRi1JvIlQza4eyHMtYgwCObNsKzQ5toodUmk80crI3Ijm+sbDEOcSwlstVS0
         XIzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bk82bxXbJxygZ2/esoOJbOmQoFQoDGqBukGE9+ZJoh8=;
        b=tYo64Dnu9LMRVzaX3NSCHKn0Ul3vU+SwY4tnJsgUAVJ8sK+G9wWSZy29YCWITuNtGI
         GGT4T9QF8W94J5serOSutWPWoTuJ52qVJ3tDoSqaXojRcSAptugMtrdJ47NjUTpcjSGE
         TX4sixCziFQns5ist3NHNz7YED1ww17yqh4CCxaJCWWWNQnLCtAqr8xYKGCYzg4M4LDr
         KzzpumW7CX6/nZh6UdcOWZpWSnEFhqtOT+7Pp0xGamtpzpMpU7ZEbGfp2A4W4mDWjOHH
         85QxFbqz1/wn2+DrGgA78NpmerTJg2wdSL8FS/LVkDEvlMBy3IwCYygt9qiSaDwW+5QE
         NuDg==
X-Gm-Message-State: AOAM532q/jxXezMdCt2xW2AybTcAAoWePHe+YPsrOuFtWQFIoL2/AuFQ
        CRKQT2NKgvMURq1FLg+Kgdn23Rvo/Ww=
X-Google-Smtp-Source: ABdhPJzq10qEJYz+tpqKEZ0XO8XSAjtAkfOqou/K6r+4ActDPPuJOgo8bCSqz0TOxUGNirksQ7dqkA==
X-Received: by 2002:a17:903:2305:b0:142:1bca:72eb with SMTP id d5-20020a170903230500b001421bca72ebmr2750956plh.67.1638316980541;
        Tue, 30 Nov 2021 16:03:00 -0800 (PST)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id j13sm21001739pfc.151.2021.11.30.16.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 16:03:00 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        dan.carpenter@oracle.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 02/15] Bluetooth: HCI: Use skb_pull_data to parse BR/EDR events
Date:   Tue, 30 Nov 2021 16:02:02 -0800
Message-Id: <20211201000215.1134831-3-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201000215.1134831-1-luiz.dentz@gmail.com>
References: <20211201000215.1134831-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

This uses skb_pull_data to check the BR/EDR events received have the
minimum required length.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
---
 include/net/bluetooth/hci.h |   4 +
 net/bluetooth/hci_event.c   | 260 +++++++++++++++++++++++++++++-------
 2 files changed, 217 insertions(+), 47 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 0d2a9216869b..ba89b078ceb5 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2012,6 +2012,10 @@ struct hci_cp_le_reject_cis {
 } __packed;
 
 /* ---- HCI Events ---- */
+struct hci_ev_status {
+	__u8    status;
+} __packed;
+
 #define HCI_EV_INQUIRY_COMPLETE		0x01
 
 #define HCI_EV_INQUIRY_RESULT		0x02
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 9d8d2d9e5d1f..0266eab8a18c 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -45,6 +45,18 @@
 
 /* Handle HCI Event packets */
 
+static void *hci_ev_skb_pull(struct hci_dev *hdev, struct sk_buff *skb,
+			     u8 ev, size_t len)
+{
+	void *data;
+
+	data = skb_pull_data(skb, len);
+	if (!data)
+		bt_dev_err(hdev, "Malformed Event: 0x%2.2x", ev);
+
+	return data;
+}
+
 static void hci_cc_inquiry_cancel(struct hci_dev *hdev, struct sk_buff *skb,
 				  u8 *new_status)
 {
@@ -2682,11 +2694,15 @@ static void hci_cs_switch_role(struct hci_dev *hdev, u8 status)
 
 static void hci_inquiry_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	__u8 status = *((__u8 *) skb->data);
+	struct hci_ev_status *ev;
 	struct discovery_state *discov = &hdev->discovery;
 	struct inquiry_entry *e;
 
-	BT_DBG("%s status 0x%2.2x", hdev->name, status);
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_INQUIRY_COMPLETE, sizeof(*ev));
+	if (!ev)
+		return;
+
+	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	hci_conn_check_pending(hdev);
 
@@ -2780,9 +2796,13 @@ static void hci_inquiry_result_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_conn_complete *ev = (void *) skb->data;
+	struct hci_ev_conn_complete *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_CONN_COMPLETE, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s", hdev->name);
 
 	hci_dev_lock(hdev);
@@ -2904,12 +2924,16 @@ static void hci_reject_conn(struct hci_dev *hdev, bdaddr_t *bdaddr)
 
 static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_conn_request *ev = (void *) skb->data;
+	struct hci_ev_conn_request *ev;
 	int mask = hdev->link_mode;
 	struct inquiry_entry *ie;
 	struct hci_conn *conn;
 	__u8 flags = 0;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_CONN_REQUEST, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s bdaddr %pMR type 0x%x", hdev->name, &ev->bdaddr,
 	       ev->link_type);
 
@@ -3015,12 +3039,16 @@ static u8 hci_to_mgmt_reason(u8 err)
 
 static void hci_disconn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_disconn_complete *ev = (void *) skb->data;
+	struct hci_ev_disconn_complete *ev;
 	u8 reason;
 	struct hci_conn_params *params;
 	struct hci_conn *conn;
 	bool mgmt_connected;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_DISCONN_COMPLETE, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	hci_dev_lock(hdev);
@@ -3099,9 +3127,13 @@ static void hci_disconn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 static void hci_auth_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_auth_complete *ev = (void *) skb->data;
+	struct hci_ev_auth_complete *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_AUTH_COMPLETE, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	hci_dev_lock(hdev);
@@ -3169,9 +3201,13 @@ static void hci_auth_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 static void hci_remote_name_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_remote_name *ev = (void *) skb->data;
+	struct hci_ev_remote_name *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_REMOTE_NAME, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s", hdev->name);
 
 	hci_conn_check_pending(hdev);
@@ -3252,9 +3288,13 @@ static void read_enc_key_size_complete(struct hci_dev *hdev, u8 status,
 
 static void hci_encrypt_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_encrypt_change *ev = (void *) skb->data;
+	struct hci_ev_encrypt_change *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_ENCRYPT_CHANGE, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	hci_dev_lock(hdev);
@@ -3367,9 +3407,14 @@ static void hci_encrypt_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
 static void hci_change_link_key_complete_evt(struct hci_dev *hdev,
 					     struct sk_buff *skb)
 {
-	struct hci_ev_change_link_key_complete *ev = (void *) skb->data;
+	struct hci_ev_change_link_key_complete *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_CHANGE_LINK_KEY_COMPLETE,
+			     sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	hci_dev_lock(hdev);
@@ -3390,9 +3435,13 @@ static void hci_change_link_key_complete_evt(struct hci_dev *hdev,
 static void hci_remote_features_evt(struct hci_dev *hdev,
 				    struct sk_buff *skb)
 {
-	struct hci_ev_remote_features *ev = (void *) skb->data;
+	struct hci_ev_remote_features *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_REMOTE_FEATURES, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	hci_dev_lock(hdev);
@@ -3841,9 +3890,11 @@ static void hci_cmd_status_evt(struct hci_dev *hdev, struct sk_buff *skb,
 			       hci_req_complete_t *req_complete,
 			       hci_req_complete_skb_t *req_complete_skb)
 {
-	struct hci_ev_cmd_status *ev = (void *) skb->data;
+	struct hci_ev_cmd_status *ev;
 
-	skb_pull(skb, sizeof(*ev));
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_CMD_STATUS, sizeof(*ev));
+	if (!ev)
+		return;
 
 	*opcode = __le16_to_cpu(ev->opcode);
 	*status = ev->status;
@@ -3951,7 +4002,11 @@ static void hci_cmd_status_evt(struct hci_dev *hdev, struct sk_buff *skb,
 
 static void hci_hardware_error_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_hardware_error *ev = (void *) skb->data;
+	struct hci_ev_hardware_error *ev;
+
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_HARDWARE_ERROR, sizeof(*ev));
+	if (!ev)
+		return;
 
 	hdev->hw_error_code = ev->code;
 
@@ -3960,9 +4015,13 @@ static void hci_hardware_error_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 static void hci_role_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_role_change *ev = (void *) skb->data;
+	struct hci_ev_role_change *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_ROLE_CHANGE, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	hci_dev_lock(hdev);
@@ -4070,17 +4129,19 @@ static struct hci_conn *__hci_conn_lookup_handle(struct hci_dev *hdev,
 
 static void hci_num_comp_blocks_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_num_comp_blocks *ev = (void *) skb->data;
+	struct hci_ev_num_comp_blocks *ev;
 	int i;
 
-	if (hdev->flow_ctl_mode != HCI_FLOW_CTL_MODE_BLOCK_BASED) {
-		bt_dev_err(hdev, "wrong event for mode %d", hdev->flow_ctl_mode);
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_NUM_COMP_BLOCKS, sizeof(*ev));
+	if (!ev)
 		return;
-	}
 
-	if (skb->len < sizeof(*ev) ||
-	    skb->len < struct_size(ev, handles, ev->num_hndl)) {
-		BT_DBG("%s bad parameters", hdev->name);
+	if (!hci_ev_skb_pull(hdev, skb, HCI_EV_NUM_COMP_BLOCKS,
+			     flex_array_size(ev, handles, ev->num_hndl)))
+		return;
+
+	if (hdev->flow_ctl_mode != HCI_FLOW_CTL_MODE_BLOCK_BASED) {
+		bt_dev_err(hdev, "wrong event for mode %d", hdev->flow_ctl_mode);
 		return;
 	}
 
@@ -4121,9 +4182,13 @@ static void hci_num_comp_blocks_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 static void hci_mode_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_mode_change *ev = (void *) skb->data;
+	struct hci_ev_mode_change *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_MODE_CHANGE, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	hci_dev_lock(hdev);
@@ -4149,9 +4214,13 @@ static void hci_mode_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 static void hci_pin_code_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_pin_code_req *ev = (void *) skb->data;
+	struct hci_ev_pin_code_req *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_PIN_CODE_REQ, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s", hdev->name);
 
 	hci_dev_lock(hdev);
@@ -4219,11 +4288,15 @@ static void conn_set_key(struct hci_conn *conn, u8 key_type, u8 pin_len)
 
 static void hci_link_key_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_link_key_req *ev = (void *) skb->data;
+	struct hci_ev_link_key_req *ev;
 	struct hci_cp_link_key_reply cp;
 	struct hci_conn *conn;
 	struct link_key *key;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_LINK_KEY_REQ, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s", hdev->name);
 
 	if (!hci_dev_test_flag(hdev, HCI_MGMT))
@@ -4279,12 +4352,16 @@ static void hci_link_key_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 static void hci_link_key_notify_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_link_key_notify *ev = (void *) skb->data;
+	struct hci_ev_link_key_notify *ev;
 	struct hci_conn *conn;
 	struct link_key *key;
 	bool persistent;
 	u8 pin_len = 0;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_LINK_KEY_NOTIFY, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s", hdev->name);
 
 	hci_dev_lock(hdev);
@@ -4339,9 +4416,13 @@ static void hci_link_key_notify_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 static void hci_clock_offset_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_clock_offset *ev = (void *) skb->data;
+	struct hci_ev_clock_offset *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_CLOCK_OFFSET, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	hci_dev_lock(hdev);
@@ -4362,9 +4443,13 @@ static void hci_clock_offset_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 static void hci_pkt_type_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_pkt_type_change *ev = (void *) skb->data;
+	struct hci_ev_pkt_type_change *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_PKT_TYPE_CHANGE, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	hci_dev_lock(hdev);
@@ -4378,9 +4463,13 @@ static void hci_pkt_type_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 static void hci_pscan_rep_mode_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_pscan_rep_mode *ev = (void *) skb->data;
+	struct hci_ev_pscan_rep_mode *ev;
 	struct inquiry_entry *ie;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_PSCAN_REP_MODE, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s", hdev->name);
 
 	hci_dev_lock(hdev);
@@ -4468,9 +4557,14 @@ static void hci_inquiry_result_with_rssi_evt(struct hci_dev *hdev,
 static void hci_remote_ext_features_evt(struct hci_dev *hdev,
 					struct sk_buff *skb)
 {
-	struct hci_ev_remote_ext_features *ev = (void *) skb->data;
+	struct hci_ev_remote_ext_features *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_REMOTE_EXT_FEATURES,
+			     sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s", hdev->name);
 
 	hci_dev_lock(hdev);
@@ -4532,9 +4626,13 @@ static void hci_remote_ext_features_evt(struct hci_dev *hdev,
 static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
 				       struct sk_buff *skb)
 {
-	struct hci_ev_sync_conn_complete *ev = (void *) skb->data;
+	struct hci_ev_sync_conn_complete *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_SYNC_CONN_COMPLETE, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	hci_dev_lock(hdev);
@@ -4697,9 +4795,14 @@ static void hci_extended_inquiry_result_evt(struct hci_dev *hdev,
 static void hci_key_refresh_complete_evt(struct hci_dev *hdev,
 					 struct sk_buff *skb)
 {
-	struct hci_ev_key_refresh_complete *ev = (void *) skb->data;
+	struct hci_ev_key_refresh_complete *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_KEY_REFRESH_COMPLETE,
+			     sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s status 0x%2.2x handle 0x%4.4x", hdev->name, ev->status,
 	       __le16_to_cpu(ev->handle));
 
@@ -4806,9 +4909,13 @@ static u8 bredr_oob_data_present(struct hci_conn *conn)
 
 static void hci_io_capa_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_io_capa_request *ev = (void *) skb->data;
+	struct hci_ev_io_capa_request *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_IO_CAPA_REQUEST, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s", hdev->name);
 
 	hci_dev_lock(hdev);
@@ -4875,9 +4982,13 @@ static void hci_io_capa_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 static void hci_io_capa_reply_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_io_capa_reply *ev = (void *) skb->data;
+	struct hci_ev_io_capa_reply *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_IO_CAPA_REPLY, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s", hdev->name);
 
 	hci_dev_lock(hdev);
@@ -4896,10 +5007,15 @@ static void hci_io_capa_reply_evt(struct hci_dev *hdev, struct sk_buff *skb)
 static void hci_user_confirm_request_evt(struct hci_dev *hdev,
 					 struct sk_buff *skb)
 {
-	struct hci_ev_user_confirm_req *ev = (void *) skb->data;
+	struct hci_ev_user_confirm_req *ev;
 	int loc_mitm, rem_mitm, confirm_hint = 0;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_USER_CONFIRM_REQUEST,
+			     sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s", hdev->name);
 
 	hci_dev_lock(hdev);
@@ -4981,7 +5097,12 @@ static void hci_user_confirm_request_evt(struct hci_dev *hdev,
 static void hci_user_passkey_request_evt(struct hci_dev *hdev,
 					 struct sk_buff *skb)
 {
-	struct hci_ev_user_passkey_req *ev = (void *) skb->data;
+	struct hci_ev_user_passkey_req *ev;
+
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_USER_PASSKEY_REQUEST,
+			     sizeof(*ev));
+	if (!ev)
+		return;
 
 	BT_DBG("%s", hdev->name);
 
@@ -4992,9 +5113,14 @@ static void hci_user_passkey_request_evt(struct hci_dev *hdev,
 static void hci_user_passkey_notify_evt(struct hci_dev *hdev,
 					struct sk_buff *skb)
 {
-	struct hci_ev_user_passkey_notify *ev = (void *) skb->data;
+	struct hci_ev_user_passkey_notify *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_USER_PASSKEY_NOTIFY,
+			     sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s", hdev->name);
 
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
@@ -5012,9 +5138,13 @@ static void hci_user_passkey_notify_evt(struct hci_dev *hdev,
 
 static void hci_keypress_notify_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_keypress_notify *ev = (void *) skb->data;
+	struct hci_ev_keypress_notify *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_KEYPRESS_NOTIFY, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s", hdev->name);
 
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
@@ -5051,9 +5181,14 @@ static void hci_keypress_notify_evt(struct hci_dev *hdev, struct sk_buff *skb)
 static void hci_simple_pair_complete_evt(struct hci_dev *hdev,
 					 struct sk_buff *skb)
 {
-	struct hci_ev_simple_pair_complete *ev = (void *) skb->data;
+	struct hci_ev_simple_pair_complete *ev;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_SIMPLE_PAIR_COMPLETE,
+			     sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s", hdev->name);
 
 	hci_dev_lock(hdev);
@@ -5082,10 +5217,15 @@ static void hci_simple_pair_complete_evt(struct hci_dev *hdev,
 static void hci_remote_host_features_evt(struct hci_dev *hdev,
 					 struct sk_buff *skb)
 {
-	struct hci_ev_remote_host_features *ev = (void *) skb->data;
+	struct hci_ev_remote_host_features *ev;
 	struct inquiry_entry *ie;
 	struct hci_conn *conn;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_REMOTE_HOST_FEATURES,
+			     sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s", hdev->name);
 
 	hci_dev_lock(hdev);
@@ -5104,9 +5244,14 @@ static void hci_remote_host_features_evt(struct hci_dev *hdev,
 static void hci_remote_oob_data_request_evt(struct hci_dev *hdev,
 					    struct sk_buff *skb)
 {
-	struct hci_ev_remote_oob_data_request *ev = (void *) skb->data;
+	struct hci_ev_remote_oob_data_request *ev;
 	struct oob_data *data;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_REMOTE_OOB_DATA_REQUEST,
+			     sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s", hdev->name);
 
 	hci_dev_lock(hdev);
@@ -5158,12 +5303,14 @@ static void hci_remote_oob_data_request_evt(struct hci_dev *hdev,
 #if IS_ENABLED(CONFIG_BT_HS)
 static void hci_chan_selected_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_channel_selected *ev = (void *)skb->data;
+	struct hci_ev_channel_selected *ev;
 	struct hci_conn *hcon;
 
-	BT_DBG("%s handle 0x%2.2x", hdev->name, ev->phy_handle);
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_CHANNEL_SELECTED, sizeof(*ev));
+	if (!ev)
+		return;
 
-	skb_pull(skb, sizeof(*ev));
+	BT_DBG("%s handle 0x%2.2x", hdev->name, ev->phy_handle);
 
 	hcon = hci_conn_hash_lookup_handle(hdev, ev->phy_handle);
 	if (!hcon)
@@ -5175,9 +5322,13 @@ static void hci_chan_selected_evt(struct hci_dev *hdev, struct sk_buff *skb)
 static void hci_phy_link_complete_evt(struct hci_dev *hdev,
 				      struct sk_buff *skb)
 {
-	struct hci_ev_phy_link_complete *ev = (void *) skb->data;
+	struct hci_ev_phy_link_complete *ev;
 	struct hci_conn *hcon, *bredr_hcon;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_PHY_LINK_COMPLETE, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s handle 0x%2.2x status 0x%2.2x", hdev->name, ev->phy_handle,
 	       ev->status);
 
@@ -5215,11 +5366,16 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
 
 static void hci_loglink_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_logical_link_complete *ev = (void *) skb->data;
+	struct hci_ev_logical_link_complete *ev;
 	struct hci_conn *hcon;
 	struct hci_chan *hchan;
 	struct amp_mgr *mgr;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_LOGICAL_LINK_COMPLETE,
+			     sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s log_handle 0x%4.4x phy_handle 0x%2.2x status 0x%2.2x",
 	       hdev->name, le16_to_cpu(ev->handle), ev->phy_handle,
 	       ev->status);
@@ -5255,9 +5411,14 @@ static void hci_loglink_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 static void hci_disconn_loglink_complete_evt(struct hci_dev *hdev,
 					     struct sk_buff *skb)
 {
-	struct hci_ev_disconn_logical_link_complete *ev = (void *) skb->data;
+	struct hci_ev_disconn_logical_link_complete *ev;
 	struct hci_chan *hchan;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_DISCONN_LOGICAL_LINK_COMPLETE,
+			     sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s log handle 0x%4.4x status 0x%2.2x", hdev->name,
 	       le16_to_cpu(ev->handle), ev->status);
 
@@ -5279,9 +5440,14 @@ static void hci_disconn_loglink_complete_evt(struct hci_dev *hdev,
 static void hci_disconn_phylink_complete_evt(struct hci_dev *hdev,
 					     struct sk_buff *skb)
 {
-	struct hci_ev_disconn_phy_link_complete *ev = (void *) skb->data;
+	struct hci_ev_disconn_phy_link_complete *ev;
 	struct hci_conn *hcon;
 
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_DISCONN_PHY_LINK_COMPLETE,
+			     sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	if (ev->status)
-- 
2.33.1

