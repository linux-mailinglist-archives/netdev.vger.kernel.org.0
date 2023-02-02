Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96A89688072
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 15:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbjBBOtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 09:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbjBBOs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 09:48:28 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20623.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::623])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75D11042A;
        Thu,  2 Feb 2023 06:48:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+LmLLl/p0RKCg2ImGi9fWxicCjdT1IHOJMyFSZTACzVgsl/LlD+rj5aU9Sf6/Ls/8+o7FTFfvTft3oDq/ohuuo6vU2hRephLTdBnkcT1vFcbmEVL+3gFTbvSGsGXc1jVNVITkTbc6Fp7nmkMw+l/V1vD0qeohjq6/Xldsw1+hvC/ySZ4hQOnXl5JPWZSDIQknUxgBZJwapHe15/bBWkS7oCwIFKltaPpN3uVTZqN3LRgMPkpaYqNjNMgHEkC6yPLY1dr6BQ0p69XCEveX0JhyURoQgbF+Qwm0+mIiOjataQr37K5kxmkBZ8JInSjlnOggq6K0QRGib7VfaRSfizSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZMUoU62f6P+VbqHalqQ1a9JDJmKVN0aPTNFKMW9WUw=;
 b=YXz6stAdQ+OyqwP777CKewKZe0eZlqQY4aXf9bjirRuCh2KixDS2iyNJhQ9bZDs2NKYFZKHy+egiCGO1P3v1OFXuRySpfWchB3i+Ny/XAGOFXboy3xmSfEOfvIEetch/QiIwL2fV8e4p1gW4wpYdrzd0SlLpxkUcVTPXMqfDDxF1Ee6RwPy1OCrEWFz2KXkv+NQ3p1EcDxb2qeXBJhhmiZOd6+0aBIZqUSlgOO7GbuU/pJvTeram1e8dcOwPSalnThhjAVgzfyWDULscqTQZkFiBQrWzji+bdaeWOuLY9cTnnjhoBlN7tWQsbezkacbcuBrZNNk/E0vphJPuZx9n7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZMUoU62f6P+VbqHalqQ1a9JDJmKVN0aPTNFKMW9WUw=;
 b=llvK2tgK+SxWnsGaSxtn1j2/5NJSkQILHH6srm6wk5k+jwgWp3TfJhEvsiiJzq8ri7IzY9MK+glMztPdNwaC++ZCbM5rITuYWYf7FPLqifObOsAygafduPdiHZr+zae/uNVjHbQ4QWHtSXNQScWbsw65PtKAUU+MeAiVttKr3UT8C0B7Y41r3T4OedixhMYHGF1nSXsA2j9yEJiEHt0Ayt3g/NUfRpt5llSICF0h4buevHRtVrTdZuzgZFUJRpaY0+J52t1MhKQSXcVuYIz3RR8lc1IUZIipjpa8W1f1z8Fssef/3Pn8yr6zC8Ve4KvJeR8/Tv8j/GmKEJGJQ1b1pw==
Received: from DS7PR03CA0225.namprd03.prod.outlook.com (2603:10b6:5:3ba::20)
 by PH8PR12MB6865.namprd12.prod.outlook.com (2603:10b6:510:1c8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 14:48:03 +0000
Received: from DS1PEPF0000E65D.namprd02.prod.outlook.com
 (2603:10b6:5:3ba:cafe::23) by DS7PR03CA0225.outlook.office365.com
 (2603:10b6:5:3ba::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 14:48:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E65D.mail.protection.outlook.com (10.167.18.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.21 via Frontend Transport; Thu, 2 Feb 2023 14:48:02 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 06:47:51 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 06:47:51 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 2 Feb
 2023 06:47:49 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 5/7] devlink: Move devlink dev flash code to dev
Date:   Thu, 2 Feb 2023 16:47:04 +0200
Message-ID: <1675349226-284034-6-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
References: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E65D:EE_|PH8PR12MB6865:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bca5897-4db5-45d0-d132-08db052c7ca0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AbmEZGxjDPTGVDWTDNwoKdZs06ixBxVpTXMTkiWXIT8zZ2eupg6YIFJtavVVNGRoeiSSvZXQvJaZIBpQC00lRvUcsfTrnuECxrt1OcNzMAMI0Z4gN9kSQOodXSRwGJAUD5/nOGIQ7U6Gs6reuvUnbvJhde6EyIn8HTSLU+0vaZzZedO/bNcaX+YReT58Rk+jd28AwzoKD3ykboZtJFSSZMWiSRzkDwTz+NWSrpQvq3W+Ey6c7bfTE9btAlCJfgRiEq3IMu0IubIgtTkk/m9+UiW+aXFAiWW+AX2u+IhiIaj5Lej52Bsp2bIDL4sAVHCnv76XKCDudcnBCCgF5r1uZdleZIA5t3Kf1dILB1cNqvvHqa6LP/lqVLB76yAv91dDw9TU67Zju6aOLkFBQ34v5OLkvw+xVTRrgXfC3atQh8Hbu4nMkhG/THtByv1EjvviNYub08Raiaq2Qsew8zv4g0+PwWnkzEKEZk9blOJddqvYfdPc9Wh6roCvH2W8NSqPidKkyDA5h0qTzEXa1O6NQtS6zSa/rUycpWwWgptrrY2fNNQu68apB2LuMtciUdprJ9u3xPKCS5K2VeqLiVVTJ9fWDjrbBPPYjOtm43PiGzeiWDDpSdgiifjgkKNaz2mhaLQDUVNKQXlS/V2Aybc6pTSFRij46unOHdJ8VRNvyUXdje7qkBV2Z4M8kH85KOerNSqiz3xwvqlM0o6vZMu1+g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(356005)(40480700001)(47076005)(336012)(2616005)(7636003)(426003)(83380400001)(82740400003)(36860700001)(40460700003)(8676002)(70586007)(70206006)(8936002)(30864003)(86362001)(5660300002)(2906002)(41300700001)(107886003)(4326008)(7696005)(478600001)(82310400005)(316002)(6666004)(186003)(26005)(54906003)(110136005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 14:48:02.9264
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bca5897-4db5-45d0-d132-08db052c7ca0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E65D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6865
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move devlink dev flash callbacks, helpers and other related code from
leftover.c to dev.c. No functional change in this patch.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
 net/devlink/dev.c           | 271 ++++++++++++++++++++++++++++++++++++
 net/devlink/devl_internal.h |   1 +
 net/devlink/leftover.c      | 271 ------------------------------------
 3 files changed, 272 insertions(+), 271 deletions(-)

diff --git a/net/devlink/dev.c b/net/devlink/dev.c
index dc21d2520835..83760e6c8c19 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -833,6 +833,246 @@ const struct devlink_cmd devl_cmd_info_get = {
 	.dump_one		= devlink_nl_cmd_info_get_dump_one,
 };
 
+static int devlink_nl_flash_update_fill(struct sk_buff *msg,
+					struct devlink *devlink,
+					enum devlink_command cmd,
+					struct devlink_flash_notify *params)
+{
+	void *hdr;
+
+	hdr = genlmsg_put(msg, 0, 0, &devlink_nl_family, 0, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto nla_put_failure;
+
+	if (cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS)
+		goto out;
+
+	if (params->status_msg &&
+	    nla_put_string(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG,
+			   params->status_msg))
+		goto nla_put_failure;
+	if (params->component &&
+	    nla_put_string(msg, DEVLINK_ATTR_FLASH_UPDATE_COMPONENT,
+			   params->component))
+		goto nla_put_failure;
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE,
+			      params->done, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,
+			      params->total, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT,
+			      params->timeout, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+out:
+	genlmsg_end(msg, hdr);
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static void __devlink_flash_update_notify(struct devlink *devlink,
+					  enum devlink_command cmd,
+					  struct devlink_flash_notify *params)
+{
+	struct sk_buff *msg;
+	int err;
+
+	WARN_ON(cmd != DEVLINK_CMD_FLASH_UPDATE &&
+		cmd != DEVLINK_CMD_FLASH_UPDATE_END &&
+		cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS);
+
+	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
+		return;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	err = devlink_nl_flash_update_fill(msg, devlink, cmd, params);
+	if (err)
+		goto out_free_msg;
+
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink),
+				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+	return;
+
+out_free_msg:
+	nlmsg_free(msg);
+}
+
+static void devlink_flash_update_begin_notify(struct devlink *devlink)
+{
+	struct devlink_flash_notify params = {};
+
+	__devlink_flash_update_notify(devlink,
+				      DEVLINK_CMD_FLASH_UPDATE,
+				      &params);
+}
+
+static void devlink_flash_update_end_notify(struct devlink *devlink)
+{
+	struct devlink_flash_notify params = {};
+
+	__devlink_flash_update_notify(devlink,
+				      DEVLINK_CMD_FLASH_UPDATE_END,
+				      &params);
+}
+
+void devlink_flash_update_status_notify(struct devlink *devlink,
+					const char *status_msg,
+					const char *component,
+					unsigned long done,
+					unsigned long total)
+{
+	struct devlink_flash_notify params = {
+		.status_msg = status_msg,
+		.component = component,
+		.done = done,
+		.total = total,
+	};
+
+	__devlink_flash_update_notify(devlink,
+				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
+				      &params);
+}
+EXPORT_SYMBOL_GPL(devlink_flash_update_status_notify);
+
+void devlink_flash_update_timeout_notify(struct devlink *devlink,
+					 const char *status_msg,
+					 const char *component,
+					 unsigned long timeout)
+{
+	struct devlink_flash_notify params = {
+		.status_msg = status_msg,
+		.component = component,
+		.timeout = timeout,
+	};
+
+	__devlink_flash_update_notify(devlink,
+				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
+				      &params);
+}
+EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
+
+struct devlink_flash_component_lookup_ctx {
+	const char *lookup_name;
+	bool lookup_name_found;
+};
+
+static void
+devlink_flash_component_lookup_cb(const char *version_name,
+				  enum devlink_info_version_type version_type,
+				  void *version_cb_priv)
+{
+	struct devlink_flash_component_lookup_ctx *lookup_ctx = version_cb_priv;
+
+	if (version_type != DEVLINK_INFO_VERSION_TYPE_COMPONENT ||
+	    lookup_ctx->lookup_name_found)
+		return;
+
+	lookup_ctx->lookup_name_found =
+		!strcmp(lookup_ctx->lookup_name, version_name);
+}
+
+static int devlink_flash_component_get(struct devlink *devlink,
+				       struct nlattr *nla_component,
+				       const char **p_component,
+				       struct netlink_ext_ack *extack)
+{
+	struct devlink_flash_component_lookup_ctx lookup_ctx = {};
+	struct devlink_info_req req = {};
+	const char *component;
+	int ret;
+
+	if (!nla_component)
+		return 0;
+
+	component = nla_data(nla_component);
+
+	if (!devlink->ops->info_get) {
+		NL_SET_ERR_MSG_ATTR(extack, nla_component,
+				    "component update is not supported by this device");
+		return -EOPNOTSUPP;
+	}
+
+	lookup_ctx.lookup_name = component;
+	req.version_cb = devlink_flash_component_lookup_cb;
+	req.version_cb_priv = &lookup_ctx;
+
+	ret = devlink->ops->info_get(devlink, &req, NULL);
+	if (ret)
+		return ret;
+
+	if (!lookup_ctx.lookup_name_found) {
+		NL_SET_ERR_MSG_ATTR(extack, nla_component,
+				    "selected component is not supported by this device");
+		return -EINVAL;
+	}
+	*p_component = component;
+	return 0;
+}
+
+int devlink_nl_cmd_flash_update(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *nla_overwrite_mask, *nla_file_name;
+	struct devlink_flash_update_params params = {};
+	struct devlink *devlink = info->user_ptr[0];
+	const char *file_name;
+	u32 supported_params;
+	int ret;
+
+	if (!devlink->ops->flash_update)
+		return -EOPNOTSUPP;
+
+	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME))
+		return -EINVAL;
+
+	ret = devlink_flash_component_get(devlink,
+					  info->attrs[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT],
+					  &params.component, info->extack);
+	if (ret)
+		return ret;
+
+	supported_params = devlink->ops->supported_flash_update_params;
+
+	nla_overwrite_mask = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK];
+	if (nla_overwrite_mask) {
+		struct nla_bitfield32 sections;
+
+		if (!(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK)) {
+			NL_SET_ERR_MSG_ATTR(info->extack, nla_overwrite_mask,
+					    "overwrite settings are not supported by this device");
+			return -EOPNOTSUPP;
+		}
+		sections = nla_get_bitfield32(nla_overwrite_mask);
+		params.overwrite_mask = sections.value & sections.selector;
+	}
+
+	nla_file_name = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME];
+	file_name = nla_data(nla_file_name);
+	ret = request_firmware(&params.fw, file_name, devlink->dev);
+	if (ret) {
+		NL_SET_ERR_MSG_ATTR(info->extack, nla_file_name,
+				    "failed to locate the requested firmware file");
+		return ret;
+	}
+
+	devlink_flash_update_begin_notify(devlink);
+	ret = devlink->ops->flash_update(devlink, &params, info->extack);
+	devlink_flash_update_end_notify(devlink);
+
+	release_firmware(params.fw);
+
+	return ret;
+}
+
 static void __devlink_compat_running_version(struct devlink *devlink,
 					     char *buf, size_t len)
 {
@@ -880,3 +1120,34 @@ void devlink_compat_running_version(struct devlink *devlink,
 		__devlink_compat_running_version(devlink, buf, len);
 	devl_unlock(devlink);
 }
+
+int devlink_compat_flash_update(struct devlink *devlink, const char *file_name)
+{
+	struct devlink_flash_update_params params = {};
+	int ret;
+
+	devl_lock(devlink);
+	if (!devl_is_registered(devlink)) {
+		ret = -ENODEV;
+		goto out_unlock;
+	}
+
+	if (!devlink->ops->flash_update) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
+	ret = request_firmware(&params.fw, file_name, devlink->dev);
+	if (ret)
+		goto out_unlock;
+
+	devlink_flash_update_begin_notify(devlink);
+	ret = devlink->ops->flash_update(devlink, &params, NULL);
+	devlink_flash_update_end_notify(devlink);
+
+	release_firmware(params.fw);
+out_unlock:
+	devl_unlock(devlink);
+
+	return ret;
+}
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index a0f4cd51603e..5fbd757b2f56 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -224,3 +224,4 @@ int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info);
 int devlink_nl_cmd_eswitch_get_doit(struct sk_buff *skb, struct genl_info *info);
 int devlink_nl_cmd_eswitch_set_doit(struct sk_buff *skb, struct genl_info *info);
 int devlink_nl_cmd_info_get_doit(struct sk_buff *skb, struct genl_info *info);
+int devlink_nl_cmd_flash_update(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 323a5d533703..ed3fb6133501 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -3848,246 +3848,6 @@ int devlink_resources_validate(struct devlink *devlink,
 	return err;
 }
 
-static int devlink_nl_flash_update_fill(struct sk_buff *msg,
-					struct devlink *devlink,
-					enum devlink_command cmd,
-					struct devlink_flash_notify *params)
-{
-	void *hdr;
-
-	hdr = genlmsg_put(msg, 0, 0, &devlink_nl_family, 0, cmd);
-	if (!hdr)
-		return -EMSGSIZE;
-
-	if (devlink_nl_put_handle(msg, devlink))
-		goto nla_put_failure;
-
-	if (cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS)
-		goto out;
-
-	if (params->status_msg &&
-	    nla_put_string(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG,
-			   params->status_msg))
-		goto nla_put_failure;
-	if (params->component &&
-	    nla_put_string(msg, DEVLINK_ATTR_FLASH_UPDATE_COMPONENT,
-			   params->component))
-		goto nla_put_failure;
-	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE,
-			      params->done, DEVLINK_ATTR_PAD))
-		goto nla_put_failure;
-	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,
-			      params->total, DEVLINK_ATTR_PAD))
-		goto nla_put_failure;
-	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT,
-			      params->timeout, DEVLINK_ATTR_PAD))
-		goto nla_put_failure;
-
-out:
-	genlmsg_end(msg, hdr);
-	return 0;
-
-nla_put_failure:
-	genlmsg_cancel(msg, hdr);
-	return -EMSGSIZE;
-}
-
-static void __devlink_flash_update_notify(struct devlink *devlink,
-					  enum devlink_command cmd,
-					  struct devlink_flash_notify *params)
-{
-	struct sk_buff *msg;
-	int err;
-
-	WARN_ON(cmd != DEVLINK_CMD_FLASH_UPDATE &&
-		cmd != DEVLINK_CMD_FLASH_UPDATE_END &&
-		cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS);
-
-	if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
-		return;
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return;
-
-	err = devlink_nl_flash_update_fill(msg, devlink, cmd, params);
-	if (err)
-		goto out_free_msg;
-
-	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink),
-				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
-	return;
-
-out_free_msg:
-	nlmsg_free(msg);
-}
-
-static void devlink_flash_update_begin_notify(struct devlink *devlink)
-{
-	struct devlink_flash_notify params = {};
-
-	__devlink_flash_update_notify(devlink,
-				      DEVLINK_CMD_FLASH_UPDATE,
-				      &params);
-}
-
-static void devlink_flash_update_end_notify(struct devlink *devlink)
-{
-	struct devlink_flash_notify params = {};
-
-	__devlink_flash_update_notify(devlink,
-				      DEVLINK_CMD_FLASH_UPDATE_END,
-				      &params);
-}
-
-void devlink_flash_update_status_notify(struct devlink *devlink,
-					const char *status_msg,
-					const char *component,
-					unsigned long done,
-					unsigned long total)
-{
-	struct devlink_flash_notify params = {
-		.status_msg = status_msg,
-		.component = component,
-		.done = done,
-		.total = total,
-	};
-
-	__devlink_flash_update_notify(devlink,
-				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
-				      &params);
-}
-EXPORT_SYMBOL_GPL(devlink_flash_update_status_notify);
-
-void devlink_flash_update_timeout_notify(struct devlink *devlink,
-					 const char *status_msg,
-					 const char *component,
-					 unsigned long timeout)
-{
-	struct devlink_flash_notify params = {
-		.status_msg = status_msg,
-		.component = component,
-		.timeout = timeout,
-	};
-
-	__devlink_flash_update_notify(devlink,
-				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
-				      &params);
-}
-EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
-
-struct devlink_flash_component_lookup_ctx {
-	const char *lookup_name;
-	bool lookup_name_found;
-};
-
-static void
-devlink_flash_component_lookup_cb(const char *version_name,
-				  enum devlink_info_version_type version_type,
-				  void *version_cb_priv)
-{
-	struct devlink_flash_component_lookup_ctx *lookup_ctx = version_cb_priv;
-
-	if (version_type != DEVLINK_INFO_VERSION_TYPE_COMPONENT ||
-	    lookup_ctx->lookup_name_found)
-		return;
-
-	lookup_ctx->lookup_name_found =
-		!strcmp(lookup_ctx->lookup_name, version_name);
-}
-
-static int devlink_flash_component_get(struct devlink *devlink,
-				       struct nlattr *nla_component,
-				       const char **p_component,
-				       struct netlink_ext_ack *extack)
-{
-	struct devlink_flash_component_lookup_ctx lookup_ctx = {};
-	struct devlink_info_req req = {};
-	const char *component;
-	int ret;
-
-	if (!nla_component)
-		return 0;
-
-	component = nla_data(nla_component);
-
-	if (!devlink->ops->info_get) {
-		NL_SET_ERR_MSG_ATTR(extack, nla_component,
-				    "component update is not supported by this device");
-		return -EOPNOTSUPP;
-	}
-
-	lookup_ctx.lookup_name = component;
-	req.version_cb = devlink_flash_component_lookup_cb;
-	req.version_cb_priv = &lookup_ctx;
-
-	ret = devlink->ops->info_get(devlink, &req, NULL);
-	if (ret)
-		return ret;
-
-	if (!lookup_ctx.lookup_name_found) {
-		NL_SET_ERR_MSG_ATTR(extack, nla_component,
-				    "selected component is not supported by this device");
-		return -EINVAL;
-	}
-	*p_component = component;
-	return 0;
-}
-
-static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
-				       struct genl_info *info)
-{
-	struct nlattr *nla_overwrite_mask, *nla_file_name;
-	struct devlink_flash_update_params params = {};
-	struct devlink *devlink = info->user_ptr[0];
-	const char *file_name;
-	u32 supported_params;
-	int ret;
-
-	if (!devlink->ops->flash_update)
-		return -EOPNOTSUPP;
-
-	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME))
-		return -EINVAL;
-
-	ret = devlink_flash_component_get(devlink,
-					  info->attrs[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT],
-					  &params.component, info->extack);
-	if (ret)
-		return ret;
-
-	supported_params = devlink->ops->supported_flash_update_params;
-
-	nla_overwrite_mask = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK];
-	if (nla_overwrite_mask) {
-		struct nla_bitfield32 sections;
-
-		if (!(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK)) {
-			NL_SET_ERR_MSG_ATTR(info->extack, nla_overwrite_mask,
-					    "overwrite settings are not supported by this device");
-			return -EOPNOTSUPP;
-		}
-		sections = nla_get_bitfield32(nla_overwrite_mask);
-		params.overwrite_mask = sections.value & sections.selector;
-	}
-
-	nla_file_name = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME];
-	file_name = nla_data(nla_file_name);
-	ret = request_firmware(&params.fw, file_name, devlink->dev);
-	if (ret) {
-		NL_SET_ERR_MSG_ATTR(info->extack, nla_file_name, "failed to locate the requested firmware file");
-		return ret;
-	}
-
-	devlink_flash_update_begin_notify(devlink);
-	ret = devlink->ops->flash_update(devlink, &params, info->extack);
-	devlink_flash_update_end_notify(devlink);
-
-	release_firmware(params.fw);
-
-	return ret;
-}
-
 static int
 devlink_nl_selftests_fill(struct sk_buff *msg, struct devlink *devlink,
 			  u32 portid, u32 seq, int flags,
@@ -11222,37 +10982,6 @@ devl_trap_policers_unregister(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devl_trap_policers_unregister);
 
-int devlink_compat_flash_update(struct devlink *devlink, const char *file_name)
-{
-	struct devlink_flash_update_params params = {};
-	int ret;
-
-	devl_lock(devlink);
-	if (!devl_is_registered(devlink)) {
-		ret = -ENODEV;
-		goto out_unlock;
-	}
-
-	if (!devlink->ops->flash_update) {
-		ret = -EOPNOTSUPP;
-		goto out_unlock;
-	}
-
-	ret = request_firmware(&params.fw, file_name, devlink->dev);
-	if (ret)
-		goto out_unlock;
-
-	devlink_flash_update_begin_notify(devlink);
-	ret = devlink->ops->flash_update(devlink, &params, NULL);
-	devlink_flash_update_end_notify(devlink);
-
-	release_firmware(params.fw);
-out_unlock:
-	devl_unlock(devlink);
-
-	return ret;
-}
-
 int devlink_compat_phys_port_name_get(struct net_device *dev,
 				      char *name, size_t len)
 {
-- 
2.27.0

