Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70582495E54
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 12:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380133AbiAULW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 06:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380132AbiAULWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 06:22:53 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB7EC061401
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 03:22:53 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id g11-20020a17090a7d0b00b001b2c12c7273so5735768pjl.0
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 03:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1ahMegGYTBxkOh/FQJXWBotaMUNdSqdUP2+0wlDcyRE=;
        b=CQjmabiYYZAPXUh0eYB4cwwRu489fiqLpRYqKvyBlLNgjDI5IxE1F1wYIKkXzEn9Z5
         1UCfcmwYbQ9tQgpLsXPKzsNHwdFwan4vlAg6sjrGPpxDeoSPqwg3IgNosqnrY5uumKlr
         DXx7g61KfrXp6ZufRkEfPr0bMAgoq0gjkI5aA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1ahMegGYTBxkOh/FQJXWBotaMUNdSqdUP2+0wlDcyRE=;
        b=L0uOh4uuzpPig38ptThdIgDzzfI8B3tXxSEaM6tRziCacppLj/E6h/XHD1Vm3fcG1H
         TzvByp5YgVojln4rp91wZwdTurOD7N3t2Bukvz7ApjVvysIqx4kC2tiNQEcKJzaIi2Hu
         jcj70anofF/0o54HFKcTAwlsFuJ5CH1vDg9/DPF6a1jchOIoCBgARwrSoZp1TAdf2ioC
         +yB4DTz9ib/itxNq3P/WEaQX6UrhOq9kwPLr1MenqkUhbHq63uiJUYrrX7o210DRj0hZ
         iAaV4vcVZceMS18iLg2HHXX2ZLZg80YBq9hBKbIDKnDX+8KaRlF9LXcYiaBnroCFYtkr
         tP4w==
X-Gm-Message-State: AOAM532fUj83t24/aa9Nlx6Jibi06A0kVETz/8sEm35E5PRqgxPTLEwL
        dFuXxYqsftFKJau8Q+0fMvdTdQ==
X-Google-Smtp-Source: ABdhPJxUddiEmQagrqggJqc3Zjm1gX0Na2FM4tszeZy/IEXp0nbs7hz1RFI0KY0I9UuOvGh7hxhmXw==
X-Received: by 2002:a17:90a:bd01:: with SMTP id y1mr292543pjr.33.1642764172959;
        Fri, 21 Jan 2022 03:22:52 -0800 (PST)
Received: from localhost (174.71.80.34.bc.googleusercontent.com. [34.80.71.174])
        by smtp.gmail.com with UTF8SMTPSA id e15sm2444529pjd.52.2022.01.21.03.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jan 2022 03:22:52 -0800 (PST)
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
Subject: [PATCH v1 2/2] Bluetooth: btintel: surface Intel telemetry events through mgmt
Date:   Fri, 21 Jan 2022 19:22:33 +0800
Message-Id: <20220121192152.v1.2.I63681490281b2392aa1ac05dff91a126394ab649@changeid>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
In-Reply-To: <20220121192152.v1.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
References: <20220121192152.v1.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
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

 drivers/bluetooth/btintel.c      | 43 +++++++++++++++++++++++++++++++-
 drivers/bluetooth/btintel.h      | 12 +++++++++
 include/net/bluetooth/hci_core.h |  2 ++
 net/bluetooth/hci_event.c        | 12 ++++++---
 4 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 1a4f8b227eac..d3b7a796cb91 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2401,8 +2401,10 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 	set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
 	set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
 
-	/* Set up the quality report callback for Intel devices */
+	/* Set up the quality report callbacks for Intel devices */
 	hdev->set_quality_report = btintel_set_quality_report;
+	hdev->is_quality_report_evt = btintel_is_quality_report_evt;
+	hdev->pull_quality_report_data = btintel_pull_quality_report_data;
 
 	/* For Legacy device, check the HW platform value and size */
 	if (skb->len == sizeof(ver) && skb->data[1] == 0x37) {
@@ -2645,6 +2647,45 @@ void btintel_secure_send_result(struct hci_dev *hdev,
 }
 EXPORT_SYMBOL_GPL(btintel_secure_send_result);
 
+#define INTEL_PREFIX		0x8087
+#define TELEMETRY_CODE		0x03
+
+struct intel_prefix_evt_data {
+	__le16 vendor_prefix;
+	__u8 code;
+	__u8 data[0];   /* a number of struct intel_tlv subevents */
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
+bool btintel_pull_quality_report_data(struct sk_buff *skb)
+{
+	skb_pull(skb, sizeof(struct intel_prefix_evt_data));
+
+	/* A telemetry event contains at least one intel_tlv subevent. */
+	if (skb->len < sizeof(struct intel_tlv)) {
+		BT_ERR("Telemetry event length %d too short (at least %u)",
+		       skb->len, sizeof(struct intel_tlv));
+		return false;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(btintel_pull_quality_report_data);
+
 MODULE_AUTHOR("Marcel Holtmann <marcel@holtmann.org>");
 MODULE_DESCRIPTION("Bluetooth support for Intel devices ver " VERSION);
 MODULE_VERSION(VERSION);
diff --git a/drivers/bluetooth/btintel.h b/drivers/bluetooth/btintel.h
index c9b24e9299e2..841aef3dbd4c 100644
--- a/drivers/bluetooth/btintel.h
+++ b/drivers/bluetooth/btintel.h
@@ -210,6 +210,8 @@ void btintel_bootup(struct hci_dev *hdev, const void *ptr, unsigned int len);
 void btintel_secure_send_result(struct hci_dev *hdev,
 				const void *ptr, unsigned int len);
 int btintel_set_quality_report(struct hci_dev *hdev, bool enable);
+bool btintel_is_quality_report_evt(struct sk_buff *skb);
+bool btintel_pull_quality_report_data(struct sk_buff *skb);
 #else
 
 static inline int btintel_check_bdaddr(struct hci_dev *hdev)
@@ -305,4 +307,14 @@ static inline int btintel_set_quality_report(struct hci_dev *hdev, bool enable)
 {
 	return -ENODEV;
 }
+
+static inline bool btintel_is_quality_report_evt(struct sk_buff *skb)
+{
+	return false;
+}
+
+static inline bool btintel_pull_quality_report_data(struct sk_buff *skb);
+{
+	return false;
+}
 #endif
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 727cb9c056b2..b74ba1585df9 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -632,6 +632,8 @@ struct hci_dev {
 	void (*cmd_timeout)(struct hci_dev *hdev);
 	bool (*wakeup)(struct hci_dev *hdev);
 	int (*set_quality_report)(struct hci_dev *hdev, bool enable);
+	bool (*is_quality_report_evt)(struct sk_buff *skb);
+	bool (*pull_quality_report_data)(struct sk_buff *skb);
 	int (*get_data_path_id)(struct hci_dev *hdev, __u8 *data_path);
 	int (*get_codec_config_data)(struct hci_dev *hdev, __u8 type,
 				     struct bt_codec *codec, __u8 *vnd_len,
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index bccb659a9454..5f9cc7b942a1 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4237,11 +4237,17 @@ static bool quality_report_evt(struct hci_dev *hdev,  void *data,
 		if (aosp_has_quality_report(hdev) &&
 		    aosp_pull_quality_report_data(skb))
 			mgmt_quality_report(hdev, skb, QUALITY_SPEC_AOSP_BQR);
-
-		return true;
+	} else if (hdev->is_quality_report_evt &&
+		   hdev->is_quality_report_evt(skb)) {
+		if (hdev->set_quality_report &&
+		    hdev->pull_quality_report_data(skb))
+			mgmt_quality_report(hdev, skb,
+					    QUALITY_SPEC_INTEL_TELEMETRY);
+	} else {
+		return false;
 	}
 
-	return false;
+	return true;
 }
 
 static void hci_vendor_evt(struct hci_dev *hdev, void *data,
-- 
2.35.0.rc0.227.g00780c9af4-goog

