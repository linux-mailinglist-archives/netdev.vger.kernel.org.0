Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05131E27FC
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbgEZRKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:10:37 -0400
Received: from mail-eopbgr40061.outbound.protection.outlook.com ([40.107.4.61]:58964
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728444AbgEZRKg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:10:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLXOxFU3TOAeYoEHjCmOsKD5yC3vpam5868fvf/2aVUrZ8WcF7NZ6Sak9XAAa/YT3PH9Dh+U7bGV2WAFufQbo4y6uTL10PuS+oGEpVYvBMkcWmk735FZUHRgJA8voGk7VZKBnMXWbhH6tXJW8MRmvdJwz53bskZlQT3T1GWYQsF8DI9S60LCQByKLx3S7tUf1URppq1FZ++5rIBeNO8k4a0T7tAt2qG0m/8S4Z5uEPzcwFBKtDEXh2qR+7X5cPshzlgFUaWJSUwKdSzyDdnk+Di5tNr+tbx9WgxHy147AcD/3ucbmQnF4pj/9I7p8dIopctlW/83WS3j18MWD/BszA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAWvtO40Iap7jB6P/uF3xcsyiuCRmgLEklMtbEVIrQs=;
 b=Vnqu6b3TOnLGeYUiuVCSfOCRVIczRVmOhHUTSK44q96Do87OajyQ9Bjjz7+NbToW1pC67LVeoErpYjmgFvTZ9v95N9vyOJOkDEOvTHjiZA9zcVWymdrdgKPfZLRK5YsQjglfYVsd3VKyqCJRrE0mZyfR6RhfQgFKJOcWnON25qDgIlpl021z7tZxQebELdgUersyKZJuBSL3HhpIbmBIBnPGjoWO2cmziAwQbWdY46aHaWnBZRGx+q9Pfpwv/JJK6Zrv45qeYM9hoqS56zbBQTMemElMythX6v6TU0uEW0cGELdVDaFWq2leeTtTYaf9FDeRfl5miVJxbwajJew9+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAWvtO40Iap7jB6P/uF3xcsyiuCRmgLEklMtbEVIrQs=;
 b=LT5Hpa8O7ePEXr8SLifhJ4bxHRWsgibRu0QSWhpfkKRAILl3ewSL6GUWTWZIF/pX0T6fBqcKwavtWZb+Qzu07okSlZ7d092eydX71ybLtLE7ywTt5GS4XOAQRbtRLF8VcR7MlQ8c19q2px5HyW2xMpBFcpn9FHZ1w6VY7w7fySM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3225.eurprd05.prod.outlook.com (2603:10a6:7:37::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.27; Tue, 26 May 2020 17:10:31 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::454c:b7ed:6a9c:21f5]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::454c:b7ed:6a9c:21f5%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 17:10:31 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        jiri@mellanox.com, idosch@mellanox.com,
        Petr Machata <petrm@mellanox.com>
Subject: [RFC PATCH net-next 1/3] net: sched: Introduce helpers for qevent blocks
Date:   Tue, 26 May 2020 20:10:05 +0300
Message-Id: <6ec558170c753c5b832b73dc999504483257b15c.1590512901.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1590512901.git.petrm@mellanox.com>
References: <cover.1590512901.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0034.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::47) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR02CA0034.eurprd02.prod.outlook.com (2603:10a6:208:3e::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27 via Frontend Transport; Tue, 26 May 2020 17:10:30 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: df8d6da8-4adb-4104-c675-08d80197b202
X-MS-TrafficTypeDiagnostic: HE1PR05MB3225:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB32251D4145AC57D5A857DB0FDBB00@HE1PR05MB3225.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JXwnvx9FVt5dTu4zQqvrS1UQ8DkjyzhxruAssS5nWCJRdVaTHbKBPJSmgp+NYd0/u6B0FwLQIMDP3wcWJIOKcED1VNuKxVo/dVBo5LHXxweYJz7zG7di/o6XEFo8zs/Jd/+jwmSgSjaMKsYEANOhB4m6XR5hJPeFPIBhU1yOyJE3GerQIcgkZQGtq4q3G7shezF96cZzrx42txSxtmKflE4jYB/gNTgPSV1RRVU85/733fXS286MbiUJ4LcyaCtF9G/32TPaAWO0G9nHaZt+S6xC16IexWb3kTH23CoKH+pReTB69PfOClDle2LALVMFDA9/PUxrLOHkdWLm4xCvyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(396003)(39840400004)(366004)(956004)(6486002)(2616005)(26005)(186003)(52116002)(6506007)(86362001)(2906002)(8676002)(8936002)(16526019)(5660300002)(6666004)(36756003)(6512007)(54906003)(6916009)(66556008)(107886003)(4326008)(478600001)(66946007)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: maQ+ljnSZa2+BE9xf2gUhUTjf4MdsHautVR5MymkgViPbq5TJ4+T1FAAyuKsWnwmNB4aOAAvjuM4pxQii6/xBhySNyeCsj0Epqs4BOPMqJBQQu9CkhQDHl28TwpCKVNbETJzu2gXwcdijceqwjI4qSduIcebkV+8xtqyfxS1evXyNRoDRVMhRDzTTYGqv+ilCa1VoKldkF8V0EnEOa21VmeehMDcXw93/6TmrPMnu5q1/f/wP3odOK3VxvsNCYemE1iNvzMKLtSNmpnO9tH+6A96wqPtxPHnlGNmdhbYqMu0R44dv07FMEmUaILjMHCrenEkY5uKmTQiEkPH1v4Jyf3/4cG32w6RH2xYm58d3qmRVN0yh+u1kiR6Dg3gbZ4A7V1MuuiPloKWGVKe8FY+dbhB3IydUCpbdCDm02MgNvSpV094+UZr0zaKKtGsM9Dq0J/RliPtNb/QynATwmZTO/XIdeLjnLS4PN2HlURR66VYold9pyvWvzH2F+6Emh/e
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df8d6da8-4adb-4104-c675-08d80197b202
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 17:10:31.4389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pNSMq0TNyMQ693d80Vhv0dDVUGik/CVJb6P/GCViEnLvukQuvtaGVymuam9P5ywqvngnnNzqcfdxjT5z5MSVXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3225
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qevents are attach points for TC blocks, where filters can be put that are
executed when "interesting events" take place in a qdisc. The data to keep
and the functions to invoke to maintain a qevent will be largely the same
between qevents. Therefore introduce sched-wide helpers for qevent
management.

Currently, similarly to ingress and egress blocks of clsact pseudo-qdisc,
blocks attachment cannot be changed after the qdisc is created. To that
end, add a helper tcf_qevent_validate_change(), which verifies whether
block index attribute is not attached, or if it is, whether its value
matches the current one (i.e. there is no material change).

The function tcf_qevent_handle() is supposed to be invoked when qdisc hits
the "interesting event" corresponding to this block.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 include/net/pkt_cls.h |  48 +++++++++++++++++++
 net/sched/cls_api.c   | 107 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 155 insertions(+)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index ed65619cbc47..efb20e3c2c98 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -32,6 +32,13 @@ struct tcf_block_ext_info {
 	u32 block_index;
 };
 
+struct tcf_qevent {
+	int			attr_name;
+	struct tcf_block	*block;
+	struct tcf_block_ext_info info;
+	struct tcf_proto __rcu *filter_chain;
+};
+
 struct tcf_block_cb;
 bool tcf_queue_work(struct rcu_work *rwork, work_func_t func);
 
@@ -552,6 +559,47 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
 			  void *cb_priv, u32 *flags, unsigned int *in_hw_count);
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
 
+#ifdef CONFIG_NET_CLS_ACT
+int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
+		    enum flow_block_binder_type binder_type,
+		    struct nlattr *block_index_attr,
+		    struct netlink_ext_ack *extack);
+void tcf_qevent_destroy(struct tcf_qevent *qe, struct Qdisc *sch);
+int tcf_qevent_validate_change(struct tcf_qevent *qe,
+			       struct nlattr *block_index_attr,
+			       struct netlink_ext_ack *extack);
+struct sk_buff *tcf_qevent_handle(struct tcf_qevent *qe, struct Qdisc *sch,
+				  struct sk_buff *skb, struct sk_buff **to_free,
+				  int *ret);
+#else
+static inline int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
+				  enum flow_block_binder_type binder_type,
+				  struct nlattr *block_index_attr,
+				  struct netlink_ext_ack *extack)
+{
+	return 0;
+}
+
+static inline void tcf_qevent_destroy(struct tcf_qevent *qe, struct Qdisc *sch)
+{
+}
+
+static inline int tcf_qevent_validate_change(struct tcf_qevent *qe,
+					     struct nlattr *block_index_attr,
+					     struct netlink_ext_ack *extack)
+{
+	return 0;
+}
+
+static inline struct sk_buff *
+tcf_qevent_handle(struct tcf_qevent *qe, struct Qdisc *sch,
+		  struct sk_buff *skb, struct sk_buff **to_free,
+		  int *ret)
+{
+	return skb;
+}
+#endif
+
 struct tc_cls_u32_knode {
 	struct tcf_exts *exts;
 	struct tcf_result *res;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 752d608f4442..f95a5eee9279 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3801,6 +3801,113 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
 }
 EXPORT_SYMBOL(tcf_exts_num_actions);
 
+static int tcf_qevent_parse_block_index(struct nlattr *block_index_attr,
+					u32 *p_block_index,
+					struct netlink_ext_ack *extack)
+{
+	*p_block_index = nla_get_u32(block_index_attr);
+	if (!*p_block_index) {
+		NL_SET_ERR_MSG(extack, "Block number may not be zero");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
+		    enum flow_block_binder_type binder_type,
+		    struct nlattr *block_index_attr,
+		    struct netlink_ext_ack *extack)
+{
+	u32 block_index;
+	int err;
+
+	if (!block_index_attr)
+		return 0;
+
+	err = tcf_qevent_parse_block_index(block_index_attr, &block_index,
+					   extack);
+	if (err)
+		return err;
+
+	if (!block_index)
+		return 0;
+
+	qe->info.binder_type = binder_type;
+	qe->info.chain_head_change = tcf_chain_head_change_dflt;
+	qe->info.chain_head_change_priv = &qe->filter_chain;
+	qe->info.block_index = block_index;
+
+	return tcf_block_get_ext(&qe->block, sch, &qe->info, extack);
+}
+EXPORT_SYMBOL(tcf_qevent_init);
+
+void tcf_qevent_destroy(struct tcf_qevent *qe, struct Qdisc *sch)
+{
+	if (qe->info.block_index)
+		tcf_block_put_ext(qe->block, sch, &qe->info);
+}
+EXPORT_SYMBOL(tcf_qevent_destroy);
+
+int tcf_qevent_validate_change(struct tcf_qevent *qe,
+			       struct nlattr *block_index_attr,
+			       struct netlink_ext_ack *extack)
+{
+	u32 block_index;
+	int err;
+
+	if (!block_index_attr)
+		return 0;
+
+	err = tcf_qevent_parse_block_index(block_index_attr, &block_index,
+					   extack);
+	if (err)
+		return err;
+
+	/* Bounce newly-configured block or change in block. */
+	if (block_index != qe->info.block_index) {
+		NL_SET_ERR_MSG(extack, "Change of blocks is not supported");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(tcf_qevent_validate_change);
+
+struct sk_buff *tcf_qevent_handle(struct tcf_qevent *qe, struct Qdisc *sch,
+				  struct sk_buff *skb, struct sk_buff **to_free,
+				  int *ret)
+{
+	struct tcf_result cl_res;
+	struct tcf_proto *fl;
+
+	if (!qe->info.block_index)
+		return skb;
+
+	fl = rcu_dereference_bh(qe->filter_chain);
+
+	switch (tcf_classify(skb, fl, &cl_res, false)) {
+	case TC_ACT_SHOT:
+		qdisc_qstats_drop(sch);
+		__qdisc_drop(skb, to_free);
+		*ret = __NET_XMIT_BYPASS;
+		return NULL;
+	case TC_ACT_STOLEN:
+	case TC_ACT_QUEUED:
+	case TC_ACT_TRAP:
+		__qdisc_drop(skb, to_free);
+		*ret = __NET_XMIT_STOLEN;
+		return NULL;
+	case TC_ACT_REDIRECT:
+		skb_do_redirect(skb);
+		*ret = __NET_XMIT_STOLEN;
+		return NULL;
+	}
+
+	return skb;
+}
+EXPORT_SYMBOL(tcf_qevent_handle);
+
 static __net_init int tcf_net_init(struct net *net)
 {
 	struct tcf_net *tn = net_generic(net, tcf_net_id);
-- 
2.20.1

