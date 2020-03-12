Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1091B183831
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgCLSGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:06:02 -0400
Received: from mail-vi1eur05on2065.outbound.protection.outlook.com ([40.107.21.65]:6068
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726523AbgCLSGB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 14:06:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYaGnDrzjG9HIEWPPo9ADI+KjOzlLp8DoEaJbv9NtenUfJ1yfdwWgtVTBewqvGi+dsEWJvMiRocsyh+Kp2DpbtEQ9L3xhfZPf8hcQxNMMhj5Aim4ptgKNdZj9V3vYm0lJzMMMbrxfj3jFFgOI2aYD7dbfJtmmcZLEXtjzsaUw70u4amRnRTjQU7yzD+AAAYi3Bv8F7pywKhVwHCovRj0DxGwKj+4PyEw0dapqE0nPQKpKrQITV6IZOtOWBvY7ERNTHGOGsMbpDigpV4+/ZgkO1JYemg66DOMQbx9vV8IwYhERnZDpPS/zqC2DRw9ffBqXxsAUSYj0xmcrUsuPwtpdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDcRWO75pDs/wyknNwWq226Err5a/70+/ARBNHguPsI=;
 b=EnDI8hfmm7mJkSgqcF9zBOouIGNoqYX71mEi1hS3OV8g+uH5PVvTvK9TMoXyp/o17IbI/NmvPWlx6qDkU6oJtK0Dwx642jJTPKpWtqlPSgQ7mdH28S1XEqUtLNCkzWkyJEwJTZtRgzHRrWHac2xZ28UpVtvSpLG2m+D9F3+cU4u08BLOVzKh8z5EbyZA+pn/OKl/5jl9Pil2tG3aVu8Ym+tNmL+1reLAmShKNTkQ8UirH0BOUG0yrEQOKzA9Mn0Oui4iGtmfQ2ucBRjxbNlq95g1HYSiRJMQKPKnt14gMIhGYmNrtKLHUmvqDjDTuKwnLf/WpD2tGwGfT25oeLOzIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDcRWO75pDs/wyknNwWq226Err5a/70+/ARBNHguPsI=;
 b=Ox6fsSOpOGlFh5b0ED+OVgXD/s/ydQ/RMfiKA4n+WmbYxGsPed7Zpm7ETRpcAGenzPGUkXef7QF5+Ul5aIzpyxcyzmsp+t/p3OJ0Kf13xhWWmUdEopcZwemfkW9lf6P//nWvVq+q0voVQk/nPtsGPzI1mpehthYRSJ75gtAPS4Y=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3499.eurprd05.prod.outlook.com (10.170.243.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Thu, 12 Mar 2020 18:05:42 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 18:05:42 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [PATCH net-next v3 3/6] net: sched: RED: Introduce an ECN nodrop mode
Date:   Thu, 12 Mar 2020 20:05:04 +0200
Message-Id: <20200312180507.6763-4-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312180507.6763-1-petrm@mellanox.com>
References: <20200312180507.6763-1-petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P191CA0043.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:55::18) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P191CA0043.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:55::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Thu, 12 Mar 2020 18:05:40 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a4033146-e84e-47d4-a8e9-08d7c6affa7b
X-MS-TrafficTypeDiagnostic: HE1PR05MB3499:|HE1PR05MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3499FDA66C9BF2CD644AE9D4DBFD0@HE1PR05MB3499.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(6486002)(52116002)(81156014)(81166006)(956004)(8936002)(2616005)(86362001)(54906003)(4326008)(6916009)(316002)(107886003)(186003)(26005)(6512007)(6666004)(16526019)(1076003)(2906002)(8676002)(36756003)(478600001)(66946007)(6506007)(66476007)(66556008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3499;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tSo5zt6EHu3Ha2GRm6C/XLoIiBrYa1FTsBxLicPsEBAiA4eWPVZRIIdrnjKgjWoQsbK2kJqu8UGFgtt1LdjrLFJdxwvS+SaeiliJipAEkT1nUr1FW8N5mSa8/y5txQi1BmYQjeCFpyzHjRK+CZZfxy6r2dCHxLoi9V+NnV5CO+h3cXgCKgb05g070OPsemZaSXrmOsZKNnDqLZn30SrXKXFHgKkUSdXHJi3T50Eo0cvSN2U5Q9zF+ruPY1wX7QkxCrrZ8g2L1TIgyItmVSi7BwqbNpXtf3bPgqMt8nMQHW/OqeajQwqrqq/ODaaCoa7HdcUwEZasXSB+SB9ihlnJR/MjJQLz2cbFA1RFPyopNTrmz/hk4QQ/RHjFum6Odcd6e2p4IYp7Bz1SntEMMArxQRYvuYN6JRB1+i03rhncvlraKUGYuzlO6WEIAsQOQlZw
X-MS-Exchange-AntiSpam-MessageData: k8n4ysUdKG/SCyY8SzDt3ckoTbqP91vWa98XPEnf3MFKGDQihe1wo6NGClfXR91mnnvzqZQ8GQwqrgRQnJVUoSPPdyPuPYyv7gnO1O/YFPPGacDeadI/IqZklWBcUHZ4Pk8ydbEJjJweGUEe0lWYHw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4033146-e84e-47d4-a8e9-08d7c6affa7b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 18:05:42.2957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uFE3ZYAUZ0xVhnfQIzeNiPYHc7MmD4hHfAy5yqEfDaXQ0323SkBOykhDSlJ53XHA6wZ0tcKyafheXtl0OSFGgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3499
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the RED Qdisc is currently configured to enable ECN, the RED algorithm
is used to decide whether a certain SKB should be marked. If that SKB is
not ECN-capable, it is early-dropped.

It is also possible to keep all traffic in the queue, and just mark the
ECN-capable subset of it, as appropriate under the RED algorithm. Some
switches support this mode, and some installations make use of it.

To that end, add a new RED flag, TC_RED_NODROP. When the Qdisc is
configured with this flag, non-ECT traffic is enqueued instead of being
early-dropped.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---

Notes:
    v3:
    - Rename "taildrop" to "nodrop"
    - Make red_use_nodrop() static instead of static inline
    
    v2:
    - Fix red_use_taildrop() condition in red_enqueue switch for
      probabilistic case.

 include/net/pkt_cls.h          |  1 +
 include/net/red.h              |  5 +++++
 include/uapi/linux/pkt_sched.h |  1 +
 net/sched/sch_red.c            | 31 +++++++++++++++++++++++++------
 4 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 341a66af8d59..e7e279ad8694 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -727,6 +727,7 @@ struct tc_red_qopt_offload_params {
 	u32 limit;
 	bool is_ecn;
 	bool is_harddrop;
+	bool is_nodrop;
 	struct gnet_stats_queue *qstats;
 };
 
diff --git a/include/net/red.h b/include/net/red.h
index 6a2aaa6c7c41..fc455445f4b2 100644
--- a/include/net/red.h
+++ b/include/net/red.h
@@ -209,6 +209,11 @@ static inline int red_get_flags(unsigned char qopt_flags,
 static inline int red_validate_flags(unsigned char flags,
 				     struct netlink_ext_ack *extack)
 {
+	if ((flags & TC_RED_NODROP) && !(flags & TC_RED_ECN)) {
+		NL_SET_ERR_MSG_MOD(extack, "nodrop mode is only meaningful with ECN");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 6325507935ea..ea39287d59c8 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -286,6 +286,7 @@ struct tc_red_qopt {
 #define TC_RED_ECN		1
 #define TC_RED_HARDDROP		2
 #define TC_RED_ADAPTATIVE	4
+#define TC_RED_NODROP		8
 };
 
 #define TC_RED_HISTORIC_FLAGS (TC_RED_ECN | TC_RED_HARDDROP | TC_RED_ADAPTATIVE)
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 3436d6de7dbe..6506c3526f44 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -48,7 +48,7 @@ struct red_sched_data {
 	struct Qdisc		*qdisc;
 };
 
-static const u32 red_supported_flags = TC_RED_HISTORIC_FLAGS;
+static const u32 red_supported_flags = TC_RED_HISTORIC_FLAGS | TC_RED_NODROP;
 
 static inline int red_use_ecn(struct red_sched_data *q)
 {
@@ -60,6 +60,11 @@ static inline int red_use_harddrop(struct red_sched_data *q)
 	return q->flags & TC_RED_HARDDROP;
 }
 
+static int red_use_nodrop(struct red_sched_data *q)
+{
+	return q->flags & TC_RED_NODROP;
+}
+
 static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		       struct sk_buff **to_free)
 {
@@ -80,23 +85,36 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	case RED_PROB_MARK:
 		qdisc_qstats_overlimit(sch);
-		if (!red_use_ecn(q) || !INET_ECN_set_ce(skb)) {
+		if (!red_use_ecn(q)) {
 			q->stats.prob_drop++;
 			goto congestion_drop;
 		}
 
-		q->stats.prob_mark++;
+		if (INET_ECN_set_ce(skb)) {
+			q->stats.prob_mark++;
+		} else if (!red_use_nodrop(q)) {
+			q->stats.prob_drop++;
+			goto congestion_drop;
+		}
+
+		/* Non-ECT packet in ECN nodrop mode: queue it. */
 		break;
 
 	case RED_HARD_MARK:
 		qdisc_qstats_overlimit(sch);
-		if (red_use_harddrop(q) || !red_use_ecn(q) ||
-		    !INET_ECN_set_ce(skb)) {
+		if (red_use_harddrop(q) || !red_use_ecn(q)) {
 			q->stats.forced_drop++;
 			goto congestion_drop;
 		}
 
-		q->stats.forced_mark++;
+		if (INET_ECN_set_ce(skb)) {
+			q->stats.forced_mark++;
+		} else if (!red_use_nodrop(q)) {
+			q->stats.forced_drop++;
+			goto congestion_drop;
+		}
+
+		/* Non-ECT packet in ECN nodrop mode: queue it. */
 		break;
 	}
 
@@ -171,6 +189,7 @@ static int red_offload(struct Qdisc *sch, bool enable)
 		opt.set.limit = q->limit;
 		opt.set.is_ecn = red_use_ecn(q);
 		opt.set.is_harddrop = red_use_harddrop(q);
+		opt.set.is_nodrop = red_use_nodrop(q);
 		opt.set.qstats = &sch->qstats;
 	} else {
 		opt.command = TC_RED_DESTROY;
-- 
2.20.1

