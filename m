Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12E64643D1
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 01:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345817AbhLAAHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 19:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345691AbhLAAGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 19:06:46 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5759DC061574;
        Tue, 30 Nov 2021 16:03:10 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id l190so21600661pge.7;
        Tue, 30 Nov 2021 16:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lsOhOBdhSU1CiDhysGg3PQYSFMuGqH476MwZHjrphro=;
        b=mJw4rZOHB8gb5lENC8ReYhvVt99FJ3/jaZDIZVkzgancR9Q+0mIVdetZHbF13AcP6c
         iduBGXAleIxbtxazuSvPcNyOkgfctogNNsorTS4fXT9XN/jOdRlHMy/KLMurCI6zTqh3
         ITVa/b6CZB6tUNMdJ0XMxRsAVF0vCQGNpITh22/7KbLVPhMlSWEKwr67t9bBd/4KbRrD
         Rnb7DLMNrXiXAfrO5LX/XhNZJynMYiIMo0hGKxh/VF8sjC3dhCahkoX6uyT2I97eFhai
         OoxdQAg+c3CA4qZRIuCz2sMxivcweeIXp0Q2Ezq1JzgmjRGqfqy7E8PZkQSpwtcUYCOT
         RpMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lsOhOBdhSU1CiDhysGg3PQYSFMuGqH476MwZHjrphro=;
        b=apm9ON8O0yroAqPrW4HGE9uuTdrHNkBu7xH3f69WE8RedxqM5vBYGwUjrpPVHYKYOm
         +Sf/OSwxI+MH/Fr6e+9OSBfw6edOCtlZizY/N/TZHf9t8H4g6qFdgOKvAUPsDGDHMdRg
         BV1SiEQ9sYwWLDMY5UMRE8tyDvKrn+tmk7lO0/4T2UvEHF9gCCUesitVjBDDl1oFms+0
         hjfQZ3gMTAznyOR3p5pC6Cwt1+goI2CD6e+TnkTEUvlx5ntiH1kqSUCjCslA0OV7uckG
         9aWKq24k+HHD8SPtlAnabG0s0/jOFcFHinwrOA9jleqf59IG9r96ZqYAoKB2VYOygK4R
         302Q==
X-Gm-Message-State: AOAM530k5lT4O4RzDLv/AyBCXJ6HnUt7hDJgDGNVApmXsVHS/qjKQJsO
        9skVvq0RaWIqUzHq+4ZWHHwVHNqURaI=
X-Google-Smtp-Source: ABdhPJyYnO5ywInh9lKFzznAztfIVyF2vBkWX2HsZy6+7odtdopngd+3URGYoLcnUgIZMl3Xq3RWBw==
X-Received: by 2002:a63:6b83:: with SMTP id g125mr1943683pgc.578.1638316989663;
        Tue, 30 Nov 2021 16:03:09 -0800 (PST)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id j13sm21001739pfc.151.2021.11.30.16.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 16:03:09 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        dan.carpenter@oracle.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 12/15] Bluetooth: hci_event: Use of a function table to handle HCI events
Date:   Tue, 30 Nov 2021 16:02:12 -0800
Message-Id: <20211201000215.1134831-13-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201000215.1134831-1-luiz.dentz@gmail.com>
References: <20211201000215.1134831-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

This change the use of switch statement to a function table
which is easier to extend and can include min/max length of each HCI
event.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
---
 net/bluetooth/hci_event.c | 903 ++++++++++++++++----------------------
 net/bluetooth/msft.c      |   2 +-
 net/bluetooth/msft.h      |   2 +-
 3 files changed, 391 insertions(+), 516 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 8f21405997d1..6fbb16997849 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3126,17 +3126,14 @@ static void hci_cs_switch_role(struct hci_dev *hdev, u8 status)
 	hci_dev_unlock(hdev);
 }
 
-static void hci_inquiry_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_inquiry_complete_evt(struct hci_dev *hdev, void *data,
+				     struct sk_buff *skb)
 {
-	struct hci_ev_status *ev;
+	struct hci_ev_status *ev = data;
 	struct discovery_state *discov = &hdev->discovery;
 	struct inquiry_entry *e;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_INQUIRY_COMPLETE, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_conn_check_pending(hdev);
 
@@ -3190,21 +3187,18 @@ static void hci_inquiry_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 }
 
-static void hci_inquiry_result_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_inquiry_result_evt(struct hci_dev *hdev, void *edata,
+				   struct sk_buff *skb)
 {
-	struct hci_ev_inquiry_result *ev;
+	struct hci_ev_inquiry_result *ev = edata;
 	struct inquiry_data data;
 	int i;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_INQUIRY_RESULT, sizeof(*ev));
-	if (!ev)
-		return;
-
 	if (!hci_ev_skb_pull(hdev, skb, HCI_EV_INQUIRY_RESULT,
 			     flex_array_size(ev, info, ev->num)))
 		return;
 
-	BT_DBG("%s num %d", hdev->name, ev->num);
+	bt_dev_dbg(hdev, "num %d", ev->num);
 
 	if (!ev->num)
 		return;
@@ -3237,16 +3231,13 @@ static void hci_inquiry_result_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 }
 
-static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_conn_complete_evt(struct hci_dev *hdev, void *data,
+				  struct sk_buff *skb)
 {
-	struct hci_ev_conn_complete *ev;
+	struct hci_ev_conn_complete *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_CONN_COMPLETE, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s", hdev->name);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
 
@@ -3365,20 +3356,16 @@ static void hci_reject_conn(struct hci_dev *hdev, bdaddr_t *bdaddr)
 	hci_send_cmd(hdev, HCI_OP_REJECT_CONN_REQ, sizeof(cp), &cp);
 }
 
-static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_conn_request_evt(struct hci_dev *hdev, void *data,
+				 struct sk_buff *skb)
 {
-	struct hci_ev_conn_request *ev;
+	struct hci_ev_conn_request *ev = data;
 	int mask = hdev->link_mode;
 	struct inquiry_entry *ie;
 	struct hci_conn *conn;
 	__u8 flags = 0;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_CONN_REQUEST, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s bdaddr %pMR type 0x%x", hdev->name, &ev->bdaddr,
-	       ev->link_type);
+	bt_dev_dbg(hdev, "bdaddr %pMR type 0x%x", &ev->bdaddr, ev->link_type);
 
 	mask |= hci_proto_connect_ind(hdev, &ev->bdaddr, ev->link_type,
 				      &flags);
@@ -3480,19 +3467,16 @@ static u8 hci_to_mgmt_reason(u8 err)
 	}
 }
 
-static void hci_disconn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_disconn_complete_evt(struct hci_dev *hdev, void *data,
+				     struct sk_buff *skb)
 {
-	struct hci_ev_disconn_complete *ev;
+	struct hci_ev_disconn_complete *ev = data;
 	u8 reason;
 	struct hci_conn_params *params;
 	struct hci_conn *conn;
 	bool mgmt_connected;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_DISCONN_COMPLETE, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
 
@@ -3568,16 +3552,13 @@ static void hci_disconn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 }
 
-static void hci_auth_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_auth_complete_evt(struct hci_dev *hdev, void *data,
+				  struct sk_buff *skb)
 {
-	struct hci_ev_auth_complete *ev;
+	struct hci_ev_auth_complete *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_AUTH_COMPLETE, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
 
@@ -3642,16 +3623,13 @@ static void hci_auth_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 }
 
-static void hci_remote_name_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_remote_name_evt(struct hci_dev *hdev, void *data,
+				struct sk_buff *skb)
 {
-	struct hci_ev_remote_name *ev;
+	struct hci_ev_remote_name *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_REMOTE_NAME, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s", hdev->name);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_conn_check_pending(hdev);
 
@@ -3729,16 +3707,13 @@ static void read_enc_key_size_complete(struct hci_dev *hdev, u8 status,
 	hci_dev_unlock(hdev);
 }
 
-static void hci_encrypt_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_encrypt_change_evt(struct hci_dev *hdev, void *data,
+				   struct sk_buff *skb)
 {
-	struct hci_ev_encrypt_change *ev;
+	struct hci_ev_encrypt_change *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_ENCRYPT_CHANGE, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
 
@@ -3847,18 +3822,13 @@ static void hci_encrypt_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 }
 
-static void hci_change_link_key_complete_evt(struct hci_dev *hdev,
+static void hci_change_link_key_complete_evt(struct hci_dev *hdev, void *data,
 					     struct sk_buff *skb)
 {
-	struct hci_ev_change_link_key_complete *ev;
+	struct hci_ev_change_link_key_complete *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_CHANGE_LINK_KEY_COMPLETE,
-			     sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
 
@@ -3875,17 +3845,13 @@ static void hci_change_link_key_complete_evt(struct hci_dev *hdev,
 	hci_dev_unlock(hdev);
 }
 
-static void hci_remote_features_evt(struct hci_dev *hdev,
+static void hci_remote_features_evt(struct hci_dev *hdev, void *data,
 				    struct sk_buff *skb)
 {
-	struct hci_ev_remote_features *ev;
+	struct hci_ev_remote_features *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_REMOTE_FEATURES, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
 
@@ -3943,16 +3909,12 @@ static inline void handle_cmd_cnt_and_timer(struct hci_dev *hdev, u8 ncmd)
 	}
 }
 
-static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
-				 u16 *opcode, u8 *status,
+static void hci_cmd_complete_evt(struct hci_dev *hdev, void *data,
+				 struct sk_buff *skb, u16 *opcode, u8 *status,
 				 hci_req_complete_t *req_complete,
 				 hci_req_complete_skb_t *req_complete_skb)
 {
-	struct hci_ev_cmd_complete *ev;
-
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_CMD_COMPLETE, sizeof(*ev));
-	if (!ev)
-		return;
+	struct hci_ev_cmd_complete *ev = data;
 
 	*opcode = __le16_to_cpu(ev->opcode);
 	*status = skb->data[0];
@@ -4330,16 +4292,12 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
 		queue_work(hdev->workqueue, &hdev->cmd_work);
 }
 
-static void hci_cmd_status_evt(struct hci_dev *hdev, struct sk_buff *skb,
-			       u16 *opcode, u8 *status,
+static void hci_cmd_status_evt(struct hci_dev *hdev, void *data,
+			       struct sk_buff *skb, u16 *opcode, u8 *status,
 			       hci_req_complete_t *req_complete,
 			       hci_req_complete_skb_t *req_complete_skb)
 {
-	struct hci_ev_cmd_status *ev;
-
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_CMD_STATUS, sizeof(*ev));
-	if (!ev)
-		return;
+	struct hci_ev_cmd_status *ev = data;
 
 	*opcode = __le16_to_cpu(ev->opcode);
 	*status = ev->status;
@@ -4445,29 +4403,25 @@ static void hci_cmd_status_evt(struct hci_dev *hdev, struct sk_buff *skb,
 		queue_work(hdev->workqueue, &hdev->cmd_work);
 }
 
-static void hci_hardware_error_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_hardware_error_evt(struct hci_dev *hdev, void *data,
+				   struct sk_buff *skb)
 {
-	struct hci_ev_hardware_error *ev;
+	struct hci_ev_hardware_error *ev = data;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_HARDWARE_ERROR, sizeof(*ev));
-	if (!ev)
-		return;
+	bt_dev_dbg(hdev, "code 0x%2.2x", ev->code);
 
 	hdev->hw_error_code = ev->code;
 
 	queue_work(hdev->req_workqueue, &hdev->error_reset);
 }
 
-static void hci_role_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_role_change_evt(struct hci_dev *hdev, void *data,
+				struct sk_buff *skb)
 {
-	struct hci_ev_role_change *ev;
+	struct hci_ev_role_change *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_ROLE_CHANGE, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
 
@@ -4484,15 +4438,12 @@ static void hci_role_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 }
 
-static void hci_num_comp_pkts_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_num_comp_pkts_evt(struct hci_dev *hdev, void *data,
+				  struct sk_buff *skb)
 {
-	struct hci_ev_num_comp_pkts *ev;
+	struct hci_ev_num_comp_pkts *ev = data;
 	int i;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_NUM_COMP_PKTS, sizeof(*ev));
-	if (!ev)
-		return;
-
 	if (!hci_ev_skb_pull(hdev, skb, HCI_EV_NUM_COMP_PKTS,
 			     flex_array_size(ev, handles, ev->num)))
 		return;
@@ -4502,7 +4453,7 @@ static void hci_num_comp_pkts_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		return;
 	}
 
-	BT_DBG("%s num %d", hdev->name, ev->num);
+	bt_dev_dbg(hdev, "num %d", ev->num);
 
 	for (i = 0; i < ev->num; i++) {
 		struct hci_comp_pkts_info *info = &ev->handles[i];
@@ -4574,26 +4525,24 @@ static struct hci_conn *__hci_conn_lookup_handle(struct hci_dev *hdev,
 	return NULL;
 }
 
-static void hci_num_comp_blocks_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_num_comp_blocks_evt(struct hci_dev *hdev, void *data,
+				    struct sk_buff *skb)
 {
-	struct hci_ev_num_comp_blocks *ev;
+	struct hci_ev_num_comp_blocks *ev = data;
 	int i;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_NUM_COMP_BLOCKS, sizeof(*ev));
-	if (!ev)
-		return;
-
 	if (!hci_ev_skb_pull(hdev, skb, HCI_EV_NUM_COMP_BLOCKS,
 			     flex_array_size(ev, handles, ev->num_hndl)))
 		return;
 
 	if (hdev->flow_ctl_mode != HCI_FLOW_CTL_MODE_BLOCK_BASED) {
-		bt_dev_err(hdev, "wrong event for mode %d", hdev->flow_ctl_mode);
+		bt_dev_err(hdev, "wrong event for mode %d",
+			   hdev->flow_ctl_mode);
 		return;
 	}
 
-	BT_DBG("%s num_blocks %d num_hndl %d", hdev->name, ev->num_blocks,
-	       ev->num_hndl);
+	bt_dev_dbg(hdev, "num_blocks %d num_hndl %d", ev->num_blocks,
+		   ev->num_hndl);
 
 	for (i = 0; i < ev->num_hndl; i++) {
 		struct hci_comp_blocks_info *info = &ev->handles[i];
@@ -4627,16 +4576,13 @@ static void hci_num_comp_blocks_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	queue_work(hdev->workqueue, &hdev->tx_work);
 }
 
-static void hci_mode_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_mode_change_evt(struct hci_dev *hdev, void *data,
+				struct sk_buff *skb)
 {
-	struct hci_ev_mode_change *ev;
+	struct hci_ev_mode_change *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_MODE_CHANGE, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
 
@@ -4659,16 +4605,13 @@ static void hci_mode_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 }
 
-static void hci_pin_code_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_pin_code_request_evt(struct hci_dev *hdev, void *data,
+				     struct sk_buff *skb)
 {
-	struct hci_ev_pin_code_req *ev;
+	struct hci_ev_pin_code_req *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_PIN_CODE_REQ, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s", hdev->name);
+	bt_dev_dbg(hdev, "");
 
 	hci_dev_lock(hdev);
 
@@ -4733,18 +4676,15 @@ static void conn_set_key(struct hci_conn *conn, u8 key_type, u8 pin_len)
 	}
 }
 
-static void hci_link_key_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_link_key_request_evt(struct hci_dev *hdev, void *data,
+				     struct sk_buff *skb)
 {
-	struct hci_ev_link_key_req *ev;
+	struct hci_ev_link_key_req *ev = data;
 	struct hci_cp_link_key_reply cp;
 	struct hci_conn *conn;
 	struct link_key *key;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_LINK_KEY_REQ, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s", hdev->name);
+	bt_dev_dbg(hdev, "");
 
 	if (!hci_dev_test_flag(hdev, HCI_MGMT))
 		return;
@@ -4753,13 +4693,11 @@ static void hci_link_key_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 	key = hci_find_link_key(hdev, &ev->bdaddr);
 	if (!key) {
-		BT_DBG("%s link key not found for %pMR", hdev->name,
-		       &ev->bdaddr);
+		bt_dev_dbg(hdev, "link key not found for %pMR", &ev->bdaddr);
 		goto not_found;
 	}
 
-	BT_DBG("%s found key type %u for %pMR", hdev->name, key->type,
-	       &ev->bdaddr);
+	bt_dev_dbg(hdev, "found key type %u for %pMR", key->type, &ev->bdaddr);
 
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
 	if (conn) {
@@ -4768,15 +4706,14 @@ static void hci_link_key_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		if ((key->type == HCI_LK_UNAUTH_COMBINATION_P192 ||
 		     key->type == HCI_LK_UNAUTH_COMBINATION_P256) &&
 		    conn->auth_type != 0xff && (conn->auth_type & 0x01)) {
-			BT_DBG("%s ignoring unauthenticated key", hdev->name);
+			bt_dev_dbg(hdev, "ignoring unauthenticated key");
 			goto not_found;
 		}
 
 		if (key->type == HCI_LK_COMBINATION && key->pin_len < 16 &&
 		    (conn->pending_sec_level == BT_SECURITY_HIGH ||
 		     conn->pending_sec_level == BT_SECURITY_FIPS)) {
-			BT_DBG("%s ignoring key unauthenticated for high security",
-			       hdev->name);
+			bt_dev_dbg(hdev, "ignoring key unauthenticated for high security");
 			goto not_found;
 		}
 
@@ -4797,19 +4734,16 @@ static void hci_link_key_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 }
 
-static void hci_link_key_notify_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_link_key_notify_evt(struct hci_dev *hdev, void *data,
+				    struct sk_buff *skb)
 {
-	struct hci_ev_link_key_notify *ev;
+	struct hci_ev_link_key_notify *ev = data;
 	struct hci_conn *conn;
 	struct link_key *key;
 	bool persistent;
 	u8 pin_len = 0;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_LINK_KEY_NOTIFY, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s", hdev->name);
+	bt_dev_dbg(hdev, "");
 
 	hci_dev_lock(hdev);
 
@@ -4861,16 +4795,13 @@ static void hci_link_key_notify_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 }
 
-static void hci_clock_offset_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_clock_offset_evt(struct hci_dev *hdev, void *data,
+				 struct sk_buff *skb)
 {
-	struct hci_ev_clock_offset *ev;
+	struct hci_ev_clock_offset *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_CLOCK_OFFSET, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
 
@@ -4888,16 +4819,13 @@ static void hci_clock_offset_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 }
 
-static void hci_pkt_type_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_pkt_type_change_evt(struct hci_dev *hdev, void *data,
+				    struct sk_buff *skb)
 {
-	struct hci_ev_pkt_type_change *ev;
+	struct hci_ev_pkt_type_change *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_PKT_TYPE_CHANGE, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
 
@@ -4908,16 +4836,13 @@ static void hci_pkt_type_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 }
 
-static void hci_pscan_rep_mode_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_pscan_rep_mode_evt(struct hci_dev *hdev, void *data,
+				   struct sk_buff *skb)
 {
-	struct hci_ev_pscan_rep_mode *ev;
+	struct hci_ev_pscan_rep_mode *ev = data;
 	struct inquiry_entry *ie;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_PSCAN_REP_MODE, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s", hdev->name);
+	bt_dev_dbg(hdev, "");
 
 	hci_dev_lock(hdev);
 
@@ -4930,22 +4855,17 @@ static void hci_pscan_rep_mode_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 }
 
-static void hci_inquiry_result_with_rssi_evt(struct hci_dev *hdev,
+static void hci_inquiry_result_with_rssi_evt(struct hci_dev *hdev, void *edata,
 					     struct sk_buff *skb)
 {
 	union {
 		struct hci_ev_inquiry_result_rssi *res1;
 		struct hci_ev_inquiry_result_rssi_pscan *res2;
-	} *ev;
+	} *ev = edata;
 	struct inquiry_data data;
 	int i;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_INQUIRY_RESULT_WITH_RSSI,
-			     sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s num_rsp %d", hdev->name, ev->res1->num);
+	bt_dev_dbg(hdev, "num_rsp %d", ev->res1->num);
 
 	if (!ev->res1->num)
 		return;
@@ -5007,18 +4927,13 @@ static void hci_inquiry_result_with_rssi_evt(struct hci_dev *hdev,
 	hci_dev_unlock(hdev);
 }
 
-static void hci_remote_ext_features_evt(struct hci_dev *hdev,
+static void hci_remote_ext_features_evt(struct hci_dev *hdev, void *data,
 					struct sk_buff *skb)
 {
-	struct hci_ev_remote_ext_features *ev;
+	struct hci_ev_remote_ext_features *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_REMOTE_EXT_FEATURES,
-			     sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s", hdev->name);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
 
@@ -5076,17 +4991,13 @@ static void hci_remote_ext_features_evt(struct hci_dev *hdev,
 	hci_dev_unlock(hdev);
 }
 
-static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
+static void hci_sync_conn_complete_evt(struct hci_dev *hdev, void *data,
 				       struct sk_buff *skb)
 {
-	struct hci_ev_sync_conn_complete *ev;
+	struct hci_ev_sync_conn_complete *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_SYNC_CONN_COMPLETE, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
 
@@ -5195,24 +5106,19 @@ static inline size_t eir_get_length(u8 *eir, size_t eir_len)
 	return eir_len;
 }
 
-static void hci_extended_inquiry_result_evt(struct hci_dev *hdev,
+static void hci_extended_inquiry_result_evt(struct hci_dev *hdev, void *edata,
 					    struct sk_buff *skb)
 {
-	struct hci_ev_ext_inquiry_result *ev;
+	struct hci_ev_ext_inquiry_result *ev = edata;
 	struct inquiry_data data;
 	size_t eir_len;
 	int i;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_EXTENDED_INQUIRY_RESULT,
-			     sizeof(*ev));
-	if (!ev)
-		return;
-
 	if (!hci_ev_skb_pull(hdev, skb, HCI_EV_EXTENDED_INQUIRY_RESULT,
 			     flex_array_size(ev, info, ev->num)))
 		return;
 
-	BT_DBG("%s num %d", hdev->name, ev->num);
+	bt_dev_dbg(hdev, "num %d", ev->num);
 
 	if (!ev->num)
 		return;
@@ -5255,19 +5161,14 @@ static void hci_extended_inquiry_result_evt(struct hci_dev *hdev,
 	hci_dev_unlock(hdev);
 }
 
-static void hci_key_refresh_complete_evt(struct hci_dev *hdev,
+static void hci_key_refresh_complete_evt(struct hci_dev *hdev, void *data,
 					 struct sk_buff *skb)
 {
-	struct hci_ev_key_refresh_complete *ev;
+	struct hci_ev_key_refresh_complete *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_KEY_REFRESH_COMPLETE,
-			     sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s status 0x%2.2x handle 0x%4.4x", hdev->name, ev->status,
-	       __le16_to_cpu(ev->handle));
+	bt_dev_dbg(hdev, "status 0x%2.2x handle 0x%4.4x", ev->status,
+		   __le16_to_cpu(ev->handle));
 
 	hci_dev_lock(hdev);
 
@@ -5370,16 +5271,13 @@ static u8 bredr_oob_data_present(struct hci_conn *conn)
 	return 0x01;
 }
 
-static void hci_io_capa_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_io_capa_request_evt(struct hci_dev *hdev, void *data,
+				    struct sk_buff *skb)
 {
-	struct hci_ev_io_capa_request *ev;
+	struct hci_ev_io_capa_request *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_IO_CAPA_REQUEST, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s", hdev->name);
+	bt_dev_dbg(hdev, "");
 
 	hci_dev_lock(hdev);
 
@@ -5443,16 +5341,13 @@ static void hci_io_capa_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 }
 
-static void hci_io_capa_reply_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_io_capa_reply_evt(struct hci_dev *hdev, void *data,
+				  struct sk_buff *skb)
 {
-	struct hci_ev_io_capa_reply *ev;
+	struct hci_ev_io_capa_reply *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_IO_CAPA_REPLY, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s", hdev->name);
+	bt_dev_dbg(hdev, "");
 
 	hci_dev_lock(hdev);
 
@@ -5467,19 +5362,14 @@ static void hci_io_capa_reply_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 }
 
-static void hci_user_confirm_request_evt(struct hci_dev *hdev,
+static void hci_user_confirm_request_evt(struct hci_dev *hdev, void *data,
 					 struct sk_buff *skb)
 {
-	struct hci_ev_user_confirm_req *ev;
+	struct hci_ev_user_confirm_req *ev = data;
 	int loc_mitm, rem_mitm, confirm_hint = 0;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_USER_CONFIRM_REQUEST,
-			     sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s", hdev->name);
+	bt_dev_dbg(hdev, "");
 
 	hci_dev_lock(hdev);
 
@@ -5500,7 +5390,7 @@ static void hci_user_confirm_request_evt(struct hci_dev *hdev,
 	 */
 	if (conn->pending_sec_level > BT_SECURITY_MEDIUM &&
 	    conn->remote_cap == HCI_IO_NO_INPUT_OUTPUT) {
-		BT_DBG("Rejecting request: remote device can't provide MITM");
+		bt_dev_dbg(hdev, "Rejecting request: remote device can't provide MITM");
 		hci_send_cmd(hdev, HCI_OP_USER_CONFIRM_NEG_REPLY,
 			     sizeof(ev->bdaddr), &ev->bdaddr);
 		goto unlock;
@@ -5519,7 +5409,7 @@ static void hci_user_confirm_request_evt(struct hci_dev *hdev,
 		if (!test_bit(HCI_CONN_AUTH_PEND, &conn->flags) &&
 		    conn->io_capability != HCI_IO_NO_INPUT_OUTPUT &&
 		    (loc_mitm || rem_mitm)) {
-			BT_DBG("Confirming auto-accept as acceptor");
+			bt_dev_dbg(hdev, "Confirming auto-accept as acceptor");
 			confirm_hint = 1;
 			goto confirm;
 		}
@@ -5557,34 +5447,24 @@ static void hci_user_confirm_request_evt(struct hci_dev *hdev,
 	hci_dev_unlock(hdev);
 }
 
-static void hci_user_passkey_request_evt(struct hci_dev *hdev,
+static void hci_user_passkey_request_evt(struct hci_dev *hdev, void *data,
 					 struct sk_buff *skb)
 {
-	struct hci_ev_user_passkey_req *ev;
-
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_USER_PASSKEY_REQUEST,
-			     sizeof(*ev));
-	if (!ev)
-		return;
+	struct hci_ev_user_passkey_req *ev = data;
 
-	BT_DBG("%s", hdev->name);
+	bt_dev_dbg(hdev, "");
 
 	if (hci_dev_test_flag(hdev, HCI_MGMT))
 		mgmt_user_passkey_request(hdev, &ev->bdaddr, ACL_LINK, 0);
 }
 
-static void hci_user_passkey_notify_evt(struct hci_dev *hdev,
+static void hci_user_passkey_notify_evt(struct hci_dev *hdev, void *data,
 					struct sk_buff *skb)
 {
-	struct hci_ev_user_passkey_notify *ev;
+	struct hci_ev_user_passkey_notify *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_USER_PASSKEY_NOTIFY,
-			     sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s", hdev->name);
+	bt_dev_dbg(hdev, "");
 
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
 	if (!conn)
@@ -5599,16 +5479,13 @@ static void hci_user_passkey_notify_evt(struct hci_dev *hdev,
 					 conn->passkey_entered);
 }
 
-static void hci_keypress_notify_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_keypress_notify_evt(struct hci_dev *hdev, void *data,
+				    struct sk_buff *skb)
 {
-	struct hci_ev_keypress_notify *ev;
+	struct hci_ev_keypress_notify *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_KEYPRESS_NOTIFY, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s", hdev->name);
+	bt_dev_dbg(hdev, "");
 
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
 	if (!conn)
@@ -5641,18 +5518,13 @@ static void hci_keypress_notify_evt(struct hci_dev *hdev, struct sk_buff *skb)
 					 conn->passkey_entered);
 }
 
-static void hci_simple_pair_complete_evt(struct hci_dev *hdev,
+static void hci_simple_pair_complete_evt(struct hci_dev *hdev, void *data,
 					 struct sk_buff *skb)
 {
-	struct hci_ev_simple_pair_complete *ev;
+	struct hci_ev_simple_pair_complete *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_SIMPLE_PAIR_COMPLETE,
-			     sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s", hdev->name);
+	bt_dev_dbg(hdev, "");
 
 	hci_dev_lock(hdev);
 
@@ -5677,19 +5549,14 @@ static void hci_simple_pair_complete_evt(struct hci_dev *hdev,
 	hci_dev_unlock(hdev);
 }
 
-static void hci_remote_host_features_evt(struct hci_dev *hdev,
+static void hci_remote_host_features_evt(struct hci_dev *hdev, void *data,
 					 struct sk_buff *skb)
 {
-	struct hci_ev_remote_host_features *ev;
+	struct hci_ev_remote_host_features *ev = data;
 	struct inquiry_entry *ie;
 	struct hci_conn *conn;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_REMOTE_HOST_FEATURES,
-			     sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s", hdev->name);
+	bt_dev_dbg(hdev, "");
 
 	hci_dev_lock(hdev);
 
@@ -5704,18 +5571,13 @@ static void hci_remote_host_features_evt(struct hci_dev *hdev,
 	hci_dev_unlock(hdev);
 }
 
-static void hci_remote_oob_data_request_evt(struct hci_dev *hdev,
+static void hci_remote_oob_data_request_evt(struct hci_dev *hdev, void *edata,
 					    struct sk_buff *skb)
 {
-	struct hci_ev_remote_oob_data_request *ev;
+	struct hci_ev_remote_oob_data_request *ev = edata;
 	struct oob_data *data;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_REMOTE_OOB_DATA_REQUEST,
-			     sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s", hdev->name);
+	bt_dev_dbg(hdev, "");
 
 	hci_dev_lock(hdev);
 
@@ -5764,16 +5626,13 @@ static void hci_remote_oob_data_request_evt(struct hci_dev *hdev,
 }
 
 #if IS_ENABLED(CONFIG_BT_HS)
-static void hci_chan_selected_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_chan_selected_evt(struct hci_dev *hdev, void *data,
+				  struct sk_buff *skb)
 {
-	struct hci_ev_channel_selected *ev;
+	struct hci_ev_channel_selected *ev = data;
 	struct hci_conn *hcon;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_CHANNEL_SELECTED, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s handle 0x%2.2x", hdev->name, ev->phy_handle);
+	bt_dev_dbg(hdev, "handle 0x%2.2x", ev->phy_handle);
 
 	hcon = hci_conn_hash_lookup_handle(hdev, ev->phy_handle);
 	if (!hcon)
@@ -5782,18 +5641,14 @@ static void hci_chan_selected_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	amp_read_loc_assoc_final_data(hdev, hcon);
 }
 
-static void hci_phy_link_complete_evt(struct hci_dev *hdev,
+static void hci_phy_link_complete_evt(struct hci_dev *hdev, void *data,
 				      struct sk_buff *skb)
 {
-	struct hci_ev_phy_link_complete *ev;
+	struct hci_ev_phy_link_complete *ev = data;
 	struct hci_conn *hcon, *bredr_hcon;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_PHY_LINK_COMPLETE, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s handle 0x%2.2x status 0x%2.2x", hdev->name, ev->phy_handle,
-	       ev->status);
+	bt_dev_dbg(hdev, "handle 0x%2.2x status 0x%2.2x", ev->phy_handle,
+		   ev->status);
 
 	hci_dev_lock(hdev);
 
@@ -5827,21 +5682,16 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
 	hci_dev_unlock(hdev);
 }
 
-static void hci_loglink_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_loglink_complete_evt(struct hci_dev *hdev, void *data,
+				     struct sk_buff *skb)
 {
-	struct hci_ev_logical_link_complete *ev;
+	struct hci_ev_logical_link_complete *ev = data;
 	struct hci_conn *hcon;
 	struct hci_chan *hchan;
 	struct amp_mgr *mgr;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_LOGICAL_LINK_COMPLETE,
-			     sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s log_handle 0x%4.4x phy_handle 0x%2.2x status 0x%2.2x",
-	       hdev->name, le16_to_cpu(ev->handle), ev->phy_handle,
-	       ev->status);
+	bt_dev_dbg(hdev, "log_handle 0x%4.4x phy_handle 0x%2.2x status 0x%2.2x",
+		   le16_to_cpu(ev->handle), ev->phy_handle, ev->status);
 
 	hcon = hci_conn_hash_lookup_handle(hdev, ev->phy_handle);
 	if (!hcon)
@@ -5871,19 +5721,14 @@ static void hci_loglink_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	}
 }
 
-static void hci_disconn_loglink_complete_evt(struct hci_dev *hdev,
+static void hci_disconn_loglink_complete_evt(struct hci_dev *hdev, void *data,
 					     struct sk_buff *skb)
 {
-	struct hci_ev_disconn_logical_link_complete *ev;
+	struct hci_ev_disconn_logical_link_complete *ev = data;
 	struct hci_chan *hchan;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_DISCONN_LOGICAL_LINK_COMPLETE,
-			     sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s log handle 0x%4.4x status 0x%2.2x", hdev->name,
-	       le16_to_cpu(ev->handle), ev->status);
+	bt_dev_dbg(hdev, "handle 0x%4.4x status 0x%2.2x",
+		   le16_to_cpu(ev->handle), ev->status);
 
 	if (ev->status)
 		return;
@@ -5900,18 +5745,13 @@ static void hci_disconn_loglink_complete_evt(struct hci_dev *hdev,
 	hci_dev_unlock(hdev);
 }
 
-static void hci_disconn_phylink_complete_evt(struct hci_dev *hdev,
+static void hci_disconn_phylink_complete_evt(struct hci_dev *hdev, void *data,
 					     struct sk_buff *skb)
 {
-	struct hci_ev_disconn_phy_link_complete *ev;
+	struct hci_ev_disconn_phy_link_complete *ev = data;
 	struct hci_conn *hcon;
 
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_DISCONN_PHY_LINK_COMPLETE,
-			     sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	if (ev->status)
 		return;
@@ -6938,13 +6778,10 @@ static void hci_le_phy_update_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 }
 
-static void hci_le_meta_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_le_meta_evt(struct hci_dev *hdev, void *data,
+			    struct sk_buff *skb)
 {
-	struct hci_ev_le_meta *ev;
-
-	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_LE_META, sizeof(*ev));
-	if (!ev)
-		return;
+	struct hci_ev_le_meta *ev = data;
 
 	switch (ev->subevent) {
 	case HCI_EV_LE_CONN_COMPLETE:
@@ -7109,6 +6946,224 @@ static void hci_store_wake_reason(struct hci_dev *hdev, u8 event,
 	hci_dev_unlock(hdev);
 }
 
+#define HCI_EV_VL(_op, _func, _min_len, _max_len) \
+[_op] = { \
+	.req = false, \
+	.func = _func, \
+	.min_len = _min_len, \
+	.max_len = _max_len, \
+}
+
+#define HCI_EV(_op, _func, _len) \
+	HCI_EV_VL(_op, _func, _len, _len)
+
+#define HCI_EV_STATUS(_op, _func) \
+	HCI_EV(_op, _func, sizeof(struct hci_ev_status))
+
+#define HCI_EV_REQ_VL(_op, _func, _min_len, _max_len) \
+[_op] = { \
+	.req = true, \
+	.func_req = _func, \
+	.min_len = _min_len, \
+	.max_len = _max_len, \
+}
+
+#define HCI_EV_REQ(_op, _func, _len) \
+	HCI_EV_REQ_VL(_op, _func, _len, _len)
+
+/* Entries in this table shall have their position according to the event opcode
+ * they handle so the use of the macros above is recommend since it does attempt
+ * to initialize at its proper index using Designated Initializers that way
+ * events without a callback function don't have entered.
+ */
+static const struct hci_ev {
+	bool req;
+	union {
+		void (*func)(struct hci_dev *hdev, void *data,
+			     struct sk_buff *skb);
+		void (*func_req)(struct hci_dev *hdev, void *data,
+				 struct sk_buff *skb, u16 *opcode, u8 *status,
+				 hci_req_complete_t *req_complete,
+				 hci_req_complete_skb_t *req_complete_skb);
+	};
+	u16  min_len;
+	u16  max_len;
+} hci_ev_table[U8_MAX + 1] = {
+	/* [0x01 = HCI_EV_INQUIRY_COMPLETE] */
+	HCI_EV_STATUS(HCI_EV_INQUIRY_COMPLETE, hci_inquiry_complete_evt),
+	/* [0x02 = HCI_EV_INQUIRY_RESULT] */
+	HCI_EV_VL(HCI_EV_INQUIRY_RESULT, hci_inquiry_result_evt,
+		  sizeof(struct hci_ev_inquiry_result), HCI_MAX_EVENT_SIZE),
+	/* [0x03 = HCI_EV_CONN_COMPLETE] */
+	HCI_EV(HCI_EV_CONN_COMPLETE, hci_conn_complete_evt,
+	       sizeof(struct hci_ev_conn_complete)),
+	/* [0x04 = HCI_EV_CONN_REQUEST] */
+	HCI_EV(HCI_EV_CONN_REQUEST, hci_conn_request_evt,
+	       sizeof(struct hci_ev_conn_request)),
+	/* [0x05 = HCI_EV_DISCONN_COMPLETE] */
+	HCI_EV(HCI_EV_DISCONN_COMPLETE, hci_disconn_complete_evt,
+	       sizeof(struct hci_ev_disconn_complete)),
+	/* [0x06 = HCI_EV_AUTH_COMPLETE] */
+	HCI_EV(HCI_EV_AUTH_COMPLETE, hci_auth_complete_evt,
+	       sizeof(struct hci_ev_auth_complete)),
+	/* [0x07 = HCI_EV_REMOTE_NAME] */
+	HCI_EV(HCI_EV_REMOTE_NAME, hci_remote_name_evt,
+	       sizeof(struct hci_ev_remote_name)),
+	/* [0x08 = HCI_EV_ENCRYPT_CHANGE] */
+	HCI_EV(HCI_EV_ENCRYPT_CHANGE, hci_encrypt_change_evt,
+	       sizeof(struct hci_ev_encrypt_change)),
+	/* [0x09 = HCI_EV_CHANGE_LINK_KEY_COMPLETE] */
+	HCI_EV(HCI_EV_CHANGE_LINK_KEY_COMPLETE,
+	       hci_change_link_key_complete_evt,
+	       sizeof(struct hci_ev_change_link_key_complete)),
+	/* [0x0b = HCI_EV_REMOTE_FEATURES] */
+	HCI_EV(HCI_EV_REMOTE_FEATURES, hci_remote_features_evt,
+	       sizeof(struct hci_ev_remote_features)),
+	/* [0x0e = HCI_EV_CMD_COMPLETE] */
+	HCI_EV_REQ_VL(HCI_EV_CMD_COMPLETE, hci_cmd_complete_evt,
+		      sizeof(struct hci_ev_cmd_complete), HCI_MAX_EVENT_SIZE),
+	/* [0x0f = HCI_EV_CMD_STATUS] */
+	HCI_EV_REQ(HCI_EV_CMD_STATUS, hci_cmd_status_evt,
+		   sizeof(struct hci_ev_cmd_status)),
+	/* [0x10 = HCI_EV_CMD_STATUS] */
+	HCI_EV(HCI_EV_HARDWARE_ERROR, hci_hardware_error_evt,
+	       sizeof(struct hci_ev_hardware_error)),
+	/* [0x12 = HCI_EV_ROLE_CHANGE] */
+	HCI_EV(HCI_EV_ROLE_CHANGE, hci_role_change_evt,
+	       sizeof(struct hci_ev_role_change)),
+	/* [0x13 = HCI_EV_NUM_COMP_PKTS] */
+	HCI_EV_VL(HCI_EV_NUM_COMP_PKTS, hci_num_comp_pkts_evt,
+		  sizeof(struct hci_ev_num_comp_pkts), HCI_MAX_EVENT_SIZE),
+	/* [0x14 = HCI_EV_MODE_CHANGE] */
+	HCI_EV(HCI_EV_MODE_CHANGE, hci_mode_change_evt,
+	       sizeof(struct hci_ev_mode_change)),
+	/* [0x16 = HCI_EV_PIN_CODE_REQ] */
+	HCI_EV(HCI_EV_PIN_CODE_REQ, hci_pin_code_request_evt,
+	       sizeof(struct hci_ev_pin_code_req)),
+	/* [0x17 = HCI_EV_LINK_KEY_REQ] */
+	HCI_EV(HCI_EV_LINK_KEY_REQ, hci_link_key_request_evt,
+	       sizeof(struct hci_ev_link_key_req)),
+	/* [0x18 = HCI_EV_LINK_KEY_NOTIFY] */
+	HCI_EV(HCI_EV_LINK_KEY_NOTIFY, hci_link_key_notify_evt,
+	       sizeof(struct hci_ev_link_key_notify)),
+	/* [0x1c = HCI_EV_CLOCK_OFFSET] */
+	HCI_EV(HCI_EV_CLOCK_OFFSET, hci_clock_offset_evt,
+	       sizeof(struct hci_ev_clock_offset)),
+	/* [0x1d = HCI_EV_PKT_TYPE_CHANGE] */
+	HCI_EV(HCI_EV_PKT_TYPE_CHANGE, hci_pkt_type_change_evt,
+	       sizeof(struct hci_ev_pkt_type_change)),
+	/* [0x20 = HCI_EV_PSCAN_REP_MODE] */
+	HCI_EV(HCI_EV_PSCAN_REP_MODE, hci_pscan_rep_mode_evt,
+	       sizeof(struct hci_ev_pscan_rep_mode)),
+	/* [0x22 = HCI_EV_INQUIRY_RESULT_WITH_RSSI] */
+	HCI_EV_VL(HCI_EV_INQUIRY_RESULT_WITH_RSSI,
+		  hci_inquiry_result_with_rssi_evt,
+		  sizeof(struct hci_ev_inquiry_result_rssi),
+		  HCI_MAX_EVENT_SIZE),
+	/* [0x23 = HCI_EV_REMOTE_EXT_FEATURES] */
+	HCI_EV(HCI_EV_REMOTE_EXT_FEATURES, hci_remote_ext_features_evt,
+	       sizeof(struct hci_ev_remote_ext_features)),
+	/* [0x2c = HCI_EV_SYNC_CONN_COMPLETE] */
+	HCI_EV(HCI_EV_SYNC_CONN_COMPLETE, hci_sync_conn_complete_evt,
+	       sizeof(struct hci_ev_sync_conn_complete)),
+	/* [0x2d = HCI_EV_EXTENDED_INQUIRY_RESULT] */
+	HCI_EV_VL(HCI_EV_EXTENDED_INQUIRY_RESULT,
+		  hci_extended_inquiry_result_evt,
+		  sizeof(struct hci_ev_ext_inquiry_result), HCI_MAX_EVENT_SIZE),
+	/* [0x30 = HCI_EV_KEY_REFRESH_COMPLETE] */
+	HCI_EV(HCI_EV_KEY_REFRESH_COMPLETE, hci_key_refresh_complete_evt,
+	       sizeof(struct hci_ev_key_refresh_complete)),
+	/* [0x31 = HCI_EV_IO_CAPA_REQUEST] */
+	HCI_EV(HCI_EV_IO_CAPA_REQUEST, hci_io_capa_request_evt,
+	       sizeof(struct hci_ev_io_capa_request)),
+	/* [0x32 = HCI_EV_IO_CAPA_REPLY] */
+	HCI_EV(HCI_EV_IO_CAPA_REPLY, hci_io_capa_reply_evt,
+	       sizeof(struct hci_ev_io_capa_reply)),
+	/* [0x33 = HCI_EV_USER_CONFIRM_REQUEST] */
+	HCI_EV(HCI_EV_USER_CONFIRM_REQUEST, hci_user_confirm_request_evt,
+	       sizeof(struct hci_ev_user_confirm_req)),
+	/* [0x34 = HCI_EV_USER_PASSKEY_REQUEST] */
+	HCI_EV(HCI_EV_USER_PASSKEY_REQUEST, hci_user_passkey_request_evt,
+	       sizeof(struct hci_ev_user_passkey_req)),
+	/* [0x35 = HCI_EV_REMOTE_OOB_DATA_REQUEST] */
+	HCI_EV(HCI_EV_REMOTE_OOB_DATA_REQUEST, hci_remote_oob_data_request_evt,
+	       sizeof(struct hci_ev_remote_oob_data_request)),
+	/* [0x36 = HCI_EV_SIMPLE_PAIR_COMPLETE] */
+	HCI_EV(HCI_EV_SIMPLE_PAIR_COMPLETE, hci_simple_pair_complete_evt,
+	       sizeof(struct hci_ev_simple_pair_complete)),
+	/* [0x3b = HCI_EV_USER_PASSKEY_NOTIFY] */
+	HCI_EV(HCI_EV_USER_PASSKEY_NOTIFY, hci_user_passkey_notify_evt,
+	       sizeof(struct hci_ev_user_passkey_notify)),
+	/* [0x3c = HCI_EV_KEYPRESS_NOTIFY] */
+	HCI_EV(HCI_EV_KEYPRESS_NOTIFY, hci_keypress_notify_evt,
+	       sizeof(struct hci_ev_keypress_notify)),
+	/* [0x3d = HCI_EV_REMOTE_HOST_FEATURES] */
+	HCI_EV(HCI_EV_REMOTE_HOST_FEATURES, hci_remote_host_features_evt,
+	       sizeof(struct hci_ev_remote_host_features)),
+	/* [0x3e = HCI_EV_LE_META] */
+	HCI_EV_VL(HCI_EV_LE_META, hci_le_meta_evt,
+		  sizeof(struct hci_ev_le_meta), HCI_MAX_EVENT_SIZE),
+#if IS_ENABLED(CONFIG_BT_HS)
+	/* [0x40 = HCI_EV_PHY_LINK_COMPLETE] */
+	HCI_EV(HCI_EV_PHY_LINK_COMPLETE, hci_phy_link_complete_evt,
+	       sizeof(struct hci_ev_phy_link_complete)),
+	/* [0x41 = HCI_EV_CHANNEL_SELECTED] */
+	HCI_EV(HCI_EV_CHANNEL_SELECTED, hci_chan_selected_evt,
+	       sizeof(struct hci_ev_channel_selected)),
+	/* [0x42 = HCI_EV_DISCONN_PHY_LINK_COMPLETE] */
+	HCI_EV(HCI_EV_DISCONN_LOGICAL_LINK_COMPLETE,
+	       hci_disconn_loglink_complete_evt,
+	       sizeof(struct hci_ev_disconn_logical_link_complete)),
+	/* [0x45 = HCI_EV_LOGICAL_LINK_COMPLETE] */
+	HCI_EV(HCI_EV_LOGICAL_LINK_COMPLETE, hci_loglink_complete_evt,
+	       sizeof(struct hci_ev_logical_link_complete)),
+	/* [0x46 = HCI_EV_DISCONN_LOGICAL_LINK_COMPLETE] */
+	HCI_EV(HCI_EV_DISCONN_PHY_LINK_COMPLETE,
+	       hci_disconn_phylink_complete_evt,
+	       sizeof(struct hci_ev_disconn_phy_link_complete)),
+#endif
+	/* [0x48 = HCI_EV_NUM_COMP_BLOCKS] */
+	HCI_EV(HCI_EV_NUM_COMP_BLOCKS, hci_num_comp_blocks_evt,
+	       sizeof(struct hci_ev_num_comp_blocks)),
+	/* [0xff = HCI_EV_VENDOR] */
+	HCI_EV(HCI_EV_VENDOR, msft_vendor_evt, 0),
+};
+
+void hci_event_func(struct hci_dev *hdev, u8 event, struct sk_buff *skb,
+		    u16 *opcode, u8 *status, hci_req_complete_t *req_complete,
+		    hci_req_complete_skb_t *req_complete_skb)
+{
+	const struct hci_ev *ev = &hci_ev_table[event];
+	void *data;
+
+	if (!ev->func)
+		return;
+
+	if (skb->len < ev->min_len) {
+		bt_dev_err(hdev, "unexpected event 0x%2.2x length: %u < %u",
+			   event, skb->len, ev->min_len);
+		return;
+	}
+
+	/* Just warn if the length is over max_len size it still be
+	 * possible to partially parse the event so leave to callback to
+	 * decide if that is acceptable.
+	 */
+	if (skb->len > ev->max_len)
+		bt_dev_warn(hdev, "unexpected event 0x%2.2x length: %u > %u",
+			    event, skb->len, ev->max_len);
+
+	data = hci_ev_skb_pull(hdev, skb, event, ev->min_len);
+	if (!data)
+		return;
+
+	if (ev->req)
+		ev->func_req(hdev, data, skb, opcode, status, req_complete,
+			     req_complete_skb);
+	else
+		ev->func(hdev, data, skb);
+}
+
 void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct hci_event_hdr *hdr = (void *) skb->data;
@@ -7125,7 +7180,8 @@ void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
 
 	event = hdr->evt;
 	if (!event) {
-		bt_dev_warn(hdev, "Received unexpected HCI Event 00000000");
+		bt_dev_warn(hdev, "Received unexpected HCI Event 0x%2.2x",
+			    event);
 		goto done;
 	}
 
@@ -7151,191 +7207,10 @@ void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
 	/* Store wake reason if we're suspended */
 	hci_store_wake_reason(hdev, event, skb);
 
-	switch (event) {
-	case HCI_EV_INQUIRY_COMPLETE:
-		hci_inquiry_complete_evt(hdev, skb);
-		break;
-
-	case HCI_EV_INQUIRY_RESULT:
-		hci_inquiry_result_evt(hdev, skb);
-		break;
-
-	case HCI_EV_CONN_COMPLETE:
-		hci_conn_complete_evt(hdev, skb);
-		break;
-
-	case HCI_EV_CONN_REQUEST:
-		hci_conn_request_evt(hdev, skb);
-		break;
-
-	case HCI_EV_DISCONN_COMPLETE:
-		hci_disconn_complete_evt(hdev, skb);
-		break;
-
-	case HCI_EV_AUTH_COMPLETE:
-		hci_auth_complete_evt(hdev, skb);
-		break;
-
-	case HCI_EV_REMOTE_NAME:
-		hci_remote_name_evt(hdev, skb);
-		break;
-
-	case HCI_EV_ENCRYPT_CHANGE:
-		hci_encrypt_change_evt(hdev, skb);
-		break;
-
-	case HCI_EV_CHANGE_LINK_KEY_COMPLETE:
-		hci_change_link_key_complete_evt(hdev, skb);
-		break;
-
-	case HCI_EV_REMOTE_FEATURES:
-		hci_remote_features_evt(hdev, skb);
-		break;
-
-	case HCI_EV_CMD_COMPLETE:
-		hci_cmd_complete_evt(hdev, skb, &opcode, &status,
-				     &req_complete, &req_complete_skb);
-		break;
+	bt_dev_dbg(hdev, "event 0x%2.2x", event);
 
-	case HCI_EV_CMD_STATUS:
-		hci_cmd_status_evt(hdev, skb, &opcode, &status, &req_complete,
-				   &req_complete_skb);
-		break;
-
-	case HCI_EV_HARDWARE_ERROR:
-		hci_hardware_error_evt(hdev, skb);
-		break;
-
-	case HCI_EV_ROLE_CHANGE:
-		hci_role_change_evt(hdev, skb);
-		break;
-
-	case HCI_EV_NUM_COMP_PKTS:
-		hci_num_comp_pkts_evt(hdev, skb);
-		break;
-
-	case HCI_EV_MODE_CHANGE:
-		hci_mode_change_evt(hdev, skb);
-		break;
-
-	case HCI_EV_PIN_CODE_REQ:
-		hci_pin_code_request_evt(hdev, skb);
-		break;
-
-	case HCI_EV_LINK_KEY_REQ:
-		hci_link_key_request_evt(hdev, skb);
-		break;
-
-	case HCI_EV_LINK_KEY_NOTIFY:
-		hci_link_key_notify_evt(hdev, skb);
-		break;
-
-	case HCI_EV_CLOCK_OFFSET:
-		hci_clock_offset_evt(hdev, skb);
-		break;
-
-	case HCI_EV_PKT_TYPE_CHANGE:
-		hci_pkt_type_change_evt(hdev, skb);
-		break;
-
-	case HCI_EV_PSCAN_REP_MODE:
-		hci_pscan_rep_mode_evt(hdev, skb);
-		break;
-
-	case HCI_EV_INQUIRY_RESULT_WITH_RSSI:
-		hci_inquiry_result_with_rssi_evt(hdev, skb);
-		break;
-
-	case HCI_EV_REMOTE_EXT_FEATURES:
-		hci_remote_ext_features_evt(hdev, skb);
-		break;
-
-	case HCI_EV_SYNC_CONN_COMPLETE:
-		hci_sync_conn_complete_evt(hdev, skb);
-		break;
-
-	case HCI_EV_EXTENDED_INQUIRY_RESULT:
-		hci_extended_inquiry_result_evt(hdev, skb);
-		break;
-
-	case HCI_EV_KEY_REFRESH_COMPLETE:
-		hci_key_refresh_complete_evt(hdev, skb);
-		break;
-
-	case HCI_EV_IO_CAPA_REQUEST:
-		hci_io_capa_request_evt(hdev, skb);
-		break;
-
-	case HCI_EV_IO_CAPA_REPLY:
-		hci_io_capa_reply_evt(hdev, skb);
-		break;
-
-	case HCI_EV_USER_CONFIRM_REQUEST:
-		hci_user_confirm_request_evt(hdev, skb);
-		break;
-
-	case HCI_EV_USER_PASSKEY_REQUEST:
-		hci_user_passkey_request_evt(hdev, skb);
-		break;
-
-	case HCI_EV_USER_PASSKEY_NOTIFY:
-		hci_user_passkey_notify_evt(hdev, skb);
-		break;
-
-	case HCI_EV_KEYPRESS_NOTIFY:
-		hci_keypress_notify_evt(hdev, skb);
-		break;
-
-	case HCI_EV_SIMPLE_PAIR_COMPLETE:
-		hci_simple_pair_complete_evt(hdev, skb);
-		break;
-
-	case HCI_EV_REMOTE_HOST_FEATURES:
-		hci_remote_host_features_evt(hdev, skb);
-		break;
-
-	case HCI_EV_LE_META:
-		hci_le_meta_evt(hdev, skb);
-		break;
-
-	case HCI_EV_REMOTE_OOB_DATA_REQUEST:
-		hci_remote_oob_data_request_evt(hdev, skb);
-		break;
-
-#if IS_ENABLED(CONFIG_BT_HS)
-	case HCI_EV_CHANNEL_SELECTED:
-		hci_chan_selected_evt(hdev, skb);
-		break;
-
-	case HCI_EV_PHY_LINK_COMPLETE:
-		hci_phy_link_complete_evt(hdev, skb);
-		break;
-
-	case HCI_EV_LOGICAL_LINK_COMPLETE:
-		hci_loglink_complete_evt(hdev, skb);
-		break;
-
-	case HCI_EV_DISCONN_LOGICAL_LINK_COMPLETE:
-		hci_disconn_loglink_complete_evt(hdev, skb);
-		break;
-
-	case HCI_EV_DISCONN_PHY_LINK_COMPLETE:
-		hci_disconn_phylink_complete_evt(hdev, skb);
-		break;
-#endif
-
-	case HCI_EV_NUM_COMP_BLOCKS:
-		hci_num_comp_blocks_evt(hdev, skb);
-		break;
-
-	case HCI_EV_VENDOR:
-		msft_vendor_evt(hdev, skb);
-		break;
-
-	default:
-		BT_DBG("%s event 0x%2.2x", hdev->name, event);
-		break;
-	}
+	hci_event_func(hdev, event, skb, &opcode, &status, &req_complete,
+		       &req_complete_skb);
 
 	if (req_complete) {
 		req_complete(hdev, status, opcode);
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 1122097e1e49..6a943634b31a 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -590,7 +590,7 @@ void msft_unregister(struct hci_dev *hdev)
 	kfree(msft);
 }
 
-void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
+void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *skb)
 {
 	struct msft_data *msft = hdev->msft_data;
 	u8 event;
diff --git a/net/bluetooth/msft.h b/net/bluetooth/msft.h
index b59b63dc0ea8..7fefc0655b6f 100644
--- a/net/bluetooth/msft.h
+++ b/net/bluetooth/msft.h
@@ -17,7 +17,7 @@ void msft_register(struct hci_dev *hdev);
 void msft_unregister(struct hci_dev *hdev);
 void msft_do_open(struct hci_dev *hdev);
 void msft_do_close(struct hci_dev *hdev);
-void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb);
+void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *skb);
 __u64 msft_get_features(struct hci_dev *hdev);
 int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor);
 int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
-- 
2.33.1

