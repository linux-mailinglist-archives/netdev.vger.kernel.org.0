Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CC93AB2C0
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 13:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhFQLjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 07:39:04 -0400
Received: from mail-eopbgr60110.outbound.protection.outlook.com ([40.107.6.110]:34908
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232592AbhFQLjD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 07:39:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWX0zYoBMkh3un3k2o3a+qhSexgjyCU0GN7qoIoKMM2+gufzeZoIfF00YLHEUMnSdvOx+CviZ11ftYscKslBCxJ0Siqf0+/l2wRBw1CRqdE2iT6h0nSdcvyesewvQjxmI5nsliAL7iJYRe0nDCY79SaWUssq4uI98tY9C6xz2RqSNmnJxzSCMGXSxDYV9z8fdhkkjXQQJcH/IX9MzaxCBMLybAt1LR61kt+pwMjmxXVQU6mR0CSUuVj5ly+FM3iNpXj6QM2fLRjvaiZnORlp/iArVOid4nAnu2Is4sBF43hrWM1OX7iZRp+KiM9iZQ4nR2Kkw+wW6rGvz+oynfkCiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mw/3ZeqO4X/b0pk8Cmi+w/JrjcEYKV8NQsh5lP8mjdo=;
 b=cNgXxRfYuHlfBkKyWEb8l0ttWZpJIiPDQJzNOYDxMr6yb+TDq4GO1P7t29QiQ6NDYfGdqeu1ihlxGkkNHpWTThs3+9TyR4QYQjvHjZMsV1nstBICFPZfPFQoWW4tmqIgrQahIv/U47u5TWDlrinZ8+xSZEMqXtv6E2uhtZOCRdxTuU54wG0+iF2qMsIhPYFTkyfDQZFccalLGMK4IzHp20xyeLXHy9Cp+viCzyJiLOrn4OOBPrHauNCx+P00WIVZ1Ss+Smj3t6IMcXVUuCICnMP0InwFVNO6DfsHRE5axB0I2zQe2V4OswnJSYMcRmtI/5PUfgOlAFsXlOjrjGNYQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mw/3ZeqO4X/b0pk8Cmi+w/JrjcEYKV8NQsh5lP8mjdo=;
 b=ZrfiVbP4fpuUE37OZB3sow6LP5jV3VWR6uEY8GBmNju32LrUiO+FbbFFuON29KjIaamheScWIjQ2R2ZSAz/SoUOi2KaBR0rZ0JVeEcTetzSsdfcR0UZ3HSlqOTlWDFrVJNnm6Vb7z7G2e+3j+qk6j0kco5lU3UgVMx9NtJsD5v4=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM8P190MB0836.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:1d2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Thu, 17 Jun
 2021 11:36:53 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.025; Thu, 17 Jun 2021
 11:36:53 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadym Kochan <vadym.kochan@plvision.eu>, idosch@idosch.org
Subject: [PATCH net-next v2] drivers: net: netdevsim: fix devlink_trap selftests failing
Date:   Thu, 17 Jun 2021 14:36:32 +0300
Message-Id: <20210617113632.21665-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6P195CA0064.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::41) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM6P195CA0064.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:87::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 11:36:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0adbbd8e-0b8a-41bc-9892-08d93184346d
X-MS-TrafficTypeDiagnostic: AM8P190MB0836:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8P190MB083683E5095E0E7EACED7A6CE40E9@AM8P190MB0836.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 51+9NFqvV1qwd9AAQgpMbdALXeRB7yeGv70mWMo0aCBhgD7bwSreDv0E8wKmBSsPhqb4+lni0FiymIEjetLnqghaHYREYpLaa7X9XZUkgMpSizBUZTjv7HHjuQClwsYj1Kw9zX0KXv46w6ESnIZ1bz3B92KN4ZH6JBMC4LdRstQNdQR7SsFQ39ecUs9Xw/P5nHkOy7YHJ8e2BvaRVu/nR5p+HiOBP/iHf7CTJ8nUU/25wFtGjQhkCtCuIG71Vl+1xdMrjvohWTiTE3oDTwpywd/45hD0JBnWmp7w/0E3SbHTWnIvDJaJ9n27Evp3PqZtiejjrNVzKnpPcGkSMh3LQrkN5nBAHMprZA1xqOsqkq+s1S037S9GGZ9kPp2CTOti4f3beIhUlhBbmnr3sy8UkegYfX/piuBCMv6dvm4tWLTtDNmlPzHXBPcZ7fsfP2rw0YTbxOz74oDEJBt9DgZTIgSeaSSS1rQka6x7wGj5rztc7+Qi2DoCkRN5LgUPTgyu3rBge+TZr4mhFqcUtC3E1kHOEoCNwe+ipIxa5vkHPzOcBNQCErw9uxRW4tiQ2teIfMi0+y/5aLOq48+dyLZOd5p9mAn52hlJ8+HJes4/ohnhBHayJs6aQRY+c8vFh2t0VecWOAESOyCMIOgkcFFCfV/Y4ygD5q6xnDUATPGcKRc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(376002)(346002)(136003)(396003)(366004)(6506007)(52116002)(36756003)(316002)(956004)(8676002)(38350700002)(38100700002)(2616005)(6512007)(478600001)(26005)(8936002)(6666004)(5660300002)(1076003)(86362001)(6486002)(44832011)(83380400001)(4326008)(16526019)(186003)(2906002)(66476007)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u4+GKhk08RJBGQG4VuXf1RpPMwtPRZMZkrkEcSAKKZ5Uuf6vWlxkA5boLyv+?=
 =?us-ascii?Q?r6JaD+aVLGFbU4CzjxG+xZrcHG4Ww63A7HmXgbrcsMqaJDZmotoYPLTJbmw9?=
 =?us-ascii?Q?yKT6jO3KQvK+fC3ESjJqRgSIMMDkmvnmb0FuKh3iJ0ZSceGKDC5ZX2SPafbm?=
 =?us-ascii?Q?aj+CP/1Rqwf5DD/LWv3CR1XjIeqU9tHkKaxXlJ/AwZLP0IaBcM4Oa8//sJ0T?=
 =?us-ascii?Q?EaJPwz7s8ob8t7Wo3wxznLL1BKoNBU7qhA43N7XlUSaRvi8pEw9MktaDaeJe?=
 =?us-ascii?Q?nCzAuS+us3eWyXlreoiHblGYR/SYO/Gq3lz4U46Ln2RxaMMaf9ji8H2LBs+r?=
 =?us-ascii?Q?JBwzsTRoRVeKLnxNJBK7aP6btjDD3QWq5/O4s1qfapHe/n20pbpJhVzeALv9?=
 =?us-ascii?Q?9HQfoIA7Vr6YeI4COh7vUhjwZybuq0oqcfTpCJxTp6HPBTeRNdSkHV9Ft+A7?=
 =?us-ascii?Q?8qMOnpTnvZQUi+0Tw4UldoqTuzgF8N92BsaA838VMyQCNr+0ruU9DxBfmVgR?=
 =?us-ascii?Q?W5Hn+GT08+AeyB1OFjpBBqBplt7MG3jBvPUPnJwaib5EoN2P+ZUwf0xiQ2GU?=
 =?us-ascii?Q?zxplWliKARYwW399xnBRKK4olIeqnLRWUUijqQ+fQ+N24QRcPC/RLrXKuDsg?=
 =?us-ascii?Q?mukcnwFmNQuYZra2geDukGzdRvsYLlNGFDwR42IFB2TxJ2aKqnZPJMvPjcR+?=
 =?us-ascii?Q?Vou46QRPNmm2CRuk34DGjwKVUYtRq6vkObo1l7Wd3yazosUtIwWrad9Io8RX?=
 =?us-ascii?Q?V5ZUpcHgs+4I2BVOYVQmwetlnR8LHfF3cQlbnFMlXaUs45fr6jYvwocePHWx?=
 =?us-ascii?Q?3yVm5A02AYNXavmjKdp4pfRmzXi6wGM2x9OXQkG1BG0OvE6u6noFoRRZhpLD?=
 =?us-ascii?Q?d/gvr7Q7KUSMEXWLlY4xUT5i4aGVi3kWSDLpARjxdnhRug7LEVToqt2xHPet?=
 =?us-ascii?Q?QulbAr2cHuHiNwqyiS18hB7egmu3ukYFiP2XzJnQIKKsc3ZFQfa+FbKzzdoo?=
 =?us-ascii?Q?2icbaPF5JUhrnTudUe8IMsDmWZ3zHYss4yBwCzD/ZZDQOXOsHh0UIT1n8Edx?=
 =?us-ascii?Q?VlHyLNFN8be7RHKtGFLKrzL4ukXrn2BVKkV3dizMGmNuM2EIgBj7UnPF1gLr?=
 =?us-ascii?Q?nYdKcDmuZFM8IRj4oJOTAkHWKlW1utiKElzhQqq4JL4w4C16CkOEtSW8wgZJ?=
 =?us-ascii?Q?UNsKl5Uf8URszL3YBl1IBMzm4MM8B+uKhi6nFBLNo9VVY/3sAhAregnI1KOE?=
 =?us-ascii?Q?u+AqjnRphCCyKW475KTYwIpvovOEMe2sbeZNSAPex0yLb2qK/6jEY3I5+QGm?=
 =?us-ascii?Q?hEOKWNWHtaLIRRuIamJdzQ7u?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 0adbbd8e-0b8a-41bc-9892-08d93184346d
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 11:36:53.7694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VDWTvWj9ZXfOgDiVx59okTCY8epVg7FWa8y1zI3ugzjP9ZvqJ8qjBPcqzUB3aR3SwztEn5mYUVFwp2MMtGUhVD1bOurW/XtxmVOUmCATX5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P190MB0836
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink_trap tests for the netdevsim fail due to misspelled
debugfs file name. Change this name, as well as name of callback
function, to match the naming as in the devlink itself - 'trap_drop_counter'.

Test-results:
selftests: drivers/net/netdevsim: devlink_trap.sh
TEST: Initialization                                                [ OK ]
TEST: Trap action                                                   [ OK ]
TEST: Trap metadata                                                 [ OK ]
TEST: Non-existing trap                                             [ OK ]
TEST: Non-existing trap action                                      [ OK ]
TEST: Trap statistics                                               [ OK ]
TEST: Trap group action                                             [ OK ]
TEST: Non-existing trap group                                       [ OK ]
TEST: Trap group statistics                                         [ OK ]
TEST: Trap policer                                                  [ OK ]
TEST: Trap policer binding                                          [ OK ]
TEST: Port delete                                                   [ OK ]
TEST: Device delete                                                 [ OK ]

Fixes: a7b3527a43fe ("drivers: net: netdevsim: add devlink trap_drop_counter_get implementation")
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
V2:
 1) change the name of the debugfs-entry variable inside nsim_dev to match the name of
    the entry itself.
 2) change name of the registered devlink callback-ops function to match the
    'trap_drop_counter' naming convention.
---
 drivers/net/netdevsim/dev.c       | 14 +++++++-------
 drivers/net/netdevsim/netdevsim.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index d85521989753..6348307bfa84 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -269,9 +269,9 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 		err = PTR_ERR(nsim_dev->nodes_ddir);
 		goto err_out;
 	}
-	debugfs_create_bool("fail_trap_counter_get", 0600,
+	debugfs_create_bool("fail_trap_drop_counter_get", 0600,
 			    nsim_dev->ddir,
-			    &nsim_dev->fail_trap_counter_get);
+			    &nsim_dev->fail_trap_drop_counter_get);
 	nsim_udp_tunnels_debugfs_create(nsim_dev);
 	return 0;
 
@@ -1208,14 +1208,14 @@ static int nsim_rate_node_parent_set(struct devlink_rate *child,
 }
 
 static int
-nsim_dev_devlink_trap_hw_counter_get(struct devlink *devlink,
-				     const struct devlink_trap *trap,
-				     u64 *p_drops)
+nsim_dev_devlink_trap_drop_counter_get(struct devlink *devlink,
+				       const struct devlink_trap *trap,
+				       u64 *p_drops)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 	u64 *cnt;
 
-	if (nsim_dev->fail_trap_counter_get)
+	if (nsim_dev->fail_trap_drop_counter_get)
 		return -EINVAL;
 
 	cnt = &nsim_dev->trap_data->trap_pkt_cnt;
@@ -1247,7 +1247,7 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 	.rate_node_del = nsim_rate_node_del,
 	.rate_leaf_parent_set = nsim_rate_leaf_parent_set,
 	.rate_node_parent_set = nsim_rate_node_parent_set,
-	.trap_drop_counter_get = nsim_dev_devlink_trap_hw_counter_get,
+	.trap_drop_counter_get = nsim_dev_devlink_trap_drop_counter_get,
 };
 
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index f2304e61919a..ae462957dcee 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -249,7 +249,7 @@ struct nsim_dev {
 	bool fail_trap_group_set;
 	bool fail_trap_policer_set;
 	bool fail_trap_policer_counter_get;
-	bool fail_trap_counter_get;
+	bool fail_trap_drop_counter_get;
 	struct {
 		struct udp_tunnel_nic_shared utn_shared;
 		u32 __ports[2][NSIM_UDP_TUNNEL_N_PORTS];
-- 
2.17.1

