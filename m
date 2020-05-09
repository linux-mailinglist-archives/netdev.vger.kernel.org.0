Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256AD1CBF04
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 10:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgEII3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 04:29:38 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:60182
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726214AbgEII3h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 04:29:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AG4xz69rWCh5mpM7PSOLWlxrZvwQkDhxxHbipey8hS9vKTq0W6BZd43Mb2461cWCdUQjX5sqMFCgq4qjqWmCfFJrpI9zA7nq/PLYpx48Fed5d3QJxNiqC/rjgj1lZQntX5CQC3IA+CZA0fK3RZhR5JZNTAeELiwVIuc3V7yWgtM3J+wtew7O3EwTkMCUdci6aGw70i/XDKwnFa72r1bUzJBjnfPXa0Q1Y6TAh6nVTt9X+B6+81waTTfQvrcoe9yw6EDM0m3qQst4RqNOChVUsCQrSdkDjvhhsBOpdrEbOo4plM5fyT1xX49KtoHDGmCZvrE9saoYWqfKnpHYTF/b+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pX1t1sczhIbcXrJKRt6/wa+ZauKrhKUojjAxC+fveZA=;
 b=brRIJWRZ0/MKONQSStsS0nSOPbtVt5YE82iYgNH1OJrhUGkbXGEM+B1l9KKtCLttogLT8R4GDUhvBuhGSuUXVEHmeZSqY1ZFg1yMvcC+RI1Y8sD/bJFFjthaMmoDnFSb1Gc8DTgo8D/3el04y9RvxeOA/knsey4XFcBkvr76gTZYEO9R/BZIp16eT1PkATFobYKEfkI9DGxZ77SKeeShKh6NA46s7LDKWkRZ6CsEH4nUfXQuseOIwNNdphdSrd01LWRFvqxqvKL/okX8lItMJ8Ga1yD9mCAuuxEMcZ+xTTU8V9wWU/TY7CM0Evz64NpUEzJE0nPAO1Xm1VkT7Zp1xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pX1t1sczhIbcXrJKRt6/wa+ZauKrhKUojjAxC+fveZA=;
 b=Kwhft7/AGFm0sos7tllT88eZti7X1Uj21hPQSfk9QWRBJiwvhxWP5J/bBcsds31vQCOF7/pLgpWvdluefRWWga+6PPgg2llRPITfPcFqH+0q9Byc6HbigxZ4gt7idu+x8vNCxDiFW8ExGwtOgVg3zbcMBEA2dB83dctpm9fDDQI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4813.eurprd05.prod.outlook.com (2603:10a6:803:52::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Sat, 9 May
 2020 08:29:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 08:29:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Raed Salem <raeds@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/13] net/mlx5e: Update UDP fields of the SKB for GSO first
Date:   Sat,  9 May 2020 01:28:49 -0700
Message-Id: <20200509082856.97337-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200509082856.97337-1-saeedm@mellanox.com>
References: <20200509082856.97337-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::24) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0011.namprd07.prod.outlook.com (2603:10b6:a02:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Sat, 9 May 2020 08:29:26 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4c9eb06f-fda3-44a7-9471-08d7f3f316c1
X-MS-TrafficTypeDiagnostic: VI1PR05MB4813:|VI1PR05MB4813:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4813AC210E9858BD916F05C7BEA30@VI1PR05MB4813.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LS94LmzNsnwCCOe517Xt2QOcb9BBx/daBUn3mrVnWD7p/kBkBQQ5rpF/ljnCvRX9+sO8g2xHtCLm/2c4UJGmmiKfk61dZVrNMu9uKDGafmv9/2ze0rjkovaWCkpW0StkfueMNlRpI2oTO6dijIwAOtY0ECXCn1MWnKgChG9/8x/w90q9yHAjIwcDp3UF6cRtcUR/Y0hY9ygmHZQxWttFY0HTPAz2FlJYN1hFabW1nlwL6eWyR3vyunEyryIDLbIy0tgyP/1Ty4cHCZDVdhlnf0AHfig4fMpv4Qv+d0RVN7dOK/31z7CMQaVh6GjYBdcc/XGOGU6U8VODO4hL5XJWYk3LAs8Nn0jFjrcH3YbYCypRWUr1mWRO+IKoHjG9yL2mn1c/2lq0TNAHThnvdI5VyzvpUEem14lYmEiFvuiTN5rEAs4vMSSNcFXSghklpQ2VDgRTfqsTDdgZt558SZGb11aMPVuSXgJa010eIgt67eP+vhcQLyWHq3JMKxYTPyLr6ebuFm3sf6h01YvEcFTkym4LzD5P8W4fDy/dUv2eAsnEvkth67V0FyHnx1YYqKwB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(33430700001)(107886003)(66946007)(316002)(2906002)(16526019)(8676002)(956004)(54906003)(66476007)(5660300002)(186003)(478600001)(52116002)(86362001)(4326008)(6512007)(6506007)(2616005)(6666004)(26005)(15650500001)(33440700001)(66556008)(36756003)(1076003)(6486002)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dSD3n744oAuwen/joH+ON2yEYEelQdgtpk/9x7PiAhe61szT6aj3A6QwQ8opJ5Ejzo7cPVjHq2Hs8kvOdvKhbPSXu7VxUjZoSGkYgunq2Dw/raSUDzR+7acxZfXRJU+R6Jo4t7m4hLu010vMlz0r7WiYA+YTJs9puWK34PmCB4vt2nsE2onlrpaqhaHfJRfJ79NYQnTm7hPrDDiYDuctd7Y6SMpZfSWkuCfzO3L7KUGChJ5sBYqFkrkqdKkPiUT+6nLv7FrGgC2G2GW+nRcpCSMnru8Z7DdX4rjeOnikjn9qUOKPCAp7aohKdVq0apmyid75r9exaJr7PySMH5n6sF7c5WsTCy/1W9U8bCRngG/UyqC1IgKiY2zWaKXMnTFEzN0Mhm1GdlK3JepLbfLJTbafqoEs0SHB1Ml/BnyMEwVL62Pi0JjOci7DFLwzGrcodK83D6NuHFjq6Zn2AWL+6AH9DOjbcKnV8G542hXw7nA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c9eb06f-fda3-44a7-9471-08d7f3f316c1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 08:29:28.2251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: quQWH56MePmOTsZ6XKEPezThymk97qwDHkev8uaegw9IWcubBxJloK/XDKaIIMMiDoM0xYaWCHPgkiHo/IhUXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

mlx5e_udp_gso_handle_tx_skb updates the length field in the UDP header
in case of GSO. It doesn't interfere with other offloads, so do it first
to simplify further restructuring of the code. This way we'll make all
independent modifications to the SKB before starting to work with WQEs.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h   | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 66bfab021d6b..d286fb09955c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -110,7 +110,12 @@ static inline bool mlx5e_accel_handle_tx(struct sk_buff *skb,
 {
 #ifdef CONFIG_MLX5_EN_TLS
 	u32 tls_tisn = 0;
+#endif
+
+	if (skb_is_gso(skb) && skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
+		mlx5e_udp_gso_handle_tx_skb(skb);
 
+#ifdef CONFIG_MLX5_EN_TLS
 	if (test_bit(MLX5E_SQ_STATE_TLS, &sq->state)) {
 		/* May send SKBs and WQEs. */
 		if (unlikely(!mlx5e_tls_handle_tx_skb(dev, sq, skb, &tls_tisn)))
@@ -130,9 +135,6 @@ static inline bool mlx5e_accel_handle_tx(struct sk_buff *skb,
 	}
 #endif
 
-	if (skb_is_gso(skb) && skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
-		mlx5e_udp_gso_handle_tx_skb(skb);
-
 	return true;
 }
 
-- 
2.25.4

