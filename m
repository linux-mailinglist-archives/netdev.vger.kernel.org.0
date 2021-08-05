Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CCB3E11DC
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 12:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240198AbhHEKDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 06:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240167AbhHEKD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 06:03:28 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F5AC0613C1
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 03:03:14 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j1so7450053pjv.3
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 03:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QiplJwogzcwvFJyM5faPv6LJ8Whp/Ld0B9s7fXpzmGU=;
        b=KztMMomiTnd43oEYOJB3LUsNplhsRTGmxIAP/Jon8ArOMfWYpsYrseSK6MBVDlimqM
         thWNslrFrRuAcry/B5bgnyPhVAOrsM886vwHUB3+Ry0JwKqY7ScV6R0iaO/79OgqROLR
         09kVodRL7YB4outoNrFch9ngQJY9W7ily1ZRY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QiplJwogzcwvFJyM5faPv6LJ8Whp/Ld0B9s7fXpzmGU=;
        b=QSdWJHe24uV1DNPRVS71TD+UjQ8oUBXwkgtuTovajcbNrc0XH6sbvO4DXUkSDw4zXo
         9JqC5ii31mYey9lwmdrualYBLGjkGFjnKPR2Dz1FLEkvY3xQH7P0A6ZbH+k0duM0ucXF
         WSuEhLvxvYVsikfDWJIRI+YxhRNdJo0CHe31HpBO/V8NzAVihDuBElQNeQibBOJjz9jd
         0gChoz7EgVYIcponwb8RuIHtpik08YEm603WDgRFql19PJDUTAWZ5NY4wEBmw/BsdjJ4
         /D9DTgzPSZS5hm8a7CkfOj+8DnMM29fMKp/fAcXyrx1YN5dMxWjljnYhFplF4T5MxTL3
         wwrg==
X-Gm-Message-State: AOAM5339BgjSMnZbfhg0X5nwbb0lrTTPQxaj9okr5v+Vi/BBu9VdPPsz
        jKOFrMpiBZjhYdYkprE4lxynDhPWVS/z8w==
X-Google-Smtp-Source: ABdhPJz09WbceglhzDNvWAhVZ+5Q8fpootcqRd05euiWtBHfBniGit898zkXFvxc0PPJoo6WQqVzzg==
X-Received: by 2002:a05:6a00:884:b029:346:8678:ce15 with SMTP id q4-20020a056a000884b02903468678ce15mr4371771pfj.75.1628157794036;
        Thu, 05 Aug 2021 03:03:14 -0700 (PDT)
Received: from josephsih-z840.tpe.corp.google.com ([2401:fa00:1:10:2c18:41ac:c6a8:ddfe])
        by smtp.gmail.com with ESMTPSA id jz24sm5436194pjb.9.2021.08.05.03.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 03:03:13 -0700 (PDT)
From:   Joseph Hwang <josephsih@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, pali@kernel.org
Cc:     josephsih@google.com, chromeos-bluetooth-upstreaming@chromium.org,
        Joseph Hwang <josephsih@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v6 4/4] Bluetooth: Support the quality report events
Date:   Thu,  5 Aug 2021 18:03:00 +0800
Message-Id: <20210805180227.v6.4.I20c79eef4f36c4a3802e1068e59ec4a9f4ded940@changeid>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
In-Reply-To: <20210805180227.v6.1.I41aec59e65ffd3226d368dabeb084af13cc133c8@changeid>
References: <20210805180227.v6.1.I41aec59e65ffd3226d368dabeb084af13cc133c8@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows a user space process to enable/disable the quality
report events dynamically through the set experimental feature mgmt
interface if CONFIG_BT_FEATURE_QUALITY_REPORT is enabled.

Since the quality report feature needs to invoke the callback function
provided by the driver, i.e., hdev->set_quality_report, a valid
controller index is required.

Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Signed-off-by: Joseph Hwang <josephsih@chromium.org>
---

(no changes since v5)

Changes in v5:
- Removed CONFIG_BT_FEATURE_QUALITY_REPORT since there was no
  large size impact.

 include/net/bluetooth/hci.h      |   1 +
 include/net/bluetooth/hci_core.h |   2 +
 net/bluetooth/mgmt.c             | 110 ++++++++++++++++++++++++++++++-
 3 files changed, 112 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index b80415011dcd..bb6b7398f490 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -330,6 +330,7 @@ enum {
 	HCI_ENABLE_LL_PRIVACY,
 	HCI_CMD_PENDING,
 	HCI_FORCE_NO_MITM,
+	HCI_QUALITY_REPORT,
 
 	__HCI_NUM_FLAGS,
 };
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index b011eeea28c3..ff6cbbfd9ab3 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -606,6 +606,7 @@ struct hci_dev {
 	int (*set_bdaddr)(struct hci_dev *hdev, const bdaddr_t *bdaddr);
 	void (*cmd_timeout)(struct hci_dev *hdev);
 	bool (*prevent_wake)(struct hci_dev *hdev);
+	int (*set_quality_report)(struct hci_dev *hdev, bool enable);
 };
 
 #define HCI_PHY_HANDLE(handle)	(handle & 0xff)
@@ -759,6 +760,7 @@ extern struct mutex hci_cb_list_lock;
 		hci_dev_clear_flag(hdev, HCI_LE_ADV);		\
 		hci_dev_clear_flag(hdev, HCI_LL_RPA_RESOLUTION);\
 		hci_dev_clear_flag(hdev, HCI_PERIODIC_INQ);	\
+		hci_dev_clear_flag(hdev, HCI_QUALITY_REPORT);	\
 	} while (0)
 
 /* ----- HCI interface to upper protocols ----- */
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 1e21e014efd2..358250862720 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3791,6 +3791,12 @@ static const u8 debug_uuid[16] = {
 };
 #endif
 
+/* 330859bc-7506-492d-9370-9a6f0614037f */
+static const u8 quality_report_uuid[16] = {
+	0x7f, 0x03, 0x14, 0x06, 0x6f, 0x9a, 0x70, 0x93,
+	0x2d, 0x49, 0x06, 0x75, 0xbc, 0x59, 0x08, 0x33,
+};
+
 /* 671b10b5-42c0-4696-9227-eb28d1b049d6 */
 static const u8 simult_central_periph_uuid[16] = {
 	0xd6, 0x49, 0xb0, 0xd1, 0x28, 0xeb, 0x27, 0x92,
@@ -3806,7 +3812,7 @@ static const u8 rpa_resolution_uuid[16] = {
 static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
 				  void *data, u16 data_len)
 {
-	char buf[62];	/* Enough space for 3 features */
+	char buf[82];   /* Enough space for 4 features: 2 + 20 * 4 */
 	struct mgmt_rp_read_exp_features_info *rp = (void *)buf;
 	u16 idx = 0;
 	u32 flags;
@@ -3850,6 +3856,24 @@ static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
 		idx++;
 	}
 
+	if (hdev) {
+		if (hdev->set_quality_report) {
+			/* BIT(0): indicating if set_quality_report is
+			 * supported by controller.
+			 */
+			flags = BIT(0);
+
+			/* BIT(1): indicating if the feature is enabled. */
+			if (hci_dev_test_flag(hdev, HCI_QUALITY_REPORT))
+				flags |= BIT(1);
+		} else {
+			flags = 0;
+		}
+		memcpy(rp->features[idx].uuid, quality_report_uuid, 16);
+		rp->features[idx].flags = cpu_to_le32(flags);
+		idx++;
+	}
+
 	rp->feature_count = cpu_to_le16(idx);
 
 	/* After reading the experimental features information, enable
@@ -3892,6 +3916,21 @@ static int exp_debug_feature_changed(bool enabled, struct sock *skip)
 }
 #endif
 
+static int exp_quality_report_feature_changed(bool enabled, struct sock *skip)
+{
+	struct mgmt_ev_exp_feature_changed ev;
+
+	BT_INFO("enabled %d", enabled);
+
+	memset(&ev, 0, sizeof(ev));
+	memcpy(ev.uuid, quality_report_uuid, 16);
+	ev.flags = cpu_to_le32(enabled ? BIT(0) : 0);
+
+	return mgmt_limited_event(MGMT_EV_EXP_FEATURE_CHANGED, NULL,
+				  &ev, sizeof(ev),
+				  HCI_MGMT_EXP_FEATURE_EVENTS, skip);
+}
+
 static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
 			   void *data, u16 data_len)
 {
@@ -4038,6 +4077,75 @@ static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
 		return err;
 	}
 
+	if (!memcmp(cp->uuid, quality_report_uuid, 16)) {
+		bool val, changed;
+		int err;
+
+		/* Command requires to use a valid controller index */
+		if (!hdev)
+			return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
+					       MGMT_OP_SET_EXP_FEATURE,
+					       MGMT_STATUS_INVALID_INDEX);
+
+		/* Parameters are limited to a single octet */
+		if (data_len != MGMT_SET_EXP_FEATURE_SIZE + 1)
+			return mgmt_cmd_status(sk, hdev->id,
+					       MGMT_OP_SET_EXP_FEATURE,
+					       MGMT_STATUS_INVALID_PARAMS);
+
+		/* Only boolean on/off is supported */
+		if (cp->param[0] != 0x00 && cp->param[0] != 0x01)
+			return mgmt_cmd_status(sk, hdev->id,
+					       MGMT_OP_SET_EXP_FEATURE,
+					       MGMT_STATUS_INVALID_PARAMS);
+
+		hci_req_sync_lock(hdev);
+
+		val = !!cp->param[0];
+		changed = (val != hci_dev_test_flag(hdev, HCI_QUALITY_REPORT));
+
+		if (!hdev->set_quality_report) {
+			BT_INFO("quality report not supported");
+			err = mgmt_cmd_status(sk, hdev->id,
+					      MGMT_OP_SET_EXP_FEATURE,
+					      MGMT_STATUS_NOT_SUPPORTED);
+			goto unlock_quality_report;
+		}
+
+		if (changed) {
+			err = hdev->set_quality_report(hdev, val);
+			if (err) {
+				BT_ERR("set_quality_report value %d err %d",
+				       val, err);
+				err = mgmt_cmd_status(sk, hdev->id,
+						      MGMT_OP_SET_EXP_FEATURE,
+						      MGMT_STATUS_FAILED);
+				goto unlock_quality_report;
+			}
+			if (val)
+				hci_dev_set_flag(hdev, HCI_QUALITY_REPORT);
+			else
+				hci_dev_clear_flag(hdev, HCI_QUALITY_REPORT);
+		}
+
+		BT_INFO("quality report enable %d changed %d",
+			val, changed);
+
+		memcpy(rp.uuid, quality_report_uuid, 16);
+		rp.flags = cpu_to_le32(val ? BIT(0) : 0);
+		hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
+		err = mgmt_cmd_complete(sk, hdev->id,
+					MGMT_OP_SET_EXP_FEATURE, 0,
+					&rp, sizeof(rp));
+
+		if (changed)
+			exp_quality_report_feature_changed(val, sk);
+
+unlock_quality_report:
+		hci_req_sync_unlock(hdev);
+		return err;
+	}
+
 	return mgmt_cmd_status(sk, hdev ? hdev->id : MGMT_INDEX_NONE,
 			       MGMT_OP_SET_EXP_FEATURE,
 			       MGMT_STATUS_NOT_SUPPORTED);
-- 
2.32.0.554.ge1b32706d8-goog

