Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1A120C0E1
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 12:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgF0Kze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 06:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgF0Kzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 06:55:31 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA49C03E979
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 03:55:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e192so12692820ybf.17
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 03:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=B8cj7noT3gqtr7TfBspAj7Mt+u+WB7mZtChkBCJp8NI=;
        b=GuwbOSx2zG2imk28P5V+Ks8JSLBbJazjhgQE9JsqNuEkS1jqWjuJgt39kolpwfSjOq
         xWKaWeBy5Bsnpj2U+PMOw4dW1y1phGQRABXsxklKivj4rqRHolF1hzwPIMM+rc8Fm1Fx
         XOtNFaP1pI1h3BUghiWWZJPvHB+EdGVZMU6F5kZAPGN5jgRd/1AuJkI9KTSsnUFZ+wvu
         lCW4NVCF/EP9iHAsSyABr2AJ1w32rVYVZoT+PUu+eSU2adkmaH0Zgyeq0ySJOXIakLg8
         IdVK7LDWRovC7TEFCjoi9bQKFA+tPPX3N90gooTlWJKAd7qXvkfdnpXZuBX166woGNbY
         Rppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=B8cj7noT3gqtr7TfBspAj7Mt+u+WB7mZtChkBCJp8NI=;
        b=bNYGAx1iYjYZZBngft46JPr8P33Naz2oewMcysbUZZGq0ls/IagvnD6g7oh3bh2njr
         HVLpcBeoxg+GX2q4pjHBXtTgPvCAGNhKOoFxKqEXO8Ii5SwhCH4AJUDqjSHbXVW0TBwU
         0dDTLovIaOuzi/fRAnnivQt5PmXyBQvYy2qmDrjGMrE7xsycd0P3Ayi8OR6g+JGpD0DE
         gaHE8w/II3TIqakWzY8Duj0KxacEj8RIe06tj4IJDGRwRPGf/Gymj9GzA4aJ+EsTwR9f
         muLDgK/1acAmVsxA0jruVQ78JC5jguBE9BXHW8BB2oWb+SgbxrNvZwZ1HE/w8O+7wqAP
         Krwg==
X-Gm-Message-State: AOAM532heywRWawhXE9+bNk+L82I+H0mICZDH68dR7N5EDo457VS7kSe
        AsCjFPlN7YtleYRWjvZga34wNwiW/3yW
X-Google-Smtp-Source: ABdhPJxRkLMu6N8l9lSqNk57NeU1XLPYmxklsrUU1kbsLq5k2gSu0s3WAGA8q5qtfNPnAT2IqpxkiWu0+FDw
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr11556917ybe.188.1593255330661;
 Sat, 27 Jun 2020 03:55:30 -0700 (PDT)
Date:   Sat, 27 Jun 2020 18:54:37 +0800
In-Reply-To: <20200627105437.453053-1-apusaka@google.com>
Message-Id: <20200627185320.RFC.v1.2.I7363a6e528433d88c5240b67cbda5a88a107f56c@changeid>
Mime-Version: 1.0
References: <20200627105437.453053-1-apusaka@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [RFC PATCH v1 2/2] Bluetooth: queue L2CAP conn req if encryption is needed
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

It is possible to receive an L2CAP conn req for an encrypted
connection, before actually receiving the HCI change encryption
event. If this happened, the received L2CAP packet will be ignored.

This patch queues the L2CAP packet and process them after the
expected HCI event is received. If after 2 seconds we still don't
receive it, then we assume something bad happened and discard the
queued packets.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

---

 include/net/bluetooth/bluetooth.h |  6 +++
 include/net/bluetooth/l2cap.h     |  6 +++
 net/bluetooth/hci_event.c         |  3 ++
 net/bluetooth/l2cap_core.c        | 87 +++++++++++++++++++++++++++----
 4 files changed, 91 insertions(+), 11 deletions(-)

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 7ee8041af803..e64278401084 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -335,7 +335,11 @@ struct l2cap_ctrl {
 	u16	reqseq;
 	u16	txseq;
 	u8	retries;
+	u8	rsp_code;
+	u8	amp_id;
+	__u8	ident;
 	__le16  psm;
+	__le16	scid;
 	bdaddr_t bdaddr;
 	struct l2cap_chan *chan;
 };
@@ -374,6 +378,8 @@ struct bt_skb_cb {
 		struct hci_ctrl hci;
 	};
 };
+static_assert(sizeof(struct bt_skb_cb) <= sizeof(((struct sk_buff *)0)->cb));
+
 #define bt_cb(skb) ((struct bt_skb_cb *)((skb)->cb))
 
 #define hci_skb_pkt_type(skb) bt_cb((skb))->pkt_type
diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 8f1e6a7a2df8..f8f6dec96f12 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -58,6 +58,7 @@
 #define L2CAP_MOVE_ERTX_TIMEOUT		msecs_to_jiffies(60000)
 #define L2CAP_WAIT_ACK_POLL_PERIOD	msecs_to_jiffies(200)
 #define L2CAP_WAIT_ACK_TIMEOUT		msecs_to_jiffies(10000)
+#define L2CAP_PEND_ENC_CONN_TIMEOUT	msecs_to_jiffies(2000)
 
 #define L2CAP_A2MP_DEFAULT_MTU		670
 
@@ -700,6 +701,9 @@ struct l2cap_conn {
 	struct mutex		chan_lock;
 	struct kref		ref;
 	struct list_head	users;
+
+	struct delayed_work	remove_pending_encrypt_conn;
+	struct sk_buff_head	pending_conn_q;
 };
 
 struct l2cap_user {
@@ -1001,4 +1005,6 @@ void l2cap_conn_put(struct l2cap_conn *conn);
 int l2cap_register_user(struct l2cap_conn *conn, struct l2cap_user *user);
 void l2cap_unregister_user(struct l2cap_conn *conn, struct l2cap_user *user);
 
+void l2cap_process_pending_encrypt_conn(struct hci_conn *hcon);
+
 #endif /* __L2CAP_H */
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 108c6c102a6a..8cefc51a5ca4 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3136,6 +3136,9 @@ static void hci_encrypt_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 unlock:
 	hci_dev_unlock(hdev);
+
+	if (conn && !ev->status && ev->encrypt)
+		l2cap_process_pending_encrypt_conn(conn);
 }
 
 static void hci_change_link_key_complete_evt(struct hci_dev *hdev,
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 35d2bc569a2d..fc6fe2c80c46 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -62,6 +62,10 @@ static void l2cap_send_disconn_req(struct l2cap_chan *chan, int err);
 static void l2cap_tx(struct l2cap_chan *chan, struct l2cap_ctrl *control,
 		     struct sk_buff_head *skbs, u8 event);
 
+static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
+					u8 ident, u8 *data, u8 rsp_code,
+					u8 amp_id, bool queue_if_fail);
+
 static inline u8 bdaddr_type(u8 link_type, u8 bdaddr_type)
 {
 	if (link_type == LE_LINK) {
@@ -1902,6 +1906,8 @@ static void l2cap_conn_del(struct hci_conn *hcon, int err)
 	if (conn->info_state & L2CAP_INFO_FEAT_MASK_REQ_SENT)
 		cancel_delayed_work_sync(&conn->info_timer);
 
+	cancel_delayed_work_sync(&conn->remove_pending_encrypt_conn);
+
 	hcon->l2cap_data = NULL;
 	conn->hchan = NULL;
 	l2cap_conn_put(conn);
@@ -2023,6 +2029,55 @@ static void l2cap_retrans_timeout(struct work_struct *work)
 	l2cap_chan_put(chan);
 }
 
+static void l2cap_add_pending_encrypt_conn(struct l2cap_conn *conn,
+					   struct l2cap_conn_req *req,
+					   u8 ident, u8 rsp_code, u8 amp_id)
+{
+	struct sk_buff *skb = bt_skb_alloc(0, GFP_KERNEL);
+
+	bt_cb(skb)->l2cap.psm = req->psm;
+	bt_cb(skb)->l2cap.scid = req->scid;
+	bt_cb(skb)->l2cap.ident = ident;
+	bt_cb(skb)->l2cap.rsp_code = rsp_code;
+	bt_cb(skb)->l2cap.amp_id = amp_id;
+
+	skb_queue_tail(&conn->pending_conn_q, skb);
+	queue_delayed_work(conn->hcon->hdev->workqueue,
+			   &conn->remove_pending_encrypt_conn,
+			   L2CAP_PEND_ENC_CONN_TIMEOUT);
+}
+
+void l2cap_process_pending_encrypt_conn(struct hci_conn *hcon)
+{
+	struct sk_buff *skb;
+	struct l2cap_conn *conn = hcon->l2cap_data;
+
+	if (!conn)
+		return;
+
+	while ((skb = skb_dequeue(&conn->pending_conn_q))) {
+		struct l2cap_conn_req req;
+		u8 ident, rsp_code, amp_id;
+
+		req.psm = bt_cb(skb)->l2cap.psm;
+		req.scid = bt_cb(skb)->l2cap.scid;
+		ident = bt_cb(skb)->l2cap.ident;
+		rsp_code = bt_cb(skb)->l2cap.rsp_code;
+		amp_id = bt_cb(skb)->l2cap.amp_id;
+
+		l2cap_connect(conn, ident, (u8 *)&req, rsp_code, amp_id, false);
+		kfree_skb(skb);
+	}
+}
+
+static void l2cap_remove_pending_encrypt_conn(struct work_struct *work)
+{
+	struct l2cap_conn *conn = container_of(work, struct l2cap_conn,
+					    remove_pending_encrypt_conn.work);
+
+	l2cap_process_pending_encrypt_conn(conn->hcon);
+}
+
 static void l2cap_streaming_send(struct l2cap_chan *chan,
 				 struct sk_buff_head *skbs)
 {
@@ -4076,8 +4131,8 @@ static inline int l2cap_command_rej(struct l2cap_conn *conn,
 }
 
 static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
-					struct l2cap_cmd_hdr *cmd,
-					u8 *data, u8 rsp_code, u8 amp_id)
+					u8 ident, u8 *data, u8 rsp_code,
+					u8 amp_id, bool queue_if_fail)
 {
 	struct l2cap_conn_req *req = (struct l2cap_conn_req *) data;
 	struct l2cap_conn_rsp rsp;
@@ -4103,8 +4158,15 @@ static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
 	/* Check if the ACL is secure enough (if not SDP) */
 	if (psm != cpu_to_le16(L2CAP_PSM_SDP) &&
 	    !hci_conn_check_link_mode(conn->hcon)) {
-		conn->disc_reason = HCI_ERROR_AUTH_FAILURE;
-		result = L2CAP_CR_SEC_BLOCK;
+		if (!queue_if_fail) {
+			conn->disc_reason = HCI_ERROR_AUTH_FAILURE;
+			result = L2CAP_CR_SEC_BLOCK;
+			goto response;
+		}
+
+		l2cap_add_pending_encrypt_conn(conn, req, ident, rsp_code,
+					       amp_id);
+		result = L2CAP_CR_PEND;
 		goto response;
 	}
 
@@ -4147,7 +4209,7 @@ static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
 
 	__set_chan_timer(chan, chan->ops->get_sndtimeo(chan));
 
-	chan->ident = cmd->ident;
+	chan->ident = ident;
 
 	if (conn->info_state & L2CAP_INFO_FEAT_MASK_REQ_DONE) {
 		if (l2cap_chan_check_security(chan, false)) {
@@ -4191,7 +4253,7 @@ static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
 	rsp.dcid   = cpu_to_le16(dcid);
 	rsp.result = cpu_to_le16(result);
 	rsp.status = cpu_to_le16(status);
-	l2cap_send_cmd(conn, cmd->ident, rsp_code, sizeof(rsp), &rsp);
+	l2cap_send_cmd(conn, ident, rsp_code, sizeof(rsp), &rsp);
 
 	if (result == L2CAP_CR_PEND && status == L2CAP_CS_NO_INFO) {
 		struct l2cap_info_req info;
@@ -4233,7 +4295,7 @@ static int l2cap_connect_req(struct l2cap_conn *conn,
 		mgmt_device_connected(hdev, hcon, 0, NULL, 0);
 	hci_dev_unlock(hdev);
 
-	l2cap_connect(conn, cmd, data, L2CAP_CONN_RSP, 0);
+	l2cap_connect(conn, cmd->ident, data, L2CAP_CONN_RSP, 0, true);
 	return 0;
 }
 
@@ -4802,8 +4864,8 @@ static int l2cap_create_channel_req(struct l2cap_conn *conn,
 
 	/* For controller id 0 make BR/EDR connection */
 	if (req->amp_id == AMP_ID_BREDR) {
-		l2cap_connect(conn, cmd, data, L2CAP_CREATE_CHAN_RSP,
-			      req->amp_id);
+		l2cap_connect(conn, cmd->ident, data, L2CAP_CREATE_CHAN_RSP,
+			      req->amp_id, true);
 		return 0;
 	}
 
@@ -4817,8 +4879,8 @@ static int l2cap_create_channel_req(struct l2cap_conn *conn,
 		goto error;
 	}
 
-	chan = l2cap_connect(conn, cmd, data, L2CAP_CREATE_CHAN_RSP,
-			     req->amp_id);
+	chan = l2cap_connect(conn, cmd->ident, data, L2CAP_CREATE_CHAN_RSP,
+			     req->amp_id, true);
 	if (chan) {
 		struct amp_mgr *mgr = conn->hcon->amp_mgr;
 		struct hci_conn *hs_hcon;
@@ -7745,8 +7807,11 @@ static struct l2cap_conn *l2cap_conn_add(struct hci_conn *hcon)
 	INIT_LIST_HEAD(&conn->users);
 
 	INIT_DELAYED_WORK(&conn->info_timer, l2cap_info_timeout);
+	INIT_DELAYED_WORK(&conn->remove_pending_encrypt_conn,
+			  l2cap_remove_pending_encrypt_conn);
 
 	skb_queue_head_init(&conn->pending_rx);
+	skb_queue_head_init(&conn->pending_conn_q);
 	INIT_WORK(&conn->pending_rx_work, process_pending_rx);
 	INIT_WORK(&conn->id_addr_update_work, l2cap_conn_update_id_addr);
 
-- 
2.27.0.212.ge8ba1cc988-goog

