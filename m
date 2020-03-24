Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C663A190CFA
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 13:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbgCXMC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 08:02:58 -0400
Received: from mail-eopbgr40067.outbound.protection.outlook.com ([40.107.4.67]:50566
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727238AbgCXMC5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 08:02:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6NPham7oIql9mztMzqVDpvvKDw8nIPZfSBC0pNiI0S2Uh1zqGn/oIVTBfIE0TMfZ8tjRax/A9MMZ7e8oWrQwfHkJ2AiNDjqFkQDnQ4mP1KPbW5XUQlB+rRKkYYSOGsr/MaLTEPLFaNOV0V2CTtHCFVD129qyigv/2NtJSTrtQvrRvSHiWpRZuFTO/VdLV+YBi6NQCtLQvljocETbKJ/d5DhvI9lA7T0nduoQk/bKrXf5WDQAhcOW4oceHVdzPrBkLe2UKmQSLmNDrD5K3Iy8eNhCX2tLqcUWO0ej4ObDbeLuIHjUt9h5EXiYN0z3PzKyY5nWQRXKmM76CFOGN/Q2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9Qf16cletMKQi0z9G9ino1/WLSXr4+RMGqBvr2rvbo=;
 b=DWi+NImFxZVy+e6k2X8w/sZbMTYbVH4RxOT2UBduSh4Xxp2LXw4bq0UIqJN6woCBbKreQl8iMAqf750i1Sb6P4qQJ6tHRuZfn28SQgl5k+G0pIE5I9wr4sg/f2pbrKZFv23YsDr9cJKBIOj/rcoOEOctZ1fuNHGzVM4OIRzHef8deQN9tA1CqlgLMshrqc8i935la2Az6DKzw2m0Q6RwGur3yV+Oc5irrtmrPBCzt4mjhI9FzaKPnXOLZ16axUm2/h1nsZ1HY8bzPrBDkRfrifMNpziWvH81up4zCoRpOjMrQNdkn9A5UlIh6feRjc1qVVHh6kIiTMlzxVswA9SU0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9Qf16cletMKQi0z9G9ino1/WLSXr4+RMGqBvr2rvbo=;
 b=Y1Xc1sz2aN7Vgln3IOiN8bqXA8TTlD9UmRD7T8Qe6eR+dk/HkLaoeqV/5v13Neexhiqf479BXGJu1Pp1L7WKTK9B+IBmkAaCYR9xN4XoIaelB5VO8I3Mw0XhilDB1OBvgoRLMnX3gjAcYijRlm1N/vc1D4ttLi3gsHqEdLW4Xg0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vladyslavt@mellanox.com; 
Received: from AM0PR05MB5059.eurprd05.prod.outlook.com (52.134.89.92) by
 AM0PR05MB6291.eurprd05.prod.outlook.com (20.179.32.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Tue, 24 Mar 2020 12:02:54 +0000
Received: from AM0PR05MB5059.eurprd05.prod.outlook.com
 ([fe80::b883:52e2:594c:384f]) by AM0PR05MB5059.eurprd05.prod.outlook.com
 ([fe80::b883:52e2:594c:384f%5]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 12:02:54 +0000
From:   Vladyslav Tarasiuk <vladyslavt@mellanox.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     maximmi@mellanox.com, mkubecek@suse.cz, moshe@mellanox.com,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Subject: [PATCH net-next] ethtool: fix incorrect tx-checksumming settings reporting
Date:   Tue, 24 Mar 2020 13:57:08 +0200
Message-Id: <20200324115708.31186-1-vladyslavt@mellanox.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0008.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::18) To AM0PR05MB5059.eurprd05.prod.outlook.com
 (2603:10a6:208:c6::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-h-vrt-022.mth.labs.mlnx (94.188.199.44) by AM0P190CA0008.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Tue, 24 Mar 2020 12:02:53 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [94.188.199.44]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c2640ddb-03b5-463c-66a5-08d7cfeb48fe
X-MS-TrafficTypeDiagnostic: AM0PR05MB6291:|AM0PR05MB6291:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB6291E4B725E02D52F07126F5BFF10@AM0PR05MB6291.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(6486002)(86362001)(316002)(8676002)(956004)(1076003)(5660300002)(2616005)(66556008)(478600001)(66476007)(6512007)(66946007)(8936002)(186003)(16526019)(4326008)(26005)(6666004)(52116002)(6506007)(81166006)(81156014)(36756003)(2906002)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6291;H:AM0PR05MB5059.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: agp3E+jq+9a0J5vmN8u2/os5r4HjxZRYC7dYjoDujNu1YE8RzEOdZz2qMhHH2C7fN0mO//HSh4baGJd6z8Ge4bLepU+10CCxAytbyMlbFgVxeG4vZuSDKSwCXEYr44E7vu55ra6GHotxGTBi1ESaxlm3GP1DGbAJk6AbbPSD5hIxd3C2N41AWVS1ljjd1569Jw+wXzb0Nrv9BYn9Md7ZtgWLb/J12yg70W/vlfBa4DPJU3P3jo5n/eFuEQx6TtyZH5Wt2U3TDiGceNE9w1pZU1VydFsyo3q4IxWDG5pfKLZNpX+N9sjmUtypKeNIfKQPlcH5rEuwcgDw7OXktLm5FD1zLB8jVEdukthsQ9ctWrvkC/WxmULd875OMjRcLiPGdIB37D9Turi3ywvV2DT0/P9d6LgDuekPbRUtK5V+0vmw5s8qbdeE3chjsy7ebpFO
X-MS-Exchange-AntiSpam-MessageData: sZ/5icTQj+9TJRUls6Kl0VppFjnqiJ8E6+Z9LvPy3lRIM3xKhh29Nbp9TQW7NZpamKpSLAgl6bwfVMq/ZgxY42TdLjsDX1azUZ7UmXeDZHDtHHvIKkt2qTOCR3NGan0k58uScSRKujQkmg972qf63A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2640ddb-03b5-463c-66a5-08d7cfeb48fe
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 12:02:54.7819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0uud3eXZen5Wiv2svUH94RAURwMXCvPQ8VxzVbSDQmxEA2KcD+nScYnlE1LcoMNzOAczcOx4KRjj/mXW+QanmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6291
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, ethtool feature mask for checksum command is ORed with
NETIF_F_FCOE_CRC_BIT, which is bit's position number, instead of the
actual feature bit - NETIF_F_FCOE_CRC.

The invalid bitmask here might affect unrelated features when toggling
TX checksumming. For example, TX checksumming is always mistakenly
reported as enabled on the netdevs tested (mlx5, virtio_net).

Fixes: f70bb06563ed ("ethtool: update mapping of features to legacy ioctl requests")
Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
---
 net/ethtool/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 3852a58d7f95..10d929abdf6a 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -196,7 +196,7 @@ static netdev_features_t ethtool_get_feature_mask(u32 eth_cmd)
 	switch (eth_cmd) {
 	case ETHTOOL_GTXCSUM:
 	case ETHTOOL_STXCSUM:
-		return NETIF_F_CSUM_MASK | NETIF_F_FCOE_CRC_BIT |
+		return NETIF_F_CSUM_MASK | NETIF_F_FCOE_CRC |
 		       NETIF_F_SCTP_CRC;
 	case ETHTOOL_GRXCSUM:
 	case ETHTOOL_SRXCSUM:
-- 
2.17.1

