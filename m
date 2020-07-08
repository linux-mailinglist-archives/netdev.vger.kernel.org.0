Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A10217F28
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 07:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgGHFjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 01:39:05 -0400
Received: from nwk-aaemail-lapp01.apple.com ([17.151.62.66]:53428 "EHLO
        nwk-aaemail-lapp01.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726206AbgGHFjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 01:39:05 -0400
X-Greylist: delayed 5224 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jul 2020 01:39:04 EDT
Received: from pps.filterd (nwk-aaemail-lapp01.apple.com [127.0.0.1])
        by nwk-aaemail-lapp01.apple.com (8.16.0.42/8.16.0.42) with SMTP id 0684334R061456;
        Tue, 7 Jul 2020 21:11:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=20180706; bh=aWP1NAGwUu9GsOwVIJkKWhciofQDNXN8LqH61SRwORQ=;
 b=vpFrq+kFwctLG9wUyPLIb//v2v+JWoDc80i7hw427WN7uUYYu7fLBHWN5KhWKg/8fSZf
 nnlTMUX56aMCbwYxeW1bpIlZ0FGCi9fHTikFGPWA22LWcRcuQ2yUjBl0NA+qL3Zq++Ye
 eOF8ajhMvHf2/q9qQcHMoaV2WE+IXCd1w4r1/1ARIHNOK+lgcVx6NzQqZ8tS5tsQu+Ej
 /NP3zR/s/jba6NKgsB91Zi3B8P5bkSIWnr+HnpnBFbS0o60n1diFNKIDm39upsGLAdJd
 66a75v53FJ4xKm9/PSq2Ml6C8P1P/Wniisrlr2o4NEGup3iFryqxr0i4A2c+BEgZerJt yg== 
Received: from rn-mailsvcp-mta-lapp03.rno.apple.com (rn-mailsvcp-mta-lapp03.rno.apple.com [10.225.203.151])
        by nwk-aaemail-lapp01.apple.com with ESMTP id 322rq0hvne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 07 Jul 2020 21:11:56 -0700
Received: from rn-mailsvcp-mmp-lapp01.rno.apple.com
 (rn-mailsvcp-mmp-lapp01.rno.apple.com [17.179.253.14])
 by rn-mailsvcp-mta-lapp03.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) with ESMTPS id <0QD400KEGUBWVN40@rn-mailsvcp-mta-lapp03.rno.apple.com>;
 Tue, 07 Jul 2020 21:11:56 -0700 (PDT)
Received: from process_milters-daemon.rn-mailsvcp-mmp-lapp01.rno.apple.com by
 rn-mailsvcp-mmp-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) id <0QD400O00U4CFB00@rn-mailsvcp-mmp-lapp01.rno.apple.com>; Tue,
 07 Jul 2020 21:11:56 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: 58b165e5c05c56e35c1cede95136570d
X-Va-E-CD: 02acc96795e1587756ebbda813435c28
X-Va-R-CD: 810e8078db3a01040172ddd4fa019fa9
X-Va-CD: 0
X-Va-ID: 5e4f14f2-3dd0-4b6a-9699-8fc38269d132
X-V-A:  
X-V-T-CD: 58b165e5c05c56e35c1cede95136570d
X-V-E-CD: 02acc96795e1587756ebbda813435c28
X-V-R-CD: 810e8078db3a01040172ddd4fa019fa9
X-V-CD: 0
X-V-ID: 9e8764e6-da35-4357-b4de-0a6cde6def26
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_01:2020-07-08,2020-07-08 signatures=0
Received: from localhost ([17.150.208.217])
 by rn-mailsvcp-mmp-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020))
 with ESMTPSA id <0QD400L2UUBVKI40@rn-mailsvcp-mmp-lapp01.rno.apple.com>; Tue,
 07 Jul 2020 21:11:56 -0700 (PDT)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] tcp: Initialize ca_priv when inheriting from listener
Date:   Tue, 07 Jul 2020 21:10:30 -0700
Message-id: <20200708041030.24375-1-cpaasch@apple.com>
X-Mailer: git-send-email 2.23.0
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_01:2020-07-08,2020-07-08 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzkaller found its way into setsockopt with TCP_CONGESTION "cdg".
tcp_cdg_init() does a kcalloc to store the gradients. As sk_clone_lock
just copies all the memory, the allocated pointer will be copied as
well, if the app called setsockopt(..., TCP_CONGESTION) on the listener.
If now the socket will be destroyed before the congestion-control
has properly been initialized (through a call to tcp_init_transfer), we
will end up freeing memory that does not belong to that particular
socket, opening the door to a double-free:

[   11.413102] ==================================================================
[   11.414181] BUG: KASAN: double-free or invalid-free in tcp_cleanup_congestion_control+0x58/0xd0
[   11.415329]
[   11.415560] CPU: 3 PID: 4884 Comm: syz-executor.5 Not tainted 5.8.0-rc2 #80
[   11.416544] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[   11.418148] Call Trace:
[   11.418534]  <IRQ>
[   11.418834]  dump_stack+0x7d/0xb0
[   11.419297]  print_address_description.constprop.0+0x1a/0x210
[   11.422079]  kasan_report_invalid_free+0x51/0x80
[   11.423433]  __kasan_slab_free+0x15e/0x170
[   11.424761]  kfree+0x8c/0x230
[   11.425157]  tcp_cleanup_congestion_control+0x58/0xd0
[   11.425872]  tcp_v4_destroy_sock+0x57/0x5a0
[   11.426493]  inet_csk_destroy_sock+0x153/0x2c0
[   11.427093]  tcp_v4_syn_recv_sock+0xb29/0x1100
[   11.427731]  tcp_get_cookie_sock+0xc3/0x4a0
[   11.429457]  cookie_v4_check+0x13d0/0x2500
[   11.433189]  tcp_v4_do_rcv+0x60e/0x780
[   11.433727]  tcp_v4_rcv+0x2869/0x2e10
[   11.437143]  ip_protocol_deliver_rcu+0x23/0x190
[   11.437810]  ip_local_deliver+0x294/0x350
[   11.439566]  __netif_receive_skb_one_core+0x15d/0x1a0
[   11.441995]  process_backlog+0x1b1/0x6b0
[   11.443148]  net_rx_action+0x37e/0xc40
[   11.445361]  __do_softirq+0x18c/0x61a
[   11.445881]  asm_call_on_stack+0x12/0x20
[   11.446409]  </IRQ>
[   11.446716]  do_softirq_own_stack+0x34/0x40
[   11.447259]  do_softirq.part.0+0x26/0x30
[   11.447827]  __local_bh_enable_ip+0x46/0x50
[   11.448406]  ip_finish_output2+0x60f/0x1bc0
[   11.450109]  __ip_queue_xmit+0x71c/0x1b60
[   11.451861]  __tcp_transmit_skb+0x1727/0x3bb0
[   11.453789]  tcp_rcv_state_process+0x3070/0x4d3a
[   11.456810]  tcp_v4_do_rcv+0x2ad/0x780
[   11.457995]  __release_sock+0x14b/0x2c0
[   11.458529]  release_sock+0x4a/0x170
[   11.459005]  __inet_stream_connect+0x467/0xc80
[   11.461435]  inet_stream_connect+0x4e/0xa0
[   11.462043]  __sys_connect+0x204/0x270
[   11.465515]  __x64_sys_connect+0x6a/0xb0
[   11.466088]  do_syscall_64+0x3e/0x70
[   11.466617]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   11.467341] RIP: 0033:0x7f56046dc469
[   11.467844] Code: Bad RIP value.
[   11.468282] RSP: 002b:00007f5604dccdd8 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
[   11.469326] RAX: ffffffffffffffda RBX: 000000000068bf00 RCX: 00007f56046dc469
[   11.470379] RDX: 0000000000000010 RSI: 0000000020000000 RDI: 0000000000000004
[   11.471311] RBP: 00000000ffffffff R08: 0000000000000000 R09: 0000000000000000
[   11.472286] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[   11.473341] R13: 000000000041427c R14: 00007f5604dcd5c0 R15: 0000000000000003
[   11.474321]
[   11.474527] Allocated by task 4884:
[   11.475031]  save_stack+0x1b/0x40
[   11.475548]  __kasan_kmalloc.constprop.0+0xc2/0xd0
[   11.476182]  tcp_cdg_init+0xf0/0x150
[   11.476744]  tcp_init_congestion_control+0x9b/0x3a0
[   11.477435]  tcp_set_congestion_control+0x270/0x32f
[   11.478088]  do_tcp_setsockopt.isra.0+0x521/0x1a00
[   11.478744]  __sys_setsockopt+0xff/0x1e0
[   11.479259]  __x64_sys_setsockopt+0xb5/0x150
[   11.479895]  do_syscall_64+0x3e/0x70
[   11.480395]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   11.481097]
[   11.481321] Freed by task 4872:
[   11.481783]  save_stack+0x1b/0x40
[   11.482230]  __kasan_slab_free+0x12c/0x170
[   11.482839]  kfree+0x8c/0x230
[   11.483240]  tcp_cleanup_congestion_control+0x58/0xd0
[   11.483948]  tcp_v4_destroy_sock+0x57/0x5a0
[   11.484502]  inet_csk_destroy_sock+0x153/0x2c0
[   11.485144]  tcp_close+0x932/0xfe0
[   11.485642]  inet_release+0xc1/0x1c0
[   11.486131]  __sock_release+0xc0/0x270
[   11.486697]  sock_close+0xc/0x10
[   11.487145]  __fput+0x277/0x780
[   11.487632]  task_work_run+0xeb/0x180
[   11.488118]  __prepare_exit_to_usermode+0x15a/0x160
[   11.488834]  do_syscall_64+0x4a/0x70
[   11.489326]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Wei Wang fixed a part of these CDG-malloc issues with commit c12014440750
("tcp: memset ca_priv data to 0 properly").

This patch here fixes the listener-scenario by memsetting ca_priv to 0
after its content has been inherited by the listener.

(The issue can be reproduced at least down to v4.4.x.)

Cc: Wei Wang <weiwan@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Fixes: 2b0a8c9ee ("tcp: add CDG congestion control")
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 net/ipv4/inet_connection_sock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index afaf582a5aa9..dc9432f9248a 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -850,6 +850,8 @@ struct sock *inet_csk_clone_lock(const struct sock *sk,
 		newicsk->icsk_backoff	  = 0;
 		newicsk->icsk_probes_out  = 0;
 
+		memset(newicsk->icsk_ca_priv, 0, sizeof(newicsk->icsk_ca_priv));
+
 		/* Deinitialize accept_queue to trap illegal accesses. */
 		memset(&newicsk->icsk_accept_queue, 0, sizeof(newicsk->icsk_accept_queue));
 
-- 
2.23.0

