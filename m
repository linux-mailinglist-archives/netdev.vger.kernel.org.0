Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D8E1DF34B
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731304AbgEVXwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:52:16 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:35520
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731169AbgEVXwQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 19:52:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DYzqfxq0/GMtOGu9tPxcpDYTa0NqEKJlxbXU4ytuxNAq+bavMa339F7sevcPiD10wJywli4wN0JkcCiKLvkAXyCXpdu0HsCglfxDA0uhgdW3iNqf8T5WxRryZtwXQNmxeQjym5RXTlatIy8Fk4FvCMCus1Kp4H9W5EWj0Us243X/aHE36q62UIcL95ET9qoBfmsRUu2VJJ6Tqa4uhTnIkNzDFToGfkXwYW2+05l7MpoPAfCPeqGK3conMY2z305aI197Zk/Me7Lt4V/spOY0J5LmnApk2yBspxtih552W3o7n1PlPcvpe2RZzF0wi47ZKJU17rxlQUIzeZx+cKXzdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wUyathyvDWTb4GmP2irOuW9MJzdxOYxKJSAxa1sMj8=;
 b=enWCZK8l0je3NDXKXx200sh7LAe5HCbtZrpE4MP2voy1y4czF6h4cuxpCdM7rRXzV0EjnnQ1sx6fKOx8q07xiarObpf7+Ez6NnfhgL3ytPLWBD+fYtc0j9WXfiNhLgfqnRzjPzlmDzByW+sZQiTbRWQM8vgT8OegBoXNnBxxavH8uox082Yqx6tiTlmObEEkOUQ9td9LSJy64nWh5OVaylJW6+tyWKbdjAnyEeYmXZaV8lgzwvHQNlhFPeBB1f0lWtyML3gG7QG6yFJd0jOoJnGOdrK6QHcuWL9yw9bffw6jxODa9wSbJf4NtDE6ga7lQ47dOhHivIoVCLWsiWDDJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wUyathyvDWTb4GmP2irOuW9MJzdxOYxKJSAxa1sMj8=;
 b=hTKoRorIsxo8p6X/ZxGvrfHNJj9pVnj1O1XjhDiX6aokFopgply/F3rb39l7en7buNrOYkRpcHRZY1ikxXMjCKu0u0n/xnv5iPYx+LApChNl36Go5K5PoSHEKd+7bk3WU1LpHAat2pwD/RCQ4U9zcSfg6b2RqHDkzfcPfFLE0Ko=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4544.eurprd05.prod.outlook.com (2603:10a6:802:5e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Fri, 22 May
 2020 23:52:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Fri, 22 May 2020
 23:52:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/10] net/mlx5e: Use IS_ERR() to check and simplify code
Date:   Fri, 22 May 2020 16:51:39 -0700
Message-Id: <20200522235148.28987-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200522235148.28987-1-saeedm@mellanox.com>
References: <20200522235148.28987-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:a03:255::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR10CA0015.namprd10.prod.outlook.com (2603:10b6:a03:255::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Fri, 22 May 2020 23:52:09 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9de41bf3-e209-4fed-272f-08d7feab2511
X-MS-TrafficTypeDiagnostic: VI1PR05MB4544:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB45445079BD87E13F4BE7F3B5BEB40@VI1PR05MB4544.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:299;
X-Forefront-PRVS: 04111BAC64
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: flOOZ6y9YtLE8W5XZswZqec7f+ttHbTtz78HHNsbF7PH7hOMCyRYg3UKBLi8Lhu1+wDIaj8Aef0kCwyqjC1cthIqcjERNjyiR8dRNv0RC7kEG851l+xswuqSSxKYjZ6oxUArDbMCxMfLglXbokY8Fg5pBQtT8IdtbuCIxlhZCn28fagXALhny1qBB6PTXC1xxJoYVZNQHTWfBfpzGgEaHQZ95XVxvzAWpMlMHSeQWECv42GFc8O9yIc+Auh5PE0lKuPi/z31+tjBW3anpeSL51rAqxZhW2V7KIKjufztHSlNp+EkXIFdnDpJYlVUOfAxpWSDozXJJdQGP12OlOGB0ohAXzkLQJjl3IVU0MwRTQY1UDcMWqsscdfW/wPC5KtT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(66476007)(956004)(6506007)(66556008)(2616005)(66946007)(107886003)(6512007)(1076003)(16526019)(478600001)(186003)(52116002)(26005)(4326008)(6666004)(316002)(6486002)(86362001)(8676002)(54906003)(36756003)(8936002)(2906002)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tK5Qt/77Gl9PxGr2rF62BV2VKBuEEAl0e+JLn7l8EEgSEjHqVcNiA44NylmLsvIHmsayKZ4W/TmKxVW/9kPExTMXmI9VYDnBu4kA4AuvSXHWi4YnSqIX3JOIsjEL3vCcVm+qmNAP/J18935A0QWdApDBxZUDhpj9W9GWvfs/Ex3J1ycNbOTzZgvNLur+NAfpPmsdVY1a2PIvhDwiPdkUrguar114q+ki0BVM959/MT0YaxUTOwcChsAtGWmoIdr/H6aiXme0nflSIM22hf057iz0X38H2djHKtJOi4IdOkIDbNFr5EI6/RNMxjlSrRBLXmvHuYPV/RfoFl0A4YKq5RSK5+9h8IG2J3Xib6IPpseIllGaxZuASf7/gzfI7y5jGeOnSQubRL+csDgzk5kMKHy4HM/GgwxdPAzlA9QpDi0IySKq1HRzUfl/u/250jqXZhfEmgHcx+oj73uWYUpqCVxLLZ7wHhrJYV0wZjiw05E=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de41bf3-e209-4fed-272f-08d7feab2511
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2020 23:52:11.4616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: am/NJ3Dj8RDf4BEuDdX7giSw+Zi6ZNQzLZ5xN2onWyK8amff6FjzVISUxjIS9ArMtVqEvJALziyAazQzutsznQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4544
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>

Use IS_ERR() and PTR_ERR() instead of PTR_ERR_OR_ZERO() to
simplify code, avoid redundant judgements.

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index b45c3f46570b..9f50a1d3c5cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -96,9 +96,8 @@ static int mlx5e_route_lookup_ipv4(struct mlx5e_priv *priv,
 	}
 
 	rt = ip_route_output_key(dev_net(mirred_dev), fl4);
-	ret = PTR_ERR_OR_ZERO(rt);
-	if (ret)
-		return ret;
+	if (IS_ERR(rt))
+		return PTR_ERR(rt);
 
 	if (mlx5_lag_is_multipath(mdev) && rt->rt_gw_family != AF_INET) {
 		ip_rt_put(rt);
-- 
2.25.4

