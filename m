Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F6F3D20BE
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 11:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhGVIja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 04:39:30 -0400
Received: from mail-mw2nam10on2134.outbound.protection.outlook.com ([40.107.94.134]:9156
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231392AbhGVIjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 04:39:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8fX0mXKmYtk8C3F1RwrgSeYlh9jstwN3UCPVw/VSEoKnvHeqmSwOgxhHLFSTjRzFUNRjTKR210b4Uj9OQYZ2tb5j4VMTiH2RTjcmIO0k7LTLNSUnJwP2GRSANx0DkmA8fY2QpbhGFwzKONQewmCk+aERG80iCdOE2AyrgeLVPM7hK+7xfsYwGKC4V2xJaoNrFnDEPlpOfMczEQRzjJTTRUGcmrwfP/t+LEzm9QXj8FOJdBXLr3/lD4dJqEnAUQcRQtS9FQkWdIuz6+GanFQh39MvAefQRtiLu3fwUkl7Mv2Ibux94G4MplY9k8MGXf0zOJ3wRqXN6coJ1B8+1AgYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/jM9NQIrl/kX0wAj/XjT+uNKnF0Co6YFWIbN/klhDE=;
 b=Veqzsm2td8vH+sy+B4uVuSCXw5dcYIKPiADyl4U6i84o/R26rrQ/u9yG//w9XzT+Vth/DEFH2wmQJ4rPtIvsq09Ray2qH+qud90Lwgh44Hww/lQCKBxmWPS3kjI25jucQYQSkkbeOxK10eLoQh3gygIqnzgIC3Y88jrVh//qWmPgUB3CNi20TB54SQh56ndGMqNlQCxwhFO9/FAPCLkI6gOnt9mLAvmcudcmLHvVbEUEf9OZw/iIHfNdzTwIiBo5pMNyrbeRiiPaBsMakkyWJxBI8H+4waAPmF1OmAU0s7ecJulPyGTTMch/HEuvBtbuOxYpdNM8PhYTDXBawE8T5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/jM9NQIrl/kX0wAj/XjT+uNKnF0Co6YFWIbN/klhDE=;
 b=jAwP/IrECNRPrmhkSud2qrlAOdIfS51cusfroyCVQJU0OuCQWB93XusJenf9a7qxIBbgN4gM/gZi7zHQfLwwN1i6g36wUBwcqmfnl4X3JXVbxcxBTLuEgzX3jkBOxq60v7FZ+iwel4i0Mh1KyPbKcaLY9Ke1pwGSa2E3WawFAyo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4841.namprd13.prod.outlook.com (2603:10b6:510:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.11; Thu, 22 Jul
 2021 09:19:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%7]) with mapi id 15.20.4352.024; Thu, 22 Jul 2021
 09:19:58 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 3/3] flow_offload: add process to update action stats from hardware
Date:   Thu, 22 Jul 2021 11:19:38 +0200
Message-Id: <20210722091938.12956-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210722091938.12956-1-simon.horman@corigine.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Thu, 22 Jul 2021 09:19:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 534a7ce2-6fdc-4acb-8c49-08d94cf1dfef
X-MS-TrafficTypeDiagnostic: PH0PR13MB4841:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4841B9F9DD35731CEAA23A0AE8E49@PH0PR13MB4841.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cQHsgRPShjP66pyUSWmedFDtgxVa9Ry9SVtlbNaiUU8sMlACTvcaxa03QpibqCogdDijCSuA3z8LKxJZrlkD90/Wxi5E0RAxRDUtRKzL64CvNxVtbmD4jUCca81bQZ8qt6FqXU9oChhFocVMoAXgvBlyqwTBjpPmAH4tob/KbYIiODomV5WPUbabLRy3SrWv0Yit3YDQBSqbwjYDRcOsyA/g5iIT1lywcKNr79vUpZpkyNBqXf2aRRjVMwlJvWAtTuz2dwUtKyqEj6g2H7d50lDHU/VynZx+hD0GeVy8nHOdmReQM0kcFCLlkIrq43RwQ4YIDUVVXgv5LZTTRVh0EPtSMKpXFS5FrkFYw6O5XcOGGrQkoiA7urkIGH81D8P8sz1PLfsKpiajo4Se7oQxk/MRdRHGRt/ptB/QMzvftvyeBOPOy4Bg9SlJKgqvTdmY6u8kafHbLCvB9ZoH6Ffl8xLtR/KTRqzz4qYzN+VE+SUOupzqgwabIeS1ZV0S/R3RJZQiw3EAsX0KzktzG9fByz1O0SGqb3GBZhsy7vc1oOueiuOwnynNGYgnsOp21iHKNmiEGqxc8VKomAMfcswLrILQNKH0HszHosPo8WXqD888Yv8HxZW9SQHJj5qzdO6o6EEaB5PR2v75uUPUS/OKug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39830400003)(136003)(376002)(6486002)(86362001)(8676002)(6666004)(2616005)(6512007)(2906002)(54906003)(83380400001)(36756003)(66476007)(66556008)(8936002)(1076003)(15650500001)(107886003)(66946007)(110136005)(4326008)(186003)(44832011)(38100700002)(508600001)(316002)(52116002)(5660300002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WxFn0a5RT/g/xWaSkFLH4JV8CMKpauMKbpQtW6XdjIuEtOs7+4qmUfeUkpjJ?=
 =?us-ascii?Q?xsimJJLEP9/V7r11qk6tVzfW4Dh/rjHsCQW/OqbZNfye4eSui8mDMwoplWIo?=
 =?us-ascii?Q?t2ksSkRSAzJdJhZF/NcDtBmKYoMDTs0C5B0/qtS7C0bWuvOBwONZA3qAlcBw?=
 =?us-ascii?Q?uhYtdF6bW/73bOQ4r8pnX7gLsnPImiLYBGmRa47GDRG9zvm7EqSY08ogPp3r?=
 =?us-ascii?Q?C9jhkt/6wu4pamAR3a+h1pcmxou+edT3tfsHWdrxaMGPVlIgigc0w0Nht3/4?=
 =?us-ascii?Q?pLOKGHML3afNT5Ac9k26AZdxw+/vmuNhIgHEaoiZMDrjchlt8vcPQOMPEJM2?=
 =?us-ascii?Q?bkVgr/WFs0Dew4eTdybDeJB/XYMm1rYscjJbbj6UjAaYFIPkDuh/30Z3tRIb?=
 =?us-ascii?Q?tawcL/e78R9VkS+LkpKGi6iLVYn3Q61T29TGmD+U4DB8H8gdGt7z2d5Sl7nv?=
 =?us-ascii?Q?ILhhZu6yCJzkVqK74HTCTpRTvv7apEKx0c10VomoX+iN5aMaUIVK5Mldsdhv?=
 =?us-ascii?Q?Os5lu4mSKsPXklD7VHWveIizZ5mzwFiV+HQ1ybFjaxlMUTZvDZ9r16Tte2Z/?=
 =?us-ascii?Q?ZdxBCNQ5dy1Us4l6ZgIEn/jCk1g0+TlwICDLW2G8Starj9EftDgN7wQrIF8F?=
 =?us-ascii?Q?qiqa+MdG9Jnof51Q7MAHYpKpVB0idkZiXVcL4796a1jCN28JO1ufiqY1KqV6?=
 =?us-ascii?Q?oVTGkgxhg7F4Zmdiu4QuEhe4EDXtP/YAz63loqZrXyWWyOi0W3QPHuMUixwK?=
 =?us-ascii?Q?tRq6EUo9mo2uKVhJxmjwRxIYwfjDgdV7rB1/ZGulozD4CNP0NuIzBou9mCI4?=
 =?us-ascii?Q?icbeKOop6HWKoX6osx1wpXrrta0LJOOcYZ1+VWyavTQE7Gv+f1qnLMJC53n1?=
 =?us-ascii?Q?fn80YDbnZo/vajz+ruZBBSdDjWkqSjjhsrMPJtMfc7csYezSPbFWA0ZJxC0M?=
 =?us-ascii?Q?00zhCVMrp4H29a0X1K/m5BY8+l2AaJNNtg+9Ddj3y5lDL7+8zSZNygmRoPv0?=
 =?us-ascii?Q?oEkO556EVa8bdGmeZEY6Zu5Xe4Qi0QuZQnZ+YiqxIwu4e7zO17NY5CrxrUHE?=
 =?us-ascii?Q?k7vTyLfZYHqBun5Czv2GSaXYs9eMCAkyXZtfh82ZJ+wxcDXYYEQEPqXyUoZH?=
 =?us-ascii?Q?407ybwibsFO8QrK62iLrHC8AffjTfGrSXe6FZ1A5rPfTj2OUHOMseZtKyc0I?=
 =?us-ascii?Q?Dne+9Ex00X1P13ud1EOQp7WjXZEHUU07Ozg229wq9x+eBifqeVYgQYOfNE17?=
 =?us-ascii?Q?HOVH75TLxrSe5JMpMDyHyauN0aIEFR2pDo/6/8CBQSOj0yZa7nGKhtHUUoof?=
 =?us-ascii?Q?v4geKKwp3M9epsiYWaTqLsMav/tELpYfHkZWkqzF04w4NHmCrUEgZ8/+USgi?=
 =?us-ascii?Q?qw2P9xZ87Am+UN3aqC0hGkbJYmXC?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 534a7ce2-6fdc-4acb-8c49-08d94cf1dfef
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 09:19:57.8727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ODfOAY1cBgb0HKDooF3ljtdsepAs6Ku+wXeBb7c64wHSxOON6Mvffx3RodLklgu5uLHuywFE4R6rGKzH3ltiMHD23hXyUc/DYQGcj12W9CI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4841
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

When collecting stats for actions update them using both
both hardware and software counters.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/act_api.h      |  1 +
 include/net/flow_offload.h |  2 +-
 include/net/pkt_cls.h      |  4 ++++
 net/sched/act_api.c        | 49 ++++++++++++++++++++++++++++++++++----
 4 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 086b291e9530..fe8331b5efce 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -233,6 +233,7 @@ static inline void tcf_action_inc_overlimit_qstats(struct tc_action *a)
 void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
 			     u64 drops, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
+int tcf_action_update_hw_stats(struct tc_action *action);
 
 int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
 			     struct tcf_chain **handle,
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 26644596fd54..467688fff7ce 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -560,7 +560,7 @@ enum flow_act_command {
 };
 
 struct flow_offload_action {
-	struct netlink_ext_ack *extack;
+	struct netlink_ext_ack *extack; /* NULL in FLOW_ACT_STATS process*/
 	enum flow_act_command command;
 	struct flow_stats stats;
 	struct flow_action action;
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 03dae225d64f..569c9294b15b 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -282,6 +282,10 @@ tcf_exts_stats_update(const struct tcf_exts *exts,
 	for (i = 0; i < exts->nr_actions; i++) {
 		struct tc_action *a = exts->actions[i];
 
+		/* if stats from hw, just skip */
+		if (!tcf_action_update_hw_stats(a))
+			continue;
+
 		tcf_action_stats_update(a, bytes, packets, drops,
 					lastuse, true);
 		a->used_hw_stats = used_hw_stats;
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 23a4538916af..7d5535bc2c13 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1089,15 +1089,18 @@ int tcf_action_offload_cmd_pre(struct tc_action *actions[],
 EXPORT_SYMBOL(tcf_action_offload_cmd_pre);
 
 int tcf_action_offload_cmd_post(struct flow_offload_action *fl_act,
-				struct netlink_ext_ack *extack)
+				struct netlink_ext_ack *extack,
+				bool keep_fl_act)
 {
 	if (IS_ERR(fl_act))
 		return PTR_ERR(fl_act);
 
 	flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT, fl_act, NULL, NULL);
 
-	tc_cleanup_flow_action(&fl_act->action);
-	kfree(fl_act);
+	if (!keep_fl_act) {
+		tc_cleanup_flow_action(&fl_act->action);
+		kfree(fl_act);
+	}
 	return 0;
 }
 
@@ -1115,10 +1118,45 @@ int tcf_action_offload_cmd(struct tc_action *actions[],
 	if (err)
 		return err;
 
-	return tcf_action_offload_cmd_post(fl_act, extack);
+	return tcf_action_offload_cmd_post(fl_act, extack, false);
 }
 EXPORT_SYMBOL(tcf_action_offload_cmd);
 
+int tcf_action_update_hw_stats(struct tc_action *action)
+{
+	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
+		[0] = action,
+	};
+	struct flow_offload_action *fl_act;
+	int err = 0;
+
+	err = tcf_action_offload_cmd_pre(actions,
+					 FLOW_ACT_STATS,
+					 NULL,
+					 &fl_act);
+	if (err)
+		goto err_out;
+
+	err = tcf_action_offload_cmd_post(fl_act, NULL, true);
+
+	if (fl_act->stats.lastused) {
+		tcf_action_stats_update(action, fl_act->stats.bytes,
+					fl_act->stats.pkts,
+					fl_act->stats.drops,
+					fl_act->stats.lastused,
+					true);
+		err = 0;
+	} else {
+		err = -EOPNOTSUPP;
+	}
+	tc_cleanup_flow_action(&fl_act->action);
+	kfree(fl_act);
+
+err_out:
+	return err;
+}
+EXPORT_SYMBOL(tcf_action_update_hw_stats);
+
 /* offload the tc command after deleted */
 int tcf_action_offload_del_post(struct flow_offload_action *fl_act,
 				struct tc_action *actions[],
@@ -1255,6 +1293,9 @@ int tcf_action_copy_stats(struct sk_buff *skb, struct tc_action *p,
 	if (p == NULL)
 		goto errout;
 
+	/* update hw stats for this action */
+	tcf_action_update_hw_stats(p);
+
 	/* compat_mode being true specifies a call that is supposed
 	 * to add additional backward compatibility statistic TLVs.
 	 */
-- 
2.20.1

