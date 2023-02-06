Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0BC68C25D
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 16:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjBFP6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 10:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjBFP6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 10:58:08 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2062.outbound.protection.outlook.com [40.107.101.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E621C83EC;
        Mon,  6 Feb 2023 07:58:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMjx2AS6oqHxze/z+ZNF7EU7xUljqQPtJV3h9VTC8gn9F3vBvQd+/hy5YsfyY/hOgzpJ5JhXxD/dIi9VIcEXPFgJGXVEmzHivvbXZlsgbDEX0OlNgRwJfAdj9Y5bkFKVWkwLvbEzH0Gap9BP9NrZlm51FinkOz4xzIA2NMyleglqbXzPnZtKeVlsw1AR33W3KZMMK7vwl4kpABuow3BIXY2Iu0vGi13u16RosQpERFUP4IWLHLRb/i0WQMAqQF0s0kSAHpfROKnODxFp2mWoKONVRoZdL3WTrmpUm9WOR4sOOyHngcjw+W9hiEnmtSnloOG/8E0Atcf2sr87PAGGMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w5xwz2A0WZP4CeNcqSGoLNavla+bV97zjdf8Jlvn4eg=;
 b=AIPmtBdbtZCBAJ9XsQhEptgW/VaCwTbwVXUj5YdwSrLnB+TaLD0wxfeib9DCgarc6e/YwXMfbk/Q4bWL97KjdVgcJj81RxOnmZpG0eBOHDvqcEHQ3hChsnGiyMefEq1kl9bvEkUUn1mn+o6GE4OTHhyGKe3t4GH5SeQzCSsSC+KWVIbJWgLcDJ4JjtfPaaS24UNEXpXT4DiNedSoEyhdBJ9CgoVJJ0l/ikpUNuPQty28HfQrMlTYFzzeoQmsGkWNJG9EQiw4u0HnBi/xuHVVIkoKH8mlLgAOtGBAYgn4NoQY104WhN0YiNJVZK+ClKL0EiEeqV+LqtgP3UgPdjeGHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5xwz2A0WZP4CeNcqSGoLNavla+bV97zjdf8Jlvn4eg=;
 b=c434D4cGGmsjQEfDoVQKXnoAYk5/H8PShB6E21djuVd6g/Skx7T1GV+SDKQTgq7zdVewST1U1jNDIjStWErp1VDg/mSD5WbW1Gaz5ErvjERdibmJi4OIBrjAEtjnoSCiRrJPvy0110tGXB+cGRzo7SmwE7+UqL42/KLdrMeNOfFDBugLjPBlqih4tfEM3rXjHyl2ZP2ChlstUjoCiMUE88SCTZfOcwMzmnZmAp7tLrGUu4F7pEWG/9QFnnLtwU809DjEFYepWv2eU72bL/+aUPsmnsu2XiM/BlKcvPrxFfouE+j9F+Kg4prUdCVZqmdS7g1Kj4CVL+E0HlPLwdOJEg==
Received: from DM6PR03CA0092.namprd03.prod.outlook.com (2603:10b6:5:333::25)
 by PH7PR12MB7818.namprd12.prod.outlook.com (2603:10b6:510:269::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 15:58:05 +0000
Received: from DS1PEPF0000E659.namprd02.prod.outlook.com
 (2603:10b6:5:333:cafe::44) by DM6PR03CA0092.outlook.office365.com
 (2603:10b6:5:333::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 15:58:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0000E659.mail.protection.outlook.com (10.167.18.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.17 via Frontend Transport; Mon, 6 Feb 2023 15:58:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 07:57:58 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 07:57:57 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Mon, 6 Feb
 2023 07:57:55 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, <linux-kernel@vger.kernel.org>,
        "Moshe Shemesh" <moshe@nvidia.com>
Subject: [PATCH net-next] devlink: Fix memleak in health diagnose callback
Date:   Mon, 6 Feb 2023 17:56:16 +0200
Message-ID: <1675698976-45993-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E659:EE_|PH7PR12MB7818:EE_
X-MS-Office365-Filtering-Correlation-Id: a2d88368-40e3-4272-cdae-08db085aeebc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6+U2LAdktVLeY8Yg3aFTkN1cgXMu5r5QFC5QBRN84HaV6uAkn4dKK1JVoeT/l7pUjldIMxei4GzDGctPJ/lMnF3AaNQ7jJO0AOmi6LJtzu1BILf34IzUkelJ0EI+caeKg0KG4LZpYL6yS4lEkFM9ZkgDhGuD0Qfv4DRRjh5nVCJO89rvsCURiieh78f8nv2fR9wGzFtzRlWeD9KIpGk8bFZ/AWVq2jwKCEszx++BVwLYovC6Ois54hgAwn3YUHvM16Sxbg0Eu3G5Ctv3sqXCtKV7Dr6Ck0FyAuaJYRgKF3r6lcGQCcxi6QXXiZTxqQ2oaEUcO5ZCTsd3wviz4GyaWriI5OOvgjvj98h398v6nGGi0IYWr4MJrXhYZ+DxXwGv750b66SlauetJ7WvwK+d4UHnBbsBETxt3Td7N+rJybYlbOHhy3CpeO58AgQbKnoXK0qvZTs6wcQnGD+O/Q7waduGi9Ax20FA2nkZw4nfIcYh8eEaD+A7X9dmA2FQBVA2ZzJQhRRWII0iUDGcp4G7CzFle2gU3t1KL0AKipwIMR29qDieY4dlqLltlSqZgjF2XyXBVoRnbYtjZeyShQdXwxC1IZZrwwAusuUM2TNR/DFEz/2+gIey6qdYG3HlDjQ7QMaSPz0IM/T/e6XKDUrK2TtKYwjzAtpVPBaUfbg1/pFhjqi4CH+1og0ve2mh48NL9hgoju5bafjdDuK8Icc04A==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(346002)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(83380400001)(36860700001)(40460700003)(36756003)(82740400003)(82310400005)(86362001)(40480700001)(8676002)(70206006)(4326008)(7636003)(70586007)(2616005)(336012)(47076005)(426003)(356005)(26005)(186003)(107886003)(7696005)(6666004)(110136005)(478600001)(54906003)(8936002)(316002)(5660300002)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 15:58:04.6924
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2d88368-40e3-4272-cdae-08db085aeebc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E659.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7818
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The callback devlink_nl_cmd_health_reporter_diagnose_doit() miss
devlink_fmsg_free(), which leads to memory leak.

Fix it by adding devlink_fmsg_free().

Fixes: e994a75fb7f9 ("devlink: remove reporter reference counting")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/leftover.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 056d9ca14a3d..79bb8320fc3a 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7866,18 +7866,22 @@ static int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
 
 	err = devlink_fmsg_obj_nest_start(fmsg);
 	if (err)
-		return err;
+		goto out;
 
 	err = reporter->ops->diagnose(reporter, fmsg, info->extack);
 	if (err)
-		return err;
+		goto out;
 
 	err = devlink_fmsg_obj_nest_end(fmsg);
 	if (err)
-		return err;
+		goto out;
+
+	err = devlink_fmsg_snd(fmsg, info,
+			       DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE, 0);
 
-	return devlink_fmsg_snd(fmsg, info,
-				DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE, 0);
+out:
+	devlink_fmsg_free(fmsg);
+	return err;
 }
 
 static int
-- 
2.37.1

