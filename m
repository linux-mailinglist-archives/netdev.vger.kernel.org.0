Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18EE6637EA0
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 18:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiKXRxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 12:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiKXRwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 12:52:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5EB109599
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 09:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669312312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fSdsuSrgjDopfALOvm1rrQFXbKKGllyvaK04VepISNM=;
        b=ROZhYJSnMBkW7V74pFqn0WJV7L9KGyDe5wMJ2rwgPLq3obJDQKZHMQkEXL3GIYM3eyl8Xl
        fDqPFEs7poIT1o0Ix44Nw08To1A4xu58VjQQ5TZ//9bQWtGDmnZLjBHmTMTjMKb0OvquHk
        vZwuAvEmG5GxKPeYY4mVQ4tBMgKfyJc=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-422-fWR4Wk77M6OhsPKpPyEpTA-1; Thu, 24 Nov 2022 12:51:50 -0500
X-MC-Unique: fWR4Wk77M6OhsPKpPyEpTA-1
Received: by mail-pj1-f69.google.com with SMTP id x8-20020a17090a6b4800b00218ae9b2a47so1425553pjl.6
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 09:51:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fSdsuSrgjDopfALOvm1rrQFXbKKGllyvaK04VepISNM=;
        b=c+B2Ug+VYBicaJbJyvWUEDMYT7IQODgNMEGgq4zL/5nWh9P3ILXcAqFT/4jd818zmj
         E8H2oqY0Qn/+NUHUPIt4OLL5vtjcaVStz/DtyqrB2D3hLGByAFnMbDl7jGdG7cZ2JRek
         EanlyhhacNXp7/mlZfQU12Iaj6Hz0KqTxGcP9sPvu9gDJLedTMjezqV7ZsXzYXUh/E16
         G81Rao+okU0rsMkP0Lvo/+OT6ChOgo1zIgGo0CVBib9BqTz+LkOuQ7faI4POAM2YMpMK
         fOR/g/wmjOx740bI/kW4rLjcWiy5dXbJ87bk7twMcsooRAahNR1bHuDXpQqZfq4LZr6M
         avyA==
X-Gm-Message-State: ANoB5pm/BjiNT8WwSDRC/SbrfjBotemOwA0yA4EbvCOTBXiEVozIRvXu
        ECEtDPIje8idPTHCfcbRnnTcyZZL1aqXSFw1SmaYx2G67y2iz/dLDcvUzvW82YwVBiJs3J7/VK3
        N9Z6LSpr04OYeFk+q
X-Received: by 2002:a17:902:ce0e:b0:172:86a2:8e68 with SMTP id k14-20020a170902ce0e00b0017286a28e68mr15973645plg.27.1669312309285;
        Thu, 24 Nov 2022 09:51:49 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7QJlepYjWsZ1z1GX6KIUy8Kfes+LstjyEEIEoRwJESdyt5NKcP15Q7qZbt8DdJt0ShoBwspw==
X-Received: by 2002:a17:902:ce0e:b0:172:86a2:8e68 with SMTP id k14-20020a170902ce0e00b0017286a28e68mr15973615plg.27.1669312308591;
        Thu, 24 Nov 2022 09:51:48 -0800 (PST)
Received: from ryzen.. ([240d:1a:c0d:9f00:fc9c:8ee9:e32c:2d9])
        by smtp.gmail.com with ESMTPSA id y75-20020a62644e000000b0056ee49d6e95sm1484968pfb.86.2022.11.24.09.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 09:51:48 -0800 (PST)
From:   Shigeru Yoshida <syoshida@redhat.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, jasowang@redhat.com,
        Shigeru Yoshida <syoshida@redhat.com>,
        syzbot+106f9b687cd64ee70cd1@syzkaller.appspotmail.com
Subject: [PATCH v3] net: tun: Fix use-after-free in tun_detach()
Date:   Fri, 25 Nov 2022 02:51:34 +0900
Message-Id: <20221124175134.1589053-1-syoshida@redhat.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported use-after-free in tun_detach() [1].  This causes call
trace like below:

==================================================================
BUG: KASAN: use-after-free in notifier_call_chain+0x1ee/0x200 kernel/notifier.c:75
Read of size 8 at addr ffff88807324e2a8 by task syz-executor.0/3673

CPU: 0 PID: 3673 Comm: syz-executor.0 Not tainted 6.1.0-rc5-syzkaller-00044-gcc675d22e422 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:284 [inline]
 print_report+0x15e/0x461 mm/kasan/report.c:395
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:495
 notifier_call_chain+0x1ee/0x200 kernel/notifier.c:75
 call_netdevice_notifiers_info+0x86/0x130 net/core/dev.c:1942
 call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
 call_netdevice_notifiers net/core/dev.c:1997 [inline]
 netdev_wait_allrefs_any net/core/dev.c:10237 [inline]
 netdev_run_todo+0xbc6/0x1100 net/core/dev.c:10351
 tun_detach drivers/net/tun.c:704 [inline]
 tun_chr_close+0xe4/0x190 drivers/net/tun.c:3467
 __fput+0x27c/0xa90 fs/file_table.c:320
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xb3d/0x2a30 kernel/exit.c:820
 do_group_exit+0xd4/0x2a0 kernel/exit.c:950
 get_signal+0x21b1/0x2440 kernel/signal.c:2858
 arch_do_signal_or_restart+0x86/0x2300 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The cause of the issue is that sock_put() from __tun_detach() drops
last reference count for struct net, and then notifier_call_chain()
from netdev_state_change() accesses that struct net.

This patch fixes the issue by calling sock_put() from tun_detach()
after all necessary accesses for the struct net has done.

Fixes: 83c1f36f9880 ("tun: send netlink notification when the device is modified")
Reported-by: syzbot+106f9b687cd64ee70cd1@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=96eb7f1ce75ef933697f24eeab928c4a716edefe [1]
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
---
v3:
- Remove redundant synchronize_rcu()
v2:
- Include symbolic stack trace
- Add Fixes and Reported-by tags
v1: https://lore.kernel.org/all/20221119075615.723290-1-syoshida@redhat.com/
---
 drivers/net/tun.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7a3ab3427369..24001112c323 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -686,7 +686,6 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 		if (tun)
 			xdp_rxq_info_unreg(&tfile->xdp_rxq);
 		ptr_ring_cleanup(&tfile->tx_ring, tun_ptr_free);
-		sock_put(&tfile->sk);
 	}
 }
 
@@ -702,6 +701,9 @@ static void tun_detach(struct tun_file *tfile, bool clean)
 	if (dev)
 		netdev_state_change(dev);
 	rtnl_unlock();
+
+	if (clean)
+		sock_put(&tfile->sk);
 }
 
 static void tun_detach_all(struct net_device *dev)
-- 
2.38.1

