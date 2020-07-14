Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DA821F7D2
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 19:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgGNRDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 13:03:33 -0400
Received: from mail-vi1eur05on2085.outbound.protection.outlook.com ([40.107.21.85]:6178
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728724AbgGNRDc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 13:03:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C/mg9WGtMJnhRxuVkuNozjJLtg63SqiohYMB2UqPlXw6LVFp+EzEzlEX9/4VaDJm0CaHhaZCI7zOzSV0GO2O6nnSDlxygb5wGvIcumYN4YU4N4O7YasS7Bcp8cX4/cgw259b9WU0kWonFAK3hS8IXmPE8CBni7bloSM6blQlHQ798hJlD6n9LER2jSqEixFwMdjLESOvvIHXa4BuOoe1SHEt2RqdxT3yWCiwHIhMfOevz+yRWg0smrFcGZ5eT4UU3p+PZFECgwAabdENGtg5I+C3MRCPqWAWilIUs8rILl8LwgFYyZZFHqQLyNHcDBwwpUz5lCzZinr30HKNQjOLzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZQ59S09mB7DSIz+E96Vtz2ZzY2bF+LJZUvS5UyDe6E=;
 b=h0UWrK9nfhzczL8RkY0shz+hn9Tm8rP0k9CThWbyUWWTzDaA1RWqK3i7+TFrRkYLbpH4o3MPbQkOZJodBsfG61QmLhRLzIG29UoUiNwE1GuxdObWXKRBtA52Gu+sC8NKEkR8Jyr9ekIrJnWFfB/CKDUsh38ZoVNUwpeKYlPm67wLIzjzozXwMwyfMVMUtLQ5U/Ns6tct/1eEENUMTp7fZw+vt4LqgEZoTgsl22OFGQcoiD23fn+QucQH5JRwujFDYFqBkchSEYbUWR6lo23GwvtIwKrj9dZM0LHegFhTaIVodvFe3Pq9VcLl2Y+FCfIyT7EA4sUcriEPZCwSpQmPlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZQ59S09mB7DSIz+E96Vtz2ZzY2bF+LJZUvS5UyDe6E=;
 b=pxLa2/HekTBKHEHDbkP4ELl1kseqFP0KeB88dg6TPKFHkid5YaOzLy1y0L7spPs4RSpaAB4W8HVU6ld71XjXJff0Jg2jxVc8vY0+B00Cuv37T2cb6cL7Hij8sKquY/l7SSCywYsYqqUTBr/j49FrrtvJBohAZ9+F/xMyRCBNe2o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0502MB3114.eurprd05.prod.outlook.com (2603:10a6:3:d6::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.22; Tue, 14 Jul 2020 17:03:27 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 17:03:27 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH net-next v3 1/2] net: sched: Do not drop root lock in tcf_qevent_handle()
Date:   Tue, 14 Jul 2020 20:03:07 +0300
Message-Id: <e309e07f9626d3c61b6da446a1273f9e7b7a10db.1594746074.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594746074.git.petrm@mellanox.com>
References: <cover.1594746074.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0028.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::15) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by FR2P281CA0028.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9 via Frontend Transport; Tue, 14 Jul 2020 17:03:26 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 87322d5c-8ba2-4dd8-dd1e-08d82817d3aa
X-MS-TrafficTypeDiagnostic: HE1PR0502MB3114:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0502MB311449B9FDD526334A536D26DB610@HE1PR0502MB3114.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TX8pGMHGqLxHqldQ6BxvxZYTMqhLwpSYDrdlWeL5HXtD2jQGLVwowYenmMeOgxETOt5ug30W4Xn7WcuaMPmEgru+mcpdg+/pRrFsbOyjYC6X0sCs4AYtcmB3GcAmAxsedUz/JbHEzAbdtQBh2w6rIcMhAuSmQq/4bNco3GlS+RZfKM6P6HxjnzXvIumGcFCXCzy6xNGWcd1SWgZFzNHJrErkqFCFbp5nFFuoJEb71zgRCErTCV3Cxt/wVQ975Fncma50dPCfoeyuu3HW8mqDB0S07JchwUR52lAZbOlVlHnr8PpYoJYTF/H3h+JLpU92FroV1L9Umegm73PyDnh+rQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(346002)(376002)(39850400004)(396003)(66476007)(66946007)(26005)(6666004)(2906002)(316002)(66556008)(52116002)(6486002)(6506007)(83380400001)(186003)(36756003)(16526019)(4326008)(107886003)(6512007)(5660300002)(8936002)(6916009)(54906003)(478600001)(8676002)(2616005)(956004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RVirYVObjq1Va/RY75Z1hKNZT3v76qh0XHBWbe8tqfW5yiznNj/CsFO7zXfgmnk156j2URgCpsfWgZurcVyD40MqqpmBtIjOO8GAJ67xvbaC76TbRdOpgoNzcJDVle8HUhKktRdiwEi0ASb7ITCNd6/VllT7SyUF65XZpVdIFNn9/gFOADAQp+2XfIHAV64wkd21XCOTzunO43j9KYCKJnfvVS7AcXk6W1uR4Eoy3P3rSe9nPsMlx4kS8XG/oosyAGgl2qalb4q3oop717900I6l5EC63rZ1SQCslEaxyva4Z8d8MgZpmsrpljmKXsbckU9031C1FKej0ViAhylB8xeYt/7cIGMK84tLWm2ArS2kT9A77+ci0GmGyUOOJXRHbPHQiheUWdEaZOynp+dfwSxHmCcTJcjUia7L7l9VfGdTdUBJxHrKnKWm3JFPzja4wiJXQ1M5N3vtg0NULYhV2tFPalp1yKI6V8WmhodDyRgh8m9h9cspAsyDCLj3rR3w
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87322d5c-8ba2-4dd8-dd1e-08d82817d3aa
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 17:03:27.6262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hUF/CLZcUZvNgsFhEglp3UakoEkLwV8Bc4nxsKXsFvgXd5tkoKLZaBYz1zWMpx/Iz6w5GcAiqsbH1A0N1i8VQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB3114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mirred currently does not mix well with blocks executed after the qdisc
root lock is taken. This includes classification blocks (such as in PRIO,
ETS, DRR qdiscs) and qevents. The locking caused by the packet mirrored by
mirred can cause deadlocks: either when the thread of execution attempts to
take the lock a second time, or when two threads end up waiting on each
other's locks.

The qevent patchset attempted to not introduce further badness of this
sort, and dropped the lock before executing the qevent block. However this
lead to too little locking and races between qdisc configuration and packet
enqueue in the RED qdisc.

Before the deadlock issues are solved in a way that can be applied across
many qdiscs reasonably easily, do for qevents what is done for the
classification blocks and just keep holding the root lock.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 include/net/pkt_cls.h | 4 ++--
 net/sched/cls_api.c   | 8 +-------
 net/sched/sch_red.c   | 6 +++---
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 690a7f49c8f9..d4d461236351 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -568,7 +568,7 @@ void tcf_qevent_destroy(struct tcf_qevent *qe, struct Qdisc *sch);
 int tcf_qevent_validate_change(struct tcf_qevent *qe, struct nlattr *block_index_attr,
 			       struct netlink_ext_ack *extack);
 struct sk_buff *tcf_qevent_handle(struct tcf_qevent *qe, struct Qdisc *sch, struct sk_buff *skb,
-				  spinlock_t *root_lock, struct sk_buff **to_free, int *ret);
+				  struct sk_buff **to_free, int *ret);
 int tcf_qevent_dump(struct sk_buff *skb, int attr_name, struct tcf_qevent *qe);
 #else
 static inline int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
@@ -591,7 +591,7 @@ static inline int tcf_qevent_validate_change(struct tcf_qevent *qe, struct nlatt
 
 static inline struct sk_buff *
 tcf_qevent_handle(struct tcf_qevent *qe, struct Qdisc *sch, struct sk_buff *skb,
-		  spinlock_t *root_lock, struct sk_buff **to_free, int *ret)
+		  struct sk_buff **to_free, int *ret)
 {
 	return skb;
 }
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 322b279154de..b2b7440c2ae7 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3822,7 +3822,7 @@ int tcf_qevent_validate_change(struct tcf_qevent *qe, struct nlattr *block_index
 EXPORT_SYMBOL(tcf_qevent_validate_change);
 
 struct sk_buff *tcf_qevent_handle(struct tcf_qevent *qe, struct Qdisc *sch, struct sk_buff *skb,
-				  spinlock_t *root_lock, struct sk_buff **to_free, int *ret)
+				  struct sk_buff **to_free, int *ret)
 {
 	struct tcf_result cl_res;
 	struct tcf_proto *fl;
@@ -3832,9 +3832,6 @@ struct sk_buff *tcf_qevent_handle(struct tcf_qevent *qe, struct Qdisc *sch, stru
 
 	fl = rcu_dereference_bh(qe->filter_chain);
 
-	if (root_lock)
-		spin_unlock(root_lock);
-
 	switch (tcf_classify(skb, fl, &cl_res, false)) {
 	case TC_ACT_SHOT:
 		qdisc_qstats_drop(sch);
@@ -3853,9 +3850,6 @@ struct sk_buff *tcf_qevent_handle(struct tcf_qevent *qe, struct Qdisc *sch, stru
 		return NULL;
 	}
 
-	if (root_lock)
-		spin_lock(root_lock);
-
 	return skb;
 }
 EXPORT_SYMBOL(tcf_qevent_handle);
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index de2be4d04ed6..a79602f7fab8 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -94,7 +94,7 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_
 
 		if (INET_ECN_set_ce(skb)) {
 			q->stats.prob_mark++;
-			skb = tcf_qevent_handle(&q->qe_mark, sch, skb, root_lock, to_free, &ret);
+			skb = tcf_qevent_handle(&q->qe_mark, sch, skb, to_free, &ret);
 			if (!skb)
 				return NET_XMIT_CN | ret;
 		} else if (!red_use_nodrop(q)) {
@@ -114,7 +114,7 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_
 
 		if (INET_ECN_set_ce(skb)) {
 			q->stats.forced_mark++;
-			skb = tcf_qevent_handle(&q->qe_mark, sch, skb, root_lock, to_free, &ret);
+			skb = tcf_qevent_handle(&q->qe_mark, sch, skb, to_free, &ret);
 			if (!skb)
 				return NET_XMIT_CN | ret;
 		} else if (!red_use_nodrop(q)) {
@@ -137,7 +137,7 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch, spinlock_t *root_
 	return ret;
 
 congestion_drop:
-	skb = tcf_qevent_handle(&q->qe_early_drop, sch, skb, root_lock, to_free, &ret);
+	skb = tcf_qevent_handle(&q->qe_early_drop, sch, skb, to_free, &ret);
 	if (!skb)
 		return NET_XMIT_CN | ret;
 
-- 
2.20.1

