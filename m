Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D64FC525
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 12:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfKNLNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 06:13:54 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46932 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfKNLNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 06:13:53 -0500
Received: by mail-lj1-f194.google.com with SMTP id e9so6197661ljp.13
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 03:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=RvY3+YNr2ELI1l1t+zgYft/TUShWupvx30AxUYL7RsU=;
        b=hLKf2zheDCMbKjNYROqoByIaSZEtX7MI/0XO+XsIPteOeU9JFleucyrL0+d261t+F/
         sEZMhocyCRXCm5pPCrGZV946t9B8Ek/b+8cFM7dYlz3IgAPPWAmR1xUnd7je8mU3TChI
         bsrXqtVXmVkicOQfJRv+rFHJ+3pGaVZNYI0CPweFl5fqFYsM3pAZCfynS2RQxoZhrjIg
         PBjedYLNhTujblF5ReA8qCDSUsbjxgwdU3w/etoL5Rx4DaQjAbpKQgwu7P4nBMAxLV/r
         T1PxQlwxtTSiGZGg+sGyZHIBLTa2/z8Gs0zqDxwDoK63wviU/OT3z7DocI1U0zlojaHk
         dQSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RvY3+YNr2ELI1l1t+zgYft/TUShWupvx30AxUYL7RsU=;
        b=nICLwLDiaRMav9gWzDv7Ss/Eqw3HS5qY6ZNCXO/0hqQ8J+0SXokTpBB1E1seu2/+z4
         8kJ2KDsmkvH38Byu/GTh0k7F3y9Cb08/Tod114WQ57Ww/r5a8+XLD7X8ksQejKHM8NnS
         ojHXNZ9iU9XYQYPV4lBj+WUU9RmnigtcT3nSjefAiras/hgR26XlDz6+UDpOZTD/9ftl
         mA9wFwBCcAaJVw9+/D1xjKfWSU4RGpknfqYV4kdqIwbWqVX0/6ZuOe6+t7vfBSfEbq0A
         TYokPDolhJR3pw3UGu/fvFnxgDz4lv/6hzfohn250YXVq9Jdt8RP2dihkGWhRIPSu/3O
         z2Ew==
X-Gm-Message-State: APjAAAWyTDPqMDBx2GJTCXcInKoQKdGrDaEbWjSyqLFKg4J68K1Q/fNw
        puMaLGzyQzx4hHVf5/9v39M6H/O8VNYf2w==
X-Google-Smtp-Source: APXvYqyYWV7NFNCcgTYEx6c/SjyjH8y86c41GmR97lbuD1paLAiXXF6WBWfRI9KN8mrnCbo1Io+DqQ==
X-Received: by 2002:a2e:b4eb:: with SMTP id s11mr6179185ljm.38.1573730031620;
        Thu, 14 Nov 2019 03:13:51 -0800 (PST)
Received: from localhost.localdomain ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id z127sm2486097lfa.19.2019.11.14.03.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 03:13:50 -0800 (PST)
From:   jouni.hogander@unikie.com
To:     netdev@vger.kernel.org
Cc:     Jouni Hogander <jouni.hogander@unikie.com>,
        David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] net-sysfs: Fix memory leak in register_queue_kobjects
Date:   Thu, 14 Nov 2019 13:13:25 +0200
Message-Id: <20191114111325.2027-1-jouni.hogander@unikie.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jouni Hogander <jouni.hogander@unikie.com>

net_rx_queue_update_kobjects and netdev_queue_update_kobjects are
leaking memory in their error paths. Leak was originally reported
by Syzkaller:

BUG: memory leak
unreferenced object 0xffff8880679f8b08 (size 8):
  comm "netdev_register", pid 269, jiffies 4294693094 (age 12.132s)
  hex dump (first 8 bytes):
    72 78 2d 30 00 36 20 d4                          rx-0.6 .
  backtrace:
    [<000000008c93818e>] __kmalloc_track_caller+0x16e/0x290
    [<000000001f2e4e49>] kvasprintf+0xb1/0x140
    [<000000007f313394>] kvasprintf_const+0x56/0x160
    [<00000000aeca11c8>] kobject_set_name_vargs+0x5b/0x140
    [<0000000073a0367c>] kobject_init_and_add+0xd8/0x170
    [<0000000088838e4b>] net_rx_queue_update_kobjects+0x152/0x560
    [<000000006be5f104>] netdev_register_kobject+0x210/0x380
    [<00000000e31dab9d>] register_netdevice+0xa1b/0xf00
    [<00000000f68b2465>] __tun_chr_ioctl+0x20d5/0x3dd0
    [<000000004c50599f>] tun_chr_ioctl+0x2f/0x40
    [<00000000bbd4c317>] do_vfs_ioctl+0x1c7/0x1510
    [<00000000d4c59e8f>] ksys_ioctl+0x99/0xb0
    [<00000000946aea81>] __x64_sys_ioctl+0x78/0xb0
    [<0000000038d946e5>] do_syscall_64+0x16f/0x580
    [<00000000e0aa5d8f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<00000000285b3d1a>] 0xffffffffffffffff

Cc: David Miller <davem@davemloft.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
---
 net/core/net-sysfs.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 865ba6ca16eb..2f44c6a3bcae 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -923,20 +923,25 @@ static int rx_queue_add_kobject(struct net_device *dev, int index)
 	error = kobject_init_and_add(kobj, &rx_queue_ktype, NULL,
 				     "rx-%u", index);
 	if (error)
-		return error;
+		goto err_init_and_add;
 
 	dev_hold(queue->dev);
 
 	if (dev->sysfs_rx_queue_group) {
 		error = sysfs_create_group(kobj, dev->sysfs_rx_queue_group);
-		if (error) {
-			kobject_put(kobj);
-			return error;
-		}
+		if (error)
+			goto err_sysfs_create;
 	}
 
 	kobject_uevent(kobj, KOBJ_ADD);
 
+	return error;
+
+err_sysfs_create:
+	kobject_put(kobj);
+err_init_and_add:
+	kfree_const(kobj->name);
+
 	return error;
 }
 #endif /* CONFIG_SYSFS */
@@ -968,6 +973,7 @@ net_rx_queue_update_kobjects(struct net_device *dev, int old_num, int new_num)
 		if (dev->sysfs_rx_queue_group)
 			sysfs_remove_group(kobj, dev->sysfs_rx_queue_group);
 		kobject_put(kobj);
+		kfree_const(kobj->name);
 	}
 
 	return error;
@@ -1461,21 +1467,28 @@ static int netdev_queue_add_kobject(struct net_device *dev, int index)
 	error = kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
 				     "tx-%u", index);
 	if (error)
-		return error;
+		goto err_init_and_add;
 
 	dev_hold(queue->dev);
 
 #ifdef CONFIG_BQL
 	error = sysfs_create_group(kobj, &dql_group);
-	if (error) {
-		kobject_put(kobj);
-		return error;
-	}
+	if (error)
+		goto err_sysfs_create;
 #endif
 
 	kobject_uevent(kobj, KOBJ_ADD);
 
 	return 0;
+
+#ifdef CONFIG_BQL
+err_sysfs_create:
+	kobject_put(kobj);
+#endif
+err_init_and_add:
+	kfree_const(kobj->name);
+
+	return error;
 }
 #endif /* CONFIG_SYSFS */
 
@@ -1503,6 +1516,7 @@ netdev_queue_update_kobjects(struct net_device *dev, int old_num, int new_num)
 		sysfs_remove_group(&queue->kobj, &dql_group);
 #endif
 		kobject_put(&queue->kobj);
+		kfree_const(queue->kobj.name);
 	}
 
 	return error;
-- 
2.17.1

