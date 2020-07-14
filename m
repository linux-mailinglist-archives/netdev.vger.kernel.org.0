Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB03B21F2AB
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgGNNdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:33:49 -0400
Received: from mail-eopbgr00072.outbound.protection.outlook.com ([40.107.0.72]:16981
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728049AbgGNNds (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 09:33:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eI/AYuhCW5Kg3I6RjSoXOBtr3+vpd5VNxmPYhshrSZ5due8xm0IVj8+boxQNW1ZOpEPWKpHCMmfpEZgJ8g2pBxzQrtSHlteDwH4siB1pYlUfoWdDveYGovcMLolYrdv1hDe4Q2rdN1t3L6Vty98emPWtdKKvhKoAj2EoMJf+nd7uRV1heTtcnEmqDC+a9Ao34WTmDlhxSWipIvVOvKZyxeNFmKCN+uufcif2zQ0vDVKhHejKKY5ztkk1C+599+s5qKfB4cAuPBQ0bq2AV1nUpEd2Bhco+qgdapbw6qh0vtdAun+HlKis8V80BEoB0s3WjkAObVK87upRxgtiWaI6YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZQ59S09mB7DSIz+E96Vtz2ZzY2bF+LJZUvS5UyDe6E=;
 b=CMl03QpRAXc5rsU+DbGhSBB7iNRvm486dGTGdvzunO0gD0T8rsKj0AxRumymX7JZxVbOgk+AQWbDEWEULjF/ZGnBU5ALva9CrefU3jYbHZUn7Ebi4LbIspEYkeRZYac45gOqEvE0sKXULZ2a1F/xqWgxUPVUhm/S/HOC/Xaxmy6bA0m2H0qitYHV9QDgH4QHySxFT5rRD7Bt+DVHarrLp9utdsUuMi30frRJIFy8Fx9x1FX8o4IysfW6f/ZMOZ2eY0JiCy3NsnIehh/P+yqP7P1ZtSGo7XBGTITK+a4wcfe/yKB2dbMP/R4sVTjONzRbY7pnaYQ5dP/tvxRHvzWJcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZQ59S09mB7DSIz+E96Vtz2ZzY2bF+LJZUvS5UyDe6E=;
 b=UbRzg7Luo2EcrMa1XF82EZUjiYL6Y5HQJR56RrNalXkl+tdGbo98UMzWS+p+UfyR7pykxyE5GPRyzJgjuhBHe2ZfrT9X3vd4455i5oSz9xSP/r//er2q03r1d/+I2iZ5QhEn0Obg3FMdMePuIoRRAjlHcL6HlmBJUUaaxr/bFTQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB4651.eurprd05.prod.outlook.com (2603:10a6:7:a2::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.22; Tue, 14 Jul 2020 13:33:44 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 13:33:44 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH net-next 1/2] net: sched: Do not drop root lock in tcf_qevent_handle()
Date:   Tue, 14 Jul 2020 16:32:54 +0300
Message-Id: <e309e07f9626d3c61b6da446a1273f9e7b7a10db.1594732978.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594732978.git.petrm@mellanox.com>
References: <cover.1594732978.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0020.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::30) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM4PR0902CA0020.eurprd09.prod.outlook.com (2603:10a6:200:9b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Tue, 14 Jul 2020 13:33:42 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ad2c5fcc-e010-48a8-cd2b-08d827fa8736
X-MS-TrafficTypeDiagnostic: HE1PR05MB4651:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB465104F9C37F2930D15F9EEBDB610@HE1PR05MB4651.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XhYWxHtAsFG0OUYE0RgcSVs5VlGpX4vLHbzkmO7RBC5ByusBZ/IySGDWU7Zv1/DJbci9O7I5+fG1v5/ByEa2h1YSpSWge50rqpwalI5M2+FXZB5KVAFX5CKq/lcXRBcPkbC7gHxHalQFDhZ47arqCHgSWo+9MZ0FpXqrawRpCCaIAdMQSon5xbMj7iduFMQQTL+aHk5xP18cGE5earofeYxnaRoXbM/A7wkDl87O5nLQtze2kqu0ewca0z3/TUrRRnpeTW0FA+r43DUuueCKcVZd6faiwUkvQmg3DUP8xvRkpt2I81UeUk6miCsJW0SRj+iiehyPQJ6ohz1ZlrCD5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39850400004)(396003)(346002)(376002)(136003)(5660300002)(6666004)(86362001)(4326008)(8676002)(478600001)(66556008)(66476007)(6916009)(66946007)(6512007)(107886003)(36756003)(8936002)(52116002)(2906002)(6486002)(26005)(54906003)(956004)(83380400001)(186003)(6506007)(316002)(16526019)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Ja2gyKba3gdHumwUnULws0ek+oCeuC3mp1dvzkefNhxNbkU7Z+SdKthp1MvJn4cW2Z5rDI2fghI8rp33in4N/xNKHaGS55FtD8plhd3Dn3IaCwcr4WK6dcR2VWwI4AeVUabf4x2Pa5uZv+9CHPoCACCkfA8if3/1o1gmyEseI8T96AE9jqm4emQvBp0VL4GpyBNSVwWeygrky6zWMJcfEAaEviZtbI1wcspes15/ttI/vHVoGbViLr6Ph08bnMF9no5+nPMUHkh1KToTSa4DL2hr408//NHFezOhvGsUjj2RRfT9plCIOI7RI4eKbnjUBuQFXGEiy7W182FZiHRoF1W1C8LOiAGB/wr+FeR8xB8oQ1DlndIILTnDV9DJSspd4ZbE8iLqAQA9L0IjGX78/1DuUZ+q29MfTW+PVMqW0CQL8qsHcsz5zIKaWvXmjRMkpuhWKO31JanDC/CWMS7Hcfp6E0izG1ykvleZjSvVSos=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad2c5fcc-e010-48a8-cd2b-08d827fa8736
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 13:33:43.9116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 93QqGA1Toby7wYdm2rna7OmdNLCl/DbN01dkEI/Z8RgnmfwqmCUiLmahAg01WRepa58TN3nQfRRk1A+v3Rj/xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4651
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

