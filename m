Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C733221F769
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 18:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgGNQfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 12:35:16 -0400
Received: from mail-vi1eur05on2078.outbound.protection.outlook.com ([40.107.21.78]:36320
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726600AbgGNQfQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 12:35:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SjQWuMrwzb9f11tZKacXZv1UrqU+a7OQatb3CDR1z0nVND1pbBbQjb3l3ynyN25PcfKsBfApBaBGp8Wx1lZCxW94Yn6jnNHoclp8/Y1sA2axql8Kniqg8Y8Z5oV28VWK+ef9oawF90c6rRjzh+X4A0TNuLOk8nSFgBOf92y4sdTGuV5ufURMp2P8PPlcP9xz8KmJWO2aRNPLWEIo7V94rc3OcY7HLmpiZ7KlLJ0iYeddYHR1/q5HNdduCjIUkEo97chkvjtogqLHSj33x/fTqrBo7Sza8itqWg9QydzWfs68QxoU0+Pr0nb8pw8dBZBPtJjXCAWIp//umGZZUGjFcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZQ59S09mB7DSIz+E96Vtz2ZzY2bF+LJZUvS5UyDe6E=;
 b=RyeiPhTnYDYibB4sK9hz2NGxEVysePLVcSHQC5NeK2Ubyt7tKnpqPI71nAlcJcsRuQYx6+Gg7SVDLc1s8FYq7FN08WF4/r6EHL8IKOs5l+hS+5gPZ9SJPcxzP+AjCWYjok8linIR3ReNAHqKjcQch0Tix27ruzLiFoKsv97pMzdPX9fY4NqM8O1oTXI0KXZ8wX8oIDaKcSEtOemX+NpB117XCriBjoSVe3/+ZLlTp4NXjr+mNOkXFcd65s0QH2snuW6a4beHDNrNJWnKQB16Pf5Y3A6wg7cg18vhL9FOx2vlbTTICjZhbEeVWI8dB49LjInPYGNSBUtHk+NrUgMu9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZQ59S09mB7DSIz+E96Vtz2ZzY2bF+LJZUvS5UyDe6E=;
 b=QShj23a6wwyN2RNg0iEut3oYRlYChVqtfClhgxb9pfBjBS2QLzmoVQHg7qmfkdtk9bA07PoZ1ySm1S3CEt6f93VFtwS2sn6w44/5UZM+6Pu/vuU/I/cMqYcaY0ITuL+Zfb9Cwabz2rWBF/M936yoHVupJ4KEAiTPFtPcvBcBcGI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB4524.eurprd05.prod.outlook.com (2603:10a6:7:96::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Tue, 14 Jul 2020 16:34:36 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 16:34:36 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH net-next v2 1/2] net: sched: Do not drop root lock in tcf_qevent_handle()
Date:   Tue, 14 Jul 2020 19:34:01 +0300
Message-Id: <e309e07f9626d3c61b6da446a1273f9e7b7a10db.1594743981.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594743981.git.petrm@mellanox.com>
References: <cover.1594743981.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0033.eurprd03.prod.outlook.com
 (2603:10a6:205:2::46) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM4PR0302CA0033.eurprd03.prod.outlook.com (2603:10a6:205:2::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Tue, 14 Jul 2020 16:34:34 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a0c25041-33fe-42e1-c866-08d82813cb76
X-MS-TrafficTypeDiagnostic: HE1PR05MB4524:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB4524D8C400A0B39DCCD2E45EDB610@HE1PR05MB4524.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v7lfhkwL+1iDkuyTvRwbgaE4WmEBVuX6RjFxFOpybqMo0WwObp7uX20gWxpxd25q4RSoI2l2zbK3jUTA9t24Ewda2CVNAJDEJKxH947hwRxshnsVo18Ip/j36CbjEKjuVRLTrvQUglJdbQoBPKk+0t1l9f87OeMPBuO9pAQxJdX3uazbs8ju6lFPzJnw0lomjquUh51oeN/QMkk+UZb+yJAeAgzYsTfIfplX5PkZVGEQrwCrTF+38jLGTc1M8hWBh8zAMxKA8Ixs46vBAbswRPmA3m2rW6OemE8VkRmXo2yCn51i6B6Q2tXlwzJSmlvif8jE+LdRCDAHLFOWJtsguA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(136003)(39850400004)(366004)(186003)(2906002)(66476007)(16526019)(66946007)(66556008)(52116002)(107886003)(83380400001)(6506007)(4326008)(26005)(956004)(5660300002)(6512007)(2616005)(54906003)(6916009)(36756003)(86362001)(8676002)(6486002)(6666004)(8936002)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oCCSCAuXoecCcf8yCpHva2t62kB2JZ2A/NFv0ffKMaQpmdM/13n1bCNM5POPRxPPVYLdCmNk4aFlOUVqI1eomBl1XUanH81mxr441rCe46qh6coktMu0t/Cgx6NoeUquypoJ0pmGqSSZSC55/OgqwkIzhcmTp/ddTNoq61bPL0U39Y3xmC/OEjVYM/2xVB3RYyEOS9kvYoysrNLzINWPoPYvesuyFpXgqA0nhcCBRdtYIbFqMufox3MYAO/gQKvpXEkMk1e2DrzxjYYFSIG4YfrKC56z+uK1SGlJuM5nEARjO52UT0LXbHrgptLLItakR9yAxePNpz5GE6MvTKat6VWaqBIdivHgb24aEyo/1lvcZBp6KJrDbnBI8cRIc8CxmhcZ7Wb/QtMHo3DjkWsevU8e5FGUWL8YpFsig1FJVaqs28pA+fVJQukM46Kk1jCk1N3EmFK06CGBtQ924KLmX0en/jDnTwFe5GsdF6meqRyeO89GdNBtWBlln6RzC636
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c25041-33fe-42e1-c866-08d82813cb76
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 16:34:35.8662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u4dxFUWjbpP+ChSjOHxXjuvBaF5s9BMsSouYrQdm9Cb/D6saB+eVqWq8TMWq6BOnE+34BvIGK5DmbFyUNUg4HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4524
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

