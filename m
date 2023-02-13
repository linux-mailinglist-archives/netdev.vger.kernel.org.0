Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80366946C4
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbjBMNPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjBMNPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:15:41 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E27A1A670
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 05:15:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HG7AQmOrn3ZVhQtsogEs1CRFRcO/uuRqPgSjtDpw+YCHuRt+tTXFusss77Hg4B8wVTMgd8XqiSvjJD9Vs8RMLABZG7uDjasZUGHXEXcjpChvUQfUW1c34bV6fh64VK834xmmEtdN11AIKNYe/nEk3Td0mZ26ptzg4Mprj8bf66y5+3OEZ1hWlmVuYBIo5xrf8NmQqmbRdHuLU3r+9im7fHpGvWDd54zTViweBryc8wPaYuAEn2Z7iJkfOZUVngO9RdJlt0vs9+U52PMYNnTEDoj3ypFn9mXr6XXpnQEQIuCVW7c1c8aQB7cSeuopktplprkc79qqB7uPYS2gsZyimQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nqbyEzMcwtGgXDMDoz3+tofRlScwAd6m5BYDYa2QY3E=;
 b=bJVttjvamGlCg6IgAOsYqqUBCF+VRHkyg4bxPZs/YG92t9WE/g3EpwTKHbhnWIZS05Y4lyG08TfeyRWg7RK5gfkN1UGsaQx/lo8nWzAAlFUApRo43IpQpS0xnDMvc9ygjsDW6uL5CKp5OOLzyMk4ZjeuE0255H+wBpdyuRlGcIQgooKL0cIFXcm4O6UCItIYfLAeTEchgF3eaVVr8S5CxoMeYO40QAnvkHR32t3mXOxK11ubcU9hYkv7ikijErf1AnJXl8XLG4vz1ZSvBoR3f7rn6O/RNsCDsJnMM7sdxBZuCq3+V7AoqQ9mMtkGAZ5mRTheh7d0NgAvISTfvkAJ0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nqbyEzMcwtGgXDMDoz3+tofRlScwAd6m5BYDYa2QY3E=;
 b=qXNekmK71Mi4uE9aEttlmgxp5qu3FgrSKXOL/6CE+4uvrD1oLpjvxg0TNIfTHAJShw44tsjr8WME2uIahmtk6qQDuWUGa4cCbgYYP7Aktw4RzIHc5zOcFvBaQgSCX6lfukxmfYQin6tmgtdtep7AVo4bndCZTyZ1sJeRaiPfU3JOq9oTF+ND1pFBXwxX270xDyLLa+fBvBjp0PaZVpV6cXoL9tUhs1U2hZItD6BXso99Sxz1BPGJ2Lgli5e2U2q1WpZ+j9n8LyupU091rFuVCl2p828ls6xLyiMyKGAdD1K/UN+nyD68OxL0kJaz3t7GDC2/RVop5ornVVwP7VlB8g==
Received: from MN2PR10CA0014.namprd10.prod.outlook.com (2603:10b6:208:120::27)
 by CH0PR12MB5283.namprd12.prod.outlook.com (2603:10b6:610:d6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 13:15:18 +0000
Received: from BL02EPF00010209.namprd05.prod.outlook.com
 (2603:10b6:208:120:cafe::26) by MN2PR10CA0014.outlook.office365.com
 (2603:10b6:208:120::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 13:15:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF00010209.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 13:15:17 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 05:15:06 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 13 Feb 2023 05:15:05 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Mon, 13 Feb 2023 05:15:04 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 09/10] devlink: Move health common function to health file
Date:   Mon, 13 Feb 2023 15:14:17 +0200
Message-ID: <1676294058-136786-10-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
References: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010209:EE_|CH0PR12MB5283:EE_
X-MS-Office365-Filtering-Correlation-Id: f56ab75a-12a8-4833-f32f-08db0dc45a1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y3e9eBuad6qABAJlpN/yeiP4XUPOAQX1/n9okWjDgSN8HwLnR0RDvURuhH6pMAPiO042V6fI4XooE1p7YFLz3r28iF4zZWT3PZig0+qj0QI9M/JYPaEXkyngLOVYjfzRvXAcfnvw8rLuJR5rO4+VXPY9zyylCQol4+4C8EWt9KJyo1ZATXNMxAuqW3oMou5ib7ZMJv+JA1HrzPhalucdll9SzUTdHPw90F7V2Sh7Ivw/6L9naMSOP3waLaxjZjpR+hqVylDupTr7qfRkqXXKnADNyH4msLYyRJixCagr6KlAoiA/OMz2Xmk8T5dQLWq6b5qW3fW5TzcxgzKP0OZ5vaFAKEskBcZ4BbUyI9kllypsKSdZU4sTee+D+c/QZGEK4UZO1aAE0GsYFEpAIBIBiLZyzl+sjpEmKykzNHn40eFJlkyzYnYXjFRV/ERWnrEEYLqMFaJDCmsD3FMmopto0UdQOSn8rEghZ+WGwwYfuSiU7I46iEKAhLqsWBnx0XE1gzdb7CP3PpwaDZep0eNGqKZgbCzJYrsV/FnxUicvXswDL6pKVCvU+lOOKRgOHqCQD1VOiA/IWaOljFT5yZ969SO4bRzuA6KOPcmr7uBgEO8senKuVzKRBh8DjDOyYs9QffuwNTRvtm5jmxCgYS/1Q0p/GccjMbXttppiRiPTSHd4/W1Smb95JKwmRNLTTmxsamkkn7dbDYOSfFfofwR+Bg==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199018)(40470700004)(46966006)(36840700001)(40460700003)(36756003)(86362001)(110136005)(316002)(8676002)(4326008)(70586007)(478600001)(7696005)(6666004)(2906002)(70206006)(82310400005)(41300700001)(8936002)(5660300002)(82740400003)(356005)(36860700001)(40480700001)(7636003)(26005)(336012)(2616005)(83380400001)(47076005)(426003)(107886003)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 13:15:17.7845
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f56ab75a-12a8-4833-f32f-08db0dc45a1d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5283
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that all devlink health callbacks and related code are in file
health.c move common health functions and devlink_health_reporter struct
to be local in health.c file.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
 net/devlink/devl_internal.h | 47 -------------------------------------
 net/devlink/health.c        | 45 +++++++++++++++++++++++++----------
 2 files changed, 32 insertions(+), 60 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 211f7ea38d6a..e133f423294a 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -200,53 +200,6 @@ int devlink_resources_validate(struct devlink *devlink,
 			       struct devlink_resource *resource,
 			       struct genl_info *info);
 
-/* Health */
-struct devlink_health_reporter {
-	struct list_head list;
-	void *priv;
-	const struct devlink_health_reporter_ops *ops;
-	struct devlink *devlink;
-	struct devlink_port *devlink_port;
-	struct devlink_fmsg *dump_fmsg;
-	struct mutex dump_lock; /* lock parallel read/write from dump buffers */
-	u64 graceful_period;
-	bool auto_recover;
-	bool auto_dump;
-	u8 health_state;
-	u64 dump_ts;
-	u64 dump_real_ts;
-	u64 error_count;
-	u64 recovery_count;
-	u64 last_recovery_ts;
-};
-
-struct devlink_health_reporter *
-devlink_health_reporter_find_by_name(struct devlink *devlink,
-				     const char *reporter_name);
-struct devlink_health_reporter *
-devlink_port_health_reporter_find_by_name(struct devlink_port *devlink_port,
-					  const char *reporter_name);
-struct devlink_health_reporter *
-devlink_health_reporter_get_from_attrs(struct devlink *devlink,
-				       struct nlattr **attrs);
-struct devlink_health_reporter *
-devlink_health_reporter_get_from_info(struct devlink *devlink,
-				      struct genl_info *info);
-int
-devlink_nl_health_reporter_fill(struct sk_buff *msg,
-				struct devlink_health_reporter *reporter,
-				enum devlink_command cmd, u32 portid,
-				u32 seq, int flags);
-int devlink_health_do_dump(struct devlink_health_reporter *reporter,
-			   void *priv_ctx,
-			   struct netlink_ext_ack *extack);
-int devlink_fmsg_dumpit(struct devlink_fmsg *fmsg, struct sk_buff *skb,
-			struct netlink_callback *cb,
-			enum devlink_command cmd);
-
-struct devlink_fmsg *devlink_fmsg_alloc(void);
-void devlink_fmsg_free(struct devlink_fmsg *fmsg);
-
 /* Line cards */
 struct devlink_linecard;
 
diff --git a/net/devlink/health.c b/net/devlink/health.c
index 3ebd531dee8a..1bcc254e38b1 100644
--- a/net/devlink/health.c
+++ b/net/devlink/health.c
@@ -27,7 +27,7 @@ struct devlink_fmsg {
 			      */
 };
 
-struct devlink_fmsg *devlink_fmsg_alloc(void)
+static struct devlink_fmsg *devlink_fmsg_alloc(void)
 {
 	struct devlink_fmsg *fmsg;
 
@@ -40,7 +40,7 @@ struct devlink_fmsg *devlink_fmsg_alloc(void)
 	return fmsg;
 }
 
-void devlink_fmsg_free(struct devlink_fmsg *fmsg)
+static void devlink_fmsg_free(struct devlink_fmsg *fmsg)
 {
 	struct devlink_fmsg_item *item, *tmp;
 
@@ -51,6 +51,25 @@ void devlink_fmsg_free(struct devlink_fmsg *fmsg)
 	kfree(fmsg);
 }
 
+struct devlink_health_reporter {
+	struct list_head list;
+	void *priv;
+	const struct devlink_health_reporter_ops *ops;
+	struct devlink *devlink;
+	struct devlink_port *devlink_port;
+	struct devlink_fmsg *dump_fmsg;
+	struct mutex dump_lock; /* lock parallel read/write from dump buffers */
+	u64 graceful_period;
+	bool auto_recover;
+	bool auto_dump;
+	u8 health_state;
+	u64 dump_ts;
+	u64 dump_real_ts;
+	u64 error_count;
+	u64 recovery_count;
+	u64 last_recovery_ts;
+};
+
 void *
 devlink_health_reporter_priv(struct devlink_health_reporter *reporter)
 {
@@ -70,7 +89,7 @@ __devlink_health_reporter_find_by_name(struct list_head *reporter_list,
 	return NULL;
 }
 
-struct devlink_health_reporter *
+static struct devlink_health_reporter *
 devlink_health_reporter_find_by_name(struct devlink *devlink,
 				     const char *reporter_name)
 {
@@ -78,7 +97,7 @@ devlink_health_reporter_find_by_name(struct devlink *devlink,
 						      reporter_name);
 }
 
-struct devlink_health_reporter *
+static struct devlink_health_reporter *
 devlink_port_health_reporter_find_by_name(struct devlink_port *devlink_port,
 					  const char *reporter_name)
 {
@@ -239,7 +258,7 @@ devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
 }
 EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
 
-int
+static int
 devlink_nl_health_reporter_fill(struct sk_buff *msg,
 				struct devlink_health_reporter *reporter,
 				enum devlink_command cmd, u32 portid,
@@ -310,7 +329,7 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
-struct devlink_health_reporter *
+static struct devlink_health_reporter *
 devlink_health_reporter_get_from_attrs(struct devlink *devlink,
 				       struct nlattr **attrs)
 {
@@ -330,7 +349,7 @@ devlink_health_reporter_get_from_attrs(struct devlink *devlink,
 								 reporter_name);
 }
 
-struct devlink_health_reporter *
+static struct devlink_health_reporter *
 devlink_health_reporter_get_from_info(struct devlink *devlink,
 				      struct genl_info *info)
 {
@@ -517,9 +536,9 @@ devlink_health_dump_clear(struct devlink_health_reporter *reporter)
 	reporter->dump_fmsg = NULL;
 }
 
-int devlink_health_do_dump(struct devlink_health_reporter *reporter,
-			   void *priv_ctx,
-			   struct netlink_ext_ack *extack)
+static int devlink_health_do_dump(struct devlink_health_reporter *reporter,
+				  void *priv_ctx,
+				  struct netlink_ext_ack *extack)
 {
 	int err;
 
@@ -1157,9 +1176,9 @@ static int devlink_fmsg_snd(struct devlink_fmsg *fmsg,
 	return err;
 }
 
-int devlink_fmsg_dumpit(struct devlink_fmsg *fmsg, struct sk_buff *skb,
-			struct netlink_callback *cb,
-			enum devlink_command cmd)
+static int devlink_fmsg_dumpit(struct devlink_fmsg *fmsg, struct sk_buff *skb,
+			       struct netlink_callback *cb,
+			       enum devlink_command cmd)
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	int index = state->idx;
-- 
2.27.0

