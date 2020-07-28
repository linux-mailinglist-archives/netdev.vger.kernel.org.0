Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FF423103B
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731691AbgG1Q6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731531AbgG1Q6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 12:58:13 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE87C0619D4
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 09:58:13 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id l2so4928195pff.0
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 09:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mwrIihuJNbQiyPto1EhLxqXOv3Ti56A9zl8lU/r4aiE=;
        b=ZQHUO2+CroLHpqPo+Cj3B3HT8//zhHljYnkiDIsNcb7XPWLQIwuTYDaWAcAzQVBKq/
         JUlAduT+8Ty1m0zBRGSatQuHVY+Clnh3yX5gb+YaYyOUjdWHfQjKgHRiV83ZjDgQxanX
         yBWBUToCoLajNehMHXapzmxqp7WH90xU7V2Ts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mwrIihuJNbQiyPto1EhLxqXOv3Ti56A9zl8lU/r4aiE=;
        b=hpP2S3J+uNSJC2kBDPVLR+owF60TSnXRVXnOChFh+b8V8GQSjfYcxeTc4rdKDwVv5P
         RhDK1GjyOLzsmBJea15lgDLqtgt+rArmN+dYWVUDm2YIHhylIGS4LVch1w9IMS8If9dE
         9zdlJfnAX4MTRn7uyWSwYEuRXF7C/TkOo8cPkmQsyubagMshOZ/Ke/EU2P+Jit3TJREl
         Tf6ICqyQmSB9v1Xy20M9xCQMYK2+c+3v8eD0odxllgfnOKdXFA16BPNU/doV20aVRtH7
         jfIugmxojjmcdFNsevIji+TjMMHMGR+sk1n25428yCZPbNwSS7jSqHkmMDPNrDBabjsL
         BDZg==
X-Gm-Message-State: AOAM532A4YoWjOqVlvQ79QJMoiOICLS0CLcbZASEvr2+rdx8FdpT+FWL
        +1dWBe6K+gjQOER7+DrGwq7vcA==
X-Google-Smtp-Source: ABdhPJw+nSCGDiE1Ny04kjNuD3elgR8BcdAawE5hI5v4ATe2zTuJ9cQo1efaE0+gcHzHeSLDftFV8w==
X-Received: by 2002:a63:b511:: with SMTP id y17mr24919808pge.425.1595955492765;
        Tue, 28 Jul 2020 09:58:12 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:7220:84ff:fe09:2b94])
        by smtp.gmail.com with ESMTPSA id z67sm10032403pfc.162.2020.07.28.09.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 09:58:12 -0700 (PDT)
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
Subject: [PATCH v3] Bluetooth: Fix suspend notifier race
Date:   Tue, 28 Jul 2020 09:58:07 -0700
Message-Id: <20200728095711.v3.1.I7ebe9eaf684ddb07ae28634cb4d28cf7754641f1@changeid>
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

Fixes: 9952d90ea2885 ("Bluetooth: Handle PM_SUSPEND_PREPARE and PM_POST_SUSPEND")
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


Changes in v3:
* Added fixes tag

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

