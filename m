Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75EC2DCAC6
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 03:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgLQCBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 21:01:14 -0500
Received: from mail-am6eur05on2048.outbound.protection.outlook.com ([40.107.22.48]:59936
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727942AbgLQCBO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 21:01:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SyixAqE4vgRI/7VmXm2omNEVMYIjxjh5T7YuTIYKaQlu6QENlxafxEMLO51vO3Y5DCbjiGPz5zeAxW/30BTuTHg92nX8n+P7i1DxbtHuHkOrFSAowBq3YR+GaFWXa4+1JdMUdFIGgPD0eMUplGTWSUllH++g6hMz3SrtvJ8e08UShR4ZtMN3N96dsHcTmowVpmTEh890H4KYY28WFDmBcXS1XXyM6LMUYzHOnmIJG1mGGY2zsoHl0AzkE6MmGBAGN7MyvJlkfkN9h4UiRgKP3tpIrkU/S4cYurItg5YYSIeVVKAJbkynBgDBgLydEZWM4ub3ZyQpiESy7tbz98Zq5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JR1kZcu+kkmKQxoTTAKQfoOuCUrLgOQTyxfmCTO4ZJw=;
 b=YPveoAxDmOa8NK9Mvzyg9WixuBPPt51wsUggpjazmxvgayS4l48ACSAH0qIB4yuW4HMJoTyE19Dx1CcsU/DPODMHwZGLW98Kri74tLFpTGKRbT8wax+5TepBy+TM6n5CfvkrRYjTSdUf7RplTDGlWCM/3aA8cv+nMzl2gpPuoPumGvX+bdRdhXG2UrAsv5NgYQUl4oy6ADCaG5nj5wa8b4yJWLyLrtN9fhhqeurqi05xkzAQzUOSdmQoUPYj9J9V8Ce69P22S3fbnZJ6bAGSfRF4OCYdalOzqgXBcvCqJPAEyiElM1Psy/6sIosrgzSodLNt1HQcVZl0sYmxShYm7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JR1kZcu+kkmKQxoTTAKQfoOuCUrLgOQTyxfmCTO4ZJw=;
 b=NurMptsAI+CKnQvwGl0YCD5mu6qAhhy5bYKqgeigABvjKMKWP20HepSqhqK/A3E4aKzFBknuOOig7gFVSOCrSf76Lm/I+0vRlt1/7/zZNm6QCaz+hd7oABcjkb1DdlkHIMnIdfOLpz5VkkMNEYs0LNJ/YWsCiuXq38pVcrCLQtc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6943.eurprd04.prod.outlook.com (2603:10a6:803:13a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Thu, 17 Dec
 2020 01:59:12 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 01:59:12 +0000
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
Subject: [RFC PATCH net-next 8/9] mlxsw: spectrum_switchdev: remove transactional logic for VLAN objects
Date:   Thu, 17 Dec 2020 03:58:21 +0200
Message-Id: <20201217015822.826304-9-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by VE1PR08CA0028.eurprd08.prod.outlook.com (2603:10a6:803:104::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 01:59:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3e4b5eb2-d900-4029-c6a8-08d8a22f598c
X-MS-TrafficTypeDiagnostic: VI1PR04MB6943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB69431220B6F30A9C04817EE5E0C40@VI1PR04MB6943.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2QzK+t8rJF2n1R8T56JixAZDy5K8G/cLEMf5BNrSL9PR8yYDUZtxLRuNQoq5LMwCPeoHV+UznP0T2FijtkGWzFGXfjtvTuLHR6BBU+N5cP1UmvS8y96RdS0EcPHbPa8wXri6uiwbZpCkRQ147cJQGynsieJz6bJyfMlDLzQA7gdZ2TbVj0RLVk/PwK0FP3+UW+2/qgsqbRqMQGWfniWpwwb/Q/lKbn32FbAEPpqzrllr1KoWQw467NukWkRZPv23s+WrBrF2kfFEkY5vIonr29UEUiuwagV+e/2lKy25aDxFw8KLLpGq3M8baa+4fAPOT2ns0YzLXi/mXxNji5ZQ/A5gD2cDTxdneM89efVjfpmAecojFvVbNTn9CiTO6Z4L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(39850400004)(396003)(6666004)(6506007)(16526019)(478600001)(956004)(2616005)(26005)(7416002)(83380400001)(36756003)(66476007)(66556008)(110136005)(86362001)(1076003)(5660300002)(66946007)(316002)(186003)(52116002)(6486002)(54906003)(69590400008)(6512007)(44832011)(2906002)(8676002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ftCx6JEXuJEW6JyZcr7Sy7F96/ZjEPG+3urSBMafqqrKz6etq9zfA15FheGX?=
 =?us-ascii?Q?e/9n6nDVxFX5DOyRmq1SHIVsgKEf1+OIdeElCudcZGf9jVOr6vX5T66pyh8i?=
 =?us-ascii?Q?yX4LxJFqoKug2XvRQD2+re8IjERA/OnNXj8HXozx96ei08wzNf5+WqjrHCCk?=
 =?us-ascii?Q?7Jw59CoYOo+4N8/FyWQADhfYo3FKYm/TwucqQs7WKc+bEh/re1aNMSVJkAP8?=
 =?us-ascii?Q?/MQiyZ07HDw/Tcw07mZ9aETHAoNFgly5P/HM7PqVs39tLAhJr7HTCfpW+OqJ?=
 =?us-ascii?Q?vWR+TtN2mKd+RhlA2txB5u0wtS7mNCC4HWO1gLXqhPrswCKXSxC7mcPSw2Ys?=
 =?us-ascii?Q?iiK7livchOtsx7KDDEj46qYW7NHeaoYqROu0JtApmjmHeq8/EmKpvqk4o4tT?=
 =?us-ascii?Q?JKQDEEmbPlJZ0qiJj8RzIuUvKjfQQMLSsrelNQSqE8F9NKerbrX1Yi97X+NR?=
 =?us-ascii?Q?uJQJX0SO02DVJ+dBD+8ASr4PMviFluQFCb76K+UVepJ40USx/+U8be2zb5cu?=
 =?us-ascii?Q?MD9Fir9U2wIq92BLkDqHUSmVZtwrMuwRSIeMAqJpHDEOvTIwoHwIyqC3D6i3?=
 =?us-ascii?Q?I/viac3wj5kemAGbBv17YkcihwTcfkjuQTKLHliIHQj6f5lqfN4gqbt0SCr/?=
 =?us-ascii?Q?2LeEISGHJdgy+ZGdXVu2llo0XWyhLCO+2CsZJNi4FbVK5TXWLqSLkbWedok/?=
 =?us-ascii?Q?0QE+uQ6SK19I5tZgdGKKW5xZXDowEU9mvk2rkAT7FGjZQYm0t9FuRm9cB7nH?=
 =?us-ascii?Q?yj/TlOmll5uDg0UYbA3WWMQIllC1aobDzhia/C7qleuoPdr6e4RO8VtFEbFd?=
 =?us-ascii?Q?Gl0LSVe+YzN6yL9rc3D/fupvYHB3PurOJ9DcdAW//tq0t1DtcfcuGGfzjBV1?=
 =?us-ascii?Q?Dd70Za76X1xKfgBySceznnP7hszJhJ2oin4g+Yl35qxOvePMQulf1soBnVfW?=
 =?us-ascii?Q?cBn9lEcRnFgulu1WL38YTd6+0UKSwzElnpiFFDQukZBb2ca2G8jqluZcmvT5?=
 =?us-ascii?Q?W30R?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 01:59:12.0776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e4b5eb2-d900-4029-c6a8-08d8a22f598c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5AMoNN9VQmFFX7J90WY0kcb+Q1bJo1uZkn+BZmI7fF5td6uwbVTc40+YV7idYROjaMtS6yWw+7oEptKy/SgzKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6943
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As of commit 457e20d65924 ("mlxsw: spectrum_switchdev: Avoid returning
errors in commit phase"), the mlxsw driver performs the VLAN object
offloading during the prepare phase. So conversion just seems to be a
matter of removing the code that was running in the commit phase.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../mellanox/mlxsw/spectrum_switchdev.c       | 38 +++----------------
 1 file changed, 5 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index e248f9deb2ec..c775c9edea78 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1199,7 +1199,6 @@ mlxsw_sp_br_ban_rif_pvid_change(struct mlxsw_sp *mlxsw_sp,
 
 static int mlxsw_sp_port_vlans_add(struct mlxsw_sp_port *mlxsw_sp_port,
 				   const struct switchdev_obj_port_vlan *vlan,
-				   struct switchdev_trans *trans,
 				   struct netlink_ext_ack *extack)
 {
 	bool flag_untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
@@ -1213,8 +1212,7 @@ static int mlxsw_sp_port_vlans_add(struct mlxsw_sp_port *mlxsw_sp_port,
 		int err = 0;
 
 		if ((vlan->flags & BRIDGE_VLAN_INFO_BRENTRY) &&
-		    br_vlan_enabled(orig_dev) &&
-		    switchdev_trans_ph_prepare(trans))
+		    br_vlan_enabled(orig_dev))
 			err = mlxsw_sp_br_ban_rif_pvid_change(mlxsw_sp,
 							      orig_dev, vlan);
 		if (!err)
@@ -1222,9 +1220,6 @@ static int mlxsw_sp_port_vlans_add(struct mlxsw_sp_port *mlxsw_sp_port,
 		return err;
 	}
 
-	if (switchdev_trans_ph_commit(trans))
-		return 0;
-
 	bridge_port = mlxsw_sp_bridge_port_find(mlxsw_sp->bridge, orig_dev);
 	if (WARN_ON(!bridge_port))
 		return -EINVAL;
@@ -1776,29 +1771,20 @@ static int mlxsw_sp_port_obj_add(struct net_device *dev,
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	const struct switchdev_obj_port_vlan *vlan;
-	struct switchdev_trans trans;
 	int err = 0;
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
 
-		trans.ph_prepare = true;
-		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, &trans,
-					      extack);
+		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, extack);
 		if (err)
 			break;
 
-		/* The event is emitted before the changes are actually
-		 * applied to the bridge. Therefore schedule the respin
-		 * call for later, so that the respin logic sees the
+		/* Schedule the respin call, so that the respin logic sees the
 		 * updated bridge state.
 		 */
 		mlxsw_sp_span_respin(mlxsw_sp_port->mlxsw_sp);
-
-		trans.ph_prepare = false;
-		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, &trans,
-					      extack);
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		err = mlxsw_sp_port_mdb_add(mlxsw_sp_port,
@@ -3364,8 +3350,7 @@ mlxsw_sp_switchdev_vxlan_vlan_del(struct mlxsw_sp *mlxsw_sp,
 static int
 mlxsw_sp_switchdev_vxlan_vlans_add(struct net_device *vxlan_dev,
 				   struct switchdev_notifier_port_obj_info *
-				   port_obj_info,
-				   struct switchdev_trans *trans)
+				   port_obj_info)
 {
 	struct switchdev_obj_port_vlan *vlan =
 		SWITCHDEV_OBJ_PORT_VLAN(port_obj_info->obj);
@@ -3388,9 +3373,6 @@ mlxsw_sp_switchdev_vxlan_vlans_add(struct net_device *vxlan_dev,
 
 	port_obj_info->handled = true;
 
-	if (switchdev_trans_ph_commit(trans))
-		return 0;
-
 	bridge_device = mlxsw_sp_bridge_device_find(mlxsw_sp->bridge, br_dev);
 	if (!bridge_device)
 		return -EINVAL;
@@ -3451,22 +3433,12 @@ mlxsw_sp_switchdev_handle_vxlan_obj_add(struct net_device *vxlan_dev,
 					struct switchdev_notifier_port_obj_info *
 					port_obj_info)
 {
-	struct switchdev_trans trans;
 	int err = 0;
 
 	switch (port_obj_info->obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		trans.ph_prepare = true;
-		err = mlxsw_sp_switchdev_vxlan_vlans_add(vxlan_dev,
-							 port_obj_info,
-							 &trans);
-		if (err)
-			break;
-
-		trans.ph_prepare = false;
 		err = mlxsw_sp_switchdev_vxlan_vlans_add(vxlan_dev,
-							 port_obj_info,
-							 &trans);
+							 port_obj_info);
 		break;
 	default:
 		break;
-- 
2.25.1

