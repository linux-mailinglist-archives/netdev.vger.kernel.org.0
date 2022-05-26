Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A46F534DF2
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 13:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242759AbiEZLVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 07:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236723AbiEZLVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 07:21:47 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D42D74
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 04:21:45 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id u12-20020a17090a1d4c00b001df78c7c209so4164926pju.1
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 04:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2iK0JmSQYTB7W/NddouTDmgmSdRkfZFIZ90UVQfjdRo=;
        b=WgHNCvPUwm6A5Bpdync/k62mv4R2FuM2AVS3mf1foVPgeo5O1GL6Bnnn+fpHzPysiw
         MH5A9YPPnv7CRFnOb2UEAahdhf7xNUejM+t/NhW47jz83y0AM3gSrN7k9IuGMZnkhvsU
         ExZRnDghSqDcjchcObjeuPGweoBRQXKXFTHzg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2iK0JmSQYTB7W/NddouTDmgmSdRkfZFIZ90UVQfjdRo=;
        b=dQdy0RvXTJ8dsXxNRMHa0TlJt2VyV2FBieIU6q73hM81WZaNmYLYECggjDOpAhf91L
         2/WeRKUKQIC2WWbtWztAWM5j+kP+2aGJ6u2ahp1W9zL+iGEkoNbC9mP1B43WOQyBJfOp
         DR4LGIb6SH08xgAy2pHYElKm+/rHwhBm+a9FFPJ4glHtcp8SGheshU+kj0GSmIV1K77j
         xwo3h35bDwFCoWK0j/8sZaKahqtuEQqI+3rOSQsUtxIa9z0tNUKomTgSSiMUb1N04wi3
         2F8LEkCnyXu+3N5mYrhoJ41ik4mrw15Go/x1SjiBJOG0ZPMe3Y1V5VsG/qulvAXStx1n
         4urw==
X-Gm-Message-State: AOAM530e0uK17mXX4e89iA36/0KGMDiHRDuNwO5P2/19/nfA6br1mhcG
        qjaz10qPYRctsAovB71kUwvq3w==
X-Google-Smtp-Source: ABdhPJz0joFdyuqT2P3YS2oo8Vyn34AHb81YGCz6tLkSAdfACCIxBNJeHTIiA9QXZXIPI+Fh3o2ULA==
X-Received: by 2002:a17:902:b692:b0:14c:935b:2b03 with SMTP id c18-20020a170902b69200b0014c935b2b03mr37389995pls.81.1653564105228;
        Thu, 26 May 2022 04:21:45 -0700 (PDT)
Received: from localhost (174.71.80.34.bc.googleusercontent.com. [34.80.71.174])
        by smtp.gmail.com with UTF8SMTPSA id w23-20020aa78597000000b0050dc7628150sm1217985pfn.42.2022.05.26.04.21.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 May 2022 04:21:44 -0700 (PDT)
From:   Joseph Hwang <josephsih@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, pali@kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org, josephsih@google.com,
        Joseph Hwang <josephsih@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v6 1/5] Bluetooth: mgmt: add MGMT_OP_SET_QUALITY_REPORT for quality report
Date:   Thu, 26 May 2022 19:21:30 +0800
Message-Id: <20220526112135.2486883-1-josephsih@chromium.org>
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

Changes in v6:
- No update in this patch. The patch 2/5 is updated to fix
  a sparse check warning.

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

