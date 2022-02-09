Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850414AEDE6
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbiBIJXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:23:39 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbiBIJXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:23:37 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20EBE00E5A3
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 01:23:32 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id y5so3232548pfe.4
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 01:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qEfAUfSAkDgSMqeOfMNjmcPHeTC8mTixekghh3MVAhM=;
        b=W0d1uP6vAnj9FShyjUbrs8b8+LlzO+f1zowV74Gw8P1CniuzlVeHNOthlwOpsGfbSz
         XH0xFyKNbTysVA5VT33K86ffq5niw3BZjSJFaiIbnBJI9uZn7YXA6se148lMaOIMlVV3
         mEziEMQeSH2nk6FCPO47t5n33Xe0/u7zxGiiI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qEfAUfSAkDgSMqeOfMNjmcPHeTC8mTixekghh3MVAhM=;
        b=rxMcXf4d1cVyi0zoAe8FcdahwqLRxC0zSb4mTa2hEkmRldMWNumaYhUk39RjAA6vdZ
         J99BfXCpREreQWnZ3yM3bENOaYr4V/JUUDO9VHMi35DS78NvT5gV7VGxBb+V93g2WY0v
         N2oIZ29/4Y+F5I0H0axG8NCwScN7QyejM01lDcVnZy1q4gLlR3i8dIlHWiTBcxMV74zf
         fiV9Fm3GLDILPWlEnR7gYMiCaAUdg1N2S8OF3IsyPn+IHzHUXI/wzCvnXhPFGKnsjJrl
         PZr1R/qIJLtTr593FAOKxEZnVg3RN4xrdNntDbBbJWYIZugkpZekuhwOfIwuMNq8Yfxr
         9x7g==
X-Gm-Message-State: AOAM533zeCeFTxEQ22ZF5LezoDkEMVTfKRcq1KA0/TLmq+VwH5QrKDrf
        Sk9hB72Ey7dxUwK0YJqxYAfgFA==
X-Google-Smtp-Source: ABdhPJyy4g+jEipJLxokRRnr0JVc1Qds93rnhOlwC25swm2hmzM3VP2EWEh7tobVFDKjMSnMnDqQFw==
X-Received: by 2002:aa7:81c9:: with SMTP id c9mr1276352pfn.9.1644398591687;
        Wed, 09 Feb 2022 01:23:11 -0800 (PST)
Received: from localhost (174.71.80.34.bc.googleusercontent.com. [34.80.71.174])
        by smtp.gmail.com with UTF8SMTPSA id mn7sm5338358pjb.8.2022.02.09.01.23.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 01:23:11 -0800 (PST)
From:   Joseph Hwang <josephsih@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, pali@kernel.org
Cc:     josephsih@google.com, chromeos-bluetooth-upstreaming@chromium.org,
        Joseph Hwang <josephsih@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 2/3] Bluetooth: btintel: surface Intel telemetry events through mgmt
Date:   Wed,  9 Feb 2022 17:22:59 +0800
Message-Id: <20220209172233.v3.2.I63681490281b2392aa1ac05dff91a126394ab649@changeid>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220209172233.v3.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
References: <20220209172233.v3.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
2.35.0.263.gb82422642f-goog

