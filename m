Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3CE44D61E
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 12:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhKKL45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 06:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbhKKL44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 06:56:56 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F0CC061767
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 03:54:07 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id z2-20020a254c02000000b005b68ef4fe24so8915673yba.11
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 03:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Hgd5YNG4upTVksFs9U+r5jmVvwpkkXvR39uZVhLasCA=;
        b=tO7a86t4tu8YX1hGLaS/0nJv74RPnfRHZF+/h2hcjoHeneujABR4wmNeYqch4pJql8
         znCEQCBD4j8tjp0tJVDUi9kXFkFDS/psPsUfEG+v+DHSfu9svjWQeMSmwrW9Qq1V1qr3
         0X3BHiFTD6jrUEDtkLOwJYOCT77RITOlXNcAmkLstAPy4jQeAUPaGT2YdRk/euKYwYMn
         4jDn9nExCgWzke6XHz9KqhQVg+Q6ZtQNK155Ws4Xg4wvxMESLj6xwtDrZ0xjq4F9Uy+8
         QBEepNGU27gCiiCetzm4Sw+FHtUKe3PYH6tG0Bxw4wcuL3f8oE38OkPW2uJN+n0P2uoB
         UCng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Hgd5YNG4upTVksFs9U+r5jmVvwpkkXvR39uZVhLasCA=;
        b=kYULfQVzq/G99kf2rgKUXEtJmSEXiKC3KkWsLU0+g4kBBOoL+LlgLYTKCNfJJXm67z
         lEUqfWl2+uvzIsyoF1cY6XiEBf1UjHLd26qzi5CioJJuba9/5OrJpfgFx/zeKK2YHxhj
         y9/oVotGrcz0l16vEjIPqPPX4cfZHB2LbA0XPET1NaIsyGwx1IvXqqHQs6nkrCXsWmdW
         tVl2n7HAn7vTyCiL7a+yCUTE4DPaXnNatx59bFy8oN0qPevx9b3CuRYJpVWOpg220Knx
         Cl2b/wgEV/HJIw2xy3k+J6Etk1PE4YaAdfyWz/06XsqY10unBb71Y+Vx8SQkAxbqxozQ
         d2gQ==
X-Gm-Message-State: AOAM530LCsewkbJfs9zF3u+hxHAiEnLmDW4el0420xvaf4n8fNphUhzq
        bTS9+3J75Lu7aQQkpCyLajfX5VZA6Nol
X-Google-Smtp-Source: ABdhPJwbEdHA/SYjwH5ny9OeUCta03+SBhoyRu7ZFXJb/kosZsNn3+InlZemiUIZc39h0lnyTHgmhh6CPO6W
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:10:b87e:3eb:e17e:1273])
 (user=apusaka job=sendgmr) by 2002:a05:6902:150b:: with SMTP id
 q11mr7798659ybu.386.1636631646640; Thu, 11 Nov 2021 03:54:06 -0800 (PST)
Date:   Thu, 11 Nov 2021 19:53:50 +0800
Message-Id: <20211111195320.1.Id7366eb14b6f48173fcbf17846ace59479179c7c@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 1/3] Bluetooth: Send device found event on name resolve failure
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

 include/net/bluetooth/mgmt.h |  1 +
 net/bluetooth/hci_event.c    | 11 ++++-------
 net/bluetooth/mgmt.c         | 11 ++++++++---
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 23a0524061b7..113438f295bf 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -940,6 +940,7 @@ struct mgmt_ev_auth_failed {
 #define MGMT_DEV_FOUND_LEGACY_PAIRING  0x02
 #define MGMT_DEV_FOUND_NOT_CONNECTABLE 0x04
 #define MGMT_DEV_FOUND_INITIATED_CONN  0x08
+#define MGMT_DEV_FOUND_CONFIRM_NAME_FAILED 0x10
 
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
index 06384d761928..c1d6fbc19207 100644
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
+		flags |= MGMT_DEV_FOUND_CONFIRM_NAME_FAILED;
 
 	ev->eir_len = cpu_to_le16(eir_len);
+	ev->flags = cpu_to_le32(flags);
 
 	mgmt_event(MGMT_EV_DEVICE_FOUND, hdev, ev, sizeof(*ev) + eir_len, NULL);
 }
-- 
2.34.0.rc0.344.g81b53c2807-goog

