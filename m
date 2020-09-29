Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE8827BEBC
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbgI2IDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgI2IDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:03:35 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FF7C0613D0
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 01:03:33 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id v14so2205733pjd.4
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 01:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WSCibO01sQYuYgwA3sjYVUdV/DSW72aymIhoZ2phP5o=;
        b=hIBpBYxFcSBkv5+Gv+LUQL9OwL17C4bUSXs7QqGkZWNygbSPYVZil4RqU8r2bKZA4z
         BAwE7qh3qofjJQ+dmU4jaJBziX1FEnmBjtKo3nUUC7xtdDL5lI6lzNif+JvIDoXWenTW
         ERIYl+5xSm47Sbp54y5zSAihIuf4sO1FEyQoQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WSCibO01sQYuYgwA3sjYVUdV/DSW72aymIhoZ2phP5o=;
        b=Ybwiqua0AXVitmldnVj1CHCaGIlUtJX5oyYR6V18+Qd7fKBy5i9kIdH9igbeVtX8CX
         stcKg/cpvE43w3vwbvs16YZyN4UZFRHkuVyTR4Q0kespzojeIRmQHqyCYxJFaIIDGgdl
         IFGnCPzaWbBs8E5a28UdhTmQ2HIwo2ObkUo7VHq6qgiyawSzg7QLsBXCDJEtWT4f5fSB
         SA3ioIxYzOWCGJg/Fi/wyFyOuT18WaNW/XeBjO/a+5uv31TI2zkAZhm5KWLf06+kGZ3a
         M6M8bd0wTmjwJUVDbh4R1iqWkP+1lPDQ4uu1LwIC6QLxIO6uN8bu98SgfBV6fzHY7C5P
         /9bg==
X-Gm-Message-State: AOAM532UN8/UTRx0AutCYJNFZNZWXE5o2M1pGnWJARRRhCSyvy81BR1/
        Bqc5s49M0e/6w9nDqPOieHH2iw==
X-Google-Smtp-Source: ABdhPJz7JIr45H+MIS6/eoqcA8VtZEAW5QQsVXbPQ3/i1MXgyW6B33/VKSqut2WOQ1nZP2FwQvQ5jQ==
X-Received: by 2002:a17:90a:f001:: with SMTP id bt1mr2672475pjb.116.1601366612918;
        Tue, 29 Sep 2020 01:03:32 -0700 (PDT)
Received: from localhost ([2401:fa00:1:10:3e52:82ff:fe5e:cc9d])
        by smtp.gmail.com with ESMTPSA id k2sm4153014pfi.169.2020.09.29.01.03.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 01:03:32 -0700 (PDT)
From:   Claire Chang <tientzu@chromium.org>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, Claire Chang <tientzu@chromium.org>
Subject: [PATCH v2] Bluetooth: Move force_bredr_smp debugfs into hci_debugfs_create_bredr
Date:   Tue, 29 Sep 2020 16:03:24 +0800
Message-Id: <20200929080324.632523-1-tientzu@chromium.org>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid multiple attempts to create the debugfs entry, force_bredr_smp,
by moving it from the SMP registration to the BR/EDR controller init
section. hci_debugfs_create_bredr is only called when HCI_SETUP and
HCI_CONFIG is not set.

Signed-off-by: Claire Chang <tientzu@chromium.org>
---
v2: correct a typo in commit message

 net/bluetooth/hci_debugfs.c | 50 +++++++++++++++++++++++++++++++++++++
 net/bluetooth/smp.c         | 44 ++------------------------------
 net/bluetooth/smp.h         |  2 ++
 3 files changed, 54 insertions(+), 42 deletions(-)

diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
index 5e8af2658e44..4626e0289a97 100644
--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -494,6 +494,45 @@ static int auto_accept_delay_get(void *data, u64 *val)
 DEFINE_SIMPLE_ATTRIBUTE(auto_accept_delay_fops, auto_accept_delay_get,
 			auto_accept_delay_set, "%llu\n");
 
+static ssize_t force_bredr_smp_read(struct file *file,
+				    char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct hci_dev *hdev = file->private_data;
+	char buf[3];
+
+	buf[0] = hci_dev_test_flag(hdev, HCI_FORCE_BREDR_SMP) ? 'Y' : 'N';
+	buf[1] = '\n';
+	buf[2] = '\0';
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+}
+
+static ssize_t force_bredr_smp_write(struct file *file,
+				     const char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct hci_dev *hdev = file->private_data;
+	bool enable;
+	int err;
+
+	err = kstrtobool_from_user(user_buf, count, &enable);
+	if (err)
+		return err;
+
+	err = smp_force_bredr(hdev, enable);
+	if (err)
+		return err;
+
+	return count;
+}
+
+static const struct file_operations force_bredr_smp_fops = {
+	.open		= simple_open,
+	.read		= force_bredr_smp_read,
+	.write		= force_bredr_smp_write,
+	.llseek		= default_llseek,
+};
+
 static int idle_timeout_set(void *data, u64 val)
 {
 	struct hci_dev *hdev = data;
@@ -589,6 +628,17 @@ void hci_debugfs_create_bredr(struct hci_dev *hdev)
 	debugfs_create_file("voice_setting", 0444, hdev->debugfs, hdev,
 			    &voice_setting_fops);
 
+	/* If the controller does not support BR/EDR Secure Connections
+	 * feature, then the BR/EDR SMP channel shall not be present.
+	 *
+	 * To test this with Bluetooth 4.0 controllers, create a debugfs
+	 * switch that allows forcing BR/EDR SMP support and accepting
+	 * cross-transport pairing on non-AES encrypted connections.
+	 */
+	if (!lmp_sc_capable(hdev))
+		debugfs_create_file("force_bredr_smp", 0644, hdev->debugfs,
+				    hdev, &force_bredr_smp_fops);
+
 	if (lmp_ssp_capable(hdev)) {
 		debugfs_create_file("ssp_debug_mode", 0444, hdev->debugfs,
 				    hdev, &ssp_debug_mode_fops);
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 433227f96c73..8b817e4358fd 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -3353,31 +3353,8 @@ static void smp_del_chan(struct l2cap_chan *chan)
 	l2cap_chan_put(chan);
 }
 
-static ssize_t force_bredr_smp_read(struct file *file,
-				    char __user *user_buf,
-				    size_t count, loff_t *ppos)
+int smp_force_bredr(struct hci_dev *hdev, bool enable)
 {
-	struct hci_dev *hdev = file->private_data;
-	char buf[3];
-
-	buf[0] = hci_dev_test_flag(hdev, HCI_FORCE_BREDR_SMP) ? 'Y': 'N';
-	buf[1] = '\n';
-	buf[2] = '\0';
-	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
-}
-
-static ssize_t force_bredr_smp_write(struct file *file,
-				     const char __user *user_buf,
-				     size_t count, loff_t *ppos)
-{
-	struct hci_dev *hdev = file->private_data;
-	bool enable;
-	int err;
-
-	err = kstrtobool_from_user(user_buf, count, &enable);
-	if (err)
-		return err;
-
 	if (enable == hci_dev_test_flag(hdev, HCI_FORCE_BREDR_SMP))
 		return -EALREADY;
 
@@ -3399,16 +3376,9 @@ static ssize_t force_bredr_smp_write(struct file *file,
 
 	hci_dev_change_flag(hdev, HCI_FORCE_BREDR_SMP);
 
-	return count;
+	return 0;
 }
 
-static const struct file_operations force_bredr_smp_fops = {
-	.open		= simple_open,
-	.read		= force_bredr_smp_read,
-	.write		= force_bredr_smp_write,
-	.llseek		= default_llseek,
-};
-
 int smp_register(struct hci_dev *hdev)
 {
 	struct l2cap_chan *chan;
@@ -3433,17 +3403,7 @@ int smp_register(struct hci_dev *hdev)
 
 	hdev->smp_data = chan;
 
-	/* If the controller does not support BR/EDR Secure Connections
-	 * feature, then the BR/EDR SMP channel shall not be present.
-	 *
-	 * To test this with Bluetooth 4.0 controllers, create a debugfs
-	 * switch that allows forcing BR/EDR SMP support and accepting
-	 * cross-transport pairing on non-AES encrypted connections.
-	 */
 	if (!lmp_sc_capable(hdev)) {
-		debugfs_create_file("force_bredr_smp", 0644, hdev->debugfs,
-				    hdev, &force_bredr_smp_fops);
-
 		/* Flag can be already set here (due to power toggle) */
 		if (!hci_dev_test_flag(hdev, HCI_FORCE_BREDR_SMP))
 			return 0;
diff --git a/net/bluetooth/smp.h b/net/bluetooth/smp.h
index 121edadd5f8d..fc35a8bf358e 100644
--- a/net/bluetooth/smp.h
+++ b/net/bluetooth/smp.h
@@ -193,6 +193,8 @@ bool smp_irk_matches(struct hci_dev *hdev, const u8 irk[16],
 int smp_generate_rpa(struct hci_dev *hdev, const u8 irk[16], bdaddr_t *rpa);
 int smp_generate_oob(struct hci_dev *hdev, u8 hash[16], u8 rand[16]);
 
+int smp_force_bredr(struct hci_dev *hdev, bool enable);
+
 int smp_register(struct hci_dev *hdev);
 void smp_unregister(struct hci_dev *hdev);
 
-- 
2.28.0.618.gf4bc123cb7-goog

