Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4781A2C07
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 00:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgDHWwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 18:52:01 -0400
Received: from mail-vi1eur05on2077.outbound.protection.outlook.com ([40.107.21.77]:45409
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726492AbgDHWwB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 18:52:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QskhgB1t+jVmV4B1RpV4JZJSCNBArMJCKWN5YGPIZmq+fILzFXjQNZ5Pk/kkxaz41m+yUOGiDUW8S3O/VD0u9cA+IiX5WQVoystKzqKGAMKmPJKaA9oPcIrrbD9d7qmtEOU1fPrtxjnogUIF4YbKQdpG0v5Wy/FMp+a6mtjNGGVwqauZDhfRm0bipI9Erv7b4mdyC47qqmO8rB/dKGTsvJqvr1HZ3QP62ZVvvY0KeAPaSgEbi8WqRWTHpWTKqqBW3a80dXnV1z3pGNQTJTgUDYtkUs6vFQ5Oub5shG+JiWyHegp2PWzCSZWvcMQnX2/PUxZ9tBF+H0q5Ne0GgxA2+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LiHMLeDml2quGTQCYSlVZ1KghaLGuJSjntHiHjX6d5g=;
 b=EULhjg1Z5KRMgeVMCmvgAOWPomP94oU2Ep1FSrgadk5EXHJAyS3Wy9TTyVxRAUTKiuksigMHYCtHVlo0uqWnHAfx3vrXdwLmWjzFMuP90FiArV419Cc1dGyWq1oMGyKjwfj0jRDKOXktEdli+DmgHmMEihg/W8Gkyjt3VZP2o1sgrb6IjkFjyiSymMRLc4U3EUL5GTigW7w6CZNn+HWNoy012tQHjn3lACCKkOd2SHJKcPsegkNkCteOuLfL0rdlOvuamXmARwgSWEs4k2kWaMT2lqKG3zZ2Z6heBL+nPzu03u/6HoYR1TlJk/21mcY1db1K4MwOw1SnYNbGPYJlkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LiHMLeDml2quGTQCYSlVZ1KghaLGuJSjntHiHjX6d5g=;
 b=ddK0tvpuXns1RyOOcqyjlFCadNU8kSKXda/VSBeiVQJ54XeKajg4Kkh6BJ1LwxfuAqZJBRYoDYlETXHBumdrYpnV5Hbw5v4SVKMVTOcXsArCqGH8Hut3Nr2z55aoOSLTX2GtEHvPib8t+WpMlbsERalXGzc7xrVu3sRN9m4cK14=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6365.eurprd05.prod.outlook.com (2603:10a6:803:f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Wed, 8 Apr
 2020 22:51:49 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Wed, 8 Apr 2020
 22:51:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Dmytro Linkin <dmitrolin@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 4/8] net/mlx5e: Fix nest_level for vlan pop action
Date:   Wed,  8 Apr 2020 15:51:20 -0700
Message-Id: <20200408225124.883292-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200408225124.883292-1-saeedm@mellanox.com>
References: <20200408225124.883292-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0026.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::39) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0026.namprd06.prod.outlook.com (2603:10b6:a03:d4::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Wed, 8 Apr 2020 22:51:48 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: be0b9394-6b04-4c64-024e-08d7dc0f6c45
X-MS-TrafficTypeDiagnostic: VI1PR05MB6365:|VI1PR05MB6365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6365F43E82CD61C27F07ACAFBEC00@VI1PR05MB6365.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(376002)(39850400004)(366004)(396003)(16526019)(956004)(6486002)(26005)(316002)(478600001)(54906003)(6916009)(4326008)(2616005)(107886003)(186003)(66946007)(5660300002)(8936002)(81156014)(36756003)(86362001)(8676002)(66476007)(1076003)(66556008)(6506007)(81166007)(6512007)(2906002)(52116002)(6666004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p4zRNiCT9tbNR3AaQQsn/ZKcPpbBPBzYjCW+BpIImpTEVVkvg3Q8MQhK9xNBn7vZMZg6G3m4moTtpEpgj71/FwZBE1PImhAxuDsvYAEVEZAkDFASQ0YRyD9raYMWgLrp0FYqaFEaQ2PbyM7cyvLSQ8JAeW+rs0Vl+I2s7NcsFfh75tSHqmwld1F7kr1uGf0r3InkdH3v+UDnpCHdXhahdpG0cS2V74hWU0tQ5oKVkEBInpIdfG/OCwUfZrrHypmNAtDyo0Uwe8/oPwON1VJbikTU0ejl8uK+E7Nplt4p6DF21QkJ84pfrbcK2okaDpQCnhXN3D3uPjkBsE1pA8niyHvCvHhoLRr39qmCVfOoI6PcGnMFMSt483SD5jCTsCQMx+mhio/HCUxyEJX6PdyEx3W4YeHG7APO48xbgxw8r+1FyXa/subMRQ3vkK+5BFE5pGwI9I8FeyiYJwkr0IQebJZALnmV2n4meFjwoSnsaJevaelE53D21iEyyH39CERL
X-MS-Exchange-AntiSpam-MessageData: zK47UNUi5Ijg2aNPLrhqRq+qlRfhv1B/mTnU2n5NmrrjDh+WUUFKyX+HZY8YBt3VW1gr/8JBv2IWTQTowsJW/cz9WKZqANq3dFf/K/7b2+GzHnFNqjxhB+5Qp8YkmmWzQldauU9GnYCnGzqHDzJiQw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be0b9394-6b04-4c64-024e-08d7dc0f6c45
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2020 22:51:49.7745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f0lpTYpptDv7u6DvJ8MZ2sdwl1vOdb0baBwLsxRTnavfRgwOBp1C5McYRorRdJ9imIGsp+I80I5PZ4eN1ZzfxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6365
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

Current value of nest_level, assigned from net_device lower_level value,
does not reflect the actual number of vlan headers, needed to pop.
For ex., if we have untagged ingress traffic sended over vlan devices,
instead of one pop action, driver will perform two pop actions.
To fix that, calculate nest_level as difference between vlan device and
parent device lower_levels.

Fixes: f3b0a18bb6cb ("net: remove unnecessary variables and callback")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Signed-off-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 438128dde187..e3fee837c7a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3558,12 +3558,13 @@ static int add_vlan_pop_action(struct mlx5e_priv *priv,
 			       struct mlx5_esw_flow_attr *attr,
 			       u32 *action)
 {
-	int nest_level = attr->parse_attr->filter_dev->lower_level;
 	struct flow_action_entry vlan_act = {
 		.id = FLOW_ACTION_VLAN_POP,
 	};
-	int err = 0;
+	int nest_level, err = 0;
 
+	nest_level = attr->parse_attr->filter_dev->lower_level -
+						priv->netdev->lower_level;
 	while (nest_level--) {
 		err = parse_tc_vlan_action(priv, &vlan_act, attr, action);
 		if (err)
-- 
2.25.1

