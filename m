Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B1C4971D6
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 15:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236664AbiAWOHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 09:07:51 -0500
Received: from giacobini.uberspace.de ([185.26.156.129]:60822 "EHLO
        giacobini.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236660AbiAWOHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 09:07:50 -0500
Received: (qmail 32133 invoked by uid 990); 23 Jan 2022 14:07:49 -0000
Authentication-Results: giacobini.uberspace.de;
        auth=pass (plain)
From:   Soenke Huster <soenke.huster@eknoes.de>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Soenke Huster <soenke.huster@eknoes.de>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2] Bluetooth: hci_event: Ignore multiple conn complete events
Date:   Sun, 23 Jan 2022 15:06:24 +0100
Message-Id: <20220123140624.30005-1-soenke.huster@eknoes.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: /
X-Rspamd-Report: BAYES_HAM(-3) R_MISSING_CHARSET(0.5) MIME_GOOD(-0.1) MID_CONTAINS_FROM(1) SUSPICIOUS_RECIPS(1.5)
X-Rspamd-Score: -0.1
Received: from unknown (HELO unkown) (::1)
        by giacobini.uberspace.de (Haraka/2.8.28) with ESMTPSA; Sun, 23 Jan 2022 15:07:49 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When one of the three connection complete events is received multiple
times for the same handle, the device is registered multiple times which
leads to memory corruptions. Therefore, consequent events for a single
connection are ignored.

The conn->state can hold different values, therefore HCI_CONN_HANDLE_UNSET
is introduced to identify new connections. To make sure the events do not
contain this or another invalid handle HCI_CONN_HANDLE_MAX and checks
are introduced.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=215497
Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
---
v2: 
- Introduce HCI_CONN_HANDLE_UNSET for new connections
- Introduce HCI_CONN_HANDLE_MAX to check for valid handles

While fuzzing I found several UAFs or null pointer dereferences
due to multiple connection complete events. They occur due to
multiple calls to device_register in one of the three connection
complete events. See the bugreport for a more in-depth description.

 include/net/bluetooth/hci_core.h |  3 ++
 net/bluetooth/hci_conn.c         |  1 +
 net/bluetooth/hci_event.c        | 63 ++++++++++++++++++++++++--------
 3 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 21eadb113a31..f5caff1ddb29 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -303,6 +303,9 @@ struct adv_monitor {
 
 #define HCI_MAX_SHORT_NAME_LENGTH	10
 
+#define HCI_CONN_HANDLE_UNSET		0xffff
+#define HCI_CONN_HANDLE_MAX		0x0eff
+
 /* Min encryption key size to match with SMP */
 #define HCI_MIN_ENC_KEY_SIZE		7
 
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 04ebe901e86f..d10651108033 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -689,6 +689,7 @@ struct hci_conn *hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t *dst,
 
 	bacpy(&conn->dst, dst);
 	bacpy(&conn->src, &hdev->bdaddr);
+	conn->handle = HCI_CONN_HANDLE_UNSET;
 	conn->hdev  = hdev;
 	conn->type  = type;
 	conn->role  = role;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 681c623aa380..664ccf1d8d93 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3068,6 +3068,11 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, void *data,
 	struct hci_ev_conn_complete *ev = data;
 	struct hci_conn *conn;
 
+	if (__le16_to_cpu(ev->handle) > HCI_CONN_HANDLE_MAX) {
+		bt_dev_err(hdev, "Ignoring HCI_Connection_Complete for invalid handle");
+		return;
+	}
+
 	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
@@ -3106,6 +3111,17 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, void *data,
 		}
 	}
 
+	/* The HCI_Connection_Complete event is only sent once per connection.
+	 * Processing it more than once per connection can corrupt kernel memory.
+	 *
+	 * As the connection handle is set here for the first time, it indicates
+	 * whether the connection is already set up.
+	 */
+	if (conn->handle != HCI_CONN_HANDLE_UNSET) {
+		bt_dev_err(hdev, "Ignoring HCI_Connection_Complete for existing connection");
+		goto unlock;
+	}
+
 	if (!ev->status) {
 		conn->handle = __le16_to_cpu(ev->handle);
 
@@ -4674,6 +4690,11 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev, void *data,
 		return;
 	}
 
+	if (__le16_to_cpu(ev->handle) > HCI_CONN_HANDLE_MAX) {
+		bt_dev_err(hdev, "Ignoring HCI_Sync_Conn_Complete for invalid handle");
+		return;
+	}
+
 	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
@@ -4697,23 +4718,19 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev, void *data,
 			goto unlock;
 	}
 
+	/* The HCI_Synchronous_Connection_Complete event is only sent once per connection.
+	 * Processing it more than once per connection can corrupt kernel memory.
+	 *
+	 * As the connection handle is set here for the first time, it indicates
+	 * whether the connection is already set up.
+	 */
+	if (conn->handle != HCI_CONN_HANDLE_UNSET) {
+		bt_dev_err(hdev, "Ignoring HCI_Sync_Conn_Complete event for existing connection");
+		goto unlock;
+	}
+
 	switch (ev->status) {
 	case 0x00:
-		/* The synchronous connection complete event should only be
-		 * sent once per new connection. Receiving a successful
-		 * complete event when the connection status is already
-		 * BT_CONNECTED means that the device is misbehaving and sent
-		 * multiple complete event packets for the same new connection.
-		 *
-		 * Registering the device more than once can corrupt kernel
-		 * memory, hence upon detecting this invalid event, we report
-		 * an error and ignore the packet.
-		 */
-		if (conn->state == BT_CONNECTED) {
-			bt_dev_err(hdev, "Ignoring connect complete event for existing connection");
-			goto unlock;
-		}
-
 		conn->handle = __le16_to_cpu(ev->handle);
 		conn->state  = BT_CONNECTED;
 		conn->type   = ev->link_type;
@@ -5509,6 +5526,11 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 	struct smp_irk *irk;
 	u8 addr_type;
 
+	if (handle > HCI_CONN_HANDLE_MAX) {
+		bt_dev_err(hdev, "Ignoring HCI_LE_Connection_Complete for invalid handle");
+		return;
+	}
+
 	hci_dev_lock(hdev);
 
 	/* All controllers implicitly stop advertising in the event of a
@@ -5550,6 +5572,17 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 		cancel_delayed_work(&conn->le_conn_timeout);
 	}
 
+	/* The HCI_LE_Connection_Complete event is only sent once per connection.
+	 * Processing it more than once per connection can corrupt kernel memory.
+	 *
+	 * As the connection handle is set here for the first time, it indicates
+	 * whether the connection is already set up.
+	 */
+	if (conn->handle != HCI_CONN_HANDLE_UNSET) {
+		bt_dev_err(hdev, "Ignoring HCI_Connection_Complete for existing connection");
+		goto unlock;
+	}
+
 	le_conn_update_addr(conn, bdaddr, bdaddr_type, local_rpa);
 
 	/* Lookup the identity address from the stored connection
-- 
2.34.1

