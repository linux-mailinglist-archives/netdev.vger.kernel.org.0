Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D67222FA3
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgGQAEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:04:50 -0400
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:58740
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725958AbgGQAEt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 20:04:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWfW0EE1BYofe3XzntKwUhkVcwDG5Ye1dlmSABdjCsiTvckx6jAVFtHZSEOGOsQVqZvclDkZhvPndQWqqy0B1F2fXLFU8/99Qe2jiNh2FCwjqr+7nPz+FrUthzLMNG9vDyAp4Po155wY0oW3xY763EzUjSOOrXefEctdLdV70p8BBFtasNK/jK5qf2ttHsNENu6x0P9DRhMLQWDWcyajlGSrUzEEFXHjVWZOkki8FXKsC9LQGBiCd35cZGLIaqMlVp/CBnv3uC+mx3O/mulHvFNtmuPW0N1xHapB6BPfjyxuqriFbJpR+9f560iCG3eBFIc1+C5YzHZmFM0l6zQmWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nmn2hXMzJajtfEpVY5QDDQBT4BUAfZUgDrIIKKjiP8s=;
 b=InsekWEGydfV1u5MN2+fZaDXXrbOCbvebO2uvImTjzuP4baV5J5HtI92MQhvku/DF61SL19E9F1gpnWo2HLbMDxuUj5dFMkPikIW9GyEDNqNQqSYSxrCEe6kAPXiDt3FeBSSPYPMOh03ZnuTkO8pgYgq4GFWvWZftmmTDUbVzAqs3kpHf8O/1UPUXqUrmQbGCuBqyObvElfmK+oO1JCtPYNDtjzw6zyGBbm17vzOGD/Rje43fZ6rvlq/l+OMZaJYxQVJMyHAT+S2pbdrp1IecvC3LzupIXRamedNZF1Hfu8tSMVBBRlbYbt+5w/4CvQwnVMw46jPzK063z6D+v0otA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nmn2hXMzJajtfEpVY5QDDQBT4BUAfZUgDrIIKKjiP8s=;
 b=o4N9G6mK1zj4FM0SoWOJbCXdKkMDBNY+h/LC8oLM4ZgQ9zGQWy8obn8uHm/5i3T7dHHP7HFTHk+9csKHFKfXfdO+jdi93fHuJBrF7p8Ji6QdTYfQGMXwjsdyzau7v8uLqN8PWPkPc+3CwILmJmQvDgNbLjdkJF0XPDpe1LaWwfc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 17 Jul
 2020 00:04:33 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Fri, 17 Jul 2020
 00:04:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 01/15] net/mlx5e: Fix missing switch_id for representors
Date:   Thu, 16 Jul 2020 17:03:56 -0700
Message-Id: <20200717000410.55600-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200717000410.55600-1-saeedm@mellanox.com>
References: <20200717000410.55600-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0008.namprd05.prod.outlook.com (2603:10b6:a03:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9 via Frontend Transport; Fri, 17 Jul 2020 00:04:31 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e25c1971-4c0e-4438-3f7b-08d829e4fbef
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB24481FE87ADB032192829AAFBE7C0@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NefdLkt+vvPCHzjTpTGaQU2F7zvRMpg+vQnq3Q1ZV5SQPkrcZqdPHn9k/ZNIVV4QUIe15dJNH33iWWSitj4pR/rFB7xaSiOFtNcNJXmsDxUDUgS7ZMvegDPOeDrkDblw4oqNuGsFpFdznt4AZJ+8zFQmyNtp+E85djEXn3x+KJAURnATk/t5Ktsjfah4TSWmC3c41Ivj+Py7e3tZTkp3JuyRYARV5Y8XEeXcWeuKz2hkbmbIODfIIGI/zQAVYKrtq9wp3H1Y9nLo7kg+lT7lD/EpTnjMHtG4gV8e0JoHCRlmXO/3t8ndhK4fL8yH3C7pWbUL0LRRZOLwUM46MSSjlpaTHQEdhQAB933lsJwwR1c+Aige4zI3TX7+b116Vm1Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(6506007)(66476007)(316002)(66946007)(66556008)(6512007)(107886003)(4326008)(2906002)(478600001)(86362001)(956004)(83380400001)(2616005)(36756003)(6666004)(52116002)(8676002)(26005)(5660300002)(16526019)(8936002)(1076003)(110136005)(6486002)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IjZdEC+d/J3Y8z0m7yOhI911cgD2/5gUkdEY4RxpKwu4cHsCjd7Pz1gGZT0JXBoarKW3VXuowp3LuUyg4k8x88aHcBej7obFsgYFWyyEhy6oZPfqpJfI/1psFyVl7hDSwe6KXuUQI5qhZmtb59gYdX2jR7k0Qq19TLL4XEjjf3PaCJVa9uyGl5LbveoVNtgOA1hiz8bxFv1a9VUp90Yot8nRpzcXtRl7GEl5y/FwBu/1xe3ZcQ2CiIryGKTnLsmldpk5LKIN+D99vM3kqoMP/ZshUQQxtGLb/xDkL/PuqYBX7GOQ0Du0cbHfMe3iSBQwOW4oRsNzb7WaEAWzVUWAQ8i/LfE/WLm6pT+Qf72kyjDDcmC6wkLddHGBdcsCmM20PPuz+vyVqJqBRpps+YFv4SiAvDNcHrr9e/Z4DxFUk4aoErbuFOirPM1+XbKoqT6+FvuPd9m9fCv46kmOZudkakjV1QFJ7BW1GQSTygvy9Sg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e25c1971-4c0e-4438-3f7b-08d829e4fbef
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2020 00:04:33.0797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vUtOqjQCv116vlSdjKrQBQpAHHoL+JAm/3EsKsaGs8Ssj4P0y8PgoZv/pCR/QRrAsxuWnrYghwGMFyozhrdJ0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Cited commit in fixes tag missed to set the switch id of the PF and VF
ports. Due to this flow cannot be offloaded, a simple command like below
fails to offload with below error.

tc filter add dev ens2f0np0 parent ffff: prio 1 flower \
 dst_mac 00:00:00:00:00:00/00:00:00:00:00:00 skip_sw \
 action mirred egress redirect dev ens2f0np0pf0vf0

Error: mlx5_core: devices are not on same switch HW, can't offload forwarding.

Hence, fix it by setting switch id for each PF and VF representors port
as before the cited commit.

Fixes: 71ad8d55f8e5 ("devlink: Replace devlink_port_attrs_set parameters with a struct")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 0a69f10ac30c9..c300729fb498e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1196,18 +1196,22 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 	mlx5e_rep_get_port_parent_id(rpriv->netdev, &ppid);
 	dl_port_index = mlx5_esw_vport_to_devlink_port_index(dev, rep->vport);
 	pfnum = PCI_FUNC(dev->pdev->devfn);
-	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
-	attrs.phys.port_number = pfnum;
-	memcpy(attrs.switch_id.id, &ppid.id[0], ppid.id_len);
-	attrs.switch_id.id_len = ppid.id_len;
-	if (rep->vport == MLX5_VPORT_UPLINK)
+	if (rep->vport == MLX5_VPORT_UPLINK) {
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+		attrs.phys.port_number = pfnum;
+		memcpy(attrs.switch_id.id, &ppid.id[0], ppid.id_len);
+		attrs.switch_id.id_len = ppid.id_len;
 		devlink_port_attrs_set(&rpriv->dl_port, &attrs);
-	else if (rep->vport == MLX5_VPORT_PF)
+	} else if (rep->vport == MLX5_VPORT_PF) {
+		memcpy(rpriv->dl_port.attrs.switch_id.id, &ppid.id[0], ppid.id_len);
+		rpriv->dl_port.attrs.switch_id.id_len = ppid.id_len;
 		devlink_port_attrs_pci_pf_set(&rpriv->dl_port, pfnum);
-	else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch, rpriv->rep->vport))
+	} else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch, rpriv->rep->vport)) {
+		memcpy(rpriv->dl_port.attrs.switch_id.id, &ppid.id[0], ppid.id_len);
+		rpriv->dl_port.attrs.switch_id.id_len = ppid.id_len;
 		devlink_port_attrs_pci_vf_set(&rpriv->dl_port,
 					      pfnum, rep->vport - 1);
-
+	}
 	return devlink_port_register(devlink, &rpriv->dl_port, dl_port_index);
 }
 
-- 
2.26.2

