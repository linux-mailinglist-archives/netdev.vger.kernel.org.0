Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3CE514A622
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 15:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgA0Oam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 09:30:42 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54057 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729186AbgA0Oal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 09:30:41 -0500
Received: by mail-pj1-f67.google.com with SMTP id n96so3014582pjc.3
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 06:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bdXp12rWWIhABbMqabuTQA3uM8UtAWN7EmJVz8e/1f0=;
        b=vaaL8N9lg7WG4Skae9qJZyaKgZ4XiBkWsjtEPQjE/qm6dQlIzJrJ7Fehqdoem4VeY/
         iepmiImxImxP4ZiKBD+c4+fxUwmZQNQF+1uO+qKxooWHaSdUa8m1JHNWlTPYrLApYf7X
         gys2U38Qt/e/2LmTL11+zc6UFClzZ8lX51px91Savn2fm6LHB44eAQAWWnpsO2FS2/WR
         dw0XCy3w0d3HJ46Kj1ynAM1hVUbGi5mCXxbfMkyUEffhNYmI2ieJktzJ8tqPYtLh7BO8
         jQjugAiYyPlx0S+zO7OLxBqKPLZagxpw0AGJFa4jTbjKt8nwJX1q6Y9HFOGNnnDG2/gI
         fWqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bdXp12rWWIhABbMqabuTQA3uM8UtAWN7EmJVz8e/1f0=;
        b=SLwbLRQCKcDVSb9z1czSire3taVnOSRl3LmQkCdYe6vr0IdD4+fZrAa8HEeRTzkH7l
         a0KX8Q9jRmlaFc60pHeT6DoctMQ89uoLu6wWoa6y2LY4djoJS5q7LU9zC5OONSod+S14
         7yCi4puLpI/lbLbr7Upn/qXDXfxOPEcAHz5b399C0EGFU/nCmK6C2p9GcvXrUFNqrx9O
         bG2gpGMslZBZFC7j7c4JAu35rvHMCOTsBR7qkMLCmG5stOKMcMRTefmA3eIUpn6s9a4D
         scO4135QnE2nn6BPSbI3tc79BH5S5oHP9lhwEdUzWIr3SZ31JxEkWQBl/yocU4cClEE8
         3uKw==
X-Gm-Message-State: APjAAAXj9xs70dJv3KUgInhjuhFAn0lnvKxg0F2UE0F3AQr2Rt2oyrIk
        RaULtNESl6AUt3hjNsNVnUDoY/tE
X-Google-Smtp-Source: APXvYqypdux3P5f2or0ANpplbR75vSRQOKqliIFXOntdeaxdKhZAHfU3kjW4HIas3lXsYdG+Z2nrzw==
X-Received: by 2002:a17:902:d918:: with SMTP id c24mr18174789plz.167.1580135441036;
        Mon, 27 Jan 2020 06:30:41 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id v25sm2059441pfe.147.2020.01.27.06.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 06:30:40 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 3/6] netdevsim: fix stack-out-of-bounds in nsim_dev_debugfs_init()
Date:   Mon, 27 Jan 2020 14:30:34 +0000
Message-Id: <20200127143034.1367-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When netdevsim dev is being created, a debugfs directory is created.
The variable "dev_ddir_name" is 16bytes device name pointer and device
name is "netdevsim<dev id>".
The maximum dev id length is 10.
So, 16bytes for device name isn't enough.

Test commands:
    modprobe netdevsim
    echo "1000000000 0" > /sys/bus/netdevsim/new_device

Splat looks like:
[  362.229174][  T889] BUG: KASAN: stack-out-of-bounds in number+0x824/0x880
[  362.230221][  T889] Write of size 1 at addr ffff8880c1def988 by task bash/889
[  362.231541][  T889]
[  362.232116][  T889] CPU: 2 PID: 889 Comm: bash Not tainted 5.5.0-rc6+ #318
[  362.233233][  T889] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  362.237316][  T889] Call Trace:
[  362.237790][  T889]  dump_stack+0x96/0xdb
[  362.238471][  T889]  ? number+0x824/0x880
[  362.239137][  T889]  print_address_description.constprop.5+0x1be/0x360
[  362.240166][  T889]  ? number+0x824/0x880
[  362.240782][  T889]  ? number+0x824/0x880
[  362.254907][  T889]  __kasan_report+0x12a/0x16f
[  362.276693][  T889]  ? number+0x824/0x880
[  362.284345][  T889]  kasan_report+0xe/0x20
[  362.291523][  T889]  number+0x824/0x880
[  362.305981][  T889]  ? put_dec+0xa0/0xa0
[  362.306583][  T889]  ? rcu_read_lock_sched_held+0x90/0xc0
[  362.307779][  T889]  vsnprintf+0x63c/0x10b0
[  362.308440][  T889]  ? pointer+0x5b0/0x5b0
[  362.309068][  T889]  ? mark_lock+0x11d/0xc40
[  362.309740][  T889]  sprintf+0x9b/0xd0
[  362.327152][  T889]  ? scnprintf+0xe0/0xe0
[  362.327888][  T889]  nsim_dev_probe+0x63c/0xbf0 [netdevsim]
[  362.328882][  T889]  ? kernfs_next_descendant_post+0x11d/0x250
[  362.331521][  T889]  ? nsim_dev_reload_up+0x500/0x500 [netdevsim]
[  362.333054][  T889]  ? kernfs_add_one+0x2c6/0x410
[  362.334145][  T889]  ? kernfs_get.part.12+0x4c/0x60
[  362.335181][  T889]  ? kernfs_put+0x29/0x4b0
[  362.335814][  T889]  ? kernfs_create_link+0x170/0x230
[  362.336600][  T889]  ? sysfs_do_create_link_sd.isra.2+0x87/0xf0
[  362.338118][  T889]  really_probe+0x4b2/0xb50
[  362.338789][  T889]  ? driver_allows_async_probing+0x110/0x110
[  362.340055][  T889]  driver_probe_device+0x24d/0x370
[  362.349864][  T889]  ? __device_attach_driver+0xae/0x210
[  362.364057][  T889]  ? driver_allows_async_probing+0x110/0x110
[  362.367598][  T889]  bus_for_each_drv+0x10f/0x190
[  362.371583][  T889]  ? bus_rescan_devices+0x20/0x20
[  362.372524][  T889]  ? mutex_lock_io_nested+0x1380/0x1380
[  362.374546][  T889]  __device_attach+0x1b1/0x2d0
[  362.376621][  T889]  ? device_bind_driver+0xa0/0xa0
[  362.378889][  T889]  ? wait_for_completion+0x390/0x390
[  362.379727][  T889]  bus_probe_device+0x1a7/0x250
[  362.380635][  T889]  device_add+0x1101/0x1900
[  362.381590][  T889]  ? memset+0x1f/0x40
[  362.382409][  T889]  ? lockdep_init_map+0x10c/0x630
[  362.383701][  T889]  ? device_link_remove+0x120/0x120
[  362.386953][  T889]  ? lockdep_init_map+0x10c/0x630
[  362.387656][  T889]  ? __init_waitqueue_head+0x3a/0x90
[  362.388868][  T889]  new_device_store+0x277/0x4c0 [netdevsim]
[  362.389822][  T889]  ? del_port_store+0x160/0x160 [netdevsim]
[ ... ]

Fixes: ab1d0cc004d7 ("netdevsim: change debugfs tree topology")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
 - Update Fixes tag
 - Do not use arbitary 32 bytes for dev_ddir_name

 drivers/net/netdevsim/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 0dfaf999e8db..2c23b232926b 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -87,7 +87,7 @@ static const struct file_operations nsim_dev_take_snapshot_fops = {
 
 static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 {
-	char dev_ddir_name[16];
+	char dev_ddir_name[sizeof(DRV_NAME) + 10];
 
 	sprintf(dev_ddir_name, DRV_NAME "%u", nsim_dev->nsim_bus_dev->dev.id);
 	nsim_dev->ddir = debugfs_create_dir(dev_ddir_name, nsim_dev_ddir);
-- 
2.17.1

