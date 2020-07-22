Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4976229C69
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbgGVP5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:57:37 -0400
Received: from mail-am6eur05on2056.outbound.protection.outlook.com ([40.107.22.56]:40624
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726427AbgGVP5f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 11:57:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKN7Sb3BTPt6sTW8k4kYmsln8VTQoGz7KUBgiapWHFchZgRm1Z7UgHQc2LFgOfmEog1NqUGs8Xju/RMBTEY7jgdO4lu/gTAXBHj7uQnORfuXzPEfTYMINQj1MSa9DQfbzxWvDQBFHS0cPQuuLYSNtMPD8pK7t1kFFR8h9veig+O/p68M7Ngwh8MwELoQrnlfDrAbVOl6MDaoFstVNGsd/KiXoT+E/lhESPijQ+lBQxv9NsCwtGRKFFKLDdrqq+HhWRO66grCb/LwJUja8DhPJzXUhhZqcACNrjCQwHn7Fgo5qf9PGPKrJfuoEjHrl/eYoIRgi/oox1HcQ27qB8tx0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pfluCjouguPPaJ7+uTE+HyOH5CHetLDWl0npqEhA7Ac=;
 b=X16Vy5lJykbTgbg1ZjaLIryHUkKubErMNQQuR4YM0pQv0hx+0TK4a97MyxyMWA/GxwID0qLo+qxdS0PNzW/kqawqPsSPN76l1AIGr5CZInOf2mROxx0ws1zIPp1hcV3UeDi2hdB7ECPT7inOAln6b/M0iMRHL4Yg4k0ejA/mhfoChZdm2+ukxKaMavayxl0HWncmLody2uKpzWf55KsEtLyJWAwAdXS7cRRd/1PWe8JzvnmMtF3TySArq1+/qtQLBLU97pF7t/TTT2LhZUX30i6q86FoW47S+UvaMFKQ7mHVrldb9krTafD3GKpv30kL+lZJ1CV6fIZ8sp4Nhs2Fnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pfluCjouguPPaJ7+uTE+HyOH5CHetLDWl0npqEhA7Ac=;
 b=tQG7ETdHWPAfRvrnMkfgecTdu4ZL/aO4AEePMFVmhEQjwZ3jC8Inn48co8U47uZBEdEI8wR2G1XxRsAxIW7coPBRDtS6Q8DDi3RuZ7AXs7UP87v+TKkUiDQLpOEtpERQnOkeejhCTRB/j4KafOm6elnNZ6qWP1q+zy4o1XZLRNM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6068.eurprd05.prod.outlook.com (20.178.119.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.21; Wed, 22 Jul 2020 15:57:27 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3195.028; Wed, 22 Jul 2020
 15:57:27 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     jiri@mellanox.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next] devlink: Always use user_ptr[0] for devlink and simplify post_doit
Date:   Wed, 22 Jul 2020 18:57:11 +0300
Message-Id: <20200722155711.976214-1-parav@mellanox.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0026.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::39) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c-141-251-1-009.mtl.labs.mlnx (94.188.199.18) by AM0PR02CA0026.eurprd02.prod.outlook.com (2603:10a6:208:3e::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Wed, 22 Jul 2020 15:57:26 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3185282d-5182-4a6f-147f-08d82e57ee8a
X-MS-TrafficTypeDiagnostic: AM0PR05MB6068:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB60681A82012D209380AA8984D1790@AM0PR05MB6068.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9HKalvlJzbH+Lfepv0IytyvTm0BG/SJJQLdqy+urMyK2n08Z6EvVZADMPcCRlnpC++ZrX9FD42jWpxbAtn1tQL969tC66p6lT6ZT3VsPi7lNRND6n0glDaUbnAtkPwxdOfNE/nT12Ew0/zCZEvMhdADQCxO5N14ysGN6HpcFyx1aATYGrs30Wh0lJdoWu7Umycd0w9XYNNHrBbC45RZHFVOGoZhKs3YFHJnTs5pf/fYOqGi+Vv8WzM5frH0qvX7jrAdbAH8YGmAKkDcezeA1ahDlx31ZqaP8ub7tlvLtIQn7xcKjT2k7QyyxrR3iFl4f4LsyicN+lDVE476c3Yzswg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(478600001)(6666004)(2906002)(16526019)(186003)(26005)(5660300002)(1076003)(30864003)(36756003)(52116002)(316002)(6506007)(8936002)(83380400001)(8676002)(86362001)(956004)(2616005)(6486002)(66556008)(66476007)(66946007)(6512007)(107886003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bTRJKEhCtcKIFwio6nSuVGow6kY9SqO4NARf0DrYMVBg7nhj5AdPaNo7aXAANoRuieuzTQH9swz3w9fs8DSbUXx2gO2dxOcDisJ6nKXdOjNIMoX2IOEYfqjpM4PsOPWqBgU0KR9jVTBZHLiXnTVy5QTsUeN5Gne0ULY11hCrGeju41WuFuzebRTPOqewfGBmS/6Zk35CTRChqm0kL8irAmRXpNyPsDRO430l00SOa3jKQx8k08z2AhiVJfNLZH1Bx87NhlKFjjYaH3InEbH8RJukly9ESMfIFs4lPW+cqBJAVXY/Ydp9bCV7/04qJ62OtBPi8BJLpK3jBfvPjHbMxZy040V2M6S0q+YoQOqMWj+vcTPwFGINNEzI7D6S2gr2oJAzIbl353gi2S9npBm3rh/CvYy+zHXRK5mkDH0B/tDDP+IVsiKi23noieDqoSsHyPfEfTMQ7ziWeyE2JKX6phBPHGpbeBNmUIkHugDptbHTHIy4xrAkwa9MlRCzz3df
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3185282d-5182-4a6f-147f-08d82e57ee8a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2020 15:57:27.4302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fbn+kuCF8uwtOP930LjUIdJNGfGgUMzWr9UUPrumA3xC9f01Y0DL6mSlL25VGx93XUbvDtmwd4qJqO1PdMDhrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6068
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently devlink instance is searched on all doit() operations.
But it is optionally stored into user_ptr[0]. This requires
rediscovering devlink again doing post_doit().

Few devlink commands related to port shared buffers needs 3 pointers
(devlink, devlink_port, and devlink_sb) while executing doit commands.
Though devlink pointer can be derived from the devlink_port during
post_doit() operation when doit() callback has acquired devlink
instance lock, relying on such scheme to access devlik pointer makes
code very fragile.

Hence, to avoid ambiguity in post_doit() and to avoid searching
devlink instance again, simplify code by always storing devlink
instance in user_ptr[0] and derive devlink_sb pointer in their
respective callback routines.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 164 +++++++++++++++++++--------------------------
 1 file changed, 70 insertions(+), 94 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 8b7bb4bfb6d0..0ca89196a367 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -386,16 +386,14 @@ devlink_region_snapshot_get_by_id(struct devlink_region *region, u32 id)
 	return NULL;
 }
 
-#define DEVLINK_NL_FLAG_NEED_DEVLINK		BIT(0)
-#define DEVLINK_NL_FLAG_NEED_PORT		BIT(1)
-#define DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT	BIT(2)
-#define DEVLINK_NL_FLAG_NEED_SB			BIT(3)
+#define DEVLINK_NL_FLAG_NEED_PORT		BIT(0)
+#define DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT	BIT(1)
 
 /* The per devlink instance lock is taken by default in the pre-doit
  * operation, yet several commands do not require this. The global
  * devlink lock is taken and protects from disruption by user-calls.
  */
-#define DEVLINK_NL_FLAG_NO_LOCK			BIT(4)
+#define DEVLINK_NL_FLAG_NO_LOCK			BIT(2)
 
 static int devlink_nl_pre_doit(const struct genl_ops *ops,
 			       struct sk_buff *skb, struct genl_info *info)
@@ -412,31 +410,19 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 	}
 	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
 		mutex_lock(&devlink->lock);
-	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_DEVLINK) {
-		info->user_ptr[0] = devlink;
-	} else if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_PORT) {
+	info->user_ptr[0] = devlink;
+	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_PORT) {
 		devlink_port = devlink_port_get_from_info(devlink, info);
 		if (IS_ERR(devlink_port)) {
 			err = PTR_ERR(devlink_port);
 			goto unlock;
 		}
-		info->user_ptr[0] = devlink_port;
+		info->user_ptr[1] = devlink_port;
 	} else if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT) {
-		info->user_ptr[0] = devlink;
 		devlink_port = devlink_port_get_from_info(devlink, info);
 		if (!IS_ERR(devlink_port))
 			info->user_ptr[1] = devlink_port;
 	}
-	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_SB) {
-		struct devlink_sb *devlink_sb;
-
-		devlink_sb = devlink_sb_get_from_info(devlink, info);
-		if (IS_ERR(devlink_sb)) {
-			err = PTR_ERR(devlink_sb);
-			goto unlock;
-		}
-		info->user_ptr[1] = devlink_sb;
-	}
 	return 0;
 
 unlock:
@@ -451,16 +437,8 @@ static void devlink_nl_post_doit(const struct genl_ops *ops,
 {
 	struct devlink *devlink;
 
-	/* When devlink changes netns, it would not be found
-	 * by devlink_get_from_info(). So try if it is stored first.
-	 */
-	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_DEVLINK) {
-		devlink = info->user_ptr[0];
-	} else {
-		devlink = devlink_get_from_info(info);
-		WARN_ON(IS_ERR(devlink));
-	}
-	if (!IS_ERR(devlink) && ~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
+	devlink = info->user_ptr[0];
+	if (~ops->internal_flags & DEVLINK_NL_FLAG_NO_LOCK)
 		mutex_unlock(&devlink->lock);
 	mutex_unlock(&devlink_mutex);
 }
@@ -759,7 +737,7 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 static int devlink_nl_cmd_port_get_doit(struct sk_buff *skb,
 					struct genl_info *info)
 {
-	struct devlink_port *devlink_port = info->user_ptr[0];
+	struct devlink_port *devlink_port = info->user_ptr[1];
 	struct devlink *devlink = devlink_port->devlink;
 	struct sk_buff *msg;
 	int err;
@@ -906,7 +884,7 @@ devlink_port_function_set(struct devlink *devlink, struct devlink_port *port,
 static int devlink_nl_cmd_port_set_doit(struct sk_buff *skb,
 					struct genl_info *info)
 {
-	struct devlink_port *devlink_port = info->user_ptr[0];
+	struct devlink_port *devlink_port = info->user_ptr[1];
 	struct devlink *devlink = devlink_port->devlink;
 	int err;
 
@@ -1041,10 +1019,14 @@ static int devlink_nl_cmd_sb_get_doit(struct sk_buff *skb,
 				      struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
-	struct devlink_sb *devlink_sb = info->user_ptr[1];
+	struct devlink_sb *devlink_sb;
 	struct sk_buff *msg;
 	int err;
 
+	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	if (IS_ERR(devlink_sb))
+		return PTR_ERR(devlink_sb);
+
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
@@ -1146,11 +1128,15 @@ static int devlink_nl_cmd_sb_pool_get_doit(struct sk_buff *skb,
 					   struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
-	struct devlink_sb *devlink_sb = info->user_ptr[1];
+	struct devlink_sb *devlink_sb;
 	struct sk_buff *msg;
 	u16 pool_index;
 	int err;
 
+	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	if (IS_ERR(devlink_sb))
+		return PTR_ERR(devlink_sb);
+
 	err = devlink_sb_pool_index_get_from_info(devlink_sb, info,
 						  &pool_index);
 	if (err)
@@ -1255,12 +1241,16 @@ static int devlink_nl_cmd_sb_pool_set_doit(struct sk_buff *skb,
 					   struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
-	struct devlink_sb *devlink_sb = info->user_ptr[1];
 	enum devlink_sb_threshold_type threshold_type;
+	struct devlink_sb *devlink_sb;
 	u16 pool_index;
 	u32 size;
 	int err;
 
+	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	if (IS_ERR(devlink_sb))
+		return PTR_ERR(devlink_sb);
+
 	err = devlink_sb_pool_index_get_from_info(devlink_sb, info,
 						  &pool_index);
 	if (err)
@@ -1339,13 +1329,17 @@ static int devlink_nl_sb_port_pool_fill(struct sk_buff *msg,
 static int devlink_nl_cmd_sb_port_pool_get_doit(struct sk_buff *skb,
 						struct genl_info *info)
 {
-	struct devlink_port *devlink_port = info->user_ptr[0];
+	struct devlink_port *devlink_port = info->user_ptr[1];
 	struct devlink *devlink = devlink_port->devlink;
-	struct devlink_sb *devlink_sb = info->user_ptr[1];
+	struct devlink_sb *devlink_sb;
 	struct sk_buff *msg;
 	u16 pool_index;
 	int err;
 
+	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	if (IS_ERR(devlink_sb))
+		return PTR_ERR(devlink_sb);
+
 	err = devlink_sb_pool_index_get_from_info(devlink_sb, info,
 						  &pool_index);
 	if (err)
@@ -1455,12 +1449,17 @@ static int devlink_sb_port_pool_set(struct devlink_port *devlink_port,
 static int devlink_nl_cmd_sb_port_pool_set_doit(struct sk_buff *skb,
 						struct genl_info *info)
 {
-	struct devlink_port *devlink_port = info->user_ptr[0];
-	struct devlink_sb *devlink_sb = info->user_ptr[1];
+	struct devlink_port *devlink_port = info->user_ptr[1];
+	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_sb *devlink_sb;
 	u16 pool_index;
 	u32 threshold;
 	int err;
 
+	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	if (IS_ERR(devlink_sb))
+		return PTR_ERR(devlink_sb);
+
 	err = devlink_sb_pool_index_get_from_info(devlink_sb, info,
 						  &pool_index);
 	if (err)
@@ -1542,14 +1541,18 @@ devlink_nl_sb_tc_pool_bind_fill(struct sk_buff *msg, struct devlink *devlink,
 static int devlink_nl_cmd_sb_tc_pool_bind_get_doit(struct sk_buff *skb,
 						   struct genl_info *info)
 {
-	struct devlink_port *devlink_port = info->user_ptr[0];
+	struct devlink_port *devlink_port = info->user_ptr[1];
 	struct devlink *devlink = devlink_port->devlink;
-	struct devlink_sb *devlink_sb = info->user_ptr[1];
+	struct devlink_sb *devlink_sb;
 	struct sk_buff *msg;
 	enum devlink_sb_pool_type pool_type;
 	u16 tc_index;
 	int err;
 
+	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	if (IS_ERR(devlink_sb))
+		return PTR_ERR(devlink_sb);
+
 	err = devlink_sb_pool_type_get_from_info(info, &pool_type);
 	if (err)
 		return err;
@@ -1689,14 +1692,19 @@ static int devlink_sb_tc_pool_bind_set(struct devlink_port *devlink_port,
 static int devlink_nl_cmd_sb_tc_pool_bind_set_doit(struct sk_buff *skb,
 						   struct genl_info *info)
 {
-	struct devlink_port *devlink_port = info->user_ptr[0];
-	struct devlink_sb *devlink_sb = info->user_ptr[1];
+	struct devlink_port *devlink_port = info->user_ptr[1];
+	struct devlink *devlink = info->user_ptr[0];
 	enum devlink_sb_pool_type pool_type;
+	struct devlink_sb *devlink_sb;
 	u16 tc_index;
 	u16 pool_index;
 	u32 threshold;
 	int err;
 
+	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	if (IS_ERR(devlink_sb))
+		return PTR_ERR(devlink_sb);
+
 	err = devlink_sb_pool_type_get_from_info(info, &pool_type);
 	if (err)
 		return err;
@@ -1724,8 +1732,12 @@ static int devlink_nl_cmd_sb_occ_snapshot_doit(struct sk_buff *skb,
 					       struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
-	struct devlink_sb *devlink_sb = info->user_ptr[1];
 	const struct devlink_ops *ops = devlink->ops;
+	struct devlink_sb *devlink_sb;
+
+	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	if (IS_ERR(devlink_sb))
+		return PTR_ERR(devlink_sb);
 
 	if (ops->sb_occ_snapshot)
 		return ops->sb_occ_snapshot(devlink, devlink_sb->index);
@@ -1736,8 +1748,12 @@ static int devlink_nl_cmd_sb_occ_max_clear_doit(struct sk_buff *skb,
 						struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
-	struct devlink_sb *devlink_sb = info->user_ptr[1];
 	const struct devlink_ops *ops = devlink->ops;
+	struct devlink_sb *devlink_sb;
+
+	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	if (IS_ERR(devlink_sb))
+		return PTR_ERR(devlink_sb);
 
 	if (ops->sb_occ_max_clear)
 		return ops->sb_occ_max_clear(devlink, devlink_sb->index);
@@ -7018,7 +7034,6 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_get_doit,
 		.dumpit = devlink_nl_cmd_get_dumpit,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -7041,24 +7056,20 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_split_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_UNSPLIT,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_unsplit_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_SB_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_get_doit,
 		.dumpit = devlink_nl_cmd_sb_get_dumpit,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
-				  DEVLINK_NL_FLAG_NEED_SB,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -7066,8 +7077,6 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_pool_get_doit,
 		.dumpit = devlink_nl_cmd_sb_pool_get_dumpit,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
-				  DEVLINK_NL_FLAG_NEED_SB,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -7075,16 +7084,13 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_pool_set_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
-				  DEVLINK_NL_FLAG_NEED_SB,
 	},
 	{
 		.cmd = DEVLINK_CMD_SB_PORT_POOL_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_port_pool_get_doit,
 		.dumpit = devlink_nl_cmd_sb_port_pool_get_dumpit,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT |
-				  DEVLINK_NL_FLAG_NEED_SB,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -7092,16 +7098,14 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_port_pool_set_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT |
-				  DEVLINK_NL_FLAG_NEED_SB,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_SB_TC_POOL_BIND_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_tc_pool_bind_get_doit,
 		.dumpit = devlink_nl_cmd_sb_tc_pool_bind_get_dumpit,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT |
-				  DEVLINK_NL_FLAG_NEED_SB,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -7109,60 +7113,50 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_tc_pool_bind_set_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT |
-				  DEVLINK_NL_FLAG_NEED_SB,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_SB_OCC_SNAPSHOT,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_occ_snapshot_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
-				  DEVLINK_NL_FLAG_NEED_SB,
 	},
 	{
 		.cmd = DEVLINK_CMD_SB_OCC_MAX_CLEAR,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_occ_max_clear_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
-				  DEVLINK_NL_FLAG_NEED_SB,
 	},
 	{
 		.cmd = DEVLINK_CMD_ESWITCH_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_eswitch_get_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_ESWITCH_SET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_eswitch_set_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_DPIPE_TABLE_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_dpipe_table_get,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 		/* can be retrieved by unprivileged users */
 	},
 	{
 		.cmd = DEVLINK_CMD_DPIPE_ENTRIES_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_dpipe_entries_get,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 		/* can be retrieved by unprivileged users */
 	},
 	{
 		.cmd = DEVLINK_CMD_DPIPE_HEADERS_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_dpipe_headers_get,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -7170,20 +7164,17 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_dpipe_table_counters_set,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_RESOURCE_SET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_resource_set,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_RESOURCE_DUMP,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_resource_dump,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -7191,15 +7182,13 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_reload,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_PARAM_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_param_get_doit,
 		.dumpit = devlink_nl_cmd_param_get_dumpit,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -7207,7 +7196,6 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_param_set_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_PARAM_GET,
@@ -7230,21 +7218,18 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.doit = devlink_nl_cmd_region_get_doit,
 		.dumpit = devlink_nl_cmd_region_get_dumpit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_REGION_NEW,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_region_new,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_REGION_DEL,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_region_del,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_REGION_READ,
@@ -7252,14 +7237,12 @@ static const struct genl_ops devlink_nl_ops[] = {
 			    GENL_DONT_VALIDATE_DUMP_STRICT,
 		.dumpit = devlink_nl_cmd_region_read_dumpit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_INFO_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_info_get_doit,
 		.dumpit = devlink_nl_cmd_info_get_dumpit,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -7317,46 +7300,39 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_flash_update,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_TRAP_GET,
 		.doit = devlink_nl_cmd_trap_get_doit,
 		.dumpit = devlink_nl_cmd_trap_get_dumpit,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 		/* can be retrieved by unprivileged users */
 	},
 	{
 		.cmd = DEVLINK_CMD_TRAP_SET,
 		.doit = devlink_nl_cmd_trap_set_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_TRAP_GROUP_GET,
 		.doit = devlink_nl_cmd_trap_group_get_doit,
 		.dumpit = devlink_nl_cmd_trap_group_get_dumpit,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 		/* can be retrieved by unprivileged users */
 	},
 	{
 		.cmd = DEVLINK_CMD_TRAP_GROUP_SET,
 		.doit = devlink_nl_cmd_trap_group_set_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_TRAP_POLICER_GET,
 		.doit = devlink_nl_cmd_trap_policer_get_doit,
 		.dumpit = devlink_nl_cmd_trap_policer_get_dumpit,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 		/* can be retrieved by unprivileged users */
 	},
 	{
 		.cmd = DEVLINK_CMD_TRAP_POLICER_SET,
 		.doit = devlink_nl_cmd_trap_policer_set_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 };
 
-- 
2.25.4

