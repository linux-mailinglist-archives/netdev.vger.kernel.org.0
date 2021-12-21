Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1D047C8D3
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 22:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236944AbhLUVeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 16:34:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236211AbhLUVeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 16:34:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640122453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YYcKmNB3YuOGfiRPOyAf8GtH4Gs9CdGfb+H9mv9OP74=;
        b=WOOg1CnuV0GOY0Y82NVhf0qbKtHb/3YVmdgK9ADOsLndIJhA6YvZTqBQsIE6HrbwXPAYDG
        OZaK7XgCep5MISRgGN5jOZGxX9D4cieMCuoED8ScmF/R7OIrjQ0KQodiBhY2vckYWXkREL
        qmoSP3Npv87KjbPmIrVitM76dcw9RbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-qi5mKOV-Pqukcqq_ZsproQ-1; Tue, 21 Dec 2021 16:34:08 -0500
X-MC-Unique: qi5mKOV-Pqukcqq_ZsproQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9822A363A6;
        Tue, 21 Dec 2021 21:34:07 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 975317C83D;
        Tue, 21 Dec 2021 21:34:06 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Ignat Korchagin <ignat@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] veth: ensure skb entering GRO are not cloned.
Date:   Tue, 21 Dec 2021 22:33:36 +0100
Message-Id: <26109603287b4d21545bec125e43b218b545b746.1640111022.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit d3256efd8e8b ("veth: allow enabling NAPI even without XDP"),
if GRO is enabled on a veth device and TSO is disabled on the peer
device, TCP skbs will go through the NAPI callback. If there is no XDP
program attached, the veth code does not perform any share check, and
shared/cloned skbs could enter the GRO engine.

Ignat reported a BUG triggered later-on due to the above condition:

[   53.970529][    C1] kernel BUG at net/core/skbuff.c:3574!
[   53.981755][    C1] invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
[   53.982634][    C1] CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted 5.16.0-rc5+ #25
[   53.982634][    C1] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[   53.982634][    C1] RIP: 0010:skb_shift+0x13ef/0x23b0
[   53.982634][    C1] Code: ea 03 0f b6 04 02 48 89 fa 83 e2 07 38 d0
7f 08 84 c0 0f 85 41 0c 00 00 41 80 7f 02 00 4d 8d b5 d0 00 00 00 0f
85 74 f5 ff ff <0f> 0b 4d 8d 77 20 be 04 00 00 00 4c 89 44 24 78 4c 89
f7 4c 89 8c
[   53.982634][    C1] RSP: 0018:ffff8881008f7008 EFLAGS: 00010246
[   53.982634][    C1] RAX: 0000000000000000 RBX: ffff8881180b4c80 RCX: 0000000000000000
[   53.982634][    C1] RDX: 0000000000000002 RSI: ffff8881180b4d3c RDI: ffff88810bc9cac2
[   53.982634][    C1] RBP: ffff8881008f70b8 R08: ffff8881180b4cf4 R09: ffff8881180b4cf0
[   53.982634][    C1] R10: ffffed1022999e5c R11: 0000000000000002 R12: 0000000000000590
[   53.982634][    C1] R13: ffff88810f940c80 R14: ffff88810f940d50 R15: ffff88810bc9cac0
[   53.982634][    C1] FS:  0000000000000000(0000) GS:ffff888235880000(0000) knlGS:0000000000000000
[   53.982634][    C1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   53.982634][    C1] CR2: 00007ff5f9b86680 CR3: 0000000108ce8004 CR4: 0000000000170ee0
[   53.982634][    C1] Call Trace:
[   53.982634][    C1]  <TASK>
[   53.982634][    C1]  tcp_sacktag_walk+0xaba/0x18e0
[   53.982634][    C1]  tcp_sacktag_write_queue+0xe7b/0x3460
[   53.982634][    C1]  tcp_ack+0x2666/0x54b0
[   53.982634][    C1]  tcp_rcv_established+0x4d9/0x20f0
[   53.982634][    C1]  tcp_v4_do_rcv+0x551/0x810
[   53.982634][    C1]  tcp_v4_rcv+0x22ed/0x2ed0
[   53.982634][    C1]  ip_protocol_deliver_rcu+0x96/0xaf0
[   53.982634][    C1]  ip_local_deliver_finish+0x1e0/0x2f0
[   53.982634][    C1]  ip_sublist_rcv_finish+0x211/0x440
[   53.982634][    C1]  ip_list_rcv_finish.constprop.0+0x424/0x660
[   53.982634][    C1]  ip_list_rcv+0x2c8/0x410
[   53.982634][    C1]  __netif_receive_skb_list_core+0x65c/0x910
[   53.982634][    C1]  netif_receive_skb_list_internal+0x5f9/0xcb0
[   53.982634][    C1]  napi_complete_done+0x188/0x6e0
[   53.982634][    C1]  gro_cell_poll+0x10c/0x1d0
[   53.982634][    C1]  __napi_poll+0xa1/0x530
[   53.982634][    C1]  net_rx_action+0x567/0x1270
[   53.982634][    C1]  __do_softirq+0x28a/0x9ba
[   53.982634][    C1]  run_ksoftirqd+0x32/0x60
[   53.982634][    C1]  smpboot_thread_fn+0x559/0x8c0
[   53.982634][    C1]  kthread+0x3b9/0x490
[   53.982634][    C1]  ret_from_fork+0x22/0x30
[   53.982634][    C1]  </TASK>

Address the issue checking for cloned skbs even in the GRO-without-XDP
input path.

Reported-and-tested-by: Ignat Korchagin <ignat@cloudflare.com>
Fixes: d3256efd8e8b ("veth: allow enabling NAPI even without XDP")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/veth.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index b78894c38933..abd1f949b2f5 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -718,6 +718,14 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (unlikely(!xdp_prog)) {
+		if (unlikely(skb_shared(skb) || skb_head_is_locked(skb))) {
+			struct sk_buff *nskb = skb_copy(skb, GFP_ATOMIC | __GFP_NOWARN);
+
+			if (!nskb)
+				goto drop;
+			consume_skb(skb);
+			skb = nskb;
+		}
 		rcu_read_unlock();
 		goto out;
 	}
-- 
2.33.1

