Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C203D20BC
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 11:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhGVIjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 04:39:20 -0400
Received: from mail-mw2nam10on2116.outbound.protection.outlook.com ([40.107.94.116]:34920
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231392AbhGVIjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 04:39:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsKt46CukyQMuWQ/KeNvaKzFtK4G+CbIfmvXE5rJgF4laqZ/ongdWZbZGrA+36idqBezxSXb0WDrECySa0t7mghT+O4LG1WlFafzyyyvXQ6ko5j+udw1QwNGm1pCqHFB4yEeyh+6Tqkd/iWq0CIqHRGXCenEgBWOjAA84LyoSGq+Eldes3ijhsjvCZ1aWuTtnXY45uHiPs98ojyAKKkD+ZLPBzgl1S+AxDDNgsTKlxSZDBNHGQRQcuI7esofXr8t0/q4WH78/YyTvjpbpcE6ctIylFtO6RWNHDgwOoa+l5rCnsWgS6LHSEw3TOffAEutmDifAjKMs+pV3ghm0pRIEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q80oKmxNL17D9s9qTL19JU1W6Si2xtc7eYc+23ApZG0=;
 b=RblhrsBXmb20Fv82qDB56qugNl48N/sfWre4g9CK3D54XeiXL2CDMKruagKOitn6Vf3aF+FwlaLBDkVVLnVK0Jap9t4jRYr2XCo3HtFSnghJfrZGyaFBnDseExI3uy9209dRYApBOk4VbkwWOX82iUw/AT5igWjMSeP6BNZ0HzD/HKE6mXbMiXwFjjrVMpy/TVPq41McDrgCJ45eqHp3+lYBmHKsh/FMPB3dB5u9oy6I6rE/A717FHLnurgBd4WY6ylmihKuaY8julVhcKbYGS1m7uak3t+5nkhy0JgqYNRV9H9xhM9zfLryzu8y+3TT2ALWVcGeCqhQN9gqUK/kLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q80oKmxNL17D9s9qTL19JU1W6Si2xtc7eYc+23ApZG0=;
 b=AZAMkWDusFh8d2TrtrGP+SGxmUUngwSuhbYaflKIEkouLaXdrMKaZQg9WX7HOV1lcsYSLBiiof5oObgFDfXZJPuU6LROHzCLrGkkcU7PtdaKc/UP3E9/6dlfit4zhDXkRXJb7Na/BreSUYw+/7c/2gxlwcgIghEXnVy2jjb3h5M=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4841.namprd13.prod.outlook.com (2603:10b6:510:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.11; Thu, 22 Jul
 2021 09:19:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%7]) with mapi id 15.20.4352.024; Thu, 22 Jul 2021
 09:19:53 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 1/3] flow_offload: allow user to offload tc action to net device
Date:   Thu, 22 Jul 2021 11:19:36 +0200
Message-Id: <20210722091938.12956-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210722091938.12956-1-simon.horman@corigine.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Thu, 22 Jul 2021 09:19:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18e54e94-f406-40ac-bdf3-08d94cf1dd56
X-MS-TrafficTypeDiagnostic: PH0PR13MB4841:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB484157FFF1BBE50CE49D0E80E8E49@PH0PR13MB4841.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Pt0y0QTC6VjuaoGDQFmEILEV3gawzRp5c5jBglaYfpV1vMH7UHKybVspX5AvmiNV62L9tmndq6vuwBbtryv8IEDv3MBSRbNXBA0TjVNATuxinjDG4Q4gEgBjpJe51se5QK3g2/P0rYAXb74czm/jTIj6dNXnTJGD/OFapA1v8RGXaAurb4j24mSpZsqdsTZeEruyXd4eiZWL+UpoeAQ6MwyT9LiHuez+DDXF0Y1b/ePPU9sBwI72AYsfm8LNe9FURIP0PKpoBDQYJgyvMQsRj0pxeyjjdudB9+tjxc6JHCc8egOs2V4BsGbEmSpwQJ3lcqSqvNjgbESdIB+VeAC9omkdLh7l/9c8VUnR1O+cozpyI2cK6HVbRljomX2MFqc6Uld6ZSRAMw3vT0huz66GTNpRFiExOgqGcsMd0esP7M6jhF/SA9N3KL9eRrmp29h+gG/zer+Pg/6RDcXuHdRTdgK2MVtzq6wSLRUucixgLYceUNUIsFmQkmI44oVqX2S/0d/bEdH8oTXdpwmm41jXOdA8RGEC61s/hqIC9L2/WngX7XPSySzkGEqG7CblZd+uBj3VKZBGtX1DNyc+OOh1Kr37feyDBLTUw/cL68QX3xQx/kVzUstwVhR+5wi5ePqeU2cGEojD1GwcrL7zl3U3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39830400003)(136003)(376002)(6486002)(86362001)(8676002)(6666004)(2616005)(30864003)(6512007)(2906002)(54906003)(83380400001)(36756003)(66476007)(66556008)(8936002)(1076003)(107886003)(66946007)(110136005)(4326008)(186003)(44832011)(38100700002)(508600001)(316002)(52116002)(5660300002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2395ysvrTkGhUaul62Zn2W+VYnDrztqu+Phz+tH+/noyLkmwzIlOkSAAoF3I?=
 =?us-ascii?Q?CFOSxuppQQMtni+cnIbqE4gnI+qOGca9XLMIzE8vFmDZaVV4s8KOWsG2NBzE?=
 =?us-ascii?Q?Z3lmstFx7ys+HGBqK0EV7PT6malCSVy5Bki6N2duP65LG9Z4TojlAPAhqswd?=
 =?us-ascii?Q?u2/FeJU8bMqhkP1j6mG+E+Cgku5n82sYlh8dZtEe1OfrGEjvY07SUoFFG7Qn?=
 =?us-ascii?Q?Tu0aXPTAAWs7rZa914BPxxDKMqerJtO3reYCYAr570Vp6m6R5TNa8QceXEA4?=
 =?us-ascii?Q?zKZk1uUd/xy+n2FZqzdkdzn+kMcOTfiW+/Nm35soLHz5xKHUtiVYJZrZG8NZ?=
 =?us-ascii?Q?/2Hd/Gks6kCgPrVVOK8XQ/G6A8GIU96rCb+67uNtYoEtI2A/AEiAkEIaBJcn?=
 =?us-ascii?Q?CFe2cUHajrqkFMkQIsZpcfuWh40GKQ4AFVyvs2c0UPt/b54Gatk0hhqjduF5?=
 =?us-ascii?Q?dTb26H0Z4ZYpOgZQmTdlM8ZOc3Fnyc7G8kFhhVFmbnbvAYcyj4pWgMXWsuBN?=
 =?us-ascii?Q?XTmPu6m3PBqGMPN8TDDg3eYC/MFIJNIKo7WEbmMG1fLRKr0N/9SNL2bToBeB?=
 =?us-ascii?Q?qcGvVRmV6hsDDAGTWn+5NmVR7by1R4hxBDgTYwoFohgRl7BYG3W8wKdHRFor?=
 =?us-ascii?Q?PNO+akesJwmPSwV2tM4gGR6shGTm0Qvjm3qdwgFjF0D2R/9tRYUjvGxCQUdR?=
 =?us-ascii?Q?aAoOteHMq4p8qaMPLoZ0MUUlAVG3JaRqbfX9DBe9l+2M5R9HOErtOyDTM93P?=
 =?us-ascii?Q?S2xmji/ucp1iiuYiPGJMKYSihRhr16e89vi0SAIL2fPabdE17j+9Ov9vPSrQ?=
 =?us-ascii?Q?sv6s0/VrE1F+fWiylTxxjq8ejpYgTPo+sYZL33TjzBbxWptg3IIAqWdNawFy?=
 =?us-ascii?Q?WdXzoZWIvUAAi1OX50V07hmPI63MSRDJyqKPpUBe5aae47wPR98GsUavWmKn?=
 =?us-ascii?Q?qt5/ru6QaoM/E6c47GmMcybHBdm0WtSYHjzDLcftCUhAiTAPZCD5+xKv8yfk?=
 =?us-ascii?Q?NcSpxEYkaHViJLrlRWZ4fghC3RnJylPh3TZTtRT0rYZPyJcDSkhDOvU0NqcR?=
 =?us-ascii?Q?xnOcN58tisnOE2CKckDDEl+qILJhGttEpLv675Jy9lZt1cmj63CQt1/Qdrk+?=
 =?us-ascii?Q?C5Kub0FC1HggLQc2NLrlQGzJn5Q/RAzwKvjIhYg/7XX/oHcI2uL8FN+pnJtt?=
 =?us-ascii?Q?wHqWD4GQzKQ5cSYq3PI9FH4+Y0r5QtVZZMmEJNQgrRVDuniGl1St6Fwch7bZ?=
 =?us-ascii?Q?0gJVYQN802+kvLXivY7slu1y8MWeto16WdicNCSBqkOCfEHr9cRgANBa9j2j?=
 =?us-ascii?Q?4/dzBd0CgzdIcGd7HmLOwGWvATjd8o2srmfpztUsJB0SFlvqxyYH0VNbs44g?=
 =?us-ascii?Q?H9XDlAQ59kDBe1jv2sHOgJllsl0b?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e54e94-f406-40ac-bdf3-08d94cf1dd56
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 09:19:53.5358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r04Y2TmFu3ju4S04aUbml25/4sEci9rDTPVCmXzhGJLjsdoQgRdONABAHGk3DXXW3QsNz18DBTWnSFnva7LRs96CyMdhPOgGhKtLo6IM5Es=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4841
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Use flow_indr_dev_register/flow_indr_dev_setup_offload to
offload tc action.

We offload the tc action mainly for ovs meter configuration.
Make some basic changes for different vendors to return EOPNOTSUPP.

We need to call tc_cleanup_flow_action to clean up tc action entry since
in tc_setup_action, some actions may hold dev refcnt, especially the mirror
action.

As per review from the RFC, the kernel test robot will fail to run, so
we add CONFIG_NET_CLS_ACT control for the action offload.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  2 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  3 ++
 .../ethernet/netronome/nfp/flower/offload.c   |  3 ++
 include/linux/netdevice.h                     |  1 +
 include/net/flow_offload.h                    | 15 ++++++++
 include/net/pkt_cls.h                         | 15 ++++++++
 net/core/flow_offload.c                       | 26 +++++++++++++-
 net/sched/act_api.c                           | 33 +++++++++++++++++
 net/sched/cls_api.c                           | 36 ++++++++++++++++---
 9 files changed, 128 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 5e4429b14b8c..edbbf7b4df77 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1951,7 +1951,7 @@ static int bnxt_tc_setup_indr_cb(struct net_device *netdev, struct Qdisc *sch, v
 				 void *data,
 				 void (*cleanup)(struct flow_block_cb *block_cb))
 {
-	if (!bnxt_is_netdev_indr_offload(netdev))
+	if (!netdev || !bnxt_is_netdev_indr_offload(netdev))
 		return -EOPNOTSUPP;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 059799e4f483..111daacc4cc3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -486,6 +486,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, struct Qdisc *sch, void *
 			    void *data,
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
+	if (!netdev)
+		return -EOPNOTSUPP;
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
 		return mlx5e_rep_indr_setup_block(netdev, sch, cb_priv, type_data,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 2406d33356ad..88bbc86347b4 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1869,6 +1869,9 @@ nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *
 			    void *data,
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
+	if (!netdev)
+		return -EOPNOTSUPP;
+
 	if (!nfp_fl_is_netdev_to_offload(netdev))
 		return -EOPNOTSUPP;
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 42f6f866d5f3..b138219baf6f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -923,6 +923,7 @@ enum tc_setup_type {
 	TC_SETUP_QDISC_TBF,
 	TC_SETUP_QDISC_FIFO,
 	TC_SETUP_QDISC_HTB,
+	TC_SETUP_ACT,
 };
 
 /* These structures hold the attributes of bpf state that are being passed
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 69c9eabf8325..26644596fd54 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -553,6 +553,21 @@ struct flow_cls_offload {
 	u32 classid;
 };
 
+enum flow_act_command {
+	FLOW_ACT_REPLACE,
+	FLOW_ACT_DESTROY,
+	FLOW_ACT_STATS,
+};
+
+struct flow_offload_action {
+	struct netlink_ext_ack *extack;
+	enum flow_act_command command;
+	struct flow_stats stats;
+	struct flow_action action;
+};
+
+struct flow_offload_action *flow_action_alloc(unsigned int num_actions);
+
 static inline struct flow_rule *
 flow_cls_offload_flow_rule(struct flow_cls_offload *flow_cmd)
 {
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index ec7823921bd2..cd4cf6b10f5d 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -266,6 +266,9 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 	for (; 0; (void)(i), (void)(a), (void)(exts))
 #endif
 
+#define tcf_act_for_each_action(i, a, actions) \
+	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
+
 static inline void
 tcf_exts_stats_update(const struct tcf_exts *exts,
 		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
@@ -536,8 +539,19 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
 	return ifindex == skb->skb_iif;
 }
 
+#ifdef CONFIG_NET_CLS_ACT
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts);
+#else
+static inline int tc_setup_flow_action(struct flow_action *flow_action,
+				       const struct tcf_exts *exts)
+{
+		return 0;
+}
+#endif
+
+int tc_setup_action(struct flow_action *flow_action,
+		    struct tc_action *actions[]);
 void tc_cleanup_flow_action(struct flow_action *flow_action);
 
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
@@ -558,6 +572,7 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
 			  enum tc_setup_type type, void *type_data,
 			  void *cb_priv, u32 *flags, unsigned int *in_hw_count);
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
+unsigned int tcf_act_num_actions(struct tc_action *actions[]);
 
 #ifdef CONFIG_NET_CLS_ACT
 int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 715b67f6c62f..0fa2f75cc9b3 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -27,6 +27,27 @@ struct flow_rule *flow_rule_alloc(unsigned int num_actions)
 }
 EXPORT_SYMBOL(flow_rule_alloc);
 
+struct flow_offload_action *flow_action_alloc(unsigned int num_actions)
+{
+	struct flow_offload_action *fl_action;
+	int i;
+
+	fl_action = kzalloc(struct_size(fl_action, action.entries, num_actions),
+			    GFP_KERNEL);
+	if (!fl_action)
+		return NULL;
+
+	fl_action->action.num_entries = num_actions;
+	/* Pre-fill each action hw_stats with DONT_CARE.
+	 * Caller can override this if it wants stats for a given action.
+	 */
+	for (i = 0; i < num_actions; i++)
+		fl_action->action.entries[i].hw_stats = FLOW_ACTION_HW_STATS_DONT_CARE;
+
+	return fl_action;
+}
+EXPORT_SYMBOL(flow_action_alloc);
+
 #define FLOW_DISSECTOR_MATCH(__rule, __type, __out)				\
 	const struct flow_match *__m = &(__rule)->match;			\
 	struct flow_dissector *__d = (__m)->dissector;				\
@@ -476,6 +497,9 @@ int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
 
 	mutex_unlock(&flow_indr_block_lock);
 
-	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
+	if (bo)
+		return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
+	else
+		return 0;
 }
 EXPORT_SYMBOL(flow_indr_dev_setup_offload);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 998a2374f7ae..185f17ea60d5 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1060,6 +1060,36 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	return ERR_PTR(err);
 }
 
+/* offload the tc command after inserted */
+int tcf_action_offload_cmd(struct tc_action *actions[],
+			   struct netlink_ext_ack *extack)
+{
+	struct flow_offload_action *fl_act;
+	int err = 0;
+
+	fl_act = flow_action_alloc(tcf_act_num_actions(actions));
+	if (!fl_act)
+		return -ENOMEM;
+
+	fl_act->extack = extack;
+	err = tc_setup_action(&fl_act->action, actions);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to setup tc actions for offload\n");
+		goto err_out;
+	}
+	fl_act->command = FLOW_ACT_REPLACE;
+
+	flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT, fl_act, NULL, NULL);
+
+	tc_cleanup_flow_action(&fl_act->action);
+
+err_out:
+	kfree(fl_act);
+	return err;
+}
+EXPORT_SYMBOL(tcf_action_offload_cmd);
+
 /* Returns numbers of initialized actions or negative error. */
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
@@ -1514,6 +1544,9 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 		return ret;
 	ret = tcf_add_notify(net, n, actions, portid, attr_size, extack);
 
+	/* offload actions to hardware if possible */
+	tcf_action_offload_cmd(actions, extack);
+
 	/* only put existing actions */
 	for (i = 0; i < TCA_ACT_MAX_PRIO; i++)
 		if (init_res[i] == ACT_P_CREATED)
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index c8cb59a11098..9b9770dab5e8 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3544,8 +3544,8 @@ static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
 	return hw_stats;
 }
 
-int tc_setup_flow_action(struct flow_action *flow_action,
-			 const struct tcf_exts *exts)
+int tc_setup_action(struct flow_action *flow_action,
+		    struct tc_action *actions[])
 {
 	struct tc_action *act;
 	int i, j, k, err = 0;
@@ -3554,11 +3554,11 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
 
-	if (!exts)
+	if (!actions)
 		return 0;
 
 	j = 0;
-	tcf_exts_for_each_action(i, act, exts) {
+	tcf_act_for_each_action(i, act, actions) {
 		struct flow_action_entry *entry;
 
 		entry = &flow_action->entries[j];
@@ -3725,7 +3725,19 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	spin_unlock_bh(&act->tcfa_lock);
 	goto err_out;
 }
+EXPORT_SYMBOL(tc_setup_action);
+
+#ifdef CONFIG_NET_CLS_ACT
+int tc_setup_flow_action(struct flow_action *flow_action,
+			 const struct tcf_exts *exts)
+{
+	if (!exts)
+		return 0;
+
+	return tc_setup_action(flow_action, exts->actions);
+}
 EXPORT_SYMBOL(tc_setup_flow_action);
+#endif
 
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
 {
@@ -3743,6 +3755,22 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
 }
 EXPORT_SYMBOL(tcf_exts_num_actions);
 
+unsigned int tcf_act_num_actions(struct tc_action *actions[])
+{
+	unsigned int num_acts = 0;
+	struct tc_action *act;
+	int i;
+
+	tcf_act_for_each_action(i, act, actions) {
+		if (is_tcf_pedit(act))
+			num_acts += tcf_pedit_nkeys(act);
+		else
+			num_acts++;
+	}
+	return num_acts;
+}
+EXPORT_SYMBOL(tcf_act_num_actions);
+
 #ifdef CONFIG_NET_CLS_ACT
 static int tcf_qevent_parse_block_index(struct nlattr *block_index_attr,
 					u32 *p_block_index,
-- 
2.20.1

