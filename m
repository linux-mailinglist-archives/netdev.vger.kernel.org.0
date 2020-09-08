Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392E7261387
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 17:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgIHPa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 11:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730263AbgIHPZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:25:27 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81199C0A893F
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 07:59:23 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id l1so9366861qvr.0
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 07:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=8GtHzLamWF1VdpdZidutHU6JDUt0jFOujpQJCbTVejU=;
        b=lqWy7OWW74aa4m2zpN6hqIuEagOzSA/htlHyrXpcAmPOTf33E6mdnBfjwjkzRQok+p
         YvdQZmZ3uznQuN6K5pxSv+ASDSwzbHgU5orwq3IngNKqdUFlQF1k7K7XpoiX3xjy2cA6
         +8FzATgomKonTJcHenXKWLhV6q/nMxRpeZos4QqCIh+I6dtXZE4SYkL5Pm6fe2Unlefq
         1cKUVKBfR2ei2pNRnCDWUTthi8Dc+2B3fjfcP+AvSvcgK+iTfPn13IYn+sozSewPsXIh
         jEsm7MGckoHZXuXfx2xxKw3Mlho9eP0c8mTsyYVvdjAkXJyq7l1PidySDlQoQSV+hkED
         SDpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=8GtHzLamWF1VdpdZidutHU6JDUt0jFOujpQJCbTVejU=;
        b=BL8JGgPWUz1/7j/kV29OSD0vXDpGymMtAdXT/K36UtFcYtpPfVg4kcNItQyrmjHJzS
         rjmonCO0Jo9hUrZKtySrSB5u0HVAaEBAttPyxbLD+MITzdtusxoIqhc3bWfqXVsJSz4z
         76J4QieTn2EIX1i8IXd/qeG7FL79uBWxmR8YDvxmnbb2AqbIfT21zTueERApKoEwMcQE
         2LdCemozpGpWmhFs8kGNCB1HmG4oxiUD9B2DcIoDjspE8uhVQIauFCi5l35jMPXngtjm
         ltn6Ie/lJiNhROwz71nfjXxPf+CEM6xNMCkUnubEOEYP8SlP60IZ1WQpLGN4EiEmJLJV
         n3gA==
X-Gm-Message-State: AOAM530HAPuKG9wt9QlkALWGWQ8zQCJOYGSo+33GTNchW7iDrPD4hChb
        8+By6aOgUvqivpCdMs9DQvk8wAy5saoHkg==
X-Google-Smtp-Source: ABdhPJx5ddNvLuQ3mwAl4vJMNyRzuwtxd3GYMxGLIuj1NP1TQ9VX8nFburf9EJSoK9nppQFupFhFiPR9/jSB1g==
X-Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
 (user=edumazet job=sendgmr) by 2002:a0c:b2d4:: with SMTP id
 d20mr471451qvf.1.1599577158168; Tue, 08 Sep 2020 07:59:18 -0700 (PDT)
Date:   Tue,  8 Sep 2020 07:59:11 -0700
Message-Id: <20200908145911.4090480-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net] wireguard: fix race in wg_index_hashtable_replace()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot got a NULL dereference in wg_index_hashtable_replace() [1]

Issue here is that right after checking hlist_unhashed(&old->index_hash)
another cpu might have removed @old already from the hash.

Since we are dealing with a very unlikely case, we can simply
acquire the table lock earlier.

[1]
general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 7395 Comm: kworker/0:3 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: wg-kex-wg1 wg_packet_handshake_receive_worker
RIP: 0010:hlist_replace_rcu include/linux/rculist.h:505 [inline]
RIP: 0010:wg_index_hashtable_replace+0x176/0x330 drivers/net/wireguard/peerlookup.c:174
Code: 00 fc ff df 48 89 f9 48 c1 e9 03 80 3c 01 00 0f 85 44 01 00 00 48 b9 00 00 00 00 00 fc ff df 48 8b 45 10 48 89 c6 48 c1 ee 03 <80> 3c 0e 00 0f 85 06 01 00 00 48 85 d2 4c 89 28 74 47 e8 a3 4f b5
RSP: 0018:ffffc90006a97bf8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888050ffc4f8 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88808e04e010
RBP: ffff88808e04e000 R08: 0000000000000001 R09: ffff8880543d0000
R10: ffffed100a87a000 R11: 000000000000016e R12: ffff8880543d0000
R13: ffff88808e04e008 R14: ffff888050ffc508 R15: ffff888050ffc500
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000f5505db0 CR3: 0000000097cf7000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 wg_noise_handshake_begin_session+0x752/0xc9a drivers/net/wireguard/noise.c:820
 wg_receive_handshake_packet drivers/net/wireguard/receive.c:183 [inline]
 wg_packet_handshake_receive_worker+0x33b/0x730 drivers/net/wireguard/receive.c:220
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Modules linked in:
---[ end trace 0d737db78b72da84 ]---
RIP: 0010:hlist_replace_rcu include/linux/rculist.h:505 [inline]
RIP: 0010:wg_index_hashtable_replace+0x176/0x330 drivers/net/wireguard/peerlookup.c:174
Code: 00 fc ff df 48 89 f9 48 c1 e9 03 80 3c 01 00 0f 85 44 01 00 00 48 b9 00 00 00 00 00 fc ff df 48 8b 45 10 48 89 c6 48 c1 ee 03 <80> 3c 0e 00 0f 85 06 01 00 00 48 85 d2 4c 89 28 74 47 e8 a3 4f b5
RSP: 0018:ffffc90006a97bf8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888050ffc4f8 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88808e04e010
RBP: ffff88808e04e000 R08: 0000000000000001 R09: ffff8880543d0000
R10: ffffed100a87a000 R11: 000000000000016e R12: ffff8880543d0000
R13: ffff88808e04e008 R14: ffff888050ffc508 R15: ffff888050ffc500
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000f5505db0 CR3: 0000000097cf7000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: wireguard@lists.zx2c4.com
---
 drivers/net/wireguard/peerlookup.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireguard/peerlookup.c b/drivers/net/wireguard/peerlookup.c
index e4deb331476b3d67c1d24eb269b26f587798cbc2..d82eba263292474a7cdfb133b2ba1862a2e9352c 100644
--- a/drivers/net/wireguard/peerlookup.c
+++ b/drivers/net/wireguard/peerlookup.c
@@ -167,21 +167,25 @@ bool wg_index_hashtable_replace(struct index_hashtable *table,
 				struct index_hashtable_entry *old,
 				struct index_hashtable_entry *new)
 {
-	if (unlikely(hlist_unhashed(&old->index_hash)))
-		return false;
+
+	bool replaced = false;
+
 	spin_lock_bh(&table->lock);
-	new->index = old->index;
-	hlist_replace_rcu(&old->index_hash, &new->index_hash);
+	if (likely(!hlist_unhashed(&old->index_hash))) {
+		replaced = true;
+		new->index = old->index;
+		hlist_replace_rcu(&old->index_hash, &new->index_hash);
 
-	/* Calling init here NULLs out index_hash, and in fact after this
-	 * function returns, it's theoretically possible for this to get
-	 * reinserted elsewhere. That means the RCU lookup below might either
-	 * terminate early or jump between buckets, in which case the packet
-	 * simply gets dropped, which isn't terrible.
-	 */
-	INIT_HLIST_NODE(&old->index_hash);
+		/* Calling init here NULLs out index_hash, and in fact after this
+		 * function returns, it's theoretically possible for this to get
+		 * reinserted elsewhere. That means the RCU lookup below might either
+		 * terminate early or jump between buckets, in which case the packet
+		 * simply gets dropped, which isn't terrible.
+		 */
+		INIT_HLIST_NODE(&old->index_hash);
+	}
 	spin_unlock_bh(&table->lock);
-	return true;
+	return replaced;
 }
 
 void wg_index_hashtable_remove(struct index_hashtable *table,
-- 
2.28.0.526.ge36021eeef-goog

