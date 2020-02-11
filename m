Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F03B159C4F
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 23:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbgBKWgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 17:36:08 -0500
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:38926
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727569AbgBKWgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 17:36:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQdkKLHuSLjyxEA5xV0r3iOLpK6adeAeV3b71B1hD7K/ROx6hT/ErmlZOM7t6ljqH1vSEvsqj9EWu6KLh9oLtJkTsdR6YfrtxlYL5vgtVUoNcpZopEK43wexmS6x1yHEcrdxGmhRxwa92HtuXENtX1F29u1oY/3ZAtoq/FSNlBHjTeaypdQVV7O5GwTpw2a78BDR4GSe4oGKdmH6gXgw5ncCOJ9q6jXSuOXqBBcOTSLfZso2kE/mBp6BrHyMxVICdR/xL/yvHgDV7YF2BJO266h+GPRALCkVZSyUHY/OCtqaZaMZ4w/K8SGWY69owgceEGlh61S9NSI45w1Fchu32Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XrJY2NtQbc2oP7X/DZ/votMyKHq6KU+k3sQwjKBzHB4=;
 b=g8dttEsCWPhOF3WygDwN+OJB0Hs8chbhUcUmvYMd2VlayGIDtxOZVDq34TEaX8ruZ3zlGH1v0zNDA2nlso3Vlfnx8aN2CHU4ioG89LUUmiyrPnpL//3lY1j+OCZbjv43JkMvqzso9Gc7vTgSzyKIbYTk0Q2xbmEvY/hiTd8RrZyNLz7QdPwLq6SKS4hx14Gt0wSWPyL9VVFJgY4F8uCwT9hhz4bjNsotjwqoAp6JhsKtWS3Y8RYn20woIpN0JRMeyI/q/hhxwS5jc1njiN37pa7HDkCo4cQuZzonkPX32FF1H4ubPP0JSavqVJPn5r8rhdbXbaRU75GqdtMgs7ELDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XrJY2NtQbc2oP7X/DZ/votMyKHq6KU+k3sQwjKBzHB4=;
 b=Q8JL1wkASmyfZAxoHZU8zMTjupNW0WNf//IuFDby2LAKWDYjIUbFY6p+XYEg6xdkY9NQ5joQ7A55cdgExRsGyDZeJqRKNIyYTPNYKfIDJTmp1IX1W9S6pTXqjO/XKHDmGkt2enxUMJdwqIKJTily5n08NFftumfQ+TomWBccNkk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4383.eurprd05.prod.outlook.com (52.133.14.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Tue, 11 Feb 2020 22:35:53 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 22:35:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 08/13] net/mlx5e: Enforce setting of a single FEC mode
Date:   Tue, 11 Feb 2020 14:32:49 -0800
Message-Id: <20200211223254.101641-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211223254.101641-1-saeedm@mellanox.com>
References: <20200211223254.101641-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Tue, 11 Feb 2020 22:35:51 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a35034d6-5abf-4535-3658-08d7af42c074
X-MS-TrafficTypeDiagnostic: VI1PR05MB4383:|VI1PR05MB4383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4383B4777B880424523DDA89BE180@VI1PR05MB4383.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(189003)(199004)(110136005)(36756003)(5660300002)(478600001)(81156014)(6512007)(54906003)(1076003)(8936002)(2616005)(8676002)(81166006)(956004)(2906002)(6506007)(316002)(4326008)(66476007)(66556008)(52116002)(107886003)(6486002)(86362001)(66946007)(16526019)(26005)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4383;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ausi5cHUGLdBesccxuKmroTb1kApQSX6l6jWXKWRUCAIB58+4Q3LI07USCRSVlvzkfDYKlIqoymrhb9fPMcxkGd9djspL2FrVlb7o0jEaz/hnaEmLRVPOtdDobA1Rx52rhIuY3zADAVAWclhbPOl7SqVhOZpEGaai0+ql814XjJLmHTepHKfEUz71gx0IWoMDo+RoNj+h4uES+uShMCnuV2wBxUDOnp6W1MNXOLjeqxEHjt3SiXFtZ2apVvTNK9L4umnTwFGifMUkvXRd3q+s5QQQfC+bEjOxBr1qWxQPWdY7g10MtAlL21JHBXxolEX61/czBHDQpeaED1wQoj7o3widsoinLrCBRdl5BQI9wFzf1mnarklc5myhB4MxiDAAsNjZ6zfuya/uWgKh8+wUWscyCVqA2R3QZeiKRyuGWSI7M4GS6E9Y0e+/iTpXq8w1q5fmXKGb9uia/6wJiZU59g1hIXQtX6CAJDR+MeTYbCCdcSeGpfOxdDx/yTVE1J82EycgMNqo1lx9/16O6zz1Wf8BTG/d2c9L6U+XtUjVKc=
X-MS-Exchange-AntiSpam-MessageData: OiFHEpaLEhkW5Lg5XiN+WOAVIiQyrcTQzCb2yRiLgThxCPVGmFQD7T19tUuX9IoH20sx4zXhVdlDUm3BLdwrdVQ0dBXPgsAdPYdkwaMpHsnSv3ddIUQwV+OwjYr22uX727B2LhRzOGXeISjmRZ7BIg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a35034d6-5abf-4535-3658-08d7af42c074
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2020 22:35:53.1716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R1Wc9Nl1djF9vyqX7dY7DXmSK01kmbJnA1A/BKSV+D9O/+FTqrDgZwQWFwYneXflwdkv9zECXwSUqtBPzdH7mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Ethtool command allow setting of several FEC modes in a single set
command. The driver can only set a single FEC mode at a time. With this
patch driver will reply not-supported on setting several FEC modes.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index d674cb679895..d1664ff1772b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1541,6 +1541,10 @@ static int mlx5e_set_fecparam(struct net_device *netdev,
 	int mode;
 	int err;
 
+	if (bitmap_weight((unsigned long *)&fecparam->fec,
+			  ETHTOOL_FEC_BASER_BIT + 1) > 1)
+		return -EOPNOTSUPP;
+
 	for (mode = 0; mode < ARRAY_SIZE(pplm_fec_2_ethtool); mode++) {
 		if (!(pplm_fec_2_ethtool[mode] & fecparam->fec))
 			continue;
-- 
2.24.1

