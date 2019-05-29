Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C955F2E96F
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 01:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfE2Xdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 19:33:45 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37969 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfE2Xdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 19:33:44 -0400
Received: by mail-qk1-f193.google.com with SMTP id a27so2672735qkk.5
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 16:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xt3DC3LRpaIEboSKzQWgQukBpnbJ9COACFzLlt+gP/o=;
        b=U+W8o4Oqvm0J6bZNJLYkxD0YL1wKt37srk2M/jqoT40GNG7mioNbAy3gC7bjiGoSnb
         S4wXKcvn7zNyOi/noufAk3CYo8TmRUHTPltbWg2T6sCUhjiHevY0ZsT9lHTmKUrI5zTG
         TYTcJmdUFWMmY05Yl41DrCSROMazswg0RGcI/ANxyeXw7oZmmwx48h5jclN9mNVtCf2w
         Vg/CXPeZXcXsbbKh+qGdZhNeHy+FeuigxB5HiikLrTqg9xVF0T9n5kKGVOLFuuQ0KJZX
         VJQTE0s/wOI3VOCGSrRSJjdzj+npgovg2uYezbONonmx+2iDLgCldQyCSciG5qTBVS/t
         OrLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xt3DC3LRpaIEboSKzQWgQukBpnbJ9COACFzLlt+gP/o=;
        b=uG68U0yZ6eJiHLbWlRX5HSKgcPJyqIAeVyBS/Grvcs1/aSpONKGmrvoaQe9e/PdbKG
         CgIXQnb92PpXR1/BsgL2K3H6BNGtC7ugJF6aC2M4xD4fR0ieEPZ2wHOzIS7mq4HQR7pY
         MMv0zWWAQlYlh/DPBN9tRVosop3QgfD7RW1l6dZMB/ke7C3WbRZdOpPV85A93BMkVIRD
         nIgOD09wPS5CjzWHs01u2o2eGNISGMMJKCoqXJv9P+kih92lUi/VpFxCkpq0Jq9yZqfQ
         8DDLK1c7JWRJt7hX+XaZQawxD+LAGzt+Mfo2bS10MwRSD3Il62Yl4al6QKrd7w8Yc9Li
         n/dg==
X-Gm-Message-State: APjAAAVMH9Q9WjdIRIbDigUbV7uH3kJWIPlhP6dKKkhceI27TU8VZxjl
        +we398lWw6TX8S2JGS6lJH8vow==
X-Google-Smtp-Source: APXvYqxm+FrYUJ88W71TpT5ApPzfc1ddGTKOcDD7JcFJ+qPql4djIcaRS00T9WKz+0lAGhyVcKfrmw==
X-Received: by 2002:ae9:df07:: with SMTP id t7mr439823qkf.193.1559172823762;
        Wed, 29 May 2019 16:33:43 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e37sm662001qte.23.2019.05.29.16.33.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 16:33:43 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        edumazet@google.com, alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Beckett <david.beckett@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net] net: don't clear sock->sk early to avoid trouble in strparser
Date:   Wed, 29 May 2019 16:33:23 -0700
Message-Id: <20190529233323.26602-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
We probably want to hold off on stable with this one :)
---
 net/ipv4/af_inet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 5183a2daba64..aff93e7cdb31 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -428,8 +428,8 @@ int inet_release(struct socket *sock)
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
2.21.0

