Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6B323E5B0
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 04:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgHGCGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 22:06:19 -0400
Received: from mail-eopbgr140087.outbound.protection.outlook.com ([40.107.14.87]:39222
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726150AbgHGCGT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 22:06:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AuuKJEbqpLeE2k/YvomXA5gDgZpATRQ/hENkkaSI5rVrnxIO30kVaRo0rKcL/QwhaXjVpFfwoMl2ss0a2furGWC6dMgQS5lVngICJRjL+41fYnkScsrGn+lL2nnVwk7EGr79AKh1s+qUvn85iScS/8m996o0APgSmOcdc8QROLP332uqLu34q3oDicU0SzFq7sGbe44+vq5mwbz+lbYJosb8QajcQnrvB7l50+tdvHoRyAoKtc13zyyc3e+8Ibon67gMryUoWfzVld0zSqZt/lCNQJnt2ne5W6UnbAjCpmu5bX0ZulNykAYjAG6+nL4kMFUigCj2oOOQ3quZCkfMlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uk2ffGEtrwAlIyCWO2gGKd9yxjRd7mPdmoZaSYu6LSk=;
 b=g2AkH31yZOBbTJhFc6ccKD7Rraw1+vv6g+pLywUZj6gieSpZZ1AJrXn/o/b9QSyWNC0kN2AY7MGMIwDAh9MvHWizVdVP4q249yeYYR4rsBWw5/HnccjWO8V1C6JJ/NFSy7B9xMtZHHxsxk2stuW5RyhnOHEEe8g0H2tR4KwJuve7PsDbPUeLGVL9/oEgUki/U01LdPA4/af0uBwKX6YKnxPqIFwkbbsYjNHLBwbzGDL/CKqLgbCZwYsPijqgeuERYd4ZBtOpTZHYMpDdKBjzpF0viWdY9K89OPqGSU/0l/SO6ly6bkoxVnzAq0m7/jQWInH53BZPPuz79xil/Z+Otw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uk2ffGEtrwAlIyCWO2gGKd9yxjRd7mPdmoZaSYu6LSk=;
 b=XOxx+GZAZcd0BBREv5MwjynFbf4OGGBhAJanK2wo1c4qAHgE4qZ3v1CUbR6cBSkRs/a37PDRjjFHtvYLswP2+hdsBEgD3I0JXBc8WPcsFjlxuZhLtLYhydETPyXs7stfRc9Xga/fKeg7pduWn9vlqSCfPlW4HXYpy7zzKHpODuQ=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5134.eurprd05.prod.outlook.com (2603:10a6:803:ad::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 7 Aug
 2020 02:06:14 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2dde:902e:3a19:4366]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2dde:902e:3a19:4366%5]) with mapi id 15.20.3261.019; Fri, 7 Aug 2020
 02:06:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19] net/mlx5e: Don't support phys switch id if not in switchdev mode
Date:   Thu,  6 Aug 2020 19:05:42 -0700
Message-Id: <20200807020542.636290-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0020.namprd03.prod.outlook.com (2603:10b6:a03:1e0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.16 via Frontend Transport; Fri, 7 Aug 2020 02:06:12 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 07415334-e781-4f21-b837-08d83a767675
X-MS-TrafficTypeDiagnostic: VI1PR05MB5134:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB51346E05BB69EC712D7EC24BBE490@VI1PR05MB5134.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dc+sU3sfL4dWE8enh0fQdViT57axQVHWgB5QuU75T8NpLN0CZJG6KGbmbopqwSilZP7oRdlJqThx7CjER4SBJs8/8VsuT+zmCcKZRGjpHX84IWyS+ZvRKFIC+N6L0fkPeI8DNdVTkp4bMJAz8rISYYBpkMFw3LsH30E+UzAuhFFi2rjd74ZZumMLClmP3ZslFBwSsjRsAG2RP7xLTu8F/1wBOyScD9muOvdSV2jOGJYss27pFrWSHTkO9/FuY296NmoXjuRkUtYH4Nz4MB+8X+KXP68i8y0TcCQKNJXKcYv99biqquVQrSIdZedO8c497PtkgODyYpiiaMInmeX31eJchYL7bBaTBrTsi58fzTJm8s5Cog8RYz4bzjJXv8f+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(6486002)(107886003)(478600001)(54906003)(4326008)(8676002)(1076003)(316002)(2906002)(6512007)(8936002)(6666004)(26005)(2616005)(66476007)(36756003)(66556008)(5660300002)(86362001)(52116002)(83380400001)(16526019)(6506007)(956004)(66946007)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KJNzluX/i7uW/vFOHYnvOm6dMYuSS9Oq2x8YbgX/fcxzu3/uj7Mjm+cm1ph1CubtqyRuw9sWEk4i7SpmmrYYmZQ1yL6LXB3qimB5y/HK0xvYWo7ypP6h4hXGbmglfO1pTUCAkNPF3YeRmZsidRI2noUXbmi36lYhD3HyrJ+ezKlIOtYazhzlawx9KGTBDKqBvd2QSRrEgNpEakL1uTLHjechnjMvs19tPpOBF8ton0xvyla+jQuZR/8e7DB732xB2b9ow1Dbl5x0afh4yTKJ4nBuc0eY82NLBPshr1NMngOeq9SwxZ9IG+0XALpP1YJL5Y2bHgj+h3JReB3rhidfZqX9hSqokovD/20MSLVx7Sxy9V3S8STHymvqh0ZS67OJKaNPRaAzKHKRpAh0CYoC2wt2SdYFL9Y9vxJNfgc7wvxbkvlWMhb4nAmXBr8EBSs4rUtJtZYYLHvsH9v2PV2DGiIdZl0mAWxKjX+EiMcjE/3fiYrEp4aaDHovPL4pJxxdWYt3Egep2NkJHQT5vYS9/tNTyd8T0q9MsuQUDdW4yMZTG2F6kH3x/ZiaIvYcYF7N4JovZqxx5CrLiCX6HrxkTqE4jg7JDleELSe5g2y9WB33iB+YAJM9OhL6w2G8uPtj4hbwHvLjngjaGz6rhbI9yQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07415334-e781-4f21-b837-08d83a767675
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 02:06:14.5181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3tdBOBrqstFD6xbT7m982uRzve3jrbnjTx7T+k0WIqj1wzKIFVx41ZJh2vEw3ZdMfS1lRn33Uc3cfE3zRmMKbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

Support for phys switch id ndo added for representors and if
we do not have representors there is no need to support it.
Since each port return different switch id supporting this
block support for creating bond over PFs and attaching to bridge
in legacy mode.

This bug doesn't exist upstream as the code got refactored and the
netdev api is totally different.

Fixes: cb67b832921c ("net/mlx5e: Introduce SRIOV VF representors")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
Hi Greg,

Sorry for submitting a non upstream patch, but this bug is
bothering some users on 4.19-stable kernels and it doesn't exist
upstream, so i hope you are ok with backporting this one liner patch.

Thanks !!

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 701624a63d2f..1ab40d622ae1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -198,7 +198,7 @@ int mlx5e_attr_get(struct net_device *dev, struct switchdev_attr *attr)
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 
-	if (esw->mode == SRIOV_NONE)
+	if (esw->mode != SRIOV_OFFLOADS)
 		return -EOPNOTSUPP;
 
 	switch (attr->id) {
-- 
2.8.4

