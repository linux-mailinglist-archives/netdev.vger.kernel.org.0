Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB05FCC26
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 18:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfKNRwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 12:52:20 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35748 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfKNRwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 12:52:20 -0500
Received: by mail-pg1-f194.google.com with SMTP id q22so4255990pgk.2
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 09:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jBDUmMt7/9zS26HPfLauv870PTGw3OXQB+3fIAOqgDI=;
        b=F3GhGVjPWYN66GqXvIBbS+kZ7K2DRogLcKg81LNSvbN46p+Qe9QUchX4j0Hl62LQjZ
         MiSQm48QfSImzULts4YtImBnMMImmDC3TVpcGPCuehkDCgnjHpYwBOC6deYGr7e29Tak
         lnfXWnWyviq/aFbm/3qoRqg7YB/uFRCqOG/6aLu6imp8g+QLcM/ITOJcpaJak61/HSlG
         Lwud2Ttx0dn18RULea1Uic6aizc5Aub/EyIbSfqIM1sGEOK4mZVnBKFSVWk131P6uXiC
         wuF1U0T7ZND3JdfFyNkIyVtT2f4jFBD1+tmwtRdPcDfJ1dWSKVgCwaPXucoytY2ALBzX
         BDkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jBDUmMt7/9zS26HPfLauv870PTGw3OXQB+3fIAOqgDI=;
        b=qZDqUqPc3ofJ5Kjjx2LjedxbGDYf4tNMrg/YzTG7w1yX9AzFyn4IKZ/VxW7Mp7b8+e
         0Nd2AFeOGDfGqE8vleXQiatbHp5Ob9RbM5+Iz1YtUJk2u65MwLCniI53Wf2ofjPmc8k6
         RqKl/khuFHxIEMY3fF5JWu6CvSLXrV6fX+iKQ1RcdjdVZvntx5pTdu/II66W9GngcYeY
         8K5tO2SMC0OxorwDxAoLbPrXHVGgIfWnrk+/6xZi6k4psgwZGkFBR0syNMSkUS/DsPPM
         TKlE083zelntpVCLYn/Abw3v6+5M1NhZBTGFuNn1bPJie+7t+PI74Qc/r1VeGPN2AqML
         XzoA==
X-Gm-Message-State: APjAAAXQOC54COM6NoFub923O+/Qkv8uPDqtwQk2oI8i0SGwj3WGFOuf
        HnFBBzAutmeAHBHCEcei5OWudcH9
X-Google-Smtp-Source: APXvYqz/nKj+PLcmLCzSd0kNWqs6anI0I03gkjO8tKOnhDWDRdUCxDuRUQ9vUhBru7gWd+3DhaqIKg==
X-Received: by 2002:a63:7210:: with SMTP id n16mr10874434pgc.397.1573753939638;
        Thu, 14 Nov 2019 09:52:19 -0800 (PST)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id y8sm7200070pfl.8.2019.11.14.09.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 09:52:19 -0800 (PST)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com,
        Petar Penkov <ppenkov@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [net-next] tun: fix data-race in gro_normal_list()
Date:   Thu, 14 Nov 2019 09:52:09 -0800
Message-Id: <20191114175209.205382-1-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petar Penkov <ppenkov@google.com>

There is a race in the TUN driver between napi_busy_loop and
napi_gro_frags. This commit resolves the race by adding the NAPI struct
via netif_tx_napi_add, instead of netif_napi_add, which disables polling
for the NAPI struct.

KCSAN reported:
BUG: KCSAN: data-race in gro_normal_list.part.0 / napi_busy_loop

write to 0xffff8880b5d474b0 of 4 bytes by task 11205 on cpu 0:
 gro_normal_list.part.0+0x77/0xb0 net/core/dev.c:5682
 gro_normal_list net/core/dev.c:5678 [inline]
 gro_normal_one net/core/dev.c:5692 [inline]
 napi_frags_finish net/core/dev.c:5705 [inline]
 napi_gro_frags+0x625/0x770 net/core/dev.c:5778
 tun_get_user+0x2150/0x26a0 drivers/net/tun.c:1976
 tun_chr_write_iter+0x79/0xd0 drivers/net/tun.c:2022
 call_write_iter include/linux/fs.h:1895 [inline]
 do_iter_readv_writev+0x487/0x5b0 fs/read_write.c:693
 do_iter_write fs/read_write.c:970 [inline]
 do_iter_write+0x13b/0x3c0 fs/read_write.c:951
 vfs_writev+0x118/0x1c0 fs/read_write.c:1015
 do_writev+0xe3/0x250 fs/read_write.c:1058
 __do_sys_writev fs/read_write.c:1131 [inline]
 __se_sys_writev fs/read_write.c:1128 [inline]
 __x64_sys_writev+0x4e/0x60 fs/read_write.c:1128
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

read to 0xffff8880b5d474b0 of 4 bytes by task 11168 on cpu 1:
 gro_normal_list net/core/dev.c:5678 [inline]
 napi_busy_loop+0xda/0x4f0 net/core/dev.c:6126
 sk_busy_loop include/net/busy_poll.h:108 [inline]
 __skb_recv_udp+0x4ad/0x560 net/ipv4/udp.c:1689
 udpv6_recvmsg+0x29e/0xe90 net/ipv6/udp.c:288
 inet6_recvmsg+0xbb/0x240 net/ipv6/af_inet6.c:592
 sock_recvmsg_nosec net/socket.c:871 [inline]
 sock_recvmsg net/socket.c:889 [inline]
 sock_recvmsg+0x92/0xb0 net/socket.c:885
 sock_read_iter+0x15f/0x1e0 net/socket.c:967
 call_read_iter include/linux/fs.h:1889 [inline]
 new_sync_read+0x389/0x4f0 fs/read_write.c:414
 __vfs_read+0xb1/0xc0 fs/read_write.c:427
 vfs_read fs/read_write.c:461 [inline]
 vfs_read+0x143/0x2c0 fs/read_write.c:446
 ksys_read+0xd5/0x1b0 fs/read_write.c:587
 __do_sys_read fs/read_write.c:597 [inline]
 __se_sys_read fs/read_write.c:595 [inline]
 __x64_sys_read+0x4c/0x60 fs/read_write.c:595
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 11168 Comm: syz-executor.0 Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 943170998b20 ("tun: enable NAPI for TUN/TAP driver")
Signed-off-by: Petar Penkov <ppenkov@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 drivers/net/tun.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index dcb63f1f9110..683d371e6e82 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -313,8 +313,8 @@ static void tun_napi_init(struct tun_struct *tun, struct tun_file *tfile,
 	tfile->napi_enabled = napi_en;
 	tfile->napi_frags_enabled = napi_en && napi_frags;
 	if (napi_en) {
-		netif_napi_add(tun->dev, &tfile->napi, tun_napi_poll,
-			       NAPI_POLL_WEIGHT);
+		netif_tx_napi_add(tun->dev, &tfile->napi, tun_napi_poll,
+				  NAPI_POLL_WEIGHT);
 		napi_enable(&tfile->napi);
 	}
 }
-- 
2.24.0.432.g9d3f5f5b63-goog

