Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1852C26132A
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 17:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbgIHPFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 11:05:06 -0400
Received: from mail-db8eur05on2046.outbound.protection.outlook.com ([40.107.20.46]:7648
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729779AbgIHPEd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 11:04:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CCfKUDG/X2FJT1PgY8A8+oJooJFXnNUdn0W9u6LFQ9R/MsgLT9RLDhuiE/qg0kGiWP7qqJ/DEFASi5URHWch7cfrAO7L2+UJsnIXukH1rW50vK1ygmwQpaMz1nEUG/UGJwO0ok3SqMyag04Mavauz7CWEyxRrgSgv1v8wOaTzv7WYrWkWuasXn6f6xqyGidX6fJlEmaiPjtDwuFkjWOYAQdCgj8w9FOJL2R3mJtzE8+Es9A+2cXc2Zbz6d2o9lFCy7OX1bbId7uc+Y1+Oza1c5a/kTxxsmhQcygJavw+ZiSI2bjBgtHRh/PJQlRUN1V61HuZ/tMUKfqghiHUOl8E7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7gqZAl2HSpIB7nRQ94eh+jmaK9JClNcuBtRTmPhfa0=;
 b=bxCB+Pj1XJcGzmwNZMbmBT7dxbr9Tr47DmX3LVbb/4bT2Rn1NNXzzThWKCwUfEJ+fgPMIVgVLYw0nOZNDwz5zAqOlH83NL6NFBNhlfi1s3fuXNQFlx0H97guP9+yJncBuMBnzkUSLdwlLdtwxViHwVjwhkrnA5SHZUT3XeIC4Fa14DyJQ3tYGZkgb0HQQjMPWO12eFCkElaC98oCYy+o0ZP7YC8qsksS47V0MH1ymiJ+okbfz8W7wPVOAwHPMBNEvi/Rt6JqkdRrhUzbYxyLVNpRfEHVDEiECoC5X5J6BDvAYgobISsjX9WqqAlp3uF9/5sgrkKGzwezMajlhSLfPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7gqZAl2HSpIB7nRQ94eh+jmaK9JClNcuBtRTmPhfa0=;
 b=P1AQCfIMzNeA9phY9FB3QsOvD3qVrzDooolEJ1K29J9xnvBPPj2/q0pm0DMx0XAGwEu71aFdHb1RJzy0OtustCk7r4brMg7SJKsqpt6MZIvBOkzye7J0EBmsN6JAuqXAxbnP7hJa9ZKD8dEoItQi0hkeFzwDeHQ5Amrw6ZKFGw4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB4353.eurprd05.prod.outlook.com (2603:10a6:208:67::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Tue, 8 Sep
 2020 14:43:16 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18%3]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 14:43:16 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 4/6] devlink: Introduce external controller flag
Date:   Tue,  8 Sep 2020 17:42:39 +0300
Message-Id: <20200908144241.21673-5-parav@mellanox.com>
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
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SA9PR11CA0020.namprd11.prod.outlook.com (2603:10b6:806:6e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 8 Sep 2020 14:43:15 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d007f08c-5a52-438a-08e7-08d854058569
X-MS-TrafficTypeDiagnostic: AM0PR05MB4353:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB4353CB9E0771370DE3345DB3D1290@AM0PR05MB4353.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CYu/txYx0/vo03RD9ks2XO3PoMBtZbnXkMI8Jz03pwDLbO4ZfjGn9/WWzVjH51fgRljQcUf9Q9avyBpQF3aD1cFt/A3rZTa7zVrWQNuoZL7QJZwXQF2Sqx3B3f/4UkIMP1yHVEG3tIMVLM8ksE8bTxekfJzC0ejw7AivZXyxMe37u8ufrJb8Z56ywOdUyfl5Xkei5bBEBDZBMLOpIiO6/grEeQA2nYUXWkH/98cuRWLg43zxH0U3PLmQiwOhmO+DRQkt20yrAfHf1jKh0awY10znOS63oVClt0kF4xfUC7Ki0/wJvSdtfDKKACD2hDkq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(6666004)(498600001)(26005)(1076003)(6512007)(6506007)(86362001)(4326008)(52116002)(54906003)(5660300002)(2906002)(36756003)(66946007)(8676002)(83380400001)(66556008)(66476007)(956004)(16526019)(8936002)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8U6nL9eK+lfkgY/EJsjMEz9QkFXUX5n6JO1k4NxbYCi6LH4eRxctMsttV2e7YbvHyA5NxI9bLNUuvfpFY+SwyWZAOSfPnuf16pDoeTmQolierm9s7YF3lw9AnemF6RW8si4IQXD3oeDMdLTuw2HqDpInq53bCc2uDyqDmzYFKaWeXiFE1GBZvvku4jGEv4IrKYOkz3+Mu6K2djKh9jeBaUw0PhOM4sDYvLcHvoGhet+fUFMQxBrzPajN++Srw5snrpVp9O3EV1NMf+uXasEJ4CB/VeUDFaj3irfGJwrpycV9vl+eAUAJBlavSL2Y9YJsujBDJpDjHEQeWPwLtmZYmARKHOUrjX/BYPwj5hhn6gPJuKefsP6tIgRCHC2PCXQMJOtPJeCPU9HkP3KmcKCIwbMLJrw7CQl8/IfTQa1TZhaLVOFUGy8OHdBTkc/tLlTHv+3QU9a8N8dMYP20d7K+FzCQO6+2+c5bz7JVOiCPOVOweIKfi/HSQFu8o5ud/SDISAHq2L4tSHzz+ELvL7WTBXb+DrOTPSR6A4eds7hhhaWBZqy/7X+9vFJWN92hLTffcy1pF2aEBR8yCAt4jws8rUBQs3nL54PcLOFLMtWsGfKby1CFV3Lo4vz+wQe6I0rITktS15sKxfa1blBkbE7PaQ==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d007f08c-5a52-438a-08e7-08d854058569
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2020 14:43:16.7935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M14skbKVqqdT3wCSISlT4rbhOhxnBx5yDdbAbSw9xwzX4cBBZY+mrU2Dv3RaEQRVRPLqXDRjFIIXk7dlY79oWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4353
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

