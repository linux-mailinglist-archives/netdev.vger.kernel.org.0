Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43C921AD1E
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 04:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgGJCb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 22:31:27 -0400
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:54404
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727124AbgGJCb0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 22:31:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBZ6WuCsmz9tBMXiacVBznWEgpQNBU+lYz2n8dWKZg/qlTanoettDj2qeezMXsw53DEvJJlhQWrXe0g/ylGCDZN2yoLEBjkjVIDMVRPlC2J65pJ7oT6A5NqTzTfmO5KLqTlSIe/IPQTJXcFSyhmbVHGXUKHz8Tt9M6jX5sjyHJzGzWfr4nF1VwLIo1JANsBUL0tRpoIawuIn71njZY3ldEm2pPaZVyVKP56PKZqAsQXWageCHKXPZGeZEnL5ei1hW6MH6NLRR30quWr3/LAJjNCgaqEMDLGbk1vsa/J0tblcp1XPvm5NpJh5z9qa6r71v3Tb5KRoM0TtzkDkGgjbLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3ISsaoAVE4MqFYgU6y/L4W8FeiK38odjh2vqeTo6dQ=;
 b=R3YHS97EN4JCebUXb12Wu6VKqfiQU89D1XzmU5SVxhe6HAz7FN/ufjXLRfMyWCtk79GcVpAaZe2j/YbKWdjV0LoRa21Y+M3Tdl2dQ1XObu+BvIj75/TddB0MIS8YIYtQxcbygZq4akJ0wi6zfDiMj9Udtxx7lwcF2F35uqSH2eeJg17DvafQUYPyv12Yudhx8kkgMBfhyB+ch0/j/T3rK4CJmYVtCOKNSHcPSfZ18wnx8B16CX6fhThL/KpXN8f1RdiXyuKrWe0foTNg6rTETbcK9voanCZXvB5GjsrkpNiU/dD3oObBkj9De+XUYnDJrlBNKKP7LrHhGihzxiRyPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3ISsaoAVE4MqFYgU6y/L4W8FeiK38odjh2vqeTo6dQ=;
 b=OIOo5BjqPO/Fi3WhC2OPG4n5Gs7XrZt5A35BhW0/nW+577lnmgW36gVWG6ShD1CQ8vx0S7yXWYJP6ZQydFYNsTOEqnRJnUUtuw0YffPCyhp64VcYft4vnSDAQiIIhlUTIi3JZfSVEpJ9si+CTJUTtgzIPeMpQbTGDiNKwT5lK8c=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7120.eurprd05.prod.outlook.com (2603:10a6:800:185::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 10 Jul
 2020 02:31:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 02:31:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 9/9] net/mlx5e: CT: Fix memory leak in cleanup
Date:   Thu,  9 Jul 2020 19:30:18 -0700
Message-Id: <20200710023018.31905-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710023018.31905-1-saeedm@mellanox.com>
References: <20200710023018.31905-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0064.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::41) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0064.namprd06.prod.outlook.com (2603:10b6:a03:14b::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 02:31:06 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0f6bfa17-1316-4483-81f2-08d824794d5f
X-MS-TrafficTypeDiagnostic: VI1PR05MB7120:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7120E8398EE5F833CC3B3A41BE650@VI1PR05MB7120.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: koVSbPys3d+vQtUD1rKnMhl9eNbVxHP800FLmn3rZgR5ENRdEbZw+pqWgNUotvh1MAesA/BHzlUjznHv1Z9Ftj/bEl1v5uf5I+icyquNXKaWjRJZfsiJg3kIH1h+E5qVK0DY0PLI5Fq2Hr5vULMqa+ZnQKPYYR0VGEV/P2fmyxIOcKoH1EQD+0F1WuwxgdslyelaFF4zwYlfqRx0F2Fc9xIeyj06OuxqL/EnTDF4eMXDTIWtXbuOCaDji3cLEd5wXoNnAK47U21jXE3y3dXr0z61DcrkP9Fq7YY3RqWQ8p+1P3e1v9XVv2XgH24naZRypoJKMnf7UjQhDkFxkXe3hc7K1bch0IBDnSZyl3TkmwHzj4zf7evIsrysDqoQN+wD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(478600001)(26005)(4326008)(86362001)(52116002)(83380400001)(956004)(2906002)(186003)(16526019)(6506007)(2616005)(6666004)(4744005)(5660300002)(8676002)(8936002)(66946007)(107886003)(66556008)(316002)(66476007)(1076003)(6512007)(110136005)(36756003)(6486002)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7pbcyFpANF4+LjRYvoGK23ThB38cil0oktJUxPoKqoVAEU2zcf3Qk3abkyM/twy93s67ug6a+kIu4QxJtwzzM1lqYgyEoC1uXP6IDxdAy+15Oi/Ia1X/bMnxqE8ubQKN4Tt5N14yuvlyzO8G3+I3WBVSt3topb0tz1HaUeo63A2qa1XvcIRDfBXPWSawM+reIa615V3iioBLhZkv8V5UT+slf3dsZec3AZfkARA67bySvvxicBgXCc58ifxobRkLkro0iIBH/oyQyB/7KrFEtTp08O5VcO+AA5vpfv9IRjXq9FlABAh+un2QWFAwSk2M4BE5cv+HGj9bNRvQjqRKn7N0VuNiWnUvX8eQrfEnlfXhmWyeBY63wf/JdaDttMosYqVLjsVVxywyR/fooiJ5TzRf6aQo+BFfZVvkwOtkk3zy/OBkM8OpWU7OoFYazbl9TqXLVQsZu73cumQ69bwGojw55mhy+RlXUBs6nB8JOVY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f6bfa17-1316-4483-81f2-08d824794d5f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 02:31:08.4900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ma6+qr3codTEmZQ3KBCnpNuPaZGHX50FR4NuXt5Vadp1XQdIMp+8gb48Q4zz0ffzCvxmpnULY+0qZwYHBWjNrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

CT entries are deleted via a workqueue from netfilter. If removing the
module before that, the rules are cleaned by the driver itself, but the
memory entries for them are not freed. Fix that.

Fixes: ac991b48d43c ("net/mlx5e: CT: Offload established flows")
Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 430025550fad..aad1c29b23db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1097,6 +1097,7 @@ mlx5_tc_ct_flush_ft_entry(void *ptr, void *arg)
 	struct mlx5_ct_entry *entry = ptr;
 
 	mlx5_tc_ct_entry_del_rules(ct_priv, entry);
+	kfree(entry);
 }
 
 static void
-- 
2.26.2

