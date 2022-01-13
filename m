Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9EC48D4DD
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 10:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbiAMJOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 04:14:15 -0500
Received: from giacobini.uberspace.de ([185.26.156.129]:48098 "EHLO
        giacobini.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233900AbiAMJMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 04:12:50 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jan 2022 04:12:49 EST
Received: (qmail 1960 invoked by uid 990); 13 Jan 2022 09:06:04 -0000
Authentication-Results: giacobini.uberspace.de;
        auth=pass (plain)
From:   Soenke Huster <soenke.huster@eknoes.de>
To:     me@eknoes.de, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Soenke Huster <soenke.huster@eknoes.de>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: fix null ptr deref on hci_sync_conn_complete_evt
Date:   Thu, 13 Jan 2022 10:05:52 +0100
Message-Id: <20220113090553.40362-1-soenke.huster@eknoes.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: ++
X-Rspamd-Report: BAYES_HAM(-0.044325) R_MISSING_CHARSET(0.5) MIME_GOOD(-0.1) MID_CONTAINS_FROM(1) SUSPICIOUS_RECIPS(1.5)
X-Rspamd-Score: 2.855674
Received: from unknown (HELO unkown) (::1)
        by giacobini.uberspace.de (Haraka/2.8.28) with ESMTPSA; Thu, 13 Jan 2022 10:06:04 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This event is specified just for SCO and eSCO link types.
On the reception of a HCI_Synchronous_Connection_Complete for a BDADDR
of an existing LE connection, LE link type and a status that triggers the
second case of the packet processing a NULL pointer dereference happens,
as conn->link is NULL.

Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
---
I found this null pointer dereference while fuzzing bluetooth-next. 
On the described behaviour, a null ptr deref in line 4723 happens, as 
conn->link is NULL. According to the Core spec, Link_Type must be SCO or eSCO,
all other values are reserved for future use. Checking that mitigates a null 
pointer dereference.

 net/bluetooth/hci_event.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index fc30f4c03d29..fc3f29d195d2 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4661,6 +4661,11 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev, void *data,
 	struct hci_ev_sync_conn_complete *ev = data;
 	struct hci_conn *conn;
 
+	if (ev->link_type != SCO_LINK || ev->link_type != ESCO_LINK) {
+		bt_dev_err(hdev, "Ignoring connect complete event for invalid link type");
+		return;
+	}
+
 	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
-- 
2.34.1

