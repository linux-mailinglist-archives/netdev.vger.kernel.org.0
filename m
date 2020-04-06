Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 831EE19F1E9
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 10:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgDFI6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 04:58:43 -0400
Received: from mail-pj1-f74.google.com ([209.85.216.74]:44982 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgDFI6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 04:58:43 -0400
Received: by mail-pj1-f74.google.com with SMTP id t7so13684938pjb.9
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 01:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=lfcuc8W8/Uvf28snFxOT4FYXFWyQRAEGdgjXm/Niomc=;
        b=lmBDYuChgxxj4YzMcT6wMdjlfMoqL9o6jT19Go0n0f370zWVvAKJWRPCLd/tGA5Cxx
         2Abspe5CfcdyP9J5zB9ysPEBZNfqw1jn974izn0D0S7UO3RIcXXRpbW1JNQimnrh9Rng
         LQRlPdFTViEbjz+QT3JQGM5wBaNWD6k+0WEDRhp1V0L3NUntM+MGQ/8seZVqNjq+v2R8
         NHNJvI34HQlTPnv1MZay1HvAZGGxHtQtIOFin7iI0zYAxVDHkfokX9Ll3VaiiW2khkIx
         Vx9hDsS4ojl/BPVlEvRRIwghdty/7u7ynLPJHdu/sjjIhCEwCez06GrMd13brfZjkDAf
         KwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=lfcuc8W8/Uvf28snFxOT4FYXFWyQRAEGdgjXm/Niomc=;
        b=tGXx4YvbWlAZDBHL0oANf5Icsk0NQLWtwkeA1iDIw9uNPO3nZ/bnzRyb4hzSTNcF7O
         jifjC4PQTIQ5zBrBIedUg5SEsMJBJ9j0T9GppLAgcX7iqsd558wfOVXHjUTct4c21Ah/
         kHUI945dOrubr5nGXnchtSWKLoO4HbvusP70dAZZuCmy7nxjdhGBSOpqpwED1vXIISNW
         /IWy5Lv5CuBfsH1LDTaPakbbgNvnX33vfNBLWSW44cmwlEzZRuu738QrAfyr38r/CW5D
         KPpdH4Cq/dDQ09urMjw4CJTG9lF9Bm0VQcCwLUXEzYfy1FqKvs9xwdEVCwEjCuJ2nkA9
         7xEw==
X-Gm-Message-State: AGi0PuYkQz3qUuAmpxmD00wlJR0QRFaLI016C93ttSq0JBevexPjeTmh
        0EVNYJKvpLugJ6gMndIIG+kD+KtcQhqX
X-Google-Smtp-Source: APiQypLP7XEJejTP0eeHM6gdsYaCjdt2N70Ny3lZoatYbbBgqdIpf1sNUTK89QQ+PYEUJPhgNYzwdUZq4xag
X-Received: by 2002:a65:6857:: with SMTP id q23mr19048657pgt.94.1586163521990;
 Mon, 06 Apr 2020 01:58:41 -0700 (PDT)
Date:   Mon,  6 Apr 2020 16:58:34 +0800
Message-Id: <20200406165542.v1.1.Ibfc500cbf0bf2dc8429b17f064e960e95bb228e9@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
Subject: [PATCH v1] Bluetooth: debugfs option to unset MITM flag
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

The BT qualification test SM/MAS/PKE/BV-01-C needs us to turn off
the MITM flag when pairing, and at the same time also set the io
capability to something other than no input no output.

Currently the MITM flag is only unset when the io capability is set
to no input no output, therefore the test cannot be executed.

This patch introduces a debugfs option for controlling whether MITM
flag should be set based on io capability.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
---

 include/net/bluetooth/hci.h |  1 +
 net/bluetooth/smp.c         | 52 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 79de2a659dd69..5e183487c7479 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -298,6 +298,7 @@ enum {
 	HCI_FORCE_STATIC_ADDR,
 	HCI_LL_RPA_RESOLUTION,
 	HCI_CMD_PENDING,
+	HCI_ENFORCE_MITM_SMP,
 
 	__HCI_NUM_FLAGS,
 };
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index d0b695ee49f63..4fa8b112fb607 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2396,7 +2396,8 @@ int smp_conn_security(struct hci_conn *hcon, __u8 sec_level)
 	/* Require MITM if IO Capability allows or the security level
 	 * requires it.
 	 */
-	if (hcon->io_capability != HCI_IO_NO_INPUT_OUTPUT ||
+	if ((hci_dev_test_flag(hcon->hdev, HCI_ENFORCE_MITM_SMP) &&
+	     hcon->io_capability != HCI_IO_NO_INPUT_OUTPUT) ||
 	    hcon->pending_sec_level > BT_SECURITY_MEDIUM)
 		authreq |= SMP_AUTH_MITM;
 
@@ -3402,6 +3403,50 @@ static const struct file_operations force_bredr_smp_fops = {
 	.llseek		= default_llseek,
 };
 
+static ssize_t enforce_mitm_smp_read(struct file *file,
+				     char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct hci_dev *hdev = file->private_data;
+	char buf[3];
+
+	buf[0] = hci_dev_test_flag(hdev, HCI_ENFORCE_MITM_SMP) ? 'Y' : 'N';
+	buf[1] = '\n';
+	buf[2] = '\0';
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+}
+
+static ssize_t enforce_mitm_smp_write(struct file *file,
+				      const char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct hci_dev *hdev = file->private_data;
+	char buf[32];
+	size_t buf_size = min(count, (sizeof(buf) - 1));
+	bool enable;
+
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	buf[buf_size] = '\0';
+	if (strtobool(buf, &enable))
+		return -EINVAL;
+
+	if (enable == hci_dev_test_flag(hdev, HCI_ENFORCE_MITM_SMP))
+		return -EALREADY;
+
+	hci_dev_change_flag(hdev, HCI_ENFORCE_MITM_SMP);
+
+	return count;
+}
+
+static const struct file_operations enforce_mitm_smp_fops = {
+	.open		= simple_open,
+	.read		= enforce_mitm_smp_read,
+	.write		= enforce_mitm_smp_write,
+	.llseek		= default_llseek,
+};
+
 int smp_register(struct hci_dev *hdev)
 {
 	struct l2cap_chan *chan;
@@ -3426,6 +3471,11 @@ int smp_register(struct hci_dev *hdev)
 
 	hdev->smp_data = chan;
 
+	/* Enforce the policy of determining MITM flag by io capabilities. */
+	hci_dev_set_flag(hdev, HCI_ENFORCE_MITM_SMP);
+	debugfs_create_file("enforce_mitm_smp", 0644, hdev->debugfs, hdev,
+			    &enforce_mitm_smp_fops);
+
 	/* If the controller does not support BR/EDR Secure Connections
 	 * feature, then the BR/EDR SMP channel shall not be present.
 	 *
-- 
2.26.0.292.g33ef6b2f38-goog

