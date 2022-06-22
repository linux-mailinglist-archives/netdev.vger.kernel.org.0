Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F3E5541E8
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 06:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356743AbiFVE6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 00:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352628AbiFVE6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 00:58:31 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06F58193F3;
        Tue, 21 Jun 2022 21:58:22 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.190.66.207])
        by mail-app2 (Coremail) with SMTP id by_KCgAHFVJNobJiUFNcAg--.15149S4;
        Wed, 22 Jun 2022 12:58:10 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net v2 2/2] net: rose: fix null-ptr-deref caused by rose_kill_by_neigh
Date:   Wed, 22 Jun 2022 12:57:48 +0800
Message-Id: <1ff88b1d5de81a12a33e577a19a6c949b0f7b864.1655871645.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1655871645.git.duoming@zju.edu.cn>
References: <cover.1655871645.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1655871645.git.duoming@zju.edu.cn>
References: <cover.1655871645.git.duoming@zju.edu.cn>
X-CM-TRANSID: by_KCgAHFVJNobJiUFNcAg--.15149S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJw1fGr1kXFyrXw4fAFWfGrg_yoW5uF4Upr
        9xKFW3Grs7Jw4DWF4DJF1Uur40vF1q9F9rWrW09F92y3Z8GrWjvrykKFWUWr15XFsrGFya
        gF1UW34SyrnFyw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPI1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
        6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI
        7VAKI48JMxAIw28IcVCjz48v1sIEY20_GFWkJr1UJwCF54CYxVAaw2AFwI0_JF0_Jw1l4c
        8EcI0Ec7CjxVAaw2AFwI0_ZF0_GFyUMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
        rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8Zw
        CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
        67AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr
        0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd
        -B_UUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgIJAVZdtaVy3wALs1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the link layer connection is broken, the rose->neighbour is
set to null. But rose->neighbour could be used by rose_connection()
and rose_release() later, because there is no synchronization among
them. As a result, the null-ptr-deref bugs will happen.

One of the null-ptr-deref bugs is shown below:

    (thread 1)                  |        (thread 2)
                                |  rose_connect
rose_kill_by_neigh              |    lock_sock(sk)
  spin_lock_bh(&rose_list_lock) |    if (!rose->neighbour)
  rose->neighbour = NULL;//(1)  |
                                |    rose->neighbour->use++;//(2)

The rose->neighbour is set to null in position (1) and dereferenced
in position (2).

The KASAN report triggered by POC is shown below:

KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
...
RIP: 0010:rose_connect+0x6c2/0xf30
RSP: 0018:ffff88800ab47d60 EFLAGS: 00000206
RAX: 0000000000000005 RBX: 000000000000002a RCX: 0000000000000000
RDX: ffff88800ab38000 RSI: ffff88800ab47e48 RDI: ffff88800ab38309
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffed1001567062
R10: dfffe91001567063 R11: 1ffff11001567061 R12: 1ffff11000d17cd0
R13: ffff8880068be680 R14: 0000000000000002 R15: 1ffff11000d17cd0
...
Call Trace:
  <TASK>
  ? __local_bh_enable_ip+0x54/0x80
  ? selinux_netlbl_socket_connect+0x26/0x30
  ? rose_bind+0x5b0/0x5b0
  __sys_connect+0x216/0x280
  __x64_sys_connect+0x71/0x80
  do_syscall_64+0x43/0x90
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

This patch adds lock_sock() in rose_kill_by_neigh() in order to
synchronize with rose_connect() and rose_release().

Meanwhile, this patch adds sock_hold() protected by rose_list_lock
that could synchronize with rose_remove_socket() in order to mitigate
UAF bug caused by lock_sock() we add.

What's more, there is no need using rose_neigh_list_lock to protect
rose_kill_by_neigh(). Because we have already used rose_neigh_list_lock
to protect the state change of rose_neigh in rose_link_failed(), which
is well synchronized.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in v2:
  - Fix refcount leak of sock.

 net/rose/af_rose.c    | 6 ++++++
 net/rose/rose_route.c | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index bf2d986a6bc..5caa222c490 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -169,9 +169,15 @@ void rose_kill_by_neigh(struct rose_neigh *neigh)
 		struct rose_sock *rose = rose_sk(s);
 
 		if (rose->neighbour == neigh) {
+			sock_hold(s);
 			rose_disconnect(s, ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
 			rose->neighbour->use--;
+			spin_unlock_bh(&rose_list_lock);
+			lock_sock(s);
 			rose->neighbour = NULL;
+			release_sock(s);
+			spin_lock_bh(&rose_list_lock);
+			sock_put(s);
 		}
 	}
 	spin_unlock_bh(&rose_list_lock);
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index fee6409c2bb..b116828b422 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -827,7 +827,9 @@ void rose_link_failed(ax25_cb *ax25, int reason)
 		ax25_cb_put(ax25);
 
 		rose_del_route_by_neigh(rose_neigh);
+		spin_unlock_bh(&rose_neigh_list_lock);
 		rose_kill_by_neigh(rose_neigh);
+		return;
 	}
 	spin_unlock_bh(&rose_neigh_list_lock);
 }
-- 
2.17.1

