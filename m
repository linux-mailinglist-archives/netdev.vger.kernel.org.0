Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5B9675520
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 14:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbjATNAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 08:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjATNAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 08:00:00 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83257BCE34
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:59:59 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4d5097a95f5so49251737b3.1
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t/l2rPveJESg8rrABbnGTyADUlPwKvyV1vHn7CoOTFc=;
        b=eQ6skuo2vK0havCN8UKiVYU7O148ksZGzZXXQh+5jar4TLssh7ue8ap+w6HQbdc6WP
         uanJ4Se36WY2WnxEAgixg3HYz2kZK63hJBxkC9G1u+k1/A1t+OYdSdO6l4RvYbv2RFUJ
         PAWy8M2LXhHf+R1atIs+TBkMrZ6TEUk9Ojr+p1PebsNv/kbRJU6ms12LMbV7civbGa0E
         T2I6JWo+vy4T8NK+IE0w0xecCUVRlvkzFJuGVBBA7X3uu02IyiRvIzQpS0oHbrLOdJDd
         WQscSlKP/V2Udub6FF2wuFW2YXupb6I9vvhJTZPXvNkESYT5CHTpJHrcHPKh3ihAaUNQ
         11+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t/l2rPveJESg8rrABbnGTyADUlPwKvyV1vHn7CoOTFc=;
        b=oolRyCeUSynD4dREFS2yzLBA2YsS4AGDKft9g2R+sHJcKtNayEd7fXczH3QnOjSsMI
         Lqh2j5RgpCHBvmyLjvWN0AlTA5lebjymJpopc/bE+vb7fEeEvB9jwfKojSB2I50CniDz
         EH5NQZnq5Pn6Ecq9XxZJBXRzriLIpWDG8yeJyqxN7JJf0UbeFwQ7TbiCyRCl0jQyS9FA
         jMBcGe77FFSDHKstAXUxpwcsDx7SuT68xguFnn/rHMc+UjSItWzHDK0rRZwSxhfFFWrb
         jq0xLJX0O91EdMZFtq1zfICzo8x0HL7DOaVsH8b12934PasB6eCVr5Yn0U/vq6tHE8FK
         DCLA==
X-Gm-Message-State: AFqh2kpM22zYTMs96g3rRRnOoxWR8gzFxWBO0GBIE0gTuaM4WPz3r4SO
        OB3NQl+Ed37EZdPlQn9m39oOri6dyepy7w==
X-Google-Smtp-Source: AMrXdXukJuZs8dO/rgJTtSnVTe/FaP1J5qKsfY47VQA2tPwaqYlWEQd4WLRUClELRPky8IlLLjsnzyzrmerr5g==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:bd6:0:b0:48d:1334:6e38 with SMTP id
 205-20020a810bd6000000b0048d13346e38mr1697578ywl.316.1674219598784; Fri, 20
 Jan 2023 04:59:58 -0800 (PST)
Date:   Fri, 20 Jan 2023 12:59:53 +0000
In-Reply-To: <20230120125955.3453768-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230120125955.3453768-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f-goog
Message-ID: <20230120125955.3453768-2-edumazet@google.com>
Subject: [PATCH net 1/3] netlink: annotate data races around nlk->portid
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
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

syzbot reminds us netlink_getname() runs locklessly [1]

This first patch annotates the race against nlk->portid.

Following patches take care of the remaining races.

[1]
BUG: KCSAN: data-race in netlink_getname / netlink_insert

write to 0xffff88814176d310 of 4 bytes by task 2315 on cpu 1:
netlink_insert+0xf1/0x9a0 net/netlink/af_netlink.c:583
netlink_autobind+0xae/0x180 net/netlink/af_netlink.c:856
netlink_sendmsg+0x444/0x760 net/netlink/af_netlink.c:1895
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg net/socket.c:734 [inline]
____sys_sendmsg+0x38f/0x500 net/socket.c:2476
___sys_sendmsg net/socket.c:2530 [inline]
__sys_sendmsg+0x19a/0x230 net/socket.c:2559
__do_sys_sendmsg net/socket.c:2568 [inline]
__se_sys_sendmsg net/socket.c:2566 [inline]
__x64_sys_sendmsg+0x42/0x50 net/socket.c:2566
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

read to 0xffff88814176d310 of 4 bytes by task 2316 on cpu 0:
netlink_getname+0xcd/0x1a0 net/netlink/af_netlink.c:1144
__sys_getsockname+0x11d/0x1b0 net/socket.c:2026
__do_sys_getsockname net/socket.c:2041 [inline]
__se_sys_getsockname net/socket.c:2038 [inline]
__x64_sys_getsockname+0x3e/0x50 net/socket.c:2038
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0x00000000 -> 0xc9a49780

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 2316 Comm: syz-executor.2 Not tainted 6.2.0-rc3-syzkaller-00030-ge8f60cd7db24-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/netlink/af_netlink.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index bca2a470ccad5fac1caa1eb810d16e95103c93dc..4aea89f7d700a587c4e9017cdff76cd3fe93ed7a 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -580,7 +580,9 @@ static int netlink_insert(struct sock *sk, u32 portid)
 	if (nlk_sk(sk)->bound)
 		goto err;
 
-	nlk_sk(sk)->portid = portid;
+	/* portid can be read locklessly from netlink_getname(). */
+	WRITE_ONCE(nlk_sk(sk)->portid, portid);
+
 	sock_hold(sk);
 
 	err = __netlink_insert(table, sk);
@@ -1141,7 +1143,8 @@ static int netlink_getname(struct socket *sock, struct sockaddr *addr,
 		nladdr->nl_pid = nlk->dst_portid;
 		nladdr->nl_groups = netlink_group_mask(nlk->dst_group);
 	} else {
-		nladdr->nl_pid = nlk->portid;
+		/* Paired with WRITE_ONCE() in netlink_insert() */
+		nladdr->nl_pid = READ_ONCE(nlk->portid);
 		netlink_lock_table();
 		nladdr->nl_groups = nlk->groups ? nlk->groups[0] : 0;
 		netlink_unlock_table();
-- 
2.39.1.405.gd4c25cc71f-goog

