Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C4F496403
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 18:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351773AbiAURhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 12:37:04 -0500
Received: from giacobini.uberspace.de ([185.26.156.129]:43116 "EHLO
        giacobini.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351623AbiAURhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 12:37:02 -0500
Received: (qmail 14399 invoked by uid 990); 21 Jan 2022 17:37:00 -0000
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
Subject: [RFC PATCH] Bluetooth: hci_event: Ignore multiple conn complete events
Date:   Fri, 21 Jan 2022 18:36:22 +0100
Message-Id: <20220121173622.192744-1-soenke.huster@eknoes.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: /
X-Rspamd-Report: BAYES_HAM(-2.999998) R_MISSING_CHARSET(0.5) MIME_GOOD(-0.1) MID_CONTAINS_FROM(1) SUSPICIOUS_RECIPS(1.5)
X-Rspamd-Score: -0.099998
Received: from unknown (HELO unkown) (::1)
        by giacobini.uberspace.de (Haraka/2.8.28) with ESMTPSA; Fri, 21 Jan 2022 18:37:00 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a HCI_CONNECTION_COMPLETE event is received multiple times
for the same handle, the device is registered multiple times which leads
to memory corruptions. Therefore, consequent events for a single
connection are ignored.

The conn->state can hold different values so conn->handle is
checked to detect whether a connection is already set up.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=215497
Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
---
This fixes the referenced bug and several use-after-free issues I discovered.
I tagged it as RFC, as I am not 100% sure if checking the existence of the
handle is the correct approach, but to the best of my knowledge it must be
set for the first time in this function for valid connections of this event,
therefore it should be fine.

net/bluetooth/hci_event.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 681c623aa380..71ccb12c928d 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3106,6 +3106,17 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, void *data,
 		}
 	}
 
+	/* The HCI_Connection_Complete event is only sent once per connection.
+	 * Processing it more than once per connection can corrupt kernel memory.
+	 *
+	 * As the connection handle is set here for the first time, it indicates
+	 * whether the connection is already set up.
+	 */
+	if (conn->handle) {
+		bt_dev_err(hdev, "Ignoring HCI_Connection_Complete for existing connection");
+		goto unlock;
+	}
+
 	if (!ev->status) {
 		conn->handle = __le16_to_cpu(ev->handle);
 
-- 
2.34.1

