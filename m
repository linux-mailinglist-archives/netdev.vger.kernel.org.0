Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FD3688066
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 15:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbjBBOsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 09:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbjBBOsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 09:48:25 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9044204;
        Thu,  2 Feb 2023 06:47:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hLazDZ5lcRUowzKZr7J31dQXc2jHVgJgymOh5kCnwRYDU4CCE2I5IcMxCDZZ89Z3/cYcdI+9KOaXnDnC3YzjFLVvU42lhvNEwg4cIR9NRFqWEGEqTw0Ikz2fk051+n51uETKUdNysOZ6BUEW878X0lxlCMyDZDB1tt91c7845VuCB57B8xuExLdb20J4kTfabc4nLymhTBS3bj9Uqmi2tLyFW10O++Jea4dp9eY/aNMf+wEfBFEggWs6Vx9UcNHOWtwNH1fuEieP90z4zKuVk0TC9XjmYK2jG4kqhC0ArdhF/+KIs2sjopvc8Go+m875cHnmvXKAUxiQnJrGAKaxwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLWgAttgnCKp9maVJs8uKjN0YGpMEs7MueFkz+EHGAU=;
 b=FERsvfLCwH+tUu01Dx8v+Y+jZfbQ23i7AWpxlDjaA9xY0KGBwJWBSfsT2lnTrj5UBKiF/ohiq8NuxcbUnYghEeugsMZS3DjNj0Tna9NSQxBsLJghUHtxMyw7797yyzyjCdidqwQU4NMgcep5qbXdYp+DlHAE7Aa7PiUxTjPhH/gTKcNiJfdfAkD77L1VoSLjUfbZwqS7bxUE22Z0GWyF3y377OofOb4astB7dHRansl+Y4mHBWbYLF7eXC+iPtox2wYb+QGld+iZQY7megaH9vyaWU/kZ3AEG4MgngjtBuLb5q1R/+rfZwv7FqUCVswkq0mBo6cYKMXEcIWSEFojuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLWgAttgnCKp9maVJs8uKjN0YGpMEs7MueFkz+EHGAU=;
 b=sc2YrJLHuKSTyrekQKsDcPKFkYI1bftpz+5f7zceFDnZ8B1mgJMEUtoA01DaYyo1U7fFO5lq2TC1LlNHMxA2xDuxFfcrpJWUjTh6gOc0ME415B0o4QaomHnvuoKbjI05hYeFK51rdaQL2DfCtoT041Nce3Y2zOPLdWuMKknxHo1HmL/j0nLX5y0RIANMmLLfaDa2X/PtYGv0vqoVn+8cF9PCNDrde5xP1tRznPkCBSivyJcnZjDfT8OYsuepP40u5Yi8bEOZvSXgWAl1qKF59C0cS0dDQo1P7HWr7fGOldjsMVS393SImzbvSRi2da6FwDLlxaNMOSeQgaCJrtOArg==
Received: from DM6PR13CA0011.namprd13.prod.outlook.com (2603:10b6:5:bc::24) by
 BL0PR12MB5010.namprd12.prod.outlook.com (2603:10b6:208:17c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Thu, 2 Feb
 2023 14:47:54 +0000
Received: from DS1PEPF0000E65A.namprd02.prod.outlook.com
 (2603:10b6:5:bc:cafe::88) by DM6PR13CA0011.outlook.office365.com
 (2603:10b6:5:bc::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.7 via Frontend
 Transport; Thu, 2 Feb 2023 14:47:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E65A.mail.protection.outlook.com (10.167.18.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.21 via Frontend Transport; Thu, 2 Feb 2023 14:47:54 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 06:47:44 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 06:47:44 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 2 Feb
 2023 06:47:42 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 2/7] devlink: Move devlink dev reload code to dev
Date:   Thu, 2 Feb 2023 16:47:01 +0200
Message-ID: <1675349226-284034-3-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
References: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E65A:EE_|BL0PR12MB5010:EE_
X-MS-Office365-Filtering-Correlation-Id: 4684d43e-b74c-478b-2687-08db052c77a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C5prhh8xoNs6DaoRcIRVuGZ43ETp4swTX5yX1nSMvqc7M5IvLA9aRfkIRQyRxx2M2c1UKNA4G11XiVvGMVod0pcNnmlJHq06Uv6vA5d+SudIvSYR1tGpSdQ7/ezFnltNd7LjsUrmse1juC+qqc66IPqgqU5CAqQ3/TS1p1yXg56nZ4R/lFe4ybrxhxSk72ydaFsNHQtmXuzFNHZJIS3yBDDQyzIZPjQB2G9ACsmlaOtXNUDtGCOCrSKAEhg8eRuS1zkkLCkAEZhRzBUXtdUi/sWpV5OKlltX6CzMVzI+o1G+6xIFkRMxxmGhRPpt1aWGwzr+EBmiVfRISUj7E/UgXNpeTzi5M73vKD5+rXZ2Xljk/x0XxRrgH7GnqcvymvZkHN1hVjrz4iuRa0/+vS3hJj5tsgUL/e+rS4ui1i/IZtgbhghR9uNX0QC/Qq0GvAr8AxbDka9lSjhErFfz4K62p5Ulorrckp7OCph9YM22vHPEjWYA+tC5ob9grQXSaOLX0IYFYN8Qs6vYSrX+vVdR4JW3SNVjCaJKkbztml2LnJi+DT6Om0HmY+iXq3gUXYZJnuATPGoxtQgO0S6NFsEVdfHjJ91jJvTfPQ8qdLxw5wBLuxNws9JkvH1siRAtpiaAFTzvqkjOrLbwd1tJoyWA5/ot/QWCNyf5XjYKwhwWiGVYje7A0tDv+r84NfrDayf8Ib0Z7qLhAXlRkuE36/EZtV5G0yqsuWUcx3N/4WsgeTUxTtSrUOGI3sIDbhq4LKFdzeCCcQBkEtCh1vcDTGnZSw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199018)(40470700004)(46966006)(36840700001)(36756003)(478600001)(70586007)(82310400005)(8676002)(4326008)(83380400001)(7636003)(36860700001)(110136005)(54906003)(82740400003)(316002)(107886003)(6666004)(26005)(186003)(30864003)(5660300002)(86362001)(40480700001)(356005)(426003)(47076005)(41300700001)(2616005)(70206006)(40460700003)(8936002)(336012)(7696005)(2906002)(461764006)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 14:47:54.5284
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4684d43e-b74c-478b-2687-08db052c77a4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E65A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5010
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move devlink dev reload callback and related code from leftover.c to
file dev.c. No functional change in this patch.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
 net/devlink/dev.c           | 417 +++++++++++++++++++++++++++++++++++
 net/devlink/devl_internal.h |   9 +-
 net/devlink/leftover.c      | 422 +-----------------------------------
 3 files changed, 427 insertions(+), 421 deletions(-)

diff --git a/net/devlink/dev.c b/net/devlink/dev.c
index 6a26dc7edef6..0d6c14b89d03 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -5,8 +5,131 @@
  */
 
 #include <net/genetlink.h>
+#include <net/sock.h>
 #include "devl_internal.h"
 
+struct devlink_reload_combination {
+	enum devlink_reload_action action;
+	enum devlink_reload_limit limit;
+};
+
+static const struct devlink_reload_combination devlink_reload_invalid_combinations[] = {
+	{
+		/* can't reinitialize driver with no down time */
+		.action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
+		.limit = DEVLINK_RELOAD_LIMIT_NO_RESET,
+	},
+};
+
+static bool
+devlink_reload_combination_is_invalid(enum devlink_reload_action action,
+				      enum devlink_reload_limit limit)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(devlink_reload_invalid_combinations); i++)
+		if (devlink_reload_invalid_combinations[i].action == action &&
+		    devlink_reload_invalid_combinations[i].limit == limit)
+			return true;
+	return false;
+}
+
+static bool
+devlink_reload_action_is_supported(struct devlink *devlink, enum devlink_reload_action action)
+{
+	return test_bit(action, &devlink->ops->reload_actions);
+}
+
+static bool
+devlink_reload_limit_is_supported(struct devlink *devlink, enum devlink_reload_limit limit)
+{
+	return test_bit(limit, &devlink->ops->reload_limits);
+}
+
+static int devlink_reload_stat_put(struct sk_buff *msg,
+				   enum devlink_reload_limit limit, u32 value)
+{
+	struct nlattr *reload_stats_entry;
+
+	reload_stats_entry = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_STATS_ENTRY);
+	if (!reload_stats_entry)
+		return -EMSGSIZE;
+
+	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_STATS_LIMIT, limit) ||
+	    nla_put_u32(msg, DEVLINK_ATTR_RELOAD_STATS_VALUE, value))
+		goto nla_put_failure;
+	nla_nest_end(msg, reload_stats_entry);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(msg, reload_stats_entry);
+	return -EMSGSIZE;
+}
+
+static int
+devlink_reload_stats_put(struct sk_buff *msg, struct devlink *devlink, bool is_remote)
+{
+	struct nlattr *reload_stats_attr, *act_info, *act_stats;
+	int i, j, stat_idx;
+	u32 value;
+
+	if (!is_remote)
+		reload_stats_attr = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_STATS);
+	else
+		reload_stats_attr = nla_nest_start(msg, DEVLINK_ATTR_REMOTE_RELOAD_STATS);
+
+	if (!reload_stats_attr)
+		return -EMSGSIZE;
+
+	for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
+		if ((!is_remote &&
+		     !devlink_reload_action_is_supported(devlink, i)) ||
+		    i == DEVLINK_RELOAD_ACTION_UNSPEC)
+			continue;
+		act_info = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTION_INFO);
+		if (!act_info)
+			goto nla_put_failure;
+
+		if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION, i))
+			goto action_info_nest_cancel;
+		act_stats = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTION_STATS);
+		if (!act_stats)
+			goto action_info_nest_cancel;
+
+		for (j = 0; j <= DEVLINK_RELOAD_LIMIT_MAX; j++) {
+			/* Remote stats are shown even if not locally supported.
+			 * Stats of actions with unspecified limit are shown
+			 * though drivers don't need to register unspecified
+			 * limit.
+			 */
+			if ((!is_remote && j != DEVLINK_RELOAD_LIMIT_UNSPEC &&
+			     !devlink_reload_limit_is_supported(devlink, j)) ||
+			    devlink_reload_combination_is_invalid(i, j))
+				continue;
+
+			stat_idx = j * __DEVLINK_RELOAD_ACTION_MAX + i;
+			if (!is_remote)
+				value = devlink->stats.reload_stats[stat_idx];
+			else
+				value = devlink->stats.remote_reload_stats[stat_idx];
+			if (devlink_reload_stat_put(msg, j, value))
+				goto action_stats_nest_cancel;
+		}
+		nla_nest_end(msg, act_stats);
+		nla_nest_end(msg, act_info);
+	}
+	nla_nest_end(msg, reload_stats_attr);
+	return 0;
+
+action_stats_nest_cancel:
+	nla_nest_cancel(msg, act_stats);
+action_info_nest_cancel:
+	nla_nest_cancel(msg, act_info);
+nla_put_failure:
+	nla_nest_cancel(msg, reload_stats_attr);
+	return -EMSGSIZE;
+}
+
 static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 			   enum devlink_command cmd, u32 portid,
 			   u32 seq, int flags)
@@ -97,3 +220,297 @@ devlink_nl_cmd_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
 const struct devlink_cmd devl_cmd_get = {
 	.dump_one		= devlink_nl_cmd_get_dump_one,
 };
+
+static void devlink_reload_failed_set(struct devlink *devlink,
+				      bool reload_failed)
+{
+	if (devlink->reload_failed == reload_failed)
+		return;
+	devlink->reload_failed = reload_failed;
+	devlink_notify(devlink, DEVLINK_CMD_NEW);
+}
+
+bool devlink_is_reload_failed(const struct devlink *devlink)
+{
+	return devlink->reload_failed;
+}
+EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
+
+static void
+__devlink_reload_stats_update(struct devlink *devlink, u32 *reload_stats,
+			      enum devlink_reload_limit limit, u32 actions_performed)
+{
+	unsigned long actions = actions_performed;
+	int stat_idx;
+	int action;
+
+	for_each_set_bit(action, &actions, __DEVLINK_RELOAD_ACTION_MAX) {
+		stat_idx = limit * __DEVLINK_RELOAD_ACTION_MAX + action;
+		reload_stats[stat_idx]++;
+	}
+	devlink_notify(devlink, DEVLINK_CMD_NEW);
+}
+
+static void
+devlink_reload_stats_update(struct devlink *devlink, enum devlink_reload_limit limit,
+			    u32 actions_performed)
+{
+	__devlink_reload_stats_update(devlink, devlink->stats.reload_stats, limit,
+				      actions_performed);
+}
+
+/**
+ *	devlink_remote_reload_actions_performed - Update devlink on reload actions
+ *	  performed which are not a direct result of devlink reload call.
+ *
+ *	This should be called by a driver after performing reload actions in case it was not
+ *	a result of devlink reload call. For example fw_activate was performed as a result
+ *	of devlink reload triggered fw_activate on another host.
+ *	The motivation for this function is to keep data on reload actions performed on this
+ *	function whether it was done due to direct devlink reload call or not.
+ *
+ *	@devlink: devlink
+ *	@limit: reload limit
+ *	@actions_performed: bitmask of actions performed
+ */
+void devlink_remote_reload_actions_performed(struct devlink *devlink,
+					     enum devlink_reload_limit limit,
+					     u32 actions_performed)
+{
+	if (WARN_ON(!actions_performed ||
+		    actions_performed & BIT(DEVLINK_RELOAD_ACTION_UNSPEC) ||
+		    actions_performed >= BIT(__DEVLINK_RELOAD_ACTION_MAX) ||
+		    limit > DEVLINK_RELOAD_LIMIT_MAX))
+		return;
+
+	__devlink_reload_stats_update(devlink, devlink->stats.remote_reload_stats, limit,
+				      actions_performed);
+}
+EXPORT_SYMBOL_GPL(devlink_remote_reload_actions_performed);
+
+static struct net *devlink_netns_get(struct sk_buff *skb,
+				     struct genl_info *info)
+{
+	struct nlattr *netns_pid_attr = info->attrs[DEVLINK_ATTR_NETNS_PID];
+	struct nlattr *netns_fd_attr = info->attrs[DEVLINK_ATTR_NETNS_FD];
+	struct nlattr *netns_id_attr = info->attrs[DEVLINK_ATTR_NETNS_ID];
+	struct net *net;
+
+	if (!!netns_pid_attr + !!netns_fd_attr + !!netns_id_attr > 1) {
+		NL_SET_ERR_MSG_MOD(info->extack, "multiple netns identifying attributes specified");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (netns_pid_attr) {
+		net = get_net_ns_by_pid(nla_get_u32(netns_pid_attr));
+	} else if (netns_fd_attr) {
+		net = get_net_ns_by_fd(nla_get_u32(netns_fd_attr));
+	} else if (netns_id_attr) {
+		net = get_net_ns_by_id(sock_net(skb->sk),
+				       nla_get_u32(netns_id_attr));
+		if (!net)
+			net = ERR_PTR(-EINVAL);
+	} else {
+		WARN_ON(1);
+		net = ERR_PTR(-EINVAL);
+	}
+	if (IS_ERR(net)) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Unknown network namespace");
+		return ERR_PTR(-EINVAL);
+	}
+	if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN)) {
+		put_net(net);
+		return ERR_PTR(-EPERM);
+	}
+	return net;
+}
+
+static void devlink_reload_netns_change(struct devlink *devlink,
+					struct net *curr_net,
+					struct net *dest_net)
+{
+	/* Userspace needs to be notified about devlink objects
+	 * removed from original and entering new network namespace.
+	 * The rest of the devlink objects are re-created during
+	 * reload process so the notifications are generated separatelly.
+	 */
+	devlink_notify_unregister(devlink);
+	move_netdevice_notifier_net(curr_net, dest_net,
+				    &devlink->netdevice_nb);
+	write_pnet(&devlink->_net, dest_net);
+	devlink_notify_register(devlink);
+}
+
+int devlink_reload(struct devlink *devlink, struct net *dest_net,
+		   enum devlink_reload_action action,
+		   enum devlink_reload_limit limit,
+		   u32 *actions_performed, struct netlink_ext_ack *extack)
+{
+	u32 remote_reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
+	struct net *curr_net;
+	int err;
+
+	memcpy(remote_reload_stats, devlink->stats.remote_reload_stats,
+	       sizeof(remote_reload_stats));
+
+	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit, extack);
+	if (err)
+		return err;
+
+	curr_net = devlink_net(devlink);
+	if (dest_net && !net_eq(dest_net, curr_net))
+		devlink_reload_netns_change(devlink, curr_net, dest_net);
+
+	err = devlink->ops->reload_up(devlink, action, limit, actions_performed, extack);
+	devlink_reload_failed_set(devlink, !!err);
+	if (err)
+		return err;
+
+	WARN_ON(!(*actions_performed & BIT(action)));
+	/* Catch driver on updating the remote action within devlink reload */
+	WARN_ON(memcmp(remote_reload_stats, devlink->stats.remote_reload_stats,
+		       sizeof(remote_reload_stats)));
+	devlink_reload_stats_update(devlink, limit, *actions_performed);
+	return 0;
+}
+
+static int
+devlink_nl_reload_actions_performed_snd(struct devlink *devlink, u32 actions_performed,
+					enum devlink_command cmd, struct genl_info *info)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq, &devlink_nl_family, 0, cmd);
+	if (!hdr)
+		goto free_msg;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto nla_put_failure;
+
+	if (nla_put_bitfield32(msg, DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED, actions_performed,
+			       actions_performed))
+		goto nla_put_failure;
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_reply(msg, info);
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+free_msg:
+	nlmsg_free(msg);
+	return -EMSGSIZE;
+}
+
+int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	enum devlink_reload_action action;
+	enum devlink_reload_limit limit;
+	struct net *dest_net = NULL;
+	u32 actions_performed;
+	int err;
+
+	err = devlink_resources_validate(devlink, NULL, info);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(info->extack, "resources size validation failed");
+		return err;
+	}
+
+	if (info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
+		action = nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_ACTION]);
+	else
+		action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT;
+
+	if (!devlink_reload_action_is_supported(devlink, action)) {
+		NL_SET_ERR_MSG_MOD(info->extack,
+				   "Requested reload action is not supported by the driver");
+		return -EOPNOTSUPP;
+	}
+
+	limit = DEVLINK_RELOAD_LIMIT_UNSPEC;
+	if (info->attrs[DEVLINK_ATTR_RELOAD_LIMITS]) {
+		struct nla_bitfield32 limits;
+		u32 limits_selected;
+
+		limits = nla_get_bitfield32(info->attrs[DEVLINK_ATTR_RELOAD_LIMITS]);
+		limits_selected = limits.value & limits.selector;
+		if (!limits_selected) {
+			NL_SET_ERR_MSG_MOD(info->extack, "Invalid limit selected");
+			return -EINVAL;
+		}
+		for (limit = 0 ; limit <= DEVLINK_RELOAD_LIMIT_MAX ; limit++)
+			if (limits_selected & BIT(limit))
+				break;
+		/* UAPI enables multiselection, but currently it is not used */
+		if (limits_selected != BIT(limit)) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "Multiselection of limit is not supported");
+			return -EOPNOTSUPP;
+		}
+		if (!devlink_reload_limit_is_supported(devlink, limit)) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "Requested limit is not supported by the driver");
+			return -EOPNOTSUPP;
+		}
+		if (devlink_reload_combination_is_invalid(action, limit)) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "Requested limit is invalid for this action");
+			return -EINVAL;
+		}
+	}
+	if (info->attrs[DEVLINK_ATTR_NETNS_PID] ||
+	    info->attrs[DEVLINK_ATTR_NETNS_FD] ||
+	    info->attrs[DEVLINK_ATTR_NETNS_ID]) {
+		dest_net = devlink_netns_get(skb, info);
+		if (IS_ERR(dest_net))
+			return PTR_ERR(dest_net);
+	}
+
+	err = devlink_reload(devlink, dest_net, action, limit, &actions_performed, info->extack);
+
+	if (dest_net)
+		put_net(dest_net);
+
+	if (err)
+		return err;
+	/* For backward compatibility generate reply only if attributes used by user */
+	if (!info->attrs[DEVLINK_ATTR_RELOAD_ACTION] && !info->attrs[DEVLINK_ATTR_RELOAD_LIMITS])
+		return 0;
+
+	return devlink_nl_reload_actions_performed_snd(devlink, actions_performed,
+						       DEVLINK_CMD_RELOAD, info);
+}
+
+bool devlink_reload_actions_valid(const struct devlink_ops *ops)
+{
+	const struct devlink_reload_combination *comb;
+	int i;
+
+	if (!devlink_reload_supported(ops)) {
+		if (WARN_ON(ops->reload_actions))
+			return false;
+		return true;
+	}
+
+	if (WARN_ON(!ops->reload_actions ||
+		    ops->reload_actions & BIT(DEVLINK_RELOAD_ACTION_UNSPEC) ||
+		    ops->reload_actions >= BIT(__DEVLINK_RELOAD_ACTION_MAX)))
+		return false;
+
+	if (WARN_ON(ops->reload_limits & BIT(DEVLINK_RELOAD_LIMIT_UNSPEC) ||
+		    ops->reload_limits >= BIT(__DEVLINK_RELOAD_LIMIT_MAX)))
+		return false;
+
+	for (i = 0; i < ARRAY_SIZE(devlink_reload_invalid_combinations); i++)  {
+		comb = &devlink_reload_invalid_combinations[i];
+		if (ops->reload_actions == BIT(comb->action) &&
+		    ops->reload_limits == BIT(comb->limit))
+			return false;
+	}
+	return true;
+}
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 60dce85885b8..cb4a89ac42ec 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -179,8 +179,6 @@ devlink_port_get_from_info(struct devlink *devlink, struct genl_info *info);
 
 /* Reload */
 bool devlink_reload_actions_valid(const struct devlink_ops *ops);
-int devlink_reload_stats_put(struct sk_buff *msg, struct devlink *devlink,
-			     bool is_remote);
 int devlink_reload(struct devlink *devlink, struct net *dest_net,
 		   enum devlink_reload_action action,
 		   enum devlink_reload_limit limit,
@@ -191,6 +189,12 @@ static inline bool devlink_reload_supported(const struct devlink_ops *ops)
 	return ops->reload_down && ops->reload_up;
 }
 
+/* Resources */
+struct devlink_resource;
+int devlink_resources_validate(struct devlink *devlink,
+			       struct devlink_resource *resource,
+			       struct genl_info *info);
+
 /* Line cards */
 struct devlink_linecard;
 
@@ -205,3 +209,4 @@ devlink_rate_node_get_from_info(struct devlink *devlink,
 				struct genl_info *info);
 /* Devlink nl cmds */
 int devlink_nl_cmd_get_doit(struct sk_buff *skb, struct genl_info *info);
+int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 54c8ea87e76b..703a03d65df7 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -632,127 +632,6 @@ size_t devlink_nl_port_handle_size(struct devlink_port *devlink_port)
 	     + nla_total_size(4); /* DEVLINK_ATTR_PORT_INDEX */
 }
 
-struct devlink_reload_combination {
-	enum devlink_reload_action action;
-	enum devlink_reload_limit limit;
-};
-
-static const struct devlink_reload_combination devlink_reload_invalid_combinations[] = {
-	{
-		/* can't reinitialize driver with no down time */
-		.action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
-		.limit = DEVLINK_RELOAD_LIMIT_NO_RESET,
-	},
-};
-
-static bool
-devlink_reload_combination_is_invalid(enum devlink_reload_action action,
-				      enum devlink_reload_limit limit)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(devlink_reload_invalid_combinations); i++)
-		if (devlink_reload_invalid_combinations[i].action == action &&
-		    devlink_reload_invalid_combinations[i].limit == limit)
-			return true;
-	return false;
-}
-
-static bool
-devlink_reload_action_is_supported(struct devlink *devlink, enum devlink_reload_action action)
-{
-	return test_bit(action, &devlink->ops->reload_actions);
-}
-
-static bool
-devlink_reload_limit_is_supported(struct devlink *devlink, enum devlink_reload_limit limit)
-{
-	return test_bit(limit, &devlink->ops->reload_limits);
-}
-
-static int devlink_reload_stat_put(struct sk_buff *msg,
-				   enum devlink_reload_limit limit, u32 value)
-{
-	struct nlattr *reload_stats_entry;
-
-	reload_stats_entry = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_STATS_ENTRY);
-	if (!reload_stats_entry)
-		return -EMSGSIZE;
-
-	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_STATS_LIMIT, limit) ||
-	    nla_put_u32(msg, DEVLINK_ATTR_RELOAD_STATS_VALUE, value))
-		goto nla_put_failure;
-	nla_nest_end(msg, reload_stats_entry);
-	return 0;
-
-nla_put_failure:
-	nla_nest_cancel(msg, reload_stats_entry);
-	return -EMSGSIZE;
-}
-
-int devlink_reload_stats_put(struct sk_buff *msg, struct devlink *devlink, bool is_remote)
-{
-	struct nlattr *reload_stats_attr, *act_info, *act_stats;
-	int i, j, stat_idx;
-	u32 value;
-
-	if (!is_remote)
-		reload_stats_attr = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_STATS);
-	else
-		reload_stats_attr = nla_nest_start(msg, DEVLINK_ATTR_REMOTE_RELOAD_STATS);
-
-	if (!reload_stats_attr)
-		return -EMSGSIZE;
-
-	for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
-		if ((!is_remote &&
-		     !devlink_reload_action_is_supported(devlink, i)) ||
-		    i == DEVLINK_RELOAD_ACTION_UNSPEC)
-			continue;
-		act_info = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTION_INFO);
-		if (!act_info)
-			goto nla_put_failure;
-
-		if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION, i))
-			goto action_info_nest_cancel;
-		act_stats = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTION_STATS);
-		if (!act_stats)
-			goto action_info_nest_cancel;
-
-		for (j = 0; j <= DEVLINK_RELOAD_LIMIT_MAX; j++) {
-			/* Remote stats are shown even if not locally supported.
-			 * Stats of actions with unspecified limit are shown
-			 * though drivers don't need to register unspecified
-			 * limit.
-			 */
-			if ((!is_remote && j != DEVLINK_RELOAD_LIMIT_UNSPEC &&
-			     !devlink_reload_limit_is_supported(devlink, j)) ||
-			    devlink_reload_combination_is_invalid(i, j))
-				continue;
-
-			stat_idx = j * __DEVLINK_RELOAD_ACTION_MAX + i;
-			if (!is_remote)
-				value = devlink->stats.reload_stats[stat_idx];
-			else
-				value = devlink->stats.remote_reload_stats[stat_idx];
-			if (devlink_reload_stat_put(msg, j, value))
-				goto action_stats_nest_cancel;
-		}
-		nla_nest_end(msg, act_stats);
-		nla_nest_end(msg, act_info);
-	}
-	nla_nest_end(msg, reload_stats_attr);
-	return 0;
-
-action_stats_nest_cancel:
-	nla_nest_cancel(msg, act_stats);
-action_info_nest_cancel:
-	nla_nest_cancel(msg, act_info);
-nla_put_failure:
-	nla_nest_cancel(msg, reload_stats_attr);
-	return -EMSGSIZE;
-}
-
 static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 				     struct devlink_port *devlink_port)
 {
@@ -4070,10 +3949,9 @@ static int devlink_nl_cmd_resource_dump(struct sk_buff *skb,
 	return devlink_resource_fill(info, DEVLINK_CMD_RESOURCE_DUMP, 0);
 }
 
-static int
-devlink_resources_validate(struct devlink *devlink,
-			   struct devlink_resource *resource,
-			   struct genl_info *info)
+int devlink_resources_validate(struct devlink *devlink,
+			       struct devlink_resource *resource,
+			       struct genl_info *info)
 {
 	struct list_head *resource_list;
 	int err = 0;
@@ -4093,271 +3971,6 @@ devlink_resources_validate(struct devlink *devlink,
 	return err;
 }
 
-static struct net *devlink_netns_get(struct sk_buff *skb,
-				     struct genl_info *info)
-{
-	struct nlattr *netns_pid_attr = info->attrs[DEVLINK_ATTR_NETNS_PID];
-	struct nlattr *netns_fd_attr = info->attrs[DEVLINK_ATTR_NETNS_FD];
-	struct nlattr *netns_id_attr = info->attrs[DEVLINK_ATTR_NETNS_ID];
-	struct net *net;
-
-	if (!!netns_pid_attr + !!netns_fd_attr + !!netns_id_attr > 1) {
-		NL_SET_ERR_MSG_MOD(info->extack, "multiple netns identifying attributes specified");
-		return ERR_PTR(-EINVAL);
-	}
-
-	if (netns_pid_attr) {
-		net = get_net_ns_by_pid(nla_get_u32(netns_pid_attr));
-	} else if (netns_fd_attr) {
-		net = get_net_ns_by_fd(nla_get_u32(netns_fd_attr));
-	} else if (netns_id_attr) {
-		net = get_net_ns_by_id(sock_net(skb->sk),
-				       nla_get_u32(netns_id_attr));
-		if (!net)
-			net = ERR_PTR(-EINVAL);
-	} else {
-		WARN_ON(1);
-		net = ERR_PTR(-EINVAL);
-	}
-	if (IS_ERR(net)) {
-		NL_SET_ERR_MSG_MOD(info->extack, "Unknown network namespace");
-		return ERR_PTR(-EINVAL);
-	}
-	if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN)) {
-		put_net(net);
-		return ERR_PTR(-EPERM);
-	}
-	return net;
-}
-
-static void devlink_reload_netns_change(struct devlink *devlink,
-					struct net *curr_net,
-					struct net *dest_net)
-{
-	/* Userspace needs to be notified about devlink objects
-	 * removed from original and entering new network namespace.
-	 * The rest of the devlink objects are re-created during
-	 * reload process so the notifications are generated separatelly.
-	 */
-	devlink_notify_unregister(devlink);
-	move_netdevice_notifier_net(curr_net, dest_net,
-				    &devlink->netdevice_nb);
-	write_pnet(&devlink->_net, dest_net);
-	devlink_notify_register(devlink);
-}
-
-static void devlink_reload_failed_set(struct devlink *devlink,
-				      bool reload_failed)
-{
-	if (devlink->reload_failed == reload_failed)
-		return;
-	devlink->reload_failed = reload_failed;
-	devlink_notify(devlink, DEVLINK_CMD_NEW);
-}
-
-bool devlink_is_reload_failed(const struct devlink *devlink)
-{
-	return devlink->reload_failed;
-}
-EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
-
-static void
-__devlink_reload_stats_update(struct devlink *devlink, u32 *reload_stats,
-			      enum devlink_reload_limit limit, u32 actions_performed)
-{
-	unsigned long actions = actions_performed;
-	int stat_idx;
-	int action;
-
-	for_each_set_bit(action, &actions, __DEVLINK_RELOAD_ACTION_MAX) {
-		stat_idx = limit * __DEVLINK_RELOAD_ACTION_MAX + action;
-		reload_stats[stat_idx]++;
-	}
-	devlink_notify(devlink, DEVLINK_CMD_NEW);
-}
-
-static void
-devlink_reload_stats_update(struct devlink *devlink, enum devlink_reload_limit limit,
-			    u32 actions_performed)
-{
-	__devlink_reload_stats_update(devlink, devlink->stats.reload_stats, limit,
-				      actions_performed);
-}
-
-/**
- *	devlink_remote_reload_actions_performed - Update devlink on reload actions
- *	  performed which are not a direct result of devlink reload call.
- *
- *	This should be called by a driver after performing reload actions in case it was not
- *	a result of devlink reload call. For example fw_activate was performed as a result
- *	of devlink reload triggered fw_activate on another host.
- *	The motivation for this function is to keep data on reload actions performed on this
- *	function whether it was done due to direct devlink reload call or not.
- *
- *	@devlink: devlink
- *	@limit: reload limit
- *	@actions_performed: bitmask of actions performed
- */
-void devlink_remote_reload_actions_performed(struct devlink *devlink,
-					     enum devlink_reload_limit limit,
-					     u32 actions_performed)
-{
-	if (WARN_ON(!actions_performed ||
-		    actions_performed & BIT(DEVLINK_RELOAD_ACTION_UNSPEC) ||
-		    actions_performed >= BIT(__DEVLINK_RELOAD_ACTION_MAX) ||
-		    limit > DEVLINK_RELOAD_LIMIT_MAX))
-		return;
-
-	__devlink_reload_stats_update(devlink, devlink->stats.remote_reload_stats, limit,
-				      actions_performed);
-}
-EXPORT_SYMBOL_GPL(devlink_remote_reload_actions_performed);
-
-int devlink_reload(struct devlink *devlink, struct net *dest_net,
-		   enum devlink_reload_action action,
-		   enum devlink_reload_limit limit,
-		   u32 *actions_performed, struct netlink_ext_ack *extack)
-{
-	u32 remote_reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
-	struct net *curr_net;
-	int err;
-
-	memcpy(remote_reload_stats, devlink->stats.remote_reload_stats,
-	       sizeof(remote_reload_stats));
-
-	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit, extack);
-	if (err)
-		return err;
-
-	curr_net = devlink_net(devlink);
-	if (dest_net && !net_eq(dest_net, curr_net))
-		devlink_reload_netns_change(devlink, curr_net, dest_net);
-
-	err = devlink->ops->reload_up(devlink, action, limit, actions_performed, extack);
-	devlink_reload_failed_set(devlink, !!err);
-	if (err)
-		return err;
-
-	WARN_ON(!(*actions_performed & BIT(action)));
-	/* Catch driver on updating the remote action within devlink reload */
-	WARN_ON(memcmp(remote_reload_stats, devlink->stats.remote_reload_stats,
-		       sizeof(remote_reload_stats)));
-	devlink_reload_stats_update(devlink, limit, *actions_performed);
-	return 0;
-}
-
-static int
-devlink_nl_reload_actions_performed_snd(struct devlink *devlink, u32 actions_performed,
-					enum devlink_command cmd, struct genl_info *info)
-{
-	struct sk_buff *msg;
-	void *hdr;
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
-
-	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq, &devlink_nl_family, 0, cmd);
-	if (!hdr)
-		goto free_msg;
-
-	if (devlink_nl_put_handle(msg, devlink))
-		goto nla_put_failure;
-
-	if (nla_put_bitfield32(msg, DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED, actions_performed,
-			       actions_performed))
-		goto nla_put_failure;
-	genlmsg_end(msg, hdr);
-
-	return genlmsg_reply(msg, info);
-
-nla_put_failure:
-	genlmsg_cancel(msg, hdr);
-free_msg:
-	nlmsg_free(msg);
-	return -EMSGSIZE;
-}
-
-static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
-{
-	struct devlink *devlink = info->user_ptr[0];
-	enum devlink_reload_action action;
-	enum devlink_reload_limit limit;
-	struct net *dest_net = NULL;
-	u32 actions_performed;
-	int err;
-
-	err = devlink_resources_validate(devlink, NULL, info);
-	if (err) {
-		NL_SET_ERR_MSG_MOD(info->extack, "resources size validation failed");
-		return err;
-	}
-
-	if (info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
-		action = nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_ACTION]);
-	else
-		action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT;
-
-	if (!devlink_reload_action_is_supported(devlink, action)) {
-		NL_SET_ERR_MSG_MOD(info->extack,
-				   "Requested reload action is not supported by the driver");
-		return -EOPNOTSUPP;
-	}
-
-	limit = DEVLINK_RELOAD_LIMIT_UNSPEC;
-	if (info->attrs[DEVLINK_ATTR_RELOAD_LIMITS]) {
-		struct nla_bitfield32 limits;
-		u32 limits_selected;
-
-		limits = nla_get_bitfield32(info->attrs[DEVLINK_ATTR_RELOAD_LIMITS]);
-		limits_selected = limits.value & limits.selector;
-		if (!limits_selected) {
-			NL_SET_ERR_MSG_MOD(info->extack, "Invalid limit selected");
-			return -EINVAL;
-		}
-		for (limit = 0 ; limit <= DEVLINK_RELOAD_LIMIT_MAX ; limit++)
-			if (limits_selected & BIT(limit))
-				break;
-		/* UAPI enables multiselection, but currently it is not used */
-		if (limits_selected != BIT(limit)) {
-			NL_SET_ERR_MSG_MOD(info->extack,
-					   "Multiselection of limit is not supported");
-			return -EOPNOTSUPP;
-		}
-		if (!devlink_reload_limit_is_supported(devlink, limit)) {
-			NL_SET_ERR_MSG_MOD(info->extack,
-					   "Requested limit is not supported by the driver");
-			return -EOPNOTSUPP;
-		}
-		if (devlink_reload_combination_is_invalid(action, limit)) {
-			NL_SET_ERR_MSG_MOD(info->extack,
-					   "Requested limit is invalid for this action");
-			return -EINVAL;
-		}
-	}
-	if (info->attrs[DEVLINK_ATTR_NETNS_PID] ||
-	    info->attrs[DEVLINK_ATTR_NETNS_FD] ||
-	    info->attrs[DEVLINK_ATTR_NETNS_ID]) {
-		dest_net = devlink_netns_get(skb, info);
-		if (IS_ERR(dest_net))
-			return PTR_ERR(dest_net);
-	}
-
-	err = devlink_reload(devlink, dest_net, action, limit, &actions_performed, info->extack);
-
-	if (dest_net)
-		put_net(dest_net);
-
-	if (err)
-		return err;
-	/* For backward compatibility generate reply only if attributes used by user */
-	if (!info->attrs[DEVLINK_ATTR_RELOAD_ACTION] && !info->attrs[DEVLINK_ATTR_RELOAD_LIMITS])
-		return 0;
-
-	return devlink_nl_reload_actions_performed_snd(devlink, actions_performed,
-						       DEVLINK_CMD_RELOAD, info);
-}
-
 static int devlink_nl_flash_update_fill(struct sk_buff *msg,
 					struct devlink *devlink,
 					enum devlink_command cmd,
@@ -9157,35 +8770,6 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 	/* -- No new ops here! Use split ops going forward! -- */
 };
 
-bool devlink_reload_actions_valid(const struct devlink_ops *ops)
-{
-	const struct devlink_reload_combination *comb;
-	int i;
-
-	if (!devlink_reload_supported(ops)) {
-		if (WARN_ON(ops->reload_actions))
-			return false;
-		return true;
-	}
-
-	if (WARN_ON(!ops->reload_actions ||
-		    ops->reload_actions & BIT(DEVLINK_RELOAD_ACTION_UNSPEC) ||
-		    ops->reload_actions >= BIT(__DEVLINK_RELOAD_ACTION_MAX)))
-		return false;
-
-	if (WARN_ON(ops->reload_limits & BIT(DEVLINK_RELOAD_LIMIT_UNSPEC) ||
-		    ops->reload_limits >= BIT(__DEVLINK_RELOAD_LIMIT_MAX)))
-		return false;
-
-	for (i = 0; i < ARRAY_SIZE(devlink_reload_invalid_combinations); i++)  {
-		comb = &devlink_reload_invalid_combinations[i];
-		if (ops->reload_actions == BIT(comb->action) &&
-		    ops->reload_limits == BIT(comb->limit))
-			return false;
-	}
-	return true;
-}
-
 static void
 devlink_trap_policer_notify(struct devlink *devlink,
 			    const struct devlink_trap_policer_item *policer_item,
-- 
2.27.0

