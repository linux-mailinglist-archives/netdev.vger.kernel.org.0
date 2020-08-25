Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B686251A6D
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 16:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgHYODs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 10:03:48 -0400
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:60483
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726473AbgHYN71 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 09:59:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdUWMBNDC9QatA3CiRcAUeu2BKn67rnhQHc43Du6EB8Nb1kW+tmP5gaKla40RoR78cb2Yy8SaqhT7PB/SGAdUEaq+88oaKjqG3aV/di+QoQFnNfBtIz7QaUgarnXraOd+NMN+wz77xXf/+MaiM2cgdnJQmreNvNejIor2JNhgaYaTXfYxPoRJjj4+q+NjeqyEEuKflwUanm609OcUWlOfPJpxuQE7wDhv/XN2uELN/aCs78ewz5eWZhvTYN08Nu2HcT3SFkP6GC7wpcuu1Ky35/PIyDTNTpSld3vqSpAf4FLPpdRWt+ZjS0fVzokPqDvQU5XPJMnhEXOUm/uHKcyNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Z1Jppa0dK038+xxPQERpTNBmBezDbhHQPdlQ2lSkhA=;
 b=IzSzHWxFDoWTXXV9Vfpp6eS/b6uOC9/orNPu1OBcwytVkNkuF8ozsQEyS65kk1Sf/XOtGWH4EYy8m/K1WK8ofqT9fxUTtYJOt/QCytqBaMXBjWZ6V4rYf9HoVnHEtypbikxD5IbihOZG6wjau8jw8jVVmNFWVNGxf6HPQi7FLQPpNRZ/GGndgu6VKMJs4VYBdN389OsRRTioeUKQeW5faeG44v78dJnTY/dD+ah1/cshAGoqxL4JsiATJdoj6zRl5JeQLhTimQeVE2RAFcW+7i7slvx5V807VAAXf0W41OzLHpD6/Fppzn3W8ZtViH9T4dkegEFdGEH/3nOL246/IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Z1Jppa0dK038+xxPQERpTNBmBezDbhHQPdlQ2lSkhA=;
 b=hWGBiuaXg8RlX66eYQXrKT/xO9vW8jtbWXfre+5X1/50+EJh2G2MOOJlnKE+pRSiAkMaHYQ6tUoKMeBVpS0xwazsO8r1g7h530tkcFRKB8p1z84U8s8k3brBd0dgZiqB217cRWeCewsHCJxTNqdkbzUFfXEnGrDh7fZixE2FVMo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR0502MB3649.eurprd05.prod.outlook.com (2603:10a6:208:22::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Tue, 25 Aug
 2020 13:58:59 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::5038:5c70:6fef:90a6]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::5038:5c70:6fef:90a6%5]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 13:58:59 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     roid@mellanox.com, saeedm@mellanox.com,
        Parav Pandit <parav@mellanox.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 2/3] devlink: Consider other controller while building phys_port_name
Date:   Tue, 25 Aug 2020 16:58:38 +0300
Message-Id: <20200825135839.106796-3-parav@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200825135839.106796-1-parav@mellanox.com>
References: <20200825135839.106796-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0048.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::28) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c-235-9-1-005.mtl.labs.mlnx (94.188.199.18) by AM0PR10CA0048.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Tue, 25 Aug 2020 13:58:58 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d4159f1c-55b0-4904-0afe-08d848ff0395
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3649:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB36490D0411CB460AAD82CAE6D1570@AM0PR0502MB3649.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3w62JuNuGXRYO15XcRX0xCiicj+gqIXU2GdLx43E/8epjbdI7mOZ1XANy1tXs51YeNLEuRCXf5B/caAlrlJoKdHnQrqPOoNE+GErw/K/vKwfI1sKAqtELsPXl5stjv7i/FFBonYPSaM6dpr+KuVMsM16OftJVJPqYNkk+hTR0EvkMsVy6FPgU+xUeibcUqSWN7hrciKmC3jtwMDvkIPPHhTF4/Nlo6qalvJGGc30OyvDJinJt5usA+L+CcZX6SF+yOeZGf9P0A6bSjhnbGXZq3IhZbAWhZrzs0B+HMRYNPngbnFrq6HJiAMAYDLOFsOhG4oLD0exqKi2CflQ14Ywfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(136003)(396003)(6506007)(6666004)(956004)(86362001)(36756003)(8936002)(54906003)(83380400001)(5660300002)(316002)(8676002)(4326008)(52116002)(6486002)(6512007)(1076003)(478600001)(2906002)(2616005)(66946007)(26005)(186003)(66476007)(66556008)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PWRPebJaLUgYFuHKerC2th89aXa515IyHSVtfj7LyKSHvWro61dxWNrhxx6Go2PSrTfO5V7RMHGLy4XB20/TOFFD3rVqauP3aA84r0leCXi4FXyx0VCJ0MbvSTSSJMbD7D8240nelUolTx/x9xU56N5TivK5dADcedOUvhQVjRgkD3Y21YcsuQpnBcD+XQQVdRxAx+5WdM4wOcN2Z1oFygeUytoIKwBrbaJR9SyORCtZfYZDprlUazwSb7snHyBSxDZn4BrDfh1qEGR4Jh5CBgu8/oOvAqI6nUagfalmP08AW7x7f9VUBUFe3z7yhRfMW70Gb0kYup7SHM2a0P5xRwV8Iou4QdcF0ltLWHhzqHLqlAUtL/dHkmjIsizfG1RaJCdEYnLlpsW6BzT+LQ5b5pAneWbfwWt4KroyPk0TW2+vmuOhbSA3ZwijEJNJeW8Oui3QPY3UsPJ3el67b9q3kj6BxzQwEtst2p6CVH3TZWvRrAc4yAQRbc1euptG+T+KFHW7MrpvyiZgpre1txyIvJzYCKUKXAaK2ecok6f3Qa4Fnsyntk17MBAPmEDrQ2N9I4gPnZZtAoyuVFCmcVTAuWN0UspOXa0fSgQ+VQc5nLfmR+C1CZwaMmN9GFmrk0YfFPHE7C2okVW6pBHu49LOqg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4159f1c-55b0-4904-0afe-08d848ff0395
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 13:58:58.9103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lecJsoLrIauwvh419cwETO/H/h0kCoR25+CAJ9qaeYWjDqCmVMMK81x+8Z6xBCTj/E0petArit2RnYCf3POJTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3649
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A devlink port may be for a controller consist of PCI device.
A devlink instance holds ports of two types of controllers.
(1) controller discovered on same system where eswitch resides
This is the case where PCI PF/VF of a controller and devlink eswitch
instance both are located on a single system.
(2) controller located on other system.
This is the case where a controller is located in one system and its
devlink eswitch ports are located in a different system. In this case
devlink instance of the eswitch only have access to ports of the
controller.

When a devlink eswitch instance serves the devlink ports of both
controllers together, PCI PF/VF numbers may overlap.
Due to this a unique phys_port_name cannot be constructed.

To differentiate ports of a controller external/remote to the devlink
instance, consider external controller number while forming the
phys_port_name.
Also return this optional controller number of the port via netlink
interface.

An example output:

$ devlink port show pci/0000:00:08.0/2
pci/0000:00:08.0/2: type eth netdev eth7 controller 0 flavour pcivf pfnum 0 vfnum 1 splittable false
  function:
    hw_addr 00:00:00:00:00:00

$ devlink port show -jp pci/0000:00:08.0/2
{
    "port": {
        "pci/0000:00:08.0/1": {
            "type": "eth",
            "netdev": "eth7",
            "controller": 0,
            "flavour": "pcivf",
            "pfnum": 0,
            "vfnum": 1,
            "splittable": false,
            "function": {
                "hw_addr": "00:00:00:00:00:00"
            }
        }
    }
}

An example representor netdev udev name consist of controller
annotation for external controller with controller number = 0,
for PF 0 and VF 1:

udevadm test-builtin net_id /sys/class/net/eth7
Using default interface naming scheme 'v245'.
ID_NET_NAMING_SCHEME=v245
ID_NET_NAME_PATH=enp0s8f0nc0pf0vf1
Unload module index
Unloaded link configuration context.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
---
 include/net/devlink.h        |  7 ++++++-
 include/uapi/linux/devlink.h |  1 +
 net/core/devlink.c           | 29 +++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 3c7ba3e1f490..612f107b94ab 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -71,16 +71,20 @@ struct devlink_port_pci_vf_attrs {
  * @flavour: flavour of the port
  * @split: indicates if this is split port
  * @splittable: indicates if the port can be split.
+ * @controller_valid: indicates if the controller_num field is valid.
  * @lanes: maximum number of lanes the port supports. 0 value is not passed to netlink.
  * @switch_id: if the port is part of switch, this is buffer with ID, otherwise this is NULL
  * @phys: physical port attributes
  * @pci_pf: PCI PF port attributes
  * @pci_vf: PCI VF port attributes
+ * @controller_num: Controller number if a port is for other controller.
  */
 struct devlink_port_attrs {
 	u8 split:1,
-	   splittable:1;
+	   splittable:1,
+	   controller_valid:1;
 	u32 lanes;
+	u32 controller_num;
 	enum devlink_port_flavour flavour;
 	struct netdev_phys_item_id switch_id;
 	union {
@@ -1206,6 +1210,7 @@ void devlink_port_type_ib_set(struct devlink_port *devlink_port,
 void devlink_port_type_clear(struct devlink_port *devlink_port);
 void devlink_port_attrs_set(struct devlink_port *devlink_port,
 			    struct devlink_port_attrs *devlink_port_attrs);
+void devlink_port_attrs_controller_set(struct devlink_port *devlink_port, u32 controller);
 void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u16 pf);
 void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port,
 				   u16 pf, u16 vf);
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index cfef4245ea5a..886cddf6a0a9 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -458,6 +458,7 @@ enum devlink_attr {
 	DEVLINK_ATTR_PORT_LANES,			/* u32 */
 	DEVLINK_ATTR_PORT_SPLITTABLE,			/* u8 */
 
+	DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,		/* u32 */
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 58c8bb07fa19..b9b71f119446 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -553,6 +553,11 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 	default:
 		break;
 	}
+
+	if (attrs->controller_valid &&
+	    nla_put_u32(msg, DEVLINK_ATTR_PORT_CONTROLLER_NUMBER, attrs->controller_num))
+		return -EMSGSIZE;
+
 	return 0;
 }
 
@@ -7711,6 +7716,22 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_set);
 
+/**
+ *	devlink_port_attrs_controller_set - Set external controller identifier
+ *
+ *	@devlink_port: devlink port
+ *	@controller: associated controller number for the devlink port instance
+ *	devlink_port_attrs_controller_set() Sets the external controller identifier
+ *	for the port. This should be called by the driver for a devlink port which is associated
+ *	with the controller which is external to the devlink instance.
+ */
+void devlink_port_attrs_controller_set(struct devlink_port *devlink_port, u32 controller)
+{
+	devlink_port->attrs.controller_valid = true;
+	devlink_port->attrs.controller_num = controller;
+}
+EXPORT_SYMBOL_GPL(devlink_port_attrs_controller_set);
+
 /**
  *	devlink_port_attrs_pci_pf_set - Set PCI PF port attributes
  *
@@ -7762,6 +7783,14 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 	if (!devlink_port->attrs_set)
 		return -EOPNOTSUPP;
 
+	if (attrs->controller_valid) {
+		n = snprintf(name, len, "c%u", attrs->controller_num);
+		if (n >= len)
+			return -EINVAL;
+		len -= n;
+		name += n;
+	}
+
 	switch (attrs->flavour) {
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
 	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
-- 
2.26.2

