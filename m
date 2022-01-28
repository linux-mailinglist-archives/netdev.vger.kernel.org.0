Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C7149F2A7
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 05:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346133AbiA1Ezu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 23:55:50 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:40516 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346148AbiA1EzU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 23:55:20 -0500
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app2 (Coremail) with SMTP id by_KCgBHTIRXdfNhomB5AQ--.44160S3;
        Fri, 28 Jan 2022 12:47:25 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     jreuter@yaina.de, ralf@linux-mips.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH 1/2] ax25: improve the incomplete fix to avoid UAF and NPD bugs
Date:   Fri, 28 Jan 2022 12:47:15 +0800
Message-Id: <87e509950a15e85274f902f29311f6234ee9f59f.1643343397.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1643343397.git.duoming@zju.edu.cn>
References: <cover.1643343397.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1643343397.git.duoming@zju.edu.cn>
References: <cover.1643343397.git.duoming@zju.edu.cn>
X-CM-TRANSID: by_KCgBHTIRXdfNhomB5AQ--.44160S3
X-Coremail-Antispam: 1UD129KBjvJXoW7AF1kZr18CF4kCFyktFy8Grg_yoW5JryrpF
        WUGF4FgFZrGF4Y9rsxGa97XF10vF4UK398Gr15Zan3u3s8JF95XFyktrWjq34YyrZ5JF18
        ZasrK34fXw4jva7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUka1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y
        6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v
        1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr
        1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUp6wZUUUUU=
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous commit 1ade48d0c27d ("ax25: NPD bug when detaching
AX25 device") introduce lock_sock() into ax25_kill_by_device to
prevent NPD bug. But the concurrency NPD or UAF bug will occur,
when lock_sock() or release_sock() dereferences the ax25_cb->sock.

The NULL pointer dereference bug can be shown as below:

ax25_kill_by_device()        | ax25_release()
                             |   ax25_destroy_socket()
                             |     ax25_cb_del()
  ...                        |     ...
                             |     ax25->sk=NULL;
  lock_sock(s->sk); //(1)    |
  s->ax25_dev = NULL;        |     ...
  release_sock(s->sk); //(2) |
  ...                        |

The root cause is that the sock is set to null before dereference
site (1) or (2). Therefore, this patch extracts the ax25_cb->sock
in advance, and uses ax25_list_lock to protect it, which can synchronize
with ax25_cb_del() and ensure the value of sock is not null before
dereference sites.

The concurrency UAF bug can be shown as below:

ax25_kill_by_device()        | ax25_release()
                             |   ax25_destroy_socket()
  ...                        |   ...
                             |   sock_put(sk); //FREE
  lock_sock(s->sk); //(1)    |
  s->ax25_dev = NULL;        |   ...
  release_sock(s->sk); //(2) |
  ...                        |

The root cause is that the sock is released before dereference
site (1) or (2). Therefore, this patch uses sock_hold() to increase
the refcount of sock and uses ax25_list_lock to protect it, which
can synchronize with ax25_cb_del() in ax25_destroy_socket() and
ensure the sock wil not be released before dereference sites.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 net/ax25/af_ax25.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 02f43f3e2c5..44a8730c26a 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -77,6 +77,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 {
 	ax25_dev *ax25_dev;
 	ax25_cb *s;
+	struct sock *sk;
 
 	if ((ax25_dev = ax25_dev_ax25dev(dev)) == NULL)
 		return;
@@ -85,13 +86,15 @@ static void ax25_kill_by_device(struct net_device *dev)
 again:
 	ax25_for_each(s, &ax25_list) {
 		if (s->ax25_dev == ax25_dev) {
+			sk = s->sk;
+			sock_hold(sk);
 			spin_unlock_bh(&ax25_list_lock);
-			lock_sock(s->sk);
+			lock_sock(sk);
 			s->ax25_dev = NULL;
-			release_sock(s->sk);
+			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
 			spin_lock_bh(&ax25_list_lock);
-
+			sock_put(sk);
 			/* The entry could have been deleted from the
 			 * list meanwhile and thus the next pointer is
 			 * no longer valid.  Play it safe and restart
-- 
2.17.1

