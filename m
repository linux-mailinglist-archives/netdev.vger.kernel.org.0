Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06AE4B8E73
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 17:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236630AbiBPQs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 11:48:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236606AbiBPQsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 11:48:25 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80072.outbound.protection.outlook.com [40.107.8.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9904B2804EA;
        Wed, 16 Feb 2022 08:48:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ru8EbBzu4KI7/SP4YT8ISuDSry00VWxfci+4jcBIasIB+QdyhjUw2fYJ20UAzKGw0Abw0FYs+kcoRigABwPgMRFNByLubtKtSgYsiazFqxOqk332OMZrIEOPMyC3cY8YB9MFe6YXWNqZQdj6XQql5QEsLbjiXuew8XB6PcOD1OCbhzHxETB/erEhKUsM9YRQPmnxHYP5nZfAfTiFR5nzL8leu+Sud98m96B+IlO3V9OJg2rSA0dV+5s98BO4fKNdIb1fM9l7oJr5pPbD/2iYfTQDtDbhHHBzk7gnO95qeFIP5dr5rsIau6Kh4G2CK4f+eT+SFxPNHgM1upGoXLHhYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mw/xwcK+PIeX/L6GS2jX6vmTbQ6FFPUpNSGkC3cidhM=;
 b=hjwUiKsepAKNx2g/GhRARD3kJGyni0w/rC4SVXC0cf+O0vxuaHmUACslUdZwz/pnxk1N9TnbD/sfwLNCPBZ0fF0EqnmPfMavchLgFXVb8sFi0h2Z+tx3UkKpzdxM8xXFKC9C8RJaZor9jx4q60WqeaASiK9Fx6eGBJbqHBoWm/ItXk6nXqAszklZTNWLlPKzJIg9cT7UbkOXsUtV0ldEhGgGSUw9ENd0/gMvPDgs0zS0wpQeca8C5qX15SST7xSXPDpMF2S7uG2OCQ7ZuJgj7+cJDRjI32WAunWrxa3APl3XJ+p8o0karM/CVzcqMqTV5F4VFL4vuXzpQ8uBZi9unA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mw/xwcK+PIeX/L6GS2jX6vmTbQ6FFPUpNSGkC3cidhM=;
 b=IikLXSgj47Q4hRlCEkRdXiOojC+0UV7ODRwi9N9UYk0VS9DXh+FVjEGEJgyptN5IPzdP/Qx/llcxP5kXGmRHY474e3u+sqdtv2nsZt+H8KjS+s5kNhaoF9izqef5CLOjug8jJVbEwmoCqHHlQIZBrHg64qaRCaN6XP4gyUvlfsY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4091.eurprd04.prod.outlook.com (2603:10a6:5:1e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 16:48:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 16:48:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH net-next 2/5] net: lan966x: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
Date:   Wed, 16 Feb 2022 18:47:49 +0200
Message-Id: <20220216164752.2794456-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216164752.2794456-1-vladimir.oltean@nxp.com>
References: <20220216164752.2794456-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0009.eurprd03.prod.outlook.com
 (2603:10a6:205:2::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ad16fe0-0b54-49fe-de76-08d9f16c1d53
X-MS-TrafficTypeDiagnostic: DB7PR04MB4091:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4091FADF4E5265D7A91038D6E0359@DB7PR04MB4091.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 57uyoMvYvjdHy6BO6vlaODJI5I5WXQK3UwuHDRRQTpPzvvrcs1QjJu68LFnd4+U3BDWxWoltfZJrSjPJmuOdkCVcveiSO1db5GMFf1Enx4fljbniL01WZ+UXnCh+Dl5Y+XjDswjPGfMzlZd0uPPNeQ3e+iKNPGcHsmOQT+Vzvjal2xeKbmBwsyuqP3Qww53kqqQkLMySw4ManEC4faXZIdqVzdR1jdJ5YMdrDtyekcKJG5B0DWir79g3r4MKvkcyoKP0KkJ8HV1w1J8BkxH/Wd9BaAtl+N0h5Nlhquq3BCkgxq+x1YbF/Sy+Z7el3paPCdbDXl7WIxY1cb5gdswZUZhP5I/5zxa+9Kaexiu/XktwygXTt6DkA/d/ihvAVAms3n6ROLAn9doQfEXr/5vAqYo6R9L4KgHsD7iJoeWj08OtPz4zyXMo4/6N+tUDEa/jxjTo8tj7Qa73PIoQjKSIvKwWAdHJppfjv2IHQFJ/9luqbl6LWVK9bjpb9rTgic8pad+SvItsX1s4FoQHgjg13bNyLOzWUlYCPKdBVFunZkGtI9bXvMQX0/Pds1NYdcms/05Ren8zAZT+lOKk/19SgNa7xok4sMSSBNtk2CV65CoVVomcHvvFdsrKwdd+v0xjoLaQHa5hiLLJLrRm3mrrD1cmjiUWYIshyIYEfyq5ZbEcNP0idkdsvpjxIHyj2ZC3OvxhgriJOIO1xyKrNO4WAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(44832011)(6916009)(5660300002)(8676002)(52116002)(186003)(7416002)(36756003)(26005)(66476007)(6512007)(1076003)(86362001)(2616005)(8936002)(38350700002)(6666004)(83380400001)(316002)(38100700002)(2906002)(6486002)(66946007)(66556008)(508600001)(6506007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6us5G9Qt7cgqc8jjE2O1QbxZdavZ6C82sClSJLoYujd6ISv465jzSMX4SMOJ?=
 =?us-ascii?Q?YdnDXfFHjMsHiZ2ioGVODOAHz6mU2gOO4Z2fsKCohU45+drhfdCI5Jtqpkey?=
 =?us-ascii?Q?S/B1dWPooOXtQ26p4I/JRv23fkftg9axHKtGASi3lnTD2BeSPWjE0bC7xH5y?=
 =?us-ascii?Q?sUZDc2d+hHDROS68He6F9Zk/WPCQ5hTJJRofjI2bjElq7Wdutd3+7VG9FNhN?=
 =?us-ascii?Q?e1BQwXEB2pJ/m5JiykEvHtmeEipTyXED784LOHevlvKbRPphWR8+5rY/hv0z?=
 =?us-ascii?Q?0WGto7wdowEtid0Ewbg2wTtvEm9iK8r7K+eQdVeO04UQt3oZtJGJRdZdPDPl?=
 =?us-ascii?Q?ekVEnnbVtCaneGLgN6r0pL3cO2oguJFgLRVLQwlcr/iyAsnCCJBrxpxBt+9i?=
 =?us-ascii?Q?jb50wLAu+miBnFiXvNzwOeJuA4SsFLV41BzKXcdUhIFNMsg5u3BQlSqTvf5D?=
 =?us-ascii?Q?zJ5deNyrFfaz+RYwaBPLj61S13YukubhVoNvHRNrqULBf7P/+1Gws3bp4Qu9?=
 =?us-ascii?Q?pGnq4SEclGuTVyumye/GoDukJIX9SLRXlCfnXzFB8OKcZmF3GYQkTJIihGH1?=
 =?us-ascii?Q?Kih1nDXMX2ohUQTFMp9ExxfDJauDH42iY7l5jZZoDROlao7c2igLauqoevyt?=
 =?us-ascii?Q?iy4qDqRGNjpZM3vNoFjJCacQY7Kp2qswVxNPNF869JVYVQEO27QhJEUHiLUo?=
 =?us-ascii?Q?/tG9Cg4Beo4hESEdnFwrDiX62+LoQNmDahwCQrfsnq2cz5Aql6XX8MuVYlLZ?=
 =?us-ascii?Q?TumVupbqYzF1Yn8cqcfOlAnCSmJ3dwaaWp5q9jOe/4KTd0jv2AZlKgUAH6zx?=
 =?us-ascii?Q?49G6qMXnFInYXyKbkDtGvVL76h4ynR3tul8E9m8Di6q0DDMjOvS6JSOb3PRp?=
 =?us-ascii?Q?dmhhSvyV2+oQWHI2os+V8KTubLlGMsERhgnDQrnYmQuw/9Zzpn593S/L42Wz?=
 =?us-ascii?Q?XmPSAutsvvIzvZO+bCQhrgmlhyWV3NyTVxYCMdEfvo6uTSsOLUAPos1XK+tU?=
 =?us-ascii?Q?KIkqEwzMjKeqehs3MadPze6a9Xp9gBaDHvoxai6BJkpmVE3LMjo3kJIsVtHw?=
 =?us-ascii?Q?GXxZhnkMdJZ7ajoNqChJqa65F+92mGAEZqJedynOlQxbz/15T70a/ggMUw4A?=
 =?us-ascii?Q?p4lg93g64wUc8PcZPaO9Cgiylb+4MID2wnDBAjTt1jtitpuv0MTy6A90Uzr3?=
 =?us-ascii?Q?f+GOmhiVbJDjj+Bec3lQvRqYd4NhxtRDoCGR9L3hozW1/sfUzWtO6C8SrTmu?=
 =?us-ascii?Q?1Tgf+TKjhpv+GcrFZmPKaryD/AiOz+xkobP7zHdZNoQZubCbEYcPZ69EUOJ1?=
 =?us-ascii?Q?PREWgNrnOZjo51BVF4Z2VDnkOQ+DFUgZVN5VZATbdUlgYZYI1z+awyeLTuFT?=
 =?us-ascii?Q?gb+Ny1Qk52tSkfKcRusZy8+dC/ZpPwxvKpR4uRLBZXueIz8RdPPb2eSOte7t?=
 =?us-ascii?Q?vMnU7EQ8pPUkT3tIM3QHvKP3G/zUTqYx/w95yOBUJTeQo104YQMuOUQm8NWf?=
 =?us-ascii?Q?VbIrAzgfe5hWs2NFVazEQyj1bzcBlZwreknmqnNjfzM/Bx41DGpwoCs221w1?=
 =?us-ascii?Q?YNA8wfr+13QkipGd+PGo1PXWTI3Lv8IQ+yMK51IHGNc3ji7BMAkz3z0fitKh?=
 =?us-ascii?Q?WsBI3QT9HAXoPulqp02CM38=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad16fe0-0b54-49fe-de76-08d9f16c1d53
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 16:48:10.2152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o1IiKyDDQcxbW1NBpfSTf1jEk8BmBwxFOAMuBmGKw/qK7YlksbTIqLiippcXwFOSbBr/VZ0xQzQ4FHWcC/MqsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4091
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 3116ad0696dd ("net: bridge: vlan: don't notify to switchdev
master VLANs without BRENTRY flag"), the bridge no longer emits
switchdev notifiers for VLANs that don't have the
BRIDGE_VLAN_INFO_BRENTRY flag, so these checks are dead code.
Remove them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../ethernet/microchip/lan966x/lan966x_switchdev.c   | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index 9fce865287e7..85099a51d4c7 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -463,18 +463,6 @@ static int lan966x_handle_port_vlan_add(struct lan966x_port *port,
 	const struct switchdev_obj_port_vlan *v = SWITCHDEV_OBJ_PORT_VLAN(obj);
 	struct lan966x *lan966x = port->lan966x;
 
-	/* When adding a port to a vlan, we get a callback for the port but
-	 * also for the bridge. When get the callback for the bridge just bail
-	 * out. Then when the bridge is added to the vlan, then we get a
-	 * callback here but in this case the flags has set:
-	 * BRIDGE_VLAN_INFO_BRENTRY. In this case it means that the CPU
-	 * port is added to the vlan, so the broadcast frames and unicast frames
-	 * with dmac of the bridge should be foward to CPU.
-	 */
-	if (netif_is_bridge_master(obj->orig_dev) &&
-	    !(v->flags & BRIDGE_VLAN_INFO_BRENTRY))
-		return 0;
-
 	if (!netif_is_bridge_master(obj->orig_dev))
 		lan966x_vlan_port_add_vlan(port, v->vid,
 					   v->flags & BRIDGE_VLAN_INFO_PVID,
-- 
2.25.1

