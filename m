Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41C00107CAC
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 04:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfKWD47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 22:56:59 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34163 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfKWD47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 22:56:59 -0500
Received: by mail-pl1-f194.google.com with SMTP id h13so4020502plr.1;
        Fri, 22 Nov 2019 19:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1dwZ+VOIOZ7HXQBGs9G4fycdYKwB3iXdgfcYFpT4HxQ=;
        b=nsSxhehuVonkCTCoq+sQYykjoFwja1lc5aIOOoGdnj7robf8+JvMqkHo6JAKDr3oVq
         zhA3ig1spGPI5vkLsLN7ntwdQE7s2Eq6e9kWPCNDxYkwsyBAD31HIZqjsxwO+FhFduFZ
         /Dqq44qKuBacUnpQsTosbBgNewsn/6dM1jjaTr5d024Oli5SvV/SXBAsZ/h6W3RJk9oz
         GN46WZxXsCL9j9FLc/KhQY/2Oj+n9NE48aL5SSLcDSx9rEErgV6Hq0wFOPuYiWzaWgq3
         FGib6Xgw+tlsFj9p7mpYyMFUK/IuXpiISuUZgQXCLROWp4iayKULs77bow9YpJFgzTq0
         uKhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1dwZ+VOIOZ7HXQBGs9G4fycdYKwB3iXdgfcYFpT4HxQ=;
        b=BF2to8VIJL9h8bu5mOtdSIyo4ARtgHRUrbzzfLvzVbZP8r6vMfGvixBvEpZVlIPtHa
         DQwQCOkobs5Tp77DC15xhug6h949CyN4QkRJkdQ3T/jEytdyG51A0Ek3wSt+guBwOA88
         DbQjW4oqCxckSf2kCp9EZf1CjuOG6P5k8IhuKvYv/08UPYZGkt5FueLf6hsd8xUkZeza
         xvJ+1EixaRg4BteiM6KFm9vMu1igiTHWqoQFBIdc17nHpb7/xgUPds6dpRBFBcyK6kqr
         XaN/X+h/vlGK85K9LPjy3S+JTwUXUeklEc5s9T34NF9HFn2smMsg+/Tom6dO9UW+yZwd
         jLBQ==
X-Gm-Message-State: APjAAAWEvMhx2ViPkKSQx2Zyw1VMY1cr3jNWhd39P9GXbX0Lx6LSW1UP
        Z4UVatb6mDUUsI0qRHJaI7dIfLQC
X-Google-Smtp-Source: APXvYqy3nTd+GSQzs1yg3RK3CGo7Y4e9VVvhI6cyagbqKVemcy3zSHFM/fSvwlhfjWl8V+2ZC2iNTQ==
X-Received: by 2002:a17:902:8bc9:: with SMTP id r9mr16575991plo.319.1574481418055;
        Fri, 22 Nov 2019 19:56:58 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i123sm9092161pfe.145.2019.11.22.19.56.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Nov 2019 19:56:57 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net] sctp: cache netns in sctp_ep_common
Date:   Sat, 23 Nov 2019 11:56:49 +0800
Message-Id: <f7ecea746b9238b1c996b51c41b5306e00a3d403.1574481409.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to fix a data-race reported by syzbot:

  BUG: KCSAN: data-race in sctp_assoc_migrate / sctp_hash_obj

  write to 0xffff8880b67c0020 of 8 bytes by task 18908 on cpu 1:
    sctp_assoc_migrate+0x1a6/0x290 net/sctp/associola.c:1091
    sctp_sock_migrate+0x8aa/0x9b0 net/sctp/socket.c:9465
    sctp_accept+0x3c8/0x470 net/sctp/socket.c:4916
    inet_accept+0x7f/0x360 net/ipv4/af_inet.c:734
    __sys_accept4+0x224/0x430 net/socket.c:1754
    __do_sys_accept net/socket.c:1795 [inline]
    __se_sys_accept net/socket.c:1792 [inline]
    __x64_sys_accept+0x4e/0x60 net/socket.c:1792
    do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

  read to 0xffff8880b67c0020 of 8 bytes by task 12003 on cpu 0:
    sctp_hash_obj+0x4f/0x2d0 net/sctp/input.c:894
    rht_key_get_hash include/linux/rhashtable.h:133 [inline]
    rht_key_hashfn include/linux/rhashtable.h:159 [inline]
    rht_head_hashfn include/linux/rhashtable.h:174 [inline]
    head_hashfn lib/rhashtable.c:41 [inline]
    rhashtable_rehash_one lib/rhashtable.c:245 [inline]
    rhashtable_rehash_chain lib/rhashtable.c:276 [inline]
    rhashtable_rehash_table lib/rhashtable.c:316 [inline]
    rht_deferred_worker+0x468/0xab0 lib/rhashtable.c:420
    process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
    worker_thread+0xa0/0x800 kernel/workqueue.c:2415
    kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

It was caused by rhashtable access asoc->base.sk when sctp_assoc_migrate
is changing its value. However, what rhashtable wants is netns from asoc
base.sk, and for an asoc, its netns won't change once set. So we can
simply fix it by caching netns since created.

Fixes: d6c0256a60e6 ("sctp: add the rhashtable apis for sctp global transport hashtable")
Reported-by: syzbot+e3b35fe7918ff0ee474e@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 3 +++
 net/sctp/associola.c       | 1 +
 net/sctp/endpointola.c     | 1 +
 net/sctp/input.c           | 4 ++--
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 503fbc3..2b6f3f1 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1239,6 +1239,9 @@ struct sctp_ep_common {
 	/* What socket does this endpoint belong to?  */
 	struct sock *sk;
 
+	/* Cache netns and it won't change once set */
+	struct net *net;
+
 	/* This is where we receive inbound chunks.  */
 	struct sctp_inq	  inqueue;
 
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index d2ffc9a..41839b8 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -64,6 +64,7 @@ static struct sctp_association *sctp_association_init(
 	/* Discarding const is appropriate here.  */
 	asoc->ep = (struct sctp_endpoint *)ep;
 	asoc->base.sk = (struct sock *)sk;
+	asoc->base.net = sock_net(sk);
 
 	sctp_endpoint_hold(asoc->ep);
 	sock_hold(asoc->base.sk);
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index ea53049..3067deb 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -110,6 +110,7 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 
 	/* Remember who we are attached to.  */
 	ep->base.sk = sk;
+	ep->base.net = sock_net(sk);
 	sock_hold(ep->base.sk);
 
 	return ep;
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 2277981..4d2bcfc 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -882,7 +882,7 @@ static inline int sctp_hash_cmp(struct rhashtable_compare_arg *arg,
 	if (!sctp_transport_hold(t))
 		return err;
 
-	if (!net_eq(sock_net(t->asoc->base.sk), x->net))
+	if (!net_eq(t->asoc->base.net, x->net))
 		goto out;
 	if (x->lport != htons(t->asoc->base.bind_addr.port))
 		goto out;
@@ -897,7 +897,7 @@ static inline __u32 sctp_hash_obj(const void *data, u32 len, u32 seed)
 {
 	const struct sctp_transport *t = data;
 
-	return sctp_hashfn(sock_net(t->asoc->base.sk),
+	return sctp_hashfn(t->asoc->base.net,
 			   htons(t->asoc->base.bind_addr.port),
 			   &t->ipaddr, seed);
 }
-- 
2.1.0

