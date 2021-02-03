Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F82230D3EA
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 08:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbhBCHK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 02:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbhBCHKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 02:10:18 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E944EC06174A
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 23:09:37 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 11so25881526ybl.21
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 23:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=/wnbMtD0oy336W9EDCGq60PMZiiWzWFv7G6400JHFhs=;
        b=ORpIZ9KqvA5JySv1a+xUn5mihk221WQUpgWJVo0oGIZRv5FvZ6QiHJy/rWa+IdEYjI
         /8JHAUH81DnuGXTBISe7MuVXH1UcJOWYwxV1PZGf3qGUR5pivDIDyLTY1K5RB3RfjS8C
         qdmy0O+f1yM9NW7yygT+6B3madCzZB+CdnwsAuZo5aU39rSboYuAaW580muhTehu4V3E
         cigMubeYmMeWUvEC+mhwwHzpJVVgmmeuKNL4xxK0En3ZLAIZpDJxe/TO420R8rs1oIma
         kUzrgy9y8ml3LVwxWfHb01cEiFrYwFZ5EH0TevmKlL2AdtqBUN0UMrChtJytP1Vhzq2q
         7K6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=/wnbMtD0oy336W9EDCGq60PMZiiWzWFv7G6400JHFhs=;
        b=G+lofpwCYXxA6Ba5jZ5lTP4VMEdO1i3be1/JMPQzuhI6cwIq3Z0O5dI4puQJMxeLO4
         K9Gex3QR9Ce5lYvU4okM5RI+C0bfW853tF1ASqRbvCkbG+VDdcnHG3JWOmUal91ykRUJ
         ywZ4YfCFINaS6oEwAqpSU0+mlYWFHxERS+g5RgQ6ZlZ/o9vl+Z1zIaODHR+pk0fgDYV0
         1M/yb7oNkrQPW+BuP5h+DK1TYryuUDuzAZCFnAnuRAfEurD2WjoBqVHywFu+oBs1XmoK
         5jBVBAx9q2iGCYYqx0lwbP7SBZMFGa2nhJrsD2laHtmRImritWaTTtIBJqe3AmE3tpSd
         t59w==
X-Gm-Message-State: AOAM530BqFhFhDe4HjppGsyrzQq3jelfBZNWVPBshAxnUldenXWPr+Ur
        KmlgkgACFWqjJ+5coQ0E2QYWK84aHn8F44lSvA==
X-Google-Smtp-Source: ABdhPJypZNI/m4g+qfZiw1c1Kl/BP/d7kUrd1HrLK8IrMqiQE82/eoWXzK8jRUdUY1sUw071wrH5VFpy2dvkgYlXwA==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:c8ff:4e4a:dbd4:e8a6])
 (user=howardchung job=sendgmr) by 2002:a25:5cd7:: with SMTP id
 q206mr2627199ybb.150.1612336177210; Tue, 02 Feb 2021 23:09:37 -0800 (PST)
Date:   Wed,  3 Feb 2021 15:09:29 +0800
Message-Id: <20210203150907.v1.1.I23ab3f91f23508bf84908e62d470bfab1d844f63@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v1] Bluetooth: Fix crash in mgmt_add_adv_patterns_monitor_complete
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

