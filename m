Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 961CB19E282
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 05:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgDDDbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 23:31:35 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45364 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgDDDbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 23:31:34 -0400
Received: by mail-pg1-f195.google.com with SMTP id o26so4555016pgc.12
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 20:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MywSYTxMvz+c+DUairYMPtaig3rFkiIAbKCB3sT2phA=;
        b=MHGvGKhd/3J77UtdPgNIETApL3dzQzcBrP4+ClU29FiyhzQGWkqMQ2fyFdPobh4n8B
         OWIFU93Xs/PhakQo1ImDMPDzhvqDczAxeV5X8bIgXA9TWURYs2FlAbsuTwRyAhsrnuda
         ed/+MaQqGiUOIGg2MkO0vArmsMuZHZXi5MVgw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MywSYTxMvz+c+DUairYMPtaig3rFkiIAbKCB3sT2phA=;
        b=VUbpV0rM0ag5hBw+SY0VrPmrzORcOY03fpGCUL2seDvrzSOUJYOTwOGkc02QXU/b/x
         UmWmuq8EtVbrNIcqPCbYnAHwo6bGNYDNIlaqMw9mN0qg1f/K7TRpxShIfuePJiDb/uWF
         3Xvv5v2qpYS2QqCsJrOKJV62idR+SXExDK65NN1aaNO5rpgXf84Q56HC6DWjs7QqwEIA
         93Nn4OJBKiLCQBPZHQWmYTVq3tX4i2RMyKO9jFrGzWUddsztFmDYYvZhA+LY/XwqqrMe
         99IOoR8D4a2mrrZ6R6nRX8tXWK1ISZBRoObilOTE984opDYwBIlPs/HmBueNtrRpbiqE
         8KYQ==
X-Gm-Message-State: AGi0PuZb5dSpjGSZ/yV7SVLrf9TqPRCOs/5xECnvRVeiJMpCPX7W60cT
        0hogGv+U6ltrY5SmG6jAHnSniQ==
X-Google-Smtp-Source: APiQypJnrT8PD4zx1fCAbpAQWk0eVDXKSGUaO+7XrXJbg/w5coyLj+brfkV67/V96dYJ4kjqrZrrOw==
X-Received: by 2002:a63:8c13:: with SMTP id m19mr10669543pgd.44.1585971092193;
        Fri, 03 Apr 2020 20:31:32 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id o184sm6800599pfg.149.2020.04.03.20.31.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Apr 2020 20:31:31 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Alain Michaud <alainm@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v5 2/3] Bluetooth: Read the supported features of Microsoft vendor extension
Date:   Fri,  3 Apr 2020 20:31:17 -0700
Message-Id: <20200403203058.v5.2.Ic59b637deef8e646f6599a80c9a2aa554f919e55@changeid>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200404033118.22135-1-mcchou@chromium.org>
References: <20200404033118.22135-1-mcchou@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This defines an opcode and packet structures of Microsoft vendor extension.
For now, we add only the HCI_VS_MSFT_Read_Supported_Features command. See
https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
microsoft-defined-bluetooth-hci-commands-and-events#microsoft-defined-
bluetooth-hci-events for more details.
Upon initialization of a hci_dev, we issue a
HCI_VS_MSFT_Read_Supported_Features command to read the supported features
of Microsoft vendor extension if the opcode of Microsoft vendor extension
is valid. See https://docs.microsoft.com/en-us/windows-hardware/drivers/
bluetooth/microsoft-defined-bluetooth-hci-commands-and-events#
hci_vs_msft_read_supported_features for more details.
This was verified on a device with Intel ThunderPeak BT controller where
the Microsoft vendor extension features are 0x000000000000003f.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
---

Changes in v5:
- Update the include line of msft.h.

Changes in v4:
- Move MSFT's do_open() and do_close() from net/bluetooth/hci_core.c to
net/bluetooth/msft.c.
- Other than msft opcode, define struct msft_data to host the rest of
information of Microsoft extension and leave a void* pointing to a
msft_data in struct hci_dev.

Changes in v3:
- Introduce msft_vnd_ext_do_open() and msft_vnd_ext_do_close().

Changes in v2:
- Issue a HCI_VS_MSFT_Read_Supported_Features command with
__hci_cmd_sync() instead of constructing a request.

 include/net/bluetooth/hci_core.h |   1 +
 include/net/bluetooth/msft.h     |   7 ++
 net/bluetooth/hci_core.c         |   5 ++
 net/bluetooth/hci_event.c        |   5 ++
 net/bluetooth/msft.c             | 125 +++++++++++++++++++++++++++++++
 5 files changed, 143 insertions(+)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 239cae2d99986..59ddcd3a52ccd 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -486,6 +486,7 @@ struct hci_dev {
 
 #if IS_ENABLED(CONFIG_BT_MSFTEXT)
 	__u16			msft_opcode;
+	void			*msft_data;
 #endif
 
 	int (*open)(struct hci_dev *hdev);
diff --git a/include/net/bluetooth/msft.h b/include/net/bluetooth/msft.h
index 7218ea759dde4..6cd5e6b3fb784 100644
--- a/include/net/bluetooth/msft.h
+++ b/include/net/bluetooth/msft.h
@@ -4,15 +4,22 @@
 #ifndef __MSFT_H
 #define __MSFT_H
 
+#include <linux/errno.h>
 #include <net/bluetooth/hci_core.h>
 
 #if IS_ENABLED(CONFIG_BT_MSFTEXT)
 
 void msft_set_opcode(struct hci_dev *hdev, __u16 opcode);
+void msft_do_open(struct hci_dev *hdev);
+void msft_do_close(struct hci_dev *hdev);
+void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb);
 
 #else
 
 static inline void msft_set_opcode(struct hci_dev *hdev, __u16 opcode) {}
+static inline void msft_do_open(struct hci_dev *hdev) {}
+static inline void msft_do_close(struct hci_dev *hdev) {}
+static inline void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb) {}
 
 #endif
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index dbd2ad3a26eda..738b20a731a79 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -39,6 +39,7 @@
 #include <net/bluetooth/hci_core.h>
 #include <net/bluetooth/l2cap.h>
 #include <net/bluetooth/mgmt.h>
+#include <net/bluetooth/msft.h>
 
 #include "hci_request.h"
 #include "hci_debugfs.h"
@@ -1563,6 +1564,8 @@ static int hci_dev_do_open(struct hci_dev *hdev)
 	    hci_dev_test_flag(hdev, HCI_VENDOR_DIAG) && hdev->set_diag)
 		ret = hdev->set_diag(hdev, true);
 
+	msft_do_open(hdev);
+
 	clear_bit(HCI_INIT, &hdev->flags);
 
 	if (!ret) {
@@ -1758,6 +1761,8 @@ int hci_dev_do_close(struct hci_dev *hdev)
 
 	hci_sock_dev_event(hdev, HCI_DEV_DOWN);
 
+	msft_do_close(hdev);
+
 	if (hdev->flush)
 		hdev->flush(hdev);
 
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 20408d3862683..da42e7f6bcef3 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -29,6 +29,7 @@
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
 #include <net/bluetooth/mgmt.h>
+#include <net/bluetooth/msft.h>
 
 #include "hci_request.h"
 #include "hci_debugfs.h"
@@ -6144,6 +6145,10 @@ void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
 		hci_num_comp_blocks_evt(hdev, skb);
 		break;
 
+	case HCI_EV_VENDOR:
+		msft_vendor_evt(hdev, skb);
+		break;
+
 	default:
 		BT_DBG("%s event 0x%2.2x", hdev->name, event);
 		break;
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 04dad4ac7bf78..b1f476ec3fcc5 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -5,6 +5,24 @@
 #include <net/bluetooth/hci_core.h>
 #include <net/bluetooth/msft.h>
 
+#define MSFT_OP_READ_SUPPORTED_FEATURES		0x00
+struct msft_cp_read_supported_features {
+	__u8   sub_opcode;
+} __packed;
+struct msft_rp_read_supported_features {
+	__u8   status;
+	__u8   sub_opcode;
+	__le64 features;
+	__u8   evt_prefix_len;
+	__u8   evt_prefix[0];
+} __packed;
+
+struct msft_data {
+	__u64 features;
+	__u8  evt_prefix_len;
+	__u8  *evt_prefix;
+};
+
 void msft_set_opcode(struct hci_dev *hdev, __u16 opcode)
 {
 	hdev->msft_opcode = opcode;
@@ -13,3 +31,110 @@ void msft_set_opcode(struct hci_dev *hdev, __u16 opcode)
 		    hdev->msft_opcode);
 }
 EXPORT_SYMBOL(msft_set_opcode);
+
+static struct msft_data *read_supported_features(struct hci_dev *hdev)
+{
+	struct msft_data *msft;
+	struct msft_cp_read_supported_features cp;
+	struct msft_rp_read_supported_features *rp;
+	struct sk_buff *skb;
+
+	cp.sub_opcode = MSFT_OP_READ_SUPPORTED_FEATURES;
+
+	skb = __hci_cmd_sync(hdev, hdev->msft_opcode, sizeof(cp), &cp,
+			     HCI_CMD_TIMEOUT);
+	if (IS_ERR(skb)) {
+		bt_dev_err(hdev, "Failed to read MSFT supported features (%ld)",
+			   PTR_ERR(skb));
+		return NULL;
+	}
+
+	if (skb->len < sizeof(*rp)) {
+		bt_dev_err(hdev, "MSFT supported features length mismatch");
+		goto failed;
+	}
+
+	rp = (struct msft_rp_read_supported_features *)skb->data;
+
+	if (rp->sub_opcode != MSFT_OP_READ_SUPPORTED_FEATURES)
+		goto failed;
+
+	msft = kzalloc(sizeof(*msft), GFP_KERNEL);
+	if (!msft)
+		goto failed;
+
+	if (rp->evt_prefix_len > 0) {
+		msft->evt_prefix = kmemdup(rp->evt_prefix, rp->evt_prefix_len,
+					   GFP_KERNEL);
+		if (!msft->evt_prefix)
+			goto failed;
+	}
+
+	msft->evt_prefix_len = rp->evt_prefix_len;
+	msft->features = __le64_to_cpu(rp->features);
+	kfree_skb(skb);
+
+	bt_dev_info(hdev, "MSFT supported features %llx", msft->features);
+	return msft;
+
+failed:
+	kfree_skb(skb);
+	return NULL;
+}
+
+void msft_do_open(struct hci_dev *hdev)
+{
+	if (hdev->msft_opcode == HCI_OP_NOP)
+		return;
+
+	bt_dev_dbg(hdev, "Initialize MSFT extension");
+	hdev->msft_data = read_supported_features(hdev);
+}
+
+void msft_do_close(struct hci_dev *hdev)
+{
+	struct msft_data *msft = hdev->msft_data;
+
+	if (!msft)
+		return;
+
+	bt_dev_dbg(hdev, "Cleanup of MSFT extension");
+
+	hdev->msft_data = NULL;
+
+	kfree(msft->evt_prefix);
+	kfree(msft);
+}
+
+void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	struct msft_data *msft = hdev->msft_data;
+	u8 event;
+
+	if (!msft)
+		return;
+
+	/* When the extension has defined an event prefix, check that it
+	 * matches, and otherwise just return.
+	 */
+	if (msft->evt_prefix_len > 0) {
+		if (skb->len < msft->evt_prefix_len)
+			return;
+
+		if (memcmp(skb->data, msft->evt_prefix, msft->evt_prefix_len))
+			return;
+
+		skb_pull(skb, msft->evt_prefix_len);
+	}
+
+	/* Every event starts at least with an event code and the rest of
+	 * the data is variable and depends on the event code. Returns true
+	 */
+	if (skb->len < 1)
+		return;
+
+	event = *skb->data;
+	skb_pull(skb, 1);
+
+	bt_dev_dbg(hdev, "MSFT vendor event %u", event);
+}
-- 
2.24.1

