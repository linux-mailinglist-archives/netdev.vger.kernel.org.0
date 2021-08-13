Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD5E3EBA6F
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 18:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237630AbhHMQxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 12:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbhHMQwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 12:52:35 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA627C0613A4
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 09:52:02 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j12-20020a17090aeb0c00b00179530520b3so1066071pjz.0
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 09:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VbWIZSaDRks5peFgeRWXgC5w1M+90q0wouqN3W24tA0=;
        b=bsGVbNnA+OaF+lSMqubmyVmuDhqT3pfr9StJLZUwanlE9lOOeoYmAnPton3AM25ga7
         VSVRVR3O/Sm80+01Wdiyu24HNAqdyG2leBocX0/v7JOKiriyHvP3/VnsUNzjAGpDJlLV
         m8fI0USn3fvt7G81Kwk3HPS/feq0K1hb4JdUM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VbWIZSaDRks5peFgeRWXgC5w1M+90q0wouqN3W24tA0=;
        b=k9VGQdBLMtIKHkUDAfOvmHaQ88+IGLIlM0+eF1ReLX+DlUMOOQSGRkhC48PkAVC4Ap
         DNFtrW5QtKrbGPRD42kcaXBnN3SAw+JtQ9ZCnsBBHVeebVte86JM5BIIq0jYtIpPR0sH
         mkOGO+fVY7DLVMjmO2A4UwB9uuP6P2JCv6DGBJIWrep7bJJbidDFqwSTnT+EqZ1v4yAw
         6/8ospm7hCK1aDzal+WpC6GdrDi0gr308hIPJy5AMPN/QgxmEnawaCJXmfYtj3B8Npim
         QovPZe807LVLUEIG2u5WD16CwNt9ETCcuXtMt2shfeUtErE0u6jHDWo//jSqe/b12bk3
         f/sA==
X-Gm-Message-State: AOAM530q4iC3UOI+K6hnc5Ps2MwhwUsCgfdqcde8PQeL5vbLE50rXdOr
        OcFNyeapyf3Rv5+Z9lV4OImwvQ==
X-Google-Smtp-Source: ABdhPJzfJVqao6Y+ztTSg72K6fdjfwQh8SEXvffqMnWBXmwe6ORrHKaeqbIDAyRdG0JDYu48o62SAg==
X-Received: by 2002:a17:902:c404:b0:12d:9929:660 with SMTP id k4-20020a170902c40400b0012d99290660mr1891675plk.2.1628873522410;
        Fri, 13 Aug 2021 09:52:02 -0700 (PDT)
Received: from josephsih-z840.tpe.corp.google.com ([2401:fa00:1:10:755d:cdee:3203:71c5])
        by smtp.gmail.com with ESMTPSA id w3sm2907407pfn.96.2021.08.13.09.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 09:52:02 -0700 (PDT)
From:   Joseph Hwang <josephsih@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, pali@kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org, josephsih@google.com,
        Joseph Hwang <josephsih@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v8 4/5] Bluetooth: Support the quality report events
Date:   Sat, 14 Aug 2021 00:51:47 +0800
Message-Id: <20210814005024.v8.4.I20c79eef4f36c4a3802e1068e59ec4a9f4ded940@changeid>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
In-Reply-To: <20210814005024.v8.1.I41aec59e65ffd3226d368dabeb084af13cc133c8@changeid>
References: <20210814005024.v8.1.I41aec59e65ffd3226d368dabeb084af13cc133c8@changeid>
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

Changes in v8:
- Rebase on the previous patch about refactoring set_exp_feature with
  a feature table. A standalone set_quality_report_func is implemented
  instead of adding the logic into set_exp_feature.

Changes in v7:
- Rebase on Tedd's patches that moved functionality from btusb to
  btintel.

Changes in v5:
- Removed CONFIG_BT_FEATURE_QUALITY_REPORT since there was no
  large size impact.

 include/net/bluetooth/hci.h      |   1 +
 include/net/bluetooth/hci_core.h |   2 +
 net/bluetooth/mgmt.c             | 113 ++++++++++++++++++++++++++++++-
 3 files changed, 115 insertions(+), 1 deletion(-)

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
index a7d06d7da602..7e9ae36b2582 100644
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
index ffd526b2beab..f0d586515a65 100644
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
-	char buf[62];   /* Enough space for 3 features */
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
 #define EXP_FEAT(_uuid, _set_func)	\
 {					\
 	.uuid = _uuid,			\
@@ -4046,6 +4085,77 @@ static int set_rpa_resolution_func(struct sock *sk, struct hci_dev *hdev,
 	return err;
 }
 
+static int set_quality_report_func(struct sock *sk, struct hci_dev *hdev,
+				   struct mgmt_cp_set_exp_feature *cp,
+				   u16 data_len)
+{
+	struct mgmt_rp_set_exp_feature rp;
+	bool val, changed;
+	int err;
+
+	/* Command requires to use a valid controller index */
+	if (!hdev)
+		return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
+				       MGMT_OP_SET_EXP_FEATURE,
+				       MGMT_STATUS_INVALID_INDEX);
+
+	/* Parameters are limited to a single octet */
+	if (data_len != MGMT_SET_EXP_FEATURE_SIZE + 1)
+		return mgmt_cmd_status(sk, hdev->id,
+				       MGMT_OP_SET_EXP_FEATURE,
+				       MGMT_STATUS_INVALID_PARAMS);
+
+	/* Only boolean on/off is supported */
+	if (cp->param[0] != 0x00 && cp->param[0] != 0x01)
+		return mgmt_cmd_status(sk, hdev->id,
+				       MGMT_OP_SET_EXP_FEATURE,
+				       MGMT_STATUS_INVALID_PARAMS);
+
+	hci_req_sync_lock(hdev);
+
+	val = !!cp->param[0];
+	changed = (val != hci_dev_test_flag(hdev, HCI_QUALITY_REPORT));
+
+	if (!hdev->set_quality_report) {
+		BT_INFO("quality report not supported");
+		err = mgmt_cmd_status(sk, hdev->id,
+				      MGMT_OP_SET_EXP_FEATURE,
+				      MGMT_STATUS_NOT_SUPPORTED);
+		goto unlock_quality_report;
+	}
+
+	if (changed) {
+		err = hdev->set_quality_report(hdev, val);
+		if (err) {
+			BT_ERR("set_quality_report value %d err %d", val, err);
+			err = mgmt_cmd_status(sk, hdev->id,
+					      MGMT_OP_SET_EXP_FEATURE,
+					      MGMT_STATUS_FAILED);
+			goto unlock_quality_report;
+		}
+		if (val)
+			hci_dev_set_flag(hdev, HCI_QUALITY_REPORT);
+		else
+			hci_dev_clear_flag(hdev, HCI_QUALITY_REPORT);
+	}
+
+	BT_INFO("quality report enable %d changed %d", val, changed);
+
+	memcpy(rp.uuid, quality_report_uuid, 16);
+	rp.flags = cpu_to_le32(val ? BIT(0) : 0);
+	hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
+	err = mgmt_cmd_complete(sk, hdev->id,
+				MGMT_OP_SET_EXP_FEATURE, 0,
+				&rp, sizeof(rp));
+
+	if (changed)
+		exp_quality_report_feature_changed(val, sk);
+
+unlock_quality_report:
+	hci_req_sync_unlock(hdev);
+	return err;
+}
+
 static const struct mgmt_exp_feature {
 	const u8 *uuid;
 	int (*set_func)(struct sock *sk, struct hci_dev *hdev,
@@ -4056,6 +4166,7 @@ static const struct mgmt_exp_feature {
 	EXP_FEAT(debug_uuid, set_debug_func),
 #endif
 	EXP_FEAT(rpa_resolution_uuid, set_rpa_resolution_func),
+	EXP_FEAT(quality_report_uuid, set_quality_report_func),
 
 	/* end with a null feature */
 	EXP_FEAT(NULL, NULL)
-- 
2.33.0.rc1.237.g0d66db33f3-goog

