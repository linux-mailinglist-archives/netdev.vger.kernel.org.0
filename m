Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC2C17B229
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 00:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgCEXSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 18:18:11 -0500
Received: from mail-am6eur05on2074.outbound.protection.outlook.com ([40.107.22.74]:62017
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbgCEXSJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 18:18:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+lcsExqEGDvDHJMgLJoCfexOlglCROTSUjpUwhau09xTXqNtiMyu5CNicFdqEdQDbEr9XrJ1I0142wCdaDoGyJfKGzuJB2ERuuGZ3waLs2HgD4jb5d4K+cJRG1WQCRuQr6Zd8Wn4I0DlS+LGeTUO2sesom1EaTZ4kcmSqDUB+UK2+ImmcDGRPLn5R9qvr3lFmwtb3P1MJNr0/7HxtMtPfLuKvo53uBchrgaMWC5WNnYX9kRYmhghUjsAuxSa+pRwKKvwb+fU9iQuN6ntaA4F6V+3k4ANROOdrr+1BO1jfwDwTTso+NYaMN877tGgrztVmydxbcMychM4h76AImA0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDLsklAW/QIfte2F90l9BExcaE3unulgFGAB++QJPbY=;
 b=bPyqPs724ytcpkNPlZEt8W0jQevVqZltn9c4x8LQbGlT9ArqlaqKp9f0xXr29Thxgha0sCTOko6U9xk7Akm1jVTvzqXkw9vmGbIQDqwONABN601WMYXnk236FGkX1uW5iEov3BIME4mNiLthjMe5FQTCAdG5c0voX3Ub9Doh34LpFDnyZvhTf4zcLF2JmJ03tuxlpO/KkZ/1n/G4CzQEyayKkiMx9YoW8xNE6JVsWIIh5rNArssrTA23tZJjCp5ua0dLkuBL1k4tSHJUIpqAfOYCqTizRJi6xh5hJMUih9zlmYopwd/QkjgOpMEQ/fSgt+benmPYnDoeK6XJH4EwSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDLsklAW/QIfte2F90l9BExcaE3unulgFGAB++QJPbY=;
 b=p2BkvXnR0DmXTtHkcuXnfEICk/7oxrjfhbi25dfASJPd3pOLwU8fX3ZFeTBYdP347IYbTSh0yWuvDiRvSY7k+nZXlQaDonzums9vVGy4rEfT95JZqUs/KTfrpbM1hESl9XlEEuThyG6iEIgHf7bFVgHqLH5DrRdPVOVaCczXHvA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Thu, 5 Mar 2020 23:18:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 23:18:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Sebastian Hense <sebastian.hense1@ibm.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 4/5] net/mlx5e: Fix endianness handling in pedit mask
Date:   Thu,  5 Mar 2020 15:17:38 -0800
Message-Id: <20200305231739.227618-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305231739.227618-1-saeedm@mellanox.com>
References: <20200305231739.227618-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0042.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::19) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0042.namprd06.prod.outlook.com (2603:10b6:a03:14b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Thu, 5 Mar 2020 23:18:01 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7c0f3455-dd29-4cec-0db1-08d7c15b73b5
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41895A9C52D759FD7943A4ACBEE20@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 03333C607F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(189003)(199004)(2906002)(81166006)(6506007)(5660300002)(6512007)(4326008)(81156014)(6486002)(52116002)(8676002)(54906003)(36756003)(8936002)(66556008)(66476007)(66946007)(2616005)(316002)(1076003)(86362001)(6666004)(956004)(186003)(6916009)(26005)(16526019)(478600001)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2rFi5z0CGflMVIcMhC/r0Tj7d0ySuGINKe3JZno3v7UGKXMzDFcN8l18QWybFlEEVAbD9OuKbrDU98iF+z213omy2gfUS9r4KUv6Bnae8nAlyyhvmNTK6P4UBxaZ91+p71klD7urCKYBUWUfcp1d8v+o0p4JslJvZetSMMHPWYNNRaPpi8N9DXxUc0HhZVSIz1xwOiLCOiBMMrxA3nPeKVuehb1/lyszaKnZxXbG14A9LF7uk3GPJDwbu/c0mKeCrx7Qm7C4Mm9S+HmlT8rP2PAihyaSpX7T7EVX5MxVeH86eUdcOOMcgZxBLpIXKd3sFCQjTXFW4/WIqrxN349gZxqgN7btH4JbVZy/wW5jF30MaAKCfFxxtn//+0/W0UGg/cHqR7gOeG1AAMuMFwwLIU+4z6x9HPZW5u8NudOkpEbPgW1IRlgkXJnwgpwXPlBfxRhV4ipIPMaIKqMT7Q1mqAI72JwNz5tA0oE1m7dp5wwqSHE8kjmeqGRDQ7EqP1CPkuwmYaoPXQ8SHmacZ6U4xvm9yomwOTFSPeYA3GRixOc=
X-MS-Exchange-AntiSpam-MessageData: C0pfcJBbSEn/cnRZ9cx/K996lFKkkjgikqfnkp83n9HsYLPXz5pV5aIMyO7XvgMZasZHeD0B7U+l3kBgkiqE3+iA0yuZx7Liodej1xM1ShR/aZtn/kvOK6+pN+/OcQxMFUQi7QOmXLnkzqd3Ea4Xpg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c0f3455-dd29-4cec-0db1-08d7c15b73b5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2020 23:18:02.6842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Boebi7cIUMUCBzh6PQN5gkQOcS979RSc23HO8VKVLllyjpXoY7bsuoH308Qx5BkT/p77hS2ddYIz39UIg5yNQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Hense <sebastian.hense1@ibm.com>

The mask value is provided as 64 bit and has to be casted in
either 32 or 16 bit. On big endian systems the wrong half was
casted which resulted in an all zero mask.

Fixes: 2b64beba0251 ("net/mlx5e: Support header re-write of partial fields in TC pedit offload")
Signed-off-by: Sebastian Hense <sebastian.hense1@ibm.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 74091f72c9a8..ec5fc52bf572 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2476,10 +2476,11 @@ static int offload_pedit_fields(struct pedit_headers_action *hdrs,
 			continue;
 
 		if (f->field_bsize == 32) {
-			mask_be32 = *(__be32 *)&mask;
+			mask_be32 = (__be32)mask;
 			mask = (__force unsigned long)cpu_to_le32(be32_to_cpu(mask_be32));
 		} else if (f->field_bsize == 16) {
-			mask_be16 = *(__be16 *)&mask;
+			mask_be32 = (__be32)mask;
+			mask_be16 = *(__be16 *)&mask_be32;
 			mask = (__force unsigned long)cpu_to_le16(be16_to_cpu(mask_be16));
 		}
 
-- 
2.24.1

