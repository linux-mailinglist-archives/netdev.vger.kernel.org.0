Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B14451938C0
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgCZGiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:38:55 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:8291
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727742AbgCZGiz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 02:38:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TvZJv2PgMqeS4PGEmAVxUbLQwgy3XAZBnyql98VP3goQQdM5677Dx25VHg6ui4gETgw4ibAmOdHF2wiTO7XYmnaVlh++861c19nhIs4uuAcekLeYtSu2XESfE4IazZAojEKBeK5q8/bEdNC2mmZMrVXiof4qPy9mXKKGdvzgWUKJpSEFUFJcUefbImR5ZX8yhXuzU1Etwcrk7smNOvFu3G9ai4AQ3cdjyI75Ur2iIl0RlgArMMQVg5W9KJIsx27ZrsjzXTtLsLnDAHolb9LUQNifostKCZjX5B1vrSrHl12tPnUOOo/RkT4iMBK5As9GgAO95caalMoiOlNOcDQMZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1fqq/2H/bCZ1gNRxC03lQv7ZDJ4YXXF7j5C3/ku+4I=;
 b=YzABja6TpIRUaMOvQWbvgKYQ1hkaSoBqzg13hWQK7buDzzTZwncsxsOnueqoXvcYQLCCyKiMWoJsHdiw/BcFHdg7BVYKT8pky9ybid77cFG86NMsXwIWcyTD3/jl50Qm530a9K1bCkQXUKwlIVijQoqS9uWjwGzeotPWzgd6FowX+YjMYwcK7w+28CriQGBnbUl8eP95hvNDMcVWeVHm2w5kMlOcUo4BFKUztFK385sw4EOys6/B+yD3NSxGd2CdK1LstO28ufnQUVR+4GrzyWubl6hHWjiVn5Y+zh23Z167bBrkfz0pQcsxLoe6oXOQLJONmbOHDbK1UauersCRtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1fqq/2H/bCZ1gNRxC03lQv7ZDJ4YXXF7j5C3/ku+4I=;
 b=er5zuN0z/8KDojjf89H0ZWSw7E16opa0Kat7H7fXnb2CHGL829kwRxjP6bAczoXae/ozEBT5/8Jr0SFoze3iGKWeW9pmjzRjR3Y+9FLCjFG1q0IG1YBjXM4ZEJL9UriWDVqg8UfRg7JslSbfDq29QVtk0+hV4vYpscn7RVwhl4M=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6479.eurprd05.prod.outlook.com (20.179.25.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.23; Thu, 26 Mar 2020 06:38:49 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 06:38:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/16] net/mlx5: Fix group version management
Date:   Wed, 25 Mar 2020 23:38:01 -0700
Message-Id: <20200326063809.139919-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200326063809.139919-1-saeedm@mellanox.com>
References: <20200326063809.139919-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::33) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 06:38:46 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1a2f4f4e-049a-4968-31ef-08d7d150572b
X-MS-TrafficTypeDiagnostic: VI1PR05MB6479:|VI1PR05MB6479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB64792CFC2BEA6BE7302CBD75BECF0@VI1PR05MB6479.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(478600001)(107886003)(52116002)(6512007)(4326008)(86362001)(6486002)(8936002)(54906003)(6506007)(36756003)(1076003)(81156014)(81166006)(2906002)(316002)(8676002)(6666004)(66946007)(186003)(16526019)(66556008)(66476007)(26005)(5660300002)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 42Zmeu0ApOHM6I5knN5tC0tkOUwxQXgHfjwcmbbk5s0CAL9ai9gr7Pq7/mtTOStt73j+4/l3HaItEDPGo6txFbcA5nBvmPtNXgsjMuVfzOWt+xeQyLxnugDhTuka7m5YWEG7qCgZJHoUli+KaZKlGeEHlMy7vddC33Ct3IK6QXUbdtqfiqvTT0v4acPpjO1p1MbU/Myl9EF926YRosIkW17yWYM468JThlCGfcuhFzsrHj8kEps31iDiouH2ZrXEoGbcioT9oF4ATb8+iM3H1xk2RdyUUgPt1fzUYYIRA7w/wmk+3tbu4VziiIzs47H7IuIOAKJ5nq9afuXNkPUU1k7kd6MDhbWM0vZi1aRayDzJUFHmYm1UE+LwGPnd5xlZ1EDv+pWS9NJGDitFz+1IupjMlVwLupfAOZPkoAbIoJetAkPEMpb+IQ8sY3k6CLC2Nnu2KYRRP763CV2tUM81LlbnTgE+O9ypx+NhOdrtTUwWg2GtlL2KXkkig0abGnDe
X-MS-Exchange-AntiSpam-MessageData: pk7XKPzJwcsxf8sxUnFDs5R7EsO3SJM6RFmigxl0QC23934fsuKkzrXI6/FXhRZr86aIjXpyBIiIjNBdCW0EBsOjvNOlULbKn3NnnQjJwD9NLFrlIpxHLfQQQM4JS2jKrrXt2MniYBkIQlExCSAoyw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a2f4f4e-049a-4968-31ef-08d7d150572b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:38:49.6586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F2YjvfEnj/SBmTBh3544HEvfcyt7TCBZNvMeeo2vqPPa9UF3LA59aBGiKmPETXKWzURcdIYkDL63RHorvrfj9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6479
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

When adding a rule to a flow group we need increment the version of the
group. Current code fails to do that and as a result, when trying to add
a rule, we will fail to discover a case where an FTE with the same match
value was added while we scanned the groups of the same match criteria,
thus we may try to add an FTE that was already added.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index a9ec40ca7893..751dd5869485 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1323,6 +1323,7 @@ add_rule_fte(struct fs_fte *fte,
 	fte->node.active = true;
 	fte->status |= FS_FTE_STATUS_EXISTING;
 	atomic_inc(&fte->node.version);
+	atomic_inc(&fg->node.version);
 
 out:
 	return handle;
-- 
2.25.1

