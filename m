Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7519C3ED953
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 16:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbhHPO6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 10:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbhHPO5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 10:57:53 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8265C061796
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 07:57:21 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id bo19so26843206edb.9
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 07:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S6bka7n7gUza4xP2Wps1Ishfu8bAYgf2m92TklQ/eyQ=;
        b=Dp0UXPFRjuNbluIqPUYBwYXP+Hmd9CJzy6JUb+ZgHUOu+EUptSSow2GN94ev2kNQmN
         J+c6exU8gLXZ62x42x7FNkBZdL3VNxq2S0nB/RlrvpcnNgHxd2mgkA2qC6JBBzn3Gfgv
         vVjcu4l3Z8lsC8Fj1Rh5h0huBYC2YNVE2fi6Ptwf3LqCV9pQaQQ19CPSVU3lMjAQBs+e
         rSh/NN1M7Kgm/J3P0HfmJmSzZu7AzY/Mz0FcMeGNq68pqWoHHRzu8a73004lty22HLQD
         Bj//aRqcMrwKhmj3/RXzrrd3SnbZOCPI9SH7Za1iROfCqCV4Wn/YRczGAKnBIt6g6Azs
         rJDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S6bka7n7gUza4xP2Wps1Ishfu8bAYgf2m92TklQ/eyQ=;
        b=NI4EWA2tb2zPfU19ltGP7y7U0LO8gYQoDXYMVCMRithGSJTMkBE2KPwhwbe5+DrYr3
         FsQe8AIitO7LjA6CrmA8Jpbhda3WQRh8wJr91z+adEwZwlapP8+i+9NsP+Pk9YmxynYe
         JktmGCBlkdOHZMkB63y7hRhPDZ5G8NImoZIABlDKz6dnWYkgwtRz0vpTrohmQYQs2HK8
         2V3S6fPernTp4LiNUBJgUatY3DVk6MlHq2eW1vg289xwjuTRFV05SMWMfKDkiMuDHCBe
         7zAmimY+XPq3TqR6b2JH4+5AbJkixbIzTv9iGwhjrDjpFlay88cD+VSHfKGRMJuq0srJ
         6RXQ==
X-Gm-Message-State: AOAM532AcRP/xzx+ssdD08NlTrmn20SrmG4lFhXPYrGMXPUa03GiTopu
        F88IZsE/F/hL/vqNILwPxuLXtS7kCgHKVrZd
X-Google-Smtp-Source: ABdhPJwMaMudg3C2wRC6jctJ9HDF1tZY7UC7wq8/5vRVBaVJAVoIAkZsMScqqTZI34HUF7m299ClBw==
X-Received: by 2002:a05:6402:13c5:: with SMTP id a5mr20272952edx.132.1629125839806;
        Mon, 16 Aug 2021 07:57:19 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t25sm4946076edi.65.2021.08.16.07.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 07:57:19 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 3/4] net: bridge: mcast: use the correct vlan group helper
Date:   Mon, 16 Aug 2021 17:57:06 +0300
Message-Id: <20210816145707.671901-4-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816145707.671901-1-razor@blackwall.org>
References: <20210816145707.671901-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

When dereferencing the port vlan group we should use the rcu helper
instead of the one relying on rtnl. In br_multicast_pg_to_port_ctx the
entry cannot disappear as we hold the multicast lock and rcu as explained
in the comment above it.
For the same reason we're ok in br_multicast_start_querier.

 =============================
 WARNING: suspicious RCU usage
 5.14.0-rc5+ #429 Tainted: G        W
 -----------------------------
 net/bridge/br_private.h:1478 suspicious rcu_dereference_protected() usage!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 3 locks held by swapper/2/0:
  #0: ffff88822be85eb0 ((&p->timer)){+.-.}-{0:0}, at: call_timer_fn+0x5/0x2da
  #1: ffff88810b32f260 (&br->multicast_lock){+.-.}-{3:3}, at: br_multicast_port_group_expired+0x28/0x13d [bridge]
  #2: ffffffff824f6c80 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire.constprop.0+0x0/0x22 [bridge]

 stack backtrace:
 CPU: 2 PID: 0 Comm: swapper/2 Kdump: loaded Tainted: G        W         5.14.0-rc5+ #429
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34 04/01/2014
 Call Trace:
  <IRQ>
  dump_stack_lvl+0x45/0x59
  nbp_vlan_group+0x3e/0x44 [bridge]
  br_multicast_pg_to_port_ctx+0xd6/0x10d [bridge]
  br_multicast_star_g_handle_mode+0xa1/0x2ce [bridge]
  ? netlink_broadcast+0xf/0x11
  ? nlmsg_notify+0x56/0x99
  ? br_mdb_notify+0x224/0x2e9 [bridge]
  ? br_multicast_del_pg+0x1dc/0x26d [bridge]
  br_multicast_del_pg+0x1dc/0x26d [bridge]
  br_multicast_port_group_expired+0xaa/0x13d [bridge]
  ? __grp_src_delete_marked.isra.0+0x35/0x35 [bridge]
  ? __grp_src_delete_marked.isra.0+0x35/0x35 [bridge]
  call_timer_fn+0x134/0x2da
  __run_timers+0x169/0x193
  run_timer_softirq+0x19/0x2d
  __do_softirq+0x1bc/0x42a
  __irq_exit_rcu+0x5c/0xb3
  irq_exit_rcu+0xa/0x12
  sysvec_apic_timer_interrupt+0x5e/0x75
  </IRQ>
  asm_sysvec_apic_timer_interrupt+0x12/0x20
 RIP: 0010:default_idle+0xc/0xd
 Code: e8 14 40 71 ff e8 10 b3 ff ff 4c 89 e2 48 89 ef 31 f6 5d 41 5c e9 a9 e8 c2 ff cc cc cc cc 0f 1f 44 00 00 e8 7f 55 65 ff fb f4 <c3> 0f 1f 44 00 00 55 65 48 8b 2c 25 40 6f 01 00 53 f0 80 4d 02 20
 RSP: 0018:ffff88810033bf00 EFLAGS: 00000206
 RAX: ffffffff819cf828 RBX: ffff888100328000 RCX: 0000000000000001
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff819cfa2d
 RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
 R10: ffff8881008302c0 R11: 00000000000006db R12: 0000000000000000
 R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000000
  ? __sched_text_end+0x4/0x4
  ? default_idle_call+0x15/0x7b
  default_idle_call+0x4d/0x7b
  do_idle+0x124/0x2a2
  cpu_startup_entry+0x1d/0x1f
  secondary_startup_64_no_verify+0xb0/0xbb

Fixes: 74edfd483de8 ("net: bridge: multicast: add helper to get port mcast context from port group")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index e411dd814c58..c9f7f56eaf9b 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -221,7 +221,7 @@ br_multicast_pg_to_port_ctx(const struct net_bridge_port_group *pg)
 	 * can safely be used on return
 	 */
 	rcu_read_lock();
-	vlan = br_vlan_find(nbp_vlan_group(pg->key.port), pg->key.addr.vid);
+	vlan = br_vlan_find(nbp_vlan_group_rcu(pg->key.port), pg->key.addr.vid);
 	if (vlan && !br_multicast_port_ctx_vlan_disabled(&vlan->port_mcast_ctx))
 		pmctx = &vlan->port_mcast_ctx;
 	else
@@ -4329,7 +4329,8 @@ static void br_multicast_start_querier(struct net_bridge_mcast *brmctx,
 		if (br_multicast_ctx_is_vlan(brmctx)) {
 			struct net_bridge_vlan *vlan;
 
-			vlan = br_vlan_find(nbp_vlan_group(port), brmctx->vlan->vid);
+			vlan = br_vlan_find(nbp_vlan_group_rcu(port),
+					    brmctx->vlan->vid);
 			if (!vlan ||
 			    br_multicast_port_ctx_state_stopped(&vlan->port_mcast_ctx))
 				continue;
-- 
2.31.1

