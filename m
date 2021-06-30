Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C593B8735
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 18:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhF3QpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 12:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbhF3QpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 12:45:19 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC4AC061756
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 09:42:49 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id kt19so2147290pjb.2
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 09:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6FBbX7FP0BuAlqzaKp5FE1dUrHY8AHA8Ga7z6TXkOK0=;
        b=pCiCWjxlLlqzydNobxW2XRLNbBwjgwXxl44pgZ4FuUa4Q+4dOfTnKvIrZnaTWm8lN6
         +HJv71y/pXXIRfQ6jSZxQAHNgJF3woO2KTv9L4qJuPqVGF5/wpYy9F5ioztIKxOPpIsh
         k7A9VTxcbehux3tZ4O4xySIrKHZm0EWzbwfUfSbb71e/S4yXYbe1bggXsm3LnusKCt51
         dD0Wo0GRB4lmztBLLUrZ3x3JY2hpqmJuAtG3tuvAXKIAq0Bb0Pv7jOboMITUwDxpZWBl
         /sYD4YavllUZZZlW+lJqIZwXLKQTCOaGYkqAsEPQUfj5CicMd/h4sPz3N3Y5dcnRhqIu
         swkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6FBbX7FP0BuAlqzaKp5FE1dUrHY8AHA8Ga7z6TXkOK0=;
        b=jiPKqNwaz5F6bFW26m30rqsOOdIr1BnFMpYIxFNrHqjdMvOtPoJ+LV5vzLdXoD+XSd
         7IRH7GQ6spkKjGQyVpD3Lr98kfjNCKtTl+pr8kC2Bv0p3dhCH9JGgK/OHY0bg2y1erXz
         HElPheqa+Ozmkzfo3aNIyqp9jz3dQn3VSMV+fIMnnJmhKszrZ1k9KOof37O+c+s5J1e3
         IkW29DlYNRco7+Z0jRDSwRheMb4AhBM/2EnEc4hVuVGPF1/RBbU+8j81/GS5uRvLh8OO
         wrr1jZx6poRbyQNtfwOne+uqvaX5yR5VMbSUiSgI7QoMjkfCyh8AQJFUUxXv3AViXTX0
         LkRA==
X-Gm-Message-State: AOAM530wrQb3Mce0pN2Z2ckGv66AmXfoqhK5SrHjq/shrv9zVsMMyKKT
        7aFKl2WAqJvSOva+uRbCvcM=
X-Google-Smtp-Source: ABdhPJxVL4Nv4RiM2XSocUqBVj+v/mPGJwDjAIga69FEH+VktZG+NGZ2acNfnCoxSVS8vczt0Mv6bQ==
X-Received: by 2002:a17:902:9f8e:b029:128:b9c5:15c4 with SMTP id g14-20020a1709029f8eb0290128b9c515c4mr21526972plq.30.1625071369178;
        Wed, 30 Jun 2021 09:42:49 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6d3e:f416:dd73:592])
        by smtp.gmail.com with ESMTPSA id i27sm22596929pgl.78.2021.06.30.09.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 09:42:48 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] udp: annotate data races around unix_sk(sk)->gso_size
Date:   Wed, 30 Jun 2021 09:42:44 -0700
Message-Id: <20210630164244.2180977-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Accesses to unix_sk(sk)->gso_size are lockless.
Add READ_ONCE()/WRITE_ONCE() around them.

BUG: KCSAN: data-race in udp_lib_setsockopt / udpv6_sendmsg

write to 0xffff88812d78f47c of 2 bytes by task 10849 on cpu 1:
 udp_lib_setsockopt+0x3b3/0x710 net/ipv4/udp.c:2696
 udpv6_setsockopt+0x63/0x90 net/ipv6/udp.c:1630
 sock_common_setsockopt+0x5d/0x70 net/core/sock.c:3265
 __sys_setsockopt+0x18f/0x200 net/socket.c:2104
 __do_sys_setsockopt net/socket.c:2115 [inline]
 __se_sys_setsockopt net/socket.c:2112 [inline]
 __x64_sys_setsockopt+0x62/0x70 net/socket.c:2112
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff88812d78f47c of 2 bytes by task 10852 on cpu 0:
 udpv6_sendmsg+0x161/0x16b0 net/ipv6/udp.c:1299
 inet6_sendmsg+0x5f/0x80 net/ipv6/af_inet6.c:642
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2337
 ___sys_sendmsg net/socket.c:2391 [inline]
 __sys_sendmmsg+0x315/0x4b0 net/socket.c:2477
 __do_sys_sendmmsg net/socket.c:2506 [inline]
 __se_sys_sendmmsg net/socket.c:2503 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2503
 do_syscall_64+0x4a/0x90 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x0000 -> 0x0005

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 10852 Comm: syz-executor.0 Not tainted 5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/udp.c | 6 +++---
 net/ipv6/udp.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 62682807b4b2b8bdc2baf2205395ff78f253acf9..62cd4cd52e8481599f5e98c6022c96067e800f2d 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1102,7 +1102,7 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	}
 
 	ipcm_init_sk(&ipc, inet);
-	ipc.gso_size = up->gso_size;
+	ipc.gso_size = READ_ONCE(up->gso_size);
 
 	if (msg->msg_controllen) {
 		err = udp_cmsg_send(sk, msg, &ipc.gso_size);
@@ -2695,7 +2695,7 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 	case UDP_SEGMENT:
 		if (val < 0 || val > USHRT_MAX)
 			return -EINVAL;
-		up->gso_size = val;
+		WRITE_ONCE(up->gso_size, val);
 		break;
 
 	case UDP_GRO:
@@ -2790,7 +2790,7 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case UDP_SEGMENT:
-		val = up->gso_size;
+		val = READ_ONCE(up->gso_size);
 		break;
 
 	case UDP_GRO:
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 368972dbd91961e9915d4f6b1fd9542a8d8ed139..0cc7ba531b34157feca74b876b3aa5a4013fec04 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1296,7 +1296,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
 
 	ipcm6_init(&ipc6);
-	ipc6.gso_size = up->gso_size;
+	ipc6.gso_size = READ_ONCE(up->gso_size);
 	ipc6.sockc.tsflags = sk->sk_tsflags;
 	ipc6.sockc.mark = sk->sk_mark;
 
-- 
2.32.0.93.g670b81a890-goog

