Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023323DD4B8
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 13:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbhHBLhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 07:37:00 -0400
Received: from mail-eopbgr00051.outbound.protection.outlook.com ([40.107.0.51]:44814
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233255AbhHBLg7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 07:36:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=joTm8tGI5j/wF0lJB1LnrLneU9PBZk5jgInv3ANDwF6CSouLTrQpsbAWbKJNArz+KssmKV/6xn7pV/uOdZzLpyDkIEum4f5q+7zfMNgJ5EUjGAs4yQpKbXaJtzYMMojCPWgsGMz4yiiXi5FddNkxwV7j8QPEpEa1fjeI1LfuIf0XfBfhkoP9emidgG8WaxSosd71daSClPTQmK9b5YdfiQINdAgTnK1hc1+UxGW4x+m4zBhK4UcjjHI67dDIyhOaRShNIqww1VgytwloS97eWl7dBY9mGXbogL6El6BW82WWgp2ni0+6S2qx3oHRqpDY401B8b1K5vM8duVSPY828g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yna7iRO9WXs8X4DbwZIW9DkTZl4CcB2f1c078iipS5g=;
 b=F64GuXySU8trqwUZ246Ouui40wvJxlTI75f+9jG4/B2dXyfoOfM35IvCdxoukY1WPPOUSYQCQOqS4QvgPyArj93Yr3CLonFCPmdz+2mQiF3gCJIlHksL4omS1lP+jhpXU2cE3sC2ONIJ5ZUhnK/WBJmn0eU18vruK8JoFiNkqDth28e3B0Zxkvx5Xv60GNRN5FDjyv9Qd0NLMg9OJ8RYr6J7EB6sUOttftruWIC31pasoWmzGsNXMQo7TW++r08uO/tgH1YzWZuFfVEJ/ZpuRA411u0+J+tMX3byTnkfuJTX1GqwSLIJMLDB+Bcx3ozdGntRQ0KcrnBjSd/5ZfjlpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yna7iRO9WXs8X4DbwZIW9DkTZl4CcB2f1c078iipS5g=;
 b=PVoyWDBy4EbNWevoEg24Ave7CL4YHxq2zePpwc9X1Nt4nZx1moXeIH3wckNbhkdtSZW74gix4UO+ls00Rb6aQKbLhUYxyO6RGuFEGbmHQXPfFcjUTwqtgljeftEkW5CXcWVXzNgmzbGCWPvyXFdtOMp6ErkyV7M+RParMR3sXGw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4685.eurprd04.prod.outlook.com (2603:10a6:803:70::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Mon, 2 Aug
 2021 11:36:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 11:36:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@resnulli.us>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org
Subject: [PATCH net-next] net: bridge: switchdev: fix incorrect use of FDB flags when picking the dst device
Date:   Mon,  2 Aug 2021 14:36:33 +0300
Message-Id: <20210802113633.189831-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0029.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1P194CA0029.EURP194.PROD.OUTLOOK.COM (2603:10a6:803:3c::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend Transport; Mon, 2 Aug 2021 11:36:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 226aca51-d4fe-462d-93ac-08d955a9cf7f
X-MS-TrafficTypeDiagnostic: VI1PR04MB4685:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4685A64ED0E8D4B2EA9B35B9E0EF9@VI1PR04MB4685.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5bo4T0HHUhIP8z558NbSa87fi3hHjGm6zTRg9lssTpyBp7Z/LwgyVVtk4enZTkw3TOnX+0h1f+v3nMQe09D7csa3Z7c1Qf+xg8QGVJF9V9AwoDajNRA0Yk5XDFEVmeaI7aaKfOMVKVebwvpkITcSEWtblbgduzvYCMQCEd2Ja09EkbBqwoUQRltty3Y9xAl9U9lLoaf0i1ReZLvBb/jLoK3TWwBCUQgzoVQvQThTHMOFXOQkNK54AedEqmilf20bQ9LDiVe7VlkDSZ6NIgYhU4pMTE6Mz3KE15NGyqoGhNWmYpQUA6JKMYNne3eRVngiLRb0/pag9nESjDzRZa47ZS0d5m3Qi5MCIq/acT5QPP7k0bEjVXyORSNXvJ6Mb/E+pG5x5CQCsZKP2IVgRZmij1ilqK/eeXPAuKN6cUfeXtchalPmEwSj4VLcPyb1t7kW2JRW32KETHiAPXPoDPqo/BoMD2keZ8e5FZ9e1kOeU7T501gq8C4JLiegv3XodTVfu6rOlYTru+1MciEMYdJLwi5YBQ9zfpQf3Zp4LbVfhBP1M6vgP92Ihxq2NPWTiD3RZBhWGAwTt2ZztJZxweUVRz+vfatufpf9M8nOA/rEeQgM1Kb+AO87sEleSjZQyaCssos4vf4exfNNnC3+8VcPXNF9WZX7/KqMNmby21P4NElUXzHGN0ZADiYiAn0YXW0Z/CK7Exe9LIeKlXMEUHVnlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(346002)(396003)(39860400002)(38350700002)(4326008)(38100700002)(2906002)(6666004)(8936002)(66476007)(6486002)(66946007)(66556008)(83380400001)(36756003)(6512007)(5660300002)(186003)(26005)(316002)(956004)(110136005)(8676002)(1076003)(86362001)(478600001)(6506007)(2616005)(54906003)(52116002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IBBWxBfDryAa5ZEZ+hSgqDYPMVExbWcyK8lW5Zm8CY7jPeEKRS38FUKu2GPW?=
 =?us-ascii?Q?I6yd/R0zkDJ3/YwqEQGSG3kvDg7LtFcW2seTa+9FY1XaJuDhq7HRAF9S/7ZO?=
 =?us-ascii?Q?ObtVQuTedj8D5DJ8xTYMNYYgAMrxRMrGufaAET15BWFjOuT5ERwEDS6NpJK1?=
 =?us-ascii?Q?TwBtovjgoYmzduTx8HGdGcGAauN5u8KNOOkL2C5hPGmHFcNlTBYcEXQzsx/L?=
 =?us-ascii?Q?3FXXphN1q6WWtvgaVCoGI+ajuGdGFfMN5UZ4aZ1YmtQfny8dzIlV49pQdzV/?=
 =?us-ascii?Q?jsUkJ1X4Jd9FfRUQWHk8lvn04sznTn77OuPXfJP4Dmwb4H4/BYS26qzcSwTo?=
 =?us-ascii?Q?vsc8EXTLsKnETMeNKYY+3ksRB197oY922OvNRUFB3y7pwyGj1Pahl8ZO8Deb?=
 =?us-ascii?Q?j4f63G2ybRhBzupxmryDfYYHymf7evIip46vq+Yj51Q5n8SLQD+UQ/EBPZbG?=
 =?us-ascii?Q?M9AMp4Cr0TFIYKPy0ufsbTSmBW1+ACbwm0YkNfvWaBAz1NgQZYNXhroSq3pU?=
 =?us-ascii?Q?2WXuYqSwPoN8MJUjvzECpuvuKXfOrhs1quJAz0SUPKDvm5fMbjwg2yg9/vyP?=
 =?us-ascii?Q?BGrRUehcJjJepjDkldr4RCR3jiohIW+513S0v/D/hH7TmM2drmJXJY4lmLGm?=
 =?us-ascii?Q?to4cuFzqdVfvtzvqec/Q1NSFyFCnbA53xQQVDJR9pHqoqhZcTspKs/Z50dOC?=
 =?us-ascii?Q?gIc5msCRERGVC6BqnKISu6mWOvZUxFBbuiQeyF4vG/qQkRA84HtVnY3lHL0A?=
 =?us-ascii?Q?U8YpjJs5FYZRvvW0Opdv4C8o4wS/oaoRbGpCzOtqpFrGQm1eR3i9Vmgynt4v?=
 =?us-ascii?Q?Al219Qmi3kFSYC1wDpNwHZFpce9uBceCmuzh5pFLufuHnNsbhQxrqG2kkgte?=
 =?us-ascii?Q?Qm1LjzcLitigY4L4vpkPHAlYS7kRT5OyN4grURRDZdCQpkUupacNpyXOjYgr?=
 =?us-ascii?Q?JtDoUC/Cra4wGrvSxApPkfJ0s7W8TMtAIwzWjSBtjWQcnhfU8+y4j8zFc1ky?=
 =?us-ascii?Q?LC+CO0+S7F1ok7VuKKBG2S9/jbKMeY2u/CpETLpK0h54xqbZGCO292WyVCu3?=
 =?us-ascii?Q?US7ODk+p3MyZyMWHXlYohICudyhZacbl1AKNOM+7y49KWHDFYZ1UvDfukYmR?=
 =?us-ascii?Q?O86J/L2uMCfKpTftauv/zjzCWXCaEzQLVVOMCEbk7IIujtO6cv5eMQD7JKVi?=
 =?us-ascii?Q?VgGsy6wlBiZtcBIo59okNZNjHpXEwgbFnbkz8UopJp8RHBPIFyj+4JmtlVpM?=
 =?us-ascii?Q?/Nz28F09PY1u8l1LSX4cJP3mHE+PWaRzUi+G8PFVu9XNZ7Y4m/oDGsAh4DGA?=
 =?us-ascii?Q?gn3JZT5kcdA59Z4rhOfqEvq1?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 226aca51-d4fe-462d-93ac-08d955a9cf7f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 11:36:47.0093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +D0Y1Z07RW2H+inV/PRBAtSqaUbDhIMJ1jOkoMXQRbcrRoTh6cM9dVP5Dp1HanY9/puwDEVVmsLc5oecqz9d+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nikolay points out that it is incorrect to assume that it is impossible
to have an fdb entry with fdb->dst == NULL and the BR_FDB_LOCAL bit in
fdb->flags not set. This is because there are reader-side places that
test_bit(BR_FDB_LOCAL, &fdb->flags) without the br->hash_lock, and if
the updating of the FDB entry happens on another CPU, there are no
memory barriers at writer or reader side which would ensure that the
reader sees the updates to both fdb->flags and fdb->dst in the same
order, i.e. the reader will not see an inconsistent FDB entry.

So we must be prepared to deal with FDB entries where fdb->dst and
fdb->flags are in a potentially inconsistent state, and that means that
fdb->dst == NULL should remain a condition to pick the net_device that
we report to switchdev as being the bridge device, which is what the
code did prior to the blamed patch.

Fixes: 52e4bec15546 ("net: bridge: switchdev: treat local FDBs the same as entries towards the bridge")
Suggested-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c       | 2 +-
 net/bridge/br_switchdev.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 4ff8c67ac88f..af31cebfda94 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -745,7 +745,7 @@ static int br_fdb_replay_one(struct net_bridge *br, struct notifier_block *nb,
 	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
 	item.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
-	item.info.dev = item.is_local ? br->dev : p->dev;
+	item.info.dev = (!p || item.is_local) ? br->dev : p->dev;
 	item.info.ctx = ctx;
 
 	err = nb->notifier_call(nb, action, &item);
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 023de0e958f1..36d75fd4a80c 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -134,7 +134,7 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 		.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags),
 		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
 	};
-	struct net_device *dev = info.is_local ? br->dev : dst->dev;
+	struct net_device *dev = (!dst || info.is_local) ? br->dev : dst->dev;
 
 	switch (type) {
 	case RTM_DELNEIGH:
-- 
2.25.1

