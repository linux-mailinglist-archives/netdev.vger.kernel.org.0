Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4821FC4EA
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 06:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgFQEAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 00:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbgFQEAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 00:00:38 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01854C0613EE
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 21:00:38 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x22so484651pfn.3
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 21:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=12CQMLW8zmSrgKFzSh+r0y7cKk1f3YOfpNSAMUhjbUc=;
        b=h8gh68mOHQHIj7mWB8bgLKRYk19xCBCgRI1kAoxM/LiqF74H19cbrjx+2QiPwKTHjY
         Zgfu8Y2FQVoO8teD3IEyNJRw3pSjlBwnSQ8tK5qrebKzRfgf6f/n8vm2MdgrGZMPll40
         SJ7WJJpT9iQK/ZkwAxI4bI8Y+YI+gZMNiEO2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=12CQMLW8zmSrgKFzSh+r0y7cKk1f3YOfpNSAMUhjbUc=;
        b=t0PYuIpDFkW0U+ji488M1QcR7yGb98SHpx1tQjizIL5zTF+NU9pJ4FZT6qIt2oxSgJ
         XZNUUVYV2vRdVF6o1onuYqRMgysBuWGhNCrWdHRECqcMQMRkbg4WVNDUjSGHFlpn8Pyl
         IpGo8O2JgdN/UNiPtz36+fhRded8HnfLkhlOaLQKUCrBo8p5lQ10KcEN3hVS1qrmgqHO
         kJP2iqwGSabinJxQ2XC5NC8aBdQ1yfXGY36h06Yn5IZqnhp/kHlJDrqFac4Oy8FuYnPI
         /lR6RbRcCOG+8YqJcmgtLpaueyv/Rmeed4bv9X42hL7SGWKRJcpvDhjF3KgptSH6WUDT
         z6RQ==
X-Gm-Message-State: AOAM533tI51uQ/78WY+/anamDSMcYrNEh6h+UoqSDZ4NRg3QKGLgl90e
        wayN4kM4kGULZ+z72fcfhwomaw==
X-Google-Smtp-Source: ABdhPJyoKl99XxndMfj2zS2cjb84ilSQJswh72daWSynJYcRGmPoOb9p9VIUaP+6GQoMl15OzWu7vQ==
X-Received: by 2002:a62:6286:: with SMTP id w128mr4815132pfb.117.1592366437515;
        Tue, 16 Jun 2020 21:00:37 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id q1sm20013089pfk.132.2020.06.16.21.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 21:00:37 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     alainm@chromium.org, chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 2/4] Bluetooth: Replace wakeable list with flag
Date:   Tue, 16 Jun 2020 21:00:20 -0700
Message-Id: <20200616210008.2.I577641918ec743663538eab7aa73c719daacb90d@changeid>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
In-Reply-To: <20200617040022.174448-1-abhishekpandit@chromium.org>
References: <20200617040022.174448-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the classic device list now supports flags, convert the wakeable
list into a flag on the existing device list.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>
---

 include/net/bluetooth/hci_core.h | 11 ++++++++++-
 net/bluetooth/hci_core.c         |  1 -
 net/bluetooth/hci_request.c      | 12 ++++++++----
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 95a3935325bbbc..0643c737ba8528 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -143,6 +143,16 @@ struct bdaddr_list_with_flags {
 	u32 current_flags;
 };
 
+enum hci_conn_flags {
+	HCI_CONN_FLAG_REMOTE_WAKEUP,
+	HCI_CONN_FLAG_MAX
+};
+
+#define hci_conn_test_flag(nr, flags) ((flags) & (1U << nr))
+
+/* Make sure number of flags doesn't exceed sizeof(current_flags) */
+static_assert(HCI_CONN_FLAG_MAX < 32);
+
 struct bt_uuid {
 	struct list_head list;
 	u8 uuid[16];
@@ -463,7 +473,6 @@ struct hci_dev {
 	struct list_head	mgmt_pending;
 	struct list_head	blacklist;
 	struct list_head	whitelist;
-	struct list_head	wakeable;
 	struct list_head	uuids;
 	struct list_head	link_keys;
 	struct list_head	long_term_keys;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 8a471bec2731ed..8e01afb2ee8c5c 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3499,7 +3499,6 @@ struct hci_dev *hci_alloc_dev(void)
 	INIT_LIST_HEAD(&hdev->mgmt_pending);
 	INIT_LIST_HEAD(&hdev->blacklist);
 	INIT_LIST_HEAD(&hdev->whitelist);
-	INIT_LIST_HEAD(&hdev->wakeable);
 	INIT_LIST_HEAD(&hdev->uuids);
 	INIT_LIST_HEAD(&hdev->link_keys);
 	INIT_LIST_HEAD(&hdev->long_term_keys);
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index a7f572ad38ef08..a5b53d3ea50802 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -968,15 +968,19 @@ static void hci_req_clear_event_filter(struct hci_request *req)
 
 static void hci_req_set_event_filter(struct hci_request *req)
 {
-	struct bdaddr_list *b;
+	struct bdaddr_list_with_flags *b;
 	struct hci_cp_set_event_filter f;
 	struct hci_dev *hdev = req->hdev;
-	u8 scan;
+	u8 scan = SCAN_DISABLED;
 
 	/* Always clear event filter when starting */
 	hci_req_clear_event_filter(req);
 
-	list_for_each_entry(b, &hdev->wakeable, list) {
+	list_for_each_entry(b, &hdev->whitelist, list) {
+		if (!hci_conn_test_flag(HCI_CONN_FLAG_REMOTE_WAKEUP,
+					b->current_flags))
+			continue;
+
 		memset(&f, 0, sizeof(f));
 		bacpy(&f.addr_conn_flt.bdaddr, &b->bdaddr);
 		f.flt_type = HCI_FLT_CONN_SETUP;
@@ -985,9 +989,9 @@ static void hci_req_set_event_filter(struct hci_request *req)
 
 		bt_dev_dbg(hdev, "Adding event filters for %pMR", &b->bdaddr);
 		hci_req_add(req, HCI_OP_SET_EVENT_FLT, sizeof(f), &f);
+		scan = SCAN_PAGE;
 	}
 
-	scan = !list_empty(&hdev->wakeable) ? SCAN_PAGE : SCAN_DISABLED;
 	hci_req_add(req, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
 }
 
-- 
2.27.0.290.gba653c62da-goog

