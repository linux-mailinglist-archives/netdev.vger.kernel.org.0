Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFC21EF356
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 10:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgFEIq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 04:46:57 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:56981 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726084AbgFEIq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 04:46:56 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01422;MF=anny.hu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U-dVCGy_1591346802;
Received: from L-PF215YVF-1240.hz.ali.com(mailfrom:anny.hu@linux.alibaba.com fp:SMTPD_---0U-dVCGy_1591346802)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Jun 2020 16:46:54 +0800
From:   dihu <anny.hu@linux.alibaba.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, dihu <anny.hu@linux.alibaba.com>
Subject: [PATCH] bpf/sockmap: fix kernel panic at __tcp_bpf_recvmsg
Date:   Fri,  5 Jun 2020 16:46:25 +0800
Message-Id: <20200605084625.9783-1-anny.hu@linux.alibaba.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When user application calls read() with MSG_PEEK flag to read data
of bpf sockmap socket, kernel panic happens at
__tcp_bpf_recvmsg+0x12c/0x350. sk_msg is not removed from ingress_msg
queue after read out under MSG_PEEK flag is set. Because it's not
judged whether sk_msg is the last msg of ingress_msg queue, the next
sk_msg may be the head of ingress_msg queue, whose memory address of
sg page is invalid. So it's necessary to add check codes to prevent
this problem.

[20759.125457] BUG: kernel NULL pointer dereference, address:
0000000000000008
[20759.132118] CPU: 53 PID: 51378 Comm: envoy Tainted: G            E
5.4.32 #1
[20759.140890] Hardware name: Inspur SA5212M4/YZMB-00370-109, BIOS
4.1.12 06/18/2017
[20759.149734] RIP: 0010:copy_page_to_iter+0xad/0x300
[20759.270877] __tcp_bpf_recvmsg+0x12c/0x350
[20759.276099] tcp_bpf_recvmsg+0x113/0x370
[20759.281137] inet_recvmsg+0x55/0xc0
[20759.285734] __sys_recvfrom+0xc8/0x130
[20759.290566] ? __audit_syscall_entry+0x103/0x130
[20759.296227] ? syscall_trace_enter+0x1d2/0x2d0
[20759.301700] ? __audit_syscall_exit+0x1e4/0x290
[20759.307235] __x64_sys_recvfrom+0x24/0x30
[20759.312226] do_syscall_64+0x55/0x1b0
[20759.316852] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: dihu <anny.hu@linux.alibaba.com>
---
 net/ipv4/tcp_bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 5a05327..b82e4c3 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -64,6 +64,9 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 		} while (i != msg_rx->sg.end);
 
 		if (unlikely(peek)) {
+			if (msg_rx == list_last_entry(&psock->ingress_msg,
+						      struct sk_msg, list))
+				break;
 			msg_rx = list_next_entry(msg_rx, list);
 			continue;
 		}
-- 
1.8.3.1

