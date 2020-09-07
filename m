Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9DA25F315
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 08:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgIGGRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 02:17:44 -0400
Received: from mail-am6eur05on2105.outbound.protection.outlook.com ([40.107.22.105]:42273
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725803AbgIGGRn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 02:17:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lodzrMAbILuZTRexxXqqF2Zh96l5PyJFGLqdhP3UV8rLDt9ONIRjBLJd9fcem/rBu3484PXTfOqujFY9qTQ8L4C/pdas9lfdNTtH0NgHbuNGcM+VoKVCTUWm/3CHtSAcYTyJYMroiMjZHowBoZow2wp1zmyi1EcYWlIXa1DTRm6YYjDWYp1ytjCrhvStpaEM3RG1Y+TGang3gOuR3LXEwYxdE2mNcAW+BUOOHumStMkyJgrzej8FDMPgUqUi5LgXCHx+yAA+t9haRtoshsVEU5jHHdrlZwvDkKCGsPKD6eUF5GqEMQ+u7Ef9godw5Mnqg2EdurkxOy+wkvQPDeGzKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckaw1E19IymmZupBJVkx/Z1AH1BHQx0iWDydMYlbRyw=;
 b=hqn3WZmYtkGD232EMmgUeWVtJSYUWA+lx6XBjg5P2rp1VjPGfjkApy83tDfC2O506JiA/dAb+j+P97E+w+QRn66mdl+g4Ga8cYH6klXvnpZLk84WsEi0LlpjxeUv+j0A989yAyULJriTHvXI9GO3iuh3XFkQb+26J80iBcMgQv0CYYsuJJAJCQEdpvcU8MYryAIMkMMbchBbs1FsROWDRF4eWbbWlCqtPgovMTjm0lI6VgAylwXn5KSBatevC5iLWMxifHkFYY9OX1wEx2JNAGGss1YQ18YOQHgXyUvby7ihBk9vQng5o6YdN3SfDh8VhlkwE84i3asAoKfF7ALxVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckaw1E19IymmZupBJVkx/Z1AH1BHQx0iWDydMYlbRyw=;
 b=k2WR8oY/KCpdDM4TAn1jcgL8cTODzn641YdGzY+Px88U7GKHx+2QeesoE8uxyIEjj7oYZKDlIIA+3pyjk7l3ShmeYt820WXtj+DOly74srWO4ElfAVOq10BlYfQwdRHvQ6vO7ZM3aMmFjIINaeDoJCz0GiEb2R/I1C46IjEkSiM=
Authentication-Results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none
 header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR05MB5182.eurprd05.prod.outlook.com (2603:10a6:803:ad::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 06:17:38 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::20b1:691e:b3c7:2f58]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::20b1:691e:b3c7:2f58%7]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 06:17:38 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     jmaloy@redhat.com, maloy@donjonn.com,
        syzbot+d5aa7e0385f6a5d0f4fd@syzkaller.appspotmail.com
Subject: [net-next v2] tipc: fix a deadlock when flushing scheduled work
Date:   Mon,  7 Sep 2020 13:17:25 +0700
Message-Id: <20200907061725.43879-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200905044518.3282-1-hoang.h.le@dektech.com.au>
References: <20200905044518.3282-1-hoang.h.le@dektech.com.au>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0165.apcprd04.prod.outlook.com (2603:1096:4::27)
 To VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (123.20.195.8) by SG2PR04CA0165.apcprd04.prod.outlook.com (2603:1096:4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Mon, 7 Sep 2020 06:17:36 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [123.20.195.8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c33326e-b837-43c7-4bc4-08d852f5b826
X-MS-TrafficTypeDiagnostic: VI1PR05MB5182:
X-Microsoft-Antispam-PRVS: <VI1PR05MB5182C2742C9B1355E65DD193F1280@VI1PR05MB5182.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1e38oQtpJ0Ry7psPwMKTIpAXKVBHnHUXWaN9v7otplNHZh0djP+1zT+oAZcL9S6OI9i8jGar67PRwgg+/7NNJrj11Jm5+nGZJF0Kp8UnL+SzhOk0TKpMcUwZzfh06m1c86l6jWQdRdPS2bWPuShs1CaaLhjT/krCbKv8S8rmQvHrOlfwWGS8aZXAb+RgWULtgqtzPz0+9BQEMLRRCLsjf8R8N8kMe/kn5vKvr64foTM96Wt12J4X7zbd0sE4NuWwmQ8rp7l5vd/QXT7UO//GMNDV7wTgajl/C1rf0/hAh6wYAgmk0jPSV+9tnTvJn8dqppMERTpQNF/fPvVhMcLMAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(396003)(366004)(39840400004)(86362001)(1076003)(956004)(8676002)(316002)(2616005)(103116003)(55236004)(478600001)(8936002)(6666004)(4326008)(83380400001)(2906002)(52116002)(66946007)(36756003)(55016002)(5660300002)(66476007)(26005)(66556008)(186003)(16526019)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: fLcUgryxZJcN7nXC5po8ooItFxJONNCBRDaFPYFetvJyhtnrfAtiArA+nlO6RIyTCQ1X0eV+L45UImVM6UF9L9CvXN0bqNh5s9XXcO81MejcmM7o1eFS1H3ZjXkrbNe8LnPuNIpnvNiWfebAlm/xio3MAXQYrti19vj/OtGyK8pmPqS0/qy8hwF+2A+qVvlPD2hOxTTlYWfGjFCPH2hZyZAQ/pkeA6GqjsMmETXWwh1JBvm0O7vitDJysTKvUcFcN1Mg62RsggcE7i7o6tdDDQL0IL1WRJyQRNkFWbGdZeecePP3508i0Ea1kSTZN+WJNAwK9PGDe4P1Cngb9DtzzbDskQTQbmhg1Se51u0u8RNIHCpQdxUVZr3w2lkvd6NtUbckXnPorQyqyflNyQ99/oUMdrEJoQ6nBBxpN+MssZ3oMjH9205jFtw5pVTl4tnKB5AkSU+AtxvhV5wM0CRhmFJuuNk0HIr5xD/1BPwy7Sw0K3rFC77l6D5AAGkaIvHV5vMCL/hUZl1Z+tyrWJv/qX/lcUQwWdiEnHLQVTEtiffJ03gEx3CnPz/nhpKbFkJzmExdtawnoS8TJfTONFuxYIGwvK4oZ8eGMiFljiZHVb0MAaQWlI22a7ucsxRJpKkldi85VBWKI/FX1GjOQu46Xg==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c33326e-b837-43c7-4bc4-08d852f5b826
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 06:17:38.6675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Dt+Tq45CBYFJ7oyBnHU4DAgI4v+9Vl3x+gY98yLt0GHktxbsTeqHZ6YZKq79rbOnysjGEeiFhLcnxos8PTk046C6gmcO/jSeIVhHIq3fGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5182
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

