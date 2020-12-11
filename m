Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141B02D7939
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 16:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437933AbgLKP1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 10:27:41 -0500
Received: from mail-am6eur05on2047.outbound.protection.outlook.com ([40.107.22.47]:46078
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437922AbgLKP1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 10:27:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgoxMFpMzr1fdVxzbjm9ceXXfM6JKYuGXFNf3hVu3x98Sw7l3aZhsApvssHEKkMf1UitfRfEn7qhlIAHTYWQVzngJHBENWjJdB6FdVe2FZfqgOaRIUownjfP0JVws0mE6mCnptLxw0MC7E6LSSeZ1Zkg63pFTp9EW6/7qfdSlQBc3lvYVLkjF575E52l1H36mN+oVNV0q3ZHK0MtP/Zkg9WRaYCM3AW6FQuFU/f0HcGq6su858qCr+exnmY01/Ki3BXURrFKIcUtX7RL4kXL3gkRXtR59acEq7T5P3Exd5Ss4OaVwZnFlMbuA3d+M/9J+53IL3EWyDbddQDz8uYjFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nj2/rfizjPUWlZ9QekU751OoWU5HcqkDHSmRwk+E7rI=;
 b=HfoYoJxrUu4i1h9pxHijrDt3QqkqHuqOgLtC2NM95Z9UPlRLIi2GtETN7RtCazUDf4wsu0JLUMMnB6Ie+aogcMekk1kLOyBpjvJCUt4/h/kTDzXCXaxZW5chQ6pFedg7jpWmimI4Exem7tI6GJOhfyoKt+taKcmPukSghpSl9WJK8dcF+eRuIsIuwcGCHdlfd6nIK5J01q5/oNmU5+lN/OVPP094FJ9xMuVOs8Mk8ZSh1Ve3XMyaSJnkZxXtWtyZaKAlxABSz0u4IcIlufSdswy9AKrvD/dbRa7WqLHgTe/URH+3jkhi+2y9xrAuSZyEgFYfGo10UkuT3mZQ+xxonA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nj2/rfizjPUWlZ9QekU751OoWU5HcqkDHSmRwk+E7rI=;
 b=Euq+RWc4qnHxBoGuM48avaV/dYz8JWJCnmSUGxw3U4sSOei0HOR7fLhAbEf0wd5YJ1e1cNBF0zJS4AGSK6/TTGu29iAjFgt3rYbSO44VpyIlKPcwX/i91WNuBeuGARrgIQ98nrH7G5gsLcun5Kl2mRBM0nxoHk7lejY4zfZWAps=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM7PR05MB6725.eurprd05.prod.outlook.com (2603:10a6:20b:136::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Fri, 11 Dec
 2020 15:26:43 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::642a:6259:153:ab88]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::642a:6259:153:ab88%3]) with mapi id 15.20.3632.024; Fri, 11 Dec 2020
 15:26:43 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next v2 1/4] net: sched: Add multi-queue support to sch_tree_lock
Date:   Fri, 11 Dec 2020 17:26:46 +0200
Message-Id: <20201211152649.12123-2-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201211152649.12123-1-maximmi@mellanox.com>
References: <20201211152649.12123-1-maximmi@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [94.188.199.18]
X-ClientProxiedBy: FRYP281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::20)
 To AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by FRYP281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.9 via Frontend Transport; Fri, 11 Dec 2020 15:26:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 34e3b972-62fc-4e9a-a86d-08d89de92a35
X-MS-TrafficTypeDiagnostic: AM7PR05MB6725:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB67257BADAD0AD8379944EEDDD1CA0@AM7PR05MB6725.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gpy+5nUwz1Gon34ssM4kZP/Rvrll/4o0itonqD5pLRlHI35+Ptn+PSviUSRfH92qYz0hA1R9KERK9HnVnN0dC4BA4IcVhksE/kutj5frNTtTaKUOvDbyf0J8qTuDpHmvH/242eo8IQ0BADriCmTnnCgIuPvKC2lws5Yqi/WNmqszTf6nMS3EdRiHQYuvrv2dPDnrsNZ7MvefRSf7/uptlMZDdBhnwY+IQ/YDIGN6+a5X14uDhT5jq9BE5bR/kq4QrnJ4qTaqXz+jT8Q/5D3dexpm2Nu1ljNO9ol5s3UsYB4EihNMPiCfyOD0kLu8uE7I9keloWLl82vY0pMvoq4E+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(66946007)(7416002)(186003)(6512007)(5660300002)(16526019)(4326008)(52116002)(2906002)(6506007)(8936002)(66476007)(478600001)(54906003)(316002)(26005)(2616005)(8676002)(83380400001)(36756003)(6486002)(956004)(110136005)(66556008)(86362001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7PqWEqH8asX8nAVrPeXybIhWj6waymkfa0OuZNUbAYNwnkAuwQDaNvE4GkAb?=
 =?us-ascii?Q?MRLU1wHrDQV+BQnhUtNrxstpGkiluzrM8e7BQCuV149E6FV8HoVG32exiyqy?=
 =?us-ascii?Q?/WprErl3jiT3x6420oNtWBOEcyK2rMX1WA/Vp/YHPyP5mAQKaTalx8wfgRJ9?=
 =?us-ascii?Q?3SiVzm08Kx3RbxXwkOHJdhNX2hNhuS6f5Cpvn25vzDmPHQwMOiUMzXgg7Ah1?=
 =?us-ascii?Q?CxSjUDig/evvPAPaWjVCpdk3YSd6xpNOZe6WYpCOYTHXZBcBxMCW09VGKaPz?=
 =?us-ascii?Q?xjIJw1MXlGhClIbxuIMsWg8u9hQC8l1mELeX/tQz5iGTPk9UF5jFuA4fC5yP?=
 =?us-ascii?Q?DDnoeuZ5E3kYZyHu0m5UWkrhYPAvmCLbJnvwq1lMnh4ebTGOaFYohjDGywr6?=
 =?us-ascii?Q?XIeS+TVkaPFTLgNy92Z76yeSzJFueQkDqRCDXTc3cIsRyiZn2IQ9IFo5LCqX?=
 =?us-ascii?Q?5YLQAt6Wl+9cVTsCeyOi1wHP3mjIq3If91CUFwDUMiQdJwI9atVAwtNHghbv?=
 =?us-ascii?Q?g4+4q/A+mFxkEVxleeb6q1xyZIRg0f78xkMRoWdIQBabivmn35GZ0JGhzgS7?=
 =?us-ascii?Q?VghAW4YMxlE6tJvOCbqg6tgXAITQIVm/794CRagPS9vhzqhrFbV5DV7JTIwq?=
 =?us-ascii?Q?Q9ZLne7EP7WNae1FrQAzbvTNIheQ1oGkNGIRSSP0wXUC4j89b2+hIg+w71GY?=
 =?us-ascii?Q?EyMa94EWM2H7W1rui1r09HUPGqjwgiJCKaXfZdIeZHlN3yZhuZjFwlUkL544?=
 =?us-ascii?Q?zlhDRc0PNDLnU1S7l0DLxp44kAkfD3gUNyt9JrPs9N6XoYgWlvN67C7rK6uz?=
 =?us-ascii?Q?emRHMR/yhCAYIe0wQpHvhJ5joon0jXytiCTAUnd7bXtkY06q3EEN13wspvuJ?=
 =?us-ascii?Q?gETer7wMFTUXdrPfbmAD+c/87Cuwdt3bqcCIM/1QwzxggeKUBK8niQUINLsb?=
 =?us-ascii?Q?WZaRMuYfuSIImFX1RYPaBc6j3d+98+W/IXtZus0zNuRZNHNtdVZEr0SvA2EO?=
 =?us-ascii?Q?bCjY?=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2020 15:26:43.3495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 34e3b972-62fc-4e9a-a86d-08d89de92a35
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: APX+sJqrbs7ed0umlrVLr19kfPO4YUIJ0tQsNrIbV+NB/+9VcJISICjP8CmKJZ1eoRTiuxClmJXeDbhDLGKbSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6725
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing qdiscs that set TCQ_F_MQROOT don't use sch_tree_lock.
However, hardware-offloaded HTB will start setting this flag while also
using sch_tree_lock.

The current implementation of sch_tree_lock basically locks on
qdisc->dev_queue->qdisc, and it works fine when the tree is attached to
some queue. However, it's not the case for MQROOT qdiscs: such a qdisc
is the root itself, and its dev_queue just points to queue 0, while not
actually being used, because there are real per-queue qdiscs.

This patch changes the logic of sch_tree_lock and sch_tree_unlock to
lock the qdisc itself if it's the MQROOT.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/net/sch_generic.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 162ed6249e8b..cfac2b0b5cc7 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -563,14 +563,20 @@ static inline struct net_device *qdisc_dev(const struct Qdisc *qdisc)
 	return qdisc->dev_queue->dev;
 }
 
-static inline void sch_tree_lock(const struct Qdisc *q)
+static inline void sch_tree_lock(struct Qdisc *q)
 {
-	spin_lock_bh(qdisc_root_sleeping_lock(q));
+	if (q->flags & TCQ_F_MQROOT)
+		spin_lock_bh(qdisc_lock(q));
+	else
+		spin_lock_bh(qdisc_root_sleeping_lock(q));
 }
 
-static inline void sch_tree_unlock(const struct Qdisc *q)
+static inline void sch_tree_unlock(struct Qdisc *q)
 {
-	spin_unlock_bh(qdisc_root_sleeping_lock(q));
+	if (q->flags & TCQ_F_MQROOT)
+		spin_unlock_bh(qdisc_lock(q));
+	else
+		spin_unlock_bh(qdisc_root_sleeping_lock(q));
 }
 
 extern struct Qdisc noop_qdisc;
-- 
2.20.1

