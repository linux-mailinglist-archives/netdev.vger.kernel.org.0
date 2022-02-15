Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF82C4B6D9F
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 14:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238344AbiBONgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 08:36:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238331AbiBONgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 08:36:03 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266B41074D0
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 05:35:50 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id e17so15391974pfv.5
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 05:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i2L/2d/WummzhFYZmp1J8UiAMxM3AINvBVUjQlggREQ=;
        b=kj8IUBBuHK/FjcZjTmdoH2RE+Bpk8jfs7BUNHvhM5Wc8eI/UqpyAQH1PGr2NXcmtLM
         UVrM/XLB+mOD1+baEvaCQayzYlXwGvsWJfwGSpytQ8JghgZRG6Ngdvoi3AJGCe7QDX4y
         2xyZOhowzR7AHS0Le8X5T3kClixmf6gVCk/mI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i2L/2d/WummzhFYZmp1J8UiAMxM3AINvBVUjQlggREQ=;
        b=GPd2KyfuCMThAZTZ73d96ypwbA7W68PkAPFM4lln/A81fASgr+71xVdmrwFDVNS2dF
         KoNFImymdVe2d2Cj123ETkU5T6Nq7k37ZSknDSKT/KlAB56hGyz4YZ1ZsQbbJ7HTPjCL
         0+Ecr+2BPjzN45glXuB5UANZYZyJTrLC0nHL24qrXR4OmlHM8OaaScLEb/vKZQ8EBaR/
         +cjglSXj78ZEJ1eg16wBMDNPVjpe3bYSGq6qJCtyU+I+UX+Bg8yd+jL+H3iVUq5H+0ya
         ioQ/LZpYbpzUPXUt3qezFOfkYwKlsfOcAiu1OWYzYgrnUDb/IgiCTFOJw0NByh5ZS5ES
         bVTw==
X-Gm-Message-State: AOAM53250+gFkDE/QzQUuJsU2pYewf6gF3shRyWJLXA+xgzMll+QRlRf
        fD4xhtbRDgTJhs4AAWDPLnoihQ==
X-Google-Smtp-Source: ABdhPJwEAb4o6qpPYrC7QhCmP4NQ0wbU1OWlS/M7Pmy/QuwmEMkjFtbzCUkKpXLwuQaimIojabiVnQ==
X-Received: by 2002:a05:6a00:148b:: with SMTP id v11mr4172298pfu.82.1644932150369;
        Tue, 15 Feb 2022 05:35:50 -0800 (PST)
Received: from localhost (208.158.221.35.bc.googleusercontent.com. [35.221.158.208])
        by smtp.gmail.com with UTF8SMTPSA id l2sm17178483pju.52.2022.02.15.05.35.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 05:35:49 -0800 (PST)
From:   Joseph Hwang <josephsih@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, pali@kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org, josephsih@google.com,
        Joseph Hwang <josephsih@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 3/3] Bluetooth: mgmt: add set_quality_report for MGMT_OP_SET_QUALITY_REPORT
Date:   Tue, 15 Feb 2022 21:35:32 +0800
Message-Id: <20220215133546.2826837-1-josephsih@chromium.org>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
In-Reply-To: <20220215213519.v4.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
References: <20220215213519.v4.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new set_quality_report mgmt handler to set
the quality report feature. The feature is removed from the
experimental features at the same time.

Signed-off-by: Joseph Hwang <josephsih@chromium.org>
---

Changes in v4:
- return current settings for set_quality_report.

Changes in v3:
- This is a new patch to enable the quality report feature.
  The reading and setting of the quality report feature are
  removed from the experimental features.

 include/net/bluetooth/mgmt.h |   7 ++
 net/bluetooth/mgmt.c         | 168 +++++++++++++++--------------------
 2 files changed, 81 insertions(+), 94 deletions(-)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 83b602636262..74d253ff617a 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -109,6 +109,7 @@ struct mgmt_rp_read_index_list {
 #define MGMT_SETTING_STATIC_ADDRESS	0x00008000
 #define MGMT_SETTING_PHY_CONFIGURATION	0x00010000
 #define MGMT_SETTING_WIDEBAND_SPEECH	0x00020000
+#define MGMT_SETTING_QUALITY_REPORT	0x00040000
 
 #define MGMT_OP_READ_INFO		0x0004
 #define MGMT_READ_INFO_SIZE		0
@@ -838,6 +839,12 @@ struct mgmt_cp_add_adv_patterns_monitor_rssi {
 } __packed;
 #define MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZE	8
 
+#define MGMT_OP_SET_QUALITY_REPORT		0x0057
+struct mgmt_cp_set_quality_report {
+	__u8	action;
+} __packed;
+#define MGMT_SET_QUALITY_REPORT_SIZE		1
+
 #define MGMT_EV_CMD_COMPLETE		0x0001
 struct mgmt_ev_cmd_complete {
 	__le16	opcode;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 5e48576041fb..ccd77b94905b 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -857,6 +857,10 @@ static u32 get_supported_settings(struct hci_dev *hdev)
 
 	settings |= MGMT_SETTING_PHY_CONFIGURATION;
 
+	if (hdev && (aosp_has_quality_report(hdev) ||
+		     hdev->set_quality_report))
+		settings |= MGMT_SETTING_QUALITY_REPORT;
+
 	return settings;
 }
 
@@ -928,6 +932,9 @@ static u32 get_current_settings(struct hci_dev *hdev)
 	if (hci_dev_test_flag(hdev, HCI_WIDEBAND_SPEECH_ENABLED))
 		settings |= MGMT_SETTING_WIDEBAND_SPEECH;
 
+	if (hci_dev_test_flag(hdev, HCI_QUALITY_REPORT))
+		settings |= MGMT_SETTING_QUALITY_REPORT;
+
 	return settings;
 }
 
@@ -3871,12 +3878,6 @@ static const u8 debug_uuid[16] = {
 };
 #endif
 
-/* 330859bc-7506-492d-9370-9a6f0614037f */
-static const u8 quality_report_uuid[16] = {
-	0x7f, 0x03, 0x14, 0x06, 0x6f, 0x9a, 0x70, 0x93,
-	0x2d, 0x49, 0x06, 0x75, 0xbc, 0x59, 0x08, 0x33,
-};
-
 /* a6695ace-ee7f-4fb9-881a-5fac66c629af */
 static const u8 offload_codecs_uuid[16] = {
 	0xaf, 0x29, 0xc6, 0x66, 0xac, 0x5f, 0x1a, 0x88,
@@ -3898,7 +3899,7 @@ static const u8 rpa_resolution_uuid[16] = {
 static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
 				  void *data, u16 data_len)
 {
-	char buf[102];   /* Enough space for 5 features: 2 + 20 * 5 */
+	char buf[82];   /* Enough space for 4 features: 2 + 20 * 4 */
 	struct mgmt_rp_read_exp_features_info *rp = (void *)buf;
 	u16 idx = 0;
 	u32 flags;
@@ -3939,18 +3940,6 @@ static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
 		idx++;
 	}
 
-	if (hdev && (aosp_has_quality_report(hdev) ||
-		     hdev->set_quality_report)) {
-		if (hci_dev_test_flag(hdev, HCI_QUALITY_REPORT))
-			flags = BIT(0);
-		else
-			flags = 0;
-
-		memcpy(rp->features[idx].uuid, quality_report_uuid, 16);
-		rp->features[idx].flags = cpu_to_le32(flags);
-		idx++;
-	}
-
 	if (hdev && hdev->get_data_path_id) {
 		if (hci_dev_test_flag(hdev, HCI_OFFLOAD_CODECS_ENABLED))
 			flags = BIT(0);
@@ -4163,80 +4152,6 @@ static int set_rpa_resolution_func(struct sock *sk, struct hci_dev *hdev,
 	return err;
 }
 
-static int set_quality_report_func(struct sock *sk, struct hci_dev *hdev,
-				   struct mgmt_cp_set_exp_feature *cp,
-				   u16 data_len)
-{
-	struct mgmt_rp_set_exp_feature rp;
-	bool val, changed;
-	int err;
-
-	/* Command requires to use a valid controller index */
-	if (!hdev)
-		return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
-				       MGMT_OP_SET_EXP_FEATURE,
-				       MGMT_STATUS_INVALID_INDEX);
-
-	/* Parameters are limited to a single octet */
-	if (data_len != MGMT_SET_EXP_FEATURE_SIZE + 1)
-		return mgmt_cmd_status(sk, hdev->id,
-				       MGMT_OP_SET_EXP_FEATURE,
-				       MGMT_STATUS_INVALID_PARAMS);
-
-	/* Only boolean on/off is supported */
-	if (cp->param[0] != 0x00 && cp->param[0] != 0x01)
-		return mgmt_cmd_status(sk, hdev->id,
-				       MGMT_OP_SET_EXP_FEATURE,
-				       MGMT_STATUS_INVALID_PARAMS);
-
-	hci_req_sync_lock(hdev);
-
-	val = !!cp->param[0];
-	changed = (val != hci_dev_test_flag(hdev, HCI_QUALITY_REPORT));
-
-	if (!aosp_has_quality_report(hdev) && !hdev->set_quality_report) {
-		err = mgmt_cmd_status(sk, hdev->id,
-				      MGMT_OP_SET_EXP_FEATURE,
-				      MGMT_STATUS_NOT_SUPPORTED);
-		goto unlock_quality_report;
-	}
-
-	if (changed) {
-		if (hdev->set_quality_report)
-			err = hdev->set_quality_report(hdev, val);
-		else
-			err = aosp_set_quality_report(hdev, val);
-
-		if (err) {
-			err = mgmt_cmd_status(sk, hdev->id,
-					      MGMT_OP_SET_EXP_FEATURE,
-					      MGMT_STATUS_FAILED);
-			goto unlock_quality_report;
-		}
-
-		if (val)
-			hci_dev_set_flag(hdev, HCI_QUALITY_REPORT);
-		else
-			hci_dev_clear_flag(hdev, HCI_QUALITY_REPORT);
-	}
-
-	bt_dev_dbg(hdev, "quality report enable %d changed %d", val, changed);
-
-	memcpy(rp.uuid, quality_report_uuid, 16);
-	rp.flags = cpu_to_le32(val ? BIT(0) : 0);
-	hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
-
-	err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_SET_EXP_FEATURE, 0,
-				&rp, sizeof(rp));
-
-	if (changed)
-		exp_feature_changed(hdev, quality_report_uuid, val, sk);
-
-unlock_quality_report:
-	hci_req_sync_unlock(hdev);
-	return err;
-}
-
 static int set_offload_codec_func(struct sock *sk, struct hci_dev *hdev,
 				  struct mgmt_cp_set_exp_feature *cp,
 				  u16 data_len)
@@ -4363,7 +4278,6 @@ static const struct mgmt_exp_feature {
 	EXP_FEAT(debug_uuid, set_debug_func),
 #endif
 	EXP_FEAT(rpa_resolution_uuid, set_rpa_resolution_func),
-	EXP_FEAT(quality_report_uuid, set_quality_report_func),
 	EXP_FEAT(offload_codecs_uuid, set_offload_codec_func),
 	EXP_FEAT(le_simultaneous_roles_uuid, set_le_simultaneous_roles_func),
 
@@ -8653,6 +8567,71 @@ static int get_adv_size_info(struct sock *sk, struct hci_dev *hdev,
 				 MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
 }
 
+static int set_quality_report(struct sock *sk, struct hci_dev *hdev,
+			      void *data, u16 data_len)
+{
+	struct mgmt_cp_set_quality_report *cp = data;
+	bool enable, changed;
+	int err;
+
+	/* Command requires to use a valid controller index */
+	if (!hdev)
+		return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
+				       MGMT_OP_SET_QUALITY_REPORT,
+				       MGMT_STATUS_INVALID_INDEX);
+
+	/* Only 0 (off) and 1 (on) is supported */
+	if (cp->action != 0x00 && cp->action != 0x01)
+		return mgmt_cmd_status(sk, hdev->id,
+				       MGMT_OP_SET_QUALITY_REPORT,
+				       MGMT_STATUS_INVALID_PARAMS);
+
+	hci_req_sync_lock(hdev);
+
+	enable = !!cp->action;
+	changed = (enable != hci_dev_test_flag(hdev, HCI_QUALITY_REPORT));
+
+	if (!aosp_has_quality_report(hdev) && !hdev->set_quality_report) {
+		err = mgmt_cmd_status(sk, hdev->id,
+				      MGMT_OP_SET_QUALITY_REPORT,
+				      MGMT_STATUS_NOT_SUPPORTED);
+		goto unlock_quality_report;
+	}
+
+	if (changed) {
+		if (hdev->set_quality_report)
+			err = hdev->set_quality_report(hdev, enable);
+		else
+			err = aosp_set_quality_report(hdev, enable);
+
+		if (err) {
+			err = mgmt_cmd_status(sk, hdev->id,
+					      MGMT_OP_SET_QUALITY_REPORT,
+					      MGMT_STATUS_FAILED);
+			goto unlock_quality_report;
+		}
+
+		if (enable)
+			hci_dev_set_flag(hdev, HCI_QUALITY_REPORT);
+		else
+			hci_dev_clear_flag(hdev, HCI_QUALITY_REPORT);
+	}
+
+	bt_dev_dbg(hdev, "quality report enable %d changed %d",
+		   enable, changed);
+
+	err = send_settings_rsp(sk, MGMT_OP_SET_QUALITY_REPORT, hdev);
+	if (err < 0)
+		goto unlock_quality_report;
+
+	if (changed)
+		err = new_settings(hdev, sk);
+
+unlock_quality_report:
+	hci_req_sync_unlock(hdev);
+	return err;
+}
+
 static const struct hci_mgmt_handler mgmt_handlers[] = {
 	{ NULL }, /* 0x0000 (no command) */
 	{ read_version,            MGMT_READ_VERSION_SIZE,
@@ -8779,6 +8758,7 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
 	{ add_adv_patterns_monitor_rssi,
 				   MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZE,
 						HCI_MGMT_VAR_LEN },
+	{ set_quality_report,      MGMT_SET_QUALITY_REPORT_SIZE },
 };
 
 void mgmt_index_added(struct hci_dev *hdev)
-- 
2.35.1.265.g69c8d7142f-goog

