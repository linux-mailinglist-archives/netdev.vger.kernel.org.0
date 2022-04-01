Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CC34EEF69
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346887AbiDAO14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346913AbiDAO1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:27:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502D1190597;
        Fri,  1 Apr 2022 07:26:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05BD2B82466;
        Fri,  1 Apr 2022 14:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48066C2BBE4;
        Fri,  1 Apr 2022 14:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823161;
        bh=B5KPLtJH+fXt5Ry9mtPvnfZoow+Ad2q3hq3CYqgKj9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLS7lHpqapkaeD/ugUp8TC4Pcb4L2E2yQkOt92OxqiOFRTcBVQXKB/BgJOXGm/Vpe
         PzK4lcQZMLZLq1bvLHjLrtBsQMHSWMkl/1e4UrJn7nO23Taz8a9bwBV5uYYoJEIdDA
         xzHFFUPt+ZxW6bP81B8TKwxmoUN7FUhMyYx/aDN034mTFB621lly2Wolodk8mosDJF
         zCTMx/lNz5t+uRvNeKhrj9jwuNjC2ovH0XTRaf7pBm0t8JPC8JDY91dfAt9LlKXwPK
         SQ/+bwD/5FlwZcL4+7XWszR4Xmyy9da379XiydbJqjXqU1cL4roj1a31tKBw0GZADC
         bzxqt/3iaE58A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Soenke Huster <soenke.huster@eknoes.de>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 009/149] Bluetooth: hci_event: Ignore multiple conn complete events
Date:   Fri,  1 Apr 2022 10:23:16 -0400
Message-Id: <20220401142536.1948161-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Soenke Huster <soenke.huster@eknoes.de>

[ Upstream commit d5ebaa7c5f6f688959e8d40840b2249ede63b8ed ]

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
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  3 ++
 net/bluetooth/hci_conn.c         |  1 +
 net/bluetooth/hci_event.c        | 63 ++++++++++++++++++++++++--------
 3 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index e336e9c1dda4..36d727f94ac2 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -294,6 +294,9 @@ struct adv_monitor {
 
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
index e47cde778b1c..4d45fd4b8ccd 100644
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

