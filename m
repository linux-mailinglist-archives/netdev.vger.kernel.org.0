Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5101F2FF988
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 01:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbhAVAjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 19:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbhAVAjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 19:39:18 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DA9C061756
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 16:38:38 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id q4so2266194plr.7
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 16:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xh1gmsKFWqh2VoIalRTQmYePy1aGr3dxBm/jAkXBTsw=;
        b=hwa2iqD7fBSPMtdhB4EdzPigbnt85mQMK4OVGbEbf8G5BlI0jGOX8rKWgsbePzGttC
         ksuUsgXw8IOGKLfZLPtR5kGlmzqjOro/PdUrTXzIdnDckDuCQ+nX4qRUvN0e2Irp3Y0N
         OLxGz9Md0SNATKVa+aI8oIvyfe+x5waV9ZnFA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xh1gmsKFWqh2VoIalRTQmYePy1aGr3dxBm/jAkXBTsw=;
        b=ZG0eoMLXKhh1DtAjO7eUylgooN5ZXUv7hCu4k7nXnuwG8Mlw+1hjgkwSVPJ+aAKqW/
         3yst4ljEQazqMGw7295C49ZL01wWkAZSU7I5CDOj9x6rJCfnPtc9sLQlsn+LybSrfbv7
         cBzmFoLmzbLfyXwMu28fxmQQ9qnzGf9uEtNdisI4hdGPww0IfEBDjoYmYCNBHIgAvxJ+
         S/3i6VKV29iE/gnjNTXygnnEU8ltJ5I095TOkw3frAysYffr5+7Uqg3ewdlx/Hz0xdMU
         q6g87HNswkf1HcuciPZLy/ZBi7uKjJ3f7YHggrIxpLZ1a2nBYWmOIvoAslbQTePx+QNL
         2g0Q==
X-Gm-Message-State: AOAM530b0XqzReTItFdz5HxqYQxnTTNOF9eNVgmeT+fNZ1xKzS2dl5Vr
        /gO8PZ5xlMnVPK0dMh7c2ZDYdn1SMe0ttg==
X-Google-Smtp-Source: ABdhPJxSYzoJR4l9sMfwnZXfHq76mqi1xMgOQos7evHsHnU9pdPCM1MFVwNVPWK+iytYEMqQ9vy2pQ==
X-Received: by 2002:a17:90a:4a08:: with SMTP id e8mr2225150pjh.149.1611275917811;
        Thu, 21 Jan 2021 16:38:37 -0800 (PST)
Received: from localhost ([2620:15c:202:201:6c51:e165:670c:baed])
        by smtp.gmail.com with ESMTPSA id 36sm6702694pgr.56.2021.01.21.16.38.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 16:38:36 -0800 (PST)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Alain Michaud <alainm@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3] Bluetooth: Keep MSFT ext info throughout ahci_dev's life cycle
Date:   Thu, 21 Jan 2021 16:38:31 -0800
Message-Id: <20210121163801.v3.1.Id9bc5434114de07512661f002cdc0ada8b3d6d02@changeid>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This moves msft_do_close() from hci_dev_do_close() to
hci_unregister_dev() to avoid clearing MSFT extension info. This also
avoids retrieving MSFT info upon every msft_do_open() if MSFT extension
has been initialized.

The following test steps were performed.
(1) boot the test device and verify the MSFT support debug log in syslog
(2) restart bluetoothd and verify msft_do_close() doesn't get invoked

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Archie Pusaka <apusaka@chromium.org>
---
Hi Maintainers,

This patch fixes the life cycle of MSFT HCI extension. The current
symmetric calls to msft_do{open,close} in hci_dev_do_{open,close} cause
incorrect MSFT features during bluetoothd start-up. After the kernel
powers on the controller to register the hci_dev, it performs
hci_dev_do_close() which call msft_do_close() and MSFT data gets wiped
out. And then during the startup of bluetoothd, Adv Monitor Manager
relies on reading the MSFT features from the kernel to present the
feature set of the controller to D-Bus clients. However, the power state
of the controller is off during the init of D-Bus interfaces. As a
result, invalid MSFT features are returned by the kernel, since it was
previously wiped out due to hci_dev_do_close().

And here is the trace (for case 1 above) that I captured without this
change.

2021-01-15T01:34:43.800155Z INFO kernel: [    2.754911] Bluetooth:
hci_power_on() @@ call hci_dev_do_open
2021-01-15T01:34:45.145025Z INFO kernel: [    4.272376] Bluetooth:
hci_dev_do_open() @@ call msft_do_open
2021-01-15T01:34:45.145050Z INFO kernel: [    4.272382] Bluetooth:
msft_do_open() @@
2021-01-15T01:34:45.146020Z INFO kernel: [    4.273139] Bluetooth:
read_supported_features() @@ features 000000000000003f
2021-01-15T01:34:47.176410Z INFO kernel: [    6.303439] Bluetooth:
hci_power_off() @@ call hci_dev_do_close
2021-01-15T01:34:47.189020Z INFO kernel: [    6.316152] Bluetooth:
hci_dev_do_close() @@ call msft_do_close
2021-01-15T01:34:47.189032Z INFO kernel: [    6.316158] Bluetooth:
msft_do_close() @@
2021-01-15T01:34:47.957401Z INFO bluetoothd[2591]: Bluetooth daemon 5.54
// skip some logs here
2021-01-15T01:34:48.004066Z INFO bluetoothd[2591]: Bluetooth
management interface 1.14 initialized
2021-01-15T01:34:48.167703Z INFO bluetoothd[2591]: @@ call
btd_adv_monitor_manager_create
2021-01-15T01:34:48.167832Z INFO bluetoothd[2591]: @@ call
MGMT_OP_READ_ADV_MONITOR_FEATURES
2021-01-15T01:34:48.167886Z INFO bluetoothd[2591]: Battery Provider
Manager created
2021-01-15T01:34:48.171924Z INFO bluetoothd[2591]: @@ features
supported_features 00000000 enabled_features 00000000
2021-01-15T01:34:48.172088Z INFO kernel: [    7.299305] Bluetooth:
hci_power_on() @@ call hci_dev_do_open
2021-01-15T01:34:48.172083Z INFO bluetoothd[2591]: Adv Monitor Manager
created with supported features:0x00000000, enabled
features:0x00000000, max number of supported monitors:32, max number
of supported patterns:16
2021-01-15T01:34:48.207800Z INFO bluetoothd[2591]: Endpoint
registered: sender=:1.52 path=/org/chromium/Cras/Bluetooth/A2DPSource
2021-01-15T01:34:48.212522Z INFO bluetoothd[2591]: Player registered:
sender=:1.52 path=/org/chromium/Cras/Bluetooth/DefaultPlayer
2021-01-15T01:34:48.214813Z INFO bluetoothd[2591]: BlueZ log level is set
to 1
2021-01-15T01:34:48.230035Z INFO kernel: [    7.357118] Bluetooth:
hci_dev_do_open() @@ call msft_do_open
2021-01-15T01:34:48.230063Z INFO kernel: [    7.357124] Bluetooth:
msft_do_open() @@
2021-01-15T01:34:48.231027Z INFO kernel: [    7.358131] Bluetooth:
read_supported_features() @@ features 000000000000003f
2021-01-15T01:34:48.248967Z INFO bluetoothd[2591]: adapter
/org/bluez/hci0 has been enabled
2021-01-15T01:34:49.176198Z INFO bluetoothd[2591]: adapter
/org/bluez/hci0 set power to 1

Regards,
Chrome OS Bluetooth team

Changes in v3:
- Remove the accepted commits from the series

 net/bluetooth/hci_core.c | 4 ++--
 net/bluetooth/msft.c     | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index eeafed2efc0da..8056f0d4ae172 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1764,8 +1764,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
 
 	hci_sock_dev_event(hdev, HCI_DEV_DOWN);
 
-	msft_do_close(hdev);
-
 	if (hdev->flush)
 		hdev->flush(hdev);
 
@@ -3844,6 +3842,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	unregister_pm_notifier(&hdev->suspend_notifier);
 	cancel_work_sync(&hdev->suspend_prepare);
 
+	msft_do_close(hdev);
+
 	hci_dev_do_close(hdev);
 
 	if (!test_bit(HCI_INIT, &hdev->flags) &&
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 8579bfeb28364..34769898858ef 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -75,7 +75,8 @@ void msft_do_open(struct hci_dev *hdev)
 {
 	struct msft_data *msft;
 
-	if (hdev->msft_opcode == HCI_OP_NOP)
+	/* Skip if opcode is not supported or MSFT has been initiatlized */
+	if (hdev->msft_opcode == HCI_OP_NOP || hdev->msft_data)
 		return;
 
 	bt_dev_dbg(hdev, "Initialize MSFT extension");
-- 
2.30.0.280.ga3ce27912f-goog

