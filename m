Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184FE6946BC
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjBMNPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbjBMNPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:15:00 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77B6213B
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 05:14:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mil9vxh2AB0bbKuvPa7Qutn/OuDHbVEeENZiPqqoLGBzPKO8W9SROuIltYKkefPNyRne35HBIoHmpdLyIi12i856LGr33PtzCLNEJXvluvsi4lW9VOA6288VYUQn402aE4XcED9yiQvEenZPSqccC/lZlXNK/sNvXeNReZdaIb+8ui6lmFnOuL2Jg4xFY2FwV6an5nZ+hvCHgX4M83Ym4vH1/VX/0ESg6c0rPoY0JI5vKmB952qSIqRypZWSXrN0TeE5YYP1hxdE4YRm8/q1ldK2QS3x0V1/6sMlpcI1vQrFRYneOGPr25LROvMPGNk0MSp+26gbp8xjiC+504kitA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9xKOv9VucLTb8txdS5R6WJVyNc6jRIH0luDNposPCfk=;
 b=IJnzTHx8A8IPJkqePx+5+Vi8kdPf5ezyjSVugwkKDdKhsfTvpvOVbncOwzfJNTbfG3jMwMMV+bT6976P90dmubjlkpOrTHEhHH/66jeIFH+a+lkmWKVpKJeqjUn6vMz9UyIS9JPYdTNKvd3dtsZLZyzcLWqPWNoW4BelCqM7K1X9Dj+bIPNKqDYjGO1PKNZzGhejRuCmuvYa7NrBKAceUyHrIdi1JSpToac3mkxs9P7NTQKY9KofmgBVZu9syEBt+oEsvm8egLhXE0PR1hNE6sYbWvAi3GihXq3bFfRalQruTUxBz/4VUCCWnDXhit+HNuMxLR7GdwMMqgDTwWVdsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xKOv9VucLTb8txdS5R6WJVyNc6jRIH0luDNposPCfk=;
 b=kSY+uw6yAB0PnJ8Hheq5XD6tH3MtDm6B7sZSa04nf015uii3CZrhhzQm62HI3k4qRj8pnxaGgKOKAzyS1dHv3GdqXo3y+IBpcgohYyX0o6sHNLRnxrtCbeaiRRZLduxZ27iKw2Ix0Gw3cqUxFMhqqpVSNdoFl8J5vPOPXA61leqYhRw4J2hmyu0cdLmtEy5XwOFaWwdXk0unWH9ASVK7V18N3VnajFtxsql2GZMCUqnrqUefPFJMMcaa1MOfyYG14+6rsb9DV0+VrzGpbY40BaGDuWJjnxVi/f/2wyrUXsFmrYDhwinMtH3FI/s6McH6TA6nih8KsdC6B1QtpqRrng==
Received: from DS7PR03CA0197.namprd03.prod.outlook.com (2603:10b6:5:3b6::22)
 by MW3PR12MB4444.namprd12.prod.outlook.com (2603:10b6:303:5c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Mon, 13 Feb
 2023 13:14:57 +0000
Received: from DS1PEPF0000E643.namprd02.prod.outlook.com
 (2603:10b6:5:3b6:cafe::39) by DS7PR03CA0197.outlook.office365.com
 (2603:10b6:5:3b6::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 13:14:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS1PEPF0000E643.mail.protection.outlook.com (10.167.17.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 13:14:57 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 05:14:56 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 13 Feb 2023 05:14:56 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Mon, 13 Feb 2023 05:14:54 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 04/10] devlink: health: Don't try to add trace with NULL msg
Date:   Mon, 13 Feb 2023 15:14:12 +0200
Message-ID: <1676294058-136786-5-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
References: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E643:EE_|MW3PR12MB4444:EE_
X-MS-Office365-Filtering-Correlation-Id: 8433a609-7262-40d1-1021-08db0dc44de5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VrnB6XlSo+u6hM2sZw+cl5rczOQs70Jmu3VBHSgx9ww4D5GUnkJHaAz4NdcWiE57H3TiCEKYKnkjoItP7jB/MwtBwJhmwje5/qRHNgNU2HM9Ecv7KVlYQNlAzG2Wqreuy7oGMFERkAwdeTrZC2WgV9QblM1w8IPSafJPa/h/ShqUBZlEFhz0NWaWev5Fm53lGCmAQ79YbSj063vdlPPjL8PFN7yv36zVfBQ1LwcNrrzijUOaEJQ/oOuLE15Fwhi6BHxpG4klhOH0Yk7tEslmvQyHIIS085E8osfHcFg/j1yrRijkAuPbkQ4JKYOz08t0XK1soDTkCuEYZNDIbU2Ma8SW/iBzORMVREBb5qwO/IebbnzZK18CAcCA2ZzIC+0yBK4bxdnXy6IzVwFRWHlx17qH3X30M7TMrlgEkRjIdjiVENDfRmVY1+WnqWexPZ4aCioSXK9VEy+60P8wPP5lui+JuUoKqmtya4nJ7lXs7mu03f7Vz/ej7aNd/3KmVdepn3OpwqibqRRkIQXthZzU8IIazCBN+pMF/AIxQKvexQ9jPChJ1j+BE9zkcbB3CpV+oyQEgaB4pqilgqx4sx/2IATHWcYXPJ8cUOiTxGcTp072S05a2OVn2LjZax/RH0QlX7HkOSId3p7As5JS0cSNeU2e1X73M7hR0Kxh2UJ+1QDxSSHPGBFvbznQO/Yn9ojJTCGXmw14JOgO11pIBOxx2g==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(376002)(136003)(451199018)(36840700001)(46966006)(40470700004)(41300700001)(4744005)(70206006)(316002)(110136005)(70586007)(8676002)(5660300002)(2906002)(8936002)(7696005)(478600001)(4326008)(6666004)(40460700003)(26005)(186003)(2616005)(107886003)(47076005)(36756003)(426003)(336012)(40480700001)(83380400001)(36860700001)(356005)(7636003)(86362001)(82310400005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 13:14:57.3259
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8433a609-7262-40d1-1021-08db0dc44de5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E643.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4444
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case devlink_health_report() msg argument is NULL a warning is
triggered, but then continue and try to print a trace with NULL pointer.

Fix it to skip trace call if msg pointer is NULL.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
 net/devlink/leftover.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 0b1c5e0122f3..bc72d80141cf 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -6077,8 +6077,8 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 	int ret;
 
 	/* write a log message of the current error */
-	WARN_ON(!msg);
-	trace_devlink_health_report(devlink, reporter->ops->name, msg);
+	if (!WARN_ON(!msg))
+		trace_devlink_health_report(devlink, reporter->ops->name, msg);
 	reporter->error_count++;
 	prev_health_state = reporter->health_state;
 	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
-- 
2.27.0

