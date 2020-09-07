Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341B525F2EB
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 08:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgIGGAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 02:00:25 -0400
Received: from mail-db8eur05on2090.outbound.protection.outlook.com ([40.107.20.90]:6113
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726278AbgIGGAY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 02:00:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDNesRdRKZss+GZhibuCFKKSgj7pXkRO3ug8tUThl1zrVaRj26b5QWkgBo6Y2XqzxrI+0UFFzhcXPJ88JxSP+U3kEjFftm1b4OHE12Hv33KC44ELFoBU74XJHg68d0eyotKPfWzCbXFN/IynSu9KxwkLFLWaQiCFjZmBCxbPWZtlBZV7eoIP6f8z6ayfy6+QtQJWZTOih4J/cca9hFIKBUXTUmiRbVNp14dgJrf8JvapVua1mtWduwUJI3CapWgi83ly1HNOeDBlAuuZn7hstJE59WHNq8HPCAfkGr/ZLGe7rQO/CTl906EEMIWrKhSk+ntfWKMZjhZ46eDjKvJ2QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckaw1E19IymmZupBJVkx/Z1AH1BHQx0iWDydMYlbRyw=;
 b=Z7m8Q5Q+gixB35VfaSKyFmZQMqihZUn8sb7vGupNpN+W4L7GkywuIyaHw7+Wzj1ap1fXPlkSktg6WmSKfXblYXoulZHF2aVXdeZ3X5uiCyydgcxrLZ6DGNzEKNzzVZeBEGnez1UtzjhP+dMm0DIZe2x/9c9aV8ECJoxtIBKK6UhpSuJng5LQD5+tqG9vX1BCOSSp1vppckpWGv8vR5sM52W6knzPIhaaIn3SNS15LoTbPPOoQs8kKg/8exm6JJLgjrDLvK/gFv0hFLNhP1hruXjKzN/lWda3yU8LExyL0dTI5QvqOC+xULDeorWbiAjKGX8c9M5xThM1niB4tpfj3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckaw1E19IymmZupBJVkx/Z1AH1BHQx0iWDydMYlbRyw=;
 b=XeT6QhFuvr3nIJVkcwhpRPV7TqKSNteT9UuP/gTeVzjUMzqMGzao5hrDg1m/FqhZ5ewueBkz3TrN8zJQyPjw+U880vEvDGvcJ0FYRdViymzIaucUvBDq9H7FJT2iWGHb5oNDdlmLjs2NIXKX4B0C8uurvrllhS5Ezko0RkcqQAs=
Authentication-Results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none
 header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR05MB6717.eurprd05.prod.outlook.com (2603:10a6:800:141::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.19; Mon, 7 Sep
 2020 06:00:20 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::20b1:691e:b3c7:2f58]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::20b1:691e:b3c7:2f58%7]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 06:00:20 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     jmaloy@redhat.com, maloy@donjonn.com,
        syzbot+d5aa7e0385f6a5d0f4fd@syzkaller.appspotmail.com
Subject: [net-next v2] tipc: fix a deadlock when flushing scheduled work
Date:   Mon,  7 Sep 2020 13:00:07 +0700
Message-Id: <20200907060007.43750-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0401CA0022.apcprd04.prod.outlook.com
 (2603:1096:3:1::32) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (123.20.195.8) by SG2PR0401CA0022.apcprd04.prod.outlook.com (2603:1096:3:1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 06:00:18 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [123.20.195.8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b34bf86d-a891-4f29-a323-08d852f34d35
X-MS-TrafficTypeDiagnostic: VI1PR05MB6717:
X-Microsoft-Antispam-PRVS: <VI1PR05MB671728DC5799234B2357C49FF1280@VI1PR05MB6717.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EpsZkNYHXSEjJUpe8ePxzeCvqOxxwjg49q0K9SuQ1+YQK42bciwaIABJxHMjz9+d+gKiIYme3P/+TenEmXX+uAvDXvLNNS6Gu7qdpXtoK0aWCGEp2Jswc/T+t25ZAfPdSuzyhL7q6k2LTdUJ6he5aHUHpkoXD/7mpXhDAu0wjgtOyheRNmYvBfCEVOqiiQoiRAOtEueHWIvbDMNrmquUTTpH8DtKEMXJznhoph0395ZNePObZi9X6RoxPIBPwxqoTSAGsaKhjZyKnDKhlxDekXZJcQqyTS8jKo8+Zw30Vl/U7+r18yBtYr7W1tlTtLKIuakFZa9ER18kxQ9ngk05XQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39840400004)(396003)(376002)(136003)(346002)(8676002)(4326008)(36756003)(478600001)(26005)(316002)(16526019)(186003)(2906002)(956004)(52116002)(7696005)(2616005)(55236004)(8936002)(86362001)(55016002)(103116003)(83380400001)(1076003)(5660300002)(66556008)(66476007)(66946007)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: K6hWQEUlDFiSPifPOIj+Y1U9ZJw4I7N90IKIL1ZnfFUwqXstOJTuU1cMWlFwu8Nwmg+reQBYyQwkVE6k7WGFMeROsWyLgQpXh1pxYWiMNZPSZNg0G029U+3x5aR3oJ/UL3Y/UxDckTeQXtAbEnoaeYLFaG88yb7CkJpDO1ux4MrP2yrzPDlX/4znjfwi+4CkOdVoiOw44F9nqubl3imxEECDJdtHVC3CInn0YkyypHs3vqbm1Hnjcbg55B5o1EicAIUGXhLlMvZRQdp0ktPqhNnbHwOTkGBUaZsdONf1fx4ZGNckIPqke6IMTsIuPmVcohiJjtqXGcAbEgRSiZZ8/hCgAAXAIF4Q/Y9MkWQ3j4a0acumYGQU7HfcklMXGNJzIbV+NNEjq1vdof+5d0Plq/267wcwlw8zBj50R6Wu956JjH7T7DHyAW6F+dgsLT5OUnJIexxd7AgY5h7TNi8A6doyrNLBIVnn/1k2rPIhzxxwH0ZKon+4SVqmAh+f6CuGduOeF9DMP4hsUWbtQcxoZssllLtc3fcXfCtH6kDX5MeFMMVtAXMpRkTA5E7Ro6p4XNNOZgL7J8rzfiOf0JziWzZnvawWK4SmhFoOXRoHMzYMhXoHRL/swJxWCNMBzy7vC9QXZ6tyQrffMhaEBqXiuA==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: b34bf86d-a891-4f29-a323-08d852f34d35
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 06:00:20.3224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uw2dWxWRwEsHqOqa+3pVCPI2Zza6SGm2eARvNhFZn8kqz/fIugg1iXEqTiLvyfD2M5Q6IWCg9pCnbrVXSm3df7J6LQY1urW2ylHj9G2MHss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6717
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the commit fdeba99b1e58
("tipc: fix use-after-free in tipc_bcast_get_mode"), we're trying
to make sure the tipc_net_finalize_work work item finished if it
enqueued. But calling flush_scheduled_work() is not just affecting
above work item but either any scheduled work. This has turned out
to be overkill and caused to deadlock as syzbot reported:

======================================================
WARNING: possible circular locking dependency detected
5.9.0-rc2-next-20200828-syzkaller #0 Not tainted
------------------------------------------------------
kworker/u4:6/349 is trying to acquire lock:
ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: flush_workqueue+0xe1/0x13e0 kernel/workqueue.c:2777

but task is already holding lock:
ffffffff8a879430 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xb10 net/core/net_namespace.c:565

[...]
 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(pernet_ops_rwsem);
                               lock(&sb->s_type->i_mutex_key#13);
                               lock(pernet_ops_rwsem);
  lock((wq_completion)events);

 *** DEADLOCK ***
[...]

v1:
To fix the original issue, we replace above calling by introducing
a bit flag. When a namespace cleaned-up, bit flag is set to zero and:
- tipc_net_finalize functionial just does return immediately.
- tipc_net_finalize_work does not enqueue into the scheduled work queue.

v2:
Use cancel_work_sync() helper to make sure ONLY the
tipc_net_finalize_work() stopped before releasing bcbase object.

Reported-by: syzbot+d5aa7e0385f6a5d0f4fd@syzkaller.appspotmail.com
Fixes: fdeba99b1e58 ("tipc: fix use-after-free in tipc_bcast_get_mode")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
---
 net/tipc/core.c |  9 +++++----
 net/tipc/core.h |  8 ++++++++
 net/tipc/net.c  | 20 +++++---------------
 net/tipc/net.h  |  1 +
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/net/tipc/core.c b/net/tipc/core.c
index 37d8695548cf..c2ff42900b53 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -60,6 +60,7 @@ static int __net_init tipc_init_net(struct net *net)
 	tn->trial_addr = 0;
 	tn->addr_trial_end = 0;
 	tn->capabilities = TIPC_NODE_CAPABILITIES;
+	INIT_WORK(&tn->final_work.work, tipc_net_finalize_work);
 	memset(tn->node_id, 0, sizeof(tn->node_id));
 	memset(tn->node_id_string, 0, sizeof(tn->node_id_string));
 	tn->mon_threshold = TIPC_DEF_MON_THRESHOLD;
@@ -107,13 +108,13 @@ static int __net_init tipc_init_net(struct net *net)
 
 static void __net_exit tipc_exit_net(struct net *net)
 {
+	struct tipc_net *tn = tipc_net(net);
+
 	tipc_detach_loopback(net);
+	/* Make sure the tipc_net_finalize_work() finished */
+	cancel_work_sync(&tn->final_work.work);
 	tipc_net_stop(net);
 
-	/* Make sure the tipc_net_finalize_work stopped
-	 * before releasing the resources.
-	 */
-	flush_scheduled_work();
 	tipc_bcast_stop(net);
 	tipc_nametbl_stop(net);
 	tipc_sk_rht_destroy(net);
diff --git a/net/tipc/core.h b/net/tipc/core.h
index 631d83c9705f..1d57a4d3b05e 100644
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -90,6 +90,12 @@ extern unsigned int tipc_net_id __read_mostly;
 extern int sysctl_tipc_rmem[3] __read_mostly;
 extern int sysctl_tipc_named_timeout __read_mostly;
 
+struct tipc_net_work {
+	struct work_struct work;
+	struct net *net;
+	u32 addr;
+};
+
 struct tipc_net {
 	u8  node_id[NODE_ID_LEN];
 	u32 node_addr;
@@ -143,6 +149,8 @@ struct tipc_net {
 	/* TX crypto handler */
 	struct tipc_crypto *crypto_tx;
 #endif
+	/* Work item for net finalize */
+	struct tipc_net_work final_work;
 };
 
 static inline struct tipc_net *tipc_net(struct net *net)
diff --git a/net/tipc/net.c b/net/tipc/net.c
index 85400e4242de..0bb2323201da 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -105,12 +105,6 @@
  *     - A local spin_lock protecting the queue of subscriber events.
 */
 
-struct tipc_net_work {
-	struct work_struct work;
-	struct net *net;
-	u32 addr;
-};
-
 static void tipc_net_finalize(struct net *net, u32 addr);
 
 int tipc_net_init(struct net *net, u8 *node_id, u32 addr)
@@ -142,25 +136,21 @@ static void tipc_net_finalize(struct net *net, u32 addr)
 			     TIPC_CLUSTER_SCOPE, 0, addr);
 }
 
-static void tipc_net_finalize_work(struct work_struct *work)
+void tipc_net_finalize_work(struct work_struct *work)
 {
 	struct tipc_net_work *fwork;
 
 	fwork = container_of(work, struct tipc_net_work, work);
 	tipc_net_finalize(fwork->net, fwork->addr);
-	kfree(fwork);
 }
 
 void tipc_sched_net_finalize(struct net *net, u32 addr)
 {
-	struct tipc_net_work *fwork = kzalloc(sizeof(*fwork), GFP_ATOMIC);
+	struct tipc_net *tn = tipc_net(net);
 
-	if (!fwork)
-		return;
-	INIT_WORK(&fwork->work, tipc_net_finalize_work);
-	fwork->net = net;
-	fwork->addr = addr;
-	schedule_work(&fwork->work);
+	tn->final_work.net = net;
+	tn->final_work.addr = addr;
+	schedule_work(&tn->final_work.work);
 }
 
 void tipc_net_stop(struct net *net)
diff --git a/net/tipc/net.h b/net/tipc/net.h
index 6740d97c706e..d0c91d2df20a 100644
--- a/net/tipc/net.h
+++ b/net/tipc/net.h
@@ -42,6 +42,7 @@
 extern const struct nla_policy tipc_nl_net_policy[];
 
 int tipc_net_init(struct net *net, u8 *node_id, u32 addr);
+void tipc_net_finalize_work(struct work_struct *work);
 void tipc_sched_net_finalize(struct net *net, u32 addr);
 void tipc_net_stop(struct net *net);
 int tipc_nl_net_dump(struct sk_buff *skb, struct netlink_callback *cb);
-- 
2.25.1

