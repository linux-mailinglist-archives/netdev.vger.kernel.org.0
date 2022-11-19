Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E10630D18
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 08:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbiKSH5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 02:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKSH5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 02:57:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F674FFB1
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 23:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668844586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oop6ZAvV1b5arBaLgtXt5J9GRGtip/WQKXGjVoxJr6g=;
        b=L2YUXwWUAuPTZWR63Kx5yFT7s3zwZJvxVNV/6s1gk1jeCtWvhZ9NhjWasjigSKTFhCzlqr
        iGEmnE18MQggwXJtX8oR/qkjy61zJSks/npbfRsNYbNVkmVDzd1+Kp7U5cqWAmrIWbetrp
        hvt5bpkJP92uykm+FBUYEgczbyOd0jI=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-383-Ea75re1UMc-_HtjyY6ht3w-1; Sat, 19 Nov 2022 02:56:22 -0500
X-MC-Unique: Ea75re1UMc-_HtjyY6ht3w-1
Received: by mail-pg1-f199.google.com with SMTP id x16-20020a63b210000000b0045f5c1e18d0so4276792pge.0
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 23:56:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oop6ZAvV1b5arBaLgtXt5J9GRGtip/WQKXGjVoxJr6g=;
        b=wzyYAMcFan3bEZzwgsjUUoCagSA52jXhIVQaXqhq4xlHmZMfFwK9DNedrmwHp1sG3w
         +k2GYcLc3JloHh7tRjMkTcs2abiJnJ/usGpMxvQTFTTyDmfTAAyNf74Q45/ebgKWQeC7
         bPkKSWPciVe7gHLHMKAJ9sEGX4+g6XU2WI8idmADbYHvGZhPdMIpUjrr8NgkGJhuvO/e
         6CgdtKhmnJkB9nN42/ybA5g7d1EtKa1uF4TGD+5bRJC1bkKGGM/KWPAoAtcDEce/aP/a
         tCqhJNSAr3OZjrOdCzWihPrGxe8FBFqH2kMuA08Ffu1QgDSnxqxTD2QBlI4FMF2O962n
         pqLg==
X-Gm-Message-State: ANoB5pkOAVmfBDyzUYI77XRR1nkxo2d5VAQay0cUaQtiMN0FrJSuL0pZ
        UlHenBp6FmjaWPwUE+AS2eqfe3Vxfxxg3+/sSE0NaCMNnF222X5MhB/yemMXRDtLY1MPm5Lg/TI
        fHNNCK2+dWguaul7E
X-Received: by 2002:a17:902:bc4b:b0:188:5340:4a38 with SMTP id t11-20020a170902bc4b00b0018853404a38mr2998912plz.34.1668844581893;
        Fri, 18 Nov 2022 23:56:21 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6I3O1lJMkDsmUe9INoKisifhBf5DDeds8aWr40Qqj/QpOwA3nfKp4JZBlwS22zOYYpjoU3OQ==
X-Received: by 2002:a17:902:bc4b:b0:188:5340:4a38 with SMTP id t11-20020a170902bc4b00b0018853404a38mr2998894plz.34.1668844581641;
        Fri, 18 Nov 2022 23:56:21 -0800 (PST)
Received: from ryzen.. ([240d:1a:c0d:9f00:fc9c:8ee9:e32c:2d9])
        by smtp.gmail.com with ESMTPSA id qe1-20020a17090b4f8100b00210039560c0sm6636821pjb.49.2022.11.18.23.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 23:56:21 -0800 (PST)
From:   Shigeru Yoshida <syoshida@redhat.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Shigeru Yoshida <syoshida@redhat.com>
Subject: [PATCH] net: tun: Fix use-after-free in tun_detach()
Date:   Sat, 19 Nov 2022 16:56:15 +0900
Message-Id: <20221119075615.723290-1-syoshida@redhat.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported use-after-free in tun_detach() [1].  This causes call
trace like below:

==================================================================
BUG: KASAN: use-after-free in notifier_call_chain+0x1da/0x1e0
...
Call Trace:
 <TASK>
 dump_stack_lvl+0x100/0x178
 print_report+0x167/0x470
 ? __virt_addr_valid+0x5e/0x2d0
 ? __phys_addr+0xc6/0x140
 ? notifier_call_chain+0x1da/0x1e0
 ? notifier_call_chain+0x1da/0x1e0
 kasan_report+0xbf/0x1e0
 ? notifier_call_chain+0x1da/0x1e0
 notifier_call_chain+0x1da/0x1e0
 call_netdevice_notifiers_info+0x83/0x130
 netdev_run_todo+0xc33/0x11b0
 ? generic_xdp_install+0x490/0x490
 ? __tun_detach+0x1500/0x1500
 tun_chr_close+0xe2/0x190
 __fput+0x26a/0xa40
 task_work_run+0x14d/0x240
 ? task_work_cancel+0x30/0x30
 do_exit+0xb31/0x2a40
 ? reacquire_held_locks+0x4a0/0x4a0
 ? do_raw_spin_lock+0x12e/0x2b0
 ? mm_update_next_owner+0x7c0/0x7c0
 ? rwlock_bug.part.0+0x90/0x90
 ? lockdep_hardirqs_on_prepare+0x17f/0x410
 do_group_exit+0xd4/0x2a0
 __x64_sys_exit_group+0x3e/0x50
 do_syscall_64+0x38/0xb0
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The cause of the issue is that sock_put() from __tun_detach() drops
last reference count for struct net, and then notifier_call_chain()
from netdev_state_change() accesses that struct net.

This patch fixes the issue by calling sock_put() from tun_detach()
after all necessary accesses for the struct net has done.

Link: https://syzkaller.appspot.com/bug?id=96eb7f1ce75ef933697f24eeab928c4a716edefe [1]
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
---
 drivers/net/tun.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7a3ab3427369..ce9fcf4c8ef4 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -686,7 +686,6 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 		if (tun)
 			xdp_rxq_info_unreg(&tfile->xdp_rxq);
 		ptr_ring_cleanup(&tfile->tx_ring, tun_ptr_free);
-		sock_put(&tfile->sk);
 	}
 }
 
@@ -702,6 +701,11 @@ static void tun_detach(struct tun_file *tfile, bool clean)
 	if (dev)
 		netdev_state_change(dev);
 	rtnl_unlock();
+
+	if (clean) {
+		synchronize_rcu();
+		sock_put(&tfile->sk);
+	}
 }
 
 static void tun_detach_all(struct net_device *dev)
-- 
2.38.1

