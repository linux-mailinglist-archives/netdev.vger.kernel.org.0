Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85A0468FDD
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389513AbfGOORR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:17:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389300AbfGOORP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:17:15 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87EDB2081C;
        Mon, 15 Jul 2019 14:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200234;
        bh=b3/08zbf0npl5HNr5gmHxafJHMI5e5HONJlhFc673FA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgbK94GfHnda3rEAZ66OvJzEDk7zS+uddsNLWueour3WJGr3SQHN4coboPdt3vP5U
         lvyLBrS7nRQ4EGdGG1Fh/lqrqqc1Dd/CC7pbvwols3UM7qDXFVgXDkHNbrR2gFOJnd
         vBa3nRmEU62jRgyx1y09w0DFw/b98qMk/t8JTo6U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     csonsino <csonsino@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 213/219] Bluetooth: validate BLE connection interval updates
Date:   Mon, 15 Jul 2019 10:03:34 -0400
Message-Id: <20190715140341.6443-213-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: csonsino <csonsino@gmail.com>

[ Upstream commit c49a8682fc5d298d44e8d911f4fa14690ea9485e ]

Problem: The Linux Bluetooth stack yields complete control over the BLE
connection interval to the remote device.

The Linux Bluetooth stack provides access to the BLE connection interval
min and max values through /sys/kernel/debug/bluetooth/hci0/
conn_min_interval and /sys/kernel/debug/bluetooth/hci0/conn_max_interval.
These values are used for initial BLE connections, but the remote device
has the ability to request a connection parameter update. In the event
that the remote side requests to change the connection interval, the Linux
kernel currently only validates that the desired value is within the
acceptable range in the Bluetooth specification (6 - 3200, corresponding to
7.5ms - 4000ms). There is currently no validation that the desired value
requested by the remote device is within the min/max limits specified in
the conn_min_interval/conn_max_interval configurations. This essentially
leads to Linux yielding complete control over the connection interval to
the remote device.

The proposed patch adds a verification step to the connection parameter
update mechanism, ensuring that the desired value is within the min/max
bounds of the current connection. If the desired value is outside of the
current connection min/max values, then the connection parameter update
request is rejected and the negative response is returned to the remote
device. Recall that the initial connection is established using the local
conn_min_interval/conn_max_interval values, so this allows the Linux
administrator to retain control over the BLE connection interval.

The one downside that I see is that the current default Linux values for
conn_min_interval and conn_max_interval typically correspond to 30ms and
50ms respectively. If this change were accepted, then it is feasible that
some devices would no longer be able to negotiate to their desired
connection interval values. This might be remedied by setting the default
Linux conn_min_interval and conn_max_interval values to the widest
supported range (6 - 3200 / 7.5ms - 4000ms). This could lead to the same
behavior as the current implementation, where the remote device could
request to change the connection interval value to any value that is
permitted by the Bluetooth specification, and Linux would accept the
desired value.

Signed-off-by: Carey Sonsino <csonsino@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c  | 5 +++++
 net/bluetooth/l2cap_core.c | 9 ++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 8b893baf9bbe..31eb0449479b 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5588,6 +5588,11 @@ static void hci_le_remote_conn_param_req_evt(struct hci_dev *hdev,
 		return send_conn_param_neg_reply(hdev, handle,
 						 HCI_ERROR_UNKNOWN_CONN_ID);
 
+	if (min < hcon->le_conn_min_interval ||
+	    max > hcon->le_conn_max_interval)
+		return send_conn_param_neg_reply(hdev, handle,
+						 HCI_ERROR_INVALID_LL_PARAMS);
+
 	if (hci_check_conn_params(min, max, latency, timeout))
 		return send_conn_param_neg_reply(hdev, handle,
 						 HCI_ERROR_INVALID_LL_PARAMS);
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 771e3e17bb6a..32d2be9d6858 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5297,7 +5297,14 @@ static inline int l2cap_conn_param_update_req(struct l2cap_conn *conn,
 
 	memset(&rsp, 0, sizeof(rsp));
 
-	err = hci_check_conn_params(min, max, latency, to_multiplier);
+	if (min < hcon->le_conn_min_interval ||
+	    max > hcon->le_conn_max_interval) {
+		BT_DBG("requested connection interval exceeds current bounds.");
+		err = -EINVAL;
+	} else {
+		err = hci_check_conn_params(min, max, latency, to_multiplier);
+	}
+
 	if (err)
 		rsp.result = cpu_to_le16(L2CAP_CONN_PARAM_REJECTED);
 	else
-- 
2.20.1

