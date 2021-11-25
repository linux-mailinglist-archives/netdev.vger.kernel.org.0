Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE91245D514
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 08:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353052AbhKYHJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 02:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348845AbhKYHH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 02:07:56 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423B0C06173E
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 23:04:46 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id dz17-20020ad45891000000b003bbb4aba6d7so5344600qvb.12
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 23:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qnF9S/WVbJtB6SNaZPimqTxpLICpyTdyDhWxnzxObkI=;
        b=H7XfQ5p8QSHMsVXHAKeX16az9dOndxxkoU5ZzJ2p2klQeg7xAEQgTFUGORuO2HogYU
         jemG1W+jiUpODS2niZA4RFQ1UsGkjdugydko8s0eSNqXCZvWYqig69W1bRaR0KfCYxiJ
         nKdK0cB7DX/SucIn9ux7aiwHpFQpPDR+QEGrvDaXNPCIiUmQNYMRJfJBDlxXA1VS1Pye
         Lhf5fmI7QZOL2CEgS70PmR47fj4hAEUYFX/EU1/Qej+bqNzxV0oPWkXOOrTTkrRouhfC
         UqqGF63/5KsU/3H7Gi6iYXAHf6oJpvs3UCZlOPqZnsW6YnLBEK7SaMwweCTko38pVfIv
         chCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qnF9S/WVbJtB6SNaZPimqTxpLICpyTdyDhWxnzxObkI=;
        b=BRkwgCspUQFkcArx/yLl/nYLTv34yQ6KyFxyDi33/ZC4/B1qgnYh1MZ7jvom8tGG3a
         hcUN1bYNyIS0AyYtQ2ebWhii4EJjyKpMnKgFi4n6rzJ9p4t1PamAJ6cygC55q5W5vm/7
         USPTYoLV5y0rnQgXr6V749F+TJX0HrjxxE1dRBOeycAb21qW5hruAIboCNqjC0j070Mu
         5RwjFXZJxgObvrnGGQ9EOsg6C3SnVCL5XC61dFetweS6Mes1zzsmzQ4O5LnegtlcLcIu
         DYSrr8y1yaR6xxv9DP4WUgmc0wFtAeQcJTXVjaw8CeMJQ3r5KJ0RHigZOti/3KAMXXQ3
         wA2g==
X-Gm-Message-State: AOAM531DK5pmY2AnT1QqNuVKLE/xzEpgCnT1MCC+JLejOnccy0Aoo+DP
        /Ez27zKJB/zm/yNl9sfXFKgf+HUtP2CC
X-Google-Smtp-Source: ABdhPJwzOa27lBS1LUYCnerWVnbBZmstJ9dgvqaSWe7ZDudiw7jY4/u+e5S7uELuO2QQ+eInTOdEXEKnmhvY
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:10:a5d9:6769:9abb:6b2])
 (user=apusaka job=sendgmr) by 2002:a25:1186:: with SMTP id
 128mr3963705ybr.547.1637823885246; Wed, 24 Nov 2021 23:04:45 -0800 (PST)
Date:   Thu, 25 Nov 2021 15:04:36 +0800
Message-Id: <20211125150430.v3.1.Id7366eb14b6f48173fcbf17846ace59479179c7c@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 1/2] Bluetooth: Send device found event on name resolve failure
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

Introducing NAME_REQUEST_FAILED flag that will be sent together with
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

Changes in v3:
* Reindent defines
* Assign variables inside if block instead of initializing

Changes in v2:
* Remove the part which accepts DONT_CARE flag in MGMT_OP_CONFIRM_NAME
* Rename MGMT constant to conform with the docs

 include/net/bluetooth/mgmt.h |  9 +++++----
 net/bluetooth/hci_event.c    | 11 ++++-------
 net/bluetooth/mgmt.c         | 12 ++++++++++--
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 23a0524061b7..107b25deae68 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -936,10 +936,11 @@ struct mgmt_ev_auth_failed {
 	__u8	status;
 } __packed;
 
-#define MGMT_DEV_FOUND_CONFIRM_NAME    0x01
-#define MGMT_DEV_FOUND_LEGACY_PAIRING  0x02
-#define MGMT_DEV_FOUND_NOT_CONNECTABLE 0x04
-#define MGMT_DEV_FOUND_INITIATED_CONN  0x08
+#define MGMT_DEV_FOUND_CONFIRM_NAME		0x01
+#define MGMT_DEV_FOUND_LEGACY_PAIRING		0x02
+#define MGMT_DEV_FOUND_NOT_CONNECTABLE		0x04
+#define MGMT_DEV_FOUND_INITIATED_CONN		0x08
+#define MGMT_DEV_FOUND_NAME_REQUEST_FAILED	0x10
 
 #define MGMT_EV_DEVICE_FOUND		0x0012
 struct mgmt_ev_device_found {
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index dee4ef22fc88..bb4c04aecccf 100644
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
index f8f74d344297..bf989ae03f9f 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9615,6 +9615,7 @@ void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 	struct mgmt_ev_device_found *ev;
 	char buf[sizeof(*ev) + HCI_MAX_NAME_LENGTH + 2];
 	u16 eir_len;
+	u32 flags;
 
 	ev = (struct mgmt_ev_device_found *) buf;
 
@@ -9624,10 +9625,17 @@ void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 	ev->addr.type = link_to_bdaddr(link_type, addr_type);
 	ev->rssi = rssi;
 
-	eir_len = eir_append_data(ev->eir, 0, EIR_NAME_COMPLETE, name,
-				  name_len);
+	if (name) {
+		eir_len = eir_append_data(ev->eir, 0, EIR_NAME_COMPLETE, name,
+					  name_len);
+		flags = 0;
+	} else {
+		eir_len = 0;
+		flags = MGMT_DEV_FOUND_NAME_REQUEST_FAILED;
+	}
 
 	ev->eir_len = cpu_to_le16(eir_len);
+	ev->flags = cpu_to_le32(flags);
 
 	mgmt_event(MGMT_EV_DEVICE_FOUND, hdev, ev, sizeof(*ev) + eir_len, NULL);
 }
-- 
2.34.0.rc2.393.gf8c9666880-goog

