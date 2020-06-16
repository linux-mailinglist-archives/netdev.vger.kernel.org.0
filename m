Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0CD1FBBB0
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 18:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730309AbgFPQ2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 12:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728919AbgFPQ2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 12:28:13 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF14DC06174E
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 09:28:12 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id l26so17161085qtr.14
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 09:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=We8MnYtBaG4t88DyFPaEaI/3JbDRE1+6v3kM+jWwEtw=;
        b=twJ3EoJyQcjR+d+L58Wh0mCUcbuU0+QAPzB6rQHEnZENPLcQAx6EyybBFWdDulFrRu
         J+xYIN0w3N2j1OTLubTC0Z3/jMGTHmMEsMPwbbi1Va8gSib0TNwb6JQG2B15hvLIduDf
         qvffpC/NY5VWez+haI1YnTr5R/IzVvBS6rCm51x+Y8S/7MwI3Co9fs2IBlueJtb+DiRm
         uiYfQM8xkBPA31QHXbdQiOtkLC3jgb5PqnDmKfROWQbON9TeEHtuYjr1bKkByTF8iqxW
         e/quk5yfVTrn2+46OxKdNHH1aWfy5zIgqBhm7pTYxlIY3ZpxpNj8sdxP8J1IcybZQdiW
         KT0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=We8MnYtBaG4t88DyFPaEaI/3JbDRE1+6v3kM+jWwEtw=;
        b=JkGfWDF2UjemzkLHPcYwMkj5LTTxgLqv+Yoi2MDHRfbAEf2ngWjDywhY2N1VgAN0uj
         mgpcDcpgJYwkRpl+EWlK9GDZnRuk2OXgQdWRpZghuRr7SKiDnFiqXPwyT+UXuYSVRPe6
         Xmfatmk77q+XVCQOgA4f6tDds5yB+5QHpmRZI3g0KL1pgCL6DSC95BB/Ed1x9K2CqU8P
         8qM2co4wWhSpOXOBlfGvt1q+Wvo0pXiod3Ygrw45X1J61A4+aqU3Kne5lMNa9IgsalD7
         A/kMmSoZsixRveJPZFdTkKeWxgOvZpv4fuO9Tayiv3nl8ibFihQ+MULeUnjQR+gVMGOV
         +alg==
X-Gm-Message-State: AOAM532CAYyL9dPJivH4lObmJ5PB8WdETaxeXhY5XXMaKQWtup0a/Lhs
        Mg4+W/6Qc9bvMlZH4v6jaR4px/Z3njCNNA==
X-Google-Smtp-Source: ABdhPJxSJhezPui+2TcwUkCJnNFInLrEP/g22g01ekicafFP/qnFgKnxpBHUD1MX9kPOnf4BHKk7214nYOqT/A==
X-Received: by 2002:a05:6214:1842:: with SMTP id d2mr3087871qvy.197.1592324891019;
 Tue, 16 Jun 2020 09:28:11 -0700 (PDT)
Date:   Tue, 16 Jun 2020 09:28:02 -0700
Message-Id: <20200616092341.v2.1.I9dd050ead919f2cc3ef83d4e866de537c7799cf3@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH v2] Bluetooth: Terminate the link if pairing is cancelled
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Alain Michaud <alainm@chromium.org>,
        Manish Mandlik <mmandlik@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If user decides to cancel the ongoing pairing process (e.g. by clicking
the cancel button on pairing/passkey window), abort any ongoing pairing
and then terminate the link if it was created because of the pair
device action.

Signed-off-by: Manish Mandlik <mmandlik@google.com>
---

Changes in v2:
- Added code to track if the connection was triggered because of the pair
  device action and then only terminate the link on pairing cancel.

 include/net/bluetooth/hci_core.h | 14 ++++++++++++--
 net/bluetooth/hci_conn.c         | 11 ++++++++---
 net/bluetooth/l2cap_core.c       |  6 ++++--
 net/bluetooth/mgmt.c             | 22 ++++++++++++++++++----
 4 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index f5b28c7cae9f2..236ffbc36b2c3 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -519,6 +519,12 @@ struct hci_dev {
 
 #define HCI_PHY_HANDLE(handle)	(handle & 0xff)
 
+enum conn_reasons {
+	CONN_REASON_PAIR_DEVICE,
+	CONN_REASON_L2CAP_CHAN,
+	CONN_REASON_SCO_CONNECT,
+};
+
 struct hci_conn {
 	struct list_head list;
 
@@ -567,6 +573,8 @@ struct hci_conn {
 	__s8		max_tx_power;
 	unsigned long	flags;
 
+	enum conn_reasons conn_reason;
+
 	__u32		clock;
 	__u16		clock_accuracy;
 
@@ -991,12 +999,14 @@ struct hci_chan *hci_chan_lookup_handle(struct hci_dev *hdev, __u16 handle);
 
 struct hci_conn *hci_connect_le_scan(struct hci_dev *hdev, bdaddr_t *dst,
 				     u8 dst_type, u8 sec_level,
-				     u16 conn_timeout);
+				     u16 conn_timeout,
+				     enum conn_reasons conn_reason);
 struct hci_conn *hci_connect_le(struct hci_dev *hdev, bdaddr_t *dst,
 				u8 dst_type, u8 sec_level, u16 conn_timeout,
 				u8 role, bdaddr_t *direct_rpa);
 struct hci_conn *hci_connect_acl(struct hci_dev *hdev, bdaddr_t *dst,
-				 u8 sec_level, u8 auth_type);
+				 u8 sec_level, u8 auth_type,
+				 enum conn_reasons conn_reason);
 struct hci_conn *hci_connect_sco(struct hci_dev *hdev, int type, bdaddr_t *dst,
 				 __u16 setting);
 int hci_conn_check_link_mode(struct hci_conn *conn);
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 3ea1bdf5d1e35..1353d7e3f1012 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1157,7 +1157,8 @@ static int hci_explicit_conn_params_set(struct hci_dev *hdev,
 /* This function requires the caller holds hdev->lock */
 struct hci_conn *hci_connect_le_scan(struct hci_dev *hdev, bdaddr_t *dst,
 				     u8 dst_type, u8 sec_level,
-				     u16 conn_timeout)
+				     u16 conn_timeout,
+				     enum conn_reasons conn_reason)
 {
 	struct hci_conn *conn;
 
@@ -1202,6 +1203,7 @@ struct hci_conn *hci_connect_le_scan(struct hci_dev *hdev, bdaddr_t *dst,
 	conn->sec_level = BT_SECURITY_LOW;
 	conn->pending_sec_level = sec_level;
 	conn->conn_timeout = conn_timeout;
+	conn->conn_reason = conn_reason;
 
 	hci_update_background_scan(hdev);
 
@@ -1211,7 +1213,8 @@ struct hci_conn *hci_connect_le_scan(struct hci_dev *hdev, bdaddr_t *dst,
 }
 
 struct hci_conn *hci_connect_acl(struct hci_dev *hdev, bdaddr_t *dst,
-				 u8 sec_level, u8 auth_type)
+				 u8 sec_level, u8 auth_type,
+				 enum conn_reasons conn_reason)
 {
 	struct hci_conn *acl;
 
@@ -1231,6 +1234,7 @@ struct hci_conn *hci_connect_acl(struct hci_dev *hdev, bdaddr_t *dst,
 
 	hci_conn_hold(acl);
 
+	acl->conn_reason = conn_reason;
 	if (acl->state == BT_OPEN || acl->state == BT_CLOSED) {
 		acl->sec_level = BT_SECURITY_LOW;
 		acl->pending_sec_level = sec_level;
@@ -1247,7 +1251,8 @@ struct hci_conn *hci_connect_sco(struct hci_dev *hdev, int type, bdaddr_t *dst,
 	struct hci_conn *acl;
 	struct hci_conn *sco;
 
-	acl = hci_connect_acl(hdev, dst, BT_SECURITY_LOW, HCI_AT_NO_BONDING);
+	acl = hci_connect_acl(hdev, dst, BT_SECURITY_LOW, HCI_AT_NO_BONDING,
+			      CONN_REASON_SCO_CONNECT);
 	if (IS_ERR(acl))
 		return acl;
 
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index bdbf37337bc6c..ee71b68582f48 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7224,11 +7224,13 @@ int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 		else
 			hcon = hci_connect_le_scan(hdev, dst, dst_type,
 						   chan->sec_level,
-						   HCI_LE_CONN_TIMEOUT);
+						   HCI_LE_CONN_TIMEOUT,
+						   CONN_REASON_L2CAP_CHAN);
 
 	} else {
 		u8 auth_type = l2cap_get_auth_type(chan);
-		hcon = hci_connect_acl(hdev, dst, chan->sec_level, auth_type);
+		hcon = hci_connect_acl(hdev, dst, chan->sec_level, auth_type,
+				       CONN_REASON_L2CAP_CHAN);
 	}
 
 	if (IS_ERR(hcon)) {
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index db7023dfcd253..06cc8d30f8f00 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2940,7 +2940,7 @@ static int pair_device(struct sock *sk, struct hci_dev *hdev, void *data,
 
 	if (cp->addr.type == BDADDR_BREDR) {
 		conn = hci_connect_acl(hdev, &cp->addr.bdaddr, sec_level,
-				       auth_type);
+				       auth_type, CONN_REASON_PAIR_DEVICE);
 	} else {
 		u8 addr_type = le_addr_type(cp->addr.type);
 		struct hci_conn_params *p;
@@ -2959,9 +2959,9 @@ static int pair_device(struct sock *sk, struct hci_dev *hdev, void *data,
 		if (p->auto_connect == HCI_AUTO_CONN_EXPLICIT)
 			p->auto_connect = HCI_AUTO_CONN_DISABLED;
 
-		conn = hci_connect_le_scan(hdev, &cp->addr.bdaddr,
-					   addr_type, sec_level,
-					   HCI_LE_CONN_TIMEOUT);
+		conn = hci_connect_le_scan(hdev, &cp->addr.bdaddr, addr_type,
+					   sec_level, HCI_LE_CONN_TIMEOUT,
+					   CONN_REASON_PAIR_DEVICE);
 	}
 
 	if (IS_ERR(conn)) {
@@ -3062,6 +3062,20 @@ static int cancel_pair_device(struct sock *sk, struct hci_dev *hdev, void *data,
 
 	err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_CANCEL_PAIR_DEVICE, 0,
 				addr, sizeof(*addr));
+
+	/* Since user doesn't want to proceed with the connection, abort any
+	 * ongoing pairing and then terminate the link if it was created
+	 * because of the pair device action.
+	 */
+	if (addr->type == BDADDR_BREDR)
+		hci_remove_link_key(hdev, &addr->bdaddr);
+	else
+		smp_cancel_and_remove_pairing(hdev, &addr->bdaddr,
+					      le_addr_type(addr->type));
+
+	if (conn->conn_reason == CONN_REASON_PAIR_DEVICE)
+		hci_abort_conn(conn, HCI_ERROR_REMOTE_USER_TERM);
+
 unlock:
 	hci_dev_unlock(hdev);
 	return err;
-- 
2.27.0.111.gc72c7da667-goog

