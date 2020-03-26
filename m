Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9743519496C
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbgCZUqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:46:48 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:8149
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727611AbgCZUqs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 16:46:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJVbH4oH8ERzKrigwj7QBSHPQBhZ1U30rNkvSemjRcKJzMpUwF9JRmPwlTjQ+1ddabqwyCSG7acQsZmQ1Faa/dTEITN0pTUs+toBX5h1+DgR3o9ALnGXT1aYuRyZpUbfQ/Zv4+6YUw2oqlpeq8QtKL2rW45Is/NUViEVYfbNmOHiM/fFXyoHBr5LSyb0Jb8t/BbNSTd+NiM3l/FgxHXAhsI1E4GmNbjhKLBJYxYmp4kHeTloXDwtxfBAOjrPjng3fcZZFGBBZAE6M9JmJnlGiXU6dWYjqIkv8pI8/VZMp73FRBk47OloLlS/jiUvDdHNYYSSwdmHZcbxHKXCGirMJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82KLTuZSw/eYa72r16IMQfWGtoIdHFC/iGzQE3z1X8A=;
 b=RsnyGM1ojEthH2OR8NNl6YSSQVCt1FXp85fwMhSCGDJOxB5lIoRM0FLRmYbdkhEW3KYBdV2zoiA4zr+lMXHO81kIDXXP8D2PSeiCa7zJQoOPjxUtu/yF9Cb8tF19AqxJIXbCFxNZx5/nqqfrk1v5dTnT1RK4xzxEfvm4PCnxSYe3zqdKod1Yt1c6UpQndT0MXQFkqUhUwIJbXoJF8tNupESubSKhtoiBPQD0QNAflmm/R7lTdEewwUU+RPSlEhUQw5Iyz/nqjZP4rMYTetUl4inGir92CuOod4X9vkHM+cHL/SVU2JeG4Ik31GpfVvAq2FA16+6MAi858J/HUqxnCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82KLTuZSw/eYa72r16IMQfWGtoIdHFC/iGzQE3z1X8A=;
 b=mqw2h5k/AGg6x1wNSXvxJJ8bsF/nhfnktsNXxQBv/9c+N0yxJIPHWPnhUquSxAS4btqiWunHlchSfThdxYIke5gcAPu/hrDGaU8aD7hjqYSqer/2BELBJvk2kpMg9t5J4gJ23DgR/jMtncgwaD5nA3+HrVikxt1o2NGTFw7zjk0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 AM6SPR01MB0020.eurprd05.prod.outlook.com (20.177.39.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Thu, 26 Mar 2020 20:46:28 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 20:46:28 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>, idosch@mellanox.com,
        jiri@mellanox.com, alexpe@mellanox.com
Subject: [PATCH net-next 2/3] sched: act_pedit: Implement stats_update callback
Date:   Thu, 26 Mar 2020 22:45:56 +0200
Message-Id: <f77ddd0b2fefb282b178a56fd6f608f01cae63ea.1585255467.git.petrm@mellanox.com>
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
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR0P264CA0043.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 20:46:27 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d86caf4b-64b5-455e-9643-08d7d1c6c1d2
X-MS-TrafficTypeDiagnostic: AM6SPR01MB0020:|AM6SPR01MB0020:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6SPR01MB00206A33C4FDED65442F6AF0DBCF0@AM6SPR01MB0020.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(26005)(66476007)(86362001)(107886003)(54906003)(16526019)(956004)(186003)(2616005)(5660300002)(66556008)(66946007)(4326008)(316002)(52116002)(8936002)(6506007)(8676002)(6512007)(478600001)(6486002)(2906002)(36756003)(6916009)(81166006)(81156014)(6666004);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Om00aZblELixTiGQ7QND/l4e/4Qd7fO6/aLQm0QoFwHqscdVO6dA+0FQeTbiqQbySN92vlOtSjvbaVNp39vKWcQO73hwZpLIud6AkX4vkogi59amKVAfFVfdOXE7oa8dQZto2Zc+dblc6d5H4VmwMRk/c6QLBSSeowg/l2GbG7fqhoZeFHWsrIZgUrueq+qmU0cE211o6FpG3fOeeout3hdOBYvfd5lEkM6hKp91jh4dHsvcuifkceX0K382YeMt3Aw/ivlWV6AdfGkAF3iURnOgGlRAyxGLt+b540Aybv5M2ZrbBYQcvgHgGSR6R4MrIp3dnakRSlYdiD2v0ID1L9QM+3djbV192yldgPn77w9ktaflQEguVVw253tOfk0od4x2LGqcWLqmJ1d2ya+srXDDzY78BgiIoFG1E1rdvJz6OodSegqiqbyLOGcNBroI
X-MS-Exchange-AntiSpam-MessageData: 7eHRkgSdUzHGW4R0udb2tgYOd5wNuX+weymllm82J5hmaABCX/pgJhGk9+Q44AFtLHusxBEROniDJ6qYxUp2uZcJDbeTn+T3EtGLKjFBev6ifPQ8D8vSZU2mUKWP89892UCTnklwuqhSo0WGd/uSrg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d86caf4b-64b5-455e-9643-08d7d1c6c1d2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 20:46:28.4286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bq+rWTd4MpYZPpZrnQVJw8wgJOBLmpVAXMI2JQJ7iBDEC0xap6SJ2xC/LK/rV4Z/8OtRT5u6mMjVMW1q3/njNQ==
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
 net/sched/act_pedit.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 3ad718576304..d41d6200d9de 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -409,6 +409,16 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 	return p->tcf_action;
 }
 
+static void tcf_pedit_stats_update(struct tc_action *a, u64 bytes, u32 packets,
+				   u64 lastuse, bool hw)
+{
+	struct tcf_pedit *d = to_pedit(a);
+	struct tcf_t *tm = &d->tcf_tm;
+
+	tcf_action_update_stats(a, bytes, packets, false, hw);
+	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
+}
+
 static int tcf_pedit_dump(struct sk_buff *skb, struct tc_action *a,
 			  int bind, int ref)
 {
@@ -485,6 +495,7 @@ static struct tc_action_ops act_pedit_ops = {
 	.id		=	TCA_ID_PEDIT,
 	.owner		=	THIS_MODULE,
 	.act		=	tcf_pedit_act,
+	.stats_update	=	tcf_pedit_stats_update,
 	.dump		=	tcf_pedit_dump,
 	.cleanup	=	tcf_pedit_cleanup,
 	.init		=	tcf_pedit_init,
-- 
2.20.1

