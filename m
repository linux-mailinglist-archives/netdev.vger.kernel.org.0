Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFA3533AD1
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 12:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240283AbiEYKp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 06:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234162AbiEYKp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 06:45:56 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AC399683
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 03:45:54 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id z25so6181045pfr.1
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 03:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eZHHJ8xZ0WLnM7kImTEfhllSgT1hYk7RJ6GDlALdclU=;
        b=kIwQ0plu4qoXAnCshP2TSrFMPv3H7erjIb4M8UZRo0gPSgdP4mlHQ4ZSXgCGx1b7Yt
         CfApB0TbHw5L4fq+ZFp0SLG3YuxVMbpDyKUPru2o76+7mB+KvWU8Ngf1kQyAgN0gTBP5
         VRqqfQfBduqFCgV+eSEGwbTGTEK4dePoYvk+U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eZHHJ8xZ0WLnM7kImTEfhllSgT1hYk7RJ6GDlALdclU=;
        b=I4+Ttb64di+GR9mHI2x7vmy2/VZLrFH6P2rfnU4laWKxBz3wL7khSzMY+2urThK1fO
         ha2iubBUE0Kq5k36bU7gXs9nhojeZTZrEiWKqzmoTyEwb0HcG0yqyDOaXvSgM5qCFU/T
         AoDTATPVgUsc+TRMMMRn3tsSLyCfr4gCp2ELXVg6JqQZdeOCo55K4F8lo5+ioylrf5Ys
         heuWEwi59TqHoYObtV8vTYJjce7bGjAY+AmwcXN2R3eId9ub+8Kfc990v2k7bh4hcrCY
         DDhxgZor+TiD2IZkZD9mHJVsfkQ+leyoxIxesT/aDGuvNfSYoy5A7nSk0hoGRn/Sjl0W
         iv6A==
X-Gm-Message-State: AOAM533rfOmKYmmYj35hnN7yeTVKVrkrNAHQ40a5hrQYLaAvnFT3l5QS
        VaaHnB8bQuSLbL5bvGtYMZpoLQ==
X-Google-Smtp-Source: ABdhPJzJj4xTqY5JKJDxbBncKjKBUh4qwknmOLSqdd/djycNTbStDWrdY3V22flQf8h+rzraqTWtXg==
X-Received: by 2002:a63:535c:0:b0:3db:69da:1ef7 with SMTP id t28-20020a63535c000000b003db69da1ef7mr28668131pgl.239.1653475553811;
        Wed, 25 May 2022 03:45:53 -0700 (PDT)
Received: from localhost (174.71.80.34.bc.googleusercontent.com. [34.80.71.174])
        by smtp.gmail.com with UTF8SMTPSA id f7-20020a6547c7000000b003db8691008esm8006519pgs.12.2022.05.25.03.45.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 03:45:53 -0700 (PDT)
From:   Joseph Hwang <josephsih@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, pali@kernel.org
Cc:     josephsih@google.com, chromeos-bluetooth-upstreaming@chromium.org,
        Joseph Hwang <josephsih@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v5 1/5] Bluetooth: mgmt: add MGMT_OP_SET_QUALITY_REPORT for quality report
Date:   Wed, 25 May 2022 18:45:41 +0800
Message-Id: <20220525104545.2314653-1-josephsih@chromium.org>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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

Changes in v5:
- This patch becomes the first patch.
- Remove useless hdev check in get_supported_settings().
- An additional patch will make quality report survive power off/on
  cycles.

Changes in v4:
- return current settings for set_quality_report.

Changes in v3:
- This is a new patch to enable the quality report feature.
  The reading and setting of the quality report feature are
  removed from the experimental features.

 include/net/bluetooth/mgmt.h |   7 ++
 net/bluetooth/mgmt.c         | 167 +++++++++++++++--------------------
 2 files changed, 80 insertions(+), 94 deletions(-)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 7c1ad0f6fcec..c1c2fd72d9e3 100644
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
index d2d390534e54..1ad84f34097f 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -857,6 +857,9 @@ static u32 get_supported_settings(struct hci_dev *hdev)
 
 	settings |= MGMT_SETTING_PHY_CONFIGURATION;
 
+	if (aosp_has_quality_report(hdev) || hdev->set_quality_report)
+		settings |= MGMT_SETTING_QUALITY_REPORT;
+
 	return settings;
 }
 
@@ -928,6 +931,9 @@ static u32 get_current_settings(struct hci_dev *hdev)
 	if (hci_dev_test_flag(hdev, HCI_WIDEBAND_SPEECH_ENABLED))
 		settings |= MGMT_SETTING_WIDEBAND_SPEECH;
 
+	if (hci_dev_test_flag(hdev, HCI_QUALITY_REPORT))
+		settings |= MGMT_SETTING_QUALITY_REPORT;
+
 	return settings;
 }
 
@@ -3901,12 +3907,6 @@ static const u8 debug_uuid[16] = {
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
@@ -3928,7 +3928,7 @@ static const u8 rpa_resolution_uuid[16] = {
 static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
 				  void *data, u16 data_len)
 {
-	char buf[102];   /* Enough space for 5 features: 2 + 20 * 5 */
+	char buf[82];   /* Enough space for 4 features: 2 + 20 * 4 */
 	struct mgmt_rp_read_exp_features_info *rp = (void *)buf;
 	u16 idx = 0;
 	u32 flags;
@@ -3969,18 +3969,6 @@ static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
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
@@ -4193,80 +4181,6 @@ static int set_rpa_resolution_func(struct sock *sk, struct hci_dev *hdev,
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
@@ -4393,7 +4307,6 @@ static const struct mgmt_exp_feature {
 	EXP_FEAT(debug_uuid, set_debug_func),
 #endif
 	EXP_FEAT(rpa_resolution_uuid, set_rpa_resolution_func),
-	EXP_FEAT(quality_report_uuid, set_quality_report_func),
 	EXP_FEAT(offload_codecs_uuid, set_offload_codec_func),
 	EXP_FEAT(le_simultaneous_roles_uuid, set_le_simultaneous_roles_func),
 
@@ -8664,6 +8577,71 @@ static int get_adv_size_info(struct sock *sk, struct hci_dev *hdev,
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
@@ -8790,6 +8768,7 @@ static const struct hci_mgmt_handler mgmt_handlers[] = {
 	{ add_adv_patterns_monitor_rssi,
 				   MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZE,
 						HCI_MGMT_VAR_LEN },
+	{ set_quality_report,      MGMT_SET_QUALITY_REPORT_SIZE },
 };
 
 void mgmt_index_added(struct hci_dev *hdev)
-- 
2.36.1.124.g0e6072fb45-goog

