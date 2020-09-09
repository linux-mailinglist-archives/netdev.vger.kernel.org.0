Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582BD26303F
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 17:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729692AbgIIPKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 11:10:54 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:57309 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730083AbgIIL73 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 07:59:29 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 0002fbc2;
        Wed, 9 Sep 2020 11:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=WRPTJHH8GASfujm1rHt7Zug89
        kw=; b=Ff5SFrAmLcBdJNdQC+SiUKJqTzN7xS6uEhEtNA5wpVp/+GHXL/b8m6dIM
        23slzrCxN9CqE4ddt1is/YyRJQOg2PsPk3lG21Ode164a/H5CXKERY0W13hLvkyS
        iPqsAo8A0vKNwqs61b1e5Wm48L0r+FkVAQjhfkCiOBwzn6A4FubJRSwsJO9TOJSX
        dIKVln3GptJyuM4wt3s1TE0j1xVuOv+siMed5bW5oAybwNaqLyFh0b6YHD+XdXWm
        LntG9yirjpqalruGEbstmuxfHUDAnWZiF1aaDGzU5Bblj/8T7AXohL2iNL/8xpBP
        OYNB0HYkPJhaVmiMpqShmM4aIyRCg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 795dd0f3 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 9 Sep 2020 11:29:29 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net 1/2] wireguard: noise: take lock when removing handshake entry from table
Date:   Wed,  9 Sep 2020 13:58:14 +0200
Message-Id: <20200909115815.522168-2-Jason@zx2c4.com>
In-Reply-To: <20200909115815.522168-1-Jason@zx2c4.com>
References: <20200909115815.522168-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric reported that syzkaller found a race of this variety:

CPU 1                                       CPU 2
-------------------------------------------|---------------------------------------
wg_index_hashtable_replace(old, ...)       |
  if (hlist_unhashed(&old->index_hash))    |
                                           | wg_index_hashtable_remove(old)
                                           |   hlist_del_init_rcu(&old->index_hash)
				           |     old->index_hash.pprev = NULL
  hlist_replace_rcu(&old->index_hash, ...) |
    *old->index_hash.pprev                 |

Syzbot wasn't actually able to reproduce this more than once or create a
reproducer, because the race window between checking "hlist_unhashed" and
calling "hlist_replace_rcu" is just so small. Adding an mdelay(5) or
similar there helps make this demonstrable using this simple script:

    #!/bin/bash
    set -ex
    trap 'kill $pid1; kill $pid2; ip link del wg0; ip link del wg1' EXIT
    ip link add wg0 type wireguard
    ip link add wg1 type wireguard
    wg set wg0 private-key <(wg genkey) listen-port 9999
    wg set wg1 private-key <(wg genkey) peer $(wg show wg0 public-key) endpoint 127.0.0.1:9999 persistent-keepalive 1
    wg set wg0 peer $(wg show wg1 public-key)
    ip link set wg0 up
    yes link set wg1 up | ip -force -batch - &
    pid1=$!
    yes link set wg1 down | ip -force -batch - &
    pid2=$!
    wait

The fundumental underlying problem is that we permit calls to wg_index_
hashtable_remove(handshake.entry) without requiring the caller to take
the handshake mutex that is intended to protect members of handshake
during mutations. This is consistently the case with calls to wg_index_
hashtable_insert(handshake.entry) and wg_index_hashtable_replace(
handshake.entry), but it's missing from a pertinent callsite of wg_
index_hashtable_remove(handshake.entry). So, this patch makes sure that
mutex is taken.

The original code was a little bit funky though, in the form of:

    remove(handshake.entry)
    lock(), memzero(handshake.some_members), unlock()
    remove(handshake.entry)

The original intention of that double removal pattern outside the lock
appears to be some attempt to prevent insertions that might happen while
locks are dropped during expensive crypto operations, but actually, all
callers of wg_index_hashtable_insert(handshake.entry) take the write
lock and then explicitly check handshake.state, as they should, which
the aforementioned memzero clears, which means an insertion should
already be impossible. And regardless, the original intention was
necessarily racy, since it wasn't guaranteed that something else would
run after the unlock() instead of after the remove(). So, from a
soundness perspective, it seems positive to remove what looks like a
hack at best.

The crash from both syzbot and from the script above is as follows:

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

Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/wireguard/20200908145911.4090480-1-edumazet@google.com/
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/noise.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireguard/noise.c b/drivers/net/wireguard/noise.c
index 3dd3b76790d0..c0cfd9b36c0b 100644
--- a/drivers/net/wireguard/noise.c
+++ b/drivers/net/wireguard/noise.c
@@ -87,15 +87,12 @@ static void handshake_zero(struct noise_handshake *handshake)
 
 void wg_noise_handshake_clear(struct noise_handshake *handshake)
 {
+	down_write(&handshake->lock);
 	wg_index_hashtable_remove(
 			handshake->entry.peer->device->index_hashtable,
 			&handshake->entry);
-	down_write(&handshake->lock);
 	handshake_zero(handshake);
 	up_write(&handshake->lock);
-	wg_index_hashtable_remove(
-			handshake->entry.peer->device->index_hashtable,
-			&handshake->entry);
 }
 
 static struct noise_keypair *keypair_create(struct wg_peer *peer)
-- 
2.28.0

