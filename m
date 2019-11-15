Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF109FDD6C
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 13:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfKOMYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 07:24:30 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42834 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbfKOMY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 07:24:29 -0500
Received: by mail-lj1-f196.google.com with SMTP id n5so10483124ljc.9
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 04:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=bzv6XndTwiYdKwJoxLwMZ+hMreX7E/3CphCS/5v6cp0=;
        b=psy+B1bEoEB+Jt3zNXyhlhkv7hz9QrzCGzkyGg/R2J6R0+saZR+xgxU2z4+qvbFHY6
         sIe+pEO/FyauUw0U+T0f6/Bjp22T+DEjJHBoBPsgkRZPdEmTFj1mbzV/OdRKd1M0mPGz
         lSQDvTaB3IAuFCsesfsUcfGD6FnhlWDl9wPzW2ItK55OlJocscxj9zO8dyFrH6fQTiRh
         LbXjJpLfyhfAjEb7wLCM2TkUcpgTVx7jsoqLHYgpSbjihVDWEIO1ajO42wVaGOyp7HFH
         H6q+xZV5rXpIYYb+vdcOhKeqkb0sHiKyAUhyOXkrQMvo3BZQlbk+bEEPYPpUNUuZKOrx
         /0cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bzv6XndTwiYdKwJoxLwMZ+hMreX7E/3CphCS/5v6cp0=;
        b=KXbfTLQdm/Ll82/Hw3uBhec1B9degXQvuj2BXvCv9B2OcFbfLeSxWJ4JAnJOMLT0Bc
         HBPSNiNA8mDuCaQeyGRiKB4yw81IaL3XmU7ixiCoJu7ROZ3DAMFsTkFDzm6nUwstkB16
         vnlHZwR+PFb8Jmszc5B+Y2cctwDphQcIR1wYrjB7PmBP6LSl3eC8dgXPr4U+7N+Dq7cL
         ChvL8trPuGtvWP9bE1IT/V+xs8j7PJKrCZUc1+N6k+Zh39AoIQbSXYnm+uSgegah5iqi
         vGtwYvWidLm1hOyZ7ijlSIXOSdjpQEBTMiQPw+J785Fg8GNVH4KxR21PMPmOOiDKPwnr
         csQA==
X-Gm-Message-State: APjAAAU3OoJfg3bCz/29MOS3eHwE7BVKAWI/ZP0OOQOJOMjgTZUcQ9i5
        Caj+ms9hIlWJSLMeDD+wDBor3Ru6kCY=
X-Google-Smtp-Source: APXvYqwLV6rTZf0f4qgfoh+vBw9ypl2I4IyXzmLHtdAr+C1kndiv6MGnameGYe0+L3RCs+NfiKvFnQ==
X-Received: by 2002:a2e:b0d9:: with SMTP id g25mr10471242ljl.176.1573820667102;
        Fri, 15 Nov 2019 04:24:27 -0800 (PST)
Received: from localhost.localdomain ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id b28sm4525060ljp.9.2019.11.15.04.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 04:24:26 -0800 (PST)
From:   jouni.hogander@unikie.com
To:     netdev@vger.kernel.org
Cc:     Jouni Hogander <jouni.hogander@unikie.com>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] net-sysfs: Fix reference count leak
Date:   Fri, 15 Nov 2019 14:24:12 +0200
Message-Id: <20191115122412.2595-1-jouni.hogander@unikie.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jouni Hogander <jouni.hogander@unikie.com>

Netdev_register_kobject is calling device_initialize. In case of error
reference taken by device_initialize is not given up. This is
the rootcause for couple of memory leaks reported by Syzkaller:

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
 net/core/net-sysfs.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 865ba6ca16eb..72ecad583953 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1626,6 +1626,12 @@ static void netdev_release(struct device *d)
 {
 	struct net_device *dev = to_net_dev(d);
 
+	/* Triggered by an error clean-up (put_device) during
+	 * initialization.
+	 */
+	if (dev->reg_state == NETREG_UNINITIALIZED)
+		return;
+
 	BUG_ON(dev->reg_state != NETREG_RELEASED);
 
 	/* no need to wait for rcu grace period:
@@ -1745,16 +1751,21 @@ int netdev_register_kobject(struct net_device *ndev)
 
 	error = device_add(dev);
 	if (error)
-		return error;
+		goto err_device_add;
 
 	error = register_queue_kobjects(ndev);
-	if (error) {
-		device_del(dev);
-		return error;
-	}
+	if (error)
+		goto err_register_queue_kobjects;
 
 	pm_runtime_set_memalloc_noio(dev, true);
 
+	return error;
+
+err_register_queue_kobjects:
+	device_del(dev);
+err_device_add:
+	put_device(dev);
+
 	return error;
 }
 
-- 
2.17.1

