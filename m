Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73422CFDEE
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 19:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgLESso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 13:48:44 -0500
Received: from mail-eopbgr00128.outbound.protection.outlook.com ([40.107.0.128]:7941
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725536AbgLESsl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 13:48:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FztR2/l+RBYyMjjhgqQFtjAeZk2tVkPa0kwqwfEUrBm6/YqlxrUSsWjlEjgYNJEhnfVcJQCAqNvcG2jw4Yd95XmA2IICDaDXADvhkJPV4yv7uXEcs2ycf0ERqXFlWvWxuecoT2i0KEe++CV3njdkyWA0rMsFBz29J5npsZmCSQ/pGhX+Ht2YmlTtnC2tsxsYz8ZZZILZZuFIYXOAa4cH19yGEiNvlkEO/QxhYlwbf+ItvF7o+/2HRlWnmkK5+0SGFw6XwWum6BxbOGKl15WrSQxumLorXijQGJL12ixM2FT5GEU3s2d6QVJzKOI8nQKnnBjmQ6ckXCZ0++NpVZgNBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RZYWq8Fm6YrOQ6IIZfqfOrzJRI88MfnjtpZWKWOzuX8=;
 b=IUjsq+W5um3VUgVwpLquA1GDUsK5n8eY6wF/Z02eP8O8W35Na/DYs2HK0k49x4h8lNclp/bIPJpW6AhW/h33tNrYSo/uwRuNzAhjmUKTMto++USx7vgOvE2ZmjhQBdw7Pwfq0lBO4ORtbnBezCf9eimms9PfXNvftxDjEQHDdfZSRI6ZOn7+5JCVMYmo5IJL5ghZ898gTQD1bVUFTzLbfEkHd4PGJvLq8YB1kJ+fFzNxLrt4cnnhdqciTREjVvsKBQ53OYs57HDvQhryfqUGkvwJqUZYA+9XYAnWTbx11Furr/ydjpVE/6qPsTu8+yva9heokqnZ6lqO3GzdUNCZsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RZYWq8Fm6YrOQ6IIZfqfOrzJRI88MfnjtpZWKWOzuX8=;
 b=iYyelW2mqZhNOWkUN6dZamK2UjEGQ6FRG6VrKq8dPJs3xYmLanxGFKMK94HWb8tkKrKaG0OdaAEnoMCkh4B+qJs4ne/U8Y+laMpDmRi75UScYNdpLx0ElwBXUrbt1ZVQcNFHu+3WFA+bZk0gKAIj+IZXEKjDZ7LykpdjAd0lSX4=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM8PR10MB4084.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1e3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Sat, 5 Dec
 2020 13:39:55 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 13:39:55 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: dsa: print the MTU value that could not be set
Date:   Sat,  5 Dec 2020 14:39:44 +0100
Message-Id: <20201205133944.10182-1-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: BE0P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::9) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by BE0P281CA0022.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:14::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.7 via Frontend Transport; Sat, 5 Dec 2020 13:39:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50d42de4-35f4-431a-b42b-08d899234061
X-MS-TrafficTypeDiagnostic: AM8PR10MB4084:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR10MB40846C411DF5053A7A6E449D93F00@AM8PR10MB4084.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ddSWhzp8kkPvxGLk+U/6TtwK+K3Y0qjmvQy3cmVO5drPADnWz9xNdO0Ck2QwwH4A89n3eCE2wDPbr1MjCyxn0EInhmt2UQRiFG7EraXiJgTBM7p4/+s0j++Dzcec44oFiR8LfAC3Gq16jTdSQ/RE1EbKDEKfNkTk3W3y7UVHmaYHrETqsaIjBA4HalG5nrDZKMZAdQbdMc3fZ5AcYW8otrrMJDqqFFzre8KZpv5OCI119bKesaPHsHRe5Sz5TeS25RocJt+kEGHu2Kx7J/IQNYmC5lKM1JSgn+0+v7GSqGNBlhVAC7EvfIGbdL8nhJyr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(136003)(346002)(376002)(366004)(396003)(16526019)(52116002)(478600001)(8976002)(66946007)(86362001)(8936002)(6486002)(8676002)(2906002)(186003)(316002)(6666004)(66556008)(6506007)(44832011)(26005)(4326008)(36756003)(66476007)(83380400001)(110136005)(1076003)(5660300002)(956004)(2616005)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hKlphJTWs00hYqrqGPwv/x53q60hRYrpEv0fDXdBIJq8GdV8NiopSgShVW48?=
 =?us-ascii?Q?UN9E8sbg2QSR9KFPqzJGoL31upj9PPMbOyvDZ7w9KCBLJsHfxVEHdtCQhgiU?=
 =?us-ascii?Q?+oRWfB2uG7Ay1Y8iIJFVJyMi1RtuAycpmggDhvdnEiYvXiYtCusTtI5Ddu4q?=
 =?us-ascii?Q?zGTUDH/CJQpYzj0c6XP9vMuJfkHj8pa8529bMXwdxvZmJ7qZJd46rQnOKhuL?=
 =?us-ascii?Q?uAZI1q+LXKFXEga+fJO4t9fAI+lmHoz1C1mqyyi7UNLzXIwCOOd1B3CxhJcQ?=
 =?us-ascii?Q?fLYzqg4dbj3NKrtm1laacAiDJgby3L2ZzwjoWXZhvzo36QbFyhXiUwrJKQem?=
 =?us-ascii?Q?I+wBQK60DhyLPFKvKL4Yfggn70sM6qOWjEvVdyrAAgjOKFZTQrXQAbY4U0XQ?=
 =?us-ascii?Q?e7KBMcQYdS7598gv29ZPrLbxcZjbYX77dOupfSLMGdlOxlUUkgCPLZWF3MPw?=
 =?us-ascii?Q?neNAnNWXrXNPgSFHUOcLUM03oS6K/F/bGIRdvaO9JKJ8AzumjDvVvUfQaAcp?=
 =?us-ascii?Q?iK79k0uvqv/h3CkMs0G/8dqqCRwQwD4TrGwY9l21B3lW2lmFz+F9h5747lEV?=
 =?us-ascii?Q?fuyDfPcO26DBvgxfLvjKdwQac4j6a67QiX1N8Z3o729kYGlzNShqKLrUCLhZ?=
 =?us-ascii?Q?Jr62xk9ist/P+Anc1TAGOnO7cuiNki3ikzGMqr70glpDzXCTx2y3BF+x0EFd?=
 =?us-ascii?Q?i5HkxuZqy65WU3W02yOPTyJwN8b7JOY1Jz/19q8tCo+GCNDsKdc2W5MYWobE?=
 =?us-ascii?Q?+voNF/Kzx0Ujbr6afK4bZ1n3VVQ+mpopQj6KXci5JCyzrfN70BdAJgp/SVs1?=
 =?us-ascii?Q?hD7oLVV5Q6+IiNHq0LarJRglj0M0f03PRlB2XwHq3cU8nVC+d+38EP/c+Uth?=
 =?us-ascii?Q?B7+zVE9W6Oyc2YJXZO5Iz8GWHlh9UrmotQsYipDFjToJ/FMNoqCJs27wEQPB?=
 =?us-ascii?Q?V+HxjK7eYyCFxLjYDlQTnq2FS92w+WfywAS3BDS9oEY6O94kkYNec1/Wxw49?=
 =?us-ascii?Q?eppI?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 50d42de4-35f4-431a-b42b-08d899234061
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 13:39:55.7374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E0pq3qkQ7IqRkMjGd4kko6DsOmaDzuHIGM2h3fGdWFirWfghDPzWcIIe7q7iZ768Lp3gerxHOZtdBV8XOlFtIQGdIYaSfGR/uGjSyG8u/u0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR10MB4084
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These warnings become somewhat more informative when they include the
MTU value that could not be set and not just the errno.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 net/dsa/master.c | 7 ++++---
 net/dsa/slave.c  | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index c91de041a91d..5a0f6fec4271 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -308,14 +308,15 @@ static struct lock_class_key dsa_master_addr_list_lock_key;
 
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 {
+	int mtu = ETH_DATA_LEN + cpu_dp->tag_ops->overhead;
 	int ret;
 
 	rtnl_lock();
-	ret = dev_set_mtu(dev, ETH_DATA_LEN + cpu_dp->tag_ops->overhead);
+	ret = dev_set_mtu(dev, mtu);
 	rtnl_unlock();
 	if (ret)
-		netdev_warn(dev, "error %d setting MTU to include DSA overhead\n",
-			    ret);
+		netdev_warn(dev, "error %d setting MTU to %d to include DSA overhead\n",
+			    ret, mtu);
 
 	/* If we use a tagging format that doesn't have an ethertype
 	 * field, make sure that all packets from this point on get
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 3bc5ca40c9fb..b4a813b8a828 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1820,8 +1820,8 @@ int dsa_slave_create(struct dsa_port *port)
 	ret = dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN);
 	rtnl_unlock();
 	if (ret && ret != -EOPNOTSUPP)
-		dev_warn(ds->dev, "nonfatal error %d setting MTU on port %d\n",
-			 ret, port->index);
+		dev_warn(ds->dev, "nonfatal error %d setting MTU to %d on port %d\n",
+			 ret, ETH_DATA_LEN, port->index);
 
 	netif_carrier_off(slave_dev);
 
-- 
2.23.0

