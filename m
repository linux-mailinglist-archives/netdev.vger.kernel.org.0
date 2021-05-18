Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC6D386FD3
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 04:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346230AbhERCKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 22:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238402AbhERCKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 22:10:34 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B595C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 19:09:17 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so679149pjb.4
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 19:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6zRU0Izr/wIyRkU18rcIMAuVEYv47HMqOTJQW2ThOrY=;
        b=GktWQ3Ym6NTgNSfaIERPXzi53sV5h66MV4A7NQKIk8Bi5b44rf0c5qZtXkYmvQaorw
         fWDVMlZkyNn5UKxUnfOa3A6cDjjXEmPsVCRwr4ajPeNoSw7J1U6qThTwgCaiK75l1TPO
         OjJ1wh5ZAnoap8a1FEiyGcWh03fBUrHAbq0R3lT/HpyaAW0NYR1btGk1PJreqC9SGmk8
         oDnQqVCq7kt30BDShoh7xtMu4e6ve3Cme4/c90QMNFyQTlzQ6IJ4XLH5ZhZOS2Q9AKl7
         9TPOHKkyblRJ21C0BBDs99lTM4zCjRLanGWCjiw4JsfUF8tIFXGeptJpVn14FdqQplGW
         iJFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6zRU0Izr/wIyRkU18rcIMAuVEYv47HMqOTJQW2ThOrY=;
        b=uO/2dEeQC32GloTcrBOdSXzIgtgjvn5FPpUlgsDgYuZfRaVftelOBIMqawBH5kj7EW
         B7KvGellQ4TNT3CSnHcytZXtN5MWiNrbWII+7Gftl2hf0YJzk8EVIAC3B5zAKelSvgIn
         /lQXFTk5TdmF38Sjo9cszk4gjUnZIawL3sOYBDOb7ljJemWHZqlA88+mJzaT8/KhBl9v
         4nR+7k/fATqJO9cNZahtqyXIZ1PsjCs6xdEBcKJqO7CmxBfCZxqOgWK5wfnywWSAnpFD
         lqVc9lgz49qjFdbIejtExcc/cXxdyrzziWoyhpNfOvW4ZSX14RkOYsGISw5Ry69EtRbC
         KcXw==
X-Gm-Message-State: AOAM532XHBqU6jBG/ZfyL38N7W7EEqSsswmzSoBJFHrlN2+fiWGGJnM+
        bowDtbzhGwDv6g+QeX70O3tfQN/hAOvzKQ==
X-Google-Smtp-Source: ABdhPJzSfTJdkt7yluaBypcOXZfphAtlj56bgOIpM51xQ13q0l7CMKMxyE+gR34afIRbgnMlswakyg==
X-Received: by 2002:a17:90a:8809:: with SMTP id s9mr2374926pjn.189.1621303756675;
        Mon, 17 May 2021 19:09:16 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n20sm11801808pjq.45.2021.05.17.19.09.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 May 2021 19:09:16 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, tipc-discussion@lists.sourceforge.net
Cc:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>
Subject: [PATCH net] tipc: simplify the finalize work queue
Date:   Tue, 18 May 2021 10:09:08 +0800
Message-Id: <1a2933d589a238682010510102d74a38b962025a.1621303748.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to use "struct work_struct" for the finalize work queue
instead of "struct tipc_net_work", as it can get the "net" and "addr"
from tipc_net's other members and there is no need to add extra net
and addr in tipc_net by defining "struct tipc_net_work".

Note that it's safe to get net from tn->bcl as bcl is always released
after the finalize work queue is done.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/core.c     |  4 ++--
 net/tipc/core.h     |  8 +-------
 net/tipc/discover.c |  4 ++--
 net/tipc/link.c     |  5 +++++
 net/tipc/link.h     |  1 +
 net/tipc/net.c      | 15 +++------------
 6 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/net/tipc/core.c b/net/tipc/core.c
index 72f3ac7..3f4542e 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -60,7 +60,7 @@ static int __net_init tipc_init_net(struct net *net)
 	tn->trial_addr = 0;
 	tn->addr_trial_end = 0;
 	tn->capabilities = TIPC_NODE_CAPABILITIES;
-	INIT_WORK(&tn->final_work.work, tipc_net_finalize_work);
+	INIT_WORK(&tn->work, tipc_net_finalize_work);
 	memset(tn->node_id, 0, sizeof(tn->node_id));
 	memset(tn->node_id_string, 0, sizeof(tn->node_id_string));
 	tn->mon_threshold = TIPC_DEF_MON_THRESHOLD;
@@ -110,7 +110,7 @@ static void __net_exit tipc_exit_net(struct net *net)
 
 	tipc_detach_loopback(net);
 	/* Make sure the tipc_net_finalize_work() finished */
-	cancel_work_sync(&tn->final_work.work);
+	cancel_work_sync(&tn->work);
 	tipc_net_stop(net);
 
 	tipc_bcast_stop(net);
diff --git a/net/tipc/core.h b/net/tipc/core.h
index 5741ae4..0a3f7a7 100644
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -91,12 +91,6 @@ extern unsigned int tipc_net_id __read_mostly;
 extern int sysctl_tipc_rmem[3] __read_mostly;
 extern int sysctl_tipc_named_timeout __read_mostly;
 
-struct tipc_net_work {
-	struct work_struct work;
-	struct net *net;
-	u32 addr;
-};
-
 struct tipc_net {
 	u8  node_id[NODE_ID_LEN];
 	u32 node_addr;
@@ -148,7 +142,7 @@ struct tipc_net {
 	struct tipc_crypto *crypto_tx;
 #endif
 	/* Work item for net finalize */
-	struct tipc_net_work final_work;
+	struct work_struct work;
 	/* The numbers of work queues in schedule */
 	atomic_t wq_count;
 };
diff --git a/net/tipc/discover.c b/net/tipc/discover.c
index 5380f60..da69e1a 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -168,7 +168,7 @@ static bool tipc_disc_addr_trial_msg(struct tipc_discoverer *d,
 
 	/* Apply trial address if we just left trial period */
 	if (!trial && !self) {
-		tipc_sched_net_finalize(net, tn->trial_addr);
+		schedule_work(&tn->work);
 		msg_set_prevnode(buf_msg(d->skb), tn->trial_addr);
 		msg_set_type(buf_msg(d->skb), DSC_REQ_MSG);
 	}
@@ -308,7 +308,7 @@ static void tipc_disc_timeout(struct timer_list *t)
 	if (!time_before(jiffies, tn->addr_trial_end) && !tipc_own_addr(net)) {
 		mod_timer(&d->timer, jiffies + TIPC_DISC_INIT);
 		spin_unlock_bh(&d->lock);
-		tipc_sched_net_finalize(net, tn->trial_addr);
+		schedule_work(&tn->work);
 		return;
 	}
 
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 1151092..c44b4bf 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -372,6 +372,11 @@ char tipc_link_plane(struct tipc_link *l)
 	return l->net_plane;
 }
 
+struct net *tipc_link_net(struct tipc_link *l)
+{
+	return l->net;
+}
+
 void tipc_link_update_caps(struct tipc_link *l, u16 capabilities)
 {
 	l->peer_caps = capabilities;
diff --git a/net/tipc/link.h b/net/tipc/link.h
index fc07232..a16f401 100644
--- a/net/tipc/link.h
+++ b/net/tipc/link.h
@@ -156,4 +156,5 @@ int tipc_link_bc_sync_rcv(struct tipc_link *l,   struct tipc_msg *hdr,
 int tipc_link_bc_nack_rcv(struct tipc_link *l, struct sk_buff *skb,
 			  struct sk_buff_head *xmitq);
 bool tipc_link_too_silent(struct tipc_link *l);
+struct net *tipc_link_net(struct tipc_link *l);
 #endif
diff --git a/net/tipc/net.c b/net/tipc/net.c
index a130195..0e95572 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -41,6 +41,7 @@
 #include "socket.h"
 #include "node.h"
 #include "bcast.h"
+#include "link.h"
 #include "netlink.h"
 #include "monitor.h"
 
@@ -142,19 +143,9 @@ static void tipc_net_finalize(struct net *net, u32 addr)
 
 void tipc_net_finalize_work(struct work_struct *work)
 {
-	struct tipc_net_work *fwork;
+	struct tipc_net *tn = container_of(work, struct tipc_net, work);
 
-	fwork = container_of(work, struct tipc_net_work, work);
-	tipc_net_finalize(fwork->net, fwork->addr);
-}
-
-void tipc_sched_net_finalize(struct net *net, u32 addr)
-{
-	struct tipc_net *tn = tipc_net(net);
-
-	tn->final_work.net = net;
-	tn->final_work.addr = addr;
-	schedule_work(&tn->final_work.work);
+	tipc_net_finalize(tipc_link_net(tn->bcl), tn->trial_addr);
 }
 
 void tipc_net_stop(struct net *net)
-- 
2.1.0

