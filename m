Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655471E70ED
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437883AbgE1Xzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437882AbgE1XzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 19:55:21 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5FAC08C5C9
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 16:55:20 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id u5so398969pgn.5
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 16:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4uzEVL38VnLA055ggimvNqS27CuUhb0l7OZ76M+p52k=;
        b=DcpKCzWzFCb7Wjhhqm/mTPtyqG8qqPDnRbPIMfXA7xIXvB0VTQhpYoXPK1DOpBoeU1
         YL6GKbpTwfaAPp9YPeL7CMNiDbbEQVdvfzqjO1UpSTZTsmuspdF3ffo4LNlEuWaGP5sB
         qsWVP2XHK4MdCdYlCD9wWQMmk5A8iO8lSZiwc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4uzEVL38VnLA055ggimvNqS27CuUhb0l7OZ76M+p52k=;
        b=XhHxQ0EjPjnTnijEtkYqALourkuYCIMEN3zOG6xTL98OfuOEi/eCgQzcLIPu+MV7vK
         rlK5bkjTFwjDxJ3XSOcjs9sxsG4aL4hnQ7nG8lMz0zdWRUFsPJgeN7iKZRLtP1lE+u5v
         lM8//mih1VaXDVnXq3jMj73wDbLo54CMvC3oXfjWHZ5QTisCCoWpcOoP/tGm/smDe5tJ
         R7J5XidJsQtiw8kyYJdAKzkIVj2cVeixi2ustoOifKTEBglQziW6yPH7s5lmpGjldQ5d
         UI0gnO3gQUI0jEzL7pIbD02RA/5NBbCqqo/hqLqEu9yXjM07aubSrCs2KhQ7h90FGd7j
         OZvw==
X-Gm-Message-State: AOAM531I81H1Qo7zqYU4qJVOSWXp9sAb3b5JTGttCzBjznpvtzPsj6GR
        9QS/LOFcSsQQljANCtbRngcgKw==
X-Google-Smtp-Source: ABdhPJwo7x+KAwgNXaoq8+h5+4tfFslbe1o3Ts2LamXu20imhcy2+QM3YJEoa31aGMqrinG2bl3H4Q==
X-Received: by 2002:a62:8647:: with SMTP id x68mr5798215pfd.178.1590710120189;
        Thu, 28 May 2020 16:55:20 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id f18sm5022591pga.75.2020.05.28.16.55.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 May 2020 16:55:19 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Alain Michaud <alainm@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Yoni Shavit <yshavit@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 4/7] Bluetooth: Add handler of MGMT_OP_REMOVE_ADV_MONITOR
Date:   Thu, 28 May 2020 16:54:52 -0700
Message-Id: <20200528165324.v1.4.Ib4effd5813fb2f8585e2c7394735050c16a765eb@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528165324.v1.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
References: <20200528165324.v1.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the request handler of MGMT_OP_REMOVE_ADV_MONITOR command.
Note that the controller-based monitoring is not yet in place. This
removes the internal monitor(s) without sending HCI traffic, so the
request returns immediately.

The following test was performed.
- Issue btmgmt advmon-remove with valid and invalid handles.

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
---

 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_core.c         | 31 +++++++++++++++++++++++++++++++
 net/bluetooth/mgmt.c             | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 862d94f711bc0..78ac7fd282d77 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1242,6 +1242,7 @@ void hci_adv_instances_set_rpa_expired(struct hci_dev *hdev, bool rpa_expired);
 void hci_adv_monitors_clear(struct hci_dev *hdev);
 void hci_free_adv_monitor(struct adv_monitor *monitor);
 int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor);
+int hci_remove_adv_monitor(struct hci_dev *hdev, u16 handle);
 
 void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb);
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 93c16bfc6da15..1fcd0cc2dcc5b 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3041,6 +3041,37 @@ int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor)
 	return 0;
 }
 
+static int free_adv_monitor(int id, void *ptr, void *data)
+{
+	struct hci_dev *hdev = data;
+	struct adv_monitor *monitor = ptr;
+
+	idr_remove(&hdev->adv_monitors_idr, monitor->handle);
+	hci_free_adv_monitor(monitor);
+
+	return 0;
+}
+
+/* This function requires the caller holds hdev->lock */
+int hci_remove_adv_monitor(struct hci_dev *hdev, u16 handle)
+{
+	struct adv_monitor *monitor;
+
+	if (handle) {
+		monitor = idr_find(&hdev->adv_monitors_idr, handle);
+		if (!monitor)
+			return -ENOENT;
+
+		idr_remove(&hdev->adv_monitors_idr, monitor->handle);
+		hci_free_adv_monitor(monitor);
+	} else {
+		/* Remove all monitors if handle is 0. */
+		idr_for_each(&hdev->adv_monitors_idr, &free_adv_monitor, hdev);
+	}
+
+	return 0;
+}
+
 struct bdaddr_list *hci_bdaddr_list_lookup(struct list_head *bdaddr_list,
 					 bdaddr_t *bdaddr, u8 type)
 {
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 9c1704ca6ad1e..710ec00219a0b 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -114,6 +114,7 @@ static const u16 mgmt_commands[] = {
 	MGMT_OP_SET_EXP_FEATURE,
 	MGMT_OP_READ_ADV_MONITOR_FEATURES,
 	MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
+	MGMT_OP_REMOVE_ADV_MONITOR,
 };
 
 static const u16 mgmt_events[] = {
@@ -3992,6 +3993,36 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 	return err;
 }
 
+static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
+			      void *data, u16 len)
+{
+	struct mgmt_cp_remove_adv_monitor *cp = data;
+	struct mgmt_rp_remove_adv_monitor rp;
+	int err;
+
+	BT_DBG("request for %s", hdev->name);
+
+	hci_dev_lock(hdev);
+
+	err = hci_remove_adv_monitor(hdev, cp->monitor_handle);
+	if (err == -ENOENT) {
+		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_REMOVE_ADV_MONITOR,
+				      MGMT_STATUS_INVALID_INDEX);
+		goto unlock;
+	}
+
+	hci_dev_unlock(hdev);
+
+	rp.monitor_handle = cp->monitor_handle;
+
+	return mgmt_cmd_complete(sk, hdev->id, MGMT_OP_REMOVE_ADV_MONITOR,
+				 MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
+
+unlock:
+	hci_dev_unlock(hdev);
+	return err;
+}
+
 static void read_local_oob_data_complete(struct hci_dev *hdev, u8 status,
 				         u16 opcode, struct sk_buff *skb)
 {
@@ -7443,6 +7474,7 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
 	{ read_adv_monitor_features, MGMT_READ_ADV_MONITOR_FEATURES_SIZE },
 	{ add_adv_patterns_monitor, MGMT_ADD_ADV_PATTERNS_MONITOR_SIZE,
 						HCI_MGMT_VAR_LEN },
+	{ remove_adv_monitor, MGMT_REMOVE_ADV_MONITOR_SIZE },
 };
 
 void mgmt_index_added(struct hci_dev *hdev)
-- 
2.26.2

