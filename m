Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29051FC4EC
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 06:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgFQEAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 00:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbgFQEAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 00:00:38 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5672C06174E
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 21:00:36 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y18so327221plr.4
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 21:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SlQ5igEsh5KDwoixNwY0LLGl50IR6ZlWr1kPj8X7CoQ=;
        b=Kma4vbXHFqBrO4xMrAauPTUefYukJYvQE4Oen/Q5PnIWkf/92pL9prUePtRX003eSP
         B0ZwK6gIJAPYk8TVsOLhwP5Wq/DA1q9/vqOdQfWdhN7/R/jsFIqE9Fupl2UAFuKZ9HDz
         TS7N/eFleOWflvN/8vzgDFDwKf4uE+2/IyVH0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SlQ5igEsh5KDwoixNwY0LLGl50IR6ZlWr1kPj8X7CoQ=;
        b=IEwxKRPCVfExs3rp5NENxnBwCKsxeWZtbq/xlym0Io6ZgvoAa1w3GdfVclRnTeI9wK
         BCs0w0bbkKNMVZM4O5VJzIGuVws2sB3mrhhcI/4sbJzBaAPVplTmxaENTbreV7cKDZhp
         5cBkpl/ucSb4o/op0wUryf4Aw2f+MdIW5rY1LKj8nWXRrGaH6eCw7sHr3fVtfd7387ss
         K2NAJRlWTLAXGcH7np0DZlTdIvYBt+5bXbDIxVkj4+RazHPBqvwOo4oz564BAQcxwfPc
         2F2tR8NmFYEUdplebAr367dIjOxHQlWrZbW8NOghAKjVhGeyLlV7w8Fte0+RDeOLBDzW
         XmSw==
X-Gm-Message-State: AOAM530S3LB11mTYDGlYIXBLl2XjrJ5D7QA+x3HIcyvw3sZ5InjvUHoa
        UCA96oAz/sfEYjdhGTdu2ffZAQ==
X-Google-Smtp-Source: ABdhPJwq/11e42VrUCeaJmKkcZfECkB69efRQz9evTXpw2YJ/ExLfgLG2WDEPqnTSa9yzHZFSaTOhw==
X-Received: by 2002:a17:902:bc4c:: with SMTP id t12mr4729669plz.141.1592366436465;
        Tue, 16 Jun 2020 21:00:36 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id q1sm20013089pfk.132.2020.06.16.21.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 21:00:36 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     alainm@chromium.org, chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 1/4] Bluetooth: Add bdaddr_list_with_flags for classic whitelist
Date:   Tue, 16 Jun 2020 21:00:19 -0700
Message-Id: <20200616210008.1.I31e5a748e9aacdf5494c1904c59066415cb5b097@changeid>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
In-Reply-To: <20200617040022.174448-1-abhishekpandit@chromium.org>
References: <20200617040022.174448-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to more easily add device flags to classic devices, create
a new type of bdaddr_list that supports setting flags.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>
---

 include/net/bluetooth/hci_core.h | 18 ++++++++--
 net/bluetooth/hci_core.c         | 58 ++++++++++++++++++++++++++++++++
 net/bluetooth/hci_event.c        |  8 ++---
 net/bluetooth/mgmt.c             |  5 +--
 4 files changed, 81 insertions(+), 8 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 0d5dbb6cb5a089..95a3935325bbbc 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -136,6 +136,13 @@ struct bdaddr_list_with_irk {
 	u8 local_irk[16];
 };
 
+struct bdaddr_list_with_flags {
+	struct list_head list;
+	bdaddr_t bdaddr;
+	u8 bdaddr_type;
+	u32 current_flags;
+};
+
 struct bt_uuid {
 	struct list_head list;
 	u8 uuid[16];
@@ -1169,12 +1176,19 @@ struct bdaddr_list *hci_bdaddr_list_lookup(struct list_head *list,
 struct bdaddr_list_with_irk *hci_bdaddr_list_lookup_with_irk(
 				    struct list_head *list, bdaddr_t *bdaddr,
 				    u8 type);
+struct bdaddr_list_with_flags *
+hci_bdaddr_list_lookup_with_flags(struct list_head *list, bdaddr_t *bdaddr,
+				  u8 type);
 int hci_bdaddr_list_add(struct list_head *list, bdaddr_t *bdaddr, u8 type);
 int hci_bdaddr_list_add_with_irk(struct list_head *list, bdaddr_t *bdaddr,
-					u8 type, u8 *peer_irk, u8 *local_irk);
+				 u8 type, u8 *peer_irk, u8 *local_irk);
+int hci_bdaddr_list_add_with_flags(struct list_head *list, bdaddr_t *bdaddr,
+				   u8 type, u32 flags);
 int hci_bdaddr_list_del(struct list_head *list, bdaddr_t *bdaddr, u8 type);
 int hci_bdaddr_list_del_with_irk(struct list_head *list, bdaddr_t *bdaddr,
-								u8 type);
+				 u8 type);
+int hci_bdaddr_list_del_with_flags(struct list_head *list, bdaddr_t *bdaddr,
+				   u8 type);
 void hci_bdaddr_list_clear(struct list_head *list);
 
 struct hci_conn_params *hci_conn_params_lookup(struct hci_dev *hdev,
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 4f1052a7c488e5..8a471bec2731ed 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3023,6 +3023,20 @@ struct bdaddr_list_with_irk *hci_bdaddr_list_lookup_with_irk(
 	return NULL;
 }
 
+struct bdaddr_list_with_flags *
+hci_bdaddr_list_lookup_with_flags(struct list_head *bdaddr_list,
+				  bdaddr_t *bdaddr, u8 type)
+{
+	struct bdaddr_list_with_flags *b;
+
+	list_for_each_entry(b, bdaddr_list, list) {
+		if (!bacmp(&b->bdaddr, bdaddr) && b->bdaddr_type == type)
+			return b;
+	}
+
+	return NULL;
+}
+
 void hci_bdaddr_list_clear(struct list_head *bdaddr_list)
 {
 	struct bdaddr_list *b, *n;
@@ -3084,6 +3098,30 @@ int hci_bdaddr_list_add_with_irk(struct list_head *list, bdaddr_t *bdaddr,
 	return 0;
 }
 
+int hci_bdaddr_list_add_with_flags(struct list_head *list, bdaddr_t *bdaddr,
+				   u8 type, u32 flags)
+{
+	struct bdaddr_list_with_flags *entry;
+
+	if (!bacmp(bdaddr, BDADDR_ANY))
+		return -EBADF;
+
+	if (hci_bdaddr_list_lookup(list, bdaddr, type))
+		return -EEXIST;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	bacpy(&entry->bdaddr, bdaddr);
+	entry->bdaddr_type = type;
+	entry->current_flags = flags;
+
+	list_add(&entry->list, list);
+
+	return 0;
+}
+
 int hci_bdaddr_list_del(struct list_head *list, bdaddr_t *bdaddr, u8 type)
 {
 	struct bdaddr_list *entry;
@@ -3123,6 +3161,26 @@ int hci_bdaddr_list_del_with_irk(struct list_head *list, bdaddr_t *bdaddr,
 	return 0;
 }
 
+int hci_bdaddr_list_del_with_flags(struct list_head *list, bdaddr_t *bdaddr,
+				   u8 type)
+{
+	struct bdaddr_list_with_flags *entry;
+
+	if (!bacmp(bdaddr, BDADDR_ANY)) {
+		hci_bdaddr_list_clear(list);
+		return 0;
+	}
+
+	entry = hci_bdaddr_list_lookup_with_flags(list, bdaddr, type);
+	if (!entry)
+		return -ENOENT;
+
+	list_del(&entry->list);
+	kfree(entry);
+
+	return 0;
+}
+
 /* This function requires the caller holds hdev->lock */
 struct hci_conn_params *hci_conn_params_lookup(struct hci_dev *hdev,
 					       bdaddr_t *addr, u8 addr_type)
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index cfeaee347db32d..8981954ff4c47d 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2697,10 +2697,10 @@ static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	 */
 	if (hci_dev_test_flag(hdev, HCI_MGMT) &&
 	    !hci_dev_test_flag(hdev, HCI_CONNECTABLE) &&
-	    !hci_bdaddr_list_lookup(&hdev->whitelist, &ev->bdaddr,
-				    BDADDR_BREDR)) {
-		    hci_reject_conn(hdev, &ev->bdaddr);
-		    return;
+	    !hci_bdaddr_list_lookup_with_flags(&hdev->whitelist, &ev->bdaddr,
+					       BDADDR_BREDR)) {
+		hci_reject_conn(hdev, &ev->bdaddr);
+		return;
 	}
 
 	/* Connection accepted */
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 99fbfd467d0465..6d996e5e5bcc2d 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -5997,8 +5997,9 @@ static int add_device(struct sock *sk, struct hci_dev *hdev,
 			goto unlock;
 		}
 
-		err = hci_bdaddr_list_add(&hdev->whitelist, &cp->addr.bdaddr,
-					  cp->addr.type);
+		err = hci_bdaddr_list_add_with_flags(&hdev->whitelist,
+						     &cp->addr.bdaddr,
+						     cp->addr.type, 0);
 		if (err)
 			goto unlock;
 
-- 
2.27.0.290.gba653c62da-goog

