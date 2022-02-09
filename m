Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE80D4AEDE7
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiBIJXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:23:20 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiBIJXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:23:18 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37976E0A81D0
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 01:23:14 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id h14-20020a17090a130e00b001b88991a305so4511921pja.3
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 01:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=glccOWeLTZJBzsf0ngcq0A1kqYNkjgHluSJNeEiU2LI=;
        b=HwVEVu11x4mbPXPpt4K0bUw4EaWMj21NxkEAi+xrvSiL8Xi9jG5bVCY3qQsyT/y7WE
         H5ZmqplePxuei+dI9z6oNgdx57w0F+9N62Q3nMA3V3IW0JF4LthkdaFlBqB/FesV7u0e
         yx4SROJMDDswqPlFTCSGSopdklW3PqPFIn5uU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=glccOWeLTZJBzsf0ngcq0A1kqYNkjgHluSJNeEiU2LI=;
        b=TjTsHHYmG6yQgfThkYI+SasQuxrSiWmNm2TfMr9wHttYYTDwZskRIcSuDwRFIWAdgU
         QmVKez5Z9WPiiffRjMkcAg2dwJz8Vsk5n37w9pf4FwP9yNt4uQYT1DcV8ODL7V/sgwMw
         g2XErCN7RDewNXGJMu91YOubhNL23VzVMycjX80BZdWDWq7/mlQwQAP9YkekZLJEFj0b
         X+wxqASNky3mlL1EG2rYQ67RMMT+FdLO2Wh1xGS1qTpFlzMTY+jN/F0xNAT4g9cRV881
         g6vEqgi80PJGiYwR0WfDljVWbFxgGjgWxu5PfJYLApeLWJluQ8azLJoxx6ZjoFQOyeWL
         P0/A==
X-Gm-Message-State: AOAM531Bb7jpLSKJo0Wr21mv6u4TjcEXo0aU+lUUXDbvIf35Lc3OsxaX
        e/qh74vysunbmx38DefSAWs8qA==
X-Google-Smtp-Source: ABdhPJzkh9MIs4IRStb6Mi9T7kvy9aoCrIKJwxnG9NepiNYVpGXLPxcHT30WZk+5th8mc4jMN9yooA==
X-Received: by 2002:a17:90a:1946:: with SMTP id 6mr1541751pjh.122.1644398588221;
        Wed, 09 Feb 2022 01:23:08 -0800 (PST)
Received: from localhost (174.71.80.34.bc.googleusercontent.com. [34.80.71.174])
        by smtp.gmail.com with UTF8SMTPSA id mj21sm5371091pjb.20.2022.02.09.01.23.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 01:23:07 -0800 (PST)
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
Subject: [PATCH v3 1/3] Bluetooth: aosp: surface AOSP quality report through mgmt
Date:   Wed,  9 Feb 2022 17:22:58 +0800
Message-Id: <20220209172233.v3.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When receiving a HCI vendor event, the kernel checks if it is an
AOSP bluetooth quality report. If yes, the event is sent to bluez
user space through the mgmt socket.

Signed-off-by: Joseph Hwang <josephsih@chromium.org>
Reviewed-by: Archie Pusaka <apusaka@chromium.org>
---

Changes in v3:
- Rebase to resolve the code conflict.
- Move aosp_quality_report_evt() from hci_event.c to aosp.c.
- A new patch (3/3) is added to enable the quality report feature.

Changes in v2:
- Scrap the two structures defined in aosp.c and use constants for
  size check.
- Do a basic size check about the quality report event. Do not pull
  data from the event in which the kernel has no interest.
- Define vendor event prefixes with which vendor events of distinct
  vendor specifications can be clearly differentiated.
- Use mgmt helpers to add the header and data to a mgmt skb.

 include/net/bluetooth/hci_core.h |  5 ++
 include/net/bluetooth/mgmt.h     |  7 +++
 net/bluetooth/aosp.c             | 27 ++++++++++
 net/bluetooth/aosp.h             | 13 +++++
 net/bluetooth/hci_event.c        | 84 +++++++++++++++++++++++++++++++-
 net/bluetooth/mgmt.c             | 20 ++++++++
 net/bluetooth/msft.c             | 14 ++++++
 net/bluetooth/msft.h             | 12 +++++
 8 files changed, 181 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index f5caff1ddb29..ea83619ac4de 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1864,6 +1864,8 @@ int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status);
 int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status);
 void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
 				  bdaddr_t *bdaddr, u8 addr_type);
+int mgmt_quality_report(struct hci_dev *hdev, void *data, u32 data_len,
+			u8 quality_spec);
 
 u8 hci_le_conn_update(struct hci_conn *conn, u16 min, u16 max, u16 latency,
 		      u16 to_multiplier);
@@ -1882,4 +1884,7 @@ void hci_copy_identity_address(struct hci_dev *hdev, bdaddr_t *bdaddr,
 
 #define TRANSPORT_TYPE_MAX	0x04
 
+#define QUALITY_SPEC_AOSP_BQR		0x0
+#define QUALITY_SPEC_INTEL_TELEMETRY	0x1
+
 #endif /* __HCI_CORE_H */
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
index 432ae3aac9e3..4a336433180d 100644
--- a/net/bluetooth/aosp.c
+++ b/net/bluetooth/aosp.c
@@ -199,3 +199,30 @@ int aosp_set_quality_report(struct hci_dev *hdev, bool enable)
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
+
+void aosp_quality_report_evt(struct hci_dev *hdev,  void *data,
+			     struct sk_buff *skb)
+{
+	if (aosp_has_quality_report(hdev) && aosp_check_quality_report_len(skb))
+		mgmt_quality_report(hdev, skb->data, skb->len,
+				    QUALITY_SPEC_AOSP_BQR);
+}
diff --git a/net/bluetooth/aosp.h b/net/bluetooth/aosp.h
index 2fd8886d51b2..b21751e012de 100644
--- a/net/bluetooth/aosp.h
+++ b/net/bluetooth/aosp.h
@@ -10,6 +10,9 @@ void aosp_do_close(struct hci_dev *hdev);
 
 bool aosp_has_quality_report(struct hci_dev *hdev);
 int aosp_set_quality_report(struct hci_dev *hdev, bool enable);
+bool aosp_check_quality_report_len(struct sk_buff *skb);
+void aosp_quality_report_evt(struct hci_dev *hdev,  void *data,
+			     struct sk_buff *skb);
 
 #else
 
@@ -26,4 +29,14 @@ static inline int aosp_set_quality_report(struct hci_dev *hdev, bool enable)
 	return -EOPNOTSUPP;
 }
 
+static inline bool aosp_check_quality_report_len(struct sk_buff *skb)
+{
+	return false;
+}
+
+static inline void aosp_quality_report_evt(struct hci_dev *hdev,  void *data,
+					   struct sk_buff *skb)
+{
+}
+
 #endif
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 63b925921c87..6468ea0f71bd 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -37,6 +37,7 @@
 #include "smp.h"
 #include "msft.h"
 #include "eir.h"
+#include "aosp.h"
 
 #define ZERO_KEY "\x00\x00\x00\x00\x00\x00\x00\x00" \
 		 "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -4241,6 +4242,87 @@ static void hci_num_comp_blocks_evt(struct hci_dev *hdev, void *data,
 	queue_work(hdev->workqueue, &hdev->tx_work);
 }
 
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
@@ -6844,7 +6926,7 @@ static const struct hci_ev {
 	HCI_EV(HCI_EV_NUM_COMP_BLOCKS, hci_num_comp_blocks_evt,
 	       sizeof(struct hci_ev_num_comp_blocks)),
 	/* [0xff = HCI_EV_VENDOR] */
-	HCI_EV_VL(HCI_EV_VENDOR, msft_vendor_evt, 0, HCI_MAX_EVENT_SIZE),
+	HCI_EV_VL(HCI_EV_VENDOR, hci_vendor_evt, 0, HCI_MAX_EVENT_SIZE),
 };
 
 static void hci_event_func(struct hci_dev *hdev, u8 event, struct sk_buff *skb,
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 08d6494f1b34..cab79f480a21 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4389,6 +4389,26 @@ static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
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
+EXPORT_SYMBOL(mgmt_quality_report);
+
 static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 			    u16 data_len)
 {
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 9a3d77d3ca86..3edf64baf479 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -731,6 +731,20 @@ static void msft_monitor_device_evt(struct hci_dev *hdev, struct sk_buff *skb)
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
2.35.0.263.gb82422642f-goog

