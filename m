Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9E8450105
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 10:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhKOJVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 04:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhKOJVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 04:21:19 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02039C061746
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 01:18:24 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id v7-20020a25ab87000000b005c2130838beso26023640ybi.0
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 01:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kCy6lJ3Y6mrf9EnZDJoiQgWHaGA5tu6NQzDrMR4H1Xs=;
        b=kRLc8y+sIBebqXEZ+zGfkmLRlIQMXeAH0opUhShqdQZzVF224kGZzw83Q1bbxljK2R
         rCtYkVSN1MwC5GMi0kMY5xXzonHErnKMWNNISXoRE6bh8HBs8jqYB+AZ4V8LZDRZUW26
         BmW29/w2y+kQg0btU2npeU954OPokgNV0uuoDaxyjnbjHaay2TYpLlNwdN9zTAChyKBv
         8yNgy8adqNqHau3hVEJniDJdu+EGJnEXJ/taH7uLw0QZMMvn+wd+TlPPvop3krbMpyOD
         qCy6Azhlv5sYqBYAorHdfOJVKZ8htHGnEzSQWihXzeFVEqX4IiehyjNieDH5srTKkMkC
         BZVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kCy6lJ3Y6mrf9EnZDJoiQgWHaGA5tu6NQzDrMR4H1Xs=;
        b=IvyBLVZEaPrLczTfjFLri0leLmFbfhLWCrzy9sET4VqSOVzr9nizCROM8ai94d/VQn
         Q6PegwRFyTp3RL5yR7SyBQAIc9pQCJdqVbRMIWKwy3ROofyGhnEX1udcKvB4oKMqaTkv
         bKfSM2QnS21Ev/eIgvqa6b/fjzUKiocSJyIL2eEIF2lEcpb3ATf68VjBPxrKYdXO5Pjq
         LQHXYyNCapSztlrGn6ywZInpYrIcbum1pjt3XsIBIGcayMXAh6xuXiaobGszbRe/PkNE
         9bQuLL8WgyIn/K3LPKgvAWRpAO3Cy2zauVUYPvRCm7niuwnf6/K8iZ+evymnm/UBKuGu
         /jgg==
X-Gm-Message-State: AOAM531jZ6SS6fjUDCK0dqubB7pcgShWC7M+GQi4kEhe8lejjrE6q1DX
        2nxUtB5fD4qkgoPy5qjSCgrqgyCuH0QV
X-Google-Smtp-Source: ABdhPJz82POTNoWkDhIG9zoITHgI0U3gzcom5MUNCPWabksJwKXm4XOEHcXbQgMohmkj0AqtdSuPf/PBoyBP
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:10:5c8f:7191:e5ca:14fb])
 (user=apusaka job=sendgmr) by 2002:a05:6902:1201:: with SMTP id
 s1mr36546890ybu.248.1636967902948; Mon, 15 Nov 2021 01:18:22 -0800 (PST)
Date:   Mon, 15 Nov 2021 17:17:49 +0800
Message-Id: <20211115171726.v2.1.Id7366eb14b6f48173fcbf17846ace59479179c7c@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v2 1/2] Bluetooth: Send device found event on name resolve failure
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

Introducing CONFIRM_NAME_FAILED flag that will be sent together with
device found event on name resolve failure. This will provide the
userspace with an information so it can decide not to resolve the
name for these devices in the future.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>

---
Hi maintainers,

This is the patch series for remote name request as was discussed here.
https://patchwork.kernel.org/project/bluetooth/patch/20211028191805.1.I35b7f3a496f834de6b43a32f94b6160cb1467c94@changeid/
Please also review the corresponding userspace change.

Thanks,
Archie

Changes in v2:
* Remove the part which accepts DONT_CARE flag in MGMT_OP_CONFIRM_NAME
* Rename MGMT constant to conform with the docs

 include/net/bluetooth/mgmt.h |  1 +
 net/bluetooth/hci_event.c    | 11 ++++-------
 net/bluetooth/mgmt.c         | 11 ++++++++---
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 23a0524061b7..3cda081ed6d0 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -940,6 +940,7 @@ struct mgmt_ev_auth_failed {
 #define MGMT_DEV_FOUND_LEGACY_PAIRING  0x02
 #define MGMT_DEV_FOUND_NOT_CONNECTABLE 0x04
 #define MGMT_DEV_FOUND_INITIATED_CONN  0x08
+#define MGMT_DEV_FOUND_NAME_REQUEST_FAILED 0x10
 
 #define MGMT_EV_DEVICE_FOUND		0x0012
 struct mgmt_ev_device_found {
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index d4b75a6cfeee..2de3080659f9 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2175,13 +2175,10 @@ static void hci_check_pending_name(struct hci_dev *hdev, struct hci_conn *conn,
 		return;
 
 	list_del(&e->list);
-	if (name) {
-		e->name_state = NAME_KNOWN;
-		mgmt_remote_name(hdev, bdaddr, ACL_LINK, 0x00,
-				 e->data.rssi, name, name_len);
-	} else {
-		e->name_state = NAME_NOT_KNOWN;
-	}
+
+	e->name_state = name ? NAME_KNOWN : NAME_NOT_KNOWN;
+	mgmt_remote_name(hdev, bdaddr, ACL_LINK, 0x00, e->data.rssi,
+			 name, name_len);
 
 	if (hci_resolve_next_name(hdev))
 		return;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 06384d761928..0d77c010b391 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9615,7 +9615,8 @@ void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 {
 	struct mgmt_ev_device_found *ev;
 	char buf[sizeof(*ev) + HCI_MAX_NAME_LENGTH + 2];
-	u16 eir_len;
+	u16 eir_len = 0;
+	u32 flags = 0;
 
 	ev = (struct mgmt_ev_device_found *) buf;
 
@@ -9625,10 +9626,14 @@ void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 	ev->addr.type = link_to_bdaddr(link_type, addr_type);
 	ev->rssi = rssi;
 
-	eir_len = eir_append_data(ev->eir, 0, EIR_NAME_COMPLETE, name,
-				  name_len);
+	if (name)
+		eir_len = eir_append_data(ev->eir, 0, EIR_NAME_COMPLETE, name,
+					  name_len);
+	else
+		flags |= MGMT_DEV_FOUND_NAME_REQUEST_FAILED;
 
 	ev->eir_len = cpu_to_le16(eir_len);
+	ev->flags = cpu_to_le32(flags);
 
 	mgmt_event(MGMT_EV_DEVICE_FOUND, hdev, ev, sizeof(*ev) + eir_len, NULL);
 }
-- 
2.34.0.rc1.387.gb447b232ab-goog

