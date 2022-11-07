Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4453661FCAD
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbiKGSEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbiKGSEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:04:34 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994D92936A
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 10:00:13 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id h67-20020a252146000000b006ccc4702068so11846155ybh.12
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 10:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mq6snR+erj1cjamE2ik/ibIOMeeoSb6MN6sNustJNZM=;
        b=N+u4e2IPoNR8Ds6qEht9IxTjGu8jGsMCSeCLGJMTKn0cM1L3RiHipVtUxj5Qb2jWZi
         3B6Lad33NES0xZXKWJJA0cRwkGnUQrMphWDmF203g9n9T28sdDQTSxmCAWhIsUq/kR2Q
         OKuKAhlccGQAQc0sTIaX00OaUAxYwDTqFhbgBhilbsFHyBjdNJdPSTw3w7Hw/AeDXui+
         +6cImslSULtvPR5OI4/q581TyAnmGwr1HDqSbKBfACvLPqYL3jfJ/qlqtJ3t0iMwWIsf
         IxJUUvTd3BtTp47judgNNOmZXiLFC3LXJw+9nUw0H7hYDrK2u//3CZL8nBS8Pg3ERxZS
         luiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mq6snR+erj1cjamE2ik/ibIOMeeoSb6MN6sNustJNZM=;
        b=CybbuVIVPoz4wYv0XC0joUcNucoyZhsYhFPBU+brWuDqc1kxlLQpZVnSIliTnOh2IM
         +vfKELwy8XMIN2RhIDfIVvX99+pam4yyu1hbMOFsmbF7/xM8bccOrLIvMlbbQ+8UcFxv
         xGmagPRnqetLK7QCLPpOjgchyHxBIShEKFhNCGlf7zIuI8uRynlB4agh2D4MIr2fuTxk
         elYqDyQMyyyqkJRR/YzLsgr3DB5kDKXoqub8txLS4XgwUjYj1xF8MIOMFzKoJeBNfYSv
         PSZHCjPwROjtM4FxcRs16G2b0x4eUimEAaf17jMQYS40y2Hc3gkERbyxRO5g4q2bckFL
         Ajhg==
X-Gm-Message-State: ACrzQf3xNnTXDVncf8VBi0pE+N1Vvcsy3brPa8lKLs2SoOX+j1qfFOdv
        haV7XeaKQCxfpX5SfTnuz+9kX5KwhpOt7w==
X-Google-Smtp-Source: AMsMyM7bi6x/wXPWxzl/VjKXqwrC8XAHWaDsejlWv5oEfl0+/UidEfElfHqjS9yn0jq4BU23dyEaLPPUy4dZbg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:84d:0:b0:6be:e218:894e with SMTP id
 v13-20020a5b084d000000b006bee218894emr739050ybq.221.1667844012833; Mon, 07
 Nov 2022 10:00:12 -0800 (PST)
Date:   Mon,  7 Nov 2022 18:00:11 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221107180011.188437-1-edumazet@google.com>
Subject: [PATCH net] net: tun: call napi_schedule_prep() to ensure we own a napi
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Wang Yufen <wangyufen@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent patch exposed another issue in napi_get_frags()
caught by syzbot [1]

Before feeding packets to GRO, and calling napi_complete()
we must first grab NAPI_STATE_SCHED.

[1]
WARNING: CPU: 0 PID: 3612 at net/core/dev.c:6076 napi_complete_done+0x45b/0x880 net/core/dev.c:6076
Modules linked in:
CPU: 0 PID: 3612 Comm: syz-executor408 Not tainted 6.1.0-rc3-syzkaller-00175-g1118b2049d77 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:napi_complete_done+0x45b/0x880 net/core/dev.c:6076
Code: c1 ea 03 0f b6 14 02 4c 89 f0 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 24 04 00 00 41 89 5d 1c e9 73 fc ff ff e8 b5 53 22 fa <0f> 0b e9 82 fe ff ff e8 a9 53 22 fa 48 8b 5c 24 08 31 ff 48 89 de
RSP: 0018:ffffc90003c4f920 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000030 RCX: 0000000000000000
RDX: ffff8880251c0000 RSI: ffffffff875a58db RDI: 0000000000000007
RBP: 0000000000000001 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffff888072d02628
R13: ffff888072d02618 R14: ffff888072d02634 R15: 0000000000000000
FS: 0000555555f13300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055c44d3892b8 CR3: 00000000172d2000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
napi_complete include/linux/netdevice.h:510 [inline]
tun_get_user+0x206d/0x3a60 drivers/net/tun.c:1980
tun_chr_write_iter+0xdb/0x200 drivers/net/tun.c:2027
call_write_iter include/linux/fs.h:2191 [inline]
do_iter_readv_writev+0x20b/0x3b0 fs/read_write.c:735
do_iter_write+0x182/0x700 fs/read_write.c:861
vfs_writev+0x1aa/0x630 fs/read_write.c:934
do_writev+0x133/0x2f0 fs/read_write.c:977
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f37021a3c19

Fixes: 1118b2049d77 ("net: tun: Fix memory leaks of napi_get_frags")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Wang Yufen <wangyufen@huawei.com>
---
 drivers/net/tun.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index eb12f3136a5490afe18f774089a2fa211fd21a54..7a3ab3427369abab7472c3fbb07c24e7031f21b2 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1967,18 +1967,25 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 					  skb_headlen(skb));
 
 		if (unlikely(headlen > skb_headlen(skb))) {
+			WARN_ON_ONCE(1);
+			err = -ENOMEM;
 			dev_core_stats_rx_dropped_inc(tun->dev);
+napi_busy:
 			napi_free_frags(&tfile->napi);
 			rcu_read_unlock();
 			mutex_unlock(&tfile->napi_mutex);
-			WARN_ON(1);
-			return -ENOMEM;
+			return err;
 		}
 
-		local_bh_disable();
-		napi_gro_frags(&tfile->napi);
-		napi_complete(&tfile->napi);
-		local_bh_enable();
+		if (likely(napi_schedule_prep(&tfile->napi))) {
+			local_bh_disable();
+			napi_gro_frags(&tfile->napi);
+			napi_complete(&tfile->napi);
+			local_bh_enable();
+		} else {
+			err = -EBUSY;
+			goto napi_busy;
+		}
 		mutex_unlock(&tfile->napi_mutex);
 	} else if (tfile->napi_enabled) {
 		struct sk_buff_head *queue = &tfile->sk.sk_write_queue;
-- 
2.38.1.431.g37b22c650d-goog

