Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D02017EE21
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgCJBnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:43:40 -0400
Received: from mail-vi1eur05on2057.outbound.protection.outlook.com ([40.107.21.57]:6098
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726284AbgCJBnh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 21:43:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDJwhA8YH1hKKUjCpcMqRYiZ+4q4XZiOTzncaeH6fIu+r9fuWWJ3UOz2O7XEbreH5Bm4mfu13XFp8Alup+A3HexmXrpnNMDxlaNBSxokCRRxPH4ReBPEe7OOvt1oP2BonkMyzcNDxK5DVqXl0iUH7lWCOyg6Vrx4QLqNk9dE6KOQSqZgXScyRJG0xuFVmj8hxA/DXxMuLB4BoYXvcWKgoqRxfnK/xv/+TYq4VnIGsAKrJtP/5VzPMQlaTvvDrnRQBiP8/v02oXzXQbjJ48JD1tdBnr/9a3XBLKZ2SnkI24y3rNc1irNtNv8VFdsi1sTFkcxb5tKtpsWxu0cBEHohXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F4/IVW2JOEdpuojk74IZccgSOjIl8WRPN4Po8lwAh5E=;
 b=SMNkuIRg7R3DMRTVi3OpQCxq5Syjb/GP64uAVMas7nP9TdIK1g/gxCvo6ZtT5kLiBQfjQBz7GTYWQ0rO2j6yiGHpnD0Yklxf2awHzKaB5K5XFxHulrfoJKLgZxtHB5yD7ubUBeHxnn+4KQ8r8cX0zGsuNyVt0kraCSuwlJ8znIDvEEcx+Gf9yBTCfFxGMooQ0Z+METc1m/XN4Ld9trbb5KWPz5tA/c0o+UkCh2P90PHdYQB3Cxxvvs59fq4Rdx3xXWUfwO83LRyH8z4KO1yNUOCYvLsEvTsmWv7JRwlYjo3v4gQoZQSxhx3Ema4pxoAAS3Q6aY4QqJ3piCnvL1mwSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F4/IVW2JOEdpuojk74IZccgSOjIl8WRPN4Po8lwAh5E=;
 b=dzLrj360ZqBR6CksmJn1m6JgUYSbSSTJ7HAXEhaAh0znZlsECVNHRyepj4qdYxQ/++MkE+OI4TbjC/eMrWZIBwSITkih0y312KFNKzMOePDkeJz1iR00Lpe4doId6E1DvMKRrE8Q5hcwUp6coLkr5LwiQNyrLPoIzyFcBwvMIIk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5533.eurprd05.prod.outlook.com (20.177.201.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 01:43:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 01:43:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/11] net/mlx5e: Init ethtool steering for representors
Date:   Mon,  9 Mar 2020 18:42:45 -0700
Message-Id: <20200310014246.30830-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310014246.30830-1-saeedm@mellanox.com>
References: <20200310014246.30830-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0068.namprd08.prod.outlook.com
 (2603:10b6:a03:117::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0068.namprd08.prod.outlook.com (2603:10b6:a03:117::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 01:43:22 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: be89a1a2-cbb4-4c2e-70fd-08d7c4946c0c
X-MS-TrafficTypeDiagnostic: VI1PR05MB5533:|VI1PR05MB5533:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5533D7A8F4E31D5CDA1ACE13BEFF0@VI1PR05MB5533.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:192;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(66476007)(16526019)(316002)(1076003)(66946007)(66556008)(8676002)(86362001)(6506007)(478600001)(107886003)(5660300002)(81166006)(81156014)(6486002)(956004)(36756003)(2906002)(6512007)(4326008)(54906003)(8936002)(26005)(2616005)(52116002)(6666004)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5533;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lt3bFn83w7a5FvWwJ76d+SlXmCAwNuiyLQfCqSc+X1WeSsUhyKAiAD+eA7oYpEmrczgt04+RKu4MF6ygbhuaa7cGv5yyXLt5PRCzijJF2Sz3NFNXGtwsskGIR2H20K9IKaNvoC3VCpYKoKMAF6FWJUlWGygmfTcgKpLe+Lweo0YIPi/0EGbX4lgaZX7sxKmovOj/3HVESu9wmqOoFmPTWh4iybyOnaHuNgGrqAT+cMv3/i/q9GcRvihpuU1/W15njiRqY5CDg/iGOw32zQ/6wp4z4IQ5g15FEEmqhyA9F2GKOHO3cujC9KICImbk07m5slrXvWlLKYruoNw2hN2eVQl7Id3c2qE/bS1yE1xcwtQ7c8wdA7zQqughXCiNHjhtQM7TsDrQdeXs1zwzAAC/8MRIVfSD3gPxbCNNAIDAPUVT8GsCFdcor73kYzZffyg2lB2SZDcer2nGt0pIuyw0vBwtD3WjMDoU7cKgkHMVqEgsqu2kK3D9lyLLJVTZGdMU2R0Fmv6WxyrTMsE5mQ/ce9QpBntRRP+2W/6obBZelbo=
X-MS-Exchange-AntiSpam-MessageData: iAUM0IqVGRUPU0gcDrMbzICwnxVprjiWQdakdXknLNAkYJROmTzt0YsgJF+QaUS/rxladLv0apwvIaaiDFKkKidxt0/gFWeLYBdJ+2+OzkE1T1jyjNsCrpLs8lMjVu6rLey+dltI9h1lr4pwntL+vg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be89a1a2-cbb4-4c2e-70fd-08d7c4946c0c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 01:43:24.6691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D/KwIwMXisZtFXOXXqRWUo52/sI3Wj23NpZkFxzGLf3sTcrqqHlOfMD9cWyobJ/+BPICMhfMD32AFj6+NEHuAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5533
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

During transition to uplink representors the code responsible for
initializing ethtool steering functionality wasn't added to representor
init rx routine. This causes NULL pointer dereference during configuration
of network flow classification rule with ethtool (only possible to
reproduce with next commit in this series which registers necessary ethtool
callbacks).

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 9ff0a8e6858e..5a7de0e93f8f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1685,6 +1685,8 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_root_ft;
 
+	mlx5e_ethtool_init_steering(priv);
+
 	return 0;
 
 err_destroy_root_ft:
-- 
2.24.1

