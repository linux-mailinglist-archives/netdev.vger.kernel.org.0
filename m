Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6AB183830
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgCLSF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:05:59 -0400
Received: from mail-vi1eur05on2065.outbound.protection.outlook.com ([40.107.21.65]:6068
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726420AbgCLSF7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 14:05:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ET78tv8rGQZYODu1CyZhWNYPBIiUDPgoUZB2vH661PgFlKuiLFXKUxbEsb9ZiRaSqFjWZ22dTZzVmvEKjCCa811/zLi1iMwnHQDOyhBNz+JOiZWoYZxbzG05JvnRTNrUVbOic2ubOfdCbheIa7bLYWt8UQHcLPebeBR7LTPDHFmX1TN0j09jLYyA7O2LtTUcON7i0cfwYZR0G6UA/i85idxfFsZsfbFyHuQBVTKfr6LHDJK3iQR6Pv9PT9LZS7itRGVSHtOqKj5L/foitxJziWgr9qlv032ZtQtuiTwmFwifpT79uRLTp2bdDHDgVi+tYcogRMn5e731nOapKnDISQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/R6VqdGPcsqNNQb0FMP46tzzX/tEgx8Z219XfY/aKY=;
 b=ZETxcKVfF5bs25MAP8FnwsUwr7nutAxEU9pFPnI6AKVuWkK2ExIVq5lbkSNSfQ5f5S2S2SZdpEjrrPhn1SzNCoXI6cj1Rx9P7qBVW08GNS0eRuIst7zkDgITo2gG0iJKW6zGnPiaty5/rB7JvQiQMqBSYafUGC6iY25lfOS3L0u4aLKd/kr6Yk3UkXxGi+E0akwcyd7whTlZQTV+xSDNHtmWE04bc1q4Rnhs04hzi4eE6yPtkUtBV4dp8/igEmz1M/ZXp9W46bqmLLIBHRQ0u2wc+VXXbWz+OKyn2UMEFJ8O27PLSr65A5DcVU18AVbWLQDQ2xHkB9fyKjsCFwtzwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/R6VqdGPcsqNNQb0FMP46tzzX/tEgx8Z219XfY/aKY=;
 b=FDpHEi0jOC9d2YgJ1nO0ZB6eIIs2hok4vgLaPjj0SklBR40AUejqXXuD1o7xxykYlGvS4JDJFiBWPHo089FJg1s2xc3IUtKKuINEp6qPpuxZqbk8/oC6TSmKTnvl8/2wB3JQvlRGWBC1FHsuoD0Pk48QKKuY//ASuy2llhnHLVo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3499.eurprd05.prod.outlook.com (10.170.243.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Thu, 12 Mar 2020 18:05:40 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 18:05:40 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [PATCH net-next v3 2/6] net: sched: Allow extending set of supported RED flags
Date:   Thu, 12 Mar 2020 20:05:03 +0200
Message-Id: <20200312180507.6763-3-petrm@mellanox.com>
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
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P191CA0043.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:55::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Thu, 12 Mar 2020 18:05:38 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e21598a0-1e16-4150-0a38-08d7c6aff93c
X-MS-TrafficTypeDiagnostic: HE1PR05MB3499:|HE1PR05MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3499DA4743085F468F0B167EDBFD0@HE1PR05MB3499.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(6486002)(52116002)(81156014)(81166006)(956004)(8936002)(2616005)(86362001)(54906003)(4326008)(6916009)(316002)(107886003)(186003)(26005)(6512007)(6666004)(16526019)(1076003)(2906002)(8676002)(36756003)(478600001)(66946007)(6506007)(66476007)(66556008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3499;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wV8iR01PFdzJm8zCU3/alLFSlWH0Oc+L2Y2c7m+J2u1hXgqUbH/NEQtPCM8W/Q6XjLXB+DQaQIqKlvKL83FfMRUH3rl6+BTYbSJpLNH9heHoJO4U+g7j4OTXP68ZKs7JIt0G3+sN6PFrJ/Pw407i3AJKQwtKZ9VqARD5wG9vxSIHDQw7Cdm0d3wAvc4PwM+bBCFRtc1+w2Hkm4i8soTAWsMA979qPbHUAackNUEAMtX8JguZw34OPwLKGJsSVERQeJEqzjg+ILiIP+ugEDztsy40fnww6MQ+YOB0375Wzky+GMsuAxLQoZfdJTMRnb/KQYkRpBKZP0oxiXE+rGUwV0bFTiEtlZMTRXifNUO972AXrNlmIjaz/ue5S+instXFFS9I2ZgQ636FYVAYQFGY+Sqh7KdcUDuMtZ/sX466RS6ZuXaMv0ayXe5haAihMVSU
X-MS-Exchange-AntiSpam-MessageData: QFeZ13Cn9gf33Zd/Sa7e0pqcm9hOHOMvg0/FgIV/KN70ECjcYTY7evi7dOPfjIUnCBGayZeN3Y2x8D34xNIgiWFv+LYkCf5BtVBwEUC9Vw6wJq2qO0ywvhwYog10B7TxjwpeR9twBFSUMlTeJsa9Xw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e21598a0-1e16-4150-0a38-08d7c6aff93c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 18:05:40.4938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fb/wTQiRdexrgMWCiWC7mo+CmtTb1HqEAs3OBQxRjS1BVfQaAduihiJlEZqB7tWNfTpEsdGCRPdzbQbQWi5CQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3499
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
passed flags of RED-like qdiscs to flags and user bits, and
red_validate_flags() to validate the resulting configuration. It further
adds a new attribute, TCA_RED_FLAGS, to pass arbitrary flags.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---

Notes:
    v3:
    - Change TCA_RED_FLAGS from NLA_U32 to NLA_BITFIELD32. Change
      RED_SUPPORTED_FLAGS the macro to red_supported_flags the constant
      and use as .validation_data.
    - Set policy's .strict_start_type to TCA_RED_FLAGS
    - red_get_flags(): Don't modify the passed-in flags until the end of
      the function. Return errno instead of bool.
    - Keep red_sched_data.flags as unsigned char.
    - Because bitfield32 allows only a subset of flags to be set, move the
      validation of the resulting configuration in red_change() into the
      critical section. Add a function red_validate_flags() specifically
      for the validation.
    - Remove braces when setting tc_red_qopt.flags in red_dump().
    - Check nla_put()'s return code when dumping TCA_RED_FLAGS.
    - Always dump TCA_RED_FLAGS, even if only old flags are active.
      The BITFIELD32 interface is richer and this way we can communicate
      to the client which flags are actually supported.
    
    v2:
    - This patch is new.

 include/net/red.h              | 33 +++++++++++++++++++++++++
 include/uapi/linux/pkt_sched.h | 16 ++++++++++++
 net/sched/sch_red.c            | 45 +++++++++++++++++++++++++++++++---
 3 files changed, 90 insertions(+), 4 deletions(-)

diff --git a/include/net/red.h b/include/net/red.h
index 9665582c4687..6a2aaa6c7c41 100644
--- a/include/net/red.h
+++ b/include/net/red.h
@@ -179,6 +179,39 @@ static inline bool red_check_params(u32 qth_min, u32 qth_max, u8 Wlog)
 	return true;
 }
 
+static inline int red_get_flags(unsigned char qopt_flags,
+				unsigned char historic_mask,
+				struct nlattr *flags_attr,
+				unsigned char supported_mask,
+				struct nla_bitfield32 *p_flags,
+				unsigned char *p_userbits,
+				struct netlink_ext_ack *extack)
+{
+	struct nla_bitfield32 flags;
+
+	if (qopt_flags && flags_attr) {
+		NL_SET_ERR_MSG_MOD(extack, "flags should be passed either through qopt, or through a dedicated attribute");
+		return -EINVAL;
+	}
+
+	if (flags_attr) {
+		flags = nla_get_bitfield32(flags_attr);
+	} else {
+		flags.selector = historic_mask;
+		flags.value = qopt_flags & historic_mask;
+	}
+
+	*p_flags = flags;
+	*p_userbits = qopt_flags & ~historic_mask;
+	return 0;
+}
+
+static inline int red_validate_flags(unsigned char flags,
+				     struct netlink_ext_ack *extack)
+{
+	return 0;
+}
+
 static inline void red_set_parms(struct red_parms *p,
 				 u32 qth_min, u32 qth_max, u8 Wlog, u8 Plog,
 				 u8 Scell_log, u8 *stab, u32 max_P)
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index bbe791b24168..6325507935ea 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -256,6 +256,7 @@ enum {
 	TCA_RED_PARMS,
 	TCA_RED_STAB,
 	TCA_RED_MAX_P,
+	TCA_RED_FLAGS,		/* bitfield32 */
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
index 1695421333e3..3436d6de7dbe 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -35,7 +35,11 @@
 
 struct red_sched_data {
 	u32			limit;		/* HARD maximal queue length */
+
 	unsigned char		flags;
+	/* Non-flags in tc_red_qopt.flags. */
+	unsigned char		userbits;
+
 	struct timer_list	adapt_timer;
 	struct Qdisc		*sch;
 	struct red_parms	parms;
@@ -44,6 +48,8 @@ struct red_sched_data {
 	struct Qdisc		*qdisc;
 };
 
+static const u32 red_supported_flags = TC_RED_HISTORIC_FLAGS;
+
 static inline int red_use_ecn(struct red_sched_data *q)
 {
 	return q->flags & TC_RED_ECN;
@@ -183,9 +189,12 @@ static void red_destroy(struct Qdisc *sch)
 }
 
 static const struct nla_policy red_policy[TCA_RED_MAX + 1] = {
-	[TCA_RED_PARMS]	= { .len = sizeof(struct tc_red_qopt) },
+	[TCA_RED_PARMS]	= { .len = sizeof(struct tc_red_qopt),
+			    .strict_start_type = TCA_RED_FLAGS },
 	[TCA_RED_STAB]	= { .len = RED_STAB_SIZE },
 	[TCA_RED_MAX_P] = { .type = NLA_U32 },
+	[TCA_RED_FLAGS] = { .type = NLA_BITFIELD32,
+			    .validation_data = &red_supported_flags },
 };
 
 static int red_change(struct Qdisc *sch, struct nlattr *opt,
@@ -194,7 +203,10 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 	struct Qdisc *old_child = NULL, *child = NULL;
 	struct red_sched_data *q = qdisc_priv(sch);
 	struct nlattr *tb[TCA_RED_MAX + 1];
+	struct nla_bitfield32 flags_bf;
 	struct tc_red_qopt *ctl;
+	unsigned char userbits;
+	unsigned char flags;
 	int err;
 	u32 max_P;
 
@@ -216,6 +228,12 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog))
 		return -EINVAL;
 
+	err = red_get_flags(ctl->flags, TC_RED_HISTORIC_FLAGS,
+			    tb[TCA_RED_FLAGS], red_supported_flags,
+			    &flags_bf, &userbits, extack);
+	if (err)
+		return err;
+
 	if (ctl->limit > 0) {
 		child = fifo_create_dflt(sch, &bfifo_qdisc_ops, ctl->limit,
 					 extack);
@@ -227,7 +245,14 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 	}
 
 	sch_tree_lock(sch);
-	q->flags = ctl->flags;
+
+	flags = (q->flags & ~flags_bf.selector) | flags_bf.value;
+	err = red_validate_flags(flags, extack);
+	if (err)
+		goto unlock_out;
+
+	q->flags = flags;
+	q->userbits = userbits;
 	q->limit = ctl->limit;
 	if (child) {
 		qdisc_tree_flush_backlog(q->qdisc);
@@ -256,6 +281,12 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 	if (old_child)
 		qdisc_put(old_child);
 	return 0;
+
+unlock_out:
+	sch_tree_unlock(sch);
+	if (child)
+		qdisc_put(child);
+	return err;
 }
 
 static inline void red_adaptative_timer(struct timer_list *t)
@@ -299,10 +330,15 @@ static int red_dump_offload_stats(struct Qdisc *sch)
 static int red_dump(struct Qdisc *sch, struct sk_buff *skb)
 {
 	struct red_sched_data *q = qdisc_priv(sch);
+	struct nla_bitfield32 flags_bf = {
+		.selector = red_supported_flags,
+		.value = q->flags,
+	};
 	struct nlattr *opts = NULL;
 	struct tc_red_qopt opt = {
 		.limit		= q->limit,
-		.flags		= q->flags,
+		.flags		= (q->flags & TC_RED_HISTORIC_FLAGS) |
+				  q->userbits,
 		.qth_min	= q->parms.qth_min >> q->parms.Wlog,
 		.qth_max	= q->parms.qth_max >> q->parms.Wlog,
 		.Wlog		= q->parms.Wlog,
@@ -319,7 +355,8 @@ static int red_dump(struct Qdisc *sch, struct sk_buff *skb)
 	if (opts == NULL)
 		goto nla_put_failure;
 	if (nla_put(skb, TCA_RED_PARMS, sizeof(opt), &opt) ||
-	    nla_put_u32(skb, TCA_RED_MAX_P, q->parms.max_P))
+	    nla_put_u32(skb, TCA_RED_MAX_P, q->parms.max_P) ||
+	    nla_put(skb, TCA_RED_FLAGS, sizeof(flags_bf), &flags_bf))
 		goto nla_put_failure;
 	return nla_nest_end(skb, opts);
 
-- 
2.20.1

