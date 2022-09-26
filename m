Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637EA5EB5C6
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 01:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiIZXbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 19:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiIZXbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 19:31:09 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5529118B0D
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 16:31:08 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id l72-20020a63914b000000b00434ac6f8214so4736972pge.13
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 16:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=MEx5AkRis1Q8EBfRmtqZKYRH8hsFfpfHGF2r7Wrj8Wg=;
        b=oy5u290Oq4tGTcZN/o5eOVGn93Dr3gj2v9kjK1/60a123+BFF/pOshej4ed+7lLCyK
         87FebeWk7csjvy3AyP94AKC+3SyzVmFT+dfOG2MES3sG+CtUsxboA0eCZb5tABBBEo4x
         HmBaD27w3gXzGs+nuO4aRtCVMcsF2zXnpLMRWMX4QH6Sf/g1lpfLbFQo58WbvapYNJO3
         rhaiad+kcvB/uvNrzDREfmauO3IyRk+A5idHXu8Ic5z9p+1bnWyCFRGc0/MiwcnOl3hm
         SG0AddHzOTmtjcfKBfDqhUsbxDvp7MdpuS0ia0J/7CwJnG7eoXTHr0RHzjrCsL0MhPxu
         k9qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=MEx5AkRis1Q8EBfRmtqZKYRH8hsFfpfHGF2r7Wrj8Wg=;
        b=NsM6WwsaWQig6WJk+x27aw+6K4ac2n9T4h/YFBbq+XSwr4Xn59rHRtWCnvPN7qrYlC
         2ev+VnTc5wZYEDG++Q8nAgMWDsfgKhla+Yaa4yXTq/RTPilbRpVjOEqUsu+VdcstaG8P
         7Z1gVtLAaUlO3umoSXGu8kf6KoXbd+qOjn5RG329l0SkPe2CfqQ6GhqDi/she4uD2VNC
         aXegmOmVGL86tY29ydaefByYTPRZ0UqP6SOsmqkHg72A+tZ5SAd178pNm4Y0xssGs6Bo
         k9FWTWmvuNNcsulg074+TP0TYOq5/8ruJ59F2QDJYI9gA2OMPzYskIVrH7iJZiV6aJlH
         ridw==
X-Gm-Message-State: ACrzQf3/opX8/aNvyvE3BNRLiQAqipEQREnun8OHONAdhj1XCLnlPAn4
        1q9299ZoIEJuN1XHNJ0pG+WhqeWgOx4WLpQQD3Ih8g==
X-Google-Smtp-Source: AMsMyM4rbGVokC9aE2JE/xVF0x1ZAaDQoXdTOe8TJxSSOUZU+I06PvqFSGV0xiKIvEhz/HDR3L37U5Dhs5unsxWHE67adw==
X-Received: from abps.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:9b4])
 (user=abhishekpandit job=sendgmr) by 2002:a05:6a00:1493:b0:546:2856:6d08 with
 SMTP id v19-20020a056a00149300b0054628566d08mr26226712pfu.84.1664235067789;
 Mon, 26 Sep 2022 16:31:07 -0700 (PDT)
Date:   Mon, 26 Sep 2022 16:31:03 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220926163057.1.Ia168b651a69b253059f2bbaa60b98083e619545c@changeid>
Subject: [PATCH] Bluetooth: Prevent double register of suspend
From:   Abhishek Pandit-Subedi <abhishekpandit@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
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

From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

Suspend notifier should only be registered and unregistered once per
hdev. Since hci_sock and hci_register_dev run in different work queues
(sock vs driver), add hci_dev_lock to avoid double registering.

Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---
This is fixing a syzbot reported warning. Tested in the following ways:
* Normal start-up of driver with bluez.
* Start/stop loop using HCI_USER_CHANNEL (sock path).
* USB reset triggering hci_dev_unregister (driver path).

------------[ cut here ]------------
double register detected
WARNING: CPU: 0 PID: 2657 at kernel/notifier.c:27
notifier_chain_register kernel/notifier.c:27 [inline]
WARNING: CPU: 0 PID: 2657 at kernel/notifier.c:27
notifier_chain_register+0x5c/0x124 kernel/notifier.c:22
Modules linked in:
CPU: 0 PID: 2657 Comm: syz-executor212 Not tainted
5.10.136-syzkaller-19376-g6f46a5fe0124 #0
  8f0771607702f5ef7184d2ee33bd0acd70219fc4
  Hardware name: Google Google Compute Engine/Google Compute Engine,
  BIOS Google 07/22/2022
  RIP: 0010:notifier_chain_register kernel/notifier.c:27 [inline]
  RIP: 0010:notifier_chain_register+0x5c/0x124 kernel/notifier.c:22
  Code: 6a 41 00 4c 8b 23 4d 85 e4 0f 84 88 00 00 00 e8 c2 1e 19 00 49
  39 ec 75 18 e8 b8 1e 19 00 48 c7 c7 80 6d ca 84 e8 2c 68 48 03 <0f> 0b
     e9 af 00 00 00 e8 a0 1e 19 00 48 8d 7d 10 48 89 f8 48 c1 e8
     RSP: 0018:ffffc900009d7da8 EFLAGS: 00010286
     RAX: 0000000000000000 RBX: ffff8881076fd1d8 RCX: 0000000000000000
     RDX: 0000001810895100 RSI: ffff888110895100 RDI: fffff5200013afa7
     RBP: ffff88811a4191d0 R08: ffffffff813b8ca1 R09: 0000000080000000
     R10: 0000000000000000 R11: 0000000000000005 R12: ffff88811a4191d0
     R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
     FS: 00005555571f5300(0000) GS:ffff8881f6c00000(0000)
     knlGS:0000000000000000
     CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
     CR2: 000078e3857f3075 CR3: 000000010d668000 CR4: 00000000003506f0
     DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
     DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
     Call Trace:
     blocking_notifier_chain_register+0x8c/0xa6 kernel/notifier.c:254
     hci_register_suspend_notifier net/bluetooth/hci_core.c:2733
     [inline]
     hci_register_suspend_notifier+0x6b/0x7c
     net/bluetooth/hci_core.c:2727
     hci_sock_release+0x270/0x3cf net/bluetooth/hci_sock.c:889
     __sock_release+0xcd/0x1de net/socket.c:597
     sock_close+0x18/0x1c net/socket.c:1267
     __fput+0x418/0x729 fs/file_table.c:281
     task_work_run+0x12b/0x15b kernel/task_work.c:151
     tracehook_notify_resume include/linux/tracehook.h:188 [inline]
     exit_to_user_mode_loop kernel/entry/common.c:165 [inline]
     exit_to_user_mode_prepare+0x8f/0x130 kernel/entry/common.c:192
     syscall_exit_to_user_mode+0x172/0x1b2 kernel/entry/common.c:268
     entry_SYSCALL_64_after_hwframe+0x61/0xc6
     RIP: 0033:0x78e38575e1db
     Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89
     7c 24 0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05
     <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
     RSP: 002b:00007ffffc20a0b0 EFLAGS: 00000293 ORIG_RAX:
     0000000000000003
     RAX: 0000000000000000 RBX: 0000000000000006 RCX: 000078e38575e1db
     RDX: ffffffffffffffb8 RSI: 0000000020000000 RDI: 0000000000000005
     RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000150
     R10: 0000000000000000 R11: 0000000000000293 R12: 000000000000e155
     R13: 00007ffffc20a140 R14: 00007ffffc20a130 R15: 00007ffffc20a0e8

 include/net/bluetooth/hci.h |  1 +
 net/bluetooth/hci_core.c    | 16 ++++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index e004ba04a9ae..36304c217151 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -353,6 +353,7 @@ enum {
 	HCI_OFFLOAD_CODECS_ENABLED,
 	HCI_LE_SIMULTANEOUS_ROLES,
 	HCI_CMD_DRAIN_WORKQUEUE,
+	HCI_SUSPEND_REGISTERED,
 
 	HCI_MESH_EXPERIMENTAL,
 	HCI_MESH,
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 66c7cdba0d32..5a32d17c69b8 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2760,10 +2760,18 @@ int hci_register_suspend_notifier(struct hci_dev *hdev)
 {
 	int ret = 0;
 
-	if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks)) {
+	hci_dev_lock(hdev);
+	if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks) &&
+	    !hci_dev_test_and_set_flag(hdev, HCI_SUSPEND_REGISTERED)) {
+		memset(&hdev->suspend_notifier, 0,
+		       sizeof(hdev->suspend_notifier));
 		hdev->suspend_notifier.notifier_call = hci_suspend_notifier;
 		ret = register_pm_notifier(&hdev->suspend_notifier);
+
+		if (ret)
+			hci_dev_clear_flag(hdev, HCI_SUSPEND_REGISTERED);
 	}
+	hci_dev_unlock(hdev);
 
 	return ret;
 }
@@ -2772,8 +2780,12 @@ int hci_unregister_suspend_notifier(struct hci_dev *hdev)
 {
 	int ret = 0;
 
-	if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks))
+	hci_dev_lock(hdev);
+	if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks) &&
+	    hci_dev_test_and_clear_flag(hdev, HCI_SUSPEND_REGISTERED)) {
 		ret = unregister_pm_notifier(&hdev->suspend_notifier);
+	}
+	hci_dev_unlock(hdev);
 
 	return ret;
 }
-- 
2.37.3.998.g577e59143f-goog

