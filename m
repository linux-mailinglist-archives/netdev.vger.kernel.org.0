Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF8D46DE6A
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 23:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237587AbhLHWgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 17:36:25 -0500
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:31041
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237509AbhLHWgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 17:36:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FF1GeKvWXAlw8LLS4nHQTzz6IPPaI/zUbIIZEn3f0Qfgo7l9b+D++b/eDrhsX2GrKCFMDdGvYvh8uFXHot/ZEvGc+xMex4+CYHj0Xsm/qn53NO3KMGL1Lx/oriEYWcBXqU897JpHwArm8Fh3AlCxnza7qknZYi5qXAN27jSFPDqGvMcKGrwumHMqeicUyMTvWqA2xyRv0A3Gq1OI1zI5lXg/tErXJMVzLRhNYEodqD/4rN/yJ/TRjgdgCXoKSjEeIuhv9I49ZFjcWbPbyoAN3XjrnpgbNhjAMkuhzleakc2z1WNaqxp8ae+cBEI+yXuA2behC3/yapFXleW5E6Jwww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aTUkNvHbk9PX+akqXwCPsrHWj+aQVsLKnmZ7iCpDswk=;
 b=LiFtMIdwKGq22yxkEBvXjkbwaoP3xiCRQHQNFRbBAnNgNiYopitJwQVYWAP/tDPqZ33ShwxG3mKD46ah0AuIXO+FdX2Ouak52aNMZwyfmki7LMK4wBr7w9NskXxTx1lO4Go6chzbv2BqD4kv9Hhx5i/F7n/YzA+EdbuYmB2XeF9+RpBeUmpyWrOskeUjVenv9SSPe/vvR4MHv94AL/rFa99PR562ZWURxfPG/Eu3GRGvkDVZheByt7EeJhwdwivxsQQnXBMwlUiGmBph7FnYR7vnH22x7wPL2OcEs5Vtn2Yao1AfyfQzX/uOiSQr2iSFthOt2tdB5BjSBTwryrzXMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aTUkNvHbk9PX+akqXwCPsrHWj+aQVsLKnmZ7iCpDswk=;
 b=okuU8rANylkurN79IRGjliJ3ckfKHIMepWjuV4J0EJNta03+1//9h6ZPEOjS4eo0oqUPHo1KLy55MwqA8c/nsgcjEs4ywglR68x1alOAXsV+vTkP5tGfbOZQ0oHMP94t9FCef9r8MOinnlSSygvzwPVAHTk7MqoBA75TTyQNQdQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Wed, 8 Dec
 2021 22:32:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 22:32:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next 4/7] net: dsa: provide switch operations for tracking the master state
Date:   Thu,  9 Dec 2021 00:32:27 +0200
Message-Id: <20211208223230.3324822-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
References: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0129.eurprd05.prod.outlook.com
 (2603:10a6:207:2::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM3PR05CA0129.eurprd05.prod.outlook.com (2603:10a6:207:2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 22:32:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d875c082-d02b-4746-bef1-08d9ba9aa9a4
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3408B3A9E133C709BD18D042E06F9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YJ5lRXfHTSIb2nt3hlDkbg9Yed1mfQtD89oa0sYFrcjGPJCGMAHOQGgVwh0Z9Pcu6K5CAFYgmsnTqXLiWmRmxeIsdPGyKJeR0B2Ol/U/4AkHRE8dV70uKVv2RTe5ZkZiRALehoTbC5+2r0bAHYTlbBPNbWQbIWKMLX9Z8bLH/z7WyjCwCQGRsBnNjH5mw3CZhPfzXtNtVmQkNbiNDLEi3p7INe4XXnhfEZFB8HEYBwthn4P7fExxjZQds5AoRw3FQZF0vyQtxcejcCeIBUsUUizmo+Ja7Jja/dkTRR/DapzFWCdYo24RPW9NggqKaORD3NTHMRVHgkAqdZ+m57njAA1aB/VAnYigmyfWR1/UDSSkCfoDzHEtkb5srz3tbAQzDx3tuBnUQKnfLPWijHxRXOyz5vl/PzRhbpihtbFka7i/qlPjAK0jilqJ21J4onrmcQISLSglZvgXMXWzAmunh7xu+SXx169qeqgXacFy3dSfOl5lmqX1fRcoG/foltdMSCyaTnCSexVHYTq1/n1VdmF+F4WduRzGdXhVAhf3IYIYNR+y+7gaqrTtzbVkDq2Jn1rl0g8O0EVkiwwKaOMCJBHX1idGiJHoMWlbl52mxIG3k15F1IyJ/8pvNe8o0RFiDMwgpjPOOrqC+IQaPK28UToBePvuY8SUPKmfgKeqa5jWIoM3o8db6xKMht1c8w90xkDpXIm6zQhCVn3tDgV0og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(66946007)(83380400001)(86362001)(66476007)(1076003)(44832011)(956004)(2616005)(36756003)(6666004)(38350700002)(6486002)(66556008)(6916009)(26005)(5660300002)(186003)(38100700002)(8676002)(4326008)(8936002)(52116002)(54906003)(6506007)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5+96N9tHyt9+qnZbuzdfIpbo47CoM+bfizQEmSS5VelyU9wxvJRs8Gw2wJIb?=
 =?us-ascii?Q?I0mEOmHnuC/qwMbN7QfkpdlytmfUc2Be4Fz74mvm2mut5oCqhyrohUNvRgcj?=
 =?us-ascii?Q?QdSbekuWKseI8tmX/g44tvY3uDNiYI6fwbSTTA02Rn5OAKJiQfQI+K02ih0H?=
 =?us-ascii?Q?f5NGz2gQaAcRSLqzp66CLxXFP9Fv7w9GoV6ymU12xP8y82gn5xz5HJGywsL8?=
 =?us-ascii?Q?E0u2Ysz8iaL11wzjHQXF+R3sKyg1wguwuXD2GDNqk1iOYmEvSmeAlXJ1UWQv?=
 =?us-ascii?Q?R0nxaobQuYrYrWDRqe0EAOqRWWPg3gao3V+3lZ8X/miOioNgAh1NrEBS32NC?=
 =?us-ascii?Q?muLdXFESCol5ku/arw+tzHIDjw5zm+mXq5PmMMNKZfQCbpr6mSt9UbMkaghl?=
 =?us-ascii?Q?CIApXwSScoaXxWOcTqHOb+ZS20Eer5NUsCLdgrd1aUU2r9SumtU5SUu39pjG?=
 =?us-ascii?Q?naZ5WWZ6AzPbXSKNDk4w8Li2ZTLYPYF0q41PvzTaveNB9ckXJ3CuTmS9Noil?=
 =?us-ascii?Q?i5Kh8C6+Av/DnP3sN5oIX5SJZR8JKmKaHr4WjU0cIDUlTz7OeUftpE7UzrrD?=
 =?us-ascii?Q?EjI4H51LNzS1NuaHykraUY6N8qXM5YuF8eLtQ3aftKEj9UEe45wLaMR30LQh?=
 =?us-ascii?Q?FHm+H5t+LQGwH0eASpt2MSI74VkfViw64PQW/TNocjCe7viKxWE25ZOq2rm8?=
 =?us-ascii?Q?bfqKIo9r0Kp0DANTwoQCMzkZoJvgXcqR0xEV9p5ukxmumsyQJO2nMogFOZr2?=
 =?us-ascii?Q?7SrI3kIFpqs3lINBPOHiyZmn9NJpb3rdsZwnMjGa1MNSOckLSmw4ARxcAjJr?=
 =?us-ascii?Q?v9ByjWS9JH6hS7Glz0zQIFMg8Fib4T8Rrg4MLQUZc4J0U0VLChkw7UPIi2Or?=
 =?us-ascii?Q?ccLEmY8bIPuJw67jdWaP+gdD71gyvQ1HTl57spk7+DXRwSn0M65SJYffLAAQ?=
 =?us-ascii?Q?JN8oCAt63GFYe90p8Gy3fCj8BsC8B7izoV/XNbDPjTiWmMz8dlLdENKC0yXZ?=
 =?us-ascii?Q?ZTXIC7zfCXGXHdYz9eN+RJ1Wv0q2e7686Szq0gBLICgaX1L/XEDwcoJZyIPX?=
 =?us-ascii?Q?gYQl18y6GLV9NUXyn4bRZNVCbumTzVbvRi3w9e6rU5QgC9/puyzcBKMFysAp?=
 =?us-ascii?Q?8/KNgyxO6546s+lwHPl58o5RLFJEpgBlkItuMFPVefAtGZeR5tC2LuqzG98Z?=
 =?us-ascii?Q?y3K8/rk5C0ZaiCkO7+0c3zmcLTZZOwiJEe+jSBW6/JssXGTXEKYLOsDlIBHg?=
 =?us-ascii?Q?XzDvvcqTsKxu67nNnAb5NQanaNEF5wYuOOSZb2e2n+Wc0o7F6UDvU44zEHSB?=
 =?us-ascii?Q?L31sTi0uf6JcnzLs7Y32nVLKkCFI7rNkopWNEx8hfanfoThw/M5DNNK7xjhk?=
 =?us-ascii?Q?Lo9hwlcV8qdHpqY0teNtvlOpZFtxqLyDl2c6HjjN4geWCa/LnyTepiDI2VF9?=
 =?us-ascii?Q?+5Xuz+zKZhL7nEmm7Dx2c8t6ohFAoh9Cp0l+F3Sbbe/3ISmWN8w1VQ0M3Lrx?=
 =?us-ascii?Q?fJ+hFgrx3fRezeBiMct/0urI6f9PVea5VHs4agd4sRruos8sBWMb0pUo8GM3?=
 =?us-ascii?Q?+jelGyycYA+1sCN59gw/YFegR7FodeHCEK3CE/+uvjO2NGqGxF9gRon5x2L8?=
 =?us-ascii?Q?uFYBGpgmjF76MhOvjqGxdGw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d875c082-d02b-4746-bef1-08d9ba9aa9a4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 22:32:48.5074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HPxWppNIEbVU6TWjWl8xeq2HQPAx580BtCJAJ1aU+9wL0D8YyRm4LsXxeL/uFKWzk3FdIvOMW+WNca5dpqo4Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Certain drivers may need to send management traffic to the switch for
things like register access, FDB dump, etc, to accelerate what their
slow bus (SPI, I2C, MDIO) can already do.

Ethernet is faster (especially in bulk transactions) but is also more
unreliable, since the user may decide to bring the DSA master down (or
not bring it up), therefore severing the link between the host and the
attached switch.

Drivers needing Ethernet-based register access already should have
fallback logic to the slow bus if the Ethernet method fails, but that
fallback may be based on a timeout, and the I/O to the switch may slow
down to a halt if the master is down, because every Ethernet packet will
have to time out. The driver also doesn't have the option to turn off
Ethernet-based I/O momentarily, because it wouldn't know when to turn it
back on.

Which is where this change comes in. By tracking NETDEV_UP and
NETDEV_GOING_DOWN events on the DSA master, we should know when this
interface becomes available for traffic. Provide this information to
switches so they can use it as they wish.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  |  8 ++++++++
 net/dsa/dsa2.c     | 14 ++++++++++++++
 net/dsa/dsa_priv.h |  9 +++++++++
 net/dsa/slave.c    | 12 ++++++++++++
 net/dsa/switch.c   | 29 +++++++++++++++++++++++++++++
 5 files changed, 72 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index bdf308a5c55e..65aef079b156 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1011,6 +1011,14 @@ struct dsa_switch_ops {
 	int	(*tag_8021q_vlan_add)(struct dsa_switch *ds, int port, u16 vid,
 				      u16 flags);
 	int	(*tag_8021q_vlan_del)(struct dsa_switch *ds, int port, u16 vid);
+
+	/*
+	 * DSA master tracking operations
+	 */
+	void	(*master_up)(struct dsa_switch *ds,
+			     const struct net_device *master);
+	void	(*master_going_down)(struct dsa_switch *ds,
+				     const struct net_device *master);
 };
 
 #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 9c490a326e6f..fe3a3d05ee24 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1187,12 +1187,26 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 	return err;
 }
 
+void dsa_tree_master_up(struct dsa_switch_tree *dst, struct net_device *master)
+{
+	struct dsa_notifier_master_state_info info = {
+		.master = master,
+	};
+
+	dsa_tree_notify(dst, DSA_NOTIFIER_MASTER_UP, &info);
+}
+
 void dsa_tree_master_going_down(struct dsa_switch_tree *dst,
 				struct net_device *master)
 {
 	struct dsa_port *dp, *cpu_dp = master->dsa_ptr;
+	struct dsa_notifier_master_state_info info = {
+		.master = master,
+	};
 	LIST_HEAD(close_list);
 
+	dsa_tree_notify(dst, DSA_NOTIFIER_MASTER_GOING_DOWN, &info);
+
 	dsa_tree_for_each_user_port(dp, dst) {
 		if (dp->cpu_dp != cpu_dp)
 			continue;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 21bd11b9d706..107f934ca592 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -43,6 +43,8 @@ enum {
 	DSA_NOTIFIER_MRP_DEL_RING_ROLE,
 	DSA_NOTIFIER_TAG_8021Q_VLAN_ADD,
 	DSA_NOTIFIER_TAG_8021Q_VLAN_DEL,
+	DSA_NOTIFIER_MASTER_UP,
+	DSA_NOTIFIER_MASTER_GOING_DOWN,
 };
 
 /* DSA_NOTIFIER_AGEING_TIME */
@@ -126,6 +128,12 @@ struct dsa_notifier_tag_8021q_vlan_info {
 	u16 vid;
 };
 
+/* DSA_NOTIFIER_MASTER_* */
+struct dsa_notifier_master_state_info {
+	const struct net_device *master;
+	struct netlink_ext_ack *extack;
+};
+
 struct dsa_switchdev_event_work {
 	struct dsa_switch *ds;
 	int port;
@@ -506,6 +514,7 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 			      struct net_device *master,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops);
+void dsa_tree_master_up(struct dsa_switch_tree *dst, struct net_device *master);
 void dsa_tree_master_going_down(struct dsa_switch_tree *dst,
 				struct net_device *master);
 unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4b91157790bb..ff0e8a173996 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2349,6 +2349,18 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		err = dsa_port_lag_change(dp, info->lower_state_info);
 		return notifier_from_errno(err);
 	}
+	case NETDEV_UP: {
+		if (netdev_uses_dsa(dev)) {
+			struct dsa_port *cpu_dp = dev->dsa_ptr;
+			struct dsa_switch_tree *dst = cpu_dp->ds->dst;
+
+			dsa_tree_master_up(dst, dev);
+
+			return NOTIFY_OK;
+		}
+
+		return NOTIFY_OK;
+	}
 	case NETDEV_GOING_DOWN: {
 		if (netdev_uses_dsa(dev)) {
 			struct dsa_port *cpu_dp = dev->dsa_ptr;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 9c92edd96961..553b67478428 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -699,6 +699,29 @@ dsa_switch_mrp_del_ring_role(struct dsa_switch *ds,
 	return 0;
 }
 
+static int dsa_switch_master_up(struct dsa_switch *ds,
+				struct dsa_notifier_master_state_info *info)
+{
+	if (!ds->ops->master_up)
+		return 0;
+
+	ds->ops->master_up(ds, info->master);
+
+	return 0;
+}
+
+static int
+dsa_switch_master_going_down(struct dsa_switch *ds,
+			     struct dsa_notifier_master_state_info *info)
+{
+	if (!ds->ops->master_going_down)
+		return 0;
+
+	ds->ops->master_going_down(ds, info->master);
+
+	return 0;
+}
+
 static int dsa_switch_event(struct notifier_block *nb,
 			    unsigned long event, void *info)
 {
@@ -784,6 +807,12 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_TAG_8021Q_VLAN_DEL:
 		err = dsa_switch_tag_8021q_vlan_del(ds, info);
 		break;
+	case DSA_NOTIFIER_MASTER_UP:
+		err = dsa_switch_master_up(ds, info);
+		break;
+	case DSA_NOTIFIER_MASTER_GOING_DOWN:
+		err = dsa_switch_master_going_down(ds, info);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
-- 
2.25.1

