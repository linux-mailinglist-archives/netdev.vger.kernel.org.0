Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0124C67D25E
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbjAZRCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbjAZRCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:02:19 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34327627BF
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 09:02:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPX+LzKf1ffoXXmOGuKnAjgMOiAKsN8VfHsTTi9/G8+3ZFjUeagXJsFGG7I1bsrTG9NrUz6taBaLWJ/kw2+VEQKYAPbDZXdRcZ1aoCLyCpkTahkv9Qf+b9XntLm0RCufnDqnlWqorEGeCT90t2O8Bzl9Du7Ekjk9nXJJA24j80E1XOZER9w+kSd8YA3zjoQloYoALGdF3V5TCxqFLGaPep+Ip9+rLLHcEgd91aM06uuGxoGvFYExqZut8WedABNdWciULpaMpjNFna/SKVzVAmOJ5kx+We05uFX8HHTNhDzkvZlWaUkQARehIpa1qgKZj1dDd30qd794Qa/wmfpj+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4fIsMoDJ/8PiWkfOg0x21X3UR76XvnVyTWkWf7ihLA=;
 b=OnlYUr1MvfX7dnnBOnbTy/wrR2o3ICQaTB4lTnAO1UeBBl8Ftii7nFwN4MbpyL8j3k9X47i+tFg2oadnFs/6k6YZYkjPS6ZH5sx7FtOIGNJ8451CvE99YWlqptPI5mnQbymoqls1DqGE/ynZq2WD3TROzgAAuzz0WulOkhK0JgHdBeXNTSyvns1r4RhjF0DnIDyv8KuDBsxzsL4P6Y7wRU15uumaJNknR+lMIr1JxCYvXPA24hyp3+b2gBX/8r9czTetZyvYYQc2kScTIiRDvf9Czp+vmWaWePNJsP5etS1PD33vpEy2eNPlJs3jwdobPFRforMjM8m6rb99Td/iPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4fIsMoDJ/8PiWkfOg0x21X3UR76XvnVyTWkWf7ihLA=;
 b=oHNSseAkzUwAoTXUmhr+WnFrFp8cvbHMZWb7GTAASOcvFgudyuns6a7VkOKE7SJ2BKtdUGVqqEIHgtLy+M0+YsgHyjw6DGwB+X9DcOUwcLgUIs6BrJHTnz8oin6mhk8Cf/Mfpw1zS+TMmIrguBXlP54dVLnkxNBKL7ha32rEepSlgOqpP2ZDMldExDr3mWtlNIuWC++K0r+/24sDt7c8Dlng01iSsVVRLMmgvg8TCmPdZa3/WbkvrUPO0jBevlsaR0W/nVw+Fh4SctZF3dNgaxP8dTQrMk+ykUjzuh31lGvXhxcwyD7Z1naPCQEvLC8+BmCY9U4FOUKhRHJiv82nXQ==
Received: from CY5PR15CA0250.namprd15.prod.outlook.com (2603:10b6:930:66::24)
 by CH0PR12MB5073.namprd12.prod.outlook.com (2603:10b6:610:e0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 17:02:12 +0000
Received: from CY4PEPF0000B8EF.namprd05.prod.outlook.com
 (2603:10b6:930:66:cafe::81) by CY5PR15CA0250.outlook.office365.com
 (2603:10b6:930:66::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Thu, 26 Jan 2023 17:02:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8EF.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.3 via Frontend Transport; Thu, 26 Jan 2023 17:02:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:01:57 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:01:54 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        <netdev@vger.kernel.org>
CC:     <bridge@lists.linux-foundation.org>,
        Petr Machata <petrm@nvidia.com>,
        "Ido Schimmel" <idosch@nvidia.com>
Subject: [PATCH net-next 02/16] net: bridge: Add extack to br_multicast_new_port_group()
Date:   Thu, 26 Jan 2023 18:01:10 +0100
Message-ID: <e22dda1dc7f1211428f6504c86ba2cedb8fdcca0.1674752051.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1674752051.git.petrm@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EF:EE_|CH0PR12MB5073:EE_
X-MS-Office365-Filtering-Correlation-Id: fb18083c-b04e-46cd-a33c-08daffbf113b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vbLO26cFV7hEQRcgdgxJFPIbQHxv0CBaXAmyU9ecL90Dmc1/FEJp3zUWoz/fv+LFyl3/kFhkNmRFvOqESF1Yr/4jI4WCeXD/Kbx+3viq63coqdCBxpzLIxrddKdbUpcHBI/q02K35ewvHfA/V5FiaD9O2nas9TpgglzEjXrI+LoxteqCKcVUKy8/n6TXJKV/V11GA1TIkHnZDowixeN5uUG4ZQuheY/xduEzGecYBDh5S3cW3MXtbcCneSg7QHEtMPJPjrbmKL/XU7TgNWp2/bF49rZFFPu0AGof/XtfO4JOkND8ACQL6B8hkHwecfn7tl3LxRAG8MU2s7HdvJLYIEwhSRsDYZsefx+yR9gSsRrERFcksKfco34ahfkCBWUYRoVFY534OFFd/BV7J3OAlSNqk3FHqJGWoAv5753/l+nWWPYKGr/MwLAAL8hUYjlgw5u4njG708UBVdd7gjd3+CzdiGtJp4YPahiq1/X8K6Y78o68qXucSdX9rwCTl/OGlB5cwXpUMI5skII7ny8G3GBG9Xduo6jtW6JG7H6YpNg40FucT9uzACDuTMZGdw7fkRZUtoMU3SicW+/crqdJ2ibpsma/y0dqygvoQCG52lCzXNz0V1//U6GbZc29XoTvGvsKPOl3UdlJKpL1brwPOySIn0GWk/zYnziW/0ax0HKAR/0zMQj/jWIWrnzUGs4FPqitTwot9IxgSjskVPlPHQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199018)(40470700004)(36840700001)(46966006)(36860700001)(8936002)(47076005)(426003)(336012)(41300700001)(6666004)(40460700003)(83380400001)(40480700001)(356005)(86362001)(7636003)(82740400003)(82310400005)(110136005)(54906003)(36756003)(70206006)(70586007)(4326008)(8676002)(316002)(2616005)(16526019)(478600001)(107886003)(26005)(186003)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 17:02:11.7897
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb18083c-b04e-46cd-a33c-08daffbf113b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5073
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make it possible to set an extack in br_multicast_new_port_group().
Eventually, this function will check for per-port and per-port-vlan
MDB maximums, and will use the extack to communicate the reason for
the bounce.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c       | 5 +++--
 net/bridge/br_multicast.c | 5 +++--
 net/bridge/br_private.h   | 3 ++-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 00e5743647b0..069061366541 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -849,7 +849,7 @@ static int br_mdb_add_group_sg(const struct br_mdb_config *cfg,
 	}
 
 	p = br_multicast_new_port_group(cfg->p, &cfg->group, *pp, flags, NULL,
-					MCAST_INCLUDE, cfg->rt_protocol);
+					MCAST_INCLUDE, cfg->rt_protocol, extack);
 	if (unlikely(!p)) {
 		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new (S, G) port group");
 		return -ENOMEM;
@@ -1075,7 +1075,8 @@ static int br_mdb_add_group_star_g(const struct br_mdb_config *cfg,
 	}
 
 	p = br_multicast_new_port_group(cfg->p, &cfg->group, *pp, flags, NULL,
-					cfg->filter_mode, cfg->rt_protocol);
+					cfg->filter_mode, cfg->rt_protocol,
+					extack);
 	if (unlikely(!p)) {
 		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new (*, G) port group");
 		return -ENOMEM;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index dea1ee1bd095..de67d176838f 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1284,7 +1284,8 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 			unsigned char flags,
 			const unsigned char *src,
 			u8 filter_mode,
-			u8 rt_protocol)
+			u8 rt_protocol,
+			struct netlink_ext_ack *extack)
 {
 	struct net_bridge_port_group *p;
 
@@ -1387,7 +1388,7 @@ __br_multicast_add_group(struct net_bridge_mcast *brmctx,
 	}
 
 	p = br_multicast_new_port_group(pmctx->port, group, *pp, 0, src,
-					filter_mode, RTPROT_KERNEL);
+					filter_mode, RTPROT_KERNEL, NULL);
 	if (unlikely(!p)) {
 		p = ERR_PTR(-ENOMEM);
 		goto out;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 15ef7fd508ee..1805c468ae03 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -956,7 +956,8 @@ br_multicast_new_port_group(struct net_bridge_port *port,
 			    const struct br_ip *group,
 			    struct net_bridge_port_group __rcu *next,
 			    unsigned char flags, const unsigned char *src,
-			    u8 filter_mode, u8 rt_protocol);
+			    u8 filter_mode, u8 rt_protocol,
+			    struct netlink_ext_ack *extack);
 int br_mdb_hash_init(struct net_bridge *br);
 void br_mdb_hash_fini(struct net_bridge *br);
 void br_mdb_notify(struct net_device *dev, struct net_bridge_mdb_entry *mp,
-- 
2.39.0

