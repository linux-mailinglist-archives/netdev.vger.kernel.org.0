Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0C031A05BB
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 06:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgDGE0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 00:26:37 -0400
Received: from mail-pj1-f74.google.com ([209.85.216.74]:34076 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgDGE0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 00:26:36 -0400
Received: by mail-pj1-f74.google.com with SMTP id d2so5329pje.1
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 21:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=QWUKDJQTRxWuVmOwgRvVPoWS0UavR+FekLqN1+lSVJ0=;
        b=vOoh/LI74uP5oGTJtFVs6Wj0xTE8/y6MFdP3yrgFAKUCddTIF/l1UpDa8U199B88Ru
         w9vQSEt0QtBFCZoQ2zSrGdEwEuiLUow0J7rStScAiPsb968sEU/qyfuiA0kYdaV+X3we
         mdF+WBr/pbi0ZmjOdWtXyEW50KZW41qkvwyiJnX5NHvmTEKAJbN8SGS5DDX7v4lo/981
         tWgMYlgRjMuDFYQgKoX43TZNCOmmHH9pWJ5iGZ+81QFYtqZYkBef/I4OntvBMmi7C3Vf
         HeWvWUzmXa3/1sdg8OMFpEKJdYBwiT3Hw4PwYvyMAPagBmFgHZL95Tu+Ne+JOmFSVKGA
         a8Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=QWUKDJQTRxWuVmOwgRvVPoWS0UavR+FekLqN1+lSVJ0=;
        b=R8+6PH9Vi55tTbAKdv9j9QdMzEahFSuoW68d726/0uHNOMigXqHN/zOiwa4DGUJlYy
         eQgyoIx1VqTI8OMgmqIeDFdD0o47dTzuOWIzjp5u5ySqNjNyghiPKhNRl28TN44EITT8
         SPBNZNFu6tFMDTJj9XRrnaJMoO41Rj2z3zWpJ0qxxcAjQY+huPWdNloL+xfTwxyyRtgS
         HdUhoPWHcKx815nMKL1yCOU4XtNJlhFHZ+QedcRme/Mub6vPpq03doZyqz677I6810fb
         QBQeTnNeLvOWfZDWnX3ygckMij7WTHFMsRd+jzjayvlfkxJ6BuW70JmJGuXSscB9DxUb
         OfqA==
X-Gm-Message-State: AGi0PubldAdMTAHW5s4EPce6A9Kbm52YYi7aHcAJ7WbyqtIWaTHXlXwJ
        NIu1brpf5aHykm95tqzLoH33/AwWGHV1
X-Google-Smtp-Source: APiQypLJCnHPeQcXq6SQEnVok3DreXL6u5mQfQikHBJHO0xSMfffYfbLHPybQF8KmADEvQ/NI6B62Eye81jN
X-Received: by 2002:a17:90b:909:: with SMTP id bo9mr432591pjb.125.1586233595138;
 Mon, 06 Apr 2020 21:26:35 -0700 (PDT)
Date:   Tue,  7 Apr 2020 12:26:27 +0800
Message-Id: <20200407122522.v2.1.Ibfc500cbf0bf2dc8429b17f064e960e95bb228e9@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
Subject: [PATCH v2] Bluetooth: debugfs option to unset MITM flag
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

This patch introduces a debugfs option to force MITM flag to be
turned off.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
---

Changes in v2:
- Rename flag to HCI_FORCE_NO_MITM
- Move debugfs functions to hci_debugfs.c
- Add comments on not setting SMP_AUTH_MITM

 include/net/bluetooth/hci.h |  1 +
 net/bluetooth/hci_debugfs.c | 46 +++++++++++++++++++++++++++++++++++++
 net/bluetooth/smp.c         | 15 ++++++++----
 3 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 79de2a659dd69..f4e8e2a0b7c15 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -298,6 +298,7 @@ enum {
 	HCI_FORCE_STATIC_ADDR,
 	HCI_LL_RPA_RESOLUTION,
 	HCI_CMD_PENDING,
+	HCI_FORCE_NO_MITM,
 
 	__HCI_NUM_FLAGS,
 };
diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
index 6b1314c738b8e..5e8af2658e44a 100644
--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -1075,6 +1075,50 @@ DEFINE_SIMPLE_ATTRIBUTE(auth_payload_timeout_fops,
 			auth_payload_timeout_get,
 			auth_payload_timeout_set, "%llu\n");
 
+static ssize_t force_no_mitm_read(struct file *file,
+				  char __user *user_buf,
+				  size_t count, loff_t *ppos)
+{
+	struct hci_dev *hdev = file->private_data;
+	char buf[3];
+
+	buf[0] = hci_dev_test_flag(hdev, HCI_FORCE_NO_MITM) ? 'Y' : 'N';
+	buf[1] = '\n';
+	buf[2] = '\0';
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+}
+
+static ssize_t force_no_mitm_write(struct file *file,
+				   const char __user *user_buf,
+				   size_t count, loff_t *ppos)
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
+	if (enable == hci_dev_test_flag(hdev, HCI_FORCE_NO_MITM))
+		return -EALREADY;
+
+	hci_dev_change_flag(hdev, HCI_FORCE_NO_MITM);
+
+	return count;
+}
+
+static const struct file_operations force_no_mitm_fops = {
+	.open		= simple_open,
+	.read		= force_no_mitm_read,
+	.write		= force_no_mitm_write,
+	.llseek		= default_llseek,
+};
+
 DEFINE_QUIRK_ATTRIBUTE(quirk_strict_duplicate_filter,
 		       HCI_QUIRK_STRICT_DUPLICATE_FILTER);
 DEFINE_QUIRK_ATTRIBUTE(quirk_simultaneous_discovery,
@@ -1134,6 +1178,8 @@ void hci_debugfs_create_le(struct hci_dev *hdev)
 			    &max_key_size_fops);
 	debugfs_create_file("auth_payload_timeout", 0644, hdev->debugfs, hdev,
 			    &auth_payload_timeout_fops);
+	debugfs_create_file("force_no_mitm", 0644, hdev->debugfs, hdev,
+			    &force_no_mitm_fops);
 
 	debugfs_create_file("quirk_strict_duplicate_filter", 0644,
 			    hdev->debugfs, hdev,
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index d0b695ee49f63..a85e3e49cd0da 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2393,12 +2393,17 @@ int smp_conn_security(struct hci_conn *hcon, __u8 sec_level)
 			authreq |= SMP_AUTH_CT2;
 	}
 
-	/* Require MITM if IO Capability allows or the security level
-	 * requires it.
+	/* Don't attempt to set MITM if setting is overridden by debugfs
+	 * Needed to pass certification test SM/MAS/PKE/BV-01-C
 	 */
-	if (hcon->io_capability != HCI_IO_NO_INPUT_OUTPUT ||
-	    hcon->pending_sec_level > BT_SECURITY_MEDIUM)
-		authreq |= SMP_AUTH_MITM;
+	if (!hci_dev_test_flag(hcon->hdev, HCI_FORCE_NO_MITM)) {
+		/* Require MITM if IO Capability allows or the security level
+		 * requires it.
+		 */
+		if (hcon->io_capability != HCI_IO_NO_INPUT_OUTPUT ||
+		    hcon->pending_sec_level > BT_SECURITY_MEDIUM)
+			authreq |= SMP_AUTH_MITM;
+	}
 
 	if (hcon->role == HCI_ROLE_MASTER) {
 		struct smp_cmd_pairing cp;
-- 
2.26.0.292.g33ef6b2f38-goog

