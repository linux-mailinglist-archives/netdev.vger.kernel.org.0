Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDBB1A2C08
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 00:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgDHWwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 18:52:04 -0400
Received: from mail-vi1eur05on2077.outbound.protection.outlook.com ([40.107.21.77]:45409
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726512AbgDHWwD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 18:52:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gyqrAUL6ef9fHVvnr1MNnWilhJ0EPPWzXX/m7KyLpHWfKrGgyjialfLxFVa7RyuToz3RtUoqtrKsTAqkM6dLXbKTeP/lPsC4UvLgCNW/2isp3QRyD2NNjU8/K1ZMduzhjXgztfS5mNUh+jGzlb4xzeb3pOF2HCYcuI3/gz4Clm3qclgFMtHTd3MuZHVOGImQNXUcPiQdD+iVH+PTn0W78R1VSjH7q7wQgbRexqR6T/Whd4LXRfgYMqkB9Kwqn/0P7QTgdbFE0s6hXujP+CRUsZCariimfr6fbBO7V91SRvAUoI3pKOJp4cIiNqQSU16jllZ6sgLVDrOE70fb/3UEXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIPxEJBg3VYWIweN2r3jqMXrUigocN4SqXzbg/CUqtc=;
 b=hKf3G0MHiLVjTRpi8CpWrLhx+Vz8VIByYKPYVeR+ZP0SXLC/6mAtJ7jijauM8e4IhfZwqLmImNP7tCVYjqyU/Xa9GeK95OCKOiq8lHOSw5cOt5W8/FkXqPCuOcQZUC5ZW+FdHXhFbtk3z3gjVEDIPRE5nlf9B1UIuOa2dwb6pyAy3wLVKqp2sg4nYHDselRFAIV/sFhwpPUqq4p4aAEzJRoXGxkaZ2IC2+c38C4JxIijIgVyLXlOGPFsY30GxI2JHNi8DH6SY96ingi3XnxEqQTv1gsRf5Lycir0hRAI7VTfkhkoYCc7IJFNv79/833W3baeyv1v6y6bJKTuZzPUog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIPxEJBg3VYWIweN2r3jqMXrUigocN4SqXzbg/CUqtc=;
 b=CsTigPWl6vAns2NAW7gZ9OPZ61Ayv00i1QoNgQrj4RRsee28nJr4uNH1JI2Q4FoxRl0f8VBD2MbdGRd+SJyReUJptP+u7t+zJe94pQshmWfwLjOXmjmgyRs5HZ+rAVOPL/5h/PCmaUYwN2Dv/EEOBzC+6jPz5O7cAFlDfNn7gBw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6365.eurprd05.prod.outlook.com (2603:10a6:803:f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Wed, 8 Apr
 2020 22:51:52 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Wed, 8 Apr 2020
 22:51:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 5/8] net/mlx5e: Fix missing pedit action after ct clear action
Date:   Wed,  8 Apr 2020 15:51:21 -0700
Message-Id: <20200408225124.883292-6-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0026.namprd06.prod.outlook.com (2603:10b6:a03:d4::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Wed, 8 Apr 2020 22:51:50 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 011a2063-befe-4571-5c6c-08d7dc0f6d82
X-MS-TrafficTypeDiagnostic: VI1PR05MB6365:|VI1PR05MB6365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6365C2E658B763A1A443B45BBEC00@VI1PR05MB6365.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(376002)(39850400004)(366004)(396003)(16526019)(956004)(6486002)(26005)(316002)(478600001)(54906003)(6916009)(4326008)(2616005)(107886003)(186003)(66946007)(5660300002)(8936002)(81156014)(36756003)(86362001)(8676002)(66476007)(1076003)(66556008)(6506007)(81166007)(6512007)(2906002)(52116002)(6666004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8/wyXBwbmZTy9n9GSn4NLILo7wwdMNKS56/ClHvafoeJxOTZxJ41glsQ5UZVvg9kz6YK3A7NVBhZIRvmOg1kV7UG9xDGh0J5wDv4eWaVx0CGWoHB2lqImdValQMF6iLIRrhOoILBIuIzGl30MIL89eMgRfjzXTlOMEh0zYEo5I20BrbZ/LX1Q6Z3RceiOgmmBHwyEA3ol60qim6U5puq2J74uSaxLZxyDuuEzjpWLvzEXfAjgAVTngC0Usaxccx7IlvFXqyDIkqD8begeUlNIPNjECSOhXm5B1RiAGdWbxs0v6BRa7nrpDNodBs7U5Jq3Am4STk85b8ajvmu6ks1jOzCkM/L1q4lfSPjJb9OO7S+zLRXXqeHtR7pjWjNc/sav2DalfKRUXLAl7zlmHZ1Q4dX9neng9bTnCZa90qraYE7aFeOpFA3LVUVGK4cwzXwBFCT+ZY4laYJxL9x1VD5+zQCNrZlR9I1Xjlg71qnM5JwHIJ3k33COHuhzr9SfAMt
X-MS-Exchange-AntiSpam-MessageData: 6AaG/4r7Dj5AeamSQMridijxHKV8PXfImQG/VpnRc4nFro2ho4jAurftNOl/m0gpLLpiA+xoMs2SCdkw4QiKcJB9IAOq53fkwABkvU/NonlhUR9/HZRDpVBHBsu2nrSkWmy7V4Ru/k5ZL9IBo5BLcQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 011a2063-befe-4571-5c6c-08d7dc0f6d82
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2020 22:51:51.9792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a5QALSKFv8Pm9o2ygZuBxNsSFeLYD5PDOi+UTmZODF9AaC0KIJ3Bo3q3wiTFlbk3wPhr8FXYo+NAP4iAftgQ0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6365
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

With ct clear action we should not allocate the action in hw
and not release the mod_acts parsed in advance.
It will be done when handling the ct clear action.

Fixes: 1ef3018f5af3 ("net/mlx5e: CT: Support clear action")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e3fee837c7a3..a574c588269a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1343,7 +1343,8 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
+	    !(attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR)) {
 		err = mlx5e_attach_mod_hdr(priv, flow, parse_attr);
 		dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
 		if (err)
-- 
2.25.1

