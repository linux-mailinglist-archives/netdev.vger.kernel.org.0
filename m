Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA946969E6
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbjBNQjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbjBNQjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:39:04 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD1E2CFD3
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:38:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z69dzK2z2PPEZlU/i7wemraX7gIIEURa65KisyL6aRpa3MJSsoSCDZ3XLWiXOEdXa6RxcECVyjmzqfWNjqr053NCeKbZgf3OpJdx57WVPZQMIsYmuHcVpR482JWoSIG72otf/DnxfQumwSiT7ZDGDd6gM7rwMWtvX4xharmwm+Gzu7SamNdra42g+ZZW+xMSY3fKyhp+oy1nEq3jr/fKAdxl6Ih9MmzHxtdKFlSm7c+bSBUKMxe4fa49NmYRR4h1Mo0S8vpuZX0Edokr5JTLDbiEJyjXd9hJspgNQRG8Ia2eOBDTz6Hf5p5QRQHL/nzhAiFiyVzM5g463miSEg70yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0u50CcqXULvXwXknKiThHjGA0kwT9L8wjFnqAxtjgCY=;
 b=L7XOJ8w6xVsiNOl4BfdLQPGipfIcbi1HYOIan4R70xG1RplWdNDRpEnrtL+Jwx8oEqgM8h2q1HO9bt913jNGSA4DQwrTjIgKwtTdGavBqGI9Dfzy/CZbhfe5OJ9YIJazIoaiOyKqFCfVOch3trCaSjDzU4tQm/lLW4OXxZVp0VgyBTF2A+TTf/n02p4cF9l8GAGX7Hk1t/gPkEZww4DzHBQKT0couRtZ4Q4psnEYVbf6ztcyF94hb99bMwgwB4BW15Nl7fbsvdp7zOO3LMzctFt1D39UR2oWF0/XQC8wmUjGySYKHN/9ASrR1kygk6AOdSZ+mhPTOo1NcnLF/uyBjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0u50CcqXULvXwXknKiThHjGA0kwT9L8wjFnqAxtjgCY=;
 b=JiJnb+VXghvxQmZAnYmkCoMA+MU71T8b1pG7WUbqB9klNl8fjfhSq09PTJPU3MnB912eQxOowMqvOushSe7bDYgEgy6dFgL0GttFYwEBH9F/i5S8l3nT0NPtLBKSZMpaiG48wmN1wSInqdyku+SNuEKkJVp4xwkwhEOF4BGxA7kYkAfS7QUgCynGSsKU7iru/sq9uPp/OAa6kATVO+r2nweQGwce+9AXMgSwhULWMEPztS1gTa85/FKTi1cVbnsEHrQHR9wwPsnmaoBimhK7q4cpbYAgiBDpBeN7r/C4cII5kA9RsTMVqJkZQld6vyl8k79XaaW6zsbnVLzu9Z+N8Q==
Received: from BN0PR03CA0016.namprd03.prod.outlook.com (2603:10b6:408:e6::21)
 by SJ2PR12MB8717.namprd12.prod.outlook.com (2603:10b6:a03:53d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 16:38:40 +0000
Received: from BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::2e) by BN0PR03CA0016.outlook.office365.com
 (2603:10b6:408:e6::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Tue, 14 Feb 2023 16:38:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT080.mail.protection.outlook.com (10.13.176.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.10 via Frontend Transport; Tue, 14 Feb 2023 16:38:38 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 08:38:30 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 14 Feb 2023 08:38:30 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 14 Feb 2023 08:38:28 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 10/10] devlink: Fix TP_STRUCT_entry in trace of devlink health report
Date:   Tue, 14 Feb 2023 18:38:06 +0200
Message-ID: <1676392686-405892-11-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
References: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT080:EE_|SJ2PR12MB8717:EE_
X-MS-Office365-Filtering-Correlation-Id: 954328f4-019a-462a-656a-08db0ea9ecfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I7yAy4avqOOIsbGgGqOCt0O62xqIUNbzBaWFwaIMZM+d5wgzmna7VVy+ogjm+G1GmiG1UVcXzNC2EueKqz0qarjAWP68Ou7COcReHkTPIXhuhHwryeHznfTzB9e46mDABa2sUv7Pf8ec2fEO8doMu7H8Jpy9sKazcK+pNKfbG/H4PzjYJdfJq20DIraDgSSYqlRopc49FSNOqasO4886Rw3eAo/e9ecFeus7vdibR17Lg4CHIij/5UC9vZtd1Qzik5L18VZJ674LThu+D1B/WTh8tN9lCgRF29iLlxzUMoRa2nvbJ0pJOFD+6LV+9TUWCcBqJjBerzrT3wpDjWLx9OeqTJPyV9VcEoGSKi3v6MginLRlYOOhCmBUdW4Jep209NHJc7eq9wipE8vRNyXTxHXNSY6RQ2dIcc/tz8T9VO2BFEWL8+z+4BF25VYIFJAPWQLoPiKU+3M7Der313YJ/NFtHi0d1evHTwSmf1Uii0ka5PjXOlFCNuYshfu3lnpCYlRwXSkVsL/y+UwbyB2Bps8OmtUzsn50FVDjrktSx1zdfGPBQaiBG60eJDUVBJn+W9eHIuUzkb6/ySYTOYsZYqxoJEZmEzu1vX2JNYez6wFA/Rpkq44e7sq2fmThwl5RshSA/lxTHbO97ZoPJ+FAgVz0EMs/ombqpYOtBVhkW2OhGIhMkHnuj+tJydxcZ8NOH3QJp0ObHfbDzgLJfEPHpQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199018)(36840700001)(46966006)(40470700004)(36756003)(40460700003)(110136005)(41300700001)(356005)(8676002)(316002)(70206006)(4326008)(36860700001)(40480700001)(86362001)(82740400003)(82310400005)(7636003)(107886003)(6666004)(70586007)(26005)(7696005)(478600001)(2616005)(4744005)(8936002)(2906002)(186003)(47076005)(5660300002)(83380400001)(336012)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:38:38.9317
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 954328f4-019a-462a-656a-08db0ea9ecfd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8717
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a bug in trace point definition for devlink health report, as
TP_STRUCT_entry of reporter_name should get reporter_name and not msg.

Note no fixes tag as this is a harmless bug as both reporter_name and
msg are strings and TP_fast_assign for this entry is correct.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
 include/trace/events/devlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/devlink.h b/include/trace/events/devlink.h
index 24969184c534..77ff7cfc6049 100644
--- a/include/trace/events/devlink.h
+++ b/include/trace/events/devlink.h
@@ -88,7 +88,7 @@ TRACE_EVENT(devlink_health_report,
 		__string(bus_name, devlink_to_dev(devlink)->bus->name)
 		__string(dev_name, dev_name(devlink_to_dev(devlink)))
 		__string(driver_name, devlink_to_dev(devlink)->driver->name)
-		__string(reporter_name, msg)
+		__string(reporter_name, reporter_name)
 		__string(msg, msg)
 	),
 
-- 
2.27.0

