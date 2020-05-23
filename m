Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE141DF397
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 02:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387507AbgEWAlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 20:41:44 -0400
Received: from mail-eopbgr40071.outbound.protection.outlook.com ([40.107.4.71]:51206
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387497AbgEWAln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 20:41:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ju/afazYbCrHs7O6kMN7H3qWx7h6gbQRd3uhspvAQ+b7E+r4py/gnjY1BTgsB/TeISNKyivn4jqQgSgPyX9Nv63Socdywn/klgbPC8HNCINJe5M2IVwLqlqJyPyDiwO9Ry5zgfRHIXfQC72FjFrk2bK0tvrclAZF2w0vQWv+V6DNCGak0Qp53ok4USuYfsShNMENitWsladuO4kr/V5rwx5hbSBqhsD8FOqVDfNI8Etx3rcRuJjJ+Bzj0ToCbFQQWd12q0LbATuZ6DhPyjIuRKPxhl18XdgCu06gLI1gg8cP3IYOXDVNpkiO1A7kxDUPueyVOrHnVf8mnt/b++A1fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tisdp2kKEjcPdwndjVqNvIo7NnR7vIS7+SxhQ0rSZT0=;
 b=nQlpVy5FkHiKnpY7JoCKZd2XvVLFCoxuRYktXYwfUT1QWNhS25UYOYUQ6bFEhw4yhhCpJV1Wi0OZH50n9jP9yrvlko0bc6qCB93BiR46nd6pMo0mlFNOzTpEJS43ECNNef5nLMgSoFrlfcEn5VM+DxDtAuJve7gkzuapxvprg3cJYXaTYinGW+/5yRDTi9XG2X0XAbTTXcrYs94YdzM3SK+tD2DWzLqKXzLQBxb9NFuSofWx7ypd33qzlwr7QHBbMpntEza/x8soBv9E4+CEH0pgZ9UGEJhS0yaPJ4EMMJHHaAcYCZbHAhnTl/djuxEszGdqnvIPDtRdiHG+D5KPJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tisdp2kKEjcPdwndjVqNvIo7NnR7vIS7+SxhQ0rSZT0=;
 b=NOVou8dqkFFMzPcLyTbkN5729hxI+OpiSNMZCZhqKbujTWycNZvATLxux5CyuZp0ZXFM7yiNMQGWZbWf5Inl56a8VuXf+WYeFt4su3RSakH4D7xYBB2csdg7IFzQ/cNhHpC8s3dtAzVnpjUrpGwg6ri8CuLa0WXGtRvpdRIH66M=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5391.eurprd05.prod.outlook.com (2603:10a6:803:95::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Sat, 23 May
 2020 00:41:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Sat, 23 May 2020
 00:41:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 09/13] net/mlx5: Don't maintain a case of del_sw_func being null
Date:   Fri, 22 May 2020 17:40:45 -0700
Message-Id: <20200523004049.34832-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200523004049.34832-1-saeedm@mellanox.com>
References: <20200523004049.34832-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:a03:117::19) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0042.namprd08.prod.outlook.com (2603:10b6:a03:117::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Sat, 23 May 2020 00:41:28 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 02b8838b-ab77-4f60-be1b-08d7feb208b6
X-MS-TrafficTypeDiagnostic: VI1PR05MB5391:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB53919876822B574C0F5CFB20BEB50@VI1PR05MB5391.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 0412A98A59
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ia6sx6pjZ7ROwhfEET+fcOgEfdCCbQquHzHCGQHV9IpWFdYSkChk91eGqt8gRgiPL9Y3m0YDXryOVX3uU0Jjpnzz9cxmcNPuYIOjLziO1AtmFkPK9CbyBRHdfGfZS34tAu1G2UBoUEK+jsdT8iYX7l9M9jsfnOLSWmwaXt+pXqpQGxzrr5KOZHa086nXWoDSAmteid+i3e00r9krhmEUV3UJy1fpNIvT9xA9ZqTKo0i9I4mIw+qqjv1/M6ii0JYhzc16KWwJfvTV03mk21RT8XZhJw6WX4aTcXPx5fp8zhLF1kSi3FCQ/IXErSn2Id6vrsrf92C7mnG7a/XXKfvXrM2Q79gFxd2ZojF5y4AjvX79J/0BZBYnkr5W3ijaPQ9A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(1076003)(8676002)(2616005)(956004)(4326008)(52116002)(186003)(26005)(16526019)(478600001)(6666004)(86362001)(6506007)(6512007)(107886003)(36756003)(316002)(5660300002)(8936002)(6486002)(66946007)(54906003)(66476007)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: le/rj7bpETFYrV3BOFIzg54/lFthYnA3xQiKRKKxLX6bq5bqFSLUC84090sokY9we+FJg7NFjm/QXUuqkS90eRJNuw01FiHjBCYues6fOUjg97o5zVhFMyzAYInuvPEpfm6ihcpVRjmA66M2C451n4SLknQJUFbpmUhbADipuEz40qCOMVXfKTm/M+QME12GTOYVFdDCNCgHumdbYECc84llVVgiUO6AEkkKS0bRYw+zHthxfP5+YJzP2WIaz4dnt5dXAGYmlYMpPzRwJVcSkzfJ+AmtY3jmcc5nXbqnX/6pVS/Wy6hTjwT4raPbaKJ/GCYr1L99/mINI7MR738eV5wunrz/PMbjuSfHyh26C4MjzdEN/H2t/hCXe9vnIxlah05Bs2Go5jkNc9RXp+yMHO1wQiTEy2EPeUCNq1Mj5YrlWgvWPEDet+OTO+rWUJHFDMYj6Sa7dGAHMa0mHjCtr16s6J1KwNwzLbecQzZW9zQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b8838b-ab77-4f60-be1b-08d7feb208b6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2020 00:41:30.2410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +kIQ8Rnjh7kTuMGYe1RoyQ5SHosySSVyMxoymtFlFe5AS+AvbrayoJdd7S+4rI75JXWF5CarPGd2GDUlUDBZrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5391
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

Add del_sw_func cb for root ns. Now there is no need to
maintain a case of del_sw_func being null when freeing the node.

Fixes: 2cc43b494a6c ("net/mlx5_core: Managing root flow table")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c   | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 8f62bfcf57af..02d0f94eaaad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -346,14 +346,10 @@ static void tree_put_node(struct fs_node *node, bool locked)
 		if (parent_node) {
 			down_write_ref_node(parent_node, locked);
 			list_del_init(&node->list);
-			if (node->del_sw_func)
-				node->del_sw_func(node);
-			up_write_ref_node(parent_node, locked);
-		} else if (node->del_sw_func) {
-			node->del_sw_func(node);
-		} else {
-			kfree(node);
 		}
+		node->del_sw_func(node);
+		if (parent_node)
+			up_write_ref_node(parent_node, locked);
 		node = NULL;
 	}
 	if (!node && parent_node)
@@ -2352,6 +2348,11 @@ static int init_root_tree(struct mlx5_flow_steering *steering,
 	return 0;
 }
 
+static void del_sw_root_ns(struct fs_node *node)
+{
+	kfree(node);
+}
+
 static struct mlx5_flow_root_namespace
 *create_root_ns(struct mlx5_flow_steering *steering,
 		enum fs_flow_table_type table_type)
@@ -2378,7 +2379,7 @@ static struct mlx5_flow_root_namespace
 	ns = &root_ns->ns;
 	fs_init_namespace(ns);
 	mutex_init(&root_ns->chain_lock);
-	tree_init_node(&ns->node, NULL, NULL);
+	tree_init_node(&ns->node, NULL, del_sw_root_ns);
 	tree_add_node(&ns->node, NULL);
 
 	return root_ns;
-- 
2.25.4

