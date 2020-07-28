Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D13823101F
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731564AbgG1QxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731484AbgG1QxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 12:53:07 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6796DC0619D2
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 09:53:07 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id w17so10159040ply.11
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 09:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c/duvw4ZsYECTtG6428ayDqRJqh3goK3mMqdqJUrMoU=;
        b=gVV9OWXDpMds2AkkWUJ+GF2FLPtzrkTaNNzO3ZIwNLNMM0hmyEQY/lP55zh2SQxl9J
         L2LrJelirzgwf5PpbUOfrjbfTp6DX3zVGHGaxB2d/U5AyDNS9zEkPuCS1JEARyw/npaR
         DBxTul+A2hkoQmpfVdgXQKeyy+75UhkvP1fP4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c/duvw4ZsYECTtG6428ayDqRJqh3goK3mMqdqJUrMoU=;
        b=ghyyVyw3E1ukcto6JzSHg6tV4awvfHSh8ze6+mDBm5OS8ReNraNMB7hKadO7pj/msJ
         bCpJ8hKgbdu7NFzhRrw1ymHxKQaeg69GAvnMhZ/PqE5aMcnJx10k34ypL60hQlSM+VYw
         nuGwVXdvlWnHvaZZarRUAXv/GiH60h/pXLEy4KqBXByeU78PftfcVF0eTeJ5mXUndwbp
         F9XEZJaxr0NX5PbC9gUlAgW7gO1bbxF7fz26Z4JjfOJ85o8gJT5dvvsSY/PZv1SBugSI
         0+NPOvLSE/Xs/r+hEUdHkBCB5bsje3I2ytUdWzO7ruF7avnxu9y0e8IbFHcXjqOYR+0Y
         ZXDw==
X-Gm-Message-State: AOAM532+9pTCxJh2u3Koq8K12VcQHZcNVjQDCWGMjoKexoXIxGe5UCUn
        +fHEhTZkvZCGbSBq3qVC2ctcig==
X-Google-Smtp-Source: ABdhPJz2on+N9OZ7VdHSCS4SV747vSQ9SlmLB7XVuvrM+WNfCNKTOGslexQhOO4L+PNl+3TPz6kXnA==
X-Received: by 2002:a17:90b:380e:: with SMTP id mq14mr5169794pjb.1.1595955186855;
        Tue, 28 Jul 2020 09:53:06 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:7220:84ff:fe09:2b94])
        by smtp.gmail.com with ESMTPSA id n22sm3407940pjq.25.2020.07.28.09.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 09:53:06 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2] Bluetooth: Fix suspend notifier race
Date:   Tue, 28 Jul 2020 09:52:59 -0700
Message-Id: <20200728095253.v2.1.I7ebe9eaf684ddb07ae28634cb4d28cf7754641f1@changeid>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unregister from suspend notifications and cancel suspend preparations
before running hci_dev_do_close. Otherwise, the suspend notifier may
race with unregister and cause cmd_timeout even after hdev has been
freed.

Below is the trace from when this panic was seen:

[  832.578518] Bluetooth: hci_core.c:hci_cmd_timeout() hci0: command 0x0c05 tx timeout
[  832.586200] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  832.586203] #PF: supervisor read access in kernel mode
[  832.586205] #PF: error_code(0x0000) - not-present page
[  832.586206] PGD 0 P4D 0
[  832.586210] PM: suspend exit
[  832.608870] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  832.613232] CPU: 3 PID: 10755 Comm: kworker/3:7 Not tainted 5.4.44-04894-g1e9dbb96a161 #1
[  832.630036] Workqueue: events hci_cmd_timeout [bluetooth]
[  832.630046] RIP: 0010:__queue_work+0xf0/0x374
[  832.630051] RSP: 0018:ffff9b5285f1fdf8 EFLAGS: 00010046
[  832.674033] RAX: ffff8a97681bac00 RBX: 0000000000000000 RCX: ffff8a976a000600
[  832.681162] RDX: 0000000000000000 RSI: 0000000000000009 RDI: ffff8a976a000748
[  832.688289] RBP: ffff9b5285f1fe38 R08: 0000000000000000 R09: ffff8a97681bac00
[  832.695418] R10: 0000000000000002 R11: ffff8a976a0006d8 R12: ffff8a9745107600
[  832.698045] usb 1-6: new full-speed USB device number 119 using xhci_hcd
[  832.702547] R13: ffff8a9673658850 R14: 0000000000000040 R15: 000000000000001e
[  832.702549] FS:  0000000000000000(0000) GS:ffff8a976af80000(0000) knlGS:0000000000000000
[  832.702550] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  832.702550] CR2: 0000000000000000 CR3: 000000010415a000 CR4: 00000000003406e0
[  832.702551] Call Trace:
[  832.702558]  queue_work_on+0x3f/0x68
[  832.702562]  process_one_work+0x1db/0x396
[  832.747397]  worker_thread+0x216/0x375
[  832.751147]  kthread+0x138/0x140
[  832.754377]  ? pr_cont_work+0x58/0x58
[  832.758037]  ? kthread_blkcg+0x2e/0x2e
[  832.761787]  ret_from_fork+0x22/0x40
[  832.846191] ---[ end trace fa93f466da517212 ]---

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
---
Hi Marcel,

This fixes a race between hci_unregister_dev and the suspend notifier.

The suspend notifier handler seemed to be scheduling commands even after
it was cleaned up and this was resulting in a panic in cmd_timeout (when
it tries to requeue the cmd_timer).

This was tested on 5.4 kernel with a suspend+resume stress test for 500+
iterations. I also confirmed that after a usb disconnect, the suspend
notifier times out before the USB device is probed again (fixing the
original race between the usb_disconnect + probe and the notifier).

Thanks
Abhishek


Changes in v2:
* Moved oops into commit message

 net/bluetooth/hci_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 5394ab56c915a9..4ba23b821cbf4a 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3767,9 +3767,10 @@ void hci_unregister_dev(struct hci_dev *hdev)
 
 	cancel_work_sync(&hdev->power_on);
 
-	hci_dev_do_close(hdev);
-
 	unregister_pm_notifier(&hdev->suspend_notifier);
+	cancel_work_sync(&hdev->suspend_prepare);
+
+	hci_dev_do_close(hdev);
 
 	if (!test_bit(HCI_INIT, &hdev->flags) &&
 	    !hci_dev_test_flag(hdev, HCI_SETUP) &&
-- 
2.28.0.rc0.142.g3c755180ce-goog

