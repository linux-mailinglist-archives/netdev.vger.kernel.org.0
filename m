Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3D743B846
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbhJZRkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234976AbhJZRk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 13:40:29 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28497C061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 10:38:05 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so2929792pjl.2
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 10:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dlH8nQ3KbsAPc+G/Bcd7SPXFylLA7rrXO7TFAS12m28=;
        b=U9gk2GPWCOc22X8ZltumWRcdG7ebaQvxNDYQSteKfow+Z0iuxMHwjViqFfG/uf+fJf
         Sjmx7ZiBY46zoMrKzrJA0oSPdCtHt25MTsY3UWiBREoNOncWONumqWzDx+IB+QUOf30B
         O7Dq2oHHe6Q6HN3mcUQvXud+zlT9NfLnhc18vmTY8Ko+lZuF/iEGOeP/Na6lx/vwvihK
         EZ9WL+9oFaZSk7bF/s5QAKuS7dajiILarvZRkvtXe/lqBLig3JN/DjnYNPBhVvnZ4O5R
         dIuGq1Qwk2N3rF0zDPZmhJHx+apGwfhAjqrvo7ljYXqJK4hBW/5JQWWIkTsOnYVXlNx/
         Cx6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dlH8nQ3KbsAPc+G/Bcd7SPXFylLA7rrXO7TFAS12m28=;
        b=Y/ZvrT52ttKbFtNY0lcn5kIhc4cmMoZhhUyJJaJpaJfzcAPoSnIvdZCyG//6jJ3WgG
         3l1vdnhyebIO5DiKap2YnX02dN3lodNwBYXZ5NHWm1kuQLj28Eg5Wt8TFjBLhGdO6dTT
         E2OIEyYurKuDDtPBsoPDRXChDIUTTTt2WTBEj+7P9P7zw5ZddAzGk/1zfWPUIJSayljG
         DydtZJKaJ7HpPTGWEEYkl/lqwcRCqumppev9rD93qmyULxh3qkh0zc2XKRdNxhYuSG1f
         9yW04BgyNKq/6b/ANIlAw6YqvmMVcO1zdA7kDQthzlPo6Y/qiP/Zd9v5icwYLf2MHUbW
         HgCw==
X-Gm-Message-State: AOAM533RCU81wfySDaqVUawmT+c24/mm0hMDFPB7KWbkZdXtZ+1jfwFB
        stFUqPT5FvN71P9jw2eYiTydjfEwuBU=
X-Google-Smtp-Source: ABdhPJx07x6hr2aX2Q92DeZMrWgouL006Df6DI+zqFMbTUmA/mOQdQqE4zZ2enPORPqK44aLMtPslA==
X-Received: by 2002:a17:902:d50c:b0:140:5f35:40f with SMTP id b12-20020a170902d50c00b001405f35040fmr10599033plg.39.1635269884717;
        Tue, 26 Oct 2021 10:38:04 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:207c:7102:7bd7:80eb])
        by smtp.gmail.com with ESMTPSA id j12sm16913358pfu.33.2021.10.26.10.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 10:38:03 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next] inet: remove races in inet{6}_getname()
Date:   Tue, 26 Oct 2021 10:38:00 -0700
Message-Id: <20211026173800.2232409-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot reported data-races in inet_getname() multiple times,
it is time we fix this instead of pretending applications
should not trigger them.

getsockname() and getpeername() are not really considered fast path.

syzbot typical report:
BUG: KCSAN: data-race in __inet_hash_connect / inet_getname

write to 0xffff888136d66cf8 of 2 bytes by task 14374 on cpu 1:
 __inet_hash_connect+0x7ec/0x950 net/ipv4/inet_hashtables.c:831
 inet_hash_connect+0x85/0x90 net/ipv4/inet_hashtables.c:853
 tcp_v4_connect+0x782/0xbb0 net/ipv4/tcp_ipv4.c:275
 __inet_stream_connect+0x156/0x6e0 net/ipv4/af_inet.c:664
 inet_stream_connect+0x44/0x70 net/ipv4/af_inet.c:728
 __sys_connect_file net/socket.c:1896 [inline]
 __sys_connect+0x254/0x290 net/socket.c:1913
 __do_sys_connect net/socket.c:1923 [inline]
 __se_sys_connect net/socket.c:1920 [inline]
 __x64_sys_connect+0x3d/0x50 net/socket.c:1920
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xa0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff888136d66cf8 of 2 bytes by task 14408 on cpu 0:
 inet_getname+0x11f/0x170 net/ipv4/af_inet.c:790
 __sys_getsockname+0x11d/0x1b0 net/socket.c:1946
 __do_sys_getsockname net/socket.c:1961 [inline]
 __se_sys_getsockname net/socket.c:1958 [inline]
 __x64_sys_getsockname+0x3e/0x50 net/socket.c:1958
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xa0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x0000 -> 0xdee0

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 14408 Comm: syz-executor.3 Not tainted 5.15.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/af_inet.c  | 16 +++++++++-------
 net/ipv6/af_inet6.c | 21 +++++++++++----------
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 8eb428387bac25ee8fc638702d993640601e09d6..31d5cefa99799ca25969894c4bcdfc578f3b4cec 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -769,26 +769,28 @@ int inet_getname(struct socket *sock, struct sockaddr *uaddr,
 	DECLARE_SOCKADDR(struct sockaddr_in *, sin, uaddr);
 
 	sin->sin_family = AF_INET;
+	lock_sock(sk);
 	if (peer) {
 		if (!inet->inet_dport ||
 		    (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_SYN_SENT)) &&
-		     peer == 1))
+		     peer == 1)) {
+			release_sock(sk);
 			return -ENOTCONN;
+		}
 		sin->sin_port = inet->inet_dport;
 		sin->sin_addr.s_addr = inet->inet_daddr;
-		BPF_CGROUP_RUN_SA_PROG_LOCK(sk, (struct sockaddr *)sin,
-					    CGROUP_INET4_GETPEERNAME,
-					    NULL);
+		BPF_CGROUP_RUN_SA_PROG(sk, (struct sockaddr *)sin,
+				       CGROUP_INET4_GETPEERNAME);
 	} else {
 		__be32 addr = inet->inet_rcv_saddr;
 		if (!addr)
 			addr = inet->inet_saddr;
 		sin->sin_port = inet->inet_sport;
 		sin->sin_addr.s_addr = addr;
-		BPF_CGROUP_RUN_SA_PROG_LOCK(sk, (struct sockaddr *)sin,
-					    CGROUP_INET4_GETSOCKNAME,
-					    NULL);
+		BPF_CGROUP_RUN_SA_PROG(sk, (struct sockaddr *)sin,
+				       CGROUP_INET4_GETSOCKNAME);
 	}
+	release_sock(sk);
 	memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
 	return sizeof(*sin);
 }
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index b5878bb8e419d6087dcff1836479f6a808ad24d9..0c4da163535ad956be0a194478ca3ab988df872a 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -521,31 +521,32 @@ int inet6_getname(struct socket *sock, struct sockaddr *uaddr,
 	sin->sin6_family = AF_INET6;
 	sin->sin6_flowinfo = 0;
 	sin->sin6_scope_id = 0;
+	lock_sock(sk);
 	if (peer) {
-		if (!inet->inet_dport)
-			return -ENOTCONN;
-		if (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_SYN_SENT)) &&
-		    peer == 1)
+		if (!inet->inet_dport ||
+		    (((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_SYN_SENT)) &&
+		    peer == 1)) {
+			release_sock(sk);
 			return -ENOTCONN;
+		}
 		sin->sin6_port = inet->inet_dport;
 		sin->sin6_addr = sk->sk_v6_daddr;
 		if (np->sndflow)
 			sin->sin6_flowinfo = np->flow_label;
-		BPF_CGROUP_RUN_SA_PROG_LOCK(sk, (struct sockaddr *)sin,
-					    CGROUP_INET6_GETPEERNAME,
-					    NULL);
+		BPF_CGROUP_RUN_SA_PROG(sk, (struct sockaddr *)sin,
+				       CGROUP_INET6_GETPEERNAME);
 	} else {
 		if (ipv6_addr_any(&sk->sk_v6_rcv_saddr))
 			sin->sin6_addr = np->saddr;
 		else
 			sin->sin6_addr = sk->sk_v6_rcv_saddr;
 		sin->sin6_port = inet->inet_sport;
-		BPF_CGROUP_RUN_SA_PROG_LOCK(sk, (struct sockaddr *)sin,
-					    CGROUP_INET6_GETSOCKNAME,
-					    NULL);
+		BPF_CGROUP_RUN_SA_PROG(sk, (struct sockaddr *)sin,
+				       CGROUP_INET6_GETSOCKNAME);
 	}
 	sin->sin6_scope_id = ipv6_iface_scope_id(&sin->sin6_addr,
 						 sk->sk_bound_dev_if);
+	release_sock(sk);
 	return sizeof(*sin);
 }
 EXPORT_SYMBOL(inet6_getname);
-- 
2.33.0.1079.g6e70778dc9-goog

