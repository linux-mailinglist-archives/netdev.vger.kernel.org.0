Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BB91B7F4E
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 21:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgDXTqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 15:46:22 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:44128
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729389AbgDXTqV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 15:46:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+GBisU3Mbx7XyzolMcyzxqixl/D8rns3s3rd/lAyfAAWvSSbDgqOMkBNl5ROnVV/vfwzIsMrBw/Iat8iXyxURPI/Ooe+P3yfkAnvjjEVsz8oiBX8DoKuBnsstqbI5XmUzrjMeTTttHe3b82mAp2yxCdRcxSuA8oC8nnOSFwGCiC+LkpA3a0ryqPFMHc4HF7D0I7jnR3gkCg5jWGIf/ggBEphhp3x2jhi2OBATfIEJDj6Lfdv/o9RozWet7P/kYB7HXkf8cDMO3OqUIA6i9D32eARnIElHSh3GDdU4ZVEBHtApOrMvgRTfrvXDw2bnM5B955h7at8Pe5zfrXr0gL0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUSwSsZAFxCJJ3OMp1P/ZuH3miNIosZvgho+7sqr6ao=;
 b=nEn2qtLYfeeDYuM6TJfyscGpD59w+7fduyeNiofiblVqzW6fSEQI0CL3JMb3Qx7dwb/vCEt+Qdm4ItgYqgsQN4HlCqqTJyR3QuMfj9aOCe85dPouCafJelfQpBDVjXRR/HoiVRxVNttqXfXGHOXYSOL90j2nVVFXl6vFNoXNnjpPMVKCLYcBZtVNa+QDMBAMiOu6ept3cQQASUbjurjlgalU+B5Vgng/ZVzP1vIukgyOLgiN8VSGUcVG+Cg0VprRdOd/7wI81aalJq5hoxvvh3oLCjhSXn0jHTJyiYCxbHCrFRbpwXdWAaKqI4Sf8YBkqeoTzLM7K7ZQWC0xqNatkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUSwSsZAFxCJJ3OMp1P/ZuH3miNIosZvgho+7sqr6ao=;
 b=tURRT9TvL337NRrDw0zrEj/4RC5xKN9UbfWwqBjvglTQiSDit9qXKqPGqQO0u6ZbxD74wnIjsbYYIHkSUlw4KZ+U0sTE7BKbz0da6QAttcBlIwi7KbGjfZk6W/wvWz73d4nthhPzRjUQZjREU8LDr62qn6paP52VE7T+y/yDAOk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5072.eurprd05.prod.outlook.com (2603:10a6:803:61::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Fri, 24 Apr
 2020 19:45:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.020; Fri, 24 Apr 2020
 19:45:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH mlx5-next 8/9] net/mlx5: Add release all pages capability bit
Date:   Fri, 24 Apr 2020 12:45:09 -0700
Message-Id: <20200424194510.11221-9-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0016.namprd06.prod.outlook.com (2603:10b6:a03:d4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 19:45:56 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bfe163c1-f5ef-4202-bcd2-08d7e8881bde
X-MS-TrafficTypeDiagnostic: VI1PR05MB5072:|VI1PR05MB5072:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5072695ADCD757FD733198F4BED00@VI1PR05MB5072.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(6506007)(26005)(4744005)(2616005)(8936002)(8676002)(316002)(6636002)(36756003)(6666004)(66946007)(66556008)(52116002)(81156014)(478600001)(107886003)(66476007)(6512007)(956004)(5660300002)(110136005)(4326008)(1076003)(54906003)(16526019)(186003)(2906002)(6486002)(86362001)(450100002)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hUMSJ6EgfAyQVh2eDGUeejf4utLLQV/8cKiL8ZSqL99YG3dCI2+KzKUm4mpp8PyTQLnQQUAxznWaTO8Gp2pHNX9z/18qcJXmVx9Bh27u72ZNanqgRA6PAeCYJIZ7LgBlC+ZoFMn9fOwrC04v7al4laJNwNQnw8MDaRlssQEslessc5zCQ3+wYFxVDAJEeMfhYq5G0+3D8FAGsWmogElftqYXShnkY6kEaFqwJhWlcJJI4D8jncsWS0b7Mgyr9gVrYtuvRmR1MvaSE0MHqn8H35P2AUCpzpdvdA5J5+Bhl9Vl5+Qxg7GiTwdG1pTIVJ+xOlMZtBp+NmFAR+gT+lDRXKSoAXdWT2izb4ClOzpJYqL9WyZ8QYVAesyI0tmB0a6JF+K15H9IWdg4571PUQPCoqYPPXXfWeD5N9PLpn8ZRv9xNW2tx6fo4VbJKBv29w7PH7nlWM3Fzb52FOxyFi8nHOAF1qBv6uG+NbhO8/McqB35/B/0TwEtzLhDuM26BGdh
X-MS-Exchange-AntiSpam-MessageData: dpXIiMh/wfGEmM0HFHbDlyvFdBLB0Qc4bRlgF7kju1F8sN1/17XFrvT9n6ed6bU/5eMMFl72ZpiTFoqBN2E/3cYyESpY4p+7M4blLr3GHlpVhCoM8CLcgMJbpbO+noeMXjxpGo90mlz4o1iDg7LpEA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfe163c1-f5ef-4202-bcd2-08d7e8881bde
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 19:45:58.8546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CBzj60ts3rmUYQweLspM7Fl1GmhZWVD30OaRFVjAk/qmQcB9GF8+NSjlI6AiLUszrVB2ScGtKA8u2LaQHv8JyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Add a bit in HCA capabilities layout to indicate if release all pages is
supported.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 6a6bb5dc7916..fb243848132d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1244,7 +1244,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_130[0xa];
 	u8         log_max_ra_res_dc[0x6];
 
-	u8         reserved_at_140[0x9];
+	u8         reserved_at_140[0x6];
+	u8         release_all_pages[0x1];
+	u8         reserved_at_147[0x2];
 	u8         roce_accl[0x1];
 	u8         log_max_ra_req_qp[0x6];
 	u8         reserved_at_150[0xa];
-- 
2.25.3

