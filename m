Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85FB1688074
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 15:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbjBBOtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 09:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbjBBOs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 09:48:29 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6569F29E3D;
        Thu,  2 Feb 2023 06:48:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjaRUecRH7B8qyxT2xTYOYWLQfsDISZIxHdz1WMDa8Vgf+FQhpyziEbVOCzbXPQs1caowFScJ75x8nWb6r1D+gaffOnoNnPjem3ktOZxynXl1XFNrJvo/TwXzJEE21AY+fBaockkRbTTfPX7CVcDJlT80ihrSIh3Uu+pVtmdxUKWaJEs7VsflBxMjB6JQIbBA+OydVnKo4jVBF7J0Rm/inVL0Zvuv9p13Sj8bwV4/oZNbHD3oxZVh6TGX5KEjE2gmogXN6GTUODkgJdIe4k6erwKimiff5zCI4oPY9B4OwKzBp6/3OK+Cr0HdyxnZH/nV2M6TXAlfJSrk7JR4xlE+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wJN6HE08mUla0tHhKwyBrIBy2gF2xzeHoAbEaQs0/VI=;
 b=ajwYUwReKhMCBqEEJxpmONuJxfA3ov5Sul3ByFH1rYdn/KYi6Dv8oAt+e774KSJ05Jj80I+yeC8IH+3sqFVhmqTk4KzWiM0iksrlNPTrSLZA/t7qvtYVJgqWn6LcuN43oT33gi/VSuMSwSSns2vxkustvFka8RhKMhU3o7OvIBVCiyFJOmADkAkk34Y/iQa8l6EvaLCSPUacJIdwUG3Y4zfCA0cQ0m24A/byXh23JORkG0t7IoJN0aPqVbfu1iLZpZdXikwhjS6sEIuoImIGc0gNEDLg2iOLlHA7EjR+Ak4ZI6guppQZisTeBm5pHsKsN0lFyQaNoRYiFX8WI7PGTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wJN6HE08mUla0tHhKwyBrIBy2gF2xzeHoAbEaQs0/VI=;
 b=GqbHJ0nGX29zQq6znbe+pH1YchkO81FG58viFpJXAgc8VhJq3pPFdrXpH6/FwQEnQxRLy7UAb1/DhJfQDP8Iq2uJw+o2BuGbqpZ5/XnwqdH8JeR8fy73L627gEzLz1FEZidOvwMZW4AtQqMbQbdI7cmIgiOROJyzgwHMj/baMj7JW6Z+xoLsJoHHTyukzUNJywr5Ulf166E89MBAH8LP2yS+UwGDFvdl3W+Jdh3tbRvAcVAQra2n9skgYuy3Ba4AWIbskCzFwO12CZ0qrYHlj8sgBSdAwZNoxNR/9u2fZ2Y6Sj1G7VOqcLMC1mEAtysPW9iLj4JxZNDpv3bf79xilw==
Received: from MW4P222CA0016.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::21)
 by CH3PR12MB8075.namprd12.prod.outlook.com (2603:10b6:610:122::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 14:48:06 +0000
Received: from CO1NAM11FT069.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::68) by MW4P222CA0016.outlook.office365.com
 (2603:10b6:303:114::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24 via Frontend
 Transport; Thu, 2 Feb 2023 14:48:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT069.mail.protection.outlook.com (10.13.174.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.28 via Frontend Transport; Thu, 2 Feb 2023 14:48:05 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 06:47:56 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 06:47:56 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 2 Feb
 2023 06:47:54 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 7/7] devlink: Move devlink dev selftest code to dev
Date:   Thu, 2 Feb 2023 16:47:06 +0200
Message-ID: <1675349226-284034-8-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
References: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT069:EE_|CH3PR12MB8075:EE_
X-MS-Office365-Filtering-Correlation-Id: e686ba30-698e-4c70-c2a4-08db052c7e0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B0S/Yid4mYOG2qBNqy00ZpmDmxzMs1VtvDQvTe3JSLAXP+1gk5nwyMTF/PvOVeQBZQEcXnjIxpXGJHXABnl3aVnDxls/tR/ToNii8odL8yW85Bw3U8tYipSrOPSTpNS28A84zqi7Iu8iPP/Kt1c0Iof25Uto2Fo5DJcW2x7wohC2jLDfnTnVcvv6GjUBUlVYWve7WqdXfn+RPSxaEdml9TbwIKF5Kiw1tcDK4SfBCSJmZBAIzImIcqFlrKAn75/F8smFOABkndNW1s0lDz9rQiNiBOGhmHqmeBuvDhfjqkFqn4aOEPl1Yp7GRzCQpv7dE01/XlxkMED5GdKh0hjfl5Sskj/CXKfXAF4jvt/MlsshBHwWm3DpTAUK2vkixl6zzQG+fyOn3CuA9SeET67IS5Pnn3xKM2KKKMe8dZnBoe38wkYiauyD2C4wSNgMy6ALSKHoeeJqx7mesCx6v0Iux/u/b9KK0tzTzP+g1V4a2f687gboOZ6lUZeBFhQynHoOfSEhqSl40tNGnQEqUi9KX2HztVGtyDI0fITAWe8V9en3ixZmqfEEGb7cIxpC6jfWvaLO2xZah+eycwHuOdOuRoLeN65FVhZQx1Q0/aUTs3/U+pZlmCLKtMrfIMyXgzUIi6xfBAQrpRnDEMtrsXqS/UysV1pf8zKTeT+7n8X3ebjjf4BrxLRvhnI1RHxRCzxEBVM7SV3Ob/W4nDtJqdAavg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(376002)(136003)(451199018)(46966006)(40470700004)(36840700001)(2906002)(70206006)(478600001)(36756003)(30864003)(107886003)(6666004)(26005)(186003)(2616005)(82310400005)(40460700003)(336012)(8936002)(7696005)(86362001)(40480700001)(5660300002)(47076005)(356005)(41300700001)(426003)(8676002)(83380400001)(4326008)(70586007)(316002)(82740400003)(110136005)(36860700001)(7636003)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 14:48:05.3716
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e686ba30-698e-4c70-c2a4-08db052c7e0e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT069.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8075
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move devlink dev selftest callbacks and related code from leftover.c to
file dev.c. No functional change in this patch.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
 net/devlink/dev.c           | 182 +++++++++++++++++++++++++++++++++++
 net/devlink/devl_internal.h |   2 +
 net/devlink/leftover.c      | 183 ------------------------------------
 3 files changed, 184 insertions(+), 183 deletions(-)

diff --git a/net/devlink/dev.c b/net/devlink/dev.c
index dcf0935462e8..78d824eda5ec 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -1159,3 +1159,185 @@ int devlink_compat_flash_update(struct devlink *devlink, const char *file_name)
 
 	return ret;
 }
+
+static int
+devlink_nl_selftests_fill(struct sk_buff *msg, struct devlink *devlink,
+			  u32 portid, u32 seq, int flags,
+			  struct netlink_ext_ack *extack)
+{
+	struct nlattr *selftests;
+	void *hdr;
+	int err;
+	int i;
+
+	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags,
+			  DEVLINK_CMD_SELFTESTS_GET);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	err = -EMSGSIZE;
+	if (devlink_nl_put_handle(msg, devlink))
+		goto err_cancel_msg;
+
+	selftests = nla_nest_start(msg, DEVLINK_ATTR_SELFTESTS);
+	if (!selftests)
+		goto err_cancel_msg;
+
+	for (i = DEVLINK_ATTR_SELFTEST_ID_UNSPEC + 1;
+	     i <= DEVLINK_ATTR_SELFTEST_ID_MAX; i++) {
+		if (devlink->ops->selftest_check(devlink, i, extack)) {
+			err = nla_put_flag(msg, i);
+			if (err)
+				goto err_cancel_msg;
+		}
+	}
+
+	nla_nest_end(msg, selftests);
+	genlmsg_end(msg, hdr);
+	return 0;
+
+err_cancel_msg:
+	genlmsg_cancel(msg, hdr);
+	return err;
+}
+
+int devlink_nl_cmd_selftests_get_doit(struct sk_buff *skb,
+				      struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct sk_buff *msg;
+	int err;
+
+	if (!devlink->ops->selftest_check)
+		return -EOPNOTSUPP;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	err = devlink_nl_selftests_fill(msg, devlink, info->snd_portid,
+					info->snd_seq, 0, info->extack);
+	if (err) {
+		nlmsg_free(msg);
+		return err;
+	}
+
+	return genlmsg_reply(msg, info);
+}
+
+static int
+devlink_nl_cmd_selftests_get_dump_one(struct sk_buff *msg,
+				      struct devlink *devlink,
+				      struct netlink_callback *cb)
+{
+	if (!devlink->ops->selftest_check)
+		return 0;
+
+	return devlink_nl_selftests_fill(msg, devlink,
+					 NETLINK_CB(cb->skb).portid,
+					 cb->nlh->nlmsg_seq, NLM_F_MULTI,
+					 cb->extack);
+}
+
+const struct devlink_cmd devl_cmd_selftests_get = {
+	.dump_one		= devlink_nl_cmd_selftests_get_dump_one,
+};
+
+static int devlink_selftest_result_put(struct sk_buff *skb, unsigned int id,
+				       enum devlink_selftest_status test_status)
+{
+	struct nlattr *result_attr;
+
+	result_attr = nla_nest_start(skb, DEVLINK_ATTR_SELFTEST_RESULT);
+	if (!result_attr)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(skb, DEVLINK_ATTR_SELFTEST_RESULT_ID, id) ||
+	    nla_put_u8(skb, DEVLINK_ATTR_SELFTEST_RESULT_STATUS,
+		       test_status))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, result_attr);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, result_attr);
+	return -EMSGSIZE;
+}
+
+static const struct nla_policy devlink_selftest_nl_policy[DEVLINK_ATTR_SELFTEST_ID_MAX + 1] = {
+	[DEVLINK_ATTR_SELFTEST_ID_FLASH] = { .type = NLA_FLAG },
+};
+
+int devlink_nl_cmd_selftests_run(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb[DEVLINK_ATTR_SELFTEST_ID_MAX + 1];
+	struct devlink *devlink = info->user_ptr[0];
+	struct nlattr *attrs, *selftests;
+	struct sk_buff *msg;
+	void *hdr;
+	int err;
+	int i;
+
+	if (!devlink->ops->selftest_run || !devlink->ops->selftest_check)
+		return -EOPNOTSUPP;
+
+	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_SELFTESTS))
+		return -EINVAL;
+
+	attrs = info->attrs[DEVLINK_ATTR_SELFTESTS];
+
+	err = nla_parse_nested(tb, DEVLINK_ATTR_SELFTEST_ID_MAX, attrs,
+			       devlink_selftest_nl_policy, info->extack);
+	if (err < 0)
+		return err;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	err = -EMSGSIZE;
+	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
+			  &devlink_nl_family, 0, DEVLINK_CMD_SELFTESTS_RUN);
+	if (!hdr)
+		goto free_msg;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto genlmsg_cancel;
+
+	selftests = nla_nest_start(msg, DEVLINK_ATTR_SELFTESTS);
+	if (!selftests)
+		goto genlmsg_cancel;
+
+	for (i = DEVLINK_ATTR_SELFTEST_ID_UNSPEC + 1;
+	     i <= DEVLINK_ATTR_SELFTEST_ID_MAX; i++) {
+		enum devlink_selftest_status test_status;
+
+		if (nla_get_flag(tb[i])) {
+			if (!devlink->ops->selftest_check(devlink, i,
+							  info->extack)) {
+				if (devlink_selftest_result_put(msg, i,
+								DEVLINK_SELFTEST_STATUS_SKIP))
+					goto selftests_nest_cancel;
+				continue;
+			}
+
+			test_status = devlink->ops->selftest_run(devlink, i,
+								 info->extack);
+			if (devlink_selftest_result_put(msg, i, test_status))
+				goto selftests_nest_cancel;
+		}
+	}
+
+	nla_nest_end(msg, selftests);
+	genlmsg_end(msg, hdr);
+	return genlmsg_reply(msg, info);
+
+selftests_nest_cancel:
+	nla_nest_cancel(msg, selftests);
+genlmsg_cancel:
+	genlmsg_cancel(msg, hdr);
+free_msg:
+	nlmsg_free(msg);
+	return err;
+}
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index a5c29ad20564..941174e157d4 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -216,3 +216,5 @@ int devlink_nl_cmd_eswitch_get_doit(struct sk_buff *skb, struct genl_info *info)
 int devlink_nl_cmd_eswitch_set_doit(struct sk_buff *skb, struct genl_info *info);
 int devlink_nl_cmd_info_get_doit(struct sk_buff *skb, struct genl_info *info);
 int devlink_nl_cmd_flash_update(struct sk_buff *skb, struct genl_info *info);
+int devlink_nl_cmd_selftests_get_doit(struct sk_buff *skb, struct genl_info *info);
+int devlink_nl_cmd_selftests_run(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index ed3fb6133501..97d30ea98b00 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -143,10 +143,6 @@ static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_
 		NLA_POLICY_BITFIELD32(DEVLINK_PORT_FN_CAPS_VALID_MASK),
 };
 
-static const struct nla_policy devlink_selftest_nl_policy[DEVLINK_ATTR_SELFTEST_ID_MAX + 1] = {
-	[DEVLINK_ATTR_SELFTEST_ID_FLASH] = { .type = NLA_FLAG },
-};
-
 #define ASSERT_DEVLINK_PORT_REGISTERED(devlink_port)				\
 	WARN_ON_ONCE(!(devlink_port)->registered)
 #define ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port)			\
@@ -3848,185 +3844,6 @@ int devlink_resources_validate(struct devlink *devlink,
 	return err;
 }
 
-static int
-devlink_nl_selftests_fill(struct sk_buff *msg, struct devlink *devlink,
-			  u32 portid, u32 seq, int flags,
-			  struct netlink_ext_ack *extack)
-{
-	struct nlattr *selftests;
-	void *hdr;
-	int err;
-	int i;
-
-	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags,
-			  DEVLINK_CMD_SELFTESTS_GET);
-	if (!hdr)
-		return -EMSGSIZE;
-
-	err = -EMSGSIZE;
-	if (devlink_nl_put_handle(msg, devlink))
-		goto err_cancel_msg;
-
-	selftests = nla_nest_start(msg, DEVLINK_ATTR_SELFTESTS);
-	if (!selftests)
-		goto err_cancel_msg;
-
-	for (i = DEVLINK_ATTR_SELFTEST_ID_UNSPEC + 1;
-	     i <= DEVLINK_ATTR_SELFTEST_ID_MAX; i++) {
-		if (devlink->ops->selftest_check(devlink, i, extack)) {
-			err = nla_put_flag(msg, i);
-			if (err)
-				goto err_cancel_msg;
-		}
-	}
-
-	nla_nest_end(msg, selftests);
-	genlmsg_end(msg, hdr);
-	return 0;
-
-err_cancel_msg:
-	genlmsg_cancel(msg, hdr);
-	return err;
-}
-
-static int devlink_nl_cmd_selftests_get_doit(struct sk_buff *skb,
-					     struct genl_info *info)
-{
-	struct devlink *devlink = info->user_ptr[0];
-	struct sk_buff *msg;
-	int err;
-
-	if (!devlink->ops->selftest_check)
-		return -EOPNOTSUPP;
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
-
-	err = devlink_nl_selftests_fill(msg, devlink, info->snd_portid,
-					info->snd_seq, 0, info->extack);
-	if (err) {
-		nlmsg_free(msg);
-		return err;
-	}
-
-	return genlmsg_reply(msg, info);
-}
-
-static int
-devlink_nl_cmd_selftests_get_dump_one(struct sk_buff *msg,
-				      struct devlink *devlink,
-				      struct netlink_callback *cb)
-{
-	if (!devlink->ops->selftest_check)
-		return 0;
-
-	return devlink_nl_selftests_fill(msg, devlink,
-					 NETLINK_CB(cb->skb).portid,
-					 cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					 cb->extack);
-}
-
-const struct devlink_cmd devl_cmd_selftests_get = {
-	.dump_one		= devlink_nl_cmd_selftests_get_dump_one,
-};
-
-static int devlink_selftest_result_put(struct sk_buff *skb, unsigned int id,
-				       enum devlink_selftest_status test_status)
-{
-	struct nlattr *result_attr;
-
-	result_attr = nla_nest_start(skb, DEVLINK_ATTR_SELFTEST_RESULT);
-	if (!result_attr)
-		return -EMSGSIZE;
-
-	if (nla_put_u32(skb, DEVLINK_ATTR_SELFTEST_RESULT_ID, id) ||
-	    nla_put_u8(skb, DEVLINK_ATTR_SELFTEST_RESULT_STATUS,
-		       test_status))
-		goto nla_put_failure;
-
-	nla_nest_end(skb, result_attr);
-	return 0;
-
-nla_put_failure:
-	nla_nest_cancel(skb, result_attr);
-	return -EMSGSIZE;
-}
-
-static int devlink_nl_cmd_selftests_run(struct sk_buff *skb,
-					struct genl_info *info)
-{
-	struct nlattr *tb[DEVLINK_ATTR_SELFTEST_ID_MAX + 1];
-	struct devlink *devlink = info->user_ptr[0];
-	struct nlattr *attrs, *selftests;
-	struct sk_buff *msg;
-	void *hdr;
-	int err;
-	int i;
-
-	if (!devlink->ops->selftest_run || !devlink->ops->selftest_check)
-		return -EOPNOTSUPP;
-
-	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_SELFTESTS))
-		return -EINVAL;
-
-	attrs = info->attrs[DEVLINK_ATTR_SELFTESTS];
-
-	err = nla_parse_nested(tb, DEVLINK_ATTR_SELFTEST_ID_MAX, attrs,
-			       devlink_selftest_nl_policy, info->extack);
-	if (err < 0)
-		return err;
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
-
-	err = -EMSGSIZE;
-	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
-			  &devlink_nl_family, 0, DEVLINK_CMD_SELFTESTS_RUN);
-	if (!hdr)
-		goto free_msg;
-
-	if (devlink_nl_put_handle(msg, devlink))
-		goto genlmsg_cancel;
-
-	selftests = nla_nest_start(msg, DEVLINK_ATTR_SELFTESTS);
-	if (!selftests)
-		goto genlmsg_cancel;
-
-	for (i = DEVLINK_ATTR_SELFTEST_ID_UNSPEC + 1;
-	     i <= DEVLINK_ATTR_SELFTEST_ID_MAX; i++) {
-		enum devlink_selftest_status test_status;
-
-		if (nla_get_flag(tb[i])) {
-			if (!devlink->ops->selftest_check(devlink, i,
-							  info->extack)) {
-				if (devlink_selftest_result_put(msg, i,
-								DEVLINK_SELFTEST_STATUS_SKIP))
-					goto selftests_nest_cancel;
-				continue;
-			}
-
-			test_status = devlink->ops->selftest_run(devlink, i,
-								 info->extack);
-			if (devlink_selftest_result_put(msg, i, test_status))
-				goto selftests_nest_cancel;
-		}
-	}
-
-	nla_nest_end(msg, selftests);
-	genlmsg_end(msg, hdr);
-	return genlmsg_reply(msg, info);
-
-selftests_nest_cancel:
-	nla_nest_cancel(msg, selftests);
-genlmsg_cancel:
-	genlmsg_cancel(msg, hdr);
-free_msg:
-	nlmsg_free(msg);
-	return err;
-}
-
 static const struct devlink_param devlink_param_generic[] = {
 	{
 		.id = DEVLINK_PARAM_GENERIC_ID_INT_ERR_RESET,
-- 
2.27.0

