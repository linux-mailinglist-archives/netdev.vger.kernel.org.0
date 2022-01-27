Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A22F49DF03
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239020AbiA0KSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239037AbiA0KSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:18:09 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6537DC06173B
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 02:18:08 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 128so2188011pfe.12
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 02:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FzKXCu84v+MEBRiOOvHJliiiXM+odd7Ou4VdHsoBS50=;
        b=i890F8dpeDakBP+TSesc7zvw7eDIzB+Ahu3Bggz3XTamcTwnNJ6QHTJ1+28+9QJXSn
         WaA/UINWRBJWl0zlofaoJng1ENEyfHsbXcVWuWjmtHKKXUKPrDiC3oo6QsOBlJDeGfzL
         Njk/GKGd65QtZnJWbFeFdyAJxDlufiGEnvNQE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FzKXCu84v+MEBRiOOvHJliiiXM+odd7Ou4VdHsoBS50=;
        b=A8oAIf5xuKo4o5acgayy94K+wIdWsLGJvguyzoVUlXL+7n8jkajb//5HkPKQy4SBE0
         3nJMn41YuPM8WMyv/p5BL7db5WVsvNZ40togFN6DE8oJ7CxX7wL7zAhcJQLP+DIVGTnl
         eDzEbQClabNb6aIb+ou+W1tTSF6k3WoOVH7bokOjDMYRsvrfSUxNsEWaF+pS9URlcAAs
         qjYvbdsxzZgcBE10ZTfNdkMkb2Dkx2ItZ0Jz1a3m8xT0d0gJzQxU3NGGbjbi/f800Gll
         3NXLvBlt4MTTROgNBFoehIjL4U/FB3xiuWyMw2R3q5z3cn2HpirGTNduCNRbaSFytsCa
         R3Xw==
X-Gm-Message-State: AOAM533lMqwJV0PjVVS3HiCAeFgusgt82kFIjygLmfZj1nqzprNgv0Sb
        QdOcaDktqBqqEmcB3z+k+xdTnithRDgTjg==
X-Google-Smtp-Source: ABdhPJyjGTq81SFhiP75e7+lMYKha/nBvwGuNIXXii0gYvqWguKVrF/+6fdHh7S1C8mDUnXKqpYjBg==
X-Received: by 2002:a63:9:: with SMTP id 9mr2252152pga.101.1643278687945;
        Thu, 27 Jan 2022 02:18:07 -0800 (PST)
Received: from localhost (174.71.80.34.bc.googleusercontent.com. [34.80.71.174])
        by smtp.gmail.com with UTF8SMTPSA id k13sm4967022pff.25.2022.01.27.02.18.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 02:18:07 -0800 (PST)
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
Subject: [PATCH v2 2/2] Bluetooth: btintel: surface Intel telemetry events through mgmt
Date:   Thu, 27 Jan 2022 18:17:59 +0800
Message-Id: <20220127181738.v2.2.I63681490281b2392aa1ac05dff91a126394ab649@changeid>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
In-Reply-To: <20220127181738.v2.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
References: <20220127181738.v2.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When receiving a HCI vendor event, the kernel checks if it is an
Intel telemetry event. If yes, the event is sent to bluez user
space through the mgmt socket.

Signed-off-by: Joseph Hwang <josephsih@chromium.org>
Reviewed-by: Archie Pusaka <apusaka@chromium.org>
---

Changes in v2:
- Drop the pull_quality_report_data function from hci_dev.
  Do not bother hci_dev with it. Do not bleed the details
  into the core.

 drivers/bluetooth/btintel.c      | 27 ++++++++++++++++++++++++++-
 drivers/bluetooth/btintel.h      |  7 +++++++
 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_event.c        | 12 ++++++++++++
 4 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 1a4f8b227eac..9e1fdb68b669 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2401,8 +2401,9 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 	set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
 	set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
 
-	/* Set up the quality report callback for Intel devices */
+	/* Set up the quality report callbacks for Intel devices */
 	hdev->set_quality_report = btintel_set_quality_report;
+	hdev->is_quality_report_evt = btintel_is_quality_report_evt;
 
 	/* For Legacy device, check the HW platform value and size */
 	if (skb->len == sizeof(ver) && skb->data[1] == 0x37) {
@@ -2645,6 +2646,30 @@ void btintel_secure_send_result(struct hci_dev *hdev,
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
+bool btintel_is_quality_report_evt(struct sk_buff *skb)
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
+EXPORT_SYMBOL_GPL(btintel_is_quality_report_evt);
+
 MODULE_AUTHOR("Marcel Holtmann <marcel@holtmann.org>");
 MODULE_DESCRIPTION("Bluetooth support for Intel devices ver " VERSION);
 MODULE_VERSION(VERSION);
diff --git a/drivers/bluetooth/btintel.h b/drivers/bluetooth/btintel.h
index c9b24e9299e2..6dd4695b8b86 100644
--- a/drivers/bluetooth/btintel.h
+++ b/drivers/bluetooth/btintel.h
@@ -210,6 +210,7 @@ void btintel_bootup(struct hci_dev *hdev, const void *ptr, unsigned int len);
 void btintel_secure_send_result(struct hci_dev *hdev,
 				const void *ptr, unsigned int len);
 int btintel_set_quality_report(struct hci_dev *hdev, bool enable);
+bool btintel_is_quality_report_evt(struct sk_buff *skb);
 #else
 
 static inline int btintel_check_bdaddr(struct hci_dev *hdev)
@@ -305,4 +306,10 @@ static inline int btintel_set_quality_report(struct hci_dev *hdev, bool enable)
 {
 	return -ENODEV;
 }
+
+static inline bool btintel_is_quality_report_evt(struct sk_buff *skb)
+{
+	return false;
+}
+
 #endif
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index b726fd595895..9d855ac1cb29 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -632,6 +632,7 @@ struct hci_dev {
 	void (*cmd_timeout)(struct hci_dev *hdev);
 	bool (*wakeup)(struct hci_dev *hdev);
 	int (*set_quality_report)(struct hci_dev *hdev, bool enable);
+	bool (*is_quality_report_evt)(struct sk_buff *skb);
 	int (*get_data_path_id)(struct hci_dev *hdev, __u8 *data_path);
 	int (*get_codec_config_data)(struct hci_dev *hdev, __u8 type,
 				     struct bt_codec *codec, __u8 *vnd_len,
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 1b69d3efd415..892a48d2f6be 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4238,6 +4238,16 @@ static void aosp_quality_report_evt(struct hci_dev *hdev,  void *data,
 				    QUALITY_SPEC_AOSP_BQR);
 }
 
+static void intel_vendor_evt(struct hci_dev *hdev,  void *data,
+			     struct sk_buff *skb)
+{
+	/* Only interested in the telemetry event for now. */
+	if (hdev->set_quality_report &&
+	    hdev->is_quality_report_evt && hdev->is_quality_report_evt(skb))
+		mgmt_quality_report(hdev, skb->data, skb->len,
+				    QUALITY_SPEC_INTEL_TELEMETRY);
+}
+
 /* Define the fixed vendor event prefixes below.
  * Note: AOSP HCI Requirements use 0x54 and up as sub-event codes without
  *       actually defining a vendor prefix. Refer to
@@ -4246,6 +4256,7 @@ static void aosp_quality_report_evt(struct hci_dev *hdev,  void *data,
  *       space to avoid collision.
  */
 static unsigned char AOSP_BQR_PREFIX[] = { 0x58 };
+static unsigned char INTEL_PREFIX[] = { 0x87, 0x80 };
 
 /* Some vendor prefixes are fixed values and lengths. */
 #define FIXED_EVT_PREFIX(_prefix, _vendor_func)				\
@@ -4283,6 +4294,7 @@ struct vendor_event_prefix {
 	__u8 (*get_prefix_len)(struct hci_dev *hdev);
 } evt_prefixes[] = {
 	FIXED_EVT_PREFIX(AOSP_BQR_PREFIX, aosp_quality_report_evt),
+	FIXED_EVT_PREFIX(INTEL_PREFIX, intel_vendor_evt),
 	DYNAMIC_EVT_PREFIX(get_msft_evt_prefix, get_msft_evt_prefix_len,
 			   msft_vendor_evt),
 
-- 
2.35.0.rc0.227.g00780c9af4-goog

