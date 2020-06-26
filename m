Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8796D20BCE6
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgFZWqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:46:39 -0400
Received: from mail-am6eur05on2082.outbound.protection.outlook.com ([40.107.22.82]:6168
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725883AbgFZWqi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 18:46:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4ZYaVUYz5GPVyuzJaZRBYCvLdFqQ4akyiB6kdJIFd+cDwaS7yOUzihnHUbna3nCdMY32ctObZPKiHrboplXO+Vhe0NylE25z9M4SLsV2UlAVWTdmXvG1xLDIN+Y0JOEeLB43CuQzMhhev4VM3ZjFTjsiI5SkHRPix97jxM5EBpMxf3c+qA1T8r5Pn+wzaO0LO4Zu0wRH3hJTKrIr9TlJBoeDRtZr4P5GSXXUJfyYZg+NOhokRDNzVkU6SSHugfcBum8xAuWRTdv236q62xTnMgJWp2GQdo7ItvuWQs8WypKnSOKM2KXXBV5WdNK5oldjj671ndriKISWqwalrsOvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWPHjZBX4cp2qM+Ap/rO/zoGGKKo4YA0Kuuhd0RhnT4=;
 b=f989UGUvLCpqIippeEMrWpWBWpwMv8Fh505QGF1Cda1ElyTlPhdDb8aoloF1osDjfVA3vHgTkHuXT2LBKqyI9ZyKSf9T/ss/aoGGuBtWNnwi7g5W5Ha6vqg8EKR4SfG0SDoyOpzffgRmidnkOMCWWNvrnmR53wmtZX+KtsHE3kl63MKtuZ39hYxpOLMDqKf/H3NvNazYgfTgySIBFSkIjp3YsZt7AjdCD28gXLLVXE1QD16S47HooXEMgIs3z3WW2WVj11hyhmbUk99DY8GVFQcRqtwpBmmMaCxIk34FzAVTqH+AtzLcNNOdU+I0zIIKOztt2YV4c3KgEoz3cMIGlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWPHjZBX4cp2qM+Ap/rO/zoGGKKo4YA0Kuuhd0RhnT4=;
 b=YtPuidwOJCtKLp/evN+5Pa3YSz3p4d0uNyBkk9EwISoVSd/VbVQ6b+tnZnDGT3Qv8KM4e2HK0os6g2UszeHYmTvhEP5siAfHwNNRNIWDu4s5P1p8q+xzwktdNDbUrX5/nZ6wArF83m5fP3kUFnCdq68qXXx5wv6HYjP2PIxrtrI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3196.eurprd05.prod.outlook.com (2603:10a6:7:33::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.21; Fri, 26 Jun 2020 22:46:13 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3131.024; Fri, 26 Jun 2020
 22:46:13 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jiri@mellanox.com,
        idosch@mellanox.com, Petr Machata <petrm@mellanox.com>
Subject: [PATCH net-next v1 3/5] net: sched: sch_red: Split init and change callbacks
Date:   Sat, 27 Jun 2020 01:45:27 +0300
Message-Id: <853342868eb857c1e4af0caebe0aca8ec83cdfd0.1593209494.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1593209494.git.petrm@mellanox.com>
References: <cover.1593209494.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0139.eurprd05.prod.outlook.com
 (2603:10a6:207:3::17) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR05CA0139.eurprd05.prod.outlook.com (2603:10a6:207:3::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Fri, 26 Jun 2020 22:46:12 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 91f37daf-0a90-4012-ca7b-08d81a22ba7f
X-MS-TrafficTypeDiagnostic: HE1PR05MB3196:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3196D943FF63507F424C3379DB930@HE1PR05MB3196.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lhhFXfSCMRHvfc3VYFGvgTXxjikGQVZh23HTKOHC8uPVHFQ+ptgE7SUUk13BW60LKHBQ6vkbf9VdmZ8CyicwvFhyoC49ZwWV8gctdyPCBDU0MRct97JNoguqDTQPIt/n4KVIvEBN5EjCzYNBR/+X4arPJaYB1uOYPq2MzRtDOwNWZerzUzINfeEMMjfKxUMNidH7bmlxWbYcMvRqVrVP0ldRjS44u1tgHvC8cGt9qBHvDbEhp5clERylAnu+f9QQEEShKe9UTjmFGxLK62RVDt8nz0lHRbFA33Iu8gqXgKaOPjZSM3L5entFvAAh4SFUEJ7bD+6RtWTe6BPoqxwBYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(5660300002)(66476007)(8676002)(956004)(54906003)(52116002)(2616005)(6666004)(83380400001)(4326008)(6512007)(2906002)(26005)(8936002)(6916009)(107886003)(66556008)(36756003)(478600001)(86362001)(66946007)(186003)(316002)(6486002)(6506007)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lmpgzZ6Nzdaijbhp1fJ53buLgpml0pI9BVgueHdgRyGqr07wFc/qmcjllRIZGYK5cLI8lphmZp/MXSSJTwUZFq9XTwfLTCCm0xOLzoNdgNOFEGtHm8HMEse57Uxuh9spDwkOlDlScvfhfMtyY8ZCwGiWLzp+E2TnW6n79+stOKaLsyY2uv77UgpX8tT2fVd4fz0azRfi90Xw3C2s0TVkdxPzmmwUyJMpjnIBiwfNMbH8PKTTZw2FvziIRu1VIK28VxLAWmS/brovJdKaPpR0yEuOa+y/kCEhcWlbHTgVlZYtyGJhOxjuqAj1SnZ1BLQXq0i7MsBdaa/Vtm+1SgIXLFpuzog2cIPzO9F2pUQkS8yJnmqrRn01qSpuE1NmaV1XrP9K2dRkfM/pa2N41dP1y0RnCoDVbhKUYwf++NaWKDdj/rtMwRNFZgugiIyKJJ5OnEZa7RqqkDA8ZllJzN9iNb120FuwR+tUN5H+/iQW2VI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91f37daf-0a90-4012-ca7b-08d81a22ba7f
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 22:46:13.7140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rY+zkMmIglbclDFqd7+/jlOTScVojdgf9qNyif+uFpojSwAhifOB1vc6eKQ6AiWnoYkrhdQ7hnyZDt4h00EOkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3196
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the following patches, RED will get two qevents. The implementation will
be clearer if the callback for change is not a pure subset of the callback
for init. Split the two and promote attribute parsing to the callbacks
themselves from the common code, because it will be handy there.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 net/sched/sch_red.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 6ace7d757e8b..225ce370e5a8 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -215,12 +215,11 @@ static const struct nla_policy red_policy[TCA_RED_MAX + 1] = {
 	[TCA_RED_FLAGS] = NLA_POLICY_BITFIELD32(TC_RED_SUPPORTED_FLAGS),
 };
 
-static int red_change(struct Qdisc *sch, struct nlattr *opt,
-		      struct netlink_ext_ack *extack)
+static int __red_change(struct Qdisc *sch, struct nlattr **tb,
+			struct netlink_ext_ack *extack)
 {
 	struct Qdisc *old_child = NULL, *child = NULL;
 	struct red_sched_data *q = qdisc_priv(sch);
-	struct nlattr *tb[TCA_RED_MAX + 1];
 	struct nla_bitfield32 flags_bf;
 	struct tc_red_qopt *ctl;
 	unsigned char userbits;
@@ -228,14 +227,6 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 	int err;
 	u32 max_P;
 
-	if (opt == NULL)
-		return -EINVAL;
-
-	err = nla_parse_nested_deprecated(tb, TCA_RED_MAX, opt, red_policy,
-					  NULL);
-	if (err < 0)
-		return err;
-
 	if (tb[TCA_RED_PARMS] == NULL ||
 	    tb[TCA_RED_STAB] == NULL)
 		return -EINVAL;
@@ -323,11 +314,38 @@ static int red_init(struct Qdisc *sch, struct nlattr *opt,
 		    struct netlink_ext_ack *extack)
 {
 	struct red_sched_data *q = qdisc_priv(sch);
+	struct nlattr *tb[TCA_RED_MAX + 1];
+	int err;
+
+	if (!opt)
+		return -EINVAL;
+
+	err = nla_parse_nested_deprecated(tb, TCA_RED_MAX, opt, red_policy,
+					  extack);
+	if (err < 0)
+		return err;
 
 	q->qdisc = &noop_qdisc;
 	q->sch = sch;
 	timer_setup(&q->adapt_timer, red_adaptative_timer, 0);
-	return red_change(sch, opt, extack);
+	return __red_change(sch, tb, extack);
+}
+
+static int red_change(struct Qdisc *sch, struct nlattr *opt,
+		      struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_RED_MAX + 1];
+	int err;
+
+	if (!opt)
+		return -EINVAL;
+
+	err = nla_parse_nested_deprecated(tb, TCA_RED_MAX, opt, red_policy,
+					  extack);
+	if (err < 0)
+		return err;
+
+	return __red_change(sch, tb, extack);
 }
 
 static int red_dump_offload_stats(struct Qdisc *sch)
-- 
2.20.1

