Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8F7917692F
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 01:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgCCAPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 19:15:49 -0500
Received: from mail-eopbgr140089.outbound.protection.outlook.com ([40.107.14.89]:56068
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726890AbgCCAPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 19:15:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RsRf+JKQFppjzPEbMhHYvGBUwBNiVHuhaFON4+f5/TW3k3FChSt5nucYocHxzbvRARuU1P4MczplJ/4WO++9f9PKwLpS7/7/6cB1HHNvq/7tFv4RBnWfVsazHo581oJaxsuvG5/YIX5IGRbtP3/ceG2FzVwjJJetI/fv9KTW5vwzmWFQTGKiLbgyOWpwgQ3+GSwPkrBk7nhtURxM5cYe3eEtacwSqvBHCQzLCOGUhvfKXHNCbyPtN+VTDQOioctAvBPrwHvnADpYoJAOZDSDC4rjfUpt9RGz4y8hJ9rPYulDK2CiD218oyizKXRNMGhHLSfpHDIsu074obcsYl8T7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2FK3WLnAJWcNwsVePy2Jd+1Ymd66Jq+CpORvGPZie6k=;
 b=k7pNqeylP+ysqkAno61+HN2hIL4PS9ZlLXXlOE4Ep13bkv8s4dsza07tQ3VQnLxLZdZWvyo9/MyFQD0gYwVaOla8VslT3q9WJ6eyLrRrLUTRhq8SuOUlDEbRBq7HqZLPBIY2JM281RMU9eJJxFu18dNgxaDunYj+gzhrYIOMSX3JwdaKm0xAOZcw2PUBKiRmgDFMo6b2djC3lo/qL7t35TorvJCFVRpRuJ773pe923DyDGmkF53qUMflPv34kN14N5Hwlx1kIwscXZeSxAIkvVCWTBZnKIxl2wT+Wmnn4YUEkYbczXY2JdRjD48+ZGh8k8lCabOjoqLWnRunCoaleQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2FK3WLnAJWcNwsVePy2Jd+1Ymd66Jq+CpORvGPZie6k=;
 b=YHJ/ciTb0bYcMs5nfS8M0ISBCUSazTrHIZw+DuXqdMekJyWL7DsDcA2EEmqqXjAG8BXox58wjQyxqCbIKhVjQZgnUA0P+SOy++S4pY0KrIsJ9vZe3NJpZDEDCRlXYzo6+O6OyR67pZQUPbj3fH/fVbT0A2amfvbqEpcoARphL2g=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3166.eurprd05.prod.outlook.com (10.170.237.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Tue, 3 Mar 2020 00:15:44 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 00:15:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Vu Pham <vuhuong@mellanox.com>
Subject: [PATCH mlx5-next 1/4] net/mlx5: Introduce egress acl forward-to-vport capability
Date:   Mon,  2 Mar 2020 16:15:19 -0800
Message-Id: <20200303001522.54067-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303001522.54067-1-saeedm@mellanox.com>
References: <20200303001522.54067-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:a03:100::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BYAPR08CA0018.namprd08.prod.outlook.com (2603:10b6:a03:100::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.19 via Frontend Transport; Tue, 3 Mar 2020 00:15:42 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 41cea2ff-3b55-47ae-20d5-08d7bf080388
X-MS-TrafficTypeDiagnostic: VI1PR05MB3166:|VI1PR05MB3166:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB316627D906777B8CB3412750BEE40@VI1PR05MB3166.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(189003)(199004)(110136005)(316002)(52116002)(6512007)(6506007)(8936002)(6666004)(6486002)(36756003)(86362001)(81156014)(81166006)(8676002)(1076003)(2616005)(16526019)(4326008)(450100002)(5660300002)(107886003)(2906002)(186003)(956004)(478600001)(26005)(66476007)(66946007)(66556008)(7049001)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3166;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F8LXJMFseNfvC1RGX4NzToVk0TgK8x3QaI/XjlczdpobsTXSnaZ2/vF+LAfjoOIeNklvTwjP5EkgbXLrlPPUGf+bsHHpHBCusPM3p5cvvGWpOPMQ/grbaPKfRXzNfGtameHDN/l8Y8dShVK/s7lbGCcKJK4w0wFpBNXI9qLB6hvNySSu53j3ftleaBt32zj2ne6Gei7omAHyfoJKGnlCaA5q+4mKnHnFXATi2txXI6HUFD65668kon9RRVSmwe6i7ARJAYf4j1+ZUx+AgxV7jAVT0/trsYgt/M7cab9AN4U0jImqWf3skesUwgAwzSsRvom5E1enTCwrMArYCwOV/Vo+dA8EWn3M9hwjA6As81/o2/h82eE8SHhf6O+c5L50tFu+iaTEuB9xLjM7FjQ3lDnYW/Y12frJ5/fFGJqE1mYS+OEWmyai5/pDGDi1fJ0QXsrDcTWY0fqqa28K5VfCy6aR6m7/7qs8EsvpqXAOT7qwD9TPhHPo5v2J1yDvZEnQo4YzLOmX/zIjzdSwGltVSKGJmfolFZV9nvOJsrsU4Nw=
X-MS-Exchange-AntiSpam-MessageData: Y0tecqGMiUZVK2h6CY9kRaabAv/44J2gBdqWiRv6cjhU71pqiXgfBve4J9stxyuo/nIA9XyxNuiDntlfwzlxoMS2sa+zVMwNprKlMOHrg6xUygok7us6dkBQh5wnm52UEpsTPV4ea2YhNhEeOi9ciA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41cea2ff-3b55-47ae-20d5-08d7bf080388
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 00:15:44.0748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gzV2kJzdOJvRPjDSrNhkSAqtJRI2K/7TGJiG08PiCNFbD0x5gxaYz9vuMQkl0cBPQdERxh+ZiiLneSUzUfRLIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Add HCA_CAP.egress_acl_forward_to_vport field to check whether HW
supports e-switch vport's egress acl to forward packets to other
e-switch vport or not.

By default E-Switch egress ACL forwards eswitch vports egress packets
to their corresponding NIC/VF vports.

With this cap enabled, the driver is allowed to alter this behavior
and forward packets to arbitrary NIC/VF vports with the following
limitations:

   a. Multiple processing paths are supported if all of the following
      conditions are met:
      - HCA_CAP.egress_acl_forward_to_vport is set ==1.
      - A destination of type Flow Table only appears once, as the
        last destination in the list.
      - Vport destination is supported if
        HCA_CAP.egress_acl_forward_to_vport==1. Vport must not be
        the Uplink.
   b. Flow_tag not supported.
   c. This table is only applicable after an FDB table is created.
   d. Push VLAN action is not supported.
   e. Pop VLAN action cannot be added concurrently to this table and
      FDB table.

This feature will be used during port failover in bonding scenario
where two VFs representors are bonded to handle failover egress traffic
(VM's ingress/receive traffic).

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ff8c9d527bb4..ea4a28ff5281 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -738,7 +738,7 @@ struct mlx5_ifc_flow_table_eswitch_cap_bits {
 	u8      flow_source[0x1];
 	u8      reserved_at_18[0x2];
 	u8      multi_fdb_encap[0x1];
-	u8      reserved_at_1b[0x1];
+	u8      egress_acl_forward_to_vport[0x1];
 	u8      fdb_multi_path_to_table[0x1];
 	u8      reserved_at_1d[0x3];
 
-- 
2.24.1

