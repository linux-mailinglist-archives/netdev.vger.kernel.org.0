Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0902E68806B
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 15:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjBBOse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 09:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbjBBOs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 09:48:27 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7726E9B;
        Thu,  2 Feb 2023 06:48:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IyYNW6vb6ltzZ56HAOwm0oQkeFYQvHDupBYj/TUxhaDheV3aw9woKTaCV9hMi1GnBfKEOtGvFIe5pw4BtuW+ozkqUJa3B+CrlsF6b7V2vthq/jUB/aNj7ndPnz9JA3E4JLfYdKDWJZPNTutdISliThTLEtblRTQGq1U+kwJxAUHphCY032qSxZ54Eqd3xbYAQDmCCQiHcLbTp9E7sLoqE3epahBypSSS6oDVIBm/o8UOIIGNedQ/HXR2rP2ZkYy8aIFIeG6PtZz8EJuGd6HRbP+H1jVUQTAensY2G/XsXtAwSiuVfVTD6xn0Cjwa6g6iu7sXNBCnrEXzNOHWAphvDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9gwp2YjbHQl+TVaz3SX9yKkVU8BQ7fFIUW1rLXDUho0=;
 b=FuRX8FwqdsqrtIN6PF3TkaBGW3rneK4rFl9TDv9Yu4wxV8rNU/ubuEvp3CZGFD72ftTUkJ+o02RFGOP894GiV+S1fezSyCOfycSbLKHv9YfCxasvvbVqbA1QHCoRkHjTqskzfOk8XsBrbP9Yx3YCg3vq4gsYxxP4Dcd55ATIEc300a8L7frGvZlEs20w4n8FaCShvyXxtdVy6Gla+90XSh78wiZ4hGeqgSPsU4hc55OLo71UvM4twkB7R9QHtpTUD/LixP2zAFi/wQxHGnao5OGWqTiXEvweuhYN4JK7sYHCRQ0+vC3rY/ltMdsXhrEYZIOfoJXgo5ZP0EKJR3Chdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gwp2YjbHQl+TVaz3SX9yKkVU8BQ7fFIUW1rLXDUho0=;
 b=IphCcKMMamMJv1CXKewYm9pwEJVCfSMPjr//K80SU5z57t5APbN1fNFHD4amd0tqER6/bh8RVuml3iMaJ7X9iKgwbxiYlzSX7Sxs8B4hnTyw7aw/q9EkJeOKkUOMhF6Wkrep/vh5w7u5rg8sZa0QUOIC5A/KOojz1efb9/xg7XZMjVs0GoWbRL7ussiZU8oWMuCjZv9jVNvYZ5bwV4janH5+1FEKluiW+SMZIRDBl+6d9rfAZmz6v+WLy5XQYJMU4fLgC6ISL7S6Sl38n7gEQZnSKDka+2vQTc/S7J4LOY+PJlOAI5ZkThB1MfNqVsVW+BvFzhv74CiumlKZsCfTSg==
Received: from MW4PR03CA0191.namprd03.prod.outlook.com (2603:10b6:303:b8::16)
 by DS0PR12MB8247.namprd12.prod.outlook.com (2603:10b6:8:f5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 14:48:02 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::2a) by MW4PR03CA0191.outlook.office365.com
 (2603:10b6:303:b8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 14:48:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.25 via Frontend Transport; Thu, 2 Feb 2023 14:48:01 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 06:47:53 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 06:47:53 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 2 Feb
 2023 06:47:51 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 6/7] devlink: Move devlink_info_req struct to be local
Date:   Thu, 2 Feb 2023 16:47:05 +0200
Message-ID: <1675349226-284034-7-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
References: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT044:EE_|DS0PR12MB8247:EE_
X-MS-Office365-Filtering-Correlation-Id: db020ea9-09f0-463b-e957-08db052c7bea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aoLmVFXiq4cn3NC0AknzI4NIHy+H21AV9rWZpPx6FEMd5j3VWp36juJ28X6jYIYB1BiuLh0ggqbljkhFkApeai9GKSzE56uL3ynlYNGrb3sdjsWLtvrSst2QLAOlXf95J+yaGehGxsi8gr50t0NJN8+PBmYbqFXMK/rFetqtp+I1IHAQWPQjySWCoxrs4NWK1UCc4X0GnzTDVjEuXt0pzy/I1AbuuDYtEq+QaySCZYeIG6cbSV11jIGDSeG8D6NDEzWd2Vo2Qv53tdDxIfeC5W0fYmyj/DtTW9rXyWcIQ4GAfK37YPuz0TyOz8d6AqdPXIgArbEwBM3M+9dGEv00IxX7FUhJ1b4GZ5PfF/YCLQ52qHPrzkvCm1V1UyRy3AxloJd4gPZvjpN6YEMS43PN7welZeMVVEPVJdOMyVGrJuh6raFpcE3kYK/f5o6FbppJGW8WAQpQSGEE0aq14OVSGUyDTQGTF0bkGEdW/sA+7b1uw/Rtf/4GcFW5WKEdM4kbTx0v+lvaJdeo0qhqpMWwwSli4jNdhIg/CC315fdiAcpKU1tvFXvA1Aa7D4CWRJR2w9DYkc6djyVaQqi+LKS5dtW9Q2dtAHstnWg2qFIETqGL/q0os9qrrbzsrWlhjI5UR8AZ5d9Lf8V3xv+b5BC+BtvTxgpQSi9QKh/iB4lIwZXekLKBH0DFaBo0WwHTbDrJAQHsmjXcC6aLoB1igH73ldg1C9DlOuIJ9dCBMynNdQYFX23J+DxR5f2pzPhz2L6b
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199018)(36840700001)(40470700004)(46966006)(2906002)(70586007)(36756003)(47076005)(40460700003)(6666004)(26005)(186003)(478600001)(107886003)(2616005)(336012)(8936002)(7696005)(86362001)(5660300002)(40480700001)(356005)(426003)(41300700001)(82310400005)(83380400001)(36860700001)(8676002)(70206006)(4326008)(316002)(82740400003)(110136005)(54906003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 14:48:01.7656
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db020ea9-09f0-463b-e957-08db052c7bea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8247
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As all users of the struct devlink_info_req are already in dev.c, move
this struct from devl_internal.c to be local in dev.c.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
 net/devlink/dev.c           | 8 ++++++++
 net/devlink/devl_internal.h | 9 ---------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/devlink/dev.c b/net/devlink/dev.c
index 83760e6c8c19..dcf0935462e8 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -8,6 +8,14 @@
 #include <net/sock.h>
 #include "devl_internal.h"
 
+struct devlink_info_req {
+	struct sk_buff *msg;
+	void (*version_cb)(const char *version_name,
+			   enum devlink_info_version_type version_type,
+			   void *version_cb_priv);
+	void *version_cb_priv;
+};
+
 struct devlink_reload_combination {
 	enum devlink_reload_action action;
 	enum devlink_reload_limit limit;
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 5fbd757b2f56..a5c29ad20564 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -189,15 +189,6 @@ static inline bool devlink_reload_supported(const struct devlink_ops *ops)
 	return ops->reload_down && ops->reload_up;
 }
 
-/* Dev info */
-struct devlink_info_req {
-	struct sk_buff *msg;
-	void (*version_cb)(const char *version_name,
-			   enum devlink_info_version_type version_type,
-			   void *version_cb_priv);
-	void *version_cb_priv;
-};
-
 /* Resources */
 struct devlink_resource;
 int devlink_resources_validate(struct devlink *devlink,
-- 
2.27.0

