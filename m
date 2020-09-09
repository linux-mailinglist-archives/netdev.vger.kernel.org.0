Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B270262676
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 06:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgIIEvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 00:51:18 -0400
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:49412
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725948AbgIIEvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 00:51:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oN0ku2hU2ZNjyi3NDcSa0HB94Q18yd6XJ57RxLieRvMBlSBNrF1uTF4ujjFeVwulIiIaSV0+jnETD9ZM0fhCLy4aGo9db65zJGrV2KFnrqrH/UBPJWZMUAcAiiRynEPzgGOZJ8Vq7qY/aezPU98C6LTaYLhgHdYakQAvuebB42bqWG6S9kPLFh0ff3s7ufmevQEAEAitoNHV4dGlSl5cka9XzjiQUtduZCvN7Tmti2oAy9dv5r+6SIuhbUsm8+XCVA9V7cHM1dqlwdxy4dKQBbMQT0+SZVTY6p9b+dR7H8WoVnMQ+qVpvrzfn6WXmN8itgejj2tIeLHkCCPaLt9A+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7gqZAl2HSpIB7nRQ94eh+jmaK9JClNcuBtRTmPhfa0=;
 b=gPG+PJdqvFpp8DzHO7e8l38YssbZeTGEbW7oNSLrV0t6a2gg/k1yVQxOFPhmtzoOWFmybCPpFhWntOi/y17PJU2irty30DHM3a2OzRku6hxp6QsnvjkIMJrtimDkd8xg4aR0tn5DOTEUcOzApvvNGGH9OUYYobeydQ9UJOOI/+Au1NezHOotKAYjgGUEAbWNJb+3RosjVeGTDUhYfELPegtlv5JBiCp80gRMpEruscmXD09utJpirpxfvZvFtEeExKhlHbOYau3pIAv1mwm16hQx3E0iKxAbvEpnvqVhenMl1PoRLI+eCDIbOTTmXT+L+6Cph28mfw3zc30WwwHLiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7gqZAl2HSpIB7nRQ94eh+jmaK9JClNcuBtRTmPhfa0=;
 b=MmWQLAXBm5JlwR3pcRDr9Kw248rPrd3ElYJfp4TjpyCxaZBOXUNXZehLkyLvUIOBRvHyRLpQxrNeLJKO1XhL/YhBWLGSDm09ENzPtPAo5wDiqcppUXIm/IFHx1D51RgS59S50Jg7KvTsW9wWKOHZpL0GE0qJJujzr7vdrP25Lcg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB5907.eurprd05.prod.outlook.com (2603:10a6:208:12c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Wed, 9 Sep
 2020 04:51:11 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18%3]) with mapi id 15.20.3370.016; Wed, 9 Sep 2020
 04:51:11 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v3 4/6] devlink: Introduce external controller flag
Date:   Wed,  9 Sep 2020 07:50:36 +0300
Message-Id: <20200909045038.63181-5-parav@mellanox.com>
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
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN6PR04CA0091.namprd04.prod.outlook.com (2603:10b6:805:f2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Wed, 9 Sep 2020 04:51:10 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4972d121-ae1a-4c90-578a-08d8547bf90d
X-MS-TrafficTypeDiagnostic: AM0PR05MB5907:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB5907B481C9E31C733D2F9F69D1260@AM0PR05MB5907.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ChroVQ5BCJTi2DPspGc1ftZdK8plCpFrMnFIBMtAXhuzmaZ4HeqPDrGKX/TGc0TU3V+Ttpi70vsLv4KhlJ8IhcgcHR9Fj7ytR7KJjj21kKMnWy1t07jk7Fl8DSGT9w5mo9bgCivSl7vf3zNQAw0K8U5saGOMh/PTSkiTbE8Yy0pBwpCFlPtN0AO1bnxp3sNQjhQlXjP44BeSccU0IXX7heDkuVCI1SI0XMg2EJ4gHzvvIS4CvCoa51P9LqDVUfiTIZOFpn86o9ErpmbH9n6KQTcxCEeqSPpzVHd3txQbzh+7C2mRJ+p2hTpo02Y9l+zv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(1076003)(86362001)(16526019)(54906003)(52116002)(4326008)(2906002)(26005)(6506007)(186003)(2616005)(316002)(508600001)(956004)(6486002)(83380400001)(8676002)(66946007)(8936002)(66556008)(66476007)(6666004)(6512007)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uGxK0JoJOjHD2XJWU+7n3n1z+KrjDIb6qk4hvflhnkom2xmrX4SO72hnwVDbywdO9y0cS3hzYoL4CEKbCNy9r6lYMJuurofyTGO5jWYEAjYbYhk+lADi9vJln3LL8OkpFINr0+dp6M49hObE452vRRRnzc2PailX331qd5KNGYSMxWoB2hSkBYZwEuSX/3F3e8cWrUNmNSon1YlDm2wYXFH7FjGyAfg/aOrAJdzhPfp5KyicLOAiPpvbiVIQEyyr8OWCNlIvmHR8EX+0A3mgUDcDGZ6mu3CUte/Iq4BYqaNW7OmKd3f5gk3ooremWyMIu7/0FDVRiZZ4TJ5gWBjas7C5y4CnSsfhJehizklIfkUr+6yjfvnDLTAt65QBe3FteRoUEiMFyDCxfndOWRmeNirdbiFRZFMsoQTFsjeKzp+TkR8cW6UqoaxFwNGry64DOY82uJHd9pQbLQIUi7998pd7+t3u01RwJUs8srilrEz7UWjRCl8Yl6bweOh51iki1mqYkuIAsDejCYkIJ2MtvzXNSirJRCRqE/EX8rgfdaZfXqHL8TA3gqi7F0PnpWetIU3DDVhRE5fdYHPuq8bA/9csl2nEHL6+ZeVnxMShOenEXHvJKdO5tEnLmNgafuMNbctmHm4xET1DezPXSojOgg==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4972d121-ae1a-4c90-578a-08d8547bf90d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 04:51:11.4853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zSAJdmOpZ4lg/iETqOcsIJpyRLUOMGWoxCEMk6k/bJ/VxBCfeB80oOesW0oBEtXaa4HXE87dBefo3Rz7qacCSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5907
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

A devlink eswitch port may represent PCI PF/VF ports of a controller.

A controller either located on same system or it can be an external
controller located in host where such NIC is plugged in.

Add the ability for driver to specify if a port is for external
controller.

Use such flag in the mlx5_core driver.

An example of an external controller having VF1 of PF0 belong to
controller 1.

$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev ens2f0pf0vf1 flavour pcivf pfnum 0 vfnum 1 external true splittable false
  function:
    hw_addr 00:00:00:00:00:00
$ devlink port show pci/0000:06:00.0/2 -jp
{
    "port": {
        "pci/0000:06:00.0/2": {
            "type": "eth",
            "netdev": "ens2f0pf0vf1",
            "flavour": "pcivf",
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
 - Addressed comments from Jiri and Jakub
 - New patch
 - Split 'external' attribute from 'external controller number'.
 - Merged mlx5_core driver to avoid compiliation break
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |  6 ++++--
 include/net/devlink.h                            |  8 ++++++--
 include/uapi/linux/devlink.h                     |  1 +
 net/core/devlink.c                               | 12 ++++++++++--
 4 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index e13e5d1b3eae..5b3599caa007 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1215,11 +1215,13 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 	struct devlink_port_attrs attrs = {};
 	struct netdev_phys_item_id ppid = {};
 	unsigned int dl_port_index = 0;
+	bool external;
 	u16 pfnum;
 
 	if (!is_devlink_port_supported(dev, rpriv))
 		return 0;
 
+	external = mlx5_core_is_ecpf_esw_manager(dev);
 	mlx5e_rep_get_port_parent_id(rpriv->netdev, &ppid);
 	dl_port_index = mlx5_esw_vport_to_devlink_port_index(dev, rep->vport);
 	pfnum = PCI_FUNC(dev->pdev->devfn);
@@ -1232,12 +1234,12 @@ static int register_devlink_port(struct mlx5_core_dev *dev,
 	} else if (rep->vport == MLX5_VPORT_PF) {
 		memcpy(rpriv->dl_port.attrs.switch_id.id, &ppid.id[0], ppid.id_len);
 		rpriv->dl_port.attrs.switch_id.id_len = ppid.id_len;
-		devlink_port_attrs_pci_pf_set(&rpriv->dl_port, pfnum);
+		devlink_port_attrs_pci_pf_set(&rpriv->dl_port, pfnum, external);
 	} else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch, rpriv->rep->vport)) {
 		memcpy(rpriv->dl_port.attrs.switch_id.id, &ppid.id[0], ppid.id_len);
 		rpriv->dl_port.attrs.switch_id.id_len = ppid.id_len;
 		devlink_port_attrs_pci_vf_set(&rpriv->dl_port,
-					      pfnum, rep->vport - 1);
+					      pfnum, rep->vport - 1, external);
 	}
 	return devlink_port_register(devlink, &rpriv->dl_port, dl_port_index);
 }
diff --git a/include/net/devlink.h b/include/net/devlink.h
index efff9274d248..2dad8c9151f4 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -60,19 +60,23 @@ struct devlink_port_phys_attrs {
 /**
  * struct devlink_port_pci_pf_attrs - devlink port's PCI PF attributes
  * @pf: Associated PCI PF number for this port.
+ * @external: when set, indicates if a port is for an external controller
  */
 struct devlink_port_pci_pf_attrs {
 	u16 pf;
+	u8 external:1;
 };
 
 /**
  * struct devlink_port_pci_vf_attrs - devlink port's PCI VF attributes
  * @pf: Associated PCI PF number for this port.
  * @vf: Associated PCI VF for of the PCI PF for this port.
+ * @external: when set, indicates if a port is for an external controller
  */
 struct devlink_port_pci_vf_attrs {
 	u16 pf;
 	u16 vf;
+	u8 external:1;
 };
 
 /**
@@ -1215,9 +1219,9 @@ void devlink_port_type_ib_set(struct devlink_port *devlink_port,
 void devlink_port_type_clear(struct devlink_port *devlink_port);
 void devlink_port_attrs_set(struct devlink_port *devlink_port,
 			    struct devlink_port_attrs *devlink_port_attrs);
-void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u16 pf);
+void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u16 pf, bool external);
 void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port,
-				   u16 pf, u16 vf);
+				   u16 pf, u16 vf, bool external);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index cfef4245ea5a..40823ed7e05a 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -458,6 +458,7 @@ enum devlink_attr {
 	DEVLINK_ATTR_PORT_LANES,			/* u32 */
 	DEVLINK_ATTR_PORT_SPLITTABLE,			/* u8 */
 
+	DEVLINK_ATTR_PORT_EXTERNAL,		/* u8 */
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 49e911c19881..6f5f85372721 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -526,6 +526,8 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 		if (nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER,
 				attrs->pci_pf.pf))
 			return -EMSGSIZE;
+		if (nla_put_u8(msg, DEVLINK_ATTR_PORT_EXTERNAL, attrs->pci_pf.external))
+			return -EMSGSIZE;
 		break;
 	case DEVLINK_PORT_FLAVOUR_PCI_VF:
 		if (nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_PF_NUMBER,
@@ -533,6 +535,8 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 		    nla_put_u16(msg, DEVLINK_ATTR_PORT_PCI_VF_NUMBER,
 				attrs->pci_vf.vf))
 			return -EMSGSIZE;
+		if (nla_put_u8(msg, DEVLINK_ATTR_PORT_EXTERNAL, attrs->pci_vf.external))
+			return -EMSGSIZE;
 		break;
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
 	case DEVLINK_PORT_FLAVOUR_CPU:
@@ -7716,8 +7720,9 @@ EXPORT_SYMBOL_GPL(devlink_port_attrs_set);
  *
  *	@devlink_port: devlink port
  *	@pf: associated PF for the devlink port instance
+ *	@external: indicates if the port is for an external controller
  */
-void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u16 pf)
+void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u16 pf, bool external)
 {
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
@@ -7728,6 +7733,7 @@ void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u16 pf)
 		return;
 
 	attrs->pci_pf.pf = pf;
+	attrs->pci_pf.external = external;
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_pf_set);
 
@@ -7737,9 +7743,10 @@ EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_pf_set);
  *	@devlink_port: devlink port
  *	@pf: associated PF for the devlink port instance
  *	@vf: associated VF of a PF for the devlink port instance
+ *	@external: indicates if the port is for an external controller
  */
 void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port,
-				   u16 pf, u16 vf)
+				   u16 pf, u16 vf, bool external)
 {
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
@@ -7750,6 +7757,7 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port,
 		return;
 	attrs->pci_vf.pf = pf;
 	attrs->pci_vf.vf = vf;
+	attrs->pci_vf.external = external;
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_vf_set);
 
-- 
2.26.2

