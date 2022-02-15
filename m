Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F0A4B6DA2
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 14:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238312AbiBONfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 08:35:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238240AbiBONfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 08:35:54 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870AC106CAF
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 05:35:43 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso2825151pjt.4
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 05:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9MJIzY5l7AT5NNwAXwNp2tquSh+F6n6ZwluW0+d3AvQ=;
        b=DUpKlw9ezpaH8Ed7r9qGeoputCJwcaTlkhryolXoD7D+siGXKxvHeEWw0PAYZzWh0y
         5Rfe3jDdPOZnw91RbmaZEansH1K9OnKbcxqXLz83PJNp1K7hVR8F9o9tROX77C7tEMHP
         bOeSnLtyJcCb05PFgvj9+hIDe71aLOyqrWIOI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9MJIzY5l7AT5NNwAXwNp2tquSh+F6n6ZwluW0+d3AvQ=;
        b=DMK6fp3Sezv2Y4YVqivh/ROvnlnWaTTYrUWLb2FDeDbpXBWR+1hduqupJCD9vGwfxy
         CM3JKyTxgdUEjOoomChJyDqaCTwPakcXRP5MJ7LigW2Zovx1/GLwdvvYRFIZ9UwC2ocQ
         MB6aP9QmFbwtt8p7b4Dx55RtFTJMJLlSvUkXUdpDcz0Vx5jFd+/te9j+CsNg36Ca/sYG
         mHcnMCz/jGiqKvwpf/LIwbZgYbbtPYdXwWG56UO47fBMBLdpl4zEJX/nqZSPfOtLGxRU
         PnlFDDJ8GANbACjUr/J/Io+RsFACeWtVoJC5mzAJqywhDioM7UNEDbaOyKLKFWKFidJ2
         YKxQ==
X-Gm-Message-State: AOAM531f8owmSbQ1ZAji6N9wIw8JI/AUWWRny19j44kIe/k5D/AwGRrP
        yhtNvYCuBKkF4CGE8RIIhpKHug==
X-Google-Smtp-Source: ABdhPJzLS+VzHoIIOEKh2Vf9YgDphhOo1OWRvxuyjr8KoVC2aV+vbtGwQQW9p61s5++uSK/btQr2AA==
X-Received: by 2002:a17:90b:4d82:: with SMTP id oj2mr4369265pjb.133.1644932142968;
        Tue, 15 Feb 2022 05:35:42 -0800 (PST)
Received: from localhost (208.158.221.35.bc.googleusercontent.com. [35.221.158.208])
        by smtp.gmail.com with UTF8SMTPSA id m20sm41392961pfk.215.2022.02.15.05.35.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 05:35:42 -0800 (PST)
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
Subject: [PATCH v4 1/3] Bluetooth: aosp: surface AOSP quality report through mgmt
Date:   Tue, 15 Feb 2022 21:35:30 +0800
Message-Id: <20220215213519.v4.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

(no changes since v3)

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
index 3d26e6a3478b..83b602636262 100644
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
index 914e2f2d3586..5e48576041fb 100644
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
2.35.1.265.g69c8d7142f-goog

