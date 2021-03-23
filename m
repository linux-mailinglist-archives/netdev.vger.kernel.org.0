Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42593459BA
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 09:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhCWIc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 04:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhCWIc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 04:32:27 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59CCC061756
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 01:32:26 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id e34so1286094pge.2
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 01:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=KtQvqrz3w6xBtTxWdXYr5PEiVwRgjP+6HysrGaoX6eU=;
        b=DlM4X9aAYWJc8Kcs/DrMzz5CAXYgCgxLO6eh8pdqDX8KSkfklA/9aW54+tDVNPAcHm
         wIw0s6/IXg/axF4KydHQHgM87VjUuPtVS8otmgkic5ye4vMJ1SgnNc+Ex61qzV/wKvTL
         JodG8sNLBwGvJvnnoP8B7d3xe4k4w/hGe2P1Slte6KbmxHtmB4Lg8KxLoKQMeH2joxmM
         4CVtT8sLX4lAk5L/GL5pshLVYMczqGS+ySwTYJB3WpBbQttsElTZjg1fgXoRxlj4TFGY
         6ZIu6I6hsJdbqZo9EctKYo1WfPFB019LRLA58gwe3NrH+WYYOvZeBEE1ZecCb7JDkCU/
         GJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=KtQvqrz3w6xBtTxWdXYr5PEiVwRgjP+6HysrGaoX6eU=;
        b=MSKrcKsEqpsjkU13Ka9n10YJn4EMkju2Zrm2tRwi+wsfwVCevmdouYDhmPzqD0hkTw
         rq8jruBwkxPM+d3llndsGNJPI1medLrtIlC8N8CcYeRCSzv8Ecf8mgiKn9305VlMRVPN
         q16DRzGuwbqtrwBNI68021hlR61nt4C+ZDq4IBKCh8u0IKWcSx4ae2CswfBaaDDAjWkb
         neO0oTVx2zO6QRfOFW2JtfzQmh6qQgMfUxl1A2+ztaAviyj9nrXMrWTsCP0jt5+PodV3
         qzlMzMVweVE5dxhu2lbwzpyN1vJa2aRwe5CyO4xseq/rp7nakHsvJTlNr/JegZ621jJI
         Hr4w==
X-Gm-Message-State: AOAM531v2Jz3US0fd1eW37RyV7CZgtt2skuIV4LcJoeq+SLelRKMXdLL
        kq2vo9gSexb60MINpqBxOY8yJJcSOWJN
X-Google-Smtp-Source: ABdhPJx/iVy/TATqUnzYQb+Zxn94peGSevSjnAX+s+QI7WSRkdje6wmgQl9jwrfCamXacJylhEIh0ThDStsh
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:b:fdf3:9f7d:e4e3:ccad])
 (user=apusaka job=sendgmr) by 2002:a62:e708:0:b029:1f8:c092:ff93 with SMTP id
 s8-20020a62e7080000b02901f8c092ff93mr3763813pfh.21.1616488345892; Tue, 23 Mar
 2021 01:32:25 -0700 (PDT)
Date:   Tue, 23 Mar 2021 16:32:20 +0800
Message-Id: <20210323163141.v2.1.I6c4306f6e8ba3ccc9106067d4eb70092f8cb2a49@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH v2] Bluetooth: check for zapped sk before connecting
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        syzbot+abfc0f5e668d4099af73@syzkaller.appspotmail.com,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

There is a possibility of receiving a zapped sock on
l2cap_sock_connect(). This could lead to interesting crashes, one
such case is tearing down an already tore l2cap_sock as is happened
with this call trace:

__dump_stack lib/dump_stack.c:15 [inline]
dump_stack+0xc4/0x118 lib/dump_stack.c:56
register_lock_class kernel/locking/lockdep.c:792 [inline]
register_lock_class+0x239/0x6f6 kernel/locking/lockdep.c:742
__lock_acquire+0x209/0x1e27 kernel/locking/lockdep.c:3105
lock_acquire+0x29c/0x2fb kernel/locking/lockdep.c:3599
__raw_spin_lock_bh include/linux/spinlock_api_smp.h:137 [inline]
_raw_spin_lock_bh+0x38/0x47 kernel/locking/spinlock.c:175
spin_lock_bh include/linux/spinlock.h:307 [inline]
lock_sock_nested+0x44/0xfa net/core/sock.c:2518
l2cap_sock_teardown_cb+0x88/0x2fb net/bluetooth/l2cap_sock.c:1345
l2cap_chan_del+0xa3/0x383 net/bluetooth/l2cap_core.c:598
l2cap_chan_close+0x537/0x5dd net/bluetooth/l2cap_core.c:756
l2cap_chan_timeout+0x104/0x17e net/bluetooth/l2cap_core.c:429
process_one_work+0x7e3/0xcb0 kernel/workqueue.c:2064
worker_thread+0x5a5/0x773 kernel/workqueue.c:2196
kthread+0x291/0x2a6 kernel/kthread.c:211
ret_from_fork+0x4e/0x80 arch/x86/entry/entry_64.S:604

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reported-by: syzbot+abfc0f5e668d4099af73@syzkaller.appspotmail.com
Reviewed-by: Alain Michaud <alainm@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
---

Changes in v2:
* Modify locking order for better visibility

 net/bluetooth/l2cap_sock.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index f1b1edd0b697..c99d65ef13b1 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -179,9 +179,17 @@ static int l2cap_sock_connect(struct socket *sock, struct sockaddr *addr,
 	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
 	struct sockaddr_l2 la;
 	int len, err = 0;
+	bool zapped;
 
 	BT_DBG("sk %p", sk);
 
+	lock_sock(sk);
+	zapped = sock_flag(sk, SOCK_ZAPPED);
+	release_sock(sk);
+
+	if (zapped)
+		return -EINVAL;
+
 	if (!addr || alen < offsetofend(struct sockaddr, sa_family) ||
 	    addr->sa_family != AF_BLUETOOTH)
 		return -EINVAL;
-- 
2.31.0.291.g576ba9dcdaf-goog

