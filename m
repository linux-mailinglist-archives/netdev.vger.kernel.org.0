Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB571C03C2
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgD3RVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:21:04 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:6237
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726355AbgD3RVD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:21:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evE39AlZJ7zqaE5hOMeDGbKmf+5bqSMwIBtEtSi9qjhhwMt57eQCPy4vX52YcRfoDSQkDfGszYSjXD+W476QQF6+9FZxDnuHfjTzw11LmVJbdecCRYIiFpbjoTy5kdjCAJ3bSlkHwkE+ogT8w/wfEraF7mYJM0eVe9/efeGQZ8eAeyo+XuhnQ+es6b3FUugbXWwAvwZ02SVCSwrU7QlrB5nRUp2hKaL1dI91OtcLAweb6TGbmch/m4hRllClRACtzeWfbKBGe6dqPueSs/GC88IuJxwkyZXP2Pc+FwXZzv/ZdwGLMlnGtNvJKFHfbzEh63S3HWPqRYMY+TfqPfVD3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6qHvTJhiFeX1z0nFs4BIfD05xYycC+GEEvFiL0uyQ5A=;
 b=KGGLJOxSKlYoPrS2W3SE8d5lnczFQz/4ansLdmTmKlSlpcn+QA4Q5JuCOerpwj7x6A7+b2iazpzCVjFTa/2KS75ji8QjS+WVVKV+A12t6AmYLi5d7+rXEBBb4Edrs+ZT2b6E42qrnT8REdoD3tne5rF2NbunPxYsSs6AFPy4Pnps8GIrlr0IEXEzkoESPnPffso4JBqjJ9sI5NUdBH3LFuQ8iIDn0rPIxuqsr63XL0DCC0WkFORxKJIHdme+4Zi4WhiJ2V/nFeB4IJqqfOCmL4f60u+BF8FX7KFlvChVuN8bZxAcIOdyyncYwuqdoSkixXk2Zr6riCapahP8N35vZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6qHvTJhiFeX1z0nFs4BIfD05xYycC+GEEvFiL0uyQ5A=;
 b=tIwLoNc1TTVCGqtMOqlM8zQ8fj87qhNDuqnwDV4l+5h5hH74v6bbe0IBnq5GtFlabnTc+dpw+7Y2L65QycUMHon6lmqQvtBsVHd/Mkkq+rMAInxnXfDlMzaSDxkuI4PRBwcB0BmP1JIcztTC7pYsZBT32jtGt9rRblyZtx7dCeE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3296.eurprd05.prod.outlook.com (2603:10a6:802:1c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 17:20:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 17:20:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/15] net/mlx5e: Use helper API to get devlink port index for all port flavours
Date:   Thu, 30 Apr 2020 10:18:22 -0700
Message-Id: <20200430171835.20812-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430171835.20812-1-saeedm@mellanox.com>
References: <20200430171835.20812-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 17:20:56 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7f1116fc-503f-4143-0ed0-08d7ed2ad8fc
X-MS-TrafficTypeDiagnostic: VI1PR05MB3296:|VI1PR05MB3296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB329665E366029AF7567A284FBEAA0@VI1PR05MB3296.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nTQYvk32FftuO3QpfjBA+oR6jTOtNeeyvLwAfhcuFk/SB8jnvzKaHyn+/ru71mDaw08Ap1BIAKPksdGORUNhvz8rBu7WdjuON3gKX81ZKhtlN6YROOnl5qocQlSd4KyRISGTy+qrQPMC8HXetGlRXVNNHjy8Y3XiaoqDkEJZPo7jPyadZfNkPF2jntBJBNkJVmNFGhkRFjcaIFZnxFDFkQZfl5vocOkbUy+NTh/zZGizVApXQpO3P3OKcAJxmWuK9mwqpaVzaduHrnDI02AvaQfPO0yph7b/ihtxAVR6CqqbN6TBC54gilrV8vlG8m6+ABbd3WXHXIgJRC+yWtSHDeXZjEIJElz32yksNB93Mr03Ri9PNojs7gNfgFAUrZE0wplOMsHu/Rgg+CiuM/x9N6K0VqoqUdwgntqlgEJ090AibKxf02ihVi23AgzDlITE1fnNX6KxrqNmJSV1+4/fDjkpW1fj+vBIvxGZ6Q0JTZRLap3/S3n/HxSPxZ9LnQ3Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(52116002)(6666004)(54906003)(2616005)(956004)(316002)(2906002)(478600001)(107886003)(4326008)(66946007)(86362001)(66476007)(66556008)(36756003)(6486002)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(6506007)(1076003)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xD0ymtdqhtNJxEGHL2uLU3W/yLOGTtKvnRFHnV/hYKi7mThiHttIEudjCLhePVK7LslGmdkTnFp5FHtsUgzC/ZG9bKLZTAo0hlh8vbYKqXyxJIKW6H3VVYXqCvhYB8+WFLg5CSTr36YFss7iCt9ecWw8o8venxGbQnBKcMNWrjCFZSMmPAdNYPKOpU6g4DcVfn9QyFvn2XLPbqJ/g9eUixoZIbLnDaf3GWFsiUA1mDaF67rlgyfACtqymZ/1kSJ4AGosfZ0L5wXuy7F9ykicxpYuZXSpFwDnNbLs7T+JXOec2b2MLrDUwGIH3YOmnubcg52peF4W5FLcnsS8GzoJ+AJkEAR7s4tQhh+8vNRiItPIBhSwI2ED9mRoumpR+njGr2tP8RdqSOVRG4uBcsxl2Nvs/ZeQWQMcxhk9t5D021Qh7g1dFWi9a9yhqwRtdVvZoiorWBqjPMhhNOlSEXPZdDsrHM/qeEzb5qk/go9eGYCxpEMK84ad0azHX/Fpm/B/PpwbErDKYMcxk5JzUH5zORYNYnKZw75xG1Cnlo3HAVYsgJ2iUvivq/hNNswysRgAP1bR8E5wmVxeyJfcnNekttCCtTdMDW6kXPbcUWwHy6PUFy9rr/UGrl/3d/MVQFO3nPS7YEwGIJ2xnCz+kPA5eT6XrOFl4nj0CCnJ7RgIWsGLKyGGH+N2E+gkaRw9Cog7C56pge+gSVaBFrkirE0EkvcxzMY0dJYTi9JbHMWUq2EmeY8YuIKqF5WlOWCBfuI/IXprKTMcs1Te0h9cQB1sjqnF/rsyTfRzRhmLYDEk6xk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f1116fc-503f-4143-0ed0-08d7ed2ad8fc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:20:58.5189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RFIpC8e72E2aWUWvzC+anTugZ8Mwu99fee0fKIIIC00JPro9vuE/1QRFwvi2Ls2EGa1SHJCSlP/hlagz9BhuXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Use existing helper API to get unique devlink port index for all
devlink port flavours.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 55457f268495..2de54d865dc8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -2056,26 +2056,22 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 		return 0;
 
 	mlx5e_rep_get_port_parent_id(rpriv->netdev, &ppid);
+	dl_port_index = vport_to_devlink_port_index(dev, rep->vport);
 	pfnum = PCI_FUNC(dev->pdev->devfn);
 
-	if (rep->vport == MLX5_VPORT_UPLINK) {
+	if (rep->vport == MLX5_VPORT_UPLINK)
 		devlink_port_attrs_set(&rpriv->dl_port,
 				       DEVLINK_PORT_FLAVOUR_PHYSICAL,
 				       pfnum, false, 0,
 				       &ppid.id[0], ppid.id_len);
-		dl_port_index = vport_to_devlink_port_index(dev, rep->vport);
-	} else if (rep->vport == MLX5_VPORT_PF) {
+	else if (rep->vport == MLX5_VPORT_PF)
 		devlink_port_attrs_pci_pf_set(&rpriv->dl_port,
 					      &ppid.id[0], ppid.id_len,
 					      pfnum);
-		dl_port_index = rep->vport;
-	} else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch,
-					    rpriv->rep->vport)) {
+	else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch, rpriv->rep->vport))
 		devlink_port_attrs_pci_vf_set(&rpriv->dl_port,
 					      &ppid.id[0], ppid.id_len,
 					      pfnum, rep->vport - 1);
-		dl_port_index = vport_to_devlink_port_index(dev, rep->vport);
-	}
 
 	return devlink_port_register(devlink, &rpriv->dl_port, dl_port_index);
 }
-- 
2.25.4

