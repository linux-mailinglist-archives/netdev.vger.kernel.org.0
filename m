Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08DF6946BB
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjBMNPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjBMNPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:15:00 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B34210D
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 05:14:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvChnJxmhfgzE3kZ1Z/dTA90aKFRrENT8djJDbItcQZv4iXj7KHu+wWJ3DGLJ890w1G6URFnw/60E8Nz9pNjOoWtGIVuGaddWADAnPMc5Ze++8BniP3Wf8uDfzXWBUc6U+Th1tU2YrSx51Qdh/pVKVOwd1MJbKrRTWksI3jkdxxXnwVKSEKvCPCVN1s7RL9IHmN3GmC7oyLquhJ6by6cus/odcBSN/gdlbDC81oU64gCPd1UbdmRMlM884LhSOUwfIkWJ0UWtgMmFGTp+PCnaXI7tnrVI3uzyTra29AZQJ1ADahXW3sbEA0IikEzdUOs/3/Z+5DwJ+ecfqdrSLCrpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=14zgU5mdQqj8ZuJAECnaPCILtOwmFvzDbqIXq2DRhyQ=;
 b=HHr2pqdChzvvHVlrncqDFmb5Ieu23hRjjQAsbR7s2NLgztlhvYAEeLTbxX3MzUsC8fbWhxPRDXK2hPOrzJ9HhQ1s9hSFEmMdBclCPBM30f808J3Qy5a9jGr8+ZY8vsM8w+yJJBKeTgzP0QNC8UkIXmZE4dTdPUtQp33ecvXxPbSoSOsqpXpxI+wxBpBG9o+pQ3YNCX0EVbkyRN08/lLn7xMf+FdBxhHaozMyCOj6OwL20MlTZuYLGYB/ebpQhmt5k3p68f3G9eYL6KrIYm9GJpNMNKvsh6pIvoPYCHq8anvDs7wuaEKu9YvdjhObYNJQ73dDCJ5KZkNwoxxi0WpKgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14zgU5mdQqj8ZuJAECnaPCILtOwmFvzDbqIXq2DRhyQ=;
 b=OY7fo3eT7Po4ZFvzhv4SFfhvRheRWanaNepdK7nqNMYC4+xyBqUI71B7yl8SwBqRDKNqhegoRJEeSDROUnISzN+EE1wXGTSMZ5u5cCbofQHLD8VUA6YzFPa3YHZMKYDT2iOiv43cZmLtr91PtlcQX+zG0pR1OkYxQJqiYiIk4ZVRt9qVhz/a5FIyA5Epzd/iwwHlwbypqinfmk0UXBE5TiEpRjfl07q28AxrCGoSRkm9xRoh5NcDXWI6EOMj1hIcorvXzgohPpzoblRI0oKjvD7FEaO7om41XXric5hjGmyuTa/Ya+liLip3NjQ4Q4YSLziEWcPkUwUjN6NqpW6T8A==
Received: from DM6PR07CA0091.namprd07.prod.outlook.com (2603:10b6:5:337::24)
 by DM4PR12MB5889.namprd12.prod.outlook.com (2603:10b6:8:65::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Mon, 13 Feb
 2023 13:14:55 +0000
Received: from DS1PEPF0000E644.namprd02.prod.outlook.com
 (2603:10b6:5:337:cafe::57) by DM6PR07CA0091.outlook.office365.com
 (2603:10b6:5:337::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 13:14:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E644.mail.protection.outlook.com (10.167.17.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 13:14:55 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 05:14:54 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 13 Feb 2023 05:14:54 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Mon, 13 Feb 2023 05:14:52 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 03/10] devlink: Move devlink health get and set code to health file
Date:   Mon, 13 Feb 2023 15:14:11 +0200
Message-ID: <1676294058-136786-4-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
References: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E644:EE_|DM4PR12MB5889:EE_
X-MS-Office365-Filtering-Correlation-Id: d5c59b7c-8dad-49ef-5ddd-08db0dc44ca3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 71QMMHxFE/XqD9QWQMxwUlrlMSvdFJYp6H+E9dmpny/evfhgovYOZY3tV2WMNdXXC6KtG6x5lSE/BQFkYpuaSzEBGRYImvFqctEYAVX4GnM427JSjllyoVahipv7N1bLcYjfuMa1EKSSf6y3V24Y57SA6PZP7rapQeFBgs4n4dYhGEjXGmoArTAVbBCrhWaEZ2qLQXl3pMA3wIg+36PQ9e7Evczc4gsJ60trlVTXIU3/7UU2osbPrzbL0LXVPD92Dntk9ip+gl4E08kXJEexmNnYnAT+NjLpgQUQ1J33zkWdBaADXAFndVZJTa+q0HFVd77KEf1FGapvViS/x/FbzzS3ceMTg8Vjz3v3/P35XDLG2yj9+p6WgAw/E04WAyxO8JHOXn+olH0BGc7Gxc/iThQEteuS5FS3uPEOFYnBDAHJg3rOCnfxJ558XdH9g1W0nRS1p9Bjdf6WCOSFTBzfif2H5b3DtdhY/Y/fbM7Xt9YNvE2s4e7oRWvYgdv9joxmNe2nzaYXV8wO9DIBROjfiGFzjP0jZpVhTs0WoJbYYO3hfGR93vgFn4TR3u5/QRdO31bKHx7oBzeqj+snUgyKq3AWDCQ3Ze/pTwq/2aKHC7iof3yhzFOLQyoPEEuAzI1wk3lMlRS11o5MKyAS7/Vps6mxKBKZnDbPxX5PYcmUVW8oMNq+24BFx3IhMHs19qktbkqaC3uhNdNdXzqJywyzIg==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(136003)(376002)(396003)(451199018)(36840700001)(40470700004)(46966006)(186003)(2906002)(26005)(356005)(82740400003)(478600001)(5660300002)(2616005)(30864003)(7636003)(40460700003)(86362001)(6666004)(107886003)(36860700001)(8936002)(41300700001)(316002)(336012)(8676002)(82310400005)(36756003)(40480700001)(4326008)(426003)(70586007)(70206006)(47076005)(110136005)(7696005)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 13:14:55.2176
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5c59b7c-8dad-49ef-5ddd-08db0dc44ca3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E644.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5889
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move devlink health get and set callbacks and related code from
leftover.c to health.c. No functional change in this patch.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
 net/devlink/devl_internal.h |  18 +++
 net/devlink/health.c        | 214 +++++++++++++++++++++++++++++++++++
 net/devlink/leftover.c      | 219 +-----------------------------------
 3 files changed, 234 insertions(+), 217 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 49fe9e2dae34..085f80b5feb8 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -176,6 +176,8 @@ int devlink_port_netdevice_event(struct notifier_block *nb,
 
 struct devlink_port *
 devlink_port_get_from_info(struct devlink *devlink, struct genl_info *info);
+struct devlink_port *devlink_port_get_from_attrs(struct devlink *devlink,
+						 struct nlattr **attrs);
 
 /* Reload */
 bool devlink_reload_actions_valid(const struct devlink_ops *ops);
@@ -224,6 +226,18 @@ devlink_health_reporter_find_by_name(struct devlink *devlink,
 struct devlink_health_reporter *
 devlink_port_health_reporter_find_by_name(struct devlink_port *devlink_port,
 					  const char *reporter_name);
+struct devlink_health_reporter *
+devlink_health_reporter_get_from_attrs(struct devlink *devlink,
+				       struct nlattr **attrs);
+struct devlink_health_reporter *
+devlink_health_reporter_get_from_info(struct devlink *devlink,
+				      struct genl_info *info);
+int
+devlink_nl_health_reporter_fill(struct sk_buff *msg,
+				struct devlink_health_reporter *reporter,
+				enum devlink_command cmd, u32 portid,
+				u32 seq, int flags);
+
 void devlink_fmsg_free(struct devlink_fmsg *fmsg);
 
 /* Line cards */
@@ -249,3 +263,7 @@ int devlink_nl_cmd_info_get_doit(struct sk_buff *skb, struct genl_info *info);
 int devlink_nl_cmd_flash_update(struct sk_buff *skb, struct genl_info *info);
 int devlink_nl_cmd_selftests_get_doit(struct sk_buff *skb, struct genl_info *info);
 int devlink_nl_cmd_selftests_run(struct sk_buff *skb, struct genl_info *info);
+int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
+					    struct genl_info *info);
+int devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
+					    struct genl_info *info);
diff --git a/net/devlink/health.c b/net/devlink/health.c
index 6b0863fbef93..1ecfd01b7b2f 100644
--- a/net/devlink/health.c
+++ b/net/devlink/health.c
@@ -194,3 +194,217 @@ devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
 	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
+
+int
+devlink_nl_health_reporter_fill(struct sk_buff *msg,
+				struct devlink_health_reporter *reporter,
+				enum devlink_command cmd, u32 portid,
+				u32 seq, int flags)
+{
+	struct devlink *devlink = reporter->devlink;
+	struct nlattr *reporter_attr;
+	void *hdr;
+
+	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto genlmsg_cancel;
+
+	if (reporter->devlink_port) {
+		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX, reporter->devlink_port->index))
+			goto genlmsg_cancel;
+	}
+	reporter_attr = nla_nest_start_noflag(msg,
+					      DEVLINK_ATTR_HEALTH_REPORTER);
+	if (!reporter_attr)
+		goto genlmsg_cancel;
+	if (nla_put_string(msg, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
+			   reporter->ops->name))
+		goto reporter_nest_cancel;
+	if (nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_STATE,
+		       reporter->health_state))
+		goto reporter_nest_cancel;
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_ERR_COUNT,
+			      reporter->error_count, DEVLINK_ATTR_PAD))
+		goto reporter_nest_cancel;
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_RECOVER_COUNT,
+			      reporter->recovery_count, DEVLINK_ATTR_PAD))
+		goto reporter_nest_cancel;
+	if (reporter->ops->recover &&
+	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD,
+			      reporter->graceful_period,
+			      DEVLINK_ATTR_PAD))
+		goto reporter_nest_cancel;
+	if (reporter->ops->recover &&
+	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER,
+		       reporter->auto_recover))
+		goto reporter_nest_cancel;
+	if (reporter->dump_fmsg &&
+	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS,
+			      jiffies_to_msecs(reporter->dump_ts),
+			      DEVLINK_ATTR_PAD))
+		goto reporter_nest_cancel;
+	if (reporter->dump_fmsg &&
+	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,
+			      reporter->dump_real_ts, DEVLINK_ATTR_PAD))
+		goto reporter_nest_cancel;
+	if (reporter->ops->dump &&
+	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,
+		       reporter->auto_dump))
+		goto reporter_nest_cancel;
+
+	nla_nest_end(msg, reporter_attr);
+	genlmsg_end(msg, hdr);
+	return 0;
+
+reporter_nest_cancel:
+	nla_nest_cancel(msg, reporter_attr);
+genlmsg_cancel:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+struct devlink_health_reporter *
+devlink_health_reporter_get_from_attrs(struct devlink *devlink,
+				       struct nlattr **attrs)
+{
+	struct devlink_port *devlink_port;
+	char *reporter_name;
+
+	if (!attrs[DEVLINK_ATTR_HEALTH_REPORTER_NAME])
+		return NULL;
+
+	reporter_name = nla_data(attrs[DEVLINK_ATTR_HEALTH_REPORTER_NAME]);
+	devlink_port = devlink_port_get_from_attrs(devlink, attrs);
+	if (IS_ERR(devlink_port))
+		return devlink_health_reporter_find_by_name(devlink,
+							    reporter_name);
+	else
+		return devlink_port_health_reporter_find_by_name(devlink_port,
+								 reporter_name);
+}
+
+struct devlink_health_reporter *
+devlink_health_reporter_get_from_info(struct devlink *devlink,
+				      struct genl_info *info)
+{
+	return devlink_health_reporter_get_from_attrs(devlink, info->attrs);
+}
+
+int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
+					    struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_health_reporter *reporter;
+	struct sk_buff *msg;
+	int err;
+
+	reporter = devlink_health_reporter_get_from_info(devlink, info);
+	if (!reporter)
+		return -EINVAL;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	err = devlink_nl_health_reporter_fill(msg, reporter,
+					      DEVLINK_CMD_HEALTH_REPORTER_GET,
+					      info->snd_portid, info->snd_seq,
+					      0);
+	if (err) {
+		nlmsg_free(msg);
+		return err;
+	}
+
+	return genlmsg_reply(msg, info);
+}
+
+static int
+devlink_nl_cmd_health_reporter_get_dump_one(struct sk_buff *msg,
+					    struct devlink *devlink,
+					    struct netlink_callback *cb)
+{
+	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
+	struct devlink_health_reporter *reporter;
+	struct devlink_port *port;
+	unsigned long port_index;
+	int idx = 0;
+	int err;
+
+	list_for_each_entry(reporter, &devlink->reporter_list, list) {
+		if (idx < state->idx) {
+			idx++;
+			continue;
+		}
+		err = devlink_nl_health_reporter_fill(msg, reporter,
+						      DEVLINK_CMD_HEALTH_REPORTER_GET,
+						      NETLINK_CB(cb->skb).portid,
+						      cb->nlh->nlmsg_seq,
+						      NLM_F_MULTI);
+		if (err) {
+			state->idx = idx;
+			return err;
+		}
+		idx++;
+	}
+	xa_for_each(&devlink->ports, port_index, port) {
+		list_for_each_entry(reporter, &port->reporter_list, list) {
+			if (idx < state->idx) {
+				idx++;
+				continue;
+			}
+			err = devlink_nl_health_reporter_fill(msg, reporter,
+							      DEVLINK_CMD_HEALTH_REPORTER_GET,
+							      NETLINK_CB(cb->skb).portid,
+							      cb->nlh->nlmsg_seq,
+							      NLM_F_MULTI);
+			if (err) {
+				state->idx = idx;
+				return err;
+			}
+			idx++;
+		}
+	}
+
+	return 0;
+}
+
+const struct devlink_cmd devl_cmd_health_reporter_get = {
+	.dump_one		= devlink_nl_cmd_health_reporter_get_dump_one,
+};
+
+int devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
+					    struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_health_reporter *reporter;
+
+	reporter = devlink_health_reporter_get_from_info(devlink, info);
+	if (!reporter)
+		return -EINVAL;
+
+	if (!reporter->ops->recover &&
+	    (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] ||
+	     info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]))
+		return -EOPNOTSUPP;
+
+	if (!reporter->ops->dump &&
+	    info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP])
+		return -EOPNOTSUPP;
+
+	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD])
+		reporter->graceful_period =
+			nla_get_u64(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD]);
+
+	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER])
+		reporter->auto_recover =
+			nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]);
+
+	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP])
+		reporter->auto_dump =
+		nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]);
+
+	return 0;
+}
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 90f95f06de28..0b1c5e0122f3 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -156,8 +156,8 @@ static struct devlink_port *devlink_port_get_by_index(struct devlink *devlink,
 	return xa_load(&devlink->ports, port_index);
 }
 
-static struct devlink_port *devlink_port_get_from_attrs(struct devlink *devlink,
-							struct nlattr **attrs)
+struct devlink_port *devlink_port_get_from_attrs(struct devlink *devlink,
+						 struct nlattr **attrs)
 {
 	if (attrs[DEVLINK_ATTR_PORT_INDEX]) {
 		u32 port_index = nla_get_u32(attrs[DEVLINK_ATTR_PORT_INDEX]);
@@ -5963,77 +5963,6 @@ static int devlink_fmsg_dumpit(struct devlink_fmsg *fmsg, struct sk_buff *skb,
 	return err;
 }
 
-static int
-devlink_nl_health_reporter_fill(struct sk_buff *msg,
-				struct devlink_health_reporter *reporter,
-				enum devlink_command cmd, u32 portid,
-				u32 seq, int flags)
-{
-	struct devlink *devlink = reporter->devlink;
-	struct nlattr *reporter_attr;
-	void *hdr;
-
-	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
-	if (!hdr)
-		return -EMSGSIZE;
-
-	if (devlink_nl_put_handle(msg, devlink))
-		goto genlmsg_cancel;
-
-	if (reporter->devlink_port) {
-		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX, reporter->devlink_port->index))
-			goto genlmsg_cancel;
-	}
-	reporter_attr = nla_nest_start_noflag(msg,
-					      DEVLINK_ATTR_HEALTH_REPORTER);
-	if (!reporter_attr)
-		goto genlmsg_cancel;
-	if (nla_put_string(msg, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
-			   reporter->ops->name))
-		goto reporter_nest_cancel;
-	if (nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_STATE,
-		       reporter->health_state))
-		goto reporter_nest_cancel;
-	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_ERR_COUNT,
-			      reporter->error_count, DEVLINK_ATTR_PAD))
-		goto reporter_nest_cancel;
-	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_RECOVER_COUNT,
-			      reporter->recovery_count, DEVLINK_ATTR_PAD))
-		goto reporter_nest_cancel;
-	if (reporter->ops->recover &&
-	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD,
-			      reporter->graceful_period,
-			      DEVLINK_ATTR_PAD))
-		goto reporter_nest_cancel;
-	if (reporter->ops->recover &&
-	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER,
-		       reporter->auto_recover))
-		goto reporter_nest_cancel;
-	if (reporter->dump_fmsg &&
-	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS,
-			      jiffies_to_msecs(reporter->dump_ts),
-			      DEVLINK_ATTR_PAD))
-		goto reporter_nest_cancel;
-	if (reporter->dump_fmsg &&
-	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,
-			      reporter->dump_real_ts, DEVLINK_ATTR_PAD))
-		goto reporter_nest_cancel;
-	if (reporter->ops->dump &&
-	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,
-		       reporter->auto_dump))
-		goto reporter_nest_cancel;
-
-	nla_nest_end(msg, reporter_attr);
-	genlmsg_end(msg, hdr);
-	return 0;
-
-reporter_nest_cancel:
-	nla_nest_cancel(msg, reporter_attr);
-genlmsg_cancel:
-	genlmsg_cancel(msg, hdr);
-	return -EMSGSIZE;
-}
-
 static void devlink_recover_notify(struct devlink_health_reporter *reporter,
 				   enum devlink_command cmd)
 {
@@ -6188,33 +6117,6 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 }
 EXPORT_SYMBOL_GPL(devlink_health_report);
 
-static struct devlink_health_reporter *
-devlink_health_reporter_get_from_attrs(struct devlink *devlink,
-				       struct nlattr **attrs)
-{
-	struct devlink_port *devlink_port;
-	char *reporter_name;
-
-	if (!attrs[DEVLINK_ATTR_HEALTH_REPORTER_NAME])
-		return NULL;
-
-	reporter_name = nla_data(attrs[DEVLINK_ATTR_HEALTH_REPORTER_NAME]);
-	devlink_port = devlink_port_get_from_attrs(devlink, attrs);
-	if (IS_ERR(devlink_port))
-		return devlink_health_reporter_find_by_name(devlink,
-							    reporter_name);
-	else
-		return devlink_port_health_reporter_find_by_name(devlink_port,
-								 reporter_name);
-}
-
-static struct devlink_health_reporter *
-devlink_health_reporter_get_from_info(struct devlink *devlink,
-				      struct genl_info *info)
-{
-	return devlink_health_reporter_get_from_attrs(devlink, info->attrs);
-}
-
 static struct devlink_health_reporter *
 devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
 {
@@ -6251,123 +6153,6 @@ devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
 }
 EXPORT_SYMBOL_GPL(devlink_health_reporter_state_update);
 
-static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
-						   struct genl_info *info)
-{
-	struct devlink *devlink = info->user_ptr[0];
-	struct devlink_health_reporter *reporter;
-	struct sk_buff *msg;
-	int err;
-
-	reporter = devlink_health_reporter_get_from_info(devlink, info);
-	if (!reporter)
-		return -EINVAL;
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
-
-	err = devlink_nl_health_reporter_fill(msg, reporter,
-					      DEVLINK_CMD_HEALTH_REPORTER_GET,
-					      info->snd_portid, info->snd_seq,
-					      0);
-	if (err) {
-		nlmsg_free(msg);
-		return err;
-	}
-
-	return genlmsg_reply(msg, info);
-}
-
-static int
-devlink_nl_cmd_health_reporter_get_dump_one(struct sk_buff *msg,
-					    struct devlink *devlink,
-					    struct netlink_callback *cb)
-{
-	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	struct devlink_health_reporter *reporter;
-	struct devlink_port *port;
-	unsigned long port_index;
-	int idx = 0;
-	int err;
-
-	list_for_each_entry(reporter, &devlink->reporter_list, list) {
-		if (idx < state->idx) {
-			idx++;
-			continue;
-		}
-		err = devlink_nl_health_reporter_fill(msg, reporter,
-						      DEVLINK_CMD_HEALTH_REPORTER_GET,
-						      NETLINK_CB(cb->skb).portid,
-						      cb->nlh->nlmsg_seq,
-						      NLM_F_MULTI);
-		if (err) {
-			state->idx = idx;
-			return err;
-		}
-		idx++;
-	}
-	xa_for_each(&devlink->ports, port_index, port) {
-		list_for_each_entry(reporter, &port->reporter_list, list) {
-			if (idx < state->idx) {
-				idx++;
-				continue;
-			}
-			err = devlink_nl_health_reporter_fill(msg, reporter,
-							      DEVLINK_CMD_HEALTH_REPORTER_GET,
-							      NETLINK_CB(cb->skb).portid,
-							      cb->nlh->nlmsg_seq,
-							      NLM_F_MULTI);
-			if (err) {
-				state->idx = idx;
-				return err;
-			}
-			idx++;
-		}
-	}
-
-	return 0;
-}
-
-const struct devlink_cmd devl_cmd_health_reporter_get = {
-	.dump_one		= devlink_nl_cmd_health_reporter_get_dump_one,
-};
-
-static int
-devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
-					struct genl_info *info)
-{
-	struct devlink *devlink = info->user_ptr[0];
-	struct devlink_health_reporter *reporter;
-
-	reporter = devlink_health_reporter_get_from_info(devlink, info);
-	if (!reporter)
-		return -EINVAL;
-
-	if (!reporter->ops->recover &&
-	    (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] ||
-	     info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]))
-		return -EOPNOTSUPP;
-
-	if (!reporter->ops->dump &&
-	    info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP])
-		return -EOPNOTSUPP;
-
-	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD])
-		reporter->graceful_period =
-			nla_get_u64(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD]);
-
-	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER])
-		reporter->auto_recover =
-			nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]);
-
-	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP])
-		reporter->auto_dump =
-		nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]);
-
-	return 0;
-}
-
 static int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
 						       struct genl_info *info)
 {
-- 
2.27.0

