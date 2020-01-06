Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B2D13101B
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 11:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgAFKOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 05:14:54 -0500
Received: from mail-ua1-f73.google.com ([209.85.222.73]:56552 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgAFKOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 05:14:53 -0500
Received: by mail-ua1-f73.google.com with SMTP id b15so5236841uas.23
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 02:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=at/6LW2CyTT3AHJ4DEYijPCx/QdUy/o9K531OsH9S78=;
        b=bDdqcPXVe98eZZsa1W/fgJGsjHgmbnuAHsdVZRxB/3KvothFJUQUfQ0onHWQZ8cfpX
         nT4tXkR1hx5QKJ0kqcm+i6hbjFiePhLwRTnnLJECG/i4KiwAfG9k7E6aYHg+osoPighR
         XXXc5btco0/w1GOLEiK4WqSzvlCx/j9nz6X+8fZqp1uvhV7PRUaXbDN25u71AmYpWLyG
         fxGkkeRTD0kfFO+jyrVOand0ROEnj5QBZn7670exqa2lPa0stOycRFTxWkSvuO/LOtdZ
         pYS7sDIxeCDkp8cvSom/ZlQ7HLcbWDA13yy8M1tvGIWYO5o2xdI4JQFmv8Z7mjlYurwT
         4nrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=at/6LW2CyTT3AHJ4DEYijPCx/QdUy/o9K531OsH9S78=;
        b=Df3vdcKBPeloLInL8VEJ5a83Ny82QbbZvVuBlwW5x/Nfy7P0efmUtzIkbhGmmTEa94
         zApVkPaF+y0BU09fEG53D2YThKSnZ93lbxp+w8H93TorgDVP9dJ+l/HVClJBCe8FuTPN
         ExU+Z5w9wg5lPkBoN7vjg4/SAXnNGM90Y3toOD4cZ09AOEp4JWlaR6j5dzrvKVB3XElf
         T27XsWxQhQCv8ExDixvDB/KLZDEFqjKjB6LFqKFcl0QwT4kAuuMBNIlm4DUd0eQXI0N1
         6HM20NVwa0CBkDCLWlvirIAJak4jCEOGUz3SJefNR0bH43msnXyAhvW52JdvwaJnr2sM
         GOJQ==
X-Gm-Message-State: APjAAAXfrIhlBUgWPgvMXAVwqZDL0NZdWzzePvgU/5krRwemLM6VsUlB
        19rLQXOBX+/Jqjjftbl00ZJYnXMFGYb/4YrVDQ==
X-Google-Smtp-Source: APXvYqxeiBsH+6mjRgu/QkCHpQHygOljrWjBgnQ6a4QtftT9FqtqwKY/jlH3egqEL8AIPfxpN+ZzS6YmKEMlPYvLDw==
X-Received: by 2002:ab0:714c:: with SMTP id k12mr58239995uao.124.1578305691993;
 Mon, 06 Jan 2020 02:14:51 -0800 (PST)
Date:   Mon,  6 Jan 2020 18:14:37 +0800
Message-Id: <20200106181425.Bluez.v1.1.I5ee1ea8e19d41c5bdffb4211aeb9cd9efa5e0a4a@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [Bluez PATCH v1] bluetooth: secure bluetooth stack from bluedump attack
From:   "howardchung@google.com" <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        howardchung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: howardchung <howardchung@google.com>

Attack scenario:
1. A Chromebook (let's call this device A) is paired to a legitimate
   Bluetooth classic device (e.g. a speaker) (let's call this device
   B).
2. A malicious device (let's call this device C) pretends to be the
   Bluetooth speaker by using the same BT address.
3. If device A is not currently connected to device B, device A will
   be ready to accept connection from device B in the background
   (technically, doing Page Scan).
4. Therefore, device C can initiate connection to device A
   (because device A is doing Page Scan) and device A will accept the
   connection because device A trusts device C's address which is the
   same as device B's address.
5. Device C won't be able to communicate at any high level Bluetooth
   profile with device A because device A enforces that device C is
   encrypted with their common Link Key, which device C doesn't have.
   But device C can initiate pairing with device A with just-works
   model without requiring user interaction (there is only pairing
   notification). After pairing, device A now trusts device C with a
   new different link key, common between device A and C.
6. From now on, device A trusts device C, so device C can at anytime
   connect to device A to do any kind of high-level hijacking, e.g.
   speaker hijack or mouse/keyboard hijack.

To fix this, reject the pairing if all the conditions below are met.
- the pairing is initialized by peer
- the authorization method is just-work
- host already had the link key to the peer

Also create a debugfs option to permit the pairing even the
conditions above are met.

Signed-off-by: howardchung <howardchung@google.com>
---

 include/net/bluetooth/hci.h |  1 +
 net/bluetooth/hci_core.c    | 47 +++++++++++++++++++++++++++++++++++++
 net/bluetooth/hci_event.c   | 12 ++++++++++
 3 files changed, 60 insertions(+)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 07b6ecedc6ce..4918b79baa41 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -283,6 +283,7 @@ enum {
 	HCI_FORCE_STATIC_ADDR,
 	HCI_LL_RPA_RESOLUTION,
 	HCI_CMD_PENDING,
+	HCI_PERMIT_JUST_WORK_REPAIR,
 
 	__HCI_NUM_FLAGS,
 };
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 9e19d5a3aac8..9014aa567e7b 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -172,10 +172,57 @@ static const struct file_operations vendor_diag_fops = {
 	.llseek		= default_llseek,
 };
 
+static ssize_t permit_just_work_repair_read(struct file *file,
+					    char __user *user_buf,
+					    size_t count, loff_t *ppos)
+{
+	struct hci_dev *hdev = file->private_data;
+	char buf[3];
+
+	buf[0] = hci_dev_test_flag(hdev, HCI_PERMIT_JUST_WORK_REPAIR) ? 'Y'
+								      : 'N';
+	buf[1] = '\n';
+	buf[2] = '\0';
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+}
+
+static ssize_t permit_just_work_repair_write(struct file *file,
+					     const char __user *user_buf,
+					     size_t count, loff_t *ppos)
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
+	if (enable)
+		hci_dev_set_flag(hdev, HCI_PERMIT_JUST_WORK_REPAIR);
+	else
+		hci_dev_clear_flag(hdev, HCI_PERMIT_JUST_WORK_REPAIR);
+
+	return count;
+}
+
+static const struct file_operations permit_just_work_repair_fops = {
+	.open		= simple_open,
+	.read		= permit_just_work_repair_read,
+	.write		= permit_just_work_repair_write,
+	.llseek		= default_llseek,
+};
+
 static void hci_debugfs_create_basic(struct hci_dev *hdev)
 {
 	debugfs_create_file("dut_mode", 0644, hdev->debugfs, hdev,
 			    &dut_mode_fops);
+	debugfs_create_file("permit_just_work_repair", 0644, hdev->debugfs,
+			    hdev, &permit_just_work_repair_fops);
 
 	if (hdev->set_diag)
 		debugfs_create_file("vendor_diag", 0644, hdev->debugfs, hdev,
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 6ddc4a74a5e4..898e347e19e0 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4539,6 +4539,18 @@ static void hci_user_confirm_request_evt(struct hci_dev *hdev,
 		goto unlock;
 	}
 
+	/* If there already exists link key in local host, terminate the
+	 * connection by default since the remote device could be malicious.
+	 * Permit the connection if permit_just_work_repair is enabled.
+	 */
+	if (!hci_dev_test_flag(hdev, HCI_PERMIT_JUST_WORK_REPAIR) &&
+	    hci_find_link_key(hdev, &ev->bdaddr)) {
+		BT_DBG("Rejecting request: local host already have link key");
+		hci_send_cmd(hdev, HCI_OP_USER_CONFIRM_NEG_REPLY,
+			     sizeof(ev->bdaddr), &ev->bdaddr);
+		goto unlock;
+	}
+
 	/* If no side requires MITM protection; auto-accept */
 	if ((!loc_mitm || conn->remote_cap == HCI_IO_NO_INPUT_OUTPUT) &&
 	    (!rem_mitm || conn->io_capability == HCI_IO_NO_INPUT_OUTPUT)) {
-- 
2.24.1.735.g03f4e72817-goog

