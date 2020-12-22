Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241982E0862
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 10:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgLVJ6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 04:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgLVJ57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 04:57:59 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073AEC0617A6
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 01:57:19 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id w17so7665276ybl.15
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 01:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=2uQ8ZwEZ9IIIBe10xutVerelIZoMi/eRg4KSvrVllNs=;
        b=VrzDNNk6POTV1bEy+udyuR2VT+6FZ8x3RV1gUXhLKsDbZxjuUNxoSNzxrlmVKxDjDt
         l+UnjWb+kgIw6qyyCMxg8BYgkgH8LZVk4lz9iWiCaa0f+34diJCBviTD9JBDjlnh6XIQ
         5wlRMwPRkmwZsMAGWk7pgecVsD6m38lWESTxHSGidvBuQbEF9nKRYsgowWDTRuVEUDQ+
         PJrjw9RyEIkIBTnE7wuFfUhX6Oa2qVf7CL65qZrWYjgbU8yrygUVuvY0SMus8581u00s
         jL2+fVDbo78ZjdqWlXFOTvMwAyR8ObdAOU7wB/aKmdjd4QNMA0jEf/Iy1lnRbe/8U9I+
         PvKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2uQ8ZwEZ9IIIBe10xutVerelIZoMi/eRg4KSvrVllNs=;
        b=k+X2e0/5gMSlmS4g2QcE8uTyAX930VuCT8ZUu+jc9rjOMlHSN/kRZHyjarTpBSMQJu
         kXpR8qzSf+VQVphZbx/DaOeq8c0ukkfqaqzrGaaDkZcGdVGAMPiqbwjNAaaUxhvJuzto
         mSFy6RE59REPcNcxSwhQ0UOH6DKK7MczNCxRGlmn7Wli+cPPUt3+KPf7PAJXStziv2hy
         3pvfNUXIE2rdGFSI5vQSNJekptb/3SRQGssxWc6SgE2B1o1VPIRRMy1pAmQsP9vToErI
         7/SIgsBn/vVhtra1rnrUdvkS/NvL54WPz1y+PybVe8dUSACnNn2bDzYdH/C3OBHX3inE
         1OTw==
X-Gm-Message-State: AOAM530BVzRDjwnXYW6jgPVpn1Mg7VsMt+xIXPa72kVGDr1PrlQphiuj
        HTeSv1zlmgoFB5fzF/3wNJRd39Idj08Z
X-Google-Smtp-Source: ABdhPJyi+DaILSdY9zJNYg78P6KYmuGf2sH7UCSSLQSTB0KVDEWB0ViNQsNNmHzUFWD2FhfnrYIXBntDb+nx
Sender: "apusaka via sendgmr" <apusaka@apusaka-p920.tpe.corp.google.com>
X-Received: from apusaka-p920.tpe.corp.google.com ([172.30.210.44])
 (user=apusaka job=sendgmr) by 2002:a25:3b97:: with SMTP id
 i145mr2594638yba.171.1608631038226; Tue, 22 Dec 2020 01:57:18 -0800 (PST)
Date:   Tue, 22 Dec 2020 17:57:02 +0800
In-Reply-To: <20201222095706.948827-1-apusaka@google.com>
Message-Id: <20201222175659.v4.1.I92d2e2a87419730d60136680cbe27636baf94b15@changeid>
Mime-Version: 1.0
References: <20201222095706.948827-1-apusaka@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH v4 1/5] Bluetooth: advmon offload MSFT add rssi support
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Yun-Hao Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

MSFT needs rssi parameter for monitoring advertisement packet,
therefore we should supply them from mgmt. This adds a new opcode
to add advertisement monitor with rssi parameters.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Reviewed-by: Yun-Hao Chung <howardchung@google.com>

---

Changes in v4:
* Change the logic of merging add_adv_patterns_monitor with rssi
* Aligning variable declaration on mgmt.h

Changes in v3:
* Flips the order of rssi and pattern_count on mgmt struct

Changes in v2:
* Add a new opcode instead of modifying an existing one

 include/net/bluetooth/hci_core.h |   9 ++
 include/net/bluetooth/mgmt.h     |  16 +++
 net/bluetooth/mgmt.c             | 225 +++++++++++++++++++++----------
 3 files changed, 178 insertions(+), 72 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 677a8c50b2ad..8b7cf3620938 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -250,8 +250,17 @@ struct adv_pattern {
 	__u8 value[HCI_MAX_AD_LENGTH];
 };
 
+struct adv_rssi_thresholds {
+	__s8 low_threshold;
+	__s8 high_threshold;
+	__u16 low_threshold_timeout;
+	__u16 high_threshold_timeout;
+	__u8 sampling_period;
+};
+
 struct adv_monitor {
 	struct list_head patterns;
+	struct adv_rssi_thresholds rssi;
 	bool		active;
 	__u16		handle;
 };
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index f9a6638e20b3..839a2028009e 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -821,6 +821,22 @@ struct mgmt_rp_add_ext_adv_data {
 	__u8	instance;
 } __packed;
 
+struct mgmt_adv_rssi_thresholds {
+	__s8	high_threshold;
+	__le16	high_threshold_timeout;
+	__s8	low_threshold;
+	__le16	low_threshold_timeout;
+	__u8	sampling_period;
+} __packed;
+
+#define MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI	0x0056
+struct mgmt_cp_add_adv_patterns_monitor_rssi {
+	struct mgmt_adv_rssi_thresholds rssi;
+	__u8	pattern_count;
+	struct mgmt_adv_pattern patterns[];
+} __packed;
+#define MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZE	8
+
 #define MGMT_EV_CMD_COMPLETE		0x0001
 struct mgmt_ev_cmd_complete {
 	__le16	opcode;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 608dda5403b7..72d37c80e071 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -124,6 +124,7 @@ static const u16 mgmt_commands[] = {
 	MGMT_OP_REMOVE_ADV_MONITOR,
 	MGMT_OP_ADD_EXT_ADV_PARAMS,
 	MGMT_OP_ADD_EXT_ADV_DATA,
+	MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI,
 };
 
 static const u16 mgmt_events[] = {
@@ -4225,75 +4226,15 @@ static int read_adv_mon_features(struct sock *sk, struct hci_dev *hdev,
 	return err;
 }
 
-static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
-				    void *data, u16 len)
+static int __add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
+				      struct adv_monitor *m, u8 status, u16 op)
 {
-	struct mgmt_cp_add_adv_patterns_monitor *cp = data;
 	struct mgmt_rp_add_adv_patterns_monitor rp;
-	struct adv_monitor *m = NULL;
-	struct adv_pattern *p = NULL;
-	unsigned int mp_cnt = 0, prev_adv_monitors_cnt;
-	__u8 cp_ofst = 0, cp_len = 0;
-	int err, i;
-
-	BT_DBG("request for %s", hdev->name);
-
-	if (len <= sizeof(*cp) || cp->pattern_count == 0) {
-		err = mgmt_cmd_status(sk, hdev->id,
-				      MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
-				      MGMT_STATUS_INVALID_PARAMS);
-		goto failed;
-	}
-
-	m = kmalloc(sizeof(*m), GFP_KERNEL);
-	if (!m) {
-		err = -ENOMEM;
-		goto failed;
-	}
-
-	INIT_LIST_HEAD(&m->patterns);
-	m->active = false;
-
-	for (i = 0; i < cp->pattern_count; i++) {
-		if (++mp_cnt > HCI_MAX_ADV_MONITOR_NUM_PATTERNS) {
-			err = mgmt_cmd_status(sk, hdev->id,
-					      MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
-					      MGMT_STATUS_INVALID_PARAMS);
-			goto failed;
-		}
-
-		cp_ofst = cp->patterns[i].offset;
-		cp_len = cp->patterns[i].length;
-		if (cp_ofst >= HCI_MAX_AD_LENGTH ||
-		    cp_len > HCI_MAX_AD_LENGTH ||
-		    (cp_ofst + cp_len) > HCI_MAX_AD_LENGTH) {
-			err = mgmt_cmd_status(sk, hdev->id,
-					      MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
-					      MGMT_STATUS_INVALID_PARAMS);
-			goto failed;
-		}
-
-		p = kmalloc(sizeof(*p), GFP_KERNEL);
-		if (!p) {
-			err = -ENOMEM;
-			goto failed;
-		}
-
-		p->ad_type = cp->patterns[i].ad_type;
-		p->offset = cp->patterns[i].offset;
-		p->length = cp->patterns[i].length;
-		memcpy(p->value, cp->patterns[i].value, p->length);
-
-		INIT_LIST_HEAD(&p->list);
-		list_add(&p->list, &m->patterns);
-	}
+	unsigned int prev_adv_monitors_cnt;
+	int err;
 
-	if (mp_cnt != cp->pattern_count) {
-		err = mgmt_cmd_status(sk, hdev->id,
-				      MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
-				      MGMT_STATUS_INVALID_PARAMS);
+	if (status)
 		goto failed;
-	}
 
 	hci_dev_lock(hdev);
 
@@ -4301,11 +4242,11 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 
 	err = hci_add_adv_monitor(hdev, m);
 	if (err) {
-		if (err == -ENOSPC) {
-			mgmt_cmd_status(sk, hdev->id,
-					MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
-					MGMT_STATUS_NO_RESOURCES);
-		}
+		if (err == -ENOSPC)
+			status = MGMT_STATUS_NO_RESOURCES;
+		else
+			status = MGMT_STATUS_FAILED;
+
 		goto unlock;
 	}
 
@@ -4316,7 +4257,7 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 
 	rp.monitor_handle = cpu_to_le16(m->handle);
 
-	return mgmt_cmd_complete(sk, hdev->id, MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
+	return mgmt_cmd_complete(sk, hdev->id, op,
 				 MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
 
 unlock:
@@ -4324,7 +4265,144 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 
 failed:
 	hci_free_adv_monitor(m);
-	return err;
+	return mgmt_cmd_status(sk, hdev->id, op, status);
+}
+
+static void parse_adv_monitor_rssi(struct adv_monitor *m,
+				   struct mgmt_adv_rssi_thresholds *rssi)
+{
+	if (rssi) {
+		m->rssi.low_threshold = rssi->low_threshold;
+		m->rssi.low_threshold_timeout =
+		    __le16_to_cpu(rssi->low_threshold_timeout);
+		m->rssi.high_threshold = rssi->high_threshold;
+		m->rssi.high_threshold_timeout =
+		    __le16_to_cpu(rssi->high_threshold_timeout);
+		m->rssi.sampling_period = rssi->sampling_period;
+	} else {
+		/* Default values. These numbers are the least constricting
+		 * parameters for MSFT API to work, so it behaves as if there
+		 * are no rssi parameter to consider. May need to be changed
+		 * if other API are to be supported.
+		 */
+		m->rssi.low_threshold = -127;
+		m->rssi.low_threshold_timeout = 60;
+		m->rssi.high_threshold = -127;
+		m->rssi.high_threshold_timeout = 0;
+		m->rssi.sampling_period = 0;
+	}
+}
+
+static u8 parse_adv_monitor_pattern(struct adv_monitor *m, u8 pattern_count,
+				    struct mgmt_adv_pattern *patterns)
+{
+	u8 offset = 0, length = 0;
+	struct adv_pattern *p = NULL;
+	unsigned int mp_cnt = 0;
+	int i;
+
+	for (i = 0; i < pattern_count; i++) {
+		if (++mp_cnt > HCI_MAX_ADV_MONITOR_NUM_PATTERNS)
+			return MGMT_STATUS_INVALID_PARAMS;
+
+		offset = patterns[i].offset;
+		length = patterns[i].length;
+		if (offset >= HCI_MAX_AD_LENGTH ||
+		    length > HCI_MAX_AD_LENGTH ||
+		    (offset + length) > HCI_MAX_AD_LENGTH)
+			return MGMT_STATUS_INVALID_PARAMS;
+
+		p = kmalloc(sizeof(*p), GFP_KERNEL);
+		if (!p)
+			return MGMT_STATUS_NO_RESOURCES;
+
+		p->ad_type = patterns[i].ad_type;
+		p->offset = patterns[i].offset;
+		p->length = patterns[i].length;
+		memcpy(p->value, patterns[i].value, p->length);
+
+		INIT_LIST_HEAD(&p->list);
+		list_add(&p->list, &m->patterns);
+	}
+
+	if (mp_cnt != pattern_count)
+		return MGMT_STATUS_INVALID_PARAMS;
+
+	return MGMT_STATUS_SUCCESS;
+}
+
+static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
+				    void *data, u16 len)
+{
+	struct mgmt_cp_add_adv_patterns_monitor *cp = data;
+	struct adv_monitor *m = NULL;
+	u8 status = MGMT_STATUS_SUCCESS;
+	size_t expected_size = sizeof(*cp);
+
+	BT_DBG("request for %s", hdev->name);
+
+	if (len <= sizeof(*cp)) {
+		status = MGMT_STATUS_INVALID_PARAMS;
+		goto done;
+	}
+
+	expected_size += cp->pattern_count * sizeof(struct mgmt_adv_pattern);
+	if (len != expected_size) {
+		status = MGMT_STATUS_INVALID_PARAMS;
+		goto done;
+	}
+
+	m = kzalloc(sizeof(*m), GFP_KERNEL);
+	if (!m) {
+		status = MGMT_STATUS_NO_RESOURCES;
+		goto done;
+	}
+
+	INIT_LIST_HEAD(&m->patterns);
+
+	parse_adv_monitor_rssi(m, NULL);
+	status = parse_adv_monitor_pattern(m, cp->pattern_count, cp->patterns);
+
+done:
+	return __add_adv_patterns_monitor(sk, hdev, m, status,
+					  MGMT_OP_ADD_ADV_PATTERNS_MONITOR);
+}
+
+static int add_adv_patterns_monitor_rssi(struct sock *sk, struct hci_dev *hdev,
+					 void *data, u16 len)
+{
+	struct mgmt_cp_add_adv_patterns_monitor_rssi *cp = data;
+	struct adv_monitor *m = NULL;
+	u8 status = MGMT_STATUS_SUCCESS;
+	size_t expected_size = sizeof(*cp);
+
+	BT_DBG("request for %s", hdev->name);
+
+	if (len <= sizeof(*cp)) {
+		status = MGMT_STATUS_INVALID_PARAMS;
+		goto done;
+	}
+
+	expected_size += cp->pattern_count * sizeof(struct mgmt_adv_pattern);
+	if (len != expected_size) {
+		status = MGMT_STATUS_INVALID_PARAMS;
+		goto done;
+	}
+
+	m = kzalloc(sizeof(*m), GFP_KERNEL);
+	if (!m) {
+		status = MGMT_STATUS_NO_RESOURCES;
+		goto done;
+	}
+
+	INIT_LIST_HEAD(&m->patterns);
+
+	parse_adv_monitor_rssi(m, &cp->rssi);
+	status = parse_adv_monitor_pattern(m, cp->pattern_count, cp->patterns);
+
+done:
+	return __add_adv_patterns_monitor(sk, hdev, m, status,
+					 MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI);
 }
 
 static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
@@ -8242,6 +8320,9 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
 						HCI_MGMT_VAR_LEN },
 	{ add_ext_adv_data,        MGMT_ADD_EXT_ADV_DATA_SIZE,
 						HCI_MGMT_VAR_LEN },
+	{ add_adv_patterns_monitor_rssi,
+				   MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZE,
+						HCI_MGMT_VAR_LEN },
 };
 
 void mgmt_index_added(struct hci_dev *hdev)
-- 
2.29.2.729.g45daf8777d-goog

