Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF61421462F
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 15:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgGDNnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 09:43:09 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:60533 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgGDNnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 09:43:09 -0400
X-Originating-IP: 82.66.179.123
Received: from localhost (unknown [82.66.179.123])
        (Authenticated sender: repk@triplefau.lt)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id C75CB1BF205;
        Sat,  4 Jul 2020 13:43:04 +0000 (UTC)
From:   Remi Pommarel <repk@triplefau.lt>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Javier Cardona <javier@cozybit.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Remi Pommarel <repk@triplefau.lt>
Subject: [PATCH] mac80211: mesh: Free ie data when leaving mesh
Date:   Sat,  4 Jul 2020 15:50:07 +0200
Message-Id: <20200704135007.27292-1-repk@triplefau.lt>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At ieee80211_join_mesh() some ie data could have been allocated (see
copy_mesh_setup()) and need to be cleaned up when leaving the mesh.

This fixes the following kmemleak report:

unreferenced object 0xffff0000116bc600 (size 128):
  comm "wpa_supplicant", pid 608, jiffies 4294898983 (age 293.484s)
  hex dump (first 32 bytes):
    30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00  0...............
    00 0f ac 08 00 00 00 00 c4 65 40 00 00 00 00 00  .........e@.....
  backtrace:
    [<00000000bebe439d>] __kmalloc_track_caller+0x1c0/0x330
    [<00000000a349dbe1>] kmemdup+0x28/0x50
    [<0000000075d69baa>] ieee80211_join_mesh+0x6c/0x3b8 [mac80211]
    [<00000000683bb98b>] __cfg80211_join_mesh+0x1e8/0x4f0 [cfg80211]
    [<0000000072cb507f>] nl80211_join_mesh+0x520/0x6b8 [cfg80211]
    [<0000000077e9bcf9>] genl_family_rcv_msg+0x374/0x680
    [<00000000b1bd936d>] genl_rcv_msg+0x78/0x108
    [<0000000022c53788>] netlink_rcv_skb+0xb0/0x1c0
    [<0000000011af8ec9>] genl_rcv+0x34/0x48
    [<0000000069e41f53>] netlink_unicast+0x268/0x2e8
    [<00000000a7517316>] netlink_sendmsg+0x320/0x4c0
    [<0000000069cba205>] ____sys_sendmsg+0x354/0x3a0
    [<00000000e06bab0f>] ___sys_sendmsg+0xd8/0x120
    [<0000000037340728>] __sys_sendmsg+0xa4/0xf8
    [<000000004fed9776>] __arm64_sys_sendmsg+0x44/0x58
    [<000000001c1e5647>] el0_svc_handler+0xd0/0x1a0

Fixes: c80d545da3f7 (mac80211: Let userspace enable and configure vendor specific path selection.)
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
---
 net/mac80211/cfg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9b360544ad6f..1079a07e43e4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2166,6 +2166,7 @@ static int ieee80211_leave_mesh(struct wiphy *wiphy, struct net_device *dev)
 	ieee80211_stop_mesh(sdata);
 	mutex_lock(&sdata->local->mtx);
 	ieee80211_vif_release_channel(sdata);
+	kfree(sdata->u.mesh.ie);
 	mutex_unlock(&sdata->local->mtx);
 
 	return 0;
-- 
2.26.2

