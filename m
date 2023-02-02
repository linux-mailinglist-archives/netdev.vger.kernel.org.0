Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645E9688069
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 15:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbjBBOsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 09:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbjBBOs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 09:48:27 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6046146A1;
        Thu,  2 Feb 2023 06:48:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5i3LrVufIFg9Kn9vBpc9t8NaLQ7VJUEDbtySfodPAfkZ/vSwaqln7VUwNk2m00rm65OxFjO6S1BPDtJbffnK5+4falS/9e4edMIW9qQ0qOjwO03TpHt9T1e2HYWb0W1XH21lJGhw9eVLDX9/JFlpNoIzlPzqTB+zSnvS/mygC3h/uyfhyorkrpgdxnmpniwTvss2thodb3vCQHsoMLSxx1Y+aaHyPWxYEPPBNjYYHwpFgC0Czqq5dOT6rpF6xgQyImjcDddWJyvTYUupiL5MJIJCln3/XffwKY5v+GV6/6eNrfiP5vw7yCIw9dgQhfAzv5NJS0sJm4MIPBTHXFppg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9kL88P6vqFjraxL/Cvtj7HAoZgQb9iAKqHUbsz7BO0=;
 b=WY685eq4QI5ZMgXrT1cUjtshDrZjA3vV++Cpe/+n0KPFRhliqZhPBEdFd+nVsVYLQpBsCeqdifOPg4xHR7smuAWR0zX3NLFBnTZoj0iPpxgVIo/Aa3SGFy4n3N/+wqHfH01lAtqqsvZp7GSEpw+XAoeIx8jr83keXb4DaTbUd65FvnMA96tFVq10kMfEHyjWDPd/UzZqAWltSbt32RVOf7cCrHtqKfGkfJlWJCp08UyMD71XJquB9UqWYUUnYTeB6YkB0PqE7C9j5tTrtJOFlQzXqS9mjP1WERBeS3kv778YJBjaAcQ8t6VgPv2AHGu8sSLbj7QV9pmLnPZFf2foSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9kL88P6vqFjraxL/Cvtj7HAoZgQb9iAKqHUbsz7BO0=;
 b=hJDt7L75o+5+skByzYDr3O9UDAFenvb3iawy7i1L4cJjZf98W9wfmHgWmwfmdkL9deDgNRvs2eKncv5vpFf50Bx7w6PIYSa+KHNL4PiCPOFYTxdRUEDvBJDPmA9+5WY3MKzRcvu4+TlQvao3jMfFiacy3uZi3Y7y1i+EuROeujpWztSCMJ5M8CCVLwifRbJCYL96qAof2xXFd/tRv7rYfzWqqHoyT1yIMoUU4TAdZZUwPGVx4dPWXDWKeDGttUX67CdLmzQxMVxZDZTKj2N3QqPYjSx0m8/2/YStdWlSPizI5tb4Knn7Z9ynmOHZS3koIfMYRgyrz/vkWXy9EmsX5Q==
Received: from DM6PR13CA0033.namprd13.prod.outlook.com (2603:10b6:5:bc::46) by
 SJ1PR12MB6219.namprd12.prod.outlook.com (2603:10b6:a03:456::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 14:47:59 +0000
Received: from DS1PEPF0000E65A.namprd02.prod.outlook.com
 (2603:10b6:5:bc:cafe::bf) by DM6PR13CA0033.outlook.office365.com
 (2603:10b6:5:bc::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.7 via Frontend
 Transport; Thu, 2 Feb 2023 14:47:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E65A.mail.protection.outlook.com (10.167.18.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.21 via Frontend Transport; Thu, 2 Feb 2023 14:47:59 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 06:47:49 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 06:47:48 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 2 Feb
 2023 06:47:47 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 4/7] devlink: Move devlink dev info code to dev
Date:   Thu, 2 Feb 2023 16:47:03 +0200
Message-ID: <1675349226-284034-5-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
References: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E65A:EE_|SJ1PR12MB6219:EE_
X-MS-Office365-Filtering-Correlation-Id: dd3f574d-ba6d-4fe0-62e4-08db052c7aad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hsox3GDM6efSIPBH9xm2qQPkHWBzqFLBQmY+uc3/YoVFqZUmyejpCOoVkOVI9im034gZESXf6u5+vz3Bv0uLAc9IFwAyIIKwaHyIaibtMnJ8f30tWoRdct9R/jDfvIFDzBATJBFWiI2IUop1WWSS1t1NgEBjBxjdjBFrreN6u0hKOkwbl//1xYZ8oQ8wZONUUZZzUfqExdqQ+hmpLZaybFTeZqG/Nx4ibiaVhTxexysztgNDBWLy1qqXCugSSR86tCmL2q8UwiNUSW7rCwQxzqcisf9eQPo6ZSGch18s28LyxiojAbFT8oufxUXfDJNtMMTZ55nasFFFhwQqwDERXebWbnB1r5s38z5CfLMZgq3/1OOxEQbR/7ilumePy9ZwYUteEi51Us8XLsPVcxrWVjVpcHgI1qlXhlPLP+aAthRNUFm6aIrcxiOGLeVVxZy41mgp5j1Mgltqf4Ty1fBkHJB2JHxUCtJxE8BP4hzgvu9sto1A20TOPHN143ha+cljClwu6KejeRkFp/yqCGYUcanOQUvDn2TLQtVG8+hzEBTXxfjcjxGq+f+XaESLITMeWXGzYM2/40C/S9h+Ri4hdCvh8RTWQuzkiROZy4IIVcAjRgUJ7ng772toHQM3RRq0OuESg7h/ldAcszoQzqDKOgbgCtNcAj67JAq1Cbi+0K8KLmE9YH3B4/lfCr7CABD6QfZSMJ8GVf4cqM+XmXg2jg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(376002)(346002)(396003)(451199018)(36840700001)(40470700004)(46966006)(36860700001)(316002)(426003)(336012)(47076005)(83380400001)(82310400005)(40460700003)(70206006)(36756003)(86362001)(70586007)(8676002)(82740400003)(40480700001)(356005)(7636003)(30864003)(4326008)(2906002)(41300700001)(5660300002)(478600001)(6666004)(110136005)(54906003)(26005)(8936002)(107886003)(186003)(2616005)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 14:47:59.6221
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd3f574d-ba6d-4fe0-62e4-08db052c7aad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E65A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6219
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move devlink dev info callbacks, related drivers helpers functions and
other related code from leftover.c to dev.c. No functional change in
this patch.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
 net/devlink/dev.c           | 246 ++++++++++++++++++++++++++++++++++
 net/devlink/devl_internal.h |  10 ++
 net/devlink/leftover.c      | 255 ------------------------------------
 3 files changed, 256 insertions(+), 255 deletions(-)

diff --git a/net/devlink/dev.c b/net/devlink/dev.c
index 4de3dcc42022..dc21d2520835 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -634,3 +634,249 @@ int devlink_nl_cmd_eswitch_set_doit(struct sk_buff *skb, struct genl_info *info)
 
 	return 0;
 }
+
+int devlink_info_serial_number_put(struct devlink_info_req *req, const char *sn)
+{
+	if (!req->msg)
+		return 0;
+	return nla_put_string(req->msg, DEVLINK_ATTR_INFO_SERIAL_NUMBER, sn);
+}
+EXPORT_SYMBOL_GPL(devlink_info_serial_number_put);
+
+int devlink_info_board_serial_number_put(struct devlink_info_req *req,
+					 const char *bsn)
+{
+	if (!req->msg)
+		return 0;
+	return nla_put_string(req->msg, DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER,
+			      bsn);
+}
+EXPORT_SYMBOL_GPL(devlink_info_board_serial_number_put);
+
+static int devlink_info_version_put(struct devlink_info_req *req, int attr,
+				    const char *version_name,
+				    const char *version_value,
+				    enum devlink_info_version_type version_type)
+{
+	struct nlattr *nest;
+	int err;
+
+	if (req->version_cb)
+		req->version_cb(version_name, version_type,
+				req->version_cb_priv);
+
+	if (!req->msg)
+		return 0;
+
+	nest = nla_nest_start_noflag(req->msg, attr);
+	if (!nest)
+		return -EMSGSIZE;
+
+	err = nla_put_string(req->msg, DEVLINK_ATTR_INFO_VERSION_NAME,
+			     version_name);
+	if (err)
+		goto nla_put_failure;
+
+	err = nla_put_string(req->msg, DEVLINK_ATTR_INFO_VERSION_VALUE,
+			     version_value);
+	if (err)
+		goto nla_put_failure;
+
+	nla_nest_end(req->msg, nest);
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(req->msg, nest);
+	return err;
+}
+
+int devlink_info_version_fixed_put(struct devlink_info_req *req,
+				   const char *version_name,
+				   const char *version_value)
+{
+	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_FIXED,
+					version_name, version_value,
+					DEVLINK_INFO_VERSION_TYPE_NONE);
+}
+EXPORT_SYMBOL_GPL(devlink_info_version_fixed_put);
+
+int devlink_info_version_stored_put(struct devlink_info_req *req,
+				    const char *version_name,
+				    const char *version_value)
+{
+	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_STORED,
+					version_name, version_value,
+					DEVLINK_INFO_VERSION_TYPE_NONE);
+}
+EXPORT_SYMBOL_GPL(devlink_info_version_stored_put);
+
+int devlink_info_version_stored_put_ext(struct devlink_info_req *req,
+					const char *version_name,
+					const char *version_value,
+					enum devlink_info_version_type version_type)
+{
+	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_STORED,
+					version_name, version_value,
+					version_type);
+}
+EXPORT_SYMBOL_GPL(devlink_info_version_stored_put_ext);
+
+int devlink_info_version_running_put(struct devlink_info_req *req,
+				     const char *version_name,
+				     const char *version_value)
+{
+	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_RUNNING,
+					version_name, version_value,
+					DEVLINK_INFO_VERSION_TYPE_NONE);
+}
+EXPORT_SYMBOL_GPL(devlink_info_version_running_put);
+
+int devlink_info_version_running_put_ext(struct devlink_info_req *req,
+					 const char *version_name,
+					 const char *version_value,
+					 enum devlink_info_version_type version_type)
+{
+	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_RUNNING,
+					version_name, version_value,
+					version_type);
+}
+EXPORT_SYMBOL_GPL(devlink_info_version_running_put_ext);
+
+static int devlink_nl_driver_info_get(struct device_driver *drv,
+				      struct devlink_info_req *req)
+{
+	if (!drv)
+		return 0;
+
+	if (drv->name[0])
+		return nla_put_string(req->msg, DEVLINK_ATTR_INFO_DRIVER_NAME,
+				      drv->name);
+
+	return 0;
+}
+
+static int
+devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
+		     enum devlink_command cmd, u32 portid,
+		     u32 seq, int flags, struct netlink_ext_ack *extack)
+{
+	struct device *dev = devlink_to_dev(devlink);
+	struct devlink_info_req req = {};
+	void *hdr;
+	int err;
+
+	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	err = -EMSGSIZE;
+	if (devlink_nl_put_handle(msg, devlink))
+		goto err_cancel_msg;
+
+	req.msg = msg;
+	if (devlink->ops->info_get) {
+		err = devlink->ops->info_get(devlink, &req, extack);
+		if (err)
+			goto err_cancel_msg;
+	}
+
+	err = devlink_nl_driver_info_get(dev->driver, &req);
+	if (err)
+		goto err_cancel_msg;
+
+	genlmsg_end(msg, hdr);
+	return 0;
+
+err_cancel_msg:
+	genlmsg_cancel(msg, hdr);
+	return err;
+}
+
+int devlink_nl_cmd_info_get_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct sk_buff *msg;
+	int err;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	err = devlink_nl_info_fill(msg, devlink, DEVLINK_CMD_INFO_GET,
+				   info->snd_portid, info->snd_seq, 0,
+				   info->extack);
+	if (err) {
+		nlmsg_free(msg);
+		return err;
+	}
+
+	return genlmsg_reply(msg, info);
+}
+
+static int
+devlink_nl_cmd_info_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
+				 struct netlink_callback *cb)
+{
+	int err;
+
+	err = devlink_nl_info_fill(msg, devlink, DEVLINK_CMD_INFO_GET,
+				   NETLINK_CB(cb->skb).portid,
+				   cb->nlh->nlmsg_seq, NLM_F_MULTI,
+				   cb->extack);
+	if (err == -EOPNOTSUPP)
+		err = 0;
+	return err;
+}
+
+const struct devlink_cmd devl_cmd_info_get = {
+	.dump_one		= devlink_nl_cmd_info_get_dump_one,
+};
+
+static void __devlink_compat_running_version(struct devlink *devlink,
+					     char *buf, size_t len)
+{
+	struct devlink_info_req req = {};
+	const struct nlattr *nlattr;
+	struct sk_buff *msg;
+	int rem, err;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	req.msg = msg;
+	err = devlink->ops->info_get(devlink, &req, NULL);
+	if (err)
+		goto free_msg;
+
+	nla_for_each_attr(nlattr, (void *)msg->data, msg->len, rem) {
+		const struct nlattr *kv;
+		int rem_kv;
+
+		if (nla_type(nlattr) != DEVLINK_ATTR_INFO_VERSION_RUNNING)
+			continue;
+
+		nla_for_each_nested(kv, nlattr, rem_kv) {
+			if (nla_type(kv) != DEVLINK_ATTR_INFO_VERSION_VALUE)
+				continue;
+
+			strlcat(buf, nla_data(kv), len);
+			strlcat(buf, " ", len);
+		}
+	}
+free_msg:
+	nlmsg_free(msg);
+}
+
+void devlink_compat_running_version(struct devlink *devlink,
+				    char *buf, size_t len)
+{
+	if (!devlink->ops->info_get)
+		return;
+
+	devl_lock(devlink);
+	if (devl_is_registered(devlink))
+		__devlink_compat_running_version(devlink, buf, len);
+	devl_unlock(devlink);
+}
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 79165050feea..a0f4cd51603e 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -189,6 +189,15 @@ static inline bool devlink_reload_supported(const struct devlink_ops *ops)
 	return ops->reload_down && ops->reload_up;
 }
 
+/* Dev info */
+struct devlink_info_req {
+	struct sk_buff *msg;
+	void (*version_cb)(const char *version_name,
+			   enum devlink_info_version_type version_type,
+			   void *version_cb_priv);
+	void *version_cb_priv;
+};
+
 /* Resources */
 struct devlink_resource;
 int devlink_resources_validate(struct devlink *devlink,
@@ -214,3 +223,4 @@ int devlink_nl_cmd_get_doit(struct sk_buff *skb, struct genl_info *info);
 int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info);
 int devlink_nl_cmd_eswitch_get_doit(struct sk_buff *skb, struct genl_info *info);
 int devlink_nl_cmd_eswitch_set_doit(struct sk_buff *skb, struct genl_info *info);
+int devlink_nl_cmd_info_get_doit(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 1fa58e69a7a2..323a5d533703 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -3976,14 +3976,6 @@ void devlink_flash_update_timeout_notify(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
 
-struct devlink_info_req {
-	struct sk_buff *msg;
-	void (*version_cb)(const char *version_name,
-			   enum devlink_info_version_type version_type,
-			   void *version_cb_priv);
-	void *version_cb_priv;
-};
-
 struct devlink_flash_component_lookup_ctx {
 	const char *lookup_name;
 	bool lookup_name_found;
@@ -5820,205 +5812,6 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	return err;
 }
 
-int devlink_info_serial_number_put(struct devlink_info_req *req, const char *sn)
-{
-	if (!req->msg)
-		return 0;
-	return nla_put_string(req->msg, DEVLINK_ATTR_INFO_SERIAL_NUMBER, sn);
-}
-EXPORT_SYMBOL_GPL(devlink_info_serial_number_put);
-
-int devlink_info_board_serial_number_put(struct devlink_info_req *req,
-					 const char *bsn)
-{
-	if (!req->msg)
-		return 0;
-	return nla_put_string(req->msg, DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER,
-			      bsn);
-}
-EXPORT_SYMBOL_GPL(devlink_info_board_serial_number_put);
-
-static int devlink_info_version_put(struct devlink_info_req *req, int attr,
-				    const char *version_name,
-				    const char *version_value,
-				    enum devlink_info_version_type version_type)
-{
-	struct nlattr *nest;
-	int err;
-
-	if (req->version_cb)
-		req->version_cb(version_name, version_type,
-				req->version_cb_priv);
-
-	if (!req->msg)
-		return 0;
-
-	nest = nla_nest_start_noflag(req->msg, attr);
-	if (!nest)
-		return -EMSGSIZE;
-
-	err = nla_put_string(req->msg, DEVLINK_ATTR_INFO_VERSION_NAME,
-			     version_name);
-	if (err)
-		goto nla_put_failure;
-
-	err = nla_put_string(req->msg, DEVLINK_ATTR_INFO_VERSION_VALUE,
-			     version_value);
-	if (err)
-		goto nla_put_failure;
-
-	nla_nest_end(req->msg, nest);
-
-	return 0;
-
-nla_put_failure:
-	nla_nest_cancel(req->msg, nest);
-	return err;
-}
-
-int devlink_info_version_fixed_put(struct devlink_info_req *req,
-				   const char *version_name,
-				   const char *version_value)
-{
-	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_FIXED,
-					version_name, version_value,
-					DEVLINK_INFO_VERSION_TYPE_NONE);
-}
-EXPORT_SYMBOL_GPL(devlink_info_version_fixed_put);
-
-int devlink_info_version_stored_put(struct devlink_info_req *req,
-				    const char *version_name,
-				    const char *version_value)
-{
-	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_STORED,
-					version_name, version_value,
-					DEVLINK_INFO_VERSION_TYPE_NONE);
-}
-EXPORT_SYMBOL_GPL(devlink_info_version_stored_put);
-
-int devlink_info_version_stored_put_ext(struct devlink_info_req *req,
-					const char *version_name,
-					const char *version_value,
-					enum devlink_info_version_type version_type)
-{
-	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_STORED,
-					version_name, version_value,
-					version_type);
-}
-EXPORT_SYMBOL_GPL(devlink_info_version_stored_put_ext);
-
-int devlink_info_version_running_put(struct devlink_info_req *req,
-				     const char *version_name,
-				     const char *version_value)
-{
-	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_RUNNING,
-					version_name, version_value,
-					DEVLINK_INFO_VERSION_TYPE_NONE);
-}
-EXPORT_SYMBOL_GPL(devlink_info_version_running_put);
-
-int devlink_info_version_running_put_ext(struct devlink_info_req *req,
-					 const char *version_name,
-					 const char *version_value,
-					 enum devlink_info_version_type version_type)
-{
-	return devlink_info_version_put(req, DEVLINK_ATTR_INFO_VERSION_RUNNING,
-					version_name, version_value,
-					version_type);
-}
-EXPORT_SYMBOL_GPL(devlink_info_version_running_put_ext);
-
-static int devlink_nl_driver_info_get(struct device_driver *drv,
-				      struct devlink_info_req *req)
-{
-	if (!drv)
-		return 0;
-
-	if (drv->name[0])
-		return nla_put_string(req->msg, DEVLINK_ATTR_INFO_DRIVER_NAME,
-				      drv->name);
-
-	return 0;
-}
-
-static int
-devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
-		     enum devlink_command cmd, u32 portid,
-		     u32 seq, int flags, struct netlink_ext_ack *extack)
-{
-	struct device *dev = devlink_to_dev(devlink);
-	struct devlink_info_req req = {};
-	void *hdr;
-	int err;
-
-	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
-	if (!hdr)
-		return -EMSGSIZE;
-
-	err = -EMSGSIZE;
-	if (devlink_nl_put_handle(msg, devlink))
-		goto err_cancel_msg;
-
-	req.msg = msg;
-	if (devlink->ops->info_get) {
-		err = devlink->ops->info_get(devlink, &req, extack);
-		if (err)
-			goto err_cancel_msg;
-	}
-
-	err = devlink_nl_driver_info_get(dev->driver, &req);
-	if (err)
-		goto err_cancel_msg;
-
-	genlmsg_end(msg, hdr);
-	return 0;
-
-err_cancel_msg:
-	genlmsg_cancel(msg, hdr);
-	return err;
-}
-
-static int devlink_nl_cmd_info_get_doit(struct sk_buff *skb,
-					struct genl_info *info)
-{
-	struct devlink *devlink = info->user_ptr[0];
-	struct sk_buff *msg;
-	int err;
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
-
-	err = devlink_nl_info_fill(msg, devlink, DEVLINK_CMD_INFO_GET,
-				   info->snd_portid, info->snd_seq, 0,
-				   info->extack);
-	if (err) {
-		nlmsg_free(msg);
-		return err;
-	}
-
-	return genlmsg_reply(msg, info);
-}
-
-static int
-devlink_nl_cmd_info_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
-				 struct netlink_callback *cb)
-{
-	int err;
-
-	err = devlink_nl_info_fill(msg, devlink, DEVLINK_CMD_INFO_GET,
-				   NETLINK_CB(cb->skb).portid,
-				   cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				   cb->extack);
-	if (err == -EOPNOTSUPP)
-		err = 0;
-	return err;
-}
-
-const struct devlink_cmd devl_cmd_info_get = {
-	.dump_one		= devlink_nl_cmd_info_get_dump_one,
-};
-
 struct devlink_fmsg_item {
 	struct list_head list;
 	int attrtype;
@@ -11429,54 +11222,6 @@ devl_trap_policers_unregister(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devl_trap_policers_unregister);
 
-static void __devlink_compat_running_version(struct devlink *devlink,
-					     char *buf, size_t len)
-{
-	struct devlink_info_req req = {};
-	const struct nlattr *nlattr;
-	struct sk_buff *msg;
-	int rem, err;
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return;
-
-	req.msg = msg;
-	err = devlink->ops->info_get(devlink, &req, NULL);
-	if (err)
-		goto free_msg;
-
-	nla_for_each_attr(nlattr, (void *)msg->data, msg->len, rem) {
-		const struct nlattr *kv;
-		int rem_kv;
-
-		if (nla_type(nlattr) != DEVLINK_ATTR_INFO_VERSION_RUNNING)
-			continue;
-
-		nla_for_each_nested(kv, nlattr, rem_kv) {
-			if (nla_type(kv) != DEVLINK_ATTR_INFO_VERSION_VALUE)
-				continue;
-
-			strlcat(buf, nla_data(kv), len);
-			strlcat(buf, " ", len);
-		}
-	}
-free_msg:
-	nlmsg_free(msg);
-}
-
-void devlink_compat_running_version(struct devlink *devlink,
-				    char *buf, size_t len)
-{
-	if (!devlink->ops->info_get)
-		return;
-
-	devl_lock(devlink);
-	if (devl_is_registered(devlink))
-		__devlink_compat_running_version(devlink, buf, len);
-	devl_unlock(devlink);
-}
-
 int devlink_compat_flash_update(struct devlink *devlink, const char *file_name)
 {
 	struct devlink_flash_update_params params = {};
-- 
2.27.0

