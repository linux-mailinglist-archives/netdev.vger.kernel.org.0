Return-Path: <netdev+bounces-5187-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD4A17101B1
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 01:30:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F8A11C20D15
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 23:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A1138836;
	Wed, 24 May 2023 23:30:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A92848D
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 23:30:10 +0000 (UTC)
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A6999
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 16:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1684971009; x=1716507009;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vyqvBazfHKigXd0x4CIk+joJzzBeEa2c995yNaXn2MQ=;
  b=pdfJwCKn9tt7JkXMUPVx4LQQHoYWQ9S8a0ht8rbh5699ecs/nc2QyM6o
   TVFwVHzlw1sTrtMsr6HKHyFWlCJKQQE1IQUHF9f3EEq1Lf8orZwJtHumM
   Zh67Knd8VLA/+2ruFowR6RNHZgTj194VlRfAxo1icsaoj/QbGu2QE/JB0
   I=;
X-IronPort-AV: E=Sophos;i="6.00,190,1681171200"; 
   d="scan'208";a="135235484"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 23:30:07 +0000
Received: from EX19MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com (Postfix) with ESMTPS id 25BDBA118C;
	Wed, 24 May 2023 23:30:04 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 24 May 2023 23:29:48 +0000
Received: from 88665a182662.ant.amazon.com (10.142.186.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 24 May 2023 23:29:45 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC: Pavel Emelyanov <xemul@parallels.com>, Kuniyuki Iwashima
	<kuniyu@amazon.com>, Kuniyuki Iwashima <kuni1840@gmail.com>,
	<netdev@vger.kernel.org>, syzkaller <syzkaller@googlegroups.com>
Subject: [PATCH v1 net] af_packet: Fix data-races of pkt_sk(sk)->num.
Date: Wed, 24 May 2023 16:29:34 -0700
Message-ID: <20230524232934.50950-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.142.186.55]
X-ClientProxiedBy: EX19D040UWA003.ant.amazon.com (10.13.139.6) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

syzkaller found a data race of pkt_sk(sk)->num.

The value is changed under lock_sock() and po->bind_lock, so we
need READ_ONCE() to access pkt_sk(sk)->num without these locks in
packet_bind_spkt(), packet_bind(), and sk_diag_fill().

Note that WRITE_ONCE() is already added by commit c7d2ef5dd4b0
("net/packet: annotate accesses to po->bind").

BUG: KCSAN: data-race in packet_bind / packet_do_bind

write (marked) to 0xffff88802ffd1cee of 2 bytes by task 7322 on cpu 0:
 packet_do_bind+0x446/0x640 net/packet/af_packet.c:3236
 packet_bind+0x99/0xe0 net/packet/af_packet.c:3321
 __sys_bind+0x19b/0x1e0 net/socket.c:1803
 __do_sys_bind net/socket.c:1814 [inline]
 __se_sys_bind net/socket.c:1812 [inline]
 __x64_sys_bind+0x40/0x50 net/socket.c:1812
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

read to 0xffff88802ffd1cee of 2 bytes by task 7318 on cpu 1:
 packet_bind+0xbf/0xe0 net/packet/af_packet.c:3322
 __sys_bind+0x19b/0x1e0 net/socket.c:1803
 __do_sys_bind net/socket.c:1814 [inline]
 __se_sys_bind net/socket.c:1812 [inline]
 __x64_sys_bind+0x40/0x50 net/socket.c:1812
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

value changed: 0x0300 -> 0x0000

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 7318 Comm: syz-executor.4 Not tainted 6.3.0-13380-g7fddb5b5300c #4
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014

Fixes: 96ec6327144e ("packet: Diag core and basic socket info dumping")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/packet/af_packet.c | 4 ++--
 net/packet/diag.c      | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 94c6a1ffa459..a1f9a0e9f3c8 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3299,7 +3299,7 @@ static int packet_bind_spkt(struct socket *sock, struct sockaddr *uaddr,
 	memcpy(name, uaddr->sa_data, sizeof(uaddr->sa_data_min));
 	name[sizeof(uaddr->sa_data_min)] = 0;
 
-	return packet_do_bind(sk, name, 0, pkt_sk(sk)->num);
+	return packet_do_bind(sk, name, 0, READ_ONCE(pkt_sk(sk)->num));
 }
 
 static int packet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
@@ -3317,7 +3317,7 @@ static int packet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len
 		return -EINVAL;
 
 	return packet_do_bind(sk, NULL, sll->sll_ifindex,
-			      sll->sll_protocol ? : pkt_sk(sk)->num);
+			      sll->sll_protocol ? : READ_ONCE(pkt_sk(sk)->num));
 }
 
 static struct proto packet_proto = {
diff --git a/net/packet/diag.c b/net/packet/diag.c
index d0c4eda4cdc6..f6b200cb3c06 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -143,7 +143,7 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb,
 	rp = nlmsg_data(nlh);
 	rp->pdiag_family = AF_PACKET;
 	rp->pdiag_type = sk->sk_type;
-	rp->pdiag_num = ntohs(po->num);
+	rp->pdiag_num = ntohs(READ_ONCE(po->num));
 	rp->pdiag_ino = sk_ino;
 	sock_diag_save_cookie(sk, rp->pdiag_cookie);
 
-- 
2.30.2


