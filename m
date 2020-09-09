Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1F1262679
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 06:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgIIEvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 00:51:31 -0400
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:49412
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726005AbgIIEvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 00:51:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lncguCsaorgfeRzAchJEsuVnczEtlGzGy+orKiH/cUOXzwEiVfWXc/9zAGQzQA6DEo3G5w0bvquDy9S300OqnxunqKFHhnfEBIxfNVC7aXPU/cgNL7uHf8a/hAOFIc0PjwSTGqh5IdAmHo+hl/dNLru7WfGOXGx3hii3bzlPlDCeeXRvbq2JdND8KdQyXjsA3TQ3hINixOZdnQJyP73wsLALHRlLr9qfHBXX9eAIRbchVl+0nxIcjj7Vp+LSbltajze0PafdNeaJLAJntaJGwtGlXs4ipwAq2ivTtlsWWXhawaoifb7Ubs+NJHKZwqFyW3Uyfc/zp5R5HRQALBasrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=od49ByK3BEcy6fVYstMvbFT8wPw71CAH/zmzRA71juE=;
 b=S5rMJzyZAMg558rBiHACXJtn3BdPdlSu65rDYLIe7zZB27YDiSOCatRCaPj6DXZoAhiwR/5z23p3xTNqFYYyN3dG5BfjrM/pvGt/ihkXDZB/b2X5mFCKf9Ymu/d6xqjmh+BbMCF70IvFxEmabtI8z1IFdpGqkQYpOPdpf52MyQM2WrPtwGnmlvOuZ0Gw9ftxLuaDyYHQY0pr/Rn+0sRc+jEJ772kQigsP1vXHOyBXRaM2+lgrdzUFwO0FfYvgSQHh9NCEEZI1k7DqsUAqpM4qTgnU3qJ41Wuq2oUMCUa2E7d0/98KT4JjerjBNSss81nVFJB7HZaI3pu2PpvRY4RDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=od49ByK3BEcy6fVYstMvbFT8wPw71CAH/zmzRA71juE=;
 b=OFKLupMjD4t6z2QF45XuHKpcFRNhfIYK5/lvNxd+X/InQbIyzxvivoccbsO2G3TGhtINDmGaP0Y12TkPeXSo297ASp02gW5kVQi3miJISPqQD4US/zTvdJ8xTtCDjxW2CAn9ADscvUlhdG3uZsWZiYK4VPKmjF36N2uJJSL/4RU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB5907.eurprd05.prod.outlook.com (2603:10a6:208:12c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Wed, 9 Sep
 2020 04:51:14 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18%3]) with mapi id 15.20.3370.016; Wed, 9 Sep 2020
 04:51:14 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v3 5/6] devlink: Introduce controller number
Date:   Wed,  9 Sep 2020 07:50:37 +0300
Message-Id: <20200909045038.63181-6-parav@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909045038.63181-1-parav@mellanox.com>
References: <20200825135839.106796-1-parav@mellanox.com>
 <20200909045038.63181-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR04CA0091.namprd04.prod.outlook.com
 (2603:10b6:805:f2::32) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN6PR04CA0091.namprd04.prod.outlook.com (2603:10b6:805:f2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Wed, 9 Sep 2020 04:51:12 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7b491952-6984-42fb-f00d-08d8547bfa40
X-MS-TrafficTypeDiagnostic: AM0PR05MB5907:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB5907F9B6E2BC6BAC1023772FD1260@AM0PR05MB5907.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hW6TlLLi5Chj3vU0LZvflpyVS8I09fXlb3RBzaB2tYX5cbi+cFaYktwVjV95+F3GQX66WwQI/CyUMwygdiXcimxLxMmbiyr33EmwTweHl2PVj4NsJnfVrVKEmQDGY6n9cH/pibPjeG68sh60znAp/OOARV2MOxPNZqx0SvCZlkmIkjhy8K7HxCkSJdK6GyuK+Vq4/q1ahaeKzcy0j1zXD4SgokPkpv15sHRnca0rwAa/MD+FL2JtIaqgo9kJorrRMczByDdQ8C3XF+OYl5DGL+scALlo2uCYzzabbHu6rxM0054+41J5LVSs5S0X26oN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(1076003)(86362001)(16526019)(54906003)(52116002)(4326008)(2906002)(26005)(6506007)(186003)(2616005)(316002)(508600001)(956004)(6486002)(83380400001)(8676002)(66946007)(8936002)(66556008)(66476007)(6666004)(6512007)(5660300002)(36756003)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: QPMoyvbGsYE/RHzNTnHa9ij8y8x1O+59oUAMqWakVtwaYzwHvTRTZlUju0Sqr+tq6eMG+Vext28GgojYbURI8rV7tqNLOtS29saXtfRhoRzca+5M2whoNDmURNlVGUjlbZ7VGwSuKDNsi8ksoWmOds20Lt4qPKckhFEYODXmJ3OSVy0CjPgMzr7oouLo95pyrOLXZ7/epybXwl7TofhieRUgEKlOm0Anh0vMB5q5ahHZp7OqboQ3QXPyNHGPdh4NB9NJ2ztxNghjIayPaV4BaD9DyqfaDJrOz33CZ6SXknUz13YxVKIbrusa9htbNfX0HxCVJ3UrnITL5SRo9XELbCEAKvOAVoTecW+bQrZ8F8OMv9lU+PVvEDnnNbXTVSoUOjqFK+XsVUEQlN4GDW0Cas6ppGFXsx4StGzFdVLlSlAvSp/UGWF/xlh3eUcarbxyUtuxCj457StWof5Sztt0vwQ3H03i8dCyQCI/sVebp/lBmtdtacVEzExU2PHbfY35d+iiRas3vGfWQkCpJOOf02yycDMaJ4o9W0FtZjmOSD1MCg/SdqcFwaQ+4YoedDX3LyzuDVf8z04tpxKGQ08TYabiWE/pYGa1h3Pw68pwJMGMKFmYHOEMC5ioa83uQ2I8oubcGz5PAfEQ0qHKi8w5sg==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b491952-6984-42fb-f00d-08d8547bfa40
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 04:51:13.9519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9xw7KdkqDiK3gvTGCwy4xP3TlYNXqhjwl3mbB7qcs+nGXvKHPPRSNcFqBxLms8ZBszEj4llCjUjLHnefwAjE5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5907
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

For example in below such system controller-0 and controller-1, each has
PCI PF pf0 whose eswitch ports can be present in controller-0.
These results in phys_port_name as "pf0" for both.
Similar problem exists for VFs and upcoming Sub functions.

An example view of two controller systems:

             ---------------------------------------------------------
             |                                                       |
             |           --------- ---------         ------- ------- |
-----------  |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
| server  |  | -------   ----/---- ---/----- ------- ---/--- ---/--- |
| pci rc  |=== | pf0 |______/________/       | pf1 |___/_______/     |
| connect |  | -------                       -------                 |
-----------  |     | controller_num=1 (no eswitch)                   |
             ------|--------------------------------------------------
             (internal wire)
                   |
             ---------------------------------------------------------
             | devlink eswitch ports and reps                        |
             | ----------------------------------------------------- |
             | |ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 |ctrl-0 | |
             | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN | |
             | ----------------------------------------------------- |
             | |ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 |ctrl-1 | |
             | |pf1    | pf1vfN | pf1sfN | pf1    | pf1vfN |pf0sfN | |
             | ----------------------------------------------------- |
             |                                                       |
             |                                                       |
             |           --------- ---------         ------- ------- |
             |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
             | -------   ----/---- ---/----- ------- ---/--- ---/--- |
             | | pf0 |______/________/       | pf1 |___/_______/     |
             | -------                       -------                 |
             |                                                       |
             |  local controller_num=0 (eswitch)                     |
             ---------------------------------------------------------

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
v2->v3:
 - Updated diagram to get rid of controller 'A' and 'B'
 - Kept ports of single controller together in diagram
 - Updated diagram for pf1's VF and SF and its ports
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

