Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E349328B4E
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 19:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239983AbhCAScu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 13:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239826AbhCASaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 13:30:07 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237F2C061788
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 10:29:23 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id e9so125675pjj.0
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 10:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LAvQgxDafwb7Ugh60Y/bOqRllkB+AWtaculCCpPGN78=;
        b=iC7pPSiSkWiy6Jv5wqth7KUuJ0WOBVFS5mNlAS0GQxJNTJSyA/gntjbhRsOzE4sox+
         Jcz+Nf+Hsfk5ot0duB2abJlFksHI0H5NE4VzJzxhtw76FYe53mfXtCz337nUli04a9PC
         Vb+llGH5mkbxmNxqzz12uu5HR//h1uYMgGuAa1gsSQ32w2JKlSo7WOnrswSUeA+dZzb/
         3H9GVoPk/86/wDPUqmPQor2GURxI93cJWZ52c+EjxHAvXBEN5VOS1ZZBYZkqJJ/y0G0I
         E2LQ3jrkFvG9K2jSUYN8/ArzL9ALFxGmDRpKOTP1QOVvj6cALd9q2nTHo3l+ClRxZGI+
         8sQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LAvQgxDafwb7Ugh60Y/bOqRllkB+AWtaculCCpPGN78=;
        b=chMUnSTA1yaX2yjmGC32VShQsKo+XDgHF54l5H30dZgJE0KPzmjnjR0+TNxcDRaF93
         aHPwt1RR/5e0hPrDJG6i3DoXVTyp7P1ajbGZeSXBDrU7AqlLhUqKuQfSKBV2WiorkeW8
         PnM9H87Nts5x0pNXm1wR+Dv7KN+uSWRO/u1zHvbmgaIMCdbQRL0fA+jKUOMZmIDsQeWu
         dlIiaSc1hI+t++lD/2SMdAYlRs36sA6zzyI2VQEB29ETHG1YOM6hKvDTzooq6nP85LpL
         PRVIeKFvgdfhPf4tgjn0Iid622dntzBJ5TlddDlGoIG6ZKemrZHxEBH/rnqZRxQZsyks
         JUXg==
X-Gm-Message-State: AOAM533PUN6C4SRj3yOYHFKla5ylzbu1vrlv2cjIHIdzPOp55MUdHkyZ
        GZsc5pS0RjFZm7MQ2Z2MRnM=
X-Google-Smtp-Source: ABdhPJwjjnW/C7e274Jjr7+0kI+HJisPH5Ajr973+MS3XypPbTygU74jVM0dzYgY7eYnjcNrfL6UyQ==
X-Received: by 2002:a17:90a:bf0e:: with SMTP id c14mr252412pjs.38.1614623362737;
        Mon, 01 Mar 2021 10:29:22 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:45b6:ff74:c40e:478a])
        by smtp.gmail.com with ESMTPSA id g8sm19513662pfu.13.2021.03.01.10.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 10:29:22 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Qingyu Li <ieatmuttonchuan@gmail.com>
Subject: [PATCH net] tcp: add sanity tests to TCP_QUEUE_SEQ
Date:   Mon,  1 Mar 2021 10:29:17 -0800
Message-Id: <20210301182917.1844037-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Qingyu Li reported a syzkaller bug where the repro
changes RCV SEQ _after_ restoring data in the receive queue.

mprotect(0x4aa000, 12288, PROT_READ)    = 0
mmap(0x1ffff000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x1ffff000
mmap(0x20000000, 16777216, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x20000000
mmap(0x21000000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x21000000
socket(AF_INET6, SOCK_STREAM, IPPROTO_IP) = 3
setsockopt(3, SOL_TCP, TCP_REPAIR, [1], 4) = 0
connect(3, {sa_family=AF_INET6, sin6_port=htons(0), sin6_flowinfo=htonl(0), inet_pton(AF_INET6, "::1", &sin6_addr), sin6_scope_id=0}, 28) = 0
setsockopt(3, SOL_TCP, TCP_REPAIR_QUEUE, [1], 4) = 0
sendmsg(3, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="0x0000000000000003\0\0", iov_len=20}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 20
setsockopt(3, SOL_TCP, TCP_REPAIR, [0], 4) = 0
setsockopt(3, SOL_TCP, TCP_QUEUE_SEQ, [128], 4) = 0
recvfrom(3, NULL, 20, 0, NULL, NULL)    = -1 ECONNRESET (Connection reset by peer)

syslog shows:
[  111.205099] TCP recvmsg seq # bug 2: copied 80, seq 0, rcvnxt 80, fl 0
[  111.207894] WARNING: CPU: 1 PID: 356 at net/ipv4/tcp.c:2343 tcp_recvmsg_locked+0x90e/0x29a0

This should not be allowed. TCP_QUEUE_SEQ should only be used
when queues are empty.

This patch fixes this case, and the tx path as well.

Fixes: ee9952831cfd ("tcp: Initial repair mode")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=212005
Reported-by: Qingyu Li <ieatmuttonchuan@gmail.com>
---
 net/ipv4/tcp.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index dfb6f286c1de92aa505ba3554018ecaa3b94fc40..de7cc8445ac035ff2f7d17b93acabd7342144da8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3469,16 +3469,23 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case TCP_QUEUE_SEQ:
-		if (sk->sk_state != TCP_CLOSE)
+		if (sk->sk_state != TCP_CLOSE) {
 			err = -EPERM;
-		else if (tp->repair_queue == TCP_SEND_QUEUE)
-			WRITE_ONCE(tp->write_seq, val);
-		else if (tp->repair_queue == TCP_RECV_QUEUE) {
-			WRITE_ONCE(tp->rcv_nxt, val);
-			WRITE_ONCE(tp->copied_seq, val);
-		}
-		else
+		} else if (tp->repair_queue == TCP_SEND_QUEUE) {
+			if (!tcp_rtx_queue_empty(sk))
+				err = -EPERM;
+			else
+				WRITE_ONCE(tp->write_seq, val);
+		} else if (tp->repair_queue == TCP_RECV_QUEUE) {
+			if (tp->rcv_nxt != tp->copied_seq) {
+				err = -EPERM;
+			} else {
+				WRITE_ONCE(tp->rcv_nxt, val);
+				WRITE_ONCE(tp->copied_seq, val);
+			}
+		} else {
 			err = -EINVAL;
+		}
 		break;
 
 	case TCP_REPAIR_OPTIONS:
-- 
2.30.1.766.gb4fecdf3b7-goog

