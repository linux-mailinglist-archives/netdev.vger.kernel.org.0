Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0492154D9D
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 21:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgBFU5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 15:57:48 -0500
Received: from mail-eopbgr60056.outbound.protection.outlook.com ([40.107.6.56]:22890
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727842AbgBFU5r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 15:57:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KjukJ/uad12QtlWBmVIyovPe2F35POrF3czyokpUiTqWEhh6e2xHiCd3OksJxOeehxuWU/N75GZs+kA/NMP/XdpdlOth/aOkBfPHd6SyUu2jtOe74Pjq3jHv5vFIZ5aDDv+lRXfce5cDhT7mQNf8xt04E51oOODcHWJFm9tWHC2u+QX3vSC/RfPZT4B9XWZFEaFx+lusSmrOkdfUFqOR7qid9tHbJLHhRhT+RzwSOPhMJ4cu6w9gvFKko9bQ8Ae8T9kMdXxVhRVCoDNH76EaS9jtHG+TQsb8RlS6AzRTCwXLb/TS8Cga9gTB0jwc11VK9Fq5i9DzIc2cgLNv3No0vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BezbYKIh+Uf9sMnpJDWK+EoKiuolNirkmYuBvRdm/9k=;
 b=EE67N6+wfweA8Q2XOXikdlhADGKk4JNyEJVT1WFXpUEZstNuyZzQ1zADihsiZBo0E1jeMH0tJmCixPcg9XldcVGrFSES7JigThFvnX4JBVYpjvB/0EjpGeWFBX2H0hSPvmrN0LsbcEI62waofrELOZCFKGUbWkWlDtE7hl2uZ+T2zrb9p+q2Gte1cTgAgi3uoDEx5vWN0PxUm5q9rbH4YvA3tRRh3tjjat3XbxIk2hlcKukzldxYJ9qjCjR7AEmlKBW96dTMPJExzFU6kssnautsdUmX6JSipnABy1ULaA0Pm2pceE3EIQPQoA1a9RzZo5aJeKSPVEHrFnJafGM7UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BezbYKIh+Uf9sMnpJDWK+EoKiuolNirkmYuBvRdm/9k=;
 b=EVpOv+3xJKhQ7TlHvFV+Yw4tNlxH28ziSIfNA1HRmRllDvo8+pNQDRXZZlsRDiOmPSb6AIXu34+DsKMiiyx1svHNjkfM4JoaZtOu/jiLKVxKIVNtksYypAgB5AW4OR8pIM3534XUX7/zzMqVlzaMHRlF0mKbA29qo/SlsIRXSJk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3280.eurprd05.prod.outlook.com (10.175.243.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Thu, 6 Feb 2020 20:57:43 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.024; Thu, 6 Feb 2020
 20:57:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/5] net/mlx5: IPsec, fix memory leak at mlx5_fpga_ipsec_delete_sa_ctx
Date:   Thu,  6 Feb 2020 12:57:08 -0800
Message-Id: <20200206205710.26861-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200206205710.26861-1-saeedm@mellanox.com>
References: <20200206205710.26861-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0005.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BY5PR20CA0005.namprd20.prod.outlook.com (2603:10b6:a03:1f4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Thu, 6 Feb 2020 20:57:41 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2ddd531e-e563-4a79-2287-08d7ab4735b4
X-MS-TrafficTypeDiagnostic: VI1PR05MB3280:|VI1PR05MB3280:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB32803A092970A6144FEEC496BE1D0@VI1PR05MB3280.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-Forefront-PRVS: 0305463112
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(199004)(189003)(86362001)(4326008)(6512007)(107886003)(26005)(5660300002)(16526019)(186003)(6506007)(8676002)(81156014)(6916009)(81166006)(8936002)(2906002)(478600001)(36756003)(52116002)(6486002)(316002)(54906003)(1076003)(6666004)(956004)(66476007)(2616005)(66556008)(66946007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3280;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0PZr44aI+F+0G/DhniIuDULtwhmVrON9adnPQI2xLBM1C/B84rv/udTOvR6/j+JjgrXK9wNnyh38nYN+Fk+jeCyQRq9FaU6vd4uE/vcrf1KWwntCT93gTq/BAiDIiLO2w+MHspmtP1TtaBCmYvnEdTQnwOK9VzFNOZNXQQ315gD1JjskdvfrOCMRPBEZzluwji+EgtCFcsWlYuvgGjGiWIupw5eU5hTxmPzoOJbHCH2rAIMO3J0Vex7a/Zkm41RVAmX2geUgajkpQfhMTIGChT92Rrmy8Bovds4romHsDp6NCXwMJDXgqiO0GWkzzdqLz43jQPNuVYiMJ/GjOOQoet4GmN0yKFQTEuP+5MjYnttfkGqyMVwzLeYDzdiNuZPN+yx1g/OgaDgdEBrR59eL5Ngcs9Ad/rcUbXkQcBuKA4YGPgFche7PAUjoVrTc/Tm24+1m9POZmzUJ7qg7g2esfq7KwyDFv8nuFhDiNhCdiS7zWy+WVvDyNljY+c5sBFqwcPSiqGj/mUfKgmy3XasmjXyD/Yqim1/tiGp9mlgZZ5U=
X-MS-Exchange-AntiSpam-MessageData: SVoMzOlXSMaXi+696vyfruw/FQJUBzn10H5xgjfEa5ZyOdntgxa0EKriAGYrNhqLSEgt9uwsz9nbJw6ar85PZFj/DC97vTBW19WanxxGnsvuwSgZh84mZycU2RJ5Di/U8gEJsA4TK9KyYzzjqMipag==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ddd531e-e563-4a79-2287-08d7ab4735b4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2020 20:57:43.1897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nXInLUIp/NEqp2i13VB5QZIlOePJTQPzOUrpRsqepr2WHWDEd7V5D+fNg0JB9I2cFjHt+wdShg/7Hm4K/kozVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3280
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

SA context is allocated at mlx5_fpga_ipsec_create_sa_ctx,
however the counterpart mlx5_fpga_ipsec_delete_sa_ctx function
nullifies sa_ctx pointer without freeing the memory allocated,
hence the memory leak.

Fix by free SA context when the SA is released.

Fixes: d6c4f0298cec ("net/mlx5: Refactor accel IPSec code")
Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index 4ed4d4d8e073..4c61d25d2e88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -850,6 +850,7 @@ void mlx5_fpga_ipsec_delete_sa_ctx(void *context)
 	mutex_lock(&fpga_xfrm->lock);
 	if (!--fpga_xfrm->num_rules) {
 		mlx5_fpga_ipsec_release_sa_ctx(fpga_xfrm->sa_ctx);
+		kfree(fpga_xfrm->sa_ctx);
 		fpga_xfrm->sa_ctx = NULL;
 	}
 	mutex_unlock(&fpga_xfrm->lock);
-- 
2.24.1

