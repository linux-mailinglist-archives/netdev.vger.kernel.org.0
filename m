Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168493A6750
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbhFNNDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:03:50 -0400
Received: from mail-eopbgr50111.outbound.protection.outlook.com ([40.107.5.111]:61697
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232685AbhFNNDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 09:03:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cVp3DKzr3WeqZO6rqevsvcadFBgvVc9FPT9p1E0TXHfYQghjUgnOktj8/T+UAmQdEkMQXH550HkGkz3eeWUUsXcgtJo0SWsrGTgL/N232FXswjGCG3sOvpGO+Qze20xDDexVZQBPsFe0VCwhih/wb05S8af9K7Cmx2Qab/USdHXbKaC0ODKxLP+ebZrKP8m46LXXqbNkL0ZRN1Rq7PtQ9W4N7FFOb8Ish3YQ1WZN02SYCXf/knUYS41kBG7a1iRbTB6JUl7pkLq4NVbjHkYw4253v/hcXtjOasbiUi5yvQ0wb1hry8ZACkH5Npx1rGm78FofjiEjJ4Vv1fs3LV9oyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPtHZVfICTIGXvtL9tlbiyLUJttkTefZ8jBk/zM7xZs=;
 b=NA/bUSnJVbPWcxMFDTxzouWYYcjz3Pd/MlBcaCFDRIYwo3L9HZUSh8hnxVn+Gk+ul5dwumA2M2h+TSlx5KvY7V1Ii6E/P0qioPSEx4yHNc9QnktrWjmGA69/3nC7NkpH/GaCHLrizU4qeebU0deR3T8Q4BRWW350yaGIj03nbGfBXFOWkq7gqO8lmZQ7e2Pl9flNoZx660p919tvlD7X7AY8Qj8pTSzMFSHVw5HaRmNiRP1a73oGQyPfkCFAbDqKO86rsaY/e2j1YXMszXlku4KD71sd5J0aAQiUGk7p2RHIHZ3j6HeUxrkhMvSI09CIwX+gCUGr+mw7iOzIJf4ikw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPtHZVfICTIGXvtL9tlbiyLUJttkTefZ8jBk/zM7xZs=;
 b=xXbaImDpRjnPTpBbC5J2zCDZNGOHTKVJ/fwg75BqyGpWnCXN2NTjeVLZ04N24ZZ2zWuqpuobfQISrKQhHITRrYASQWVGWxhYhyCdSV85XLyhSpRtJpEi7eYiJyMhtNlJ7sOwyedWUZguW75KcqrV6jgWlgorNWdSaVahqn+9Pxg=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1396.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3b6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Mon, 14 Jun
 2021 13:01:39 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 13:01:39 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadym Kochan <vadym.kochan@plvision.eu>, andrew@lunn.ch,
        nikolay@nvidia.com, idosch@idosch.org
Subject: [PATCH net-next v2 3/7] drivers: net: netdevsim: add devlink trap_drop_counter_get implementation
Date:   Mon, 14 Jun 2021 16:01:14 +0300
Message-Id: <20210614130118.20395-4-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210614130118.20395-1-oleksandr.mazur@plvision.eu>
References: <20210614130118.20395-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR06CA0140.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::45) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0140.eurprd06.prod.outlook.com (2603:10a6:208:ab::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 13:01:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b8ffc2a-9d02-4556-4f70-08d92f348c4e
X-MS-TrafficTypeDiagnostic: AM9P190MB1396:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB1396A938159344737158FDB8E4319@AM9P190MB1396.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kwy3lRFVtwnXnCAtD+6EWZ7NsyHovQUr82fktsvYzRPepnj7g0rmDmTQWBz8g7XmutWlcHUQkLbCdUt+qKUFhaJz+g5L0Ae5SGwJK/61OCdCCiJ7W5OPibEAEZVfgabMBBgoHTo0oNAC5dmceJ/jpH2IDxgUUvKZPUFIRYLJmciE7mZORi6NXyxtN+HEviqKGxNQuFAEwrnbpU6kkKn07zGsQygg+ztJ6EVdN7nCYsDIsYkjp9QYK2yqffV7lD8gCV9kMtuuO9RgMceuB6NXRYfhROUVVHp9NgOVq4jPEaGsQanxrFWt8QyvgL/yD/eCWU6rp7wW3U1uY42sXUsM7E/h4G/n7HcetUd4fLgL1mzKtNP5QVVB3qhF7MDXuNMEh4aEXab6/NMn19ZuHfTh+ZQGQhhf0ojPw2ihrK/UuEoq31TorKsGOavjO8q6OEmwSl1iu02/PDh7A5hETeEmdMQBlPeRuc5YGClT5rh++tC24Dg1aZPFv9WXLy7avuFgRHgyh7iCpO6vtX2XrgFTaYdteo00HzpOz7bb7iGHDKXhkVKp22m2IVSj/tZb5cckWxbttfE8xxtpY77ESTK5klFDVbzaHOO8uqm4ATe2mEuDTXBpP/6cDU1puWtW6W9l4HPy/tOIyXJMp7A5IZrgmZsTWMEQcNQcoJRmII+Mrig=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(136003)(39830400003)(346002)(6486002)(66556008)(16526019)(186003)(83380400001)(66946007)(956004)(66476007)(2616005)(316002)(86362001)(26005)(8936002)(4326008)(8676002)(478600001)(2906002)(44832011)(38350700002)(36756003)(6512007)(5660300002)(52116002)(6666004)(6506007)(1076003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lgz6Ja+ETz++2TbpFEBLq2qLwv49BcRBxoShNGnno0e1/RTb2GI2ny9ECkAs?=
 =?us-ascii?Q?QQ1UE6O7QBd5ve9WnESTFIwcrziAPpVqgQFtM5Ddio1kpVrtTLGlYCRcPysK?=
 =?us-ascii?Q?+ZcPbzj8ITgweHhRPFPO2bSJBapY6sGqUAeYcizULdlXCQk/iZ13wHJuOy7B?=
 =?us-ascii?Q?jvM/7fXLxiTNMUuBnhU+whbnZ8h+0GViWhfP7UU/qWSBsJctd+Q607HhjVKS?=
 =?us-ascii?Q?GTQaZPhZ7lvLbTyu0R/mjyFbw13Teo5iO/N1+gRVGhUku288XyetOkQecBfB?=
 =?us-ascii?Q?1BObiOAy1ITRTiziazR3YK/a3iZ0GxPDoFIL2QagFa233K3ieVbD/sF5F63I?=
 =?us-ascii?Q?WAKqw/ZbWlXQrYcgCZVTDRFPY/pcfJ3lEB4O5s5YkIv/97Lk8x5pcJGsBrDw?=
 =?us-ascii?Q?3qQRs9FkcCqYrqKdaOrCqRrn1ng1HZ4kOi3vQvcD3pmqEypbdz7328+PBGkw?=
 =?us-ascii?Q?bUwTUhNEGGYQAP9jcouVosyD7HKTPTvTGbknItJUFPyWCHmOy21BAbqt8jrk?=
 =?us-ascii?Q?OLtWRhGdKRdeKm53Ph2VufHpzw8b6oe28a0txQq4SiXmeNV3E2JavX5dv1Ic?=
 =?us-ascii?Q?p9PsEDKixkBWvDmmocQEeX1qnDlQ3SIDo1u2qtqJ/I3BBFl8lA0UtySMf3Uw?=
 =?us-ascii?Q?Rir8YM+U7aouW7wjzfc2HDxiOVpABXwQkrjfRafd9w2bcgrFufujewwAlR/9?=
 =?us-ascii?Q?dh4zBqeOqBbqL8yIuvYrAZigFlo3BC4hIxAKhKb1g5L2v1ZAVmVp5PMKWEwU?=
 =?us-ascii?Q?W1xYVT7rGatKqG3i9MCN7CdlWMAp3EAq0GZrSNns0QEWUr0mNXnlah8Tejan?=
 =?us-ascii?Q?EuZ+NRLCuVFlA6FsZzIDldNqH4aaCjncyMABORGsnOYX4sH8l8eiz9/EnkvH?=
 =?us-ascii?Q?IqLgH0vjWdozzPUEsWtZTQy2K5ZBGjltUMXmJrFkiWnqupYeLCbNm4K0+5Sz?=
 =?us-ascii?Q?U1EB6THDbiURSbRjtvBZIGOiJwsUaD3HT4C/7vejw6xOC2vC74nCKKyjshqO?=
 =?us-ascii?Q?GUjnKGORwdJVTKRUTvE2Ub00gA6MoRnO1rgQowFs0IhbqfZWkGvWRuiVcwhy?=
 =?us-ascii?Q?TY4IeHdpwF+ucmHE9lmlnFHF6vCL4IfQk+K139f25/ZY5vAUVa5VDpjitdhc?=
 =?us-ascii?Q?XYc3KKEyxsCpmdNx1Czh16+C87x0YRNIewYVnyo/lDg/bBv2AX5EiTSkslwu?=
 =?us-ascii?Q?VqRiR+sR6X/k4k0HuIxrF2Bf30qP7ZuT+07MrQOBvm7jaVu2tf6d/fq2UqBM?=
 =?us-ascii?Q?AExSOSCnI3CotvmnnquEVfea4V/4s3Aj7QTYLueX3SAbduXHi40aCQ9bbtQT?=
 =?us-ascii?Q?uiGGXMAyzCIfRJmdwAb5D8b8?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b8ffc2a-9d02-4556-4f70-08d92f348c4e
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 13:01:39.0444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LUp5q6WrX+BvYw3ApgNkUXJa1N3sVkXdIw5JWShXYCTgBbFYFwVGj/UUK5Ua0mN9skLCua3oWd4Ew/P+CFc2Ag7ljt37FOt7dS2++kASuDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1396
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever query statistics is issued for trap with DROP action,
devlink subsystem would also fill-in statistics 'dropped' field.
In case if device driver did't register callback for hard drop
statistics querying, 'dropped' field will be omitted and not filled.
Add trap_drop_counter_get callback implementation to the netdevsim.
Add new test cases for netdevsim, to test both the callback
functionality, as well as drop statistics alteration check.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 drivers/net/netdevsim/dev.c       | 22 ++++++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  1 +
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 6f4bc70049d2..d85521989753 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -269,6 +269,9 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 		err = PTR_ERR(nsim_dev->nodes_ddir);
 		goto err_out;
 	}
+	debugfs_create_bool("fail_trap_counter_get", 0600,
+			    nsim_dev->ddir,
+			    &nsim_dev->fail_trap_counter_get);
 	nsim_udp_tunnels_debugfs_create(nsim_dev);
 	return 0;
 
@@ -563,6 +566,7 @@ struct nsim_trap_data {
 	struct delayed_work trap_report_dw;
 	struct nsim_trap_item *trap_items_arr;
 	u64 *trap_policers_cnt_arr;
+	u64 trap_pkt_cnt;
 	struct nsim_dev *nsim_dev;
 	spinlock_t trap_lock;	/* Protects trap_items_arr */
 };
@@ -1203,6 +1207,23 @@ static int nsim_rate_node_parent_set(struct devlink_rate *child,
 	return 0;
 }
 
+static int
+nsim_dev_devlink_trap_hw_counter_get(struct devlink *devlink,
+				     const struct devlink_trap *trap,
+				     u64 *p_drops)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	u64 *cnt;
+
+	if (nsim_dev->fail_trap_counter_get)
+		return -EINVAL;
+
+	cnt = &nsim_dev->trap_data->trap_pkt_cnt;
+	*p_drops = (*cnt)++;
+
+	return 0;
+}
+
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.eswitch_mode_set = nsim_devlink_eswitch_mode_set,
 	.eswitch_mode_get = nsim_devlink_eswitch_mode_get,
@@ -1226,6 +1247,7 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 	.rate_node_del = nsim_rate_node_del,
 	.rate_leaf_parent_set = nsim_rate_leaf_parent_set,
 	.rate_node_parent_set = nsim_rate_node_parent_set,
+	.trap_drop_counter_get = nsim_dev_devlink_trap_hw_counter_get,
 };
 
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index cdfdf2a99578..f2304e61919a 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -249,6 +249,7 @@ struct nsim_dev {
 	bool fail_trap_group_set;
 	bool fail_trap_policer_set;
 	bool fail_trap_policer_counter_get;
+	bool fail_trap_counter_get;
 	struct {
 		struct udp_tunnel_nic_shared utn_shared;
 		u32 __ports[2][NSIM_UDP_TUNNEL_N_PORTS];
-- 
2.17.1

