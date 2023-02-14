Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A906969E1
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbjBNQjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbjBNQin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:38:43 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110102B2AB
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:38:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+qFNA6rJsmypruPQo6lIP2NRdBLFMc8mLr1H2J31YucS3EKPKjKOLUIMpUXtNFrLquYe4kEHoNwRMGiHvj2H0DTKiNb8oDWcAR0d9mdDIJWFzEKKgLwQ2eYm3aTm75fL7B+aP57YYzJlZqeLSiKQbEIFie8elSLUCZ/yWrSt6RPsk/6g3tLc6NkAH4CkaKdf9r2B/+XKAKfpxEQJ1n1FQhky7pQs6UHXPcnmIv3f5b7UOSxe2Lnd9xb3+IC/RfTDQIEaQltKIKB5F2O1PV9c6ye8Z2BsvfMYQa0b3JkM47/k5B8SMPPtRD8t8/K37TCb+kKLQ1BOqmP3/xspQSIww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YA6vA0gPLlPNxu1vhZ/nBbSsaOwswuI0FU6bmw716k=;
 b=e5v+MaD1/D0Je+7ZjlpdqNeQiWwQ+pyM7Dor5cayf8kyDzTsL6bNbPeZDFywQ/asJV/aTRh3wuQyGSyjjnlIujbSNJ1hhqEKmmqoxgdgU1LqDAuH65Og+AiNI23gptTAF4J9jScaRLQLPl8vudyO3XHc4IeveicPb3lklx0C7dsvG7qjpWFqKhImiI25QGsHjR7+r3s3rcmAgpR9/HtebtXjmNsAzYfJUxYO8MvDXlvovVgLJm7V626Xg8Kd9A3ljrFqFO0Gi1m8pCud7N0RjeyWSCSf4Ia0qtqO0CxyYMhBd+8RTzxlysMNsTsJKqTB3AvTYy0RFcqL4ko7+E5p6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YA6vA0gPLlPNxu1vhZ/nBbSsaOwswuI0FU6bmw716k=;
 b=JQSGYlSw5dceTlZ9GcGp1RibmNLh49w6927eAG5ND1C/w3YPomMfniuJwDAuURiSSBpaTBQfFt92WBP/6myOmu6bLUGJ1ylps/q7gz2FoDssxGpUNigONIarsH1rV6AnWh+SljtQ0RRtfEZyOIP7FXG3tFwEZbMoIBMw6+H5AYnPvlNh+D0VZZF3a4aGnFzPfSBjGutfAwbzIQCiFh/mqBT8y2CotbawuwsQ5rdQsERsT00/Pvn/8MINegm/hIT1OJLTZoEHpLU5ZhUu7p5LT11aoq3puChnRJmy7H4Q9J8C37rkFkFeHZ8GMbqklyM534MfjhkbNuUBnalKI64AsQ==
Received: from BN9PR03CA0761.namprd03.prod.outlook.com (2603:10b6:408:13a::16)
 by SJ2PR12MB8062.namprd12.prod.outlook.com (2603:10b6:a03:4cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 16:38:31 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::3f) by BN9PR03CA0761.outlook.office365.com
 (2603:10b6:408:13a::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Tue, 14 Feb 2023 16:38:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26 via Frontend Transport; Tue, 14 Feb 2023 16:38:31 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 08:38:26 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 14 Feb 2023 08:38:26 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 14 Feb 2023 08:38:24 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 08/10] devlink: Move health common function to health file
Date:   Tue, 14 Feb 2023 18:38:04 +0200
Message-ID: <1676392686-405892-9-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
References: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT023:EE_|SJ2PR12MB8062:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a733ef1-9b28-40b5-b346-08db0ea9e87d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TJ8AAPuMOFw8ktgJnbjW6azOcT1+QCzGI5rqYfQ1CkkjCIXuYfeIyN51wAdDDLfjM6kzmiuK8+q4gdj7CxjHNYnEIcocmeCJXCsV4Le9ulOCj7k4iZvauHK2T+FSkAlRmc0Jh9s2fnddlJ5/HyeppzG2aTVzEUL3oQmkTWCiUSgiNvB8Raxf/qAzR5x8NNhdEr/kJMT6pVbdRFor0gZw/30+6VPRyFoaV+bF9yjuQB+g+Tn+2bNLre/273PoSDcWlauhvz70TXWZGbp8eZtz7VSRayY8DP1CAGQLbDXEN6EMbxAlXxZAeABEgRhEB9VJt4DyZ9kAVpGKcFnwun426IGUCKWkpUSZZ2sX4R4h12gOXNmNON95c1snUNtswleVyerGQEs4q/U8LoU73tnpFG2l9TjE1Ivf8RXhz+UeWdCigDq0kzN2xT94LPK9ryIs3WKHS2nmBNemzPdpW2u3X0LBdiqA3d4N2kc43w1hSjdDn+dgUc4xGMLak1HL9dIfPMHnTxLMvFu6bvTjDsELH6ZuE0Q8LgXrSwBxr4w8l3ZE1+NieusENWdyPv6xsIZf88PKn8YmOUMrL+Giz7kNaQSG15LRsvXksoQVlV+meo6dMOVk+UUplQLqJ35qCWYXBuU3IEUvtcdo4axPwD5n5K/7aYgLTaGTcV47US6A+YZPknBaIBko8fCTYRWyydSyflBlOqnm02WdraU6lG+HYA==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(376002)(136003)(346002)(451199018)(36840700001)(46966006)(40470700004)(36756003)(356005)(110136005)(40460700003)(86362001)(4326008)(8676002)(47076005)(316002)(41300700001)(70206006)(8936002)(5660300002)(70586007)(7696005)(82310400005)(2906002)(36860700001)(40480700001)(83380400001)(82740400003)(186003)(6666004)(107886003)(26005)(336012)(478600001)(426003)(2616005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:38:31.3996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a733ef1-9b28-40b5-b346-08db0ea9e87d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8062
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
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
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
index 38ad890bb947..0839706d5741 100644
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

