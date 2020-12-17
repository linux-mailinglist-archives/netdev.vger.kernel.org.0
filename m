Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CEC2DCABE
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 03:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbgLQCAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 21:00:04 -0500
Received: from mail-am6eur05on2048.outbound.protection.outlook.com ([40.107.22.48]:59936
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727090AbgLQCAD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 21:00:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=go+0m8DtImyTn7pHJymXfWyiCuxHp41cebNis1M6Hkzs3hMgZO5XgjXvCqvlQr3Y7tlP0kMFAJtUQHsouE+j8nedr5ubS57mQYzJSNKHldW7UluW6PH8norbtLrTYLzBgolsH8Vjgmq0kMSOp9jbrejjKKaNvhqZAfMgW8maJ773LQN2FCP8TphESRmm80WUJ5pocL4ltlrZikVEDxdrrsRHrECV7BWYgWAzv3ADSYyB6RUt1yuDEJvl0uyrJv/eSkHpMqss/qK5fEmFg2HrkM1yiF5ElkTFATD4ifnWe/i/abPwZpqORnFGkYYMJC6MLbVf70iagxu3QQZ+SOo/fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwMelCHnjCMlzihheLLIJuELJU/eV34Pz53KDg7uNFc=;
 b=mc82qppeS9cWnvGcJwkm+SmeUcCxUmLEge0W5252y8hTOS1XAFyQJwwbtNzlc5iEKEDID9p8MhJ/Xgyo6A4s0oq+QJoFUcUt0lpPkm/UZ799FossjoSYT7c+/mM9lEpM42JyB8OzTz1ESUtnZ7j5jfEKqOJ+Cc+8vp9qwERCMNb9tFzlM7JResaOQ4WU30eJwbHFEQw+VUWAjmiiyncIO4nKvIo2aqEamiXBIRDstdzZ+ywGuzjrOlhzR//k8ue0C9fnajU//W+QcHIbTny6a+RGZU/YvxFmYCdCs5NTNm8s9Id2Cd+RTU6m0Z1vDS47tw5Cack5EsYjsot+nGgbYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwMelCHnjCMlzihheLLIJuELJU/eV34Pz53KDg7uNFc=;
 b=IbBXTTAytXVsKrFBMVUHdD7OyG4/TbetAqXZFAQLIIqu+BMA0NZENJQZW6byT3RSEYnGlsBOlCPI7xdH81LzDlEMgJtkOGlZ0bCQISr08Ltrf32jZz+wRL59cDphDsX4IUYgnOWv1f53jzZJTf4oRzzm9iFOL8rZYW2g7GUVBW0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6943.eurprd04.prod.outlook.com (2603:10a6:803:13a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Thu, 17 Dec
 2020 01:59:03 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 01:59:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [RFC PATCH net-next 1/9] net: switchdev: remove the transaction structure from port object notifiers
Date:   Thu, 17 Dec 2020 03:58:14 +0200
Message-Id: <20201217015822.826304-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201217015822.826304-1-vladimir.oltean@nxp.com>
References: <20201217015822.826304-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VE1PR08CA0028.eurprd08.prod.outlook.com
 (2603:10a6:803:104::41) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VE1PR08CA0028.eurprd08.prod.outlook.com (2603:10a6:803:104::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 01:59:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f926adbc-11b9-4b0a-b67c-08d8a22f5417
X-MS-TrafficTypeDiagnostic: VI1PR04MB6943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB694303691F364CC35B155355E0C40@VI1PR04MB6943.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2J3ysoqTuOdF1EaYj+qlucRCOYg70BGKeAG/IqBG/WzdSpqiIA146ytO0vV/FEbQuc5+V1UWzJY4mQGqhbZt6IeEc/j0uISjit/rD+kbQltc9B2ya1aybb4XMRSOyfqiGfq9DRekQvni3Gqi6769uGT6vZJWGS5nO+1Sv2ThbttdZrp5i1D8U8BTQ4qgyFiAaYSAV7/NmJ44R2dbpdtzGko2+pbR6Zis6oRAJW7LhLAONDK30v8w3bfjwOyp3JUfEzQIELLakMM9b0JDjRAM2XIVYI7OcXoBgKJiZUUlR6STIRnMsKX54V5kNMA8yyzVSXXe6m6rexVLs65CFtlmx5WTgf/CoQzfq2Pkg+3lQ4zA1p/INiirDTn6IYpHy380
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(39850400004)(396003)(6666004)(6506007)(16526019)(478600001)(956004)(2616005)(26005)(7416002)(83380400001)(36756003)(66476007)(66556008)(110136005)(86362001)(1076003)(5660300002)(66946007)(316002)(30864003)(186003)(52116002)(6486002)(54906003)(69590400008)(6512007)(44832011)(2906002)(8676002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0jjQcnkZKdzfxP3tssvGMPYrSSH6OA7CfEp/84Terp4+9AhB+4xUN2/8v3po?=
 =?us-ascii?Q?TlU2GB1DHtlDe0K/Ruu9BeQwD54lcEQ4Mqa6DfcnbHZOVC1Qf+ujtjWvqbAT?=
 =?us-ascii?Q?RIoUjZnyUTqH8YShTOnXe49YrAg9IVY+tkunCTNluTBrsMfDlFTPCQkeLlwS?=
 =?us-ascii?Q?gI0AIz3Jeh0C7hCx8gkL5nFOnE1rFw07lAn6tsWaq8CXWkosIUDkrSZZNQty?=
 =?us-ascii?Q?KcYYkwkQuz8X3RahCjJ0HI2N7R45GXD9cHrMOur01gdbsL8gke31jO3siW8v?=
 =?us-ascii?Q?Pme4UCH/4CC2w28q1NonzMZPHCOD3QsHFGFHbFF1oVP8buFwS1V7OCJEPIHW?=
 =?us-ascii?Q?EEtiSLyiASr9sTSinJ/1wwhfjg3dNedB2J91CShNsuMjp9PyiQpBqDGh8s9M?=
 =?us-ascii?Q?MDhZAiMSzSp0Iutr91oJARlcF9uLKCEH8IXyJ3NBJ6PEu8a/oHLsrobNBDjL?=
 =?us-ascii?Q?ywbLkAFGC3lDL/S2lPk5pBPdEKlOI8qTCqYHjPW4fmQpXpKRuujHODTcmdza?=
 =?us-ascii?Q?OLHJJB/vNFW3unRQmP3aC/oIP4IAC/3XEmakJ+S9S169Fb1FjMsPVE9liLoF?=
 =?us-ascii?Q?2RgYLaDwMHlfpb5TnSmYhKiPtqWKWdYzwEwT6+xs4Xa1Dqa3pROxYoR5tXJq?=
 =?us-ascii?Q?Jw4e4qv0ddG86u60/KP0byiOueUq5QGsDol48ihtFE2phAXkI94uVc1fEXjJ?=
 =?us-ascii?Q?PqPjqqNryhHyWy2ghBHw5Ujrz/WamUrc8G/t5pEL1B7UK89J/BNTUQT4q1NE?=
 =?us-ascii?Q?lbcM7LWzR1JDY+KHzUYXCd66fnDIzSCAzFjcBXGsbpHQusUmR/ZZlssgoKKE?=
 =?us-ascii?Q?bUYKyTplNtM6hKS3bbV7kbVm5D2NPjFq1VUi6q3zo5YVCmVqf/FzIx5c3W1E?=
 =?us-ascii?Q?OlpohbENDW4vf/g+R/BzDm0VAqZYJk+sotmZuDULa+IC+64GLUDNQ5eNTIZo?=
 =?us-ascii?Q?vOG5D+0hJDKBPvHZm716ILI5hzDyS+Ho19z3K4uDHBNG1l0g2ssFsG9su2Sa?=
 =?us-ascii?Q?g456?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 01:59:02.9988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: f926adbc-11b9-4b0a-b67c-08d8a22f5417
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WyS9zjUFGaZGQR9QqxpmS/t6XijUiMa7iCqH4MnB2Y99OB6qw4dpLyga60+bWzBo79nU6DDPQaSk38ASbzj8/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6943
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the introduction of the switchdev API, port objects were
transmitted to drivers for offloading using a two-step transactional
model, with a prepare phase that was supposed to catch all errors, and a
commit phase that was supposed to never fail.

Some classes of failures can never be avoided, like hardware access, or
memory allocation. In the latter case, merely attempting to move the
memory allocation to the preparation phase makes it impossible to avoid
memory leaks, since commit 91cf8eceffc1 ("switchdev: Remove unused
transaction item queue") which has removed the unused mechanism of
passing on the allocated memory between one phase and another.

It is time we admit that separating the preparation from the commit
phase is something that is best left for the driver to decide, and not
something that should be baked into the API, especially since there are
no switchdev callers that depend on this.

This patch removes the struct switchdev_trans member from switchdev port
object notifier structures, and converts drivers to not look at this
member.

Where driver conversion is trivial (like in the case of the Marvell
Prestera driver, NXP DPAA2 switch, TI CPSW, and Rocker drivers), it is
done in this patch.

Where driver conversion needs more attention (DSA, Mellanox Spectrum),
the conversion is left for subsequent patches and here we only fake the
prepare/commit phases at a lower level, just not in the switchdev
notifier itself.

Where the code has a natural structure that is best left alone as a
preparation and a commit phase (as in the case of the Ocelot switch),
that structure is left in place, just made to not depend upon the
switchdev transactional model.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../marvell/prestera/prestera_switchdev.c     |  7 +--
 .../mellanox/mlxsw/spectrum_switchdev.c       | 51 +++++++++-------
 drivers/net/ethernet/mscc/ocelot_net.c        | 26 +++-----
 drivers/net/ethernet/rocker/rocker_main.c     | 15 ++---
 drivers/net/ethernet/ti/cpsw_switchdev.c      | 17 ++----
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       | 59 ++++++++-----------
 include/net/switchdev.h                       |  3 -
 net/dsa/dsa_priv.h                            |  6 +-
 net/dsa/port.c                                | 28 +++++++--
 net/dsa/slave.c                               | 34 +++--------
 net/switchdev/switchdev.c                     | 42 ++-----------
 11 files changed, 109 insertions(+), 179 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 7d83e1f91ef1..e92fa4329de2 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -1020,7 +1020,6 @@ prestera_bridge_port_vlan_del(struct prestera_port *port,
 
 static int prestera_port_vlans_add(struct prestera_port *port,
 				   const struct switchdev_obj_port_vlan *vlan,
-				   struct switchdev_trans *trans,
 				   struct netlink_ext_ack *extack)
 {
 	bool flag_untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
@@ -1034,9 +1033,6 @@ static int prestera_port_vlans_add(struct prestera_port *port,
 	if (netif_is_bridge_master(dev))
 		return 0;
 
-	if (switchdev_trans_ph_commit(trans))
-		return 0;
-
 	br_port = prestera_bridge_port_by_dev(sw->swdev, dev);
 	if (WARN_ON(!br_port))
 		return -EINVAL;
@@ -1060,7 +1056,6 @@ static int prestera_port_vlans_add(struct prestera_port *port,
 
 static int prestera_port_obj_add(struct net_device *dev,
 				 const struct switchdev_obj *obj,
-				 struct switchdev_trans *trans,
 				 struct netlink_ext_ack *extack)
 {
 	struct prestera_port *port = netdev_priv(dev);
@@ -1069,7 +1064,7 @@ static int prestera_port_obj_add(struct net_device *dev,
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
-		return prestera_port_vlans_add(port, vlan, trans, extack);
+		return prestera_port_vlans_add(port, vlan, extack);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index cea42f6ed89b..16129edf1751 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1716,8 +1716,7 @@ static int mlxsw_sp_port_remove_from_mid(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int mlxsw_sp_port_mdb_add(struct mlxsw_sp_port *mlxsw_sp_port,
-				 const struct switchdev_obj_port_mdb *mdb,
-				 struct switchdev_trans *trans)
+				 const struct switchdev_obj_port_mdb *mdb)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct net_device *orig_dev = mdb->obj.orig_dev;
@@ -1729,9 +1728,6 @@ static int mlxsw_sp_port_mdb_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	u16 fid_index;
 	int err = 0;
 
-	if (switchdev_trans_ph_commit(trans))
-		return 0;
-
 	bridge_port = mlxsw_sp_bridge_port_find(mlxsw_sp->bridge, orig_dev);
 	if (!bridge_port)
 		return 0;
@@ -1813,32 +1809,37 @@ mlxsw_sp_port_mrouter_update_mdb(struct mlxsw_sp_port *mlxsw_sp_port,
 
 static int mlxsw_sp_port_obj_add(struct net_device *dev,
 				 const struct switchdev_obj *obj,
-				 struct switchdev_trans *trans,
 				 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	const struct switchdev_obj_port_vlan *vlan;
+	struct switchdev_trans trans;
 	int err = 0;
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
-		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, trans,
+
+		trans.ph_prepare = true;
+		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, &trans,
 					      extack);
+		if (err)
+			break;
 
-		if (switchdev_trans_ph_prepare(trans)) {
-			/* The event is emitted before the changes are actually
-			 * applied to the bridge. Therefore schedule the respin
-			 * call for later, so that the respin logic sees the
-			 * updated bridge state.
-			 */
-			mlxsw_sp_span_respin(mlxsw_sp_port->mlxsw_sp);
-		}
+		/* The event is emitted before the changes are actually
+		 * applied to the bridge. Therefore schedule the respin
+		 * call for later, so that the respin logic sees the
+		 * updated bridge state.
+		 */
+		mlxsw_sp_span_respin(mlxsw_sp_port->mlxsw_sp);
+
+		trans.ph_prepare = false;
+		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, &trans,
+					      extack);
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		err = mlxsw_sp_port_mdb_add(mlxsw_sp_port,
-					    SWITCHDEV_OBJ_PORT_MDB(obj),
-					    trans);
+					    SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	default:
 		err = -EOPNOTSUPP;
@@ -3400,13 +3401,13 @@ mlxsw_sp_switchdev_vxlan_vlan_del(struct mlxsw_sp *mlxsw_sp,
 static int
 mlxsw_sp_switchdev_vxlan_vlans_add(struct net_device *vxlan_dev,
 				   struct switchdev_notifier_port_obj_info *
-				   port_obj_info)
+				   port_obj_info,
+				   struct switchdev_trans *trans)
 {
 	struct switchdev_obj_port_vlan *vlan =
 		SWITCHDEV_OBJ_PORT_VLAN(port_obj_info->obj);
 	bool flag_untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool flag_pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
-	struct switchdev_trans *trans = port_obj_info->trans;
 	struct mlxsw_sp_bridge_device *bridge_device;
 	struct netlink_ext_ack *extack;
 	struct mlxsw_sp *mlxsw_sp;
@@ -3487,12 +3488,22 @@ mlxsw_sp_switchdev_handle_vxlan_obj_add(struct net_device *vxlan_dev,
 					struct switchdev_notifier_port_obj_info *
 					port_obj_info)
 {
+	struct switchdev_trans trans;
 	int err = 0;
 
 	switch (port_obj_info->obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		trans.ph_prepare = true;
+		err = mlxsw_sp_switchdev_vxlan_vlans_add(vxlan_dev,
+							 port_obj_info,
+							 &trans);
+		if (err)
+			break;
+
+		trans.ph_prepare = false;
 		err = mlxsw_sp_switchdev_vxlan_vlans_add(vxlan_dev,
-							 port_obj_info);
+							 port_obj_info,
+							 &trans);
 		break;
 	default:
 		break;
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 2bd2840d88bd..5babe2a38041 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -890,8 +890,7 @@ static int ocelot_port_attr_set(struct net_device *dev,
 }
 
 static int ocelot_port_obj_add_vlan(struct net_device *dev,
-				    const struct switchdev_obj_port_vlan *vlan,
-				    struct switchdev_trans *trans)
+				    const struct switchdev_obj_port_vlan *vlan)
 {
 	int ret;
 	u16 vid;
@@ -900,11 +899,11 @@ static int ocelot_port_obj_add_vlan(struct net_device *dev,
 		bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 		bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 
-		if (switchdev_trans_ph_prepare(trans))
-			ret = ocelot_vlan_vid_prepare(dev, vid, pvid,
-						      untagged);
-		else
-			ret = ocelot_vlan_vid_add(dev, vid, pvid, untagged);
+		ret = ocelot_vlan_vid_prepare(dev, vid, pvid, untagged);
+		if (ret)
+			return ret;
+
+		ret = ocelot_vlan_vid_add(dev, vid, pvid, untagged);
 		if (ret)
 			return ret;
 	}
@@ -929,17 +928,13 @@ static int ocelot_port_vlan_del_vlan(struct net_device *dev,
 }
 
 static int ocelot_port_obj_add_mdb(struct net_device *dev,
-				   const struct switchdev_obj_port_mdb *mdb,
-				   struct switchdev_trans *trans)
+				   const struct switchdev_obj_port_mdb *mdb)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
 	int port = priv->chip_port;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	return ocelot_port_mdb_add(ocelot, port, mdb);
 }
 
@@ -956,7 +951,6 @@ static int ocelot_port_obj_del_mdb(struct net_device *dev,
 
 static int ocelot_port_obj_add(struct net_device *dev,
 			       const struct switchdev_obj *obj,
-			       struct switchdev_trans *trans,
 			       struct netlink_ext_ack *extack)
 {
 	int ret = 0;
@@ -964,12 +958,10 @@ static int ocelot_port_obj_add(struct net_device *dev,
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		ret = ocelot_port_obj_add_vlan(dev,
-					       SWITCHDEV_OBJ_PORT_VLAN(obj),
-					       trans);
+					       SWITCHDEV_OBJ_PORT_VLAN(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
-		ret = ocelot_port_obj_add_mdb(dev, SWITCHDEV_OBJ_PORT_MDB(obj),
-					      trans);
+		ret = ocelot_port_obj_add_mdb(dev, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index dd0bc7f0aaee..1018d3759316 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -1638,17 +1638,13 @@ rocker_world_port_attr_bridge_ageing_time_set(struct rocker_port *rocker_port,
 
 static int
 rocker_world_port_obj_vlan_add(struct rocker_port *rocker_port,
-			       const struct switchdev_obj_port_vlan *vlan,
-			       struct switchdev_trans *trans)
+			       const struct switchdev_obj_port_vlan *vlan)
 {
 	struct rocker_world_ops *wops = rocker_port->rocker->wops;
 
 	if (!wops->port_obj_vlan_add)
 		return -EOPNOTSUPP;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	return wops->port_obj_vlan_add(rocker_port, vlan);
 }
 
@@ -2102,8 +2098,7 @@ static int rocker_port_attr_set(struct net_device *dev,
 }
 
 static int rocker_port_obj_add(struct net_device *dev,
-			       const struct switchdev_obj *obj,
-			       struct switchdev_trans *trans)
+			       const struct switchdev_obj *obj)
 {
 	struct rocker_port *rocker_port = netdev_priv(dev);
 	int err = 0;
@@ -2111,8 +2106,7 @@ static int rocker_port_obj_add(struct net_device *dev,
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		err = rocker_world_port_obj_vlan_add(rocker_port,
-						     SWITCHDEV_OBJ_PORT_VLAN(obj),
-						     trans);
+						     SWITCHDEV_OBJ_PORT_VLAN(obj));
 		break;
 	default:
 		err = -EOPNOTSUPP;
@@ -2847,8 +2841,7 @@ rocker_switchdev_port_obj_event(unsigned long event, struct net_device *netdev,
 
 	switch (event) {
 	case SWITCHDEV_PORT_OBJ_ADD:
-		err = rocker_port_obj_add(netdev, port_obj_info->obj,
-					  port_obj_info->trans);
+		err = rocker_port_obj_add(netdev, port_obj_info->obj);
 		break;
 	case SWITCHDEV_PORT_OBJ_DEL:
 		err = rocker_port_obj_del(netdev, port_obj_info->obj);
diff --git a/drivers/net/ethernet/ti/cpsw_switchdev.c b/drivers/net/ethernet/ti/cpsw_switchdev.c
index 29747da5c514..48a4f277ee31 100644
--- a/drivers/net/ethernet/ti/cpsw_switchdev.c
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
@@ -253,8 +253,7 @@ static int cpsw_port_vlan_del(struct cpsw_priv *priv, u16 vid,
 }
 
 static int cpsw_port_vlans_add(struct cpsw_priv *priv,
-			       const struct switchdev_obj_port_vlan *vlan,
-			       struct switchdev_trans *trans)
+			       const struct switchdev_obj_port_vlan *vlan)
 {
 	bool untag = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct net_device *orig_dev = vlan->obj.orig_dev;
@@ -268,9 +267,6 @@ static int cpsw_port_vlans_add(struct cpsw_priv *priv,
 	if (cpu_port && !(vlan->flags & BRIDGE_VLAN_INFO_BRENTRY))
 		return 0;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
 		int err;
 
@@ -301,8 +297,7 @@ static int cpsw_port_vlans_del(struct cpsw_priv *priv,
 }
 
 static int cpsw_port_mdb_add(struct cpsw_priv *priv,
-			     struct switchdev_obj_port_mdb *mdb,
-			     struct switchdev_trans *trans)
+			     struct switchdev_obj_port_mdb *mdb)
 
 {
 	struct net_device *orig_dev = mdb->obj.orig_dev;
@@ -311,9 +306,6 @@ static int cpsw_port_mdb_add(struct cpsw_priv *priv,
 	int port_mask;
 	int err;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	if (cpu_port)
 		port_mask = BIT(HOST_PORT_NUM);
 	else
@@ -352,7 +344,6 @@ static int cpsw_port_mdb_del(struct cpsw_priv *priv,
 
 static int cpsw_port_obj_add(struct net_device *ndev,
 			     const struct switchdev_obj *obj,
-			     struct switchdev_trans *trans,
 			     struct netlink_ext_ack *extack)
 {
 	struct switchdev_obj_port_vlan *vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
@@ -365,11 +356,11 @@ static int cpsw_port_obj_add(struct net_device *ndev,
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		err = cpsw_port_vlans_add(priv, vlan, trans);
+		err = cpsw_port_vlans_add(priv, vlan);
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
-		err = cpsw_port_mdb_add(priv, mdb, trans);
+		err = cpsw_port_mdb_add(priv, mdb);
 		break;
 	default:
 		err = -EOPNOTSUPP;
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index d524e92051a3..d7e6e06418ed 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -975,38 +975,33 @@ static int dpaa2_switch_port_attr_set(struct net_device *netdev,
 }
 
 static int dpaa2_switch_port_vlans_add(struct net_device *netdev,
-				       const struct switchdev_obj_port_vlan *vlan,
-				       struct switchdev_trans *trans)
+				       const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	struct dpsw_attr *attr = &ethsw->sw_attr;
 	int vid, err = 0, new_vlans = 0;
 
-	if (switchdev_trans_ph_prepare(trans)) {
-		for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-			if (!port_priv->ethsw_data->vlans[vid])
-				new_vlans++;
-
-			/* Make sure that the VLAN is not already configured
-			 * on the switch port
-			 */
-			if (port_priv->vlans[vid] & ETHSW_VLAN_MEMBER)
-				return -EEXIST;
-		}
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		if (!port_priv->ethsw_data->vlans[vid])
+			new_vlans++;
 
-		/* Check if there is space for a new VLAN */
-		err = dpsw_get_attributes(ethsw->mc_io, 0, ethsw->dpsw_handle,
-					  &ethsw->sw_attr);
-		if (err) {
-			netdev_err(netdev, "dpsw_get_attributes err %d\n", err);
-			return err;
-		}
-		if (attr->max_vlans - attr->num_vlans < new_vlans)
-			return -ENOSPC;
+		/* Make sure that the VLAN is not already configured
+		 * on the switch port
+		 */
+		if (port_priv->vlans[vid] & ETHSW_VLAN_MEMBER)
+			return -EEXIST;
+	}
 
-		return 0;
+	/* Check if there is space for a new VLAN */
+	err = dpsw_get_attributes(ethsw->mc_io, 0, ethsw->dpsw_handle,
+				  &ethsw->sw_attr);
+	if (err) {
+		netdev_err(netdev, "dpsw_get_attributes err %d\n", err);
+		return err;
 	}
+	if (attr->max_vlans - attr->num_vlans < new_vlans)
+		return -ENOSPC;
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
 		if (!port_priv->ethsw_data->vlans[vid]) {
@@ -1043,15 +1038,11 @@ static int dpaa2_switch_port_lookup_address(struct net_device *netdev, int is_uc
 }
 
 static int dpaa2_switch_port_mdb_add(struct net_device *netdev,
-				     const struct switchdev_obj_port_mdb *mdb,
-				     struct switchdev_trans *trans)
+				     const struct switchdev_obj_port_mdb *mdb)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	int err;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	/* Check if address is already set on this port */
 	if (dpaa2_switch_port_lookup_address(netdev, 0, mdb->addr))
 		return -EEXIST;
@@ -1070,21 +1061,18 @@ static int dpaa2_switch_port_mdb_add(struct net_device *netdev,
 }
 
 static int dpaa2_switch_port_obj_add(struct net_device *netdev,
-				     const struct switchdev_obj *obj,
-				     struct switchdev_trans *trans)
+				     const struct switchdev_obj *obj)
 {
 	int err;
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		err = dpaa2_switch_port_vlans_add(netdev,
-						  SWITCHDEV_OBJ_PORT_VLAN(obj),
-						  trans);
+						  SWITCHDEV_OBJ_PORT_VLAN(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		err = dpaa2_switch_port_mdb_add(netdev,
-						SWITCHDEV_OBJ_PORT_MDB(obj),
-						trans);
+						SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	default:
 		err = -EOPNOTSUPP;
@@ -1411,8 +1399,7 @@ static int dpaa2_switch_port_obj_event(unsigned long event,
 
 	switch (event) {
 	case SWITCHDEV_PORT_OBJ_ADD:
-		err = dpaa2_switch_port_obj_add(netdev, port_obj_info->obj,
-						port_obj_info->trans);
+		err = dpaa2_switch_port_obj_add(netdev, port_obj_info->obj);
 		break;
 	case SWITCHDEV_PORT_OBJ_DEL:
 		err = dpaa2_switch_port_obj_del(netdev, port_obj_info->obj);
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 99cd538d6519..daca7a14c1db 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -234,7 +234,6 @@ struct switchdev_notifier_fdb_info {
 struct switchdev_notifier_port_obj_info {
 	struct switchdev_notifier_info info; /* must be first */
 	const struct switchdev_obj *obj;
-	struct switchdev_trans *trans;
 	bool handled;
 };
 
@@ -289,7 +288,6 @@ int switchdev_handle_port_obj_add(struct net_device *dev,
 			bool (*check_cb)(const struct net_device *dev),
 			int (*add_cb)(struct net_device *dev,
 				      const struct switchdev_obj *obj,
-				      struct switchdev_trans *trans,
 				      struct netlink_ext_ack *extack));
 int switchdev_handle_port_obj_del(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
@@ -373,7 +371,6 @@ switchdev_handle_port_obj_add(struct net_device *dev,
 			bool (*check_cb)(const struct net_device *dev),
 			int (*add_cb)(struct net_device *dev,
 				      const struct switchdev_obj *obj,
-				      struct switchdev_trans *trans,
 				      struct netlink_ext_ack *extack))
 {
 	return 0;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 7c96aae9062c..ec70066413c7 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -148,8 +148,7 @@ int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid);
 int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data);
 int dsa_port_mdb_add(const struct dsa_port *dp,
-		     const struct switchdev_obj_port_mdb *mdb,
-		     struct switchdev_trans *trans);
+		     const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_mdb_del(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags,
@@ -159,8 +158,7 @@ int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags,
 int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
 		     struct switchdev_trans *trans);
 int dsa_port_vlan_add(struct dsa_port *dp,
-		      const struct switchdev_obj_port_vlan *vlan,
-		      struct switchdev_trans *trans);
+		      const struct switchdev_obj_port_vlan *vlan);
 int dsa_port_vlan_del(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan);
 int dsa_port_link_register_of(struct dsa_port *dp);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 73569c9af3cc..8d173064539c 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -425,16 +425,24 @@ int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data)
 }
 
 int dsa_port_mdb_add(const struct dsa_port *dp,
-		     const struct switchdev_obj_port_mdb *mdb,
-		     struct switchdev_trans *trans)
+		     const struct switchdev_obj_port_mdb *mdb)
 {
 	struct dsa_notifier_mdb_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.trans = trans,
 		.mdb = mdb,
 	};
+	struct switchdev_trans trans;
+	int err;
+
+	info.trans = &trans;
+
+	trans.ph_prepare = true;
+	err = dsa_port_notify(dp, DSA_NOTIFIER_MDB_ADD, &info);
+	if (err)
+		return err;
 
+	trans.ph_prepare = false;
 	return dsa_port_notify(dp, DSA_NOTIFIER_MDB_ADD, &info);
 }
 
@@ -451,16 +459,24 @@ int dsa_port_mdb_del(const struct dsa_port *dp,
 }
 
 int dsa_port_vlan_add(struct dsa_port *dp,
-		      const struct switchdev_obj_port_vlan *vlan,
-		      struct switchdev_trans *trans)
+		      const struct switchdev_obj_port_vlan *vlan)
 {
 	struct dsa_notifier_vlan_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.trans = trans,
 		.vlan = vlan,
 	};
+	struct switchdev_trans trans;
+	int err;
+
+	info.trans = &trans;
+
+	trans.ph_prepare = true;
+	err = dsa_port_notify(dp, DSA_NOTIFIER_VLAN_ADD, &info);
+	if (err)
+		return err;
 
+	trans.ph_prepare = false;
 	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_ADD, &info);
 }
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4a0498bf6c65..d32fda1fed6f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -326,8 +326,7 @@ dsa_slave_vlan_check_for_8021q_uppers(struct net_device *slave,
 }
 
 static int dsa_slave_vlan_add(struct net_device *dev,
-			      const struct switchdev_obj *obj,
-			      struct switchdev_trans *trans)
+			      const struct switchdev_obj *obj)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -345,7 +344,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	/* Deny adding a bridge VLAN when there is already an 802.1Q upper with
 	 * the same VID.
 	 */
-	if (trans->ph_prepare && br_vlan_enabled(dp->bridge_dev)) {
+	if (br_vlan_enabled(dp->bridge_dev)) {
 		rcu_read_lock();
 		err = dsa_slave_vlan_check_for_8021q_uppers(dev, &vlan);
 		rcu_read_unlock();
@@ -353,7 +352,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 			return err;
 	}
 
-	err = dsa_port_vlan_add(dp, &vlan, trans);
+	err = dsa_port_vlan_add(dp, &vlan);
 	if (err)
 		return err;
 
@@ -363,7 +362,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	 */
 	vlan.flags &= ~BRIDGE_VLAN_INFO_PVID;
 
-	err = dsa_port_vlan_add(dp->cpu_dp, &vlan, trans);
+	err = dsa_port_vlan_add(dp->cpu_dp, &vlan);
 	if (err)
 		return err;
 
@@ -378,7 +377,6 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 
 static int dsa_slave_port_obj_add(struct net_device *dev,
 				  const struct switchdev_obj *obj,
-				  struct switchdev_trans *trans,
 				  struct netlink_ext_ack *extack)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -393,17 +391,16 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		if (obj->orig_dev != dev)
 			return -EOPNOTSUPP;
-		err = dsa_port_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj), trans);
+		err = dsa_port_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
 		/* DSA can directly translate this to a normal MDB add,
 		 * but on the CPU port.
 		 */
-		err = dsa_port_mdb_add(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj),
-				       trans);
+		err = dsa_port_mdb_add(dp->cpu_dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		err = dsa_slave_vlan_add(dev, obj, trans);
+		err = dsa_slave_vlan_add(dev, obj);
 		break;
 	default:
 		err = -EOPNOTSUPP;
@@ -1294,28 +1291,15 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 		/* This API only allows programming tagged, non-PVID VIDs */
 		.flags = 0,
 	};
-	struct switchdev_trans trans;
 	int ret;
 
 	/* User port... */
-	trans.ph_prepare = true;
-	ret = dsa_port_vlan_add(dp, &vlan, &trans);
-	if (ret)
-		return ret;
-
-	trans.ph_prepare = false;
-	ret = dsa_port_vlan_add(dp, &vlan, &trans);
+	ret = dsa_port_vlan_add(dp, &vlan);
 	if (ret)
 		return ret;
 
 	/* And CPU port... */
-	trans.ph_prepare = true;
-	ret = dsa_port_vlan_add(dp->cpu_dp, &vlan, &trans);
-	if (ret)
-		return ret;
-
-	trans.ph_prepare = false;
-	ret = dsa_port_vlan_add(dp->cpu_dp, &vlan, &trans);
+	ret = dsa_port_vlan_add(dp->cpu_dp, &vlan);
 	if (ret)
 		return ret;
 
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 23d868545362..a575bb33ee6c 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -221,7 +221,6 @@ static size_t switchdev_obj_size(const struct switchdev_obj *obj)
 static int switchdev_port_obj_notify(enum switchdev_notifier_type nt,
 				     struct net_device *dev,
 				     const struct switchdev_obj *obj,
-				     struct switchdev_trans *trans,
 				     struct netlink_ext_ack *extack)
 {
 	int rc;
@@ -229,7 +228,6 @@ static int switchdev_port_obj_notify(enum switchdev_notifier_type nt,
 
 	struct switchdev_notifier_port_obj_info obj_info = {
 		.obj = obj,
-		.trans = trans,
 		.handled = false,
 	};
 
@@ -248,35 +246,10 @@ static int switchdev_port_obj_add_now(struct net_device *dev,
 				      const struct switchdev_obj *obj,
 				      struct netlink_ext_ack *extack)
 {
-	struct switchdev_trans trans;
-	int err;
-
 	ASSERT_RTNL();
 
-	/* Phase I: prepare for obj add. Driver/device should fail
-	 * here if there are going to be issues in the commit phase,
-	 * such as lack of resources or support.  The driver/device
-	 * should reserve resources needed for the commit phase here,
-	 * but should not commit the obj.
-	 */
-
-	trans.ph_prepare = true;
-	err = switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
-					dev, obj, &trans, extack);
-	if (err)
-		return err;
-
-	/* Phase II: commit obj add.  This cannot fail as a fault
-	 * of driver/device.  If it does, it's a bug in the driver/device
-	 * because the driver said everythings was OK in phase I.
-	 */
-
-	trans.ph_prepare = false;
-	err = switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
-					dev, obj, &trans, extack);
-	WARN(err, "%s: Commit of object (id=%d) failed.\n", dev->name, obj->id);
-
-	return err;
+	return switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
+					 dev, obj, extack);
 }
 
 static void switchdev_port_obj_add_deferred(struct net_device *dev,
@@ -307,10 +280,6 @@ static int switchdev_port_obj_add_defer(struct net_device *dev,
  *	@obj: object to add
  *	@extack: netlink extended ack
  *
- *	Use a 2-phase prepare-commit transaction model to ensure
- *	system is not left in a partially updated state due to
- *	failure from driver/device.
- *
  *	rtnl_lock must be held and must not be in atomic section,
  *	in case SWITCHDEV_F_DEFER flag is not set.
  */
@@ -329,7 +298,7 @@ static int switchdev_port_obj_del_now(struct net_device *dev,
 				      const struct switchdev_obj *obj)
 {
 	return switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_DEL,
-					 dev, obj, NULL, NULL);
+					 dev, obj, NULL);
 }
 
 static void switchdev_port_obj_del_deferred(struct net_device *dev,
@@ -449,7 +418,6 @@ static int __switchdev_handle_port_obj_add(struct net_device *dev,
 			bool (*check_cb)(const struct net_device *dev),
 			int (*add_cb)(struct net_device *dev,
 				      const struct switchdev_obj *obj,
-				      struct switchdev_trans *trans,
 				      struct netlink_ext_ack *extack))
 {
 	struct netlink_ext_ack *extack;
@@ -462,8 +430,7 @@ static int __switchdev_handle_port_obj_add(struct net_device *dev,
 	if (check_cb(dev)) {
 		/* This flag is only checked if the return value is success. */
 		port_obj_info->handled = true;
-		return add_cb(dev, port_obj_info->obj, port_obj_info->trans,
-			      extack);
+		return add_cb(dev, port_obj_info->obj, extack);
 	}
 
 	/* Switch ports might be stacked under e.g. a LAG. Ignore the
@@ -491,7 +458,6 @@ int switchdev_handle_port_obj_add(struct net_device *dev,
 			bool (*check_cb)(const struct net_device *dev),
 			int (*add_cb)(struct net_device *dev,
 				      const struct switchdev_obj *obj,
-				      struct switchdev_trans *trans,
 				      struct netlink_ext_ack *extack))
 {
 	int err;
-- 
2.25.1

