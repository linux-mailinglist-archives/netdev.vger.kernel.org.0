Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0FC19496B
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgCZUqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:46:45 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:8149
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727509AbgCZUqo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 16:46:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9175vsZL/kPZF6j+wKoo/8t3/pZoM+bV++MtnEdIOTnvkh/PEYqwiAio29KeBVwnFKT+y6jYQraig/GA1vFaz4166f1gfod/fG/W1bxuJJzr17Kkgqir1a3MEmavpSF0ATnzPjZjXdsOuVcP71/x96gTireI+SDd6XscWLcJqqkPA5SL8rDnCwGXRr/aOS3/KZLJ38icZH5uBVxErjmwBloZ62+L9JHIdtNAbxo7bUQpm+52Pl2ffihuKmb60WiDZeT5KJk8dDwxOL5Y/35Mg5rGyD9YMF3K72UKnbaZwgrsXkCbq7cMQRbIyeL4m8RvIl54XEuUJ+PcZnkMfKuOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVnC72YRlrPPKyjtFAsIfR4noWvq9jwqBYXSa6eFYg4=;
 b=h8y3h4Uz5mmk4lDQa8w1HkEQMkdoz+w9kaIltbtgoSv5pH0IVCowFB7KmxYz71fWbW1dsyzHNErVLLrfUL0QQlwc50EQe+/+QEcoOov8Ux+jSdCqHxuEcC/05xiKCl4MH077cqg6PkWCLaYVFfMkxtuYralVRMRafjJBh/JTA+nNNOEZ9iXijlQ5zO80tghrU/AZxOkZrU8MTAsLeXTHUbu64OFhsMSLz61dCEhiEeCTv8sXeVR9vvTm3zN2eC8Dhpy6zS2BACtbNPlhQ2hpNikjdfytWwasOAIHHqlYYgkN+WkuFJURXIbYbqzw7R3E0Fa6cB7YCiLNwQLAXJCv0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVnC72YRlrPPKyjtFAsIfR4noWvq9jwqBYXSa6eFYg4=;
 b=EAzMmltU4khnxJmlXoa+34m86TNJZm6xKlZ4khDi/SDYuCX74MT+y7CtlQC/Em2ZMeZCBtdn7/sCPyu/itWdJRHoXBvxgHyD06LjPiyls+6ccIT1bL/coxT/0FltL70yZ+VsN7IEktGoCtdATczVqhomVQgjnKeJwicJF3REYL4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 AM6SPR01MB0020.eurprd05.prod.outlook.com (20.177.39.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Thu, 26 Mar 2020 20:46:27 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 20:46:27 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>, idosch@mellanox.com,
        jiri@mellanox.com, alexpe@mellanox.com
Subject: [PATCH net-next 1/3] sched: act_skbedit: Implement stats_update callback
Date:   Thu, 26 Mar 2020 22:45:55 +0200
Message-Id: <acfca1d05e4fc40069167f38085971d9cf6753c8.1585255467.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1585255467.git.petrm@mellanox.com>
References: <cover.1585255467.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0043.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::31) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR0P264CA0043.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 20:46:25 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e7529450-9c85-4201-1eac-08d7d1c6c102
X-MS-TrafficTypeDiagnostic: AM6SPR01MB0020:|AM6SPR01MB0020:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6SPR01MB00204B9377F4DF7F51590E55DBCF0@AM6SPR01MB0020.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(26005)(66476007)(86362001)(107886003)(54906003)(16526019)(956004)(186003)(2616005)(5660300002)(66556008)(66946007)(4326008)(316002)(52116002)(8936002)(6506007)(8676002)(6512007)(478600001)(6486002)(2906002)(36756003)(6916009)(81166006)(81156014)(6666004);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WPu02kQ00Njwm4Z1mOTgzY6SFmIDBNOsrFK/8ISb2L2yKchO+Xr3qwHUYrBZFtOQUYHetMuJiF2sI2QPd+pQS1RbxtNhP5w2s8o1fLhw2yZzmVjLhrzhWrHQAMe/OvBPdQ2R485dv1SLG0zZJEWn/P6WkszX2w125RzGqloGzMj+eMj4N/IShqHPRyas3TX50i/IA/OIHG1aeUAhmqNmrwIxfIqO5cmvMGR17XGp6lDGf3pvQKXsaUSGlpzwPxXv/KtP+6rbOOqrnT2HkRrfiHdBHdi6A0UvjYJ0znK2GI29xtSwPrUGUYY3RAxk8vBBEuGA1Yo6Uyo37wUNtivKwZmC/29skRbr6FHyuxmkJVKaHUsHu88E4Kym4ziuN6xZH88yAuKXvxRQjbCBZaBtCLgNCuaamSxkkgMutacWIKy9Aux6Zfuzxqs0B8+1NE0w
X-MS-Exchange-AntiSpam-MessageData: 3uwNT57Ysm7jmJUaXazUbrb3eRkHc2PHt/K8JjLzEwy6wCaTdSHEjZdmTHXqmJJCxSzFXKNcVRY7+5SAKQ0vHGGj8dJUMBfM1Ff0Y31y5PWLotlgW9PjuvpTUkqlL+tw10k5JSvYlqwumke7jZ3a7Q==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7529450-9c85-4201-1eac-08d7d1c6c102
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 20:46:27.1274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1sPmKsRFPiLf0KUfW5QU4WwqrMSfAc20gKuQ2IpRTf3o5VzPRyeLABLUmxux/PWiro44/DN1VSOOOdsx1IrENA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6SPR01MB0020
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement this callback in order to get the offloaded stats added to the
kernel stats.

Reported-by: Alexander Petrovskiy <alexpe@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 net/sched/act_skbedit.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index e857424c387c..b125b2be4467 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -73,6 +73,16 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
 	return TC_ACT_SHOT;
 }
 
+static void tcf_skbedit_stats_update(struct tc_action *a, u64 bytes,
+				     u32 packets, u64 lastuse, bool hw)
+{
+	struct tcf_skbedit *d = to_skbedit(a);
+	struct tcf_t *tm = &d->tcf_tm;
+
+	tcf_action_update_stats(a, bytes, packets, false, hw);
+	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
+}
+
 static const struct nla_policy skbedit_policy[TCA_SKBEDIT_MAX + 1] = {
 	[TCA_SKBEDIT_PARMS]		= { .len = sizeof(struct tc_skbedit) },
 	[TCA_SKBEDIT_PRIORITY]		= { .len = sizeof(u32) },
@@ -323,6 +333,7 @@ static struct tc_action_ops act_skbedit_ops = {
 	.id		=	TCA_ID_SKBEDIT,
 	.owner		=	THIS_MODULE,
 	.act		=	tcf_skbedit_act,
+	.stats_update	=	tcf_skbedit_stats_update,
 	.dump		=	tcf_skbedit_dump,
 	.init		=	tcf_skbedit_init,
 	.cleanup	=	tcf_skbedit_cleanup,
-- 
2.20.1

