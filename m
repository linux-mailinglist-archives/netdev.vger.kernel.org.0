Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C813B9E0E
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 11:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhGBJYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 05:24:39 -0400
Received: from mail-mw2nam10on2090.outbound.protection.outlook.com ([40.107.94.90]:15104
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230245AbhGBJYd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 05:24:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ey7HgyGN9CSilNBnxFOEoNvVifpOoADVmubSDsIIltKss44FPDlhf3XbbFiO6ssNaKimXXBVH0AyE5VCtesgpRmDtWPjLAjIx8S8U1Ycix1EQWUYW9Ys+u+NOb3NqtvE3rFL4WhogLUNdOUOade3tPN9+60pcDk9tOJCZYYGPj7Mp4dxMUNP5PVOcNZKUOagyn2FCHeyAPws/S9aKqk86SKfepVo/4kdGThpRfYpLFCQO2oOeukF8KcTqAQcUittUyXgKyr/fKrL+PXLkwcUl9MMkijvWOFe//T7nLUKPqH7AHSm2XsXPl5VoPMNe/b9ZwhJo6eRgfr15GExNVWosA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FDPj+sAbpQ+bk45cUpeknTA/coqgNfvhcw/k6eRDecg=;
 b=fWGvLRp82glq2cHkcBnV7wBXZffSx8akf2iVv2Emva8HVSSi557z9BxeAUFtlTLCiigY1wqPUEEpwvwoiWt3QQNR+0OFrexEAYAwUavSJzYiLhoEsmp/DVCfzdtgsPHtQYXN2fKit3EJOwuYoCYnltrO2HxuB6t2qvgerzBaePAhV6iwgVmIEDbIKdKWPOkk4JXU3OHxNyKMKbI6r0iKr4uxOJd87T+CXCXUmXplRSc/ZQkmFr1XBdqDUBYSFTOHPMG9A1RkMbDI1kRX8x0SrUU9CYHaMnE+MAGSeNqjt9x/N1YtvKB07ibtRyFFx/F7hUQXXUdLDRGeIG3dqv4TfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FDPj+sAbpQ+bk45cUpeknTA/coqgNfvhcw/k6eRDecg=;
 b=qFTUUTEUGojGNEnZ+RMcB+7edBFtb2pVkEaIsykXlE8ep8JqeaFLSh7UgcTVZIPGqBEGZGTKtKvWNEeg+mdhN//aE75+incAtOj2XpZaSEl4wlFjj8ilRE53WHYim5WA/VbVWJlp9ynx075rDzUUJXEq5fvlQ2naLX8At9tfx80=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4987.namprd13.prod.outlook.com (2603:10b6:510:75::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.12; Fri, 2 Jul
 2021 09:22:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4308.012; Fri, 2 Jul 2021
 09:22:01 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net 1/2] net/sched: act_ct: remove and free nf_table callbacks
Date:   Fri,  2 Jul 2021 11:21:38 +0200
Message-Id: <20210702092139.25662-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210702092139.25662-1-simon.horman@corigine.com>
References: <20210702092139.25662-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0112.eurprd07.prod.outlook.com
 (2603:10a6:207:7::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM3PR07CA0112.eurprd07.prod.outlook.com (2603:10a6:207:7::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Fri, 2 Jul 2021 09:21:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fe981da-fdb0-400b-bcef-08d93d3ad921
X-MS-TrafficTypeDiagnostic: PH0PR13MB4987:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4987E8F3660FE8F5E90383B5E81F9@PH0PR13MB4987.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mUnqDKl3LhQohuYZZNOeP0Ip2AuK0vm/RnorRz3eF2p0jc8vvL1lDRUCo28Yjmyp3z+JS/1i8CmPUFjr63KE3W9KYoHVkf5PIguw97hnEw+FUdqJNiO9w1B4PjclmSRhw06XtuZd8a5TQxfLTHDzA8HRDljM7TG7bXOT0eoBOsAS9FnrAYxW5l7HOBBQUqxqp3bQD4m1EtUQsFOXX0CmyG3p6U089cv7tMVHPTMJgtMR5fbcrStbW24jFUUqWoItq1dg8FE+gwjwCFjCHm1z/sakxl8Fi10pZx7JJ4imv6IHEO9rpMQki1f0CgppYFcdmE+/+ueOJtYY/uBv0nJd1Q9LIIzKm2SGhOCBjN5CPEecszTaWB6zoryzUZkmvJKi7flt79HSRPYNpTuSs+29f9cKd1u3Xci06mC6zC7gKz0VuQwZ7KX97+S2mvevpS5FjUqztAe75QphD4GqhH0Rf8NmIrukiBra0tiQXFsFXb85/haElA1JhWrexlGEL12ujiv4ilGoMJJfLRaw0P/OtZqLuTTM76pKt+SQ0sopHbZUDHbGOKCuK59bRMXKDxoHKN2KmWLIcqmRXFx6Ou7LzugEGvAZgfxTiWZtstiB6Lx+Zo0rQG+rbtUVHZqqoQM3uD8kGdKU08IjIW13hEh6ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(39830400003)(136003)(366004)(478600001)(36756003)(6666004)(38100700002)(54906003)(2616005)(110136005)(6506007)(2906002)(44832011)(52116002)(316002)(6512007)(107886003)(66476007)(66946007)(6486002)(186003)(4326008)(8936002)(8676002)(66556008)(5660300002)(83380400001)(1076003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sfAX/ySVvGWBag0S1QjsqF4WOr8qU2Dxo3eLNPrLtQE+Y+BR3j4rRlOtrpHH?=
 =?us-ascii?Q?UZco6aS4m+UN6KLBxEJgLkuWII9ujt9084BMhd8f7Q9fAL1Ca8ZCRy2VicJT?=
 =?us-ascii?Q?+TtbCMkD3i+F5PsyFOT5CPf4IHYmOTcIQy8BMTJuFLU2ZGQ6j8oQlGiJTXNu?=
 =?us-ascii?Q?Yxrd8l8PbzsnPjUiHbro3Kz7xs9fQAHHmkqghDeunt9FGlguKymdd/n7sUjp?=
 =?us-ascii?Q?ZQsaS1CST4DcHYwZFvOuTOHQxaJfOH3Ws/v12F/DJVPRIotEAGGPpOtnFVmf?=
 =?us-ascii?Q?uWxCZ8qz2itPrGSc3q83mAXUKQ1fZLX6EVaiKDiwf7UZSmV46cnfSAupNxMx?=
 =?us-ascii?Q?ypWRadtS3zB5k8Ms9LFOcriyhzO8r5UN8GJuKwvBQPlNQb1YbIj7ucs4YIvA?=
 =?us-ascii?Q?EZsTXQ8gmIc26OSgOF04SYgmabKSC8eTuFpfxiLPYLHkcXeQGVhn8McQ+X6J?=
 =?us-ascii?Q?VgVV7Fu1Y8Dp7OC9gGhyusWO27p7Kfitq9ZGlRtfeblbd/WQF/4D7xScMXFp?=
 =?us-ascii?Q?Rzt2CcxobPeLI4U5+wflA2ozy99E0ORakYeb7AOZAF0K/tUM+0vVHJVmUuB3?=
 =?us-ascii?Q?RPhvGav2Y4IrdLKxbKT/hVDFbmoO6bMVmLlmWJwk9Y0ctXXKMakcjl7/SVvi?=
 =?us-ascii?Q?vtdP+OQnowYCp/Kdqf3Zi1iFUYxyCLAqBzKt157pwD/+diSk8y9nkZyJYTPh?=
 =?us-ascii?Q?iYsXXzKvrplq2Oac2apmHG+E16A7j82vI7+p1+glIGvk8Vtf6Gv1I2rrdbiB?=
 =?us-ascii?Q?5nACGWgdtAYgvnHzKbXDYgrUa29uvkxvCK5s1L2PGz5MOo9niWcRy6F7WaFM?=
 =?us-ascii?Q?Rw1qwMOZrBP8sbCLjbdszW4oI2kgueytmBg4kxGq/9FcNsarbUSquYxwPTSt?=
 =?us-ascii?Q?EyE5CTZKP+CoJ71+TnI3ECEy2AM+MNX+lcnQzJD9qSVWJio7m1vf0yyqapio?=
 =?us-ascii?Q?k6DsGPUE8PTasTJKib2yeqM24/9UxUr79NdNFPlQ9IGPuGyP078wGUsOKFSB?=
 =?us-ascii?Q?g/TndgCjz82BeGWElIK9Ep4ibS9x5K7VigwMK0B7QJMCVfGInJtAf51hYFp+?=
 =?us-ascii?Q?yDakoDsfASV3yrAWSQdj6tiLG+hiL6ClSfvFyXyecZIhwcIvQShsSrS9hDiB?=
 =?us-ascii?Q?nC+G+tZY5zZEOjkFMYhXa4K2exqFfKqeRDWfZE+CjIHSldZG7bgnB0dAYLfs?=
 =?us-ascii?Q?NKR/o3QT9f33pDTjUpTNsA0udmsZdbPnD+ypCVwGHlT9yC1My1L7GzhFMBYu?=
 =?us-ascii?Q?uMwn1QM92N5D0pzjNVY5qwEiLGeO+HDhgQ7cT+SvqhpK4Ev/Z5o1zWSlXHkz?=
 =?us-ascii?Q?FxKuotekd+lhwAWxAhNBqT9D/d2l4Mhxd9taAqw0NMUkCwKOhyHzb3VMs3Fr?=
 =?us-ascii?Q?z7TTn54dxMhJYpscLdsUO5oA86lT?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fe981da-fdb0-400b-bcef-08d93d3ad921
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2021 09:22:01.0776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QgS01Fmw2/q6pTJZaQoOyiuvdKs7hTW0iJIFNn2LlgxEhdJRneBHvFO+CvwQQ9nXM7iF4hesdteLz1o0sSfDRTklBOvcNm963RuL9IoshRo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4987
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

When cleaning up the nf_table in tcf_ct_flow_table_cleanup_work
there is no guarantee that the callback list, added to by
nf_flow_table_offload_add_cb, is empty. This means that it is
possible that the flow_block_cb memory allocated will be lost.

Fix this by iterating the list and freeing the flow_block_cb entries
before freeing the nf_table entry (via freeing ct_ft).

Fixes: 978703f42549 ("netfilter: flowtable: Add API for registering to flow table events")
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 net/sched/act_ct.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index a656baa321fe..7ec443ca48d6 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -322,11 +322,22 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
 
 static void tcf_ct_flow_table_cleanup_work(struct work_struct *work)
 {
+	struct flow_block_cb *block_cb, *tmp_cb;
 	struct tcf_ct_flow_table *ct_ft;
+	struct flow_block *block;
 
 	ct_ft = container_of(to_rcu_work(work), struct tcf_ct_flow_table,
 			     rwork);
 	nf_flow_table_free(&ct_ft->nf_ft);
+
+	/* Remove any remaining callbacks before cleanup */
+	block = &ct_ft->nf_ft.flow_block;
+	down_write(&ct_ft->nf_ft.flow_block_lock);
+	list_for_each_entry_safe(block_cb, tmp_cb, &block->cb_list, list) {
+		list_del(&block_cb->list);
+		flow_block_cb_free(block_cb);
+	}
+	up_write(&ct_ft->nf_ft.flow_block_lock);
 	kfree(ct_ft);
 
 	module_put(THIS_MODULE);
-- 
2.20.1

