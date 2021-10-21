Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458AF4364FF
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 17:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhJUPHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 11:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbhJUPHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 11:07:03 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA638C061348
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 08:04:47 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gn3so745330pjb.0
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 08:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nRQxWGzImi7clOdvh2498JBTr8KRh9zMPH4Aj6/5tPk=;
        b=krOdecJ9wsAw9sJSkGrZu9FvYjA60OXWhN0qHdV1BuXf1K/TlYg2kluaeDFp+wiw8R
         xl6eiPOIPy+7fd/THMPOzFFLnoWii1ivgWPveZQQeD/MkFDHWThojrOaNvNnrs/QSrlX
         Gf9SiS7i6Tan3sDKr9uRbZdrGzaXMF/KB9uO8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nRQxWGzImi7clOdvh2498JBTr8KRh9zMPH4Aj6/5tPk=;
        b=NpiKQ6ByVg6wCpcEWkoeIa4bupWAHuyf/BWoyEcnOqSW84V5wkWkDCeQCIHIe6HLA4
         NqyxzrKpORZkBbtKcy2DfgTo+Yp7a123zR4sJD5AL4Irno7yFH1qDsY2fKFF8kii/7us
         L43r5VzoUsEM7QT7IsJgL6WR0dkjekgP+sdOLg6dQqXPrT7S3SqCKwbeudHncXARSwTI
         iOpSRKvf/pS1Z3h/aDSOHPJ/TIs+KoLDlO3iJw8bUzv6AfB2zT2RkmgByGIwlVXZN98G
         kQZLDSeFShGW/VaN9isqMFLEVwPUNthgk4ffyd0oaaEfuDD1tIObh++Ic/X0oEUmLCBq
         wPFQ==
X-Gm-Message-State: AOAM531ZnCRvlgbWCgJSC48PtS4gf8Rf5LZBWNfLUuZcRExqecv/f9ZC
        zPuioeDPoV8N4EOjMA6GKBe7hg==
X-Google-Smtp-Source: ABdhPJwtNncS9MF/nZqlrK47730b8mnlNGNimsWT0ObLpZoQKt18S+hTYu/DrlBDGL8Ph7oaq7wRMA==
X-Received: by 2002:a17:902:9a4b:b0:13f:c764:6e85 with SMTP id x11-20020a1709029a4b00b0013fc7646e85mr5566905plv.29.1634828687180;
        Thu, 21 Oct 2021 08:04:47 -0700 (PDT)
Received: from josephsih-z840.tpe.corp.google.com ([2401:fa00:1:10:acf2:287:fa53:43f4])
        by smtp.gmail.com with ESMTPSA id 21sm9546045pjg.57.2021.10.21.08.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 08:04:46 -0700 (PDT)
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
Subject: [PATCH v6 2/3] Bluetooth: aosp: Support AOSP Bluetooth Quality Report
Date:   Thu, 21 Oct 2021 23:04:24 +0800
Message-Id: <20211021230356.v6.2.Iaa4a0269e51d8e8d8784a6ac8e05899b49a1377d@changeid>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211021230356.v6.1.I139e71adfd3f00b88fe9edb63d013f9cd3e24506@changeid>
References: <20211021230356.v6.1.I139e71adfd3f00b88fe9edb63d013f9cd3e24506@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the support of the AOSP Bluetooth Quality Report
(BQR) events.

Multiple vendors have supported the AOSP Bluetooth Quality Report.
When a Bluetooth controller supports the capability, it can enable
the aosp capability through hci_set_aosp_capable. Then hci_core will
set up the hdev->aosp_set_quality_report callback through aosp_do_open
if the controller responds to support the quality report capability.

Note that Intel also supports a distinct telemetry quality report
specification. Intel sets up the hdev->set_quality_report callback
in the btusb driver module.

Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Signed-off-by: Joseph Hwang <josephsih@chromium.org>

---

Changes in v6:
- Use the decimal version instead of hexadecimal version to be
  consistent with the AOSP specification.
- Move the code of checking the bluetooth_quality_report_support field
  to the previous patch.

Changes in v5:
- Fix the patch per
  [RFC PATCH] Bluetooth: Add framework for AOSP quality report setting
- Declare aosp_set_quality_report.
- Use aosp_do_open() to set hdev->aosp_set_quality_report.
- Add aosp_has_quality_report().
- In mgmt, use hdev->aosp_set_quality_report and
  hdev->set_quality_report separately.

Changes in v4:
- Move the AOSP BQR support from the driver level to net/bluetooth/aosp.
- Fix the drivers to use hci_set_aosp_capable to enable aosp.
- Add Mediatek to support the capability too.

Changes in v3:
- Fix the auto build test ERROR
  "undefined symbol: btandroid_set_quality_report" that occurred
  with some kernel configs.
- Note that the mgmt-tester "Read Exp Feature - Success" failed.
  But on my test device, the same test passed. Please kindly let me
  know what may be going wrong. These patches do not actually
  modify read/set experimental features.
- As to CheckPatch failed. No need to modify the MAINTAINERS file.
  Thanks.

Changes in v2:
- Fix the titles of patches 2/3 and 3/3 and reduce their lengths.

 net/bluetooth/aosp.c | 87 ++++++++++++++++++++++++++++++++++++++++++++
 net/bluetooth/aosp.h | 13 +++++++
 net/bluetooth/mgmt.c | 18 ++++++---
 3 files changed, 113 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/aosp.c b/net/bluetooth/aosp.c
index 64684b2bf79b..582c380a29fa 100644
--- a/net/bluetooth/aosp.c
+++ b/net/bluetooth/aosp.c
@@ -147,3 +147,90 @@ void aosp_do_close(struct hci_dev *hdev)
 
 	bt_dev_dbg(hdev, "Cleanup of AOSP extension");
 }
+
+/* BQR command */
+#define BQR_OPCODE			hci_opcode_pack(0x3f, 0x015e)
+
+/* BQR report action */
+#define REPORT_ACTION_ADD		0x00
+#define REPORT_ACTION_DELETE		0x01
+#define REPORT_ACTION_CLEAR		0x02
+
+/* BQR event masks */
+#define QUALITY_MONITORING		BIT(0)
+#define APPRAOCHING_LSTO		BIT(1)
+#define A2DP_AUDIO_CHOPPY		BIT(2)
+#define SCO_VOICE_CHOPPY		BIT(3)
+
+#define DEFAULT_BQR_EVENT_MASK	(QUALITY_MONITORING | APPRAOCHING_LSTO | \
+				 A2DP_AUDIO_CHOPPY | SCO_VOICE_CHOPPY)
+
+/* Reporting at milliseconds so as not to stress the controller too much.
+ * Range: 0 ~ 65535 ms
+ */
+#define DEFALUT_REPORT_INTERVAL_MS	5000
+
+struct aosp_bqr_cp {
+	__u8	report_action;
+	__u32	event_mask;
+	__u16	min_report_interval;
+} __packed;
+
+static int enable_quality_report(struct hci_dev *hdev)
+{
+	struct sk_buff *skb;
+	struct aosp_bqr_cp cp;
+
+	cp.report_action = REPORT_ACTION_ADD;
+	cp.event_mask = DEFAULT_BQR_EVENT_MASK;
+	cp.min_report_interval = DEFALUT_REPORT_INTERVAL_MS;
+
+	skb = __hci_cmd_sync(hdev, BQR_OPCODE, sizeof(cp), &cp,
+			     HCI_CMD_TIMEOUT);
+	if (IS_ERR(skb)) {
+		bt_dev_err(hdev, "Enabling Android BQR failed (%ld)",
+			   PTR_ERR(skb));
+		return PTR_ERR(skb);
+	}
+
+	kfree_skb(skb);
+	return 0;
+}
+
+static int disable_quality_report(struct hci_dev *hdev)
+{
+	struct sk_buff *skb;
+	struct aosp_bqr_cp cp = { 0 };
+
+	cp.report_action = REPORT_ACTION_CLEAR;
+
+	skb = __hci_cmd_sync(hdev, BQR_OPCODE, sizeof(cp), &cp,
+			     HCI_CMD_TIMEOUT);
+	if (IS_ERR(skb)) {
+		bt_dev_err(hdev, "Disabling Android BQR failed (%ld)",
+			   PTR_ERR(skb));
+		return PTR_ERR(skb);
+	}
+
+	kfree_skb(skb);
+	return 0;
+}
+
+bool aosp_has_quality_report(struct hci_dev *hdev)
+{
+	return hdev->aosp_quality_report;
+}
+
+int aosp_set_quality_report(struct hci_dev *hdev, bool enable)
+{
+	if (!aosp_has_quality_report(hdev))
+		return -EOPNOTSUPP;
+
+	bt_dev_dbg(hdev, "quality report enable %d", enable);
+
+	/* Enable or disable the quality report feature. */
+	if (enable)
+		return enable_quality_report(hdev);
+	else
+		return disable_quality_report(hdev);
+}
diff --git a/net/bluetooth/aosp.h b/net/bluetooth/aosp.h
index 328fc6d39f70..2fd8886d51b2 100644
--- a/net/bluetooth/aosp.h
+++ b/net/bluetooth/aosp.h
@@ -8,9 +8,22 @@
 void aosp_do_open(struct hci_dev *hdev);
 void aosp_do_close(struct hci_dev *hdev);
 
+bool aosp_has_quality_report(struct hci_dev *hdev);
+int aosp_set_quality_report(struct hci_dev *hdev, bool enable);
+
 #else
 
 static inline void aosp_do_open(struct hci_dev *hdev) {}
 static inline void aosp_do_close(struct hci_dev *hdev) {}
 
+static inline bool aosp_has_quality_report(struct hci_dev *hdev)
+{
+	return false;
+}
+
+static inline int aosp_set_quality_report(struct hci_dev *hdev, bool enable)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 44683443300c..d6c322763567 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -39,6 +39,7 @@
 #include "mgmt_config.h"
 #include "msft.h"
 #include "eir.h"
+#include "aosp.h"
 
 #define MGMT_VERSION	1
 #define MGMT_REVISION	21
@@ -3863,7 +3864,8 @@ static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
 		idx++;
 	}
 
-	if (hdev && hdev->set_quality_report) {
+	if (hdev && (aosp_has_quality_report(hdev) ||
+		     hdev->set_quality_report)) {
 		if (hci_dev_test_flag(hdev, HCI_QUALITY_REPORT))
 			flags = BIT(0);
 		else
@@ -4127,7 +4129,8 @@ static int set_quality_report_func(struct sock *sk, struct hci_dev *hdev,
 	val = !!cp->param[0];
 	changed = (val != hci_dev_test_flag(hdev, HCI_QUALITY_REPORT));
 
-	if (!hdev->set_quality_report) {
+	if (!aosp_has_quality_report(hdev) && !hdev->set_quality_report) {
+		BT_INFO("quality report not supported");
 		err = mgmt_cmd_status(sk, hdev->id,
 				      MGMT_OP_SET_EXP_FEATURE,
 				      MGMT_STATUS_NOT_SUPPORTED);
@@ -4135,13 +4138,18 @@ static int set_quality_report_func(struct sock *sk, struct hci_dev *hdev,
 	}
 
 	if (changed) {
-		err = hdev->set_quality_report(hdev, val);
+		if (hdev->set_quality_report)
+			err = hdev->set_quality_report(hdev, val);
+		else
+			err = aosp_set_quality_report(hdev, val);
+
 		if (err) {
 			err = mgmt_cmd_status(sk, hdev->id,
 					      MGMT_OP_SET_EXP_FEATURE,
 					      MGMT_STATUS_FAILED);
 			goto unlock_quality_report;
 		}
+
 		if (val)
 			hci_dev_set_flag(hdev, HCI_QUALITY_REPORT);
 		else
@@ -4153,8 +4161,8 @@ static int set_quality_report_func(struct sock *sk, struct hci_dev *hdev,
 	memcpy(rp.uuid, quality_report_uuid, 16);
 	rp.flags = cpu_to_le32(val ? BIT(0) : 0);
 	hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
-	err = mgmt_cmd_complete(sk, hdev->id,
-				MGMT_OP_SET_EXP_FEATURE, 0,
+
+	err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_SET_EXP_FEATURE, 0,
 				&rp, sizeof(rp));
 
 	if (changed)
-- 
2.33.0.1079.g6e70778dc9-goog

