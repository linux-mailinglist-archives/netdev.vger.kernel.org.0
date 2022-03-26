Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23774E7FAB
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 07:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbiCZHBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 03:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbiCZHBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 03:01:18 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 005D658E76;
        Fri, 25 Mar 2022 23:59:40 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app2 (Coremail) with SMTP id by_KCgCXOZTDuT5iK3SBAA--.58940S2;
        Sat, 26 Mar 2022 14:59:28 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     netdev@vger.kernel.org
Cc:     linux-x25@vger.kernel.org, linux-kernel@vger.kernel.org,
        ms@dev.tdt.de, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, tanxin.ctf@gmail.com, linma@zju.edu.cn,
        xiyuyang19@fudan.edu.cn, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net] net/x25: Fix null-ptr-deref caused by x25_disconnect
Date:   Sat, 26 Mar 2022 14:59:12 +0800
Message-Id: <20220326065912.41077-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgCXOZTDuT5iK3SBAA--.58940S2
X-Coremail-Antispam: 1UD129KBjvJXoW7urWfZr1xJw43Wr4UCw17Wrg_yoW8WrW8pF
        y2yrWkW34DJ3909rs7CFykurn2vwsFgw18Xr15u34Skr9xGrWqvryrKrZIgw13WFs3AFyj
        vr1UWwsxJF4kCFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvl1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
        6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28I
        cxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJV
        W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
        1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
        IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
        x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
        DU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgwPAVZdtYygQQACsR
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous commit 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when
x25 disconnect") adds decrement of refcount of x25->neighbour and sets
x25->neighbour to NULL in x25_disconnect(), but when the link layer is
terminating, it could cause null-ptr-deref bugs in x25_sendmsg(),
x25_recvmsg() and x25_connect(). One of the bugs is shown below.

x25_link_terminated()          | x25_recvmsg()
 x25_kill_by_neigh()           |  ...
  x25_disconnect()             |  lock_sock(sk)
   ...                         |  ...
   x25->neighbour = NULL //(1) |
   ...                         |  x25->neighbour->extended //(2)

We set NULL to x25->neighbour in position (1) and dereference
x25->neighbour in position (2), which could cause null-ptr-deref bug.

This patch adds lock_sock(sk) in x25_disconnect() in order to synchronize
with x25_sendmsg(), x25_recvmsg() and x25_connect(). What`s more, the sk
held by lock_sock() is not NULL, because it is extracted from x25_list
and uses x25_list_lock to synchronize.

Fixes: 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 disconnect")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 net/x25/x25_subr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/x25/x25_subr.c b/net/x25/x25_subr.c
index 0285aaa1e93..4e19752bdd0 100644
--- a/net/x25/x25_subr.c
+++ b/net/x25/x25_subr.c
@@ -360,7 +360,9 @@ void x25_disconnect(struct sock *sk, int reason, unsigned char cause,
 	if (x25->neighbour) {
 		read_lock_bh(&x25_list_lock);
 		x25_neigh_put(x25->neighbour);
+		lock_sock(sk);
 		x25->neighbour = NULL;
+		release_sock(sk);
 		read_unlock_bh(&x25_list_lock);
 	}
 }
-- 
2.17.1

