Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0834F1B7F4C
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 21:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbgDXTqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 15:46:19 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:44128
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729175AbgDXTqS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 15:46:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPiT8/F+1rKJRsZQRHCV/YhpEGb259CYkJME03ZssBCb/0mHJA/e6/q/COQe1yia+mz+KNyHYVIlUI5Qb7w3HdUAux/Gc3xpsweejUTrDDToOuavQ7Z86/Q6Lo8Y+B3u5SBMzwmOaqgixul8B9hvIns6XKtC0qtto7mKw1lW6wCX2hcO9bRAyijvJ32gpTYcOfksmkZYaJZei3ADab8xqVafM3sKHIgEPs5w70tnLoSRdeVt/f6i+MnkM8NSvC4dHxRGsgZfb+MJg6TTunv4ZTzTFJyyr8FxFybCDc3QOaPQXkWGKCMF7BaCBe4TI6IuAVspYfRyiZ088sgPuLx3Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7jKkUf/RlJCXygmbiWGLer9G0lC9xWnrYBt0AtALsw=;
 b=kSj1PK/uF8DbvFOVgrD4aUwNJEloqdcbWJYM0S82aNJxsnur4Oudu5X1VEFzGf5ndxshaITwwQ/Frv5NlqlkGDCbbgKVP1n/GydvRkHHzgT/ttJcC0qUnQdkcQQplI6wYqvYWRUCs82q5+cDWptEtWmz6Px434rDFvC+LTzI2O+GbpsrXRjS2hZdX0kCtnoNjbalIh6MF3uTKaP1YyUuh5nmwmG6y9w2NrmhZkJOhZWAcck0Pigd8ipeaG8HA7oqdk5riagvatPyeXSn8pSoNPn/meoGlXU3d/eKEz9qPKFqURCiWxatV0fXQxXBG3yvz6jfU3BwVwmPaNqJhjoxbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7jKkUf/RlJCXygmbiWGLer9G0lC9xWnrYBt0AtALsw=;
 b=LbyBS4hDgK22ON4bGmBZoMh4wRfOjE8KkGvpD1D2J4uzfuyNAqlD9WupynONW6m7yoOuUvwhk6b9jlHk+bSBTW7dYW8q3giCiL2Z0KkqvjSjy6+05cPe9wv6uyPwtpjOlkhQR4I3giglKDKdS0Py/etttCjuIGUcnb43k2vuNxE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5072.eurprd05.prod.outlook.com (2603:10a6:803:61::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Fri, 24 Apr
 2020 19:46:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.020; Fri, 24 Apr 2020
 19:46:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Raed Salem <raeds@mellanox.com>
Subject: [PATCH mlx5-next 9/9] net/mlx5: TX WQE Add trailer insertion field
Date:   Fri, 24 Apr 2020 12:45:10 -0700
Message-Id: <20200424194510.11221-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200424194510.11221-1-saeedm@mellanox.com>
References: <20200424194510.11221-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0016.namprd06.prod.outlook.com (2603:10b6:a03:d4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 19:46:00 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 71d58aa9-c12b-485a-6b83-08d7e8881dfc
X-MS-TrafficTypeDiagnostic: VI1PR05MB5072:|VI1PR05MB5072:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5072DF2D6FD14BAD58F4AB8EBED00@VI1PR05MB5072.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(6506007)(26005)(2616005)(8936002)(8676002)(316002)(6636002)(36756003)(6666004)(66946007)(66556008)(52116002)(81156014)(478600001)(107886003)(66476007)(6512007)(956004)(5660300002)(110136005)(4326008)(1076003)(16526019)(186003)(2906002)(6486002)(86362001)(450100002)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ZbZZs9qjJDxsWsPKphApImbbn6qW+CIpapVfDPrLG4qGKUrf6UBymt4MsYURzDP5lf8CNcGJsyyT92nJCaAiLaKPzrYUkb8JClw/FRoyS/TSFT8zD1x5vMG3erusPWurN8o2QKpq/PtlkHbcjSEvofWX6u30Ypa83I0kAlFZfDfLrPojf40ZuM9+mdUcFYCCQh3GOoojars1v3dL4GHznTh3Csg4qmUpv4+ZlU+v/9IlCYPALfwodvn0c3tNiRY75SBn3lDyv0nrgigj8Dgh91wumEN8iaV6Q5xENg1Y5M3rwKuHUuYVSAmbs1iLsl22mQX2TQz2jB8NBCX5ZxQMxKyw0bL8iHEhyafvCbwRQNKAQayO+ELuOAGSpeKfY6pUHCIkFr4NJYIzb7pXG/TzvoRymXg3CFtY/ObBiW14qBy+ZHn1GU2T9uXcZa1ShGVFCbHayNHlq6TbOPn9FM7J12mGCR7Ek9G2jXHbNyWLbM/eHUfa3a5VwJ1bAO/wHwc
X-MS-Exchange-AntiSpam-MessageData: Z9u+wA+7ikaukv+nkQgPnpPClBX7N1DAHoTSixfNSFh/dZw5Psz2Uf4lcS2sFXZ31oDlIliMeSjvpW4JONa/7AlLpSG9f+T5tt1Fb09RPSOzc4HdUVtbM92df1Xuqs6N9476/cj+tGDmvLCng6Vm2Q==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71d58aa9-c12b-485a-6b83-08d7e8881dfc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 19:46:02.2456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: USWPqcq1srthx4ueU11hzNqmVJsoEUf4LJg2oH04Yfp8Szvx8XOL9Q5SnNBpnGRc9ibFriB6JmPCHCF0P8uUvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

Add new TX WQE field for Connect-X6DX trailer insertion support,
when set, the HW adds a trailer to the packet, the WQE trailer
association flags are used to set to HW the header which the
trailer belongs.

Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/qp.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index ef127a156a62..f23eb18526fe 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -229,6 +229,11 @@ enum {
 
 enum {
 	MLX5_ETH_WQE_SVLAN              = 1 << 0,
+	MLX5_ETH_WQE_TRAILER_HDR_OUTER_IP_ASSOC = 1 << 26,
+	MLX5_ETH_WQE_TRAILER_HDR_OUTER_L4_ASSOC = 1 << 27,
+	MLX5_ETH_WQE_TRAILER_HDR_INNER_IP_ASSOC = 3 << 26,
+	MLX5_ETH_WQE_TRAILER_HDR_INNER_L4_ASSOC = 1 << 28,
+	MLX5_ETH_WQE_INSERT_TRAILER     = 1 << 30,
 	MLX5_ETH_WQE_INSERT_VLAN        = 1 << 15,
 };
 
@@ -257,6 +262,7 @@ struct mlx5_wqe_eth_seg {
 			__be16 type;
 			__be16 vlan_tci;
 		} insert;
+		__be32 trailer;
 	};
 };
 
-- 
2.25.3

