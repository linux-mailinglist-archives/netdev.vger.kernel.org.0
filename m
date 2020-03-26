Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E06A7193A17
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 08:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgCZH7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 03:59:55 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:51504 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbgCZH7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 03:59:52 -0400
Received: by mail-pj1-f65.google.com with SMTP id w9so2123618pjh.1
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 00:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d3vBOF1WIUmdx5diIlqq5HiBjmrSSvAByjzTDruCL+A=;
        b=NapyBqTnh4Jhz4C8q6SrjI4PczVGvEBdAwIbyz6kSqc71aRDwcC5mrYiDYHVIGFFak
         gKP3ttl50ZKni+ffkOxAqMdnE8wC5ZGB4nThKQSJmjZCPH1y8XTNjp+aCmx87jv7HI2o
         Gz+PlXmqmZUh5NB+QXMflLET79ZfnlessY6Bs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d3vBOF1WIUmdx5diIlqq5HiBjmrSSvAByjzTDruCL+A=;
        b=W+CU7n/NkRJd0nW8SOP5vr2fI8eBHWZ7UfZGdHTaT3csdlaL2NOkGE35hCPOQzFsg5
         FCOE82+4v8hwsyBC9+PgserMQSkCm28tmBUKzCKcIunyutfxQENIN7ENXGjl7FKwWiMX
         VBfL6w22UlxVgOtQuvR4Tj/iy5ziDU6qQ7dgJ0rtr3M0d8m8pwIfVbHyyHeQnIon9j4a
         xINs9RnBHD/IPxLFQOvlPLLHh/H0Y6ypaPgMDf2q0Ps9yPl0W49wDEUHFGrJHsadicqV
         1Sw8IlcLwqJMJBReyHDAeZ8TAUARRMUmHSBMKRFyIFrm3b3Q/hIoHvDbU6hbcqgQUwIM
         xXkg==
X-Gm-Message-State: ANhLgQ1oSIfPhM21Wb5ISmydZeH5c6KIzmh7XTamWURtCjwO696faPHr
        ZQ3igRQ6VuOQWn4fV1iyAAbuJw==
X-Google-Smtp-Source: ADFU+vuELIYqUH6/PfhgFASn/9qiCLg/598xvv/TNS46XAS8vE0QYYoJQuqG0JmKPiP2kMaEitu8rw==
X-Received: by 2002:a17:90a:a102:: with SMTP id s2mr1746406pjp.46.1585209590821;
        Thu, 26 Mar 2020 00:59:50 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id 8sm1036476pfv.65.2020.03.26.00.59.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Mar 2020 00:59:50 -0700 (PDT)
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
Subject: [PATCH v3 2/2] Bluetooth: btusb: Read the supported features of Microsoft vendor extension
Date:   Thu, 26 Mar 2020 00:59:38 -0700
Message-Id: <20200326005931.v3.2.I4e01733fa5b818028dc9188ca91438fc54aa5028@changeid>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200326075938.65053-1-mcchou@chromium.org>
References: <20200326075938.65053-1-mcchou@chromium.org>
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
This was verified on a device with Intel ThunderPeak BT controller where
the Microsoft vendor extension features are 0x000000000000003f.

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
---

Changes in v3:
- Introduce msft_vnd_ext_do_open() and msft_vnd_ext_do_close().

 net/bluetooth/hci_core.c | 95 ++++++++++++++++++++++++++++++++++++++++
 net/bluetooth/msft.c     | 27 ++++++++++++
 2 files changed, 122 insertions(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 286294540bed..1062692e8612 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1408,6 +1408,87 @@ static void hci_dev_get_bd_addr_from_property(struct hci_dev *hdev)
 	bacpy(&hdev->public_addr, &ba);
 }
 
+static void process_msft_vnd_ext_cmd_complete(struct hci_dev *hdev,
+					       struct sk_buff *skb)
+{
+	struct msft_cmd_cmp_info *info = (void *)skb->data;
+	struct msft_vnd_ext *msft_ext = (struct msft_vnd_ext *)hdev->msft_ext;
+	const u8 status = info->status;
+	const u16 sub_opcode = __le16_to_cpu(info->sub_opcode);
+
+	skb_pull(skb, sizeof(*info));
+
+	if (IS_ERR(skb)) {
+		bt_dev_warn(hdev, "Microsoft extension response packet invalid");
+		return;
+	}
+
+	if (status) {
+		bt_dev_warn(hdev, "Microsoft extension sub command 0x%2.2x failed",
+			    sub_opcode);
+		return;
+	}
+
+	bt_dev_dbg(hdev, "status 0x%2.2x sub opcode 0x%2.2x", status,
+		   sub_opcode);
+
+	switch (sub_opcode) {
+	case MSFT_OP_READ_SUPPORTED_FEATURES: {
+		struct msft_rp_read_supported_features *rp = (void *)skb->data;
+		u8 prefix_len = rp->evt_prefix_len;
+
+		msft_ext->features = __le64_to_cpu(rp->features);
+		msft_ext->evt_prefix_len = prefix_len;
+		msft_ext->evt_prefix = kmalloc(prefix_len, GFP_ATOMIC);
+		if (!msft_ext->evt_prefix) {
+			bt_dev_warn(hdev, "Microsoft extension invalid event prefix");
+			return;
+		}
+
+		memcpy(msft_ext->evt_prefix, rp->evt_prefix, prefix_len);
+		bt_dev_info(hdev, "Microsoft extension features 0x%016llx",
+			    msft_ext->features);
+		break;
+	}
+	default:
+		bt_dev_warn(hdev, "Microsoft extension unknown sub opcode 0x%2.2x",
+			    sub_opcode);
+		break;
+	}
+}
+
+static bool msft_vnd_ext_supported(struct hci_dev *hdev)
+{
+	struct msft_vnd_ext *msft_ext = (struct msft_vnd_ext *)hdev->msft_ext;
+
+	return msft_ext->opcode != HCI_OP_NOP;
+}
+
+static void msft_vnd_ext_do_open(struct hci_dev *hdev)
+{
+	struct sk_buff *skb;
+	struct msft_vnd_ext *msft_ext = (struct msft_vnd_ext *)hdev->msft_ext;
+	struct msft_cp_read_supported_features cp;
+
+	msft_ext->features = 0;
+	msft_ext->evt_prefix_len = 0;
+	msft_ext->evt_prefix = NULL;
+
+	if (!msft_vnd_ext_supported(hdev))
+		return;
+
+	cp.sub_opcode = MSFT_OP_READ_SUPPORTED_FEATURES;
+	skb = __hci_cmd_sync(hdev, msft_ext->opcode, sizeof(cp), &cp,
+			     HCI_CMD_TIMEOUT);
+
+	process_msft_vnd_ext_cmd_complete(hdev, skb);
+
+	if (skb) {
+		kfree_skb(skb);
+		skb = NULL;
+	}
+}
+
 static int hci_dev_do_open(struct hci_dev *hdev)
 {
 	int ret = 0;
@@ -1555,6 +1636,8 @@ static int hci_dev_do_open(struct hci_dev *hdev)
 		}
 	}
 
+	msft_vnd_ext_do_open(hdev);
+
 	/* If the HCI Reset command is clearing all diagnostic settings,
 	 * then they need to be reprogrammed after the init procedure
 	 * completed.
@@ -1685,6 +1768,16 @@ static void hci_pend_le_actions_clear(struct hci_dev *hdev)
 	BT_DBG("All LE pending actions cleared");
 }
 
+static void msft_vnd_ext_do_close(struct hci_dev *hdev)
+{
+	struct msft_vnd_ext *msft_ext = (struct msft_vnd_ext *)hdev->msft_ext;
+
+	msft_ext->features = 0;
+	msft_ext->evt_prefix_len = 0;
+	kfree(msft_ext->evt_prefix);
+	msft_ext->evt_prefix = NULL;
+}
+
 int hci_dev_do_close(struct hci_dev *hdev)
 {
 	bool auto_off;
@@ -1734,6 +1827,8 @@ int hci_dev_do_close(struct hci_dev *hdev)
 			cancel_delayed_work_sync(&adv_instance->rpa_expired_cb);
 	}
 
+	msft_vnd_ext_do_close(hdev);
+
 	/* Avoid potential lockdep warnings from the *_flush() calls by
 	 * ensuring the workqueue is empty up front.
 	 */
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index c7ede27095be..21cb32105206 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -20,6 +20,33 @@
 // COPYRIGHTS, TRADEMARKS OR OTHER RIGHTS, RELATING TO USE OF THIS
 // SOFTWARE IS DISCLAIMED.
 
+#define MSFT_EVT_PREFIX_MAX_LEN			255
+
 struct msft_vnd_ext {
 	__u16	opcode;
+	__u64	features;
+	__u8	evt_prefix_len;
+	__u8	*evt_prefix;
 };
+
+struct msft_cmd_cmp_info {
+	__u8 status;
+	__u8 sub_opcode;
+} __packed;
+
+/* Microsoft Vendor HCI subcommands */
+#define MSFT_OP_READ_SUPPORTED_FEATURES		0x00
+#define MSFT_FEATURE_MASK_RSSI_MONITOR_BREDR_CONN	0x0000000000000001
+#define MSFT_FEATURE_MASK_RSSI_MONITOR_LE_CONN		0x0000000000000002
+#define MSFT_FEATURE_MASK_RSSI_MONITOR_LE_ADV		0x0000000000000004
+#define MSFT_FEATURE_MASK_ADV_MONITOR_LE_ADV		0x0000000000000008
+#define MSFT_FEATURE_MASK_VERIFY_CURVE			0x0000000000000010
+#define MSFT_FEATURE_MASK_CONCURRENT_ADV_MONITOR	0x0000000000000020
+struct msft_cp_read_supported_features {
+	__u8 sub_opcode;
+} __packed;
+struct msft_rp_read_supported_features {
+	__u64 features;
+	__u8  evt_prefix_len;
+	__u8  evt_prefix[0];
+} __packed;
-- 
2.24.1

