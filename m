Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 974F9FAFF1
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 12:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbfKMLpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 06:45:16 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36601 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfKMLpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 06:45:15 -0500
Received: by mail-lj1-f195.google.com with SMTP id k15so2220835lja.3
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 03:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=I7AXy12/5YKS0SrI4dBiI52jTw8405fp8A1nlbMdo4Q=;
        b=uu2Gg0vrd6k541IGPN+E7zAoGBg6QMbJGWAWourVcAqga3dX/+NMV6oBHPodYG5vjP
         wESSJSzbMddudXeeHDKYfBAYqGuj+8c96fVcksJ83LN3kxYJG19MXCZ3uUw6HvcLPyaj
         Oi47/ly4GvF5wd/Lu7hf7Nvi1+5q1vmg7ojvlXa9zX9kZ2CcZNf5TTOpUULbBVbJuzbp
         VaKXk2cFRVQmssdysPn2V2z/RCZEVg1CH5t269jtvCLW0mk7U5gBPe/EDVmuyuoO3tbU
         13DzDf2/hQNqnMFswRsF/K8Zs8hs9+4RtwQosbSk8y9xULzwQHqZloIaQGbMxv9NHpT6
         XfmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=I7AXy12/5YKS0SrI4dBiI52jTw8405fp8A1nlbMdo4Q=;
        b=oFH1DZcoDO73pylSlEcfbeUO1wbaTiiT00j0AW/gI0VrX7LFQiSkPagNpNHYDuc8RN
         UorVEsVE1rIyuBl06WQSFbQhyDqY6sRYZ7TOO3WvJtp3tQqJhAf5Ry98LQBXkKs+6QzW
         n30NJoqWHKteBZ8W+2+Mwaz5CIzjH+mdXertSH2Y06u2+BKEM9ILq6RHLd1llkM72sit
         aZiiSdWt3jH57n8yDrsyXT0BGP0cP8fI9ulU4ipMG3sFKIeCn3Oi/VX28Aeqx6HNGPy9
         nthwbh5nRtvo4cqt/bts5bVrnFyC9IcWuFe0eaLA46qoWrjR4akOZEp58aPhucHak5Dp
         gWpw==
X-Gm-Message-State: APjAAAUfX88wcQygES/d4AUIeeUigQU01r5xlS6tVUwmmVIIGB/bVJQ+
        c3YkfXTbcmvMpECTb4eGjc1P+qFoX3daMA==
X-Google-Smtp-Source: APXvYqzK2F09AT9Xqg79xxpXg85BWYFqz70FhFvcoBXlOFGdHNoQ7h3kkZ/esXp2erJXHbgRV+sDLg==
X-Received: by 2002:a2e:8654:: with SMTP id i20mr2292651ljj.224.1573645513743;
        Wed, 13 Nov 2019 03:45:13 -0800 (PST)
Received: from localhost.localdomain ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id y75sm950146lff.58.2019.11.13.03.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 03:45:13 -0800 (PST)
From:   jouni.hogander@unikie.com
To:     netdev@vger.kernel.org
Cc:     Jouni Hogander <jouni.hogander@unikie.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] slip: Fix memory leak in slip_open error path
Date:   Wed, 13 Nov 2019 13:45:02 +0200
Message-Id: <20191113114502.22462-1-jouni.hogander@unikie.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jouni Hogander <jouni.hogander@unikie.com>

Driver/net/can/slcan.c is derived from slip.c. Memory leak was detected
by Syzkaller in slcan. Same issue exists in slip.c and this patch is
addressing the leak in slip.c.

Here is the slcan memory leak trace reported by Syzkaller:

BUG: memory leak unreferenced object 0xffff888067f65500 (size 4096):
  comm "syz-executor043", pid 454, jiffies 4294759719 (age 11.930s)
  hex dump (first 32 bytes):
    73 6c 63 61 6e 30 00 00 00 00 00 00 00 00 00 00 slcan0..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
  backtrace:
    [<00000000a06eec0d>] __kmalloc+0x18b/0x2c0
    [<0000000083306e66>] kvmalloc_node+0x3a/0xc0
    [<000000006ac27f87>] alloc_netdev_mqs+0x17a/0x1080
    [<0000000061a996c9>] slcan_open+0x3ae/0x9a0
    [<000000001226f0f9>] tty_ldisc_open.isra.1+0x76/0xc0
    [<0000000019289631>] tty_set_ldisc+0x28c/0x5f0
    [<000000004de5a617>] tty_ioctl+0x48d/0x1590
    [<00000000daef496f>] do_vfs_ioctl+0x1c7/0x1510
    [<0000000059068dbc>] ksys_ioctl+0x99/0xb0
    [<000000009a6eb334>] __x64_sys_ioctl+0x78/0xb0
    [<0000000053d0332e>] do_syscall_64+0x16f/0x580
    [<0000000021b83b99>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<000000008ea75434>] 0xfffffffffffffff

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
---
 drivers/net/slip/slip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index cac64b96d545..4d479e3c817d 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -855,6 +855,7 @@ static int slip_open(struct tty_struct *tty)
 	sl->tty = NULL;
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
+	free_netdev(sl->dev);
 
 err_exit:
 	rtnl_unlock();
-- 
2.17.1

