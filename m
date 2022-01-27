Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50CA149DF00
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239057AbiA0KSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239014AbiA0KSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:18:05 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1348EC061747
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 02:18:05 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o64so2468857pjo.2
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 02:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QlVZGQ16szL2DWrQnv8fTtJQRx0l+wiE8AJ+x9gD1R4=;
        b=JKDZczn5ufXC2V1HiX4+FByhhjOvbwShdXF4NyGega5DYQkeZEmJOxbd6QoQVVfG/l
         tYzaxS/WIrpySAY+1fUzIrboFdTAJndMQHarnfAwhUUsxzV9/UPT11riVTA52mg4PKKt
         pz50S87Rc8g51MM/enxvn8jTUtu5ihzmUAB/w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QlVZGQ16szL2DWrQnv8fTtJQRx0l+wiE8AJ+x9gD1R4=;
        b=a+XOZHIdduej2wiwCJlRxsJFeUU5s/GKx6bAqCXFhk70DHLjYlOnANnHFQkB8GcZjs
         3byFL7q5Crp3OXJg0l9PozrS9mU5k61pTLcKOq3M4KHt5YlU1uC1+QdzyzGyB5M8w1ab
         ZaOev4movlb2cj+RJHeqeN5m+81fKurp1vpe8hUT4BgVcnJpW8+/db1mCm7Rb5qzbzr2
         Ewt/O3MaIxZFSno/UqdLUVnuUA+tZA/RfREztqqbY1SNE1klCQl+m98zPnPkpjZuaWHX
         e0QqSFBknov38UY9VzVIAa554TqCsDVer4LlMhla2n2lr4skANnCD2MyCQ7VifCDGB2P
         kZ4A==
X-Gm-Message-State: AOAM530DDRB8QdxuUabb13gn9Q56j7vbVgKKtstm4lQT6s4GR/MCQFD1
        61ZUq7k1SQYEbttKfgxCcPz5JQ==
X-Google-Smtp-Source: ABdhPJwR8mG8xcE2owI1DzsvtAduf8BlRfEaorWul4l2FmhW2vtJfpiz001orar1dqtv7hpapA2TSg==
X-Received: by 2002:a17:90a:de06:: with SMTP id m6mr13539406pjv.196.1643278684579;
        Thu, 27 Jan 2022 02:18:04 -0800 (PST)
Received: from localhost (174.71.80.34.bc.googleusercontent.com. [34.80.71.174])
        by smtp.gmail.com with UTF8SMTPSA id 14sm5663789pjh.45.2022.01.27.02.18.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 02:18:04 -0800 (PST)
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
Subject: [PATCH v2 1/2] Bluetooth: aosp: surface AOSP quality report through mgmt
Date:   Thu, 27 Jan 2022 18:17:58 +0800
Message-Id: <20220127181738.v2.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When receiving a HCI vendor event, the kernel checks if it is an
AOSP bluetooth quality report. If yes, the event is sent to bluez
user space through the mgmt socket.

Signed-off-by: Joseph Hwang <josephsih@chromium.org>
Reviewed-by: Archie Pusaka <apusaka@chromium.org>
---

Changes in v2:
- Scrap the two structures defined in aosp.c and use constants for
  size check.
- Do a basic size check about the quality report event. Do not pull
  data from the event in which the kernel has no interest.
- Define vendor event prefixes with which vendor events of distinct
  vendor specifications can be clearly differentiated.
- Use mgmt helpers to add the header and data to a mgmt skb.

 include/net/bluetooth/hci_core.h |  2 +
 include/net/bluetooth/mgmt.h     |  7 +++
 net/bluetooth/aosp.c             | 19 +++++++
 net/bluetooth/aosp.h             |  6 ++
 net/bluetooth/hci_event.c        | 96 +++++++++++++++++++++++++++++++-
 net/bluetooth/mgmt.c             | 19 +++++++
 net/bluetooth/msft.c             | 14 +++++
 net/bluetooth/msft.h             | 12 ++++
 8 files changed, 174 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 21eadb113a31..b726fd595895 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1861,6 +1861,8 @@ int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status);
 int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status);
 void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
 				  bdaddr_t *bdaddr, u8 addr_type);
+int mgmt_quality_report(struct hci_dev *hdev, void *data, u32 data_len,
+			u8 quality_spec);
 
 u8 hci_le_conn_update(struct hci_conn *conn, u16 min, u16 max, u16 latency,
 		      u16 to_multiplier);
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 99266f7aebdc..03204b4ba641 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -1120,3 +1120,10 @@ struct mgmt_ev_adv_monitor_device_lost {
 	__le16 monitor_handle;
 	struct mgmt_addr_info addr;
 } __packed;
+
+#define MGMT_EV_QUALITY_REPORT			0x0031
+struct mgmt_ev_quality_report {
+	__u8	quality_spec;
+	__u32	data_len;
+	__u8	data[];
+} __packed;
diff --git a/net/bluetooth/aosp.c b/net/bluetooth/aosp.c
index 432ae3aac9e3..9ec845a098bd 100644
--- a/net/bluetooth/aosp.c
+++ b/net/bluetooth/aosp.c
@@ -199,3 +199,22 @@ int aosp_set_quality_report(struct hci_dev *hdev, bool enable)
 	else
 		return disable_quality_report(hdev);
 }
+
+#define BLUETOOTH_QUALITY_REPORT_EV		0x58
+
+/* The following LEN = 1-byte Sub-event code + 48-byte Sub-event Parameters */
+#define BLUETOOTH_QUALITY_REPORT_LEN		49
+
+bool aosp_check_quality_report_len(struct sk_buff *skb)
+{
+	/* skb->len is allowed to be larger than BLUETOOTH_QUALITY_REPORT_LEN
+	 * to accommodate an additional Vendor Specific Parameter (vsp) field.
+	 */
+	if (skb->len < BLUETOOTH_QUALITY_REPORT_LEN) {
+		BT_ERR("AOSP evt data len %d too short (%u expected)",
+		       skb->len, BLUETOOTH_QUALITY_REPORT_LEN);
+		return false;
+	}
+
+	return true;
+}
diff --git a/net/bluetooth/aosp.h b/net/bluetooth/aosp.h
index 2fd8886d51b2..fdb6264b8ea7 100644
--- a/net/bluetooth/aosp.h
+++ b/net/bluetooth/aosp.h
@@ -10,6 +10,7 @@ void aosp_do_close(struct hci_dev *hdev);
 
 bool aosp_has_quality_report(struct hci_dev *hdev);
 int aosp_set_quality_report(struct hci_dev *hdev, bool enable);
+bool aosp_check_quality_report_len(struct sk_buff *skb);
 
 #else
 
@@ -26,4 +27,9 @@ static inline int aosp_set_quality_report(struct hci_dev *hdev, bool enable)
 	return -EOPNOTSUPP;
 }
 
+static inline bool aosp_check_quality_report_len(struct sk_buff *skb)
+{
+	return false;
+}
+
 #endif
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 681c623aa380..1b69d3efd415 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -37,6 +37,7 @@
 #include "smp.h"
 #include "msft.h"
 #include "eir.h"
+#include "aosp.h"
 
 #define ZERO_KEY "\x00\x00\x00\x00\x00\x00\x00\x00" \
 		 "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -4225,6 +4226,99 @@ static void hci_num_comp_blocks_evt(struct hci_dev *hdev, void *data,
 	queue_work(hdev->workqueue, &hdev->tx_work);
 }
 
+#define QUALITY_SPEC_NA			0x0
+#define QUALITY_SPEC_INTEL_TELEMETRY	0x1
+#define QUALITY_SPEC_AOSP_BQR		0x2
+
+static void aosp_quality_report_evt(struct hci_dev *hdev,  void *data,
+				    struct sk_buff *skb)
+{
+	if (aosp_has_quality_report(hdev) && aosp_check_quality_report_len(skb))
+		mgmt_quality_report(hdev, skb->data, skb->len,
+				    QUALITY_SPEC_AOSP_BQR);
+}
+
+/* Define the fixed vendor event prefixes below.
+ * Note: AOSP HCI Requirements use 0x54 and up as sub-event codes without
+ *       actually defining a vendor prefix. Refer to
+ *       https://source.android.com/devices/bluetooth/hci_requirements
+ *       Hence, the other vendor event prefixes should not use the same
+ *       space to avoid collision.
+ */
+static unsigned char AOSP_BQR_PREFIX[] = { 0x58 };
+
+/* Some vendor prefixes are fixed values and lengths. */
+#define FIXED_EVT_PREFIX(_prefix, _vendor_func)				\
+{									\
+	.prefix = _prefix,						\
+	.prefix_len = sizeof(_prefix),					\
+	.vendor_func = _vendor_func,					\
+	.get_prefix = NULL,						\
+	.get_prefix_len = NULL,						\
+}
+
+/* Some vendor prefixes are only available at run time. The
+ * values and lengths are variable.
+ */
+#define DYNAMIC_EVT_PREFIX(_prefix_func, _prefix_len_func, _vendor_func)\
+{									\
+	.prefix = NULL,							\
+	.prefix_len = 0,						\
+	.vendor_func = _vendor_func,					\
+	.get_prefix = _prefix_func,					\
+	.get_prefix_len = _prefix_len_func,				\
+}
+
+/* Every distinct vendor specification must have a well-defined vendor
+ * event prefix to determine if a vendor event meets the specification.
+ * If an event prefix is fixed, it should be delcared with FIXED_EVT_PREFIX.
+ * Otherwise, DYNAMIC_EVT_PREFIX should be used for variable prefixes.
+ */
+struct vendor_event_prefix {
+	__u8 *prefix;
+	__u8 prefix_len;
+	void (*vendor_func)(struct hci_dev *hdev, void *data,
+			    struct sk_buff *skb);
+	__u8 *(*get_prefix)(struct hci_dev *hdev);
+	__u8 (*get_prefix_len)(struct hci_dev *hdev);
+} evt_prefixes[] = {
+	FIXED_EVT_PREFIX(AOSP_BQR_PREFIX, aosp_quality_report_evt),
+	DYNAMIC_EVT_PREFIX(get_msft_evt_prefix, get_msft_evt_prefix_len,
+			   msft_vendor_evt),
+
+	/* end with a null entry */
+	{},
+};
+
+static void hci_vendor_evt(struct hci_dev *hdev, void *data,
+			   struct sk_buff *skb)
+{
+	int i;
+	__u8 *prefix;
+	__u8 prefix_len;
+
+	for (i = 0; evt_prefixes[i].vendor_func; i++) {
+		if (evt_prefixes[i].get_prefix)
+			prefix = evt_prefixes[i].get_prefix(hdev);
+		else
+			prefix = evt_prefixes[i].prefix;
+
+		if (evt_prefixes[i].get_prefix_len)
+			prefix_len = evt_prefixes[i].get_prefix_len(hdev);
+		else
+			prefix_len = evt_prefixes[i].prefix_len;
+
+		if (!prefix || prefix_len == 0)
+			continue;
+
+		/* Compare the raw prefix data directly. */
+		if (!memcmp(prefix, skb->data, prefix_len)) {
+			evt_prefixes[i].vendor_func(hdev, data, skb);
+			break;
+		}
+	}
+}
+
 static void hci_mode_change_evt(struct hci_dev *hdev, void *data,
 				struct sk_buff *skb)
 {
@@ -6811,7 +6905,7 @@ static const struct hci_ev {
 	HCI_EV(HCI_EV_NUM_COMP_BLOCKS, hci_num_comp_blocks_evt,
 	       sizeof(struct hci_ev_num_comp_blocks)),
 	/* [0xff = HCI_EV_VENDOR] */
-	HCI_EV(HCI_EV_VENDOR, msft_vendor_evt, 0),
+	HCI_EV(HCI_EV_VENDOR, hci_vendor_evt, 0),
 };
 
 static void hci_event_func(struct hci_dev *hdev, u8 event, struct sk_buff *skb,
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 08d6494f1b34..5388018cd738 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4389,6 +4389,25 @@ static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
 			       MGMT_STATUS_NOT_SUPPORTED);
 }
 
+int mgmt_quality_report(struct hci_dev *hdev, void *data, u32 data_len,
+			u8 quality_spec)
+{
+	struct mgmt_ev_quality_report *ev;
+	struct sk_buff *skb;
+
+	skb = mgmt_alloc_skb(hdev, MGMT_EV_QUALITY_REPORT,
+			     sizeof(*ev) + data_len);
+	if (!skb)
+		return -ENOMEM;
+
+	ev = skb_put(skb, sizeof(*ev));
+	ev->quality_spec = quality_spec;
+	ev->data_len = data_len;
+	skb_put_data(skb, data, data_len);
+
+	return mgmt_event_skb(skb, NULL);
+}
+
 static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 			    u16 data_len)
 {
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 484540855863..92fd7fca5889 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -729,6 +729,20 @@ static void msft_monitor_device_evt(struct hci_dev *hdev, struct sk_buff *skb)
 				 handle_data->mgmt_handle);
 }
 
+__u8 *get_msft_evt_prefix(struct hci_dev *hdev)
+{
+	struct msft_data *msft = hdev->msft_data;
+
+	return msft->evt_prefix;
+}
+
+__u8 get_msft_evt_prefix_len(struct hci_dev *hdev)
+{
+	struct msft_data *msft = hdev->msft_data;
+
+	return msft->evt_prefix_len;
+}
+
 void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *skb)
 {
 	struct msft_data *msft = hdev->msft_data;
diff --git a/net/bluetooth/msft.h b/net/bluetooth/msft.h
index afcaf7d3b1cb..a354ebf61fed 100644
--- a/net/bluetooth/msft.h
+++ b/net/bluetooth/msft.h
@@ -27,6 +27,8 @@ int msft_set_filter_enable(struct hci_dev *hdev, bool enable);
 int msft_suspend_sync(struct hci_dev *hdev);
 int msft_resume_sync(struct hci_dev *hdev);
 bool msft_curve_validity(struct hci_dev *hdev);
+__u8 *get_msft_evt_prefix(struct hci_dev *hdev);
+__u8 get_msft_evt_prefix_len(struct hci_dev *hdev);
 
 #else
 
@@ -77,4 +79,14 @@ static inline bool msft_curve_validity(struct hci_dev *hdev)
 	return false;
 }
 
+static inline __u8 *get_msft_evt_prefix(struct hci_dev *hdev)
+{
+	return NULL;
+}
+
+static inline __u8 get_msft_evt_prefix_len(struct hci_dev *hdev)
+{
+	return 0;
+}
+
 #endif
-- 
2.35.0.rc0.227.g00780c9af4-goog

