Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41979443D0D
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 07:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhKCGYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 02:24:09 -0400
Received: from mail-eopbgr1320118.outbound.protection.outlook.com ([40.107.132.118]:32230
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229650AbhKCGYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 02:24:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLeX/2MyOPIhFJoV26xIxgroI/fz7yhOQqd8HwfL8uuyODUnq1Ja3oVzAou09dnB55QSHYaQJhJbFto17exRlu1aP+h7jzK+YMEgYCHUi/x/Massln4i0GX4z/jbB9sqhCCAtSUXu6p1cYUBU9Vtju8IKFMk16/v6sriPH2mes8uYJ7fXo98h2VEMyGgA+CL/vxUVjU1nP3HMVpSzFC5qwpEJu7kGTiB/WJnsT4GQQj67CUNu+6T9LHnfDMVnwdpACnUvQrMU+aavurcWVx0gWoh/4PXrT+OM9dhZQs2XpqgBm/35TZ89s/M96GY9FReQx36zlVuQwG6BFPAbWqvWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jLM95XMZRVBTa4HtP3lXE3FUi2yfec4PSOzTSeDh/mQ=;
 b=UypurM27SvZgU4OjDK4hgH5QabBHx32YmdYttzm0ONBj83RE8scDc+WkyfL0ww8Yv2TESZ1CqMfqpeqtQrDU5pNXmi7xYVwrXbqcIlsEsKzjlSLwLQNMKOvnuqJ7hHjaxuIgT/+3LUebJRe5RPc0DcOa8e4HQMVqVPPcThZ4J7jZ3Xkl3Qq4lwp0qJYMvVJi8ZB557sOFQ3+kqBYZjAIY/05fPeJ/z6OGXPED0h61MfebPIecpBLJ9Lc3+VW0t92C0Zo6DSLFqfF6/aMc2EHuiQTC9Ah99Y56aSw9zxZHJxNb2G7hNGaXW+TS5+1scF6CGGuRbO/X3TuB/vUIsBuHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLM95XMZRVBTa4HtP3lXE3FUi2yfec4PSOzTSeDh/mQ=;
 b=GTzBMZYSXRd3eRtG3VshWK+PBTxkDyLp6nhEAgOD7oMXE98OgcehUuKDHhMemzNWS7lndWUc9yTkUfInJqvLXhzG9uWoWifNNZmYnagxetFmmNtE2PlBZupfAEAxW5V0cMJjsxkhpaVE4xAjpWHmVhwHR+Ym4rGOf7+EJ/oHLRc=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by TYAPR06MB2413.apcprd06.prod.outlook.com (2603:1096:404:17::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Wed, 3 Nov
 2021 06:21:30 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::5e:78e1:eba3:7d0e]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::5e:78e1:eba3:7d0e%9]) with mapi id 15.20.4669.010; Wed, 3 Nov 2021
 06:21:29 +0000
From:   Yihao Han <hanyihao@vivo.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Yihao Han <hanyihao@vivo.com>
Subject: [PATCH] net/mlx5:using swap() instead of tmp variable
Date:   Tue,  2 Nov 2021 23:21:09 -0700
Message-Id: <20211103062111.3286-1-hanyihao@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0302CA0023.apcprd03.prod.outlook.com
 (2603:1096:3:2::33) To TYZPR06MB4173.apcprd06.prod.outlook.com
 (2603:1096:400:26::14)
MIME-Version: 1.0
Received: from ubuntu.localdomain (103.220.76.181) by SG2PR0302CA0023.apcprd03.prod.outlook.com (2603:1096:3:2::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.4 via Frontend Transport; Wed, 3 Nov 2021 06:21:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1024c525-1c69-4819-7fb1-08d99e922c6e
X-MS-TrafficTypeDiagnostic: TYAPR06MB2413:
X-Microsoft-Antispam-PRVS: <TYAPR06MB2413DAC16E5B7ED145D40BA8A28C9@TYAPR06MB2413.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gDUnXoqb8J+bmb2XDp36aCVcQShXkDoIdiI/9M64lgnAk5jHIuSPXpsjrFVAm1/oIOSOFDeY1N5oRsqHukShSm+Bkp2kLMUMK6cFdPThJT8cTebnoGLxTwytY5Jv008goIFn9Ff0RVoQ1hI6WA2LOkLsoAn2CUI6IvHhCq5/arODGi3ne52f8wkRJR6UiwrCTveSch2Uf9DCsbo8lPeR5sYAkPbYYHLsyBHE0NcXtZU19zo9/SA8QLSfYDdlIrWwDc6JXhQfGEo2VlAKUhCAWgQRBvyM6KJDy9u9troxpaj/oRFgjf/F47i6G7Tx0YqEF7Nmeg3Os71sEV2fMav2Ef53nnioxyFHYB386ufEX0i7EUPQ0+r+V3sn8Kg6GgFXeSOHUXiEnWKUB2DdNJ5fsYQofEZ5z7zFRq+noULthBb16H8XsJDL9XoMNP57cBBk05QZhNetyLau4euH9EYXUNZPib/sMLtAoNs/OHs2m/hYv3dVNsWyPCvU3OXYvaGsObEmzlT72RgW0gwj9eOHAiMdiF6rTNufQQ080N2o5W2mKlesDMny0Wn66EYjoTHNZAAqU6dV9JBVkbmFqksSLdLk7JXc7rzXpAWiHzVR+fj5dx31cTvFDE21F+Cvf5L3FnTM9FMpdcdwNaEoa82ShGIb/HPMUy5BlRNR3rUG7zFwCwfycIdb5jqb4kZy9yo1GEzmWUmO7PCXGNqX3FRjGt7UrxFjrNkjJ9OIALMcnqo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(38100700002)(38350700002)(6512007)(83380400001)(508600001)(5660300002)(921005)(52116002)(8936002)(8676002)(4326008)(956004)(1076003)(6486002)(66556008)(107886003)(66946007)(186003)(110136005)(86362001)(66476007)(6666004)(316002)(6506007)(36756003)(26005)(2906002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pqyBGzhgpMzmIsZo4JN6ycG/Zro7K7XPADbqP3JyyUxOOJIWI5bohMFXgzHk?=
 =?us-ascii?Q?84liILD3PzT2mi5qgMTlbvY5O9ADcf6gVQxdK/ngFc9ivr5vN7sN8martSym?=
 =?us-ascii?Q?9GM1gaB5zas7fOdUHuF0ZYlJTlWlFnDgvq2hzQplVbPIbOWBsVE+xOwNykEX?=
 =?us-ascii?Q?TgXAK+AbLzVPby6NB2mXfflVscJpyBzqq657HRmvWiijbt2TpTDdsaq+RlzV?=
 =?us-ascii?Q?9TPzn7mhnbvvJ3tvbA8uH21UG8HuenZ5L4tcoikPePQVtX8AoOop1egDIv64?=
 =?us-ascii?Q?3cfTr4J1dgbOvvbH4lnKUS4w3a7PkMqUjlbptQ+TNn25JqposB6Oe7u+Fsko?=
 =?us-ascii?Q?66rhwTVtdJ1al1hLsjWP0tFcLRtuqR6AyuI9L8SKynPJu3tLq2SauMJTOUpA?=
 =?us-ascii?Q?yzPbD5igxb9RunfbNNvC4i8rpkQwlPljq6tGuh+8aHLYxM3D7pZ6ysinkgiS?=
 =?us-ascii?Q?0ZC+P8WsDMeU9YDBYjGGXN65a9zkQzChzCajJwK/pFMRDzYg3RmqXzD3LeCH?=
 =?us-ascii?Q?qVWw79vCuf4xpylL0R7vrg9itwQ23kGcoaMFOF8SlOqFbRnBoEFe9jyFalP3?=
 =?us-ascii?Q?5UZxQtVtlNE3+3l+9UjtSY9J/XuXz4bjmDhJW2HS8PWv5E7TNeyMawSJscou?=
 =?us-ascii?Q?fMeB4tj3hTbAeUGppVqG8ycuwfVo9L4Vxd+KXK0CX68h+CgL6CNQAM1uK6y2?=
 =?us-ascii?Q?d96M0h0n8VaYABdBGy/46d6+Ug24PL005Uycsory3G7wGjWdb9Bs8QUhlKZk?=
 =?us-ascii?Q?h0CEX4fdQmvTT4M2LpxbedfOSVTYrxGHeX5dAv6Dvii3bHxMq71fPuRdIx/O?=
 =?us-ascii?Q?4w7B9ZQqKbtc36yrnCLDvRt9fdBpRjK7ZiUknqU0pF1y7NQ4vrh3awiv2J4Y?=
 =?us-ascii?Q?hF3xuZ2h3GTq+OPLSIUjMrf0Y8PutFa6MMu1elmjTY8SkD4XNnCVPk/TcgjE?=
 =?us-ascii?Q?N+L/tTpIFAzXAVeqvTvV6Q56HmhlODjkPcQgC0jmqyFfvnqHoV/X/1nJ7nSQ?=
 =?us-ascii?Q?Ycf/h1VGNLMJOg8lflVyrPnnADnuSK9p/dap3hCqH51ygfe25+thWABQYx9K?=
 =?us-ascii?Q?cpfrS6n9+HzYilISL3c9YDlNGLoX+IWlHAw019pyTw1GY1b6hTN7Wk7skYeK?=
 =?us-ascii?Q?P1hg44V+be7+UPysjWkz5i2k2dw34hHsZco9j2ZHx2DSXZrahMAhBiZySqXz?=
 =?us-ascii?Q?9gCtKbdq7ocP1rHk7IABYRB3xwMNVVxVWR0U6Lh4reEIkZQzke2UOi3zlzKK?=
 =?us-ascii?Q?YubzfoKBp8su8zwHhGQc1M3PV0Dtb2RUj6sXpKLzspDltQSVORXlnofj5R8u?=
 =?us-ascii?Q?+/iLpXAPzPHDb9aRAfUS+nLKHGDS1Rb92OmGZo4n/oe64JZCI9SYUaz/Koi/?=
 =?us-ascii?Q?4usUQ65+Er14i92rjtJnbLs9UJ/978TdDSeTlb0g4y23BKB1GQwtLml4urSF?=
 =?us-ascii?Q?XagfE+wtysdah0BbNSZPfJggBePLj3Nr6bYXAsTc3fIo4/GjvzJpppdlEI/B?=
 =?us-ascii?Q?JbUjmLZ/M8oSKZ1cpSupL4AOat2hFN2HsQiyf8PMnac7DtRNPVx4AH/zAodf?=
 =?us-ascii?Q?kdMjhceUYHJURj9X/4jHiG4vCXHzlQdxD+quVIEpfYEFY/YeJIDPpzyu53AT?=
 =?us-ascii?Q?wfI8sMvgswN3s1RTNnHb+nY=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1024c525-1c69-4819-7fb1-08d99e922c6e
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 06:21:29.9081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YVmyUE4kBpkqvL6LQO34IhjgqOa+/SmkozX0X+diGCvNqgpAzJCufPuEFlJOsqFaKzQAPhsrvrKK3T43XhBU+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR06MB2413
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

swap() was used instead of the tmp variable to swap values

Signed-off-by: Yihao Han <hanyihao@vivo.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 740cd6f088b8..d4b4f32603f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -907,12 +907,9 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 	struct mlx5_ct_tuple rev_tuple = entry->tuple;
 	struct mlx5_ct_counter *shared_counter;
 	struct mlx5_ct_entry *rev_entry;
-	__be16 tmp_port;
 
 	/* get the reversed tuple */
-	tmp_port = rev_tuple.port.src;
-	rev_tuple.port.src = rev_tuple.port.dst;
-	rev_tuple.port.dst = tmp_port;
+	swap(rev_tuple.port.src, rev_tuple.port.dst);
 
 	if (rev_tuple.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
 		__be32 tmp_addr = rev_tuple.ip.src_v4;
-- 
2.17.1

