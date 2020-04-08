Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C068D1A2C09
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 00:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgDHWwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 18:52:07 -0400
Received: from mail-vi1eur05on2077.outbound.protection.outlook.com ([40.107.21.77]:45409
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726492AbgDHWwF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 18:52:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FeEGlXz+RupdCWzdT6yp3sUQEkCwNnUFJ3oSVkbLnNs8YkQlkwNL+slEncQ4W3f8wkjo1f+hSU0Q4ospKDvPYP6vVR5O9yN/xXLYPt9Rm+Lh5x8HTIp/G8aI7PvP4qipoOxqExWfIS/4JosPB5sJxPwoSu5IYzmNJaFi+AEbY1Ze0F4Qzgs+oZXlt678K8SaNWGtAk7FBLdRz8OIGhwBSPmGfvs76gkBVnFWZ19BXg++DCL5ZNwFuRTCW2oEslo+gkTamPWC/SI7/7lOpjRK8Xt0wmpNmRNc1hjar8qolSqolJruF6epgg/nYv7Fwqrpk9XzUW7sEmmwDjwoqR9WEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFYUKHU7HYu8XusIN36ngeu0Q3kbZU7Ou99DqhWtLQ8=;
 b=AbMpEJt0t1NBgDkIs0o5kjfsWED/u9TMevL1Qw327VYC3IeRlqMExMF2kG8mcKdKOAVmk6VIuekX+XmEfEX9Grf3ZQGjK25MvDitOitgmA5LYM/JvEPBK+GMvqCDmLC7Oo2/cS1xjSJSyMB4EDS12wD14GG+CL6l2L414zHJ9YA0ieucpsX9sJ7nvx7+fCeLj5q8EarxyCXEfdMEuMLirHmoyryorMp4Tnt9cNqImnvuYgw3k6AL/8ixRjuqGQyC3GZAXb2HSX8LjeQyxnq8X35ek7yikXxCHE9vZD4yNwO4+Ed/USywl3C44yH1f7Kx+o/SCUyNTB+mkUSaxVIJLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFYUKHU7HYu8XusIN36ngeu0Q3kbZU7Ou99DqhWtLQ8=;
 b=gAONZUM52TkYpftYRsPQQmhLfsXMx2QffASiJOCU0uNyXdr2lPxZmRpmdw9Ge5OxXeEs6WjVKPPQXRXMRIqoez7BNHFyg8rpNbTIbUQb145V0wGxy1ApRmUABe+xDrMnYmAAUUXevo42j4m1sCMSjj/nYVaYuAhCjommGpamw10=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6365.eurprd05.prod.outlook.com (2603:10a6:803:f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Wed, 8 Apr
 2020 22:51:53 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Wed, 8 Apr 2020
 22:51:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 6/8] net/mlx5e: Fix pfnum in devlink port attribute
Date:   Wed,  8 Apr 2020 15:51:22 -0700
Message-Id: <20200408225124.883292-7-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0026.namprd06.prod.outlook.com (2603:10b6:a03:d4::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Wed, 8 Apr 2020 22:51:52 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aba2feb0-0c47-45f7-468f-08d7dc0f6eb4
X-MS-TrafficTypeDiagnostic: VI1PR05MB6365:|VI1PR05MB6365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB636539586E6F5000BFF211D9BEC00@VI1PR05MB6365.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(376002)(39850400004)(366004)(396003)(16526019)(956004)(6486002)(26005)(316002)(478600001)(54906003)(6916009)(4326008)(2616005)(107886003)(186003)(66946007)(5660300002)(8936002)(81156014)(36756003)(86362001)(8676002)(66476007)(1076003)(66556008)(6506007)(81166007)(6512007)(2906002)(52116002)(6666004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: js9UlRk2tOCJK158VlniCNJ/0hq4UgrC8vSQO7JueFAsxoOYML6gEgBFUH2eL+AvDyFwk1sbApshYtP2xelWm9CNN8HPlXYrObAMU1OKaCDT9vlFFhleEjXM3xm/vqGEkRz/FxqqYZmRcYdkVwH3a8X3gIM+HfY1pA1QGTr2JIjXwoYW/Quu7c2KK+F79vlD9nIUuISQtgbytSFFP9FW7fMdl9RxK9Ctsra0eZGd5114Jgh6d3nfVEs9DaH6F4117+QYb0KsHwEk49VTr1DGDWO+UPo0VOftkYFF4IenVhrW8T8aEywMsBEYSx8wTS2xq+6Gn6c4i8lO6Aw+TUBsb3oGAqzWpUBsOTbL9NClx6+WsnsTaHxk/GTGLFmBBW/0miRPTFShcre6hlV2ghHzzORGjjYUrj8dH9/IfQOblfDf2Ingp1pkpcG29QqOkd46tPNuJmS6oO1eUY4bRR2d648AMUb3b0UEz3/uaTmk35XWHjr5WHUWmqdTL6NLJUSD
X-MS-Exchange-AntiSpam-MessageData: ag3+ork8KIvh/0jQPEGi6QYIl3wJNb4iDHltDYE2w9K6iX8EV3V8otU9mbwBoidZ1OAUDaGe1fkD7QolwDE+0ZV/4CndACZEanjLjMI/cXUbdvb/6J6CPQ0ONZXF0rs6qq8m2qoUiir7UG6sMjpe6g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aba2feb0-0c47-45f7-468f-08d7dc0f6eb4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2020 22:51:53.7871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBQLWrCvoJ5AsBYpbYwIXx4g355vnfXVPCqtWVMK7JWoRtJvIzMaEZuc5IFmKbdoRL6cb+5IPiDQAvdyGTyTHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6365
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Cited patch missed to extract PCI pf number accurately for PF and VF
port flavour. It considered PCI device + function number.
Due to this, device having non zero device number shown large pfnum.

Hence, use only PCI function number; to avoid similar errors, derive
pfnum one time for all port flavours.

Fixes: f60f315d339e ("net/mlx5e: Register devlink ports for physical link, PCI PF, VFs")
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 2a0243e4af75..55457f268495 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -2050,29 +2050,30 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
 	struct netdev_phys_item_id ppid = {};
 	unsigned int dl_port_index = 0;
+	u16 pfnum;
 
 	if (!is_devlink_port_supported(dev, rpriv))
 		return 0;
 
 	mlx5e_rep_get_port_parent_id(rpriv->netdev, &ppid);
+	pfnum = PCI_FUNC(dev->pdev->devfn);
 
 	if (rep->vport == MLX5_VPORT_UPLINK) {
 		devlink_port_attrs_set(&rpriv->dl_port,
 				       DEVLINK_PORT_FLAVOUR_PHYSICAL,
-				       PCI_FUNC(dev->pdev->devfn), false, 0,
+				       pfnum, false, 0,
 				       &ppid.id[0], ppid.id_len);
 		dl_port_index = vport_to_devlink_port_index(dev, rep->vport);
 	} else if (rep->vport == MLX5_VPORT_PF) {
 		devlink_port_attrs_pci_pf_set(&rpriv->dl_port,
 					      &ppid.id[0], ppid.id_len,
-					      dev->pdev->devfn);
+					      pfnum);
 		dl_port_index = rep->vport;
 	} else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch,
 					    rpriv->rep->vport)) {
 		devlink_port_attrs_pci_vf_set(&rpriv->dl_port,
 					      &ppid.id[0], ppid.id_len,
-					      dev->pdev->devfn,
-					      rep->vport - 1);
+					      pfnum, rep->vport - 1);
 		dl_port_index = vport_to_devlink_port_index(dev, rep->vport);
 	}
 
-- 
2.25.1

