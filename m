Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA225181F90
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 18:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730516AbgCKRef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 13:34:35 -0400
Received: from mail-eopbgr60070.outbound.protection.outlook.com ([40.107.6.70]:25761
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730375AbgCKRee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 13:34:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPiZUCn+yiHgICUsG8ItXz9WqqEbQ0OkUrPXX/s3hQhRETU7qtsCJsm9EayjHo56ar4MBr2yR0OP3hBO2vVEjYoae8wks9FKj27TVSqoMgpuSN2b70zSleiVxebjEjYB8yIRSZK76xievrxx5TjqSgN/Nvd0cixqOPQrUSEOkTDxnZHy1mpyjkHJOsbKlOSIDkNtbw7EdyzC1XhZ8Cf/BklaIDz5539UriKry7mNN/Q9blAZdDWQ+9F7YvY53AZCFXQYbBrv4HtK3R1Ho9Tl29+wiGidaOBtCKdrI95wpD5P1K9DAGFxnMeg6edlTzDV1NQ6sfEQX1Sm5gsfldK3Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bAEr2vtim63JHx1KFGVbpFqG8qCXsAc/+DgnJ7pdCyw=;
 b=OCWDtqHMSYqm6pqF5DilCEQN7W67h7ZY9PMbezC+vUsjOu1zGcE2sdapWFCXTgERr6Rm1rimaZoaz2xuMypjwhHbhlTj0pHwvCjsyxWOaFg+P9LMXk6ttpSnq2dDjUlvauXgQPGSKuB98AYTpffNugUZuk4TJw/h6ruQ7jUv2fR50UDn+zJRnbLeZ6IsR1jbTTM+xwlQQ3Eh4h5Pl6UOwALhZmcfS/rV6KPCUaK6rNtzxH14E2bcudIHMmauCO181Z6MMosClDtA9xMdEk4FuuKwNWuUwDDuCfndGxaA+1bUi8pFUSlUBPGOZerGuWj8YxMIBf9RW6KKy682VvGIBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bAEr2vtim63JHx1KFGVbpFqG8qCXsAc/+DgnJ7pdCyw=;
 b=gNorI+8qmz6uCpXlyT//t+YRaLge6h93zm6OhBlbReXuYBo/m7tvqgSEEhfKq0ASPcOQexLMXlNALywk6FZUiEDlkJbE4xWfqPOCi79vAEaVd+pKOTceVVBMnnc8yccfUYCh89iukGo8MmGlgkOem5++K8YRCYCSemuJL7KirEc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3449.eurprd05.prod.outlook.com (10.170.248.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Wed, 11 Mar 2020 17:34:30 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Wed, 11 Mar 2020
 17:34:30 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com
Subject: [PATCH net-next v2 2/6] net: sched: Allow extending set of supported RED flags
Date:   Wed, 11 Mar 2020 19:33:52 +0200
Message-Id: <20200311173356.38181-3-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200311173356.38181-1-petrm@mellanox.com>
References: <20200311173356.38181-1-petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::17) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Wed, 11 Mar 2020 17:34:28 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ec93eb9a-f304-49e7-69a2-08d7c5e2743f
X-MS-TrafficTypeDiagnostic: HE1PR05MB3449:|HE1PR05MB3449:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB34499B7F0F14CE335D795236DBFC0@HE1PR05MB3449.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(199004)(6506007)(186003)(107886003)(6666004)(81156014)(4326008)(81166006)(26005)(16526019)(8936002)(8676002)(2616005)(2906002)(86362001)(956004)(36756003)(6512007)(66476007)(66556008)(6486002)(6916009)(316002)(478600001)(1076003)(54906003)(52116002)(5660300002)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3449;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MIAxdBulW/XxPIaMhCVz9E8bU8z7EJSP3WPE+htJzuGhdIR4kH6n6YOrFwLoipoS80ZUcR+pGrQi13BP8OUOy/DbB912/a5onH51rMSb2niabghKskCstLS4JNb7a46zKe0Xx7hOUlMWsaSFrocAFadtt9ItrKv60m26pjpwS1O7nfAkyr7FH+Co7BoI3gIwA3JmwBh1TTso2HLrrPNdJnVzTFJLBq9M8mCMN9KzHJmK1twBFh791I0S8fNXDhrY5wQCIne/rVqrGp/PW4o5jT9sL15hOATdjK2mPHLDVzv1z7BGfLqCurPJ/da+30W+ySkbCPI6EyLgFQvUMK6osoHBPXQRItWIIU3tz/Ss5FhYWyi1FGI41fIHDc+nzD417IQydXpdusFEOFsIeB5ZCBvt80JoKYVD8s+14So/4lUgVPck2DPLEh8lxoDaqpuE
X-MS-Exchange-AntiSpam-MessageData: Ess6EEtgyJkMCy49YnV9IJRgDQXDYkOzp6O7aDYNi26Gm4jr7WgRoM69/aGEU9/RNXDtiO4m1eNtWi7bGbb4b1oAyIqCwGRdeA4KSEWROU3LUNnlChz73l7KV5950w4cOdqgN1ChzLS1BEPaaY8RTA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec93eb9a-f304-49e7-69a2-08d7c5e2743f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 17:34:30.1787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fPo5R6ncUjIfMTVG5/gVoKY2//BTL0d5qLIx2228AXglRu9CUim0XI++1Ekz2LxK2VHCXXdS4VN/aMLWiSA3Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3449
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The qdiscs RED, GRED, SFQ and CHOKE use different subsets of the same pool
of global RED flags. These are passed in tc_red_qopt.flags. However none of
these qdiscs validate the flag field, and just copy it over wholesale to
internal structures, and later dump it back. (An exception is GRED, which
does validate for VQs -- however not for the main setup.)

A broken userspace can therefore configure a qdisc with arbitrary
unsupported flags, and later expect to see the flags on qdisc dump. The
current ABI therefore allows storage of several bits of custom data to
qdisc instances of the types mentioned above. How many bits, depends on
which flags are meaningful for the qdisc in question. E.g. SFQ recognizes
flags ECN and HARDDROP, and the rest is not interpreted.

If SFQ ever needs to support ADAPTATIVE, it needs another way of doing it,
and at the same time it needs to retain the possibility to store 6 bits of
uninterpreted data. Likewise RED, which adds a new flag later in this
patchset.

To that end, this patch adds a new function, red_get_flags(), to split the
passed flags of RED-like qdiscs to flags and user bits, and to validate the
flags that are passed in. It further adds a new attribute, TCA_RED_FLAGS,
to pass arbitrary flags.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---

Notes:
    v2:
    - This patch is new.

 include/net/red.h              | 25 +++++++++++++++++++++++++
 include/uapi/linux/pkt_sched.h | 16 ++++++++++++++++
 net/sched/sch_red.c            | 24 +++++++++++++++++++++---
 3 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/include/net/red.h b/include/net/red.h
index 9665582c4687..5718d2b25637 100644
--- a/include/net/red.h
+++ b/include/net/red.h
@@ -179,6 +179,31 @@ static inline bool red_check_params(u32 qth_min, u32 qth_max, u8 Wlog)
 	return true;
 }
 
+static inline bool red_get_flags(unsigned char flags,
+				 unsigned char historic_mask,
+				 struct nlattr *flags_attr,
+				 unsigned int supported_mask,
+				 unsigned int *p_flags, unsigned char *p_userbits,
+				 struct netlink_ext_ack *extack)
+{
+	if (flags && flags_attr) {
+		NL_SET_ERR_MSG_MOD(extack, "flags should be passed either through qopt, or through a dedicated attribute");
+		return false;
+	}
+
+	*p_flags = flags & historic_mask;
+	if (flags_attr)
+		*p_flags |= nla_get_u32(flags_attr);
+
+	if (*p_flags & ~supported_mask) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported RED flags specified");
+		return false;
+	}
+
+	*p_userbits = flags & ~historic_mask;
+	return true;
+}
+
 static inline void red_set_parms(struct red_parms *p,
 				 u32 qth_min, u32 qth_max, u8 Wlog, u8 Plog,
 				 u8 Scell_log, u8 *stab, u32 max_P)
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index bbe791b24168..277df546e1a9 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -256,6 +256,7 @@ enum {
 	TCA_RED_PARMS,
 	TCA_RED_STAB,
 	TCA_RED_MAX_P,
+	TCA_RED_FLAGS,		/* u32 */
 	__TCA_RED_MAX,
 };
 
@@ -268,12 +269,27 @@ struct tc_red_qopt {
 	unsigned char   Wlog;		/* log(W)		*/
 	unsigned char   Plog;		/* log(P_max/(qth_max-qth_min))	*/
 	unsigned char   Scell_log;	/* cell size for idle damping */
+
+	/* This field can be used for flags that a RED-like qdisc has
+	 * historically supported. E.g. when configuring RED, it can be used for
+	 * ECN, HARDDROP and ADAPTATIVE. For SFQ it can be used for ECN,
+	 * HARDDROP. Etc. Because this field has not been validated, and is
+	 * copied back on dump, any bits besides those to which a given qdisc
+	 * has assigned a historical meaning need to be considered for free use
+	 * by userspace tools.
+	 *
+	 * Any further flags need to be passed differently, e.g. through an
+	 * attribute (such as TCA_RED_FLAGS above). Such attribute should allow
+	 * passing both recent and historic flags in one value.
+	 */
 	unsigned char	flags;
 #define TC_RED_ECN		1
 #define TC_RED_HARDDROP		2
 #define TC_RED_ADAPTATIVE	4
 };
 
+#define TC_RED_HISTORIC_FLAGS (TC_RED_ECN | TC_RED_HARDDROP | TC_RED_ADAPTATIVE)
+
 struct tc_red_xstats {
 	__u32           early;          /* Early drops */
 	__u32           pdrop;          /* Drops due to queue limits */
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 1695421333e3..61d7c5a61279 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -35,7 +35,11 @@
 
 struct red_sched_data {
 	u32			limit;		/* HARD maximal queue length */
-	unsigned char		flags;
+
+	u32			flags;
+	/* Non-flags in tc_red_qopt.flags. */
+	unsigned char		userbits;
+
 	struct timer_list	adapt_timer;
 	struct Qdisc		*sch;
 	struct red_parms	parms;
@@ -44,6 +48,8 @@ struct red_sched_data {
 	struct Qdisc		*qdisc;
 };
 
+#define RED_SUPPORTED_FLAGS TC_RED_HISTORIC_FLAGS
+
 static inline int red_use_ecn(struct red_sched_data *q)
 {
 	return q->flags & TC_RED_ECN;
@@ -186,6 +192,7 @@ static const struct nla_policy red_policy[TCA_RED_MAX + 1] = {
 	[TCA_RED_PARMS]	= { .len = sizeof(struct tc_red_qopt) },
 	[TCA_RED_STAB]	= { .len = RED_STAB_SIZE },
 	[TCA_RED_MAX_P] = { .type = NLA_U32 },
+	[TCA_RED_FLAGS] = { .type = NLA_U32 },
 };
 
 static int red_change(struct Qdisc *sch, struct nlattr *opt,
@@ -195,6 +202,8 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 	struct red_sched_data *q = qdisc_priv(sch);
 	struct nlattr *tb[TCA_RED_MAX + 1];
 	struct tc_red_qopt *ctl;
+	unsigned char userbits;
+	u32 flags;
 	int err;
 	u32 max_P;
 
@@ -216,6 +225,11 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog))
 		return -EINVAL;
 
+	if (!red_get_flags(ctl->flags, TC_RED_HISTORIC_FLAGS,
+			   tb[TCA_RED_FLAGS], RED_SUPPORTED_FLAGS,
+			   &flags, &userbits, extack))
+		return -EINVAL;
+
 	if (ctl->limit > 0) {
 		child = fifo_create_dflt(sch, &bfifo_qdisc_ops, ctl->limit,
 					 extack);
@@ -227,7 +241,8 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 	}
 
 	sch_tree_lock(sch);
-	q->flags = ctl->flags;
+	q->flags = flags;
+	q->userbits = userbits;
 	q->limit = ctl->limit;
 	if (child) {
 		qdisc_tree_flush_backlog(q->qdisc);
@@ -302,7 +317,8 @@ static int red_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct nlattr *opts = NULL;
 	struct tc_red_qopt opt = {
 		.limit		= q->limit,
-		.flags		= q->flags,
+		.flags		= ((q->flags & TC_RED_HISTORIC_FLAGS) |
+				   q->userbits),
 		.qth_min	= q->parms.qth_min >> q->parms.Wlog,
 		.qth_max	= q->parms.qth_max >> q->parms.Wlog,
 		.Wlog		= q->parms.Wlog,
@@ -321,6 +337,8 @@ static int red_dump(struct Qdisc *sch, struct sk_buff *skb)
 	if (nla_put(skb, TCA_RED_PARMS, sizeof(opt), &opt) ||
 	    nla_put_u32(skb, TCA_RED_MAX_P, q->parms.max_P))
 		goto nla_put_failure;
+	if (q->flags & ~TC_RED_HISTORIC_FLAGS)
+		nla_put_u32(skb, TCA_RED_FLAGS, q->flags);
 	return nla_nest_end(skb, opts);
 
 nla_put_failure:
-- 
2.20.1

