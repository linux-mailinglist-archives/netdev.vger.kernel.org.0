Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57DA113F4F6
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389361AbgAPRIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:08:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389352AbgAPRIQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F11452192A;
        Thu, 16 Jan 2020 17:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194494;
        bh=P2tgffq5is540UJYUH8qV+fPM1TviJzp/s9I/PyPUFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JS+8Uns+KYbrGqBdoY32UUWrhuGde+JPYFFSYAkvIvAbM8Tbcpo3eMqCCP07EEWAI
         wg0jmtxddsNHr11eelKbjJLlXvp5UfXqrEI1OtTVsJj3hW5LyxmCuWEGUAKRBlTA1j
         GonVH68mK/p7syaw4MvQrXTusDqZCHm2Yw7p687g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Beckett <david.beckett@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 392/671] net: don't clear sock->sk early to avoid trouble in strparser
Date:   Thu, 16 Jan 2020 12:00:30 -0500
Message-Id: <20200116170509.12787-129-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 2b81f8161dfeda4017cef4f2498ccb64b13f0d61 ]

af_inet sets sock->sk to NULL which trips strparser over:

BUG: kernel NULL pointer dereference, address: 0000000000000012
PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
CPU: 7 PID: 0 Comm: swapper/7 Not tainted 5.2.0-rc1-00139-g14629453a6d3 #21
RIP: 0010:tcp_peek_len+0x10/0x60
RSP: 0018:ffffc02e41c54b98 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff9cf924c4e030 RCX: 0000000000000051
RDX: 0000000000000000 RSI: 000000000000000c RDI: ffff9cf97128f480
RBP: ffff9cf9365e0300 R08: ffff9cf94fe7d2c0 R09: 0000000000000000
R10: 000000000000036b R11: ffff9cf939735e00 R12: ffff9cf91ad9ae40
R13: ffff9cf924c4e000 R14: ffff9cf9a8fcbaae R15: 0000000000000020
FS: 0000000000000000(0000) GS:ffff9cf9af7c0000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000012 CR3: 000000013920a003 CR4: 00000000003606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
 <IRQ>
 strp_data_ready+0x48/0x90
 tls_data_ready+0x22/0xd0 [tls]
 tcp_rcv_established+0x569/0x620
 tcp_v4_do_rcv+0x127/0x1e0
 tcp_v4_rcv+0xad7/0xbf0
 ip_protocol_deliver_rcu+0x2c/0x1c0
 ip_local_deliver_finish+0x41/0x50
 ip_local_deliver+0x6b/0xe0
 ? ip_protocol_deliver_rcu+0x1c0/0x1c0
 ip_rcv+0x52/0xd0
 ? ip_rcv_finish_core.isra.20+0x380/0x380
 __netif_receive_skb_one_core+0x7e/0x90
 netif_receive_skb_internal+0x42/0xf0
 napi_gro_receive+0xed/0x150
 nfp_net_poll+0x7a2/0xd30 [nfp]
 ? kmem_cache_free_bulk+0x286/0x310
 net_rx_action+0x149/0x3b0
 __do_softirq+0xe3/0x30a
 ? handle_irq_event_percpu+0x6a/0x80
 irq_exit+0xe8/0xf0
 do_IRQ+0x85/0xd0
 common_interrupt+0xf/0xf
 </IRQ>
RIP: 0010:cpuidle_enter_state+0xbc/0x450

To avoid this issue set sock->sk after sk_prot->close.
My grepping and testing did not discover any code which
would depend on the current behaviour.

Fixes: c46234ebb4d1 ("tls: RX path for ktls")
Reported-by: David Beckett <david.beckett@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/af_inet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 1fbe2f815474..bbf3b3daa999 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -424,8 +424,8 @@ int inet_release(struct socket *sock)
 		if (sock_flag(sk, SOCK_LINGER) &&
 		    !(current->flags & PF_EXITING))
 			timeout = sk->sk_lingertime;
-		sock->sk = NULL;
 		sk->sk_prot->close(sk, timeout);
+		sock->sk = NULL;
 	}
 	return 0;
 }
-- 
2.20.1

