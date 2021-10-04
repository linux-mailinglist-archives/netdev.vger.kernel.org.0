Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC6F421934
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 23:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235443AbhJDV0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 17:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbhJDV0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 17:26:09 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C24EC061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 14:24:20 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id rj12-20020a17090b3e8c00b0019f88e44d85so391084pjb.4
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 14:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fhvim1QbCn5dymRbgxoc4I/ulqG37A6e9/Xnoy6qodQ=;
        b=CVieOIdQ22Nd+S1+4GVLLyn/1w+u+XX4Ql5umQfl/kXssy/mLm6u6K5q0xzizwA/p3
         xRr171TEmMI4wPQHjntFtZ4GQLR9bg1+hveQvawvTDbeHWL9JB3J44ox363EotC7SH2Y
         WTvjRD0WjOB2o350lVRZpqTRg3IC4oKcclCVjfJ8XufC6EEiTABi6ajwNZZaPkE6IRNR
         DsBFMqWBRBq0rYyqoxQVmkqDUeVgHvsib9UiyGzWDWaVWyNebaNOZCWf3ZDTNInG6YCL
         hno5IrBNgCwhWuK8iy2ozEbA48Kqqmm/jKn0B2e1EaG7L+8vR6mZ4Wgercp/hyY7zVuN
         BUXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fhvim1QbCn5dymRbgxoc4I/ulqG37A6e9/Xnoy6qodQ=;
        b=nRugFyO29gFe81Pgv3NiwtenTa6ZeCqlnM/rzaE/y5U5x+NmBWqsN7ODiMrqtiG0gq
         p67xDneWBERb7TIx6Oc6Y+sn4jD3SMOfPAj6KSR4TSusndYJdZC95zqhLNkzMF1PQhRG
         z229JsbHyDhDICtXopSPSEiIBpLv2X48CLbOO+3EetaE/RzDWe5hQIoNxCj4kLN34d2g
         oyVabnCxcI9iwBncvqV505jbxzrN5Yf0OiroPk8Dfol+D2/V21Zm+C/u0TMS8AxuZLkS
         PC0LbVHOd7eBZX/UZAouUtOOeH6xbFA7ZGMyLZw5f7UGuMRuOwIW+1muGZvFDg8gBYr7
         BT7Q==
X-Gm-Message-State: AOAM532GBHUHxv19tr3OX2NyBjg6cVJ+r9AgchzSkjqgDFu5O7Zsc4mj
        a0pcDo5pldE+FBPft1yHjQE=
X-Google-Smtp-Source: ABdhPJy15ajFpA5VyYqAYI4Ro0GZef9V9zrhmtpeq/lOd3PsAR9TOxHKx6tMP7D+0A31PkZbNUaYXA==
X-Received: by 2002:a17:902:e807:b0:13d:bdc9:b955 with SMTP id u7-20020a170902e80700b0013dbdc9b955mr1718103plg.88.1633382659732;
        Mon, 04 Oct 2021 14:24:19 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7236:cc97:8564:4e2a])
        by smtp.gmail.com with ESMTPSA id r7sm15133251pff.112.2021.10.04.14.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 14:24:19 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] netlink: annotate data races around nlk->bound
Date:   Mon,  4 Oct 2021 14:24:15 -0700
Message-Id: <20211004212415.2080576-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

While existing code is correct, KCSAN is reporting
a data-race in netlink_insert / netlink_sendmsg [1]

It is correct to read nlk->bound without a lock, as netlink_autobind()
will acquire all needed locks.

[1]
BUG: KCSAN: data-race in netlink_insert / netlink_sendmsg

write to 0xffff8881031c8b30 of 1 bytes by task 18752 on cpu 0:
 netlink_insert+0x5cc/0x7f0 net/netlink/af_netlink.c:597
 netlink_autobind+0xa9/0x150 net/netlink/af_netlink.c:842
 netlink_sendmsg+0x479/0x7c0 net/netlink/af_netlink.c:1892
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg net/socket.c:723 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2392
 ___sys_sendmsg net/socket.c:2446 [inline]
 __sys_sendmsg+0x1ed/0x270 net/socket.c:2475
 __do_sys_sendmsg net/socket.c:2484 [inline]
 __se_sys_sendmsg net/socket.c:2482 [inline]
 __x64_sys_sendmsg+0x42/0x50 net/socket.c:2482
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff8881031c8b30 of 1 bytes by task 18751 on cpu 1:
 netlink_sendmsg+0x270/0x7c0 net/netlink/af_netlink.c:1891
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg net/socket.c:723 [inline]
 __sys_sendto+0x2a8/0x370 net/socket.c:2019
 __do_sys_sendto net/socket.c:2031 [inline]
 __se_sys_sendto net/socket.c:2027 [inline]
 __x64_sys_sendto+0x74/0x90 net/socket.c:2027
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00 -> 0x01

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 18751 Comm: syz-executor.0 Not tainted 5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: da314c9923fe ("netlink: Replace rhash_portid with bound")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/netlink/af_netlink.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 24b7cf447bc55b21e74cd82ba19528a575956981..ada47e59647a03e69f64a2ea935b5e8ec9785fe5 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -594,7 +594,10 @@ static int netlink_insert(struct sock *sk, u32 portid)
 
 	/* We need to ensure that the socket is hashed and visible. */
 	smp_wmb();
-	nlk_sk(sk)->bound = portid;
+	/* Paired with lockless reads from netlink_bind(),
+	 * netlink_connect() and netlink_sendmsg().
+	 */
+	WRITE_ONCE(nlk_sk(sk)->bound, portid);
 
 err:
 	release_sock(sk);
@@ -1012,7 +1015,8 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
 	if (nlk->ngroups < BITS_PER_LONG)
 		groups &= (1UL << nlk->ngroups) - 1;
 
-	bound = nlk->bound;
+	/* Paired with WRITE_ONCE() in netlink_insert() */
+	bound = READ_ONCE(nlk->bound);
 	if (bound) {
 		/* Ensure nlk->portid is up-to-date. */
 		smp_rmb();
@@ -1098,8 +1102,9 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
 
 	/* No need for barriers here as we return to user-space without
 	 * using any of the bound attributes.
+	 * Paired with WRITE_ONCE() in netlink_insert().
 	 */
-	if (!nlk->bound)
+	if (!READ_ONCE(nlk->bound))
 		err = netlink_autobind(sock);
 
 	if (err == 0) {
@@ -1888,7 +1893,8 @@ static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		dst_group = nlk->dst_group;
 	}
 
-	if (!nlk->bound) {
+	/* Paired with WRITE_ONCE() in netlink_insert() */
+	if (!READ_ONCE(nlk->bound)) {
 		err = netlink_autobind(sock);
 		if (err)
 			goto out;
-- 
2.33.0.800.g4c38ced690-goog

