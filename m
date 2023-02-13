Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD636946BE
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjBMNPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjBMNPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:15:11 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3971ADD7
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 05:15:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0NVYQwzRb/JLxrAL3eSiDNhdNDoSJlmY8cAEdaivFFRyuVmt+JZyDPuRh2OOApXm6WauMN/4S2rw6EFnSxRFzQQkSZUSy/FmnN7Ie0sW020cgPD8IYSyI7WkixSGTV2jonadSq/eCfzbNtu3J7bhgPxR7ObTwrR68agCjEpJh03dt8Ba629yXmdb/b+67zWLqOskorCs9vBxbArBXLkfqIwkJlslgzAbXZ8cWKXexQrRjw0MJzwO+2A81Z6MhVay0Cryu44HVTKFWKDGMqXYkK+JM6ZZq3KKTG1/5JEz3oWINDsWm5BVaoio9IYYNaPlLocBCEN7VZRKvM1vXiWcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cR5wzxObzgwrn4qs5nc6x0SSXTMRn28J74V0GA4kJpI=;
 b=j29wOBLhgmaXtmRDjuwAbgGHA8kYeGR8xDYDZ1BIDXX67qv6ay2nVz6ZesNXCiNlcmVbFOUj5UA+xju4zezTG9CU2Id3oeinQMU2G4LZUIfYgxkvAPeAJNnR35nczWVGyCyH6t+J6YyffdGLMaeY3kbWHfVrlGkV7H1l7qwgn7lI1x8bXVJhk59fUyfBOHXJWte7TTtq/esWTAbybg+ay4FFLn34onS51Qv3AlGexPVabHCp0BhAjzNSRfdU3GBdMPGnv15p48vubDD945k1wC7K+3BgiONdZn1cXCDlbb5P3COdocI5cEyh0YFm/4UBk5QPH/xrPuw+xpA30nFYUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cR5wzxObzgwrn4qs5nc6x0SSXTMRn28J74V0GA4kJpI=;
 b=qSPzwkwuqrH0gW6Gmx84Y8rtBAbw5OoO0SIv84EE9TA6ZDR8XlE9yd9Nz7AtSK2V3nd6IDPsMKxNoOK5z15CW0ZrvkdxvObh/EYH5cPX2e3lEJwrg8xVyUui9QSLVvPYs6uG3SS5b7ES9S+vNuNPw7NSrgHghUL73W5QywFCZuWVjejjXqgBMSsQyz4TUv1Q484TEpBEoBmoGOgTEza6tRPt1rA0IaVDKrJ4e7QB2kN3iumJ/KMkWZofMmWZuFB5Q5hpYbqJkz6/+RSDV+FVx386lqD342NYuqNyajBuXXJPhJ07wJg0HW4ypf2BKOak90ml0AM338G1Ayt9F9Pj1Q==
Received: from MN2PR11CA0007.namprd11.prod.outlook.com (2603:10b6:208:23b::12)
 by IA0PR12MB8349.namprd12.prod.outlook.com (2603:10b6:208:407::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Mon, 13 Feb
 2023 13:15:05 +0000
Received: from BL02EPF00010206.namprd05.prod.outlook.com
 (2603:10b6:208:23b:cafe::fe) by MN2PR11CA0007.outlook.office365.com
 (2603:10b6:208:23b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 13:15:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF00010206.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 13:15:04 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 05:14:48 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 13 Feb 2023 05:14:48 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Mon, 13 Feb 2023 05:14:47 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 00/10] devlink: cleanups and move devlink health functionality to separate file
Date:   Mon, 13 Feb 2023 15:14:08 +0200
Message-ID: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010206:EE_|IA0PR12MB8349:EE_
X-MS-Office365-Filtering-Correlation-Id: b16756ac-6fe2-41bf-b2d6-08db0dc45230
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IK+fEjOdBJt7jBeDVTHn3y3T5qSISyHCvc5Gx2qHlCb5aLnmmHpG49dzafcNmWhoQY9CT/4FXmv+XNgiWU2jWZxvATXlvbSY3PRru6J+wWeozz1BU33mhwx5JHYoI+703dwQxLN0JkClGwvuvl9eTtnqTTH34rO1eNUIlVgbxOIHShpZbPcL91OKRpEKMS3Ib3x709a2VBtQ25Vl2KiRapn8GYzdcyT2hNFqMNhjjIm74zRXRPPvtf595zIS4avBVDl9J5Sc296r4qmpvRdVyubwn1tiG3fcUCXOlaC1Em1Z6dp6iy85GGm67WHUUgFhZFUkg9iWyG38RfIakBQUuIDPTARw1D048v4nhY3nTiIfCKPoP+BCLIg0lMoHpjSWDGBl9jP5iYTFLqytsfB2PWorfduvnBalPbxsy7O4qJA4BfnYvsNoEugH9EpJnyWsy9xO04qwsn0nWE7dP49vx96ANteyiw2SinHZ7PavQnv96G7FbUFbPdcS0fRWOTOajQcrfxvIx/6k68EV0iyfw2t0q0TI0MC8MxyvGdf6RLMYvu8pXWatq/M222W69VA3ZlBzNE9/cKcig3w0oXSuiew9EQv1FBU55DxPoKkMSfnjUPIbrmteFllfJdW3NQVFlie1eHFotnb71JWfMPc5mx75ehQJl7WXWDM0x1vvv9E+DZ9Ux0X5FV/hHgB8nkGMNJiaDyqffYtJ3m1hNhNvgQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(396003)(136003)(346002)(451199018)(36840700001)(40470700004)(46966006)(8936002)(2906002)(82740400003)(356005)(40480700001)(4326008)(8676002)(70206006)(5660300002)(70586007)(36756003)(41300700001)(107886003)(110136005)(7636003)(82310400005)(86362001)(478600001)(7696005)(26005)(47076005)(336012)(426003)(186003)(2616005)(6666004)(40460700003)(36860700001)(83380400001)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 13:15:04.4700
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b16756ac-6fe2-41bf-b2d6-08db0dc45230
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010206.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8349
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset moves devlink health callbacks, helpers and related code
from leftover.c to new file health.c. About 1.3K LoC are moved by this
patchset, covering all devlink health functionality.

In addition this patchset includes a couple of small cleanups in devlink
health code and documentation update.

Moshe Shemesh (10):
  devlink: Split out health reporter create code
  devlink: health: Fix nla_nest_end in error flow
  devlink: Move devlink health get and set code to health file
  devlink: health: Don't try to add trace with NULL msg
  devlink: Move devlink health report and recover to health file
  devlink: Move devlink fmsg and health diagnose to health file
  devlink: Move devlink health dump to health file
  devlink: Move devlink health test to health file
  devlink: Move health common function to health file
  devlink: Update devlink health documentation

 .../networking/devlink/devlink-health.rst     |   23 +-
 net/devlink/Makefile                          |    2 +-
 net/devlink/devl_internal.h                   |   16 +
 net/devlink/health.c                          | 1333 +++++++++++++++++
 net/devlink/leftover.c                        | 1330 +---------------
 5 files changed, 1373 insertions(+), 1331 deletions(-)
 create mode 100644 net/devlink/health.c

-- 
2.27.0

