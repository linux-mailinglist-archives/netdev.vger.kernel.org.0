Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EC71F73CA
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 08:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgFLGQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 02:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbgFLGPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 02:15:41 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82144C08C5C2
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 23:15:40 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b16so3806375pfi.13
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 23:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GcYnF28Nh+G7TMQSM+vD1g8u4nToFPTTwQBlG/R1xTw=;
        b=OOTsdJgDttFqJbNjaW4FdofySZX5FYqqyOgySBhEzkmTpeCQL+50Rn5pbh5GtqvaR1
         oEmQTndNDfNECPjGOsEYE9d5hPzOj7P0rf0Fu4SfHwiimIPvdXmrRStCJEEl7Qn1PMBU
         5UBD9rACsQ54a32BooykTX1MHPs/FOfk/eBhs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GcYnF28Nh+G7TMQSM+vD1g8u4nToFPTTwQBlG/R1xTw=;
        b=Qz39jSapZwRBcckQBRTQ/d3Ip3F4USKzAd+/ypweerF3q/YAwW8cEJc8beABMHHTI9
         k89RZvjd49joAt3SgzoESIDQJcic4k5PA62JBdCHUWC/sRZg8QKrx69gzxTTQcaSJLlZ
         lq3o+C5K+NroBbFxqpqjcc2aJPN3Eeod9WVuEY5+ZcP0vO/7KlHzh1k8pTVa9y2rbnzS
         +hUkH0iS5r5ZK+2ymsyxujq4dCWn3CJtkGTJkvcUKARSIHevFPoqyzuVhWU8j50zPaKl
         uJID9knbu4Otu0rjWt+M7zeCBOLF3MS3kvHOf2XsJoV8TGdcFzgNpVcRdGa6sMOJ/qZ2
         DcYA==
X-Gm-Message-State: AOAM531nEc3Yjeu5NDij15HK2ounpMEroAxvwbmRQhNqQBrsZ8FpVZRK
        +Ai7U4oGImO+am1sIopP+FslBQ==
X-Google-Smtp-Source: ABdhPJx4ZjK3AbSPOq/x+zbnpGy/e3onOgL/7KdbCTG7ErVe775hdm30OUPGHkA1awwfm6FuuEib0Q==
X-Received: by 2002:a63:8c5a:: with SMTP id q26mr5513149pgn.312.1591942540065;
        Thu, 11 Jun 2020 23:15:40 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id g6sm4933923pfb.164.2020.06.11.23.15.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jun 2020 23:15:39 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Alain Michaud <alainm@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Yoni Shavit <yshavit@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 3/7] Bluetooth: Add handler of MGMT_OP_ADD_ADV_PATTERNS_MONITOR
Date:   Thu, 11 Jun 2020 23:15:25 -0700
Message-Id: <20200611231459.v3.3.Iea5d308a1936ac26177316c977977cdf7de42de8@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611231459.v3.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
References: <20200611231459.v3.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the request handler of MGMT_OP_ADD_ADV_PATTERNS_MONITOR command.
Note that the controller-based monitoring is not yet in place. This tracks
the content of the monitor without sending HCI traffic, so the request
returns immediately.

The following manual test was performed.
- Issue btmgmt advmon-add with valid and invalid inputs.
- Issue btmgmt advmon-add more the allowed number of monitors.

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
---

Changes in v3:
- Update the opcode in the mgmt table.
- Convert the endianness of the returned handle.

Changes in v2: None

 include/net/bluetooth/hci_core.h |   2 +
 net/bluetooth/hci_core.c         |  40 +++++++++++++
 net/bluetooth/mgmt.c             | 100 +++++++++++++++++++++++++++++++
 3 files changed, 142 insertions(+)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 431fe0265dcfb..862d94f711bc0 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1240,6 +1240,8 @@ int hci_remove_adv_instance(struct hci_dev *hdev, u8 instance);
 void hci_adv_instances_set_rpa_expired(struct hci_dev *hdev, bool rpa_expired);
 
 void hci_adv_monitors_clear(struct hci_dev *hdev);
+void hci_free_adv_monitor(struct adv_monitor *monitor);
+int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor);
 
 void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb);
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index bfcf00e4dfa92..fdbb58eb2fb22 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2998,9 +2998,49 @@ int hci_add_adv_instance(struct hci_dev *hdev, u8 instance, u32 flags,
 /* This function requires the caller holds hdev->lock */
 void hci_adv_monitors_clear(struct hci_dev *hdev)
 {
+	struct adv_monitor *monitor;
+	int handle;
+
+	idr_for_each_entry(&hdev->adv_monitors_idr, monitor, handle)
+		hci_free_adv_monitor(monitor);
+
 	idr_destroy(&hdev->adv_monitors_idr);
 }
 
+void hci_free_adv_monitor(struct adv_monitor *monitor)
+{
+	struct adv_pattern *pattern;
+	struct adv_pattern *tmp;
+
+	if (!monitor)
+		return;
+
+	list_for_each_entry_safe(pattern, tmp, &monitor->patterns, list)
+		kfree(pattern);
+
+	kfree(monitor);
+}
+
+/* This function requires the caller holds hdev->lock */
+int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor)
+{
+	int min, max, handle;
+
+	if (!monitor)
+		return -EINVAL;
+
+	min = HCI_MIN_ADV_MONITOR_HANDLE;
+	max = HCI_MIN_ADV_MONITOR_HANDLE + HCI_MAX_ADV_MONITOR_NUM_HANDLES;
+	handle = idr_alloc(&hdev->adv_monitors_idr, monitor, min, max,
+			   GFP_KERNEL);
+	if (handle < 0)
+		return handle;
+
+	hdev->adv_monitors_cnt++;
+	monitor->handle = handle;
+	return 0;
+}
+
 struct bdaddr_list *hci_bdaddr_list_lookup(struct list_head *bdaddr_list,
 					 bdaddr_t *bdaddr, u8 type)
 {
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 63536d6332d45..8e0d4ccf81f15 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -113,6 +113,7 @@ static const u16 mgmt_commands[] = {
 	MGMT_OP_READ_EXP_FEATURES_INFO,
 	MGMT_OP_SET_EXP_FEATURE,
 	MGMT_OP_READ_ADV_MONITOR_FEATURES,
+	MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
 };
 
 static const u16 mgmt_events[] = {
@@ -3896,6 +3897,103 @@ static int read_adv_monitor_features(struct sock *sk, struct hci_dev *hdev,
 				 MGMT_STATUS_SUCCESS, rp, rp_size);
 }
 
+static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
+				    void *data, u16 len)
+{
+	struct mgmt_cp_add_adv_patterns_monitor *cp = data;
+	struct mgmt_rp_add_adv_patterns_monitor rp;
+	struct adv_monitor *m = NULL;
+	struct adv_pattern *p = NULL;
+	__u8 cp_ofst = 0, cp_len = 0;
+	unsigned int mp_cnt = 0;
+	int err, i;
+
+	BT_DBG("request for %s", hdev->name);
+
+	if (len <= sizeof(*cp) || cp->pattern_count == 0) {
+		err = mgmt_cmd_status(sk, hdev->id,
+				      MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
+				      MGMT_STATUS_INVALID_PARAMS);
+		goto failed;
+	}
+
+	m = kmalloc(sizeof(*m), GFP_KERNEL);
+	if (!m) {
+		err = -ENOMEM;
+		goto failed;
+	}
+
+	INIT_LIST_HEAD(&m->patterns);
+	m->active = false;
+
+	for (i = 0; i < cp->pattern_count; i++) {
+		if (++mp_cnt > HCI_MAX_ADV_MONITOR_NUM_PATTERNS) {
+			err = mgmt_cmd_status(sk, hdev->id,
+					      MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
+					      MGMT_STATUS_INVALID_PARAMS);
+			goto failed;
+		}
+
+		cp_ofst = cp->patterns[i].offset;
+		cp_len = cp->patterns[i].length;
+		if (cp_ofst >= HCI_MAX_AD_LENGTH ||
+		    cp_len > HCI_MAX_AD_LENGTH ||
+		    (cp_ofst + cp_len) > HCI_MAX_AD_LENGTH) {
+			err = mgmt_cmd_status(sk, hdev->id,
+					      MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
+					      MGMT_STATUS_INVALID_PARAMS);
+			goto failed;
+		}
+
+		p = kmalloc(sizeof(*p), GFP_KERNEL);
+		if (!p) {
+			err = -ENOMEM;
+			goto failed;
+		}
+
+		p->ad_type = cp->patterns[i].ad_type;
+		p->offset = cp->patterns[i].offset;
+		p->length = cp->patterns[i].length;
+		memcpy(p->value, cp->patterns[i].value, p->length);
+
+		INIT_LIST_HEAD(&p->list);
+		list_add(&p->list, &m->patterns);
+	}
+
+	if (mp_cnt != cp->pattern_count) {
+		err = mgmt_cmd_status(sk, hdev->id,
+				      MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
+				      MGMT_STATUS_INVALID_PARAMS);
+		goto failed;
+	}
+
+	hci_dev_lock(hdev);
+
+	err = hci_add_adv_monitor(hdev, m);
+	if (err) {
+		if (err == -ENOSPC) {
+			mgmt_cmd_status(sk, hdev->id,
+					MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
+					MGMT_STATUS_NO_RESOURCES);
+		}
+		goto unlock;
+	}
+
+	hci_dev_unlock(hdev);
+
+	rp.monitor_handle = cpu_to_le16(m->handle);
+
+	return mgmt_cmd_complete(sk, hdev->id, MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
+				 MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
+
+unlock:
+	hci_dev_unlock(hdev);
+
+failed:
+	hci_free_adv_monitor(m);
+	return err;
+}
+
 static void read_local_oob_data_complete(struct hci_dev *hdev, u8 status,
 				         u16 opcode, struct sk_buff *skb)
 {
@@ -7351,6 +7449,8 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
 	{ NULL }, // 0x004F
 	{ NULL }, // 0x0050
 	{ read_adv_monitor_features, MGMT_READ_ADV_MONITOR_FEATURES_SIZE },
+	{ add_adv_patterns_monitor, MGMT_ADD_ADV_PATTERNS_MONITOR_SIZE,
+						HCI_MGMT_VAR_LEN },
 };
 
 void mgmt_index_added(struct hci_dev *hdev)
-- 
2.26.2

