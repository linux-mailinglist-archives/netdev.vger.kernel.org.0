Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A50C2E497E
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 13:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439705AbfJYLMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 07:12:32 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:33392 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439120AbfJYLMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 07:12:32 -0400
Received: from penelope.horms.nl (ip4dab7138.direct-adsl.nl [77.171.113.56])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 175B625BDD7;
        Fri, 25 Oct 2019 22:12:25 +1100 (AEDT)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id 77019376E; Fri, 25 Oct 2019 13:12:20 +0200 (CEST)
From:   Simon Horman <horms@verge.net.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>,
        Julian Anastasov <ja@ssi.bg>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH 2/2] ipvs: move old_secure_tcp into struct netns_ipvs
Date:   Fri, 25 Oct 2019 13:12:05 +0200
Message-Id: <20191025111205.30555-3-horms@verge.net.au>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025111205.30555-1-horms@verge.net.au>
References: <20191025111205.30555-1-horms@verge.net.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot reported the following issue :

BUG: KCSAN: data-race in update_defense_level / update_defense_level

read to 0xffffffff861a6260 of 4 bytes by task 3006 on cpu 1:
 update_defense_level+0x621/0xb30 net/netfilter/ipvs/ip_vs_ctl.c:177
 defense_work_handler+0x3d/0xd0 net/netfilter/ipvs/ip_vs_ctl.c:225
 process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
 worker_thread+0xa0/0x800 kernel/workqueue.c:2415
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

write to 0xffffffff861a6260 of 4 bytes by task 7333 on cpu 0:
 update_defense_level+0xa62/0xb30 net/netfilter/ipvs/ip_vs_ctl.c:205
 defense_work_handler+0x3d/0xd0 net/netfilter/ipvs/ip_vs_ctl.c:225
 process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
 worker_thread+0xa0/0x800 kernel/workqueue.c:2415
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 7333 Comm: kworker/0:5 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events defense_work_handler

Indeed, old_secure_tcp is currently a static variable, while it
needs to be a per netns variable.

Fixes: a0840e2e165a ("IPVS: netns, ip_vs_ctl local vars moved to ipvs struct.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 include/net/ip_vs.h            |  1 +
 net/netfilter/ipvs/ip_vs_ctl.c | 15 +++++++--------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 3759167f91f5..078887c8c586 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -889,6 +889,7 @@ struct netns_ipvs {
 	struct delayed_work	defense_work;   /* Work handler */
 	int			drop_rate;
 	int			drop_counter;
+	int			old_secure_tcp;
 	atomic_t		dropentry;
 	/* locks in ctl.c */
 	spinlock_t		dropentry_lock;  /* drop entry handling */
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index c8f81dd15c83..3cccc88ef817 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -93,7 +93,6 @@ static bool __ip_vs_addr_is_local_v6(struct net *net,
 static void update_defense_level(struct netns_ipvs *ipvs)
 {
 	struct sysinfo i;
-	static int old_secure_tcp = 0;
 	int availmem;
 	int nomem;
 	int to_change = -1;
@@ -174,35 +173,35 @@ static void update_defense_level(struct netns_ipvs *ipvs)
 	spin_lock(&ipvs->securetcp_lock);
 	switch (ipvs->sysctl_secure_tcp) {
 	case 0:
-		if (old_secure_tcp >= 2)
+		if (ipvs->old_secure_tcp >= 2)
 			to_change = 0;
 		break;
 	case 1:
 		if (nomem) {
-			if (old_secure_tcp < 2)
+			if (ipvs->old_secure_tcp < 2)
 				to_change = 1;
 			ipvs->sysctl_secure_tcp = 2;
 		} else {
-			if (old_secure_tcp >= 2)
+			if (ipvs->old_secure_tcp >= 2)
 				to_change = 0;
 		}
 		break;
 	case 2:
 		if (nomem) {
-			if (old_secure_tcp < 2)
+			if (ipvs->old_secure_tcp < 2)
 				to_change = 1;
 		} else {
-			if (old_secure_tcp >= 2)
+			if (ipvs->old_secure_tcp >= 2)
 				to_change = 0;
 			ipvs->sysctl_secure_tcp = 1;
 		}
 		break;
 	case 3:
-		if (old_secure_tcp < 2)
+		if (ipvs->old_secure_tcp < 2)
 			to_change = 1;
 		break;
 	}
-	old_secure_tcp = ipvs->sysctl_secure_tcp;
+	ipvs->old_secure_tcp = ipvs->sysctl_secure_tcp;
 	if (to_change >= 0)
 		ip_vs_protocol_timeout_change(ipvs,
 					      ipvs->sysctl_secure_tcp > 1);
-- 
2.20.1

