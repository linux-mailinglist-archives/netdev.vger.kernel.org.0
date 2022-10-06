Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C46A5F6352
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 11:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiJFJJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 05:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiJFJJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 05:09:40 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5783FCE8
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 02:09:37 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3521c1a01b5so12435567b3.23
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 02:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=W6dnd6MUybWhVHYUHQ8d7S6D4UzG0vGs7tI9w8WKSPw=;
        b=SSpzU+3wLTsbRTZVM5yu2Enu8uvoYL9bqFOuq1fID5Ck3vddYC9Fn2fSzvLKbenMUx
         fuF4R6M5SBRsLSABcNeCV9rpYF62Ev+3xv/A+pnTFcZsv2lxVRPguNBfm5QCC6EMr7E7
         H2vr6MX5XTebP3D0H5ofNAwLXJkTUMjqS54djUwpy0stP3+jl9ypp6h1ipVNdaNPtss1
         SpAiACIC768tO0rIonQB/nhoOdlTl9Bl9YlCeF4YPv6cVlA7MjUcyKgelLElupjTIX2q
         KiDfZ6dzGys/MZJ8FBdi91HZBLTjIe20tkGm6j4flwNHexG6NHjuhpLIIUgDGpxwmrpg
         3Rag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=W6dnd6MUybWhVHYUHQ8d7S6D4UzG0vGs7tI9w8WKSPw=;
        b=ymCa8sfsPkavFIyXANEIxcHgsOaksueI8FLEN38VqUbbjAUzzjBcpFDwM5brcv7T7p
         Bqldq3ZdIW5JOFJJ7CL6Ep58FL+fNWSH+hjxkY9YWD7lRL64OvsDFz6ajWX8Jcu99Rm1
         /ueKHq/QZ/kRqTsi0TqWt3WKt9dsA0D69VeQw1PHYJQFCNvzAaYp9aUaDHYg5RBsJS8q
         +8c2VWiJaP6lOxFimJ6AxvCYjEytJaGi1C3l4kCFSgfkKTcYZgYpeXLlFTIRmuraRtWr
         Dc/chhnZvJ7nDz6s4p8zGcBXEZsd5bVAwwoHoWSGr6DZ+69Uzkql8+qr/+3YQcmI6rc5
         OnDA==
X-Gm-Message-State: ACrzQf0v6JvN/q3+ir1DcaB6j59D2DeVpb+4s/wJeR1IxVGq78bamh4l
        srzacnLgeNVFTPKzvBl4bMWkkuZuk6dL
X-Google-Smtp-Source: AMsMyM7BSEaT9DRaVmFt6QmDrsflEMyuH9+JhiEkNuJR/D+9w0X/VRjRUTm1V5JxJGcr0IWCFKhdt8ZK2Am/
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:17:1fb9:e3c:c40d:dd12])
 (user=apusaka job=sendgmr) by 2002:a25:bc83:0:b0:6bc:a6d2:5216 with SMTP id
 e3-20020a25bc83000000b006bca6d25216mr3841415ybk.204.1665047376628; Thu, 06
 Oct 2022 02:09:36 -0700 (PDT)
Date:   Thu,  6 Oct 2022 17:09:31 +0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006170915.v3.1.I46e98b47be875d0b9abff2d19417c612077d1909@changeid>
Subject: [PATCH v3] Bluetooth: btusb: Introduce generic USB reset
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@google.com>,
        Ying Hsu <yinghsu@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

On cmd_timeout with no reset_gpio, reset the USB port as a last
resort.

This patch changes the behavior of btusb_intel_cmd_timeout and
btusb_rtl_cmd_timeout.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@google.com>
Reviewed-by: Ying Hsu <yinghsu@chromium.org>

---
Tested by not cancelling cmd_timer when handing hci event.
Before the patch:
ERR kernel: [  716.929206] Bluetooth: hci_cmd_timeout() hci0: command 0x0000 tx timeout
ERR kernel: [  716.929218] Bluetooth: btusb_rtl_cmd_timeout() hci0: No gpio to reset Realtek device, ignoring

After the patch:
ERR kernel: [  225.270048] Bluetooth: hci_cmd_timeout() hci0: command 0x0000 tx timeout
ERR kernel: [  225.270060] Bluetooth: btusb_rtl_cmd_timeout() hci0: Resetting usb device.
INFO kernel: [  225.386613] usb 3-3: reset full-speed USB device number 3 using xhci_hcd

Changes in v3:
* introduce hdev->reset to override the generic reset function

Changes in v2:
* Update commit message

 drivers/bluetooth/btusb.c        | 35 +++++++++++++++++++++++---------
 include/net/bluetooth/hci_core.h |  1 +
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 271963805a38..e6add3604214 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -696,6 +696,28 @@ struct btusb_data {
 	unsigned cmd_timeout_cnt;
 };
 
+static void btusb_reset(struct hci_dev *hdev)
+{
+	struct btusb_data *data;
+	int err;
+
+	if (hdev->reset) {
+		hdev->reset(hdev);
+		return;
+	}
+
+	data = hci_get_drvdata(hdev);
+	/* This is not an unbalanced PM reference since the device will reset */
+	err = usb_autopm_get_interface(data->intf);
+	if (err) {
+		bt_dev_err(hdev, "Failed usb_autopm_get_interface: %d", err);
+		return;
+	}
+
+	bt_dev_err(hdev, "Resetting usb device.");
+	usb_queue_reset_device(data->intf);
+}
+
 static void btusb_intel_cmd_timeout(struct hci_dev *hdev)
 {
 	struct btusb_data *data = hci_get_drvdata(hdev);
@@ -705,7 +727,7 @@ static void btusb_intel_cmd_timeout(struct hci_dev *hdev)
 		return;
 
 	if (!reset_gpio) {
-		bt_dev_err(hdev, "No way to reset. Ignoring and continuing");
+		btusb_reset(hdev);
 		return;
 	}
 
@@ -736,7 +758,7 @@ static void btusb_rtl_cmd_timeout(struct hci_dev *hdev)
 		return;
 
 	if (!reset_gpio) {
-		bt_dev_err(hdev, "No gpio to reset Realtek device, ignoring");
+		btusb_reset(hdev);
 		return;
 	}
 
@@ -761,7 +783,6 @@ static void btusb_qca_cmd_timeout(struct hci_dev *hdev)
 {
 	struct btusb_data *data = hci_get_drvdata(hdev);
 	struct gpio_desc *reset_gpio = data->reset_gpio;
-	int err;
 
 	if (++data->cmd_timeout_cnt < 5)
 		return;
@@ -787,13 +808,7 @@ static void btusb_qca_cmd_timeout(struct hci_dev *hdev)
 		return;
 	}
 
-	bt_dev_err(hdev, "Multiple cmd timeouts seen. Resetting usb device.");
-	/* This is not an unbalanced PM reference since the device will reset */
-	err = usb_autopm_get_interface(data->intf);
-	if (!err)
-		usb_queue_reset_device(data->intf);
-	else
-		bt_dev_err(hdev, "Failed usb_autopm_get_interface with %d", err);
+	btusb_reset(hdev);
 }
 
 static inline void btusb_free_frags(struct btusb_data *data)
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index c54bc71254af..55a40f5606c3 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -659,6 +659,7 @@ struct hci_dev {
 	int (*set_diag)(struct hci_dev *hdev, bool enable);
 	int (*set_bdaddr)(struct hci_dev *hdev, const bdaddr_t *bdaddr);
 	void (*cmd_timeout)(struct hci_dev *hdev);
+	void (*reset)(struct hci_dev *hdev);
 	bool (*wakeup)(struct hci_dev *hdev);
 	int (*set_quality_report)(struct hci_dev *hdev, bool enable);
 	int (*get_data_path_id)(struct hci_dev *hdev, __u8 *data_path);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

