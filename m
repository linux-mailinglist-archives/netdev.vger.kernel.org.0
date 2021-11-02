Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E4A442829
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 08:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhKBHWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 03:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbhKBHWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 03:22:11 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776C7C061714
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 00:19:35 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id y1so14601365plk.10
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 00:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=13hwNJhXlqX8JgwEFp5btGd3IwvyshzRtY7S25HF1qw=;
        b=BPhvzgTwlZ7Qm0RyfCGd9rZvJLsOUTM6VKeVo1esXSU+M5dLJx7kBKTpLV1k2/8+21
         OhHc6N36a9Nqr9SUV3dxmCldra070wcKEeAmmBrsAVhevWELaLMi2Ytb5h0mPXN6euWL
         wSH0CCJ5Ccc3PK9weYfwX7nFiftqo4RzjKTsk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=13hwNJhXlqX8JgwEFp5btGd3IwvyshzRtY7S25HF1qw=;
        b=LWnGVmc0Hynb5OQnXZvui0Ncgwn0/2V0X6NwurI4T24el7H06V7IWIeUr3KOoyYNo8
         IAZFQjl+uYrCigzL9alLFndPcNL/akiLtQuLKGDr+DVZoOk3fNLws7QtParmgYfT0reC
         CGQnB8iDFffe0+hNZuD44Zx4q7R7VBdm8f0Nh/qL/giyCwisnzsTQx5ISDjTFYpz07No
         XIdIP/Hq+vXSFMzZTV2DVel7XzZOIP0zFYqMQ3e1sjjDPdOaQdqcOg17EtXeBzbNKQny
         jPFtWLKv1g7r+scSsx2tY7byIAPS6hKXvstjfLcn7FJRGCOKLV6j9K8g4d5x8s0gmymJ
         tz/Q==
X-Gm-Message-State: AOAM531QzG1d6JbavGi0ELy0WI0dhWazI5LNeCx6oSgJh57M2U7IbfTc
        tJkaVzJChW8RGXaH755Edbs6mQ==
X-Google-Smtp-Source: ABdhPJwQBUfENhnIvKd37TimZ4NnOPVuIT54Tuf6+ai+5Z3rnRqReGJXsd3zQzQ7DfvfkENGreEpyA==
X-Received: by 2002:a17:90b:1bd2:: with SMTP id oa18mr4628798pjb.212.1635837575410;
        Tue, 02 Nov 2021 00:19:35 -0700 (PDT)
Received: from josephsih-z840.tpe.corp.google.com ([2401:fa00:1:10:df29:c6df:4e78:cf45])
        by smtp.gmail.com with ESMTPSA id b13sm7165243pfv.186.2021.11.02.00.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 00:19:34 -0700 (PDT)
From:   Joseph Hwang <josephsih@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, pali@kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org, josephsih@google.com,
        Joseph Hwang <josephsih@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v7 1/2] Bluetooth: Add struct of reading AOSP vendor capabilities
Date:   Tue,  2 Nov 2021 15:19:28 +0800
Message-Id: <20211102151908.v7.1.I139e71adfd3f00b88fe9edb63d013f9cd3e24506@changeid>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the struct of reading AOSP vendor capabilities.
New capabilities are added incrementally. Note that the
version_supported octets will be used to determine whether a
capability has been defined for the version.

Signed-off-by: Joseph Hwang <josephsih@chromium.org>

---

Changes in v7:
- Use the full struct aosp_rp_le_get_vendor_capa. If the
  version_supported is >= 98, check bluetooth_quality_report_support.
- Use __le16 and __le32.
- Use proper bt_dev_err and bt_dev_warn per review comments.
- Skip unnecessary bt_dev_dbg.
- Remove unnecessary rp->status check.
- Skip unnecessary check about version_supported on versions that we
  do not care about. For now, we only care about quality report support.
- Add the define for the length of the struct.
- Mediatek will submit a separate patch to enable aosp.

Changes in v6:
- Add historical versions of struct aosp_rp_le_get_vendor_capabilities.
- Perform the basic check about the struct length.
- Through the version, bluetooth_quality_report_support can be checked.

Changes in v5:
- This is a new patch.
- Add struct aosp_rp_le_get_vendor_capabilities so that next patch
  can determine whether a particular capability is supported or not.

 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/aosp.c             | 83 +++++++++++++++++++++++++++++++-
 2 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 53a8c7d3a4bf..b5f061882c10 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -603,6 +603,7 @@ struct hci_dev {
 
 #if IS_ENABLED(CONFIG_BT_AOSPEXT)
 	bool			aosp_capable;
+	bool			aosp_quality_report;
 #endif
 
 	int (*open)(struct hci_dev *hdev);
diff --git a/net/bluetooth/aosp.c b/net/bluetooth/aosp.c
index a1b7762335a5..0d4f1702ce35 100644
--- a/net/bluetooth/aosp.c
+++ b/net/bluetooth/aosp.c
@@ -8,9 +8,43 @@
 
 #include "aosp.h"
 
+/* Command complete parameters of LE_Get_Vendor_Capabilities_Command
+ * The parameters grow over time. The base version that declares the
+ * version_supported field is v0.95. Refer to
+ * https://cs.android.com/android/platform/superproject/+/master:system/
+ *         bt/gd/hci/controller.cc;l=452?q=le_get_vendor_capabilities_handler
+ */
+struct aosp_rp_le_get_vendor_capa {
+	/* v0.95: 15 octets */
+	__u8	status;
+	__u8	max_advt_instances;
+	__u8	offloaded_resolution_of_private_address;
+	__le16	total_scan_results_storage;
+	__u8	max_irk_list_sz;
+	__u8	filtering_support;
+	__u8	max_filter;
+	__u8	activity_energy_info_support;
+	__le16	version_supported;
+	__le16	total_num_of_advt_tracked;
+	__u8	extended_scan_support;
+	__u8	debug_logging_supported;
+	/* v0.96: 16 octets */
+	__u8	le_address_generation_offloading_support;
+	/* v0.98: 21 octets */
+	__le32	a2dp_source_offload_capability_mask;
+	__u8	bluetooth_quality_report_support;
+	/* v1.00: 25 octets */
+	__le32	dynamic_audio_buffer_support;
+} __packed;
+
+#define VENDOR_CAPA_BASE_SIZE		15
+#define VENDOR_CAPA_0_98_SIZE		21
+
 void aosp_do_open(struct hci_dev *hdev)
 {
 	struct sk_buff *skb;
+	struct aosp_rp_le_get_vendor_capa *rp;
+	u16 version_supported;
 
 	if (!hdev->aosp_capable)
 		return;
@@ -20,9 +54,56 @@ void aosp_do_open(struct hci_dev *hdev)
 	/* LE Get Vendor Capabilities Command */
 	skb = __hci_cmd_sync(hdev, hci_opcode_pack(0x3f, 0x153), 0, NULL,
 			     HCI_CMD_TIMEOUT);
-	if (IS_ERR(skb))
+	if (IS_ERR(skb)) {
+		bt_dev_err(hdev, "AOSP get vendor capabilities (%ld)",
+			   PTR_ERR(skb));
 		return;
+	}
+
+	/* A basic length check */
+	if (skb->len < VENDOR_CAPA_BASE_SIZE)
+		goto length_error;
+
+	rp = (struct aosp_rp_le_get_vendor_capa *)skb->data;
+
+	version_supported = le16_to_cpu(rp->version_supported);
+	/* AOSP displays the verion number like v0.98, v1.00, etc. */
+	bt_dev_info(hdev, "AOSP version v%u.%02u",
+		    version_supported >> 8, version_supported & 0xff);
+
+	/* Do not support very old versions. */
+	if (version_supported < 95) {
+		bt_dev_warn(hdev, "AOSP capabilities version %u too old",
+			    version_supported);
+		goto done;
+	}
+
+	if (version_supported >= 95 && version_supported < 98) {
+		bt_dev_warn(hdev, "AOSP quality report is not supported");
+		goto done;
+	}
+
+	if (version_supported >= 98) {
+		if (skb->len < VENDOR_CAPA_0_98_SIZE)
+			goto length_error;
+
+		/* The bluetooth_quality_report_support is defined at version
+		 * v0.98. Refer to
+		 * https://cs.android.com/android/platform/superproject/+/
+		 *         master:system/bt/gd/hci/controller.cc;l=477
+		 */
+		if (rp->bluetooth_quality_report_support) {
+			hdev->aosp_quality_report = true;
+			bt_dev_info(hdev, "AOSP quality report is supported");
+		}
+	}
+
+	goto done;
+
+length_error:
+	bt_dev_err(hdev, "AOSP capabilities length %d too short", skb->len);
 
+done:
 	kfree_skb(skb);
 }
 
-- 
2.33.1.1089.g2158813163f-goog

