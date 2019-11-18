Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E36D310054E
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 13:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfKRMHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 07:07:14 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40639 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfKRMHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 07:07:14 -0500
Received: by mail-lj1-f194.google.com with SMTP id q2so18655690ljg.7
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 04:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=ehv1YhJh7G1Dt/ALm5NaJwWTi478fLewVPzKAwhadQs=;
        b=z2ubnHj+cxm3wFNNHUfFbQz4H9XH5JamqykN54XN529Z3K0dWZk9nx5zWkHdVVuHSg
         zC2yJ7Z5XeYqtcfC4Zt/KJCIUSZ4+ElQsxnCIjAGCpBapCpcjgfFgv3wfmDNxYNeUzSB
         mX3kGkIHcGDK9Ej4JMaLF61p7ljJrDMjaFD7njMlahc20SsYmLCKy0S+UfoQBl34Lnvc
         E6kGtBWEoPF3MOaAIz8CzkA0RfQrJD9CCBKAQnUaOeRncCp57NhGMprE+EpsfVzGoRqw
         Qz0nphhQ7GJVsGTOODI0WsGbHL9BHaeVor8xrj6yaLlQxG2k1HY0jFy0vAQdDLRB/kLw
         aPgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ehv1YhJh7G1Dt/ALm5NaJwWTi478fLewVPzKAwhadQs=;
        b=O3BLohcWRhMlWKP+W+6onF+A/dfzsAMwSBnhEkGNX+s7llT9mG0kWVIKMqUXTO7agP
         9YY7Uk6Cv42KgiuskmjKWcEckMiiRg3MGsPG4xp9Phzxf/pYPmkSFdxWc9jwrJpcJT6C
         aOc4AV4YlG9mRcRNyq+n474T8Q4E0XQgi9E17LzRvUm3OAbDKYyxqLfWj3moWz5x7PdY
         8OToMK1QaYlVAsBlsciUyjcK+uvFbvPseJIL/vMZPdk/20eD4eicT+NQo07Sr91j+owt
         Bs2oPCp3qN+323D42BJ90ra291TR6VFLQODq2p2KDkUlILU0JSarTRf37GQ8azfstdcE
         wS9A==
X-Gm-Message-State: APjAAAVWxdnUa2Q6YGT/Bep1NZt61ihUa0zK7lQzV/d1skWPXdYc3HPj
        Jr4qqgMODYBAjxIYKqS9HCoZOTmfut4=
X-Google-Smtp-Source: APXvYqzKaBv5cNtLWyNr30qTnHvseImNYq3hQsOHC43xz0YcDV3mFBNSpI4fTW0qOi1tf6K8JK407A==
X-Received: by 2002:a2e:8919:: with SMTP id d25mr20970423lji.97.1574078830951;
        Mon, 18 Nov 2019 04:07:10 -0800 (PST)
Received: from localhost.localdomain ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id 13sm1578243lfr.78.2019.11.18.04.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 04:07:10 -0800 (PST)
From:   jouni.hogander@unikie.com
To:     netdev@vger.kernel.org
Cc:     Jouni Hogander <jouni.hogander@unikie.com>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH v3] net-sysfs: Fix reference count leak
Date:   Mon, 18 Nov 2019 14:06:50 +0200
Message-Id: <20191118120650.12597-1-jouni.hogander@unikie.com>
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

Also replace BUG_ON with WARN_ON in free_netdev and in netdev_release.

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

v2 -> v3:
* Replaced BUG_ON with WARN_ON in free_netdev and netdev_release

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
index 99ac84ff398f..1d6c0bfb5ec5 100644
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
+	WARN_ON(dev->reg_state != NETREG_UNREGISTERED &&
+		dev->reg_state != NETREG_UNINITIALIZED);
 
-	BUG_ON(dev->reg_state != NETREG_UNREGISTERED);
-	dev->reg_state = NETREG_RELEASED;
+	if (dev->reg_state != NETREG_UNINITIALIZED)
+		dev->reg_state = NETREG_RELEASED;
 
 	/* will free via device release */
 	put_device(&dev->dev);
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 865ba6ca16eb..11f1e3b4b18f 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1626,7 +1626,11 @@ static void netdev_release(struct device *d)
 {
 	struct net_device *dev = to_net_dev(d);
 
-	BUG_ON(dev->reg_state != NETREG_RELEASED);
+	/* reg_state is NETREG_UNINITIALIZED if there is an error in
+	 * registration.
+	 */
+	WARN_ON(dev->reg_state != NETREG_RELEASED &&
+		dev->reg_state != NETREG_UNINITIALIZED);
 
 	/* no need to wait for rcu grace period:
 	 * device is dead and about to be freed.
-- 
2.17.1

