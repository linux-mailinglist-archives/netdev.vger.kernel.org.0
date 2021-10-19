Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B037943356C
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbhJSMJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhJSMJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 08:09:39 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C59C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 05:07:26 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id m21so19103871pgu.13
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 05:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P1QGNl0cgWp6Q/NbeZQ6qfaTxP4VB5dnkkqXn90EmY0=;
        b=Vxl/6Q3yWLYkk4Ha9ewMxHqJoLuh/9D97IyuCcd6lk1Uoj6PzXsGZ2JxWmCrKrJzPP
         A9NxWi0N5z1535w4yIyKJy0fFCt2Hd5LOufhgvSBp4OpzRgz/jjTkuIMQuvr2rjLiAPG
         aYgUxjUq7BmvYhaGK4PWP50L4S6NO44tgyhzM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P1QGNl0cgWp6Q/NbeZQ6qfaTxP4VB5dnkkqXn90EmY0=;
        b=K2i4fxDj9rF98GWgeYWrrqugDVIgijikH6nw6pvrey8OZN51Fk7NuSWmFMklUKPbhV
         YWk7GG4IfZ+pe68x7r6/izcXk/nVbwasioxRtrKjRvXQi5Rf8vqU7y2ftxJOh9v9WsTb
         02WjCqt4sua64+cNPubZ1sb+poNunDl/a85uJ370qoQpXREjnkMngpbXXvpNS+Ny/r+f
         D/m433jS2JKxCHGy8ZijKZQjpQmxmo1RSqvqJjWk/YfDWzumilfZvyRf1Mt78575hGZQ
         0rXhjncxhq2ZCNvVXJ6LIfNR5/17GYzZQh4j0AH5Pvz8/7sZt//l9mYGSH/CL7C7/01w
         YTVQ==
X-Gm-Message-State: AOAM533IqhFCeUbFMHei07XgrnR9pNEJmgOJBewlIjNdsHmXmECVMWqv
        CQz9xGqgZxFUohVQbCueWIzrOA==
X-Google-Smtp-Source: ABdhPJzL9l3Yqv0saCu2ioyR3TkiKF1Yn6+8erncYztS/TxBImWZSJdpiW5rxArXr9Y30Uusk1rtOg==
X-Received: by 2002:a05:6a00:16d2:b029:300:200b:6572 with SMTP id l18-20020a056a0016d2b0290300200b6572mr34757209pfc.62.1634645246298;
        Tue, 19 Oct 2021 05:07:26 -0700 (PDT)
Received: from josephsih-z840.tpe.corp.google.com ([2401:fa00:1:10:1d7c:b745:dee:c8a4])
        by smtp.gmail.com with ESMTPSA id k16sm5236160pgt.57.2021.10.19.05.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 05:07:25 -0700 (PDT)
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
Subject: [PATCH v5 2/3] Bluetooth: aosp: Support AOSP Bluetooth Quality Report
Date:   Tue, 19 Oct 2021 20:07:14 +0800
Message-Id: <20211019200701.v5.2.Iaa4a0269e51d8e8d8784a6ac8e05899b49a1377d@changeid>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211019200701.v5.1.I139e71adfd3f00b88fe9edb63d013f9cd3e24506@changeid>
References: <20211019200701.v5.1.I139e71adfd3f00b88fe9edb63d013f9cd3e24506@changeid>
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

 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/aosp.c             | 97 ++++++++++++++++++++++++++++++++
 net/bluetooth/aosp.h             | 13 +++++
 net/bluetooth/mgmt.c             | 18 ++++--
 4 files changed, 124 insertions(+), 5 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index dd8840e70e25..32b3774227f2 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -603,6 +603,7 @@ struct hci_dev {
 
 #if IS_ENABLED(CONFIG_BT_AOSPEXT)
 	bool			aosp_capable;
+	bool			aosp_quality_report;
 #endif
 
 	int (*open)(struct hci_dev *hdev);
diff --git a/net/bluetooth/aosp.c b/net/bluetooth/aosp.c
index 3f0ea57a68de..0d4497656feb 100644
--- a/net/bluetooth/aosp.c
+++ b/net/bluetooth/aosp.c
@@ -62,6 +62,16 @@ void aosp_do_open(struct hci_dev *hdev)
 	version_supported = le16_to_cpu(rp->version_supported);
 	bt_dev_info(hdev, "AOSP version 0x%4.4x", version_supported);
 
+	/* The bluetooth_quality_report_support is defined at version 0x0062.
+	 * Refer to https://cs.android.com/android/platform/superproject/+/
+	 *                  master:system/bt/gd/hci/controller.cc;l=477
+	 */
+	if (version_supported >= 0x0062 &&
+	    rp->bluetooth_quality_report_support) {
+		hdev->aosp_quality_report = true;
+		bt_dev_info(hdev, "bluetooth quality report is supported");
+	}
+
 	kfree_skb(skb);
 }
 
@@ -72,3 +82,90 @@ void aosp_do_close(struct hci_dev *hdev)
 
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

