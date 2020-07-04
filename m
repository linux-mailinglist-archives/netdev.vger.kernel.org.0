Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93740214632
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 15:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgGDNq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 09:46:59 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:59243 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgGDNq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 09:46:59 -0400
X-Originating-IP: 82.66.179.123
Received: from localhost (unknown [82.66.179.123])
        (Authenticated sender: repk@triplefau.lt)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 406D1C0003;
        Sat,  4 Jul 2020 13:46:54 +0000 (UTC)
From:   Remi Pommarel <repk@triplefau.lt>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Remi Pommarel <repk@triplefau.lt>
Subject: [PATCH] mac80211: mesh: Free pending skb when destroying a mpath
Date:   Sat,  4 Jul 2020 15:54:19 +0200
Message-Id: <20200704135419.27703-1-repk@triplefau.lt>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A mpath object can hold reference on a list of skb that are waiting for
mpath resolution to be sent. When destroying a mpath this skb list
should be cleaned up in order to not leak memory.

Fixing that kind of leak:

unreferenced object 0xffff0000181c9300 (size 1088):
  comm "openvpn", pid 1782, jiffies 4295071698 (age 80.416s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 f9 80 36 00 00 00 00 00  ..........6.....
    02 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
  backtrace:
    [<000000004bc6a443>] kmem_cache_alloc+0x1a4/0x2f0
    [<000000002caaef13>] sk_prot_alloc.isra.39+0x34/0x178
    [<00000000ceeaa916>] sk_alloc+0x34/0x228
    [<00000000ca1f1d04>] inet_create+0x198/0x518
    [<0000000035626b1c>] __sock_create+0x134/0x328
    [<00000000a12b3a87>] __sys_socket+0xb0/0x158
    [<00000000ff859f23>] __arm64_sys_socket+0x40/0x58
    [<00000000263486ec>] el0_svc_handler+0xd0/0x1a0
    [<0000000005b5157d>] el0_svc+0x8/0xc
unreferenced object 0xffff000012973a40 (size 216):
  comm "openvpn", pid 1782, jiffies 4295082137 (age 38.660s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 c0 06 16 00 00 ff ff 00 93 1c 18 00 00 ff ff  ................
  backtrace:
    [<000000004bc6a443>] kmem_cache_alloc+0x1a4/0x2f0
    [<0000000023c8c8f9>] __alloc_skb+0xc0/0x2b8
    [<000000007ad950bb>] alloc_skb_with_frags+0x60/0x320
    [<00000000ef90023a>] sock_alloc_send_pskb+0x388/0x3c0
    [<00000000104fb1a3>] sock_alloc_send_skb+0x1c/0x28
    [<000000006919d2dd>] __ip_append_data+0xba4/0x11f0
    [<0000000083477587>] ip_make_skb+0x14c/0x1a8
    [<0000000024f3d592>] udp_sendmsg+0xaf0/0xcf0
    [<000000005aabe255>] inet_sendmsg+0x5c/0x80
    [<000000008651ea08>] __sys_sendto+0x15c/0x218
    [<000000003505c99b>] __arm64_sys_sendto+0x74/0x90
    [<00000000263486ec>] el0_svc_handler+0xd0/0x1a0
    [<0000000005b5157d>] el0_svc+0x8/0xc

Fixes: 2bdaf386f99c (mac80211: mesh: move path tables into if_mesh)
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
---
 net/mac80211/mesh_pathtbl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 117519bf33d6..aca608ae313f 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -521,6 +521,7 @@ static void mesh_path_free_rcu(struct mesh_table *tbl,
 	del_timer_sync(&mpath->timer);
 	atomic_dec(&sdata->u.mesh.mpaths);
 	atomic_dec(&tbl->entries);
+	mesh_path_flush_pending(mpath);
 	kfree_rcu(mpath, rcu);
 }
 
-- 
2.26.2

