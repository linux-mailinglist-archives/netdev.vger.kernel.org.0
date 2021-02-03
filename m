Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4393C30D391
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 07:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhBCG5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 01:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbhBCG5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 01:57:51 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00390C06174A
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 22:57:10 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id e62so22794115yba.5
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 22:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=/wnbMtD0oy336W9EDCGq60PMZiiWzWFv7G6400JHFhs=;
        b=tfjQFmZuBFZHJuQTjSVhg3ixz+DnPLN/S9VEIvqbIxFzeoWNgV77XNtiyL9ixPO4Tb
         dz0un2MfXWvAwVLGdjRh/++XmGFZd948pQuQFXv6vBXBjSlmZWraR0aKplDotFXISRP3
         PeaaH93UfYOEVLcTJI3ORIUPgyXvtocYdiJV0Rzzn/CVwSvbupy+oy554e7WbzRO8+sk
         mBMRaneAEtmswh0W3dKwol0esz25Gaupy0pjB6oF9Z2y+Gx8h+HzW/iChV83VZoVLDMJ
         ehusselEhRZwCjTxFbKkR7wDR4RiJEaZHPGDsLcrWuNkLWdNWH0IIC74zkgZdeTrh0BK
         sZ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=/wnbMtD0oy336W9EDCGq60PMZiiWzWFv7G6400JHFhs=;
        b=AzYnGYlbGTucLZl78isvr5m1Z0mgMIQGaPs20ZorX8a5W06GlRSrB0GmqA75Nq/3S3
         OERKDayfx21NgdtDlTe5CCDdMJLe7XHnUxJVAjgo49LFutR/IcBKy/kOfMPE8hVqfpuk
         TA6ZY0ah88pRRl9yE/MGNNRAOWckK9lVgSk5NxkGpbYED6qmueh2xt49ifcb5ePFCQL7
         VHMNUdNsFndMXdnX+13tNfOUr4I+79oKD8BNAG8b+Y3WOLB2Rayr0dybjMLQ/VA/izqp
         /+ygaibuEO4+yEwNeVnURkGMgP/aKa/0Ckp+W0+a+TVgseEvvqndjDKkIi2lTvKO/ORh
         UQUg==
X-Gm-Message-State: AOAM533q+ueEYgMwDYoLBGsCItY1GS3GRIuk2R3f2YzyBq+/GDaA0I6U
        kBwDFbtlwG0dCHFAvy24vjEHL6aql+uN4gPrgA==
X-Google-Smtp-Source: ABdhPJxSiqk8gZYYdNVJFLC3BUkDqUVnJelM3j+yz+P8URDuHFvJS7qJyIaFDqLtAWy+TUl7m+Am741X6VRHRXrL9A==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:c8ff:4e4a:dbd4:e8a6])
 (user=howardchung job=sendgmr) by 2002:a25:ca8c:: with SMTP id
 a134mr2589170ybg.106.1612335430056; Tue, 02 Feb 2021 22:57:10 -0800 (PST)
Date:   Wed,  3 Feb 2021 14:56:44 +0800
Message-Id: <20210203145558.Bluez.v1.1.I23ab3f91f23508bf84908e62d470bfab1d844f63@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [Bluez PATCH v1] Bluetooth: Fix crash in mgmt_add_adv_patterns_monitor_complete
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     Howard Chung <howardchung@google.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        Manish Mandlik <mmandlik@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If hci_add_adv_monitor is a pending command(e.g. forward to
msft_add_monitor_pattern), it is possible that
mgmt_add_adv_patterns_monitor_complete gets called before
cmd->user_data gets set, which will cause a crash when we
try to get the moniter handle through cmd->user_data in
mgmt_add_adv_patterns_monitor_complete.

This moves the cmd->user_data assignment earlier than
hci_add_adv_monitor.

RIP: 0010:mgmt_add_adv_patterns_monitor_complete+0x82/0x187 [bluetooth]
Code: 1e bf 03 00 00 00 be 52 00 00 00 4c 89 ea e8 9e
e4 02 00 49 89 c6 48 85 c0 0f 84 06 01 00 00 48 89 5d b8 4c 89 fb 4d 8b
7e 30 <41> 0f b7 47 18 66 89 45 c0 45 84 e4 75 5a 4d 8b 56 28 48 8d 4d
c8
RSP: 0018:ffffae81807dbcb8 EFLAGS: 00010286
RAX: ffff91c4bdf723c0 RBX: 0000000000000000 RCX: ffff91c4e5da5b80
RDX: ffff91c405680000 RSI: 0000000000000052 RDI: ffff91c49d654c00
RBP: ffffae81807dbd00 R08: ffff91c49fb157e0 R09: ffff91c49fb157e0
R10: 000000000002a4f0 R11: ffffffffc0819cfd R12: 0000000000000000
R13: ffff91c405680000 R14: ffff91c4bdf723c0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff91c4ea300000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000018 CR3: 0000000133612002 CR4:
00000000003606e0
Call Trace:
 ? msft_le_monitor_advertisement_cb+0x111/0x141
[bluetooth]
 hci_event_packet+0x425e/0x631c [bluetooth]
 ? printk+0x59/0x73
 ? __switch_to_asm+0x41/0x70
 ?
msft_le_set_advertisement_filter_enable_cb+0xa6/0xa6 [bluetooth]
 ? bt_dbg+0xb4/0xbb [bluetooth]
 ? __switch_to_asm+0x41/0x70
 hci_rx_work+0x101/0x319 [bluetooth]
 process_one_work+0x257/0x506
 worker_thread+0x10d/0x284
 kthread+0x14c/0x154
 ? process_one_work+0x506/0x506
 ? kthread_blkcg+0x2c/0x2c
 ret_from_fork+0x1f/0x40

Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
Reviewed-by: Archie Pusaka <apusaka@chromium.org>
Signed-off-by: Howard Chung <howardchung@google.com>
---

 net/bluetooth/mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 8ff9c4bb43d11..74971b4bd4570 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4303,6 +4303,7 @@ static int __add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
+	cmd->user_data = m;
 	pending = hci_add_adv_monitor(hdev, m, &err);
 	if (err) {
 		if (err == -ENOSPC || err == -ENOMEM)
@@ -4330,7 +4331,6 @@ static int __add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 
 	hci_dev_unlock(hdev);
 
-	cmd->user_data = m;
 	return 0;
 
 unlock:
-- 
2.30.0.365.g02bc693789-goog

