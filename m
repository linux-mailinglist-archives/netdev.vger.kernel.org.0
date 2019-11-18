Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A817100405
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 12:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfKRL0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 06:26:17 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45645 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbfKRL0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 06:26:08 -0500
Received: by mail-lf1-f67.google.com with SMTP id v8so13467484lfa.12
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 03:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=2/X0Bt3B6f1WlBC1gd2WYnN+ZmRKaSnEax4l+v6cv4o=;
        b=jB0FPq2BuA6LRHE2MaMmLYzSWiZf4YWVknd2kbcPkptBe2BzIK3fJ8VXYZr8Q8LYy9
         SEi29A3fyHKZ+Pq5gtJZM0uep05KDV4AQrcba49TclbQMqxeTprb6T2/KNcySj6gCyZP
         IOJ1XIWllOvU22H8q5sajVOjvQ6NuvMyClhwZn00+egy5XYD9K8mfvZjN9K0tQ4uyY10
         rQmElDkgZOU+neJtOko7x8WwtBXC6EVgPWsRP5UrEjXNH55WEq/cXeKMdZYw4sUkKkxk
         tlYDmYmcOKaDRoiC9GX7SLqLJEsm4+Xq/+RemqAAvWqXvGxFuTcYy6a3/5LhtU2rKD4A
         xtCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2/X0Bt3B6f1WlBC1gd2WYnN+ZmRKaSnEax4l+v6cv4o=;
        b=M0mfA5hL8l1UkLGJ146zPPClJcxUizj0Teflkyd/WVusBOMvHcq+F62Qk4E1KIpaZp
         Cj/U8j5eRzKqGzkW8dTTO2PJQVKcFLSLxtVxOGtUsaatYLU0wdXqjjaBkaCMe5wjBFM7
         JqvT8pEHNhVup+LitlBY7D7RfBhdhI3yu76+prGkyqEf7ruoQrLFSISreCrUOedT+Znl
         5lvpgZ3z2T1Ua0FJwJXEQGU4l8fxGuAuUWji/8xIj8neb5jeZl950fYr1aCl3pzNqvth
         qshE7eVgd5jFOsfirmG4hLzQ0Hjtnduv2rH+eBw3CjA3XCNQWjGpjXYEF35zbiT2thAg
         qwqA==
X-Gm-Message-State: APjAAAXRNGiYtSTjODMDZhPFNOCE1oDegjZhQsm4Q6iC0soEl2nPHX1+
        g9oJIXHg1v/ZP0t6yWIQBiWkXpYjfxQ=
X-Google-Smtp-Source: APXvYqy89roAKnxEubmw1VtHs5JzUcjAOC2NqKAViXCKDoTyoALDnCFqmKXzSNaz4H4T9MWL0Yyb+w==
X-Received: by 2002:ac2:4c9b:: with SMTP id d27mr18675964lfl.139.1574076365954;
        Mon, 18 Nov 2019 03:26:05 -0800 (PST)
Received: from localhost.localdomain ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id g14sm8858701lfj.17.2019.11.18.03.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 03:26:05 -0800 (PST)
From:   jouni.hogander@unikie.com
To:     netdev@vger.kernel.org
Cc:     Jouni Hogander <jouni.hogander@unikie.com>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] net-sysfs: Fix reference count leak
Date:   Mon, 18 Nov 2019 13:25:53 +0200
Message-Id: <20191118112553.4271-1-jouni.hogander@unikie.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jouni Hogander <jouni.hogander@unikie.com>

Netdev_register_kobject is calling device_initialize. In case of error
reference taken by device_initialize is not given up.

Drivers are supposed to call free_netdev in case of error. In non-error
case the last reference is given up there and device release sequence
is triggered. In error case this reference is kept and the release
sequence is never started.

Fix this reference count leak by allowing giving up the reference also
in error case in free_netdev.

This is the rootcause for couple of memory leaks reported by Syzkaller:

BUG: memory leak unreferenced object 0xffff8880675ca008 (size 256):
  comm "netdev_register", pid 281, jiffies 4294696663 (age 6.808s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
  backtrace:
    [<0000000058ca4711>] kmem_cache_alloc_trace+0x167/0x280
    [<000000002340019b>] device_add+0x882/0x1750
    [<000000001d588c3a>] netdev_register_kobject+0x128/0x380
    [<0000000011ef5535>] register_netdevice+0xa1b/0xf00
    [<000000007fcf1c99>] __tun_chr_ioctl+0x20d5/0x3dd0
    [<000000006a5b7b2b>] tun_chr_ioctl+0x2f/0x40
    [<00000000f30f834a>] do_vfs_ioctl+0x1c7/0x1510
    [<00000000fba062ea>] ksys_ioctl+0x99/0xb0
    [<00000000b1c1b8d2>] __x64_sys_ioctl+0x78/0xb0
    [<00000000984cabb9>] do_syscall_64+0x16f/0x580
    [<000000000bde033d>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<00000000e6ca2d9f>] 0xffffffffffffffff

BUG: memory leak
unreferenced object 0xffff8880668ba588 (size 8):
  comm "kobject_set_nam", pid 286, jiffies 4294725297 (age 9.871s)
  hex dump (first 8 bytes):
    6e 72 30 00 cc be df 2b                          nr0....+
  backtrace:
    [<00000000a322332a>] __kmalloc_track_caller+0x16e/0x290
    [<00000000236fd26b>] kstrdup+0x3e/0x70
    [<00000000dd4a2815>] kstrdup_const+0x3e/0x50
    [<0000000049a377fc>] kvasprintf_const+0x10e/0x160
    [<00000000627fc711>] kobject_set_name_vargs+0x5b/0x140
    [<0000000019eeab06>] dev_set_name+0xc0/0xf0
    [<0000000069cb12bc>] netdev_register_kobject+0xc8/0x320
    [<00000000f2e83732>] register_netdevice+0xa1b/0xf00
    [<000000009e1f57cc>] __tun_chr_ioctl+0x20d5/0x3dd0
    [<000000009c560784>] tun_chr_ioctl+0x2f/0x40
    [<000000000d759e02>] do_vfs_ioctl+0x1c7/0x1510
    [<00000000351d7c31>] ksys_ioctl+0x99/0xb0
    [<000000008390040a>] __x64_sys_ioctl+0x78/0xb0
    [<0000000052d196b7>] do_syscall_64+0x16f/0x580
    [<0000000019af9236>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<00000000bc384531>] 0xffffffffffffffff

v1 -> v2:
* Relying on driver calling free_netdev rather than calling
  put_device directly in error path

Reported-by: syzbot+ad8ca40ecd77896d51e2@syzkaller.appspotmail.com
Cc: David Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
---
 net/core/dev.c       | 14 +++++++-------
 net/core/net-sysfs.c |  6 +++++-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 99ac84ff398f..4b8d03f9cba3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9603,14 +9603,14 @@ void free_netdev(struct net_device *dev)
 
 	netdev_unregister_lockdep_key(dev);
 
-	/*  Compatibility with error handling in drivers */
-	if (dev->reg_state == NETREG_UNINITIALIZED) {
-		netdev_freemem(dev);
-		return;
-	}
+	/* reg_state is NETREG_UNINITIALIZED if there is an error in
+	 * registration.
+	 */
+	BUG_ON(dev->reg_state != NETREG_UNREGISTERED &&
+	       dev->reg_state != NETREG_UNINITIALIZED);
 
-	BUG_ON(dev->reg_state != NETREG_UNREGISTERED);
-	dev->reg_state = NETREG_RELEASED;
+	if (dev->reg_state != NETREG_UNINITIALIZED)
+		dev->reg_state = NETREG_RELEASED;
 
 	/* will free via device release */
 	put_device(&dev->dev);
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 865ba6ca16eb..f76066870c67 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1626,7 +1626,11 @@ static void netdev_release(struct device *d)
 {
 	struct net_device *dev = to_net_dev(d);
 
-	BUG_ON(dev->reg_state != NETREG_RELEASED);
+	/* reg_state is NETREG_UNINITIALIZED if there is an error in
+	 * registration.
+	 */
+	BUG_ON(dev->reg_state != NETREG_RELEASED &&
+	       dev->reg_state != NETREG_UNINITIALIZED);
 
 	/* no need to wait for rcu grace period:
 	 * device is dead and about to be freed.
-- 
2.17.1

