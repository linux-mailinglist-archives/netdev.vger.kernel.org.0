Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5549A108DC0
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 13:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfKYMYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 07:24:18 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41233 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfKYMYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 07:24:18 -0500
Received: by mail-lj1-f195.google.com with SMTP id m4so15580454ljj.8
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 04:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=TlTlmQXLSAY6b+F8finEKkava++Yy2TFyuV91M4FK/c=;
        b=og92FXLKBeiu7TzoWUVFkv/1lmIe8JPniuR4xoaclkp8UXWHJGka6pgYE6jVJ67/nR
         DVZTx5yWHLABuk87wo6NeqPLjxGHOD3aERGaH2bMc4iKfbOb6cRPUhrMNfGifCrApWsf
         pcIjRoRl16EaqtH2MEsydpV/u2noXwB/v/o84Vwj6Ij+qfdTGtlcn0NKsV2asZy/mtpE
         K3YJGcbuFkN6T0xDWW3cZclDPyLeu7Qz+cHXMpL4UAHBbpltfE3D83kjF8/K2u4JxG74
         92VeqCn8LvWLRTSQTPm3J1Zu4MUhjoBor0LdaOVL+nLZgYDUofTuxcUAguzv1NOUHjhn
         LTJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TlTlmQXLSAY6b+F8finEKkava++Yy2TFyuV91M4FK/c=;
        b=KVXI/Flz64iZwvnPP9mwRaoCQ6LTDRv2wShocXv74Qti6jjK/vbCdo+kDYSCgJmy+P
         oAJwPERmHK0z4LCo1S+fW0+lyQVQa7R01fVtTvnlqahMlImNINcZRrMmvB8tttNv/coN
         dlB0Vj+3zgri5iOViBGV+ypMDgNvhvF9yfba3NAGEHL5GzxAidJRLPTvXVkZY5UAhjy7
         u7syxn+SElQCyss7tgeLWv5t1/o0MEYa7N+2yHQqKtHETLrxETDJCnWhCEOI+K3onI2+
         jtlVIhZkN2mMtmsNH7YCZjuHdLqhKujUxGMZfifIioM5BzeoF97075R9xb0EDvFMaK8a
         FjXA==
X-Gm-Message-State: APjAAAXbXWr7t0rMlzXDJnEQWwi6V2Qe/HbNL5nGkqPEqKQD+xtuuseQ
        LskyRC62cWdBWcJv4+5Uk7E10iXWKnY=
X-Google-Smtp-Source: APXvYqzQ1UW4F3Q9FrI32akWIhIMyYKHfbh+nzbS2sGKnsT3suiip/vlYH1uIgLRkgdJL10EeX1iwg==
X-Received: by 2002:a2e:2c19:: with SMTP id s25mr22237695ljs.26.1574684656575;
        Mon, 25 Nov 2019 04:24:16 -0800 (PST)
Received: from localhost.localdomain ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id r12sm3523328lfc.28.2019.11.25.04.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 04:24:16 -0800 (PST)
From:   jouni.hogander@unikie.com
To:     netdev@vger.kernel.org
Cc:     Jouni Hogander <jouni.hogander@unikie.com>,
        David Miller <davem@davemloft.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] slip: Fix use-after-free Read in slip_open
Date:   Mon, 25 Nov 2019 14:23:43 +0200
Message-Id: <20191125122343.17904-1-jouni.hogander@unikie.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jouni Hogander <jouni.hogander@unikie.com>

Slip_open doesn't clean-up device which registration failed from the
slip_devs device list. On next open after failure this list is iterated
and freed device is accessed. Fix this by calling sl_free_netdev in error
path.

Here is the trace from the Syzbot:

__dump_stack lib/dump_stack.c:77 [inline]
dump_stack+0x197/0x210 lib/dump_stack.c:118
print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
__kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
kasan_report+0x12/0x20 mm/kasan/common.c:634
__asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
sl_sync drivers/net/slip/slip.c:725 [inline]
slip_open+0xecd/0x11b7 drivers/net/slip/slip.c:801
tty_ldisc_open.isra.0+0xa3/0x110 drivers/tty/tty_ldisc.c:469
tty_set_ldisc+0x30e/0x6b0 drivers/tty/tty_ldisc.c:596
tiocsetd drivers/tty/tty_io.c:2334 [inline]
tty_ioctl+0xe8d/0x14f0 drivers/tty/tty_io.c:2594
vfs_ioctl fs/ioctl.c:46 [inline]
file_ioctl fs/ioctl.c:509 [inline]
do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
__do_sys_ioctl fs/ioctl.c:720 [inline]
__se_sys_ioctl fs/ioctl.c:718 [inline]
__x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: 3b5a39979daf ("slip: Fix memory leak in slip_open error path")
Reported-by: syzbot+4d5170758f3762109542@syzkaller.appspotmail.com
Cc: David Miller <davem@davemloft.net>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
---
 drivers/net/slip/slip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index 4d479e3c817d..2a91c192659f 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -855,6 +855,7 @@ static int slip_open(struct tty_struct *tty)
 	sl->tty = NULL;
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
+	sl_free_netdev(sl->dev);
 	free_netdev(sl->dev);
 
 err_exit:
-- 
2.17.1

