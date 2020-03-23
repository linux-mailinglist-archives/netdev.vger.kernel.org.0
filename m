Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA5F18F040
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 08:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgCWH2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 03:28:39 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:37850 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727446AbgCWH2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 03:28:39 -0400
Received: by mail-pj1-f68.google.com with SMTP id o12so1940016pjs.2
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 00:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=peUcUJiWwH+jNWHv1XJjZ5RdsEPMfqXUmHLM2UZ+oGY=;
        b=gLnDgnE5axXZulHjrMwIKcMzI2z0jYs+ovG+RkBPPaHMnfDz8hyi3Ug3TYUXvOf2sk
         Jjxp3JN+gfykwgJp2859+PEUvlNywm/0Enznrra+RS20S2Ds08PykqxaT+Dv7sHcKIbU
         EHNelb/RxLV9ouR3oKbMbll6l1lkRM4G6M9SY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=peUcUJiWwH+jNWHv1XJjZ5RdsEPMfqXUmHLM2UZ+oGY=;
        b=CUQfj63eukruky6Jwbbu60/C16cTg1Q4eurmR+u1D9sJ37ibohnjpIWiEGEU5rNkm6
         6lhDZJEGCY/+VEnh48Qln8hQsZxp9cngITeN4e9yJJmOCjduZsCMyiHZm+vvX/jtZfoZ
         W/Vh2wqTS3wT3d0jPAA42yyxkWRB7CEXEzu3/om2F4KEL2BwOvu3MB7h4ZCgWy5pYtGu
         pR+NozBVdywERod09rzq+QqJGq+3HLrwJf8jhd/5nTzPbpit8WkiKWk2fHOfVSGX7hgp
         aBUaMzBAJBfUpGy1kPliEluJN1FOr+r9b6T/maSb5EEa4d3BWU0TnRuxLC4bKoBWAw+Q
         U2Rw==
X-Gm-Message-State: ANhLgQ0gSBUPyfRRS8BzDHZMkPRrxRS0qHeyhwR8xlqguukTWjjyAjFd
        zdbY+ns90KaBp+zYLQlFTgdB7Q==
X-Google-Smtp-Source: ADFU+vszQGhcp0OVnTmSb6ygcIVoxVz2AgsuoSKFCu6oASGs31eM2dg7Mt8vmMSGsH30Zai6ahgG5g==
X-Received: by 2002:a17:902:a588:: with SMTP id az8mr20125265plb.163.1584948518415;
        Mon, 23 Mar 2020 00:28:38 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id z16sm12645399pfr.138.2020.03.23.00.28.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Mar 2020 00:28:37 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Alain Michaud <alainm@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 2/2] Bluetooth: btusb: Read the supported features of Microsoft vendor extension
Date:   Mon, 23 Mar 2020 00:28:24 -0700
Message-Id: <20200323002820.v1.2.I4e01733fa5b818028dc9188ca91438fc54aa5028@changeid>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200323072824.254495-1-mcchou@chromium.org>
References: <20200323072824.254495-1-mcchou@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a new header to facilitate the opcode and packet structures of
vendor extension(s). For now, we add only the
HCI_VS_MSFT_Read_Supported_Features command from Microsoft vendor
extension. See https://docs.microsoft.com/en-us/windows-hardware/drivers/
bluetooth/microsoft-defined-bluetooth-hci-commands-and-events#
microsoft-defined-bluetooth-hci-events for more details.
Upon initialization of a hci_dev, we issue a
HCI_VS_MSFT_Read_Supported_Features command to read the supported features
of Microsoft vendor extension if the opcode of Microsoft vendor extension
is valid. See https://docs.microsoft.com/en-us/windows-hardware/drivers/
bluetooth/microsoft-defined-bluetooth-hci-commands-and-events#
hci_vs_msft_read_supported_features for more details.
This was verified on a device with Intel ThhunderPeak BT controller where
the Microsoft vendor extension features are 0x000000000000003f.

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
---

Changes in v1:
- Add vendor_hci.h to facilitate opcodes and packet structures of vendor
extension(s).
- Add opcode for the HCI_VS_MSFT_Read_Supported_Features command from
Microsoft vendor extension.
- Issue a HCI_VS_MSFT_Read_Supported_Features command upon
hci_dev_do_open and save the return values.

 include/net/bluetooth/hci_core.h   |  1 +
 include/net/bluetooth/vendor_hci.h | 51 ++++++++++++++++++++++++++++++
 net/bluetooth/hci_core.c           | 30 ++++++++++++++++++
 net/bluetooth/hci_event.c          | 49 +++++++++++++++++++++++++++-
 4 files changed, 130 insertions(+), 1 deletion(-)
 create mode 100644 include/net/bluetooth/vendor_hci.h

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 15daf3b2d4f0..941e71bdad42 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -30,6 +30,7 @@
 
 #include <net/bluetooth/hci.h>
 #include <net/bluetooth/hci_sock.h>
+#include <net/bluetooth/vendor_hci.h>
 
 /* HCI priority */
 #define HCI_PRIO_MAX	7
diff --git a/include/net/bluetooth/vendor_hci.h b/include/net/bluetooth/vendor_hci.h
new file mode 100644
index 000000000000..bd374a7bf976
--- /dev/null
+++ b/include/net/bluetooth/vendor_hci.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * BlueZ - Bluetooth protocol stack for Linux
+ * Copyright (C) 2020 Google Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation;
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
+ * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS.
+ * IN NO EVENT SHALL THE COPYRIGHT HOLDER(S) AND AUTHOR(S) BE LIABLE FOR ANY
+ * CLAIM, OR ANY SPECIAL INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ *
+ * ALL LIABILITY, INCLUDING LIABILITY FOR INFRINGEMENT OF ANY PATENTS,
+ * COPYRIGHTS, TRADEMARKS OR OTHER RIGHTS, RELATING TO USE OF THIS
+ * SOFTWARE IS DISCLAIMED.
+ */
+
+#ifndef __VENDOR_HCI_H
+#define __VENDOR_HCI_H
+
+#define MSFT_EVT_PREFIX_MAX_LEN				255
+
+struct msft_cmd_cmp_info {
+	__u8 status;
+	__u8 sub_opcode;
+} __packed;
+
+/* Microsoft Vendor HCI subcommands */
+#define MSFT_OP_READ_SUPPORTED_FEATURES			0x00
+#define MSFT_FEATURE_MASK_RSSI_MONITOR_BREDR_CONN	0x0000000000000001
+#define MSFT_FEATURE_MASK_RSSI_MONITOR_LE_CONN		0x0000000000000002
+#define MSFT_FEATURE_MASK_RSSI_MONITOR_LE_ADV		0x0000000000000004
+#define MSFT_FEATURE_MASK_ADV_MONITOR_LE_ADV		0x0000000000000008
+#define MSFT_FEATURE_MASK_VERIFY_CURVE_			0x0000000000000010
+#define MSFT_FEATURE_MASK_CONCURRENT_ADV_MONITOR	0x0000000000000020
+struct msft_cp_read_supported_features {
+	__u8 sub_opcode;
+} __packed;
+struct msft_rp_read_supported_features {
+	__u64 features;
+	__u8  msft_evt_prefix_len;
+	__u8  msft_evt_prefix[0];
+} __packed;
+
+#endif /* __VENDOR_HCI_H */
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index dbd2ad3a26ed..3cec58ca0047 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1407,6 +1407,32 @@ static void hci_dev_get_bd_addr_from_property(struct hci_dev *hdev)
 	bacpy(&hdev->public_addr, &ba);
 }
 
+static int hci_msft_read_supported_features_req(struct hci_request *req,
+						unsigned long opt)
+{
+	struct hci_dev *hdev = req->hdev;
+	struct msft_cp_read_supported_features cp;
+
+	if (hdev->msft_vnd_ext_opcode == HCI_OP_NOP)
+		return -EOPNOTSUPP;
+
+	cp.sub_opcode = MSFT_OP_READ_SUPPORTED_FEATURES;
+	hci_req_add(req, hdev->msft_vnd_ext_opcode, sizeof(cp), &cp);
+	return 0;
+}
+
+static void read_vendor_extension_features(struct hci_dev *hdev)
+{
+	int err;
+
+	if (hdev->msft_vnd_ext_opcode !=  HCI_OP_NOP) {
+		err = __hci_req_sync(hdev, hci_msft_read_supported_features_req,
+				     0, HCI_CMD_TIMEOUT, NULL);
+		if (err)
+			BT_ERR("HCI_VS_MSFT_Read_Supported_Feature failed");
+	}
+}
+
 static int hci_dev_do_open(struct hci_dev *hdev)
 {
 	int ret = 0;
@@ -1572,6 +1598,10 @@ static int hci_dev_do_open(struct hci_dev *hdev)
 		set_bit(HCI_UP, &hdev->flags);
 		hci_sock_dev_event(hdev, HCI_DEV_UP);
 		hci_leds_update_powered(hdev, true);
+
+		/* Check features supported by HCI extensions. */
+		read_vendor_extension_features(hdev);
+
 		if (!hci_dev_test_flag(hdev, HCI_SETUP) &&
 		    !hci_dev_test_flag(hdev, HCI_CONFIG) &&
 		    !hci_dev_test_flag(hdev, HCI_UNCONFIGURED) &&
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 20408d386268..6a156167dfc9 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -23,7 +23,6 @@
 */
 
 /* Bluetooth HCI event handling. */
-
 #include <asm/unaligned.h>
 
 #include <net/bluetooth/bluetooth.h>
@@ -1787,6 +1786,47 @@ static void hci_cc_write_ssp_debug_mode(struct hci_dev *hdev, struct sk_buff *sk
 		hdev->ssp_debug_mode = *mode;
 }
 
+static void hci_cc_msft_vnd_ext(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	struct msft_cmd_cmp_info *info = (void *)skb->data;
+	const u8 status = info->status;
+	const u16 sub_opcode = __le16_to_cpu(info->sub_opcode);
+
+	skb_pull(skb, sizeof(*info));
+
+	if (status) {
+		BT_ERR("Microsoft vendor extension sub command 0x%2.2x failed",
+		       sub_opcode);
+		return;
+	}
+
+	BT_DBG("%s status 0x%2.2x sub opcode 0x%2.2x", hdev->name, status,
+	       sub_opcode);
+
+	switch (sub_opcode) {
+	case MSFT_OP_READ_SUPPORTED_FEATURES: {
+		struct msft_rp_read_supported_features *rp = (void *)skb->data;
+
+		hdev->msft_vnd_ext_features = __le64_to_cpu(rp->features);
+		hdev->msft_vnd_ext_evt_prefix_len = rp->msft_evt_prefix_len;
+		hdev->msft_vnd_ext_evt_prefix =
+			kmalloc(hdev->msft_vnd_ext_evt_prefix_len, GFP_ATOMIC);
+		if (!hdev->msft_vnd_ext_evt_prefix)
+			return;
+
+		memcpy(hdev->msft_vnd_ext_evt_prefix, rp->msft_evt_prefix,
+		       hdev->msft_vnd_ext_evt_prefix_len);
+		BT_DBG("%s Microsoft vendor extension features 0x%016llx",
+		       hdev->name, hdev->msft_vnd_ext_features);
+		break;
+	}
+	default:
+		BT_ERR("%s unknown sub opcode 0x%2.2x", hdev->name,
+		       sub_opcode);
+		break;
+	}
+}
+
 static void hci_cs_inquiry(struct hci_dev *hdev, __u8 status)
 {
 	BT_DBG("%s status 0x%2.2x", hdev->name, status);
@@ -3198,6 +3238,7 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
 				 hci_req_complete_skb_t *req_complete_skb)
 {
 	struct hci_ev_cmd_complete *ev = (void *) skb->data;
+	const u16 msft_vnd_ext_opcode = hdev->msft_vnd_ext_opcode;
 
 	*opcode = __le16_to_cpu(ev->opcode);
 	*status = skb->data[sizeof(*ev)];
@@ -3538,6 +3579,12 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
 		break;
 
 	default:
+		/* Check if it's a Microsoft vendor extension opcode. */
+		if (msft_vnd_ext_opcode != HCI_OP_NOP &&
+		    *opcode == msft_vnd_ext_opcode) {
+			hci_cc_msft_vnd_ext(hdev, skb);
+			break;
+		}
 		BT_DBG("%s opcode 0x%4.4x", hdev->name, *opcode);
 		break;
 	}
-- 
2.24.1

