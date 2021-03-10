Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B8633394C
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhCJJ4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 04:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhCJJ4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 04:56:41 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9F2C06174A
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 01:56:40 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso7194101pjb.3
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 01:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TIohQZ6rfzxEjaeiZdt6pQXFidKIY80O92T4njC0Lzo=;
        b=onaEjaN5h7y5mZELI7Bh9xkoNQ6DXezddhohGcttiv0ZL9PQoUzMXgV77/EehoBqNx
         7PjqEl7vxyXlHEdeXMdVB7u4x3aHv535rt2YqSXmpgDklzdn0SPDdkkxHvXt6cPQ9fyx
         iP6Zb5/ygBg9O5XLoI9iML4sCyNokqxIbE+3nQSwMsEC7LpWvUb4uqR6C8vINQjRRA5M
         VeRAT+lXh2tlXJRFS4h3F2squeRK6OW/v9GB7uoztiJ78WvVO+K3GsA+ehlSTWW1Ju9m
         Sz3pUmgthjHEdR/62GICJckNblyHOss/zhUb+m3OZunLe4eVVJ1a430OEX09oUUf9swN
         XNow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TIohQZ6rfzxEjaeiZdt6pQXFidKIY80O92T4njC0Lzo=;
        b=VW6QuRDcrzSTWJGUHFX5RpOoOZVZInb2cxn9QgiAJlMPj66Uj2njw4cblrTMAWV/M6
         RAjDhvjbzDP5+i3er51/S0hsMQreOunno5lETblsrXcxTlNVkvWlbITM0q4i5jZWbUEb
         SX5UyMeJXxHEM80eLxHvyVXB/8Lo9S0cX5T0CTdNkkaUbWm2ubryF24C3YLuRCZxRCkz
         uhUE90+/NmIyT+4pZ/IEe5ccRcFm8QFiCzhv615v2mzAxpIa257jjTU6zjqfkCIT6WHn
         Ypn040gg1l3Sriu0ym8OKCuQRhLa8l0txQm5TQQTin919tyd71xdAZVOH04hWirUjFkc
         Yqfw==
X-Gm-Message-State: AOAM530rTDhxlHzjkJgipsJ9ExZXGHeU5rpgHt9CpflcgslYZa8vp9uD
        0UjuPYhQmSrQQ4hiWAGV28SyQMiqx60=
X-Google-Smtp-Source: ABdhPJxf51x/ZFemuLCS0yVzP8wcmykuZk0m7WaUR1u8rj1Lwrufb9YBTtAeshjXk/2ThBdcEz0lWQ==
X-Received: by 2002:a17:902:9a0c:b029:e5:fedb:92c6 with SMTP id v12-20020a1709029a0cb02900e5fedb92c6mr2064085plp.59.1615370200479;
        Wed, 10 Mar 2021 01:56:40 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:98ce:157a:580f:2400])
        by smtp.gmail.com with ESMTPSA id il6sm5427609pjb.56.2021.03.10.01.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 01:56:39 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] macvlan: macvlan_count_rx() needs to be aware of preemption
Date:   Wed, 10 Mar 2021 01:56:36 -0800
Message-Id: <20210310095636.202881-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

macvlan_count_rx() can be called from process context, it is thus
necessary to disable preemption before calling u64_stats_update_begin()

syzbot was able to spot this on 32bit arch:

WARNING: CPU: 1 PID: 4632 at include/linux/seqlock.h:271 __seqprop_assert include/linux/seqlock.h:271 [inline]
WARNING: CPU: 1 PID: 4632 at include/linux/seqlock.h:271 __seqprop_assert.constprop.0+0xf0/0x11c include/linux/seqlock.h:269
Modules linked in:
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 4632 Comm: kworker/1:3 Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: ARM-Versatile Express
Workqueue: events macvlan_process_broadcast
Backtrace:
[<82740468>] (dump_backtrace) from [<827406dc>] (show_stack+0x18/0x1c arch/arm/kernel/traps.c:252)
 r7:00000080 r6:60000093 r5:00000000 r4:8422a3c4
[<827406c4>] (show_stack) from [<82751b58>] (__dump_stack lib/dump_stack.c:79 [inline])
[<827406c4>] (show_stack) from [<82751b58>] (dump_stack+0xb8/0xe8 lib/dump_stack.c:120)
[<82751aa0>] (dump_stack) from [<82741270>] (panic+0x130/0x378 kernel/panic.c:231)
 r7:830209b4 r6:84069ea4 r5:00000000 r4:844350d0
[<82741140>] (panic) from [<80244924>] (__warn+0xb0/0x164 kernel/panic.c:605)
 r3:8404ec8c r2:00000000 r1:00000000 r0:830209b4
 r7:0000010f
[<80244874>] (__warn) from [<82741520>] (warn_slowpath_fmt+0x68/0xd4 kernel/panic.c:628)
 r7:81363f70 r6:0000010f r5:83018e50 r4:00000000
[<827414bc>] (warn_slowpath_fmt) from [<81363f70>] (__seqprop_assert include/linux/seqlock.h:271 [inline])
[<827414bc>] (warn_slowpath_fmt) from [<81363f70>] (__seqprop_assert.constprop.0+0xf0/0x11c include/linux/seqlock.h:269)
 r8:5a109000 r7:0000000f r6:a568dac0 r5:89802300 r4:00000001
[<81363e80>] (__seqprop_assert.constprop.0) from [<81364af0>] (u64_stats_update_begin include/linux/u64_stats_sync.h:128 [inline])
[<81363e80>] (__seqprop_assert.constprop.0) from [<81364af0>] (macvlan_count_rx include/linux/if_macvlan.h:47 [inline])
[<81363e80>] (__seqprop_assert.constprop.0) from [<81364af0>] (macvlan_broadcast+0x154/0x26c drivers/net/macvlan.c:291)
 r5:89802300 r4:8a927740
[<8136499c>] (macvlan_broadcast) from [<81365020>] (macvlan_process_broadcast+0x258/0x2d0 drivers/net/macvlan.c:317)
 r10:81364f78 r9:8a86d000 r8:8a9c7e7c r7:8413aa5c r6:00000000 r5:00000000
 r4:89802840
[<81364dc8>] (macvlan_process_broadcast) from [<802696a4>] (process_one_work+0x2d4/0x998 kernel/workqueue.c:2275)
 r10:00000008 r9:8404ec98 r8:84367a02 r7:ddfe6400 r6:ddfe2d40 r5:898dac80
 r4:8a86d43c
[<802693d0>] (process_one_work) from [<80269dcc>] (worker_thread+0x64/0x54c kernel/workqueue.c:2421)
 r10:00000008 r9:8a9c6000 r8:84006d00 r7:ddfe2d78 r6:898dac94 r5:ddfe2d40
 r4:898dac80
[<80269d68>] (worker_thread) from [<80271f40>] (kthread+0x184/0x1a4 kernel/kthread.c:292)
 r10:85247e64 r9:898dac80 r8:80269d68 r7:00000000 r6:8a9c6000 r5:89a2ee40
 r4:8a97bd00
[<80271dbc>] (kthread) from [<80200114>] (ret_from_fork+0x14/0x20 arch/arm/kernel/entry-common.S:158)
Exception stack(0x8a9c7fb0 to 0x8a9c7ff8)

Fixes: 412ca1550cbe ("macvlan: Move broadcasts into a work queue")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/linux/if_macvlan.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/if_macvlan.h b/include/linux/if_macvlan.h
index 96556c64c95daeff81775132ea93f9758e8d6f27..10c94a3936ca76c782a7e4080046088e83969c1a 100644
--- a/include/linux/if_macvlan.h
+++ b/include/linux/if_macvlan.h
@@ -43,13 +43,14 @@ static inline void macvlan_count_rx(const struct macvlan_dev *vlan,
 	if (likely(success)) {
 		struct vlan_pcpu_stats *pcpu_stats;
 
-		pcpu_stats = this_cpu_ptr(vlan->pcpu_stats);
+		pcpu_stats = get_cpu_ptr(vlan->pcpu_stats);
 		u64_stats_update_begin(&pcpu_stats->syncp);
 		pcpu_stats->rx_packets++;
 		pcpu_stats->rx_bytes += len;
 		if (multicast)
 			pcpu_stats->rx_multicast++;
 		u64_stats_update_end(&pcpu_stats->syncp);
+		put_cpu_ptr(vlan->pcpu_stats);
 	} else {
 		this_cpu_inc(vlan->pcpu_stats->rx_errors);
 	}
-- 
2.30.1.766.gb4fecdf3b7-goog

