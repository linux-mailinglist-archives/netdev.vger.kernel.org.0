Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0662A558C98
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 03:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiFXBGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 21:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiFXBGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 21:06:15 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C82B25DF0F;
        Thu, 23 Jun 2022 18:06:11 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.190.64.135])
        by mail-app2 (Coremail) with SMTP id by_KCgCHjorsDbViLh+JAg--.57370S4;
        Fri, 24 Jun 2022 09:06:05 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org, pabeni@redhat.com
Cc:     ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net v3 2/2] net: rose: fix null-ptr-deref caused by rose_kill_by_neigh
Date:   Fri, 24 Jun 2022 09:05:45 +0800
Message-Id: <c31f454f74833b2003713fffa881aabb190b8290.1656031586.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1656031586.git.duoming@zju.edu.cn>
References: <cover.1656031586.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1656031586.git.duoming@zju.edu.cn>
References: <cover.1656031586.git.duoming@zju.edu.cn>
X-CM-TRANSID: by_KCgCHjorsDbViLh+JAg--.57370S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJw1fGr1kXFyrXw4fAFWfGrg_yoW5uF43pr
        9xKrW3Grs7Jw4DWF4DJF1Uur40vF1q9F9rJrW09F92y3Z8GrWjvrykKFWUWr15XFsrGFya
        gF1UW34SyrnFyw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk21xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
        GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
        8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv
        6cx26r4fKr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGw
        C20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48J
        MIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMI
        IF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
        87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAg4KAVZdtaXsswA3s0
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
Changes since v2:
  - v2: Fix refcount leak of sock.

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

