Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A1D4B6DA4
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 14:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238329AbiBONgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 08:36:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238328AbiBONf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 08:35:56 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F156C106CAF
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 05:35:46 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id i10so5489399plr.2
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 05:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5pLk2TtiVET/mS6ZsI1zq61AicplaTsASGX27V0i7pA=;
        b=TOYkrgg7lJgb5vHU3Se8S54lQ2+4qeDdNQXoguuZRBbzn3aMvIy1paiTDUYrdVDxxM
         wlc0SSFYU+IUydgX7REd3c01+ESnZSkQGjDdKVtLuaG4Lk27mUyjGmDvMR2kMGawj5cU
         /BAri+54hTOiuE741J9/AU6AnBTgfYAS+yjRo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5pLk2TtiVET/mS6ZsI1zq61AicplaTsASGX27V0i7pA=;
        b=XAF5NNe+A+vbWX97qNifOab4+2dSETdFrtV9Xldi/E7XQBIY/mixZxbTSG/BLPpTg0
         qnHAGfJf8rzXOJ28sCmO96LcpzWdjnIsGjOs2BYWdArDBgNOd88i1VcIg1w8rUh/cten
         JYhHI0mEqtIF8TA/iiv6LC8QNkYvMnNyC4wimDpJKqt833JP6GTQq/ddVI/w0KK/1el+
         tHkgwIFvsdVQLOFo/zp6RonFfSv1nOzgBsaK7fvv178Crp+FiA1zbdT2JqnaoLSI+ISx
         ANuQAYIVujFUlyw1/+gyQTM27lNrsW9thaNGuwNFXbMPhI4H48hfNSREOo4bQ2mrIacd
         Vdfg==
X-Gm-Message-State: AOAM530OnpW9gB5sDHZanQP5jm1JMKSnh5l8H4HnKXfsTd5IelKOEG8T
        ZSEUw8Y8trlMT9IrC6gzOgfG/w==
X-Google-Smtp-Source: ABdhPJw+O2tcswE3MmpizEK6bDamDlQUXC3F7DLbA5QLW/kYiwv8e7r6bdvzVGdm57JBksISAIGlIA==
X-Received: by 2002:a17:902:d4d2:: with SMTP id o18mr4380527plg.70.1644932146467;
        Tue, 15 Feb 2022 05:35:46 -0800 (PST)
Received: from localhost (208.158.221.35.bc.googleusercontent.com. [35.221.158.208])
        by smtp.gmail.com with UTF8SMTPSA id h5sm41531249pfi.111.2022.02.15.05.35.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 05:35:46 -0800 (PST)
From:   Joseph Hwang <josephsih@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, pali@kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org, josephsih@google.com,
        Joseph Hwang <josephsih@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 2/3] Bluetooth: btintel: surface Intel telemetry events through mgmt
Date:   Tue, 15 Feb 2022 21:35:31 +0800
Message-Id: <20220215213519.v4.2.I63681490281b2392aa1ac05dff91a126394ab649@changeid>
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

When receiving a HCI vendor event, the kernel checks if it is an
Intel telemetry event. If yes, the event is sent to bluez user
space through the mgmt socket.

Signed-off-by: Joseph Hwang <josephsih@chromium.org>
Reviewed-by: Archie Pusaka <apusaka@chromium.org>
---

(no changes since v3)

Changes in v3:
- Move intel_vendor_evt() from hci_event.c to the btintel driver.

Changes in v2:
- Drop the pull_quality_report_data function from hci_dev.
  Do not bother hci_dev with it. Do not bleed the details
  into the core.

 drivers/bluetooth/btintel.c      | 37 +++++++++++++++++++++++++++++++-
 drivers/bluetooth/btintel.h      |  7 ++++++
 include/net/bluetooth/hci_core.h |  2 ++
 net/bluetooth/hci_event.c        | 12 +++++++++++
 4 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 06514ed66022..c7732da2752f 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2401,9 +2401,12 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 	set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
 	set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
 
-	/* Set up the quality report callback for Intel devices */
+	/* Set up the quality report callbacks for Intel devices */
 	hdev->set_quality_report = btintel_set_quality_report;
 
+	/* Set up the vendor specific callback for Intel devices */
+	hdev->vendor_evt = btintel_vendor_evt;
+
 	/* For Legacy device, check the HW platform value and size */
 	if (skb->len == sizeof(ver) && skb->data[1] == 0x37) {
 		bt_dev_dbg(hdev, "Read the legacy Intel version information");
@@ -2650,6 +2653,38 @@ void btintel_secure_send_result(struct hci_dev *hdev,
 }
 EXPORT_SYMBOL_GPL(btintel_secure_send_result);
 
+#define INTEL_PREFIX		0x8087
+#define TELEMETRY_CODE		0x03
+
+struct intel_prefix_evt_data {
+	__le16 vendor_prefix;
+	__u8 code;
+	__u8 data[];   /* a number of struct intel_tlv subevents */
+} __packed;
+
+static bool is_quality_report_evt(struct sk_buff *skb)
+{
+	struct intel_prefix_evt_data *ev;
+	u16 vendor_prefix;
+
+	if (skb->len < sizeof(struct intel_prefix_evt_data))
+		return false;
+
+	ev = (struct intel_prefix_evt_data *)skb->data;
+	vendor_prefix = __le16_to_cpu(ev->vendor_prefix);
+
+	return vendor_prefix == INTEL_PREFIX && ev->code == TELEMETRY_CODE;
+}
+
+void btintel_vendor_evt(struct hci_dev *hdev,  void *data, struct sk_buff *skb)
+{
+	/* Only interested in the telemetry event for now. */
+	if (hdev->set_quality_report && is_quality_report_evt(skb))
+		mgmt_quality_report(hdev, skb->data, skb->len,
+				    QUALITY_SPEC_INTEL_TELEMETRY);
+}
+EXPORT_SYMBOL_GPL(btintel_vendor_evt);
+
 MODULE_AUTHOR("Marcel Holtmann <marcel@holtmann.org>");
 MODULE_DESCRIPTION("Bluetooth support for Intel devices ver " VERSION);
 MODULE_VERSION(VERSION);
diff --git a/drivers/bluetooth/btintel.h b/drivers/bluetooth/btintel.h
index e0060e58573c..82dc278b09eb 100644
--- a/drivers/bluetooth/btintel.h
+++ b/drivers/bluetooth/btintel.h
@@ -211,6 +211,7 @@ void btintel_bootup(struct hci_dev *hdev, const void *ptr, unsigned int len);
 void btintel_secure_send_result(struct hci_dev *hdev,
 				const void *ptr, unsigned int len);
 int btintel_set_quality_report(struct hci_dev *hdev, bool enable);
+void btintel_vendor_evt(struct hci_dev *hdev,  void *data, struct sk_buff *skb);
 #else
 
 static inline int btintel_check_bdaddr(struct hci_dev *hdev)
@@ -306,4 +307,10 @@ static inline int btintel_set_quality_report(struct hci_dev *hdev, bool enable)
 {
 	return -ENODEV;
 }
+
+static inline void btintel_vendor_evt(struct hci_dev *hdev,  void *data,
+				      struct sk_buff *skb)
+{
+}
+
 #endif
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index ea83619ac4de..3505ffe20779 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -635,6 +635,8 @@ struct hci_dev {
 	void (*cmd_timeout)(struct hci_dev *hdev);
 	bool (*wakeup)(struct hci_dev *hdev);
 	int (*set_quality_report)(struct hci_dev *hdev, bool enable);
+	void (*vendor_evt)(struct hci_dev *hdev, void *data,
+			   struct sk_buff *skb);
 	int (*get_data_path_id)(struct hci_dev *hdev, __u8 *data_path);
 	int (*get_codec_config_data)(struct hci_dev *hdev, __u8 type,
 				     struct bt_codec *codec, __u8 *vnd_len,
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 6468ea0f71bd..e34dea0f0c2e 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4250,6 +4250,7 @@ static void hci_num_comp_blocks_evt(struct hci_dev *hdev, void *data,
  *       space to avoid collision.
  */
 static unsigned char AOSP_BQR_PREFIX[] = { 0x58 };
+static unsigned char INTEL_PREFIX[] = { 0x87, 0x80 };
 
 /* Some vendor prefixes are fixed values and lengths. */
 #define FIXED_EVT_PREFIX(_prefix, _vendor_func)				\
@@ -4273,6 +4274,16 @@ static unsigned char AOSP_BQR_PREFIX[] = { 0x58 };
 	.get_prefix_len = _prefix_len_func,				\
 }
 
+/* Every vendor that handles particular vendor events in its driver should
+ * 1. set up the vendor_evt callback in its driver and
+ * 2. add an entry in struct vendor_event_prefix.
+ */
+static void vendor_evt(struct hci_dev *hdev,  void *data, struct sk_buff *skb)
+{
+	if (hdev->vendor_evt)
+		hdev->vendor_evt(hdev, data, skb);
+}
+
 /* Every distinct vendor specification must have a well-defined vendor
  * event prefix to determine if a vendor event meets the specification.
  * If an event prefix is fixed, it should be delcared with FIXED_EVT_PREFIX.
@@ -4287,6 +4298,7 @@ struct vendor_event_prefix {
 	__u8 (*get_prefix_len)(struct hci_dev *hdev);
 } evt_prefixes[] = {
 	FIXED_EVT_PREFIX(AOSP_BQR_PREFIX, aosp_quality_report_evt),
+	FIXED_EVT_PREFIX(INTEL_PREFIX, vendor_evt),
 	DYNAMIC_EVT_PREFIX(get_msft_evt_prefix, get_msft_evt_prefix_len,
 			   msft_vendor_evt),
 
-- 
2.35.1.265.g69c8d7142f-goog

