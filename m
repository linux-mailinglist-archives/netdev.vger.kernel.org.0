Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0717167D265
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjAZRCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjAZRCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:02:33 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EBC27D74
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 09:02:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVqKjA3KVTBrMpWtJ+D3WRQJJeZc9YYgti0uqWHfFeu0vkcHYHi0xXN+73n9sV6F59cxgG2oPkdkI1bI8OyddqCQVKGbcT2HkgH9zt42BsPKgEUYwkai7zcgJezX9lA771kQdiOX2/LXqMMrO5jn2egz7jfAziQdJEqG6ETX+oBAeGySK0CUIYX47ChPlUCAeeVGvNmek9ah44yroucBUmqYIh33pZHo2jZa8ZSqb5oLarxzmpUW4hQ8gjk12+wAEovZzhj3QOzW8VqERhvvKyGObwZVj1H/nTU4jwj+UFrEG5M6pOmNE5U+LLbSSRjleFZ9ZmgG7Lg6IRvjv/TLoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pBd5VA6L7syDZ43Dyq/m1/c2H+SarOuvGQuo21Au2p8=;
 b=NBsL7fxhUYXxqpgbI1sciamyqDqnFeSvKlUhUlM2IafroUDTTurdf6iM+wUs7LFDTk0RmqoUYNqcu1wF0B8rRV6IyJR0yic10713ivzrHxA/946xOitjoFnlJCjxQm1Bs4aNj44D1FNgW9e3j10r6j/mdjqwNiSocyFDo4WTcWllLvOKWyMlvzU7Ux5JK6AKN4O5VAYNoXntKggEvWQ/UlXvGFH2JzBgiax4TQETbuNjwh4RSJxIm058DMO+k25PqTzyvfcGR+7p6tJc8xKVqRb1Whenp59pdt0wyRXKIaiyTpKWH7cEBm7GNt4mhD+zyrPpFvA9q77mkPTbZjBJag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBd5VA6L7syDZ43Dyq/m1/c2H+SarOuvGQuo21Au2p8=;
 b=Nworjmkyu/HbRbGLxvgAwtepilKRtSX1rHFa9dMQwMTN2y5e8MeiziB2/6xWRiw+YFD0V3QMJJmcTZvMv/mAK9vN/kQ+MVMeGcvL8jlwSwLI1dHGYhQfEgPUpo/xDi1iwHX0g0sfnkgL71kV20+TN71PyR4mXh5faGmo2DNzMCAc8V3VJ3Ex75o9NsFQd1WU44HnHWo25iMKFD6sP3p7TWJY/TPgnlxNmv1dshM6vk95IbWg9bTnV1eMppQN4T4ToWvddO7mi1eBkBYEF3ArT4d7xl2K4XxXoVGqaN9ZCiN9kzvTUclkCNs9IChFrQ3fMZQd6iXHxVtevjPVw6wCgw==
Received: from CY5PR15CA0255.namprd15.prod.outlook.com (2603:10b6:930:66::25)
 by MN2PR12MB4440.namprd12.prod.outlook.com (2603:10b6:208:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 17:02:19 +0000
Received: from CY4PEPF0000B8EF.namprd05.prod.outlook.com
 (2603:10b6:930:66:cafe::82) by CY5PR15CA0255.outlook.office365.com
 (2603:10b6:930:66::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Thu, 26 Jan 2023 17:02:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8EF.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.3 via Frontend Transport; Thu, 26 Jan 2023 17:02:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:04 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:02 -0800
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
Subject: [PATCH net-next 05/16] net: bridge: Change a cleanup in br_multicast_new_port_group() to goto
Date:   Thu, 26 Jan 2023 18:01:13 +0100
Message-ID: <9d183b709841456456c8a541a963eeb1f6ee2d1f.1674752051.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EF:EE_|MN2PR12MB4440:EE_
X-MS-Office365-Filtering-Correlation-Id: fc5418af-a852-446f-8838-08daffbf156c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yWhz9n8INNBAiChyGcJ0cQmqAothq7veKF4nclVTh8JsK+AEB59saVTvMJunmUEs0aJqL96ZpJrxn7/2Go/We5Of7s4xdFZ0izJzjolkgy+9MNX+oUTNl5GnLbwih6w8kO99YWlAGIMT5w1fsYRQlTb0YpeviS4Vhq8xkC9H7zT3pbB5fCGgMVmzJzX0xySRA1Sj0F1KkRxyyqWWZ6eDtad02t31KpQJL6BjrViQ7pqqha5eZ8vakWpDtw97itZs9yZ3DE1b3H4gAY8d6yKWKOjxkoVe8VHJQX6wd/UFE5FDX6F0sTqj6f4e/q8jpWG4Mga/A2raJgdEyTE6DIlSFVEULcJFCVt0IgB1WZVyjgA1p+F1GlJCRXhLFDbPPwvc8OgvP2fcA8SERpiw7pxfilSCO5oIb2kFuUyf19YX12oQUEuBmspLdfEL1XarI6kHf2YCtNJg5Wb6/h6IHP9BC/ziFDE2c5AOshtibRsotKarU7wKvN4Itp5EgeJ1+7agI0Z+FruN9KzX3ZINLmvsozaFS9vnwSmAaNNerLo4g0AvN/G3ERLgPRvlCrVcJcHUeKhwWQ6QIqXVp1OWHXjquVxLaKb6gh0ELLRtddPyFc+JFs2DLfTXvuETcYKzNc1xS4wToXP2nJ5+hGmgtNtF+UABQ0XxZhOV1mlDsyzr+TEUFt/yMO4EWjlkrdw2zGn/uzEWAdu1RbNyXBK5XBQp/Q==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(40460700003)(40480700001)(16526019)(26005)(6666004)(107886003)(83380400001)(316002)(426003)(336012)(186003)(2616005)(54906003)(110136005)(8676002)(4326008)(70586007)(478600001)(356005)(7636003)(70206006)(82740400003)(86362001)(36860700001)(47076005)(82310400005)(5660300002)(36756003)(2906002)(41300700001)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 17:02:18.8054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc5418af-a852-446f-8838-08daffbf156c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4440
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function is getting more to clean up in the following patches.
Structuring the cleanups in one labeled block will allow reusing the same
cleanup from several places.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_multicast.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 08da724ebfdd..51b622afdb67 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1309,8 +1309,7 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 	    rhashtable_lookup_insert_fast(&port->br->sg_port_tbl, &p->rhnode,
 					  br_sg_port_rht_params)) {
 		NL_SET_ERR_MSG_MOD(extack, "Couldn't insert new port group");
-		kfree(p);
-		return NULL;
+		goto free_out;
 	}
 
 	rcu_assign_pointer(p->next, next);
@@ -1324,6 +1323,10 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 		eth_broadcast_addr(p->eth_addr);
 
 	return p;
+
+free_out:
+	kfree(p);
+	return NULL;
 }
 
 void br_multicast_del_port_group(struct net_bridge_port_group *p)
-- 
2.39.0

