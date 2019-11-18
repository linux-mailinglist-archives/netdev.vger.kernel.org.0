Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 550C91005B0
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 13:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfKRMdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 07:33:00 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42317 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfKRMdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 07:33:00 -0500
Received: by mail-lf1-f66.google.com with SMTP id z12so13651972lfj.9
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 04:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=JqS6F/NvcdlzSVsZSI7ZaBdsSIbg8detX6L6Sx+apK0=;
        b=aLtLVPopu2Vll3B2v+MMGbXYGwPTCbm0SeS330LPIhRXd1UMOzU8Ui7VCIjhMYiRZI
         gwm15F63abwDiq6JizT2OTfsPBKcUmiUx4tEcMoJ83hs5/4q6ZjUS0Io7Q4pPRUlqJZm
         0wyJuZKZhltWVgoLqIBReOwqVbeRHmz99CEhDYWdqAjDJqU5frvHs52WK+QHxsGs71h1
         3FfI1xlwzatOnu7YbT2HMmdgDGOrTJMCRN81ZW66lKJKEwEoKGCiIRpK8DdvKZ7lhyJ1
         Z1VxVKgkkJGazTzlyOZprVtJXVje9DFNfZyhbb2I11/CVkyZZBTH+OxsEdu9XmLb81Y6
         zMAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JqS6F/NvcdlzSVsZSI7ZaBdsSIbg8detX6L6Sx+apK0=;
        b=ougx3F6yaQZzeZ0OrZ4L5oa5kG/8FtWkwfIqJY4Pl6Xhmw/hliQI5Qh7BRfsJSVq4K
         QE4FiAzx55DTaqH6ku6D8qCXiM1vL8De+rUn50Z5eYVdUY9X7StZbYMw14Yb+WETo2A3
         2G4WwrU+gDD8PB81J32U8ytxS972luViLOm3GSOiwcrA5X0K0PS7IEQXa5LKrWPLFcI3
         j/rOPYoJHWa988XXyWoEo6qg1a+uQrU223iahbDgyB3qkklHGw8U7ZQQWBFR7v2BnC7T
         HX5spGxOBpgtjYbNyGjxHluB6qsKzp5snb2uUVTT7JqCW8xdHyZsYxd+ANJqhPUkgKUc
         Kaww==
X-Gm-Message-State: APjAAAWgpLNwEZsqu+ll95moWwHtIy0RGlNXQmr7etFYjBktUKZaWJnC
        XfILCiN73GBv1iJtiIlG/s08QKkBIz4=
X-Google-Smtp-Source: APXvYqxe2UiE9vEyjKshBkQ3zsEkrC1isRwNS/ZRGHJA81gWx7jvP+g64fbJm59cliKf2iFsa5MbcA==
X-Received: by 2002:a19:5509:: with SMTP id n9mr8501955lfe.27.1574080376135;
        Mon, 18 Nov 2019 04:32:56 -0800 (PST)
Received: from localhost.localdomain ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id i8sm8750926lfl.80.2019.11.18.04.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 04:32:55 -0800 (PST)
From:   jouni.hogander@unikie.com
To:     netdev@vger.kernel.org
Cc:     Jouni Hogander <jouni.hogander@unikie.com>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH v3] net-sysfs: Fix reference count leak
Date:   Mon, 18 Nov 2019 14:32:46 +0200
Message-Id: <20191118123246.27618-1-jouni.hogander@unikie.com>
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

Reported-by: syzbot+ad8ca40ecd77896d51e2@syzkaller.appspotmail.com
Cc: David Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
---
v2 -> v3:
* Replaced BUG_ON with WARN_ON in free_netdev and netdev_release
v1 -> v2:
* Relying on driver calling free_netdev rather than calling
  put_device directly in error path
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

