Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1DE3687B2
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 22:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbhDVUJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 16:09:52 -0400
Received: from mail-bn8nam11on2137.outbound.protection.outlook.com ([40.107.236.137]:54369
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236058AbhDVUJv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 16:09:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y901rCHkoT+/pvN32IyK+1d4ipg0iie2aUiMcjbJq0uHxeclz4B7wx8c9NQCY/neIIvK2x/P6WNXT9GDTuDBrZN622An56hM/tRUm9oHGQATjXskPTIRNw4jQwpCI2fVdQM372mw87WkNF2jA9UTB+db8DVO/nOi7jICqVIfhz9e1WpTHH2mt9XXBCx1QfBqsN3NcMypLqxgJvLEiR1Yd8LrD72mo1NVgqMGFeRSdSVlm+3AaRw5T++oaHJydgobshByaElssknSBn+94rFEiffx4a5yiVjNtXVicjKSnYxs/FkCxfkaMAdg+in6kWBeptlU5msgPMt9eouHYMXaVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HW1LprGcENLM0iygFhoPSwNAKzpzg8bogE24IZgrIcY=;
 b=bJobZnvhLsn/zHrsokTTd6LfXQAYlkacV8j5DhoMyF4glEwrrEt27kXnT61CJiQNf4ZxCl3qkDCFbXKIpw7pPurn8h1bDQrF0y1lpRFbKFSAXqCJX/zPkvBCXhF8wP8JTXLs5YovOsVIZXLr4GQAFFhto78RvNJzJBWf2Slqx1xJ74xBGUKm3tD/w+IRvfqrUN59275RIRqIIlvDtkCXeSYhurjTz1MlhFM1N56wxZ7JhE73GKw1zVCIBp+w6dS7l1+aRfZcegwSlS9ROibk9cNc1ZB03aBnbOUMjb3mqnWzChRd0cz2zUR9DPT1HWObF6ITcGrHIRXpuLtCgQGXAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HW1LprGcENLM0iygFhoPSwNAKzpzg8bogE24IZgrIcY=;
 b=Vf+lGyBas9rhxxMTFjSoiaVRV84h2ZVqvY1btvJW2VYRju+rkNHXUXlbNurE/ItfTYppx/og2+HO/uIhfvhk9J4DGCy0IhJN+WlKh+PsBjCl1OXBKDqrMc55Xl2JVQBjk65eb2jT8/xbvNcq+LXzKJxBOvVK9b2OrDTcwNPrkNU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26) by BL0PR2101MB1042.namprd21.prod.outlook.com
 (2603:10b6:207:37::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.7; Thu, 22 Apr
 2021 20:09:14 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::6509:a15d:8847:e962]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::6509:a15d:8847:e962%4]) with mapi id 15.20.4087.019; Thu, 22 Apr 2021
 20:09:14 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     davem@davemloft.net, kuba@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sthemmin@microsoft.com, wei.liu@kernel.org, liuwe@microsoft.com,
        netdev@vger.kernel.org, dan.carpenter@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH net-next] net: mana: Use int to check the return value of mana_gd_poll_cq()
Date:   Thu, 22 Apr 2021 13:08:16 -0700
Message-Id: <20210422200816.11100-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-Originating-IP: [2001:4898:80e8:35:c7fc:2a33:51a0:f7f3]
X-ClientProxiedBy: CO2PR05CA0067.namprd05.prod.outlook.com
 (2603:10b6:102:2::35) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:37::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:35:c7fc:2a33:51a0:f7f3) by CO2PR05CA0067.namprd05.prod.outlook.com (2603:10b6:102:2::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.15 via Frontend Transport; Thu, 22 Apr 2021 20:09:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f595af2-ab2e-4022-a096-08d905ca8003
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1042:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR2101MB1042D7CB8AE662EF30AB00B6BF469@BL0PR2101MB1042.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AGQ0lErs81OaWh/be9nKqeLQ9x5x1Id0eXtin8BDqoxG84oIEh6kswBMMMgmGAkCkCuJQzXcBa4Awu/38QeTWCTgKFXxT7p94dKb8JsUBfe9mXU50T5HIfJ1kWHWtOO6/ybC5fCcESqtI/pke+gKdMBZKJA1yAVbgkSHGuHqxCAf91vSeWAR8pY3QzwkNDWOk5fgiUuRkJzTjnlFjTZWROcPsdoiRrfvTgc+YTp1b75c6unC6XBfXGnN8FDgpGo7Cz0uqQKbo+cNmHymWGt/eK1glX2cuA+AyFD9StQSV/x8VTioR9C9eKolJfjRVGHCcwNBcDC7+aWgsP9EjbPjhTP41OURmc3tbAmFrFCCQ95MjQH2t0u7xpUyie0aJjVJE7Kcu+7AczqCIw/hPyMMDJKvjqYKZNU/28BlOsfwuRP/DoPQe5DQk1XXOGP00D98H3ZLg1iXheEmzEujP9jHX1b1FkAxS3BZCaFrLbnfy2jZgjHjLi1eZMOJgYdlUDfzdPj91IYTLT5UvQyyN3338+Ggi1jfyJPd9KX1aroLsFhBp+r2fJofhXLPFN/VIE3CM6lvPJruq08RLPILLfO1p+8cgcaRRQ5RbJDVoYrwj2EUn3sBhKwfQ0EbkYyU+v4/5V1X8phIHnzDGp8ClvEdyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(186003)(10290500003)(5660300002)(921005)(478600001)(16526019)(2906002)(83380400001)(8676002)(7696005)(4326008)(316002)(66946007)(1076003)(6486002)(66476007)(66556008)(3450700001)(36756003)(86362001)(107886003)(8936002)(52116002)(82960400001)(2616005)(82950400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QSzr+4cDaYxJO4ru29LFIGjgoemjppqByrLDf3c7EKMzCHYaYMZ+2ZPBqwqK?=
 =?us-ascii?Q?kGU2B/9byBuVweDURgEYcGoU7w6OTwCtIEfpwzl3emTrDtBGMO7TlX8K78vb?=
 =?us-ascii?Q?4RybqmNikODoPEFcsbI3vlMphL9j33NVj6n3wMCdoO0cuMjhh3KfNhpSdygC?=
 =?us-ascii?Q?O7503beOnFX3PvgVQJR3Jkny2kjhv3LIt+kcgzKlTWHRj6Maqi9k4Zz6ic04?=
 =?us-ascii?Q?OR/nLftZfDxwZNIT91WQe5/UAAmMmNQlHro7JAIfU0TkjUmDV7R66WHbhBPn?=
 =?us-ascii?Q?NChMsxSSJxg06BUCC+DpnKwyedZtoZ9pEtmuhS9RK2ACgiefUnUg8Wf3NQW8?=
 =?us-ascii?Q?OPjCDVzYs/1QC3KY+ueHYB0y9FrQh67ouwa7tooy4ZN5uAozNMB4xtjPbRFA?=
 =?us-ascii?Q?Qlv4FkyyLeY+luztXbd7Zfi3S/y/KklF2jUN9+SUGgshJ5NZ6DuZZsGrB2YI?=
 =?us-ascii?Q?bxLgZgXunCG/zNO7mJBsRKw3Op6Y7qJS4hE/zeE0qS9OXJqjVM+uh4UW3xT7?=
 =?us-ascii?Q?x/9JoQvQgtDUsrO9yWn/01/m3vHLAMR7p3Gbwe04F14QzUBH781e9lIbKhCU?=
 =?us-ascii?Q?2sru1L3X14Up60yqyGWcjOAiy/pHmJ7e9iG+u4g/Zyo09a9noQyvjA+/2pnF?=
 =?us-ascii?Q?0WWqgfmy1uGFSkSW9jImAS7LMdt4ZaRRHE3SGZl/S203fcJ9EeOYjDN3aA6L?=
 =?us-ascii?Q?f3QlQUYgXLpu+ZleE/9q7Yy5QOJT7tHt2c2B9LIeSUn0/ps11bPVi/RXSzUK?=
 =?us-ascii?Q?abrvE9PHP+oMw686cOCbWIiObdtRPCebQdnsp5G5GPmgyFVfLzyNpXsuMC/7?=
 =?us-ascii?Q?MiILOaLiXdTASmyirMotEEL4v+Q1jJxI/D8weUbkBTcXEjkdtWWNrvmjtDRQ?=
 =?us-ascii?Q?Lf6elhbEl3qosv6xInPMTp1hxsYjtS+OBCkBBG6VFo+HFf+K4FdP650w9JOe?=
 =?us-ascii?Q?dVnubReWfx2LGGo4iW5RXEXyhPAr0PLH8+r3J1AvK4HTPMBx0nnqfoF+769j?=
 =?us-ascii?Q?xN87+pZYGGp6UEolyzajhCBQ5XPgqCTZ3+Fzn+vcakNifuJdj18xFzb3TyBu?=
 =?us-ascii?Q?RRcdXG3KM1qV5LbGSuETN0wRwBbdduH0Wryz07Pc5edREIs+QHTZN2xBKUCD?=
 =?us-ascii?Q?D+3JZQ4WEYTYdX6PU2kN26PvI/KY37yDEYHDc8+xR5uAIfDK5NumvnaBeIOz?=
 =?us-ascii?Q?Yd5+/rqIBa7y/2Axn4pgSxlEQKMNfmGopWd0ujWGlJpS8UbpVicQymosi3Xt?=
 =?us-ascii?Q?Q0y7giPAcKAgO5eVORGGktyRVZlNrqu5WCb7PJztnp8xW2J+e7wLkGcQ26oJ?=
 =?us-ascii?Q?udScS0weKsQmbD5falqVXcElGmTR1Z6Io7STm38XU0JmgvRfCwCXyj3yzWlV?=
 =?us-ascii?Q?nXYGCTfZsvqXs/dqlwpvzWLUBPNz?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f595af2-ab2e-4022-a096-08d905ca8003
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 20:09:14.7165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LtQwxVL0idLmLaNqxySH3wtV9Tkt8H7JydbKbTxlM0cM8hUb8kG1LG3IPtPn1GnZoLCQaNzJZwGxQS6WwtrI+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1042
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mana_gd_poll_cq() may return -1 if an overflow error is detected (this
should never happen unless there is a bug in the driver or the hardware).

Fix the type of the variable "comp_read" by using int rather than u32.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/hw_channel.c | 2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 0cf0322702ed..1a923fd99990 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -283,7 +283,7 @@ static void mana_hwc_comp_event(void *ctx, struct gdma_queue *q_self)
 	struct hwc_rx_oob comp_data = {};
 	struct gdma_comp *completions;
 	struct hwc_cq *hwc_cq = ctx;
-	u32 comp_read, i;
+	int comp_read, i;
 
 	WARN_ON_ONCE(hwc_cq->gdma_cq != q_self);
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index a744ca0b6c19..04d067243457 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1061,7 +1061,7 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 static void mana_poll_rx_cq(struct mana_cq *cq)
 {
 	struct gdma_comp *comp = cq->gdma_comp_buf;
-	u32 comp_read, i;
+	int comp_read, i;
 
 	comp_read = mana_gd_poll_cq(cq->gdma_cq, comp, CQE_POLLING_BUFFER);
 	WARN_ON_ONCE(comp_read > CQE_POLLING_BUFFER);
-- 
2.20.1

