Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501AF26132F
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 17:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgIHPHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 11:07:05 -0400
Received: from mail-eopbgr80057.outbound.protection.outlook.com ([40.107.8.57]:47842
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729655AbgIHPEX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 11:04:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mR+2cP3aPRlWXmc2mNBu+NS6EnGfj0YCW8rCNpvAsOPeHFM20fAMUc9cYfd3TWms0ZRAZYwIMwvb6TlMPiDryA4VQ+z8wdtNeSbIepqt4WNJ0Tp32RCKmDJkzSfaXD8pFmPubRFH4tcQNzhxd4PqEQs7FDUBhYPSUjydDU0mTPGVJabNCC/TgAYGI7zTP2za4mekzujg/rwUkREMZaIja1LcUq5Zf7xAAICYR7L14yWBsNOSHXTc8IAg+Ao5no3POQya5gh3ZKlEmrH30R/bBG1zkg91n4hZL4r4+oLWYYs8gp4lSLybwQAJOUmT0XRRESYYvnRXHBNmljbiwkD6ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qpVjFbR98z1LVEi0xBlZRiuK0jIO11oda11lCjhEGbI=;
 b=RE1r8beJu9eqCFblSBXdO3Hmm3j8xIVePV3g2pHp4oePhhUsEfGmK8hIj4YW94R2yZvzW44UzO0btAfH51BItc681+EZgQOB+b1i8My39P3DzhP5KsrOrKQK9dKNNoQqU3pn8QXNoUKG2AQY1OJUZLWcDmNwGkaOatKphwAsmFV99teMLzm0FixD+sZrVqGiswFpWn3Ndq66v91iKs5gPDunn8n+GF7CwC18Gh3IqHhliHA8Qr99gWaaCJ2VURQ8a4jdavEAimACJhcfp5qc6Ky7u8zdK/yoFEQAXhybRvAc6wkN2gqic15jy+/9AQEOyvjo0ciLyExo9JHWMi0X9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qpVjFbR98z1LVEi0xBlZRiuK0jIO11oda11lCjhEGbI=;
 b=dgc/VnBUPyH2O6B4COZ873u9er7KjjgTxmlHChjFwiqm9BjI3LpZIDKMwIdRvTeRSR5FBx3kCVsC72nUUS7R2O90KyJ+gadlk/oj4lJRIDeNgZTbnzcda1z4DcEEvmbGlqn4VNdF03F40Uc7IypgBLyG4MvvrdRwgwZsPjHK6nM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM8PR05MB7331.eurprd05.prod.outlook.com (2603:10a6:20b:1dd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 8 Sep
 2020 14:43:19 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18%3]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 14:43:18 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 5/6] devlink: Introduce controller number
Date:   Tue,  8 Sep 2020 17:42:40 +0300
Message-Id: <20200908144241.21673-6-parav@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908144241.21673-1-parav@mellanox.com>
References: <20200825135839.106796-1-parav@mellanox.com>
 <20200908144241.21673-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0020.namprd11.prod.outlook.com
 (2603:10b6:806:6e::25) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SA9PR11CA0020.namprd11.prod.outlook.com (2603:10b6:806:6e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 8 Sep 2020 14:43:17 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2dcfaf8a-672d-4898-9ea8-08d85405867a
X-MS-TrafficTypeDiagnostic: AM8PR05MB7331:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM8PR05MB7331667CCE5689BF76FF1F68D1290@AM8PR05MB7331.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hoRRuAzb6xI42x7uHF4yaFwEri73GkaGyXU9St6vVP4Qy7TKAnXPVQ899VYeLk7Q9nSsZfPii5BKNw1pnVcTV0KT8CpB+rwMUQxfhYLNqAAaUGExjdyRwfjlWJ2k+AGcU1UOqEo//MGgZ8Z3rD42OEFVFDtM2j+cG0MJPBad8hYxMryVnglGWkK+GYzw11SLND5isbpiU4Sfy4TvPQQeInStcNYXRECdSn8G6N/QuUWvzM4iHbbc3KVQquexBEBUNy7f+dhyIcUWzNbeXyD1fGsGOoOeDwSPM1LA1Re72SYdrLiq9aRy0bjK+GOs+vAl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(8676002)(5660300002)(66476007)(66946007)(66556008)(30864003)(2906002)(36756003)(2616005)(956004)(54906003)(186003)(8936002)(86362001)(498600001)(16526019)(6506007)(83380400001)(26005)(6486002)(1076003)(52116002)(6666004)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /TIZTZgsbrTAuAc5X7L8St58FRRrxF9fePHLTFHgtlNWA+qZTevw3ewtfLbC0QgwFiN7dHvQB5ryZCUDriNkk88e5dquPXqGqdndGMSlwtuxqmXnaFSRY1dadkm9/L5R4do6sAhZ1daNaW+b8NB2HaJp26PywYUFdKQI6Ne3QSY5w51QRdaN6GNoD0f4+y9uFRM2WS56zxsyzZ85piFmCICebjYo5pSWD5IC9jXrF/KM3BAxYJEMGENhVLRs+eWP8JOxnm22U6wXVMd5t4UAzOghQHO57he+n4VLPnm+MpzNeswbmeCzUT/fCwtdp8GHKoee+FGhH59PDz3EqObreakSQt3yzn1qJttMWMScUntX4JlZ928dTc7L7wvZzkMahPOck+Qg1tNBkU9bPF2ikMruRDwLxe7sUboOe1TUD7glkrKn/Oe/kxUmjGnC6HGHZ5HjMpKQ3JAylTGo1tdu4/75JieDZAAeURO2luXt1a4m+eNwRTsWlwPlTkjuyrwylb62IbQnidRIdJVjfMGLGSwijZ5cM3xSAXOCvy47FxfMNADF0IULisYBnkULXwxfpTinm1MwImhO46Z6p1VJvjDv49HJxKIdgyprA9jsDGS8wYC37409ivLuf+Z8S5HMl5esV5Us3/fzREPsmPJV3A==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dcfaf8a-672d-4898-9ea8-08d85405867a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2020 14:43:18.7323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VptlJbKqR4RbQhLAYSX8tw3OFIqI+oSDSJVzO0jHoHtfIdOufDq4AsnPF9ElLzM+f6FJW0gWCWLzlvIGVURtTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR05MB7331
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

A devlink port may be for a controller consist of PCI device.
A devlink instance holds ports of two types of controllers.
(1) controller discovered on same system where eswitch resides
This is the case where PCI PF/VF of a controller and devlink eswitch
instance both are located on a single system.
(2) controller located on external host system.
This is the case where a controller is located in one system and its
devlink eswitch ports are located in a different system.

When a devlink eswitch instance serves the devlink ports of both
controllers together, PCI PF/VF numbers may overlap.
Due to this a unique phys_port_name cannot be constructed.

For example in below such system controller-A and controller-B, each has
PCI PF pf0 whose eswitch ports are present in controller-A.
These results in phys_port_name as "pf0" for both.
Similar problem exists for VFs and upcoming Sub functions.

An example view of two controller systems:

                -----------------------------------------------------
                |                                                   |
                |           --------- ---------                     |
-------------   |           | vf(s) | | sf(s) |                     |
| server    |   | -------   ----/---- ---/-----  -------            |
| pci rc    |=====| pf0 |______/________/        | pf1 |            |
| connection|   | -------                        -------            |
-------------   |     | controller-B (no eswitch) (controller num=1)|
                ------|----------------------------------------------
                (internal wire)
                      |
                -----------------------------------------------------
                |  devlink eswitch ports and reps                   |
                |  ---------------------------------------------    |
                |  |ctrl-A | ctrl-B | ctrl-A | ctrl-B | ctrl-B |    |
                |  |pf0    | pf0    | pf0vfN | pf0vfN | pf0sfN |    |
                |  ---------------------------------------------    |
                |                                                   |
                |           ---------                               |
                |           | sf(s) |                               |
                | -------   ---/-----    -------                    |
                | | pf0 |_____/          | pf1 |                    |
                | -------                -------                    |
                |                                                   |
                |  local controller-A (eswitch) (controller num=0)  |
                -----------------------------------------------------

An example devlink port for external controller with controller
number = 1 for a VF 1 of PF 0:

$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev ens2f0pf0vf1 flavour pcivf controller 1 pfnum 0 vfnum 1 external true splittable false
  function:
    hw_addr 00:00:00:00:00:00

$ devlink port show pci/0000:06:00.0/2 -jp
{
    "port": {
        "pci/0000:06:00.0/2": {
            "type": "eth",
            "netdev": "ens2f0pf0vf1",
            "flavour": "pcivf",
            "controller": 1,
            "pfnum": 0,
            "vfnum": 1,
            "external": true,
            "splittable": false,
            "function": {
                "hw_addr": "00:00:00:00:00:00"
            }
        }
    }
}

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
Changelog:
v1->v2:
 - Added text diagram of multiple controllers
 - Updated example for a VF
 - Addressed comments from Jiri and Jakub
 - Moved controller number attribute to PCI port flavours
   This enables to better, hirerchical view with controller and its
    PF, VF numbers
 - Split 'external' and 'controller number' attributes as two
   different attributes
 - Merged mlx5_core driver to avoid compiliation break
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  9 ++++++--
 include/net/devlink.h                         |  9 ++++++--
 include/uapi/linux/devlink.h                  |  1 +
 net/core/devlink.c                            | 23 +++++++++++--------
 4 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 5b3599caa007..135ee26881c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1210,11 +1210,13 @@ is_devlink_port_supported(const struct mlx5_core_dev *dev,
 static int register_devlink_port(struct mlx5_core_dev *dev,
 				 struct mlx5e_rep_priv *rpriv)
 {
+	struct mlx5_esw_offload *offloads = &dev->priv.eswitch->offloads;
 	struct devlink *devlink = priv_to_devlink(dev);
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
 	struct devlink_port_attrs attrs = {};
 	struct netdev_phys_item_id ppid = {};
 	unsigned int dl_port_index = 0;
+	u32 controller_num = 0;
 	bool external;
 	u16 pfnum;
 
@@ -1222,6 +1224,8 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 		return 0;
 
 	external = mlx5_core_is_ecpf_esw_manager(dev);
+	if (external)
+		controller_num = offloads->host_number + 1;
 	mlx5e_rep_get_port_parent_id(rpriv->netdev, &ppid);
 	dl_port_index = mlx5_esw_vport_to_devlink_port_index(dev, rep->vport);
 	pfnum = PCI_FUNC(dev->pdev->devfn);
@@ -1234,11 +1238,12 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 	} else if (rep->vport == MLX5_VPORT_PF) {
 		memcpy(rpriv->dl_port.attrs.switch_id.id, &ppid.id[0], ppid.id_len);
 		rpriv->dl_port.attrs.switch_id.id_len = ppid.id_len;
-		devlink_port_attrs_pci_pf_set(&rpriv->dl_port, pfnum, external);
+		devlink_port_attrs_pci_pf_set(&rpriv->dl_port, controller_num,
+					      pfnum, external);
 	} else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch, rpriv->rep->vport)) {
 		memcpy(rpriv->dl_port.attrs.switch_id.id, &ppid.id[0], ppid.id_len);
 		rpriv->dl_port.attrs.switch_id.id_len = ppid.id_len;
-		devlink_port_attrs_pci_vf_set(&rpriv->dl_port,
+		devlink_port_attrs_pci_vf_set(&rpriv->dl_port, controller_num,
 					      pfnum, rep->vport - 1, external);
 	}
 	return devlink_port_register(devlink, &rpriv->dl_port, dl_port_index);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 2dad8c9151f4..eaec0a8cc5ef 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -59,21 +59,25 @@ struct devlink_port_phys_attrs {
 
 /**
  * struct devlink_port_pci_pf_attrs - devlink port's PCI PF attributes
+ * @controller: Associated controller number
  * @pf: Associated PCI PF number for this port.
  * @external: when set, indicates if a port is for an external controller
  */
 struct devlink_port_pci_pf_attrs {
+	u32 controller;
 	u16 pf;
 	u8 external:1;
 };
 
 /**
  * struct devlink_port_pci_vf_attrs - devlink port's PCI VF attributes
+ * @controller: Associated controller number
  * @pf: Associated PCI PF number for this port.
  * @vf: Associated PCI VF for of the PCI PF for this port.
  * @external: when set, indicates if a port is for an external controller
  */
 struct devlink_port_pci_vf_attrs {
+	u32 controller;
 	u16 pf;
 	u16 vf;
 	u8 external:1;
@@ -1219,8 +1223,9 @@ void devlink_port_type_ib_set(struct devlink_port *devlink_port,
 void devlink_port_type_clear(struct devlink_port *devlink_port);
 void devlink_port_attrs_set(struct devlink_port *devlink_port,
 			    struct devlink_port_attrs *devlink_port_attrs);
-void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u16 pf, bool external);
-void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port,
+void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u32 controller,
+				   u16 pf, bool external);
+void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 controller,
 				   u16 pf, u16 vf, bool external);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 40823ed7e05a..40d35145c879 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -459,6 +459,7 @@ enum devlink_attr {
 	DEVLINK_ATTR_PORT_SPLITTABLE,			/* u8 */
 
 	DEVLINK_ATTR_PORT_EXTERNAL,		/* u8 */
+	DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,	/* u32 */
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6f5f85372721..9cf5b118253b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -523,17 +523,18 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 		return -EMSGSIZE;
 	switch (devlink_port->attrs.flavour) {
 	case DEVLINK_PORT_FLAVOUR_PCI_PF:
-		if (nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER,
-				attrs->pci_pf.pf))
+		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,
+				attrs->pci_pf.controller) ||
+		    nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER, attrs->pci_pf.pf))
 			return -EMSGSIZE;
 		if (nla_put_u8(msg, DEVLINK_ATTR_PORT_EXTERNAL, attrs->pci_pf.external))
 			return -EMSGSIZE;
 		break;
 	case DEVLINK_PORT_FLAVOUR_PCI_VF:
-		if (nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER,
-				attrs->pci_vf.pf) ||
-		    nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_VF_NUMBER,
-				attrs->pci_vf.vf))
+		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,
+				attrs->pci_vf.controller) ||
+		    nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER, attrs->pci_vf.pf) ||
+		    nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_VF_NUMBER, attrs->pci_vf.vf))
 			return -EMSGSIZE;
 		if (nla_put_u8(msg, DEVLINK_ATTR_PORT_EXTERNAL, attrs->pci_vf.external))
 			return -EMSGSIZE;
@@ -7719,10 +7720,12 @@ EXPORT_SYMBOL_GPL(devlink_port_attrs_set);
  *	devlink_port_attrs_pci_pf_set - Set PCI PF port attributes
  *
  *	@devlink_port: devlink port
+ *	@controller: associated controller number for the devlink port instance
  *	@pf: associated PF for the devlink port instance
  *	@external: indicates if the port is for an external controller
  */
-void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u16 pf, bool external)
+void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u32 controller,
+				   u16 pf, bool external)
 {
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
@@ -7731,7 +7734,7 @@ void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u16 pf, bo
 				       DEVLINK_PORT_FLAVOUR_PCI_PF);
 	if (ret)
 		return;
-
+	attrs->pci_pf.controller = controller;
 	attrs->pci_pf.pf = pf;
 	attrs->pci_pf.external = external;
 }
@@ -7741,11 +7744,12 @@ EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_pf_set);
  *	devlink_port_attrs_pci_vf_set - Set PCI VF port attributes
  *
  *	@devlink_port: devlink port
+ *	@controller: associated controller number for the devlink port instance
  *	@pf: associated PF for the devlink port instance
  *	@vf: associated VF of a PF for the devlink port instance
  *	@external: indicates if the port is for an external controller
  */
-void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port,
+void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 controller,
 				   u16 pf, u16 vf, bool external)
 {
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
@@ -7755,6 +7759,7 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port,
 				       DEVLINK_PORT_FLAVOUR_PCI_VF);
 	if (ret)
 		return;
+	attrs->pci_vf.controller = controller;
 	attrs->pci_vf.pf = pf;
 	attrs->pci_vf.vf = vf;
 	attrs->pci_vf.external = external;
-- 
2.26.2

