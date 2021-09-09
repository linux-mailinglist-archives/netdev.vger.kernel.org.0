Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F4E4051E3
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354480AbhIIMjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:39:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353810AbhIIMe6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:34:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AD0761B6F;
        Thu,  9 Sep 2021 11:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188427;
        bh=rXlLFN2W3/ibx/tfFV1MtqfrE46u2tbBH270PV+DI1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NL8fLk8S1JpH72LiKdoCPp6qAmg8RXLlVd11fLndZJbdR029ep2Zh8odPPzEqZFmT
         5aVv4wOVXmeavnrLS6TYW78FTt597+9Achko+Qi4dXU3bz8pHJn8k0lHzCGOECRuGc
         I2SJ+pf6IPfoYLRJMXoy+Q4Q4AALQx3sf5LGG3I1vBXpZvKGNDicfxcIDXZYrVbAKk
         lnLn7ouHOwqZq1vUecB5NyYW/Xv7iiHGOoYC2mMO08LNkko8Gg1qtNf5PuIbm9hjTs
         e/qP3UbgEV4eDNE3b8bDSWxt/YJtmTeuIOKJVlPB0OIrXCDulr9NvZnAcxpSiypv/6
         wXeV+ti5Uza4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 115/176] Bluetooth: Fix handling of LE Enhanced Connection Complete
Date:   Thu,  9 Sep 2021 07:50:17 -0400
Message-Id: <20210909115118.146181-115-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit cafae4cd625502f65d1798659c1aa9b62d38cc56 ]

LE Enhanced Connection Complete contains the Local RPA used in the
connection which must be used when set otherwise there could problems
when pairing since the address used by the remote stack could be the
Local RPA:

BLUETOOTH CORE SPECIFICATION Version 5.2 | Vol 4, Part E
page 2396

  'Resolvable Private Address being used by the local device for this
  connection. This is only valid when the Own_Address_Type (from the
  HCI_LE_Create_Connection, HCI_LE_Set_Advertising_Parameters,
  HCI_LE_Set_Extended_Advertising_Parameters, or
  HCI_LE_Extended_Create_Connection commands) is set to 0x02 or
  0x03, and the Controller generated a resolvable private address for the
  local device using a non-zero local IRK. For other Own_Address_Type
  values, the Controller shall return all zeros.'

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 93 ++++++++++++++++++++++++++-------------
 1 file changed, 62 insertions(+), 31 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 45de2d8b9a9d..9f52145bb7b7 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5070,9 +5070,64 @@ static void hci_disconn_phylink_complete_evt(struct hci_dev *hdev,
 }
 #endif
 
+static void le_conn_update_addr(struct hci_conn *conn, bdaddr_t *bdaddr,
+				u8 bdaddr_type, bdaddr_t *local_rpa)
+{
+	if (conn->out) {
+		conn->dst_type = bdaddr_type;
+		conn->resp_addr_type = bdaddr_type;
+		bacpy(&conn->resp_addr, bdaddr);
+
+		/* Check if the controller has set a Local RPA then it must be
+		 * used instead or hdev->rpa.
+		 */
+		if (local_rpa && bacmp(local_rpa, BDADDR_ANY)) {
+			conn->init_addr_type = ADDR_LE_DEV_RANDOM;
+			bacpy(&conn->init_addr, local_rpa);
+		} else if (hci_dev_test_flag(conn->hdev, HCI_PRIVACY)) {
+			conn->init_addr_type = ADDR_LE_DEV_RANDOM;
+			bacpy(&conn->init_addr, &conn->hdev->rpa);
+		} else {
+			hci_copy_identity_address(conn->hdev, &conn->init_addr,
+						  &conn->init_addr_type);
+		}
+	} else {
+		conn->resp_addr_type = conn->hdev->adv_addr_type;
+		/* Check if the controller has set a Local RPA then it must be
+		 * used instead or hdev->rpa.
+		 */
+		if (local_rpa && bacmp(local_rpa, BDADDR_ANY)) {
+			conn->resp_addr_type = ADDR_LE_DEV_RANDOM;
+			bacpy(&conn->resp_addr, local_rpa);
+		} else if (conn->hdev->adv_addr_type == ADDR_LE_DEV_RANDOM) {
+			/* In case of ext adv, resp_addr will be updated in
+			 * Adv Terminated event.
+			 */
+			if (!ext_adv_capable(conn->hdev))
+				bacpy(&conn->resp_addr,
+				      &conn->hdev->random_addr);
+		} else {
+			bacpy(&conn->resp_addr, &conn->hdev->bdaddr);
+		}
+
+		conn->init_addr_type = bdaddr_type;
+		bacpy(&conn->init_addr, bdaddr);
+
+		/* For incoming connections, set the default minimum
+		 * and maximum connection interval. They will be used
+		 * to check if the parameters are in range and if not
+		 * trigger the connection update procedure.
+		 */
+		conn->le_conn_min_interval = conn->hdev->le_conn_min_interval;
+		conn->le_conn_max_interval = conn->hdev->le_conn_max_interval;
+	}
+}
+
 static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
-			bdaddr_t *bdaddr, u8 bdaddr_type, u8 role, u16 handle,
-			u16 interval, u16 latency, u16 supervision_timeout)
+				 bdaddr_t *bdaddr, u8 bdaddr_type,
+				 bdaddr_t *local_rpa, u8 role, u16 handle,
+				 u16 interval, u16 latency,
+				 u16 supervision_timeout)
 {
 	struct hci_conn_params *params;
 	struct hci_conn *conn;
@@ -5120,32 +5175,7 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 		cancel_delayed_work(&conn->le_conn_timeout);
 	}
 
-	if (!conn->out) {
-		/* Set the responder (our side) address type based on
-		 * the advertising address type.
-		 */
-		conn->resp_addr_type = hdev->adv_addr_type;
-		if (hdev->adv_addr_type == ADDR_LE_DEV_RANDOM) {
-			/* In case of ext adv, resp_addr will be updated in
-			 * Adv Terminated event.
-			 */
-			if (!ext_adv_capable(hdev))
-				bacpy(&conn->resp_addr, &hdev->random_addr);
-		} else {
-			bacpy(&conn->resp_addr, &hdev->bdaddr);
-		}
-
-		conn->init_addr_type = bdaddr_type;
-		bacpy(&conn->init_addr, bdaddr);
-
-		/* For incoming connections, set the default minimum
-		 * and maximum connection interval. They will be used
-		 * to check if the parameters are in range and if not
-		 * trigger the connection update procedure.
-		 */
-		conn->le_conn_min_interval = hdev->le_conn_min_interval;
-		conn->le_conn_max_interval = hdev->le_conn_max_interval;
-	}
+	le_conn_update_addr(conn, bdaddr, bdaddr_type, local_rpa);
 
 	/* Lookup the identity address from the stored connection
 	 * address and address type.
@@ -5239,7 +5269,7 @@ static void hci_le_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	le_conn_complete_evt(hdev, ev->status, &ev->bdaddr, ev->bdaddr_type,
-			     ev->role, le16_to_cpu(ev->handle),
+			     NULL, ev->role, le16_to_cpu(ev->handle),
 			     le16_to_cpu(ev->interval),
 			     le16_to_cpu(ev->latency),
 			     le16_to_cpu(ev->supervision_timeout));
@@ -5253,7 +5283,7 @@ static void hci_le_enh_conn_complete_evt(struct hci_dev *hdev,
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	le_conn_complete_evt(hdev, ev->status, &ev->bdaddr, ev->bdaddr_type,
-			     ev->role, le16_to_cpu(ev->handle),
+			     &ev->local_rpa, ev->role, le16_to_cpu(ev->handle),
 			     le16_to_cpu(ev->interval),
 			     le16_to_cpu(ev->latency),
 			     le16_to_cpu(ev->supervision_timeout));
@@ -5289,7 +5319,8 @@ static void hci_le_ext_adv_term_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	if (conn) {
 		struct adv_info *adv_instance;
 
-		if (hdev->adv_addr_type != ADDR_LE_DEV_RANDOM)
+		if (hdev->adv_addr_type != ADDR_LE_DEV_RANDOM ||
+		    bacmp(&conn->resp_addr, BDADDR_ANY))
 			return;
 
 		if (!hdev->cur_adv_instance) {
-- 
2.30.2

