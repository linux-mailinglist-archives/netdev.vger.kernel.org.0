Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18EBB63131A
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 09:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiKTIj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 03:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiKTIj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 03:39:57 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCD7140E6;
        Sun, 20 Nov 2022 00:39:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJO8jFGJzovs0rmHl1qmZ4EaTJ0hDCFpJZzGSgg35n4R8+au0yElXJNrB8/0iibTcuY2r2liYT8GmphIpjUO8uEO+y4lgYmxMMvOw4dYcPn12XchVbrzukXNPRDr1w4PmcqJYm5+Ob3AXsBxpLXQ0IIGcAxzt7Q9QPElR+d8a93T2IraotYeeGb0OWw4ULUmKHxuGsnAq0dtSNYAPPLjCOtX73tML2TpftnUfnrdt9ed85qwmC/jWsAV6ENvSwuaHL9fG+Yyut6+GS3+joksNM+MNAVaQcg0gm5T+OKvy9vOzkOhK+eqz/7D8UI5ISR62K9Z5ILNCWhXlnq3igdqeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S9vtSp8c01ilHRKMOwIk6b6v9Vbr8FNVp4MVgaqnFzQ=;
 b=OIZvAykKbqFTWZrygttJMjz2/A8unrP0sL3RK0L+vPAW6wlbBn54gxa/g03jYF6dtIGzPGfpx9mqzYYiWkdaelX043MzPoiDwQ+Qz36163BSIqFKGIRk8wTtLsaOkZ/OAPIoCl3sK5rjyhRzsv6cSp3Guu1BF5zUY7Vggm9oI0qaY7217V5wigbC2mmZgjnNeFxqtfpISQC1sVVz/hPf2hQgptUurTP0/FNODvLFIvocz85lrz02fPQ79RFM43NLDtnm6jU34el4sZYrSpsyIPwSwvqGGMfA7oI61w642+q9X0FS9RjeyFngLrmMw6BUn+bH0t2Rz8Qq9E0Gbmppaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9vtSp8c01ilHRKMOwIk6b6v9Vbr8FNVp4MVgaqnFzQ=;
 b=pIQUWUARYB6FAVAn1tHR9nMkrn72XmbXeZY2uatVnCCm5tIbBRvl6tSqJXadk5N3yl2gmzhjalfenpNJK4y9PEnkfqNv1ks6kb3r6kqK79v3cHIVWVeylrgozKTJs631xhTnltHi8WG+OXilDGO61xVAPbfSKvJaC0m5tvEzaA56FDs08UMyjfwS4askG57+DkNlF/RkkFhq2fs+ebZHQor8Rq34MV6dbyCoFjY3GG/BPnpXuxqyPg6qbS6kkbPMUEOgXZOQt35vg+5az+famE5oAvMnAIzJ78q774jIbu7lmTn3fynk9Df/l7suLHhFKvhnahFLoXEXq/rvTA1jnw==
Received: from DM6PR17CA0002.namprd17.prod.outlook.com (2603:10b6:5:1b3::15)
 by DS0PR12MB8019.namprd12.prod.outlook.com (2603:10b6:8:14e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Sun, 20 Nov
 2022 08:39:53 +0000
Received: from DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::40) by DM6PR17CA0002.outlook.office365.com
 (2603:10b6:5:1b3::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9 via Frontend
 Transport; Sun, 20 Nov 2022 08:39:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT031.mail.protection.outlook.com (10.13.172.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Sun, 20 Nov 2022 08:39:53 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 20 Nov
 2022 00:39:52 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 20 Nov 2022 00:39:52 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Sun, 20 Nov 2022 00:39:50 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next] devlink: remove redundant health state set to error
Date:   Sun, 20 Nov 2022 10:36:52 +0200
Message-ID: <1668933412-5498-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT031:EE_|DS0PR12MB8019:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fcf70f3-3ab9-4c05-f90a-08dacad2cba6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uNoH0SKUhBbtxQDHQqwE0Ji45KXnBGtABHgJKTvP/LVyOkKPyNee+CkP9EkOqC2ryCukE6qtF8zN7PBsOsz+fra9DrkM4u0BPAz65e9JSkxRo7YOG6Nvyg+jtvlDwFIySlEcI97/HHAzp2zgpGm8+eJq7a/xJFmp39KOQQDVY0XcvmCAwBllE+jtiqRmHOxP7U+oUv38p5LidNbhpWi4Gg4uMWIH4qDvFzzHBNhSG1O8zTWrbhcJk+jRlxChc44AyDA3o5ged1HnUAFTqxsaEVVoJChzXOjXVHXtp6Nz9GbJ2W3hvkLKiPpMPECWLsGWZ0V9e/jxIohyhBv0siv9byh9K8OW2eE1TSXD9ObR9gn8nojGtBYSxH+nw5Oq8WfZrX1gSwn9oJ9vRKdLa4BxoET2epOC4KZyUggmuj899PB8iCjgXOxu+MNXlvBe1LOvM4MvDLsQF+txuUsCYRyF5lyaBiR5FBDEA09LjrkOV/Moq20ek+zWcvGiuLAkcZQks/tLj5HkMKWaEviWqQjyV3ono6uebBRXKuo2K9qQC3RqqQWl4AiWEtGGeXsQO0VS5TiY2Z9DgDl4VhzAHWqUw3nl8KCDRf+kbjigj7v0UShN6qNOtyr3VtVAcQ9hNav2S38QDD3curlZUbQzVSzRw3dygbSOPxll7uLtA9qdE/k9Y7E8GfKMIqp+enzJIRj5CyikHHb9MJhEGr3ReGio5w==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(86362001)(36756003)(82310400005)(40460700003)(40480700001)(41300700001)(2616005)(70206006)(70586007)(4326008)(8676002)(4744005)(47076005)(426003)(186003)(8936002)(336012)(5660300002)(107886003)(478600001)(316002)(26005)(7696005)(54906003)(110136005)(82740400003)(7636003)(356005)(83380400001)(2906002)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2022 08:39:53.3600
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fcf70f3-3ab9-4c05-f90a-08dacad2cba6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8019
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reporter health_state is set twice to error in devlink_health_report().
Remove second time as it is redundant.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
---
 net/core/devlink.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index d93bc95cd7cb..cea154ddce7a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7846,8 +7846,6 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 		return -ECANCELED;
 	}
 
-	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
-
 	if (reporter->auto_dump) {
 		mutex_lock(&reporter->dump_lock);
 		/* store current dump of current error, for later analysis */
-- 
2.26.3

