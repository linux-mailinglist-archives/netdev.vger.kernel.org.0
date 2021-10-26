Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79AC643BC6A
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 23:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbhJZVcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 17:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235155AbhJZVcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 17:32:43 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EE0C061570
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 14:30:18 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id n11-20020a17090a2bcb00b001a1e7a0a6a6so3437574pje.0
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 14:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=etcHEv285Jy30oYGI4S0NKlT+5PTLrVR3zyXC8lIUDM=;
        b=MpO/Rj0YiebJ7VuvGyqbA/mESKMwp+m0iRND3FoqpThJRi/pzCxkC2qjwieaB/mOJa
         9cOZ3EiYZcd8dv/n0aAWfpPMWooaMojZqDuGGNYO6LhbeoxXcbCj7RQ6WembztADaFhl
         AMwiCQxI2frYpdY8/CM2kmPFdU3m8BtrJrmEhzNwlwO3AaAV6ggRToPtdrjM6myGZq9O
         H+o3QbMlL/aDzUImsKPzAfG2AQMkrZOMHL7EEasy3wbJFqMkIAtQQrHFJzMdlcOjd+/T
         QTAegAfTS7ka6WXUmQF4JU33iVua/WdRptlKNJMmpUrukhJc+7lbOKcUo9tINuPtR4OU
         a84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=etcHEv285Jy30oYGI4S0NKlT+5PTLrVR3zyXC8lIUDM=;
        b=xWwloGNHAU+UoFSHk8XE7q28C6FsyiY2f15/SXa8xyarCx2op8tM1UACj2rPalMPbx
         xMLJPoRIwk5Ji2XwmBLJEvk9BezpHnbNmrRYN8ooZAswcYUon+W8HjbTkh+2NC2R9gYr
         UYS7Srpn6PIQ+Yy55AD+tONPgsBIvkqIjsgkVM4pNQIdaAjhdmYhd9hXSkceOA32J7x+
         RoiZQGv/AQjZdbdoE9AL4CiL3K2A00cBFWWdtMVxFqxbtH+EVeMj6iAOQAVJVbrrLitP
         ymRHQ3VP9bS2U/mgmlLT/GP9OrDZGJ14Yvxe1lvqjE4tSG67Jk44UZ9YibH6xurDIu8H
         2DVw==
X-Gm-Message-State: AOAM532SBUH18yw1gVC7/FlleFV1Ucm09ysicu4/Jsd0tu+2PCrwb+BB
        RL2r/B7ibwquOvpOiRJ/Mn4=
X-Google-Smtp-Source: ABdhPJynfjxTLviPzFiqCDMb3N4yf24lLTwO85qVYx/BENq0LmFuH0dIPrg0l//uc+THYEZYK5h/gw==
X-Received: by 2002:a17:902:c40f:b0:140:6774:9365 with SMTP id k15-20020a170902c40f00b0014067749365mr9742902plk.67.1635283818367;
        Tue, 26 Oct 2021 14:30:18 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:207c:7102:7bd7:80eb])
        by smtp.gmail.com with ESMTPSA id b10sm24814929pfl.200.2021.10.26.14.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 14:30:17 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH V2 net-next] inet: remove races in inet{6}_getname()
Date:   Tue, 26 Oct 2021 14:30:14 -0700
Message-Id: <20211026213014.3026708-1-eric.dumazet@gmail.com>
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

v2: added the missing BPF_CGROUP_RUN_SA_PROG() declaration
    needed when CONFIG_CGROUP_BPF=n, as reported by
    kernel test robot <lkp@intel.com>

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
 include/linux/bpf-cgroup.h |  1 +
 net/ipv4/af_inet.c         | 16 +++++++++-------
 net/ipv6/af_inet6.c        | 21 +++++++++++----------
 3 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 2746fd8042162c68d869bcbe210cee13bf89cf34..3536ab432b30cbeac6273d0ad8affaf9f23e3789 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -517,6 +517,7 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 
 #define cgroup_bpf_enabled(atype) (0)
 #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, atype, t_ctx) ({ 0; })
+#define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, atype) ({ 0; })
 #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (0)
 #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk,skb) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET_EGRESS(sk,skb) ({ 0; })
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

