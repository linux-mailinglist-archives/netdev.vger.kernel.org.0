Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF9F138277
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 17:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbgAKQhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 11:37:18 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40851 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729957AbgAKQhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 11:37:17 -0500
Received: by mail-pf1-f195.google.com with SMTP id q8so2687052pfh.7
        for <netdev@vger.kernel.org>; Sat, 11 Jan 2020 08:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eLAImGD0pHCBf56xMSR45b9cn1YCQoioyqesM7JEOBE=;
        b=DIcIzYFnZHEFR12iAsCEspQp1Z7iEU6Fj3IwB4NcCs4uuJSh3gr1JCGM+5XFwbWfGf
         cfVeuq0wCceOM/EzP6ThofVGaIqfUVysaWTfQ40M8lJzUwFuMoKuNawbOOvSbEPsnVrg
         cUUggsloPN4EHwrUh5qhC+exsAMKo9j5R6EWgqEuQMvgsfvJev/i7Zk2iUv+RH9LjEw2
         CxuZS5YneV0X1plX0woWK/TRJdEF0vom/mNYZcQExy/zjY8GlDSjq8X+YuPiFbBEEKXI
         Us++XdBUSxjIx5/OuictUlGEe2lWd0ll0tsZ6T1CgX1Mgutk7GbYU32e34GdwPdTjQ/N
         Jo0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eLAImGD0pHCBf56xMSR45b9cn1YCQoioyqesM7JEOBE=;
        b=E4/3O23UMgzYQ7nWKZfuMmOpJGcrJcGsW24QPcI0yza9s+0kLKl5Zg8qZDyan7RYPC
         wLwm6oyvCQO+it06oE4IJSEIrG5/CyZXYE1uNOLFeDzxN+RPHZRp6L3QUCrTiN98ioMn
         3VMcJgO8O6kctzrc5uOLZMu4c4Wy0O7Zn1RwUlE3FazzSKSZLwSZs4iRo3XGp0NpVrEK
         VgvPBvEI5vNpwkLsr0Ob7LOj5vEmqsM/8OitxmZlcNsfWKbRKYsedPTi1zDG5DSe1BPk
         tZZenasfHsGVKDeCmk5D6j+EiciiGkDLx35kEoENgTn5SLrgRnTLOZgQRqvaWMaAnWpR
         yExQ==
X-Gm-Message-State: APjAAAWB+48kE7aDoi4PyVjvJrn01rltiHNrhF++yx0C0/0cPAJsLriP
        l5WFT17HGJ5fVKkuy4F79GA=
X-Google-Smtp-Source: APXvYqxcQUD87QYu/4jjwznGFQ/oCJ3nTeUPyncNyW3Z7dnzSistTRXBkN7dP0imdx8ztsXol2Gqrg==
X-Received: by 2002:a63:4f54:: with SMTP id p20mr11986580pgl.246.1578760637067;
        Sat, 11 Jan 2020 08:37:17 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id u7sm7430778pfh.128.2020.01.11.08.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 08:37:16 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 2/5] netdevsim: fix stack-out-of-bounds in nsim_dev_debugfs_init()
Date:   Sat, 11 Jan 2020 16:37:09 +0000
Message-Id: <20200111163709.4181-1-ap420073@gmail.com>
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
[   90.624922][ T1000] BUG: KASAN: stack-out-of-bounds in number+0x824/0x880
[   90.626999][ T1000] Write of size 1 at addr ffff8880b7f47988 by task bash/1000
[   90.627798][ T1000]
[   90.628076][ T1000] CPU: 0 PID: 1000 Comm: bash Not tainted 5.5.0-rc5+ #270
[   90.628806][ T1000] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   90.629752][ T1000] Call Trace:
[   90.630080][ T1000]  dump_stack+0x96/0xdb
[   90.630512][ T1000]  ? number+0x824/0x880
[   90.630939][ T1000]  print_address_description.constprop.5+0x1be/0x360
[   90.631610][ T1000]  ? number+0x824/0x880
[   90.632038][ T1000]  ? number+0x824/0x880
[   90.632469][ T1000]  __kasan_report+0x12a/0x16f
[   90.632939][ T1000]  ? number+0x824/0x880
[   90.633397][ T1000]  kasan_report+0xe/0x20
[   90.633954][ T1000]  number+0x824/0x880
[   90.634513][ T1000]  ? put_dec+0xa0/0xa0
[   90.635047][ T1000]  ? rcu_read_lock_sched_held+0x90/0xc0
[   90.636469][ T1000]  vsnprintf+0x63c/0x10b0
[   90.637187][ T1000]  ? pointer+0x5b0/0x5b0
[   90.637871][ T1000]  ? mark_lock+0x11d/0xc40
[   90.638591][ T1000]  sprintf+0x9b/0xd0
[   90.639164][ T1000]  ? scnprintf+0xe0/0xe0
[   90.639802][ T1000]  nsim_dev_probe+0x63c/0xbf0 [netdevsim]
[ ... ]

Fixes: 83c9e13aa39a ("netdevsim: add software driver for testing offloads")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/netdevsim/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 634eb5cdcbbe..a0c80a70bb23 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -88,7 +88,7 @@ static const struct file_operations nsim_dev_take_snapshot_fops = {
 
 static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 {
-	char dev_ddir_name[16];
+	char dev_ddir_name[32];
 
 	sprintf(dev_ddir_name, DRV_NAME "%u", nsim_dev->nsim_bus_dev->dev.id);
 	nsim_dev->ddir = debugfs_create_dir(dev_ddir_name, nsim_dev_ddir);
-- 
2.17.1

