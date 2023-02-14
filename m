Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5326969E0
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbjBNQi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbjBNQij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:38:39 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0993928D31
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:38:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ca/yp+x2FhIV3ju7VSpvisvi+6zKDFGf5bR3zA/O52myHKn6FIvG2uzRkmZbcIAfCenlE+7zwrIupGbD0smHUKdyJbZVTYXt6ZnUdwbCbvetlr+wh0+zZKQJalbLWHcbunhOV3zNajSUTvo+SvaOLF+hpF5ca2GFkLZ2+VcpEVkisGC9HtrWHDVpoHRl2gq36UDC/MHUHdR4wt60hEeMS42vVc1eJXAhY0CDokfbr1MKhJsDrrqfeUjKNkXbw0Kg30gETsZ8i9sKRayl92+1YgWHwcWS0SYO6/Mko47SERCmycDYTgKi3VQlRNT+yon5dsxkZXc8XK2FOBDXV2uYDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jdnlszMOQc6FVsS5sUaWbPCJOUV/HNC1DD4dGHj2Y4k=;
 b=iKBH+4Wk4YKz5HeRagELnGG/TS3+Hik4U5xqiiUNkgDEuGWvcvB2X752guqNJBQjF7ZcTSEE9pxhDe1qtdGP9MYYQaa/KFvInBELymFjG0yzVhe5PoL3VXGtpFHoQ26kzSCI0zZaZtFW8nygYpfnnE2LOs2B8LF6RhSgvt9A1cl7xM4IHdEbIoWO6sAokBN6XQhJ48T8hafgYkKkrUefRSXlT4xgg4CcQpnmbR4wr5zC2RTZUIHC+x5gvO5qL6kSZil7dI0bBnh3Jflf23x4cZhHe4Kg39hBQ64X6MtgPFTyXSC71GZuwCsNrbAjYEpT4YVJjA9epVr3zRGNFicQSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jdnlszMOQc6FVsS5sUaWbPCJOUV/HNC1DD4dGHj2Y4k=;
 b=Yxv4yyAl3ClURadCrBBoTsy3DNDMuxUQsJKKs+1aS1ky81gNK51Ll/mlayN9AhnN74kGydrEojFRhqjuCN80widaxMWCtIkV18TIS2M6/wwCiNt7L3balfNKSwN4RTXffVGLAN7npyYkztA4gPFcqqNGY14rl9CW4hqc/puFipAWbx3HQbx1687lLd4CCkWqAUk/Pfb+zcJdAnaeqTfQifxDPMvhSCXc+drzATbbkgXuYoBlvvkRehJfbCZMKmHVKINUQOCWDbSGdM8ptr7l3lvaoR4Cx7Slr4Noq1om3n9w+5hYECzNHbzXk3Csf6+8IrlaUcskYb0L8pzhDMxqvQ==
Received: from MW4PR03CA0173.namprd03.prod.outlook.com (2603:10b6:303:8d::28)
 by DM6PR12MB4340.namprd12.prod.outlook.com (2603:10b6:5:2a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Tue, 14 Feb
 2023 16:38:29 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::c0) by MW4PR03CA0173.outlook.office365.com
 (2603:10b6:303:8d::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Tue, 14 Feb 2023 16:38:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26 via Frontend Transport; Tue, 14 Feb 2023 16:38:29 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 08:38:15 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 14 Feb 2023 08:38:14 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 14 Feb 2023 08:38:13 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 02/10] devlink: health: Fix nla_nest_end in error flow
Date:   Tue, 14 Feb 2023 18:37:58 +0200
Message-ID: <1676392686-405892-3-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
References: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT035:EE_|DM6PR12MB4340:EE_
X-MS-Office365-Filtering-Correlation-Id: 87098e8c-3520-42dd-5502-08db0ea9e71a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xoA0R7ZAT7gfqZV3tVABffZGIlrp3bweUgMreGtb+4KrDfVIeQ+I3wOvqBHDJqe2AjXBivayl77Eego46DsYEVhcUTCzzNy2XE4cLeUaZgCvGjFB1RTotV9nCjXSf22J426H/7/RJuIYHxKOPH6IkV45b8+N/ATWYu1zYiXialul2w/SyYABk7I7tEawsJzyjaeMfrxziYk7pVkA/ON5l+72leQR7RXN6pDmRGk+UqUY9HbrB7CAluPRAY8Pk/muw+1Ci2nCdPJ9t7cv6sJq+kL5Cd6Tj91Ofett50PXCt97pyeomGn+ZAP43oRBUeEQ1W+FYk+2rdLAQKdpTQfcD2BUkNDLV59zT/B1eJ5eYJPJI7T1ugEYq2moTN1BNS/f4J8lh5qo6Rfx/MOtbirMwMP5Nko4DNgKBP6JUs5SaP3fDbFzPOAS5xVfjkaG3FJnhaUC1m/3t2sAgAAUoEUzIvZgTfSlz7Wq1SkAadTj5qGMfpPHoq7JT3WM07+WBocEsHsXorXu+cKY7HfXbQUB1Fxt56Oa6GdVsQoMQXf697MEn++9/qBD4l4K6gCKzReAJHGspDaOkSy2zVcG74rDI+cY2UR8K1zv4Y3LnofTLhZ3qwKmkDsFSeKAv+bCQm6UUa5rv2Tyr0ddH4kvu8mpgv1Gu5xvqOGCQgNC3C4uPyabGLn6eMsI1EZ4kA9jCzzU0Pvi7y4rpHNz4TRAZ0xRCA==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39860400002)(376002)(396003)(451199018)(40470700004)(36840700001)(46966006)(478600001)(41300700001)(8936002)(5660300002)(4744005)(110136005)(40460700003)(86362001)(316002)(7696005)(4326008)(82310400005)(70206006)(70586007)(8676002)(426003)(47076005)(336012)(83380400001)(186003)(26005)(107886003)(6666004)(40480700001)(2616005)(356005)(36756003)(2906002)(82740400003)(7636003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:38:29.1644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87098e8c-3520-42dd-5502-08db0ea9e71a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4340
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink_nl_health_reporter_fill() error flow calls nla_nest_end(). Fix
it to call nla_nest_cancel() instead.

Note the bug is harmless as genlmsg_cancel() cancel the entire message,
so no fixes tag added.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/leftover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index cfd1b90a0fc1..90f95f06de28 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -6028,7 +6028,7 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
 	return 0;
 
 reporter_nest_cancel:
-	nla_nest_end(msg, reporter_attr);
+	nla_nest_cancel(msg, reporter_attr);
 genlmsg_cancel:
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
-- 
2.27.0

