Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDFC28630F
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 18:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgJGQDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 12:03:14 -0400
Received: from mxout04.lancloud.ru ([89.108.124.63]:57036 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728989AbgJGQDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 12:03:13 -0400
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Oct 2020 12:03:08 EDT
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 589BC2153C10
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: [PATCH 2/2] bluetooth: hci_event: reduce indentation levels
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        <linux-bluetooth@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
References: <bbdd9cbe-b65e-b309-1188-71a3a4ca6fdc@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <46cf8b72-978e-1b63-85b4-5003e5d8bf73@omprussia.ru>
Date:   Wed, 7 Oct 2020 18:55:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <bbdd9cbe-b65e-b309-1188-71a3a4ca6fdc@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.87.153.155]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce the indentation levels in the HCI driver, mostly by using *goto* in
the error paths (and also by collapsing "double" *if* statements into the
"singular" ones).  This makes the coding style more consistent across the
HCI driver.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

---
 net/bluetooth/hci_event.c |  316 ++++++++++++++++++++++++----------------------
 1 file changed, 170 insertions(+), 146 deletions(-)

Index: bluetooth-next/net/bluetooth/hci_event.c
===================================================================
--- bluetooth-next.orig/net/bluetooth/hci_event.c
+++ bluetooth-next/net/bluetooth/hci_event.c
@@ -1861,13 +1861,11 @@ static void hci_cs_create_conn(struct hc
 			} else
 				conn->state = BT_CONNECT2;
 		}
-	} else {
-		if (!conn) {
-			conn = hci_conn_add(hdev, ACL_LINK, &cp->bdaddr,
-					    HCI_ROLE_MASTER);
-			if (!conn)
-				bt_dev_err(hdev, "no memory for new connection");
-		}
+	} else if (!conn) {
+		conn = hci_conn_add(hdev, ACL_LINK, &cp->bdaddr,
+				    HCI_ROLE_MASTER);
+		if (!conn)
+			bt_dev_err(hdev, "no memory for new connection");
 	}
 
 	hci_dev_unlock(hdev);
@@ -1895,16 +1893,19 @@ static void hci_cs_add_sco(struct hci_de
 	hci_dev_lock(hdev);
 
 	acl = hci_conn_hash_lookup_handle(hdev, handle);
-	if (acl) {
-		sco = acl->link;
-		if (sco) {
-			sco->state = BT_CLOSED;
+	if (!acl)
+		goto unlock;
 
-			hci_connect_cfm(sco, status);
-			hci_conn_del(sco);
-		}
-	}
+	sco = acl->link;
+	if (!sco)
+		goto unlock;
 
+	sco->state = BT_CLOSED;
+
+	hci_connect_cfm(sco, status);
+	hci_conn_del(sco);
+
+unlock:
 	hci_dev_unlock(hdev);
 }
 
@@ -1925,13 +1926,13 @@ static void hci_cs_auth_requested(struct
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(cp->handle));
-	if (conn) {
-		if (conn->state == BT_CONFIG) {
-			hci_connect_cfm(conn, status);
-			hci_conn_drop(conn);
-		}
-	}
+	if (!conn || conn->state != BT_CONFIG)
+		goto unlock;
+
+	hci_connect_cfm(conn, status);
+	hci_conn_drop(conn);
 
+unlock:
 	hci_dev_unlock(hdev);
 }
 
@@ -1952,13 +1953,13 @@ static void hci_cs_set_conn_encrypt(stru
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(cp->handle));
-	if (conn) {
-		if (conn->state == BT_CONFIG) {
-			hci_connect_cfm(conn, status);
-			hci_conn_drop(conn);
-		}
-	}
+	if (!conn || conn->state != BT_CONFIG)
+		goto unlock;
 
+	hci_connect_cfm(conn, status);
+	hci_conn_drop(conn);
+
+unlock:
 	hci_dev_unlock(hdev);
 }
 
@@ -2128,13 +2129,13 @@ static void hci_cs_read_remote_features(
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(cp->handle));
-	if (conn) {
-		if (conn->state == BT_CONFIG) {
-			hci_connect_cfm(conn, status);
-			hci_conn_drop(conn);
-		}
-	}
+	if (!conn || conn->state != BT_CONFIG)
+		goto unlock;
 
+	hci_connect_cfm(conn, status);
+	hci_conn_drop(conn);
+
+unlock:
 	hci_dev_unlock(hdev);
 }
 
@@ -2155,13 +2156,13 @@ static void hci_cs_read_remote_ext_featu
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(cp->handle));
-	if (conn) {
-		if (conn->state == BT_CONFIG) {
-			hci_connect_cfm(conn, status);
-			hci_conn_drop(conn);
-		}
-	}
+	if (!conn || conn->state != BT_CONFIG)
+		goto unlock;
+
+	hci_connect_cfm(conn, status);
+	hci_conn_drop(conn);
 
+unlock:
 	hci_dev_unlock(hdev);
 }
 
@@ -2187,16 +2188,19 @@ static void hci_cs_setup_sync_conn(struc
 	hci_dev_lock(hdev);
 
 	acl = hci_conn_hash_lookup_handle(hdev, handle);
-	if (acl) {
-		sco = acl->link;
-		if (sco) {
-			sco->state = BT_CLOSED;
+	if (!acl)
+		goto unlock;
 
-			hci_connect_cfm(sco, status);
-			hci_conn_del(sco);
-		}
-	}
+	sco = acl->link;
+	if (!sco)
+		goto unlock;
+
+	sco->state = BT_CLOSED;
+
+	hci_connect_cfm(sco, status);
+	hci_conn_del(sco);
 
+unlock:
 	hci_dev_unlock(hdev);
 }
 
@@ -2217,13 +2221,15 @@ static void hci_cs_sniff_mode(struct hci
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(cp->handle));
-	if (conn) {
-		clear_bit(HCI_CONN_MODE_CHANGE_PEND, &conn->flags);
+	if (!conn)
+		goto unlock;
 
-		if (test_and_clear_bit(HCI_CONN_SCO_SETUP_PEND, &conn->flags))
-			hci_sco_setup(conn, status);
-	}
+	clear_bit(HCI_CONN_MODE_CHANGE_PEND, &conn->flags);
+
+	if (test_and_clear_bit(HCI_CONN_SCO_SETUP_PEND, &conn->flags))
+		hci_sco_setup(conn, status);
 
+unlock:
 	hci_dev_unlock(hdev);
 }
 
@@ -2244,13 +2250,14 @@ static void hci_cs_exit_sniff_mode(struc
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(cp->handle));
-	if (conn) {
-		clear_bit(HCI_CONN_MODE_CHANGE_PEND, &conn->flags);
+	if (!conn)
+		goto unlock;
 
-		if (test_and_clear_bit(HCI_CONN_SCO_SETUP_PEND, &conn->flags))
-			hci_sco_setup(conn, status);
-	}
+	clear_bit(HCI_CONN_MODE_CHANGE_PEND, &conn->flags);
 
+	if (test_and_clear_bit(HCI_CONN_SCO_SETUP_PEND, &conn->flags))
+		hci_sco_setup(conn, status);
+unlock:
 	hci_dev_unlock(hdev);
 }
 
@@ -2406,13 +2413,13 @@ static void hci_cs_le_read_remote_featur
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(cp->handle));
-	if (conn) {
-		if (conn->state == BT_CONFIG) {
-			hci_connect_cfm(conn, status);
-			hci_conn_drop(conn);
-		}
-	}
+	if (!conn || conn->state != BT_CONFIG)
+		goto unlock;
+
+	hci_connect_cfm(conn, status);
+	hci_conn_drop(conn);
 
+unlock:
 	hci_dev_unlock(hdev);
 }
 
@@ -3171,15 +3178,17 @@ static void hci_change_link_key_complete
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(ev->handle));
-	if (conn) {
-		if (!ev->status)
-			set_bit(HCI_CONN_SECURE, &conn->flags);
+	if (!conn)
+		goto unlock;
 
-		clear_bit(HCI_CONN_AUTH_PEND, &conn->flags);
+	if (!ev->status)
+		set_bit(HCI_CONN_SECURE, &conn->flags);
 
-		hci_key_change_cfm(conn, ev->status);
-	}
+	clear_bit(HCI_CONN_AUTH_PEND, &conn->flags);
+
+	hci_key_change_cfm(conn, ev->status);
 
+unlock:
 	hci_dev_unlock(hdev);
 }
 
@@ -3737,15 +3746,17 @@ static void hci_role_change_evt(struct h
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
-	if (conn) {
-		if (!ev->status)
-			conn->role = ev->role;
+	if (!conn)
+		goto unlock;
 
-		clear_bit(HCI_CONN_RSWITCH_PEND, &conn->flags);
+	if (!ev->status)
+		conn->role = ev->role;
 
-		hci_role_switch_cfm(conn, ev->status, ev->role);
-	}
+	clear_bit(HCI_CONN_RSWITCH_PEND, &conn->flags);
+
+	hci_role_switch_cfm(conn, ev->status, ev->role);
 
+unlock:
 	hci_dev_unlock(hdev);
 }
 
@@ -3898,21 +3909,22 @@ static void hci_mode_change_evt(struct h
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(ev->handle));
-	if (conn) {
-		conn->mode = ev->mode;
+	if (!conn)
+		goto unlock;
 
-		if (!test_and_clear_bit(HCI_CONN_MODE_CHANGE_PEND,
-					&conn->flags)) {
-			if (conn->mode == HCI_CM_ACTIVE)
-				set_bit(HCI_CONN_POWER_SAVE, &conn->flags);
-			else
-				clear_bit(HCI_CONN_POWER_SAVE, &conn->flags);
-		}
+	conn->mode = ev->mode;
 
-		if (test_and_clear_bit(HCI_CONN_SCO_SETUP_PEND, &conn->flags))
-			hci_sco_setup(conn, ev->status);
+	if (!test_and_clear_bit(HCI_CONN_MODE_CHANGE_PEND, &conn->flags)) {
+		if (conn->mode == HCI_CM_ACTIVE)
+			set_bit(HCI_CONN_POWER_SAVE, &conn->flags);
+		else
+			clear_bit(HCI_CONN_POWER_SAVE, &conn->flags);
 	}
 
+	if (test_and_clear_bit(HCI_CONN_SCO_SETUP_PEND, &conn->flags))
+		hci_sco_setup(conn, ev->status);
+
+unlock:
 	hci_dev_unlock(hdev);
 }
 
@@ -4011,27 +4023,29 @@ static void hci_link_key_request_evt(str
 	       &ev->bdaddr);
 
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
-	if (conn) {
-		clear_bit(HCI_CONN_NEW_LINK_KEY, &conn->flags);
+	if (!conn)
+		goto found;
 
-		if ((key->type == HCI_LK_UNAUTH_COMBINATION_P192 ||
-		     key->type == HCI_LK_UNAUTH_COMBINATION_P256) &&
-		    conn->auth_type != 0xff && (conn->auth_type & 0x01)) {
-			BT_DBG("%s ignoring unauthenticated key", hdev->name);
-			goto not_found;
-		}
+	clear_bit(HCI_CONN_NEW_LINK_KEY, &conn->flags);
 
-		if (key->type == HCI_LK_COMBINATION && key->pin_len < 16 &&
-		    (conn->pending_sec_level == BT_SECURITY_HIGH ||
-		     conn->pending_sec_level == BT_SECURITY_FIPS)) {
-			BT_DBG("%s ignoring key unauthenticated for high security",
-			       hdev->name);
-			goto not_found;
-		}
+	if ((key->type == HCI_LK_UNAUTH_COMBINATION_P192 ||
+	     key->type == HCI_LK_UNAUTH_COMBINATION_P256) &&
+	    conn->auth_type != 0xff && (conn->auth_type & 0x01)) {
+		BT_DBG("%s ignoring unauthenticated key", hdev->name);
+		goto not_found;
+	}
 
-		conn_set_key(conn, key->type, key->pin_len);
+	if (key->type == HCI_LK_COMBINATION && key->pin_len < 16 &&
+	    (conn->pending_sec_level == BT_SECURITY_HIGH ||
+	     conn->pending_sec_level == BT_SECURITY_FIPS)) {
+		BT_DBG("%s ignoring key unauthenticated for high security",
+		       hdev->name);
+		goto not_found;
 	}
 
+	conn_set_key(conn, key->type, key->pin_len);
+
+found:
 	bacpy(&cp.bdaddr, &ev->bdaddr);
 	memcpy(cp.link_key, key->val, HCI_LINK_KEY_SIZE);
 
@@ -4155,11 +4169,13 @@ static void hci_pscan_rep_mode_evt(struc
 	hci_dev_lock(hdev);
 
 	ie = hci_inquiry_cache_lookup(hdev, &ev->bdaddr);
-	if (ie) {
-		ie->data.pscan_rep_mode = ev->pscan_rep_mode;
-		ie->timestamp = jiffies;
-	}
+	if (!ie)
+		goto unlock;
+
+	ie->data.pscan_rep_mode = ev->pscan_rep_mode;
+	ie->timestamp = jiffies;
 
+unlock:
 	hci_dev_unlock(hdev);
 }
 
@@ -5041,11 +5057,13 @@ static void hci_disconn_phylink_complete
 	hci_dev_lock(hdev);
 
 	hcon = hci_conn_hash_lookup_handle(hdev, ev->phy_handle);
-	if (hcon) {
-		hcon->state = BT_CLOSED;
-		hci_conn_del(hcon);
-	}
+	if (!hcon)
+		goto unlock;
+
+	hcon->state = BT_CLOSED;
+	hci_conn_del(hcon);
 
+unlock:
 	hci_dev_unlock(hdev);
 }
 #endif
@@ -5198,14 +5216,16 @@ static void le_conn_complete_evt(struct
 
 	params = hci_pend_le_action_lookup(&hdev->pend_le_conns, &conn->dst,
 					   conn->dst_type);
-	if (params) {
-		list_del_init(&params->action);
-		if (params->conn) {
-			hci_conn_drop(params->conn);
-			hci_conn_put(params->conn);
-			params->conn = NULL;
-		}
-	}
+	if (!params)
+		goto unlock;
+
+	list_del_init(&params->action);
+	if (!params->conn)
+		goto unlock;
+
+	hci_conn_drop(params->conn);
+	hci_conn_put(params->conn);
+	params->conn = NULL;
 
 unlock:
 	hci_update_background_scan(hdev);
@@ -5286,12 +5306,14 @@ static void hci_le_conn_update_complete_
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(ev->handle));
-	if (conn) {
-		conn->le_conn_interval = le16_to_cpu(ev->interval);
-		conn->le_conn_latency = le16_to_cpu(ev->latency);
-		conn->le_supv_timeout = le16_to_cpu(ev->supervision_timeout);
-	}
+	if (!conn)
+		goto unlock;
 
+	conn->le_conn_interval = le16_to_cpu(ev->interval);
+	conn->le_conn_latency = le16_to_cpu(ev->latency);
+	conn->le_supv_timeout = le16_to_cpu(ev->supervision_timeout);
+
+unlock:
 	hci_dev_unlock(hdev);
 }
 
@@ -5700,34 +5722,36 @@ static void hci_le_remote_feat_complete_
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(ev->handle));
-	if (conn) {
-		if (!ev->status)
-			memcpy(conn->features[0], ev->features, 8);
+	if (!conn)
+		goto unlock;
 
-		if (conn->state == BT_CONFIG) {
-			__u8 status;
+	if (!ev->status)
+		memcpy(conn->features[0], ev->features, 8);
 
-			/* If the local controller supports slave-initiated
-			 * features exchange, but the remote controller does
-			 * not, then it is possible that the error code 0x1a
-			 * for unsupported remote feature gets returned.
-			 *
-			 * In this specific case, allow the connection to
-			 * transition into connected state and mark it as
-			 * successful.
-			 */
-			if ((hdev->le_features[0] & HCI_LE_SLAVE_FEATURES) &&
-			    !conn->out && ev->status == 0x1a)
-				status = 0x00;
-			else
-				status = ev->status;
+	if (conn->state == BT_CONFIG) {
+		__u8 status;
 
-			conn->state = BT_CONNECTED;
-			hci_connect_cfm(conn, status);
-			hci_conn_drop(conn);
-		}
+		/* If the local controller supports slave-initiated
+		 * features exchange, but the remote controller does
+		 * not, then it is possible that the error code 0x1a
+		 * for unsupported remote feature gets returned.
+		 *
+		 * In this specific case, allow the connection to
+		 * transition into connected state and mark it as
+		 * successful.
+		 */
+		if ((hdev->le_features[0] & HCI_LE_SLAVE_FEATURES) &&
+		    !conn->out && ev->status == 0x1a)
+			status = 0x00;
+		else
+			status = ev->status;
+
+		conn->state = BT_CONNECTED;
+		hci_connect_cfm(conn, status);
+		hci_conn_drop(conn);
 	}
 
+unlock:
 	hci_dev_unlock(hdev);
 }
 
