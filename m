Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C11A4A8949
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352499AbiBCRH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:07:29 -0500
Received: from mail-eopbgr130124.outbound.protection.outlook.com ([40.107.13.124]:14899
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230439AbiBCRH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 12:07:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0SkD4y5Nb6AQhPm/R6ZE4gPkehkleB2e9P/StZOVOVExQb9DvEI2bbL9Jy2+suV2jqk6yIYDB9409zK9lzNsstW7tsR/xZ1o7CMo6vkTBbrmcw0GaOmofDQPXv1GokStxtel+ikvA2S7u57eILTxgGnZfV51pjmC77/Vwgy0U43ZtteNPKI7Sv+oSoNvJMLsUHtu2vBUDvFU2PIsFC5YUyvRHSRS1urA0UCNGfV+GMCSmtXysLmTnDN71WuChs2Z1BMNi5KM/CnmREsO5VWR7t4CF+HQQkWWRAI5/h+Xv56M9KaBXWq8Zd228SfR/LXBtgq8ZH0BydoKo3ZjAdJyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oilwTxtWG9ioJagG2A1UEQStcPOJxwa1T/rekfuWgyo=;
 b=Fn59Xfnjni2JvxXibYvhWJibhspbh7AxwOcZJTRkfY4Nl1IAl+Mx4wYs3xEVNErNq6rgW02b0+oY38yYsudtiGu7xyn0bx92OneUra4uRW5WuEsChbHkizvqS4U07m6FN0o8myisPKrI0f3Lw/uidacNoxdNoDZfoMvz+Pk1AUQXH83Qsh6x3JrX75BDygXcuVjmaI/UiT4UN9+POps6OpRc9k+zQPjooi2fmXCRDXKDcYY6E7yjodHs3Wx+yoOa3iRQjN6W7+SHbZWvDVvX2aajZYHb5rNvM3axtmWyxjT8u3oce5QqBrWmEE3c2YEip/tzMMUch8TylB7K5YojgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oilwTxtWG9ioJagG2A1UEQStcPOJxwa1T/rekfuWgyo=;
 b=U4dzlQVJaPv3sGXyzz3Z5x+0vk8BjaBq9E9J7mREyo6pKluj3QghT2StNWE/k4I4RGcv+3JvACebSJSjnVCMN1p/C3++cX/LJdJ3YH5eBvikJvn6ZWeqFIwLq+Z/DFnLL7Gctm5uNectVrCqpbIk3ZvkyLsTivwXolgyK1wJq94=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 3 Feb
 2022 17:07:19 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::a15f:104c:c805:a3]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::a15f:104c:c805:a3%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 17:07:19 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [RFC net-next] net: bridge: multicast: notify switchdev driver whenever MC processing gets disabled
Date:   Thu,  3 Feb 2022 19:06:54 +0200
Message-Id: <20220203170654.29784-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::16) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d80d484b-7193-4050-96ab-08d9e737a2ed
X-MS-TrafficTypeDiagnostic: VI1P190MB0734:EE_
X-Microsoft-Antispam-PRVS: <VI1P190MB0734FCDC4215E9EB7C339CA2E4289@VI1P190MB0734.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ALghg3gwPu7iOoWzIFq0426U/lWJja2+UycjyvHCQ4G2WdoWI6GCS0sPIpu+8fSIpDtegF8jOeuMX0HmA9BfI4UckAvyGmlqcAz49MXQ3vduL/5YesORMUi/WoGc3FSiYkRVc4dgjRA6xUBQsJgR65NdyUHaOpusoBhsMprtCVqVIM6J3jBa8sLk8ltiaB/QH29PRlmrzFh6vGbH0V25AAkBvLomHSlK5AWSgsJedk0zbQ4oxE2zOXLIK/iUNWltpHa2f5DftQpsMMOp2VlTuTVGdoAzFR4WL3kfRbosSjTG0SEMGFGiXTHPtu9svdxQFyML4XpVe4Q3Sjlkv0EdP7GjkSRYMfzw3CeIPn3YWcay+Npum9y2MW/EDbhwR+EwGs11VVT7Ak307xBAf8Gzod6r1FPTipf2aKz1e5ftpIcqJJxpfEAmc2eB6v+fwiLD7OrJBRgbeI8f3brumD+l3CnTmpgCxdb8phME0zmIQZUSc8JSrhVAH2V06aNSGv6wIJmN+v9CepvYwSENLQt2sqoyYUWLjIVIPXiUxQVkRpEVlot09/sPZCM3le7NtUDmlj8F0uqyo+0yOLgaMWbpVB2mUazaWYwMORVSEM2nnOC0qNQ377S04C2kyPomhWKBZOpSBCARt71j7iSGaJ2EvL/OpmU5T3VuKK6RvE7NcvrhYCVJr0eoSV+/OZoAeyH25oUTrxdnvRajRifMZUP59w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(346002)(39830400003)(376002)(396003)(366004)(136003)(186003)(26005)(36756003)(6506007)(6512007)(6666004)(6486002)(54906003)(66946007)(8676002)(8936002)(66556008)(66476007)(83380400001)(4326008)(508600001)(316002)(6916009)(44832011)(2616005)(38350700002)(38100700002)(1076003)(86362001)(2906002)(5660300002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YQ9nXn0BB68m7XePcvhDpfjAOvJYflLDl+u0s5hrXmIObCGO219z73EUroSy?=
 =?us-ascii?Q?1cS+fZrK0dHfPcon1NXLKe73csIrNVcmnfkGXYAW43hLJtq7DL3pXg2nfdeb?=
 =?us-ascii?Q?9HU48bW3IzPbl4cR3swIwwdxuNgh+Rr6IW/Zfy5FjM7d73D84hnNQ58IbiQu?=
 =?us-ascii?Q?BhZJkuxXodJXVVG9CRYVWXFSEF39XC8q1Amisb1HOhQkk+vOrnjId0jp21Jh?=
 =?us-ascii?Q?hTGbUw9kBCnpUK8cbd4+CAXfVpmvq6JgbM12aB6kzJjg0WamV9axkDSCBzw6?=
 =?us-ascii?Q?Of7Ersjlv6NiLiKKDkq1O0HmJn8X0tjcH6NzbZs4H99zV/A1zLcttXqa4A1J?=
 =?us-ascii?Q?0Zu4lcrNGEE2S3KZfCHYV8rUrPRwu9jqocZ9pUfYSNAmoljH0nygaSzTs5ZN?=
 =?us-ascii?Q?66EkJ/KQ3pjeY1lbq2V0PKUbF3xkMh4nMoCpi4oWKLQwSUPYrI3h0LoTX7qC?=
 =?us-ascii?Q?C0FophWchSIVm/6QHyWeVjvr09KuSAqVB+5tGc6ra3l3IlYxNt+fg381ChtQ?=
 =?us-ascii?Q?dvfp4gmTXSKbV1CL4RizvRgMo1klD4CYUx73cVSxjuHzINMSgfsqJlSDtqDL?=
 =?us-ascii?Q?fucY8uVuphiUksMTEEipE3witqUrxgLLVpmJp9stsgYC+tJdSzmxnjTVWCer?=
 =?us-ascii?Q?UoBp91yH5osGvN/WCwdXQTZtA4MUiY7Kql7XFQk7XSln2VUFbx0OIHLS0dhw?=
 =?us-ascii?Q?7rq3fDxcrk8DHIyLGQgPVnSkdfX4YJy7EH1ve/aAZX6RlKP9htH774QbDEXo?=
 =?us-ascii?Q?FI3oJOeHl0FstqJxhC9cpfSUgTqtUd+wGFRM49S+hDs/APb45TWG9+9i11qD?=
 =?us-ascii?Q?sBe1LP7e42JX3fcwORfQ/4wU53XsxOEy8D0czIr7McFG9iMx0whtCCubxVET?=
 =?us-ascii?Q?TfkVhR3GzbDYO8qEumJXUl3dQgo7bZKIKKRba5p9j1C+V9KfCYR40q/Jjhiq?=
 =?us-ascii?Q?Ra6sKLmo5RyLEuYs/Y13qhj0yvOjY3RA07rABrJSyFIYDUrvNTta4goO0Uzt?=
 =?us-ascii?Q?vINRwhHFIHNs13Zb1TZSvhbTjSmi3+ka2rEGdLX2n1LXTRngV+EaiIuWSKAJ?=
 =?us-ascii?Q?AHlWB87JEJkKcNSOL53jt4BxeW7qj9yBOFuRprxIS+trjnxVlqHcCp6SeJi9?=
 =?us-ascii?Q?iSu2IR1GAZjzz6haQIvktl+Y6BaOxJC+NdD1rAxFVegdQug6izS0CLZbKFnu?=
 =?us-ascii?Q?5LHHGDU81uUFjF/W801ByR3XDkOhCF4d993sEaaLSJvvB9U3B/JZyxV77y07?=
 =?us-ascii?Q?b20Dk+FH9axD8e8jSCoTx4yavVSOaUzs53MEr5paDZWa562eX+Y1Jy4CP1rp?=
 =?us-ascii?Q?SktSZT/KW3sxxLemlNpweX6KbEH/xts1wAnPQaAYtIuoPDnCnd3F0yHPMheU?=
 =?us-ascii?Q?yMbCEHGFxsBPm9GyftwqNFF1Cio4f8mX5y9Y7mPTHBTcjziWcS6HwAyhvGs1?=
 =?us-ascii?Q?dx3qQdX8eKsFD+ciCSRGeu4ncM7SGaCy/Ec0p6JeOJDC7G6GbN2F+CoYHhuO?=
 =?us-ascii?Q?YXrMjHWoON+uBjZ9DqPmTBdDpEpumxvouCRvmugKADIgQnkAHxfAMOvf1ROr?=
 =?us-ascii?Q?DRV49FbQ1TTmkUqzdKjUEsrqpgOrmsW1Djkg9/J6n1MRRwgS1W+/ZPpifEhs?=
 =?us-ascii?Q?DNkB+Uvzhhz7k5dl5duQKfRIfXCqCFrYPg2gWIMWtLek8oqKYIxVn8CzKO0+?=
 =?us-ascii?Q?3WZ1Iw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: d80d484b-7193-4050-96ab-08d9e737a2ed
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 17:07:19.3582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PVpmzEF9OSGiIO7UfvJdITJkhOP/s3CqoCWF9UpooMepw2Q/8rzLJwdSp16X3A70f8idVDvPIPsEpRhs3Km5zSSB3DtcoaDvVv7XPKgwZIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0734
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever bridge driver hits the max capacity of MDBs, it disables
the MC processing (by setting corresponding bridge option), but never
notifies switchdev about such change (the notifiers are called only upon
explicit setting of this option, through the registered netlink interface).

This could lead to situation when Software MDB processing gets disabled,
but this event never gets offloaded to the underlying Hardware.

I would like to propose to simply add a notify message in such case,
as in other places where this option gets altered.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 net/bridge/br_multicast.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index de2409889489..d53c08906bc8 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -82,6 +82,9 @@ static void br_multicast_find_del_pg(struct net_bridge *br,
 				     struct net_bridge_port_group *pg);
 static void __br_multicast_stop(struct net_bridge_mcast *brmctx);
 
+static int br_mc_disabled_update(struct net_device *dev, bool value,
+				 struct netlink_ext_ack *extack);
+
 static struct net_bridge_port_group *
 br_sg_port_find(struct net_bridge *br,
 		struct net_bridge_port_group_sg_key *sg_p)
@@ -1156,6 +1159,8 @@ struct net_bridge_mdb_entry *br_multicast_new_group(struct net_bridge *br,
 		return mp;
 
 	if (atomic_read(&br->mdb_hash_tbl.nelems) >= br->hash_max) {
+		err = br_mc_disabled_update(br->dev, false, NULL);
+		WARN_ON(err && err != -EOPNOTSUPP);
 		br_opt_toggle(br, BROPT_MULTICAST_ENABLED, false);
 		return ERR_PTR(-E2BIG);
 	}
-- 
2.17.1

