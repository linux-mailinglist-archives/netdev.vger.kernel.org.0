Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7611034D0
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 08:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfKTHIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 02:08:31 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33620 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfKTHIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 02:08:30 -0500
Received: by mail-lf1-f65.google.com with SMTP id d6so19268269lfc.0
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 23:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=rCfbeD7G07Jn9t2krPhRa+p06jbA96TDRZuHPMaGxOQ=;
        b=0nGMj5PfbLvtm0kiyaF1UbKjG7nhGjNNUfFMvfiwvmXOpkgwXZ2AW94VOkEcW97ba2
         GZ+wNoT4KiHQhTBl1Df6RSes5B3P8jJdamte2YnBzHycGo9y4zcNbYuIpQRdHGfTXToo
         1NrPt2ROUOUExL8Y1aIrZvkX/OVy3z08NmWnpA7IC3GryPyuoePpqw/DgR1O4RC+Pmae
         dEwOjnr3SMmNNwCRhOj+AXIZgKoK1s6O2ddYsne03m8b+KYInKP1AWyO7liVv5yom3H+
         bkqx/AhDvzesom6t7hd8glt3Lh+RQ8u9F1/yDyBUqEEmCQeEa5UndUCf1jhvoALZ7iwD
         il+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rCfbeD7G07Jn9t2krPhRa+p06jbA96TDRZuHPMaGxOQ=;
        b=M+uXFbuet87W19I+fHq++s8J6hs3YT3XKZIlbt8enbIqKOEm/z3y8OHtyjjPppjQyo
         laRt883IH/XJN/MzI5Xg5tAt5MdaNukp2jtgDPTZwYV3wLM9Og4J5YSMvWAyoeorNkPJ
         KEyR4dUb8U6PF/zHl9xUI24S6pI9wYdzW6AB9jMpdzsOnChoFrF4guSa1j9xbrPP+GUi
         ZYRMaajnu6eGZy0VOGEajyuLCOcl7mlFp2vzPsXxkNfmTnzoxia5uPQdsHleKkM4RzRy
         iNaxCTaE4GDKi76QQ4rhoTirLjPqTpN+5zLvRd4n8hmttzmqF0ZYnDEW6mrIYZ6Fsyne
         YvzA==
X-Gm-Message-State: APjAAAXSfu+oGPErHGdpYFaDiNKOwTxi5U5MJIWsDf2SlcaiR8e/84Wz
        qUv/5rRujgznUku64jUSXpK03HzQREk=
X-Google-Smtp-Source: APXvYqxAnaTnksAULMoiPv/1KD51HttHjCTAKbrJhC62ZbZ0OE7Pft4aOW856qaSK88rV2jhgZaxSA==
X-Received: by 2002:a19:7d06:: with SMTP id y6mr1449671lfc.120.1574233708565;
        Tue, 19 Nov 2019 23:08:28 -0800 (PST)
Received: from localhost.localdomain ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id y6sm11208778ljn.40.2019.11.19.23.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 23:08:27 -0800 (PST)
From:   jouni.hogander@unikie.com
To:     netdev@vger.kernel.org
Cc:     Jouni Hogander <jouni.hogander@unikie.com>,
        David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
Date:   Wed, 20 Nov 2019 09:08:16 +0200
Message-Id: <20191120070816.12893-1-jouni.hogander@unikie.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jouni Hogander <jouni.hogander@unikie.com>

kobject_init_and_add takes reference even when it fails. This has
to be given up by the caller in error handling. Otherwise memory
allocated by kobject_init_and_add is never freed. Originally found
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
 net/core/net-sysfs.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 865ba6ca16eb..4f404bf33e44 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -923,21 +923,23 @@ static int rx_queue_add_kobject(struct net_device *dev, int index)
 	error = kobject_init_and_add(kobj, &rx_queue_ktype, NULL,
 				     "rx-%u", index);
 	if (error)
-		return error;
+		goto err;
 
 	dev_hold(queue->dev);
 
 	if (dev->sysfs_rx_queue_group) {
 		error = sysfs_create_group(kobj, dev->sysfs_rx_queue_group);
-		if (error) {
-			kobject_put(kobj);
-			return error;
-		}
+		if (error)
+			goto err;
 	}
 
 	kobject_uevent(kobj, KOBJ_ADD);
 
 	return error;
+
+err:
+	kobject_put(kobj);
+	return error;
 }
 #endif /* CONFIG_SYSFS */
 
@@ -1461,21 +1463,21 @@ static int netdev_queue_add_kobject(struct net_device *dev, int index)
 	error = kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
 				     "tx-%u", index);
 	if (error)
-		return error;
+		goto err;
 
 	dev_hold(queue->dev);
 
 #ifdef CONFIG_BQL
 	error = sysfs_create_group(kobj, &dql_group);
-	if (error) {
-		kobject_put(kobj);
-		return error;
-	}
+	if (error)
+		goto err;
 #endif
 
 	kobject_uevent(kobj, KOBJ_ADD);
 
-	return 0;
+err:
+	kobject_put(kobj);
+	return error;
 }
 #endif /* CONFIG_SYSFS */
 
-- 
2.17.1

