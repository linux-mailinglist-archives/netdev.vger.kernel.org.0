Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72E0C142481
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 08:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgATHwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 02:52:13 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36248 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgATHwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 02:52:13 -0500
Received: by mail-lf1-f67.google.com with SMTP id f24so2151200lfh.3
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 23:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Q78jxLq69yQ8+I6v+H+QE4BBQ/QqocKA2/SoMWdhnBA=;
        b=vZxYQ+u4lgsk0Kg3Vw0ToQ6fiCv02hvBdRKr1Th3x/LMsi4fCUPAGzHIULNedGghnn
         OtnCp77zvThc3wZeLltHtqvWRiDqWsQ90JAgJYbHG8vKoA3cOA2CoYxqgB4cAgLReesY
         XPEYJF5JxFz2eeK4SATbWA/Xo6CdD7QVuKhGDZl4CGQPRxPrH9ocOeYtxylTS5zEwN5f
         6gtuN1Q+mYfVWpXtHzc3A2Kq7kSr/c5Qb+pzQCbxcetbgfHpc9Oy8u3FATyAYT3XYTUR
         LaeSsERMHKG9W3/KCF8eS3e2HgERSE5EonQdfJCL5TkSrVxnPW2lm0RR2T3p1seu72F5
         awoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Q78jxLq69yQ8+I6v+H+QE4BBQ/QqocKA2/SoMWdhnBA=;
        b=WhNjOuqVhtJbiBfVP06uBLBj2pZVKrFXyxb3SQQI02vN1Dae7sKHqE3Kcc7L3/3fOB
         FLMZDXFrNf50p46jY+fG3mTNPR7OrQyF/aw3u88DGycfIV8hkk5Gyb1mLTLAwckQXGI2
         ZLx4p/7fGorodJTUQHAT4mUIh7IqlHNKkNBz/G6/hI5vfHflKdZdDzfxrDXulFLtxm6y
         I+iY0Dxuf4HMDKPUi1WEwWkNpERV1gQ+HItOpowMKxN706TIaS0LMSmsCXqhj4Wxp2Yy
         TAAJqSC+Us/ztbxJ2iJdU1DkLYMzyoEll+r9YHqdyDz2vK6IMbPmxWlZ1i330qQ4dgJY
         vR8g==
X-Gm-Message-State: APjAAAVxuUbEfYQ+RKYciJTHTQ8B7cOKpXivOvJLUI7EGELMCAeojzhZ
        a0uL7lrdUwPNAbW17o7F+xv45D67YzR2CA==
X-Google-Smtp-Source: APXvYqxn1feHcslTsiHgSJmcok6Dyfu7lxZZ+P1P4Yafuxu7hANTrITA8FlNzR9rZawWdvdCPkbAtg==
X-Received: by 2002:ac2:5983:: with SMTP id w3mr12588402lfn.137.1579506730488;
        Sun, 19 Jan 2020 23:52:10 -0800 (PST)
Received: from localhost.localdomain ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id y21sm613291lfy.46.2020.01.19.23.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2020 23:52:10 -0800 (PST)
From:   jouni.hogander@unikie.com
To:     netdev@vger.kernel.org
Cc:     Jouni Hogander <jouni.hogander@unikie.com>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH v4] net-sysfs: Fix reference count leak
Date:   Mon, 20 Jan 2020 09:51:03 +0200
Message-Id: <20200120075103.30551-1-jouni.hogander@unikie.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191118112553.4271-1-jouni.hogander@unikie.com>
References: <20191118112553.4271-1-jouni.hogander@unikie.com>
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

Fix this by setting reg_state as NETREG_UNREGISTERED if registering
fails.

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

v3 -> v4:
  Set reg_state to NETREG_UNREGISTERED if registering fails

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
 net/core/dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7e885d069707..e82e9b82dfd9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9302,8 +9302,10 @@ int register_netdevice(struct net_device *dev)
 		goto err_uninit;
 
 	ret = netdev_register_kobject(dev);
-	if (ret)
+	if (ret) {
+		dev->reg_state = NETREG_UNREGISTERED;
 		goto err_uninit;
+	}
 	dev->reg_state = NETREG_REGISTERED;
 
 	__netdev_update_features(dev);
-- 
2.17.1

