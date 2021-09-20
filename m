Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CD941290A
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 00:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbhITWxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 18:53:02 -0400
Received: from mail-eopbgr20052.outbound.protection.outlook.com ([40.107.2.52]:12372
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232282AbhITWu7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 18:50:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/x/waGnAJB79xowtYHhgJFrZJKWecoj5wCJcEz9qGe79p9XzQNvvU2kMjoK5reDaMkfOaH1Gxlqi5ypaRkCRFQATuSH/qom4FeKUe/xhvgjdo5sD+TZZmRTg0DCBgb1isEqmenFqysKb88IKx6QpnydqEgc7i+Coo6XrNXcyzeD9xbUnWW3g4egVa7SCvmWMTnefhSO6rGbHjptL6v1V5ZWFkEcIM4aS8mRnNUNvvDJq0uUJL0P7JAlGgtRuAGeQkfTxPZqhsG3eHZgfushl3G9lTiD+0x7R1QNRRzkeomy2jus4P5ocUEzxdtcj0xqqL6I8o7fsqrhjRxZfTwdUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=w2qF59zglM6nj70fL6/N+jbbFUykW71UD0mwyqvedPs=;
 b=J8cwr9J9p3XRD6X0uIOHSyKPXWFekunmTN3SuK3lByMfwgV+vFCBeFF5pbI4L8tWOKLhdVtJwP6J/jN6702Q+TBcCG810JR4iPfy+X83rio78if+eM5nvTUt+DEi91NE+RG9gkWZUeW7IKgtEl6oLF773OxhWmOl5VpclTHbUoJmsMdUoJBS90+aUcq5edntlpf+TU+OfE5sQ1n9duUN4BfYXXyveIf2/PbO5X/JZClQy8lUtHrjupFicKd6YTdGIwg9JnlMs6ChNBIXUHpbYT6+oMqKYF4Nf27BfYajXBEg94oi5traQcBfY4Euslv16IbKUzkS/pGKmdyeTks01w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w2qF59zglM6nj70fL6/N+jbbFUykW71UD0mwyqvedPs=;
 b=maXEQd/ifpL7JPB1CC+3msF39fEu+uND6pxATDS+k/i1mQsGOc2MWUCozTHp9LQK3dVc3O8ZvalzttAIRwKlU4GhiIAWs1Y9RBIUMznu5th83IsAGG6ghtkSjKsCFNvR2DFxLYyvpB2kKl7GF79uImFFFlBTreg2SKZskwy0mZQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7327.eurprd04.prod.outlook.com (2603:10a6:800:1ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Mon, 20 Sep
 2021 22:49:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 22:49:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: dsa: fix dsa_tree_setup error path
Date:   Tue, 21 Sep 2021 01:49:18 +0300
Message-Id: <20210920224918.1751214-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR04CA0138.eurprd04.prod.outlook.com (2603:10a6:207::22)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by AM3PR04CA0138.eurprd04.prod.outlook.com (2603:10a6:207::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Mon, 20 Sep 2021 22:49:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7146835b-7b38-4fb4-7937-08d97c88e797
X-MS-TrafficTypeDiagnostic: VE1PR04MB7327:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7327251F25AC67624DEF888AE0A09@VE1PR04MB7327.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:152;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pWuHDpenBUjmR1omJUwX2yDcvxrDoLVrb42c+kcaoakYh4fmnH45WrXeQipPmBRIho7P8N4twmTbBI6tYpI3zAVS4SMG6/OIm5EB+KzqgLYvJnlkaaGGTFQz4Bj2TJdygUJBIS7Gtov3tgM2PSsCYrKQW8sqLw4QYsFpCDHHuwtJsLwPlllt6ScOAgmmCsWgS0QQB7itWJCiz2xSW7F9YAmVbe5Ndv3Crpevci73rR/WQ2AFU+s2CenAU0aOSN8zWl0HjFHrkigwjrUwJqZfgW8NbYsUDWr96c37mOdW3E2eSUXB8lVcKYxUK6yEwqsopUzTzDFagP+pEchs1SPx7Rs4HMeTkw0J557fc9s+PrpV/6wTG0wHZwniM9zEpuPY+AXGfR9TD53QC1FVI7hzhmmK3ai2bS1pj38ko7Ti5p+S/AE6P8Dm+AjU0OwCVB5/9QU2uR9ncBdGSSIFAy5hGnN0ZvIg5jqHIaRNCkDh/vMhowUB1eXcLCioXlOB0TttRTKF1kHtn64xD6z7sokWvoxmTCudG53kvuOGtCP4BVWA6D/u9l1SGr45CHbdQTA3NxmVT8BS4i1wscj5P3JrjeJpmAnrYx22KLxEk/9BnPpQeFSANnU5up6oEcaNioNw4Bb/+KYtXBgKbkgc8e5j0Q3MvUX6Uwkyt24/yfSbP3kiNWw41+U30gERV7Yw1gVQIQXFQ8C7S4VR/GOwKThYgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(4326008)(38100700002)(54906003)(52116002)(2906002)(186003)(316002)(36756003)(8936002)(4744005)(6486002)(66946007)(6512007)(5660300002)(956004)(86362001)(1076003)(6666004)(2616005)(8676002)(44832011)(478600001)(66476007)(66556008)(6506007)(38350700002)(6916009)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eu6S+yQiBR3RJQXiujUhMEQ3XQ7IKzdtpmyHDav+1dgPx5rwtpyTE9sEcoVV?=
 =?us-ascii?Q?2iaX5qUphDvKvzfJwULhCBv2mH+qRIw5gMDnCmV7CACvmGMIAs8I/BRsT3Tg?=
 =?us-ascii?Q?DlgZXmIHuu5udd4Ro5xnEffmtT0fayBq9Fg4YLrfwX8OAcc00pTty0SuOCo7?=
 =?us-ascii?Q?m+p6El07E7sksO6oobkia00DsqgaCMTsARuh8eA5VRsH4Tv4WipURjhXiWEd?=
 =?us-ascii?Q?XkY/5ZBneGeDjhMNOb5RwGlpMHyHQp2/2p691titEMoyKjNNpTONHHYocoUH?=
 =?us-ascii?Q?OHZZ5rMZ48jdFxTGD9uXwQXoQwWLq39Mys1zPO1Q9AUJDP9bYzgaBLondLEG?=
 =?us-ascii?Q?mzMgG4MTg1eQqewTqtNNtjXzL8JmlBLEHfW4M540HpNqgTuK0JFGut5LH+aY?=
 =?us-ascii?Q?udfNopZfYYLc27MaWJdz9pr73c3kNNrjPUc8m2ZSku/oQaQTFNrF0uz/8zmg?=
 =?us-ascii?Q?5aJQ+3QhkZFD+KkRisZyHau/nbSKJGywBmUJVUbVNEItohxud+jtHoPAo2CE?=
 =?us-ascii?Q?dUFzqURDsvZs0GCOBi819nena5j1NnIo8wlM/gl/seCtHUahLxjkG5f7HF++?=
 =?us-ascii?Q?w2bjZfZdk1EinDfD+TRYUaJ6/uIETQjuBag1tfS7fKdozeF5QTEPNOrs0g/F?=
 =?us-ascii?Q?Qici/mnXOmgtov3pnD+/6EjvxKamL5LX5Z7bfPveWEBOfvSFJLil1QojXtHL?=
 =?us-ascii?Q?Dh/sRxI21lrmajPH+AQmNkLJz57HCf35f1sRblladXB6qs0UFBXFQbYzho73?=
 =?us-ascii?Q?B314u3SjUwVDM4lwQ0YH+p5nJFyIaW0/VLXZkFF15ctyQIwhYBDYmDe6frBa?=
 =?us-ascii?Q?dtWaYXqVfgk07ZI4BhPpqU41w62luCOKA1r4caFbwZN+dMiUp2j66cDQMKWm?=
 =?us-ascii?Q?OwE/bztky4qyS+h9Sxlu0U5q8X+SVw7DFJaevYQm7yln7avEX1U8IcG64eVA?=
 =?us-ascii?Q?MUnw2/H8AS/Z6UbMWUIuMl70iwQBK85Fb+YgbQk+2pJIRfB/Sp0OefdaJCfQ?=
 =?us-ascii?Q?Hm8NIjeN7uNNCkok+CkLopWUNABepuL643Ng6Uxub1N8xww7RF1Y/+mP/Ye/?=
 =?us-ascii?Q?kEEDDjFvOsSLfzoeaM6ReDr2a4ynoG1NfDs8MIc/ESCgkwJ3Ra6KbsS0vB/i?=
 =?us-ascii?Q?z8pqCuSJoPqFl4a/X5plnQEZ5ICYWCQii4rQE4TqhN8MfbaJBo7v2zDBvPrk?=
 =?us-ascii?Q?fNzTaN/YcuBib5V3xDCsyJ3yxIjOMG5yuMghtO/Q6jGf68xIU8zlHhjVOmSx?=
 =?us-ascii?Q?F16R1PR0X6nzc+iUmz0SdonP4/jj9O6QiP2sdXTQVxPL7z0wM+rxKue8pNQa?=
 =?us-ascii?Q?6SFzHQSGZ/J0fmiyHRb+tWMF?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7146835b-7b38-4fb4-7937-08d97c88e797
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 22:49:29.4455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CcEsxzB89/QbD7qKQGTa0nJcmgaBHR8/kT50uyrz9EFHr9AJHk1qiYaTq5H5KXE16HiXUqc/HpmsGChczz21+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7327
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the blamed commit, dsa_tree_teardown_switches() was split into two
smaller functions, dsa_tree_teardown_switches and dsa_tree_teardown_ports.

However, the error path of dsa_tree_setup stopped calling dsa_tree_teardown_ports.

Fixes: a57d8c217aad ("net: dsa: flush switchdev workqueue before tearing down CPU/DSA ports")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index f14897d9b31d..f54639a3a822 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1089,6 +1089,7 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 teardown_master:
 	dsa_tree_teardown_master(dst);
 teardown_switches:
+	dsa_tree_teardown_ports(dst);
 	dsa_tree_teardown_switches(dst);
 teardown_cpu_ports:
 	dsa_tree_teardown_cpu_ports(dst);
-- 
2.25.1

